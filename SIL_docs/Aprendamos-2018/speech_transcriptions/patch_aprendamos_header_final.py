"""
Patch the teiHeader of an Aprendamos Lección TEI/XML file with the finalized
header template (confirmed against Leccion_01.xml, which already carries the
correct, approved header used in Leccion_01-07).

Only the <teiHeader> is replaced. The <text>/<body> content is copied through
completely untouched (byte-for-byte, taken from between the original file's
own <text> and </text> tags), so this is safe to run on files that already
have real utterances -- it only fixes header metadata, nothing else.

This is meant for Leccion_08.xml through Leccion_12.xml (and
_Los_Sonidos_del_mixteco.xml if it needs it too), which currently have only
the stub header:
    <publicationStmt><p>Publication Information</p></publicationStmt>
instead of the full metadata Leccion_01-07 have.

Template fields that change per lesson (confirmed from Leccion_01.xml):
  - <title>...Transcriptions of <ref type="file" subtype="audio">Leccion_NN.wav</ref></title>
  - <ref type="file" subtype="audio">Leccion_NN.mp3</ref>  (source file, in sourceDesc)
  - <ref type="file" subtype="audio">Leccion_NN.wav</ref>  (converted file, in sourceDesc)

Everything else (respStmt names/roles, publicationStmt, seriesStmt catalog
line, profileDesc/creation) is IDENTICAL across lessons per Leccion_01.xml,
and is reproduced verbatim here. If a specific lesson's seriesStmt/catalog
reference actually differs (different disco number, etc.), that needs to be
hand-adjusted -- this script assumes "Libro 1, disco 1" is the source for
all lessons the way Leccion_01.xml states.

NOTE: this script does NOT add xml:id="BSV" to the Speaker/Recording (Mixtec)
respStmt <name> elements. Jack said he's adding those manually across all
files himself -- adding it here too would just mean redoing that pass, so
this intentionally matches Leccion_01.xml's respStmt block exactly as-is
(only <name xml:id="JB"> already has an id, same as the source template).

Usage:
    python3 patch_aprendamos_header_final.py <lesson_number_or_stem> <input_file> [output_file]

    Example:
        python3 patch_aprendamos_header_final.py 08 Leccion_08.xml
        (writes Leccion_08.xml.patched by default; pass an explicit
        output_file to overwrite in place or write elsewhere)
"""

import sys
import re

TEI_NS = "http://www.tei-c.org/ns/1.0"


def build_header(lesson_stem: str) -> str:
    """lesson_stem e.g. 'Leccion_08' -- used to fill in the .mp3/.wav refs."""
    wav_name = f"{lesson_stem}.wav"
    mp3_name = f"{lesson_stem}.mp3"

    return f"""   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title>Aprendamos el idioma mixteco: Transcriptions of <ref type="file" subtype="audio">{wav_name}</ref></title>
            <respStmt>
               <resp>Annotation</resp>
               <resp>Encoding</resp>
               <name xml:id="JB">Jack Bowers</name>
            </respStmt>
            <respStmt>
               <resp>Speaker</resp>
               <name>Bernardino Santiago Velasco</name>
            </respStmt>
         <respStmt>
            <resp>Compiler</resp>
            <name>María M. Nieves</name>
         </respStmt>
            <respStmt>
               <resp>Editor (Mixtec text)</resp>
               <name>Juan Miguel Bautista Martínez</name>
               <name>Octavio Hernández Velasco</name>
               <name>Bernardino Santiago Velasco</name>
            </respStmt><respStmt>
               <resp>Recording (Spanish content)</resp>
               <name>Víctor Moreno Rojas</name>
            </respStmt>
            <respStmt>
               <resp>Recording (Mixtec content)</resp>
               <name>Bernardino Santiago Velasco</name>
            </respStmt>
         </titleStmt>
         <publicationStmt>
            <publisher>Instituto Lingüístico de Verano, A.C.</publisher>
            <pubPlace>Ciudad de México</pubPlace>
            <date>2018</date>
            <authority>Instituto Lingüístico de Verano, A.C.</authority>
            <availability>
               <licence>Licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 3.0 (CC BY-NC-ND 3.0)</licence>
            </availability>
         </publicationStmt>
         <seriesStmt>
            <ab>Content originally published as: Aprendamos el idioma mixteco (Na kutuʼva ko saʼan savi), Libro 1, disco 1. Catalog reference: mix 18-027 .25C. Primera edición.</ab>
         </seriesStmt>
         <sourceDesc>
            <p>Transcriptions derrived from file <ref type="file" subtype="audio">{mp3_name}</ref> file converted to .wav as <ref type="file" subtype="audio">{wav_name}</ref> </p>
            <p>Originally retrieved from <ref target="www.sil.org/mexico/mixteca/mixtepec" type="url">www.sil.org/mexico/mixteca/mixtepec</ref> <note>(no longer active as of 2026)</note></p>
         </sourceDesc>
      </fileDesc>
      <profileDesc>
         <creation>Content reviewed and recorded by Mixtec speakers originally from the municipality of <settlement>San Juan Mixtepec</settlement>, <district>Juxtlahuaca</district> district.</creation>
      </profileDesc>
   </teiHeader>"""


def patch_file(input_path: str, lesson_stem: str) -> str:
    with open(input_path, encoding="utf-8") as f:
        content = f.read()

    # Grab everything from <text> to </text> inclusive -- body content passes
    # through completely untouched, whatever it currently contains (stub or
    # otherwise -- this script never looks inside it).
    body_match = re.search(r"<text>.*</text>", content, re.DOTALL)
    if not body_match:
        raise ValueError(f"Could not find <text>...</text> in {input_path}; "
                          "refusing to patch (body extraction failed).")
    body_block = body_match.group(0)

    # Grab the root <TEI ...> opening tag as-is, to preserve whatever
    # namespace declaration/attributes the original file already has.
    root_match = re.search(r"<TEI[^>]*>", content)
    if not root_match:
        raise ValueError(f"Could not find <TEI ...> root tag in {input_path}.")
    root_open = root_match.group(0)

    xml_decl_match = re.match(r"<\?xml[^>]*\?>", content)
    xml_decl = xml_decl_match.group(0) if xml_decl_match else '<?xml version="1.0" encoding="UTF-8"?>'

    header = build_header(lesson_stem)

    return f"""{xml_decl}
{root_open}
{header}
   {body_block}
</TEI>
"""


def main():
    LESSON_STEM_ARG = 1   # e.g. "Leccion_08" -- used to fill in .mp3/.wav refs
    INPUT_FILE_ARG = 2
    OUTPUT_FILE_ARG = 3   # optional -- defaults to "<input_file>.patched"

    if len(sys.argv) <= INPUT_FILE_ARG:
        print("Usage: python3 patch_aprendamos_header_final.py <lesson_stem> <input_file> [output_file]")
        print(f"  arg {LESSON_STEM_ARG}: lesson stem, e.g. Leccion_08 (no extension)")
        print(f"  arg {INPUT_FILE_ARG}: the existing TEI/XML file to patch")
        print(f"  arg {OUTPUT_FILE_ARG} (optional): output path, default <input_file>.patched")
        sys.exit(1)

    lesson_stem = sys.argv[LESSON_STEM_ARG]
    input_file = sys.argv[INPUT_FILE_ARG]
    output_file = sys.argv[OUTPUT_FILE_ARG] if len(sys.argv) > OUTPUT_FILE_ARG else f"{input_file}.patched"

    patched = patch_file(input_file, lesson_stem)

    with open(output_file, "w", encoding="utf-8") as f:
        f.write(patched)

    print(f"Patched header written to {output_file}")
    print("Body content copied through untouched -- diff against the original "
          "to confirm before overwriting.")


if __name__ == "__main__":
    main()
