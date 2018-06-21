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
    
    <!-- (1) find string of source filename:
                in text value of: //source/p/ptr[@target]
    
            > speaker initials are the two capital letters preceding the file extension e.g. "*TS.txt"
    
    -->
    
    
    
    <xsl:template match="//source/p/ptr[1]">
        
        
        
        
    </xsl:template>
    
    
    
</xsl:stylesheet>