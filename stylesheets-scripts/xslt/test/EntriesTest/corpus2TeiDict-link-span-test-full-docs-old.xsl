<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
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
    
    <xsl:param name="input" as="xs:string" select="'L098-tok-mini.xml'"/>
    <xsl:preserve-space elements="*"/>
    
    <!-- read file defined in $input -->
    <xsl:param name="readDoc" select="document($input)"/>
    
    <xsl:template match="/">
        <xsl:message>My file: <xsl:value-of select="document-uri($readDoc)"/></xsl:message>
        
        <xsl:variable name="theRoot" select="."/>
        <xsl:variable name="folderName" select="'EntriesTest'"/>
        <xsl:variable name="allLemmas" select="distinct-values($readDoc/descendant::w[ancestor-or-self::*/@xml:lang='mix'])"/>
        
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>Concordance lexical entry for lemma: <xsl:value-of select="normalize-space(.)"/></title>
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
                            <!--  <xsl:message>coucou: <xsl:value-of select="$allLemmas"/></xsl:message> -->
                            <xsl:for-each select="$allLemmas">
                                <xsl:sort/>              
                     
                                <xsl:for-each select="$readDoc/descendant::w[. = current()]">
                                
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
                                    
                                    <!-- THIS IN PROGRESS: can't match because can't make a variable of an @ value that is multiple strings (with spaces) -->
                                    <xsl:variable name="spanTargetEn"
                                        select="$readDoc/descendant::spanGrp[@type = 'translation']/span[not(@type='S') and @xml:lang='en']/@target"/>
                                    
                                    <xsl:variable name="wIDs" select="tokenize($spanTargetEn,' ')"/>
                                    
                                    
                                
                                <xsl:message>es: <xsl:value-of select="$sTranslationEs"/></xsl:message>
                                
                                <!-- link pointing to w/@xml:id (there are never any existing english translations so <linkGrp> will only point from spanish and mixtec -->
                                <xsl:variable name="linkTranslationEs"
                                    select="$readDoc/descendant::linkGrp[@type = 'translation']/link[tokenize(@target,' ') = $target]"/>                                  
                                <xsl:message>es: <xsl:value-of select="$linkTranslationEs"/></xsl:message>
                                
                                <xsl:variable name="wTranslationEn" 
                                    select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='en' and tokenize(@target,' ') = $target]"/>
                             <!-- 
                             <xsl:message>en: <xsl:value-of select="$wTranslationEn"/></xsl:message>
                                 -->   
                                    <xsl:variable name="wTranslationEs"
                                        select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='es' and tokenize(@target,' ') = $target]"/>
                                    
                                <!--add other languages if needed by copying spanish
                                
                                <xsl:variable name="distinctSense" select="distinct-values($wTranslationEn)"/>    -->  
                                
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
                                    <pos></pos>
                                </gramGrp>
                                
                                <!-- if a //span/@target contains more than one pointer, and one of which = $wID; print all the <w>'s pointed to and get gloss-->
                                <xsl:if test="count($wIDs)>1">
                                <re>
                                    <form type="complexForm">      
                                        <xsl:for-each select="$wID">
                                            <xsl:message>Le résultat: <xsl:value-of select="$readDoc/descendant::w[@xml:id = substring-after(current(),'#')]"/></xsl:message>
                                            <seg>
                                                <xsl:value-of select="$readDoc/descendant::w[@xml:id = substring-after(current(),'#')]"/>
                                            </seg>
                                        </xsl:for-each>
                                        
                                    
                                    </form>
                                </re>
                                </xsl:if>
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
                                        
                                        <xsl:for-each select="$senseNote">
                                             <xsl:copy-of select="."/>         
                                        </xsl:for-each>
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
                                                 
                                            <xsl:for-each select="distinct-values($wTranslationEn)">
                                                <!--  
                                            <xsl:message>en: <xsl:value-of select="$distinctSense"/></xsl:message> 
                                            -->
                                            
                                            <cit type="translation">
                                                <form>
                                                    <orth xml:lang="en">
                                                        <xsl:value-of select="$wTranslationEn"/>
                                                    </orth>
                                                </form>
                                            </cit>
                                            </xsl:for-each>
                                        
                                        <xsl:for-each select="distinct-values($wTranslationEs)">
                                            
                                            <xsl:message>es: <xsl:value-of select="$wTranslationEs"/></xsl:message> 
                                            
                                            <cit type="translation">
                                                <form>
                                                    <orth xml:lang="es">
                                                        <xsl:value-of select="$wTranslationEs"/>
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
                            </xsl:for-each>
                            
                            </xsl:for-each>
                        </body>
                    </text>
                </TEI>
   <!--         </xsl:result-document> 
        </xsl:for-each>--> 
    </xsl:template>
</xsl:stylesheet>