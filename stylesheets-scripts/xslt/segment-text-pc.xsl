<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template> 
    
    <xsl:template match="//seg/text()" priority="1">
        <xsl:analyze-string select="." regex="(\w+)">
            <xsl:matching-substring>
                <w><xsl:value-of select="regex-group(1)"/></w>
            </xsl:matching-substring>
     <!--        <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(\.|;|:|,|')(^|$)">
                    <xsl:matching-substring>
                        <pc><xsl:value-of select="."/></pc>
                    </xsl:matching-substring>
                    --> 
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
            <!-- 
                </xsl:analyze-string>         
            </xsl:non-matching-substring> -->
        </xsl:analyze-string>
    </xsl:template>

    
</xsl:stylesheet>