<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <xsl:strip-space elements="*"/>

    <xsl:param name="input" as="xs:string" select="'QNTY_nobody_01_02_03_spkrTS.txt'"/>

    <xsl:param name="text-encoding" as="xs:string" select="'UTF-16'"/>
    <!-- utf-8 ISO-8859-1 and it works well. I think it's for European characters, which is fine. I still don't know why UTF-16 -->

    <!-- Reading the text file $input into the string variable $input-text -->
    <xsl:variable name="input-text" as="xs:string" select="unparsed-text($input, $text-encoding)"/>

    <!-- Trouble shooting with: http://rishida.net/tools/conversion/ -->

    <!-- splitting the input into lines -->
    <xsl:variable name="lines" as="xs:string*" select="tokenize($input-text, '\r?\n')"/>

    <xsl:variable name="teiHeader">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>Mixtepec-Mixtec TEI output for Praat TextGrid Transcriptions</title>
                    <respStmt>
                        <name>Jack T. Bowers</name>
                        <resp>Transcription</resp>
                        <resp>Data Modeling</resp>
                        <resp>Speaker Consultation</resp>
                    </respStmt>
                </titleStmt>
                <publicationStmt>
                    <p>Publication Information</p>
                </publicationStmt>
                <sourceDesc>
                    <p>This file was converted from the source file <ptr target="{$input}"/> which was extracted from the Praat TextGrid transcriptions of the speech file <ptr target="{substring-before($input, '.txt')}.wav"/></p>
                </sourceDesc>
            </fileDesc>
        </teiHeader>
    </xsl:variable>
    <!-- TEST FOR GIT BRANCHING -->

    <xsl:variable name="lines-into-tabs" as="element()*">
        <xsl:for-each select="$lines[. != '']">
            <xsl:variable name="lpos" select="position()"/>
            <xsl:if test="not(starts-with(normalize-space(.), 'tmin'))">
                <line>
                    <xsl:for-each select="tokenize(., '\t')">
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
                <xsl:sort
                    select="
                        if (tier eq 'Tokens') then
                            1
                        else
                            if (tier eq 'Orth') then
                                2
                            else
                                3"/>
                <!-- <Tokens start="3.76" end="5.33">3</Tokens>	  -->
                <xsl:element name="{tier}">
                    <xsl:attribute name="start" select="start"/>
                    <xsl:attribute name="end" select="end"/>
                    <xsl:value-of select="text"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="{replace($input,'\.txt$','.xml')}">
            <TEI>
                <xsl:sequence select="$teiHeader"/>
                <!--<xsl:sequence select="$lines-into-tabs"/>-->
                <text>
                    <body>
                        <xsl:for-each-group select="$praat-parsed" group-starting-with="start">
                            <xsl:variable name="whens" as="element()*">
                                <xsl:for-each
                                    select="distinct-values((current-group()[self::Orth | self::Gloss | self::Vowels | self::Tones | self::Consonants | self::Gld-Nas-Lat]/@start, current-group()[self::Gloss]/@end))">
                                    <when xml:id="T{position()}" interval="{.}"/>
                                </xsl:for-each>
                            </xsl:variable>
                            <timeline>
                                <xsl:sequence select="$whens"/>
                            </timeline>

                            <xsl:for-each-group select="$praat-parsed" group-starting-with="Tokens">
                                <!-- NEED TO RE-ESTABLISH THE CONNECTION TO VALUES OF 'when' FOR ATTRIBUTES OF <w> -->
                                <annotationBlock>

                                    <u n="{current-group()[1]}"><!-- eventually this should have the @who filled in with speakers initials -->
                                        <xsl:copy-of select="current-group()[1]/(@start, @end)"/>
                                        <seg function="utterance" notation="orth">
                                            <xsl:for-each select="current-group()/self::Orth">
                                                <xsl:variable name="start" select="@start"/>
                                                <w synch="#{$whens[@interval = $start]/@xml:id}">
                                                    <xsl:value-of select="."/>
                                                </w>
                                            </xsl:for-each>
                                        </seg>
                                        <seg function="utterance" notation="ipa">
                                            <xsl:for-each-group select="current-group()[not(self::Tokens)]" group-starting-with="Orth">
                                                <xsl:variable name="start" select="current-group()[1]/@start"/>
                                                <w synch="#{$whens[@interval = $start]/@xml:id}">
                                                    <xsl:for-each select="current-group()[self::Vowels | self::Tones | self::Consonants | self::Gld-Nas-Lat]">
                                                        <c>
                                                            <xsl:if test="self::Tones">
                                                                <xsl:attribute name="function">tone</xsl:attribute>
                                                            </xsl:if>
                                                            <xsl:value-of select="."/>
                                                        </c>
                                                    </xsl:for-each>
                                                </w>
                                            </xsl:for-each-group>
                                        </seg>
                                    </u>
                                    <spanGrp>
                                        <xsl:for-each select="current-group()/self::Gloss">
                                            <xsl:variable name="start" select="@start"/>
                                            <xsl:variable name="end" select="@end"/>
                                            <span from="#{$whens[@interval = $start]/@xml:id}" to="#{$whens[@interval = $end]/@xml:id}">
                                                <xsl:value-of select="."/>
                                            </span>
                                        </xsl:for-each>
                                    </spanGrp>
                                </annotationBlock>
                            </xsl:for-each-group>
                        </xsl:for-each-group>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
