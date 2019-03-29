<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="inputDocs" select="collection('?select=*.xml')"/>  
    <xsl:param name="readDoc" select="document($inputDocs)"/>
    
    <xsl:template match="/">   
        <xsl:message>My file: <xsl:value-of select="document-uri($readDoc)"/></xsl:message>
        <xsl:variable name="folderName" select="'Entries'"/>
        <xsl:variable name="allEntries" select="$inputDocs//entry"/>
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>Merged TEI single entry files test</title>
                            </titleStmt>
                            <publicationStmt>
                                <!-- add the document path? -->

                            </publicationStmt>
                            <sourceDesc>
                                <bibl>
                                    <!-- add the document path in attribute -->
                                    <!-- change to only print texts and make output for spanish and english titles -->
                                    <!-- 
                                        <xsl:value-of select="$readDoc/descendant::titleStmt/title"  separator=" "/>
                                    -->
                                </bibl>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <xsl:for-each select="$allEntries">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                            
                            <!-- ALSO IN COPYING EXAMPLE SENTENCES, COPY SOURCE FILES (NAME OR IN POINTER!!) -->
                            <!-- 
                            <xsl:for-each select="$inputDocs">
                                <xsl:apply-templates select="entry"/>
                            </xsl:for-each>
                             -->
                        </body>
                    </text>
                </TEI>
        <!--  
            </xsl:result-document>
            -->
        
    </xsl:template>
</xsl:stylesheet>