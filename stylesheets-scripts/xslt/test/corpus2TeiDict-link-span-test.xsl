<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <!-- variable for each unique item should be based on english or spanish translation (instead of value of: "distinct-values(descendant::w/@lemma)"  -->
    
    <!-- adapt for multi-token items (what about where I annotated phrases?) -->
    
    <xsl:param name="input" as="xs:string" select="'L155-tok.xml'"/>
    <xsl:preserve-space elements="*"/>
    
    <!-- read file defined in $input -->
    <xsl:param name="readDoc" select="document($input)"/>
    
    <xsl:template match="/">
        <xsl:message>My file: <xsl:value-of select="document-uri($readDoc)"/></xsl:message>
        
        <xsl:variable name="theRoot" select="."/>
        <xsl:variable name="folderName" select="'Entries2'"/>
        <xsl:variable name="allLemmas" select="distinct-values($readDoc/descendant::w[ancestor-or-self::*/@xml:lang='mix'])"/>
        
        

        <!-- will need to define variable for getting translations of full sentences.. (point from <span>/<link> to <seg>) -->
        
        <xsl:message>coucou: <xsl:value-of select="$allLemmas"/></xsl:message>
        <xsl:for-each select="$allLemmas">
            <xsl:sort/>
            <xsl:result-document href="{$folderName}/{.}.xml" method="xml">
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>Concordance lexical entry for lemma: <xsl:value-of select="."/></title>
                            </titleStmt>
                            <publicationStmt><!-- add the document path? -->
                                <xsl:copy-of select="$readDoc/descendant::publicationStmt/distributor"/>
                                <xsl:copy-of select="$readDoc/descendant::publicationStmt/address"/>
                                <xsl:copy-of select="$readDoc/descendant::publicationStmt/availability"/>
                            </publicationStmt>
                            <sourceDesc>
                                <bibl>
                                    <!-- add the document path in attribute -->
                                    <!-- change to only print texts and make output for spanish and english titles -->
                                    <xsl:copy-of select="$readDoc/descendant::titleStmt/title"/>
                                    <!-- 
                                        <xsl:value-of select="$readDoc/descendant::titleStmt/title"  separator=" "/>
                                    -->
                                </bibl>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <entry>
                                <form type="lemma">
                                    <orth xml:lang="mix">
                                        <!-- modify to make all lowercase -->
                                        <xsl:value-of select="."/>
                                    </orth>
                                </form>
                                <xsl:for-each select="$readDoc/descendant::w[@xml:lang='mix'][. = current()]">
                                    
                                    <xsl:variable name="segID" select="parent::seg/@xml:id"/>
                                    
                                    <xsl:variable name="wID" select="@xml:id"/>
                                    
                                    <xsl:variable name="segTarget" as="xs:string" select="concat('#',$segID)"/>
                                    
                                    <xsl:variable name="target" as="xs:string" select="concat('#',$wID)"/>
                                    
                                    
                                    <xsl:variable name="sTranslationEn" select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='en' and @target = $segTarget]"/>
                                    <xsl:message>en: <xsl:value-of select="$sTranslationEn"/></xsl:message>
                                    
                                    <xsl:variable name="sTranslationEs" select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='es' and @target = $segTarget]"/>
                                    <xsl:message>es: <xsl:value-of select="$sTranslationEs"/></xsl:message>
                                    
                                    <!-- link pointing to w/@xml:id (there are never any existing english translations so <linkGrp> will only point from spanish and mixtec -->
                                    <xsl:variable name="linkTranslationEs" select="$readDoc/descendant::link[contains(@target,$target) and not(@type)]"/>
                                    
                                    <xsl:variable name="wTranslationEn" select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='en' and @target = $target]"/>
                                    <!--  <xsl:message>en: <xsl:value-of select="$wTranslationEn"/></xsl:message>-->
                                    
                                    <xsl:variable name="wTranslationEs" select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='es' and @target = $target]"/>
                                    <!--  <xsl:message>es: <xsl:value-of select="$wTranslationEs"/></xsl:message>--> 
                                    
                                    <xsl:variable name="wTranslationLat" select="$readDoc/descendant::spanGrp[@type = 'translation']/span[@xml:lang='la' and @target = $target]"/>
                                    
                                    <xsl:variable name="distinctSense" select="distinct-values($wTranslationEn)"/>     
                                    <sense>
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
                                            
                                            <cit type="translation">
                                                <form>
                                                    <orth xml:lang="es">
                                                        <xsl:value-of select="$linkTranslationEs"/>
                                                    </orth>
                                                </form>
                                            </cit>
                                            
                                            <xsl:if test="span[@xml:lang='la']">
                                            <cit type="translation">
                                                <form>
                                                    <orth xml:lang="la">
                                                        <xsl:value-of select="$wTranslationLat"/>
                                                    </orth>
                                                </form>
                                            </cit>
                                            </xsl:if>
                                            <!-- 
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
                                             -->
                                        </xsl:for-each>
                                    </sense>
                                </xsl:for-each>
                            </entry>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>