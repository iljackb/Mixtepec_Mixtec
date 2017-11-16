<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
   
    <!--<seg xml:id="(^L093-[0-9]{2}-[0-9]{2}-[0-9]{2})"> -->
        <!-- @xml:id="(^L093-[0-9]{2}-[0-9]{2}-[0-9]{2})"-->
    
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

    <!--adds attribute-value pair (@ana="#S") to <seg>'s whose parent node is <p> -->
    <xsl:template match="p/seg">
        <xsl:copy>
            <xsl:copy-of select="@*"/> 
            <xsl:attribute name="ana">#S</xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- adds attribute-value pair (@ana="#LexItm") to <seg>'s whose parent node is <seg> (above)  -->
    <xsl:template match="seg/seg">
        <xsl:copy>
            <xsl:copy-of select="@*"/> 
            <xsl:attribute name="ana">#LexItm</xsl:attribute>
            <xsl:value-of select="node()"/>
        </xsl:copy>
       
    </xsl:template>

    <!-- desired output: <seg xml:id="(^L093-[0-9]{2}-[0-9]{2}-[0-9]{2})" ana="#LexItm">-->
 
</xsl:stylesheet>

<!-- next step, output: value of <seg xml:id="(^L093-[0-9]{2}-[0-9]{2}-[0-9]{2})"> to dictionary entry: /entry/form @type="lemma"/orth/ -->