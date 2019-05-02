<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <!-- exports the contents extracted from annotated TEI corpus documents into TEI dictionary for human readable output prior to final transfer into dictionary (full or paradigms) -->
    
    <xsl:output method="text" />
    <xsl:variable name="separator" select="'&#009;'" />
    <xsl:variable name="newline" select="'&#10;'" />
    <xsl:variable name="orth1" select="//form[@type='lemma']/orth[1]"/>
    
    <!-- ADD DOMAINS -->
    
    <xsl:template match="/">
        <xsl:text>Orth&#009; EN(sense1.i)&#009; EN(sense1.ii)&#009; EN(sense1.iii)&#009; ES (sense1.i)&#009; ES (sense1.ii)&#009; ES (sense1.iii)&#009; Dom(sense1.i)&#009; POS(sense1)&#009; Example (sense 1)&#009; Example (EN)&#009; Example (ES)&#009;</xsl:text>
        <xsl:value-of select="$newline" />
        
        <xsl:for-each select="//entry | //re">
            <!--  
            <xsl:value-of select="concat(form[@type='lemma']/orth[1],$newline)" />
            -->
            <xsl:value-of select="form[@type='lemma']/orth[1]" />
            <xsl:value-of select="$separator"/>
            
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'])[1] |(form/gloss[@xml:lang='en'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'])[2] |(form/gloss[@xml:lang='en'])[2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'])[3] |(form/gloss[@xml:lang='en'])[3]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'])[1] |(form/gloss[@xml:lang='es'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'])[2] |(form/gloss[@xml:lang='es'])[2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'])[3] |(form/gloss[@xml:lang='en'])[3]"/>
            <xsl:value-of select="$separator" />
            
            <xsl:value-of select="(sense[1]/usg[@type='domain'])[1]"/>
            <xsl:value-of select="$separator" />

            <xsl:value-of select="gramGrp[1]/pos |  sense/sense[1]/gramGrp/pos |  sense[1]/gramGrp/pos"/><!-- test!! -->
            <xsl:value-of select="$separator" /> 
                          
            <xsl:value-of select="(sense[1]/cit[@type='example']/quote[@xml:lang='mix'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='en'])[1]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="(sense[1]/cit[@type='example']/cit[@type='translation']/quote[@xml:lang='es'])[1]"/>
            <xsl:value-of select="$newline" />
            
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
</xsl:stylesheet>