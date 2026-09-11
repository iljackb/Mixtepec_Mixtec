<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.tei-c.org/ns/1.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="xs"
                version="2.0"><!-- version 2026-10-07 --><!-- INSTRUCTIONS: 
        PROCESSES ONE FILE AT A TIME:
        XSL SHOULD BE IN SAME DIRECTORY    
        INSERT FILENAME IN $input
        RUN ON SELF
        OXYEGEN TRANFORMATION SCENARIO "praat2tei-sil"
    -->
   <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="input" as="xs:string" select="'Leccion_12.txt'"/>
   <xsl:param name="text-encoding" as="xs:string" select="'UTF-8'"/>
   <!-- <xsl:param name="text-encoding" as="xs:string" select="'UTF-8'"/> -->
   <!-- utf-8 ISO-8859-1 and it works well. I think it's for European characters, which is fine. I still don't know why UTF-16 -->
   <!-- Reading the text file $input into the string variable $input-text -->
   <xsl:variable name="input-text"
                 as="xs:string"
                 select="unparsed-text($input, $text-encoding)"/>
   <!-- Trouble shooting with: http://rishida.net/tools/conversion/ -->
   <!-- splitting the input into lines -->
   <xsl:variable name="lines"
                 as="xs:string*"
                 select="tokenize($input-text, '\r?\n')"/>
   <!-- input files mush have iso 639 code (if exists) as header of collumn) -->
   <!--
    
    <xsl:param name="fileName">	
        <xsl:value-of select="tokenize(substring-before(base-uri(),'-clnd09.xml'),'/')[last()]"/>
    </xsl:param>  
   
    <xsl:param name="Spkr">	
        <xsl:value-of select="tokenize(substring-after(base-uri(),'_','.txt'))[last()]"/>
    </xsl:param>  
     -->
   <!-- PSEUDO CODE
        
element "data"
  for each line tokenize the line by delimiter
    element "row"
      for each field n
        element "header n"
          content of field n
        end of element "header n"
      end for
    end of element "row"
  end for
end of element "data"
    
    -->
   <xsl:variable name="teiHeader">
      <teiHeader>
         <fileDesc>
            <titleStmt>
               <title>TEI output for tab separated bilingual text files exported from file <xsl:value-of select="$input"/></title>
               <respStmt>
                  <resp>Annotation</resp>
                  <resp>Encoding</resp>
                  <name xml:id="JB">Jack Bowers</name>
               </respStmt>
               <respStmt>
                  <resp>Speaker</resp>
                  <name><!-- ADD FROM END OF FILENAME STRING!! --><!-- CREATE VARIABLES FOR EACH SPEAKER
                                & ASSIGN DESIGNATED INITIALS AS VALUE 
                                OF @xml:id
                            --></name>
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
               </respStmt>
               <respStmt>
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
               <availability>
                  <p>© 2018 Instituto Lingüístico de Verano, A.C. Licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 3.0 (CC BY-NC-ND 3.0).</p>
               </availability>
            </publicationStmt>
            <notesStmt>
               <note>Content originally published as: <title>Aprendamos el idioma mixteco</title> (<title xml:lang="mix">Na kutuꞌva ko saꞌan savi</title>), Libro 1, disco 1. Catalog reference: mix 18-027 .25C. Primera edición.</note>
               <note>Content reviewed and recorded by Mixtec speakers originally from the municipality of San Juan Mixtepec, Juxtlahuaca district.</note>
               <note>Originally retrieved from www.sil.org/mexico/mixteca/mixtepec (no longer active as of 2026).</note>
            </notesStmt>
            <sourceDesc>
               <p>Information about the source <ptr target="{base-uri()}"/></p>
            </sourceDesc>
         </fileDesc>
      </teiHeader>
   </xsl:variable>
   <xsl:variable name="lines-into-tabs" as="element()*">
      <xsl:for-each select="$lines[. != '']">
         <xsl:variable name="lpos" select="position()"/>
         <xsl:variable name="cols" select="tokenize(., '&#9;')"/>
         <!-- Strip a possible leading BOM (U+FEFF) from the first column, in case the
              .tsv was saved with a byte-order mark; otherwise the header check below
              could fail to match even when the line really is the header row. -->
         <xsl:variable name="col1-clean" select="translate($cols[1], codepoints-to-string(65279), '')"/>
         <xsl:variable name="is-header"
                       select="$col1-clean = 'tmin' and $cols[2] = 'tier' and $cols[3] = 'text' and count($cols) ge 4 and $cols[4] = 'tmax'"/>
         <xsl:if test="not(starts-with(normalize-space(.), 'ilo')) and not($is-header)">
            <line>
               <xsl:for-each select="$cols">
                  <xsl:choose>
                     <xsl:when test="position() eq 1">
                        <start>
                           <xsl:value-of select="."/>
                        </start>
                     </xsl:when>
                     <xsl:when test="position() eq 2">
                        <tier>
                           <xsl:value-of select="."/>
                        </tier>
                     </xsl:when>
                     <xsl:when test="position() eq 3">
                        <text>
                           <xsl:value-of select="."/>
                        </text>
                     </xsl:when>
                     <xsl:when test="position() eq 4">
                        <end>
                           <xsl:value-of select="."/>
                        </end>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:message terminate="yes">Too many columns in line <xsl:value-of select="$lpos"/>.</xsl:message>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
            </line>
         </xsl:if>
      </xsl:for-each>
   </xsl:variable>
   <xsl:variable name="praat-parsed" as="element()*">
      <xsl:for-each-group select="$lines-into-tabs" group-by="start">
         <xsl:for-each select="current-group()">
            <!-- Defensive guard: only construct an element when tier resolves to a
                 real, non-blank name. Some Saxon editions/optimizers (observed:
                 Saxon-PE, both 9.9.1.7 and 12.9) can surface a fatal XTDE0820 error
                 ("zero-length element name") when downstream distinct-values()
                 forces eager atomization of every constructed element, even for
                 edge-case rows that Saxon-HE's evaluation order does not trigger
                 the same way on. Skipping (with a warning, not a silent drop)
                 makes this robust regardless of which edition/version runs it. -->
            <xsl:choose>
               <xsl:when test="normalize-space(tier) = ''">
                  <xsl:message>WARNING: skipped row with blank tier -- start=[<xsl:value-of select="start"/>] text=[<xsl:value-of select="text"/>] end=[<xsl:value-of select="end"/>]</xsl:message>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:element name="{tier}">
                     <xsl:attribute name="start" select="start"/>
                     <xsl:attribute name="end" select="end"/>
                     <xsl:value-of select="text"/>
                  </xsl:element>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:for-each-group>
   </xsl:variable>
   <xsl:template match="/"><!--  
        <xsl:message><xsl:value-of select="praat-parsed[2]/*/@start"/></xsl:message>
        -->
      <xsl:result-document href="{replace($input,'\.txt$','.xml')}">
         <TEI>
            <xsl:sequence select="$teiHeader"/>
            <!--<xsl:sequence select="$lines-into-tabs"/>-->
            <text>
               <body>
                  <timeline><!-- when @xml:id @interval -->
                     <xsl:for-each select=" distinct-values($praat-parsed/@start | $praat-parsed/@end)">
                        <when xml:id="{concat('T',.)}" interval="{.}"/>
                     </xsl:for-each>
                  </timeline>
                  <xsl:for-each-group select="$praat-parsed" group-starting-with="Tokens"><!-- DEFINED VARIABLES FOR TIMEPOINTS IN TIMELINE -->
                     <!-- Only process real utterance groups; content appearing before the first
                          genuine Tokens boundary (stray tier rows, header rows, etc.) falls into an
                          "orphan" leftover group here and must be skipped, since its fabricated xml:id
                          can collide with the real first utterance if they share a start time. -->
                     <xsl:if test="current-group()[1]/self::Tokens">
                     <xsl:variable name="whens" as="element()*">
                        <xsl:for-each select="                                     distinct-values(                                     (current-group()[self::Mixtec|self::IPA|self::English|self::Spanish]/@start, current-group()[self::English]/@end)                                     )">
                           <when xml:id="T{position()}" interval="{.}"/>
                        </xsl:for-each>
                     </xsl:variable>
                     <annotationBlock>
                        <u n="{current-group()[1]}" xml:id="{generate-id(.)}"><!-- ID's ok-->
                           <xsl:copy-of select="current-group()[1]/(@start, @end)"/>
                           <!-- output content from "Orth" -->
                           <seg xml:lang="mix"
                                xml:id="{concat('T','-mx-',@start)}"
                                synch="{@start}">
                              <xsl:for-each select="current-group()/self::Mixtec">
                                 <xsl:variable name="start" select="@start"/>
                                 <w synch="{concat('#T',@start,' #T',@end)}" xml:id="{concat('T','-o-',@start)}">
                                    <xsl:value-of select="."/>
                                 </w>
                              </xsl:for-each>
                           </seg>
                           <!-- output content from "Pron" -->
                           <seg function="utterance"
                                xml:lang="mix"
                                notation="ipa"
                                xml:id="{concat('T','-ipa-',@start)}">
                              <xsl:for-each select="current-group()/self::IPA">
                                 <xsl:variable name="start" select="@start"/>
                                 <w synch="{concat('#T',@start,' #T',@end)}" xml:id="{concat('T','-p-',@start)}">
                                    <xsl:value-of select="."/>
                                 </w>
                              </xsl:for-each>
                           </seg>
                           <xsl:variable name="mixSegID">
                              <xsl:value-of select="current-group()/seg[@xml:lang='mix' and not(@function)]/@xml:id"/>
                           </xsl:variable>
                           <xsl:variable name="espSegID">
                              <xsl:value-of select="current-group()/seg[@xml:lang='es']/@xml:id"/>
                           </xsl:variable>
                           <spanGrp type="annotations">
                              <xsl:for-each select="current-group()/self::English">
                                 <span xml:lang="en" target="#{$mixSegID}" type="translation"><xsl:value-of select="."/></span>
                              </xsl:for-each>
                              <xsl:for-each select="current-group()/self::Spanish">
                                 <span xml:lang="es" target="#{$mixSegID}" type="translation"><xsl:value-of select="."/></span>
                              </xsl:for-each>
                           </spanGrp>
                        </u>
                        <!-- can add other features as needed -->
                     </annotationBlock>
                     </xsl:if>
                  </xsl:for-each-group>
               </body>
            </text>
         </TEI>
      </xsl:result-document>
   </xsl:template>
</xsl:stylesheet>
