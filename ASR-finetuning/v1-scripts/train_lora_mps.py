"""
Standalone LoRA fine-tuning script for WhIPA on Apple Silicon (M-series MPS),
built on the prepped dataset from run_prep_dataset.py.

##############################################################################
# WHY THIS SCRIPT EXISTS, INSTEAD OF JUST RUNNING fine_tune.py DIRECTLY
##############################################################################
fine_tune.py's __main__ block does two things we can't use as-is:

  1. It loads training data via a config-driven corpora system (PARAMS[split]
     ["corpora"], read from ft_config.json + their own scripts/loader.py
     load_ft_data() function) -- built for THEIR benchmark corpora (CommonVoice,
     ASC, THCHS-30, Sanna), not an arbitrary custom dataset sitting on disk.
     We already built + prepped our own dataset directly, so we skip this
     entire layer and load our data with datasets.load_from_disk() instead.

  2. Its LoRA-loading path (scripts/loader.py's load_whisper_res(), peft=True
     branch) loads the base model via:
         WhisperForConditionalGeneration.from_pretrained(modelname,
             quantization_config=BitsAndBytesConfig(load_in_8bit=True),
             device_map="auto")
     8-bit quantization via bitsandbytes is a CUDA-only code path -- it will
     not run on an Apple Silicon Mac (no NVIDIA GPU, no CUDA). This script
     replaces ONLY that one step: load the model in full precision and move
     it explicitly to the "mps" device (Apple's GPU backend) instead.

EVERYTHING ELSE is reused directly from your actual fine_tune.py / loader.py
code -- the LoraConfig target-module selection logic, the add_ipa() special-
token setup, the DataCollatorSpeechSeq2SeqWithPadding class, the
SavePeftModelCallback, and the final model-saving logic -- copied/imported
as closely as possible to what their own script does, so this isn't a
reimplementation of their approach, just a hardware-compatible substitution
for the one CUDA-specific step.
##############################################################################

STEP-BY-STEP WHAT THIS SCRIPT DOES:

  1. Load the prepped dataset (output of run_prep_dataset.py) -- already has
     "input_features" and "labels" columns, ready for training.
  2. Split it into train/dev (your single dataset doesn't have this split
     built in yet; fine_tune.py's Trainer requires both).
  3. Load the base Whisper model (e.g. openai/whisper-large-v2) in full
     precision, moved to the MPS device.
  4. Add the special "<|ip|>" IPA language token to the tokenizer and resize
     the model's embeddings to match -- this is add_ipa() from loader.py,
     called exactly as their own non-PEFT-non-whipa loading path does, since
     we're starting a NEW LoRA fine-tune from a fresh base model (not
     continuing from an existing WhIPA/LoWhIPA checkpoint).
  5. Build the LoRA config -- SAME parameters as loader.py's PEFT branch:
     r=32, lora_alpha=64, targeting only the decoder's q_proj/v_proj
     submodules (their exact target-module selection logic, copied verbatim).
  6. Wrap the model with PEFT's get_peft_model().
  7. Set up the data collator (their exact DataCollatorSpeechSeq2SeqWithPadding
     class, imported directly from fine_tune.py).
  8. Configure Seq2SeqTrainingArguments -- CPU/MPS-appropriate defaults
     (matching fine_tune.py's own "cpu_default" fallback values, since we
     have no CUDA GPU to trigger their gpu_default branch).
  9. Train.
  10. Save: merge the LoRA adapter into the base model and save the final
      merged model to disk -- same final step fine_tune.py performs for a
      PEFT run when save_steps isn't set.

Usage (run from inside whipa/code/, same as run_prep_dataset.py):

    python3 train_lora_mps.py \
        --dataset-dir ../whipa_prepped_dataset \
        --base-model openai/whisper-large-v2 \
        --output-dir ../models/lowhipa-mixtec-v1 \
        --num-train-epochs 5 \
        --dev-fraction 0.1
"""

import argparse
import os

import torch
from datasets import load_from_disk
from transformers import (
    WhisperForConditionalGeneration,
    WhisperTokenizer,
    WhisperProcessor,
    Seq2SeqTrainingArguments,
    Seq2SeqTrainer,
)
from peft import LoraConfig, get_peft_model

# Reuse THEIR actual classes directly -- not reimplemented. Both are plain
# class definitions in fine_tune.py sitting outside its `if __name__ ==
# "__main__":` guard, so importing them here does NOT trigger their whole
# argparse/config-driven CLI.
from fine_tune import DataCollatorSpeechSeq2SeqWithPadding, SavePeftModelCallback

# Reuse their add_ipa() function directly too -- exact same special-token
# setup they use for every fresh (non-continued) fine-tuning run.
from scripts.loader import add_ipa


def get_device():
    """Apple Silicon (M1-M5) uses the 'mps' backend for GPU acceleration --
    the direct equivalent of CUDA on NVIDIA hardware, but through PyTorch's
    Metal Performance Shaders integration instead. Falls back to plain CPU
    if MPS isn't available for some reason (e.g. running this on a different
    machine later)."""
    if torch.backends.mps.is_available():
        print("Using Apple Silicon MPS backend for training.")
        return torch.device("mps")
    else:
        print("MPS not available -- falling back to CPU (this will be slow).")
        return torch.device("cpu")


def build_lora_config(model):
    """EXACT same target-module selection logic as loader.py's PEFT branch:
    only the decoder's q_proj/v_proj submodules get LoRA adapters, matching
    the standard Whisper LoRA fine-tuning recipe referenced in their own
    code comments (openai/whisper#1707)."""
    target_modules = []
    for name, param in model.named_modules():
        if "model.decoder" in name and ("q_proj" in name or "v_proj" in name):
            target_modules.append(name)

    print(f"LoRA target modules ({len(target_modules)} found): {target_modules[:5]}... (truncated)")

    # r=32, lora_alpha=64, dropout=0.05, bias="none" -- identical values to
    # loader.py's own LoraConfig(...) call.
    return LoraConfig(
        r=32,
        lora_alpha=64,
        target_modules=target_modules,
        lora_dropout=0.05,
        bias="none",
    )


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dataset-dir", type=str, required=True,
                     help="Output directory from run_prep_dataset.py")
    ap.add_argument("--base-model", type=str, default="openai/whisper-large-v2")
    ap.add_argument("--output-dir", type=str, required=True)
    ap.add_argument("--dev-fraction", type=float, default=0.1,
                     help="Fraction of data held out for evaluation during training")
    ap.add_argument("--num-train-epochs", type=int, default=3,
                     help="Reduced from the project's own default of 5 -- with only "
                          "~1,076 total examples, fewer epochs meaningfully cuts total "
                          "training time with low risk of losing much benefit; 3 is a "
                          "reasonable balance, not a hard rule.")
    ap.add_argument("--eval-steps", type=int, default=242,
                     help="How often to run evaluation during training. Measured "
                          "directly on this dataset: each eval pass took ~103 seconds "
                          "on whisper-large-v2 -- at the project's own default "
                          "(every 50 steps), evaluation overhead alone would add roughly "
                          "1.5+ hours to a full run. 242 (~half an epoch at batch size 2) "
                          "cuts eval count roughly 5x while still giving regular progress "
                          "checkpoints.")
    ap.add_argument("--save-steps", type=int, default=242,
                     help="How often to save a checkpoint -- kept in sync with --eval-steps "
                          "by default. Checkpointing a 1.5B-parameter model also has real "
                          "disk-write overhead (~30 seconds observed for the final merge/save "
                          "step alone), so this shouldn't be set too frequently either.")
    ap.add_argument("--max-steps", type=int, default=-1,
                     help="If set (>0), stop after this many steps regardless of "
                          "epochs -- useful for a quick timing test on a large model "
                          "before committing to a full run (e.g. --max-steps 20).")
    ap.add_argument("--per-device-train-batch-size", type=int, default=4,
                     help="Kept small by default -- MPS memory behaves differently "
                          "from CUDA; increase if training runs stably and you want "
                          "faster epochs, decrease if you hit memory errors.")
    ap.add_argument("--learning-rate", type=float, default=1e-5)
    ap.add_argument("--seed", type=int, default=42)
    args = ap.parse_args()

    device = get_device()

    # -------------------------------------------------------------------
    # STEP 1: Load the prepped dataset (already has input_features + labels
    # from run_prep_dataset.py -- this is NOT raw audio anymore).
    # -------------------------------------------------------------------
    print(f"\nLoading prepped dataset from {args.dataset_dir}")
    dataset = load_from_disk(args.dataset_dir)
    print(f"  {len(dataset)} total examples")

    # Drop everything except input_features/labels before training. The
    # prepped dataset still carries the raw "audio" arrays (run_prep_dataset.py's
    # .map() call adds new columns without removing old ones) plus bookkeeping
    # columns (xml_file, orth, etc.) -- combined with remove_unused_columns=False
    # (required below for PEFT), keeping these around makes the Trainer do a lot
    # of unnecessary work handling large raw audio arrays it never actually uses,
    # which is the most likely cause of a long silent stall before training
    # visibly starts.
    keep_columns = {"input_features", "labels"}
    drop_columns = [c for c in dataset.column_names if c not in keep_columns]
    if drop_columns:
        print(f"  Dropping unused columns before training: {drop_columns}")
        dataset = dataset.remove_columns(drop_columns)

    # -------------------------------------------------------------------
    # STEP 2: Train/dev split. fine_tune.py's Trainer expects both
    # data_bin["train"] and data_bin["dev"] -- our dataset doesn't have this
    # split yet, since we built it as one combined manifest.
    # -------------------------------------------------------------------
    split = dataset.train_test_split(test_size=args.dev_fraction, seed=args.seed)
    train_dataset, dev_dataset = split["train"], split["test"]
    print(f"  Train: {len(train_dataset)}  |  Dev: {len(dev_dataset)}")

    # -------------------------------------------------------------------
    # STEP 3: Load tokenizer + processor (needed before the model, since
    # add_ipa() below needs the tokenizer to add the special IPA token).
    # -------------------------------------------------------------------
    print(f"\nLoading tokenizer/processor for base model: {args.base_model}")
    tokenizer = WhisperTokenizer.from_pretrained(args.base_model, task="transcribe")
    processor = WhisperProcessor.from_pretrained(args.base_model, task="transcribe")

    # -------------------------------------------------------------------
    # STEP 4: Load the base model in FULL PRECISION, moved to MPS.
    # This is the one step that genuinely differs from loader.py's own PEFT
    # branch (which uses CUDA-only 8-bit quantization via bitsandbytes).
    # -------------------------------------------------------------------
    print(f"Loading base model {args.base_model} (full precision, no quantization)")
    model = WhisperForConditionalGeneration.from_pretrained(args.base_model)
    model = model.to(device)

    # -------------------------------------------------------------------
    # STEP 5: add_ipa() -- THEIR function, called exactly as their own
    # non-whipa loading path does: adds the "<|ip|>" special token to the
    # tokenizer, registers it as a language ID, and resizes the model's
    # token embeddings to account for the new vocabulary entry.
    # -------------------------------------------------------------------
    print("Adding special <|ip|> IPA language token (add_ipa from loader.py)")
    add_ipa(model, tokenizer)
    model.generation_config.language = "<|ip|>"
    model.generation_config.task = "transcribe"

    # -------------------------------------------------------------------
    # STEP 6: Build and apply the LoRA adapter -- same target-module
    # selection and hyperparameters as loader.py's PEFT branch.
    # -------------------------------------------------------------------
    print("Applying LoRA adapter")
    lora_config = build_lora_config(model)
    model = get_peft_model(model, lora_config)
    model.enable_input_require_grads()  # same call loader.py makes for a fresh PEFT model
    model.print_trainable_parameters()

    # -------------------------------------------------------------------
    # STEP 7: Data collator -- THEIR exact class, imported directly.
    # Handles padding audio features and label sequences separately (they
    # need different padding strategies), and replaces label padding with
    # -100 so the loss function correctly ignores padded positions.
    # -------------------------------------------------------------------
    data_collator = DataCollatorSpeechSeq2SeqWithPadding(
        processor=processor,
        decoder_start_token_id=model.config.decoder_start_token_id,
    )

    # -------------------------------------------------------------------
    # STEP 8: Training arguments. Values below mirror fine_tune.py's own
    # "cpu_default" fallback values (the ones it uses when no CUDA GPU is
    # detected) -- since MPS is closer in practice to "no CUDA" than to a
    # full CUDA GPU in terms of how HuggingFace's Trainer treats it.
    #
    # A few settings are hardcoded differently from fine_tune.py on purpose:
    #   - fp16=False: mixed-precision training support on MPS has historically
    #     been inconsistent; disabling it trades some speed for reliability.
    #   - predict_with_generate=False, metric_for_best_model=None: required
    #     when PEFT is used, per fine_tune.py's own comment on these exact
    #     settings ("incompatible with PEFT").
    #   - remove_unused_columns=False, label_names=["labels"]: also required
    #     for PEFT, per fine_tune.py's own comments.
    # -------------------------------------------------------------------
    training_args = Seq2SeqTrainingArguments(
        output_dir=args.output_dir,
        per_device_train_batch_size=args.per_device_train_batch_size,
        per_device_eval_batch_size=max(1, args.per_device_train_batch_size // 2),
        gradient_accumulation_steps=1,
        learning_rate=args.learning_rate,
        warmup_steps=10,
        num_train_epochs=args.num_train_epochs,
        max_steps=args.max_steps,
        gradient_checkpointing=True,
        fp16=False,
        eval_strategy="steps",
        eval_steps=args.eval_steps,
        save_steps=args.save_steps,
        logging_steps=10,
        logging_first_step=True,
        report_to=["tensorboard"],
        load_best_model_at_end=True,
        predict_with_generate=False,      # required: incompatible with PEFT
        metric_for_best_model=None,       # required: incompatible with PEFT
        greater_is_better=False,
        remove_unused_columns=False,      # required for PEFT (see fine_tune.py comment)
        label_names=["labels"],           # required for PEFT
    )

    # -------------------------------------------------------------------
    # STEP 9: Build the trainer and train.
    # -------------------------------------------------------------------
    print("\n" + "=" * 80)
    print("Building Seq2SeqTrainer...")
    trainer = Seq2SeqTrainer(
        args=training_args,
        model=model,
        train_dataset=train_dataset,
        eval_dataset=dev_dataset,
        data_collator=data_collator,
        compute_metrics=None,             # skipped here for simplicity -- their
                                           # compute_metrics() depends on eval.py's
                                           # calc_metrics(), can be wired in later
                                           # once a basic training run is confirmed working
        callbacks=[SavePeftModelCallback],  # their exact checkpoint-saving callback
        processing_class=tokenizer,
    )
    print("Trainer built successfully.")

    print("\n" + "=" * 80)
    print("Starting fine-tuning...")
    print("=" * 80)
    trainer.train()

    # -------------------------------------------------------------------
    # STEP 10: Save the final model. Same final step fine_tune.py performs
    # for a PEFT run when save_steps isn't explicitly disabled -- merge the
    # LoRA adapter weights into the base model and save the result.
    # -------------------------------------------------------------------
    print("\nMerging LoRA adapter into base model and saving...")
    merged_model = model.merge_and_unload()
    merged_model.save_pretrained(args.output_dir, save_adapters=True, save_embedding_layers=True)
    tokenizer.save_pretrained(args.output_dir)
    processor.save_pretrained(args.output_dir)

    print(f"\nDone. Final model saved to {args.output_dir}")


if __name__ == "__main__":
    main()
