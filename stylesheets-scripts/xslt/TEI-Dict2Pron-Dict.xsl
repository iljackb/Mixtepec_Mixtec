<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="ns1:entry" xmlns:ns1="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="ns1:form/ns1:gloss"/>

        <xsl:value-of select="ns1:form/ns1:orth"/>
        
        <xsl:value-of select="ns1:form/ns1:pron"/>
        
        <xsl:if test="ns1:form/ns1:pVar">
            <xsl:value-of select="ns1:form/ns1:pVar"/>
        </xsl:if>
        
    </xsl:template>
</xsl:stylesheet>
