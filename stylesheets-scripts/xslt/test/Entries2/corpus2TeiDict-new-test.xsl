<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- 
    THIS VERSION IS MEANT FOR FILES WHERE ALL <w>'s are in Mixtec
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
    
    <xsl:param name="input" as="xs:string" select="'L098-tok-mini.xml'"/>
    <xsl:preserve-space elements="*"/>
    
    <!-- read file defined in $input -->
    <xsl:variable name="readDoc" select="document($input)"/>
    
    <xsl:template match="/">
        <xsl:message>My file: <xsl:value-of select="document-uri($readDoc)"/></xsl:message>
        
        <!--<xsl:variable name="folderName" select="'EntriesTest'"/>-->
        
        <xsl:variable name="allSpans" select="distinct-values($readDoc/descendant::span[not(@type) and @xml:lang='en'])"/>
        
        <xsl:message><xsl:value-of select="$allSpans"  separator=" - "/></xsl:message>

        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Concordance lexical entry for lemma: <xsl:value-of select="normalize-space(.)"/></title>
                    </titleStmt>
                    <publicationStmt><!-- add the document path? -->
                        <p>blablabla</p>
                    </publicationStmt>
                    <sourceDesc>
                        <bibl>BLABLABLA</bibl>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:for-each select="$allSpans">
                        <!--<xsl:sort/> -->   
                        
                        <xsl:for-each select="$readDoc/descendant::span[not(@type) and @xml:lang='en'][. = current()]">
                            
                            <xsl:variable name="targetSpan" select="@target"/>
                            
                            <xsl:message>Boucle: <xsl:value-of select="."/></xsl:message>
                            
                            <xsl:variable name="wIDs" select="tokenize($targetSpan,' ')"/>
                            
                            <xsl:message>Tokens: <xsl:value-of select="$wIDs"/></xsl:message>
                           
                            <xsl:variable name="segID" select="parent::seg/@xml:id"/><!-- ?? -->
                            
                            <!--<xsl:variable name="segTarget" as="xs:string" select="concat('#',$segID)"/>-->
                            
                            <!-- we could get the context sentence by using segID or by just getting value of span[@type='sentence'] -->
                            <xsl:variable name="sTranslationEn"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='en'
                                and @target = $segID]"/>
                            
                            <xsl:variable name="sTranslationEs"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='es'
                                and @target = $segID]"/>
                            <!--  
                            <xsl:variable name="linkTranslationEs"
                                select="$readDoc/descendant::linkGrp[@type = 'translation']/link[tokenize(@target,' ') = $target]"/>
                            
                            <xsl:variable name="wTranslationEn" 
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='en' and tokenize(@target,' ') = $target]"/>
                            
                            <xsl:variable name="wTranslationEs"
                                select="$readDoc/descendant::spanGrp[@type = 'translation']/span[contains(.,$target) and tokenize(@target,' ') = $target]"/>
               
                            <xsl:variable name="distinctSense" select="distinct-values($wTranslationEn)"/>    -->
                            
                            <entry>
                                
                                <form type="lemma">
                                    <orth xml:lang="mix">
                                        <xsl:choose>
                                            <xsl:when test="count($wIDs)>1">
                                               <xsl:for-each select="$wIDs">
                                                   <xsl:message>Le résultat: <xsl:value-of select="$readDoc/descendant::w[@xml:id = substring-after(current(),'#')]"/></xsl:message>
                                                   <seg>
                                                       <xsl:value-of select="$readDoc/descendant::w[@xml:id = substring-after(current(),'#')]"/>
                                                   </seg>
                                               </xsl:for-each>
                                                
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:message>Un seul token: <xsl:value-of select="$wIDs"/></xsl:message>
                                                <xsl:message>Le résultat solitaire: <xsl:value-of select="$readDoc/descendant::w[@xml:id = substring-after($wIDs,'#')]"/></xsl:message>
                                                <xsl:value-of select="$readDoc/descendant::w[@xml:id = substring-after($wIDs,'#')]"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </orth>
                                    <pron xml:lang="mix" notation="ipa"></pron>
                                </form>
                                <!--
                                <gramGrp>
                                    <pos></pos>
                                </gramGrp>
                                -->
                                <sense>
                                    <!--  
                                    <xsl:for-each select="$distinctSense">   
                                        -->
                                        <xsl:if test="parent::seg[@type='S']/*">
                                            <cit type="example">
                                                <quote xml:lang="mix">      
                                                    <xsl:value-of select="parent::seg/*" separator=" "/>
                                                </quote>
                                                <cit type="translation">
                                                    <quote xml:lang="en">
                                                        <xsl:value-of select="$sTranslationEn" separator=" "/>
                                                    </quote>
                                                </cit>
                                                <cit type="translation">
                                                    <quote xml:lang="es">
                                                        <xsl:value-of select="$sTranslationEs" separator=" "/>
                                                    </quote>
                                                </cit>
                                            </cit>
                                        </xsl:if>

                                          <!-- 
                                        <cit type="translation">
                                            <form>
                                                <orth xml:lang="en">
                                                    <xsl:value-of select="$wTranslationEn"/>
                                                </orth>
                                            </form>
                                        </cit>
                                  <!-\- for where there is a <linkGrp> translation -\-> -->
                                        <!--  
                                        <xsl:for-each select="$linkTranslationEs">
                                            <cit type="translation">
                                                <form>
                                                    <orth xml:lang="es">
                                                        <xsl:for-each select="tokenize(@target,' ')">
                                                            <xsl:variable name="currentLinkedId" select="substring-after(.,'#')"/>                 
                                                            <xsl:variable name="currentLinkedObject"
                                                                select="$readDoc/descendant::w[@xml:id=$currentLinkedId and @xml:lang ='es']"/>   
                                                            <xsl:value-of select="normalize-space($currentLinkedObject)"/>  
                                                        </xsl:for-each>    
                                                        
                                                    </orth>
                                                </form>
                                            </cit>
                                        </xsl:for-each>
                                        -->
                                    <!--  
                                        <xsl:for-each select="$wTranslationEs">
                                            <cit type="translation">
                                                <form>
                                                    <orth xml:lang="es">
                                                        <xsl:value-of select="$wTranslationEs"/>
                                                    </orth>
                                                </form>
                                            </cit>
                                        </xsl:for-each>
                  
                                    </xsl:for-each>
                                    -->
                                </sense>
                            </entry>
                            
                        </xsl:for-each>
                        
                    </xsl:for-each>
                </body>
            </text>
        </TEI>
        
    </xsl:template>
</xsl:stylesheet>