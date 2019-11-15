<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- ADD FOR WHERE ALREADY A <spanGrp> with only translations with or w/o <u>-->
    
    <!-- ADD FOR WHERE NO <spanGrp typ="annotations"> and no <u> -->
    
    
    <!-- for where no @sameAs
    
    <xsl:template match="//u/descendant::seg[@notation='ipa']">
        <xsl:variable name="timeSpan">
            <xsl:value-of select="//w/@synch"/>
        </xsl:variable>
        
    </xsl:template>
    
 -->
    <!-- Works for utterance files -->
    <xsl:template match="//u">
        <xsl:for-each select=".">         
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
                        <span type="gram" target="#{$orthID}" ana="#"/>  
                    </xsl:for-each>
                <!-- MODIFY TO CHECK FOR PRE-EXISTING ! -->
                <xsl:for-each select="seg[@notation='orth']/w">
                    <xsl:variable name="wID">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:variable>
                    <span type="translation" target="#{$wID}" xml:lang="en"></span>
                    <span type="translation" target="#{$wID}" xml:lang="es"></span>
                    <span type="gram" target="#{$wID}" ana="#"><gloss type="igt"></gloss></span>            
                </xsl:for-each>
                
                <xsl:for-each select="seg[@notation='ipa']/w/m">
                    <xsl:variable name="mID">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:variable>
                    <span type="gram" subtype="" target="#{$mID}" ana="#"/>
                </xsl:for-each>
            </spanGrp>     
        </xsl:for-each>           
    </xsl:template>
      
      <xsl:template match="span[@type='translation' and @xml:lang='es']">
          <xsl:for-each select=".">         
              <xsl:copy>
                  <xsl:apply-templates select="@* | node()"/>
              </xsl:copy>  
                  <xsl:variable name="targetID">
                      <xsl:value-of select="@target"/>
                  </xsl:variable> 
              <span type="gram" target="{$targetID}" ana="#"><gloss type="igt"></gloss></span> 
              
          </xsl:for-each>
      </xsl:template>

<!-- NEED TO ADD WHERE THERE ARE <w>'s with no <span type="translation"> -->

<!-- 
    for each //seg[@type='S'] which has following-sibling::spanGrp[@type='annotations']
    
    for each //seg[@type='S']/w/@xml:id which is not pointed to in //spanGrp[@type='annotations']/span
     >add <span type="gram" target="{$targetID}" ana="#"><gloss type="igt"></gloss></span>
    
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

    <!-- Generic copy template -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>
