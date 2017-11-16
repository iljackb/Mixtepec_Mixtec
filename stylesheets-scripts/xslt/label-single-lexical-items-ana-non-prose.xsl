<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <!-- For labeling lexical items in documents in which there is no prose -->
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <xsl:template match="/"> <!-- <xsl:template match="/ | node() |@*">-->
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy/>  
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!--adds attribute-value pair (@ana="#LexItm") to <seg>'s; Defines vocabulary items in document -->
    <xsl:template match="p/seg">
        <xsl:copy>
            <xsl:copy-of select="@*"/> 
            <xsl:attribute name="ana">#LexItm</xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>