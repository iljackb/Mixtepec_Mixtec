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
    <xsl:template match="u/seg[@type]">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
                           
            <spanGrp type="annotations">  
                <span type="translation" target="#{@xml:id}" xml:lang="en" ana="#"></span>
                <span type="translation" target="#{@xml:id}" xml:lang="es" ana="#"></span>
                
                
                <xsl:for-each select="w">
                    <span type="translation" target="#{@xml:id}" xml:lang="en"></span>
                    <span type="translation" target="#{@xml:id}" xml:lang="es"></span>
                </xsl:for-each>
            </spanGrp>       

    </xsl:template>

    <xsl:template match="spanGrp[@type='annotations']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:for-each select="span[@type='translation' and @xml:lang='es']">
            <xsl:copy>
                <xsl:attribute name="type">gram</xsl:attribute>
                <xsl:attribute name="ana"></xsl:attribute>
                <xsl:copy-of select="@*  except @type and @ana"/>

            </xsl:copy>
        </xsl:for-each>
    </xsl:template>   -->
    <!--  
    <xsl:template match="seg" priority="1">
        <seg xml:id="{generate-id(.)}">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="xml:lang">mix</xsl:attribute>

            <xsl:apply-templates select="node()"/>
        </seg>
    </xsl:template>
    
    
    <xsl:template match="w" priority="1">
        <w xml:id="{generate-id(.)}">
            <xsl:copy-of select="@*"/>

            <xsl:apply-templates select="node()"/>
        </w>
    </xsl:template>
    
    -->
    
    <xsl:template match="annotationBlock">
        <xsl:for-each select="//u">
            
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
            
            <spanGrp type="annotations">  
                    <xsl:for-each select="seg[@type='S' and @notation='orth']">    
                        <xsl:variable name="orthID">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:variable>                   
                        <span type="translation" target="#{$orthID}" xml:lang="en" ana="#S"></span>
                        <span type="translation" target="#{$orthID}" xml:lang="es" ana="#S"></span>       
                    </xsl:for-each>
                
                <xsl:for-each select="seg[@notation='orth']/w">
                    <xsl:variable name="wID">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:variable>
                    <span type="translation" target="#{$wID}" xml:lang="en"></span>
                    <span type="translation" target="#{$wID}" xml:lang="es"></span>
                    <span type="gram" target="#{$wID}" ana="#"/>            
                </xsl:for-each>
                
                <xsl:for-each select="seg[@notation='ipa']/w/m">
                    <xsl:variable name="mID">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:variable>
                    <span type="gram" target="#{$mID}" ana="#"/>
                </xsl:for-each>
            </spanGrp>     
        </xsl:for-each>
            
    </xsl:template>
      

            
    <!--  
    <xsl:template match="//u[descendant::seg[@notation]]">
        <xsl:variable name="orthID">
            <xsl:value-of select="//u/seg[@notation='orth']/@xml:id"/>
        </xsl:variable>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <spanGrp type="annotations">  
            <xsl:if test="//u/seg[@type='S']">
                <span target="#{$orthID}" xml:lang="en"></span>
                <span target="#{$orthID}" xml:lang="es"></span>       
            </xsl:if>

            <xsl:for-each select="w">
                <span target="#{@xml:id}" xml:lang="en"></span>
                <span target="#{@xml:id}" xml:lang="es"></span>
            </xsl:for-each>
        </spanGrp>       
        
    </xsl:template>
-->
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
    
<!-- for content in a table /cell
    <xsl:template match="cell/seg[@xml:lang='mix']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        
        
        <spanGrp type="translation">     
            <span target="#{@xml:id}" xml:lang="en"></span>
            <xsl:for-each select="w">
                <span target="#{@xml:id}" xml:lang="en"></span>
            </xsl:for-each>
        </spanGrp>       
        
    </xsl:template>
  -->
    <!-- Generic copy template -->

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
