<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="html"/>
    
    <xsl:key name="findTheWord" match="w" use="string-join(*)"/>
    
    <xsl:template match="/">
        <xsl:value-of select="descendant-or-self::w/string-join(*)" separator=" - "/>
        <xsl:for-each select="key('findTheWord','la˩ku˥ku˧˥')">
            <p>
                Id: <xsl:value-of select="@xml:id"/><br/>
            </p>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>