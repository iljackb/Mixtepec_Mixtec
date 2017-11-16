<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
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
    <!-- Goal 1: search all <seg @ana="#S">; if the value of the 1st child element is "¿", add tag "#Q" to @ana="#S"; desired result(<seg @ana="#S #Q">) -->
    
    <xsl:template match="seg">
       
    </xsl:template>
    
    <!-- Goal 2: if the value of the LAST child element is ".", add tag "#Ans" to @ana="#S"; desired result(<seg @ana="#S #Ans">) -->
    
</xsl:stylesheet>