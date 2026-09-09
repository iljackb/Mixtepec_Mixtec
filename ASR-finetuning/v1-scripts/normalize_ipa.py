"""
Consolidated IPA normalization for WhIPA fine-tuning training targets.

Combines all four established normalization rules into one module, so both
extraction scripts (extract_finetune_data.py, extract_finetune_data_sentences.py)
apply identical, consistent normalization. Operates ONLY on derived training-
target strings -- never touches archival TEI source files.

Rules implemented (see IPA_Transcription_Guidelines.md for full rationale):
  1. Tone-stripping (strip_tones) -- already existed, included here for completeness
  2. Affricate tie-bar standardization -- tʃ/ʧ -> t͡ʃ, dʒ/ʤ -> d͡ʒ, ts -> t͡s
     (confirmed via corpus scan: 84x tʃ, 32x dʒ, 91x ts, 6x ʧ, 17x ʤ; 0 tɕ/dʑ/etc found)
  3. General vowel-length normalization -- Vː -> VV (doubles the vowel+diacritic
     cluster, e.g. nasalized ɛ̃ː -> ɛ̃ɛ̃, not just the bare vowel)
  4. Creakiness heuristic -- strips creaky-voice diacritic (U+0330) when adjacent
     to ʔ (redundant, non-phonological per VʔV coarticulation); keeps it when NOT
     adjacent to ʔ (informative -- likely marking a reduced/deleted glottal stop)
"""

import re
import unicodedata

# ---------------------------------------------------------------------------
# 1. Tone-stripping (unchanged from extract_finetune_data.py)
# ---------------------------------------------------------------------------
STANDALONE_TONE_CHARS = set(range(0x02E5, 0x02EA)) | {0x2197, 0x2198, 0x2219, 0xA71C}
TONE_COMBINING_MARKS = {0x0301, 0x0300, 0x0302, 0x0304, 0x030C, 0x1DC7, 0x1DC5}


def strip_tones(ipa: str) -> str:
    no_standalone = "".join(ch for ch in ipa if ord(ch) not in STANDALONE_TONE_CHARS)
    decomposed = unicodedata.normalize("NFD", no_standalone)
    cleaned = "".join(ch for ch in decomposed if ord(ch) not in TONE_COMBINING_MARKS)
    return unicodedata.normalize("NFC", cleaned)


# ---------------------------------------------------------------------------
# 2. Affricate normalization -- ligatures only, no tie-bar insertion
# ---------------------------------------------------------------------------
# Decision (2026-09-09): dropped tie-bar standardization. The plain sequences
# [tʃ], [dʒ] etc. are unambiguous enough for this project's actual use case
# (transcriptions for language documentation/community use, not a phonetics
# publication) -- not worth the added visual complexity or the tie-bar
# inconsistency the model itself showed in early fine-tuning output.
# Ligatures (ʧ, ʤ, etc.) are still normalized down to plain two-character
# sequences, since those are deprecated in the current IPA standard and
# inconsistent across fonts/rendering -- just without adding a tie bar.
LIGATURE_MAP = {
    "ʧ": "tʃ",
    "ʤ": "dʒ",
    "ʦ": "ts",
    "ʣ": "dz",
}


def standardize_affricates(ipa: str) -> str:
    for ligature, replacement in LIGATURE_MAP.items():
        ipa = ipa.replace(ligature, replacement)
    return ipa


# ---------------------------------------------------------------------------
# 3. General vowel-length normalization: Vː -> VV
# ---------------------------------------------------------------------------
VOWELS = "aeiouɛɔɨɯ"
LENGTH_MARK = "\u02D0"  # ː

# Matches a base vowel plus any combining diacritics (e.g. nasalization tilde),
# followed by the length mark -- so nasalized/other-marked long vowels double
# correctly (ɛ̃ː -> ɛ̃ɛ̃), not just the bare vowel.
LONG_VOWEL_RE = re.compile(f"([{VOWELS}][\u0300-\u036F]*)\u02D0")


def normalize_vowel_length(ipa: str) -> str:
    return LONG_VOWEL_RE.sub(lambda m: m.group(1) * 2, ipa)


# ---------------------------------------------------------------------------
# 4. Creakiness heuristic
# ---------------------------------------------------------------------------
CREAKY_MARK = "\u0330"  # combining tilde below


def normalize_creakiness(ipa: str) -> str:
    """
    Strip creaky-voice diacritic when adjacent (within 1 char) to ʔ (redundant,
    since the glottal stop is already fully articulated/marked). Keep it
    otherwise (likely marking a reduced/deleted glottal stop -- informative).
    """
    decomposed = unicodedata.normalize("NFD", ipa)
    chars = list(decomposed)
    result = []
    i = 0
    while i < len(chars):
        ch = chars[i]
        if ch == CREAKY_MARK:
            # look at immediate neighbors (1 char before/after in the decomposed stream)
            prev_ch = result[-1] if result else ""
            next_ch = chars[i + 1] if i + 1 < len(chars) else ""
            if prev_ch == "ʔ" or next_ch == "ʔ":
                i += 1
                continue  # drop it -- redundant
            else:
                result.append(ch)  # keep it -- informative
        else:
            result.append(ch)
        i += 1
    return unicodedata.normalize("NFC", "".join(result))


# ---------------------------------------------------------------------------
# Combined pipeline
# ---------------------------------------------------------------------------
def normalize_for_training(ipa: str) -> str:
    """Apply all four rules in sequence to produce a final ASR training target."""
    ipa = strip_tones(ipa)
    ipa = standardize_affricates(ipa)
    ipa = normalize_vowel_length(ipa)
    ipa = normalize_creakiness(ipa)
    return ipa
