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
   <!--
    <xsl:template match="f[@name='zsampa']"/>
    
    <xsl:template match="//cit[@type='translation']/quote">
        <form>
            <orth xml:lang="es">
                <xsl:value-of select="."/>
            </orth>
        </form>
        
    </xsl:template>
    
    <xsl:template match="seg[@type='blank']">
        <seg>
            <xsl:copy-of select="@*"/>
            <span><xsl:value-of select="."/></span>
        </seg>
    </xsl:template>
      
   
    <xsl:template match="//s/seg">
        <w>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </w>
    </xsl:template>
    --> 
    <xsl:template match="c">
        <pc>
            <xsl:value-of select="."/>
        </pc>
    </xsl:template>
    <xsl:template match="s">
        <seg type='S'>
            <xsl:copy-of select="node()|@*"/>
        </seg>
    </xsl:template>
    <!-- 
    <xsl:template match="desc">
        <seg type="desc">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </seg>
    </xsl:template>

    <xsl:template match="//cit[@type='translation']/quote">
        <orth>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </orth>
    </xsl:template>
    
    <xsl:template match="//form[@type='lemma']/orth[not(@xml:lang)]">
            <orth xml:lang="mix">
                <xsl:copy-of select="@*"/>
                <xsl:value-of select="."/>
            </orth>
    </xsl:template>
    
    <xsl:template match="//form[@type='lemma']/pron[not(@xml:lang)]">
        <pron xml:lang="mix">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </pron>
    </xsl:template>
    
    
    
    <xsl:template match="//cit[@type='translation' and @xml:lang='en']/orth">
         <form>
            <orth xml:lang="en">
                <xsl:copy-of select="@*  except @xml:lang"/>
                <xsl:value-of select="."/>
            </orth>
        </form>
     
    </xsl:template>
    
    <xsl:template match="//cit[@type='translation' and @xml:lang='es']/orth">
            <form>
                <orth xml:lang="es">
                    <xsl:copy-of select="@*  except @xml:lang"/>
                    <xsl:value-of select="."/>
                </orth>
            </form>
    </xsl:template>
    
    
    
    
    <xsl:template match="//cit[@type='etymon']/orth">
        <form>
            <orth xml:lang="mix">
                <xsl:copy-of select="@*"/>
                <xsl:value-of select="."/>
            </orth>
        </form>
    </xsl:template>
    
    <xsl:template match="aspect">
        <gram type="aspect">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </gram>
    </xsl:template>
     -->
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