"""
Patch transcriptions-xml/*.xml: for every <w> inside a multi-word seg
(notation='orth' or notation='ipa'), add an end-time reference to its
@synch attribute, using the next <w>'s own start time as the approximation
(or the parent <u>'s own @end, for the last word in that seg).

This is an approximation (assumes no silence/gap between annotated words),
not a measured boundary -- acceptable per project decision, given
per-phone-tier raw data isn't readily re-derivable for this corpus.

Writes patched files to a separate output directory (never overwrites
the working copy in place), so the result can be reviewed/diffed before
being copied over the originals.
"""

from pathlib import Path
from lxml import etree

TEI_NS = "http://www.tei-c.org/ns/1.0"
NSMAP = {"tei": TEI_NS}

SRC_DIR = Path("transcriptions-xml")
OUT_DIR = Path("transcriptions-xml-patched")


def qn(tag):
    return f"{{{TEI_NS}}}{tag}"


def get_when_interval(tree, when_id: str):
    """Resolve a #Txxx synch reference to its actual timeline interval value."""
    when_id = when_id.lstrip("#")
    when = tree.find(f".//tei:when[@{{http://www.w3.org/XML/1998/namespace}}id='{when_id}']", NSMAP)
    return when.get("interval") if when is not None else None


def find_or_create_when(tree, timeline, interval_value: str):
    """Find an existing <when> with this interval, or create a new one if needed."""
    for when in timeline.findall("tei:when", NSMAP):
        if when.get("interval") == interval_value:
            return when.get("{http://www.w3.org/XML/1998/namespace}id")

    # No existing timepoint for this value -- create one
    existing_ids = [w.get("{http://www.w3.org/XML/1998/namespace}id") for w in timeline.findall("tei:when", NSMAP)]
    n = 1
    while f"T{n}" in existing_ids:
        n += 1
    new_id = f"T{n}"
    new_when = etree.SubElement(timeline, qn("when"))
    new_when.set("{http://www.w3.org/XML/1998/namespace}id", new_id)
    new_when.set("interval", interval_value)
    return new_id


def patch_file(path: Path):
    try:
        tree = etree.parse(str(path))
    except Exception:
        parser = etree.XMLParser(recover=True)
        tree = etree.parse(str(path), parser)

    root = tree.getroot()
    timeline = root.find(".//tei:timeline", NSMAP)
    if timeline is None:
        return False  # nothing to do

    modified = False

    for u in root.findall(".//tei:u", NSMAP):
        u_end = u.get("end")

        for seg in u.findall("tei:seg", NSMAP):
            ws = seg.findall("tei:w", NSMAP)
            if len(ws) < 2:
                continue  # single-word seg -- no ambiguity, nothing to patch

            for i, w in enumerate(ws):
                synch = w.get("synch", "").strip()
                if not synch:
                    continue  # no synch at all -- leave unmodified
                if " " in synch:
                    continue  # already has an end reference -- skip

                if i < len(ws) - 1:
                    next_synch_raw = ws[i + 1].get("synch", "").split()
                    if not next_synch_raw:
                        continue  # next <w> has no synch at all -- leave unmodified
                    next_synch = next_synch_raw[0]
                    end_interval = get_when_interval(tree, next_synch)
                else:
                    end_interval = u_end

                if end_interval is None:
                    continue  # couldn't resolve -- leave unmodified rather than guess wrong

                end_when_id = find_or_create_when(tree, timeline, end_interval)
                w.set("synch", f"{synch} #{end_when_id}")
                modified = True

    if modified:
        OUT_DIR.mkdir(exist_ok=True)
        tree.write(str(OUT_DIR / path.name), encoding="UTF-8", xml_declaration=True, pretty_print=True)

    return modified


def main():
    files = sorted(f for f in SRC_DIR.glob("*.xml") if not f.name.endswith("-metadata.xml"))
    patched_count = 0

    for f in files:
        if patch_file(f):
            patched_count += 1

    print(f"Scanned {len(files)} files")
    print(f"Patched (had multi-word segs needing an end-time fix): {patched_count}")
    print(f"Output written to: {OUT_DIR}/")


if __name__ == "__main__":
    main()
