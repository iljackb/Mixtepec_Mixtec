<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template> 
    
    <xsl:template match="//seg/text()">
        <xsl:analyze-string select="." regex="^((\w+)\s*(\w+))*:">
            <xsl:matching-substring>
                <label><xsl:value-of select="regex-group(1)"/></label><pc>:</pc>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

  
    <xsl:template match="//seg/text()">
        <xsl:analyze-string select="." regex="^(\w+):">
            <xsl:matching-substring>
                <label><xsl:value-of select="regex-group(1)"/></label><pc>:</pc>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="(^((\w+)/(\w+(\.*)):))">
                    <xsl:matching-substring>
                        <label>
                        <seg>
                            <xsl:value-of select="regex-group(3)"/>    
                        </seg>
                        <pc>/</pc>
                        <seg>
                            <xsl:value-of select="regex-group(4)"/>    
                        </seg>
                        <pc>:</pc>
                        </label>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="." regex="(^(\w+\.):)">
                            <xsl:matching-substring>
                                <label><xsl:value-of select="regex-group(2)"/>
                                <pc>:</pc>
                                </label>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="(^((\w+)-(\w+):))">
                                    <xsl:matching-substring>
                                        <label>
                                        <seg>
                                            <xsl:value-of select="regex-group(3)"/>
                                        </seg>
                                        <pc>-</pc>
                                        <seg>
                                            <xsl:value-of select="regex-group(4)"/>
                                        </seg>
                                        <pc>:</pc>
                                        </label>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                            <xsl:analyze-string select="." regex="(^((\w+-)/(\w+):))">
                                                <xsl:matching-substring>
                                                    <label>
                                                    <seg>
                                                        <xsl:value-of select="regex-group(3)"/>
                                                    </seg>
                                                    <pc>/</pc>
                                                    <seg>
                                                        <xsl:value-of select="regex-group(4)"/>
                                                    </seg>
                                                    <pc>:</pc>
                                                    </label>
                                                </xsl:matching-substring>
                                                <xsl:non-matching-substring>
                                                    <xsl:analyze-string select="." regex="(^((\w+-)/(\w+\.):))">
                                                        <xsl:matching-substring>
                                                            <label>
                                                                <seg>
                                                                    <xsl:value-of select="regex-group(3)"/>
                                                                </seg>
                                                                <pc>/</pc>
                                                                <seg>
                                                                    <xsl:value-of select="regex-group(4)"/>
                                                                </seg>
                                                                <pc>:</pc>
                                                            </label>
                                                        </xsl:matching-substring>
                                                        <xsl:non-matching-substring>
                                                            <xsl:analyze-string select="." regex="(^((\w+\.)(\w+):))">
                                                                <xsl:matching-substring>
                                                                    <label>
                                                                        <seg>
                                                                            <xsl:value-of select="regex-group(3)"/>
                                                                        </seg>
                                                                        <seg>
                                                                            <xsl:value-of select="regex-group(4)"/>
                                                                        </seg>
                                                                        <pc>:</pc>
                                                                    </label>
                                                                </xsl:matching-substring>
                                                                <xsl:non-matching-substring>
                                                                    <xsl:analyze-string select="." regex="(^((\w+)/(\w+-)/(\w+\.):))">
                                                                        <xsl:matching-substring>
                                                                            <label>
                                                                                <seg>
                                                                                    <xsl:value-of select="regex-group(3)"/>
                                                                                </seg>
                                                                                <pc>/</pc>
                                                                                <seg>
                                                                                    <xsl:value-of select="regex-group(4)"/>
                                                                                </seg>
                                                                                <pc>/</pc>
                                                                                <seg>
                                                                                    <xsl:value-of select="regex-group(5)"/>
                                                                                </seg>
                                                                                <pc>:</pc>
                                                                            </label>
                                                                        </xsl:matching-substring>
                                                                        <xsl:non-matching-substring>
                                                                            <xsl:analyze-string select="." regex="(^((\w+\.\w+\.)/(\w+\.):))">
                                                                                <xsl:matching-substring>
                                                                                    <label>
                                                                                        <seg>
                                                                                            <xsl:value-of select="regex-group(3)"/>
                                                                                        </seg>
                                                                                        <pc>/</pc>
                                                                                        <seg>
                                                                                            <xsl:value-of select="regex-group(4)"/>
                                                                                        </seg>                                
                                                                                        <pc>:</pc>
                                                                                    </label>
                                                                                </xsl:matching-substring>
                                                                                <xsl:non-matching-substring>
                                                                                    <xsl:analyze-string select="." regex="(^((\w+\.)/(\w+\.):))">
                                                                                        <xsl:matching-substring>
                                                                                            <label>
                                                                                                <seg>
                                                                                                    <xsl:value-of select="regex-group(3)"/>
                                                                                                </seg>
                                                                                                <pc>/</pc>
                                                                                                <seg>
                                                                                                    <xsl:value-of select="regex-group(4)"/>
                                                                                                </seg>                                
                                                                                                <pc>:</pc>
                                                                                            </label>
                                                                                        </xsl:matching-substring>
                                                                                        <xsl:non-matching-substring>
                                                                                            <xsl:analyze-string select="." regex="(^((\w+)/(-\w+):))">
                                                                                                <xsl:matching-substring>
                                                                                                    <label>
                                                                                                        <seg>
                                                                                                            <xsl:value-of select="regex-group(3)"/>
                                                                                                        </seg>
                                                                                                        <pc>/</pc>
                                                                                                        <seg>
                                                                                                            <xsl:value-of select="regex-group(4)"/>
                                                                                                        </seg>                                
                                                                                                        <pc>:</pc>
                                                                                                    </label>
                                                                                                </xsl:matching-substring>
                                                                                                <xsl:non-matching-substring>
                                                                                                    <xsl:analyze-string select="." regex="(^((\w+)/(\w+\.\w+):))">
                                                                                                        <xsl:matching-substring>
                                                                                                            <label>
                                                                                                                <seg>
                                                                                                                    <xsl:value-of select="regex-group(3)"/>
                                                                                                                </seg>
                                                                                                                <pc>/</pc>
                                                                                                                <seg>
                                                                                                                    <xsl:value-of select="regex-group(4)"/>
                                                                                                                </seg>
                                                                                                                <pc>:</pc>
                                                                                                            </label>
                                                                                                        </xsl:matching-substring>
                                                                                                        <xsl:non-matching-substring>
                                                                                                            <xsl:analyze-string select="." regex="(^((\w+\.\w+):)/(\w+):)">
                                                                                                                <xsl:matching-substring>
                                                                                                                    <label>
                                                                                                                        <seg>
                                                                                                                            <xsl:value-of select="regex-group(3)"/>
                                                                                                                        </seg>
                                                                                                                        <pc>/</pc>
                                                                                                                        <seg>
                                                                                                                            <xsl:value-of select="regex-group(4)"/>
                                                                                                                        </seg>                                
                                                                                                                        <pc>:</pc>
                                                                                                                    </label>
                                                                                                                </xsl:matching-substring>
                                                                                                                <xsl:non-matching-substring>
                                                                                                                    <xsl:analyze-string select="." regex="(^(\((\w+)\)(\w+\.)):)">
                                                                                                                        <xsl:matching-substring>
                                                                                                                            <label><pc>(</pc><seg><xsl:value-of select="regex-group(3)"/></seg><pc>)</pc><seg><xsl:value-of select="regex-group(4)"/></seg></label><pc>:</pc>
                                                                                                                        </xsl:matching-substring>
                                                                                                                        <xsl:non-matching-substring>
                                                                                                                            <xsl:analyze-string select="." regex="(^((\w+\.\w+):)/(\w+):)">
                                                                                                                                <xsl:matching-substring>
                                                                                                                                    <label>
                                                                                                                                        <seg>
                                                                                                                                            <xsl:value-of select="regex-group(3)"/>
                                                                                                                                        </seg>
                                                                                                                                        <pc>/</pc>
                                                                                                                                        <seg>
                                                                                                                                            <xsl:value-of select="regex-group(4)"/>
                                                                                                                                        </seg>
                                                                                                                                        <pc>:</pc>
                                                                                                                                    </label>
                                                                                                                                </xsl:matching-substring>
                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                    <xsl:analyze-string select="." regex="(^((\w+\.\w+)/(\w+)):)">
                                                                                                                                        <xsl:matching-substring>
                                                                                                                                            <label>
                                                                                                                                                <seg>
                                                                                                                                                    <xsl:value-of select="regex-group(3)"/>
                                                                                                                                                </seg>
                                                                                                                                                <pc>/</pc>
                                                                                                                                                <seg>
                                                                                                                                                    <xsl:value-of select="regex-group(4)"/>
                                                                                                                                                </seg>
                                                                                                                                                <pc>:</pc>                                
                                                                                                                                            </label>
                                                                                                                                        </xsl:matching-substring>
                                                                                                                                        <xsl:non-matching-substring>
                                                                                                                                            <xsl:analyze-string select="." regex="(^((\w+)/(\w+)-(\w+\.):))">
                                                                                                                                                <xsl:matching-substring>
                                                                                                                                                    <label>
                                                                                                                                                        <seg>
                                                                                                                                                            <xsl:value-of select="regex-group(3)"/>
                                                                                                                                                        </seg>
                                                                                                                                                        <pc>/</pc>
                                                                                                                                                        <seg>
                                                                                                                                                            <xsl:value-of select="regex-group(4)"/>
                                                                                                                                                        </seg>
                                                                                                                                                        <pc>-</pc>
                                                                                                                                                        <seg>
                                                                                                                                                            <xsl:value-of select="regex-group(5)"/>
                                                                                                                                                        </seg>
                                                                                                                                                        <pc>:</pc> 
                                                                                                                                                    </label>
                                                                                                                                                    
                                                                                                                                                </xsl:matching-substring>
                                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                                    <xsl:analyze-string select="." regex="(^((\w+\.)/(\w+):))">
                                                                                                                                                        <xsl:matching-substring>
                                                                                                                                                            <label>
                                                                                                                                                                <seg>
                                                                                                                                                                    <xsl:value-of select="regex-group(3)"/>
                                                                                                                                                                </seg>
                                                                                                                                                                <pc>/</pc>
                                                                                                                                                                <seg>
                                                                                                                                                                    <xsl:value-of select="regex-group(4)"/>
                                                                                                                                                                </seg>
                                                                                                                                                                <pc>:</pc>  
                                                                                                                                                            </label>
                                                                                                                                                        </xsl:matching-substring>
                                                                                                                                                        <xsl:non-matching-substring>
                                                                                                                                                            <xsl:analyze-string select="." regex="(^((\w+)/(-\w-):))">
                                                                                                                                                                <xsl:matching-substring>
                                                                                                                                                                    <label>
                                                                                                                                                                        <seg>
                                                                                                                                                                            <xsl:value-of select="regex-group(3)"/>
                                                                                                                                                                        </seg>
                                                                                                                                                                        <pc>/</pc>
                                                                                                                                                                        <seg>
                                                                                                                                                                            <xsl:value-of select="regex-group(4)"/>
                                                                                                                                                                        </seg>
                                                                                                                                                                        <pc>:</pc>  
                                                                                                                                                                    </label>
                                                                                                                                                                </xsl:matching-substring>
                                                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                                                    <xsl:analyze-string select="." regex="(^((\w+-)(\w+)(-\w+):))">
                                                                                                                                                                        <xsl:matching-substring>
                                                                                                                                                                            <label>
                                                                                                                                                                                <seg>
                                                                                                                                                                                    <xsl:value-of select="regex-group(3)"/>
                                                                                                                                                                                </seg>
                                                                                                                                                                                <seg>
                                                                                                                                                                                    <xsl:value-of select="regex-group(4)"/>
                                                                                                                                                                                </seg> 
                                                                                                                                                                                <seg>
                                                                                                                                                                                    <xsl:value-of select="regex-group(5)"/>
                                                                                                                                                                                </seg>
                                                                                                                                                                                <pc>:</pc>
                                                                                                                                                                            </label>
                                                                                                                                                                        </xsl:matching-substring>
                                                                                                                                                                        <xsl:non-matching-substring>
                                                                                                                                                                            <xsl:analyze-string select="." regex="(^((\w+-)(\w+)(-\w+)/(\w+):))">
                                                                                                                                                                                <xsl:matching-substring>
                                                                                                                                                                                    <label>
                                                                                                                                                                                        <seg>
                                                                                                                                                                                            <xsl:value-of select="regex-group(3)"/>
                                                                                                                                                                                        </seg>
                                                                                                                                                                                        <seg>
                                                                                                                                                                                            <xsl:value-of select="regex-group(4)"/>
                                                                                                                                                                                        </seg> 
                                                                                                                                                                                        <seg>
                                                                                                                                                                                            <xsl:value-of select="regex-group(5)"/>
                                                                                                                                                                                        </seg>
                                                                                                                                                                                        <pc>/</pc>
                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(6)"/></seg>
                                                                                                                                                                                        <pc>:</pc>
                                                                                                                                                                                    </label>
                                                                                                                                                                                </xsl:matching-substring>
                                                                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                                                                    <xsl:analyze-string select="." regex="(^((\w+)/(\w+-):))">
                                                                                                                                                                                        <xsl:matching-substring>
                                                                                                                                                                                            <label>
                                                                                                                                                                                                <seg>
                                                                                                                                                                                                    <xsl:value-of select="regex-group(3)"/>
                                                                                                                                                                                                </seg>
                                                                                                                                                                                                <pc>/</pc>
                                                                                                                                                                                                <seg>
                                                                                                                                                                                                    <xsl:value-of select="regex-group(4)"/>
                                                                                                                                                                                                </seg>
                                                                                                                                                                                                <pc>:</pc>
                                                                                                                                                                                            </label>
                                                                                                                                                                                        </xsl:matching-substring>
                                                                                                                                                                                        <xsl:non-matching-substring>
                                                                                                                                                                                            <xsl:analyze-string select="." regex="(^((\w+\.)/(\w+)-(\w+):))">
                                                                                                                                                                                                <xsl:matching-substring>
                                                                                                                                                                                                    <label>
                                                                                                                                                                                                        <seg>
                                                                                                                                                                                                            <xsl:value-of select="regex-group(3)"/>
                                                                                                                                                                                                        </seg>
                                                                                                                                                                                                        <pc>/</pc>
                                                                                                                                                                                                        <seg>
                                                                                                                                                                                                            <xsl:value-of select="regex-group(4)"/>
                                                                                                                                                                                                        </seg>
                                                                                                                                                                                                        <pc>-</pc>
                                                                                                                                                                                                        <seg>
                                                                                                                                                                                                            <xsl:value-of select="regex-group(5)"/>
                                                                                                                                                                                                        </seg>
                                                                                                                                                                                                        <pc>:</pc>
                                                                                                                                                                                                    </label>
                                                                                                                                                                                                </xsl:matching-substring>
                                                                                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                                                                                    <xsl:analyze-string select="." regex="(^((\w+\.)/(-\w+):))">
                                                                                                                                                                                                        <xsl:matching-substring>
                                                                                                                                                                                                            <label>
                                                                                                                                                                                                                <seg>
                                                                                                                                                                                                                    <xsl:value-of select="regex-group(3)"/>
                                                                                                                                                                                                                </seg>
                                                                                                                                                                                                                <pc>/</pc>
                                                                                                                                                                                                                <seg>
                                                                                                                                                                                                                    <xsl:value-of select="regex-group(4)"/>
                                                                                                                                                                                                                </seg>
                                                                                                                                                                                                                <pc>:</pc>
                                                                                                                                                                                                            </label>
                                                                                                                                                                                                        </xsl:matching-substring>
                                                                                                                                                                                                        <xsl:non-matching-substring>
                                                                                                                                                                                                            <xsl:analyze-string select="." regex="(^(\w+\.*)\s(\w+\.*):)">
                                                                                                                                                                                                                <xsl:matching-substring>
                                                                                                                                                                                                                    <label><seg><xsl:value-of select="regex-group(2)"/></seg> <seg><xsl:value-of select="regex-group(3)"/></seg></label><pc>:</pc>
                                                                                                                                                                                                                </xsl:matching-substring>
                                                                                                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                                                                                                    <xsl:analyze-string select="." regex="(^(\w+)\((\w)\):)">
                                                                                                                                                                                                                        <xsl:matching-substring>
                                                                                                                                                                                                                            <label>
                                                                                                                                                                                                                                <seg><xsl:value-of select="regex-group(2)"/><pc>(</pc><xsl:value-of select="regex-group(3)"/><pc>)</pc></seg>
                                                                                                                                                                                                                                <pc>:</pc>
                                                                                                                                                                                                                            </label>
                                                                                                                                                                                                                        </xsl:matching-substring>
                                                                                                                                                                                                                        <xsl:non-matching-substring>
                                                                                                                                                                                                                            <xsl:analyze-string select="." regex="(^(\w+)\((\w+)\):)">
                                                                                                                                                                                                                                <xsl:matching-substring>
                                                                                                                                                                                                                                    <label>
                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(2)"/><pc>(</pc><seg><xsl:value-of select="regex-group(3)"/><pc>)</pc></seg></seg>
                                                                                                                                                                                                                                        <pc>:</pc>
                                                                                                                                                                                                                                    </label>
                                                                                                                                                                                                                                </xsl:matching-substring>
                                                                                                                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                                                                                                                    <xsl:analyze-string select="." regex="(^(\w+\.*)\s(\w+\.*)\s(\w+\.*):)">
                                                                                                                                                                                                                                        <xsl:matching-substring>
                                                                                                                                                                                                                                            <label><seg><xsl:value-of select="regex-group(2)"/></seg> <seg><xsl:value-of select="regex-group(3)"/></seg> <seg><xsl:value-of select="regex-group(4)"/></seg></label><pc>:</pc>
                                                                                                                                                                                                                                        </xsl:matching-substring>
                                                                                                                                                                                                                                        <xsl:non-matching-substring>
                                                                                                                                                                                                                                            <xsl:analyze-string select="." regex="(^(\w+\.*)\s(\w+\.*)\s(\w+\.*)/(\w+\.*):)">
                                                                                                                                                                                                                                                <xsl:matching-substring>
                                                                                                                                                                                                                                                    <label><seg><xsl:value-of select="regex-group(2)"/></seg>
                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(3)"/></seg>
                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(4)"/></seg>
                                                                                                                                                                                                                                                        <pc>/</pc>
                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(5)"/></seg>
                                                                                                                                                                                                                                                        <pc>:</pc>
                                                                                                                                                                                                                                                    </label>
                                                                                                                                                                                                                                                </xsl:matching-substring>
                                                                                                                                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                                                                                                                                    <xsl:analyze-string select="." regex="(^(\w+\.*)\s(\w+\.*)\s(\w+\.*)/(\w+-)(\w+\.*):)">
                                                                                                                                                                                                                                                        <xsl:matching-substring>
                                                                                                                                                                                                                                                            <label><seg><xsl:value-of select="regex-group(2)"/></seg>
                                                                                                                                                                                                                                                                <seg><xsl:value-of select="regex-group(3)"/></seg>
                                                                                                                                                                                                                                                                <seg><xsl:value-of select="regex-group(4)"/></seg>
                                                                                                                                                                                                                                                                <pc>/</pc>
                                                                                                                                                                                                                                                                <seg><xsl:value-of select="regex-group(5)"/></seg>
                                                                                                                                                                                                                                                                <seg><xsl:value-of select="regex-group(6)"/></seg>
                                                                                                                                                                                                                                                                <pc>:</pc>
                                                                                                                                                                                                                                                            </label>
                                                                                                                                                                                                                                                        </xsl:matching-substring>
                                                                                                                                                                                                                                                        <xsl:non-matching-substring>
                                                                                                                                                                                                                                                            <xsl:analyze-string select="." regex="(^(\w+\.*)\s(\w+\.*)\s(\w+\.*)\s(\w+\.*):)">
                                                                                                                                                                                                                                                                <xsl:matching-substring>
                                                                                                                                                                                                                                                                    <label><seg><xsl:value-of select="regex-group(2)"/></seg>
                                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(3)"/></seg>
                                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(4)"/></seg>
                                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(5)"/></seg>
                                                                                                                                                                                                                                                                        <pc>:</pc>
                                                                                                                                                                                                                                                                    </label>
                                                                                                                                                                                                                                                                </xsl:matching-substring>
                                                                                                                                                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                                                                                                                                                    <xsl:analyze-string select="." regex="(^(\w+\.*)/(\w+\.*)\s(\w+\.*):)">
                                                                                                                                                                                                                                                                        <xsl:matching-substring>
                                                                                                                                                                                                                                                                            <label>
                                                                                                                                                                                                                                                                                <seg><xsl:value-of select="regex-group(2)"/></seg>
                                                                                                                                                                                                                                                                                <pc>/</pc>
                                                                                                                                                                                                                                                                                <seg><xsl:value-of select="regex-group(3)"/></seg>
                                                                                                                                                                                                                                                                                <seg><xsl:value-of select="regex-group(4)"/></seg>
                                                                                                                                                                                                                                                                                <pc>:</pc>
                                                                                                                                                                                                                                                                            </label>
                                                                                                                                                                                                                                                                        </xsl:matching-substring>
                                                                                                                                                                                                                                                                        <xsl:non-matching-substring>
                                                                                                                                                                                                                                                                            <xsl:analyze-string select="." regex="(^(\w+\.*)/(\w+\.*)-(\w+\.*)-(\w+\.*):)">
                                                                                                                                                                                                                                                                                <xsl:matching-substring>
                                                                                                                                                                                                                                                                                    <label>
                                                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(2)"/></seg>
                                                                                                                                                                                                                                                                                        <pc>/</pc>
                                                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(3)"/></seg>
                                                                                                                                                                                                                                                                                        <pc>-</pc>
                                                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(4)"/></seg>
                                                                                                                                                                                                                                                                                        <pc>-</pc>
                                                                                                                                                                                                                                                                                        <seg><xsl:value-of select="regex-group(5)"/></seg>
                                                                                                                                                                                                                                                                                        <pc>:</pc>
                                                                                                                                                                                                                                                                                    </label>
                                                                                                                                                                                                                                                                                </xsl:matching-substring>
                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                <!-- CORE PORTION OF FRAGE CONTENT  -->
                                                                                                                                                                                                                                                                                <!-- get puntuation (except periods, dashes, quotes(single and double), square brackets, dashes, and fwd slashes)  -->
                                                                                                                                                                                                                                                                                <xsl:non-matching-substring>
                                                                                                                                                                                                                                                                                    <seg ana="question">
                                                                                                                                                                                                                                                                                        <xsl:value-of select="."/>
                                                                                                                                                                                                                                                                                    </seg>
                                                                                                                                                                                                                                                                                </xsl:non-matching-substring>
                                                                                                                                                                                                                                                                            </xsl:analyze-string>
                                                                                                                                                                                                                                                                        </xsl:non-matching-substring>
                                                                                                                                                                                                                                                                    </xsl:analyze-string>
                                                                                                                                                                                                                                                                </xsl:non-matching-substring>
                                                                                                                                                                                                                                                            </xsl:analyze-string>
                                                                                                                                                                                                                                                        </xsl:non-matching-substring>
                                                                                                                                                                                                                                                    </xsl:analyze-string>
                                                                                                                                                                                                                                                </xsl:non-matching-substring>
                                                                                                                                                                                                                                            </xsl:analyze-string>
                                                                                                                                                                                                                                        </xsl:non-matching-substring>
                                                                                                                                                                                                                                    </xsl:analyze-string>
                                                                                                                                                                                                                                </xsl:non-matching-substring>
                                                                                                                                                                                                                            </xsl:analyze-string>
                                                                                                                                                                                                                        </xsl:non-matching-substring>
                                                                                                                                                                                                                    </xsl:analyze-string>
                                                                                                                                                                                                                </xsl:non-matching-substring>
                                                                                                                                                                                                            </xsl:analyze-string>
                                                                                                                                                                                                        </xsl:non-matching-substring>
                                                                                                                                                                                                    </xsl:analyze-string>
                                                                                                                                                                                                </xsl:non-matching-substring>
                                                                                                                                                                                            </xsl:analyze-string>
                                                                                                                                                                                        </xsl:non-matching-substring>
                                                                                                                                                                                    </xsl:analyze-string>
                                                                                                                                                                                </xsl:non-matching-substring>
                                                                                                                                                                            </xsl:analyze-string>
                                                                                                                                                                        </xsl:non-matching-substring>
                                                                                                                                                                    </xsl:analyze-string>
                                                                                                                                                                </xsl:non-matching-substring>
                                                                                                                                                            </xsl:analyze-string>
                                                                                                                                                        </xsl:non-matching-substring>
                                                                                                                                                    </xsl:analyze-string>
                                                                                                                                                </xsl:non-matching-substring>
                                                                                                                                            </xsl:analyze-string>
                                                                                                                                        </xsl:non-matching-substring>
                                                                                                                                    </xsl:analyze-string>
                                                                                                                                </xsl:non-matching-substring>
                                                                                                                            </xsl:analyze-string>
                                                                                                                        </xsl:non-matching-substring>
                                                                                                                    </xsl:analyze-string>
                                                                                                                </xsl:non-matching-substring>
                                                                                                            </xsl:analyze-string>
                                                                                                        </xsl:non-matching-substring>
                                                                                                    </xsl:analyze-string>
                                                                                                </xsl:non-matching-substring>
                                                                                            </xsl:analyze-string>
                                                                                        </xsl:non-matching-substring>
                                                                                    </xsl:analyze-string>
                                                                                </xsl:non-matching-substring>
                                                                            </xsl:analyze-string>
                                                                        </xsl:non-matching-substring>
                                                                    </xsl:analyze-string>
                                                                </xsl:non-matching-substring>
                                                            </xsl:analyze-string>
                                                        </xsl:non-matching-substring>
                                                    </xsl:analyze-string>
                                                </xsl:non-matching-substring>
                                            </xsl:analyze-string>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>



<!-- segments (works) -->
<!-- 
    <xsl:template match="/p/s/text()">
        <xsl:for-each select="tokenize(., '[\s]')[.]">
                <seg>
                    <xsl:sequence select="."/>
                </seg>  
        </xsl:for-each>
    </xsl:template>
 -->
<!-- this should combine the steps of tokenizing into <seg>, splitting punctuation and tagging with <pc>
<xsl:template match="*/p/s/text()">
    <xsl:analyze-string select="." regex="(.,'(\.,:;)')">
        <xsl:matching-substring>
            <pc>
                <xsl:sequence select="matches(regex-group(2),'.')"/>
            </pc>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
            <xsl:for-each select="tokenize(., '[\s]')[.]">
                <seg>
                    <xsl:sequence select="."/>
                </seg>  
            </xsl:for-each>
            
        </xsl:non-matching-substring>
    </xsl:analyze-string>
    
</xsl:template>
 -->
<!--  

    <xsl:template match="seg">
            <seg xml:id="{generate-id(.)}">
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates select="node()"/>
            </seg>
        
    </xsl:template>
    -->
  
    <!--
        <xsl:template match="seg/text()">          
        <xsl:for-each select="tokenize(.,'$delimitor')">
            <xsl:sequence select="."/>
            <xsl:if test="not(position() eq last())">
                <pc>/</pc> 
            </xsl:if>
            <xsl:if test="not($delimitor)">
                <seg><xsl:value-of select="."/></seg>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
        -->
 
    <!--works in tagging delimiter-->
<!-- 
    <xsl:template match="seg/text()">
        <xsl:for-each select="tokenize(.,'/')">
            <xsl:sequence select="."/>
            <xsl:if test="not(position() eq last())">
                <pc>/</pc> 
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
 --> 
 
    <!-- 
    <xsl:template match="seg">
        <seg xml:id="{generate-id(.)}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </seg>
    </xsl:template>
    -->
</xsl:stylesheet>