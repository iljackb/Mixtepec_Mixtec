<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
   <xsl:output encoding="UTF-8" method="html" indent="yes"/>

   <xsl:param name="input" as="xs:string" select="'../../SIL_docs/Parangon/ParangonMixtepec-MNieves-TEI.xml'"/>
   
   <xsl:param name="text-encoding" as="xs:string" select="'UTF-16'"/>

   <xsl:variable name="input-document" select="doc($input)"/>
   
   <xsl:param name="searchTarget" select="'vii'"/>
    <xsl:param name="searchLang" select="'mix'"/>
   
   <!-- to make tri-lingual/directional use "if" clause -->
   
    
    <xsl:template match="/">
       <xsl:message>Fichier: <xsl:value-of select="$input"/></xsl:message>
       <xsl:message>Fichier: <xsl:value-of select="$input-document/descendant::w[1]"/></xsl:message>
      <html>
         <body>
            <h1>Searched element</h1>
            <xsl:value-of select="$searchTarget"/>
            <h1>Results</h1>
            <xsl:apply-templates select="$input-document/descendant::w[contains(.,$searchTarget)]"/>
         </body>
      </html>
    </xsl:template>
   
   <xsl:template match="w">
      <xsl:variable name="currentId" select="@xml:id"/>
      <xsl:variable name="currentTarget" select="concat('#',$currentId)"/>
      
      <xsl:variable name="spanTranslations" select="$input-document/descendant::span[contains(@target,$currentTarget) and not(@type)]"/>   
      <xsl:variable name="literalSpanTranslations" select="$input-document/descendant::span[contains(@target,$currentTarget) and @type]"/>   
      <xsl:variable name="linkTranslations" select="$input-document/descendant::link[contains(@target,$currentTarget) and not(@type)]"/>
      <xsl:variable name="literalLinkTranslations" select="$input-document/descendant::link[contains(@target,$currentTarget) and @type]"/>
      
      <p>
         <xsl:value-of select="."/> (<xsl:value-of select="$currentTarget"/>) = 
         <xsl:for-each select="$spanTranslations">
            <xsl:text>Span: </xsl:text><!-- remove later -->
            <xsl:variable name="spanLang" select="@xml:lang"/>
            (<xsl:value-of select="$spanLang"/>)
            <xsl:value-of select="."/>, <!-- only want where there is another one -->      
         </xsl:for-each>
         
         <xsl:for-each select="$literalSpanTranslations">
            <xsl:text>Span: </xsl:text><!-- remove later -->
            <xsl:variable name="spanLang" select="@xml:lang"/>
            (<xsl:value-of select="$spanLang"/>:literal)
            <xsl:value-of select="."/>, <!-- only want where there is another one -->      
         </xsl:for-each>
         
         <xsl:for-each select="$linkTranslations">
            <xsl:for-each select="tokenize(@target,' ')">
               <xsl:text> Links: </xsl:text><!-- remove later -->
                            
               <xsl:variable name="currentLinkedId" select="substring-after(.,'#')"/>
               <xsl:variable name="currentLinkedObject" select="$input-document/descendant::*[@xml:id=$currentLinkedId]"/>
               <xsl:variable name="linkLang" select="$currentLinkedObject/ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
               
               <xsl:if test="$linkLang='es'">
                  (<xsl:value-of select="$linkLang"/>)
                  <xsl:value-of select="$currentLinkedObject"/>
               </xsl:if>
            </xsl:for-each>,
         </xsl:for-each>
         
         <xsl:for-each select="$literalLinkTranslations"><!-- finish this -->
            <xsl:for-each select="tokenize(@target,' ')">
               <xsl:text> Links: </xsl:text><!-- remove later -->
               (<xsl:value-of select="$linkLang"/>)
               <xsl:variable name="currentLinkedId" select="substring-after(.,'#')"/>
               <xsl:variable name="currentLinkedObject" select="$input-document/descendant::*[@xml:id=$currentLinkedId]"/>
               
               <xsl:if test="$currentLinkedObject/ancestor-or-self::*[@xml:lang][1]/@xml:lang='es'">
                  <xsl:value-of select="$currentLinkedObject"/>
               </xsl:if>
            </xsl:for-each>,
         </xsl:for-each>
        
      </p>
   </xsl:template>
    
    
    
    
    
    
    
    <!-- add XPath for title translations also (once implemented) -->
    
    
    <!-- Normalized wordforms (//w[@norm]) -->
    <!-- 
        In all cases where there is the structure //w/w, this is a combination of multiple items that either: 
        
        (a) should have been/be written as one word according to updated orthography;
        (b) the content is a compound but which are written with whitespace;
    
    then;
        the full value of the combined form is included (and should ideally) be extracted from:
        
        the attribute value @norm in //w[@norm]
        
    -->
    
    <!-- Aves -->
    <!--  
    <item>Mixtec content found at following locations: <ref>//list/item/w[@xml:lang='mix']</ref></item>
    
     <item>Spanish translations are part of original content and are found at following location: <ref>//list/item/w[@xml:lang='es']</ref></item>
                  
    <item>Spanish translations are defined in relation to their Mixtec equivalents in the following location:
    
      <ref>//list/item/linkGrp[@type='translation']/link[@target</ref> and the two equivalent translation values are defined in the value of <ref>//link[@target]</ref></item>
                  
                  <item>English translations are defined in relation to their Mixtec equivalents in the following location: <ref>//list/item/spanGrp[@type='translation']/span</ref> the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref></item>
    -->
    
    <!-- Tisu Vienna Diary -->
    <!-- 
              <item>Mixtec content found at following locations: 
                     <ref>//div/p/seg[@xml:lang='mix']/w</ref>  and 
                     <ref>//div/salute/seg[@xml:lang='mix']/w</ref>
                  </item>
                  
                  <item>English translations are defined in relation to their Mixtec equivalents in the following locations:
                  <ref>//div/p/spanGrp[@type='translation']/span[xml:lang='en']</ref> (where preceding sibling is //seg[@xml:lang='mix']) and 
                  <ref>//div/salute</ref> (where preceding sibling is //seg[@xml:lang='mix']);
                  
                  In both (<ref>//div/p/seg[@xml:lang='mix']/w</ref>  and  <ref>//div/salute/seg[@xml:lang='mix']/w</ref>):
                     the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>
                  </item>
                  
                  <item>Spanish translations are defined in relation to their Mixtec equivalents in the following locations: <ref>//div/p/spanGrp[@type='translation']/span[xml:lang='es']</ref> (where preceding sibling is //seg) and <ref>//div/salute</ref> (where preceding sibling is //seg[@xml:lang='mix']);  in both the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>
                  </item>
    
    -->
    
    <!-- Cruxigramas, L145 -->
    <!-- 
    <list>
                  <item>Mixtec content found at following locations: 
                     <ref>//div/head/seg[@xml:lang='mix']/w</ref>  
                     <ref>//div/label/seg[@xml:lang='mix']/w</ref>  
                     <ref>//div/p/seg[@xml:lang='mix']/w</ref>
                     <ref>//div/list/head/seg[@xml:lang='mix']/w</ref>
                     <ref>//div/list/item/seg[@xml:lang='mix']/w</ref>
                  </item>
                  
                  
                  <item>English translations are defined in relation to their Mixtec equivalents in the following locations:
                     
                     <ref>//div/head/spanGrp[@type='translation']/span[xml:lang='en']</ref> where preceding sibling is: <ref>//div/head/seg[@xml:lang='mix']</ref>  
                     
                     <ref>//div/label/spanGrp[@type='translation']/span[xml:lang='en']</ref> where preceding sibling is: <ref>//div/label/seg[@xml:lang='mix']</ref>  
                     
                     <ref>//div/p/spanGrp[@type='translation']/span[xml:lang='en']</ref> where preceding sibling is: <ref>//div/p/seg[@xml:lang='mix']</ref>
                     
                     <ref>//div/list/head/spanGrp[@type='translation']/span[xml:lang='en']</ref> where preceding sibling is: <ref>//div/list/head/seg[@xml:lang='mix']</ref>
                     
                     <ref>//div/list/item/spanGrp[@type='translation']/span[xml:lang='en']</ref> where preceding sibling is: <ref>//div/list/item/seg[@xml:lang='mix']</ref>
                        
                  </item>
                  
                  <item>Spanish translations are defined both in relation to their Mixtec equivalents and as original content (as a prompt for readers to give the Mixtec equivalent) in the following locations:
                     
                     The document contains original content Spanish vocab as prompts to which the answer is the Mixtec item, at the following: <ref>//div/list/item/seg[@xml:lang='es']/w</ref>
                     
                     <ref>//div/head/spanGrp[@type='translation']/span[xml:lang='es']</ref> where preceding sibling is: <ref>//div/head/seg[@xml:lang='mix']</ref>  
                     
                     <ref>//div/label/spanGrp[@type='translation']/span[xml:lang='es']</ref> where preceding sibling is: <ref>//div/label/seg[@xml:lang='mix']</ref>  
                     
                     <ref>//div/p/spanGrp[@type='translation']/span[xml:lang='es']</ref> where preceding sibling is: <ref>//div/p/seg[@xml:lang='mix']</ref>
                     
                     <ref>//div/list/head/spanGrp[@type='translation']/span[xml:lang='es']</ref> where preceding sibling is: <ref>//div/list/head/seg[@xml:lang='mix']</ref>
                     
                     <ref>//div/list/item/spanGrp[@type='translation']/span[xml:lang='es']</ref> where preceding sibling is: <ref>//div/list/item/seg[@xml:lang='mix']</ref>
                 
                  </item>
                  
                  <item>
                     
                     <ref>//div/list/item/spanGrp[@type='translation']/span[xml:lang='mix']</ref> where preceding sibling is: <ref>//div/list/item/seg[@xml:lang='es']</ref>
                     
                     
                  </item>
    
    -->

    <!-- L095-tok-QA-rspns -->
    
    <!-- 
    
    <list>
                     <item>Mixtec content found at following locations:
                     
                        <ref>//text[@xml:lang='mix']/p/seg/w</ref>
                        and
                        <ref>//text[@xml:lang='mix']/ab/seg/w</ref>
                     </item>
                     
                     <item>English translations are defined in relation to their Mixtec equivalents in the following location: <ref>//p/spanGrp[@type='translation']/span[@xml:lang='en']</ref> the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref> where preceding sibling is: <ref>//div/p/seg[@xml:lang='mix']</ref> or <ref>//div/ab/seg[@xml:lang='mix']</ref>
                        
                     </item>
                     
                     <item>Spanish translations are defined in relation to their Mixtec equivalents in the following location: <ref>//p/spanGrp[@type='translation']/span[@xml:lang='es']</ref> the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref> where preceding sibling is:  <ref>//div/p/seg[@xml:lang='mix']</ref> or <ref>//div/ab/seg[@xml:lang='mix']</ref>
                        
                     </item>
                  </list>
    -->
    
    
   <!-- L093, L097, L098, L099, L101, L102, L103, L104, L106, L144, L146, L147, L149, L150, L152, L153, L154, L155, L156, L157, L158, L159, L161, -->
   <!-- 
               <ab type="annotation">
               <list>
                  <item>Mixtec content found at following locations: <ref>//text[@xml:lang='mix']/body/div/p/seg/w</ref>
                     
                  </item>
                  <item>English translations are defined in relation to their Mixtec equivalents in the following location: <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='en']</ref> the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>where preceding sibling is: <ref>//text[@xml:lang='mix']/body/div/p/seg</ref>
                  </item>
                  <item>Spanish translations are defined in relation to their Mixtec equivalents in the following location: <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='es']</ref> the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>where preceding sibling is: <ref>//text[@xml:lang='mix']/body/div/p/seg</ref>
                  </item>
               </list>
            </ab>
   
   
   -->
   <!-- L145 -->
   <!-- 
            <ab type="annotation">
               <list>
                  <item>Mixtec content found at following locations:
                     
                     <ref>//text[@xml:lang='mix']/body/div/p/seg/w</ref>                 
                     <ref>//text[@xml:lang='mix']/body/div/head/seg[@xml:lang='mix']/w</ref>          
                     <ref>//text[@xml:lang='mix']/body/div/list/item/seg[@xml:lang='mix']/w</ref>       
                     <ref>//text[@xml:lang='mix']/body/div/label/seg[@xml:lang='mix']/w</ref>  
                     <ref>//text[@xml:lang='mix']/body/div/p/seg[@xml:lang='mix']/w</ref>
                     <ref>//text[@xml:lang='mix']/body/div/list/head/seg[@xml:lang='mix']/w</ref>
                     
                  </item>
                  <item>English translations are defined in relation to their Mixtec equivalents in the following location:
                     
                     <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='en']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/head/spanGrp[@type='translation']/span[@xml:lang='en']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/list/item/spanGrp[@type='translation']/span[@xml:lang='en']</ref> 
                     <ref>//text[@xml:lang='mix']/body/div/label/spanGrp[@type='translation']/span[@xml:lang='en']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='en']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/list/head/spanGrp[@type='translation']/span[@xml:lang='en']</ref>
                     
                     for each, the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref> where a preceding sibling is:
                     <ref>//text[@xml:lang='mix']/body/*/seg</ref>
                     
                  </item>
                  
                  <item>Spanish translations are defined in relation to their Mixtec equivalents in the following location:
                     
                     <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='es']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/head/spanGrp[@type='translation']/span[@xml:lang='es']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/list/item/spanGrp[@type='translation']/span[@xml:lang='es']</ref> 
                     <ref>//text[@xml:lang='mix']/body/div/label/spanGrp[@type='translation']/span[@xml:lang='es']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='es']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/list/head/spanGrp[@type='translation']/span[@xml:lang='es']</ref>
                     
                     
                     for each, the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>where preceding a sibling is: <ref>//text[@xml:lang='mix']/body/*/seg</ref>
                  </item>
               </list>
   -->
    
    <!-- L151 -->
   
   <!-- 
   
   <ab type="annotation">
               <list>
                  <item>Mixtec content found at following locations:
                     <ref>//text[@xml:lang='mix']/body/div/p/seg/w</ref>
                     <ref>//text[@xml:lang='mix']/body/div/head/seg/w</ref>
                     
                  </item>
                  <item>English translations are defined in relation to their Mixtec equivalents in the following locations:
                     <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='en']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/head/spanGrp[@type='translation']/span[@xml:lang='en']</ref>
                     
                     the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>where a preceding sibling is: <ref>//text[@xml:lang='mix']/body/div/*/seg</ref>
                  </item>
                  <item>Spanish translations are defined in relation to their Mixtec equivalents in the following locations:
                     <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='es']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/head/spanGrp[@type='translation']/span[@xml:lang='es']</ref>
                     
                     the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>where a preceding sibling is: <ref>//text[@xml:lang='mix']/body/div/*/seg</ref>
                  </item>
               </list>
            </ab>
   -->
    
    <!-- L160 -->
    <!-- 
    
    <ab type="annotation">
               <list>
                  <item>Mixtec content found at following locations: 
                     <ref>//text[@xml:lang='mix']/body/div/p/seg/w</ref>
                     <ref>//text[@xml:lang='mix']/body/div/head/seg/w</ref>
                     
                  </item>
                  <item>English translations are defined in relation to their Mixtec equivalents in the following locations:
                     <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='en']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/head/spanGrp[@type='translation']/span[@xml:lang='en']</ref>
                     where the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>
                     
                     where a preceding sibling is: <ref>//text[@xml:lang='mix']/body/div/*/seg</ref>
                  </item>
                  <item>Spanish translations are defined in relation to their Mixtec equivalents in the following location:                    
                     <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span[@xml:lang='es']</ref>
                     <ref>//text[@xml:lang='mix']/body/div/head/spanGrp[@type='translation']/span[@xml:lang='es']</ref>
                     where the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>
                     
                     where a preceding sibling is: <ref>//text[@xml:lang='mix']/body/div/*/seg</ref>
                  </item>
               </list>
            </ab>
    -->
</xsl:stylesheet>