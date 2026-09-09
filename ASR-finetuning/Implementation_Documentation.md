# Implementation Documentation: Mixtepec Mixtec WhIPA Fine-Tuning Pipeline

**Purpose**: A complete, step-by-step record of every component built to go from "existing TEI/XML transcription corpus" to "a fine-tuned, evaluated LoWhIPA model," suitable for someone else to follow to reproduce or extend this work. Every step is explicitly labeled by its provenance (see legend below), directly answering the question: was this documented/expected by WhIPA, or did it have to be built/discovered from scratch?

## Provenance legend

- **[DOCUMENTED]** — directly specified in WhIPA's README or the accompanying paper; used as intended.
- **[SOURCE-DERIVED]** — not documented in the README/paper at all, but discoverable by reading WhIPA's actual source code. The functionality exists and works as WhIPA's authors intended, but a user following only the README would not know it was needed.
- **[BUG FIX]** — a code change required just to get WhIPA's own documented functionality working, due to the codebase being written against older versions of its dependencies (`transformers`, primarily). Not a design gap, but a compatibility problem with current library versions.
- **[IMPROVISED — NEW]** — built entirely from scratch, with no equivalent anywhere in WhIPA's code or documentation, because the task (working with an arbitrary custom TEI corpus, rather than WhIPA's own benchmark corpora) is outside what WhIPA was designed to handle.
- **[HARDWARE ADAPTATION]** — a substitution for a piece of WhIPA's own code that is CUDA-specific and does not run on Apple Silicon.

---

## Direct answer to "was everything needed explained in the documentation?"

**No.** The README documents *inference* with an existing pretrained checkpoint reasonably well (loading a `WHIPA` object, calling `transcribe_ipa()`). It does **not** document:
- The exact dataset schema `prep_dataset()`/`prepare_dataset_ipa()` expects (the literal required column name `"ipa"`, the fact that `"labels"` must be pre-tokenized rather than raw text) — this had to be discovered by reading `scripts/whipa_utils.py` directly.
- How to fine-tune on a custom, non-benchmark dataset at all — `fine_tune.py`'s entire `__main__` block is built around a config-driven system for loading WhIPA's own named corpora (CommonVoice, ASC, THCHS-30, Sanna), with no documented path for "I have my own TEI corpus, how do I plug it in."
- Any Apple Silicon / non-CUDA guidance whatsoever — the LoRA loading path is hardcoded to CUDA-only 8-bit quantization via `bitsandbytes`.
- A dependency list (no `requirements.txt` existed; the actual dependency set had to be discovered by running the code and installing packages as import errors surfaced).

**Also no** — several things that should have "just worked" per the documented API did not, due to the codebase predating current versions of `transformers`. These are enumerated as **[BUG FIX]** items below and are not a documentation gap so much as a maintenance gap; they'd affect any user regardless of how carefully they read the README.

**On which scripts were "expected" of the user**: None of the custom pipeline scripts described below (the TEI extraction, normalization, dataset-building, or MPS training scripts) were anticipated or outlined anywhere in WhIPA's documentation as something a user would need to write. The README's implicit assumption is that a user brings data already in one of WhIPA's supported benchmark formats. Adapting an arbitrary existing corpus (TEI/XML, custom tier structures, inconsistent legacy notation) to that pipeline required building an entirely separate, project-specific pre-processing layer that has no WhIPA counterpart at all.

---

## Stage 1: Understanding the target system

1. **[DOCUMENTED]** Read WhIPA's README (usage section: loading a `WHIPA` object, `transcribe_ipa()` inference pattern, evaluation via `STIPA_METRICS`).
2. **[DOCUMENTED]** Read the associated papers (Taguchi et al. 2023 "MultIPA"; Suchardt et al. 2025 EMNLP "Towards Language-Agnostic STIPA") for methodology, published benchmark numbers, and model/training design rationale.
3. **[SOURCE-DERIVED]** Ran a zero-shot baseline test against 10 held-out Mixtepec Mixtec tokens using an off-the-shelf `jshrdt/whipa-large-cv` checkpoint, to establish whether fine-tuning was worthwhile at all before investing further effort. This required directly inspecting `deploy.py`'s source to discover the actual required input schema for `transcribe_ipa()` (a dict with `input_features` and `audio.array`, not raw audio as the README's brief description might suggest) — **[SOURCE-DERIVED]**.

## Stage 2: Bugs found and fixed in WhIPA's own code (all [BUG FIX])

These were required just to get already-documented functionality (inference, then later training) working at all, independent of any custom-corpus work:

1. `deploy.py`: missing `import torch` (used inside `transcribe_ipa()` but never imported at module level).
2. `deploy.py`: `transcribe_ipa()` referenced an undefined variable `whipa` (should have been `self`) — a leftover from whatever script/notebook this method was originally developed in.
3. `deploy.py`'s `__init__` parameter is `base_model_name`, not `base_model` as the README's usage example shows — a README/code mismatch, not a bug in the code itself, but caused the same practical blocker.
4. `scripts/whipa_utils.py`: `prepare_dataset_ipa()` called `tokenizer.encode_plus(...)`, a method removed in current `transformers` releases. Fixed by calling the tokenizer directly (`tokenizer(...)`), which returns the same `.input_ids` attribute.
5. `scripts/loader.py`: top-level import of `TRANSFORMERS_CACHE` from `transformers`, a constant removed in current releases. Fixed by dropping it from the import line (confirmed unused by any function actually needed for this project's training path).
6. Custom training script (`train_lora_mps.py`, described below) hit `Seq2SeqTrainingArguments.__init__()` rejecting `overwrite_output_dir`, another parameter removed in current `transformers`. `fine_tune.py` itself uses this same parameter and would hit the identical error if run as-is on a current `transformers` install.

All six were reported upstream as bug reports (drafted, not necessarily all submitted at time of writing).

## Stage 3: TEI corpus extraction — entirely custom, [IMPROVISED — NEW]

WhIPA has no concept of a TEI/XML corpus; this entire stage has no WhIPA counterpart.

1. **[IMPROVISED — NEW]** `extract_finetune_data.py`: parses the single-word-per-utterance TEI corpus (`transcriptions-xml/`), extracting orthography, gold IPA, and token-level start/end timestamps per `<u>` element.
2. **[IMPROVISED — NEW]** `extract_finetune_data_sentences.py`: parses the structurally different multi-word-per-utterance corpus (Lección files), extracting individual word-level tokens (rather than whole-utterance strings) using the TEI `@synch` timestamp mechanism.
3. **[IMPROVISED — NEW]** `normalize_encoding.py`: detects and normalizes inconsistent file encoding in Praat's `.tsv` exports (UTF-8, UTF-16BE, UTF-16LE observed from the same export procedure on different files) to UTF-8 before any XML processing.
4. **[IMPROVISED — NEW]** Multiple fixes to the project's own `praat2tei-sil.xsl` XSLT (unrelated to WhIPA): filtering the TSV header row from being treated as a data row; excluding "orphan" content appearing before the first real utterance boundary from producing spurious output; adding a second timepoint reference to each `<w>`'s `@synch` attribute so multi-word utterances carry real per-word end-boundaries (previously only onset was recorded).
5. **[IMPROVISED — NEW]** `regenerate_word_alignment.py`: recovers word-level audio timing and applies legacy-to-current notation conversion for an older, structurally different raw-tier export format (pre-dating the current XSLT pipeline) found in some source files.

## Stage 4: Training-target normalization — [IMPROVISED — NEW]

1. **[IMPROVISED — NEW]** `normalize_ipa.py`: consolidated module implementing tone-stripping, affricate notation normalization, general vowel-length (`Vː`→`VV`) normalization, and the creakiness-adjacency rule. No equivalent exists in WhIPA; all rules were derived from direct consultation on this specific corpus's transcription conventions.

## Stage 5: Audio verification — [IMPROVISED — NEW]

1. **[IMPROVISED — NEW]** `verify_audio_paths.py`: cross-references manifest-expected audio filenames against actual files across one or more search directories (recursive), resolving naming inconsistencies (space/underscore separators) and reporting genuinely missing files. No WhIPA equivalent; entirely a consequence of working with a real-world, imperfectly organized existing corpus rather than a pre-packaged benchmark dataset.

## Stage 6: Dataset construction — [IMPROVISED — NEW] + [SOURCE-DERIVED]

1. **[IMPROVISED — NEW]** `build_finetune_dataset.py`: reads the normalized manifest, locates and crops audio per token, resamples to 16kHz, and packages into a `datasets.Dataset` with raw `audio` array and `ipa` text columns only (deliberately not precomputing features/labels itself).
2. **[SOURCE-DERIVED]** The decision to output *raw* audio + text (rather than precomputed features/labels) and hand off to WhIPA's own `prep_dataset()` function was made specifically to avoid reimplementing their tokenization/feature-extraction logic and risking a subtle mismatch — this was only possible after directly reading `prepare_dataset_ipa()`'s source to discover its exact expected input schema (the literal column name `"ipa"`; labels via direct tokenizer call).
3. **[SOURCE-DERIVED]** `run_prep_dataset.py`: imports and calls WhIPA's actual `prep_dataset()`/`prepare_dataset_ipa()` functions directly against the custom raw dataset, guaranteeing identical preprocessing to what `fine_tune.py` itself would produce, without reimplementing it.

## Stage 7: LoRA fine-tuning — [HARDWARE ADAPTATION] + [DOCUMENTED, reused directly]

`train_lora_mps.py` was built by directly reading `fine_tune.py` and `scripts/loader.py` end to end and reproducing their actual training logic, substituting only the one CUDA-specific step:

1. **[DOCUMENTED, reused directly]** `DataCollatorSpeechSeq2SeqWithPadding` class — imported directly from `fine_tune.py`, unmodified.
2. **[DOCUMENTED, reused directly]** `SavePeftModelCallback` class — imported directly from `fine_tune.py`, unmodified.
3. **[DOCUMENTED, reused directly]** `add_ipa()` function (special `<|ip|>` token setup, embedding resize) — imported directly from `scripts/loader.py`, unmodified.
4. **[DOCUMENTED, reused directly]** LoRA hyperparameters (r=32, alpha=64, dropout=0.05, target modules = decoder `q_proj`/`v_proj` only) — copied verbatim from `scripts/loader.py`'s own `LoraConfig` construction.
5. **[HARDWARE ADAPTATION]** Model loading: WhIPA's own PEFT branch loads the base model via `BitsAndBytesConfig(load_in_8bit=True), device_map="auto"` — CUDA-only. Replaced with loading in full precision and explicit `.to("mps")` placement, since 8-bit quantization via `bitsandbytes` is not available on Apple Silicon.
6. **[IMPROVISED — NEW, but modeled on their defaults]** `Seq2SeqTrainingArguments` values: based on `fine_tune.py`'s own documented "CPU default" fallback values (used when no CUDA GPU is detected), since MPS is closer to "no CUDA" than to a full CUDA GPU in terms of expected HuggingFace Trainer behavior. `fp16` explicitly disabled (inconsistent MPS support); `eval_steps`/`save_steps` increased beyond the project's defaults after direct measurement showed evaluation overhead consuming a disproportionate fraction of total training time on this hardware.
7. **[IMPROVISED — NEW]** Post-hoc fix: dataset columns not needed by the data collator (raw `audio` arrays, bookkeeping columns) were found to cause a severe, silent multi-minute stall before training visibly began, apparently due to `remove_unused_columns=False` (itself required for PEFT, per `fine_tune.py`'s own code comment) causing the Trainer to handle these large unused columns unnecessarily. Fixed by explicitly dropping all columns except `input_features`/`labels` before constructing the Trainer.

## Stage 8: Evaluation — [DOCUMENTED reused] + [IMPROVISED — NEW]

1. **[IMPROVISED — NEW]** Updated `test_whipa.py` (originally built for zero-shot baseline testing) to point at the local fine-tuned checkpoint, and to apply the *same* normalization pipeline (Stage 4) to displayed gold transcriptions, so predicted vs. gold comparisons are made on equal footing.
2. **[DOCUMENTED, reused directly]** `score_test_results.py`: uses WhIPA's own `STIPA_METRICS` class (`compute_all()`) directly for PER/PFER scoring — not a reimplementation. This is the one evaluation step that WhIPA's documentation does describe reasonably completely (the README shows this exact usage pattern).

---

## Summary table: what fraction of this pipeline is WhIPA's own vs. custom-built

| Stage | Provenance |
|---|---|
| Zero-shot baseline testing | Source-derived (schema undocumented) |
| Bug fixes to WhIPA's own code | Bug fixes (6 found) |
| TEI corpus extraction | 100% custom |
| Training-target normalization | 100% custom |
| Audio verification | 100% custom |
| Dataset construction | Custom wrapper, handing off to their real preprocessing functions |
| LoRA fine-tuning | Their exact config/logic, one hardware-forced substitution |
| Evaluation scoring | Their exact metrics class, used as documented |

**Overall assessment**: the *modeling* core (LoRA config, tokenization, feature extraction, evaluation metrics) is WhIPA's own code, used correctly and mostly as intended once the undocumented schema requirements were discovered. The *entire data pipeline* (getting from an existing real-world TEI corpus to something WhIPA can consume) had no equivalent in WhIPA at all and was built from scratch specifically for this project.
