<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDDIS' and SubElm[5]='D0833L']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SSP']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01CCReceiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='CCR']"/>
		<xsl:variable name="S01Contact" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='RSP']"/>
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<xsl:variable name="S05Referral" select="BrevIndhold/S05"/>
		<xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
		<xsl:variable name="S09Relatives" select="BrevIndhold/S09"/>
		<xsl:variable name="S11" select="BrevIndhold/S11"/>
		<xsl:variable name="DTMAdmission" select="$S11/DTM[Elm[1]/SubElm[1]='90']"/>
		<xsl:variable name="DTMDischarge" select="$S11/DTM[Elm[1]/SubElm[1]='91']"/>
		<xsl:variable name="CINMainDiag" select="$S11/CIN[Elm[1]/SubElm[1]='A']"/>
		<xsl:variable name="CINMainAddDiags" select="$S11/CIN[Elm[1]/SubElm[1]='DM']"/>
		<xsl:variable name="S14OtherDiags" select="BrevIndhold/S14[CIN]"/>
		<xsl:variable name="S14ClinicalInformations" select="BrevIndhold/S14[FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL')]]"/>
		<xsl:variable name="S14RefFTXs" select="BrevIndhold/S14/FTX[Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL']"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S05'  or name()='S07' or name()='S09'  or name()='S11'  or name()='S14')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='SSP' or NAD/Elm[1]/SubElm[1]='PO' or NAD/Elm[1]/SubElm[1]='CCR' or NAD/Elm[1]/SubElm[1]='RSP')]
												|	BrevIndhold/S14[not(CIN or FTX)]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<PhysiotherapyLetter>
			<xsl:for-each select="$S02LetterInfo">
				<Letter>
					<Identifier>
						<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
					</Identifier>
					<VersionCode>XD0833L</VersionCode>
					<StatisticalCode>XDIS08</StatisticalCode>
					<xsl:for-each select="$Dtm">
						<Authorisation>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Authorisation>
					</xsl:for-each>
					<TypeCode>XDIS08</TypeCode>
					<StatusCode>
						<xsl:variable name="C" select="GIS/Elm[1]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$C='N' ">nytbrev</xsl:when>
							<xsl:when test="$C='M' ">rettetbrev</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="Error">
									<xsl:with-param name="Node" select="$C"/>
									<xsl:with-param name="Text">Kan ikke oversaette fra GIS til StatusCode: <xsl:value-of select="$C"/>
									</xsl:with-param>
								</xsl:call-template>
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
					<xsl:for-each select="$S01Contact">
						<Contact>
							<xsl:for-each select="NAD">
								<xsl:call-template name="NADToIdentifier"/>
								<xsl:call-template name="NADToIdentifierCode"/>
								<xsl:call-template name="NADToOrganisationName"/>
								<xsl:call-template name="NADToDepartmentName"/>
								<xsl:call-template name="NADToUnitName"/>
							</xsl:for-each>
						</Contact>
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
			<xsl:for-each select="$S01CCReceiver">
				<CCReceiver>
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
				</CCReceiver>
			</xsl:for-each>
			<xsl:for-each select="$S07Patient">
				<Patient>
					<xsl:if test="count(RFF)=0 and PNA/Elm[2]/SubElm[1]='' ">
						<FEJL>En patient skal enten have et lovligt cpr eller et alternativt ID</FEJL>
					</xsl:if>
					<xsl:for-each select="PNA">
						<xsl:if test="Elm[2]/SubElm[1]!='' ">
							<CivilRegistrationNumber>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</CivilRegistrationNumber>
						</xsl:if>
                                        </xsl:for-each>
					<xsl:for-each select="RFF">
						<AlternativeIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</AlternativeIdentifier>
					</xsl:for-each>
                                        <xsl:for-each select="PNA">
						<PersonSurnameName>
							<xsl:value-of select="Elm[5]/SubElm[2]"/>
						</PersonSurnameName>
						<xsl:if test="Elm[6]/SubElm[2]!='' ">
							<PersonGivenName>
								<xsl:value-of select="Elm[6]/SubElm[2]"/>
							</PersonGivenName>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
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
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$EOCSC"/>
										<xsl:with-param name="Text">Kan ikke oversaette til EpisodeOfCareStatusCode: <xsl:value-of select="$EOCSC"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</EpisodeOfCareStatusCode>
					</xsl:for-each>
				</Patient>
			</xsl:for-each>
			<xsl:for-each select="$S09Relatives">
				<Relative>
					<xsl:for-each select="REL">
						<xsl:call-template name="RELToRelationCode"/>
					</xsl:for-each>
					<xsl:for-each select="PNA">
						<xsl:if test="Elm[2]/SubElm[1]!='_' and Elm[2]/SubElm[1]!='' ">
							<PersonIdentifier>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</PersonIdentifier>
						</xsl:if>
						<PersonSurnameName>
							<xsl:value-of select="Elm[5]/SubElm[2]"/>
						</PersonSurnameName>
						<PersonGivenName>
							<xsl:value-of select="Elm[6]/SubElm[2]"/>
						</PersonGivenName>
					</xsl:for-each>
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
				</Relative>
			</xsl:for-each>
			<xsl:for-each select="$S05Referral">
				<Referral>
					<xsl:variable name="CINRefMainDiag" select="CIN[Elm[1]/SubElm[1]='DI']"/>
					<xsl:variable name="CINRefAddDiags" select="CIN[Elm[1]/SubElm[1]='DM']"/>
					<xsl:for-each select="RFF">
						<Identifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</Identifier>
					</xsl:for-each>
					<xsl:for-each select="DTM">
						<Received>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Received>
					</xsl:for-each>
					<xsl:for-each select="$CINRefMainDiag">
						<Refer>
							<DiagnoseCode>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</DiagnoseCode>
							<DiagnoseTypeCode>
								<xsl:variable name="DTC" select="Elm[2]/SubElm[2]"/>
								<xsl:choose>
									<xsl:when test="$DTC='SKS' ">SKSdiagnosekode</xsl:when>
									<xsl:when test="$DTC='USP' ">uspecificeretkode</xsl:when>
									<xsl:when test="$DTC='ICP' ">ICPCkode</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="$DTC"/>
											<xsl:with-param name="Text">Kan ikke oversaette til DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</DiagnoseTypeCode>
							<DiagnoseText>
								<xsl:value-of select="Elm[2]/SubElm[4]"/>
							</DiagnoseText>
						</Refer>
					</xsl:for-each>
					<xsl:for-each select="$CINRefAddDiags">
						<ReferalAdditional>
							<DiagnoseCode>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</DiagnoseCode>
							<DiagnoseTypeCode>
								<xsl:variable name="DTC" select="Elm[2]/SubElm[2]"/>
								<xsl:choose>
									<xsl:when test="$DTC='SKS' ">SKSdiagnosekode</xsl:when>
									<xsl:when test="$DTC='USP' ">uspecificeretkode</xsl:when>
									<xsl:when test="$DTC='ICP' ">ICPCkode</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="$DTC"/>
											<xsl:with-param name="Text">Kan ikke oversaette til DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</DiagnoseTypeCode>
							<DiagnoseText>
								<xsl:value-of select="Elm[2]/SubElm[4]"/>
							</DiagnoseText>
						</ReferalAdditional>
					</xsl:for-each>
				</Referral>
			</xsl:for-each>
			<xsl:for-each select="$DTMAdmission">
				<Admission>
					<xsl:call-template name="DTM203ToDateTime"/>
				</Admission>
			</xsl:for-each>
			<xsl:for-each select="$DTMDischarge">
				<Discharge>
					<xsl:call-template name="DTM203ToDateTime"/>
				</Discharge>
			</xsl:for-each>
			<xsl:if test="count($CINMainDiag)+count($CINMainAddDiags)+count($S14OtherDiags)>0">
				<Diagnose>
					<xsl:for-each select="$CINMainDiag">
						<Main>
							<DiagnoseCode>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</DiagnoseCode>
							<DiagnoseText>
								<xsl:value-of select="Elm[2]/SubElm[4]"/>
							</DiagnoseText>
						</Main>
					</xsl:for-each>
					<xsl:for-each select="$CINMainAddDiags">
						<MainAdditional>
							<DiagnoseCode>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</DiagnoseCode>
							<DiagnoseText>
								<xsl:value-of select="Elm[2]/SubElm[4]"/>
							</DiagnoseText>
						</MainAdditional>
					</xsl:for-each>
					<xsl:for-each select="$S14OtherDiags">
						<Other>
							<xsl:for-each select="CIN">
								<DiagnoseDescriptionCode>
									<xsl:variable name="Desc" select="Elm[1]/SubElm[1]"/>
									<xsl:choose>
										<xsl:when test="$Desc='DI'">uspec_diagnose</xsl:when>
										<xsl:when test="$Desc='H'">henv_diagnose</xsl:when>
										<xsl:when test="$Desc='B'">bidiagnose</xsl:when>
										<xsl:when test="$Desc='DM'">tillaegsdiagnose</xsl:when>
										<xsl:when test="$Desc='A'">aktionsdiagnose</xsl:when>
										<xsl:when test="$Desc='G'">grundmorbus</xsl:when>
										<xsl:when test="$Desc='M'">midlertidig_diagnose</xsl:when>
										<xsl:when test="$Desc='S'">forloebsdiagnose</xsl:when>
										<xsl:when test="$Desc='TR'">operation</xsl:when>
										<xsl:when test="$Desc='IN'">roentgenundersoegelse</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="Error">
												<xsl:with-param name="Node" select="$Desc"/>
												<xsl:with-param name="Text">Kan ikke oversaette til DiagnoseDescriptionCode: <xsl:value-of select="$Desc"/>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</DiagnoseDescriptionCode>
								<DiagnoseCode>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</DiagnoseCode>
								<DiagnoseTypeCode>
									<xsl:variable name="DTC" select="Elm[2]/SubElm[2]"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKS' ">SKSdiagnosekode</xsl:when>
										<xsl:when test="$DTC='USP' ">uspecificeretkode</xsl:when>
										<xsl:when test="$DTC='ICP' ">ICPCkode</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="Error">
												<xsl:with-param name="Node" select="$DTC"/>
												<xsl:with-param name="Text">Kan ikke oversaette til DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</DiagnoseTypeCode>
								<DiagnoseText>
									<xsl:value-of select="Elm[2]/SubElm[4]"/>
								</DiagnoseText>
							</xsl:for-each>
							<xsl:for-each select="DTM">
								<DiagnoseDateTime>
									<xsl:call-template name="DTM203ToDateTime"/>
								</DiagnoseDateTime>
							</xsl:for-each>
						</Other>
					</xsl:for-each>
				</Diagnose>
			</xsl:if>
			<xsl:for-each select="$S14ClinicalInformations">
				<ClinicalInformation>
					<xsl:for-each select="DTM">
						<Signed>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Signed>
					</xsl:for-each>
					<Text01>
						<xsl:call-template name="FTXSegmentsToFormattedText">
							<xsl:with-param name="FTXSegments" select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL')]"/>
						</xsl:call-template>
					</Text01>
				</ClinicalInformation>
			</xsl:for-each>
			<xsl:for-each select="$S14RefFTXs">
				<xsl:call-template name="FTXSegmentToReference"/>
			</xsl:for-each>
		</PhysiotherapyLetter>
	</xsl:template>
</xsl:stylesheet>
