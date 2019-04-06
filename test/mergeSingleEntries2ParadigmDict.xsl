<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="inputDocs" select="collection('?select=*.xml')"/>
    <xsl:param name="readDoc" select="document($inputDocs)"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="folderName" select="'Entries'"/>
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
                        <listBibl xml:id="Pastor-Azcona">
                            <head>Pastor and Azcona Publications</head>
                            <bibl xml:id="paster-2004a">
                                <author>Paster, M.</author>, <date>2004</date>. <title>A
                                    phonological sketch of the Yucunany Mixtepec Mixtec person
                                    marking</title>. <editor>In Lea Harper and Carmen Jany
                                        (Ed.)</editor>, Proceedings of Conference on Oto-Manguean and
                                Oaxacan Languages (COOL). UC Berkeley, Berkeley.</bibl>
                            <bibl xml:id="paster-2004b">
                                <author>Paster, M.</author>, <date>2004</date>. <title>A
                                    phonological sketch of the Yucanani Mixtepec dialect of
                                    Mixtec</title>. <editor>In Lea Harper and Carmen Jany
                                        (Ed.)</editor>, Proceedings of the 7th Annual Workshop on
                                American Indian Languages (pp. 61-76). UC Santa Barbara.</bibl>
                            <bibl xml:id="paster-azcona-2004a">
                                <author>Paster, Mary</author> and <author>Beam de Azcona,
                                    Rosemary</author>. <date>2004a</date>. <title>Aspects of tone in
                                        Yucunany Mixtepec Mixtec</title>. <editor>In Lea Harper and
                                            Carmen Jany (Ed.)</editor>, Proceedings of the 7th Annual
                                Workshop on American Indian Languages (pp. 61-76). UC Santa
                                Barbara.</bibl>
                            <bibl xml:id="paster-azcona-2004b">
                                <author>Paster, M.</author> and <author>Beam de Azcona,
                                    Rosemary</author>. <date>2004b</date>. <title>Aspects of tone in
                                        the Yucunany dialect of Mixtepec Mixtec</title>. Paper presented
                                at the Conference on Otomanguean and Oaxacan Languages, University
                                ofCalifornia, Berkeley.</bibl>
                            <bibl xml:id="paster-2005">
                                <author>Paster, M.</author>
                                <date>2005</date>. <title>Tone Rules in Yucanani Mixtepec
                                    Mixtec</title>. SSILA meeting (p. 13). Oakland: SSILA.</bibl>
                            <bibl xml:id="paster-2007">
                                <author>Paster, M.</author>, <date>2007</date>. <title>The origin of
                                    (Apparent) Avoidance of homophony in Yucanany Mixtepec dialect
                                    of Mixtec</title>., Proceedings of American Indian Languages
                                (August, 17). UCLA.</bibl>
                        </listBibl>
                        <bibl xml:id="Pike-Ibach-MIX-1978">
                            <author>Pike, Eunice V.</author> and <author>Thomas Ibach</author>.
                            <date>1978</date>. <title>The phonology of the Mixtepec dialect of
                                Mixtec</title>. Pp. 271-285 in Mohammed Jazayery, Edgar C. Polomé,
                            and Werner Winter, eds. Linguistic and Literary Studies in Honor of
                            Archibald A. Hill, Volume 2: Descriptive Linguistics. The Hague:
                            Mouton.</bibl>
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
