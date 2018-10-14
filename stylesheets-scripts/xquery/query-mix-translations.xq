xquery version "3.0";

declare function local:query($term, $lang) {
  local:query($term, $lang, ())
};

declare function local:query($term, $lang,$mode) {
    switch($mode)
      case 'case-insensitive' return db:open("Mixtepec_Mixtec")//*[contains(lower-case(.), lower-case($term))][ancestor-or-self::*/@lang[. = $lang]]
      case 'exact' return db:open("Mixtepec_Mixtec")//*[. = $term][ancestor-or-self::*/@lang[. = $lang]]
      default return db:open("Mixtepec_Mixtec")//*[contains(., $term)][ancestor-or-self::*/@lang[. = $lang]]
};


declare function local:format-match($match-id as attribute(id), $match-elt as element(), $trs as element()*) {
  <result document="{$match-elt/root()//title[1]}" match-id="{$match-id}">
      <match>{$match-elt}</match>
      <translations>{$trs}</translations>
  </result>
};

declare function local:translation-to-mix($elt) as element() {
    let $mix :=  
        if ($elt/self::span) 
        then $elt/root()//*[@id]["#"||@id = $elt/@target/tokenize(.,' ')] 
        else ()
    return
    <translation-set lang="{$elt/@lang}">
      <context>{$mix}</context>
      <translation>{$elt}</translation>
    </translation-set>

      
};

(: $elt any element to find a translation for :) 
declare function local:mix-to-translation($elt as element()) {
  let $id := $elt/@id
  (: any element - either span or link - that has an @target attribute containing $elt's id :)
  let $tr-elts := $elt/root()//(linkGrp|spanGrp)[@type = "translation"]/(link|span)[contains(@target,'#'||$id)]
  return 
      (: if an translation for $elt is found, return that :)
      if (exists($tr-elts))
      then 
        for $t in $tr-elts
        let $context := if ($t instance of element(span)) 
                                then $t/root()//*[@id = tokenize($t/@target,' ')!substring-after(.,'#')]
                                else $elt
        let $translation := local:format-translation($t)[not(@id = $id)]
        let $language := $translation/ancestor-or-self::*[@lang][1]/@lang
        return
            <translation-set lang="{$language}" orig-elt="{local-name($t)}">
                
                <context>{$context}</context>
                <translation>{$translation}</translation>
            </translation-set>

      (: if no translation of $elt is found, try with the parent element if this has an @id :)
      else 
        if ($elt/../@id)
        then local:mix-to-translation($elt/..)
        else ()
};

declare function local:format-translation($e as element()) {
  switch (true())
        case $e instance of element(span) return $e
        case $e instance of element(link) return
          let $target-ids := for $idref in tokenize($e/@target, "\s+") return substring-after($idref,'#')
          return $e/root()//*[@id = $target-ids] 
        default return $e/local-name() 
};

declare function local:format-matches($searchString, $matches as element()*) {
  <results query-term="{$searchString}" n="{count($matches)}">{
    for $w in $matches
    return
    if ($w/ancestor-or-self::*[@lang][1]/@lang = "mix")
    then
      if (not($w/@id))
      then comment {"no id for token " || $w}
      else 
      let $translation-contexts := local:mix-to-translation($w)
      return 
        if (exists($translation-contexts))
        then local:format-match($w/@id,$w, $translation-contexts)
        else ()
    else local:translation-to-mix($w)
  }</results>
};

let $lang := "en"
let $searchString := "play"
(: match on a substring: "case-insensitive" or "case-sensitive" :)
(: match on the whole "exact" :)
let $matches := local:query($searchString, $lang, 'exact')
return local:format-matches($searchString, $matches)
