<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--  
    <xsl:template match="//seg[@type='S' and not(@xml:lang)]">
        <seg>
            <xsl:attribute name="xml:lang">mix</xsl:attribute>
            <xsl:copy-of select="node()|@*"/>
        </seg>
        
    </xsl:template>
    -->
    
    <xsl:template match="//w[not(@xml:lang)]">
        <w>
            <xsl:attribute name="xml:lang">mix</xsl:attribute>
            <xsl:copy-of select="node()|@*"/>
        </w>
        
    </xsl:template>
    
</xsl:stylesheet>