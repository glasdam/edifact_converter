<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/medcom.dk/xml/schemas/2014/10/08/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDREQ' and SubElm[5]='Q0331P']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01OrgReq" select="BrevIndhold/S01/NAD[Elm[1]/SubElm[1]='ORL'] | BrevIndhold/S01/NAD[Elm[1]/SubElm[1]='ORN']"/>
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
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='PO' or NAD/Elm[1]/SubElm[1]='SLA' or NAD/Elm[1]/SubElm[1]='CCR' or NAD/Elm[1]/SubElm[1]='BV' or NAD/Elm[1]/SubElm[1]='PAY' or NAD/Elm[1]/SubElm[1]='ORL' or NAD/Elm[1]/SubElm[1]='ORN')] 
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
				<VersionCode>XQ0331P</VersionCode>
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
			<xsl:for-each select="$S01OrgReq">
				<OriginalRequester>
					<xsl:for-each select=".">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCode"/>
						<xsl:call-template name="NADToOrganisationName"/>
						<xsl:call-template name="NADToDepartmentName"/>
						<xsl:call-template name="NADToUnitName"/>
					</xsl:for-each>
					<xsl:for-each select="../ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select=".">
						<ReplyTo>
							<xsl:variable name="RTO" select="Elm[1]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$RTO='ORN'">false</xsl:when>
								<xsl:when test="$RTO='ORL'">true</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ValueListError">
										<xsl:with-param name="ValueNode" select="$RTO"/>
										<xsl:with-param name="Text">Ukendt afsender kvalifikator: <xsl:value-of select="$RTO"/></xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</ReplyTo>
					</xsl:for-each>
				</OriginalRequester>
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
							<xsl:when test="$PTC='PRE'">rekvirent</xsl:when>
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
								<xsl:variable name="ICO" select="Elm[2]/SubElm[3]"/>
								<xsl:choose>
									<xsl:when test="$IC='AMT' ">amt</xsl:when>
									<xsl:when test="$ICO = 9">lokationsnummer</xsl:when>
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
						<xsl:if test="Elm[4]/SubElm[2] != ''">
							<OrderIdentifier>
								<xsl:value-of select="Elm[4]/SubElm[2]"/>
							</OrderIdentifier>
						</xsl:if>
						<xsl:if test="Elm[4]/SubElm[3] != ''">
							<AccountIdentifier>
								<xsl:value-of select="Elm[4]/SubElm[3]"/>
							</AccountIdentifier>
						</xsl:if>
						
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
					<xsl:variable name="NPN" select="Elm[1]/SubElm[4]"/>
					<xsl:choose>
						<xsl:when test="$NPN='NPN'">
							<SampleIdentifierType>nationaltproevenummer</SampleIdentifierType>
						</xsl:when>
					</xsl:choose>						
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
							<xsl:variable name="NPN" select="Elm[1]/SubElm[4]"/>
							<xsl:choose>
								<xsl:when test="$NPN='NPN'">
									<SampleIdentifierType>nationaltproevenummer</SampleIdentifierType>
								</xsl:when>
							</xsl:choose>						
						</xsl:for-each>
						<xsl:for-each select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL')]">
							<MaterialDescription>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
								<xsl:value-of select="Elm[4]/SubElm[2]"/>
								<xsl:value-of select="Elm[4]/SubElm[3]"/>
							</MaterialDescription>
						</xsl:for-each>
					  	<xsl:for-each select="SPC[Elm[1]/SubElm[1]='PRM' ]">
							<MaterialPreTreatment>
								<xsl:choose>
									<xsl:when test="Elm[1]/SubElm[1]='PRM' and Elm[2]/SubElm[1]='T998'">fikseret</xsl:when>
									<xsl:when test="Elm[1]/SubElm[1]='PRM' and Elm[2]/SubElm[1]='T100'">frysesnit</xsl:when>
									<xsl:otherwise>ikke_fikseret</xsl:otherwise>
						 		</xsl:choose>
							</MaterialPreTreatment>
						</xsl:for-each>
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
						<xsl:for-each select="DTM">
							<AnswerAtLatestDateTime>
								<xsl:call-template name="DTM203ToDateTime"/>
							</AnswerAtLatestDateTime>
						</xsl:for-each>
					</RequestedAnalysis>
				</xsl:for-each>

				<xsl:for-each select="$S10Prompts">
					<Prompt>
						<xsl:for-each select="INV">
							<Question>
								<Code>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</Code>
								<CodeType>
									<xsl:variable name="ACT" select="Elm[2]/SubElm[2]"/>
									<xsl:choose>
										<xsl:when test="$ACT='PA8'">PA8</xsl:when>
										<xsl:when test="$ACT='91'">lokal</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="ValueListError">
												<xsl:with-param name="ValueNode" select="$ACT"/>
												<xsl:with-param name="Text">Ukendt
												KODETABEL</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</CodeType>
								<CodeResponsible>
									<xsl:value-of select="Elm[2]/SubElm[3]"/>
								</CodeResponsible>
								<CodeText>
									<xsl:value-of select="Elm[2]/SubElm[4]"/>
								</CodeText>
							</Question>
						</xsl:for-each>
						<Answer>
							<xsl:for-each select="RSL[Elm[1]/SubElm[1]='TV' or Elm[1]/SubElm[1]='AV']">
								<Text>
									<xsl:value-of select="Elm[2]/SubElm[6]"/>
								</Text>
							</xsl:for-each>
							<xsl:for-each select="RSL[Elm[1]/SubElm[1]='NV']">
								<Numerical>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</Numerical>
							</xsl:for-each>
<!--						<xsl:for-each select="RSL[Elm[1]/SubElm[1]='CV']">
								<DiagnoseCode>
									<xsl:value-of select="Elm[2]/SubElm[3]"/>
								</DiagnoseCode>
							</xsl:for-each>-->
							<xsl:for-each select="RSL[Elm[1]/SubElm[1]='CV']">
								<xsl:variable name="Logisk" select="Elm[2]/SubElm[1]"/>
								<Logical>
									<xsl:choose>
										<xsl:when test="$Logisk='1'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</Logical>
							</xsl:for-each>
							<xsl:for-each select="DTM">
								<DateTime>
									<xsl:call-template name="DTM203ToDateTime"/>
								</DateTime>
							</xsl:for-each>
						</Answer>
					</Prompt>
				</xsl:for-each>
			</Requests>
		</PathologyRequest>
	</xsl:template>
</xsl:stylesheet>
