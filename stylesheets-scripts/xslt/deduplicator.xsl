<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml"/>

    <xsl:template match="/">

        <xsl:message>Coucou</xsl:message>
        <!-- Diagnostic: list of forms and number of them -->

      <!-- 1) Makes list of all unique forms -->
        <xsl:variable name="allForms" select="distinct-values(descendant::form[@type = 'lemma']/orth)"/>
        
        <xsl:variable name="allEnglish" select="distinct-values(descendant::cit[@type='translation']/form/orth[@xml:lang='en'])"/>     
        <xsl:variable name="allSpanish" select="distinct-values(descendant::cit[@type='translation']/form/orth[@xml:lang='es'])"/>
        
        <xsl:variable name="theRoot" select="."/>

        <xsl:message><!-- IS THIS PART ALL JUST FOR HUMAN INFO? -->
            <!-- 2) Selects each member of list of all unique forms -->
            <xsl:for-each select="$allForms">   
                <!-- 3) Current form (basis of comparisson) is made into variable -->
                <xsl:variable name="theCurrentForm" select="."/>
                <!-- 4) selects the form-->
                <xsl:value-of select="."/>
                <!-- 5)  counts (& prints) the number of occurances of the selected form (for human information only?) -->
                (<xsl:value-of select="count($theRoot/descendant::form[@type = 'lemma']/orth[. = $theCurrentForm])"/>) -
            </xsl:for-each>
        </xsl:message>
        
        
        <xsl:message>
            <xsl:for-each select="entry">   
                <xsl:variable name="theCurrentForm" select="form[@type = 'lemma']/orth"/>
                <xsl:variable name="theCurrentSenseEn" select="cit[@type='translation']/form/orth[@xml:lang='en']"/>
                <xsl:variable name="theCurrentSenseEs" select="cit[@type='translation']/form/orth[@xml:lang='es']"/>
                <xsl:variable name="distinctEntry" select="concat(.,$theCurrentForm,$theCurrentSenseEn,$theCurrentSenseEs)"/>
                <xsl:value-of select="."/>
        
                (<xsl:value-of select="count($theRoot/descendant::form[@type = 'lemma']/orth[. = $theCurrentForm] and
                    $theRoot/descendant::cit[@type='translation']/form/orth[@xml:lang='en'][. = $theCurrentSenseEn] and
                    $theRoot/descendant::cit[@type='translation']/form/orth[@xml:lang='es'][. = $theCurrentSenseEs]
                    )"/>) -
            </xsl:for-each>
        </xsl:message>
        
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <xsl:template match="entry[
        form[@type = 'lemma']/orth = preceding-sibling::entry/form[@type = 'lemma']/orth
        and 
        sense/cit[@type='translation']/form/orth[@xml:lang='en'] = preceding-sibling::entry/sense/cit[@type='translation']/form/orth[@xml:lang='en']
        and 
        sense/cit[@type='translation']/form/orth[@xml:lang='es'] = preceding-sibling::entry/sense/cit[@type='translation']/form/orth[@xml:lang='es']
        ]">
        <xsl:message>Doublon supprimé: <xsl:value-of select="form[@type = 'lemma']/orth"/></xsl:message>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
