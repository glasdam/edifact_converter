<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/"
  xmlns:gepj="http://medinfo.dk/epj/proj/gepka/20030701/xml/schema"
  xmlns:cpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/"
  xmlns:dkcc="http://rep.oio.dk/ebxml/xml/schemas/dkcc/2003/02/13/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output media-type="text/html"/>
  
  <xsl:include href="WebReport.xsl"/>
  <xsl:key name="requisitiongroup2result" match="m:Emessage/m:LaboratoryReport/m:LaboratoryResults/m:Result" use="concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)"/>
  <!-- EmergencyLetter -->
  <xsl:template match="m:Emessage[m:DoctorsCallCenterLetter]">
    <xsl:for-each select="m:DoctorsCallCenterLetter">
      <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
        <table width="100%">
          <tbody>
            <tr>
              <xsl:call-template name="ShowMessageHeader">
                <xsl:with-param name="MessageName" select="'Lægevagtsepikrise'"/>
              </xsl:call-template>
            </tr>
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <td valign="top">
                        <b>Besøgsdato (starttidspunkt) for første besøg:</b>
                      </td>
                      <td valign="top">
                        <xsl:for-each select="m:Admission">
                          <xsl:call-template name="FormatDateTime"/>
                        </xsl:for-each>
                      </td>
                      <td valign="top">
                        <b>Sidste besøg (sluttidspunkt):</b>
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

  <!-- SpecialistLetter -->
  <xsl:template match="m:Emessage[m:PrivateSpecialistLetter]">
    <xsl:for-each select="m:PrivateSpecialistLetter">
      <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
        <table width="100%">
          <tbody>
            <tr>
              <xsl:call-template name="ShowMessageHeader">
                <xsl:with-param name="MessageName" select="'Speciallægeepikrise'"/>
              </xsl:call-template>
            </tr>
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <td valign="top">
                        <b>Behandling påbegyndt:</b>
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

  <!-- PhysiotherapyLetter -->
  <xsl:template match="m:Emessage[m:PhysiotherapyLetter]">
    <xsl:for-each select="m:PhysiotherapyLetter">
      <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
        <table width="100%">
          <tbody>
            <tr>
              <xsl:call-template name="ShowMessageHeader">
                <xsl:with-param name="MessageName" select="'Fysioterapiepikrise'"/>
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

  <xsl:template match="m:Emessage[m:PrivateSpecialistReferral]">
    <xsl:for-each select="m:PrivateSpecialistReferral">
      <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
        <table width="100%">
          <tbody>
            <tr>
              <xsl:call-template name="ShowMessageHeader">
                <xsl:with-param name="MessageName" select="'Speciallægehenvisning'"/>
              </xsl:call-template>
            </tr>
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <xsl:for-each select="m:AdditionalInformation/m:Priority">
                        <td valign="top">
                          <b>Prioritet:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <xsl:for-each select="m:AdditionalInformation/m:ReferralStatus">
                        <td valign="top">
                          <b>Henvisningstype:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <xsl:for-each select="m:AdditionalInformation/m:Transport">
                        <td valign="top">
                          <b>Transport:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <xsl:for-each select="m:AdditionalInformation/m:Supplementary">
                        <td valign="top">
                          <b>Andet:</b>
                        </td>
                        <td valign="top">
                          <xsl:apply-templates/>
                        </td>
                      </xsl:for-each>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <xsl:if test="count(m:Referral)>0">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b> Henvisnings diagnoser </b>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <table>
                            <tbody>
                              <xsl:for-each select="m:Referral/m:Refer">
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
                              <xsl:for-each select="m:Referral/m:ReferralAdditional">
                                <tr>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseDescriptionCode"/>: </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseText"/>
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
            <xsl:if test="count(m:AdditionalInformation/m:ClinicalReason)">
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <td valign="top">
                        <b> Ønsket undersøgelse/behandling/problemstilling </b>
                      </td>
                    </tr>
                    <tr>
                      <td valign="top">
                        <xsl:attribute name="bgcolor">
                          <xsl:value-of select="$highlightbgcolor"/>
                        </xsl:attribute>
                        <table>
                          <tbody>
                            <xsl:for-each select="m:AdditionalInformation/m:ClinicalReason">
                              <tr>
                                <td valign="top">
                                  <xsl:apply-templates/>
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
                <table width="100%">
                  <tbody>
                    <tr>
                      <td valign="top" width="100%">
                        <b> Kliniske oplysninger </b>
                      </td>
                    </tr>
                    <tr>
                      <xsl:attribute name="bgcolor">
                        <xsl:value-of select="$compoundbgcolor"/>
                      </xsl:attribute>
                      <td valign="top" width="100%">
                        <table width="100%">
                          <tbody>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Cave">
                              <tr>
                                <td>
                                  <b>Cave</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Anamnesis">
                              <tr>
                                <td>
                                  <b>Anamnese</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Examination">
                              <tr>
                                <td>
                                  <b>Undersøgelser/behandlinger</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:ActualMedicine">
                              <tr>
                                <td>
                                  <b>Aktuel medicin</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
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
            <xsl:if test="count(m:HospitalVisitation)>0">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b>Visitation (udfyldt af modtager)</b>
                        </td>
                      </tr>
                      <tr>
                        <td valign="top">
                          <table>
                            <tbody>
                              <xsl:for-each select="m:HospitalVisitation">
                                <tr>
                                  <td valign="top">
                                    <xsl:value-of select="m:InformationCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:for-each select="m:Information">
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
            </xsl:if>
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

  <!-- template til at vise en fysioterapeuthenvisning.  -->
  <xsl:template match="m:Emessage[m:PhysiotherapyReferral]">
    <xsl:for-each select="m:PhysiotherapyReferral">
      <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
        <table width="100%">
          <tbody>
            <tr>
              <xsl:call-template name="ShowMessageHeader">
                <xsl:with-param name="MessageName" select="'Fysioterapeuthenvisning'"/>
              </xsl:call-template>
            </tr>
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <xsl:for-each select="m:AdditionalInformation/m:Priority">
                        <td valign="top">
                          <b>Prioritet:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <xsl:for-each select="m:AdditionalInformation/m:ReferralStatus">
                        <td valign="top">
                          <b>Behandlingssted:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <xsl:for-each select="m:AdditionalInformation/m:Transport">
                        <td valign="top">
                          <b>Transport:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <xsl:for-each select="m:AdditionalInformation/m:Supplementary">
                        <td valign="top">
                          <b>Andet:</b>
                        </td>
                        <td valign="top">
                          <xsl:apply-templates/>
                        </td>
                      </xsl:for-each>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <xsl:if test="count(m:Referral)>0">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b> Henvisnings diagnoser </b>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <table>
                            <tbody>
                              <xsl:for-each select="m:Referral/m:Refer">
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
                              <xsl:for-each select="m:Referral/m:ReferralAdditional">
                                <tr>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseDescriptionCode"/>: </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseText"/>
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
            <xsl:if test="count(m:AdditionalInformation/m:ClinicalReason)">
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <td valign="top">
                        <b> Ønsket undersøgelse/behandling/problemstilling </b>
                      </td>
                    </tr>
                    <tr>
                      <td valign="top">
                        <xsl:attribute name="bgcolor">
                          <xsl:value-of select="$highlightbgcolor"/>
                        </xsl:attribute>
                        <table>
                          <tbody>
                            <xsl:for-each select="m:AdditionalInformation/m:ClinicalReason">
                              <tr>
                                <td valign="top">
                                  <xsl:apply-templates/>
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
                <table width="100%">
                  <tbody>
                    <tr>
                      <td valign="top" width="100%">
                        <b> Kliniske oplysninger </b>
                      </td>
                    </tr>
                    <tr>
                      <xsl:attribute name="bgcolor">
                        <xsl:value-of select="$compoundbgcolor"/>
                      </xsl:attribute>
                      <td valign="top" width="100%">
                        <table width="100%">
                          <tbody>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Cave">
                              <tr>
                                <td>
                                  <b>Cave</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Anamnesis">
                              <tr>
                                <td>
                                  <b>Anamnese</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Examination">
                              <tr>
                                <td>
                                  <b>Undersøgelser/behandlinger</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:ActualMedicine">
                              <tr>
                                <td>
                                  <b>Aktuel medicin</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
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
            <xsl:if test="count(m:HospitalVisitation)>0">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b>Visitation (udfyldt af modtager)</b>
                        </td>
                      </tr>
                      <tr>
                        <td valign="top">
                          <table>
                            <tbody>
                              <xsl:for-each select="m:HospitalVisitation">
                                <tr>
                                  <td valign="top">
                                    <xsl:value-of select="m:InformationCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:for-each select="m:Information">
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
            </xsl:if>
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

  <!-- template til at vise en fysioterapeuthenvisning.  -->
  <xsl:template match="m:Emessage[m:TeddyReferral]">
    <xsl:for-each select="m:TeddyReferral">
      <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
        <table width="100%">
          <tbody>
            <tr>
              <xsl:call-template name="ShowMessageHeader">
                <xsl:with-param name="MessageName" select="'Fysioterapeuthenvisning'"/>
              </xsl:call-template>
            </tr>
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <xsl:for-each select="m:AdditionalInformation/m:Priority">
                        <td valign="top">
                          <b>Prioritet:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <xsl:for-each select="m:AdditionalInformation/m:ReferralStatus">
                        <td valign="top">
                          <b>Behandlingssted:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <xsl:for-each select="m:AdditionalInformation/m:Transport">
                        <td valign="top">
                          <b>Transport:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <xsl:for-each select="m:AdditionalInformation/m:Supplementary">
                        <td valign="top">
                          <b>Andet:</b>
                        </td>
                        <td valign="top">
                          <xsl:apply-templates/>
                        </td>
                      </xsl:for-each>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <xsl:if test="count(m:Referral)>0">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b> Henvisnings diagnoser </b>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <table>
                            <tbody>
                              <xsl:for-each select="m:Referral/m:Refer">
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
                              <xsl:for-each select="m:Referral/m:ReferralAdditional">
                                <tr>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseDescriptionCode"/>: </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseText"/>
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
            <xsl:if test="count(m:AdditionalInformation/m:ClinicalReason)">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b> Ønsket undersøgelse/behandling/problemstilling </b>
                        </td>
                      </tr>
                      <tr>
                        <td valign="top">
                          <xsl:attribute name="bgcolor">
                            <xsl:value-of select="$highlightbgcolor"/>
                          </xsl:attribute>
                          <table>
                            <tbody>
                              <xsl:for-each select="m:AdditionalInformation/m:ClinicalReason">
                                <tr>
                                  <td valign="top">
                                    <xsl:apply-templates/>
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
                <table width="100%">
                  <tbody>
                    <tr>
                      <td valign="top" width="100%">
                        <b> Kliniske oplysninger </b>
                      </td>
                    </tr>
                    <tr>
                      <xsl:attribute name="bgcolor">
                        <xsl:value-of select="$compoundbgcolor"/>
                      </xsl:attribute>
                      <td valign="top" width="100%">
                        <table width="100%">
                          <tbody>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Cave">
                              <tr>
                                <td>
                                  <b>Cave</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Anamnesis">
                              <tr>
                                <td>
                                  <b>Anamnese</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Examination">
                              <tr>
                                <td>
                                  <b>Undersøgelser/behandlinger</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:ActualMedicine">
                              <tr>
                                <td>
                                  <b>Aktuel medicin</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
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
            <xsl:if test="count(m:HospitalVisitation)>0">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b>Visitation (udfyldt af modtager)</b>
                        </td>
                      </tr>
                      <tr>
                        <td valign="top">
                          <table>
                            <tbody>
                              <xsl:for-each select="m:HospitalVisitation">
                                <tr>
                                  <td valign="top">
                                    <xsl:value-of select="m:InformationCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:for-each select="m:Information">
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
            </xsl:if>
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

  <!-- template til at vise en psykologhenvisning.  -->
  <xsl:template match="m:Emessage[m:PsychologistReferral]">
    <xsl:for-each select="m:PsychologistReferral">
      <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
        <table width="100%">
          <tbody>
            <tr>
              <xsl:call-template name="ShowMessageHeader">
                <xsl:with-param name="MessageName" select="'Psykologhenvisning'"/>
              </xsl:call-template>
            </tr>
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <xsl:for-each select="m:AdditionalInformation/m:Priority">
                        <td valign="top">
                          <b>Prioritet:</b>
                        </td>
                        <td valign="top">
                          <xsl:value-of select="."/>
                        </td>
                      </xsl:for-each>
                      <!-- xsl:for-each select="m:AdditionalInformation/m:ReferralStatus">
												<td valign="top">
													<b>Henvisningstype:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each-->
                      <!-- xsl:for-each select="m:AdditionalInformation/m:Transport">
												<td valign="top">
													<b>Transport:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each-->
                      <xsl:for-each select="m:AdditionalInformation/m:Supplementary">
                        <td valign="top">
                          <b>Andet:</b>
                        </td>
                        <td valign="top">
                          <xsl:apply-templates/>
                        </td>
                      </xsl:for-each>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <xsl:if test="count(m:Referral)>0">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b> Henvisningsårsag </b>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <table>
                            <tbody>
                              <xsl:for-each select="m:Referral/m:Refer">
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
                              <xsl:for-each select="m:Referral/m:ReferralAdditional">
                                <tr>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseDescriptionCode"/>: </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:value-of select="m:DiagnoseText"/>
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
            <xsl:if test="count(m:AdditionalInformation/m:ClinicalReason)">
            <tr>
              <td valign="top" width="100%">
                <table>
                  <tbody>
                    <tr>
                      <td valign="top">
                        <b> Ønsket undersøgelse/behandling/problemstilling </b>
                      </td>
                    </tr>
                    <tr>
                      <td valign="top">
                        <xsl:attribute name="bgcolor">
                          <xsl:value-of select="$highlightbgcolor"/>
                        </xsl:attribute>
                        <table>
                          <tbody>
                            <xsl:for-each select="m:AdditionalInformation/m:ClinicalReason">
                              <tr>
                                <td valign="top">
                                  <xsl:apply-templates/>
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
                <table width="100%">
                  <tbody>
                    <tr>
                      <td valign="top" width="100%">
                        <b> Kliniske oplysninger </b>
                      </td>
                    </tr>
                    <tr>
                      <xsl:attribute name="bgcolor">
                        <xsl:value-of select="$compoundbgcolor"/>
                      </xsl:attribute>
                      <td valign="top" width="100%">
                        <table width="100%">
                          <tbody>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Cave">
                              <tr>
                                <td>
                                  <b>Cave</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Anamnesis">
                              <tr>
                                <td>
                                  <b>Anamnese</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:Examination">
                              <tr>
                                <td>
                                  <b>Undersøgelser/behandlinger</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </xsl:for-each>
                            <xsl:for-each select="m:RelevantClinicalInformation/m:ActualMedicine">
                              <tr>
                                <td>
                                  <b>Aktuel medicin</b>
                                </td>
                              </tr>
                              <tr>
                                <td>
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td valign="top">
                                          <xsl:apply-templates/>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
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
            <xsl:if test="count(m:HospitalVisitation)>0">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <tbody>
                      <tr>
                        <td valign="top">
                          <b>Visitation (udfyldt af modtager)</b>
                        </td>
                      </tr>
                      <tr>
                        <td valign="top">
                          <table>
                            <tbody>
                              <xsl:for-each select="m:HospitalVisitation">
                                <tr>
                                  <td valign="top">
                                    <xsl:value-of select="m:InformationCode"/>
                                  </td>
                                  <td valign="top">
                                    <xsl:for-each select="m:Information">
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
            </xsl:if>
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

  <!--  DIABETESREPORT -->
  <xsl:template match="m:Emessage[m:DiabetesReport	]">
    <td>
      <table width="100%">
        <tbody>
          <xsl:for-each select="m:DiabetesReport">
            <tr>
              <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
                <table width="100%">
                  <tbody>
                    <!--<tr>
											<xsl:call-template name="ShowMessageHeader">
												<xsl:with-param name="MessageName" select="'DiabetesReport'"/>
											</xsl:call-template>
										</tr>-->
                    <tr>
                      <td align="center">
                        <font color="#ff0000">Dette er en tilnrmelse til det officielle
                          indberetningsskema, der kun skal benyttes i testjemed.</font>
                      </td>
                    </tr>
                    <tr>
                      <th>
                        <h2>REGISTRERINGSSKEMA</h2>
                      </th>
                    </tr>
                    <tr>
                      <th>
                        <h1>NIP-DIABETES</h1>
                      </th>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%" bgcolor="#cccccc">
                          <tbody>
                            <tr>
                              <td>
                                <table border="0" width="100%">
                                  <tbody>
                                    <tr>
                                      <tr>
                                        <td colspan="2">Skemaet skal udfyldes n gang om ret for alle
                                          diabetespatienter ( alder 18+) med flgende
                                        diagnosekoder:</td>
                                      </tr>
                                      <tr>
                                        <td width="10px"/>
                                        <td>
                                          <ul>
                                            <li>E10.0 - E10.9: Insulinkrvende sukkersyge (IDDM)</li>
                                            <li>E11.0 - E11.9: Ikke insulinkrvende sukkersyge
                                              (NIDDM)</li>
                                            <li>E13.0 - E13.9: Anden form for sukkersyge</li>
                                            <li>E14.0 - E14.9: Sukkersyge uden specifikation</li>
                                          </ul>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td colspan="2">Der henvises til "Datadefinitioner for
                                          NIP-diabetes" for specifikation af registreringen (<a
                                            href="http://www.nip.dk" target="newwindow"
                                          >www.nip.dk</a>)</td>
                                      </tr>
                                      <tr>
                                        <td width="10px"/>
                                        <td align="right">Revideret maj 2007, Det koordinerende
                                          Sekretariat</td>
                                      </tr>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="ccccccc">
                              <td colspan="2">
                                <b>Indberettende enhed:</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%"> Dataindberettende enhed i relation til
                                aktuelle indberetning: </td>
                              <td valign="top">
                                <table width="100%">
                                  <tbody>
                                    <tr>
                                      <td valign="top" width="30%">
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="m:Sender/m:IdentifierCode='ydernummer' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Almen praksis </td>
                                      <td valign="top">
                                        <input type="text" size="3" readonly="true">
                                          <xsl:if test="m:Sender/m:IdentifierCode='ydernummer' ">
                                            <xsl:attribute name="Value">
                                              <xsl:value-of select="m:Sender/m:Identifier"/>
                                            </xsl:attribute>
                                          </xsl:if>
                                        </input> ydernr </td>
                                    </tr>
                                    <tr>
                                      <td valign="top" width="30%">
                                        <input type="checkbox" disabled="true">
                                          <xsl:if
                                            test="m:Sender/m:IdentifierCode='sygehusafdelingsnummer' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Sygehus </td>
                                      <td valign="top">
                                        <input type="text" size="1" readonly="true">
                                          <xsl:if
                                            test="m:Sender/m:IdentifierCode='sygehusafdelingsnummer' ">
                                            <xsl:attribute name="Value">
                                              <xsl:value-of
                                                select="substring(m:Sender/m:Identifier,1,4)"/>
                                            </xsl:attribute>
                                          </xsl:if>
                                        </input> sgh <input type="text" size="1" readonly="true">
                                          <xsl:if
                                            test="m:Sender/m:IdentifierCode='sygehusafdelingsnummer' ">
                                            <xsl:attribute name="Value">
                                              <xsl:value-of
                                                select="substring(m:Sender/m:Identifier,5,2)"/>
                                            </xsl:attribute>
                                          </xsl:if>
                                        </input> afd </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Statusdato</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%"> Den dato (mned/r), hvor den ansvarlige
                                behandler gr status over patientens behandling </td>
                              <td valign="top">
                                <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:StatusDate/m:Date,6,2)}"/> mm <input
                                  type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:StatusDate/m:Date,3,2)}"/>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Patient data</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Patientents cpr.nr.:</b>
                              </td>
                              <td valign="top">
                                <input size="3" readonly="true"
                                  value="{substring(m:Patient/m:CivilRegistrationNumber,1,6)}"
                                  />-<input size="1" readonly="true"
                                  value="{substring(m:Patient/m:CivilRegistrationNumber,7,4)}"/>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Fornavn(e):</b>
                              </td>
                              <td valign="top">
                                <input type="text" readonly="true"
                                  value="{m:Patient/m:PersonGivenName}"/>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Efternavn:</b>
                              </td>
                              <td valign="top">
                                <input type="text" readonly="true"
                                  value="{m:Patient/m:PersonSurnameName}"/>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>PatientForlb</b>
                              </td>
                            </tr>
                            <tr>
                              <td width="30%"> Patienten gr aktuelt til behandling for diabetes bde
                                hos egen lge og i diabetesambulatorium / anden afdeling p sygehuset </td>
                              <td>
                                <xsl:variable name="YN" select="m:Report/m:SharedCare"/>
                                <table width="100%">
                                  <tbody>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$YN = 'ja' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Ja </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Diagnose</b>
                              </td>
                            </tr>
                            <tr>
                              <td width="30%">
                                <b>Diagnoser og -mned</b>
                              </td>
                              <td valign="top">
                                <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Diagnose/m:DiagnoseDate/m:Date,6,2)}"
                                /> mm <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Diagnose/m:DiagnoseDate/m:Date,3,2)}"/>
                                <input type="checkbox" disabled="true">
                                  <xsl:if test="count(m:Report/m:Diagnose/m:DiagnoseDate/m:Date)=0 ">
                                    <xsl:attribute name="checked">1</xsl:attribute>
                                  </xsl:if>
                                </input> Uoplyst </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Diagnosetype</b>
                              </td>
                              <td valign="top">
                                <table width="100%">
                                  <tbody>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if
                                            test="m:Report/m:Diagnose/m:DiagnoseType = 'type1' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Type 1 Diabetes </td>
                                    </tr>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if
                                            test="m:Report/m:Diagnose/m:DiagnoseType = 'type2' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Type 2 Diabetes </td>
                                    </tr>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if
                                            test="m:Report/m:Diagnose/m:DiagnoseType = 'anden_diabetes_form' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Anden form for diabetes </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Eventuel SKS kode</b>
                              </td>
                              <td valign="top">
                                <input type="text" readonly="true"
                                  value="{m:Report/m:Diagnose/m:ClassificationCode}"/>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Supplerende oplysninger</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Rygning</b>
                              </td>
                              <td valign="top">
                                <xsl:variable name="SS" select="m:Report/m:History/m:SmokingStatus"/>
                                <table width="100%">
                                  <tbody>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$SS = 'ryger_dagligt' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Ryger dagligt </td>
                                    </tr>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$SS = 'ryger_lejlighedsvist' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Ryger lejlighedsvist </td>
                                    </tr>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$SS = 'eksryger' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Eks-ryger (i over r) </td>
                                    </tr>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$SS = 'aldrig_ryger' ">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Aldrig ryger </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Body Mass Index</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <br/>
                                <table width="100%">
                                  <tbody>
                                    <tr>
                                      <td colspan="3">
                                        <b>Er hjden relevant:</b>
                                      </td>
                                    </tr>
                                    <tr>
                                      <xsl:variable name="isHIrrelevant"
                                        select="m:Report/m:Examinations/m:Height/m:Examinated"/>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$isHIrrelevant">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Nej </td>
                                      <td align="right">
                                        <i>...hvis ja:</i>
                                      </td>
                                      <td width="5px"/>
                                    </tr>
                                    <tr>
                                      <td colspan="3">
                                        <xsl:text>&#160;</xsl:text>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td colspan="3">
                                        <b>Er vgten relevant:</b>
                                      </td>
                                    </tr>
                                    <tr>
                                      <xsl:variable name="isWIrrelevant"
                                        select="m:Report/m:Examinations/m:Weight/m:Examinated"/>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$isWIrrelevant">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Nej </td>
                                      <td align="right">
                                        <i>...hvis ja:</i>
                                      </td>
                                      <td width="5px"/>
                                    </tr>
                                  </tbody>
                                </table>
                                <br/> BMI beregnes automatisk ved den elektroniske indtastning i
                                KMS, nr patientens hjde og vgt er udfyldt </td>
                              <td valign="top">
                                <br/>
                                <table>
                                  <tbody>
                                    <tr>
                                      <td colspan="3">
                                        <xsl:text>&#160;</xsl:text>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td valign="top">Hjde: </td>
                                      <td valign="top">
                                        <input size="1" readonly="true"
                                          value="{m:Report/m:Examinations/m:Height/m:Value}"/>
                                      </td>
                                      <td valign="top">(hele cm)</td>
                                    </tr>
                                    <tr>
                                      <td colspan="3">
                                        <xsl:text>&#160;</xsl:text>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td colspan="3">
                                        <xsl:text>&#160;</xsl:text>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td valign="top">Vgt: </td>
                                      <td valign="top">
                                        <input size="1" readonly="true"
                                          value="{m:Report/m:Examinations/m:Weight/m:Value}"/>
                                      </td>
                                      <td valign="top">(hele kg)</td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Blodtryk</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Dato for seneste blodtryksmling</b>
                                <br/>
                                <br/>
                                <b>Resultat for seneste blodtryksmling (siddende)</b>
                              </td>
                              <td valign="top">
                                <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:BloodPressure/m:ExaminationDate/m:Date,6,2)}"
                                /> mm <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:BloodPressure/m:ExaminationDate/m:Date,3,2)}"/>
                                <br/>
                                <br/>
                                <table>
                                  <tbody>
                                    <tr>
                                      <td valign="top">Systolisk BT: </td>
                                      <td valign="top">
                                        <input size="1" readonly="true">
                                          <xsl:if
                                            test="m:Report/m:Examinations/m:BloodPressure/m:SystolicValue">
                                            <xsl:attribute name="Value">
                                              <xsl:value-of
                                                select="m:Report/m:Examinations/m:BloodPressure/m:SystolicValue"
                                              />
                                            </xsl:attribute>
                                          </xsl:if>
                                        </input>
                                      </td>
                                      <td valign="top">mm Hg</td>
                                    </tr>
                                    <tr>
                                      <td valign="top">Diastolisk BT:</td>
                                      <td valign="top">
                                        <input size="1" readonly="true">
                                          <xsl:if
                                            test="m:Report/m:Examinations/m:BloodPressure/m:DiastolicValue">
                                            <xsl:attribute name="Value">
                                              <xsl:value-of
                                                select="m:Report/m:Examinations/m:BloodPressure/m:DiastolicValue"
                                              />
                                            </xsl:attribute>
                                          </xsl:if>
                                        </input>

                                      </td>
                                      <td valign="top">mm Hg</td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Metabolisk eller glykmisk regulering</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Dato for seneste mling af HbA1c</b>
                                <br/>
                                <br/>
                                <b>Resultat for seneste mling af HbA1c</b>
                              </td>
                              <td valign="top">
                                <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:HbA1c/m:ExaminationDate/m:Date,6,2)}"
                                /> mm <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:HbA1c/m:ExaminationDate/m:Date,3,2)}"/>
                                <br/>
                                <br/>
                                <input size="1" readonly="true">
                                  <xsl:if test="m:Report/m:Examinations/m:HbA1c/m:ExaminationDate">
                                    <xsl:attribute name="value">
                                      <xsl:value-of
                                        select="format-number(m:Report/m:Examinations/m:HbA1c/m:Value *100,'##.#')"
                                      />
                                    </xsl:attribute>

                                  </xsl:if>
                                </input> % (n decimal) </td>
                            </tr>
                            <tr>
                              <td>
                                <b>Eventuel SKS kode</b>
                              </td>
                              <td>
                                <input type="text" readonly="true">
                                  <xsl:if test="m:Report/m:Examinations/m:HbA1c/m:ExaminationCode">
                                    <xsl:attribute name="value">
                                      <xsl:value-of
                                        select="m:Report/m:Examinations/m:HbA1c/m:ExaminationCode"/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </input>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Urin-albumin</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Er det relevant at undersge for albuminuri:</b>
                                <br/>
                                <br/>
                                <xsl:variable name="isAlbuIrrelevant"
                                  select="m:Report/m:Examinations/m:Albuminuri/m:Examinated"/>
                                <table width="100%">
                                  <tbody>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$isAlbuIrrelevant">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Nej </td>
                                      <td align="right">
                                        <i>...hvis ja:</i>
                                      </td>
                                      <td width="5px"/>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                              <td valign="top">
                                <br/>
                                <br/> Tidspunkt for senest udfrte mling: <input type="text" size="1"
                                  readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:Albuminuri/m:ExaminationDate/m:Date,6,2)}"
                                /> mm <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:Albuminuri/m:ExaminationDate/m:Date,3,2)}"/>
                                <br/>
                                <br/>
                                <table width="100%">
                                  <tbody>
                                    <tr>
                                      <td valign="top">Resultat af senest registrerede mling: <br/>
                                        (kun n af kategorierene udfyldes)</td>
                                      <td valign="top">Albumin-udskillelseshastighed: <table
                                          width="100%">
                                          <tbody>
                                            <tr>
                                              <td valign="top" align="right" width="50px">
                                                <input size="1" readonly="true"
                                                  value="{m:Report/m:Examinations/m:Albuminuri/m:Value/m:GramPer24h}"
                                                />
                                              </td>
                                              <td valign="top">g/dgn</td>
                                            </tr>
                                            <tr>
                                              <td valign="top" align="right" width="50px">
                                                <input size="1" readonly="true"
                                                  value="{m:Report/m:Examinations/m:Albuminuri/m:Value/m:MilligramPer24h}"
                                                />
                                              </td>
                                              <td valign="top">mg/dgn</td>
                                            </tr>
                                            <tr>
                                              <td valign="top" align="right" width="50px">
                                                <input size="1" readonly="true"
                                                  value="{m:Report/m:Examinations/m:Albuminuri/m:Value/m:MicromolPer24h}"
                                                />
                                              </td>
                                              <td valign="top">mikromol/dgn</td>
                                            </tr>
                                            <tr>
                                              <td valign="top" align="right" width="50px">
                                                <input size="1" readonly="true"
                                                  value="{m:Report/m:Examinations/m:Albuminuri/m:Value/m:MicrogramPerMin}"
                                                />
                                              </td>
                                              <td valign="top">mikrogram/min</td>
                                            </tr>
                                          </tbody>
                                        </table>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td valign="top"/>
                                      <td valign="top">Albumin-kreatinin-ratio: <table width="100%">
                                          <tbody>
                                            <tr>
                                              <td valign="top" align="right" width="50px">
                                                <input size="1" readonly="true"
                                                  value="{m:Report/m:Examinations/m:Albuminuri/m:Value/m:MilligramPerGram}"
                                                />
                                              </td>
                                              <td valign="top">mg/g</td>
                                            </tr>
                                            <tr>
                                              <td valign="top" align="right" width="50px">
                                                <input size="1" readonly="true"
                                                  value="{m:Report/m:Examinations/m:Albuminuri/m:Value/m:MilligramPerMillimol}"
                                                />
                                              </td>
                                              <td valign="top">mg/mmol</td>
                                            </tr>
                                            <tr>
                                              <td valign="top" align="right" width="50px">
                                                <input size="1" readonly="true"
                                                  value="{m:Report/m:Examinations/m:Albuminuri/m:Value/m:MicromolPerMillimol}"
                                                />
                                              </td>
                                              <td valign="top">mikromol/millimol</td>
                                            </tr>
                                          </tbody>
                                        </table>
                                      </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <b>Eventuel SKS kode</b>
                              </td>
                              <td>
                                <input type="text" readonly="true"
                                  value="{m:Report/m:Examinations/m:Albuminuri/m:ExaminationCode}"/>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Lipider</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Tidspunkt for senest udfrte (fulde) lipid mling:</b>
                                <br/>
                                <br/>
                                <b>Resultat af senest udfrte lipid status:</b>
                              </td>
                              <td valign="top">
                                <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:Lipids/m:ExaminationDate/m:Date,6,2)}"
                                /> mm <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:Lipids/m:ExaminationDate/m:Date,3,2)}"/>
                                <br/>
                                <br/>
                                <table>
                                  <tbody>
                                    <tr>
                                      <td valign="top">Total cholesterol: </td>
                                      <td valign="top" align="right" width="50px">
                                        <input size="1" readonly="true"
                                          value="{m:Report/m:Examinations/m:Lipids/m:TotalCholesterol/m:Value}"
                                        />
                                      </td>
                                      <td valign="top">mmol/l</td>
                                      <td width="20px">&#160;</td>
                                      <td>Eventuel SKS kode: </td>
                                      <td colspan="2">
                                        <input type="text" readonly="true"
                                          value="{m:Report/m:Examinations/m:Lipids/m:TotalCholesterol/m:ExaminationCode}"
                                        />
                                      </td>

                                    </tr>
                                    <tr>
                                      <td valign="top">HDL-cholestorol:</td>
                                      <td valign="top" align="right" width="50px">
                                        <input size="1" readonly="true"
                                          value="{m:Report/m:Examinations/m:Lipids/m:HDLCholesterol/m:Value}"
                                        />
                                      </td>
                                      <td valign="top">mmol/l</td>
                                      <td width="20px">&#160;</td>
                                      <td>Eventuel SKS kode: </td>
                                      <td colspan="2">
                                        <input type="text" readonly="true"
                                          value="{m:Report/m:Examinations/m:Lipids/m:HDLCholesterol/m:ExaminationCode}"
                                        />
                                      </td>

                                    </tr>
                                    <tr>
                                      <td valign="top">LDL-cholesterol:</td>
                                      <td valign="top" align="right" width="50px">
                                        <input size="1" readonly="true"
                                          value="{m:Report/m:Examinations/m:Lipids/m:LDLCholesterol/m:Value}"
                                        />
                                      </td>
                                      <td valign="top">mmol/l</td>
                                      <td width="20px">&#160;</td>
                                      <td>Eventuel SKS kode: </td>
                                      <td colspan="2">
                                        <input type="text" readonly="true"
                                          value="{m:Report/m:Examinations/m:Lipids/m:LDLCholesterol/m:ExaminationCode}"
                                        />
                                      </td>

                                    </tr>
                                    <tr>
                                      <td valign="top">Triglycerid:</td>
                                      <td valign="top" align="right" width="50px">
                                        <input size="1" readonly="true"
                                          value="{m:Report/m:Examinations/m:Lipids/m:Triglycerid/m:Value}"
                                        />
                                      </td>
                                      <td valign="top">mmol/l</td>
                                      <td width="20px">&#160;</td>
                                      <td>Eventuel SKS kode: </td>
                                      <td colspan="2">
                                        <input type="text" readonly="true"
                                          value="{m:Report/m:Examinations/m:Lipids/m:Triglycerid/m:ExaminationCode}"
                                        />
                                      </td>

                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Aktuel behandling</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Fr patienten peroral antidiabetika:</b>
                              </td>
                              <td valign="top">
                                <input type="checkbox" disabled="true">
                                  <xsl:if
                                    test="m:Report/m:CurrentTreatment/m:PeroralAntidiabetics/m:Treatment= 'ja' ">
                                    <xsl:attribute name="checked">1</xsl:attribute>
                                  </xsl:if>
                                </input> Ja </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Er patienten i insulinbehandling:</b>
                              </td>
                              <td valign="top">
                                <input type="checkbox" disabled="true">
                                  <xsl:if
                                    test="m:Report/m:CurrentTreatment/m:Insulin/m:Treatment= 'ja' ">
                                    <xsl:attribute name="checked">1</xsl:attribute>
                                  </xsl:if>
                                </input> Ja </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Er patienten i antihypertensiv behandling:</b>
                              </td>
                              <td valign="top">
                                <input type="checkbox" disabled="true">
                                  <xsl:if
                                    test="m:Report/m:CurrentTreatment/m:AntiHypertensive/m:Treatment= 'ja' ">
                                    <xsl:attribute name="checked">1</xsl:attribute>
                                  </xsl:if>
                                </input> Ja </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Er patienten i behandling med ACE hmmer / Angiotensin II
                                  antagonister (ATIIR):</b>
                              </td>
                              <td valign="top">
                                <input type="checkbox" disabled="true">
                                  <xsl:if
                                    test="m:Report/m:CurrentTreatment/m:ACEInhibitor/m:Treatment= 'ja' ">
                                    <xsl:attribute name="checked">1</xsl:attribute>
                                  </xsl:if>
                                </input> Ja </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Er patienten i medicinsk behandling for dyslipidmi:</b>
                              </td>
                              <td valign="top">
                                <input type="checkbox" disabled="true">
                                  <xsl:if
                                    test="m:Report/m:CurrentTreatment/m:Dyslipidemia/m:Treatment= 'ja' ">
                                    <xsl:attribute name="checked">1</xsl:attribute>
                                  </xsl:if>
                                </input> Ja </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Komplikations screening</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Er jenundersgelse relevant:</b>
                                <br/>
                                <br/>
                                <xsl:variable name="isEyeIrrelevant"
                                  select="m:Report/m:Examinations/m:EyeExamination/m:Examinated"/>
                                <table width="100%">
                                  <tbody>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$isEyeIrrelevant">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Nej </td>
                                      <td align="right">
                                        <i>...hvis ja:</i>
                                      </td>
                                      <td width="5px"/>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                              <td valign="top">
                                <br/>
                                <br/> Tidspunkt for senest udfrte undersgelse: <input type="text"
                                  size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:EyeExamination/m:ExaminationDate/m:Date,6,2)}"
                                /> mm <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:EyeExamination/m:ExaminationDate/m:Date,3,2)}"
                                />
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:text>&#160;</xsl:text>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
                          width="100%">
                          <tbody>
                            <tr bgcolor="cccccc">
                              <td colspan="2">
                                <b>Komplikations screening</b>
                              </td>
                            </tr>
                            <tr>
                              <td valign="top" width="30%">
                                <b>Er fodundersgelse relevant:</b>
                                <br/>
                                <br/>
                                <xsl:variable name="isFootIrrelevant"
                                  select="m:Report/m:Examinations/m:FootExamination/m:Examinated"/>
                                <table width="100%">
                                  <tbody>
                                    <tr>
                                      <td>
                                        <input type="checkbox" disabled="true">
                                          <xsl:if test="$isFootIrrelevant">
                                            <xsl:attribute name="checked">1</xsl:attribute>
                                          </xsl:if>
                                        </input> Nej </td>
                                      <td align="right">
                                        <i>...hvis ja:</i>
                                      </td>
                                      <td width="5px"/>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                              <td valign="top">
                                <br/>
                                <br/> Tidspunkt for senest udfrte undersgelse: <input type="text"
                                  size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:FootExamination/m:ExaminationDate/m:Date,6,2)}"
                                /> mm <input type="text" size="1" readonly="true"
                                  value="{substring(m:Report/m:Examinations/m:FootExamination/m:ExaminationDate/m:Date,3,2)}"
                                />
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>

                    <tr>
                      <th>
                        <h3>Det Nationale Indikatorprojekt Lyseng All 1, 8270 Hjbjerg</h3>
                      </th>
                    </tr>
                    <tr>
                      <td align="center"> Tlf. 89 44 69 74, <a
                          href="mailto:fagligkvalitet@ag.aaa.dk">fagligkvalitet@ag.aaa.dk</a>, <a
                          href="http://www.nip.dk">www.nip.dk</a>
                      </td>
                    </tr>

                  </tbody>
                </table>
              </td>
            </tr>
            <tr bgcolor="#000000">
              <td>
                <xsl:text>&#160;</xsl:text>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </td>
  </xsl:template>

	<!--  MICROBIOLOGYREPORT -->
	<xsl:template match="m:Emessage[m:MicrobiologyReport]">
		<xsl:for-each select="m:MicrobiologyReport">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Mikrobiologisvar'"/>
							</xsl:call-template>
						</tr>
					  <!--<tr>
					    <td>
					      <xsl:variable name="url">
					        https://www.sundhed.dk/wps/myportal/_s.155/4518?parameter_navn=cprnr_field&amp;cprnrfield=<xsl:value-of select="m:Patient/m:CivilRegistrationNumber"/>
					      </xsl:variable>
					      <a><xsl:attribute name="href"><xsl:value-of select="$url"/></xsl:attribute>Beskrivelse på Sundhed.dk</a>
					    </td>
					  </tr>-->
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SamplingDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Prøve modtaget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SampleReceivedDateTime">
													<!--ikke som i microbiologi (der er det under sample)-->
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<xsl:variable name="RS" select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultStatus"/>
												<xsl:choose>
													<xsl:when test="$RS='modtaget'">
														<b>Modtagelse bekræftet:</b>
													</xsl:when>
													<xsl:when test="$RS='delvis'">
														<b>Delvist svar:</b>
													</xsl:when>
													<xsl:when test="$RS='komplet'">
														<b>Komplet svar:</b>
													</xsl:when>
													<xsl:otherwise>
														<b>Svaret:</b>
													</xsl:otherwise>
												</xsl:choose>
											</td>
											<td valign="top">
												<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:for-each select="m:RequisitionInformation/m:Comments">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Kommentarer til rekvisitionen
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select=".">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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
						</xsl:for-each>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Resultater</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<tr>
															<td valign="top">
																<b>Analysetype</b>
															</td>
															<td valign="top">
																<b>Analyse</b>
															</td>
															<td valign="top">
																<b>Undersøgelse</b>
															</td>
															<td valign="top">
																<b>Materiale</b>
															</td>
															<td valign="top">
																<b>Lokation</b>
															</td>
															<td valign="top">
																<b>Værdi</b>
															</td>
															<td valign="top">
																<b>Bem.</b>
															</td>
															<td valign="top">
																<b>Enhed</b>
															</td>
															<td valign="top">
																<b>Reference</b>
															</td>
															<td valign="top">
																<b>Status</b>
															</td>
														</tr>
														<xsl:for-each select="m:LaboratoryResults/m:Result">
															<xsl:variable name="RNr" select="position()"/>
															<xsl:variable name="CNr" select="count(../m:Result[position()&lt;=$RNr and count(m:ResultTextValue|m:ResultComments)>0])"/>
															<xsl:variable name="isevenrow" select="position() mod 2 = 0"/>
															<tr>
																<xsl:if test="not($isevenrow)">
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																</xsl:if>
																<xsl:if test="$isevenrow">
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																</xsl:if>
																<td valign="top">
																	<xsl:value-of select="m:Analysis/m:ExaminationTypeCode"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="concat(m:Analysis/m:AnalysisShortName,' (',m:Analysis/m:MICAnalysisCode,':',m:Analysis/m:AnalysisCodeResponsible,')')"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Analysis/m:AnalysisMDSName/m:Examination"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Analysis/m:AnalysisMDSName/m:Material"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Analysis/m:AnalysisMDSName/m:Location"/>
																</td>
																<td valign="top">
																	<xsl:variable name="RV" select="m:ResultValidation"/>
																  <xsl:if test="m:ProducerOfLabResult">
																    <xsl:attribute name="title"><xsl:text>Producent: </xsl:text><xsl:value-of select="m:ProducerOfLabResult"/></xsl:attribute>
																  </xsl:if>
																	<xsl:choose>
																		<xsl:when test="$RV='unormal' ">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$valueabnormbgcolor"/></xsl:attribute>
																		</xsl:when>
																		<xsl:when test="$RV='for_hoej' ">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetohighbgcolor"/></xsl:attribute>
																		</xsl:when>
																		<xsl:when test="$RV='for_lav' ">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetolowbgcolor"/></xsl:attribute>
																		</xsl:when>
																	</xsl:choose>
																	<xsl:variable name="O" select="m:Operator"/>
																	<xsl:choose>
																		<xsl:when test="$O='mindre_end'">&amp;lt;</xsl:when>
																		<xsl:when test="$O='stoerre_end'">&amp;gt;</xsl:when>
																	</xsl:choose>
																	<xsl:value-of select="m:Value"/>
																  
																</td>
																<td valign="top">
																	<font size="1">
																		<xsl:if test="count(m:ResultTextValue|m:ResultComments)>0">
																			<xsl:value-of select="$CNr"/>
																		</xsl:if>
																	</font>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Unit"/>
																</td>
																<td valign="top">
																	<xsl:if test="count(m:ReferenceInterval/m:LowerLimit|m:ReferenceInterval/m:UpperLimit)>0">
																		<xsl:value-of select="concat(m:ReferenceInterval/m:LowerLimit,'-',m:ReferenceInterval/m:UpperLimit)"/>
																	</xsl:if>
																	<xsl:value-of select="m:ReferenceInterval/m:IntervalText"/>
																</td>
																<td>
																	<xsl:value-of select="m:ResultStatusCode"/>
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
						<xsl:if test="count(m:LaboratoryResults/m:Result/m:ResultComments)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Bemærkninger</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:LaboratoryResults/m:Result[count(m:ResultTextValue|m:ResultComments)>0]">
																<xsl:variable name="RNr" select="position()"/>
																<tr>
																	<td valign="top">
																		<font size="1">
																			<xsl:value-of select="$RNr"/>
																		</font>
																	</td>
																	<td valign="top">
																		<table>
																			<tbody>
																				<xsl:for-each select="m:ResultTextValue|m:ResultComments">
																					<tr>
																						<!--<xsl:if test="not($isevenrow)"><xsl:attribute name="bgcolor">dddddd</xsl:attribute></xsl:if>-->
																						<td valign="top">
																							<xsl:if test="name()='ResultTextValue' ">Værdi</xsl:if>
																							<xsl:if test="name()='ResultComments' ">Bem.</xsl:if>
																						</td>
																						<td valign="top">
																							<xsl:apply-templates/>
																						</td>
																					</tr>
																				</xsl:for-each>
																			</tbody>
																		</table>
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
												<b>
													<xsl:value-of select="m:LaboratoryResults/m:MicroscopicFindings/m:Headline"/>
												</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:apply-templates select="m:LaboratoryResults/m:MicroscopicFindings/m:Comments/text()|m:LaboratoryResults/m:MicroscopicFindings/m:Comments/*"/>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
													<xsl:value-of select="m:LaboratoryResults/m:CultureWithoutFindings/m:Headline"/>
												</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:apply-templates select="m:LaboratoryResults/m:CultureWithoutFindings/m:Comments/text()|m:LaboratoryResults/m:CultureWithoutFindings/m:Comments/*"/>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
													<xsl:value-of select="m:LaboratoryResults/m:CultureWithFindings/m:Headline"/>
												</b>
											</td>
										</tr>
										<xsl:for-each select="m:LaboratoryResults/m:CultureWithFindings/m:Microorganism">
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">(<xsl:value-of select="position()"/>)</td>
																<td valign="top">
																	<xsl:value-of select="m:GrowthValue"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Name"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:MultiResistance"/>
																</td>
															</tr>
														</tbody>
													</table>
												</td>
											</tr>
										</xsl:for-each>
										<tr>
											<xsl:for-each select="m:LaboratoryResults/m:CultureWithFindings/m:Pattern/m:PatternEntry[1]">
												<tr>
													<td valign="top">
														<xsl:call-template name="ShowTable2">
															<xsl:with-param name="ColNames" select="../../m:Microorganism/m:Name"/>
															<xsl:with-param name="RowNames" select="../m:Antibiotic"/>
															<xsl:with-param name="ColIdxs" select="../m:PatternEntry/m:RefMicroorganism"/>
															<xsl:with-param name="RowIdxs" select="../m:PatternEntry/m:RefAntibiotic"/>
															<xsl:with-param name="Values" select="../m:PatternEntry/m:Sensitivity"/>
														</xsl:call-template>
													</td>
												</tr>
											</xsl:for-each>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<tr>
															<xsl:for-each select="m:LaboratoryResults/m:CultureWithFindings/m:Pattern/m:SensitivityInterpretation/text()">
																<td valign="top">
																	<xsl:value-of select="."/>
																</td>
															</xsl:for-each>
														</tr>
													</tbody>
												</table>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:apply-templates select="m:LaboratoryResults/m:CultureWithFindings/m:Comments/text()|m:LaboratoryResults/m:CultureWithFindings/m:Comments/*"/>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:RequisitionInformation/m:ClinicalInformation)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Klinisk information
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:RequisitionInformation/m:ClinicalInformation">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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
						<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation[m:Comments]">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:Comments">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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
						</xsl:for-each>
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

	<!-- 	LABORATORYREPORT -->
	<xsl:template match="m:Emessage[m:LaboratoryReport]">
		<xsl:for-each select="m:LaboratoryReport">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Laboratoriesvar'"/>
							</xsl:call-template>
						</tr>
					<!--  <tr>
					    <td>
					      <xsl:variable name="patientcpr" select="m:Patient/m:CivilRegistrationNumber"/>
					      <a href="https://www.sundhed.dk/wps/myportal/_s.155/4518?parameter_navn=cprnr_field&amp;cprnrfield={$patientcpr}">Beskrivelse på Sundhed.dk</a>
					    </td>
					  </tr>-->
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SamplingDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Svaret<!--tidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:RequisitionInformation/m:Comments)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top" width="100%">
													<b>Kommentarer til rekvisitionen</b>
												</td>
											</tr>
											<tr>
												<td valign="top" width="100%">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:RequisitionInformation/m:Comments">
																		<xsl:apply-templates/>
																	</xsl:for-each>
																</td>
															</tr>
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
												<b>Resultater</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<tr bgcolor="#cccccc">
															<td valign="top">
																<b>Analyse</b>
															</td>
															<td valign="top">
																<b>Værdi</b>
															</td>
															<td valign="top">
																<b>Bem.</b>
															</td>
															<td valign="top">
																<b>Enhed</b>
															</td>
															<td valign="top">
																<b>Reference</b>
															</td>
															<td valign="top">
																<b>Status</b>
															</td>
															<td/>
														</tr>
														<xsl:variable name="Results2" select="m:LaboratoryResults/m:Result"/>
														<xsl:variable name="Firstresults2" select="$Results2[count(.|(key('requisitiongroup2result',concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)))[1])=1]"/>
														<xsl:for-each select="$Firstresults2">
															<xsl:sort select="m:Analysis/m:RequisitionGroup/m:Identifier"/>
															<xsl:variable name="GNr" select="position()"/>
															<xsl:variable name="Key" select="concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)"/>
															<xsl:variable name="ResultsInGrp" select="key('requisitiongroup2result',$Key)"/>
															<tr>
																<td colspan="6">
																	<b>
																		<i>
																			<xsl:value-of select="m:Analysis/m:RequisitionGroup/m:Name"/>
																		</i>
																	</b>
																</td>
															</tr>
															<xsl:for-each select="$ResultsInGrp">
																<xsl:sort select="Analysis/m:Order"/>
																<xsl:variable name="NrInG" select="position()"/>
																<!--<xsl:variable name="CNr" select="count(../m:Result[(concat('X',m:Analysis/m:RequisitionGroup/m:Identifier)&lt;concat('X',$Id))])"/>-->
																<!-- and count(m:ResultTextValue|m:ResultComments)>0-->
																<!-- or (m:Analysis/m:RequisitionGroup/m:Identifier=$Id and concat(' ',m:Analysis/m:Order) &lt;concat(' ',$Order))-->
																<xsl:variable name="isevenrow" select="position() mod 2 = 0"/>
																<tr>
																	<xsl:if test="not($isevenrow)">
																		<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																	</xsl:if>
																	<xsl:if test="$isevenrow">
																		<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																	</xsl:if>
																	<td valign="top">
																	       <xsl:choose>
																	         <xsl:when test="m:Analysis/m:AnalysisShortName">
																	           <xsl:value-of select="m:Analysis/m:AnalysisShortName"/>
																	         </xsl:when>
																	         <xsl:otherwise>
																	           <xsl:value-of select="concat(m:Analysis/m:AnalysisCompleteName,' (',m:Analysis/m:AnalysisCode,':',m:Analysis/m:AnalysisCodeResponsible,')')"/>
																	         </xsl:otherwise>
																	       </xsl:choose>
																	</td>
																	<td valign="top">
																	  <xsl:attribute name="title">
																	    <xsl:if test="m:ResultTextValue">
																	      <xsl:text>Tekstværdi: </xsl:text><xsl:value-of select="m:ResultTextValue"/><xsl:text>, 
</xsl:text>
																	    </xsl:if>
																	    <xsl:text>Producent: </xsl:text><xsl:value-of select="m:ProducerOfLabResult"/>
																	  </xsl:attribute>
																	  <xsl:choose>
																	    <xsl:when test="m:ResultValidation">
																	      <xsl:variable name="RV" select="m:ResultValidation"/>
																	      <xsl:choose>
																	        <xsl:when test="$RV='unormal' ">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valueabnormbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	        <xsl:when test="$RV='for_hoej' ">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valuetohighbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	        <xsl:when test="$RV='for_lav' ">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valuetolowbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	      </xsl:choose>
																	    </xsl:when>
																	    <xsl:when test="m:ResultType = 'numerisk'">
																	      <xsl:choose>
																	        <xsl:when test="m:Value > m:ReferenceInterval/m:UpperLimit">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valuetohighbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	        <xsl:when test="m:Value &lt; m:ReferenceInterval/m:LowerLimit">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valuetolowbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	      </xsl:choose>
																	    </xsl:when>
																	  </xsl:choose>
																		<xsl:variable name="O" select="m:Operator"/>
																		<xsl:choose>
																			<xsl:when test="$O='mindre_end'">&lt;</xsl:when>
																			<xsl:when test="$O='stoerre_end'">&gt;</xsl:when>
																		</xsl:choose>
																		<xsl:value-of select="m:Value"/>
																	</td>
																	<td valign="top">
																		<xsl:if test="count(m:ResultTextValue|m:ResultComments)>0">
																			<font size="1">
																				<xsl:attribute name="title"><xsl:value-of select="m:ResultComments"/></xsl:attribute>
																				<xsl:value-of select="concat($GNr,',',$NrInG)"/>
																			</font>
																		</xsl:if>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Unit"/>
																	</td>
																	<td valign="top">
																		<xsl:if test="count(m:ReferenceInterval/m:LowerLimit|m:ReferenceInterval/m:UpperLimit)>1">
																			<xsl:value-of select="concat(m:ReferenceInterval/m:LowerLimit,'-',m:ReferenceInterval/m:UpperLimit)"/>
																		</xsl:if>
																		<xsl:if test="count(m:ReferenceInterval/m:LowerLimit|m:ReferenceInterval/m:UpperLimit)=1">
																		  	<xsl:if test="count(m:ReferenceInterval/m:LowerLimit)=1">
																		  	   <xsl:value-of select="concat('&gt;',m:ReferenceInterval/m:LowerLimit)"/>
																		  	</xsl:if>
																		  	<xsl:if test="count(m:ReferenceInterval/m:UpperLimit)=1">
																		  	   <xsl:value-of select="concat('&lt;',m:ReferenceInterval/m:UpperLimit)"/>
																		  	</xsl:if>

																		</xsl:if>
																		<xsl:value-of select="m:ReferenceInterval/m:IntervalText"/>
																	</td>
																	<td>
																		<xsl:value-of select="m:ResultStatusCode"/>
																	</td>
																	<td>
																		<xsl:for-each select="m:Reference[m:URL]">
																			<a>
																				<xsl:attribute name="href"><xsl:value-of select="m:URL"/></xsl:attribute>
																				<img src="img/urlicon.PNG">
																					<xsl:attribute name="alt"><xsl:value-of select="m:RefDescription"/></xsl:attribute>
																				</img>
																			</a>
																		</xsl:for-each>
																	</td>
																</tr>
															</xsl:for-each>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
										<!--
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<tr>
															<td valign="top">
																<b>Analyse</b>
															</td>
															<td valign="top">
																<b>Værdi</b>
															</td>
															<td valign="top">
																<b>Bem.</b>
															</td>
															<td valign="top">
																<b>Enhed</b>
															</td>
															<td valign="top">
																<b>Reference</b>
															</td>
															<td valign="top">
																<b>Status</b>
															</td>
														</tr>
														<xsl:for-each select="m:LaboratoryResults/m:Result">
															<xsl:variable name="RNr" select="position()"/>
															<xsl:variable name="CNr" select="count(../m:Result[position()&lt;=$RNr and count(m:ResultTextValue|m:ResultComments)>0])"/>
															<xsl:variable name="isevenrow" select="position() mod 2 = 0"/>
															<tr>
																<xsl:if test="not($isevenrow)">
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																</xsl:if>
																<xsl:if test="$isevenrow">
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																</xsl:if>
																<td valign="top">
																	<xsl:value-of select="concat(m:Analysis/m:AnalysisCompleteName,' (',m:Analysis/m:AnalysisCode,':',m:Analysis/m:AnalysisCodeResponsible,')')"/>
																</td>
																<td valign="top">
																	<xsl:variable name="RV" select="m:ResultValidation"/>
																	<xsl:choose>
																		<xsl:when test="$RV='unormal' ">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$valueabnormbgcolor"/></xsl:attribute>
																		</xsl:when>
																		<xsl:when test="$RV='for_hoej' ">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetohighbgcolor"/></xsl:attribute>
																		</xsl:when>
																		<xsl:when test="$RV='for_lav' ">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetolowbgcolor"/></xsl:attribute>
																		</xsl:when>
																	</xsl:choose>
																	<xsl:variable name="O" select="m:Operator"/>
																	<xsl:choose>
																		<xsl:when test="$O='mindre_end'">&lt;</xsl:when>
																		<xsl:when test="$O='stoerre_end'">&gt;</xsl:when>
																	</xsl:choose>
																	<xsl:value-of select="m:Value"/>
																</td>
																<td valign="top">
																	<xsl:if test="count(m:ResultTextValue|m:ResultComments)>0">
																		<font size="1">
																			<xsl:attribute name="title"><xsl:value-of select="m:ResultTextValue|m:ResultComments"/></xsl:attribute>
																			<xsl:value-of select="$CNr"/>
																		</font>
																	</xsl:if>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Unit"/>
																</td>
																<td valign="top">
																	<xsl:if test="count(m:ReferenceInterval/m:LowerLimit|m:ReferenceInterval/m:UpperLimit)>0">
																		<xsl:value-of select="concat(m:ReferenceInterval/m:LowerLimit,'-',m:ReferenceInterval/m:UpperLimit)"/>
																	</xsl:if>
																	<xsl:value-of select="m:ReferenceInterval/m:IntervalText"/>
																</td>
																<td>
																	<xsl:value-of select="m:ResultStatusCode"/>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>-->
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Bemærkninger</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
													       <xsl:for-each select="m:LaboratoryResults">
													         <xsl:variable name="GNr" select="position()"/>
														<xsl:variable name="Results" select="m:Result"/>
														<xsl:variable name="Firstresults" select="$Results[count(.|(key('requisitiongroup2result',m:Analysis/m:RequisitionGroup/m:Identifier))[1])=1]"/>
														<xsl:for-each select="$Firstresults">
															<xsl:sort select="m:Analysis/m:RequisitionGroup/m:Identifier"/>
															
															<xsl:variable name="Key" select="concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)"/>
															<!--<xsl:variable name="ResultsInGrp" select="key('requisitiongroup2result',$Key)"/>
															<xsl:for-each select="$ResultsInGrp">-->
																<!--<xsl:sort select="Analysis/m:Order"/>-->
																<xsl:variable name="NrInG" select="position()"/>
																<xsl:if test="count(m:ResultTextValue|m:ResultComments)>0">
																	<tr>
																		<td valign="top">
																			<font size="1">
																				<xsl:value-of select="concat($GNr,',',$NrInG)"/>
																			</font>
																		</td>
																		<td valign="top">
																			<table>
																				<tbody>
																					<xsl:for-each select="m:ResultTextValue|m:ResultComments">
																						<tr>
																							<!--<xsl:if test="not($isevenrow)"><xsl:attribute name="bgcolor">dddddd</xsl:attribute></xsl:if>-->
																							<td valign="top">
																								<xsl:if test="name()='ResultTextValue' ">Værdi</xsl:if>
																								<xsl:if test="name()='ResultComments' ">Bem.</xsl:if>
																							</td>
																							<td valign="top">
																								<xsl:apply-templates/>
																							</td>
																						</tr>
																					</xsl:for-each>
																				</tbody>
																			</table>
																		</td>
																	</tr>
																</xsl:if>
															<!--</xsl:for-each>-->
														</xsl:for-each>
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
