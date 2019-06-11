<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes"/>

    <!-- 
    THIS VERSION IS MEANT FOR FILES WHERE ALL <w>'s are in Mixtec (but @xml:id not necessarily on it)
    -->

    <!-- 
    Needs to ADD:
     - TO INCLUDE MULTI WORD EXPRESSIONS (& COMPOUNDS):IE WHERE TRANSLATION POINTS TO MULTIPLE <w>'s
     - ONLY MAKE ENTRIES FOR DISTINCT SENSES!!!
     - DISTINGUISH FROM SPANISH <w>'s IN HEADER!!
    -->

    <!--
        SPECIFY FOLDER IN VARIABLE "$folderName" 
        RUN ON SELF: 
        Input file and xsl in scenario should be "${currentFile}" -->

    <!-- variable for each unique item should be based on english or spanish translation (instead of value of: "distinct-values(descendant::w/@lemma)"  -->

    <!-- adapt for multi-token items (what about where I annotated phrases?) -->

    <!-- SCRIPT IS FOR DOCS WITH NO SENTENCES AND SPANISH ONLY AS <linkGrp> -->

    <xsl:param name="input" as="xs:string" select="'L157-tok.xml'"/>
    <xsl:preserve-space elements="*"/>

    <!-- read file defined in $input -->
    <xsl:param name="readDoc" select="document($input)"/>

    <xsl:template match="/">
        <xsl:message>My file: <xsl:value-of select="document-uri($readDoc)"/></xsl:message>

        <xsl:variable name="theRoot" select="."/>
        <xsl:variable name="folderName" select="'EntriesTest'"/>
        <xsl:variable name="allLemmas"
            select="distinct-values($readDoc/descendant::w[ancestor-or-self::*/@xml:lang = 'mix'])"/>

        <xsl:message>All lemmas: <xsl:value-of select="$allLemmas" separator=" - "/></xsl:message>

        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Concordance lexical entry for lemma: <xsl:value-of
                                select="$input"/></title>
                    </titleStmt>
                    <publicationStmt><!-- add the document path? 
                                <xsl:copy-of select="$readDoc/descendant::publicationStmt/distributor"/>
                                <xsl:copy-of select="$readDoc/descendant::publicationStmt/address"/>
                                <xsl:copy-of select="$readDoc/descendant::publicationStmt/availability"/>-->
                    </publicationStmt>
                    <sourceDesc>
                        <bibl>
                            <!-- add the document path in attribute
                                    <editor><xsl:value-of select="$readDoc/descendant::titleStmt/editor" separator=" "/></editor>, <date><xsl:value-of select="$readDoc/descendant::sourceDesc/bibl/date"/></date>. <title xml:lang="mix"><xsl:value-of select="$readDoc/descendant::titleStmt/title[@xml:lang='mix']" separator=" "/>
                                    </title> -->
                        </bibl>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:for-each select="$allLemmas">
                        <xsl:sort/>

                        <xsl:for-each select="$readDoc/descendant::w[. = current()]">

                            <xsl:variable name="segID" select="parent::seg/@xml:id"/>

                            <xsl:variable name="wID" select="@xml:id"/>

                            <xsl:variable name="segTarget" as="xs:string"
                                select="concat('#', $segID)"/>

                            <xsl:variable name="target" as="xs:string" select="concat('#', $wID)"/>

                            <xsl:variable name="sTranslationEn"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'en' and @target = $segTarget]"/>
                            <xsl:message>English translation: <xsl:value-of select="$sTranslationEn"/></xsl:message>

                            <xsl:variable name="cert-sTranslationEn"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'en' and @target = $segTarget]/@cert"/>

                            <xsl:variable name="sTranslationEs"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'es' and @target = $segTarget]"/>
                            <xsl:message>Spanish translation: <xsl:value-of select="$sTranslationEs"/></xsl:message>
                            
                            <xsl:variable name="cert-sTranslationEs"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'es' and @target = $segTarget]/@cert"/>
                            
                            <xsl:variable name="spanTargetEn"
                                select="($readDoc/descendant::spanGrp[@type = 'translation']/span[not(@type = 'S') and @xml:lang='en']/@target[tokenize(., ' ') = $target])[1]"/>

                            <xsl:variable name="spanTargetInflected"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@type = 'inflected']/@target[tokenize(., ' ') = $target]"/>

                            <xsl:variable name="spanTargetPhrase"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@type = 'phrase']/@target[tokenize(., ' ') = $target]"/>

                            <xsl:variable name="spanTargetCompound"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@type = 'compound']/@target[tokenize(., ' ') = $target]"/>

                            <xsl:variable name="wPhoneticForm" select="$readDoc/descendant::w[@sameAs= $target]"/>
                            

                            <xsl:message>Span Target Phrase:
                                <xsl:value-of select="$spanTargetPhrase"/>
                                <xsl:value-of select="$readDoc/descendant::w[@xml:id = substring-after(current(), '#')]"/>
                            </xsl:message>
                            
                            <xsl:variable name="wIDs" select="tokenize($spanTargetEn, ' ')"/>
                            <xsl:message>Tokenised Ids: <xsl:value-of select="$wIDs"/></xsl:message>
                            
                            <!-- link pointing to w/@xml:id (there are never any existing english translations so <linkGrp> will only point from spanish and mixtec -->
                            <xsl:variable name="linkTranslationEs-W"
                                select="$readDoc/descendant::linkGrp[@type = 'translation']/link[not(@type='S')][tokenize(@target, ' ') = $target]"/>
                            <xsl:message>es: <xsl:value-of select="$linkTranslationEs-W"/></xsl:message>
                            
                            <xsl:variable name="linkTranslationEs-S"
                                select="$readDoc/descendant::linkGrp[@type = 'translation']/link[@type='S'][tokenize(@target, ' ') = $target]"/>
                            <xsl:message>es: <xsl:value-of select="$linkTranslationEs-S"/></xsl:message>
             
                            <xsl:variable name="certTranslationEn" select="$readDoc/descendant::spanGrp[@type = 'translation']/span[not(@type = 'S') and @xml:lang = 'en'][@target[tokenize(., ' ') = $target]]/@cert"/>

                            <xsl:variable name="certTranslationEs" select="$readDoc/descendant::spanGrp[@type = 'translation']/span[not(@type = 'S') and @xml:lang = 'es'][@target[tokenize(., ' ') = $target]]/@cert"/>
                            
                            <xsl:variable name="literalTranslationEn" select="$readDoc/descendant::spanGrp[@type = 'translation']/span[not(@type = 'S') and @xml:lang = 'en'][@target[tokenize(., ' ') = $target]]/@type='literal'"/>
                            
                            <xsl:variable name="literalTranslationEs" select="$readDoc/descendant::spanGrp[@type = 'translation']/span[not(@type = 'S') and @xml:lang = 'es'][@target[tokenize(., ' ') = $target]]//@type='literal'"/>

                            <xsl:variable name="wTranslationEn"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'en' and not(@type= 'note') and tokenize(@target, ' ') = $target]"/>
                            <xsl:variable name="wTranslationEs"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'es' and not(@type= 'note') and tokenize(@target, ' ') = $target]"/>

                            <!--add other languages if needed by copying spanish
                                <xsl:variable name="distinctSense" select="distinct-values($wTranslationEn)"/>    -->
                            
                            <!-- ADD VARIABLE FOR PHONETIC FORM WHICH CONTAINS $target as value of @sameAs: do for <w> and parent <seg> if applicable
                            (for words you can place and point to the <w> because it is mixtec to mixtec and the segmentation matches orthography)
                            -->

                            <xsl:variable name="note"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@type = 'note' and tokenize(@target, ' ') = $target]"/>

                            <xsl:variable name="EntrySenseName"
                                select="$readDoc/descendant::spanGrp[@type = 'semantics']/span[@type = 'sense' and tokenize(@target, ' ') = $target]/@corresp/substring-after(., 'http://dbpedia.org/resource/')"/>

                            <!-- 
                                <xsl:variable name="entryID" select="concat($EntrySenseName, '-MIX')"/>
                                 -->

                            <!-- NEED TO ADD @CERT ON CERTAIN ITEMS! -->
                            
                            <!-- DONT MAKE ENTRY UNLESS THERE IS A TRANSLATION!!-->
                            <xsl:if test="$wTranslationEn or $wTranslationEs or $note">     
                            <entry>
                                <xsl:if test="$spanTargetCompound">
                                    <xsl:attribute name="type">
                                        <xsl:text>compound</xsl:text>
                                    </xsl:attribute>
                                </xsl:if>
                                <!-- could add id $compound here and then if true, add @type="compound" on <entry> 
                                <xsl:attribute name="xml:id">
                                    <xsl:value-of select="$target"/>
                                </xsl:attribute>
-->
                                <xsl:if test="count($wIDs) = 1 and not($spanTargetInflected | $spanTargetPhrase| $spanTargetCompound)">
                                        <form type="lemma">
                                            <orth xml:lang="mix">
                                                <xsl:value-of select="lower-case(normalize-space(.))"/>
                                            </orth>
                                            <pron xml:lang="mix" notation="ipa">
                                                <xsl:value-of select="$wPhoneticForm"/>
                                            </pron>
                                        </form>  
                                </xsl:if>
                                
                                <xsl:if test="$spanTargetInflected">
                                    <!-- also add condition for inflected forms that aren't more than one <w>!! I don't want them in <seg> -->
                                    <form type="inflected">
                                        <orth xml:lang="mix">                                                    
                                            <xsl:for-each select="$wIDs">
                                                <xsl:message>Span Target Inflected:
                                                    <xsl:value-of select="lower-case($readDoc/descendant::w[@xml:id = substring-after(current(), '#')])"/>
                                                </xsl:message>
                                                <seg>    
                                                    <xsl:value-of select="lower-case($readDoc/descendant::w[@xml:id = substring-after(current(), '#')])" />
                                                </seg>
                                            </xsl:for-each>
                                        </orth>
                                        <gramGrp>
                                            <pos/>
                                            <per/>
                                            <number/>
                                        </gramGrp>
                                        <!-- add glosses here (instead of translations) -->
                                        <xsl:for-each select="distinct-values($wTranslationEn)">
                                            <gloss xml:lang="en">
                                                <xsl:for-each select="$certTranslationEn">
                                                    <xsl:attribute name="cert">
                                                        <xsl:value-of select="."/>
                                                    </xsl:attribute>
                                                </xsl:for-each>
                                                <xsl:value-of select="."/> 
                                            </gloss>
                                        </xsl:for-each>
<!-- ADD CODE TO CORRECTLY GET <note> when form is inflected (current error places notes in <gloss>) -->
                                        <xsl:for-each select="distinct-values($wTranslationEs)">
                                            <gloss xml:lang="es">
                                                <xsl:for-each select="$certTranslationEs">
                                                    <xsl:attribute name="cert">
                                                        <xsl:value-of select="."/>
                                                    </xsl:attribute>
                                                </xsl:for-each>
                                                <xsl:value-of select="."/>
                                            </gloss>
                                        </xsl:for-each>

                                    </form>
                                </xsl:if>
                                
                                <xsl:if test="$spanTargetPhrase and not($spanTargetInflected | $spanTargetCompound)">
                                    <form type="phrase">
                                        <orth xml:lang="mix">
                                            <xsl:for-each select="$wIDs">
                                                <xsl:message>Span Target Phrase:
                                                    <xsl:value-of select="$spanTargetPhrase"/>
                                                    <xsl:value-of select="lower-case($readDoc/descendant::w[@xml:id = substring-after(current(), '#')])"/>
                                                </xsl:message>
                                                <seg>
                                                    <xsl:value-of select="lower-case($readDoc/descendant::w[@xml:id = substring-after(current(), '#')])"/>
                                                </seg>
                                            </xsl:for-each>
                                        </orth>
                                    </form>
                                </xsl:if>
                                <xsl:if test="$spanTargetCompound">
                                    <form type="lemma">
                                        <orth xml:lang="mix">
                                            <xsl:for-each select="$wIDs">
                                                <xsl:message>Span Target compound:
                                                    <xsl:value-of select="$spanTargetCompound"/>
                                                    <xsl:value-of select="lower-case($readDoc/descendant::w[@xml:id = substring-after(current(), '#')])"/>
                                                </xsl:message>
                                                <seg>
                                                    <xsl:value-of select="lower-case($readDoc/descendant::w[@xml:id = substring-after(current(), '#')])"/>
                                                </seg>
                                            </xsl:for-each>
                                        </orth>
                                    </form>
                                </xsl:if>
                                

                                <gramGrp>
                                    <pos/>
                                </gramGrp>

                                <sense>

                                    <!--  
                                        <xsl:variable name="wSense1" 
                                            select="$readDoc/descendant::spanGrp[@type = 'semantics']/span[@type='sense' and tokenize(@target,' ') = $target]/@corresp"/>
                                        
                                        <xsl:attribute name="corresp">
                                            <xsl:value-of select="$wSense1"/>
                                        </xsl:attribute>   
                                        -->
                                    <!-- old way [...and @target = $target]/note 
                                        <xsl:variable name="senseNote" 
                                            select="$readDoc/descendant::spanGrp[@type = 'semantics']/span[@type='note' and tokenize(@target,' ') = $target]/note"/>
                                            -->
                                        <xsl:for-each select="$note">
                                            <note>
                                                <xsl:for-each select="$note">
                                                    <xsl:if test="@resp">
                                                        <xsl:attribute name="resp">
                                                            <xsl:value-of select="."/>
                                                        </xsl:attribute>
                                                    </xsl:if>
                                                </xsl:for-each>
                                                <xsl:value-of select="."/>
                                            </note>
                                        </xsl:for-each>


                                    <xsl:if test="parent::seg[@type = 'S']/*">
                                        <cit type="example">
                                            <quote xml:lang="mix">
                                                <xsl:value-of select="parent::seg/*"/>
                                            </quote>
                                            <cit type="translation">
                                                <xsl:for-each select="$cert-sTranslationEs">
                                                    <xsl:attribute name="cert">
                                                        <xsl:value-of select="."/>
                                                    </xsl:attribute>
                                                </xsl:for-each>
                                                <quote xml:lang="en">
                                                  <xsl:value-of select="$sTranslationEn" separator=" "/>
                                                </quote>
                                            </cit>
                                            <cit type="translation">
                                                <xsl:for-each select="$cert-sTranslationEs">
                                                    <xsl:attribute name="cert">
                                                        <xsl:value-of select="."/>
                                                    </xsl:attribute>
                                                </xsl:for-each>
                                                <quote xml:lang="es">
                                                  <xsl:value-of select="$sTranslationEs | $linkTranslationEs-S" separator=" "/>
                                                </quote>
                                            </cit>
                                        </cit>
                                    </xsl:if>
                                    
                               <xsl:for-each select="distinct-values($wTranslationEn)">

                                        <cit type="translation">
                                            <xsl:for-each select="$certTranslationEn">
                                                <xsl:attribute name="cert">
                                                    <xsl:value-of select="."/>
                                                </xsl:attribute>
                                            </xsl:for-each>
                                            
                                            <xsl:if test="$literalTranslationEn">
                                                <xsl:attribute name="subtype">
                                                    <xsl:value-of select="."/>
                                                </xsl:attribute>
                                            </xsl:if>

                                            <form>
                                                <orth xml:lang="en">
                                                  <xsl:value-of select="."/>
                                                </orth>
                                            </form>
                                        </cit>
                                 </xsl:for-each>    <!-- -->

                                    <xsl:for-each select="distinct-values($wTranslationEs)">
                                        <xsl:message>es: <xsl:value-of select="$wTranslationEs"/></xsl:message>

                                        <cit type="translation">
                                            <xsl:for-each select="$certTranslationEs">
                                                <xsl:attribute name="cert">
                                                    <xsl:value-of select="."/>
                                                </xsl:attribute>
                                            </xsl:for-each>
                                            
                                            <xsl:if test="$literalTranslationEs">
                                                <xsl:attribute name="subtype">
                                                    <xsl:value-of select="."/>
                                                </xsl:attribute>
                                            </xsl:if>
                                            
                                            <form>
                                                <orth xml:lang="es">
                                                  <xsl:value-of select="."/>
                                                </orth>
                                            </form>
                                        </cit>
                                    </xsl:for-each>
                                    <!-- (BUG: need to allow for multiple spanish terms and "es-MEX" or "es" )-->

                                    <xsl:for-each select="$linkTranslationEs-W">
                                        <cit type="translation">
                                            <form>
                                                <orth xml:lang="es">

                                                  <xsl:for-each select="tokenize(@target, ' ')">

                                                  <xsl:variable name="currentLinkedId" select="substring-after(., '#')"/>

                                                  <xsl:variable name="currentLinkedObject"
                                                  select="$readDoc/descendant::w[@xml:id = $currentLinkedId and @xml:lang = 'es']"/>

                                                  <xsl:value-of select="normalize-space($currentLinkedObject)"/>

                                                  </xsl:for-each>

                                                </orth>
                                            </form>
                                        </cit>
                                    </xsl:for-each>

                                    <!-- Problem: where multiple latin items:       
                                            <xsl:for-each select="$wTranslationLat">
                                            <cit type="translation">
                                                <form>
                                                    <orth xml:lang="la">
                                                        <xsl:value-of select="$wTranslationLat"/>
                                                    </orth>
                                                </form>
                                            </cit>         
                                            </xsl:for-each>
                                            -->

                                </sense>
                            </entry>
                            </xsl:if>
                        </xsl:for-each>

                    </xsl:for-each>
                </body>
            </text>
        </TEI>
        <!--         </xsl:result-document> 
        </xsl:for-each>-->
    </xsl:template>
</xsl:stylesheet>
