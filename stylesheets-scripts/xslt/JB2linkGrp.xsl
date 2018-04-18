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
    <!-- standard document format -->
    <!--  
    <xsl:template match="seg[@type='S']">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
            <spanGrp type="translation">  
                    <span target="#{@xml:id}" xml:lang="en"></span>
                    <span target="#{@xml:id}" xml:lang="es"></span>
                
                
                <xsl:for-each select="w">
                    <span target="#{@xml:id}" xml:lang="en"></span>
                    <span target="#{@xml:id}" xml:lang="es"></span>
                </xsl:for-each>
            </spanGrp>       
        
    </xsl:template>-->
    
    <!-- For content in //list/item structures with dual (spanish-mixtec) content -->
    <!--  
    <xsl:template match="item">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        
        <linkGrp type="translation">         
            <xsl:for-each select="w">
                <link target="#{@xml:id}"/>
            </xsl:for-each>
        </linkGrp>       
  
        <spanGrp type="translation">         
            <xsl:for-each select="w[@xml:lang='mix']">
                <span target="#{@xml:id}" xml:lang="en"></span>
            </xsl:for-each>
        </spanGrp>       
        
    </xsl:template>
-->
    <!-- For content in //list/item structures with just mixtec content
    <xsl:template match="item">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        
        
        <spanGrp type="translation">         
            <xsl:for-each select="w">
                <span target="#{@xml:id}" xml:lang="en"></span>
            </xsl:for-each>
        </spanGrp>       
        
    </xsl:template>
     -->
    
    <!-- for content in a table /cell  -->
    <xsl:template match="cell/seg[@xml:lang='es']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        
        
        <linkGrp type="translation">     
            <link target="#{@xml:id}"/>
            <xsl:for-each select="w">
                <link target="#{@xml:id}"/>
            </xsl:for-each>
        </linkGrp>       
        
    </xsl:template>
    
    <!-- Generic copy template -->
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
