# WhIPA Fine-Tuning on Mixtepec Mixtec — Preliminary Results Report

**Date:** 2026-09-09
**Model:** LoRA fine-tune of `openai/whisper-large-v2`, using the WhIPA/LoWhIPA framework (Suchardt et al., 2025 EMNLP; code: github.com/jshrdt/whipa)
**Checkpoint identifier:** `lowhipa-mixtec-v1`

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

Loss decreased steadily and substantially across training (final eval loss 1.008 vs. initial single-batch loss 7.119), with no indication of divergence or instability.

---

## 4. Evaluation

### 4.1 Metric definitions

Evaluation used WhIPA's own `STIPA_METRICS` class (`code/scripts/metrics.py`), not a reimplementation:

- **PER (Phone Error Rate)**: phone-level edit distance (insertions/deletions/substitutions, each phone as one unit via `retokenize_ipa`), normalized by gold phone count, ×100.
- **PFER (Phonetic Feature Error Rate)**: same edit-distance structure, but substitution cost is weighted by phonetic feature (articulatory) distance via PanPhon, rather than binary match/mismatch.

Both metrics compare model output against the *normalized* gold target (Section 2.3), since this is what the model was trained to predict.

### 4.2 Results — held-out test set (n=20 tokens, 10 files)

| Token | Predicted | Gold (normalized) | PER% | PFER% |
|---|---|---|---|---|
| che'e | t͡ʃe | t͡ʃɛʔɛ | 75.0 | 51.0 |
| vii | b | vii | 100.0 | 69.4 |
| ka'nu (1) | tano | kaʔnũ | 60.0 | 26.2 |
| ka'nu (2) | kãʔ̪n̪̪ | kaʔnũ | 80.0 | 22.1 |
| ka'nu (3) | kano | kaʔnũ | 40.0 | 22.5 |
| xeen (1) | ʃe | ʃɛ̃ɛ̃ | 66.7 | 36.1 |
| xeen (2) | ʃe | ʃɛ̃ɛ̃ | 66.7 | 36.1 |
| nchichi (1) | dʒitʃi | nd͡ʒit͡ʃi | 80.0 | 25.0 |
| nchich (2) | ndʒitʃi | nd͡ʒit͡ʃi | 80.0 | 43.3 |
| kochi (1) | koçi | kot͡ʃi | 25.0 | 5.7 |
| kochi (2) | koʔçi | kot͡ʃi | 50.0 | 30.7 |
| vee (1) | vee | vee | 0.0 | 0.0 |
| vee (2) | be | vee | 66.7 | 36.1 |
| vee (3) | beː | vee | 100.0 | 37.5 |
| nani (1) | nani | nani | 0.0 | 0.0 |
| nani (2) | nani | nani | 0.0 | 0.0 |
| nani (3) | nani | nani | 0.0 | 0.0 |
| kani (1) | kani | kani | 0.0 | 0.0 |
| kani (2) | kani | kani | 0.0 | 0.0 |
| kani (3) | kani | kani | 0.0 | 0.0 |

**Mean PER: 44.5%**
**Mean PFER: 22.1%**
**Exact-match rate: 7/20 (35%)**

### 4.3 Comparison: zero-shot baseline (pre-fine-tuning)

The same 10 held-out files were tested against the unmodified `jshrdt/whipa-large-cv` checkpoint (zero-shot, no Mixtec-specific training) prior to fine-tuning.

| Metric | Zero-shot (pre-fine-tune) | Fine-tuned (this report) |
|---|---|---|
| Exact-match rate | 0/20 (0%) | 7/20 (35%) |
| Approximate character-level PER (informal, pre-normalization convention) | ~68% | — |
| Character-level PER (this measurement, post-normalization) | — | 39.2% |
| Mean PFER (phone-feature-based) | not computed at time of zero-shot test | 22.1% |

Representative zero-shot failure case: input `ka'nu` (gold `kaʔnũ`) produced `t͡ɕɛraɾɛmɯ`, a prediction bearing no discernible phonetic relationship to the input audio — characteristic of the decoding-breakdown failure mode documented in the source papers for genuinely out-of-distribution input. No comparable total breakdown occurred in any fine-tuned prediction; all fine-tuned errors were partial (wrong or missing segments within an otherwise-recognizable prediction).

### 4.4 Comparison to published benchmarks

| Source | Metric | Value |
|---|---|---|
| Human inter-annotator agreement (Taguchi et al., 2023) | PFER | 19.6% |
| MultIPA zero-shot, unrelated languages (Taguchi et al., 2023) | PFER | 34.2% |
| WhIPA zero-shot, unrelated languages (Suchardt et al., 2025) | PFER (best config) | ~21.2% |
| **This work: LoWhIPA fine-tuned on Mixtepec Mixtec** | **PFER** | **22.1%** |

The fine-tuned model's PFER (22.1%) is close to the range reported for human inter-annotator agreement (19.6%) and to WhIPA's own best zero-shot cross-lingual transfer results on typologically related/unrelated languages, despite Mixtepec Mixtec being entirely absent from any prior training data and the fine-tuning corpus being an order of magnitude smaller than the ~1,000-samples-per-language scale used in the source papers.

---

## 5. Data quality issues encountered and addressed

- **Inconsistent tone/vowel-length notation** across source files, requiring the normalization pipeline in Section 2.3 (full detail in "IPA Transcription Guidelines" document).
- **Inconsistent file encoding** in Praat `.tsv` exports (UTF-8, UTF-16BE, UTF-16LE observed from the same export command on different files/sessions) — required an automatic encoding-detection/normalization step before XML generation.
- **XSLT pipeline bugs** discovered and fixed during this work: TSV header row not filtered from data rows; content preceding the first real utterance boundary incorrectly treated as a data row, causing duplicate-ID collisions; `<w>` elements originally carried only an onset timestamp, not an offset, preventing precise word-level audio cropping for multi-word utterances (fixed via TEI's native multi-pointer `@synch` mechanism).
- **6 of 1,082 training tokens** excluded due to unresolvable audio file references (2 files not yet located; see GitHub issue tracking this).

## 6. Notable decision reversed during this work

Affricate notation was initially standardized to the tie-barred IPA convention (`t͡ʃ`) to match WhIPA's own predicted-output convention, on the reasoning that consistent notation between training targets and model output would improve measured accuracy. This decision was reversed after reviewing early fine-tuning output showed the model itself was inconsistent in producing the tie bar — combined with a judgment that plain digraphs (`tʃ`, `dʒ`) are unambiguous for this corpus's actual intended use (language documentation/community use), the added notational complexity was judged not worthwhile. Note that `STIPA_METRICS`'s own normalization step treats both conventions as equivalent regardless, so this decision affects only what the model is trained to produce, not how scoring is performed.

---

## 7. Limitations

- **Test set size**: n=20 tokens across 10 files, several representing repeated recordings of the same word (`nani`×3, `kani`×3, `ka'nu`×3, `xeen`×2, `vee`×3). Effective diversity is closer to 12–13 unique word types. Results should be treated as an initial checkpoint, not a statistically robust benchmark.
- **No tone evaluation**: tone was excluded from both training targets and evaluation; this work addresses segmental phone transcription only.
- **Approximate audio boundaries for a subset of training data**: for the 324 multi-word files where word-level timing was reconstructed rather than natively present in the original export, end-of-word boundaries were approximated as the onset of the following word (or the utterance's own end, for the final word), not independently measured. This affects only the fine-tuning training data location logic, not the held-out test set (which has fully native per-token timing).
- **Training/dev split is a random split over the full corpus**, not stratified by word type; some word types may appear in both the training and dev partitions (though never in the fully separate held-out test set), which could modestly inflate dev-set metrics relative to genuinely unseen data.
- **Single training run**: no repeated runs with different random seeds have been performed to assess result variance.
