<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output encoding="UTF-8" method="html" indent="yes"/>

    <xsl:template match="/">
        <html>
            <xsl:for-each select="descendant::seg[@xml:id and @type = 'S']">
                <table border="0">
                    <tr>
                        <xsl:for-each select="*">
                            <td>
                                <font size="4"><xsl:value-of select="."/></font>
                            </td>
                        </xsl:for-each>
                    </tr>
                </table>
                <xsl:variable name="annotations" select="following-sibling::spanGrp[@type='translation'][1]"/>
                <table border="1">
                    <tr><td colspan="2">English</td></tr>
                    <xsl:for-each select="$annotations/span[@xml:lang='en']">
                        <tr>
                            <td>
                                <xsl:value-of select="."/>
                            </td>
                            <td>
                                <xsl:value-of select="for $i in tokenize(@target,' ') return /descendant::w[@xml:id= substring-after($i,'#')]" separator=" "/>
                            </td>
                        </tr>
                    </xsl:for-each>
                    <tr><td colspan="2">Spanish</td></tr>
                    <xsl:for-each select="$annotations/span[@xml:lang='es']">
                        <tr>
                            <td>
                                <xsl:value-of select="."/>
                            </td>
                            <td>
                                <xsl:value-of select="for $i in tokenize(@target,' ') return /descendant::w[@xml:id= substring-after($i,'#')]" separator=" "/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:for-each>
            <!--  -->
            <!--<p n="1">
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
                    <xsl:for-each select="descendant::span[@type = 'phrase' and contains(@ana, '#POSS')]">
                        <xsl:variable name="orth" select="substring-after(substring-before(@target, ' '), '#')"/>
                        <xsl:variable name="pron" select="substring-after(substring-after(@target, ' '), '#')"/>

                        <tr>
                            <td>
                                <xsl:value-of select="$currentCollection/descendant-or-self::seg[@xml:id = $orth]/w"/>
                            </td>
                            <td>
                                <xsl:value-of select="$currentCollection/descendant-or-self::seg[@xml:id = $pron]/w/c" separator=""/>
                            </td>
                            <td>
                                <xsl:value-of select="$currentCollection/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'en' and contains(@target, $orth)]" separator="/"/>
                            </td>
                            <td>
                                <xsl:value-of select="$currentCollection/descendant::spanGrp[@type = 'translation']/span[@xml:lang = 'es' and contains(@target, $orth)]" separator="/"/>
                            </td>
                        </tr>
                        <br/>
                    </xsl:for-each>
                </xsl:for-each>
            </table>-->
        </html>
    </xsl:template>

</xsl:stylesheet>
