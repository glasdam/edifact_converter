<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2009/08/01/">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDDIS' and SubElm[5]='D9034L']]">
        <xsl:variable name="Unh" select="UNH"/>
        <xsl:variable name="Unt" select="UNT"/>
        <xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
        <xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
        <xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SSP']"/>
        <xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
        <xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
        <xsl:variable name="Priority" select="$S02LetterInfo/RFF[2]/Elm[1]/SubElm[1]"/>
        <xsl:variable name="SubjectFTX" select="BrevIndhold/S14/FTX[position() = 1 and Elm[1]/SubElm[1]='OE']"></xsl:variable>
        <xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
        <xsl:variable name="S11" select="BrevIndhold/S11"/>
        <xsl:variable name="S14ClinicalInformations"
            select="BrevIndhold/S14[FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL' or Elm[1]/SubElm[1]='OE')]]"/>
        <xsl:variable name="S14RefFTXs" select="BrevIndhold/S14/FTX[Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL']"/>
        <xsl:variable name="IkkeBrugteSegmenter"
            select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S05'  or name()='S07' or name()='S11'  or name()='S14')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='SSP' or NAD/Elm[1]/SubElm[1]='PO')]
												|	BrevIndhold/S14[not(FTX)]"/>
        <xsl:for-each select="$IkkeBrugteSegmenter">
            <FEJL>
                <xsl:attribute name="linie">
                    <xsl:value-of select="./@linie"/>
                </xsl:attribute>
                <xsl:attribute name="position">
                    <xsl:value-of select="./@position"/>
                </xsl:attribute>
		Uventet segment: <xsl:value-of select="name()"/>
            </FEJL>
        </xsl:for-each>
      <AdministrativeEmail>
            <xsl:for-each select="$S02LetterInfo">
                <Letter>
                    <Identifier>
                        <xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
                    </Identifier>
                    <VersionCode>XD9034L</VersionCode>
                    <StatisticalCode>XDIS90</StatisticalCode>
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
                                    </xsl:attribute>
						Forkert antal tegn i Dato:<xsl:value-of select="$DT203"/>
                                </FEJL>
                            </xsl:if>
                            <Date>
                                <xsl:value-of select="concat(substring($DT203,1,4),'-',substring($DT203,5,2),'-',substring($DT203,7,2))"/>
                            </Date>
                            <Time>
                                <xsl:value-of select="concat(substring($DT203,9,2),':',substring($DT203,11,2))"/>
                            </Time>
                        </Authorisation>
                    </xsl:for-each>
                    <TypeCode>XDIS90</TypeCode>
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
                                    </xsl:attribute>
							Kan ikke oversaette fra GIS til StatusCode: <xsl:value-of select="$C"/>
                                </FEJL>
                            </xsl:otherwise>
                        </xsl:choose>
                    </StatusCode>
                    <xsl:for-each select="$S11/RFF[Elm[1]/SubElm[1]='REI'] ">
                        <EpisodeOfCareIdentifier>
                            <xsl:value-of select="Elm[1]/SubElm[2]"/>
                        </EpisodeOfCareIdentifier>
                    </xsl:for-each>
                    <!--Boer tjekkes for at kval er 'REI' eller 'AHI'-->
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
            <xsl:for-each select="$S07Patient">
                <Patient>
                    <xsl:if test="count(RFF)=0 and PNA/Elm[2]/SubElm[1]='' ">
                        <FEJL>En patient skal enten have et lovligt cpr eller et alternativt ID</FEJL>
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
                    <xsl:for-each select="$S11/PAS">
                        <EpisodeOfCareStatusCode>
                            <xsl:variable name="EOCSC" select="Elm[1]/SubElm[1]"/>
                            <xsl:choose>
                                <xsl:when test="$EOCSC='POT' ">inaktiv</xsl:when>
                                <xsl:when test="$EOCSC='HS' ">indlagt</xsl:when>
                                <xsl:when test="$EOCSC='HA' ">ambulant</xsl:when>
                                <xsl:when test="$EOCSC='DA' ">doed</xsl:when>
                                <xsl:when test="$EOCSC='REQ' ">ambulant_roentgen</xsl:when>
                                <xsl:otherwise>
                                    <FEJL>
                                        <xsl:attribute name="linie">
                                            <xsl:value-of select="$EOCSC/@linie"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="position">
                                            <xsl:value-of select="$EOCSC/@position"/>
                                        </xsl:attribute>
							Kan ikke oversaette til EpisodeOfCareStatusCode: <xsl:value-of select="$EOCSC"/>
                                    </FEJL>
                                </xsl:otherwise>
                            </xsl:choose>
                        </EpisodeOfCareStatusCode>
                    </xsl:for-each>
                </Patient>
            </xsl:for-each>
            <xsl:if test="count($SubjectFTX) &gt; 0 or $Priority">
            <AdditionalInformation>
                <xsl:choose>
                    <xsl:when test="$Priority = 'HI'"><Priority>høj_prioritet</Priority></xsl:when>
                    <xsl:when test="$Priority = 'NO'"><Priority>rutine</Priority></xsl:when>
                </xsl:choose>
                <xsl:for-each select="$SubjectFTX">
                    <Subject><xsl:value-of select="$SubjectFTX/Elm[4]/SubElm[1]"/></Subject>
                </xsl:for-each>
            </AdditionalInformation>
            </xsl:if>
            <xsl:for-each select="$S14ClinicalInformations">
                <ClinicalInformation>
                    <Text01>
                        <xsl:call-template name="FTXSegmentsToFormattedText">
                            <xsl:with-param name="FTXSegments"
                                select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL' or Elm[1]/SubElm[1]='OE')]"/>
                        </xsl:call-template>
                    </Text01>
                </ClinicalInformation>
            </xsl:for-each>
            <xsl:for-each select="$S14RefFTXs">
                <xsl:call-template name="FTXSegmentToReference"/>
            </xsl:for-each>
        </AdministrativeEmail>
    </xsl:template>
</xsl:stylesheet>
