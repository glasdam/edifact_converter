<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://rep.oio.dk/medcom.dk/xml/schemas/2003/05/02/" xmlns:dkcc="http://rep.oio.dk/ebxml/xml/schemas/dkcc/2003/02/13/" xmlns:dkcpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/" xmlns:gepj="http://medinfo.dk/epj/proj/gepka/20030701/xml/schema" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:template match="/">
        <html>
            <head />
            <body>
                <xsl:for-each select="n1:Emessage">
                    <xsl:apply-templates />
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="n1:MicrobiologyReport">
        <table bgcolor="white" border="0" width="100%">
            <tbody>
                <tr>
                    <td>Mikrobiologisvar</td>
                </tr>
                <tr>
                    <td />
                </tr>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>
