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
    <xsl:template match="//etym[@type='borrowing']">
        <xsl:if test="/cit[@type='etymon']/*/orth[@xml:lang='mix']">
            <form>
                <orth xml:lang="es">
                    <xsl:copy-of select="@*"/>
                    <xsl:value-of select="."/>
                </orth>
            </form> 
        </xsl:if>   
    </xsl:template>
    -->
    
    <xsl:template match="sense/etym[@type='compounding']" priority="1">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template>
        
    </xsl:template>
    
</xsl:stylesheet>