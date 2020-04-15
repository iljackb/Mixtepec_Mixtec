<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output indent="yes" method="xhtml"/>

    <!-- Regarder: https://developer.mozilla.org/fr/docs/Apprendre/HTML/Multimedia_and_embedding/Contenu_audio_et_video pour l'audio et la video -->

    <!-- position: absolute; -->
    <!--  -->

    <!-- Creation of the HTML skeleton -->

    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:apply-templates select="/TEI/teiHeader/fileDesc/titleStmt/title"/>
                </title>
                <style type="text/css">
                    body {
                        padding-left: 2em;
                        padding-top: 4em;
                        color: purple;
                        background-color: #d8da3d;
                    }
                    h1 {
                        text-align: center;
                    }
                    table.resp,
                    tr.resp,
                    td.resp {
                        order: none;
                        text-align: center;
                    }
                    table.resp {
                    margin-left:auto;
                    margin-right:auto;
                    }
                    blockquote.etym {
                        margin: 0.5em 0em 0em 2em;
                        border: 0.05em dotted black;
                    }
                    div.header {
                        left: 1em;
                        width: 40em;
                        padding-left: 1em;
                        padding-bottom: 1em;
                        border-left: 0.1em solid black;
                        border-bottom: 0.1em solid black;
                    }
                    div.text {
                        top: 2em;
                        left: 2em;
                        padding-left: 2em;
                        padding-bottom: 1em;
                    }
                    span.quote {
                        display: block;
                        font-weight: bold;
                    }
                    span.translation {
                        display: block;
                        font-style: italic;
                    }
                    
                    span.domain {
                        font-variant: small-caps;
                    }
                    img {
                    max-height: 100px;
                    max-width: 100px;
                    }
                    
                    form[type="lemma"] > orth::before {
                    padding: 20px;
                    }
                
                    form[type="lemma"] > orth {
                    font-size: 24px;
                    font-weight: bold;
                    display: inline;
                    }
                    
                    form[type="variant"] > orth::before {
                    content: ", ";
                    color:black !important
                    }
                    
                    form[type="variant"] > orth {
                    font-size: 22px !important;
                    font-weight: bold;
                    display: inline;
                    color:gray
                    }
                    
                    cit[type="example"] > quote::before {
                    padding: 20px;
                    }
                    
                    <!-- 
                        modify for related entries! (ñási'i) 
                        create full line space above
                    -->
                </style>

            </head>
            <body>
                <xsl:apply-templates select="descendant::teiHeader"/>
                <xsl:apply-templates select="descendant::text"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="titleStmt">
        <xsl:apply-templates select="title"/>
        <table class="resp">
            <tr class="resp">
                <xsl:apply-templates select="respStmt/*[1]"/>
            </tr>
            <tr class="resp">
                <xsl:apply-templates select="respStmt/*[2]"/>
            </tr>
        </table>
        <xsl:apply-templates select="* except (title | respStmt)"/>
    </xsl:template>

    <xsl:template match="title">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>

    <xsl:template match="respStmt/resp">
        <td class="resp">
            <i><xsl:apply-templates/></i>
        </td>
    </xsl:template>
    
    <xsl:template match="respStmt/name">
        <td class="resp">
            <b><xsl:apply-templates/></b>
        </td>
    </xsl:template>
    
    <xsl:template match="form[@type='lemma']/orth">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    
    <xsl:template match="form[@type='variant']/orth">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>

    <xsl:template match="pron">
        <span>
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="gramGrp">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="sense">
        <blockquote class="sense">
            <xsl:if test="@n">
                <xsl:text>(</xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>) </xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>

    <xsl:template match="sense/cit[@type = 'translation']">
        <span class="gloss">
            <xsl:apply-templates/>
            <xsl:if test="following-sibling::*[1][@type = 'translation']">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </span>
    </xsl:template>

    <xsl:template match="etym">
        <blockquote class="etym">
            <b>(Etymology</b><i> - <xsl:value-of select="@type"/></i>) <br/>
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>

    <xsl:template match="cit[@type = 'example']/quote">
        <span class="quote">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="gloss"><!-- maybe modify to its own specs separate from translations -->
        <span class="translation">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="cit[@type = 'example']/cit[@type = 'translation']">
        <span class="translation">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="usg[@type = 'domain']">
        <span class="domain">
            <xsl:text>[</xsl:text>
            <a href="{@corresp}">
                <xsl:apply-templates/>
            </a>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="media[@mimeType = 'audio/wav']">
        <figure>
            <!--<figcaption>Listen to the T-Rex:</figcaption>-->
            <audio controls="controls" src="{@url}"> Your browser does not support the <code>audio</code> element.
            </audio>
        </figure>
    </xsl:template>


    <xsl:template match="figure">
        <picture>
            <xsl:apply-templates/>
        </picture>
    </xsl:template>
    
    <!-- media="(min-width: 650px)"  -->
    <xsl:template match="graphic">
        <!--<source srcset="{@url}"/>-->
        <img src="{@url}"/>
    </xsl:template>

    <xsl:template match="teiHeader">
        <div class="header">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="text">
        <div class="text">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

<!-- add formatting for <note> which should be indented (see 'face') -->

</xsl:stylesheet>
