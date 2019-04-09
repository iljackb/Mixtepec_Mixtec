<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    
    <!-- version 2017-12-09 -->
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="input" as="xs:string" select="'Leccion_01.txt'"/>
    
    <xsl:param name="text-encoding" as="xs:string" select="'UTF-16'"/>
    <!-- utf-8 ISO-8859-1 and it works well. I think it's for European characters, which is fine. I still don't know why UTF-16 -->
    
    <!-- Reading the text file $input into the string variable $input-text -->
    <xsl:variable name="input-text" as="xs:string" select="unparsed-text($input, $text-encoding)"/>
    
    <!-- Trouble shooting with: http://rishida.net/tools/conversion/ -->
    
    <!-- splitting the input into lines -->
    <xsl:variable name="lines"  as="xs:string*" select="tokenize($input-text, '\r?\n')"/>
    
    <!-- input files mush have iso 639 code (if exists) as header of collumn) -->
    <!--
    
    <xsl:param name="fileName">	
        <xsl:value-of select="tokenize(substring-before(base-uri(),'-clnd09.xml'),'/')[last()]"/>
    </xsl:param>  
   
    <xsl:param name="Spkr">	
        <xsl:value-of select="tokenize(substring-after(base-uri(),'_','.txt'))[last()]"/>
    </xsl:param>  
     -->
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
                    <title>TEI output for tab separated bilingual text files exported from file <!-- insert filename here!! --></title>
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
                                & ASSIGN DESIGNATED INITIALS AS VALUE 
                                OF @xml:id
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
                    <p>Information about the source(ADD POINTER TO SOURCE FILE) <ptr target="{base-uri()}"/>
                        <!--
                   ADD POINTER TO <fs> INVENTORY WHERE TAGS ARE!! -->
                    </p>
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
                <xsl:element name="{tier}">
                    <xsl:attribute name="start" select="start"/>
                    <xsl:attribute name="end" select="end"/>
                    <xsl:value-of select="text"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:variable>
    
    <xsl:template match="/">
        <!--  
        <xsl:message><xsl:value-of select="praat-parsed[2]/*/@start"/></xsl:message>
        -->
        <xsl:result-document href="{replace($input,'\.txt$','.xml')}">
            <TEI>
                <xsl:sequence select="$teiHeader"/>
                <!--<xsl:sequence select="$lines-into-tabs"/>-->
                <text>
                    <body>
                        
                        <timeline>
                            <!-- when @xml:id @interval -->
                            <xsl:for-each select=" distinct-values($praat-parsed/@start | $praat-parsed/@end)">
                                <when xml:id="{concat('T',.)}" interval="{.}"/>
                            </xsl:for-each>
                            
                        </timeline>
                        
                        <xsl:for-each-group select="$praat-parsed" group-starting-with="Tokens">
                            <!-- DEFINED VARIABLES FOR TIMEPOINTS IN TIMELINE -->
                            
                            <xsl:variable name="whens" as="element()*">
                                
                                <xsl:for-each select="
                                    distinct-values(
                                    (current-group()[self::Mixtec|self::Spanish|self::IPA|self::English]/@start, current-group()[self::English]/@end)
                                    )">
                                    <when xml:id="T{position()}" interval="{.}"/>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <annotationBlock>
                                <u n="{current-group()[1]}" xml:id="{generate-id(.)}"><!-- ID's ok-->
                                    <xsl:copy-of select="current-group()[1]/(@start, @end)"/>
                                    
                                    <!-- output content from "Spanish" -->
                                 
                                    <seg xml:lang="es" xml:id="{concat('T','-es-',@start)}">   <!--concat(tier+timestamp) -->
                                        <xsl:for-each select="current-group()/self::Spanish">
                                            <xsl:variable name="start" select="@start"/>
                                            <w xml:id="{concat('T','-',@start)}">
                                                <xsl:value-of select="."/>
                                            </w>
                                        </xsl:for-each>
                                    </seg>
                                    
                                    
                                    <!-- output content from "Orth" -->
                                    <seg xml:lang="mix"  xml:id="{concat('T','-mx-',@start)}" synch="{@start}">
                                        <xsl:for-each select="current-group()/self::Mixtec">
                                            <xsl:variable name="start" select="@start"/>
                                            <w synch="{concat('#T',@start)}" xml:id="{concat('T','-o-',@start)}">
                                                <xsl:value-of select="."/>
                                            </w>
                                        </xsl:for-each>
                                    </seg>
                                    
                                    <!-- output content from "Pron" -->
                                    <seg function="utterance" xml:lang="mix" notation="ipa" xml:id="{concat('T','-ipa-',@start)}">
                                        <xsl:for-each select="current-group()/self::IPA">
                                            <xsl:variable name="start" select="@start"/>
                                            <w synch="{concat('#T',@start)}" xml:id="{concat('T','-p-',@start)}">
                                                <xsl:value-of select="."/>
                                            </w>
                                        </xsl:for-each>
                                    </seg>
                                </u>
                                <xsl:variable name="mixSegID">
                                    <xsl:value-of select="current-group()/seg[@xml:lang='mix' and not(@function)]/@xml:id"/>
                                </xsl:variable>
                                <xsl:variable name="espSegID">
                                    <xsl:value-of select="current-group()/seg[@xml:lang='es']/@xml:id"/>
                                </xsl:variable>
                                <spanGrp type="translation">

                                    <xsl:for-each select="current-group()/self::English">
                                        <span xml:lang="en" target="#{$mixSegID}">
                                            <xsl:value-of select="."/>
                                        </span>
                                    </xsl:for-each>
                                </spanGrp>
                                
                                <linkGrp type="translation">
                                    <link target="#{$espSegID} #{$mixSegID}"/>
                                </linkGrp>
                                <!-- can add other features as needed -->
                            </annotationBlock>
                        </xsl:for-each-group>
                        
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>