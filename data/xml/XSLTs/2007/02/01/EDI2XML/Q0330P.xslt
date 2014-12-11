<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDREQ' and SubElm[5]='Q0330P']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SLA']"/>
		<xsl:variable name="S01CCReceiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='CCR']"/>
		<xsl:variable name="S01Physician" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV' and RFF/Elm[1]/SubElm[2]=$S01Sender/SEQ/Elm[2]/SubElm[1]]"/>
		<xsl:variable name="S01Payer" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PAY']"/>
<!--		<xsl:variable name="S01Collector" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='COL']"/>
		<xsl:variable name="S01ColPhysician" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV'  and RFF/Elm[1]/SubElm[2]=$S01Collector/SEQ/Elm[2]/SubElm[1]]"/>-->
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<xsl:variable name="S05Patient" select="BrevIndhold/S05"/>
		<xsl:variable name="S06Patient" select="BrevIndhold/S06[PNA/Elm[1]/SubElm[1]='PAT']"/>
		<xsl:variable name="S06Relative" select="BrevIndhold/S06[PNA/Elm[1]/SubElm[1]='PER']"/>
		<xsl:variable name="S09ClinInfo" select="BrevIndhold/S09"/>
		<xsl:variable name="S10Prompts" select="BrevIndhold/S10"/>
		<xsl:variable name="S15Sample" select="BrevIndhold/S15"/>
		<xsl:variable name="S17Requests" select="BrevIndhold/S17"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S05'  or name()='S06' or name()='S09'  or name()='S10'  or name()='S15' or name()='S17')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='PO' or NAD/Elm[1]/SubElm[1]='SLA' or NAD/Elm[1]/SubElm[1]='CCR' or NAD/Elm[1]/SubElm[1]='BV' or NAD/Elm[1]/SubElm[1]='PAY' )] 
												|	BrevIndhold/S06[not(PNA/Elm[1]/SubElm[1]='PAT' or PNA/Elm[1]/SubElm[1]='PER')]"/><!--or BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='COL'--> 
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<PathologyRequest>
			<Letter>
				<Identifier>
					<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
				</Identifier>
				<VersionCode>XQ0330P</VersionCode>
				<StatisticalCode>XREQ03</StatisticalCode>
				<xsl:for-each select="$Dtm">
					<Authorisation>
						<xsl:call-template name="DTM203ToDateTime"/>
					</Authorisation>
				</xsl:for-each>
				<TypeCode>XREQ03</TypeCode>
			</Letter>
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
					<xsl:for-each select="COM">
						<xsl:call-template name="COMToTelephoneSubscriberIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="SPR">
						<xsl:call-template name="SPRToMedicalSpecialityCode"/>
					</xsl:for-each>
					<xsl:for-each select="$S01Physician">
						<Physician>
							<xsl:for-each select="NAD">
								<xsl:call-template name="NADToPersonInitials"/>
							</xsl:for-each>
						</Physician>
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
				</CCReceiver>
			</xsl:for-each>
			<xsl:for-each select="$S01Payer">
				<Payer>
					<PayersTypeCode>
						<xsl:variable name="PTC" select="$S02LetterInfo/FCA/Elm[1]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$PTC='NSP'">anden</xsl:when>
							<xsl:when test="$PTC='PPI'">sygesikring_gruppe_1</xsl:when>
							<xsl:when test="$PTC='PPO'">sygesikring_gruppe_2</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="ValueListError">
									<xsl:with-param name="ValueNode" select="$PTC"/>
									<xsl:with-param name="Text">Ukendt BETKOD</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</PayersTypeCode>
					<xsl:for-each select="NAD">
						<!-- TESTS FOR BETID og BETKOD -->
						<xsl:if test="$S02LetterInfo/FCA/Elm[1]/SubElm[1]='NSP' and Elm[2]/SubElm[1]!='' ">
							<xsl:call-template name="Error">
								<xsl:with-param name="Node" select="Elm[2]/SubElm[1]"/>
								<xsl:with-param name="Text">Der kan ikke angives BETID når BETKOD er <xsl:value-of select="$S02LetterInfo/FCA/Elm[1]/SubElm[1]"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="$S02LetterInfo/FCA/Elm[1]/SubElm[1]!='NSP' and Elm[2]/SubElm[1]='' ">
							<xsl:call-template name="Error">
								<xsl:with-param name="Node" select="Elm[2]/SubElm[1]"/>
								<xsl:with-param name="Text">Der skal angives BETID når BETKOD er <xsl:value-of select="$S02LetterInfo/FCA/Elm[1]/SubElm[1]"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="NADToIdentifier"/>
						<!--SPECIEL OVERSÆTTELSE AF NADToIdentifierCode-->
						<xsl:if test="Elm[2]/SubElm[1]!='' ">
							<IdentifierCode>
								<xsl:variable name="IC" select="Elm[2]/SubElm[2]"/>
								<xsl:choose>
									<xsl:when test="$IC='AMT' ">amt</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="$IC"/>
											<xsl:with-param name="Text">Kan ikke oversaette til IdentifierCodeType: <xsl:value-of select="$IC"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</IdentifierCode>
						</xsl:if>
						<xsl:call-template name="NADToOrganisationName"/>
					</xsl:for-each>
				</Payer>
			</xsl:for-each>
			<!--
			<xsl:for-each select="$S01Collector">
				<Sender>
					<xsl:for-each select="NAD">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCode"/>
						<xsl:call-template name="NADToOrganisationName"/>
						<xsl:call-template name="NADToDepartmentName"/>
						<xsl:call-template name="NADToUnitName"/>
					</xsl:for-each>
					<xsl:for-each select="$S01ColPhysician">
						<Physician>
							<xsl:for-each select="NAD">
								<xsl:call-template name="NADToPersonInitials"/>
							</xsl:for-each>
						</Physician>
					</xsl:for-each>
				</Sender>
			</xsl:for-each>
			-->
			<Patient>
				<xsl:for-each select="$S06Patient">
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
				</xsl:for-each>
				<xsl:for-each select="$S05Patient">
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="COM">
						<xsl:call-template name="COMToTelephoneSubscriberIdentifier"/>
				       </xsl:for-each>
				</xsl:for-each>
				<Consent>
					<Given>
						<xsl:value-of select="count($S06Patient/HAN)=0"/>
					</Given>
				</Consent>
			</Patient>
			<xsl:for-each select="$S06Relative">
				<Relative>
					<xsl:for-each select="REL">
						<xsl:call-template name="RELToRelationCode"/><!--?????? FAR MOR VÆRGE-->
					</xsl:for-each>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNAToPersonIdentifier"/>
						<xsl:call-template name="PNAToPersonSurnameName"/>
						<xsl:call-template name="PNAToPersonGivenName"/>
					</xsl:for-each>
				</Relative>
			</xsl:for-each>
			<RequisitionInformation>
				<xsl:for-each select="$S02LetterInfo/RFF">
					<RequestersRequisitionIdentifier>
						<xsl:value-of select="Elm[1]/SubElm[2]"/>
					</RequestersRequisitionIdentifier>
				</xsl:for-each>
				<RequisitionDateTime>
					<xsl:for-each select="$S02LetterInfo/DTM">
						<xsl:call-template name="DTM203ToDateTime"/>
					</xsl:for-each>
				</RequisitionDateTime>
				<xsl:for-each select="$S15Sample[1]/SPC[Elm[1]/SubElm[1]='SCI']">
						<SamplingLocationCode>
							<xsl:variable name="SLC" select="Elm[2]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$SLC='ATT'">rekvirenten</xsl:when>
								<xsl:when test="$SLC='SPR'">laboratoriet</xsl:when>
								<xsl:when test="$SLC='PAT'">patienten</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ValueListError">
										<xsl:with-param name="ValueNode" select="$SLC"/>
										<xsl:with-param name="Text">Ukendt PRKODE</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</SamplingLocationCode>
					</xsl:for-each>
				<xsl:for-each select="$S15Sample[1]/SPC[Elm[1]/SubElm[1]='SCI']">
						<SamplingDateTimeType>
							<xsl:variable name="SLC" select="Elm[2]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$SLC='ATT'">faktisk</xsl:when>
								<xsl:when test="$SLC='SPR'">oensket</xsl:when>
								<xsl:when test="$SLC='PAT'">oensket</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ValueListError">
										<xsl:with-param name="ValueNode" select="$SLC"/>
										<xsl:with-param name="Text">Ukendt PRKODE</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</SamplingDateTimeType>
					</xsl:for-each>
				<SamplingDateTime>
				<xsl:for-each select="$S02LetterInfo/DTM">
						<xsl:call-template name="DTM203ToDateTime"/>
					</xsl:for-each>
				</SamplingDateTime>

				<xsl:for-each select="$S15Sample">
					<Sample>
						<xsl:for-each select="RFF">
							<RequesterSampleIdentifier>
								<xsl:value-of select="Elm[1]/SubElm[2]"/>
							</RequesterSampleIdentifier>
						</xsl:for-each>
						
						<xsl:for-each select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL')]">
							<MaterialDescription>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
							</MaterialDescription>
						</xsl:for-each>
						<MaterialPreTreatment>
							<xsl:choose>
								<xsl:when test="count(SPC[Elm[1]/SubElm[1]='PRM' and Elm[2]/SubElm[1]='T998'])>0">fikseret</xsl:when>
								<xsl:when test="count(SPC[Elm[1]/SubElm[1]='PRM' and Elm[2]/SubElm[1]='T100'])>0">frysesnit</xsl:when>
								<xsl:otherwise>ikke_fikseret</xsl:otherwise>
							</xsl:choose>
						</MaterialPreTreatment>
						<xsl:variable name="RefFTXs" select="FTX[Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL']"/>
						<xsl:for-each select="$RefFTXs">
							<xsl:call-template name="FTXSegmentToReference"/>
						</xsl:for-each>
					</Sample>
				</xsl:for-each>
				<xsl:for-each select="$S02LetterInfo/PAC">
					<NumberOfTestTubes>
						<xsl:value-of select="Elm[1]/SubElm[1]"/>
					</NumberOfTestTubes>
				</xsl:for-each>
				<xsl:for-each select="$S09ClinInfo/FTX">
					<ClinicalInformation>
						<xsl:call-template name="FTXSegmentsToBreakableText"/>
					</ClinicalInformation>
				</xsl:for-each>
				<xsl:for-each select="$S02LetterInfo/CIN">
					<CodedClinicalInformation>
						<IndicationCode><xsl:value-of select="Elm[2]/SubElm[1]"/></IndicationCode>
						<IndicationText><xsl:value-of select="Elm[2]/SubElm[4]"/></IndicationText>
					</CodedClinicalInformation>
				</xsl:for-each>
				<xsl:for-each select="$S02LetterInfo/FTX[Elm[1]/SubElm[1]!='KOP']">
					<Comments>
						<xsl:call-template name="FTXSegmentsToBreakableText"/>
					</Comments>
				</xsl:for-each>
				<xsl:for-each select="$S02LetterInfo/FTX[Elm[1]/SubElm[1]='KOP']">
					<CarbonCopyReceiver>
						<xsl:value-of select="Elm[4]/SubElm[1]"/>
					</CarbonCopyReceiver>
				</xsl:for-each>
			</RequisitionInformation>
			<Requests>
				<xsl:for-each select="$S17Requests">
					<RequestedAnalysis>
						<xsl:for-each select="$S02LetterInfo/PTY">
							<ResultPriority>
								<xsl:variable name="P" select="Elm[2]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$P='CI'">straks</xsl:when>
									<xsl:when test="$P='HI'">fremskyndet</xsl:when>
									<xsl:when test="$P='NO'">rutine</xsl:when>
									<!--	<xsl:when test="$P='PH'">telefonsvar</xsl:when>-->
									<xsl:otherwise>
										<xsl:call-template name="ValueListError">
											<xsl:with-param name="ValueNode" select="$P"/>
											<xsl:with-param name="Text">Ukendt PRIOR</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</ResultPriority>
						</xsl:for-each>
						<xsl:for-each select="INV">
							<Analysis>
								<AnalysisCode>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</AnalysisCode>
								<AnalysisCodeType>
									<xsl:value-of select="Elm[2]/SubElm[2]"/>
								</AnalysisCodeType>
								<AnalysisShortName>
									<xsl:value-of select="Elm[2]/SubElm[4]"/>
								</AnalysisShortName>
							</Analysis>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='ACM']">
							<AnalysisMDSName>
								<Examination>
									<xsl:value-of select="Elm[4]/SubElm[1]"/>
								</Examination>
								<Material>
									<xsl:value-of select="Elm[4]/SubElm[2]"/>
								</Material>
								<Location>
									<xsl:value-of select="Elm[4]/SubElm[3]"/>
								</Location>
							</AnalysisMDSName>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='SRC']">
							<SupplementaryLocation>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
							</SupplementaryLocation>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='IVC']">
							<SupplementaryAnalysis>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
							</SupplementaryAnalysis>
						</xsl:for-each>
					</RequestedAnalysis>
				</xsl:for-each>
				<xsl:variable name="Kondylomer" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP101']"/>
				<xsl:variable name="Spiral" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP102']"/>
				<xsl:variable name="Gravid" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP103']"/>
				<xsl:variable name="Menstruation" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP201']"/>
				<xsl:variable name="Hormonbeh" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP202']"/>
				<xsl:variable name="Kryobeh" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP203']"/>
				<xsl:variable name="Laser" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP204']"/>
				<xsl:variable name="Konisation" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP205']"/>
				<xsl:variable name="Hysterektomi" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP206']"/>
				<xsl:variable name="Straaleterapi" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP213']"/>
				<xsl:variable name="Kemoterapi" select="$S10Prompts[INV/Elm[2]/SubElm[1]='ADP214']"/>
				<xsl:if test="count($S10Prompts)>0">
					<SupplementaryCervixInformations>
						<xsl:if test="count($Kondylomer)>0">
							<Condyloma>true</Condyloma>
						</xsl:if>
						<xsl:if test="count($Spiral)>0">
							<IUD>true</IUD>
						</xsl:if>
						<xsl:if test="count($Gravid)>0">
							<Pregnant>true</Pregnant>
						</xsl:if>
						<xsl:for-each select="$Menstruation/DTM">
							<DateOfPeriod>
								<xsl:call-template name="DTM102ToDateType"/>
							</DateOfPeriod>
						</xsl:for-each>
						<xsl:for-each select="$Hormonbeh/RSL">
							<HormonTherapy>
								<xsl:value-of select="Elm[2]/SubElm[6]"/>
							</HormonTherapy>
						</xsl:for-each>
						<!--KIG IGEN-->
						<xsl:for-each select="$Kryobeh">
							<DateOfCryoTherapy>
								<xsl:if test="count(DTM)=0">0001-01-01</xsl:if>
								<xsl:for-each select="DTM">
								<xsl:call-template name="DTM102ToDateType"/>
								</xsl:for-each>
							</DateOfCryoTherapy>
						</xsl:for-each>
						<xsl:for-each select="$Laser">
							<DateOfLaser>
								<xsl:if test="count(DTM)=0">0001-01-01</xsl:if>
								<xsl:for-each select="DTM">
								<xsl:call-template name="DTM102ToDateType"/>
								</xsl:for-each>
							</DateOfLaser>
						</xsl:for-each>
						<!--KIG IGEN HERTIL-->
						<xsl:for-each select="$Konisation/DTM">
							<DateOfConisation>
								<xsl:call-template name="DTM102ToDateType"/>
							</DateOfConisation>
						</xsl:for-each>
						<xsl:for-each select="$Hysterektomi/DTM">
							<DateOfHysterectomi>
								<xsl:call-template name="DTM102ToDateType"/>
							</DateOfHysterectomi>
						</xsl:for-each>
						<xsl:for-each select="$Straaleterapi/DTM">
							<DateOfIrradiation>
								<xsl:call-template name="DTM102ToDateType"/>
							</DateOfIrradiation>
						</xsl:for-each>
						<xsl:for-each select="$Kemoterapi/DTM">
							<DateOfChemoTherapy>
								<xsl:call-template name="DTM102ToDateType"/>
							</DateOfChemoTherapy>
						</xsl:for-each>
					</SupplementaryCervixInformations>
				</xsl:if>
			</Requests>
		</PathologyRequest>
	</xsl:template>
</xsl:stylesheet>
