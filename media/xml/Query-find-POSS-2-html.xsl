<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output encoding="UTF-8" method="html" indent="yes"/>

    <xsl:template match="/">
        <xsl:variable name="theCollection" select="collection('./?select=*.*')"/>
        <html>
            <p n="1">
                <xsl:for-each select="$theCollection">
                    <xsl:for-each select="descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'en']">
                        <result>
                            <xsl:value-of select="."/>
                        </result>
                    </xsl:for-each>
                </xsl:for-each>
            </p>
            <table n="2">
                <xsl:for-each select="$theCollection">
                    <xsl:variable name="currentCollection" select="."/>
                    <!-- ALSO NEED TO FIND THOSE NOT IN <seg type="phrase"> as some are in sentences! -->
                    <xsl:for-each select="descendant::span[@type = 'phrase' and contains(@ana, '#POSS')]">
                        <xsl:variable name="orth"
                                select="substring-after(substring-before(@target, ' '), '#')"/>
                        <xsl:variable name="pron"
                                select="substring-after(substring-after(@target, ' '), '#')"/>
                  <!-- add space! -->

                        <tr>
                            <td>
                                <xsl:value-of select="$currentCollection/descendant-or-self::seg[@xml:id = $orth]/w"
                                      separator=" "/>
                            </td>
                     <!-- need space between N and particle!! -->
                            <td>
                                <xsl:value-of select="$currentCollection/descendant-or-self::seg[@xml:id = $pron]/w/c"
                                      separator=" "/>
                        <!-- see if you can add separator after /w only!! -->
                            </td>
                            <td>
                                <xsl:value-of select="$currentCollection/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'en' and contains(@target, $orth)]"
                                      separator="/"/>
                            </td>
                            <td>
                                <xsl:value-of select="$currentCollection/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'es' and contains(@target, $orth)]"
                                      separator="/"/>
                            </td>
                        </tr>
                        <br/>
                    </xsl:for-each>
               <!-- make version that can return full context of observation -->
                </xsl:for-each>
            </table>
        </html>
    </xsl:template>

</xsl:stylesheet>
