<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:mc="http://rep.oio.dk/medcom.dk/xml/schemas/2011/02/17/">
    <xsl:output method="html" indent="yes"/>

    <xsl:include href="common.xsl"/>
    
    <xsl:include href="BirthNotification2html.xsl"/>

    <xsl:template match="mc:Emessage">
        <html>
            <head>
                <title>Fødselsanmeldelse</title>
                <style type="text/css">
                    <![CDATA[
                    body {
                        font-size: 10pt;
                    }
                    
                    
                    table {
                        width: 100%;
                        padding: 10px 0px 10px 0px;
                    }
                
                    td {
                        background-color: white;
                        width: 50%;
                        padding: 3px;
                    }
                    
                    table.edit {
                      margin: 0px;
                      padding: 0px;
                    }
                    
                    table.edit tr td{
                    border: 1px solid black;
                    min-height: 1em;
                    width: auto;
                    }
                    
                    td.field {
                        border: 1px solid black;
                        min-height: 1em;
                    }

                    td.container {
                        padding: 0px;
                        margin: 0px;
                        background-color: transparent;
                    }

                     td.heading {
                         background-color: #bedefc;
                         border: 1px solid black;
                     }
                     
                     div.background {
                         background-color: #7ebefd;
                         border: 1px solid black;
                         margin: 10px;
                         padding: 10px;
                         width: 60em;
                     }
                     
                     h4 {
                         font-size: 14pt;
                         margin: 10px 2px 0px 10px;
                         padding-left: 2px;
                     }
                     
                     h5 {
                     font-size: 12pt;
                     margin: 0px 2px 0px 10px;
                     padding-left: 2px;
                     }
                     
                     h6 {
                     font-size: 10pt;
                     margin: 0px 2px 0px 2px;
                     padding-left: 2px;
                     }
                     h7 {
                     font-size: 8pt;
                     margin: 0px 2px 0px 2px;
                     padding-left: 2px;
                     }
                     
                     span.generaltext {
                         padding: 5px;
                     }
                     
                    .label {
                        font-weight: 700;
                     }
                     
                     table.part {
                        width: auto;
                     }
                     
                     table.part tr td {
                        width: auto;
                     }
                     
                     table.part tr td {
                        padding: 2px 4px 2px 2px;
                        border: 0px solid black;
                     }
                     
                     span.bold {
                        font-weight: 700;
                     }
                     
                     span.italic {
                        font-style: italic;
                     }
                     
                     span.underline {
                        text-decoration: underline;
                     }
                     
                     p.right {
                        text-align: right;
                        margin-bottom: 0px;
                        margin-top: 0px;
                     }
                     
                     span.fixedfont {
                        font-family: "Courier New", Courier, mono;
                     }
                     
                     table.table {
                        background-color: white;
                        border: none;
                     }
                     
                     table.table th {
                        text-align: left;
                     }
                     
                     table.table tr td {
                        width: auto;
                     }
                     
                      table.table tr td.subtitle {
                        padding-top: 0px;
                        padding-left: 10px;
                     }
                     
                     table.table tr.subtitle td {
                        padding-top: 0px;
                     }
                     
                ]]></style>
            </head>
            <body>
                <div class="background">
                    <xsl:apply-templates select="mc:*"/>
                </div>
            </body>
         </html>
    </xsl:template>
    
    <xsl:template match="mc:Envelope">
       <small>Afsendt: <xsl:value-of select="mc:Sent/mc:Date"/> kl: <xsl:value-of select="mc:Sent/mc:Time"/></small> <br/>
        <small>EMessage ID: <xsl:value-of select="mc:Identifier"/> <br/>
            <xsl:choose>
                <xsl:when test="mc:AcknowledgementCode = 'pluspositivkvitt'">Positiv kvitering valg</xsl:when>
                <xsl:when test="mc:AcknowledgementCode = 'minuspositivkvitt'">Positiv kvitering fravalgt</xsl:when>
            </xsl:choose>
            
        </small>
    </xsl:template>
    
</xsl:stylesheet>
