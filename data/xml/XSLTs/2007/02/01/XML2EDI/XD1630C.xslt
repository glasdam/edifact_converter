<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="m:ReportOfAdmission">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="SignedBy" select="$Sender/m:SignedBy"/>
		<xsl:variable name="ContactInformation" select="$Sender/m:ContactInformation"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="CCReceiver" select="m:CCReceiver"/>
		<xsl:variable name="Practitioner" select="m:Practitioner"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="Relatives" select="m:Relatives"/>
		<xsl:variable name="Relative" select="$Relatives/m:Relative"/>
		<xsl:variable name="Auxiliaries" select="m:Auxiliaries"/>
		<xsl:variable name="Auxiliary" select="$Auxiliaries/m:Auxiliary"/>
		<xsl:variable name="Services" select="m:Services"/>
		<xsl:variable name="Service" select="$Services/m:Service"/>
		<xsl:variable name="Medicine" select="m:Medicine"/>
		<xsl:variable name="Drug" select="$Medicine/m:Drug"/>
		<xsl:variable name="MotionEvaluation" select="m:MotionEvaluation"/>
		<xsl:variable name="PatientHealthSummary" select="m:PatientHealthSummary"/>
		<xsl:variable name="CauseOfAdmission" select="m:CauseOfAdmission"/>
		<xsl:variable name="InformedRelative" select="m:InformedRelative"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>MEDDIS</SubElm>
					<SubElm>D</SubElm>
					<SubElm>93A</SubElm>
					<SubElm>UN</SubElm>
					<SubElm>D1630C</SubElm>
				</Elm>
				<Elm>
					<SubElm>DIS16</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>EPI</SubElm>
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
							<SubElm>SSP</SubElm>
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
									<xsl:when test="$IC='lokationsnummer' ">EAN</xsl:when>
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
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:DepartmentName"/>
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
					<xsl:if test="count($Participant/m:TelephoneSubscriberIdentifier)=1">
						<CON>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Participant/m:TelephoneSubscriberIdentifier"/>
								</SubElm>
								<SubElm>TE</SubElm>
							</Elm>
						</CON>
					</xsl:if>
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
							<!-- JPO: er kode og kodeorg hardcoded? -->
							<SubElm>SKS</SubElm>
							<SubElm>SST</SubElm>
						</Elm>
						<Elm>
							<SubElm>DIS16</SubElm>
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
									<xsl:when test="$IC='lokationsnummer' ">EAN</xsl:when>
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
								<xsl:if test="count($Participant/m:OrganisationName)=1">
									<xsl:value-of select="$Participant/m:OrganisationName"/>
								</xsl:if>
								<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:DepartmentName"/>
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
										<xsl:when test="$IC='lokationsnummer' ">EAN</xsl:when>
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
									<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
									<xsl:value-of select="$Participant/m:OrganisationName"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Participant/m:DepartmentName"/>
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
								<SubElm>3</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				<!-- Practitioner -->
				<xsl:if test="count($Practitioner)=1">
					<S01>
						<Elm>
							<SubElm>01</SubElm>
						</Elm>
						<NAD>
							<Elm>
								<SubElm>UGP</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Practitioner/m:Identifier"/>
								</SubElm>
								<SubElm>YNR</SubElm>
								<SubElm>SFU</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Practitioner/m:PersonName"/>
								</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>US</SubElm>
							</Elm>
						</NAD>
						<CON>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Practitioner/m:TelephoneSubscriberIdentifier"/>
								</SubElm>
								<SubElm>TE</SubElm>
							</Elm>
						</CON>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:if test="count($CCReceiver)=0">3</xsl:if>
									<xsl:if test="count($CCReceiver)=1">4</xsl:if>
								</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				<!-- Signedby -->
				<S01>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>OMI</SubElm>
						</Elm>
						<Elm/>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:value-of select="$SignedBy/m:PersonGivenName"/>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$SignedBy/m:PersonSurnameName"/>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$SignedBy/m:PersonTitle"/>
							</SubElm>
							<SubElm/>
							<SubElm/>
							<SubElm>US</SubElm>
						</Elm>
					</NAD>
					<RFF>
						<Elm>
							<SubElm>AHL</SubElm>
							<SubElm>1</SubElm>
						</Elm>
					</RFF>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:if test="count($CCReceiver)=0">4</xsl:if>
								<xsl:if test="count($CCReceiver)=1">5</xsl:if>
							</SubElm>
						</Elm>
					</SEQ>
				</S01>				
				<!-- ContactInformation -->								
				<xsl:if test="count($ContactInformation)>=1">
					<xsl:for-each select="$ContactInformation">
						<S01>
							<xsl:variable name="Participant" select="$ContactInformation"/>
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
										<xsl:value-of select="$Participant/m:ContactNamePrimary"/>
									</SubElm>
									<SubElm>
										<xsl:value-of select="$Participant/m:ContactNameSecondary"/>
									</SubElm>
									<SubElm/>
									<SubElm/>
									<SubElm/>
									<SubElm>US</SubElm>
								</Elm>
							</NAD>
							<xsl:if test="$Participant/m:TelephoneSubscriberIdentifier!=''">
								<CON>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="$Participant/m:TelephoneSubscriberIdentifier"/>
										</SubElm>
										<SubElm>TE</SubElm>
									</Elm>
								</CON>
							</xsl:if>
							<xsl:if test="$Participant/m:TelefaxSubscriberIdentifier!=''">
								<CON>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="$Participant/m:TelefaxSubscriberIdentifier"/>
										</SubElm>
										<SubElm>FX</SubElm>
									</Elm>
								</CON>
							</xsl:if>
							<xsl:if test="$Participant/m:EmailAddressIdentifier!=''">
								<CON>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="$Participant/m:EmailAddressIdentifier"/>
										</SubElm>
										<SubElm>EM</SubElm>
									</Elm>
								</CON>
							</xsl:if>
							<RFF>
								<Elm>
									<SubElm>AHL</SubElm>
									<SubElm>1</SubElm>
								</Elm>
							</RFF>
							<RFF>											
								<xsl:if test="$Participant/m:ContactTimeText!=''">
									<Elm>
										<SubElm>BUH</SubElm>
										<SubElm>
											<xsl:value-of select="$Participant/m:ContactTimeText"/>
										</SubElm>
									</Elm>
								</xsl:if>
							</RFF>
							<SEQ>
								<Elm/>
								<Elm>
									<SubElm>
										<!-- der er muligvis fejl i udtrykket -->
										<!--xsl:number value="count(preceding:://m:Sender/m:ContactInformation) + 5 + count($CCReceiver)" format="1" /-->
										<xsl:number value="count(preceding::m:Sender/m:ContactInformation) + 5 + count($CCReceiver)" format="1" />
									</SubElm>
								</Elm>
							</SEQ>
						</S01>
					</xsl:for-each>
				</xsl:if>
				<!-- Letter id -->
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
								<xsl:value-of select="$Letter/m:Identifier"/>
							</SubElm>
						</Elm>
					</RFF>
					<DTM>
						<Elm>
							<SubElm>182</SubElm>
							<SubElm>
								<xsl:call-template name="DateTimeToDTM203">
									<xsl:with-param name="DT" select="$Letter/m:Authorisation"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
				</S02>
				<!-- Patient -->
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
							<xsl:if test="count($Person/m:PersonGivenName)=1">
								<SubElm>FO</SubElm>
								<SubElm>
									<xsl:value-of select="$Person/m:PersonGivenName"/>
								</SubElm>
							</xsl:if>
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
					<!-- Standard for ADR segments -->
					<xsl:variable name="Adr" select="$Patient"/>
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
					<xsl:if test="count($Patient/m:OccupancyText)=1">
						<EMP>
							<Elm>
								<SubElm>1</SubElm>
							</Elm>
							<Elm/>							
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="$Patient/m:OccupancyText"/>
								</SubElm>
							</Elm>
						</EMP>
					</xsl:if>
				</S07>
				<!-- Relatives -->
				<xsl:for-each select="$Relative">
					<S09>
						<xsl:variable name="Person" select="."/>
						<Elm>
							<SubElm>09</SubElm>
						</Elm>
						<REL>
							<Elm>
								<SubElm>PER</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="RC" select="m:RelationCode"/>
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
						<PNA>
							<Elm>
								<SubElm>PAS</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:PersonIdentifier"/>
								</SubElm>
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
						<!-- Standard for ADR segments -->
						<xsl:variable name="Adr" select="$Person"/>
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
						<xsl:for-each select="$Relative/m:TelephoneSubscriber">
							<xsl:variable name="TelephoneSubscriber" select="current()"/>
							<CON>
								<Elm>
									<SubElm>
										<xsl:value-of select="$TelephoneSubscriber/m:TelephoneType"/>		
									</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="$TelephoneSubscriber/m:TelephoneNumber"/>		
									</SubElm>
									<SubElm>TE</SubElm>
								</Elm>
							</CON>
						</xsl:for-each>
					</S09>
				</xsl:for-each>
				<!-- Forloebs nr. -->
				<S11>
					<Elm>
						<SubElm>11</SubElm>
					</Elm>
					<GIS>
						<Elm>
							<SubElm>N</SubElm>
						</Elm>
					</GIS>
					<xsl:if test="count($Letter/m:EpisodeOfCareIdentifier)=1">
						<RFF>
							<Elm>
								<SubElm>REI</SubElm>
								<SubElm>
									<xsl:value-of select="$Letter/m:EpisodeOfCareIdentifier"/>
								</SubElm>
							</Elm>
						</RFF>
					</xsl:if>
					<xsl:if test="count($Letter/m:EpisodeOfCareIdentifier)=0">
						<RFF>
							<Elm>
								<SubElm>AHI</SubElm>
								<SubElm>1</SubElm>
							</Elm>
						</RFF>
					</xsl:if>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>1</SubElm>
						</Elm>
					</SEQ>
					<PAS>
						<Elm>
							<SubElm>POT</SubElm>
						</Elm>
					</PAS>
				</S11>
				<!-- Hjaelpemidler -->
				<xsl:if test="count($Auxiliaries)>0">
					<S14>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<xsl:if test="count($Auxiliary)>0">
							<xsl:for-each select="$Auxiliary">
								<CIN>
									<Elm>
										<SubElm>NC</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="$Auxiliary/m:AuxiliaryCode"/>
										</SubElm>
										<SubElm>
											<xsl:value-of select="$Auxiliary/m:Identifier"/>
										</SubElm>
										<SubElm>
											<xsl:value-of select="$Auxiliary/m:IdentifierCode"/>
										</SubElm>
										<SubElm>
											<xsl:value-of select="$Auxiliary/m:AuxiliaryText"/>
										</SubElm>
									</Elm>
								</CIN>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="count($Auxiliaries/m:Comment)>0">
							<XFTX maxOccurs="5">
								<Elm>
									<SubElm>HK</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="$Auxiliaries/m:Comment/text()|$Auxiliaries/m:Comment/*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:if>
					</S14>
				</xsl:if>
				<!-- Ydelser -->
				<xsl:if test="count($Services)>0">
					<S14>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<xsl:if test="count($Services/m:Comment)>0">
							<XFTX maxOccurs="5">
								<Elm>
									<SubElm>YK</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="$Services/m:Comment/text()|$Services/m:Comment/*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:if>
						<xsl:if test="count($Service)>0">
							<xsl:for-each select="$Service">
								<XFTX maxOccurs="28">
									<Elm>
										<SubElm><xsl:number value="position()" format="001" /></SubElm>
									</Elm>
									<Elm>
										<SubElm>P00</SubElm>
									</Elm>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:ServiceHeadline"/>
											<Break/>
											<xsl:copy-of select="m:ServiceText/text()|m:ServiceText/*"/>
										</SubElm>
									</Elm>
								</XFTX>
							</xsl:for-each>
						</xsl:if>
					</S14>
				</xsl:if>
				<!-- Medicin segment inddeling fejl -->
				<xsl:if test="count($Medicine)>0">
					<S14>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<xsl:if test="count($Medicine/m:Comment)>0">
							<XFTX maxOccurs="5">
								<Elm>
									<SubElm>MEK</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="$Medicine/m:Comment/text()|$Medicine/m:Comment/*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:if>
						<xsl:if test="count($Drug)>0">
							<xsl:for-each select="$Drug">
								<FTX>
									<Elm>
										<SubElm>MED</SubElm>
									</Elm>
									<Elm>
										<SubElm>P00</SubElm>
									</Elm>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:copy-of select="m:NameOfDrug/text()|m:NameOfDrug/*"/>
										</SubElm>
										<SubElm>										
											<xsl:copy-of select="m:DosageForm/text()|m:DosageForm/*"/>		
										</SubElm>
										<SubElm>											
											<xsl:copy-of select="m:DrugStrength/text()|m:DrugStrength/*"/>		
										</SubElm>
										<SubElm>											
											<xsl:copy-of select="m:Dosage/text()|m:Dosage/*"/>		
										</SubElm>
										<SubElm>											
											<xsl:copy-of select="m:Indication/text()|m:Indication/*"/>		
										</SubElm>
									</Elm>
								</FTX>
							</xsl:for-each>
						</xsl:if>
					</S14>
				</xsl:if>
				<!-- Funktionsvurdering -->
				<xsl:if test="count($MotionEvaluation)>0">
					<S14>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<XFTX maxOccurs="9">
							<Elm>
								<SubElm>FV</SubElm>
							</Elm>
							<Elm>
								<SubElm>P00</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="m:MotionEvaluation/text()|m:MotionEvaluation/*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</S14>
				</xsl:if>						
				<!-- Resume -->
				<xsl:if test="count($PatientHealthSummary)>0">
					<S14>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<XFTX maxOccurs="9">
							<Elm>
								<SubElm>RS</SubElm>
							</Elm>
							<Elm>
								<SubElm>P00</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="m:PatientHealthSummary/text()|m:PatientHealthSummary/*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</S14>
				</xsl:if>						
				<!-- Indlaeggelsesaarsag -->		
				<xsl:if test="count($CauseOfAdmission)>0 or count($InformedRelative)>0">
					<S14>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<xsl:if test="count($CauseOfAdmission)>0">
							<XFTX maxOccurs="1">
								<Elm>
									<SubElm>PR</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="m:CauseOfAdmission/text()|m:CauseOfAdmission/*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:if>
						<xsl:if test="count($InformedRelative)>0">
							<XFTX maxOccurs="1">
								<Elm>
									<SubElm>AP</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="m:InformedRelative/text()|m:InformedRelative/*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:if>						
					</S14>
				</xsl:if>				
			<!-- afslutning -->
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
