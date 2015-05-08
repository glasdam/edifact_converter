<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/medcom.dk/xml/schemas/2014/10/08/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRPT' and SubElm[5]='R0432P']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SLA']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01CCReceiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='CCR']"/>
		<xsl:variable name="S01Examinator" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV' and RFF/Elm[1]/SubElm[2]='1']"/>
		<xsl:variable name="S01RPhysician" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV' and RFF/Elm[1]/SubElm[2]='2']"/>
		<xsl:variable name="S01CCRPhysician" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV' and RFF/Elm[1]/SubElm[2]='3']"/>
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<xsl:variable name="S02Answer" select="BrevIndhold/S02"/>
		<xsl:variable name="S04Sample" select="BrevIndhold/S04"/>
		<xsl:variable name="DocRekvNrRFF" select="$S04Sample/RFF[Elm[1]/SubElm[1]='ROI']"/>
		<xsl:variable name="LabRekvNrRFF" select="$S04Sample/RFF[Elm[1]/SubElm[1]='SOI']"/>
		<xsl:variable name="SamplingDTM" select="$S04Sample/DTM[Elm[1]/SubElm[1]='4']"/>
		<xsl:variable name="SampleRecDTM" select="$S04Sample/DTM[Elm[1]/SubElm[1]='8']"/>
		<xsl:variable name="S06Patient" select="BrevIndhold/S06"/>
		<xsl:variable name="S07Patient" select="BrevIndhold/S07[PNA/Elm[1]/SubElm[1]='PAT'] "/>
		<xsl:variable name="S07Relative" select="BrevIndhold/S07[PNA/Elm[1]/SubElm[1]='PER'] "/>
		<xsl:variable name="S10ReqInfo" select="BrevIndhold/S10"/>
		<xsl:variable name="S16Samples" select="BrevIndhold/S16"/>
		<xsl:variable name="S18" select="BrevIndhold/S18"/>
		<xsl:variable name="S18Table" select="$S18[1]"/>
		<!--
		<xsl:variable name="S18DiagHeadlinex" select="$S18[2]"/>
		<xsl:variable name="S18Materialsx" select="$S18[(position()>2) and (position() mod 2=0) and (CIN)]"/>
		-->
		<xsl:variable name="S18Headlines" select="$S18[INV/Elm[1]/SubElm[1]='OE']"/>
		<xsl:variable name="DiagnosisHeadline" select="$S18Headlines[2]/INV[1]/Elm[2]/SubElm[4]"/>
		<xsl:variable name="S18Materials" select="$S18[CIN]"/>
		<!--
		<xsl:variable name="Countx" select="2*count(S18Materials)+2"/>
		<xsl:variable name="S18Rest" select="S18[position()>$Countx]"/>
		<xsl:variable name="Mac" select="$S18Rest[1][not(FTX)]"/>
		-->
		<xsl:variable name="S18Macroscopic" select="$S18[FTX/Elm[1]/SubElm[1]='MAC']"/>
		<xsl:variable name="S18Microscopic" select="$S18[FTX//Elm[1]/SubElm[1]='MIC']"/>
		<xsl:variable name="S18Conclusion" select="$S18[FTX/Elm[1]/SubElm[1]='KON']"/>
		<xsl:variable name="S18Hematology" select="$S18[FTX/Elm[1]/SubElm[1]='HEM']"/>
		<xsl:variable name="S18Comments" select="$S18[FTX/Elm[1]/SubElm[1]='SPC']"/>
		<!-- Hvad hvis der ikke er udfyldt FTX segmenter i en af Macro/Micro/Conclusion, hvor de er valgfrie?  
				antag f.eks at macro ikke finder nogen, så må macro være den første af overskrifterne!
				antag at micro er tom og macro ikke er det, så må micro være den første tomme overskrift osv.-->
		<!--
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S05'  or name()='S07' or name()='S09'  or name()='S11'  or name()='S14')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='SSP' or NAD/Elm[1]/SubElm[1]='PO' or NAD/Elm[1]/SubElm[1]='CCR' or NAD/Elm[1]/SubElm[1]='RSP')]
												|	BrevIndhold/S14[not(CIN or FTX)]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>-->
		<HistopathologyReport>
			<xsl:for-each select="$S02LetterInfo">
				<Letter>
					<Identifier>
						<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
					</Identifier>
					<VersionCode>XR0432P</VersionCode>
					<StatisticalCode>XRPT04</StatisticalCode>
					<xsl:for-each select="$Dtm">
						<Authorisation>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Authorisation>
					</xsl:for-each>
					<TypeCode>XRPT04</TypeCode>
					<!--
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
					</StatusCode>-->
					<!--	<xsl:for-each select="$S11/RFF[Elm[1]/SubElm[1]='REI'] ">
						<EpisodeOfCareIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</EpisodeOfCareIdentifier>
					</xsl:for-each>-->
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
					<xsl:for-each select="SPR">
						<xsl:call-template name="SPRToMedicalSpecialityCode"/>
					</xsl:for-each>
					<xsl:for-each select="$S01Examinator">
						<Examinator>
							<xsl:for-each select="NAD">
								<xsl:call-template name="NADToPersonInitials"/>
							</xsl:for-each>
						</Examinator>
					</xsl:for-each>
					<xsl:for-each select="RFF">
						<FromLabIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</FromLabIdentifier>
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
					<xsl:for-each select="$S01RPhysician">
						<Physician>
							<xsl:for-each select="NAD">
								<xsl:call-template name="NADToPersonInitials"/>
							</xsl:for-each>
						</Physician>
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
					</xsl:for-each>
					<xsl:for-each select="$S01CCRPhysician">
						<Physician>
							<xsl:for-each select="NAD">
								<xsl:call-template name="NADToPersonInitials"/>
							</xsl:for-each>
						</Physician>
					</xsl:for-each>
				</CCReceiver>
			</xsl:for-each>
			<Patient>
				<xsl:for-each select="$S07Patient">
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
				<xsl:for-each select="$S06Patient">
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
						<xsl:call-template name="ADRToMunicipalityId"/>
						<xsl:call-template name="ADRToMunicipalityName"/>
					</xsl:for-each>
					<xsl:for-each select="$S07Patient">
						<xsl:for-each select="HAN">
							<Consent>
								<Given>false</Given>
							</Consent>
						</xsl:for-each>
						<xsl:if test="count(HAN)=0">
							<Consent>
								<Given>true</Given>
							</Consent>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</Patient>
			<xsl:for-each select="$S07Relative">
				<Relative>
					<xsl:for-each select="REL">
						<xsl:call-template name="RELToRelationCode"/>
					</xsl:for-each>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNAToPersonIdentifier"/>
						<xsl:call-template name="PNAToPersonSurnameName"/>
						<xsl:call-template name="PNAToPersonGivenName"/>
					</xsl:for-each>
				</Relative>
			</xsl:for-each>
			<RequisitionInformation>
				<xsl:for-each select="$DocRekvNrRFF">
					<RequestersRequisitionIdentifier>
						<xsl:value-of select="Elm[1]/SubElm[2]"/>
					</RequestersRequisitionIdentifier>
				</xsl:for-each>
				<xsl:for-each select="$LabRekvNrRFF">
					<ReceiversRequisitionIdentifier>
						<xsl:value-of select="Elm[1]/SubElm[2]"/>
					</ReceiversRequisitionIdentifier>
				</xsl:for-each>
				<xsl:for-each select="$SamplingDTM">
					<SamplingDateTime>
						<xsl:call-template name="DTM203ToDateTime"/>
					</SamplingDateTime>
				</xsl:for-each>
				<xsl:for-each select="$SampleRecDTM">
					<SampleReceivedDateTime>
						<xsl:call-template name="DTM203ToDateTime"/>
					</SampleReceivedDateTime>
				</xsl:for-each>
				<xsl:for-each select="$S10ReqInfo">
					<ClinicalInformation>
						<xsl:call-template name="FTXSegmentsToBreakableText">
						  <xsl:with-param name="FTXSegments" select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL')]"/>
						</xsl:call-template>
						<!--
							<xsl:call-template name="FTXSegmentsToFormattedText">
								<xsl:with-param name="FTXSegments" select="FTX"/>
							</xsl:call-template>-->
					</ClinicalInformation>
				</xsl:for-each>
				<xsl:for-each select="$S02LetterInfo">
					<xsl:if test="count(FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL')])>0">
					<Comments>
						<xsl:call-template name="FTXSegmentsToBreakableText">
							<xsl:with-param name="FTXSegments" select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL')]"/>
						</xsl:call-template>
						<!--
							<xsl:call-template name="FTXSegmentsToFormattedText">
								<xsl:with-param name="FTXSegments" select="FTX"/>
							</xsl:call-template>-->
					</Comments>
					</xsl:if>
				</xsl:for-each>
				<xsl:variable name="RefFTXs" select="$S10ReqInfo/FTX[Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL']"/>
				<xsl:for-each select="$RefFTXs">
					<xsl:call-template name="FTXSegmentToReference"/>
				</xsl:for-each>
			</RequisitionInformation>
			<LaboratoryResults>
				<GeneralResultInformation>
					<ReportStatusCode>
						<xsl:variable name="SStatC" select="$S02LetterInfo/STS/Elm[2]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$SStatC='K'">komplet_svar</xsl:when>
							<xsl:when test="$SStatC='D'">del_svar</xsl:when>
							<xsl:when test="$SStatC='M'">modtaget</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="Error">
									<xsl:with-param name="Node" select="$SStatC"/>
									<xsl:with-param name="Text">Kan ikke overætte fra STATUS:<xsl:value-of select="$SStatC"/> til ReportStatusCode
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</ReportStatusCode>
					<ResultStatusCode>
						<xsl:variable name="RStatC" select="$S18Table/GIS/Elm[1]/SubElm[1]"/>
						<xsl:variable name="RServC" select="$S18Table/STS/Elm[2]/SubElm[1]"/>
						<!--<xsl:variable name="IsTemp" select="$S18Table/INV/Elm[2]/SubElm[1]='*****'"/>-->
						<xsl:choose>
							<xsl:when test="$RStatC='N' and $RServC='FR' ">svar_endeligt</xsl:when>
							<xsl:when test="$RStatC='M' and $RServC='FR' ">svar_rettet</xsl:when>
							<!--<xsl:when test="$RStatC='N' and $RServC='PR' and $IsTemp ">proeve_modtaget</xsl:when>-->
							<xsl:when test="$RStatC='N' and $RServC='PR' ">svar_midlertidigt</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="Error">
									<xsl:with-param name="Node" select="$RServC"/>
									<xsl:with-param name="Text">Kan ikke overætte fra SERVICETYPE til ResultServiceCode: <xsl:value-of select="$RServC"/> og STATUS 2: <xsl:value-of select="$RStatC"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</ResultStatusCode>
					<xsl:for-each select="$S18Table/RFF[Elm[1]/SubElm[1]!='AHI']">
						<ToLabIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</ToLabIdentifier>
					</xsl:for-each>	
					
					<!--
					<xsl:for-each select="$S18Table/GIS">
						<ResultsServiceCode>
							<xsl:variable name="RSC" select="Elm[1]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$RSC='N' ">nyt</xsl:when>
								<xsl:when test="$RSC='M' ">rettet</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$RSC"/>
										<xsl:with-param name="Text">Kan ikke overætte fra SERVICETYPE til ResultServiceCode: <xsl:value-of select="$RSC"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</ResultsServiceCode>
					</xsl:for-each>
					<xsl:for-each select="$S18Table/STS">
						<ResultsStatusCode>
							<xsl:variable name="RSC" select="Elm[2]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$RSC='FR' ">endeligt</xsl:when>
								<xsl:when test="$RSC='PR' ">foreloebigt</xsl:when>
								
								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$RSC"/>
										<xsl:with-param name="Text">Kan ikke oversætte fra STATUS2 til ResultsStatusCode: <xsl:value-of select="$RSC"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
							
						</ResultsStatusCode>
					</xsl:for-each>-->
					<xsl:for-each select="$S02Answer/DTM">
						<ResultsDateTime>
							<xsl:call-template name="DTM203ToDateTime"/>
						</ResultsDateTime>
					</xsl:for-each>
					<xsl:for-each select="$S02Answer/RFF">
						<LaboratoryInternalProductionIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</LaboratoryInternalProductionIdentifier>
					</xsl:for-each>
				</GeneralResultInformation>
				<CodedFormat>
					<xsl:for-each select="$DiagnosisHeadline">
						<DiagnosisHeadline>
							<xsl:value-of select="."/>
						</DiagnosisHeadline>
					</xsl:for-each>
					<xsl:for-each select="$S16Samples">
						<Sample>
							<xsl:for-each select="RFF[Elm[1]/SubElm[1]='RTI']">
								<RequesterSampleIdentifier>
									<xsl:value-of select="Elm[1]/SubElm[2]"/>
								</RequesterSampleIdentifier>
							</xsl:for-each>
							<xsl:for-each select="RFF[Elm[1]/SubElm[1]='STI']">
								<LaboratoryInternalSampleIdentifier>
									<xsl:value-of select="Elm[1]/SubElm[2]"/>
								</LaboratoryInternalSampleIdentifier>
							</xsl:for-each>
							<MaterialDescription>
								<xsl:call-template name="FTXSegmentsToText">
									<xsl:with-param name="FTXSegments" select="FTX"/>
								</xsl:call-template>
							</MaterialDescription>
							<xsl:variable name="Num" select="SEQ/Elm[2]/SubElm[1]"/>
							<xsl:for-each select="$S18Materials[RFF/Elm[1]/SubElm[2]=$Num]">
								<CodedResults>
									<xsl:variable name="S18Headline" select="./preceding-sibling::S18[1]"/>
									<!-- Det ser ud til at den bliver i omvendt rækkefølge når vi siger preceding-sibling, man skulle ellers mene at det var sidste preceding-sibling der gav headline-->
									<xsl:variable name="INVHeadline" select="$S18Headline[1]/INV[last()]"/>
									<Headline>
										<xsl:value-of select="$INVHeadline/Elm[2]/SubElm[4]"/>
									</Headline>
									<xsl:for-each select="CIN[position()=1 and Elm[1]/SubElm[1]='CCI']">
										<Topography>
											<Code>
												<xsl:value-of select="Elm[2]/SubElm[1]"/>
											</Code>
											<Text>
												<xsl:value-of select="Elm[2]/SubElm[4]"/>
											</Text>
											<xsl:variable name="Com" select="CIN[position()=2 and Elm[1]/SubElm[1]='SPC']"/>
											<xsl:if test="count($Com)=1">
												<Comment>
													<xsl:value-of select="$Com/Elm[2]/SubElm[4]"/>
												</Comment>
											</xsl:if>
										</Topography>
									</xsl:for-each>
									<xsl:for-each select="CIN[position()>1 and Elm[1]/SubElm[1]='CCI']">
										<Result>
											<Code>
												<xsl:value-of select="Elm[2]/SubElm[1]"/>
											</Code>
											<Text>
												<xsl:value-of select="Elm[2]/SubElm[4]"/>
											</Text>
											<xsl:variable name="Com" select="./following-sibling::CIN[position()=1 and  Elm[1]/SubElm[1]='SPC' ]"/>
											<xsl:if test="count($Com)=1">
												<Comment>
													<xsl:value-of select="$Com/Elm[2]/SubElm[4]"/>
												</Comment>
											</xsl:if>
										</Result>
									</xsl:for-each>
								</CodedResults>
							</xsl:for-each>
						</Sample>
					</xsl:for-each>
				</CodedFormat>
				<xsl:for-each select="$S18Table">
					<TableFormat>
						<xsl:for-each select="INV">
							<ResultHeadline>
								<xsl:value-of select="Elm[2]/SubElm[4]"/>
							</ResultHeadline>
						</xsl:for-each>
						<xsl:for-each select="RSL">
							<TableResult>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</TableResult>

							<xsl:variable name="ResVal" select="Elm[5]/SubElm[1]"/>
							<xsl:if test="$ResVal!=''">
								<ResultValidation>
									<xsl:choose>
										<xsl:when test="$ResVal='MA'">malign</xsl:when>
										<xsl:when test="$ResVal='PM'">premalign</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="Error">
												<xsl:with-param name="Node" select="$ResVal"/>
												<xsl:with-param name="Text">Kan ikke oversætte fra ABNORM:<xsl:value-of select="$ResVal"/> til ResultValidation
												</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</ResultValidation>
							</xsl:if>
						</xsl:for-each>
					</TableFormat>
				</xsl:for-each>
				<TextualFormat>
					<xsl:for-each select="$S18Macroscopic">
						<Macroscopic>
							<Headline>
								<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
							</Headline>
							<Text>
								<xsl:call-template name="FTXSegmentsToFormattedText">
									<xsl:with-param name="FTXSegments" select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL')]"/>
								</xsl:call-template>
							</Text>
							<xsl:variable name="RefFTXs" select="FTX[Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL']"/>
							<xsl:for-each select="$RefFTXs">
								<xsl:call-template name="FTXSegmentToReference"/>
							</xsl:for-each>
						</Macroscopic>
					</xsl:for-each>
					<xsl:for-each select="$S18Microscopic">
						<Microscopic>
							<Headline>
								<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
							</Headline>
							<Text>
								<xsl:call-template name="FTXSegmentsToFormattedText">
									<xsl:with-param name="FTXSegments" select="FTX[not(Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL')]"/>
								</xsl:call-template>
							</Text>
							<xsl:variable name="RefFTXs" select="FTX[Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL']"/>
							<xsl:for-each select="$RefFTXs">
								<xsl:call-template name="FTXSegmentToReference"/>
							</xsl:for-each>
						</Microscopic>
					</xsl:for-each>
					<xsl:for-each select="$S18Conclusion">
						<Conclusion>
							<Headline>
								<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
							</Headline>
							<Text>
								<xsl:call-template name="FTXSegmentsToFormattedText">
									<xsl:with-param name="FTXSegments" select="FTX"/>
								</xsl:call-template>
							</Text>
						</Conclusion>
					</xsl:for-each>
					<xsl:for-each select="$S18Hematology">
						<Hematology>
							<Headline>
								<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
							</Headline>
						  <Labels>
						    <CellTypes>
						      <xsl:value-of select="normalize-space(substring(FTX[1]/Elm[4]/SubElm[1], 1, 40))"/>
						    </CellTypes>
						    <Marrow>
						      <xsl:value-of select="normalize-space(substring(FTX[1]/Elm[4]/SubElm[1], 41, 11))"/>
						    </Marrow>
						    <Peripheral>
						      <xsl:value-of select="normalize-space(substring(FTX[1]/Elm[4]/SubElm[1], 53, 11))"/>
						    </Peripheral>
						  </Labels>
						  <xsl:for-each select="FTX[position() > 1]/Elm[4]/SubElm[1]">
						    <xsl:call-template name="HEM2TABLE"/>
						  </xsl:for-each>
						</Hematology>
					</xsl:for-each>
					<xsl:for-each select="$S18Comments">
						<Comments>
							<Headline>
								<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
							</Headline>
							<Text>
								<xsl:call-template name="FTXSegmentsToFormattedText">
									<xsl:with-param name="FTXSegments" select="FTX"/>
								</xsl:call-template>
							</Text>
						</Comments>
					</xsl:for-each>
				</TextualFormat>
			</LaboratoryResults>
		</HistopathologyReport>
	</xsl:template>
  
  <xsl:template name="HEM2TABLE">
    <xsl:variable name="text" select="text()"/>
    <Result>
      <CellType>
        <xsl:value-of select="normalize-space(substring($text, 1, 40))"/>
      </CellType>
      <Marrow>
        <xsl:value-of select="normalize-space(substring($text, 41, 11))"/>
      </Marrow>
      <Peripheral>
        <xsl:value-of select="normalize-space(substring($text, 53, 11))"/>
      </Peripheral>
    </Result>
  </xsl:template>
  
</xsl:stylesheet>
