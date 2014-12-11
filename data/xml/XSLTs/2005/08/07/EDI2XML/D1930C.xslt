<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDDIS' and SubElm[5]='D1930C']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SSP']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01CCReceiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='CCR']"/>
		<xsl:variable name="S01FamDoc" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='UGP']"/>
		<xsl:variable name="S01Signatur" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='OMI']"/>
		<xsl:variable name="S01ContactInfos" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV']"/>
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
		<xsl:variable name="S09Relatives" select="BrevIndhold/S09"/>
		<xsl:variable name="S11" select="BrevIndhold/S11"/>
		<xsl:variable name="S14" select="BrevIndhold/S14"/>
		<xsl:variable name="DTMAdmission" select="$S14/DTM[Elm[1]/SubElm[1]='CIS']"/>
		<xsl:variable name="DTMEOT" select="$S14/DTM[Elm[1]/SubElm[1]='CIE']"/>
		<xsl:variable name="DTMPD" select="$S14/DTM[Elm[1]/SubElm[1]='CIF']"/>
		<xsl:variable name="DTMPC" select="$S14/DTM[Elm[1]/SubElm[1]='CIP']"/>
		<xsl:variable name="S14CareDescription" select="BrevIndhold/S14[FTX]"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S05'  or name()='S07' or name()='S09'  or name()='S11'  or name()='S14')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='SSP' or NAD/Elm[1]/SubElm[1]='PO' or NAD/Elm[1]/SubElm[1]='CCR' or NAD/Elm[1]/SubElm[1]='UGP' or NAD/Elm[1]/SubElm[1]='OMI' or NAD/Elm[1]/SubElm[1]='BV')]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<WarningOfDischarge>
			<xsl:for-each select="$S02LetterInfo">
				<Letter>
					<Identifier>
						<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
					</Identifier>
					<VersionCode>XD1930C</VersionCode>
					<StatisticalCode>XDIS19</StatisticalCode>
					<xsl:for-each select="$Dtm">
						<Authorisation>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Authorisation>
					</xsl:for-each>
					<TypeCode>XDIS19</TypeCode>
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
					<xsl:for-each select="$S01Signatur">
						<Signatur>
							<xsl:for-each select="NAD">
								<xsl:if test="Elm[4]/SubElm[1]!=''  and Elm[4]/SubElm[1]!='_' ">
									<PersonSurnameName>
										<xsl:value-of select="Elm[4]/SubElm[1]"/>
									</PersonSurnameName>
								</xsl:if>
								<xsl:if test="Elm[4]/SubElm[2]!=''  and Elm[4]/SubElm[2]!='_' ">
									<PersonGivenName>
										<xsl:value-of select="Elm[4]/SubElm[2]"/>
									</PersonGivenName>
								</xsl:if>
								<xsl:if test="Elm[4]/SubElm[3]!='' ">
									<PersonTitle>
										<xsl:value-of select="Elm[4]/SubElm[3]"/>
									</PersonTitle>
								</xsl:if>
							</xsl:for-each>
						</Signatur>
					</xsl:for-each>
					<xsl:for-each select="$S01ContactInfos">
						<ContactInformation>
							<xsl:for-each select="NAD">
								<xsl:if test="Elm[4]/SubElm[1]!=''  and Elm[4]/SubElm[1]!='_' ">
									<ContactName>
										<xsl:value-of select="Elm[4]/SubElm[1]"/>
									</ContactName>
								</xsl:if>
								<xsl:if test="Elm[4]/SubElm[2]!=''  and Elm[4]/SubElm[2]!='_' ">
									<ContactName>
										<xsl:value-of select="Elm[4]/SubElm[2]"/>
									</ContactName>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="CON[Elm[2]/SubElm[2]='TE'] ">
								<TelephoneSubscriberIdentifier>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</TelephoneSubscriberIdentifier>
							</xsl:for-each>
							<xsl:for-each select="CON[Elm[2]/SubElm[2]='FX'] ">
								<TelefaxSubscriberIdentifier>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</TelefaxSubscriberIdentifier>
							</xsl:for-each>
							<xsl:for-each select="CON[Elm[2]/SubElm[2]='EM'] ">
								<EmailIdentifier>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</EmailIdentifier>
							</xsl:for-each>
							<xsl:for-each select="RFF[Elm[1]/SubElm[1]='BUH'] ">
								<ContactTimeText>
									<xsl:value-of select="Elm[1]/SubElm[2]"/>
								</ContactTimeText>
							</xsl:for-each>
						</ContactInformation>
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
					<xsl:for-each select="CON">
						<CodedTelephoneSubscriberIdentifier>
							<TelephoneCode>
								<xsl:variable name="Value" select="Elm[1]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$Value='HO' ">privat</xsl:when>
									<xsl:when test="$Value='WO' ">arbejde</xsl:when>
									<xsl:when test="$Value='MO' ">mobil</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="$Value"/>
											<xsl:with-param name="Text">Kan ikke oversaette til TelephoneCodeType: <xsl:value-of select="$Value"/></xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</TelephoneCode>
							<TelephoneSubscriberIdentifier>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</TelephoneSubscriberIdentifier>
						</CodedTelephoneSubscriberIdentifier>
					</xsl:for-each>
				</Relative>
			</xsl:for-each>
			<xsl:for-each select="$S01FamDoc">
				<FamilyDoctor>
					<xsl:for-each select="NAD">
						<xsl:if test="Elm[2]/SubElm[1]!='' ">
							<Identifier>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</Identifier>
						</xsl:if>
						<xsl:if test="Elm[4]/SubElm[1]!='' ">
							<OrganisationName>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
							</OrganisationName>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="CON">
						<TelephoneSubscriberIdentifier>
							<xsl:value-of select="Elm[2]/SubElm[1]"/>
						</TelephoneSubscriberIdentifier>
					</xsl:for-each>
				</FamilyDoctor>
			</xsl:for-each>
			<xsl:for-each select="$DTMAdmission">
				<Admission>
					<xsl:call-template name="DTM203ToDateTime"/>
				</Admission>
			</xsl:for-each>
			<xsl:for-each select="$DTMPC">
				<PlanConference>
					<xsl:call-template name="DTM203ToDateTime"/>
				</PlanConference>
			</xsl:for-each>
			<xsl:for-each select="$DTMEOT">
				<EndOfTreatment>
					<xsl:call-template name="DTM203ToDateTime"/>
				</EndOfTreatment>
			</xsl:for-each>
			<xsl:for-each select="$DTMPD">
				<PlannedDischarge>
					<xsl:call-template name="DTM203ToDateTime"/>
				</PlannedDischarge>
			</xsl:for-each>
			<xsl:for-each select="$S14CareDescription">
				<CareDescription>
					<CommentsText>
						<xsl:call-template name="FTXSegmentsToFormattedText">
							<xsl:with-param name="FTXSegments" select="FTX"/>
						</xsl:call-template>
					</CommentsText>
				</CareDescription>
			</xsl:for-each>
		</WarningOfDischarge>
	</xsl:template>
</xsl:stylesheet>
