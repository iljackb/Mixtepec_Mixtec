<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        
        <xsl:for-each select="TEI">
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
        <xsl:copy>
            <xsl:apply-templates select="entry"/>
            <xsl:apply-templates select="document('a.xml')/*/entry"/>
            <xsl:apply-templates select="document('Amigo.xml')/*/entry"/>
        </xsl:copy>
                </body>
            </text>
        </TEI>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>