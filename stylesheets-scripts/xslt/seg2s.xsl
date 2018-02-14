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
    
    <!-- seg2s -->
    <!--  
    <xsl:template match="p/seg[@type='S']">
        <s xml:id="{generate-id(.)}" type="multiWordExpression">
            <xsl:copy-of select="@xml:lang"/>
            <xsl:apply-templates select="node()"/>
        </s>     
    </xsl:template>
    -->
    
    <!-- s2seg -->
    <xsl:template match="p/s">
        <seg type="S">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </seg>     
    </xsl:template>
    
    <xsl:template match="//seg/seg[@type='LexItem']">
        <w xml:id="{generate-id(.)}">
            <!-- <xsl:copy-of select="@* except(@ana)"/> -->
            <xsl:value-of select="."/>
        </w>
    </xsl:template>
    
    <!-- 
    <xsl:template match="//p/w">
        <s xml:id="{generate-id(.)}" type="declarative">
            <w xml:id="{generate-id(.)}">
                <xsl:value-of select="."/>
            </w>
        </s>
    </xsl:template>
     -->
</xsl:stylesheet>