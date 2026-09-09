"""
Apply WhIPA's OWN prep_dataset() function (from code/scripts/whipa_utils.py)
to the raw dataset built by build_finetune_dataset.py.

WHY THIS SCRIPT EXISTS SEPARATELY:
  build_finetune_dataset.py deliberately does NOT precompute input_features or
  labels -- it just produces raw audio + the "ipa" text column. This script
  imports your actual, real prep_dataset()/prepare_dataset_ipa() functions
  directly from whipa_utils.py and runs them on that raw dataset, so the
  feature extraction and tokenization are IDENTICAL to what fine_tune.py
  itself would do -- not a separate reimplementation that could subtly differ
  (e.g. in whatever special-token handling their WhisperTokenizer config
  applies during tokenizer.encode_plus(batch["ipa"], add_special_tokens=True)).

USAGE:
  This must be run with whipa's code/ directory on your Python path, since it
  imports directly from there. Run it FROM the code/ directory itself:

    cd /Code/Projects/whipa/code
    python3 run_prep_dataset.py \
        --input-dir ../../whipa_raw_dataset \
        --output-dir ../../whipa_prepped_dataset \
        --base-model openai/whisper-large-v2 \
        --max-len 448

  --base-model should match whichever WhIPA/LoWhIPA checkpoint you actually
  plan to fine-tune from (check ft_config.json if unsure).
  --max-len is Whisper's max generation/label length; 448 is the standard
  Whisper default, but check model.generation_config.max_length for your
  specific checkpoint if you want to be precise (fine_tune.py itself uses
  exactly this value -- see the prep_dataset(..., max_len=model.generation_config.max_length, ...)
  call we found in fine_tune.py).
"""

import argparse
import sys
from pathlib import Path

from datasets import load_from_disk
from transformers import WhisperProcessor, WhisperTokenizer

# Import their ACTUAL functions -- not a reimplementation.
from scripts.whipa_utils import prep_dataset


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input-dir", type=str, required=True,
                     help="Output directory from build_finetune_dataset.py")
    ap.add_argument("--output-dir", type=str, required=True)
    ap.add_argument("--base-model", type=str, default="openai/whisper-large-v2")
    ap.add_argument("--max-len", type=int, default=448,
                     help="Drops examples whose tokenized labels exceed this length "
                          "(matches fine_tune.py's own max_len=model.generation_config.max_length)")
    ap.add_argument("--num-proc", type=int, default=4)
    args = ap.parse_args()

    print(f"Loading raw dataset from {args.input_dir}")
    dataset = load_from_disk(args.input_dir)
    print(f"  {len(dataset)} examples loaded")

    print(f"Loading WhisperProcessor and WhisperTokenizer for {args.base_model}")
    processor = WhisperProcessor.from_pretrained(args.base_model, task="transcribe")
    tokenizer = WhisperTokenizer.from_pretrained(args.base_model, task="transcribe")

    print("Running prep_dataset() -- this calls prepare_dataset_ipa() on every "
          "example, extracting input_features via the processor and tokenizing "
          "the 'ipa' column into 'labels' via tokenizer.encode_plus(...). This "
          "is their exact code, not a reimplementation.")
    prepped = prep_dataset(
        dataset, processor, tokenizer,
        max_len=args.max_len,
        seed=42,
        num_proc=args.num_proc,
    )

    print(f"\nAfter prep_dataset(): {len(prepped)} examples remain "
          f"(some may have been dropped for exceeding max_len)")

    prepped.save_to_disk(args.output_dir)
    print(f"Saved final training-ready dataset to {args.output_dir}")
    print(f"This is ready to pass directly into fine_tune.py's training loop / Seq2SeqTrainer.")


if __name__ == "__main__":
    main()
