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
    
    <!-- for each <w> if not a <span> @target containing the xml:id; add (for both english and spanish) into spanGrp (ASSUMES THERE IS A <spanGrp type="translation" ALREADY)  -->
    
    <xsl:template match="//s/spanGrp[@type='translation']">
        
        <!-- for each <w> in -->
    
    </xsl:template>
    
</xsl:stylesheet>