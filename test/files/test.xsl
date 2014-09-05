<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:my="http://edifact.medware.dk/converter" extension-element-prefixes="my" version="2.0">
    <xsl:output encoding="ISO-8859-1"/>

    <xsl:template match="/Edifact">
        <Edifact>
            <xsl:apply-templates select="*"/>
        </Edifact>
    </xsl:template>

    <xsl:template match="*[my:is_segment(.)]">
        <xsl:variable name="elms" select="my:valid_elms(Elm)"/>
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="$elms"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*[my:is_segmentgroup(.)]">
        <xsl:if test="not(@hidden)">
            <xsl:element name="{local-name()}">
                <xsl:copy-of select="*[1]"/>
            </xsl:element>
        </xsl:if>
        <xsl:apply-templates select="*[position() &gt; 1]"/>
    </xsl:template>

    <xsl:template match="Elm">
        <xsl:variable name="subelms" select="my:valid_subelms(*)"/>
        <xsl:copy-of select="$subelms"/>
    </xsl:template>

    <!-- 
    <xsl:template match="*">
        
    </xsl:template>
     -->

</xsl:stylesheet>
