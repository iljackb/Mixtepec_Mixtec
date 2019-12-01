<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>



    <xsl:variable name="sourceFile" as="xs:string" select="tokenize(base-uri(.), '/')[last()]"/>

    <xsl:variable name="soundFile" as="xs:string"
        select="concat(substring-before($sourceFile, '.xml'), '.wav')"/>

    <xsl:template match="body/*"/>

    <xsl:template match="body">
        <body><ab>This is a metadata record of this spoken language content.</ab></body>
    </xsl:template>

<!-- may want to change my role in headed as there is no transcription -->

<xsl:template match="listPrefixDef"/>

    <xsl:template match="sourceDesc/p">
        <xsl:copy>This file is a metadata record for the utterance in: <xsl:apply-templates
                select="media"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="publicationStmt">
        <publicationStmt>
            <authority>
                <name>Jack Bowers</name>
                <name>Jeremías Salazar</name>
                <name>Tisu'ma Salazar</name>
            </authority>
            <availability>
                <licence>CC-BY</licence>
            </availability>
        </publicationStmt>
    </xsl:template>

    <xsl:template match="title">
        <title>Metadata record for: <xsl:value-of select="$soundFile"/></title>
    </xsl:template>

</xsl:stylesheet>
