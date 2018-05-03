<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
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
    
    <!-- Cruxigramas -->
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
    
    <!-- L093 -->
    
    <!-- 
<list>
                  <item>Mixtec content found at following locations: <ref>//text[@xml:lang='mix']/body/p/seg/w</ref></item>     
                  
                  <item>Spanish translations are defined in relation to their Mixtec equivalents in the following location: <ref>//text[@xml:lang='mix']/body/p/spanGrp[@type='translation']/span[@target</ref> and the two equivalent translation values are defined in the value of <ref>//span[@target]</ref> 
                  where preceding sibling is: <ref>//text[@xml:lang='mix']/body/p/seg[@xml:lang='mix']</ref></item>
                  
                  <item>English translations are defined in relation to their Mixtec equivalents in the following location: <ref>//text[@xml:lang='mix']/body/p/spanGrp[@type='translation']/span</ref> the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>where preceding sibling is: <ref>//text[@xml:lang='mix']/body/p/seg[@xml:lang='mix']</ref></item>
                  
               </list>
    
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
    
    
   <!-- L097, L098, L099, L101, L102, L103, L104, L106, L144,-->
   <!-- 
               <ab type="annotation">
               <list>
                  <item>Mixtec content found at following locations: <ref>//text[@xml:lang='mix']/body/div/p/seg/w</ref>
                     
                  </item>
                  <item>English translations are defined in relation to their Mixtec equivalents in the following location: <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span</ref> the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>where preceding sibling is: <ref>//text[@xml:lang='mix']/body/div/p/seg</ref>
                  </item>
                  <item>Spanish translations are defined in relation to their Mixtec equivalents in the following location: <ref>//text[@xml:lang='mix']/body/div/p/spanGrp[@type='translation']/span</ref> the value of <ref>//span[@target] is the pointer to the Mixtec translation equivalent</ref>where preceding sibling is: <ref>//text[@xml:lang='mix']/body/div/p/seg</ref>
                  </item>
               </list>
            </ab>
   
   
   -->
    
</xsl:stylesheet>