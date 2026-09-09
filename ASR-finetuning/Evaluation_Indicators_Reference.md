# Evaluation Indicators for STIPA Fine-Tuning Experiments — Reference Notes

**Purpose of this document**: This is a working reference for the indicators/metrics/considerations relevant to evaluating a speech-to-IPA (STIPA) fine-tuning experiment like the one performed here, and *why* each one matters in this specific context. Written to support independent understanding of the methodology — not a summary of the specific results (see the separate Preliminary Results Report for that), and not written toward a specific paper framing, since that framing should be developed independently.

---

## 1. Core accuracy metrics

### 1.1 PER (Phone Error Rate)
**What it is**: Edit distance (insertions + deletions + substitutions) between predicted and gold phone sequences, where each phone is one unit, normalized by gold length.

**Why it matters here**: This is the most direct, literal measure of "how many phones did the model get wrong." It's the metric most comparable across papers in this space (Taguchi et al. 2023, Suchardt et al. 2025), since it's simple and doesn't depend on which phonetic feature system is used.

**Limitation to understand**: PER treats *all* errors as equally bad. A model that confuses /p/ and /b/ (a one-feature difference) scores identically to a model that confuses /p/ and /a/ (a stop consonant vs. a vowel — many features different). This means PER alone can make a linguistically "close" model look no better than a genuinely confused one.

### 1.2 PFER (Phonetic Feature Error Rate)
**What it is**: Same edit-distance structure as PER, but substitution cost is weighted by how many articulatory features (from PanPhon's feature table — place, manner, voicing, etc.) actually differ between the predicted and gold phone.

**Why it matters here**: This is the metric that actually reflects whether a model has learned real phonetic/articulatory structure, as opposed to just pattern-matching. If a model's PFER is much lower than its PER, that's a specific, interpretable signal: the model's mistakes are phonetically *close* to correct, not random. This is the more informative metric for judging whether fine-tuning taught the model something linguistically real about the target language, which is the actual research question here (not just "did the string match exactly").

**Why comparing to literature specifically requires PFER, not PER**: The original papers report both, but treat PFER as the primary metric precisely because it's less sensitive to how a training corpus's diacritic/notation conventions happen to be structured. If you want to make a claim like "this model approaches human-level performance," PFER against the reported human inter-annotator agreement figure is the legitimate comparison — PER against that same figure is not directly comparable, since PER's raw number is more sensitive to the underlying phone inventory size and notation granularity.

### 1.3 Normalized variants (PER_norm, PFER_norm)
**What they are**: Same numerator (edit distance), but divided by `max(len(pred), len(gold))` instead of just `len(gold)`.

**Why they matter here**: When a model's prediction is drastically shorter or longer than the gold (e.g. a decoding failure producing a 3-character garbage string against a 6-character gold), plain PER/PFER can exceed 100% or become misleadingly large/small depending on direction. The normalized variant bounds this, useful specifically for catching and reasonably scoring catastrophic failure cases (like the zero-shot baseline's `t͡ɕɛraɾɛmɯ` for `kaʔnũ`) without them distorting an aggregate average as badly.

### 1.4 CER (Character Error Rate) / raw Levenshtein distance
**What it is**: Same idea as PER, but operating on raw characters rather than phone-tokenized units.

**Why it's a weaker but still useful check here**: CER doesn't understand that a multi-character sequence (e.g. `t͡ʃ`, a tie-barred affricate) is *one* phone, not three characters — so it will penalize a phonetically-correct affricate prediction as if it were several separate errors, just because of how many Unicode codepoints it happens to use. This matters directly in this project, since the corpus has genuinely mixed affricate notation conventions (plain digraphs, ligatures, tie-barred forms) — CER is notation-sensitive in a way PER/PFER (via proper phone tokenization) are not. Still useful as a quick sanity check when you don't have the full PanPhon pipeline running, but should never be the metric used for a real claim.

---

## 2. Training-process indicators (not accuracy metrics, but essential to interpret results correctly)

### 2.1 Training loss trajectory
**What to look for**: Loss should decrease and stabilize, not oscillate wildly or plateau immediately at a high value.

**Why it matters here**: This is the first-line check that the fine-tuning pipeline is actually working at all — e.g., if the tokenizer/label pipeline had a bug (as several were found and fixed during this implementation), loss would likely fail to decrease meaningfully, which is a diagnostic signal *before* you ever get to computing PER/PFER on held-out data.

### 2.2 Train loss vs. eval loss divergence (overfitting indicator)
**What to look for**: If train loss keeps dropping while eval loss stops improving or starts rising, that's the classic overfitting signature.

**Why it matters especially in this project**: The training corpus here (968 examples) is extremely small by ASR fine-tuning standards. Overfitting risk is genuinely higher than it would be with a corpus in the thousands or tens of thousands of examples. This should be actively monitored on every future training run, not just checked once — as more data is added, the point at which overfitting starts to appear will shift, and needs to be re-verified rather than assumed to still hold.

### 2.3 Number of epochs
**Why it's a real decision, not just a hyperparameter to default**: With a very small dataset, more epochs means more passes over the *same* limited examples, which increases overfitting risk without necessarily adding real generalizable signal. The published WhIPA/MultIPA papers use a default of 5 epochs, calibrated to their much larger training sets (700–50,000+ samples). Using their default epoch count uncritically on a dataset 1–2 orders of magnitude smaller is not automatically appropriate and should be tuned/monitored rather than assumed to transfer.

---

## 3. Sample-size and test-set-composition considerations

### 3.1 Test set size and statistical robustness
**Why this matters specifically for this result**: An n=20 test set (this experiment) cannot support strong claims about "true" model accuracy — a handful of unlucky or lucky tokens can swing the mean substantially. This isn't a flaw unique to this implementation; it's a general property of small-sample evaluation. The practical implication: treat any single PER/PFER number from a small test set as a *checkpoint for relative comparison* (did this training run do better or worse than the last one, on the same fixed test set), not as a precise, generalizable accuracy figure.

### 3.2 Repeated word types within a test set
**Why this matters specifically here**: This experiment's 20-token test set contains only ~12–13 unique word types (several words appear 2–3 times, e.g. multiple recordings of "nani", "kani"). A model that has essentially memorized a handful of common short words will look artificially strong if those same words are heavily repeated in the test set. This is worth explicitly separating in future evaluation: report both a per-token average AND a per-unique-word-type average, since they can tell meaningfully different stories about whether the model generalizes or has just learned specific common words well.

### 3.3 Train/dev split contamination risk
**Why this matters here specifically**: The train/dev split used in this experiment was a random split over the full token pool, not stratified by word type or speaker. If the same word (e.g. multiple recordings of the same elicitation item) appears in both train and dev, the dev-set loss/metrics will be somewhat inflated relative to genuinely unseen material — because the model may have partially learned that specific word's audio-to-IPA mapping from a near-duplicate training example. This is a smaller-scale version of the same underlying issue as 3.2, but affects the *training process's own internal validation signal* (eval_loss), not just the final held-out test score. Note this does **not** affect the held-out test set itself, which was excluded from the corpus entirely before any splitting occurred — this is specifically a caveat about how much to trust the eval_loss numbers seen *during* training.

---

## 4. Comparability to published benchmarks

### 4.1 Why comparing to Taguchi et al. (2023) and Suchardt et al. (2025) is meaningful at all
Both papers report PER/PFER for zero-shot transfer to languages absent from training data, and both report a human inter-annotator agreement figure as an implicit upper bound on what any model (or even a second human transcriber) should be expected to achieve. Comparing a new result against these numbers answers a specific, well-posed question: **is this model's performance in the range we'd expect from "reasonably good phonetic transcription," or is it still in "essentially broken" territory?** This is a more meaningful framing than an isolated PER/PFER number with no external reference point.

### 4.2 What such a comparison can and cannot support
**Can support**: "this fine-tuned model's PFER is comparable to published zero-shot cross-lingual transfer results on other unrelated languages, despite this specific language having zero prior representation and this training corpus being far smaller than those studies used."

**Cannot support** (without further work): direct claims about relative model quality across languages, since test-set composition, phone inventory size, and recording conditions differ substantially across corpora and are not controlled for.

### 4.3 Why the specific comparison point matters (zero-shot vs. fine-tuned, not just "vs. literature")
The most defensible comparison in this project is the **within-project** one: this same base architecture, zero-shot vs. fine-tuned, on the same held-out test set. This holds constant everything except the one variable actually being tested (did fine-tuning help), and is a stronger piece of evidence than comparing raw numbers to a different paper's different corpus. The literature comparison (Section 4.1) is a secondary, contextualizing data point, not the primary evidence.

---

## 5. Data-quality and pipeline-integrity considerations

### 5.1 Training-target notation consistency
**Why this is itself an evaluation consideration, not just a data-cleaning step**: If gold transcriptions in the training data use inconsistent notation for the same underlying phone (e.g. sometimes `Vː`, sometimes `VV` for the same long vowel), the model receives contradictory training signal for identical acoustic input — this isn't just messy data, it's a direct source of measurable performance degradation, and normalizing it is a legitimate, reportable methodological step (see the normalization pipeline described in the Preliminary Results Report), not merely housekeeping.

### 5.2 Matching evaluation-time normalization to training-time normalization
**Why this specific check mattered in this project**: Early in this implementation, held-out gold transcriptions were displayed and could have been compared in their *raw*, un-normalized form (tone marks, inconsistent vowel-length notation intact) against a model that was *trained* on normalized targets. This would have produced a systematically misleading (artificially poor) accuracy figure, penalizing the model for correctly not producing tone marks it was never trained to produce. This is a general principle for any fine-tuning evaluation: **the evaluation target must be transformed by the exact same normalization pipeline as the training target**, or the comparison is not valid.

### 5.3 What tone exclusion means for interpreting these results
Since tone was stripped from all training and evaluation targets in this phase, these PER/PFER numbers say nothing about tone-prediction accuracy — they exclusively measure segmental (consonant/vowel) transcription quality. Any future report or presentation of these results should be explicit that this is a **segmental-only** evaluation, to avoid the reader assuming a stronger claim (full phonetic transcription including tone) than what was actually tested.

---

## 6. Open questions worth resolving before treating results as final

- Should future evaluation report per-unique-word-type metrics separately from per-token metrics (Section 3.2)?
- Should the train/dev split be re-done in a stratified (by word type or speaker) manner to reduce the contamination risk in Section 3.3?
- At what corpus size does the epoch-count decision (Section 2.3) need to be revisited?
- Would a larger, more diverse held-out test set (beyond the current 10 files/20 tokens) be worth constructing before making stronger claims, given Section 3.1?
