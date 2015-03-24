<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2015/02/16/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="m:GeneralPractitionerInvoice">
    <Brev>
      <UNH>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
        <Elm>
          <SubElm>MEDRUC</SubElm>
          <SubElm>D</SubElm>
          <SubElm>93A</SubElm>
          <SubElm>UN</SubElm>
          <SubElm>U0131U</SubElm>
        </Elm>
        <Elm>
          <SubElm>RUC01</SubElm>
        </Elm>
      </UNH>
      <xsl:call-template name="BuildInvoice"/>
      <UNT>
        <Elm>
          <SubElm>1</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
      </UNT>
    </Brev>
  </xsl:template>
  
  <xsl:template match="m:EmergencyServicePractitionerInvoice">
    <Brev>
      <UNH>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
        <Elm>
          <SubElm>MEDRUC</SubElm>
          <SubElm>D</SubElm>
          <SubElm>93A</SubElm>
          <SubElm>UN</SubElm>
          <SubElm>U0831U</SubElm>
        </Elm>
        <Elm>
          <SubElm>RUC08</SubElm>
        </Elm>
      </UNH>
      <xsl:call-template name="BuildInvoice"/>
      <UNT>
        <Elm>
          <SubElm>1</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
      </UNT>
    </Brev>
  </xsl:template>
  
  <xsl:template match="m:PrivateSpecialistInvoice">
    <Brev>
      <UNH>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
        <Elm>
          <SubElm>MEDRUC</SubElm>
          <SubElm>D</SubElm>
          <SubElm>93A</SubElm>
          <SubElm>UN</SubElm>
          <SubElm>U0231U</SubElm>
        </Elm>
        <Elm>
          <SubElm>RUC02</SubElm>
        </Elm>
      </UNH>
      <xsl:call-template name="BuildInvoice"/>
      <UNT>
        <Elm>
          <SubElm>1</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
      </UNT>
    </Brev>
  </xsl:template>
  
  <xsl:template match="m:PsychologistInvoice">
    <Brev>
      <UNH>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
        <Elm>
          <SubElm>MEDRUC</SubElm>
          <SubElm>D</SubElm>
          <SubElm>93A</SubElm>
          <SubElm>UN</SubElm>
          <SubElm>U1031U</SubElm>
        </Elm>
        <Elm>
          <SubElm>RUC10</SubElm>
        </Elm>
      </UNH>
      <xsl:call-template name="BuildInvoice"/>
      <UNT>
        <Elm>
          <SubElm>1</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
      </UNT>
    </Brev>
  </xsl:template>
  
  <xsl:template match="m:ChiropractorInvoice">
    <Brev>
      <UNH>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
        <Elm>
          <SubElm>MEDRUC</SubElm>
          <SubElm>D</SubElm>
          <SubElm>93A</SubElm>
          <SubElm>UN</SubElm>
          <SubElm>U0631U</SubElm>
        </Elm>
        <Elm>
          <SubElm>RUC06</SubElm>
        </Elm>
      </UNH>
      <xsl:call-template name="BuildInvoice"/>
      <UNT>
        <Elm>
          <SubElm>1</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
      </UNT>
    </Brev>
  </xsl:template>
  
  <xsl:template match="m:ChiropodyInvoice">
    <Brev>
      <UNH>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
        <Elm>
          <SubElm>MEDRUC</SubElm>
          <SubElm>D</SubElm>
          <SubElm>93A</SubElm>
          <SubElm>UN</SubElm>
          <SubElm>U1131U</SubElm>
        </Elm>
        <Elm>
          <SubElm>RUC11</SubElm>
        </Elm>
      </UNH>
      <xsl:call-template name="BuildInvoice"/>
      <UNT>
        <Elm>
          <SubElm>1</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
      </UNT>
    </Brev>
  </xsl:template>
  
  <xsl:template match="m:LaboratoryInvoice">
    <Brev>
      <UNH>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
        <Elm>
          <SubElm>MEDRUC</SubElm>
          <SubElm>D</SubElm>
          <SubElm>93A</SubElm>
          <SubElm>UN</SubElm>
          <SubElm>U0731U</SubElm>
        </Elm>
        <Elm>
          <SubElm>RUC07</SubElm>
        </Elm>
      </UNH>
      <xsl:call-template name="BuildInvoice"/>
      <UNT>
        <Elm>
          <SubElm>1</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
      </UNT>
    </Brev>
  </xsl:template>
  
  <xsl:template match="m:PhysiotherapyInvoice">
    <Brev>
      <UNH>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
        <Elm>
          <SubElm>MEDRUC</SubElm>
          <SubElm>D</SubElm>
          <SubElm>93A</SubElm>
          <SubElm>UN</SubElm>
          <SubElm>U0432U</SubElm>
        </Elm>
        <Elm>
          <SubElm>RUC04</SubElm>
        </Elm>
      </UNH>
      <xsl:call-template name="BuildInvoice"/>
      <UNT>
        <Elm>
          <SubElm>1</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
      </UNT>
    </Brev>
  </xsl:template>
  
  <xsl:template match="m:DentistInvoice">
    <Brev>
      <UNH>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
        <Elm>
          <SubElm>MEDRUC</SubElm>
          <SubElm>D</SubElm>
          <SubElm>93A</SubElm>
          <SubElm>UN</SubElm>
          <SubElm>U0332U</SubElm>
        </Elm>
        <Elm>
          <SubElm>RUC03</SubElm>
        </Elm>
      </UNH>
      <xsl:call-template name="BuildInvoice"/>
      <UNT>
        <Elm>
          <SubElm>1</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Letter/m:Identifier"/>
          </SubElm>
        </Elm>
      </UNT>
    </Brev>
  </xsl:template>
  
  <xsl:template name="BuildInvoice">
    <BrevIndhold>
      <BGM>
        <Elm>
          <SubElm>AFR</SubElm>
          <SubElm/>
          <SubElm/>
          <SubElm>REGN0003</SubElm>
        </Elm>
        <Elm/>
        <Elm/>
        <Elm>
          <SubElm>NA</SubElm>
        </Elm>
      </BGM>
      <DTM>
        <Elm>
          <SubElm>137</SubElm>
          <SubElm>
            <xsl:call-template name="DateTimeToDTM203">
              <xsl:with-param name="DT" select="m:Letter/m:Authorisation"/>
            </xsl:call-template>
          </SubElm>
          <SubElm>203</SubElm>
        </Elm>
      </DTM>
      <xsl:for-each select="m:WeekIdentifier">
      <DTM>
        <Elm>
          <SubElm>263</SubElm>
          <SubElm>
            <xsl:value-of select="m:Year"/><xsl:value-of select="m:Week"/>
          </SubElm>
          <SubElm>616</SubElm>
        </Elm>
      </DTM>
      </xsl:for-each>
      <QTY>
        <Elm>
          <SubElm>TMQ</SubElm>
          <SubElm><xsl:value-of select="count(m:Invoice)"/></SubElm>
        </Elm>
      </QTY>
      <S01 hidden="true">
      <MOA>
        <Elm>
          <SubElm>86</SubElm>
          <SubElm>
            <xsl:value-of select="m:Amount"/>
          </SubElm>
        </Elm>
      </MOA>
      </S01>
      <S02 hidden="true">
      <NAD>
        <Elm>
          <SubElm>MS</SubElm>
        </Elm>
        <Elm>
          <SubElm><xsl:value-of select="m:Sender/m:Identifier"/></SubElm>
          <SubElm>YNR</SubElm>
          <SubElm>SFU</SubElm>
        </Elm>
      </NAD>
      <xsl:for-each select="m:FieldOfService">
        <ADR>
          <Elm>
            <SubElm>VA</SubElm>
          </Elm>
          <Elm/>
          <Elm/>
          <Elm/>
          <Elm/>
          <Elm>
            <SubElm>
              <xsl:value-of select="text()"/>
            </SubElm>
            <SubElm>VA</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </ADR>
      </xsl:for-each>
      <xsl:for-each select="m:Sender/m:SpecialityIdentifier">
        <SPR>
          <Elm>
            <SubElm>ORG</SubElm>
          </Elm>
          <Elm/>
          <Elm>
            <SubElm>
              <xsl:call-template name="SpecialityCodeToAFSSPEC"/>
            </SubElm>
            <SubElm>SPC</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </SPR>
      </xsl:for-each>
      <xsl:for-each select="m:Receiver/m:CountyIdentifier">
        <NAD>
          <Elm>
            <SubElm>MR</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:value-of select="."/>
            </SubElm>
            <SubElm>AMT</SubElm>
            <SubElm>IM</SubElm>
          </Elm>
        </NAD>
      </xsl:for-each>
      </S02>
      <S03 hidden="true">
        <CTI>
          <Elm>
            <SubElm>VAL</SubElm>
          </Elm>
          <Elm/>
          <Elm>
            <SubElm>I</SubElm>
            <SubElm>PRL</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </CTI>
      </S03>
      <xsl:apply-templates mode="RUC" select="m:Invoice"/>
    </BrevIndhold>
  </xsl:template>
  
  <xsl:template mode="RUC" match="m:Invoice">
    <S05 hidden="true">
      <BUS>
        <Elm>
          <SubElm>1</SubElm>
          <SubElm>AFR</SubElm>
        </Elm>
      </BUS>
      <xsl:apply-templates mode="RUC" select="m:Insured"/>
      <xsl:apply-templates mode="RUC" select="m:PatientType"/>
      <xsl:apply-templates mode="RUC" select="m:Activity"/>
      <xsl:apply-templates mode="RUC" select="m:Rules"/>
      <xsl:apply-templates mode="RUC" select="m:CommunityMedicine"/>
      <xsl:apply-templates mode="RUC" select="m:ReferralIdentifier"/>
      <xsl:apply-templates mode="RUC" select="m:Service"/>
    </S05>
  </xsl:template>
  
  <xsl:template mode="RUC" match="m:Insured">
    <S07 hidden="true">
      <PNA>
        <Elm>
          <SubElm>PAT</SubElm>
        </Elm>
        <Elm>
          <xsl:choose>
            <xsl:when test="m:CivilRegistrationNumber">
              <SubElm>
              <xsl:value-of select="m:CivilRegistrationNumber"/>
              </SubElm>
              <SubElm>CPR</SubElm>
              <SubElm>IM</SubElm>              
            </xsl:when>
            <xsl:otherwise>
              <SubElm>
                <xsl:value-of select="m:AlternativeIdentifier"/>
              </SubElm>
              <SubElm>CPR</SubElm>
              <SubElm>SFU</SubElm>  
            </xsl:otherwise>
          </xsl:choose>
        </Elm>
      </PNA>
      <xsl:for-each select="m:ServicedChild">
        <REL>
          <Elm>
            <SubElm>IP</SubElm>
          </Elm>
          <Elm>
            <SubElm>CH</SubElm>
            <SubElm>SKS</SubElm>
            <SubElm>SST</SubElm>
          </Elm>
        </REL>
      </xsl:for-each>
      <xsl:for-each select="m:CountryCode">
        <NAT>
          <Elm>
            <SubElm>PN</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:value-of select="."/>
            </SubElm>
            <SubElm>PNK</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </NAT>
      </xsl:for-each>
    </S07>
  </xsl:template>
  
  <xsl:template mode="RUC" match="m:PatientType">
    <S10 hidden="true">
      <CTI>
        <Elm>
          <SubElm>CUR</SubElm>
        </Elm>
        <Elm/>
        <Elm>
          <SubElm>
            <xsl:value-of select="text()"/>
          </SubElm>
          <SubElm>PTT</SubElm>
          <SubElm>SFU</SubElm>
        </Elm>
      </CTI>
    </S10>
  </xsl:template>

  <xsl:template mode="RUC" match="m:Activity">
    <S12 hidden="true">
      <PRC>
        <Elm>
          <SubElm>CON</SubElm>
        </Elm>
      </PRC>
      <xsl:for-each select="m:Stratified">
        <CIN>
          <Elm>
            <SubElm>RFA</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:value-of select="text()"/>
            </SubElm>
            <SubElm>FTB</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </CIN>
      </xsl:for-each>
      <xsl:for-each select="m:ReferralType">
        <PAS>
          <Elm>
            <SubElm>PC</SubElm>
          </Elm>
          <Elm/>
          <Elm>
            <SubElm>
              <xsl:value-of select="."/>
            </SubElm>
            <SubElm>HET</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </PAS>
      </xsl:for-each>
      <xsl:for-each select="m:ReferralCause">
        <CIN>
          <Elm>
            <SubElm>RFA</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:value-of select="text()"/>
            </SubElm>
            <SubElm>RRP</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </CIN>
      </xsl:for-each>
      <xsl:for-each select="m:Diagnose">
        <CIN>
          <Elm>
            <SubElm>RFA</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:value-of select="text()"/>
            </SubElm>
            <SubElm>FTD</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </CIN>
      </xsl:for-each>
      <xsl:for-each select="m:PatientGroup">
        <CIN>
          <Elm>
            <SubElm>RFA</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:value-of select="text()"/>
            </SubElm>
            <SubElm>FTC</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </CIN>
      </xsl:for-each>
      <xsl:for-each select="m:NaturalTeeth">
        <CIN>
          <Elm>
            <SubElm>RFA</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:value-of select="text()"/>
            </SubElm>
            <SubElm>NAT</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </CIN>
      </xsl:for-each>
      <xsl:for-each select="m:CarieTeeth">
        <CIN>
          <Elm>
            <SubElm>RFA</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:value-of select="text()"/>
            </SubElm>
            <SubElm>CAT</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </CIN>
      </xsl:for-each>
      <xsl:for-each select="m:FillingTeeth">
        <CIN>
          <Elm>
            <SubElm>RFA</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:value-of select="text()"/>
            </SubElm>
            <SubElm>FIT</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </CIN>
      </xsl:for-each>
      <xsl:for-each select="m:ReferralDate">
        <DTM>
          <Elm>
            <SubElm>REF</SubElm>
            <xsl:call-template name="DateTo102"/>
          </Elm>
        </DTM>
      </xsl:for-each>
      <xsl:for-each select="m:SubmissionDate">
        <DTM>
          <Elm>
            <SubElm>RFS</SubElm>
            <xsl:call-template name="DateTo102"/>
          </Elm>
        </DTM>
      </xsl:for-each>
      <xsl:for-each select="m:StartDate">
        <DTM>
          <Elm>
            <SubElm>194</SubElm>
            <xsl:call-template name="DateTo102"/>
          </Elm>
        </DTM>
      </xsl:for-each>  
      <xsl:for-each select="m:EndDate">
        <DTM>
          <Elm>
            <SubElm>206</SubElm>
            <xsl:call-template name="DateTo102"/>
          </Elm>
        </DTM>
      </xsl:for-each>      
      <xsl:for-each select="m:Time">
      <DTM>
        <Elm>
          <SubElm>RET</SubElm>
          <SubElm>
            <xsl:value-of select="substring(text(), 1, 2)"/>
            <xsl:value-of select="substring(text(), 4, 2)"/>
          </SubElm>
          <SubElm>401</SubElm>
        </Elm>
      </DTM>
      </xsl:for-each>
      <xsl:for-each select="m:ReferralID">
        <RFF>
          <Elm>
            <SubElm>REF</SubElm>
            <SubElm>
              <xsl:value-of select="."/>
            </SubElm>
          </Elm>
        </RFF>
      </xsl:for-each>
      <xsl:for-each select="m:Statistic">
        <FTX>
          <Elm>
            <SubElm>ACF</SubElm>
          </Elm>
          <Elm/>
          <Elm/>
          <Elm>
            <SubElm>
              <xsl:value-of select="text()"/>
            </SubElm>
          </Elm>
        </FTX>
      </xsl:for-each>		
      <xsl:for-each select="m:ConsultationsAmount">
        <QTY>
          <Elm>
            <SubElm>CON</SubElm>
            <SubElm>
              <xsl:value-of select="."/>
            </SubElm>
          </Elm>
        </QTY>
      </xsl:for-each>
      <xsl:for-each select="m:TelephoneConsultationsAmount">
        <QTY>
          <Elm>
            <SubElm>TEL</SubElm>
            <SubElm>
              <xsl:value-of select="."/>
            </SubElm>
          </Elm>
        </QTY>
      </xsl:for-each>
      <QTY>
        <Elm>
          <SubElm>DET</SubElm>
          <SubElm>
            <xsl:value-of select="count(../m:Service)"/>
          </SubElm>
        </Elm>
      </QTY>
    </S12>
  </xsl:template>

  <xsl:template mode="RUC" match="m:Rules">
    <S14 hidden="true">
      <RCS>
        <Elm>
          <SubElm>ACT</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:TimeRate"/>
          </SubElm>
          <SubElm>TID</SubElm>
          <SubElm>SFU</SubElm>
        </Elm>
      </RCS>
      <xsl:if test="m:InsuranceCard">
          <RCS>
            <Elm>
              <SubElm>ACT</SubElm>
            </Elm>
            <Elm>
              <SubElm><xsl:value-of select="m:InsuranceCard"/></SubElm>
              <SubElm>PSB</SubElm>
              <SubElm>SFU</SubElm>
            </Elm>
          </RCS>
      </xsl:if>
      <xsl:if test="m:ElectronicReferral">
        <RCS>
          <Elm>
            <SubElm>ACT</SubElm>
          </Elm>
          <Elm>
            <SubElm><xsl:value-of select="m:ElectronicReferral"/></SubElm>
            <SubElm>ERF</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </RCS>
      </xsl:if>      
    </S14>
  </xsl:template>

  <xsl:template mode="RUC" match="m:CommunityMedicine">
    <S15 hidden="true">
      <NAD>
        <Elm>
          <SubElm>AFR</SubElm>
        </Elm>
        <Elm>
          <SubElm><xsl:value-of select="m:*/text()"/></SubElm>
          <SubElm>
          <xsl:choose>
            <xsl:when test="m:CountyIdentifier">
              <xsl:text>AMT</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>KOM</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          </SubElm>
          <SubElm>IM</SubElm>
        </Elm>
      </NAD>
    </S15>
  </xsl:template>

  <xsl:template mode="RUC" match="m:ReferralIdentifier">
    <S15 hidden="true">
      <NAD>
        <Elm>
          <SubElm>REF</SubElm>
        </Elm>
        <Elm>
          <SubElm><xsl:value-of select="text()"/></SubElm>
          <SubElm>YNR</SubElm>
          <SubElm>SFU</SubElm>
        </Elm>
      </NAD>
    </S15>
  </xsl:template>

  <xsl:template mode="RUC" match="m:Service">
    <S17 hidden="true">
      <CLI>
        <Elm>
          <SubElm>CO</SubElm>
        </Elm>
        <Elm>
          <SubElm>
            <xsl:value-of select="m:Rate"/>
          </SubElm>
          <SubElm>TKS</SubElm>
          <SubElm>SFU</SubElm>
        </Elm>
      </CLI>
      <xsl:for-each select="m:Correction">
        <GIS>
          <Elm>
            <SubElm><xsl:value-of select="text()"/></SubElm>
          </Elm>
        </GIS>
      </xsl:for-each>
      <DTM>
        <Elm>
          <SubElm>TRD</SubElm>
          <xsl:call-template name="DateTo102">
            <xsl:with-param name="date" select="m:DateOfTreatment"/>
          </xsl:call-template>
        </Elm>
      </DTM>
      <QTY>
        <Elm>
          <SubElm>YDE</SubElm>
          <SubElm>
            <xsl:value-of select="m:Amount"/>
          </SubElm>
        </Elm>
      </QTY>
      <S19 hidden="true">
        <RCS>
          <Elm>
            <SubElm>HC</SubElm>
          </Elm>
          <Elm>
            <SubElm>
              <xsl:choose>
                <xsl:when test="m:TimeQualifier">
                  <xsl:value-of select="m:TimeQualifier"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
              </xsl:choose>
            </SubElm>
            <SubElm>TPK</SubElm>
            <SubElm>SFU</SubElm>
          </Elm>
        </RCS>
      </S19>
    </S17>
  </xsl:template>
  
  <xsl:template name="DateTo102">
    <xsl:param name="date" select="."/>
    <SubElm>
      <xsl:value-of select="substring($date, 1, 4)"/>
      <xsl:value-of select="substring($date, 6, 2)"/>
      <xsl:value-of select="substring($date, 9, 2)"/>
    </SubElm>
    <SubElm>102</SubElm>
  </xsl:template>

	<!-- BILLING -->
	<xsl:template match="m:GeneralPractitionerBilling">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="BillInfos" select="m:BillingInformation"/>
		<xsl:variable name="PatInfos" select="$BillInfos/m:PatientInformation"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>MEDRUC</SubElm>
					<SubElm>D</SubElm>
					<SubElm>93A</SubElm>
					<SubElm>UN</SubElm>
					<SubElm>U0131U</SubElm>
				</Elm>
				<Elm>
					<SubElm>RUC01</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>AFR</SubElm>
						<SubElm/>
						<SubElm/>
						<SubElm>REGN0003</SubElm>
					</Elm>
					<Elm/>
					<Elm/>
					<Elm>
						<SubElm>NA</SubElm>
					</Elm>
				</BGM>
				<DTM>
					<Elm>
						<SubElm>137</SubElm>
						<SubElm>
							<xsl:variable name="DT" select="$Letter/m:Authorisation"/>
							<xsl:variable name="DT203" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
							<xsl:value-of select="$DT203"/>
						</SubElm>
						<SubElm>203</SubElm>
					</Elm>
				</DTM>
				<DTM>
					<Elm>
						<SubElm>263</SubElm>
						<SubElm>
							<xsl:value-of select="$BillInfos/m:BillingWeek"/>
						</SubElm>
						<SubElm>616</SubElm>
					</Elm>
				</DTM>
				<QTY>
					<Elm>
						<SubElm>TMQ</SubElm>
						<SubElm>
							<xsl:value-of select="$BillInfos/m:TotalPatientCount"/>
						</SubElm>
					</Elm>
				</QTY>
				<S01 hidden="true">
					<MOA>
						<Elm>
							<SubElm>86</SubElm>
							<SubElm>
								<xsl:value-of select="$BillInfos/m:TotalPrice"/>
							</SubElm>
						</Elm>
					</MOA>
				</S01>
				<!-- SENDER -->
				<S02 hidden="true">
					<xsl:variable name="Participant" select="$Sender"/>
					<NAD>
						<Elm>
							<SubElm>MS</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:Identifier"/>
							</SubElm>
							<SubElm>YNR</SubElm>
							<SubElm>SFU</SubElm>
						</Elm>
					</NAD>
					<!-- Standard for ADR segments -->
					<ADR>
						<Elm>
							<SubElm>VA</SubElm>
						</Elm>
						<Elm/>
						<Elm/>
						<Elm/>
						<Elm/>
						<Elm>
							<SubElm>0000</SubElm>
							<SubElm>VA</SubElm>
							<SubElm>SFU</SubElm>
						</Elm>
					</ADR>
					<SPR>
						<Elm>
							<SubElm>ORG</SubElm>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:call-template name="SpecialityCodeToAFSSPEC">
									<xsl:with-param name="SC" select="$Participant/m:SpecialityCode"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>SPC</SubElm>
							<SubElm>SFU</SubElm>
						</Elm>
					</SPR>
				</S02>
				<!-- Receiver -->
				<S02 hidden="true">
					<xsl:variable name="Participant" select="$Receiver"/>
					<NAD>
						<Elm>
							<SubElm>MR</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:CountyCode"/>
							</SubElm>
							<SubElm>AMT</SubElm>
							<SubElm>IM</SubElm>
						</Elm>
					</NAD>
				</S02>
				<S03 hidden="true">
					<CTI>
						<Elm>
							<SubElm>VAL</SubElm>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>I</SubElm>
							<SubElm>PRL</SubElm>
							<SubElm>SFU</SubElm>
						</Elm>
					</CTI>
				</S03>
				<!-- Regning -->
				<xsl:for-each select="$PatInfos">
					<S05 hidden="true">
						<BUS>
							<Elm>
								<SubElm>1</SubElm>
								<SubElm>AFR</SubElm>
							</Elm>
						</BUS>
					</S05>
					<S07 hidden="true">
						<PNA>
							<Elm>
								<SubElm>PAT</SubElm>
							</Elm>
							<Elm>
								<xsl:if test="count(m:CivilRegistrationNumber)=1">
									<SubElm>
										<xsl:if test="string-length(m:CivilRegistrationNumber)=10">
											<xsl:value-of select="m:CivilRegistrationNumber"/>
										</xsl:if>
										<xsl:if test="string-length(m:CivilRegistrationNumber)=11">
											<xsl:value-of select="concat(substring(m:CivilRegistrationNumber,1,6),substring(m:CivilRegistrationNumber,8,4))"/>
										</xsl:if>
									</SubElm>
									<SubElm>CPR</SubElm>
									<SubElm>IM</SubElm>
								</xsl:if>
								<xsl:if test="count(m:AlternativeIdentifier)=1">
									<SubElm>
										<xsl:value-of select="m:AlternativeIdentifier"/>
									</SubElm>
									<SubElm>CPR</SubElm>
									<SubElm>SFU</SubElm>
								</xsl:if>
							</Elm>
						</PNA>
						
					</S07>
					<xsl:if test="count(m:PatientType)=1">
					<S10 hidden="true">
						<CTI>
							<Elm>
								<SubElm>CUR</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:PatientType"/>
								</SubElm>
								<SubElm>PTT</SubElm>
								<SubElm>SFU</SubElm>
							</Elm>
						</CTI>
					</S10>
					</xsl:if>
					<S12 hidden="true">
						<PRC>
							<Elm>
								<SubElm>CON</SubElm>
							</Elm>
						</PRC>
						<DTM>
							<Elm>
								<SubElm>RET</SubElm>
								<SubElm>
									<xsl:value-of select="m:ServiceTimeCode"/>
								</SubElm>
								<SubElm>401</SubElm>
							</Elm>
						</DTM>
						<xsl:if test="count(m:Statistical15abcde)=1">
							<FTX>
								<Elm>
									<SubElm>ACF</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:Statistical15abcde"/>
									</SubElm>
								</Elm>
							</FTX>
						</xsl:if>						
						<QTY>
							<Elm>
								<SubElm>DET</SubElm>
								<SubElm>
									<xsl:value-of select="m:ServiceCount"/>
								</SubElm>
							</Elm>
						</QTY>
					</S12>
					<S14 hidden="true">
						<RCS>
							<Elm>
								<SubElm>ACT</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:DisadvantageCode"/>
								</SubElm>
								<SubElm>TID</SubElm>
								<SubElm>SFU</SubElm>
							</Elm>
						</RCS>
						<xsl:if test="count(m:CardUsed)=1">
							<xsl:if test="m:CardUsed=1">
							<RCS>
								<Elm>
									<SubElm>ACT</SubElm>
								</Elm>
								<Elm>
									<SubElm>p</SubElm>
									<SubElm>PSB</SubElm>
									<SubElm>SFU</SubElm>
								</Elm>
							</RCS>
							</xsl:if>
						</xsl:if>
					</S14>
					<xsl:if test="count(m:County)=1">
						<S15 hidden="true">
							<NAD>
								<Elm>
									<SubELm>AFR</SubELm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:County/m:CountyNumber"/>
									</SubElm>
									<SubElm>
										<xsl:variable name="KOM" select="m:County/m:CountyCode"/>
										<xsl:choose>
											<xsl:when test=" $KOM='amtet'">AMT</xsl:when>
											<xsl:when test=" $KOM='primaerkommunen'">KOM</xsl:when>
											<xsl:otherwise>
												<FEJL>Kan ikke oversætte CountyCode: <xsl:value-of select="$KOM"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</SubElm>
									<SubElm>IM</SubElm>
								</Elm>
							</NAD>
						</S15>
					</xsl:if>
					<xsl:for-each select="m:Service">
						<S17 hidden="true">
							<CLI>
								<Elm>
									<SubElm>CO</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:Number"/>
									</SubElm>
									<SubElm>TKS</SubElm>
									<SubElm>SFU</SubElm>
								</Elm>
							</CLI>
							<xsl:if test="m:Correction=1">
								<GIS>
									<Elm>
										<SubElm>C</SubElm>
									</Elm>
								</GIS>
							</xsl:if>
							<DTM>
								<Elm>
									<SubElm>TRD</SubElm>
									<SubElm>
										<xsl:variable name="DT102" select="concat(substring(m:Date,1,4),substring(m:Date,6,2),substring(m:Date,9,2))"/>
										<xsl:value-of select="$DT102"/>
									</SubElm>
									<SubElm>102</SubElm>
								</Elm>
							</DTM>
							<QTY>
								<Elm>
									<SubElm>YDE</SubElm>
									<SubElm>
										<xsl:value-of select="m:Count"/>
									</SubElm>
								</Elm>
							</QTY>
						</S17>
						<S19 hidden="true">
							<RCS>
								<Elm>
									<SubElm>HC</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:DateCode"/>
									</SubElm>
									<SubElm>TPK</SubElm>
									<SubElm>SFU</SubElm>
								</Elm>
							</RCS>
						</S19>
					</xsl:for-each>
				</xsl:for-each>
			</BrevIndhold>
			<UNT>
				<Elm>
					<SubElm>1</SubElm>
				</Elm>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
			</UNT>
		</Brev>
	</xsl:template>
</xsl:stylesheet>
