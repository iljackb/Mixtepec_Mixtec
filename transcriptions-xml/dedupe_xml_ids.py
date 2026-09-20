"""
Fix "ID d1e### already defined" parse errors by regenerating duplicate
xml:id (and bare id) values WITHIN a single file to be unique.

These duplicates are within one file only -- each file is an independent
XML document, so a duplicate id in file A has nothing to do with any id
used in file B, even if they happen to share the literal string "d1e196".
Only ids repeated inside the SAME file are a problem, and this script only
ever touches one file at a time.

Because other elements reference these ids by `#id` in attributes like
@synch, @target, @from, @to, @corresp, etc. (e.g. synch="#T1 #T7"), a naive
rename would break those references. This script:

  1. Parses the file as raw text (NOT as XML -- if it doesn't parse as XML
     in the first place, that's exactly the problem we're fixing).
  2. Finds every xml:id="..." (and id="...") occurrence via regex, in
     document order.
  3. Whenever it sees an id value it's already seen IN THIS FILE, generates
     a new unique id for that later occurrence (id + "-dup1", "-dup2", ...).
  4. Rewrites every #<old-id> reference elsewhere in the file that was
     pointing at that SPECIFIC duplicate occurrence... except this is
     fundamentally ambiguous: if two elements both had id="d1e196", any
     "#d1e196" reference in the file could have originally meant either one,
     and there's no way to recover which from the file alone.

Given that ambiguity, this script takes the conservative approach: it
renames the SECOND (and later) occurrences of a duplicated id, and leaves
all "#id" references pointing at the ORIGINAL (first) occurrence. This is
almost always correct in practice for this corpus, because inspection of
several sample files showed the duplicates are typically leftover/orphaned
copy-paste artifacts (e.g. a <span> or <m> element duplicated with its
sibling's id still attached) rather than two genuinely-referenced elements
that both need independent incoming links. It prints every rename it makes
so you can review whether references need manual correction afterward.

This is NOT fully automatic-and-forget: always diff the output against the
original and spot check, especially any file where a duplicated id WAS
targeted by a #reference somewhere -- those need a human decision about
which occurrence the reference actually meant.

Usage:
    Single file:
        python3 dedupe_xml_ids.py <input_file> [output_file]
        (writes <input_file>.deduped by default)

    Batch mode -- run over every file matching a glob (e.g. all 32 files
    that failed the classify_tei_structure.py PARSE ERROR check at once),
    writing each as <file>.deduped next to the original and validating with
    lxml afterward:
        python3 dedupe_xml_ids.py --batch "/path/to/transcriptions-xml/*.xml"

    Example:
        python3 dedupe_xml_ids.py S_CMND_go_home_with_Pedro_01_02_03_spkrTS.xml
"""

import sys
import re
import glob
from collections import defaultdict

# Matches xml:id="..." or bare id="..." (single or double quotes)
ID_ATTR_RE = re.compile(r'(\b(?:xml:id|id))=(["\'])([^"\']+)\2')


def find_duplicates(content: str):
    """Return {id_value: [list of match start positions]} for ids seen >1 time."""
    positions = defaultdict(list)
    for m in ID_ATTR_RE.finditer(content):
        positions[m.group(3)].append(m.start())
    return {k: v for k, v in positions.items() if len(v) > 1}


def dedupe(content: str):
    dupes = find_duplicates(content)
    if not dupes:
        return content, []

    renames = []  # (old_id, new_id, occurrence_index)

    # Build a plan: for each duplicated id, occurrence 0 keeps the original
    # id; occurrences 1, 2, ... get "-dup1", "-dup2", etc.
    rename_plan = {}  # (id_value, occurrence_index) -> new_id
    for id_value, starts in dupes.items():
        for occ_idx, start in enumerate(starts):
            if occ_idx == 0:
                continue
            new_id = f"{id_value}-dup{occ_idx}"
            rename_plan[(id_value, occ_idx)] = new_id
            renames.append((id_value, new_id, occ_idx))

    # Walk the file once, tracking how many times we've seen each id so far,
    # and only rewrite the ATTRIBUTE DEFINITION itself (the id="..." token),
    # never any #id reference elsewhere -- those stay pointing at whichever
    # occurrence they originally referenced textually (ambiguous per the
    # docstring above, but left untouched rather than guessed at).
    seen_count = defaultdict(int)

    def replace_match(m):
        attr_name, quote, id_value = m.group(1), m.group(2), m.group(3)
        occ_idx = seen_count[id_value]
        seen_count[id_value] += 1
        if (id_value, occ_idx) in rename_plan:
            new_id = rename_plan[(id_value, occ_idx)]
            return f'{attr_name}={quote}{new_id}{quote}'
        return m.group(0)

    new_content = ID_ATTR_RE.sub(replace_match, content)
    return new_content, renames


def process_one(input_file, output_file):
    with open(input_file, encoding="utf-8") as f:
        content = f.read()

    new_content, renames = dedupe(content)

    if not renames:
        print(f"  {input_file}: no duplicate ids found -- skipped")
        return

    with open(output_file, "w", encoding="utf-8") as f:
        f.write(new_content)

    print(f"  {input_file}: renamed {len(renames)} occurrence(s) -> {output_file}")
    for old_id, new_id, occ_idx in renames:
        print(f"      occurrence #{occ_idx} of '{old_id}' -> '{new_id}'")

    try:
        from lxml import etree
        etree.parse(output_file)
        print(f"      valid XML after fix")
    except Exception as e:
        print(f"      STILL FAILS TO PARSE: {e}  <-- needs a manual look")


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  Single file:  python3 dedupe_xml_ids.py <input_file> [output_file]")
        print('  Batch:        python3 dedupe_xml_ids.py --batch "/path/to/*.xml"')
        sys.exit(1)

    if sys.argv[1] == "--batch":
        if len(sys.argv) < 3:
            print("--batch requires a glob pattern, e.g. --batch \"/path/*.xml\"")
            sys.exit(1)
        pattern = sys.argv[2]
        files = sorted(glob.glob(pattern))
        if not files:
            print(f"No files matched: {pattern}")
            return
        print(f"Processing {len(files)} file(s):")
        for input_file in files:
            output_file = f"{input_file}.deduped"
            process_one(input_file, output_file)
        print("\nReview each .deduped file (diff against the original) before")
        print("replacing it. Any file still failing to parse needs a manual look --")
        print("that means it has a duplicate id/reference pattern this script's")
        print("conservative renaming approach can't resolve automatically.")
        return

    INPUT_FILE_ARG = 1
    OUTPUT_FILE_ARG = 2  # optional -- defaults to "<input_file>.deduped"

    input_file = sys.argv[INPUT_FILE_ARG]
    output_file = sys.argv[OUTPUT_FILE_ARG] if len(sys.argv) > OUTPUT_FILE_ARG else f"{input_file}.deduped"

    process_one(input_file, output_file)
    print("\nIMPORTANT: check whether any '#<old-id>' reference elsewhere in the")
    print("file should actually point at the RENAMED occurrence instead of the")
    print("original -- this script always leaves references pointing at the")
    print("first (original) occurrence, which may not be textually correct.")


if __name__ == "__main__":
    main()
