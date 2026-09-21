# WhIPA Fine-Tuning on Mixtepec Mixtec — Preliminary Results Report

**Date:** 2026-09-09
**Model:** LoRA fine-tune of `openai/whisper-large-v2`, using the WhIPA/LoWhIPA framework (Suchardt et al., 2025 EMNLP; code: github.com/jshrdt/whipa)
**Checkpoint identifier:** `lowhipa-mixtec-v1`

---

> **⚠️ Post-hoc data quality addendum (added 2026-09-21):** the 818-token
> `transcriptions-xml/` figure in Section 2.1 was produced by an extraction script
> (`extract_finetune_data.py`) later found to have a bug: it silently truncated
> every multi-word utterance to its first word while keeping the *entire* utterance's
> audio span as the timestamp. Independent structural classification of the source
> corpus found that ~441 of these 818 "single-word" tokens (54%) were actually drawn
> from multi-word sentences, not single-word elicitations as described below. See
> the note in Section 2.1 and the new bullet in Section 7 for detail. This does not
> invalidate the pipeline, methodology, or evaluation metrics documented here — the
> held-out test set (Section 2.2) was unaffected, since it was verified against
> genuinely single-word files — but it means a meaningful fraction of
> `lowhipa-mixtec-v1`'s *training* data paired mismatched audio/text, and the results
> below should not be treated as a clean baseline for comparison against a checkpoint
> trained on corrected data.

---

## 1. Objective

Evaluate whether LoRA fine-tuning of a Whisper-based speech-to-IPA (STIPA) model, using a small existing corpus of Mixtepec Mixtec phonetic transcriptions, improves automatic phonetic transcription accuracy relative to the same base model's zero-shot performance on this language. Mixtepec Mixtec is not represented in any of WhIPA's original training data (CommonVoice languages, Arabic Speech Corpus, THCHS-30 Mandarin), nor in any typologically similar training language.

---

## 2. Data

### 2.1 Training corpus

| Source | Tokens | Description |
|---|---|---|
| `transcriptions-xml/` (single-word elicitation corpus) | 818 | Individually elicited words/short phrases, one gold IPA transcription per token, TEI/XML format |
| `SIL_docs/Aprendamos-2018/speech_transcriptions/` (Lección 01–05) | 264 | Word-level tokens extracted from sentence-level elicitation recordings |
| **Total training tokens** | **1,082** | |
| Tokens with resolvable audio (post audio-file verification) | 1,076 | 6 tokens excluded: audio file not locatable |

**Note (added 2026-09-21):** the 818 tokens attributed to `transcriptions-xml/` above
were extracted with a script since found to truncate multi-word utterances to their
first word (see addendum at top of document, and Section 7). ~441 of these 818 tokens
were likely mismatched audio/text pairs rather than genuine single-word elicitations.

Training/dev split: 968 / 108 (90/10 random split, seed=42), performed on the combined 1,076-token pool.

### 2.2 Held-out test set

10 single-word audio files (`ADJ_beautiful_anim_01_JS.wav`, `ADJ_beautiful_inan_01_JS.wav`, `ADJ_big_01_02_03_JS.wav`, `ADJ_dangerous_01_JS.wav`, `ADJ_dangerous_02_JS.wav`, `ADJ_difficult_01_02_spkrTS.wav`, `ADJ_fat_01_02_spkrTS.wav`, `ADJ_heavy_01_02_03_JS.wav`, `ADJ_long_DIST_01_02_03_JS.wav`, `ADJ_long_SHAPE_01_02_03_TS.wav`), comprising 20 individual tokens (several files contain repeated tokens of the same word). These files were excluded from the training corpus at extraction time and never seen by the model during fine-tuning.

### 2.3 Training-target normalization

Gold IPA transcriptions in the source corpus follow several inconsistent notational conventions (see Section 5 and the accompanying "IPA Transcription Guidelines" document for full detail). Before use as training targets, all gold IPA strings were normalized via a fixed pipeline (`normalize_ipa.py`):

1. **Tone-stripping**: all tone/suprasegmental marks removed (Chao tone letters, contour arrows, indeterminate-tone marker, downstep, combining tone diacritics). Segmental features (nasalization, length, glottal stop, dental diacritics) explicitly preserved.
2. **Affricate normalization**: precomposed ligatures (ʧ, ʤ, ʦ, ʣ) converted to plain two-character sequences (tʃ, dʒ, ts, dz). No tie-bar insertion (see Section 6, decision reversal).
3. **Vowel-length normalization**: `Vː` (vowel + IPA length mark) converted to `VV` (doubled vowel letter), correctly handling nasalized/diacritic-bearing vowels (e.g. `ɛ̃ː` → `ɛ̃ɛ̃`, not `ɛɛ̃`).
4. **Creakiness normalization**: creaky-voice diacritic (U+0330) stripped when adjacent to `ʔ` (redundant coarticulatory effect); retained otherwise. Confirmed via direct consultation that creaky voice in this corpus occurs only adjacent to `/ʔ/`, never independently.

Tone is deliberately excluded from this training pass; tone modeling is scoped as a separate, later phase.

---

## 3. Method

### 3.1 Pipeline overview

1. **Extraction**: TEI/XML transcriptions parsed to extract token-level orthography, gold IPA, and precise start/end audio timestamps. Two extraction paths were required due to differing source-corpus structures (single-word-per-utterance vs. multi-word-per-utterance).
2. **Audio verification**: cross-referenced every token's expected audio filename against actual files on disk across multiple candidate directories, resolving naming inconsistencies (space vs. underscore separators, missing `<media>` references).
3. **Dataset construction**: audio cropped to each token's exact time span, resampled to 16kHz (Whisper's required input rate), packaged into a HuggingFace `datasets.Dataset` with the raw `audio` array and normalized `ipa` text column.
4. **Feature/label preparation**: WhIPA's own `prep_dataset()`/`prepare_dataset_ipa()` functions (from `scripts/whipa_utils.py`) applied directly, producing precomputed Whisper mel-spectrogram features and tokenized label sequences.
5. **LoRA fine-tuning**: base `whisper-large-v2` loaded in full precision (no quantization), special `<|ip|>` IPA-language token added and embeddings resized, LoRA adapter applied to decoder `q_proj`/`v_proj` modules (r=32, alpha=64, dropout=0.05 — identical to WhIPA's own published configuration), trained via HuggingFace `Seq2SeqTrainer`.

### 3.2 Hardware and training configuration

- **Hardware**: Apple Silicon M5 (MPS backend, no CUDA GPU)
- **Base model**: `openai/whisper-large-v2` (1,553,792,000 total parameters)
- **Trainable parameters**: 10,485,760 (0.6748% of total, via LoRA)
- **Epochs**: 3
- **Batch size**: 2 (per device)
- **Learning rate**: 1e-5
- **Eval/save interval**: every 242 steps
- **Total steps**: 1,452
- **Precision**: full (fp32); fp16 disabled due to inconsistent MPS support
- **Total training time**: 3 hours 13 minutes (11,610 seconds)

### 3.3 Training dynamics

| Step (approx.) | Train loss | Eval loss |
|---|---|---|
| Start (step ~1) | 7.119 | — |
| ~50% (epoch ~1.5) | ~1.0–1.3 | ~1.0 |
| End (step 1452, epoch 3) | 2.58 (running avg.) | 1.008 |

Loss decreased steadily and substantially across training (final eval loss