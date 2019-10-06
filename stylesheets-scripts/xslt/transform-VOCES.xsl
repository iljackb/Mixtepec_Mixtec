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
    
    <xsl:template match="usg[contains(.,'metáfora')]">
        <etym type="metaphor">
            <seg type="desc"><xsl:value-of select="."/></seg>
            <cit type="etymon" resp="#JB">
                <form>
                    <orth/>
                </form>
                <def xml:lang="es"/>
            </cit>
        </etym>
    </xsl:template>

    <xsl:template match="usg[not(contains(.,'metáfora'))]">
        <usg type="hint">
            <xsl:value-of select="."/>
        </usg>
    </xsl:template>




    <!-- 
    <xsl:template match="usg/text()[contains(.,'metáfora')]">
        <xsl:analyze-string select="." regex="^(dicho por metáfora|por metáfora|es por metáfora)$">
            <xsl:matching-substring>
                <etym type="metaphor">
                    <seg type="desc"><xsl:value-of select="regex-group(1)"/></seg>
                    <cit type="etymon" resp="#JB">
                        <form>
                            <orth/>
                        </form>
                        <def xml:lang="es"/>
                    </cit>
                </etym>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
  -->
    
</xsl:stylesheet>