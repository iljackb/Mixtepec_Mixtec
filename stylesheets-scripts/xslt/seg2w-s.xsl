<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <!-- 
    <xsl:template match="seg[not(@type='blank')]">
        <w>
            <xsl:copy-of select="@* "/>
            <xsl:value-of select="."/>
        </w>
    </xsl:template>
    
    
     -->
    <xsl:template match="seg[@ana='#LexItm']">
        <w>
            <xsl:copy-of select="@* except(@ana)"/>
            <xsl:value-of select="."/>
        </w>
    </xsl:template>
        
      <!--
    <xsl:template match="seg[@type='S']">
        <s>
            <xsl:copy-of select="@* except(@type)"/>
            <xsl:value-of select="."/>
        </s>
    </xsl:template>
    -->

</xsl:stylesheet>