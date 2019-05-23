<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml"/>

    <xsl:template match="/">

        <xsl:message>Coucou</xsl:message>
        <!-- Diagnostic: list of forms and number of them -->

        <xsl:variable name="allForms" select="distinct-values(descendant::form[@type = 'lemma']/orth)"/>
        <xsl:variable name="theRoot" select="."/>

        <xsl:message>
            <xsl:for-each select="$allForms">
                <xsl:variable name="theCurrentForm" select="."/>
                <xsl:value-of select="."/> (<xsl:value-of
                    select="count($theRoot/descendant::form[@type = 'lemma']/orth[. = $theCurrentForm])"/>) -
            </xsl:for-each>
        </xsl:message>
        
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="entry[form[@type = 'lemma']/orth = preceding-sibling::entry/form[@type = 'lemma']/orth]">
        <xsl:message>Doublon supprimé: <xsl:value-of select="form[@type = 'lemma']/orth"/></xsl:message>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
