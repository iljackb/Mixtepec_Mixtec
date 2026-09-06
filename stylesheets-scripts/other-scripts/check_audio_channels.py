"""
Scan a directory of audio files and report channel count + sample rate for each.
Flags stereo (or >1 channel) files so you know which ones need conversion to mono
before running through WhIPA/LoWhIPA.

Usage:
    python3 check_audio_channels.py /path/to/audio_folder [--csv output.csv]

Requires: pip install soundfile --break-system-packages
"""

import argparse
import csv
import sys
from pathlib import Path

import soundfile as sf

AUDIO_EXTS = {".wav", ".mp3", ".flac", ".ogg", ".m4a", ".aiff", ".aif"}


def scan_folder(folder: Path):
    results = []
    files = sorted(p for p in folder.rglob("*") if p.suffix.lower() in AUDIO_EXTS)
    if not files:
        print(f"No audio files found under {folder}", file=sys.stderr)
        return results

    for f in files:
        try:
            info = sf.info(str(f))
            results.append({
                "file": str(f),
                "channels": info.channels,
                "samplerate": info.samplerate,
                "duration_sec": round(info.frames / info.samplerate, 2),
                "format": info.format,
            })
        except Exception as e:
            results.append({
                "file": str(f),
                "channels": "ERROR",
                "samplerate": "ERROR",
                "duration_sec": "ERROR",
                "format": str(e),
            })
    return results


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("folder", type=str, help="Directory to scan recursively")
    ap.add_argument("--csv", type=str, default=None, help="Optional path to write results as CSV")
    args = ap.parse_args()

    folder = Path(args.folder)
    if not folder.is_dir():
        print(f"Not a directory: {folder}", file=sys.stderr)
        sys.exit(1)

    results = scan_folder(folder)

    mono = [r for r in results if r["channels"] == 1]
    stereo_or_more = [r for r in results if isinstance(r["channels"], int) and r["channels"] > 1]
    errors = [r for r in results if r["channels"] == "ERROR"]

    print(f"\nScanned {len(results)} file(s) under {folder}\n")
    print(f"  Mono (1 channel):      {len(mono)}")
    print(f"  Stereo/multi-channel:  {len(stereo_or_more)}")
    print(f"  Errors (unreadable):   {len(errors)}\n")

    if stereo_or_more:
        print("Files needing conversion to mono:")
        for r in stereo_or_more:
            print(f"  [{r['channels']}ch, {r['samplerate']}Hz] {r['file']}")
        print()

    if errors:
        print("Files that couldn't be read:")
        for r in errors:
            print(f"  {r['file']}  ({r['format']})")
        print()

    if args.csv:
        with open(args.csv, "w", newline="") as fh:
            writer = csv.DictWriter(fh, fieldnames=["file", "channels", "samplerate", "duration_sec", "format"])
            writer.writeheader()
            writer.writerows(results)
        print(f"Full results written to {args.csv}")


if __name__ == "__main__":
    main()
