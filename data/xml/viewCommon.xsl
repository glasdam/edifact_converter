<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:variable name="compoundbgcolor" select="'#eeeeee'"/>
  <xsl:variable name="highlightbgcolor" select="'#ffcccc'"/>
  <xsl:variable name="headerbgcolor" select="'#001973'"/>
  <xsl:variable name="headerfontcolor" select="'#ffffff'"/>
  <xsl:variable name="footerbgcolor" select="'#001973'"/>
  <xsl:variable name="footerfontcolor" select="'#ffffff'"/>
  <xsl:variable name="evenrowbgcolor" select="'#eeeeee'"/>
  <xsl:variable name="oddrowbgcolor" select="'#dddddd'"/>
  <xsl:variable name="evenrowhighlightbgcolor" select="'#ffcccc'"/>
  <xsl:variable name="oddrowhighlightbgcolor" select="'#ffbbbb'"/>
  <xsl:variable name="valuetolowbgcolor" select="'aaaaff'"/>
  <xsl:variable name="valuetohighbgcolor" select="'#ffaaaa'"/>
  <xsl:variable name="valueabnormbgcolor" select="'#ffffaa'"/>
  <xsl:variable name="table2bordercolor" select="'#ee0000'"/>
  <xsl:variable name="namebgcolor" select="'#dddddd'"/>
  <xsl:variable name="namefontcolor" select="'#0000ff'"/>
  
  <xsl:template name="ConvertBoolean">
    <xsl:param name="value"/>
    <xsl:choose>
      <xsl:when test="$value">
        Ja
      </xsl:when>
      <xsl:otherwise>
        Nej
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
