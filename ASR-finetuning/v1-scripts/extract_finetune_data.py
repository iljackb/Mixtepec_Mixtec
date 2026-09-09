"""
Walk transcriptions-xml, extract every <u> token with both orth+ipa,
strip tone/suprasegmental marks from the IPA to produce a training-target
column, and write everything to a CSV for manual review before fine-tuning.

Excludes files matching the held-out test set (already used for zero-shot
baseline comparison) so that set stays clean for before/after evaluation.

Tone/suprasegmental characters stripped:
  - Chao tone letters: ˥ ˦ ˧ ˨ ˩ (U+02E5-U+02E9)
  - Contour arrows: ↗ ↘ (U+2197, U+2198)
  - Indeterminate-tone marker: ∙ (U+2219, used when F0 quality was too poor
    to judge tone)

NOT stripped (these are segmental, not tonal):
  - Vowel length ː
  - Nasalization tilde ̃
  - Glottal stop ʔ
  - Any other IPA segmental symbols/diacritics
"""

import csv
import re
import unicodedata
from pathlib import Path

from lxml import etree

TEI_NS = {"tei": "http://www.tei-c.org/ns/1.0"}
XML_DIR = Path("transcriptions-xml")
OUT_CSV = Path("finetune_review.csv")

# Basenames already used as the held-out test set -- excluded from training data
HELD_OUT = {
    "ADJ_beautiful_anim_01_JS",
    "ADJ_beautiful_inan_01_JS",
    "ADJ_big_01_02_03_JS",
    "ADJ_dangerous_01_JS",
    "ADJ_dangerous_02_JS",
    "ADJ_difficult_01_02_spkrTS",
    "ADJ_fat_01_02_spkrTS",
    "ADJ_heavy_01_02_03_JS",
    "ADJ_long_DIST_01_02_03_JS",
    "ADJ_long_SHAPE_01_02_03_TS",
}

# Convention A: standalone tone symbols (used in original IPA-transcribed files)
#   Chao tone letters (˥˦˧˨˩), contour arrows (↗↘), indeterminate-tone dot (∙),
#   downstep modifier (ꜜ)
STANDALONE_TONE_CHARS = set(range(0x02E5, 0x02EA)) | {0x2197, 0x2198, 0x2219, 0xA71C}

# Convention B: precomposed vowel+accent tone marking (used in newer batches)
#   acute (high), grave (low), circumflex (falling), macron (mid), caron (rising
#   contour), acute-macron / grave-macron (additional contour tones) -- as
#   COMBINING marks after NFD decomposition. E.g. ṹ decomposes to u + combining-
#   tilde (nasalization, kept) + combining-acute (tone, stripped); kã́ʔũ̌ decomposes
#   similarly, keeping both nasal tildes while stripping the acute/caron on top.
# Use the full consolidated normalization pipeline (tone-stripping + affricate
# tie-bars + vowel-length + creakiness), not just tone-stripping alone.
from normalize_ipa import normalize_for_training


def strip_tones(ipa: str) -> str:
    # Handle Convention A first (standalone characters, no decomposition needed)
    no_standalone = "".join(ch for ch in ipa if ord(ch) not in STANDALONE_TONE_CHARS)

    # Handle Convention B: decompose to separate stacked diacritics (e.g. tilde+acute),
    # strip only the tone-marking combining chars, then recompose.
    decomposed = unicodedata.normalize("NFD", no_standalone)
    TONE_COMBINING_MARKS = {0x0301, 0x0300, 0x0302, 0x0304, 0x030C, 0x1DC7, 0x1DC5}
    cleaned = "".join(ch for ch in decomposed if ord(ch) not in TONE_COMBINING_MARKS)
    return unicodedata.normalize("NFC", cleaned)


def get_wav_media_ref(tree, xml_filename: str = "") -> str:
    """Pull the referenced .wav filename from sourceDesc/media, if present.
    Falls back to deriving it from the XML's own filename (basename + .wav)
    when no <media> element exists -- confirmed reliable for files following
    the standard naming convention (e.g. ADJ_wide_01_02_03_JS.xml -> .wav)."""
    media = tree.find(".//tei:media", TEI_NS)
    if media is not None:
        url = media.get("url", "")
        # url looks like soundfiles-gen:FILENAME.wav -- strip the prefix
        if ":" in url:
            return url.split(":", 1)[1]
        return url
    if xml_filename:
        return Path(xml_filename).stem + ".wav"
    return ""


def main():
    files = sorted(f for f in XML_DIR.glob("*.xml") if not f.name.endswith("-metadata.xml"))

    rows = []
    skipped_held_out = 0
    skipped_no_tokens = 0
    tone_free_tokens = 0

    for f in files:
        basename = f.stem
        if basename in HELD_OUT:
            skipped_held_out += 1
            continue

        try:
            tree = etree.parse(str(f))
        except Exception:
            parser = etree.XMLParser(recover=True)
            try:
                tree = etree.parse(str(f), parser)
            except Exception as e:
                print(f"SKIP (unparseable): {f.name}: {e}")
                continue

        wav_ref = get_wav_media_ref(tree, f.name)
        us = tree.findall(".//tei:u", TEI_NS)

        file_had_token = False
        for u in us:
            start = u.get("start", "")
            end = u.get("end", "")
            n = u.get("n", "")

            orth_seg = u.find(".//tei:seg[@notation='orth']", TEI_NS)
            ipa_seg = u.find(".//tei:seg[@notation='ipa']", TEI_NS)

            if orth_seg is None or ipa_seg is None:
                continue

            orth_w = orth_seg.find(".//tei:w", TEI_NS)
            ipa_w = ipa_seg.find(".//tei:w", TEI_NS)
            if orth_w is None or ipa_w is None:
                continue

            orth_text = "".join(orth_w.itertext()).strip()
            ipa_text = "".join(ipa_w.itertext()).strip()
            ipa_notone = strip_tones(ipa_text)
            ipa_full_normalized = normalize_for_training(ipa_text)

            if ipa_text == ipa_notone:
                tone_free_tokens += 1  # nothing was stripped -- flag for review too, might already lack tone marks

            rows.append({
                "xml_file": f.name,
                "wav_file": wav_ref,
                "token_n": n,
                "start": start,
                "end": end,
                "orth": orth_text,
                "ipa_gold": ipa_text,
                "ipa_notone": ipa_notone,
                "ipa_full_normalized": ipa_full_normalized,
                "changed": "yes" if ipa_text != ipa_notone else "no",
            })
            file_had_token = True

        if not file_had_token:
            skipped_no_tokens += 1

    with open(OUT_CSV, "w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=[
            "xml_file", "wav_file", "token_n", "start", "end",
            "orth", "ipa_gold", "ipa_notone", "ipa_full_normalized", "changed"
        ])
        writer.writeheader()
        writer.writerows(rows)

    print(f"Wrote {len(rows)} tokens to {OUT_CSV}")
    print(f"  Held-out test files skipped: {skipped_held_out}")
    print(f"  Files with no usable tokens: {skipped_no_tokens}")
    print(f"  Tokens where stripping changed nothing (already tone-free or unmarked): {tone_free_tokens}")
    print(f"\nReview {OUT_CSV} before using it for fine-tuning -- check the 'ipa_notone' column,")
    print(f"especially any row where 'changed' is 'no' but you expected a tone mark to be present.")


if __name__ == "__main__":
    main()
