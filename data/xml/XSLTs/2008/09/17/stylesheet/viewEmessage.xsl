<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2008/09/17/"
  xmlns:cpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output media-type="text/html"/>

  <!-- PsychologistLetter -->
  <xsl:template match="m:Emessage[m:PsychologistLetter]">
    <xsl:for-each select="m:PsychologistLetter">
      <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
        <table width="100%">
          <tbody>
            <tr>
              <xsl:call-template name="ShowMessageHeader">
                <xsl:with-param name="MessageName" select="'Psykologepikrise'"/>
              </xsl:call-template>
            </tr>
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <td valign="top">
                        <b>Påbegyndt behandling:</b>
                      </td>
                      <td valign="top">
                        <xsl:for-each select="m:Admission">
                          <xsl:call-template name="FormatDateTime"/>
                        </xsl:for-each>
                      </td>
                      <td valign="top">
                        <b>Behandling afsluttet:</b>
                      </td>
                      <td valign="top">
                        <xsl:for-each select="m:Discharge">
                          <xsl:call-template name="FormatDateTime"/>
                        </xsl:for-each>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <xsl:if test="count(m:Diagnose)>0">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b> Diagnoser/undersøgelser </b>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <table>
                            <tbody>
                              <xsl:for-each select="m:Diagnose/m:Main">
                                <tr>
                                  <td valign="top">
                                    <b>Hoveddiagnose:</b>
                                  </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseText"/>
                                  </td>
                                </tr>
                              </xsl:for-each>
                              <xsl:for-each select="m:Diagnose/m:MainAdditional">
                                <tr>
                                  <td valign="top">
                                    <b>Bidiagnose:</b>
                                  </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseText"/>
                                  </td>
                                </tr>
                              </xsl:for-each>
                              <xsl:for-each select="m:Diagnose/m:Other">
                                <tr>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseDescriptionCode"/>: </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseText"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:for-each select="m:DiagnoseDateTime">
                                      <xsl:call-template name="FormatDateTime"/>
                                    </xsl:for-each>
                                  </td>
                                </tr>
                              </xsl:for-each>
                            </tbody>
                          </table>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
            </xsl:if>
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <td valign="top">
                        <b> Epikrise </b>
                      </td>
                    </tr>
                    <tr>
                      <td valign="top">
                        <table>
                          <tbody>
                            <xsl:for-each select="m:ClinicalInformation">
                              <tr>
                                <td valign="top">
                                  <xsl:for-each select="m:Signed">
                                    <xsl:call-template name="FormatDateTime"/>
                                  </xsl:for-each>
                                </td>
                                <td valign="top">
                                  <xsl:for-each select="m:Text01">
                                    <xsl:apply-templates/>
                                  </xsl:for-each>
                                </td>
                              </tr>
                            </xsl:for-each>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <tr>
              <xsl:call-template name="showReferences">
                <xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
              </xsl:call-template>
            </tr>
            <tr>
              <xsl:call-template name="ShowPatientAndRelatives"/>
            </tr>
            <tr>
              <xsl:call-template name="ShowParticipants"/>
            </tr>
          </tbody>
        </table>
      </td>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
