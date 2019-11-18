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
    <xsl:template match="span[@xml:lang and not(@type)]">  
        <xsl:copy>
            <xsl:copy-of select="@* "/>
            <xsl:attribute name="type">translation</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
  
    <xsl:template match="span[@type='S']">  
        <xsl:copy>
            <xsl:attribute name="ana">#S</xsl:attribute>
            <xsl:copy-of select="@*  except @type"/>
            <xsl:attribute name="type">translation</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
  
 
    <xsl:template match="spanGrp/@type[.='translation']">
        <xsl:attribute name="type">annotations</xsl:attribute>
    </xsl:template>
      --> 
    
    <!-- 
   <xsl:template match="linkGrp[@type='translation']/link" priority="1">  
       <xsl:copy>
           <xsl:copy-of select="@* "/>
           <xsl:attribute name="type">translation</xsl:attribute>
           <xsl:value-of select="."/>
       </xsl:copy>
   </xsl:template>
   
    <xsl:template match="linkGrp[@type='IGT']/link" priority="1">  
        <xsl:copy>
            <xsl:copy-of select="@* "/>
            <xsl:attribute name="type">igt</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="seg/@type[.='IGT']">
        <xsl:attribute name="type">S</xsl:attribute>
        <xsl:attribute name="notation">igt</xsl:attribute>
    </xsl:template>
-->   
    <xsl:template match="linkGrp/@type[.='translation']">  
        <xsl:attribute name="type">annotations</xsl:attribute>
    </xsl:template>
    
    <xsl:template match="linkGrp/@type[.='IGT']">  
        <xsl:attribute name="type">annotations</xsl:attribute>
    </xsl:template>
    
    <xsl:template match="gloss">  
        <xsl:copy>
            <xsl:copy-of select="@* "/>
            <xsl:attribute name="type">igt</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
   <!--  
  
    <xsl:template match="//spanGrp[@type='gram']/span">  
        <xsl:copy>
            <xsl:copy-of select="@*  except @type"/>
            <xsl:attribute name="type">gram</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
   
    <xsl:template match="span[@type='sentence']">  
        <xsl:copy>
            <xsl:attribute name="ana">#S</xsl:attribute>
            <xsl:copy-of select="@*  except @type"/>
            <xsl:attribute name="type">translation</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="span[@type='inflected']">
        <xsl:copy>
            <xsl:attribute name="ana">#INFL</xsl:attribute>
            <xsl:copy-of select="@*  except @type"/>
            <xsl:attribute name="type">translation</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
         
    <xsl:template match="span[@type='phrase']">
        <xsl:copy>
            <xsl:attribute name="ana">#PHRS</xsl:attribute>
            <xsl:copy-of select="@*  except @type"/>
            <xsl:attribute name="type">translation</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="span[@type='compound']">
        <xsl:copy>
            <xsl:attribute name="ana">#CMPND</xsl:attribute>
            <xsl:copy-of select="@*  except @type"/>
            <xsl:attribute name="type">translation</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
  
    
  
    <xsl:template match="span/@type[.='S']">
        <xsl:attribute name="type">sentence</xsl:attribute>
    </xsl:template>
    

  
    
    <xsl:variable name="spkrInit">
        <xsl:value-of select="//respStmt[2]/name/@xml:id"/>
    </xsl:variable>

  
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
     
    <xsl:template match="u" priority="1">
        <xsl:copy>
            <xsl:attribute name="who"><xsl:value-of select="concat('#',$spkrInit)"/></xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="c[@function]" priority="1">
        <m>
            <xsl:if test="@xml:id">
                <xsl:copy-of select="@xml:id"/>
            </xsl:if>
            <xsl:if test="not(@xml:id)">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute> 
            </xsl:if>
            <xsl:value-of select="."/>
        </m>
    </xsl:template>
    <xsl:template match="c[not(@function)]" priority="2">
        <xsl:value-of select="text()"/>
    </xsl:template>
    
    <xsl:template match="@function"/>
    
    <xsl:template match="//titleStmt/respStmt/name[text() = 'Jack Bowers']">
        <name xml:id="JB">
            <xsl:value-of select="."/>
        </name>
    </xsl:template> --> 
    <!-- make variable for  <w> id! (if value of @synch the same on IPA and orth, get value of orth and put in @sameAs="#" on the IPA span-->
    
    
    
  <xsl:template priority="2" match="c"/>
       <!--  
    <xsl:template match="w">
        <seg type="caption" xml:lang="mix">
            <w>
                <xsl:copy-of select="@* except @xml:lang"/>
                <xsl:value-of select="."/>
            </w>
        </seg>
    </xsl:template>
  
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