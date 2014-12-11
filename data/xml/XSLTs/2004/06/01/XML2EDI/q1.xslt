<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2004/06/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- DISCHARGELETTER -->
	<xsl:template match="m:LaboratoryRequest">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Physician" select="$Sender/m:Physician"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="CCReceiver" select="m:CCReceiver"/>
		<xsl:variable name="Payer" select="m:Payer"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="ReqInfo" select="m:RequisitionInformation"/>
		<xsl:variable name="Requests" select="m:Requests"/>
		<xsl:variable name="ReqAnas" select="$Requests/m:RequestedAnalysis"/>
		<xsl:variable name="Prompts" select="$Requests/m:Prompt"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>MEDREQ</SubElm>
					<SubElm>D</SubElm>
					<SubElm>93A</SubElm>
					<SubElm>UN</SubElm>
					<SubElm>Q0130K</SubElm>
				</Elm>
				<Elm>
					<SubElm>REQ01</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>LRE</SubElm>
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
									<xsl:when test="count($IC)=0 "/>
									<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
									<xsl:when test="$IC='sorkode'">SOR</xsl:when>
									<xsl:otherwise>
										<FEJL>1-Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
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
										<FEJL>2-Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
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
								<xsl:if test="count($Participant/m:DepartmentName)=0">_</xsl:if>
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
						<COM>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Participant/m:TelephoneSubscriberIdentifier"/>
								</SubElm>
								<SubElm>WTE</SubElm>
							</Elm>
						</COM>
					</xsl:if>
					<SEQ>
						<Elm>
							</Elm>
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
							<SubElm>REQ01</SubElm>
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
									<xsl:when test="$IC='lokationsnummer' ">EAN</xsl:when>
									<xsl:when test="count($IC)=0"/>
									<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
									<xsl:when test="$IC='sorkode'">SOR</xsl:when>
									<xsl:otherwise>
										<FEJL>3-Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
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
										<FEJL>4-Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
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
											<FEJL>5-Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
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
											<FEJL>6-Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
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
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>3</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				<xsl:if test="count($Physician)>0">
					<S01>
						<xsl:variable name="Participant" select="$Physician"/>
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
									<xsl:if test="count($Participant/m:PersonInitials)=0">_</xsl:if>
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
								<SubElm>1</SubElm>
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
				<xsl:if test="count($Payer)>0">
					<S01>
						<xsl:variable name="Participant" select="$Payer"/>
						<Elm>
							<SubElm>01</SubElm>
						</Elm>
						<NAD>
							<Elm>
								<SubElm>PAY</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Participant/m:Identifier"/>
								</SubElm>
								<SubElm>
									<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
									<xsl:choose>
										<xsl:when test="count($IC)=0"/>
										<xsl:when test="$IC='amt' ">AMT</xsl:when>
										<xsl:otherwise>
											<FEJL>7-Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:if test="count($Participant/m:Identifier)>0">IM</xsl:if>
								</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
									<xsl:value-of select="$Participant/m:OrganisationName"/>
								</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>US</SubElm>
							</Elm>
						</NAD>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="3+count($CCReceiver)+count($Physician)"/>
								</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				<S02>
					<Elm>
						<SubElm>02</SubElm>
					</Elm>
					<xsl:for-each select="$Payer">
						<FCA>
							<Elm>
								<SubElm>
									<xsl:variable name="PTC" select="m:PayersTypeCode"/>
									<xsl:choose>
										<xsl:when test="$PTC='anden'">NSP</xsl:when>
										<xsl:when test="$PTC='sygesikring_gruppe_1'">PPI</xsl:when>
										<xsl:when test="$PTC=''">sygesikring_gruppe_2</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt PayersTypeCode: <xsl:value-of select="$PTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</FCA>
					</xsl:for-each>
					<GIS>
						<Elm>
							<SubElm>N</SubElm>
						</Elm>
					</GIS>
					<RFF>
						<Elm>
							<SubElm>ROI</SubElm>
							<SubElm>
								<xsl:value-of select="$ReqInfo/m:Sample/m:RequesterSampleIdentifier"/>
							</SubElm>
						</Elm>
					</RFF>
					<DTM>
						<Elm>
							<SubElm>4</SubElm>
							<SubElm>
								<xsl:call-template name="DateTimeToDTM203">
									<xsl:with-param name="DT" select="$ReqInfo/m:SamplingDateTime"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
					<xsl:for-each select="$ReqInfo/m:Comments">
						<XFTX>
							<Elm>
								<SubElm>RRO</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="text()|*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</xsl:for-each>
					<PAC>
						<Elm>
							<SubElm>
								<xsl:value-of select="$ReqInfo/m:NumberOfTestTubes"/>
							</SubElm>
						</Elm>
					</PAC>
				</S02>
				<xsl:for-each select="$Patient">
					<xsl:variable name="Participant" select="."/>
					<S05>
						<Elm>
							<SubElm>05</SubElm>
						</Elm>
						<xsl:variable name="Adr" select="$Participant"/>
						<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:DistrictName)+count($Adr/m:PostCodeIdentifier)>0">
							<ADR>
								<Elm>
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
					</S05>
					<S06>
						<Elm>
							<SubElm>06</SubElm>
						</Elm>
						<xsl:if test="count($Patient//m:CivilRegistrationNumber)=1 and count($Patient/m:AlternativeIdentifier)=1">
							<FEJL>Patient kan ikke både have et CivilRegistrationNumber og et AlternativeIdentifier</FEJL>
						</xsl:if>
						<xsl:if test="count($Patient//m:CivilRegistrationNumber)=0 and count($Patient/m:AlternativeIdentifier)=0">
							<FEJL>Patient skal have et CivilRegistrationNumber eller et AlternativeIdentifier</FEJL>
						</xsl:if>
						<xsl:variable name="Person" select="."/>
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
						<xsl:if test="(count(m:Consent)=1) and (m:Consent/m:Given='false') ">
							<HAN>
								<Elm>
									<SubElm>CDS</SubElm>
								</Elm>
							</HAN>
						</xsl:if>
					</S06>
				</xsl:for-each>
				<S09>
					<Elm>
						<SubElm>09</SubElm>
					</Elm>
					<xsl:for-each select="$ReqInfo/m:ClinicalInformation">
						<XFTX>
							<Elm>
								<SubElm>CO</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="text()|*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</xsl:for-each>
				</S09>
				<xsl:for-each select="$Prompts">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Question"/>
								</SubElm>
							</Elm>
						</INV>
						<xsl:for-each select="m:Answer">
							<xsl:for-each select="m:Text">
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
											<xsl:value-of select="."/>
										</SubElm>
									</Elm>
								</RSL>
							</xsl:for-each>
							<xsl:for-each select="m:Numerical">
								<RSL>
									<Elm>
										<SubElm>NV</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:Value"/>
										</SubElm>
									</Elm>
									<Elm>
										<SubElm/>
										<SubElm/>
										<SubElm/>
										<SubElm>
											<xsl:value-of select="m:Unit"/>
										</SubElm>
									</Elm>
								</RSL>
							</xsl:for-each>
							<xsl:for-each select="m:DiagnoseCode">
								<RSL>
									<Elm>
										<SubElm>CV</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="."/>
										</SubElm>
										<SubElm>SKS</SubElm>
										<SubElm>SST</SubElm>
									</Elm>
								</RSL>
							</xsl:for-each>
							<xsl:for-each select="m:DateTime">
								<DTM>
									<Elm>
										<SubElm>CDV</SubElm>
										<SubElm>
											<xsl:call-template name="DateTimeToDTM203"/>
										</SubElm>
										<SubElm>203</SubElm>
									</Elm>
								</DTM>
							</xsl:for-each>
						</xsl:for-each>
					</S10>
				</xsl:for-each>
				<S15>
					<Elm>
						<SubElm>15</SubElm>
					</Elm>
					<SPC>
						<Elm>
							<SubElm>SCI</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:variable name="SLC" select="$ReqInfo/m:SamplingLocationCode"/>
								<xsl:choose>
									<xsl:when test="$SLC='rekvirenten'">ATT</xsl:when>
									<xsl:when test="$SLC='laboratoriet'">SPR</xsl:when>
									<xsl:when test="$SLC='patienten'">PAT</xsl:when>
									<xsl:otherwise>
										<FEJL>Ukendt SamplingLocationCode: <xsl:value-of select="$SLC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
					</SPC>
					<RFF>
						<Elm>
							<SubElm>RTI</SubElm>
							<SubElm>
								<xsl:value-of select="$ReqInfo/m:Sample/m:RequesterSampleIdentifier"/>
							</SubElm>
						</Elm>
					</RFF>
					<xsl:for-each select="$ReqInfo/m:SamplingDateTime">
						<DTM>
							<Elm>
								<SubElm>
									<xsl:variable name="SLC" select="$ReqInfo/m:SamplingLocationCode"/>
									<xsl:choose>
										<xsl:when test="$SLC='rekvirenten'">SCO</xsl:when>
										<xsl:when test="$SLC='laboratoriet'">RCS</xsl:when>
										<xsl:when test="$SLC='patienten'">RCS</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt SamplingLocationCode: <xsl:value-of select="$SLC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:call-template name="DateTimeToDTM203"/>
								</SubElm>
								<SubElm>203</SubElm>
							</Elm>
						</DTM>
					</xsl:for-each>
					<xsl:variable name="Refs" select="$ReqInfo/m:Sample/m:Reference"/>
					<xsl:if test="count($Refs)>0">
						<XFTX maxOccurs="9">
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
												<xsl:for-each select="m:BIN/m:ObjectCode"><xsl:call-template name="ObjectCodeToValue"/></xsl:for-each>
												<Break/>
												<xsl:for-each select="m:BIN/m:ObjectExtensionCode">
													<xsl:call-template name="ObjectExtensionCodeToValue"/>
												</xsl:for-each>
												<Break/>
												<xsl:value-of select="m:BIN/m:OriginalObjectSize"/>
											</xsl:when>
											<xsl:otherwise></xsl:otherwise>
										</xsl:choose>
									</SubElm>
								</Elm>
							</xsl:for-each>
						</XFTX>
					</xsl:if>				
				</S15>
				<xsl:for-each select="$ReqAnas">
					<S17 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<PTY>
							<Elm>
								<SubElm>REP</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="P" select="m:ResultPriority"/>
									<xsl:choose>
										<xsl:when test="$P='straks'">CI</xsl:when>
										<xsl:when test="$P='fremskyndet'">HI</xsl:when>
										<xsl:when test="$P='rutine'">NO</xsl:when>
									       <!--<xsl:when test="$P='telefonsvar'">PH</xsl:when>-->
										<xsl:otherwise>
											<FEJL>Ukendt ResultPriority: <xsl:value-of select="$P"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</PTY>
						<xsl:for-each select="m:Analysis">
							<INV>
								<Elm>
									<SubElm>MQ</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:AnalysisCode"/>
									</SubElm>
									<SubElm>
										<xsl:variable name="ACT" select="m:AnalysisCodeType"/>
										<xsl:choose>
											<xsl:when test="$ACT='iupac' ">CQU</xsl:when>
											<xsl:when test="$ACT='lokal' ">91</xsl:when>
											<xsl:otherwise>
												<FEJL>Ukendt  AnalysisCodeType: <xsl:value-of select="$ACT"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</SubElm>
									<SubElm>
										<xsl:value-of select="m:AnalysisCodeResponsible"/>
									</SubElm>
								</Elm>
							</INV>
						</xsl:for-each>
					</S17>
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
