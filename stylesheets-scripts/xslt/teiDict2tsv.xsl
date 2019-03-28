<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="text" />
    <xsl:variable name="separator" select="'&#59;'" />
    <xsl:variable name="newline" select="'&#10;'" />
    <xsl:variable name="orth1" select="//form[@type='lemma']/orth[1]"/>
    
    <xsl:template match="/">
             <xsl:text>Orth;Pron(1);Pron(2);Pron(3)..;Eng(sense1);Span(sense1);Def(sense1);Span(sense1);Def(sense1);</xsl:text>
        <xsl:value-of select="$newline" />
        
        <xsl:for-each select="//entry">
            <!--  
            <xsl:value-of select="concat(form[@type='lemma']/orth[1],$newline)" />
            -->
            <xsl:value-of select="form[@type='lemma']/orth[1]" />
            <xsl:value-of select="$separator"/>
            <xsl:value-of select="form[@type='lemma']/pron[1]" />
            <xsl:value-of select="$separator" />
            <xsl:value-of select="form[@type='lemma' or @type='variant']/pron[2]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="form[@type='lemma' or @type='variant']/pron[3]"/>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[1]/cit[@type='translation']/form/orth[@xml:lang='en'][1]"/>
            <xsl:value-of select="$separator" />
            <!-- add "if" to add more than one translation in same language -->
            <xsl:value-of select="sense[1]/cit[@type='translation']/form/orth[@xml:lang='es'][1]"/>
            <!-- add "if" to add more than one translation in same language -->
            <xsl:value-of select="$separator" />
            <xsl:if test="sense[1]/def[@xml:lang='en']">
                <xsl:value-of select="sense[1]/def[@xml:lang='en']"/>
            </xsl:if>
            <xsl:value-of select="$separator" />
            <xsl:value-of select="sense[2]/cit[@type='translation']/form/orth[@xml:lang='en'][1]"/>
            <xsl:value-of select="$separator" />
            <!-- add "if" to add more than one translation in same language -->
            <xsl:value-of select="sense[2]/cit[@type='translation']/form/orth[@xml:lang='es'][1]"/>
            <!-- add "if" to add more than one translation in same language -->
            <xsl:value-of select="$separator" />
            <xsl:if test="sense[2]/def[@xml:lang='en']">
                <xsl:value-of select="sense[2]/def[@xml:lang='en']"/>
            </xsl:if>
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