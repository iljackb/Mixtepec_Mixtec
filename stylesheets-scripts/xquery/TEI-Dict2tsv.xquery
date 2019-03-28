xquery version "3.0";
declare default element namespace "http://www.tei-c.org/ns/1.0";

declare variable $local:separator := ",";
declare variable $local:quot := "&#x9;";
declare variable $local:newline := '&#10;';

(: Header labels here:)
declare variable $local:fields := (
  "Orth (1)",
  "Orth (2)",
  "A"
);

(:XPath to the contents here:)
declare function local:format-entry-as-csv($e) {
  let $fields := (
     $e/form[@type = "lemma"]/orth[1],
     $e/form[@type = "lemma" and not(@type='variant')]/pron[not(@source='#Pike-Ibach-MIX-1978')][1],
     $e/form[@type = "lemma"]/pron[2],
     
     
     $e/ref[@type="fragebogenNummer"],
     $e/cit[@type="kontext" and @n="1"]/ref[@type="fragebogenNummer"],
     $e/cit[@type="kontext" and @n="2"]/ref[@type="fragebogenNummer"],
     $e/form[@type = "hauptlemma"],
     $e/form[@type = "nebenlemma"],
     $e/gramGrp/pos[1],
     $e/form[@type="lautung" and @n="1"]/pron[@notation="tustep"][1],
     $e/form[@type="lautung" and @n="1"]/pron[@notation="ipa"][1],
     $e/form[@type='lautung' and @n="1"]/gramGrp/gram,
     $e/sense[@corresp='this:LT1'][1]/def,
     $e/form[@type="lautung" and @n="2"]/pron[@notation="tustep"][1],
     $e/form[@type="lautung" and @n="2"]/pron[@notation="ipa"][1],
     $e/form[@type='lautung' and @n="2"]/gramGrp/gram,
     $e/sense[@corresp='this:LT2'][1]/def,
     $e/form[@type="lautung" and @n="3"]/pron[@notation="tustep"][1],
     $e/form[@type="lautung" and @n="3"]/pron[@notation="ipa"][1],
     $e/form[@type='lautung' and @n="3"]/gramGrp/gram,
     $e/sense[@corresp='this:LT3'][1]/def,               
     $e/cit[@type = 'kontext'][@n = "1"]/quote[1],
     $e/cit[@type = 'kontext'][@n = "1"]/quote[2],
     $e/cit[@type='kontext' and @n='1']/interp[1],
     $e/cit[@type='kontext' and @n='1']/def[not(@corresp)][1],     
     $e/def[@corresp='this:WBD/KT1'][1],
     $e/cit[@type='kontext' and @n='1']/re[@type='zusatzlemma'][1],
     $e/cit[@type='kontext' and @n='1']/re[@type='zusatzlemma'][2],
     $e/cit[@type='kontext' and @n='1']/note[@type="anmerkung"][1],
     $e/cit[@type = 'kontext'][@n = "2"]/quote[1],
     $e/cit[@type = 'kontext'][@n = "2"]/quote[2],
     $e/cit[@type='kontext' and @n='2']/interp[1],
     $e/cit[@type='kontext' and @n='2']/def[not(@corresp)][1],     
     $e/def[@corresp='this:WBD/KT2'][1],
     $e/cit[@type='kontext' and @n='2']/re[@type='zusatzlemma'][1],
     $e/cit[@type='kontext' and @n='2']/re[@type='zusatzlemma'][2],
     $e/cit[@type='kontext' and @n='2']/note[@type="anmerkung"][1],
     $e/cit[@type = 'kontext'][@n = "3"]/quote[1],
     $e/cit[@type = 'kontext'][@n = "3"]/quote[2],
     $e/cit[@type='kontext' and @n='3']/interp[1],
     $e/cit[@type='kontext' and @n='3']/def[not(@corresp)][1],     
     $e/def[@corresp='this:WBD/KT3'][1],
     $e/cit[@type='kontext' and @n='3']/re[@type='zusatzlemma'][1],
     $e/cit[@type='kontext' and @n='3']/re[@type='zusatzlemma'][2],
     $e/cit[@type='kontext' and @n='3']/note[@type="anmerkung"][1],     
     $e/note[@type='anmerkung' and @resp='O'][1],
     $e/note[@type='anmerkung' and @resp='B'][1],
     $e/usg[not(@corresp)][1]/placeName[1],
     $e/usg[@corresp='this:LT1']/placeName,
     $e/usg[@corresp='this:LT2']/placeName,
     $e/usg[@corresp='this:LT3']/placeName,
     $e/ref[@type='quelle']/date,
     $e/ref[@type='quelle'],
     $e/ref[@type='quelleBearbeitet'],
     $e/etym[@resp='O'][1],
     $e/etym[@resp='B'],
     $e/ref[@type='archiv']
  )
  return local:csv-line(for $f in $fields return local:csv-cell($f))
};

declare function local:csv-heading(){
  local:csv-line(
    for $f in (
      $local:fields
    ) return local:csv-cell($f)
  )
};

declare function local:csv-cell($data) {
  concat($local:quot, $data, $local:quot)
};

declare function local:csv-line($cells) {
  string-join($cells, $local:separator)
};

declare function local:csv($entries) {
  let $lines := for $e in $entries  return local:format-entry-as-csv($e)
  return local:csv-heading()||$local:newline||string-join($lines, $local:newline)
};

let $r := //form/orth[@type="lemma"][1][not(node())]/ancestor::entry

return local:csv($r)