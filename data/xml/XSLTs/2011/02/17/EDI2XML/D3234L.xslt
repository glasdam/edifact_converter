<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://rep.oio.dk/medcom.dk/xml/schemas/2011/02/17/">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDDIS' and SubElm[5]='D3234L']]">
        <xsl:variable name="Unh" select="UNH"/>
        <xsl:variable name="Unt" select="UNT"/>
        <xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
        <xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
        <xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SSP']"/>
        <xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
        <xsl:variable name="OwnMaternityMother" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PRH']"/>
        <xsl:variable name="Practitioner" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='UGP']"/>
        <xsl:variable name="BirthMaternityMother"
            select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV']"/>
        <xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
        <xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
        <xsl:variable name="S09Relative" select="BrevIndhold/S09"/>
        <xsl:variable name="S11" select="BrevIndhold/S11"/>

        <BirthNotification>

            <xsl:for-each select="$S02LetterInfo">
                <Letter>
                    <Identifier>
                        <xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
                    </Identifier>
                    <VersionCode>XD3234L</VersionCode>
                    <StatisticalCode>XDIS32</StatisticalCode>
                    <xsl:for-each select="$Dtm">
                        <Authorisation>
                            <xsl:variable name="DTM" select="."/>
                            <xsl:variable name="DT203" select="$DTM/Elm[1]/SubElm[2]"/>
                            <xsl:if test="string-length($DT203)!=12">
                                <FEJL>
                                    <xsl:attribute name="linie">
                                        <xsl:value-of select="$DT203/@linie"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="position">
                                        <xsl:value-of select="$DT203/@position"/>
                                    </xsl:attribute> Forkert antal tegn i Dato:<xsl:value-of
                                        select="$DT203"/>
                                </FEJL>
                            </xsl:if>
                            <Date>
                                <xsl:value-of
                                    select="concat(substring($DT203,1,4),'-',substring($DT203,5,2),'-',substring($DT203,7,2))"
                                />
                            </Date>
                            <Time>
                                <xsl:value-of
                                    select="concat(substring($DT203,9,2),':',substring($DT203,11,2))"
                                />
                            </Time>
                        </Authorisation>
                    </xsl:for-each>
                    <TypeCode>XDIS32</TypeCode>
                    <StatusCode>
                        <xsl:variable name="C" select="GIS/Elm[1]/SubElm[1]"/>
                        <xsl:choose>
                            <xsl:when test="$C='N' ">nytbrev</xsl:when>
                            <xsl:when test="$C='M' ">rettetbrev</xsl:when>
                            <xsl:otherwise>
                                <FEJL>
                                    <xsl:attribute name="linie">
                                        <xsl:value-of select="$C/@linie"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="position">
                                        <xsl:value-of select="$C/@position"/>
                                    </xsl:attribute> Kan ikke oversaette fra GIS til StatusCode:
                                        <xsl:value-of select="$C"/>
                                </FEJL>
                            </xsl:otherwise>
                        </xsl:choose>
                    </StatusCode>
                    <xsl:for-each select="$S11/RFF[Elm[1]/SubElm[1]='REI'] ">
                        <EpisodeOfCareIdentifier>
                            <xsl:value-of select="Elm[1]/SubElm[2]"/>
                        </EpisodeOfCareIdentifier>
                    </xsl:for-each>
                </Letter>
            </xsl:for-each>
            <xsl:for-each select="$S01Sender">
                <Sender>
                    <EANIdentifier>
                        <xsl:value-of select="$SenderEAN"/>
                    </EANIdentifier>
                    <xsl:for-each select="NAD">
                        <xsl:call-template name="NADToIdentifier"/>
                        <xsl:call-template name="NADToIdentifierCode"/>
                        <xsl:call-template name="NADToOrganisationName"/>
                        <xsl:call-template name="NADToDepartmentName"/>
                        <xsl:call-template name="NADToUnitName"/>
                    </xsl:for-each>
                    <xsl:for-each select="ADR">
                        <xsl:call-template name="ADRToStreetName"/>
                        <xsl:call-template name="ADRToSuburbName"/>
                        <xsl:call-template name="ADRToDistrictName"/>
                        <xsl:call-template name="ADRToPostCodeIdentifier"/>
                    </xsl:for-each>
                    <xsl:for-each select="CON">
                        <TelephoneSubscriberIdentifier>
                            <xsl:value-of select="Elm[2]/SubElm[1]"/>
                        </TelephoneSubscriberIdentifier>
                    </xsl:for-each>
                    <xsl:for-each select="SPR">
                        <xsl:call-template name="SPRToMedicalSpecialityCode"/>
                    </xsl:for-each>
                </Sender>
            </xsl:for-each>
            <xsl:for-each select="$S01Receiver">
                <Receiver>
                    <EANIdentifier>
                        <xsl:value-of select="$ReceiverEAN"/>
                    </EANIdentifier>
                    <xsl:for-each select="NAD">
                        <xsl:call-template name="NADToIdentifier"/>
                        <xsl:call-template name="NADToIdentifierCode"/>
                        <xsl:call-template name="NADToOrganisationName"/>
                        <xsl:call-template name="NADToDepartmentName"/>
                        <xsl:call-template name="NADToUnitName"/>
                    </xsl:for-each>
                    <xsl:for-each select="ADR">
                        <xsl:call-template name="ADRToStreetName"/>
                        <xsl:call-template name="ADRToSuburbName"/>
                        <xsl:call-template name="ADRToDistrictName"/>
                        <xsl:call-template name="ADRToPostCodeIdentifier"/>
                    </xsl:for-each>
                </Receiver>
            </xsl:for-each>

            <xsl:for-each select="$OwnMaternityMother">
                <OwnMaternityMother>
                    <xsl:for-each select="NAD">
                        <xsl:call-template name="NADToIdentifier"/>
                        <xsl:call-template name="NADToIdentifierCode"/>
                        <xsl:call-template name="SpecialPersonName"/>
                        <xsl:call-template name="SpecialOrganisationName"/>
                    </xsl:for-each>
                    <xsl:for-each select="ADR">
                        <xsl:call-template name="ADRToStreetName"/>
                        <xsl:call-template name="ADRToSuburbName"/>
                        <xsl:call-template name="ADRToDistrictName"/>
                        <xsl:call-template name="ADRToPostCodeIdentifier"/>
                    </xsl:for-each>
                </OwnMaternityMother>
            </xsl:for-each>

            <xsl:for-each select="$Practitioner">
                <Practitioner>
                    <xsl:for-each select="NAD">
                        <xsl:call-template name="NADToIdentifier"/>
                        <xsl:call-template name="NADToIdentifierCode"/>
                        <xsl:call-template name="NADToOrganisationName"/>
                    </xsl:for-each>
                    <xsl:for-each select="ADR">
                        <xsl:call-template name="ADRToStreetName"/>
                        <xsl:call-template name="ADRToSuburbName"/>
                        <xsl:call-template name="ADRToDistrictName"/>
                        <xsl:call-template name="ADRToPostCodeIdentifier"/>
                    </xsl:for-each>
                </Practitioner>
            </xsl:for-each>

            <xsl:for-each select="$BirthMaternityMother">
                <BirthMaternityMother>
                    <xsl:for-each select="NAD">
                        <xsl:call-template name="NADToIdentifier"/>
                        <xsl:call-template name="NADToIdentifierCode"/>
                        <xsl:call-template name="SpecialPersonName"/>
                        <xsl:call-template name="SpecialOrganisationName"/>
                    </xsl:for-each>
                    <xsl:for-each select="ADR">
                        <xsl:call-template name="ADRToStreetName"/>
                        <xsl:call-template name="ADRToSuburbName"/>
                        <xsl:call-template name="ADRToDistrictName"/>
                        <xsl:call-template name="ADRToPostCodeIdentifier"/>
                    </xsl:for-each>
                </BirthMaternityMother>
            </xsl:for-each>

            <xsl:for-each select="$S07Patient">
                <Patient>
                    <xsl:if test="count(RFF)=0 and PNA/Elm[2]/SubElm[1]='' ">
                        <FEJL>En patient skal enten have et lovligt cpr eller et alternativt
                            ID</FEJL>
                    </xsl:if>
                    <xsl:for-each select="PNA">
                        <xsl:call-template name="PNAToCivilRegistrationNumber"/>
                    </xsl:for-each>
                    <xsl:for-each select="RFF">
                        <xsl:call-template name="RFFToAlternativeIdentifier"/>
                    </xsl:for-each>
                    <xsl:for-each select="PNA">
                        <xsl:call-template name="PNAToPersonSurnameName"/>
                        <xsl:call-template name="PNAToPersonGivenName"/>
                    </xsl:for-each>

                    <xsl:for-each select="ADR">
                        <xsl:if test="Elm[2]/SubElm[2]!='' ">
                            <StreetName>
                                <xsl:value-of select="Elm[2]/SubElm[2]"/>
                            </StreetName>
                        </xsl:if>
                        <xsl:if test="Elm[2]/SubElm[3]!='' ">
                            <SuburbName>
                                <xsl:value-of select="Elm[2]/SubElm[3]"/>
                            </SuburbName>
                        </xsl:if>
                        <xsl:if test="Elm[3]/SubElm[1]!='' ">
                            <DistrictName>
                                <xsl:value-of select="Elm[3]/SubElm[1]"/>
                            </DistrictName>
                        </xsl:if>
                        <xsl:if test="Elm[4]/SubElm[1]!='' ">
                            <PostCodeIdentifier>
                                <xsl:value-of select="Elm[4]/SubElm[1]"/>
                            </PostCodeIdentifier>
                        </xsl:if>
                    </xsl:for-each>

                    <xsl:for-each select="EMP">
                        <OccupancyText>
                            <xsl:value-of select="Elm[3]/SubElm[4]"/>
                        </OccupancyText>
                    </xsl:for-each>

                    <xsl:for-each select="PDI">
                        <xsl:call-template name="PDIToMaritalStatus"/>
                    </xsl:for-each>

                    <xsl:if test="count(CON) &gt; 0">
                        <TelephoneSubscriber>
                            <xsl:for-each select="CON">
                                <xsl:call-template name="CONToTelephoneSubscriber"/>
                            </xsl:for-each>
                        </TelephoneSubscriber>
                    </xsl:if>

                    <xsl:if test="count(LAN) &gt; 0">
                        <InterpretationNeeds>
                            <xsl:for-each select="LAN">
                                <xsl:call-template name="LANToInterpretationIsNeededCode"/>
                                <!-- <xsl:call-template name="LANToISOLanguageCode"/>
                                <xsl:call-template name="LANToISOLanguageCodeDescription"/> -->
                            </xsl:for-each>
                        </InterpretationNeeds>
                    </xsl:if>

                    <xsl:for-each select="$S11/PAS">
                        <EpisodeOfCareStatusCode>
                            <xsl:variable name="EOCSC" select="Elm[1]/SubElm[1]"/>
                            <xsl:choose>
                                <xsl:when test="$EOCSC='POT' ">forløb</xsl:when>
                                <xsl:when test="$EOCSC='HJ' ">direkte_hjem_fra_fødegang</xsl:when>
                                <xsl:when test="$EOCSC='HK' "
                                    >forventet_udskrevet_inden_24_timer_efter_fødslen</xsl:when>
                                <xsl:when test="$EOCSC='HL' "
                                    >forventet_udskrevet_senere_end_24_timer_efter_fødslen</xsl:when>
                                <xsl:otherwise>
                                    <FEJL>
                                        <xsl:attribute name="linie">
                                            <xsl:value-of select="$EOCSC/@linie"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="position">
                                            <xsl:value-of select="$EOCSC/@position"/>
                                        </xsl:attribute> Kan ikke oversaette til
                                        EpisodeOfCareStatusCode: <xsl:value-of select="$EOCSC"/>
                                    </FEJL>
                                </xsl:otherwise>
                            </xsl:choose>
                        </EpisodeOfCareStatusCode>
                    </xsl:for-each>
                </Patient>
            </xsl:for-each>

            <xsl:for-each select="$S09Relative">
                <xsl:if test="REL/Elm[2]/SubElm[1] = 'SD'">
                    <ChildRelation>
                        <xsl:for-each select="REL">
                            <xsl:call-template name="RELToRelationCode"/>
                        </xsl:for-each>
                        <xsl:for-each select="PNA">
                            <xsl:call-template name="PNAToPersonIdentifier"/>
                            <xsl:call-template name="PNAToPersonSurnameNameNM"/>
                            <xsl:call-template name="PNAToPersonGivenName"/>
                        </xsl:for-each>
                        <xsl:for-each select="DTM">
                            <TimeOfBirth>
                                <xsl:call-template name="DTM203ToDateTime"/>
                            </TimeOfBirth>
                        </xsl:for-each>
                        <xsl:for-each select="RFF">
                            <xsl:call-template name="RFFToBirthStatus1"/>
                            <xsl:call-template name="RFFToBirthStatus2"/>
                        </xsl:for-each>
                        <xsl:for-each select="PDI">
                            <xsl:call-template name="PDIToGenderChild"/>
                        </xsl:for-each>
                    </ChildRelation>
                </xsl:if>
                <xsl:if test="REL/Elm[2]/SubElm[1] != 'SD'">
                    <PartnerRelation>
                        <xsl:for-each select="REL">
                            <xsl:call-template name="RELToRelationCode"/>
                        </xsl:for-each>
                        <xsl:for-each select="PNA">
                            <xsl:call-template name="PNAToPersonIdentifier"/>
                            <xsl:call-template name="PNAToPersonSurnameNameNM"/>
                            <xsl:call-template name="PNAToPersonGivenName"/>
                        </xsl:for-each>
                        <xsl:for-each select="EMP">
                            <OccupancyText>
                                <xsl:value-of select="Elm[3]/SubElm[4]"/>
                            </OccupancyText>
                        </xsl:for-each>
                    </PartnerRelation>
                </xsl:if>


            </xsl:for-each>

            <xsl:for-each select="$S11/SEQ">
                <xsl:variable name="SSEQ" select="Elm[2]/SubElm[1]/text()"/>
                <xsl:variable name="SS14"
                    select="//S14[preceding-sibling::S11[SEQ/Elm[2]/SubElm[1] = $SSEQ] and not(preceding-sibling::S11[SEQ/Elm[2]/SubElm[1] = ($SSEQ+1)])]"/>
                <xsl:choose>
                    <xsl:when test="$SSEQ = '1'">
                        <xsl:call-template name="Pregnancy">
                            <xsl:with-param name="SS14" select="$SS14"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$SSEQ='2' ">
                        <xsl:call-template name="Birth">
                            <xsl:with-param name="SS14" select="$SS14"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$SSEQ &gt; '2' ">
                        <xsl:call-template name="ChildInfo">
                            <xsl:with-param name="SS14" select="$SS14"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise> </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>

        </BirthNotification>
    </xsl:template>

    <xsl:template name="Pregnancy">
        <xsl:param name="SS14"/>
        <Pregnancy>
            <xsl:for-each select="../DTM">
                <xsl:variable name="DT" select="Elm[1]/SubElm[1]"/>
                <xsl:choose>
                    <xsl:when test="$DT = '90'">
                        <DateOfLastMenstruation>
                            <xsl:call-template name="DTM203ToDateTime"/>
                        </DateOfLastMenstruation>
                    </xsl:when>
                    <xsl:when test="$DT = '91'">
                        <DateofDelivery>
                            <xsl:call-template name="DTM203ToDateTime"/>
                        </DateofDelivery>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>

            <xsl:for-each select="../CIN">
                <xsl:variable name="CI" select="Elm[1]/SubElm[1]"/>
                <xsl:choose>
                    <xsl:when test="$CI= 'A'">
                        <PregnancyPrincipalDiagnoses>
                            <xsl:call-template name="CINToDiagnoseDescriptionCode"/>
                            <xsl:call-template name="CINToDiagnoseCode"/>
                            <xsl:call-template name="CINToDiagnoseTypeCode"/>
                            <xsl:call-template name="CINToDiagnoseText"/>
                        </PregnancyPrincipalDiagnoses>
                    </xsl:when>
                    <xsl:when test="$CI= 'DM'">
                        <PregnancyAdditionalDiagnoses>
                            <xsl:call-template name="CINToDiagnoseDescriptionCode"/>
                            <xsl:call-template name="CINToDiagnoseCode"/>
                            <xsl:call-template name="CINToDiagnoseTypeCode"/>
                            <xsl:call-template name="CINToDiagnoseText"/>
                        </PregnancyAdditionalDiagnoses>
                    </xsl:when>

                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$SS14">
                <xsl:variable name="FX"
                    select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL' or Elm[1]/SubElm[1]='OE')]"/>
                <xsl:variable name="CI" select="CIN"/>
                <PregnancyInvestigationAndTreatments>
                    <xsl:for-each select="CIN">
                        <InvestigationAndTreatmentDiagnoses>
                            <xsl:call-template name="CINToDiagnoseDescriptionCode"/>
                            <xsl:call-template name="CINToDiagnoseCode"/>
                            <xsl:call-template name="CINToDiagnoseTypeCode"/>
                            <xsl:call-template name="CINToDiagnoseText"/>
                        </InvestigationAndTreatmentDiagnoses>
                    </xsl:for-each>
                    <xsl:for-each select="DTM">
                        <ClinicalInfoDate>
                            <xsl:call-template name="DTM203ToDateTime"/>
                        </ClinicalInfoDate>
                    </xsl:for-each>

                    <xsl:if test="$FX !=''">
                        <InvestigationAndTreatmentText>
                            <xsl:call-template name="FTXSegmentsToFormattedText">
                                <xsl:with-param name="FTXSegments"
                                    select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL' or Elm[1]/SubElm[1]='OE')]"
                                />
                            </xsl:call-template>
                        </InvestigationAndTreatmentText>
                    </xsl:if>
                </PregnancyInvestigationAndTreatments>
            </xsl:for-each>

        </Pregnancy>
    </xsl:template>

    <xsl:template name="Birth">
        <xsl:param name="SS14"/>
        <Birth>
            <xsl:for-each select="../DTM">
                <PregnancyDuration>
                    <xsl:call-template name="DTM103ToYearsWeeksDays"/>
                </PregnancyDuration>
            </xsl:for-each>

            <xsl:for-each select="../CIN">
                <xsl:variable name="CI" select="Elm[1]/SubElm[1]"/>
                <xsl:choose>
                    <xsl:when test="$CI= 'A'">
                        <BirthPrincipalDiagnoses>
                            <xsl:call-template name="CINToDiagnoseDescriptionCode"/>
                            <xsl:call-template name="CINToDiagnoseCode"/>
                            <xsl:call-template name="CINToDiagnoseTypeCode"/>
                            <xsl:call-template name="CINToDiagnoseText"/>
                        </BirthPrincipalDiagnoses>
                    </xsl:when>
                    <xsl:when test="$CI= 'DM'">
                        <BirthAdditionalDiagnoses>
                            <xsl:call-template name="CINToDiagnoseDescriptionCode"/>
                            <xsl:call-template name="CINToDiagnoseCode"/>
                            <xsl:call-template name="CINToDiagnoseTypeCode"/>
                            <xsl:call-template name="CINToDiagnoseText"/>
                        </BirthAdditionalDiagnoses>
                    </xsl:when>

                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$SS14">
                <xsl:for-each select="CIN">
                    <BirthInvestigationAndTreatmentDiagnoses>
                        <xsl:call-template name="CINToDiagnoseDescriptionCode"/>
                        <xsl:call-template name="CINToDiagnoseCode"/>
                        <xsl:call-template name="CINToDiagnoseTypeCode"/>
                        <xsl:call-template name="CINToDiagnoseText"/>
                    </BirthInvestigationAndTreatmentDiagnoses>
                </xsl:for-each>
                <xsl:for-each select="FTX">
                    <xsl:variable name="FC" select="Elm[1]/SubElm[1]"/>
                    <xsl:choose>
                        <xsl:when test="$FC = 'K04'">
                            <BleedingVolume>
                                <xsl:call-template name="FTXSegmentsToFormattedText"/>
                            </BleedingVolume>
                        </xsl:when>
                        <xsl:when test="$FC = 'K05'">
                            <AmnioticFluidDescription>
                                <xsl:call-template name="FTXSegmentsToFormattedText"/>
                            </AmnioticFluidDescription>
                        </xsl:when>
                        <xsl:when test="$FC = 'AFT'">
                            <MaternityMotherAppointment>
                                <xsl:value-of select="Elm[4]/SubElm[1]"/>
                            </MaternityMotherAppointment>
                        </xsl:when>

                        <xsl:otherwise>
                            <BirthAdditionalInfo>
                                <xsl:call-template name="FTXSegmentsToFormattedText"/>
                            </BirthAdditionalInfo>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>

            </xsl:for-each>

        </Birth>
    </xsl:template>

    <xsl:template name="ChildInfo">
        <xsl:param name="SS14"/>
        <ChildInfo>
            <xsl:for-each select="../CIN">
                <xsl:variable name="CI" select="Elm[1]/SubElm[1]"/>
                <xsl:choose>
                    <xsl:when test="$CI= 'A'">
                        <ChildPrincipalDiagnoses>
                            <xsl:call-template name="CINToDiagnoseDescriptionCode"/>
                            <xsl:call-template name="CINToDiagnoseCode"/>
                            <xsl:call-template name="CINToDiagnoseTypeCode"/>
                            <xsl:call-template name="CINToDiagnoseText"/>
                        </ChildPrincipalDiagnoses>
                    </xsl:when>
                    <xsl:when test="$CI= 'DM'">
                        <ChildAdditionalDiagnoses>
                            <xsl:call-template name="CINToDiagnoseDescriptionCode"/>
                            <xsl:call-template name="CINToDiagnoseCode"/>
                            <xsl:call-template name="CINToDiagnoseTypeCode"/>
                            <xsl:call-template name="CINToDiagnoseText"/>
                        </ChildAdditionalDiagnoses>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$SS14">
                <xsl:variable name="S14CIN" select="CIN"/>
                <xsl:if test="$S14CIN !='' ">
                    <xsl:for-each select="CIN">
                        <ChildOtherDiagnoses>
                            <xsl:call-template name="CINToDiagnoseDescriptionCode"/>
                            <xsl:call-template name="CINToDiagnoseCode"/>
                            <xsl:call-template name="CINToDiagnoseTypeCode"/>
                            <xsl:call-template name="CINToDiagnoseText"/>
                        </ChildOtherDiagnoses>
                    </xsl:for-each>
                </xsl:if>
                <xsl:for-each select="FTX">
                    <xsl:variable name="FC" select="Elm[1]/SubElm[1]"/>
                    <xsl:choose>
                        <xsl:when test="$FC = 'K06'">
                            <ChildDimensions>
                                <Weight>
                                    <xsl:value-of select="Elm[4]/SubElm[1]"/>
                                </Weight>
                                <Length>
                                    <xsl:value-of select="Elm[4]/SubElm[2]"/>
                                </Length>
                                <HeadCircumference>
                                    <xsl:value-of select="Elm[4]/SubElm[3]"/>
                                </HeadCircumference>
                            </ChildDimensions>
                        </xsl:when>
                        <xsl:when test="$FC = 'K07'">
                            <ApgarScore>
                                <xsl:if test="Elm[4]/SubElm[1] !='' and Elm[4]/SubElm[1] !='_'">
                                    <ScoreAfterOneMin>
                                        <xsl:value-of select="Elm[4]/SubElm[1]"/>
                                    </ScoreAfterOneMin>
                                </xsl:if>
                                <xsl:if test="Elm[4]/SubElm[2] !='' and Elm[4]/SubElm[2] !='_'">
                                    <ScoreAfterFiveMin>
                                        <xsl:value-of select="Elm[4]/SubElm[2]"/>
                                    </ScoreAfterFiveMin>
                                </xsl:if>
                                <xsl:if test="Elm[4]/SubElm[3] !='' and Elm[4]/SubElm[3] !='_'">
                                    <ScoreAfterTenMin>
                                        <xsl:value-of select="Elm[4]/SubElm[3]"/>
                                    </ScoreAfterTenMin>
                                </xsl:if>
                                <xsl:if test="Elm[4]/SubElm[4] !='' and Elm[4]/SubElm[4] !='_'">
                                    <MinutesAtScoreTen>
                                        <xsl:value-of select="Elm[4]/SubElm[4]"/>
                                    </MinutesAtScoreTen>
                                </xsl:if>
                            </ApgarScore>
                        </xsl:when>
                        <xsl:when test="$FC = 'OVF'">
                            <ChildTransferral>
                                <xsl:value-of select="Elm[4]/SubElm[1]"/>
                            </ChildTransferral>
                        </xsl:when>

                        <xsl:otherwise>
                            <ChildAdditionalInfo>
                                <xsl:call-template name="FTXSegmentsToFormattedText"/>
                            </ChildAdditionalInfo>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>

            </xsl:for-each>

        </ChildInfo>
    </xsl:template>
</xsl:stylesheet>
