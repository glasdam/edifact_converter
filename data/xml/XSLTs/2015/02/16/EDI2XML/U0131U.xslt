<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/medcom.dk/xml/schemas/2015/02/16/">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U0131U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <GeneralPractitionerInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU0131U</VersionCode>
        <StatisticalCode>XRUC01</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC01</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </GeneralPractitionerInvoice>
  </xsl:template>
  
  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U0831U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <EmergencyServicePractitionerInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU0831U</VersionCode>
        <StatisticalCode>XRUC08</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC08</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </EmergencyServicePractitionerInvoice>
  </xsl:template>
  
  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U0231U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <PrivateSpecialistInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU0231U</VersionCode>
        <StatisticalCode>XRUC02</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC02</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </PrivateSpecialistInvoice>
  </xsl:template>

  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U1031U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <PsychologistInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU1031U</VersionCode>
        <StatisticalCode>XRUC10</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC10</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </PsychologistInvoice>
  </xsl:template>

  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U0631U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <ChiropractorInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU0631U</VersionCode>
        <StatisticalCode>XRUC06</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC06</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </ChiropractorInvoice>
  </xsl:template>
  
  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U1131U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <ChiropodyInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU1131U</VersionCode>
        <StatisticalCode>XRUC11</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC11</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </ChiropodyInvoice>
  </xsl:template>

  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U0731U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <LaboratoryInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU0731U</VersionCode>
        <StatisticalCode>XRUC07</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC07</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </LaboratoryInvoice>
  </xsl:template>

  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U0431U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <PhysiotherapyInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU0431U</VersionCode>
        <StatisticalCode>XRUC04</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC04</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </PhysiotherapyInvoice>
  </xsl:template>
  
  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U0432U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <PhysiotherapyInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU0432U</VersionCode>
        <StatisticalCode>XRUC04</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC04</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </PhysiotherapyInvoice>
  </xsl:template>
  
  <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRUC' and SubElm[5]='U0332U']]">
    <xsl:variable name="Dtm" select="BrevIndhold/DTM[1]"/>
    <xsl:variable name="patientcount" select="BrevIndhold/QTY/Elm[1]/SubElm[2]/text()"/>
    <xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
    <xsl:if test="count(BrevIndhold/S05) != $patientcount">
      <xsl:call-template name="Error">
        <xsl:with-param name="Text">
          Angivet <xsl:value-of select="$patientcount"/> antal patienter, men indholder <xsl:value-of
            select="count(BrevIndhold/S05)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <DentistInvoice>
      <Letter>
        <Identifier>
          <xsl:value-of select="UNH/Elm[1]/SubElm[1]"/>
        </Identifier>
        <VersionCode>XU0332U</VersionCode>
        <StatisticalCode>XRUC03</StatisticalCode>
        <xsl:for-each select="$Dtm">
          <Authorisation>
            <xsl:call-template name="DTM203ToDateTime"/>
          </Authorisation>
        </xsl:for-each>
        <TypeCode>XRUC03</TypeCode>
        <StatusCode>nytbrev</StatusCode>
      </Letter>
      <xsl:apply-templates mode="RUC01" select="BrevIndhold"/>
    </DentistInvoice>
  </xsl:template>

  <xsl:template mode="RUC01" match="BrevIndhold">
    <Sender>
      <EANIdentifier>
        <xsl:value-of select="$SenderEAN"/>
      </EANIdentifier>
      <Identifier>
        <xsl:value-of select="S02/NAD[1]/Elm[2]/SubElm[1]"/>
      </Identifier>
      <xsl:for-each select="S02/SPR/Elm[3]/SubElm[1]">
        <SpecialityIdentifier>
          <xsl:call-template name="AFSSPECToSpecialityCode"/>
          <xsl:if test=". = 54">
            <xsl:if test="not(/Edifact/Brev/BrevIndhold/S05/S12/CIN/Elm[2]/SubElm[2] = 'FTB')">
              <xsl:call-template name="Error">
                <xsl:with-param name="Text">
                  <xsl:text>Mangler risikostratificering for speciale </xsl:text><xsl:value-of select="."/><xsl:text>. CIN+RFA+Stratificering:FTB:SFU’</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:if>
        </SpecialityIdentifier>
      </xsl:for-each>
    </Sender>

    <Receiver>
      <EANIdentifier>
        <xsl:value-of select="$ReceiverEAN"/>
      </EANIdentifier>
      <CountyIdentifier>
        <xsl:value-of select="S02/NAD[2]/Elm[2]/SubElm[1]"/>
      </CountyIdentifier>
    </Receiver>
      <WeekIdentifier>
        <xsl:variable name="weeknr" select="DTM[2]/Elm[1]/SubElm[2]"/>
        <Year>
         <xsl:value-of select="substring($weeknr, 1, 4)"/>
        </Year>
        <Week>
          <xsl:value-of select="substring($weeknr, 5, 3)"/>
        </Week>
      </WeekIdentifier>
      <Amount>
        <xsl:value-of select="S01/MOA/Elm[1]/SubElm[2]"/>
      </Amount>
      <FieldOfService>
        <xsl:value-of select="S02/ADR/Elm[6]/SubElm[1]"/>
      </FieldOfService>
      <xsl:apply-templates mode="RUC01" select="S05"/>
    
  </xsl:template>

  <xsl:template mode="RUC01" match="S05">
    <Invoice>
    <xsl:apply-templates mode="RUC01" select="*[position() > 1]"/>
    </Invoice>
  </xsl:template>
  
  <xsl:template mode="RUC01" match="S07">
    <Insured>
    <xsl:choose>
      <xsl:when test="PNA/Elm[2]/SubElm[3] = 'IM'">
        <CivilRegistrationNumber>
          <xsl:value-of select="PNA/Elm[2]/SubElm[1]"/>
        </CivilRegistrationNumber>
      </xsl:when>
      <xsl:otherwise>
        <AlternativeIdentifier>
          <xsl:value-of select="PNA/Elm[2]/SubElm[1]"/>
        </AlternativeIdentifier>
        <xsl:if test="NAT">
          <CountryCode>
            <xsl:value-of select="NAT/Elm[2]/SubElm[1]"/>
          </CountryCode>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="REL">
      <ServicedChild>true</ServicedChild>
    </xsl:if>
    </Insured>
  </xsl:template>
  
  <xsl:template mode="RUC01" match="S10">
    <PatientType>
      <xsl:value-of select="CTI/Elm[3]/SubElm[1]"/>
    </PatientType>
  </xsl:template>

  <xsl:template mode="RUC01" match="S12">
    <Activity>
      
      <xsl:for-each select="PAS">
        <ReferralType>
          <xsl:value-of select="Elm[3]/SubElm[1]"/>
        </ReferralType>
      </xsl:for-each>
      <xsl:for-each select="RFF">
        <ReferralID>
          <xsl:value-of select="Elm[1]/SubElm[2]"/>
        </ReferralID>
      </xsl:for-each>
      <xsl:for-each select="DTM">
        <xsl:variable name="type" select="Elm[1]/SubElm[1]"/>
        <xsl:choose>
          <xsl:when test="$type = 'RET'">
            <Time>
              <xsl:variable name="time" select="Elm[1]/SubElm[2]"/>
              <xsl:value-of select="substring($time, 1, 2)"/>:<xsl:value-of select="substring($time, 3, 2)"/>
            </Time>            
          </xsl:when>
          <xsl:when test="$type = 'REF'">
            <ReferralDate>
              <xsl:call-template name="DTM102">
                <xsl:with-param name="date" select="Elm[1]/SubElm[2]"/>
              </xsl:call-template>
            </ReferralDate>
          </xsl:when>
          <xsl:when test="$type = 'RFS'">
            <SubmissionDate>
              <xsl:call-template name="DTM102">
                <xsl:with-param name="date" select="Elm[1]/SubElm[2]"/>
              </xsl:call-template>
            </SubmissionDate>
          </xsl:when>
          <xsl:when test="$type = '194'">
            <StartDate>
              <xsl:call-template name="DTM102">
                <xsl:with-param name="date" select="Elm[1]/SubElm[2]"/>
              </xsl:call-template>
            </StartDate>
          </xsl:when>
          <xsl:when test="$type = '206'">
            <EndDate>
              <xsl:call-template name="DTM102">
                <xsl:with-param name="date" select="Elm[1]/SubElm[2]"/>
              </xsl:call-template>
            </EndDate>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <xsl:for-each select="CIN">
        <xsl:variable name="type" select="Elm[2]/SubElm[2]"/>
        <xsl:choose>
          <xsl:when test="$type = 'FTD'">
            <Diagnose>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </Diagnose>            
          </xsl:when>
          <xsl:when test="$type = 'FTC'">
            <PatientGroup>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </PatientGroup>
          </xsl:when>
          <xsl:when test="$type = 'NAT'">
            <NaturalTeeth>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </NaturalTeeth>
          </xsl:when>
          <xsl:when test="$type = 'CAT'">
            <CarieTeeth>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </CarieTeeth>
          </xsl:when>
          <xsl:when test="$type = 'FIT'">
            <FillingTeeth>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </FillingTeeth>
          </xsl:when>
          <xsl:when test="$type = 'FTB'">
            <Stratified>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </Stratified>
          </xsl:when>
          <xsl:otherwise>
            <ReferralCause>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </ReferralCause>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:for-each>
      <xsl:for-each select="FTX">
      <Statistic>
        <xsl:value-of select="Elm[4]/SubElm[1]"/>
      </Statistic>
      </xsl:for-each>
      <xsl:for-each select="QTY">
        <xsl:variable name="type" select="Elm[1]/SubElm[1]"/>
        <xsl:choose>
          <xsl:when test="$type = 'CON'">
            <ConsultationsAmount>
              <xsl:value-of select="Elm[1]/SubElm[2]"/>
            </ConsultationsAmount>            
          </xsl:when>
          <xsl:when test="$type = 'TEL'">
            <TelephoneConsultationsAmount>
              <xsl:value-of select="Elm[1]/SubElm[2]"/>
            </TelephoneConsultationsAmount>
          </xsl:when>
          <xsl:when test="$type = 'DET'">
            <Amount>
              <xsl:value-of select="Elm[1]/SubElm[2]"/>
            </Amount>            
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </Activity>
  </xsl:template>
  
  <xsl:template mode="RUC01" match="S14">
    <Rules>
      <xsl:for-each select="RCS">
        <xsl:variable name="type" select="Elm[2]/SubElm[2]"/>
        <xsl:choose>
          <xsl:when test="$type = 'TID'">
            <TimeRate>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </TimeRate>            
          </xsl:when>
          <xsl:when test="$type = 'PSB'">
            <InsuranceCard>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </InsuranceCard>
          </xsl:when>
          <xsl:when test="$type = 'ERF'">
            <ElectronicReferral>
              <xsl:value-of select="Elm[2]/SubElm[1]"/>
            </ElectronicReferral>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </Rules>
  </xsl:template>
  
  <xsl:template mode="RUC01" match="S15[../../../UNH/Elm/SubElm[5]='U1031U'] | S15[../../../UNH/Elm/SubElm[5]='U0231U'] | S15[../../../UNH/Elm/SubElm[5]='U0731U'] | S15[../../../UNH/Elm/SubElm[5]='U0432U'] | S15[../../../UNH/Elm/SubElm[5]='U1131U']">
    <ReferralIdentifier>
      <xsl:value-of select="NAD/Elm[2]/SubElm[1]"/>
    </ReferralIdentifier>
  </xsl:template>

  <xsl:template mode="RUC01" match="S15">
    <CommunityMedicine>
      <xsl:choose>
        <xsl:when test="NAD/Elm[2]/SubElm[2] = 'AMT'">
          <CountyIdentifier>
            <xsl:value-of select="NAD/Elm[2]/SubElm[1]"/>
          </CountyIdentifier>
        </xsl:when>
        <xsl:otherwise>
          <MunicipalityIdentifier>
            <xsl:value-of select="NAD/Elm[2]/SubElm[1]"/>
          </MunicipalityIdentifier>          
        </xsl:otherwise>
      </xsl:choose>
    </CommunityMedicine>
  </xsl:template>  

  <xsl:template mode="RUC01" match="S17">
    <Service>
      <Rate>
        <xsl:value-of select="CLI/Elm[2]/SubElm[1]"/>
      </Rate>          
      <xsl:for-each select="GIS">
        <Correction>
          <xsl:value-of select="Elm[1]/SubElm[1]"/>
        </Correction>        
      </xsl:for-each>      
      <xsl:for-each select="DTM">
        <DateOfTreatment>
          <xsl:call-template name="DTM102">
            <xsl:with-param name="date" select="Elm[1]/SubElm[2]"/>
          </xsl:call-template>
        </DateOfTreatment>
      </xsl:for-each>
      <xsl:for-each select="QTY">
        <Amount>
          <xsl:value-of select="Elm[1]/SubElm[2]"/>
        </Amount>
      </xsl:for-each>
      <xsl:for-each select="S19/RCS[Elm[2]/SubElm[1]/text() != '0']">
        <TimeQualifier>
          <xsl:value-of select="Elm[2]/SubElm[1]"/>
        </TimeQualifier>
      </xsl:for-each>
    </Service>
  </xsl:template>
  
  <xsl:template name="DTM102">
    <xsl:param name="date" select="text()"/>
    <xsl:value-of select="substring($date, 1, 4)"/>-<xsl:value-of select="substring($date, 5, 2)"/>-<xsl:value-of select="substring($date, 7, 2)"/>
  </xsl:template>

</xsl:stylesheet>
