<?xml version="1.0" encoding="UTF-8"?>
	
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"	
    xmlns:xs="http://www.w3.org/2001/XMLSchema"   
    xmlns:tei="http://www.tei-c.org/ns/1.0"    	
    xmlns="http://www.tei-c.org/ns/1.0"    	
    exclude-result-prefixes="#all"   	
    version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">	
        	
    <xsl:output method="xml" indent="yes"/>
	
    <xsl:template match="node() | @*">      
        <xsl:copy>           
            <xsl:apply-templates select="node() | @*"/>     
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="@ana[.='#LexItm']">
            <xsl:attribute name="type">
                <xsl:text>LexItem</xsl:text>
            </xsl:attribute>  
    </xsl:template>
    
    <xsl:template match="@style[.='orth']">
        <xsl:attribute name="notation">
            <xsl:text>orth</xsl:text>
        </xsl:attribute>  
    </xsl:template>
    
    <xsl:template match="@ana[.='#S']">
        <xsl:attribute name="type">
            <xsl:text>S</xsl:text>
        </xsl:attribute>  
    </xsl:template>
    
    <xsl:template match="c">
        <xsl:analyze-string select="." regex="(\.{{4}})|(\.{{1}})|!|,|¡|:|;|\-|—|¿|\?|&quot;">
            <xsl:matching-substring>
                <pc>
                    <xsl:value-of select="."/>
                </pc>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <c>
                    <xsl:value-of select="."/>   
                </c>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
    
</xsl:stylesheet>
