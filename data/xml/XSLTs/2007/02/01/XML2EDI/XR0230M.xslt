<?xml version="1.0"  encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- CERVIXCYTOLGYREPORT -->
	<xsl:template match="m:MicrobiologyReport">
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
		<xsl:variable name="LabResults" select="m:LaboratoryResults"/>
		<xsl:variable name="GeneralResultInformation" select="$LabResults/m:GeneralResultInformation"/>
		<xsl:variable name="Results" select="$LabResults/m:Result"/>
		<xsl:variable name="Samples" select="$ReqInfo/m:Sample"/>
		<xsl:variable name="Micro" select="$LabResults/m:MicroscopicFindings"/>
		<xsl:variable name="GrowthWOFindings" select="$LabResults/m:CultureWithoutFindings"/>
		<xsl:variable name="GrowthWFindings" select="$LabResults/m:CultureWithFindings"/>
		<xsl:variable name="MicroOrgs" select="$GrowthWFindings/m:Microorganism"/>
		<xsl:variable name="Pattern" select="$GrowthWFindings/m:Pattern"/>
		<xsl:variable name="Antibiotics" select="$Pattern/m:Antibiotic"/>
		<xsl:variable name="PatternEntries" select="$Pattern/m:PatternEntry"/>
<!--		<xsl:variable name="TableSEQ" select="count($Results)+count($Micro)+count($GrowthWOFindings)+count($MicroOrgs)+3"/>-->
		<xsl:variable name="TableSEQ" select="count($Results)+count($Micro)+count($GrowthWOFindings)+count($GrowthWFindings)+count($MicroOrgs)+count($GrowthWFindings/m:Comments)+1"/>

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
					<SubElm>R0230M</SubElm>
				</Elm>
				<Elm>
					<SubElm>RPT02</SubElm>
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
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SKS</xsl:when>
									<xsl:when test="$IC='ydernummer' ">YNR</xsl:when>
									<xsl:when test="$IC='lokationsnummer' "></xsl:when>
									<xsl:when test="count($IC)=0 "/>
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
									<xsl:when test="count($IC)=0 ">9</xsl:when>
									<xsl:when test="$IC='kommunenummer' ">IM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SST</xsl:when>
			 <xsl:otherwise>
										<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
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
							<SubElm>RPT02</SubElm>
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
								<SubElm>
									<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
									<xsl:choose>
										<xsl:when test="$IC='sygehusafdelingsnummer' ">SKS</xsl:when>
										<xsl:when test="$IC='ydernummer' ">YNR</xsl:when>
										<xsl:when test="$IC='lokationsnummer' "></xsl:when>
										<xsl:when test="count($IC)=0 "/>
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
										<xsl:when test="count($IC)=0 ">9</xsl:when>
										<xsl:when test="$IC='kommunenummer' ">IM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SST</xsl:when>
			 <xsl:otherwise>
											<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
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
				<!--
				<xsl:if test="count($CCRPhysician)=1">
					<S01>
						<xsl:variable name="Participant" select="$CCRPhysician"/>
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
								<SubElm>6</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				-->
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
							<SubElm>
								<xsl:variable name="RS" select="$GeneralResultInformation/m:ResultStatus"/>
								<xsl:choose>
									<xsl:when test="$RS='komplet' ">K</xsl:when>
									<xsl:when test="$RS='delvis' ">D</xsl:when>
									<xsl:when test="$RS='modtaget' ">M</xsl:when>
									<xsl:otherwise>
										<FEJL>Ukendt ResultStatus: <xsl:value-of select="$RS"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
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
					<xsl:if test="count($ReqInfo/m:Comments)=1">
						<XFTX maxOccurs="1">
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
				</S02>
				<S04>
					<Elm>
						<SubElm>04</SubElm>
					</Elm>
					<xsl:for-each select="$Samples/m:RequesterSampleIdentifier">
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
								<xsl:value-of select="$Samples/m:LaboratoryInternalSampleIdentifier"/>
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
					</DTM>
				</S04>
				<S06>
					<Elm>
						<SubElm>06</SubElm>
					</Elm>
					<xsl:variable name="Person" select="$Patient"/>
					<!--<xsl:variable name="Adr" select="$Person"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm>
								<SubElm/>
								<SubElm>PO</SubElm>
							</Elm>
							<Elm>
								<SubElm>US</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr//m:StreetName"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr/m:SuburbName"/>
								</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr//m:MunicipalityId"/>
								</SubElm>
								<SubElm>KOM</SubElm>
								<SubElm>IM</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr//m:MunicipalityName"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>-->
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
					<!--
					<xsl:if test="(count($Patient/m:Consent)=1) and ($Patient/m:Consent/m:Given='true') ">
						<HAN>
							<Elm>
								<SubElm>CDS</SubElm>
								<SubElm>SKS</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>
									<xsl:value-of select="$Patient/m:Consent/m:Text"/>
								</SubElm>
							</Elm>
						</HAN>
					</xsl:if>-->
				</S07>
				<!--
				<xsl:if test="count($Relative)=1">
					<S07>
						<xsl:variable name="Person" select="$Relative"/>
						<Elm>
							<SubElm>07</SubElm>
						</Elm>
						<PNA>
							<Elm>
								<SubElm>PER</SubElm>
							</Elm>
							<Elm>
								<xsl:if test="count($Person/m:PersonIdentifier)=1">
									<SubElm>
										<xsl:value-of select="$Person/m:PersonIdentifier"/>
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
						<REL>
							<Elm>
								<SubElm>PER</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="RC" select="$Person/m:RelationCode"/>
									<xsl:choose>
										<xsl:when test="$RC='uspec_paaroerende'">GU</xsl:when>
										<xsl:when test="$RC='mor'">MO</xsl:when>
										<xsl:when test="$RC='far'">FA</xsl:when>
										<xsl:when test="$RC='barn'">SD</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte kode for pårørende: <xsl:value-of select="$RC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</REL>
					</S07>
				</xsl:if>-->
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
				</xsl:if>
				<xsl:for-each select="$Samples">
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
								<SubElm>
									<xsl:variable name="ETC" select="m:Analysis/m:ExaminationTypeCode"/>
									<xsl:choose>
										<xsl:when test="$ETC='maalemetode' ">MM</xsl:when>
										<xsl:when test="$ETC='maaleprocedure' ">MP</xsl:when>
										<xsl:when test="$ETC='maalbar_kvantitet' ">MQ</xsl:when>
										<xsl:when test="$ETC='kvantitet' ">PR</xsl:when>
										<xsl:when test="$ETC='overskrift' ">OE</xsl:when>
										<xsl:when test="$ETC='observerbar_egenskab' ">OP</xsl:when>
										<xsl:when test="$ETC='antibiotika_sammensaetning' ">CO</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt ExaminationTypeCode: <xsl:value-of select="$ETC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:Analysis/m:MICAnalysisCode"/>
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
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Nr"/>
								</SubElm>
							</Elm>
						</SEQ>
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
											<xsl:when test="$O='mindre_end'">6</xsl:when>
											<xsl:when test="$O='stoerre_end'">7</xsl:when>
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
								  <xsl:value-of select="m:Unit/text()"/>
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
						<xsl:for-each select="m:Analysis/m:AnalysisMDSName">
							<FTX>
								<Elm>
									<SubElm>ACM</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:Examination"/>
									</SubElm>
									<SubElm>
										<xsl:value-of select="m:Material"/>
									</SubElm>
									<SubElm>
										<xsl:value-of select="m:Location"/>
									</SubElm>
								</Elm>
							</FTX>
						</xsl:for-each>
						<xsl:if test="count(m:ResultComments)>0">
							<XFTX maxOccurs="1">
								<Elm>
									<SubElm>SPC</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="m:ResultComments/text()|m:ResultComments/*"/>
									</SubElm>
								</Elm>
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
					        <SubElm><xsl:value-of select="$Results/m:ProducerOfLabResult/m:IdentifierCode"/></SubElm>
					        <SubElm><xsl:value-of select="$Results/m:ProducerOfLabResult/m:Identifier"/></SubElm>
					      </Elm>
					    </REL>
					  </xsl:if>
						<xsl:for-each select="m:ReferenceInterval">
							<S20>
								<Elm><SubElm>20</SubElm></Elm>
								<xsl:if test="count(m:LowerLimit)+count(m:UpperLimit)>0">
									<RND>
										<Elm>
											<SubElm>U</SubElm>
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
				<!--
					MICROSCOPIC
				-->
				<xsl:for-each select="$Micro">
					<!-- S18 hidden
						GIS+N'
						INV+OE+:::Microscopic' 
						SEQ++2'
						FTX++++?+?+ barylia med xxxxxx:?+bsbsbs med yyyy'
						-->
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="count($Results)+1"/>
								</SubElm>
							</Elm>
						</SEQ>
						<xsl:if test="count(m:Comments)>0">
							<XFTX maxOccurs="9">
								<Elm>
									<SubElm>RIT</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<FixedFont>
											<xsl:copy-of select="m:Comments/text()|m:Comments/*"/>
										</FixedFont>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:if>
					</S18>
				</xsl:for-each>
				<!--
					GROWTHWITHOUTFINDINGS
				-->
				<xsl:for-each select="$GrowthWOFindings">
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="count($Results)+count($Micro)+1"/>
								</SubElm>
							</Elm>
						</SEQ>
						<xsl:if test="count(m:Comments)>0">
							<XFTX maxOccurs="1">
								<Elm>
									<SubElm>RIT</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<FixedFont>
											<xsl:copy-of select="m:Comments/text()|m:Comments/*"/>
										</FixedFont>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:if>
					</S18>
				</xsl:for-each>
				<!--
					GROWTHWITHFINDINGS
				-->
				<xsl:for-each select="$GrowthWFindings">
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="count($Results)+count($Micro)+count($GrowthWOFindings)+1"/>
								</SubElm>
							</Elm>
						</SEQ>
					</S18>
				</xsl:for-each>
				<xsl:for-each select="$MicroOrgs">
					<xsl:variable name="MNr" select="position()"/>
					<!--
						GIS+N'
						INV+MQ+:::Baktnavn1'
						SEQ++Sekvnr'
						RSL+TV+:::::Vaekstgradtekst'
						FTX+SPC+F00++Multiresistent'
					-->
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>MQ</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Name"/>
								</SubElm>
							</Elm>
						</INV>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="count($Results)+count($Micro)+count($GrowthWOFindings)+$MNr+1"/>
								</SubElm>
							</Elm>
						</SEQ>
						<RSL>
							<Elm>
								<SubElm>TV</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:GrowthValue"/>
								</SubElm>
							</Elm>
						</RSL>
						<xsl:if test="count(m:SpeciesComment)>0">
							<FTX>
								<Elm>
									<SubElm>SPC</SubElm>
								</Elm>
								<Elm>
									<SubElm>F00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:SpeciesComment"/>
									</SubElm>
								</Elm>
							</FTX>
						</xsl:if>
					</S18>
				</xsl:for-each>
				<xsl:for-each select="$GrowthWFindings/m:Comments">
					<!--
						GIS+N'
						INV+NR'
						SEQ++Sekvnr'
						FTX+SPC+P00++Kommtekstfund:Kommtekstfund:Kommtekstfund:Kommtekstfund:Kommtekstfund'
						FTX+SPC+P00++Kommtekstfund:Kommtekstfund:Kommtekstfund:Kommtekstfund:Kommtekstfund'
					-->
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>NR</SubElm>
							</Elm>
						</INV>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="count($Results)+count($Micro)+count($GrowthWOFindings)+count($MicroOrgs)+2"/>
								</SubElm>
							</Elm>
						</SEQ>
						<XFTX maxOccurs="2">
							<Elm>
								<SubElm>SPC</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="text()|*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</S18>
				</xsl:for-each>
				<xsl:for-each select="$Pattern">
					<!--
						GIS+N'
						INV+OE+:::Antibiotikafølsomhed'
						SEQ++OverskriftSeqNummer1'
						RSL+SB+2'
						-->
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$TableSEQ"/>
								</SubElm>
							</Elm>
						</SEQ>
						<RSL>
							<Elm>
								<SubElm>SB</SubElm>
							</Elm>
							<Elm>
								<SubElm>2</SubElm>
							</Elm>
						</RSL>
					</S18>
				<!--FBH </xsl:for-each>-->
				
				<xsl:for-each select="$MicroOrgs">
					<xsl:variable name="MNr" select="position()"/>
					<xsl:variable name="Entries" select="$PatternEntries[m:RefMicroorganism=$MNr]"/>
					<xsl:variable name="CountEntriesInEarlierColumns" select="count($PatternEntries[m:RefMicroorganism &lt; $MNr])"/>
					<xsl:variable name="MSEQ" select="$TableSEQ+$CountEntriesInEarlierColumns+$MNr"/>
					<!--
						GIS+N'
						INV+MQ+:::Baktnavn1'
						SEQ++Bakt1Sekvensnr2'
						RFF+ARL:OverskriftSeqNummer1'
						-->
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>MQ</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Name"/>
								</SubElm>
							</Elm>
						</INV>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$MSEQ"/>
								</SubElm>
							</Elm>
						</SEQ>
						<RFF>
							<Elm>
								<SubElm>ARL</SubElm>
								<SubElm>
									<xsl:value-of select="$TableSEQ"/>
								</SubElm>
							</Elm>
						</RFF>
					</S18>
					<!-- lav kolonne og husk referencenr-->
					<xsl:for-each select="$Antibiotics">
						<xsl:variable name="ANr" select="position()"/>
						<xsl:variable name="Entry" select="$Entries[m:RefAntibiotic=$ANr]"/>
						<xsl:if test="count($Entry)>0">
							<xsl:variable name="CountEntriesEarlierInThisColumn" select="count($Entries[m:RefAntibiotic &lt; $ANr])"/>
							<xsl:variable name="ASEQ" select="$MSEQ+$CountEntriesEarlierInThisColumn+1"/>
							<!--lav et S18
									GIS+N'
									INV+CO+:::AntibiotikaNavn'
									SEQ++Sekvnr'
									RSL+AV+::Resistenskode'
									RFF+ARL:Bakt1Sekvensnr2'
								-->
							<S18 hidden="true">
								<GIS>
									<Elm>
										<SubElm>N</SubElm>
									</Elm>
								</GIS>
								<INV>
									<Elm>
										<SubElm>CO</SubElm>
									</Elm>
									<Elm>
										<SubElm/>
										<SubElm/>
										<SubElm/>
										<SubElm>
											<xsl:value-of select="m:Name"/>
										</SubElm>
									</Elm>
								</INV>
								<SEQ>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="$ASEQ"/>
										</SubElm>
									</Elm>
								</SEQ>
								<RSL>
									<Elm>
										<SubElm>AV</SubElm>
									</Elm>
									<Elm>
										<SubElm/>
										<SubElm/>
										<SubElm>
											<xsl:value-of select="$Entry/m:Sensitivity"/>
										</SubElm>
									</Elm>
								</RSL>
								<RFF>
									<Elm>
										<SubElm>ARL</SubElm>
										<SubElm>
											<xsl:value-of select="$MSEQ"/>
										</SubElm>
									</Elm>
								</RFF>
							</S18>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
				<!--FBH XXXX<xsl:for-each select="$Pattern">-->
				<!--
						GIS+N'
						INV+MM+:::Antibiotikafølsomhed'
						SEQ++Sekvnr'
						RSL+SS+SKEMASLUT'
						RFF+ARL:OverskriftSeqNummer1'
						-->
				<S18 hidden="true">
					<GIS>
						<Elm>
							<SubElm>N</SubElm>
						</Elm>
					</GIS>
					<INV>
						<Elm>
							<SubElm>MM</SubElm>
						</Elm>
						<Elm>
							<SubElm/>
							<SubElm/>
							<SubElm/>
							<SubElm>
								<xsl:value-of select="m:Headline"/>
							</SubElm>
						</Elm>
					</INV>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:value-of select="$TableSEQ+count($PatternEntries)+count($MicroOrgs)+1"/>
							</SubElm>
						</Elm>
					</SEQ>
					<RSL>
						<Elm>
							<SubElm>SS</SubElm>
						</Elm>
						<Elm>
							<SubElm>SKEMASLUT</SubElm>
						</Elm>
					</RSL>
					<RFF>
						<Elm>
							<SubElm>ARL</SubElm>
							<SubElm>
								<xsl:value-of select="$TableSEQ"/>
							</SubElm>
						</Elm>
					</RFF>
				</S18>
				</xsl:for-each>
				<!--
					GIS+N'
					INV+OE+:::Følsomhed'
					SEQ++Sekvnr'
					FTX+RIT+P00++Foelsom=a:Foelsom=b:Foelsom=c:Foelsom=d:Foelsom=e'-->
				<xsl:for-each select="$Pattern/m:SensitivityInterpretation">
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="'Følsomhed'"/>
								</SubElm>
							</Elm>
						</INV>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$TableSEQ+count($PatternEntries)+count($MicroOrgs)+2"/>
								</SubElm>
							</Elm>
						</SEQ>
						<XFTX maxOccurs="1">
							<Elm>
								<SubElm>RIT</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="text()|*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</S18>
				</xsl:for-each>
				<!--
					GIS+N'
					INV+OE+:::Kommentar'
					SEQ++Sekvnr'
					FTX+RIT+P00++Svartekst:Svartekst:Svartekst:Svartekst:Svartekst'
					FTX+RIT+P00++Svartekst:Svartekst:Svartekst:Svartekst:Svartekst'
				-->
				<xsl:for-each select="$GeneralResultInformation/m:Comment">
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="'Kommentar'"/>
								</SubElm>
							</Elm>
						</INV>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$TableSEQ+count($PatternEntries)+count($MicroOrgs)+3"/>
								</SubElm>
							</Elm>
						</SEQ>
						<XFTX maxOccurs="2">
							<Elm>
								<SubElm>RIT</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="text()|*"/>
								</SubElm>
							</Elm>
						</XFTX>
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
</xsl:stylesheet>
