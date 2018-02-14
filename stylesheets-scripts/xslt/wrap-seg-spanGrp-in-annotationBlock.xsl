<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- 
    <xsl:key name="group" match="seg[@type='S'][following-sibling::spanGrp]" use=""/>
     -->
    
    <xsl:template match="seg[@type = 'S' and parent::p and following-sibling::spanGrp]">
        <annotationBlock>
            <xsl:for-each-group select="seg and spanGrp" group-adjacent="following-sibling::node()[spanGrp]">
              <xsl:apply-templates/>
            </xsl:for-each-group>
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>         
        </annotationBlock>
    </xsl:template>

    <xsl:template match="spanGrp[preceding-sibling::seg]">
        <xsl:copy>          
               <xsl:apply-templates/>
        </xsl:copy>

    </xsl:template>
     
</xsl:stylesheet>