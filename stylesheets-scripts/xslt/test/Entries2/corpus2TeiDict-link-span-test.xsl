<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- SPECIFY FOLDER IN VARIABLE "$folderName" RUN ON SELF: Input file and xsl in scenario should be "${currentFile}" -->
    
    <!-- variable for each unique item should be based on english or spanish translation (instead of value of: "distinct-values(descendant::w/@lemma)"  -->
    
    <!-- adapt for multi-token items (what about where I annotated phrases?) -->
    
    <!-- SCRIPT IS FOR DOCS WITH NO SENTENCES AND SPANISH ONLY AS <linkGrp> -->
    
    <xsl:param name="input" as="xs:string" select="'Las_aves-mix.xml'"/>
    <xsl:preserve-space elements="*"/>
    
    <!-- read file defined in $input -->
    <xsl:param name="readDoc" select="document($input)"/>
    
    <xsl:template match="/">
        <xsl:message>My file: <xsl:value-of select="document-uri($readDoc)"/></xsl:message>
        
        <xsl:variable name="theRoot" select="."/>
        <xsl:variable name="folderName" select="'EntriesTest'"/>
        <xsl:variable name="allLemmas" select="distinct-values($readDoc/descendant::w[@xml:lang='mix'])"/>
        <!-- 
        <xsl:variable name="allLemmas" select="distinct-values($readDoc/descendant::w[ancestor-or-self::*/@xml:lang='mix'])"/>
         -->
        

        <!-- 
        
        <xsl:message>coucou: <xsl:value-of select="$allLemmas"/></xsl:message>
        <xsl:for-each select="$allLemmas">
            <xsl:sort/>
            <xsl:result-document href="{$folderName}/{normalize-space(.)}.xml" method="xml">-->
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>Concordance lexical entry for lemma: <xsl:value-of select="normalize-space(.)"/></title>
                            </titleStmt>
                            <publicationStmt><!-- add the document path? -->
                                <xsl:copy-of select="$readDoc/descendant::publicationStmt/distributor"/>
                                <xsl:copy-of select="$readDoc/descendant::publicationStmt/address"/>
                                <xsl:copy-of select="$readDoc/descendant::publicationStmt/availability"/>
                            </publicationStmt>
                            <sourceDesc>
                                <bibl>
                                    <!-- add the document path in attribute -->
                                    <editor><xsl:value-of select="$readDoc/descendant::titleStmt/editor" separator=" "/></editor>, <date><xsl:value-of select="$readDoc/descendant::sourceDesc/bibl/date"/></date>. <title xml:lang="mix"><xsl:value-of select="$readDoc/descendant::titleStmt/title[@xml:lang='mix']" separator=" "/>
                                    </title>
                                </bibl>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <xsl:message>coucou: <xsl:value-of select="$allLemmas"/></xsl:message>
                            <xsl:for-each select="$allLemmas">
                                <xsl:sort/>

                            <!-- add @xml:id on <entry> take substring after dbpedia sense[@corresp][starts-with(.,"http://dbpedia.org/resource/")] 
                                   -->                  
                     
                            <xsl:for-each select="$readDoc/descendant::w[@xml:lang='mix'][. = current()]">
                                
                                <xsl:variable name="segID" select="parent::seg/@xml:id"/>
                                
                                <xsl:variable name="wID" select="@xml:id"/>
                                
                                <xsl:variable name="segTarget" as="xs:string" select="concat('#',$segID)"/>
                                
                                <xsl:variable name="target" as="xs:string" select="concat('#',$wID)"/>

                                <xsl:variable name="sTranslationEn"
                                    select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='en'
                                    and @target = $segTarget]"/>
                                
                                <xsl:message>en: <xsl:value-of select="$sTranslationEn"/></xsl:message>
                                
                                <xsl:variable name="sTranslationEs"
                                    select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='es'
                                    and @target = $segTarget]"/>
                                
                                <xsl:message>es: <xsl:value-of select="$sTranslationEs"/></xsl:message>
                                
                                <!-- link pointing to w/@xml:id (there are never any existing english translations so <linkGrp> will only point from spanish and mixtec -->
                                <xsl:variable name="linkTranslationEs"
                                    select="$readDoc/descendant::linkGrp[@type = 'translation']/link[tokenize(@target,' ') = $target]"/>
                                
                                
                                <!-- Old way:
                                                                <xsl:variable name="linkTranslationEs"
                                    select="$readDoc/descendant::linkGrp[@type = 'translation']/link[contains(@target,$target)]"/>
                                -->
                                <xsl:message>es: <xsl:value-of select="$linkTranslationEs"/></xsl:message>
                                
                                <!-- NEED TO DISTINGUISH WHOLE STRINGS (CURRENT ERROR MATCHES ANY target that contains ($target) even if not full word -->
                                <xsl:variable name="wTranslationEn" 
                                    select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='en' and tokenize(@target,' ') = $target]"/>
                             <!-- 
                             <xsl:message>en: <xsl:value-of select="$wTranslationEn"/></xsl:message>
                                 -->   
                                    <xsl:variable name="wTranslationEs"
                                        select="$readDoc/descendant::spanGrp[@type = 'translation']/span[contains(.,$target) and tokenize(@target,' ') = $target]"/>
                                <!--
                            <xsl:message>es: <xsl:value-of select="$wTranslationEs"/></xsl:message>
                               -->   
                                <xsl:variable name="wTranslationLat" 
                                    select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='la' and tokenize(@target,' ') = $target]"/>
                                
                                <!-- Old way:
                                    
                                                         <xsl:variable name="wTranslationLat" 
                                    select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='la'
                                    and @target = $target]"/>
                                
                                -->
                                
                                <xsl:variable name="distinctSense" select="distinct-values($wTranslationEn)"/>    
                                
                                <xsl:variable name="EntrySenseName" 
                                    select="$readDoc/descendant::spanGrp[@type = 'semantics']/span[@type='sense' and tokenize(@target,' ') = $target]/@corresp/substring-after(.,'http://dbpedia.org/resource/')"/>
                                
                                <!-- 
                                <xsl:variable name="entryID" select="concat($EntrySenseName, '-MIX')"/>
                                 -->
                                
                                <!-- NEED TO ADD @CERT ON CERTAIN ITEMS! -->
                            <entry>
                                <xsl:attribute name="xml:id">
                                    <xsl:value-of select="$EntrySenseName"/>
                                </xsl:attribute>
                                
                                <form type="lemma">
                                    <orth xml:lang="mix">
                                        <!-- modify to make all lowercase -->
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </orth>
                                    <pron xml:lang="mix" notation="ipa"></pron>
                                </form>
                                <gramGrp>
                                    <pos>noun</pos>
                                </gramGrp>

                                <!-- MAJOR ERRORS WHERE <sense @corresp has two values pointed to;
                                This happens where there are 2+ Mixtec forms; currently the script correctly makes separate entries for each, 
                                but the /entry/@xml values don't copy in these cases
                                -->
                                    <sense>
                                        <xsl:variable name="wSense1" 
                                            select="$readDoc/descendant::spanGrp[@type = 'semantics']/span[@type='sense' and tokenize(@target,' ') = $target]/@corresp"/>
                                        
                                        <xsl:attribute name="corresp">
                                            <xsl:value-of select="$wSense1"/>
                                        </xsl:attribute>   
                                        
                                        <!-- old way [...and @target = $target]/note -->
                                        <xsl:variable name="senseNote" 
                                            select="$readDoc/descendant::spanGrp[@type = 'semantics']/span[@type='note' and tokenize(@target,' ') = $target]/note"/>
                                        
                                        <xsl:for-each select="$senseNote">
                                             <xsl:copy-of select="."/>         
                                        </xsl:for-each>

                                        
                                        <usg type="domain" corresp="http://dbpedia.org/resource/Animal">Animal</usg>
                                        <usg type="domain" corresp="http://dbpedia.org/resource/Bird">Bird</usg>
                                        <xr type="hyponymOf">
                                            <ref corresp="#bird" xml:lang="mix">saa</ref>
                                            <ref type="sense" corresp="http://dbpedia.org/resource/Bird"/>
                                        </xr>
                                             
                                        <xsl:if test="parent::seg/*">
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
                                             
                                        
                                        <xsl:for-each select="$wTranslationEn">
                                            <!-- make new sense only if unique...-->
                                            <xsl:message>en: <xsl:value-of select="$distinctSense"/></xsl:message> 
                                            
                                            <cit type="translation">
                                                <form>
                                                    <orth xml:lang="en">
                                                        <xsl:value-of select="$wTranslationEn"/>
                                                    </orth>
                                                </form>
                                            </cit>
                                            </xsl:for-each>
                                            <!-- (BUG: need to allow for multiple spanish terms and "es-MEX" or "es" )-->
                                            
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
                                            
                                            <!-- Problem: where multiple latin items: -->
                                            
                                            
                                            <xsl:for-each select="$wTranslationLat">
                                            <cit type="translation">
                                                <form>
                                                    <orth xml:lang="la">
                                                        <xsl:value-of select="$wTranslationLat"/>
                                                    </orth>
                                                </form>
                                            </cit>         
                                            </xsl:for-each>
               
                                    </sense>
                            </entry>
                            </xsl:for-each>
                            
                            </xsl:for-each>
                        </body>
                    </text>
                </TEI>
   <!--         </xsl:result-document> 
        </xsl:for-each>--> 
    </xsl:template>
</xsl:stylesheet>