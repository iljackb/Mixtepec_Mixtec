<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output encoding="UTF-8" method="html" indent="yes"/>
    
    <xsl:template match="/">

<!-- extracts original text and glosses into html -->
        
        <html>
            
            <link href="display-text-docs.css" rel="stylesheet" type="text/css"/>
            <xsl:for-each select="//title"><!-- make bigger center on page -->
                <label><b><font size="6"><xsl:value-of select="."/></font></b></label>
            </xsl:for-each>
            
            <!-- author -->
            <!-- editor -->
            
            <!--(for each) source description -->
            
            <xsl:for-each select="//div">
                <!-- 
                <xsl:for-each select="//head">
                    <label><b><xsl:value-of select="."/></b></label>
                </xsl:for-each> -->
                <br/>
                <br/>
                <label><b><font size="5"><xsl:value-of select="head/text()"/></font></b></label>
                <br/>
                <br/>
                <br/>
                <xsl:for-each select="descendant::p/seg[@xml:id and @xml:lang='mix']">
                  
                    <table border="0">
                        <tr>   
                            <xsl:for-each select="*">
                                <td>
                                    <font size="5"><xsl:value-of select="."/></font>
                                </td>
                            </xsl:for-each>
                        </tr>  
                    </table>
                    <!-- <xsl:for-each select="*">
                          <p>
                            <font size="5"><xsl:value-of select="."/></font>
                        </p>
                    </xsl:for-each> -->
                  <xsl:variable name="annotations" select="following-sibling::spanGrp[@type='annotations'][1]"/>
                      
                    <table border="0">
                        <xsl:for-each select="$annotations/span[@ana='#S' and @xml:lang='en']">
                            <tr>   
                                <td>
                                    <font size="4"><xsl:value-of select="."/></font>
                                </td>
                            </tr>         
                        </xsl:for-each>
                        <!--
                            <xsl:for-each select="$annotations/span[@ana='#S' and @xml:lang='en']">
                    <p>
                        <font size="4"><xsl:value-of select="."/></font>
                    </p>
                    </xsl:for-each>-->
                    <br/>
                  
                        <xsl:for-each select="$annotations/span[@ana='#S' and @xml:lang='es']">
                            <tr>   
                                    <td>
                                        <font size="4"><xsl:value-of select="."/></font>
                                    </td>                       
                            </tr>       
                        </xsl:for-each>
                    </table>  
                      <!--<xsl:for-each select="$annotations/span[@ana='#S' and @xml:lang='es']">
                    <p>
                        <font size="4"><xsl:value-of select="."/></font>
                    </p>
                    </xsl:for-each>-->
                    <br/>
                    <br/>
                </xsl:for-each> 
               
            </xsl:for-each>


        </html>
                         
    </xsl:template>
</xsl:stylesheet>