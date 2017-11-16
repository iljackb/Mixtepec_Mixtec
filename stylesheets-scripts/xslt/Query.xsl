<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <xsl:template match="/">
        <results>
            <xsl:for-each select="collection('./sample-mix-u-files/?select=*.*')">
                <xsl:for-each select="descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'en']">
                    <result>
                        <xsl:value-of select="."/>
                    </result>
                </xsl:for-each>
            </xsl:for-each>
        </results>
    </xsl:template>

</xsl:stylesheet>
