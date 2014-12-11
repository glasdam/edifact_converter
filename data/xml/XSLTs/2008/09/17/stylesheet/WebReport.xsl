<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/">

  <!--  MICROBIOLOGYREPORT -->
  <xsl:template match="m:Emessage[m:MicrobiologyWebReport]">
    <xsl:for-each select="m:MicrobiologyWebReport">
      <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
        <table width="100%">
          <tbody>
            <tr>
              <xsl:call-template name="ShowMessageHeader">
                <xsl:with-param name="MessageName" select="'Mikrobiologisvar'"/>
              </xsl:call-template>
            </tr>
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
                        <xsl:for-each
                          select="m:RequisitionInformation/m:Sample/m:SampleReceivedDateTime">
                          <!--ikke som i microbiologi (der er det under sample)-->
                          <xsl:call-template name="FormatDateTime"/>
                        </xsl:for-each>
                      </td>
                      <td valign="top">
                        <xsl:variable name="RS"
                          select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultStatus"/>
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
                        <xsl:for-each
                          select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
                          <xsl:call-template name="FormatDateTime"/>
                        </xsl:for-each>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
            <xsl:if test="m:RequisitionInformation/m:Comments">
              <tr>
                <td valign="top" width="100%">
                  <table>
                    <thead>
                      <th align="left">Bemærkninger til rekvisitionen</th>
                    </thead>
                    <xsl:for-each select="m:RequisitionInformation/m:Comments">
                    <tr>
                      <td>
                        <xsl:call-template name="Comment"/>
                      </td>
                    </tr>
                    </xsl:for-each>
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
                        <script language="javascript" type="text/javascript">
                          var olddivid = 'Investigation1';
                          
                          function hello(link){
                            var oldlink = document.getElementById('current');
                            oldlink.setAttribute('id','val');
                            link.setAttribute('id','current');
                            var divid = link.getAttribute('href');
                            divid = divid.split('?')[1];
                            divid = 'Investigation'+divid;
                            var olddiv = document.getElementById(olddivid);
                            olddiv.setAttribute('class','hidden');
                            olddiv.className = 'hidden';
                            var newdiv = document.getElementById(divid);
                            newdiv.setAttribute('class','visible');
                            newdiv.className = 'visible';
                            olddivid = divid;
                            return false;
                          }

                        </script>
                        <table>
                          <tbody>
                            <tr>
                              <td colspan="4">
                                <xsl:apply-templates select="m:LaboratoryResults"/>
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
                              <xsl:for-each
                                select="m:LaboratoryResults/m:Result[count(m:ResultTextValue|m:ResultComments)>0]">
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
                          <xsl:value-of
                            select="m:LaboratoryResults/m:MicroscopicFindings/m:Headline"/>
                        </b>
                      </td>
                    </tr>
                    <tr>
                      <td valign="top">
                        <xsl:apply-templates
                          select="m:LaboratoryResults/m:MicroscopicFindings/m:Comments/text()|m:LaboratoryResults/m:MicroscopicFindings/m:Comments/*"
                        />
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
                          <xsl:value-of
                            select="m:LaboratoryResults/m:CultureWithoutFindings/m:Headline"/>
                        </b>
                      </td>
                    </tr>
                    <tr>
                      <td valign="top">
                        <xsl:apply-templates
                          select="m:LaboratoryResults/m:CultureWithoutFindings/m:Comments/text()|m:LaboratoryResults/m:CultureWithoutFindings/m:Comments/*"
                        />
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
                          <xsl:value-of
                            select="m:LaboratoryResults/m:CultureWithFindings/m:Headline"/>
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
                      <xsl:for-each
                        select="m:LaboratoryResults/m:CultureWithFindings/m:Pattern/m:PatternEntry[1]">
                        <tr>
                          <td valign="top">
                            <xsl:call-template name="ShowTable2">
                              <xsl:with-param name="ColNames" select="../../m:Microorganism/m:Name"/>
                              <xsl:with-param name="RowNames" select="../m:Antibiotic"/>
                              <xsl:with-param name="ColIdxs"
                                select="../m:PatternEntry/m:RefMicroorganism"/>
                              <xsl:with-param name="RowIdxs"
                                select="../m:PatternEntry/m:RefAntibiotic"/>
                              <xsl:with-param name="Values" select="../m:PatternEntry/m:Sensitivity"
                              />
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
                              <xsl:for-each
                                select="m:LaboratoryResults/m:CultureWithFindings/m:Pattern/m:SensitivityInterpretation/text()">
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
                        <xsl:apply-templates
                          select="m:LaboratoryResults/m:CultureWithFindings/m:Comments/text()|m:LaboratoryResults/m:CultureWithFindings/m:Comments/*"
                        />
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
                          <b> Klinisk information </b>
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

  <xsl:template name="Comment">
    <xsl:param name="title" select="'Bemærkning'"/>
   
    <div style="background-color: #ffffcc; width: 100%; padding: 5px">
    <xsl:apply-templates select="m:Text/m:Paragraph"/>
    </div>
  </xsl:template>


  <xsl:template match="m:Paragraph">
    <xsl:value-of select="."/><br/>
  </xsl:template>

  <xsl:template match="m:LaboratoryResults">
     <div id="navcontainer">
      <ul id="navlist">
        <xsl:for-each select="m:Investigation">
          <xsl:element name="li">
            <xsl:if test="position()=1">
              <xsl:attribute name="id">
                <xsl:value-of select="'active'"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:element name="a">
              <xsl:attribute name="href">#?<xsl:value-of select="position()"/></xsl:attribute>
              <xsl:attribute name="onClick">hello(this);</xsl:attribute>
              <xsl:if test="position()=1">
                <xsl:attribute name="id">
                  <xsl:value-of select="'current'"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="concat(local-name(),' ',position())"/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </ul>
      <xsl:for-each select="m:Investigation">
        <xsl:element name="div">
          <xsl:attribute name="id">Investigation<xsl:value-of select="position()"/></xsl:attribute>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="position()=1">visible</xsl:when>
              <xsl:otherwise>hidden</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <!--<xsl:attribute name="style">
          <xsl:if test="position()!=1">
          <xsl:value-of select="'display: none;'"/>
          </xsl:if>
          <xsl:value-of select="'border: 1px solid black; border-top: none;margin: 0px;'"/>
          </xsl:attribute>-->
          <xsl:for-each select="m:Examination">
            <table>
              <xsl:attribute name="bordercolor">
                <xsl:value-of select="$table2bordercolor"/>
              </xsl:attribute>
              <tr>
                <td colspan="2">
                  <b>Examination</b>
                </td>
              </tr>
              <xsl:apply-templates mode="SimplePresentation" select="*"/>
            </table>
          </xsl:for-each>

          <xsl:for-each select="m:QuantitativeFindings">
            <table>
              <xsl:attribute name="bordercolor">
                <xsl:value-of select="$table2bordercolor"/>
              </xsl:attribute>
              <tr>
                <td colspan="2">
                  <b>QuantitativeFindings</b>
                </td>
              </tr>
              <xsl:apply-templates mode="SimplePresentation" select="*"/>
            </table>
          </xsl:for-each>

          <xsl:for-each select="m:CultureFindings">
            <xsl:call-template name="cultureFindingsTable"/>
<!--            
            <table>
              <xsl:apply-templates mode="SimplePresentation" select="*"/>
            </table>
-->          
          </xsl:for-each>

          <xsl:apply-templates select="m:MicroscopicFindings"/>
          
          <!--<xsl:for-each select="m:MicroscopicFindings">
            <table>
              <xsl:attribute name="bordercolor">
                <xsl:value-of select="$table2bordercolor"/>
              </xsl:attribute>
              <tr>
                <td colspan="2">
                  <b>MicroscopicFindings</b>
                </td>
              </tr>
              <xsl:apply-templates mode="SimplePresentation" select="*"/>
            </table>
          </xsl:for-each>-->

        </xsl:element>
      </xsl:for-each>
    </div>
  </xsl:template>


  <xsl:template mode="SimplePresentation" match="*">
    <tr>
      <td>
        <xsl:attribute name="bgcolor">
          <xsl:value-of select="$oddrowbgcolor"/>
        </xsl:attribute>
        <xsl:value-of select="local-name()"/>
      </td>
      <td>
        <xsl:attribute name="bgcolor">
          <xsl:value-of select="$oddrowbgcolor"/>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="count(*)>0">
            <table>
              <xsl:attribute name="bordercolor">
                <xsl:value-of select="$table2bordercolor"/>
              </xsl:attribute>
              <xsl:apply-templates mode="SimplePresentation" select="*"/>
            </table>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="style">border: 1px solid white</xsl:attribute>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template match="m:MicroscopicFindings">
    <h4><xsl:value-of select="m:Headline"/></h4>
    <table>
      <thead>
        <th align="left">Bemærkninger</th>
      </thead>
      <xsl:for-each select="m:Comments">
        <tr>
          <td>
            <div style="background-color: #ffffcc; width: 100%; padding: 5px">
              <xsl:apply-templates select="m:Paragraph"/>
            </div>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="cultureFindingsTable">
    <xsl:variable name="nrOfColumns" select="count(./m:Microorganism)+1"/>
    <h4><xsl:value-of select="./m:Headline"/></h4>
    <table class="culturefindings">
      <xsl:attribute name="bordercolor">
        <xsl:value-of select="'black'"/>
      </xsl:attribute>
      <tr>
        <th>Antibiotika</th>
        <xsl:for-each select="m:Microorganism">
          <th>
            <xsl:attribute name="title">
              <xsl:value-of select="m:Identification/m:Text"/>
              , Identifikation: Kode: <xsl:value-of select="m:Identification/m:Code"/>
              , Kode Type: <xsl:value-of select="m:Identification/m:CodeType"/>
              , Kode Ansvarlig: <xsl:value-of select="m:Identification/m:CodeResponsible"/>
              , Vækst: <xsl:value-of select="m:GrowthValue"/>
            </xsl:attribute>
            <xsl:value-of select="position()"/>
          </th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="m:Pattern">
        <xsl:variable name="entries" select="m:PatternEntry"/>
        <xsl:for-each select="m:Antibiotic">
          <tr>
            <xsl:attribute name="bgcolor">
              <xsl:choose>
                <xsl:when test="position() mod 2">
                  <xsl:value-of select="$oddrowbgcolor"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$evenrowbgcolor"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <td>
              <xsl:value-of select="./m:AntibioticName/m:Text"/>
            </td>
            <xsl:variable name="abId" select="position()"/>
            <xsl:for-each select="../../m:Microorganism">
              <xsl:variable name="micId" select="position()"/>
              <td>
                <xsl:for-each select="$entries">
                  <xsl:if test="m:RefAntibiotic = $abId">
                    <xsl:if test="m:RefMicroorganism = $micId">
                      <xsl:value-of select="m:Susceptibility"/>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each>
              </td>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </xsl:for-each>
      <tr>
        <xsl:attribute name="bgcolor">
          <xsl:value-of select="white"/>
        </xsl:attribute>
        <td colspan="{$nrOfColumns}">
          <xsl:for-each select="./m:Pattern/m:SusceptibilityInterpretation/m:Paragraph">
            <small><xsl:value-of select="."/></small><br/>
          </xsl:for-each>
        </td>
      </tr>
      
    </table>
  </xsl:template>

</xsl:stylesheet>
