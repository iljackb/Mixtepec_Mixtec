<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- The tab delimited document, relative to the stylesheet location or an absolute location -->
    <xsl:param name="doc" select="'ilocano_temp_list_110211.txt'"/>
    <!-- The encoding for the tab delimited document -->
    <xsl:param name="enc" select="'UTF-8'"/>
    <!-- The result XML root element name -->
    <xsl:param name="root" select="'file'"/>
    <!-- The result XML element name that will mark the values from a line -->
    <xsl:param name="line" select="'line'"/>
    <!-- The result XML element name that will mark each value from the input document -->
    <xsl:param name="entry" select="'entry'"/>
    
    <!--
    main template
  -->
    <xsl:template match="/">
        <xsl:element name="{$root}">
            <xsl:call-template name="tLines">
                <xsl:with-param name="value" select="unparsed-text($doc, $enc)"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <!-- 
    tokenize lines 
  -->
    <xsl:template name="tLines">
        <xsl:param name="value" select="''"/>
        <xsl:analyze-string select="$value" regex="\n|\r">
            <xsl:matching-substring/>
            <xsl:non-matching-substring>
                <xsl:element name="{$line}">
                    <xsl:call-template name="tValues">
                        <xsl:with-param name="value" select="."/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <!-- 
    tokenize values 
  -->
    <xsl:template name="tValues">
        <xsl:param name="value" select="''"/>
        <xsl:analyze-string select="$value" regex="\t">
            <xsl:matching-substring/>
            <xsl:non-matching-substring>
                <xsl:element name="{$entry}">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>