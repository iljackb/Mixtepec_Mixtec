<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="text" />
    <xsl:variable name="separator" select="'&#009;'" />
    <xsl:variable name="newline" select="'&#10;'" />
    <xsl:variable name="orth1" select="//form[@type='lemma']/orth[1]"/>
    
    <xsl:template match="/">
             <xsl:text>Orth&#009;  Pron(1)&#009; Pron(Pastor and Beam de Azcona)&#009; Pron(Pike and Ibach)&#009; Pron&#009; Pron&#009; POS(sense1)&#009; EN(sense1.i)&#009; EN(sense1.ii)&#009; EN(sense1.iii)&#009; ES (sense1.i)&#009; ES (sense1.ii)&#009; ES (sense1.iii)&#009; LA (sense1.i)&#009;  LA (sense1.ii)&#009; Def(sense1)&#009;  Example (sense 1)&#009; Example (EN)&#009; Example (ES)&#009; POS(sense2)&#009; EN(sense2.i)&#009; EN(sense2.ii)&#009; EN(sense2.iii)&#009; ES (sense2.i)&#009; ES(sense2.ii)&#009;  ES(sense2.iii)&#009; Def(sense2)&#009; Example (sense 2)&#009; Example (sense 2) (EN)&#009; Example (sense 2) (ES)</xsl:text>
        <xsl:value-of select="$newline" />
        
        <xsl:for-each select="//entry | //re">
            <!--  
            <xsl:value-of select="concat(form[@type='lemma']/orth[1],$newline)" />
            -->
            <xsl:value-of select="form[@type='lemma']/orth[1]" />
            <xsl:value-of select="$separator"/>
            <!-- need to add for where variant lemma forms (eg. colors) -->
            <xsl:value-of select="form[@type='lemma']/pron[not(@source)][1]" />
            <xsl:value-of select="$separator" />
            <xsl:value-of select="form[@type='lemma']/pron[@source='#Pastor-Azcona'][1]" />
            <xsl:value-of select="$separator" />
            <xsl:value-of select="form[@type='lemma']/pron[@source='#Pike-Ibach-MIX-1978'][1]" />
            <xsl:value-of select="$separator" />
            <xsl:value-of select="form[@type='lemma' or @type='variant']/pron[not(@source)][2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="form[@type='lemma' or @type='variant']/pron[not(@source)][3]"/>
            <xsl:value-of select="$separator" /> 
            
            <!-- (1) normal single pos entry; (2) sense/sense[1]/gramGrp/pos is where the translation is the same but it can have different POS; (3) where different senses have different POS and different translation                 -->
            <xsl:value-of select="gramGrp[1]/pos |  sense/sense[1]/gramGrp/pos |  sense[1]/gramGrp/pos"/><!-- test!! -->
            <xsl:value-of select="$separator" /> 
            
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'])[2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'])[3]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'])[2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'])[3]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='la'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='la'])[2]"/>
            <xsl:value-of select="$separator" />
           <xsl:value-of select="sense[1]/def[@xml:lang='en']"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='example']/quote[@xml:lang='mix'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='en'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='es'])[1]"/>
            <xsl:value-of select="$separator" />
            
            <xsl:value-of select="gramGrp[2]/pos | sense[2]/gramGrp/pos | (sense)/sense[2]/gramGrp/pos"/>
            <xsl:value-of select="$separator" /> 
            
            <xsl:value-of select="(sense[2]/cit[@type='translation']/form/orth[@xml:lang='en'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[2]/cit[@type='translation']/form/orth[@xml:lang='en'])[2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[2]/cit[@type='translation']/form/orth[@xml:lang='en'])[3]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[2]/cit[@type='translation']/form/orth[@xml:lang='es'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[2]/cit[@type='translation']/form/orth[@xml:lang='es'])[2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[2]/cit[@type='translation']/form/orth[@xml:lang='es'])[3]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/def[@xml:lang='en']"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/cit[@type='example']/quote[@xml:lang='mix'][1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[2]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='en'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[2]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='es'])[1]"/>
            <!--              <xsl:value-of select="$separator" />-->
            <xsl:value-of select="$newline" />
   
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
</xsl:stylesheet>