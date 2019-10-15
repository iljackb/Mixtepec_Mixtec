<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--  
    <xsl:template match="teiHeader">
    <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
        <encodingDesc>
            <classDecl>
                <taxonomy>
                    <desc>Typology of linguistic speech events captured in recordings as per: <bibl>Himmelmann (<date>1998</date>)</bibl>. aka Typology of "naturalness".</desc>
                    <category xml:id="observed">
                        <catDesc>
                            <term>Observed communicative event:</term> the extent of external interference is limited to the knowledge of the speakers that the speech is being recorded or observed.</catDesc>  
                    </category>
                    <category xml:id="staged">
                        <catDesc><term>Staged communicative event:</term> speech events realized for the purpose of recording (i.e. elicited speech). Events are not really being realized for the purpose of communication but for the benefit of the investigator.</catDesc>   
                        <category xml:id="staged-free-topical">
                            <catDesc><term>Staged-Topical</term> Prompt to speak freely about topic</catDesc>
                        </category>                  
                        <category xml:id="staged-stimuli">
                            <catDesc><term>Staged-Stimuli</term> events based on stimuli to be described in speakers own words</catDesc>
                        </category>
                    </category> 
                    <category xml:id="elicitation">
                        <catDesc><term>Elicitation:</term> speech act for the sole purpose of linguistic investigation. (A new type of speech event for most communities).</catDesc>    
                        <category xml:id="elicitation-contextualizing">
                            <catDesc><term>Contextualizing elicitation:</term> where native speakers are asked to provide contexts for a item or construction as prompted by the investigator.</catDesc>
                        </category>      
                        <category xml:id="elicitation-translation">
                            <catDesc><term>Translation-based elicitation:</term> native speaker asked to translate item from second language</catDesc>
                        </category>          
                        <category xml:id="elicitation-judgement">
                            <catDesc><term>Judgement:</term> where native speakers are asked to judge the acceptibility of a given construction based on any aspect of language, e.g. grammar, etc.</catDesc>
                        </category>
                    </category>
                </taxonomy>
            </classDecl>
        </encodingDesc>
    </xsl:copy>
    
    </xsl:template>

    
    <xsl:template match="fileDesc/ab"/>
    
    <xsl:template match="recording">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <ab>Content was recorded using <term ana="#elicitation-translation">Translation-based elicitation</term> using <lang>English</lang> and/or <lang>Spanish</lang>.</ab>
        </xsl:copy>
    </xsl:template>
        -->
</xsl:stylesheet>