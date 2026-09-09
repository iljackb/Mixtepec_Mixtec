"""
Check the training manifest against actual audio files on disk: for each row's
wav_file, search one or more candidate base directories (searched recursively)
for a matching filename, and report what's found vs. missing.

Usage:
    python3 verify_audio_paths.py finetune_manifest_combined.csv \
        --search-dir "/Users/jackbowers/Archived - Box Sync/Language_Data/Mixtepec_Mixtec/media/speech-mix" \
        --search-dir "/Users/jackbowers/Archived - Box Sync/Language_Data/Mixtepec_Mixtec/SIL_docs/Aprendamos-2018/Archivos_de_audio___Mixtepec"

Add as many --search-dir flags as needed. Searches recursively (subfolders included).
"""

import argparse
import csv
from pathlib import Path


def build_wav_index(search_dirs):
    """Map filename (lowercase, no path) -> full path, across all search dirs."""
    index = {}
    for d in search_dirs:
        d = Path(d)
        if not d.exists():
            print(f"WARNING: search dir not found, skipping: {d}")
            continue
        for wav_path in d.rglob("*.wav"):
            index[wav_path.name.lower()] = wav_path
    return index


def name_variants(name: str):
    """Generate plausible filename variants to check when an exact match fails
    (e.g. underscore vs space separators are inconsistently used across
    different recording sessions/devices)."""
    variants = {name}
    variants.add(name.replace("_", " "))
    variants.add(name.replace(" ", "_"))
    return variants


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("manifest_csv", type=str)
    ap.add_argument("--search-dir", action="append", required=True, dest="search_dirs",
                     help="Directory to search recursively for .wav files (repeatable)")
    args = ap.parse_args()

    print("Indexing .wav files in search directories (this may take a moment)...")
    wav_index = build_wav_index(args.search_dirs)
    print(f"Found {len(wav_index)} unique .wav filenames across all search directories.\n")

    found = []
    missing = []
    blank = []

    with open(args.manifest_csv, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            wav_file = row.get("wav_file", "").strip()
            xml_file = row.get("xml_file", "")

            if not wav_file:
                blank.append(xml_file)
                continue

            wav_name = Path(wav_file).name.lower()

            match = None
            for variant in name_variants(wav_name):
                if variant in wav_index:
                    match = wav_index[variant]
                    break

            if match:
                found.append((xml_file, wav_file, str(match)))
            else:
                missing.append((xml_file, wav_file))

    total = len(found) + len(missing) + len(blank)
    print(f"Total manifest rows: {total}")
    print(f"  Found:              {len(found)}")
    print(f"  Missing:            {len(missing)}")
    print(f"  Blank wav_file:     {len(blank)}  (e.g. Leccion_* rows -- filename must be derived separately)")
    print()

    if missing:
        print("MISSING (expected wav_file not found in any search dir):")
        seen = set()
        for xml_file, wav_file in missing:
            if wav_file not in seen:
                print(f"  {wav_file}  (referenced by {xml_file})")
                seen.add(wav_file)
        print()

    if blank:
        blank_files = sorted(set(blank))
        print(f"BLANK wav_file, unique source xml files ({len(blank_files)}):")
        for xf in blank_files:
            print(f"  {xf}")
        print("  (For these -- e.g. Leccion_01.xml -- the expected audio is likely Leccion_01.wav,")
        print("   derivable directly from the xml filename rather than a <media> reference.)")


if __name__ == "__main__":
    main()
