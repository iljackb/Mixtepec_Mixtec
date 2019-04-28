<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="inputDocs" select="collection('?select=*.xml')"/>
    <xsl:param name="readDoc" select="document($inputDocs)"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="folderName" select="'EntriesTest'"/>
        <xsl:variable name="allEntries" select="$inputDocs//entry"/>
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Mixtepec Mixtec Paradigms Entries</title>
                        <respStmt>
                            <resp>Editor</resp>
                            <name>Jack Bowers</name>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <p>version: <date>2019-04-06</date></p>
                    </publicationStmt>
                    <sourceDesc>
                            <bibl>
                                <editor>Gisela Beckmann</editor>, <date>2014</date>. <title xml:lang="mix">Kue Kiti Ntava</title>
                            </bibl>
                    </sourceDesc>
                    <!-- add the document path in attribute -->
                    <!-- change to only print texts and make output for spanish and english titles -->
                    <!-- 
                                        <xsl:value-of select="$readDoc/descendant::titleStmt/title"  separator=" "/>
                                    -->
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
