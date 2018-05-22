<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <!-- 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http: //www.tei-c.org/ns/1.0"
    -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <!--  
    <xsl:template match="u">
        <u xml:id="{generate-id(.)}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </u>
    </xsl:template>
    -->
    <xsl:template match="seg">
        <seg xml:id="{generate-id(.)}">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="xml:lang">mix</xsl:attribute>
           <!--  <xsl:copy-of select="@*[not(name()='xml:id')]"/>
               -->
            <xsl:apply-templates select="node()"/>
        </seg>
    </xsl:template>
    
    <xsl:template match="s">
        <s xml:id="{generate-id(.)}">
            <!--  <xsl:copy-of select="@*"/>-->
            <xsl:apply-templates select="node()"/>
        </s>
    </xsl:template>
    
    <xsl:template match="w">
        <w xml:id="{generate-id(.)}">
            <xsl:copy-of select="@*"/>
            <!--  <xsl:copy-of select="@*[not(name()='xml:id')]"/>
               -->
            <xsl:apply-templates select="node()"/>
        </w>
    </xsl:template>
  <!--    
    <xsl:template match="c">
        <c xml:id="{generate-id(.)}">
           <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </c>
    </xsl:template>
     -->

    
    
    <!--  
    <xsl:template match="item">
        <xsl:variable name="fbnum" select="column[@name='fragebogen_id']/text()"/>
        <xsl:variable name="fragenum" select="column[@name='nummer']/text()"/>
        <xsl:variable name="seg-index" select="count(/seg)"/>
        <xsl:variable name="seg-id" select="concat($fbnum,$fragenum,generate-id())"/>
        
        
        <xsl:for-each-group select="column" group-by="seg">
            <xsl:sort select="count(current-group())" order="ascending"/>
            <seg>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="$seg-id"/>
                </xsl:attribute>
                <xsl:apply-templates select="node()"/>  
            </xsl:copy>
            </seg>
        </xsl:for-each-group>

    </xsl:template>
    -->
    <!--  
    <xsl:template match="column/seg">
        <xsl:variable name="delimiter" select="','"/>
        
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <pc>
                <xsl:value-of select="$delimiter"/> 
            </pc>

            <xsl:apply-templates select="node()"/>  
        </xsl:copy>
        
    </xsl:template>
   -->
    <!-- works-->
    <!-- 
    <xsl:template match="column/seg">
        <seg xml:id="{generate-id(.)}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </seg>
    </xsl:template>
     -->
 <!--  
    <xsl:template match="item">
        <xsl:variable name="fbnum" select="column[@name='fragebogen_id']/text()"/>
        <xsl:variable name="fragenum" select="column[@name='nummer']/text()"/>
        <xsl:variable name="id-prefix">frage</xsl:variable>
        <xsl:variable name="fb-frage" select="concat($id-prefix,$fbnum,$fragenum)"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="$fb-frage"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>  
        </xsl:copy>
    </xsl:template>
-->
        <!--  
    <xsl:template match="item">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                    <xsl:attribute name="n">
                        <xsl:value-of select="column[@name='nummer']/text()"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="node()"/>  
            </xsl:copy>
    </xsl:template>

    <xsl:template match="*//column[@name='id']"/>
    
    <xsl:template match="*//seg[text()='NULL']"/>
    
    <xsl:template match="*//column[@name='kurzfrage']">
        <xsl:if test="not[text()]">
            <xsl:apply-templates/>
        </xsl:if>

    </xsl:template>    
    -->
</xsl:stylesheet>