<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output encoding="UTF-8" method="html" indent="yes"/>

    <xsl:template match="/">
        
        <html>
            
            <link href="display-text-docs.css" rel="stylesheet" type="text/css"/>
            <xsl:for-each select="//title">
                <label><b><font size="5"><xsl:value-of select="."/></font></b></label>
            </xsl:for-each>
            
            <xsl:for-each select="//div">
                <!-- 
                <xsl:for-each select="//head">
                    <label><b><xsl:value-of select="."/></b></label>
                </xsl:for-each> -->
                <br/>
                <br/>
                    <label><b><xsl:value-of select="head/text()"/></b></label>
                <br/>
                <br/>
                <xsl:for-each select="descendant::seg[@xml:id]">
                <table border="0">
                    <tr>   
                        <!-- add numbering here (for each sentence in <div>) 
                            <td>
                                <xsl:value-of select="position()"/><xsl:text>) </xsl:text>
                            </td>-->
                            <xsl:for-each select="*">
                            <td>
                                <!--  
                                    <xsl:number value="position()" format="1" grouping-separator=")"/>
                                -->
                                <font size="4"><xsl:value-of select="."/></font>
                            </td>
                        </xsl:for-each>
                    </tr>
                </table>
                    
                <xsl:variable name="annotations" select="following-sibling::spanGrp[@type='annotations']"/>
                <table border="1">
                    <tr><td colspan="2"><b>English</b></td></tr>
                    <xsl:for-each select="$annotations/span[@xml:lang='en']"><!-- (bug!!) need to limit to annotations (spanGrp) following specific sentence w/axes!! -->
                        <tr>
                            <td>
                                <!-- can add condition of w[@cert] vs w[not(@cert)] here -->
                                <xsl:value-of select="."/>
                            </td>
                            <td> 
                                <!-- can add condition of w[@cert] vs w[not(@cert)] here -->
                                <xsl:value-of select="for $i in tokenize(@target,' ') return /descendant::w[@xml:id= substring-after($i,'#')]" separator=" "/>
                            </td>
                        </tr>
                    </xsl:for-each>
                    <tr><td colspan="2"><b>Spanish</b></td></tr>
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
                    <!-- add "if" to include extra cell for hypelinks to semantic annotations -->
                </table>
            </xsl:for-each>
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
