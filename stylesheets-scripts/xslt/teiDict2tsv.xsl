<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="text" />
    <xsl:variable name="separator" select="'&#44;'" />
    <xsl:variable name="newline" select="'&#10;'" />
    <xsl:variable name="orth1" select="//form[@type='lemma']/orth[1]"/>
    
    <xsl:template match="/">
             <xsl:text>
                 Orth; Pron(1); Pron(Pike and Ibach); Pron(2); Pron(3); EN(sense1.i); EN(sense1.ii);EN(sense1.iii); ES (sense1.i);ES(sense1.ii); ES(sense1.iii); Def(sense1); Example (sense 1); Example (EN); Example (ES); EN(sense2.i); EN(sense2.ii);EN(sense2.iii); ES (sense2.i); ES(sense2.ii); ES(sense2.iii); Def(sense2); Example (sense 2); Example (sense 2) (EN); Example (sense 2) (ES);</xsl:text>
        <xsl:value-of select="$newline" />
        
        <xsl:for-each select="//entry | //re">
            <!--  
            <xsl:value-of select="concat(form[@type='lemma']/orth[1],$newline)" />
            -->
            <xsl:value-of select="form[@type='lemma']/orth[1]" />
            <xsl:value-of select="$separator"/>
            <xsl:value-of select="form[@type='lemma']/pron[not(@source)][1]" />
            <xsl:value-of select="$separator" />
            <xsl:value-of select="form[@type='lemma']/pron[@source='#Pike-Ibach-MIX-1978'][1]" />
            <xsl:value-of select="$separator" />
            <xsl:value-of select="form[@type='lemma' or @type='variant']/pron[not(@source)][2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="form[@type='lemma' or @type='variant']/pron[not(@source)][3]"/>
            <xsl:value-of select="$separator" />    
            <xsl:value-of select="sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'][1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'][2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'][3]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'][1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'][2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'][3]"/>
            <xsl:value-of select="$separator" />
           <xsl:value-of select="sense[1]/def[@xml:lang='en']"/>
            <xsl:value-of select="sense[1]/cit[@type='example']/quote[@xml:lang='mix'][1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[1]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='en'][1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[1]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='es'][1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/cit[@type='translation']/form/orth[@xml:lang='en'][1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/cit[@type='translation']/form/orth[@xml:lang='en'][2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/cit[@type='translation']/form/orth[@xml:lang='en'][3]"/>
            <xsl:value-of select="$separator" />
            <!-- add "if" to add more than one translation in same language -->
            <xsl:value-of select="sense[2]/cit[@type='translation']/form/orth[@xml:lang='es'][1]"/>
            <!-- add "if" to add more than one translation in same language -->
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/cit[@type='translation']/form/orth[@xml:lang='es'][2]"/>
            <!-- add "if" to add more than one translation in same language -->
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/cit[@type='translation']/form/orth[@xml:lang='es'][3]"/>
            <!-- add "if" to add more than one translation in same language -->
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/def[@xml:lang='en']"/>
            <xsl:value-of select="sense[2]/cit[@type='example']/quote[@xml:lang='mix'][1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='en'][1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='es'][1]"/>
            <xsl:value-of select="$separator" />
         <!--              <xsl:text>&#xD;</xsl:text> <xsl:value-of select="$newline" />
            <xsl:value-of select="$separator" />
            <xsl:value-of select="../vehicle_Set/vehicle/make" />
            <xsl:value-of select="$separator" />
            <xsl:value-of select="invoice/id" />
            <xsl:value-of select="$separator" />
            <xsl:value-of select="invoice/description" />
            <xsl:value-of select="$separator" />         -->
            <xsl:value-of select="$newline" />
   
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
</xsl:stylesheet>