<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes"/>


    <!-- Intercepting the <seg>'s -->
    
    <!-- uncomment this when adding new <spanGrp type="translation"> -->
<!--  
    <xsl:template match="seg[@type = 'S' and parent::p]">
        <annotationBlock>
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
            <spanGrp type="translation">
                <span target="#{@xml:id}" xml:lang="en"/>
                <span target="#{@xml:id}" xml:lang="es"/>
                <xsl:for-each select="w">
                    <span target="#{@xml:id}" xml:lang="en"/>
                    <span target="#{@xml:id}" xml:lang="es"/>
                </xsl:for-each>
            </spanGrp>
        </annotationBlock>
    </xsl:template>
    -->
    
    <!-- put <seg type="S"> and pre-existing <spanGrp>'s into <annotationBlock> 
       
    <xsl:template match="seg[@type = 'S' and parent::p]">
        <annotationBlock>
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>         

        </annotationBlock>
    </xsl:template>
    

    <xsl:template match="annotationBlock">
        <xsl:apply-templates select="@* | seg"/>
    </xsl:template>

    <xsl:template match="seg[@type = 'S' and parent::annotationBlock]">

        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>

        <xsl:apply-templates select="../spanGrp[@type = 'translation']"/>

        <xsl:if test="not(../spanGrp[@type = 'translation'])">
            <spanGrp type="translation">
                <span target="#{@xml:id}" xml:lang="en"/>
                <span target="#{@xml:id}" xml:lang="es"/>
                <xsl:for-each select="w">
                    <span target="#{@xml:id}" xml:lang="en"/>
                    <span target="#{@xml:id}" xml:lang="es"/>
                </xsl:for-each>
            </spanGrp>
        </xsl:if>

    </xsl:template>
 -->



<!-- for all <seg>'s <u> or not  -->
    <xsl:template match="spanGrp[@type = 'translation']">
        <xsl:variable name="theSpanGrp" select="."/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            
            <xsl:for-each select="(../seg/@xml:id, ../seg/w/@xml:id)">
                <xsl:choose>
                    <xsl:when test="not(concat('#', .) = $theSpanGrp/span/@target)">
                        <span target="{concat('#',.)}" xml:lang="en"/>
                        <span target="{concat('#',.)}" xml:lang="es"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$theSpanGrp/span[@target = concat('#', current())]"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <!-- for all <seg>'s <u> or not 
    <xsl:template match="spanGrp[@type = 'gram']">
        <xsl:variable name="theSpanGrp" select="."/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            
            <xsl:for-each select="(../seg/@xml:id, ../seg/w/@xml:id)">
                <xsl:choose>
                    <xsl:when test="not(concat('#', .) = $theSpanGrp/span/@target)">
                        <span target="{concat('#',.)}" ana=""/>
                        <span target="{concat('#',.)}" ana=""/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$theSpanGrp/span[@target = concat('#', current())]"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
 -->

<!-- for UTTERANCES (IN PROGRESS)
    <xsl:template match="spanGrp[@type = 'translation']">
        <xsl:variable name="theSpanGrp" select="."/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:for-each select="(../u/seg/@xml:id, ../u/seg/w/@xml:id)">
                <xsl:choose>
                    <xsl:when test="not(concat('#', .) = $theSpanGrp/span/@target)">
                        <span target="{concat('#',.)}" xml:lang="en"/>
                        <span target="{concat('#',.)}" xml:lang="es"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$theSpanGrp/span[@target = concat('#', current())]"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
 -->


    <!-- Generic copy template -->

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="//seg/w">
        <xsl:copy>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="//seg/text()">
        <xsl:analyze-string select="." regex="(, | \.|^')">
            <xsl:matching-substring>
                <pc><xsl:value-of select="normalize-space(regex-group(1))"/></pc>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>
