<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <!-- Intercepting the <seg>'s  -original LR-->
    <!--  
    <xsl:template match="seg[@type='S']">
        <annotationBlock>
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
            <spanGrp type="translation" subtype="segmentGrain">
                <span target="#{@xml:id}" xml:lang="en"></span>
                <span target="#{@xml:id}" xml:lang="es"></span>
            </spanGrp>
            <spanGrp type="translation" subtype="wordGrain">
                <xsl:for-each select="w">
                    <span target="#{@xml:id}" xml:lang="en"></span>
                    <span target="#{@xml:id}" xml:lang="es"></span>
                </xsl:for-each>
            </spanGrp>
        </annotationBlock>
    </xsl:template>
    -->
    <xsl:template match="seg[@type='S']"><!-- Need more specific tagging to identify only those <seg>'s with spatial expressions!!-->
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <spanGrp type="spatialSemantics">  
            <span type="trajector" target="#" ana="#TR-"/>
            <span type="landmark" target="#" ana="#LM-"/>
            <span type="frameOfReference" target="#" ana="#-FoR"/>
            <span type="direction" ana="#"/>
            <span type="region" ana="#"/>
            <span type="path" target="#" ana="#-PATH"/><!-- Zlatev: if path defined minimally, requires REGION to profile trajectory, REGION requires LM -->
            <!-- how (whether) to tag spatial indicator (region or directional concept)? (e.g. "nu")? -->
            
        </spanGrp>       
        
    </xsl:template>
    
    
    <!-- Generic copy template -->
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
