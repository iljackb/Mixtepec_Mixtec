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
    
    <xsl:template match="//cit[@type='translation']/quote">
        <orth>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </orth>
    </xsl:template>
    
    <xsl:template match="aspect">
        <gram type="aspect">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </gram>
    </xsl:template>
    
    <!--  
    <xsl:template match="//etym">
        <etym>
            <xsl:copy-of select="@*"/>
            <cit type="etymon">
                <xsl:if test="descendant::orth">
                    <orth>
                        <xsl:value-of select="."/>
                    </orth>
                </xsl:if>
                <xsl:if test="descendant::pron">
                    <pron>
                        <xsl:copy-of select="pron[@*]"/>
                        <xsl:value-of select="."/>
                    </pron>
                </xsl:if>
            </cit>
        </etym>
    </xsl:template>
    
    -->
    <!-- 
    <xsl:template match="seg[not(@type='blank')]">
        <w>
            <xsl:copy-of select="@* "/>
            <xsl:value-of select="."/>
        </w>
    </xsl:template>
    
    
     -->
    <!--  
    <xsl:template match="//seg[@type='LexItem']">
        <w>   
            <xsl:copy-of select="@* except(@type)"/>
            <xsl:value-of select="."/>
        </w>
    </xsl:template>
  -->
  <!-- 
    <xsl:template match="//seg[@type='IGT']" priority="1">
        <seg notation="igt">   
            <xsl:copy-of select="node()|@*"/>
        </seg>
    </xsl:template>
   
    <xsl:template match="//seg[@type='IGT']/w">
        <gloss>   
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </gloss>
    </xsl:template>
    
    <xsl:template match="//lbl">
        <desc>   
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </desc>
    </xsl:template>
        
    <xsl:template match="//cit[@type='etymon' or @type='descendent']/oRef">
        <form>   
            <orth>
                <xsl:copy-of select="@*"/>
                <xsl:value-of select="."/>     
            </orth>
        </form>
    </xsl:template>
    
    <xsl:template match="//cit[@type='etymon' or @type='descendent']/pRef">
        <form>   
            <pron>
                <xsl:copy-of select="@*"/>
                <xsl:value-of select="."/>     
            </pron>
        </form>
    </xsl:template>-->
      <!--
    <xsl:template match="seg[@type='S']">
        <s>
            <xsl:copy-of select="@* except(@type)"/>
            <xsl:value-of select="."/>
        </s>
    </xsl:template>
    -->

</xsl:stylesheet>