<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/">
  <xsl:output media-type="text/html"/>
  <xsl:template match="/">
    <html>
      <head>
<title>Test tekst eksempel</title>
      </head>
      <body bgcolor="#F3F7F8">
        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0" width="200px">
          <xsl:apply-templates select="m:TestComment"/>
        </table>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="m:TestComment">
    <table>
      <tbody>
        <tr>
          <th><xsl:value-of select="m:Subject"/></th>
        </tr>
        <tr>
          <td>
            <xsl:apply-templates select="m:Max10LinesText"/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>
  
  <xsl:template match="m:Max10LinesText">
    <xsl:for-each select="m:Paragraph">
       <xsl:value-of select="."/><br/>   
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
