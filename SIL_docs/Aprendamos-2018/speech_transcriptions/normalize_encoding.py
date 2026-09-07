"""
Normalize a Praat tab-separated export to UTF-8, regardless of what encoding
Praat actually saved it in (observed: UTF-8, UTF-16 BE, and UTF-16 LE all occur
unpredictably from the same "Save as tab-separated file..." command).

Usage:
    python3 normalize_encoding.py path/to/Leccion_01.txt
    python3 normalize_encoding.py path/to/Leccion_01.txt path/to/Leccion_02.txt ...

Overwrites each file in place with a clean UTF-8 (no BOM) version, after
detecting its actual encoding from its byte signature. Safe to run on files
that are already UTF-8 -- they're left unchanged (re-written identically).
"""

import sys
from pathlib import Path


def detect_and_read(path: Path) -> str:
    raw = path.read_bytes()

    if raw.startswith(b"\xff\xfe") or raw.startswith(b"\xfe\xff"):
        return raw.decode("utf-16")  # generic "utf-16" auto-detects AND strips the BOM
    elif raw.startswith(b"\xef\xbb\xbf"):
        return raw.decode("utf-8-sig")  # UTF-8 with BOM
    else:
        # No BOM -- assume UTF-8 (Praat's other common default for this export)
        return raw.decode("utf-8")


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 normalize_encoding.py file1.txt [file2.txt ...]")
        sys.exit(1)

    for arg in sys.argv[1:]:
        path = Path(arg)
        if not path.exists():
            print(f"SKIP (not found): {path}")
            continue

        try:
            text = detect_and_read(path)
        except UnicodeDecodeError as e:
            print(f"FAILED to decode {path.name}: {e}")
            continue

        path.write_text(text, encoding="utf-8")
        print(f"Normalized to UTF-8: {path.name}")


if __name__ == "__main__":
    main()
