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
    
    <xsl:template match="//seg[@type='S']">
        <s xml:id="{generate-id(.)}" type="interrogative">
            <xsl:apply-templates select="node()"/>
        </s>
        <spanGrp type="translation">
            <span target="#" xml:lang="en">Which animal's foot is this?</span>
            <span target="#" xml:lang="es">¿De qué animales son las patas?</span>        
        </spanGrp>
    </xsl:template>
    
    <xsl:template match="//p/w">
        <s xml:id="{generate-id(.)}" type="declarative">
            <w xml:id="{generate-id(.)}">
                <xsl:value-of select="."/>
            </w>
        </s>
        <spanGrp type="translation">
            <span target="#" xml:lang="en"></span>
            <span target="#" xml:lang="es"></span>        
        </spanGrp>
    </xsl:template>
    
</xsl:stylesheet>