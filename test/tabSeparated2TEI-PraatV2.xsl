<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="input" as="xs:string" select="'flea-nest_TS.txt'"/>
    
    <xsl:param name="text-encoding" as="xs:string" select="'UTF-16'"/>
    <!-- utf-8 ISO-8859-1 and it works well. I think it's for European characters, which is fine. I still don't know why UTF-16 -->
    
    <!-- Reading the text file $input into the string variable $input-text -->
    <xsl:variable name="input-text" as="xs:string" select="unparsed-text($input, $text-encoding)"/>
    
    <!-- Trouble shooting with: http://rishida.net/tools/conversion/ -->
    
    <!-- splitting the input into lines -->
    <xsl:variable name="lines"  as="xs:string*" select="tokenize($input-text, '\r?\n')"/>
    
    <!-- input files mush have iso 639 code (if exists) as header of collumn) -->
    
    <!-- PSEUDO CODE
        
element "data"
  for each line tokenize the line by delimiter
    element "row"
      for each field n
        element "header n"
          content of field n
        end of element "header n"
      end for
    end of element "row"
  end for
end of element "data"
    
    -->
    
    

    
    <xsl:variable name="teiHeader">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>Test TEI output for Tab separated bilingual text files</title>
                    <respStmt>
                        <resp>Annotation</resp>
                        <resp>Encoding</resp>
                        <name xml:id="JB">Jack Bowers</name>
                    </respStmt>
                    <respStmt>
                        <resp>Speaker</resp>
                        <name>
                            <!-- ADD FROM END OF FILENAME STRING!! -->
                            <!-- CREATE VARIABLES FOR EACH SPEAKER
                                & ASSIGN DESIGNATED INITIALS AS VALUE OF @xml:id
                            -->
                        </name>
                    </respStmt>
                </titleStmt>
                <publicationStmt>
                    <p>Publication Information</p>
                </publicationStmt>
                <notesStmt>
                    <note>add note</note>
                </notesStmt>
                <sourceDesc>
                    <p>Information about the source(ADD POINTER TO SOURCE FILE) </p>
                </sourceDesc>
            </fileDesc>
        </teiHeader>
    </xsl:variable>
    
    
    <xsl:variable name="lines-into-tabs" as="element()*">
        <xsl:for-each select="$lines[. != '']">
            <xsl:variable name="lpos" select="position()"/>
            <xsl:if test="not(starts-with(normalize-space(.), 'ilo'))">
                <line>
                    <xsl:for-each select="tokenize(., '\t')">
                        <xsl:choose>
                            <xsl:when test="position() eq 1">
                                <start><xsl:value-of select="."/></start>
                            </xsl:when>
                            <xsl:when test="position() eq 2">
                                <tier><xsl:value-of select="."/></tier>
                            </xsl:when>
                            <xsl:when test="position() eq 3">
                                <text><xsl:value-of select="."/></text>
                            </xsl:when>
                            <xsl:when test="position() eq 4">
                                <end><xsl:value-of select="."/></end>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message terminate="yes">Too many columns in line <xsl:value-of select="$lpos"/>.</xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </line>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="praat-parsed" as="element()*">
        <xsl:for-each-group select="$lines-into-tabs" group-by="start">
            <xsl:for-each select="current-group()">
                <!-- 
                <xsl:sort select="if (tier eq 'Tokens') then 1 else if (tier eq 'Orth') then 2 else 3"/>
                 -->
                <!-- <Tokens start="3.76" end="5.33">3</Tokens>	  -->
                <xsl:element name="{tier}">
                    <xsl:attribute name="start" select="start"/>
                    <xsl:attribute name="end" select="end"/>
                    <xsl:value-of select="text"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:result-document href="{replace($input,'\.txt$','.xml')}">
            <TEI>
                <xsl:sequence select="$teiHeader"/>
                <!--<xsl:sequence select="$lines-into-tabs"/>-->
                <text>
                    <body>
                        <xsl:for-each-group select="$praat-parsed" group-starting-with="Tokens">
                            
                            <!-- DEFINED VARIABLES FOR TIMEPOINTS IN TIMELINE -->
                            <xsl:variable name="whens" as="element()*">
                                <xsl:for-each select="distinct-values((current-group()[self::Orth|self::Pron|self::Esp|self::Eng]/@start, current-group()[self::Esp|self::Eng]/@end))">
                                    <when xml:id="T{position()}" interval="{.}"/>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <timeline>
                                <xsl:sequence select="$whens"/>
                            </timeline>
                            
                            <annotationBlock>
                                <u n="{current-group()[1]}" xml:id="{generate-id(.)}"><!-- generate-id() ok here?-->
                                    <xsl:copy-of select="current-group()[1]/(@start, @end)"/>
                                    
                                    <!-- output content from "Orth" -->
                                    <seg function="utterance" notation="orth" xml:id="{generate-id(.)}">
                                        <xsl:for-each select="current-group()/self::Orth">
                                            <xsl:variable name="start" select="@start"/>
                                            <w synch="#{$whens[@interval = $start]/@xml:id}" xml:id="{generate-id(.)}">
                                                <xsl:value-of select="."/>
                                            </w>
                                        </xsl:for-each>
                                    </seg>
                                    
                                    <!-- output content from "Pron" -->
                                    <seg function="utterance" notation="ipa" xml:id="{generate-id(.)}">
                                        <xsl:for-each select="current-group()/self::Pron">
                                            <xsl:variable name="start" select="@start"/>
                                            <w synch="#{$whens[@interval = $start]/@xml:id}" xml:id="{generate-id(.)}">
                                                <xsl:value-of select="."/>
                                            </w>
                                        </xsl:for-each>
                                    </seg>
                                </u>
                            </annotationBlock>
                    
                            <spanGrp type="translation">
                                <xsl:for-each select="current-group()/self::Esp">
                          
                                    <!-- (change) to match:
                                           for each <w> (both orth and pron)
                                    -->
                                    <span xml:lang="es" target="# #">
                                        <xsl:value-of select="."/>
                                    </span>
  
                                </xsl:for-each>
                                <xsl:for-each select="current-group()/self::Eng">
                                    <span xml:lang="en" target="# #">
                                        <xsl:value-of select="."/>
                                    </span>
                                </xsl:for-each>
                            </spanGrp>
                            
                            <!-- add //spanGrp[@type="gram"] -->
                            
                            <!-- add //spanGrp[@type="semantics"] -->
                            
                        </xsl:for-each-group>
                        
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>