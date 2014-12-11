<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- LABORATORYREPORT -->
	<xsl:template match="m:LaboratoryReport">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<!--<xsl:variable name="Examinator" select="$Sender/m:Examinator"/>-->
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="RPhysician" select="$Receiver/m:Physician"/>
		<xsl:variable name="CCReceiver" select="m:CCReceiver"/>
		<!--<xsl:variable name="CCRPhysician" select="$CCReceiver/m:Physician"/>-->
		<xsl:variable name="Patient" select="m:Patient"/>
		<!--<xsl:variable name="Relative" select="m:Relative"/>-->
		<xsl:variable name="ReqInfo" select="m:RequisitionInformation"/>
		<xsl:variable name="Sample" select="$ReqInfo/m:Sample"/>
		<xsl:variable name="LabResults" select="m:LaboratoryResults"/>
		<xsl:variable name="GeneralResultInformation" select="$LabResults/m:GeneralResultInformation"/>
		<xsl:variable name="Results" select="$LabResults/m:Result"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>MEDRPT</SubElm>
					<SubElm>D</SubElm>
					<SubElm>93A</SubElm>
					<SubElm>UN</SubElm>
					<SubElm>R0130K</SubElm>
				</Elm>
				<Elm>
					<SubElm>RPT01</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>LRP</SubElm>
					</Elm>
					<Elm/>
					<Elm>
						<SubElm>9</SubElm>
					</Elm>
					<Elm>
						<SubElm>NA</SubElm>
					</Elm>
				</BGM>
				<DTM>
					<Elm>
						<SubElm>137</SubElm>
						<SubElm>
							<xsl:call-template name="DateTimeToDTM203">
								<xsl:with-param name="DT" select="$Letter/m:Authorisation"/>
							</xsl:call-template>
						</SubElm>
						<SubElm>203</SubElm>
					</Elm>
				</DTM>
				<!-- SENDER -->
				<S01>
					<xsl:variable name="Participant" select="$Sender"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>SLA</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:Identifier"/>
							</SubElm>
							<xsl:for-each select="$Participant/m:IdentifierCode">
								<xsl:call-template name="RPTIdentifierCode"/>
							</xsl:for-each>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:OrganisationName"/>
								<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:DepartmentName"/>
								<xsl:if test="count($Participant/m:DepartmentName)=0 and count($Participant/m:UnitName)>0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:UnitName"/>
							</SubElm>
							<SubElm/>
							<SubElm/>
							<SubElm>US</SubElm>
						</Elm>
					</NAD>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>1</SubElm>
						</Elm>
					</SEQ>
					<SPR>
						<Elm>
							<SubElm>ORG</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:call-template name="MedicalSpecialityCodeToAFSSPEC">
									<xsl:with-param name="MSC" select="$Participant/m:MedicalSpecialityCode"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>SKS</SubElm>
							<SubElm>SST</SubElm>
						</Elm>
						<Elm>
							<SubElm>RPT01</SubElm>
							<SubElm>SKS</SubElm>
							<SubElm>SST</SubElm>
						</Elm>
					</SPR>
				</S01>
				<!-- Receiver -->
				<S01>
					<xsl:variable name="Participant" select="$Receiver"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>PO</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:Identifier"/>
							</SubElm>
							<xsl:for-each select="$Participant/m:IdentifierCode">
								<xsl:call-template name="RPTIdentifierCode"/>
							</xsl:for-each>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:OrganisationName"/>
								<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:DepartmentName"/>
								<xsl:if test="count($Participant/m:DepartmentName)=0 and count($Participant/m:UnitName)>0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:UnitName"/>
							</SubElm>
							<SubElm/>
							<SubElm/>
							<SubElm>US</SubElm>
						</Elm>
					</NAD>
					<!-- Standard for ADR segments -->
					<xsl:variable name="Adr" select="$Participant"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:DistrictName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm/>
							<Elm>
								<SubElm>US</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr//m:StreetName"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr/m:SuburbName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:DistrictName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>2</SubElm>
						</Elm>
					</SEQ>
				</S01>
				<!-- CCReceiver -->
				<xsl:if test="count($CCReceiver)=1">
					<S01>
						<xsl:variable name="Participant" select="$CCReceiver"/>
						<Elm>
							<SubElm>01</SubElm>
						</Elm>
						<NAD>
							<Elm>
								<SubElm>CCR</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Participant/m:Identifier"/>
								</SubElm>
								<xsl:for-each select="$Participant/m:IdentifierCode">
									<xsl:call-template name="RPTIdentifierCode"/>
								</xsl:for-each>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Participant/m:OrganisationName"/>
									<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Participant/m:DepartmentName"/>
									<xsl:if test="count($Participant/m:DepartmentName)=0 and count($Participant/m:UnitName)>0">_</xsl:if>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Participant/m:UnitName"/>
								</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm>US</SubElm>
							</Elm>
						</NAD>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>3</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				<xsl:if test="count($RPhysician)=1">
					<S01>
						<xsl:variable name="Participant" select="$RPhysician"/>
						<Elm>
							<SubElm>01</SubElm>
						</Elm>
						<NAD>
							<Elm>
								<SubElm>BV</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Participant/m:PersonInitials"/>
								</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>US</SubElm>
							</Elm>
						</NAD>
						<RFF>
							<Elm>
								<SubElm>AHL</SubElm>
								<SubElm>2</SubElm>
							</Elm>
						</RFF>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="3+count($CCReceiver)"/>
								</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				<S02>
					<Elm>
						<SubElm>02</SubElm>
					</Elm>
					<GIS>
						<Elm>
							<SubElm>N</SubElm>
						</Elm>
					</GIS>
					<RFF>
						<Elm>
							<SubElm>SRI</SubElm>
							<SubElm>
								<xsl:value-of select="$GeneralResultInformation/m:LaboratoryInternalProductionIdentifier"/>
							</SubElm>
						</Elm>
					</RFF>
					<STS>
						<Elm/>
						<Elm>
							<SubElm>K</SubElm>
						</Elm>
					</STS>
					<DTM>
						<Elm>
							<SubElm>ISR</SubElm>
							<SubElm>
								<xsl:call-template name="DateTimeToDTM203">
									<xsl:with-param name="DT" select="$GeneralResultInformation/m:ResultsDateTime"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
					<xsl:variable name="ReqComs" select="$ReqInfo/m:Comments"/>
					<xsl:variable name="Refs" select="$ReqInfo/m:Reference"/>
					<xsl:if test="count($ReqComs)=1 or count($Refs)>0">
							<xsl:if test="count($ReqComs)=1">
								<XFTX maxOccurs="11">
								<Elm>
									<SubElm>SPC</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="$ReqInfo/m:Comments/text()|$ReqInfo/m:Comments/*"/>
									</SubElm>
								</Elm>
								</XFTX>
							</xsl:if>
							<xsl:if test="$Refs">
								<FTX maxOccurs="11">
							<xsl:for-each select="$Refs">
								<Elm>
									<SubElm>
										<xsl:choose>
											<xsl:when test="count(m:SUP)=1">SUP</xsl:when>
											<xsl:when test="count(m:URL)=1">URL</xsl:when>
											<xsl:when test="count(m:BIN)=1">BIN</xsl:when>
											<xsl:otherwise>
									</xsl:otherwise>
										</xsl:choose>
									</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:RefDescription"/>
										<Break/>
										<xsl:choose>
											<xsl:when test="count(m:SUP)=1"/>
											<xsl:when test="count(m:URL)=1">
												<xsl:value-of select="m:URL"/>
											</xsl:when>
											<xsl:when test="count(m:BIN)">
												<xsl:value-of select="m:BIN/m:ObjectIdentifier"/>
												<Break/>
												<xsl:for-each select="m:BIN/m:ObjectCode">
													<xsl:call-template name="ObjectCodeToValue"/>
												</xsl:for-each>
												<Break/>
												<xsl:for-each select="m:BIN/m:ObjectExtensionCode">
													<xsl:call-template name="ObjectExtensionCodeToValue"/>
												</xsl:for-each>
												<Break/>
												<xsl:value-of select="m:BIN/m:OriginalObjectSize"/>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</SubElm>
								</Elm>
							</xsl:for-each>
									</FTX>
							</xsl:if>
					</xsl:if>
				</S02>
				<S04>
					<Elm>
						<SubElm>04</SubElm>
					</Elm>
					<xsl:for-each select="$Sample/m:RequesterSampleIdentifier">
						<RFF>
							<Elm>
								<SubElm>ROI</SubElm>
								<SubElm>
									<xsl:value-of select="."/>
								</SubElm>
							</Elm>
						</RFF>
					</xsl:for-each>
					<RFF>
						<Elm>
							<SubElm>SOI</SubElm>
							<SubElm>
								<xsl:value-of select="$Sample/m:LaboratoryInternalSampleIdentifier"/>
							</SubElm>
						</Elm>
					</RFF>
					<DTM>
						<Elm>
							<SubElm>4</SubElm>
							<SubElm>
								<xsl:call-template name="DateTimeToDTM203">
									<xsl:with-param name="DT" select="$ReqInfo/m:Sample/m:SamplingDateTime"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
					<!--
					<DTM>
						<Elm>
							<SubElm>8</SubElm>
							<SubElm>
								<xsl:call-template name="DateTimeToDTM203">
									<xsl:with-param name="DT" select="$ReqInfo/m:Sample/m:SampleReceivedDateTime"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>-->
				</S04>
				<S06>
					<Elm>
						<SubElm>06</SubElm>
					</Elm>
					<xsl:variable name="Person" select="$Patient"/>
				</S06>
				<S07>
					<xsl:if test="count($Patient//m:CivilRegistrationNumber)=1 and count($Patient/m:AlternativeIdentifier)=1">
						<FEJL>Patient kan ikke både have et CivilRegistrationNumber og et AlternativeIdentifier</FEJL>
					</xsl:if>
					<xsl:if test="count($Patient//m:CivilRegistrationNumber)=0 and count($Patient/m:AlternativeIdentifier)=0">
						<FEJL>Patient skal have et CivilRegistrationNumber eller et AlternativeIdentifier</FEJL>
					</xsl:if>
					<xsl:variable name="Person" select="$Patient"/>
					<Elm>
						<SubElm>07</SubElm>
					</Elm>
					<PNA>
						<Elm>
							<SubElm>PAT</SubElm>
						</Elm>
						<Elm>
							<xsl:if test="count($Patient/m:CivilRegistrationNumber)=1">
								<SubElm>
									<xsl:value-of select="$Patient/m:CivilRegistrationNumber"/>
								</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm>CPR</SubElm>
								<SubElm>IM</SubElm>
							</xsl:if>
						</Elm>
						<Elm/>
						<Elm/>
						<Elm>
							<SubElm>SU</SubElm>
							<SubElm>
								<xsl:value-of select="$Person/m:PersonSurnameName"/>
							</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:if test="count($Person/m:PersonGivenName)=1">FO</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Person/m:PersonGivenName"/>
							</SubElm>
						</Elm>
					</PNA>
					<xsl:if test="count($Patient/m:AlternativeIdentifier)=1">
						<RFF>
							<Elm>
								<SubElm>XPI</SubElm>
								<SubElm>
									<xsl:value-of select="$Patient/m:AlternativeIdentifier"/>
								</SubElm>
							</Elm>
						</RFF>
					</xsl:if>
				</S07>
				<!--
				<xsl:if test="count($ReqInfo/m:ClinicalInformation)=1">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<XFTX maxOccurs="3">
							<Elm>
								<SubElm>CID</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="$ReqInfo/m:ClinicalInformation/text()|$ReqInfo/m:ClinicalInformation/*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</S10>
				</xsl:if>-->
				<xsl:for-each select="$Sample">
					<xsl:variable name="pos" select="position()"/>
					<S16>
						<Elm>
							<SubElm>16</SubElm>
						</Elm>
						<SPC>
							<Elm>
								<SubElm>SCI</SubElm>
							</Elm>
							<Elm>
								<SubElm>ATT</SubElm>
							</Elm>
						</SPC>
						<xsl:if test="count(m:Volumen)+count(m:UnitOfVolumen)>0">
							<QTY>
								<Elm>
									<SubElm>SVO</SubElm>
									<SubElm>
										<xsl:value-of select="m:Volumen"/>
									</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:UnitOfVolumen"/>
									</SubElm>
								</Elm>
							</QTY>
						</xsl:if>
						<xsl:for-each select="m:SamplingInterval">
							<DTM>
								<Elm>
									<SubElm>SCS</SubElm>
									<SubElm>
										<xsl:call-template name="DateTimeToDTM203">
											<xsl:with-param name="DT" select="m:StartDateTime"/>
										</xsl:call-template>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
							<DTM>
								<Elm>
									<SubElm>SCE</SubElm>
									<SubElm>
										<xsl:call-template name="DateTimeToDTM203">
											<xsl:with-param name="DT" select="m:EndDateTime"/>
										</xsl:call-template>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:for-each>
					</S16>
				</xsl:for-each>
				<!--
				
				-->
				<xsl:for-each select="$Results">
					<xsl:variable name="Nr" select="position()"/>
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>
									<xsl:variable name="RSC" select="m:ResultStatusCode"/>
									<xsl:choose>
										<xsl:when test="$RSC='svar_endeligt' or $RSC='svar_midlertidigt' or $RSC='proeve_modtaget' ">N</xsl:when>
										<xsl:when test="$RSC='svar_rettet' ">M</xsl:when>
										<xsl:otherwise>
											<FEJL>ukendt ResultStatusCode: <xsl:value-of select="$RSC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
									<!--
									<xsl:variable name="RSC" select="m:ResultServiceCode"/>
									<xsl:choose>
										<xsl:when test="$RSC='nyt' ">N</xsl:when>
										<xsl:when test="$RSC='rettet' ">M</xsl:when>
										<xsl:otherwise>
											<FEJL>ukendt ResultServiceCode: <xsl:value-of select="$RSC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>-->
								</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>MQ</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:Analysis/m:AnalysisCode"/>
								</SubElm>
								<SubElm>
									<xsl:variable name="ACT" select="m:Analysis/m:AnalysisCodeType"/>
									<xsl:choose>
										<xsl:when test="$ACT='iupac'">CQU</xsl:when>
										<xsl:when test="$ACT='lokal'">91</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt AnalysisCodeType: <xsl:value-of select="$ACT"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:value-of select="m:Analysis/m:AnalysisCodeResponsible"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="m:Analysis/m:AnalysisShortName"/>
								</SubElm>
							</Elm>
						</INV>
						<RSL>
							<Elm>
								<SubElm>
									<xsl:variable name="RT" select="m:ResultType"/>
									<xsl:choose>
										<xsl:when test="$RT='numerisk'">NV</xsl:when>
										<xsl:when test="$RT='alfanumerisk'">AV</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt ResultType: <xsl:value-of select="$RT"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:Value"/>
								</SubElm>
								<SubElm>
									<xsl:if test="count(m:Operator)>0">
										<xsl:variable name="O" select="m:Operator"/>
										<xsl:choose>
											<xsl:when test="$O='mindre_end'">7</xsl:when>
											<xsl:when test="$O='stoerre_end'">6</xsl:when>
											<xsl:otherwise>
												<FEJL>Ukendt Operator: <xsl:value-of select="$O"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Unit"/>
								</SubElm>
							</Elm>
							<xsl:if test="count(m:ResultValidation)>0">
								<Elm>
									<SubElm>
										<xsl:variable name="RV" select="m:ResultValidation"/>
										<xsl:choose>
											<xsl:when test="$RV='for_hoej'">HI</xsl:when>
											<xsl:when test="$RV='for_lav'">LO</xsl:when>
											<xsl:when test="$RV='unormal'">UN</xsl:when>
											<xsl:otherwise>
												<FEJL>Ukendt ResultValidation: <xsl:value-of select="$RV"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</SubElm>
								</Elm>
							</xsl:if>
						</RSL>
						<STS>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:variable name="RSC" select="m:ResultStatusCode"/>
									<xsl:choose>
										<xsl:when test="$RSC='svar_endeligt' or $RSC='svar_rettet' ">FR</xsl:when>
										<xsl:when test="$RSC='proeve_modtaget' or $RSC='svar_midlertidigt' ">PR</xsl:when>
										<!--	<xsl:when test="$RSC='MR' ">modificeret</xsl:when>-->
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte ResultsStatusCode: <xsl:value-of select="$RSC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
									<!--
									<xsl:variable name="RSC" select="m:ResultStatusCode"/>
									<xsl:choose>
										<xsl:when test="$RSC='endeligt' ">FR</xsl:when>
										<xsl:when test="$RSC='foreloebigt' ">PR</xsl:when>
										<xsl:otherwise>
											<FEJL>ukendt ResultStatusCode: <xsl:value-of select="$RSC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>-->
								</SubElm>
							</Elm>
						</STS>
						<xsl:for-each select="m:Analysis/m:AnalysisCompleteName">
							<XFTX>
								<Elm>
									<SubElm>ACM</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="text()|*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:for-each>
						<xsl:if test="count(m:ResultTextValue|m:ResultComments)>0">
							<XFTX maxOccurs="20">
								<xsl:for-each select="m:ResultTextValue|m:ResultComments">
									<Elm>
										<SubElm>
											<xsl:if test="name()='ResultTextValue'">RIT</xsl:if>
											<xsl:if test="name()='ResultComments'">SPC</xsl:if></SubElm>
									</Elm>
									<Elm/>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:copy-of select="text()|*"/>
										</SubElm>
									</Elm>
								</xsl:for-each>
							</XFTX>
						</xsl:if>
						<xsl:variable name="Refs" select="m:Reference"/>
						<xsl:if test="count($Refs)>0">
						<XFTX maxOccurs="10">
								<xsl:for-each select="$Refs">
									<Elm>
										<SubElm>
											<xsl:choose>
												<xsl:when test="count(m:SUP)=1">SUP</xsl:when>
												<xsl:when test="count(m:URL)=1">URL</xsl:when>
												<xsl:when test="count(m:BIN)=1">BIN</xsl:when>
												<xsl:otherwise>
									</xsl:otherwise>
											</xsl:choose>
										</SubElm>
									</Elm>
									<Elm>
										<SubElm>P00</SubElm>
									</Elm>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:RefDescription"/>
											<Break/>
											<xsl:choose>
												<xsl:when test="count(m:SUP)=1"/>
												<xsl:when test="count(m:URL)=1">
													<xsl:value-of select="m:URL"/>
												</xsl:when>
												<xsl:when test="count(m:BIN)">
													<xsl:value-of select="m:BIN/m:ObjectIdentifier"/>
													<Break/>
													<xsl:for-each select="m:BIN/m:ObjectCode">
														<xsl:call-template name="ObjectCodeToValue"/>
													</xsl:for-each>
													<Break/>
													<xsl:for-each select="m:BIN/m:ObjectExtensionCode">
														<xsl:call-template name="ObjectExtensionCodeToValue"/>
													</xsl:for-each>
													<Break/>
													<xsl:value-of select="m:BIN/m:OriginalObjectSize"/>
												</xsl:when>
												<xsl:otherwise/>
											</xsl:choose>
										</SubElm>
									</Elm>
								</xsl:for-each>
							</XFTX>
						</xsl:if>
					       <xsl:if test="m:ProducerOfLabResult">
					         <REL>
					           <Elm>
					             <SubElm>PRF</SubElm>
					           </Elm>
					           <Elm>
					             <SubElm>POR</SubElm>
					             <SubElm>91</SubElm>
					             <SubElm><xsl:value-of select="m:ProducerOfLabResult/m:IdentifierCode"/></SubElm>
					             <SubElm><xsl:value-of select="m:ProducerOfLabResult/m:Identifier"/></SubElm>
					           </Elm>
					         </REL>
					       </xsl:if>
						<xsl:for-each select="m:ReferenceInterval">
							<S20>
								<Elm>
									<SubElm>20</SubElm>
								</Elm>
								<xsl:if test="count(m:LowerLimit)+count(m:UpperLimit)>0">
									<RND>
										<Elm>
											<SubElm>
											<xsl:variable name="TOF" select="m:TypeOfInterval"/>
											<xsl:choose>
											<xsl:when test="$TOF='fysiologisk'">F</xsl:when>
											<xsl:when test="$TOF='terapeutisk' ">T</xsl:when>
											<xsl:when test="$TOF='uspecificeret'">U</xsl:when>
											<xsl:otherwise>
												<FEJL>Ukendt TypeOfInterval: <xsl:value-of select="$TOF"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose></SubElm>
										</Elm>
										<Elm>
											<SubElm>
												<xsl:value-of select="m:LowerLimit"/>
											</SubElm>
										</Elm>
										<Elm>
											<SubElm>
												<xsl:value-of select="m:UpperLimit"/>
											</SubElm>
										</Elm>
									</RND>
								</xsl:if>
								<xsl:if test="count(m:IntervalText)>0">
									<FTX>
										<Elm>
											<SubElm>UCI</SubElm>
										</Elm>
										<Elm>
											<SubElm>F00</SubElm>
										</Elm>
										<Elm/>
										<Elm>
											<SubElm>
												<xsl:value-of select="m:IntervalText"/>
											</SubElm>
										</Elm>
									</FTX>
								</xsl:if>
							</S20>
						</xsl:for-each>
					</S18>
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
	
	<xsl:template name="RPTIdentifierCode">
		<xsl:param name="Participant" select=".."/>
		<xsl:for-each select="$Participant/m:IdentifierCode">
			<SubElm>
				<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
				<xsl:choose>
					<xsl:when test="$IC='sygehusafdelingsnummer' ">SKS</xsl:when>
					<xsl:when test="$IC='ydernummer' ">YNR</xsl:when>
					<xsl:when test="$IC='lokationsnummer' "></xsl:when>
					<xsl:when test="count($IC)=0"/>
					<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SOR</xsl:when>
			 <xsl:otherwise>
						<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
						</FEJL>
					</xsl:otherwise>
				</xsl:choose>
			</SubElm>
			<SubElm>
				<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
				<xsl:choose>
					<xsl:when test="$IC='sygehusafdelingsnummer' ">SST</xsl:when>
					<xsl:when test="$IC='ydernummer' ">SFU</xsl:when>
					<xsl:when test="$IC='lokationsnummer' ">9</xsl:when>
					<xsl:when test="count($IC)=0">9</xsl:when>
					<xsl:when test="$IC='kommunenummer' ">IM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SST</xsl:when>
			 <xsl:otherwise>
						<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
						</FEJL>
					</xsl:otherwise>
				</xsl:choose>
			</SubElm>
		</xsl:for-each>
		<xsl:for-each select="$Participant/m:IdentifierLocal">
			<SubElm>
				91
			</SubElm>
			<SubElm>
				<xsl:value-of select="."/>
			</SubElm>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
