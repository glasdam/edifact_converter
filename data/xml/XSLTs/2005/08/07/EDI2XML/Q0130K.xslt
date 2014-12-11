<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDREQ' and SubElm[5]='Q0130K']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SLA']"/>
		<xsl:variable name="S01CCReceiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='CCR']"/>
		<xsl:variable name="S01Physician" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV']"/>
		<xsl:variable name="S01Payer" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PAY']"/>
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<xsl:variable name="S05Patient" select="BrevIndhold/S05"/>
		<xsl:variable name="S06Patient" select="BrevIndhold/S06"/>
		<xsl:variable name="S09ClinInfo" select="BrevIndhold/S09"/>
		<xsl:variable name="S10Prompts" select="BrevIndhold/S10"/>
		<xsl:variable name="S15Sample" select="BrevIndhold/S15"/>
		
		<xsl:variable name="S17Requests" select="BrevIndhold/S17"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S05'  or name()='S06' or name()='S09'  or name()='S10'  or name()='S15' or name()='S17')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='PO' or NAD/Elm[1]/SubElm[1]='SLA' or NAD/Elm[1]/SubElm[1]='CCR' or NAD/Elm[1]/SubElm[1]='BV' or NAD/Elm[1]/SubElm[1]='PAY')]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<LaboratoryRequest>
			<Letter>
				<Identifier>
					<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
				</Identifier>
				<VersionCode>XQ0130K</VersionCode>
				<StatisticalCode>XREQ01</StatisticalCode>
				<xsl:for-each select="$Dtm">
					<Authorisation>
						<xsl:call-template name="DTM203ToDateTime"/>
					</Authorisation>
				</xsl:for-each>
				<TypeCode>XREQ01</TypeCode>
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
			<RequisitionInformation>
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
					<xsl:for-each select="$S15Sample[1]/DTM">
					  <SamplingDateTime>
						<xsl:call-template name="DTM203ToDateTime"/>
					  </SamplingDateTime>
					</xsl:for-each>
				<xsl:for-each select="$S15Sample">
				<Sample>
					<xsl:for-each select="$S02LetterInfo/RFF">
						<RequesterSampleIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</RequesterSampleIdentifier>
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
						<xsl:for-each select="PTY">
							<ResultPriority>
								<xsl:variable name="P" select="Elm[2]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$P='CI'">straks</xsl:when>
									<xsl:when test="$P='HI'">fremskyndet</xsl:when>
									<xsl:when test="$P='NO'">rutine</xsl:when>
									<!--<xsl:when test="$P='PH'">telefonsvar</xsl:when>-->
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
									<xsl:variable name="ACT" select="Elm[2]/SubElm[2]"/>
									<xsl:choose>
										<xsl:when test="$ACT='CQU'">iupac</xsl:when>
										<xsl:when test="$ACT='91'">lokal</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="ValueListError">
												<xsl:with-param name="ValueNode" select="$ACT"/>
												<xsl:with-param name="Text">Ukendt KODETABEL</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</AnalysisCodeType>
								<AnalysisCodeResponsible>
									<xsl:value-of select="Elm[2]/SubElm[3]"/>
								</AnalysisCodeResponsible>
							</Analysis>
						</xsl:for-each>
					</RequestedAnalysis>
				</xsl:for-each>
				<xsl:for-each select="$S10Prompts">
					<Prompt>
						<xsl:for-each select="INV">
							<Question>
								<xsl:value-of select="Elm[2]/SubElm[4]"/>
							</Question>
						</xsl:for-each>
						<Answer>
							<xsl:for-each select="RSL[Elm[1]/SubElm[1]='TV']">
								<Text>
									<xsl:value-of select="Elm[2]/SubElm[6]"/>
								</Text>
							</xsl:for-each>
							<xsl:for-each select="RSL[Elm[1]/SubElm[1]='NV']">
								<Numerical>
									<Value>
										<xsl:value-of select="Elm[2]/SubElm[1]"/>
									</Value>
									<Unit>
										<xsl:value-of select="Elm[3]/SubElm[4]"/>
									</Unit>
								</Numerical>
							</xsl:for-each>
							<xsl:for-each select="RSL[Elm[1]/SubElm[1]='CV']">
								<DiagnoseCode>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</DiagnoseCode>
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
		</LaboratoryRequest>
	</xsl:template>
</xsl:stylesheet>
