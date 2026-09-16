# Mixtepec-Mixtec IPA Transcription & Normalization Guidelines

**Purpose**: This document logs (1) the transcription conventions Jack uses going forward for new annotation, and (2) the normalization rules applied when converting existing/legacy transcriptions into consistent ASR training targets. These are two different things — the *archival* transcription can stay however it was originally written; normalization happens at the point of generating a derived training manifest, never by editing the original TEI source.

Last updated: 2026-09-08

---

## 1. Tone marking

### Current/forward convention
- Level tones marked with a single combining diacritic directly on the vowel: acute ( ́ , high), grave ( ̀ , low), macron ( ̄ , mid), caron ( ̌ , rising contour), circumflex ( ̂ , falling contour).
- Additional contour diacritics available: combining acute-macron (᷇, high-mid), combining grave-macron (᷅, low-mid), combining macron-acute (᷄, mid-high), combining macron-grave (᷆, mid-low).
- Downstep marked with ꜜ (U+A71C, standalone modifier letter).
- On a **long vowel** (spelled as two vowel letters, e.g. `ee`), a contour tone is spelled as **one diacritic per mora** — one accent on each of the two letters — rather than a single combined symbol on one letter. E.g. `jéê` (high-falling long /e/), not a single vowel + combined contour mark.

### Legacy convention (older transcriptions, being phased out)
- Long vowel marked as a single vowel + IPA length mark (`ː`), with the tone/contour expressed as a **trailing arrow sequence** immediately after the length mark — e.g. `tsaː↗↘` (rising-then-falling contour on a long /a/).
- Standalone Chao tone letters (˥˦˧˨˩) were also used directly, sometimes doubled for contours (e.g. `˥˧` for a high-falling-to-mid contour).
- `∙` (U+2219) was used to mark "tone indeterminate — F0 quality too poor to judge," not a real tone value.

### Normalization rule: legacy → current
When generating ASR training targets (or otherwise normalizing legacy data to the current convention):
- `Vː` + exactly 2 trailing marks (arrows and/or the indeterminate-tone dot) → per-mora `VV` + individual diacritics, one per mora. Mapping:
  - `↘` (falling) → combining circumflex, e.g. **â**
  - `↗` (rising) → combining caron, e.g. **ǎ**
  - `∙` (indeterminate — tone genuinely unknown) → **no diacritic**, bare vowel
  - Example: `tsaː↗↘` → `tsǎâ`
  - Example with indeterminate marker: `veː∙↗` → `veě` (first mora unmarked, second mora rising)
- **Contour-diacritic collapsing rule (added 2026-09-09)**: the combining contour diacritics that mix two *level* tones (combining macron-acute "mid-high", combining grave-macron "low-mid", combining macron-grave "mid-low", combining acute-macron "high-mid") should be converted to the simpler **rising** (caron, for any contour moving low→high) or **falling** (circumflex, for any contour moving high→low) diacritic instead of preserved as their own separate 4-way distinction. This collapses a finer-grained tone system down to the same rising/falling contrast already used for the arrow-derived contours above, for consistency across the whole corpus's tone marking.
- **Open question, not yet resolved**: 3+ consecutive marks after a long vowel. A full corpus scan found only 2 real cases (`iː↘↗↘` and `k̬oː↘↗↘`, both fall-rise-fall on a 2-mora vowel, both from similar "live at home" sentences) — under review, pending Jack checking the original recordings to determine the intended contour before a rule is set. Do not guess; `convert_legacy_long_vowel_contour()` leaves these untouched and flags them.

### Important scope note: this conversion is for ASR training targets only, not a mandate to change the archival transcription convention
The arrows in the legacy notation don't always mark a concretely-identified phonological tone — Jack has also used them at times to record a general auditory *impression* of pitch movement, without committing to a specific tone category. That's a meaningful distinction the current-convention diacritics don't capture as loosely. So:
- This conversion is being applied **now** specifically to generate clean training targets for the WhIPA fine-tuning task.
- It is **not yet** a decision to normalize the broader dictionary/corpus (TextGrid → tsv → XML → dictionary, all downstream stages) to the new convention — that's a separate, larger decision still pending, given the real cost of re-touching every stage of the pipeline and the open question of how to preserve the "general impression" meaning some arrows carry versus fully-committed phonological tone.

### Normalization rule: full tone-stripping (for phone-only ASR training targets)
Since the current fine-tuning pass is training on segmental phones only (tone excluded), ALL tone/suprasegmental marks are stripped entirely from training targets — this is a separate, more aggressive step than the legacy-to-current conversion above. Characters stripped:

**Standalone characters:**
- Chao tone letters: `˥ ˦ ˧ ˨ ˩` (U+02E5–U+02E9)
- Contour arrows: `↗ ↘` (U+2197, U+2198)
- Indeterminate-tone marker: `∙` (U+2219)
- Downstep: `ꜜ` (U+A71C)

**Combining diacritics** (stripped after NFD decomposition, so stacked marks like nasalization+tone separate correctly):
- Acute `´` (U+0301, high)
- Grave `̀` (U+0300, low)
- Circumflex `^` (U+0302, falling)
- Macron `¯` (U+0304, mid)
- Caron `ˇ` (U+030C, rising contour)
- Combining acute-macron (U+1DC7), grave-macron (U+1DC5) — additional contour tones

**Critically NOT stripped** (these are segmental, not tonal): vowel length `ː`, nasalization tilde `̃`, glottal stop `ʔ`, dental diacritic, or any other segmental IPA symbol/diacritic. The stripping function must operate on individual Unicode combining marks after decomposition, not delete whole characters wholesale — e.g. `meṹ` (nasalized + high tone /u/) → `meũ` (nasalization preserved, tone removed), not `meu` (which would incorrectly also destroy the nasalization).

Implemented in `extract_finetune_data.py`'s `strip_tones()`.

---

## 2. Vowel length

### Decision: standardize on `VV` (doubled letter), not `Vː` (vowel + length mark)
Reasoning:
- Ties directly to the tone-marking decision above — per-mora tone marking (one diacritic per letter) only works cleanly with the doubled-letter spelling, since each mora needs its own letter to carry its own diacritic.
- Matches the majority convention already present in the existing 818-token corpus.
- After tone-stripping, `VV` and `Vː` are NOT equivalent as training targets (`aa` vs `aː`) — picking one and normalizing consistently avoids introducing label noise that would otherwise count phonetically-identical vowels as mismatches during PER/PFER scoring.

---

## 3. Affricates

### Decision: standardize on tie-barred form (e.g. `t͡ʃ`), not plain sequences or ligatures
Three conventions found coexisting in the existing corpus (818-token scan): 91 tokens using plain two-character sequences (`tʃ`), 6 using precomposed ligatures (`ʧ`), 0 using tie-barred form.

Reasoning for standardizing on tie-barred:
- **Matches WhIPA's own predicted output convention** — the model's zero-shot predictions consistently produced tie-barred affricates (`t͡ʃɛɛ`, `d͡ʒit͡ɕi`, etc.). Training targets in a different convention would penalize phonetically-correct predictions purely on notation mismatch during scoring.
- **Affects phone counting**, not just cosmetics — `metrics.py`'s `retokenize_ipa()` and `transcribe_ipa()`'s phones-per-second rate-limit logic need to treat an affricate as one phone. A plain two-character sequence risks being counted as two separate phones (stop + fricative).
- Precomposed ligatures (`ʧ`, `ʤ`, etc.) are deprecated in the current IPA standard (removed from the official chart since 1989), have inconsistent font support, and behave unpredictably under Unicode NFC/NFD normalization.

Tracked in GitHub issue #134.

---

## 4. Creakiness diacritics (VʔV context)

### Decision: only mark when it carries real phonetic information
In a V-ʔ-V context, the first vowel tends to be creaky as an automatic, non-phonological coarticulatory effect of the following glottal stop — this is NOT independently meaningful when the glottal stop itself is fully articulated and already marked.

- **Do NOT mark creakiness** when a fully-articulated `ʔ` is already present and clearly transcribed — it's redundant, and inconsistent marking of a redundant feature is pure label noise.
- **DO mark creakiness** in fast-speech contexts where the glottal stop has reduced or deleted entirely — in that case, the creaky voice is the *only* surviving cue that a `/ʔ/` was underlyingly present, and is genuinely informative.

Rationale generalizes the same principle as the tone/affricate/vowel-length normalization: consistency of a feature's marking matters more to the model than capturing every phonetic detail, and marking something in some tokens but not others (when it's not distinctive) actively hurts training.

---

## 5. Long /e/ — flagged for review, not yet resolved

Transcriptions of long /e/ across the corpus are suspected to actually be **open-mid [ɛː]** rather than **close-mid [eː]** in most/all cases. This needs a manual review pass across the corpus before fine-tuning — not yet normalized, since the correct target value per-token hasn't been confirmed.

## 5a. Other diacritics reviewed (2026-09-09 corpus scan)

A full scan of every combining diacritic actually in use across the training manifests, prompted by identifying the dental diacritic issue below, surfaced a few more cases worth a documented decision each:

- **Dental diacritic (combining bridge below, U+032A, 143 occurrences)**: **stripped** from training targets. Dental articulation is not phonologically contrastive in this language (confirmed via direct consultation) — this is narrow phonetic detail, not a meaningful distinction, and leaving it in would only add notational noise without conveying real information to the model.
- **Combining caron below (U+032C, 28 occurrences)**: **kept, not stripped.** This marks a systematic, regular partially-voiced variant of /k/ in post-nasal position — not incidental noise like the dental diacritic. Stripping it would collapse two acoustically distinct sounds (this variant and a "clean" voiceless /k/ elsewhere in the corpus) onto the identical training symbol, which is exactly the kind of inconsistency the rest of this normalization effort is trying to eliminate, not create. There is an open concern that this partially-voiced variant may be perceptually/acoustically close enough to /g/ that the ASR could confuse the two — but this is treated as an empirical question to observe in future evaluation, not a reason to hide the distinction via normalization.
- **Two rare, single-occurrence marks** (combining vertical line below U+0329, "syllabic"; combining right half ring below U+0339, "less rounded"): **stripped** from training targets, confirmed incidental rather than a systematic pattern given only one occurrence each across the whole corpus.

---

## 5b. Transcription methodology — AILLA MYUC-1042 source specifically

These principles apply to phonetic transcription of the MYUC-1042 (AILLA) recording specifically, not the corpus's general conventions elsewhere:

**General articulatory phones**: transcribing what is actually heard, not what the source orthography states. The original transcription (Jerry Salazar / Guillem Belmar's team) normalizes both pronunciation variants and, at times, vocabulary itself in its orthographic layer — this project's IPA layer is independent of that normalization and reflects direct auditory judgment instead.

**Tone transcription/attribution**: the original transcribers' tone marking is trusted and preserved by default (Guillem Belmar's tone judgments specifically). Exception: cases where the source orthography marks two different tones on a single long vowel. These require direct judgment call:
- If there is no audible pitch change across the vowel, one of the two marked tones is chosen (informed by, but not strictly bound to, the source's own attribution) — e.g. source "oò" with no perceptible pitch movement resolves to a single chosen tone.
- If there is an audible pitch slope, but its duration only spans a single mora's length (not the full long vowel), the slope is transcribed as a simple rising or falling tone accordingly, based on direct auditory judgment.

### 5b.1 Overriding a confident (non-ambiguous) original tone transcription

The case above concerns resolving genuine ambiguity already present in the source's own marking. A separate, stronger situation: overriding an original tone transcription that is NOT ambiguous — the source clearly and confidently marked a specific tone pattern — because direct evidence contradicts it.

**Confirmed case**: a CVCV utterance the source transcribed as L-L, where auditory judgment and F0 both clearly indicated H-F instead. Corrected to H-F in this project's IPA layer.

**Criteria for this kind of override** (not to be applied loosely):
- The utterance was carefully, deliberately articulated (not rapid/casual connected speech) — this matters because it supports confident phonetic judgment in the first place, and because F0 in casual speech is heavily shaped by intonation, prosodic phrasing, declination, and emphasis, not just lexical tone (see caution below).
- The discrepancy is clear and unambiguous, not a borderline or subtle judgment call.
- Auditory perception and F0 evidence agree with each other, not just one or the other.

**Caution, explicitly flagged**: reading phonological tone categories directly off F0 contours in natural, casual, spontaneous speech is methodologically risky — F0 movement in that register reflects many overlapping factors beyond lexical tone, and is not a reliable basis for confident tone reassignment the way a carefully-articulated, citation-style utterance is. This override policy is NOT license to systematically "correct" tone transcriptions across casual conversational material based on F0 measurement alone.

**Open action item**: this specific case suggests a broader review of tone transcriptions in this source may be warranted before the tone-inclusive data is used for fine-tuning, distinct from and in addition to the already-open questions in Section 6. Not yet scoped as a formal task.

## 6. Open decisions pending

- **Praat TextGrid source sync (added 2026-09-09)**: If tone/notation normalization is ever applied more broadly than the current ASR-training-manifest scope (i.e., beyond just deriving a training target), a decision is needed on whether to also update the original Praat TextGrid source files to match, or leave them as-is. If only the TEI/XML output is updated and the TextGrid sources are not, the two will fall out of sync with each other; the TextGrid would show the old/legacy notation while the XML shows the new one, for the same recording. Not yet decided; flagging as a real tradeoff (consistency across the whole pipeline vs. the cost/risk of touching archival TextGrid sources) rather than assuming either direction.

- **[r] vs. [ɾ] not currently distinguished (added 2026-09-10)**: the trill and the flap have not been distinguished in transcription so far, due to the low number of observed flap cases — distinguishing them was judged not worth the added complexity at that frequency. However, a more serious concern than under-distinguishing [r]/[ɾ] themselves: [r] may end up mistakenly transcribed by the ASR as [d] instead, which would be a substantially worse error than conflating the two rhotics with each other. Planned action: check the next training run's output for a disproportionate rate of /r/–/d/ confusion specifically, to determine whether this needs to be addressed (e.g. by beginning to distinguish [r]/[ɾ], or some other fix) before it compounds further.

- **Inconsistent voicing-gradient notation between /k/ and /t/ (added 2026-09-10)**: in pre-vocalic/intervocalic context (especially in clitics, e.g. "ka", "ko"), voiceless velar stop /k/ varies in voicing and tenseness, and this variation IS currently captured with a three-way notation: [k] ~ [k̬] ~ [ɣ] (voiceless, partially voiced, fully lenited to a fricative). /t/ undergoes an analogous voicing gradient in the same kind of context, and is always articulated as dental regardless of voicing, but this is currently captured with only two endpoints: [t̪] ~ [d] — no intermediate partially-voiced stage is marked (unlike [k̬] for /k/), and the fully-voiced endpoint also drops the dental place marker entirely (plain [d], not [d̪]), even though the dental place of articulation does not actually change. A parallel, consistent notation for /t/ would be [t̪] ~ [t̬̪] ~ [d̪] (preserving dental place throughout, with a partially-voiced dental stage matching how [k̬] is already handled). Not yet decided whether to adopt this; flagged for consideration alongside the other open items here.

- **Trimming non-lexical onset/offset transition sounds (added 2026-09-10)**: current practice trims segment start/end times to exclude non-lexical transitional sounds immediately before or after a word (e.g. "[nnn ɲààà]" trimmed to just "[ɲààà]"). This is in tension with the eventual goal of transcribing unsegmented input directly. Resolution: this tension is not actually about whether to include noise generally -- it is deferred to the planned VAD (voice activity detection) pre-processing stage (Idea 1 in the original project TODO), which is meant to handle segmentation of raw audio BEFORE WhIPA ever sees it, rather than expecting WhIPA itself to learn word-boundary-finding in raw continuous audio. The real open question this raises is narrower than "keep all noise or none": once VAD is implemented, its output will likely have some realistic boundary imprecision (a little transitional noise at segment edges), and it may be worth training WhIPA to be robust to that small amount of boundary slop specifically -- WITHOUT notating the noise itself in the transcription target (the target stays the clean word; only the audio input would include a bit of edge noise). This is a narrower, more bounded technique than transcribing noise generally, and does not require inventing notation for non-lexical sounds. Not yet implemented; current practice (precise trimming) is being kept for now given the small dataset size, where clean, precisely-bounded training signal is judged more valuable than this robustness technique at this stage. Revisit once the VAD pipeline exists and the actual scale of its boundary imprecision can be measured, rather than guessing at the right amount of noise-tolerance now.

## 7. Historical pipeline notes (for future reference, not active conventions)

The corpus's annotation/export pipeline evolved through several distinct stages, which explains why raw exports and intermediate scripts don't all match:

1. **Original phone-tier TextGrid structure**: `Tokens`, `Orth`, `Gloss`, `Vowels`, `Tones`, `Consonants`, `Gld-Nas-Lat` — four separate phone-type tiers, allowing each phone to be individually annotated. Some raw `.txt` exports from this stage are **3-column** (`tmin`/`text`/`tmax`, no explicit tier-name column) — meaning tier identity for these files can only be reconstructed via content/position heuristics, not read directly.
2. **`tabSeparated2TEI.xsl` / `parse-textgrid-output-*.xslt`**: consume the above tier structure directly (when a tier-labeled 4-column export is available), wrapping each phone in `<c>` and marking tones via `function="tone"` attribute. Only whole-word-level timing is captured; individual phones/tones inside a word have no timing of their own.
3. **`tabSeparated2TEI-PraatV2.xsl`**: expects an already-different, already-simplified tier set (`Tokens`, `Orth`, `Pron`, `Esp`, `Eng`) — meaning by this stage, the four phone-type tiers had already been merged into one combined `Pron` string per word. No script producing this merge has been found; it's presumed to have been done via direct manual annotation (typing the combined pronunciation into one tier at annotation time) rather than a post-hoc merge step.
4. **Current gold corpus** (the actual TEI files in `transcriptions-xml/`): bare phone text with only tone marks wrapped in `<m>` — this doesn't exactly match the output of any of the above scripts either, suggesting a further hand-refinement pass (likely manual/regex-based cleanup) that isn't captured in any surviving script.
5. **Current SIL/Lección pipeline** (`praat2tei-sil.xsl`): the actively-maintained script, processing sentence-level multi-word utterances with tiers `Tokens`/`Mixtec`/`IPA`/`English`/`Spanish`. Produces flat `<w synch="#Tstart #Tend">` elements — no `<c>`/`<m>` nesting at all. This is the convention the phone-alignment regeneration scripts (`regenerate_word_alignment.py`) were designed to match, for consistency going forward.

**Practical implication**: don't try to fully reverse-engineer stage 3→4 above — it's not needed for current work. For recovering timing from legacy raw exports (stage 1's `.txt` files), `regenerate_word_alignment.py` reconstructs word-level (not phone-level) timing directly from the raw multi-tier export without needing tier identity, which is sufficient for the current fine-tuning goal of phone-only (tone-excluded) ASR training.

---

## 8. Scripts referenced in this document

| Script | Purpose |
|---|---|
| `extract_finetune_data.py` | Extracts tokens from `transcriptions-xml/` (ADJ_*-style single-word corpus), strips tone marks (`strip_tones()`), outputs review CSV |
| `extract_finetune_data_sentences.py` | Same, for multi-word-per-utterance files (Lección/`_Los_Sonidos_del_mixteco` style), reusing `strip_tones()` |
| `regenerate_word_alignment.py` | Recovers word-level timing + concatenated IPA from legacy 3-column raw multi-tier `.txt` exports; applies legacy-to-current long-vowel-contour conversion |
| `normalize_encoding.py` | Detects and normalizes `.txt` file encoding (UTF-8/UTF-16 BE/LE, with or without BOM) to clean UTF-8, to work around Praat's inconsistent export encoding behavior |
| `praat2tei-sil-claude.xsl` | Current SIL/Lección TSV-to-TEI pipeline; includes fixes for header-row filtering, orphan pre-Tokens groups, and per-word `@synch` start+end timing |

