"""
Patch the teiHeader/fileDesc section of already-generated Lección TEI files
with the new publication metadata (compiler, editors, recorders, publisher,
license, source notes), without touching anything else in the file (body,
annotationBlocks, timeline, etc.).

Usage:
    python3 patch_header_metadata.py Leccion_01.xml Leccion_02.xml ...

Writes patched files to a separate output directory (never overwrites in
place), so you can review/diff before copying over your working files.
"""

import sys
from pathlib import Path
from lxml import etree

TEI_NS = "http://www.tei-c.org/ns/1.0"
NSMAP = {"tei": TEI_NS}
OUT_DIR = Path("patched_headers")


def qn(tag):
    return f"{{{TEI_NS}}}{tag}"


NEW_RESPSTMTS = [
    {"resp": "Compiler", "names": ["María M. Nieves"]},
    {"resp": "Editor (Mixtec text)", "names": [
        "Juan Miguel Bautista Martínez",
        "Octavio Hernández Velasco",
        "Bernardino Santiago Velasco",
    ]},
    {"resp": "Recording (Spanish content)", "names": ["Víctor Moreno Rojas"]},
    {"resp": "Recording (Mixtec content)", "names": ["Bernardino Santiago Velasco"]},
]


def build_respstmt(resp_text, names):
    respStmt = etree.Element(qn("respStmt"))
    resp = etree.SubElement(respStmt, qn("resp"))
    resp.text = resp_text
    for n in names:
        name_el = etree.SubElement(respStmt, qn("name"))
        name_el.text = n
    return respStmt


def patch_file(path: Path):
    try:
        tree = etree.parse(str(path))
    except Exception:
        parser = etree.XMLParser(recover=True)
        tree = etree.parse(str(path), parser)

    root = tree.getroot()
    titleStmt = root.find(".//tei:titleStmt", NSMAP)
    publicationStmt = root.find(".//tei:publicationStmt", NSMAP)
    notesStmt = root.find(".//tei:notesStmt", NSMAP)

    if titleStmt is None or publicationStmt is None:
        print(f"  SKIP (couldn't find titleStmt/publicationStmt): {path.name}")
        return False

    # --- Add new respStmt blocks after the existing ones in titleStmt ---
    # Only add if not already present (avoid duplicating on repeated runs)
    existing_resps = {r.text for r in titleStmt.findall(".//tei:resp", NSMAP)}
    for spec in NEW_RESPSTMTS:
        if spec["resp"] not in existing_resps:
            titleStmt.append(build_respstmt(spec["resp"], spec["names"]))

    # --- Replace publicationStmt content ---
    for child in list(publicationStmt):
        publicationStmt.remove(child)
    publisher = etree.SubElement(publicationStmt, qn("publisher"))
    publisher.text = "Instituto Lingüístico de Verano, A.C."
    pubPlace = etree.SubElement(publicationStmt, qn("pubPlace"))
    pubPlace.text = "Ciudad de México"
    date = etree.SubElement(publicationStmt, qn("date"))
    date.text = "2018"
    availability = etree.SubElement(publicationStmt, qn("availability"))
    avail_p = etree.SubElement(availability, qn("p"))
    avail_p.text = (
        "\u00a9 2018 Instituto Ling\u00fc\u00edstico de Verano, A.C. "
        "Licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 3.0 "
        "(CC BY-NC-ND 3.0)."
    )

    # --- Replace notesStmt content ---
    if notesStmt is not None:
        for child in list(notesStmt):
            notesStmt.remove(child)
        note1 = etree.SubElement(notesStmt, qn("note"))
        note1.text = (
            "Content originally published as: Aprendamos el idioma mixteco "
            "(Na kutu\u02bcva ko sa\u02bcan savi), Libro 1, disco 1. "
            "Catalog reference: mix 18-027 .25C. Primera edici\u00f3n."
        )
        note2 = etree.SubElement(notesStmt, qn("note"))
        note2.text = (
            "Content reviewed and recorded by Mixtec speakers originally from "
            "the municipality of San Juan Mixtepec, Juxtlahuaca district."
        )
        note3 = etree.SubElement(notesStmt, qn("note"))
        note3.text = "Originally retrieved from www.sil.org/mexico/mixteca/mixtepec (no longer active as of 2026)."

    OUT_DIR.mkdir(exist_ok=True)
    tree.write(str(OUT_DIR / path.name), encoding="UTF-8", xml_declaration=True, pretty_print=True)
    return True


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 patch_header_metadata.py file1.xml [file2.xml ...]")
        sys.exit(1)

    patched = 0
    for arg in sys.argv[1:]:
        path = Path(arg)
        if not path.exists():
            print(f"SKIP (not found): {path}")
            continue
        if patch_file(path):
            patched += 1
            print(f"Patched: {path.name}")

    print(f"\n{patched} file(s) patched. Output in: {OUT_DIR}/")


if __name__ == "__main__":
    main()
