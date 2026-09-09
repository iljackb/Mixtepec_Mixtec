"""
Extract individual word-level tokens from multi-word-per-utterance TEI files
(Leccion_01-05.xml, _Los_Sonidos_del_mixteco.xml -- the sentence-elicitation
corpus, structurally different from the single-word ADJ_*.xml corpus already
handled by extract_finetune_data.py).

Requires the updated praat2tei-sil.xsl, which writes BOTH a start and end
timepoint reference into each <w>'s @synch attribute (e.g.
synch="#T14.90 #T15.25"), giving each individual word its own real audio
boundary rather than approximating end-time as "wherever the next word starts".

Reuses strip_tones() from extract_finetune_data.py so tone-stripping stays
consistent across both corpora.

Output CSV columns match finetune_review.csv's schema, so both can be
concatenated into one combined training manifest.
"""

import csv
import re
from pathlib import Path

from lxml import etree

# Reuse the already-verified tone-stripping logic rather than duplicating it
from extract_finetune_data import strip_tones
from normalize_ipa import normalize_for_training

TEI_NS = {"tei": "http://www.tei-c.org/ns/1.0"}

FILES = [
    "Leccion_01.xml",
    "Leccion_02.xml",
    "Leccion_03.xml",
    "Leccion_05.xml",
    "_Los_Sonidos_del_mixteco.xml",
]

XML_DIR = Path(".")  # adjust as needed
OUT_CSV = Path("finetune_review_sentences.csv")

SYNCH_TIME_RE = re.compile(r"#T([\d.]+)")


def get_word_map(seg):
    """
    Map each <w>'s start-time key -> (text, start, end), reading both
    timepoints from @synch (format: "#Tstart #Tend"). Falls back to
    start-only (no end) if a <w> only has one synch ref, for files generated
    before the XSLT fix -- flagged via end=None so callers can skip/handle.
    """
    result = {}
    if seg is None:
        return result
    for w in seg.findall("tei:w", TEI_NS):
        text = "".join(w.itertext()).strip()
        if not text:
            continue
        synch = w.get("synch", "")
        times = SYNCH_TIME_RE.findall(synch)
        if not times:
            continue
        start = times[0]
        end = times[1] if len(times) > 1 else None
        result[start] = (text, start, end)
    return result


def get_wav_media_ref(tree, xml_filename: str = "") -> str:
    media = tree.find(".//tei:media", TEI_NS)
    if media is not None:
        url = media.get("url", "")
        return url.split(":", 1)[1] if ":" in url else url
    if xml_filename:
        return Path(xml_filename).stem + ".wav"
    return ""


def main():
    rows = []
    skipped_no_end = 0

    for fname in FILES:
        path = XML_DIR / fname
        if not path.exists():
            print(f"SKIP (not found): {fname}")
            continue

        try:
            tree = etree.parse(str(path))
        except Exception:
            parser = etree.XMLParser(recover=True)
            tree = etree.parse(str(path), parser)

        wav_ref = get_wav_media_ref(tree, fname)

        for u in tree.findall(".//tei:u", TEI_NS):
            mix_seg = None
            ipa_seg = None
            for seg in u.findall("tei:seg", TEI_NS):
                lang = seg.get("{http://www.w3.org/XML/1998/namespace}lang")
                notation = seg.get("notation")
                if lang == "mix" and notation != "ipa":
                    mix_seg = seg
                elif notation == "ipa":
                    ipa_seg = seg

            orth_words = get_word_map(mix_seg)
            ipa_words = get_word_map(ipa_seg)

            for start_key in set(orth_words) & set(ipa_words):
                orth_text, o_start, o_end = orth_words[start_key]
                ipa_text, i_start, i_end = ipa_words[start_key]

                # Prefer the IPA row's own end (should match orth's, but IPA is
                # the tier we ultimately care about matching to audio)
                end = i_end or o_end
                if end is None:
                    skipped_no_end += 1
                    continue

                ipa_notone = strip_tones(ipa_text)
                ipa_full_normalized = normalize_for_training(ipa_text)

                rows.append({
                    "xml_file": fname,
                    "wav_file": wav_ref,
                    "token_n": "",  # not applicable at word level; utterance context lost intentionally here
                    "start": start_key,
                    "end": end,
                    "orth": orth_text,
                    "ipa_gold": ipa_text,
                    "ipa_notone": ipa_notone,
                    "ipa_full_normalized": ipa_full_normalized,
                    "changed": "yes" if ipa_text != ipa_notone else "no",
                })

    with open(OUT_CSV, "w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=[
            "xml_file", "wav_file", "token_n", "start", "end",
            "orth", "ipa_gold", "ipa_notone", "ipa_full_normalized", "changed"
        ])
        writer.writeheader()
        writer.writerows(rows)

    print(f"Wrote {len(rows)} word-level tokens to {OUT_CSV}")
    print(f"Skipped (no end-time available -- file predates synch fix): {skipped_no_end}")


if __name__ == "__main__":
    main()
