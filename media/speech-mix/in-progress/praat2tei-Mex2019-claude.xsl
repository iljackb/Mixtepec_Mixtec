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
   <xsl:param name="input" as="xs:string" select="'190630_0051-na_nu-ka_nu.txt'"/>
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
               <title>TEI output for file: 190630_0051-na_nu-ka_nu.wav</title>
               <respStmt>
                  <resp>Annotation</resp>
                  <resp>Encoding</resp>
                  <name xml:id="JB">Jack Bowers</name>
               </respStmt>
               <!-- edit as needed -->
               <respStmt>
                  <resp>Speaker</resp>
                  <name xml:id="JS">Jeremías Salazar</name> 
               </respStmt>
            </titleStmt>
            <publicationStmt>
               <authority>
                  <name>Jack Bowers</name>
                  <name>Jeremías Salazar</name>
                  <name>Tisu'ma Salazar</name>
               </authority>
               <availability>
                  <licence>CC-BY</licence>
               </availability>
            </publicationStmt>
            <sourceDesc>
               <p>This is a record of the speech file  <media mimeType="wav" url="190710_0270-tell-the-truth.wav"/></p>
            </sourceDesc>
            <sourceDesc>
               <recordingStmt>
                  <!-- change as needed -->
                  <recording type="audio">
                     <respStmt>
                        <resp>Recording</resp>
                        <resp>Elicitation</resp>
                        <name>Jack Bowers</name>
                     </respStmt>
                     <equipment>
                        <ab>Audio recorded using a Tascam DR-05X Linear PCM Recorder at a rate of 96kHz/24-bit.</ab>
                     </equipment>
                     <ab>
                        <location>                      
                           <placeName>Santiago Juxtlahuaca</placeName>
                           <country>Mexico</country>
                        </location>
                     </ab>
                     <date>2019-07-10</date>
                     <ab>Content was recorded from <term ana="#elicitation-translation">Translation-based elicitation</term> from <lang>English</lang>.</ab>
                  </recording>
               </recordingStmt>
            </sourceDesc>
         </fileDesc>
         <encodingDesc>
            <classDecl>
               <taxonomy>
                  <desc>Typology of linguistic speech events captured in recordings as per: <bibl>Himmelmann (<date>1998</date>)</bibl>. aka Typology of "naturalness".</desc>
                  <category xml:id="observed">
                     <catDesc>
                        <term>Observed communicative event:</term> the extent of external interference is limited to the knowledge of the speakers that the speech is being recorded or observed.</catDesc>
                  </category>
                  <category xml:id="staged">
                     <catDesc>
                        <term>Staged communicative event:</term> speech events realized for the purpose of recording (i.e. elicited speech). Events are not really being realized for the purpose of communication but for the benefit of the investigator.</catDesc>
                     <category xml:id="staged-free-topical">
                        <catDesc>
                           <term>Staged-Topical</term>Prompt to speak freely about topic</catDesc>
                     </category>
                     <category xml:id="staged-stimuli">
                        <catDesc>
                           <term>Staged-Stimuli</term> events based on stimuli to be described in speakers own words</catDesc>
                     </category>
                  </category>
                  <category xml:id="elicitation">
                     <catDesc>
                        <term>Elicitation:</term> speech act for the sole purpose of linguistic investigation. (A new type of speech event for most communities).</catDesc>
                     <category xml:id="elicitation-contextualizing">
                        <catDesc>
                           <term>Contextualizing elicitation:</term> where native speakers are asked to provide contexts for a item or construction as prompted by the investigator.</catDesc>
                     </category>
                     <category xml:id="elicitation-translation">
                        <catDesc>
                           <term>Translation-based elicitation:</term> native speaker asked to translate item from second language</catDesc>
                     </category>
                     <category xml:id="elicitation-judgement">
                        <catDesc>
                           <term>Judgement:</term> where native speakers are asked to judge the acceptibility of a given construction based on any aspect of language, e.g. grammar, etc.</catDesc>
                     </category>
                  </category>
               </taxonomy>
            </classDecl>
         </encodingDesc>
         <revisionDesc status="unfinished">
            <list>
               <item>
                  <note>Not all utterances in this recording have been transcribed</note>
               </item>
            </list>
         </revisionDesc>
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
                        <xsl:for-each select="distinct-values((current-group()[self::Mixtec|self::IPA|self::English]/@start, current-group()[self::English]/@end))">
                           <when xml:id="T{position()}" interval="{.}"/>
                        </xsl:for-each>
                     </xsl:variable>
                     <annotationBlock>
                        <u n="{current-group()[1]}" xml:id="{generate-id(.)}"><!-- ID's ok-->
                           <xsl:copy-of select="current-group()[1]/(@start, @end)"/>
                           <!-- output content from "Orth" -->
                           <seg xml:lang="mix"
                                xml:id="{concat('T','-mx-',@start)}"
                                synch="{@start}"
                                notation="orth">
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
                                 <span xml:lang="es" target="#{$mixSegID}" type="translation"></span>
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
