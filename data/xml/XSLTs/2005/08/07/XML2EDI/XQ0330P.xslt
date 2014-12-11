<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- DISCHARGELETTER -->
	<xsl:template match="m:PathologyRequest">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Physician" select="$Sender/m:Physician"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="CCReceiver" select="m:CCReceiver"/>
		<xsl:variable name="Payer" select="m:Payer"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="Relative" select="m:Relative"/>
		<xsl:variable name="ReqInfo" select="m:RequisitionInformation"/>
		<xsl:variable name="Requests" select="m:Requests"/>
		<xsl:variable name="ReqAnas" select="$Requests/m:RequestedAnalysis"/>
		<xsl:variable name="SupCervixInfo" select="$Requests/m:SupplementaryCervixInformations"/>
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
					<SubElm>Q0330P</SubElm>
				</Elm>
				<Elm>
					<SubElm>REQ03</SubElm>
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
							<xsl:call-template name="identifierCode2edi">
								<xsl:with-param name="code" select="$Participant/m:IdentifierCode"/>
							</xsl:call-template>
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
							<SubElm>REQ03</SubElm>
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
							<xsl:call-template name="identifierCode2edi">
								<xsl:with-param name="code" select="$Participant/m:IdentifierCode"/>
							</xsl:call-template>
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
								<xsl:call-template name="identifierCode2edi">
									<xsl:with-param name="code" select="$Participant/m:IdentifierCode"/>
								</xsl:call-template>
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
								<xsl:value-of select="$ReqInfo/m:RequestersRequisitionIdentifier"/>
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
					<xsl:for-each select="$ReqAnas/m:ResultPriority">
						<PTY>
							<Elm>
								<SubElm>REP</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="P" select="."/>
									<xsl:choose>
										<xsl:when test="$P='straks'">CI</xsl:when>
										<xsl:when test="$P='fremskyndet'">HI</xsl:when>
										<xsl:when test="$P='rutine'">NO</xsl:when>
										<!--	<xsl:when test="$P='PH'">telefonsvar</xsl:when>-->
										<xsl:otherwise>
											<FEJL>Ukendt ResultPriority</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</PTY>
					</xsl:for-each>
					<xsl:for-each select="$ReqInfo/m:CodedClinicalInformation">
						<CIN>
							<Elm>
								<SubElm>RRO</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:IndicationCode"/>
								</SubElm>
								<SubElm>PA4</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>
									<xsl:value-of select="m:IndicationText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:for-each>
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
					<xsl:for-each select="$ReqInfo/m:CarbonCopyReceiver">
						<FTX>
							<Elm>
								<SubElm>KOP</SubElm>
							</Elm>
							<Elm>
								<SubElm>P00</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="."/>
								</SubElm>
							</Elm>
						</FTX>
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
						<xsl:if test="count(m:TelephoneSubscriberIdentifier)=1">
							<COM>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:TelephoneSubscriberIdentifier"/>
									</SubElm>
									<SubElm>HTE</SubElm>
								</Elm>
							</COM>
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
				<xsl:for-each select="$Relative">
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
								<SubElm>PER</SubElm>
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
						<REL>
							<Elm>
								<SubElm>PER</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="RC" select="m:RelationCode"/>
									<xsl:choose>
										<xsl:when test="$RC='vaerge'">GU</xsl:when>
										<xsl:when test="$RC='far'">FA</xsl:when>
										<xsl:when test="$RC='mor'">MO</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt RelationCode <xsl:value-of select="$RC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</REL>
					</S06>
				</xsl:for-each>
				<S09>
					<Elm>
						<SubElm>09</SubElm>
					</Elm>
					<xsl:for-each select="$ReqInfo/m:ClinicalInformation">
						<XFTX maxOccurs="3">
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
				<xsl:variable name="Kondylomer" select="$SupCervixInfo/m:Condyloma"/>
				<xsl:variable name="Spiral" select="$SupCervixInfo/m:IUD"/>
				<xsl:variable name="Gravid" select="$SupCervixInfo/m:Pregnant"/>
				<xsl:variable name="Menstruation" select="$SupCervixInfo/m:DateOfPeriod"/>
				<xsl:variable name="Hormonbeh" select="$SupCervixInfo/m:HormonTherapy"/>
				<xsl:variable name="Kryobeh" select="$SupCervixInfo/m:DateOfCryoTherapy"/>
				<xsl:variable name="Laser" select="$SupCervixInfo/m:DateOfLaser"/>
				<xsl:variable name="Konisation" select="$SupCervixInfo/m:DateOfConisation"/>
				<xsl:variable name="Hysterektomi" select="$SupCervixInfo/m:DateOfHysterectomi"/>
				<xsl:variable name="Straaleterapi" select="$SupCervixInfo/m:DateOfIrradiation"/>
				<xsl:variable name="Kemoterapi" select="$SupCervixInfo/m:DateOfChemoTherapy"/>
				<xsl:for-each select="$Kondylomer[.='true']">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP101</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Kondylomer</SubElm>
							</Elm>
						</INV>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Spiral[.='true']">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP102</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Spiral</SubElm>
							</Elm>
						</INV>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Gravid[.='true']">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP103</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Patienten er gravid</SubElm>
							</Elm>
						</INV>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Menstruation">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP201</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Menstruation</SubElm>
							</Elm>
						</INV>
						<DTM>
							<Elm>
								<SubElm>LMC</SubElm>
								<SubElm>
									<xsl:call-template name="DateToDTM102"/>
								</SubElm>
								<SubElm>102</SubElm>
							</Elm>
						</DTM>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Hormonbeh">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP202</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Hormonbehandling</SubElm>
							</Elm>
						</INV>
						<RSL>
							<Elm>
								<SubElm>AV</SubElm>
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
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Kryobeh">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP203</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Kryobehandling</SubElm>
							</Elm>
						</INV>
						<RSL>
							<Elm>
								<SubElm>CV</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm>1</SubElm>
							</Elm>
						</RSL>
						<xsl:if test=".!='0001-01-01' ">
							<DTM>
								<Elm>
									<SubElm>AIC</SubElm>
									<SubElm>
										<xsl:call-template name="DateToDTM102"/>
									</SubElm>
									<SubElm>102</SubElm>
								</Elm>
							</DTM>
						</xsl:if>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Laser">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP204</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Laser</SubElm>
							</Elm>
						</INV>
						<RSL>
							<Elm>
								<SubElm>CV</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm>1</SubElm>
							</Elm>
						</RSL>
						<xsl:if test=".!='0001-01-01' ">
							<DTM>
								<Elm>
									<SubElm>AIC</SubElm>
									<SubElm>
										<xsl:call-template name="DateToDTM102"/>
									</SubElm>
									<SubElm>102</SubElm>
								</Elm>
							</DTM>
						</xsl:if>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Konisation">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP205</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Konisation</SubElm>
							</Elm>
						</INV>
						<RSL>
							<Elm>
								<SubElm>CV</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm>1</SubElm>
							</Elm>
						</RSL>
						<DTM>
							<Elm>
								<SubElm>AIC</SubElm>
								<SubElm>
									<xsl:call-template name="DateToDTM102"/>
								</SubElm>
								<SubElm>102</SubElm>
							</Elm>
						</DTM>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Hysterektomi">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP206</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Hysterektomi</SubElm>
							</Elm>
						</INV>
						<RSL>
							<Elm>
								<SubElm>CV</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm>1</SubElm>
							</Elm>
						</RSL>
						<DTM>
							<Elm>
								<SubElm>AIC</SubElm>
								<SubElm>
									<xsl:call-template name="DateToDTM102"/>
								</SubElm>
								<SubElm>102</SubElm>
							</Elm>
						</DTM>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Straaleterapi">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP213</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Stråleterapi</SubElm>
							</Elm>
						</INV>
						<RSL>
							<Elm>
								<SubElm>CV</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm>1</SubElm>
							</Elm>
						</RSL>
						<DTM>
							<Elm>
								<SubElm>AIC</SubElm>
								<SubElm>
									<xsl:call-template name="DateToDTM102"/>
								</SubElm>
								<SubElm>102</SubElm>
							</Elm>
						</DTM>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$Kemoterapi">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<INV>
							<Elm>
								<SubElm>IN</SubElm>
							</Elm>
							<Elm>
								<SubElm>ADP214</SubElm>
								<SubElm>PA8</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>Kemoterapi</SubElm>
							</Elm>
						</INV>
						<RSL>
							<Elm>
								<SubElm>CV</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm>1</SubElm>
							</Elm>
						</RSL>
						<DTM>
							<Elm>
								<SubElm>AIC</SubElm>
								<SubElm>
									<xsl:call-template name="DateToDTM102"/>
								</SubElm>
								<SubElm>102</SubElm>
							</Elm>
						</DTM>
					</S10>
				</xsl:for-each>
				<xsl:for-each select="$ReqInfo/m:Sample">
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
						<xsl:if test="m:MaterialPreTreatment='fikseret'">
							<SPC>
								<Elm>
									<SubElm>PRM</SubElm>
								</Elm>
								<Elm>
									<SubElm>T998</SubElm>
									<SubElm>PA3</SubElm>
									<SubElm>SST</SubElm>
									<SubElm>Fikseret</SubElm>
								</Elm>
							</SPC>
						</xsl:if>
						<xsl:if test="m:MaterialPreTreatment='frysesnit'">
							<SPC>
								<Elm>
									<SubElm>PRM</SubElm>
								</Elm>
								<Elm>
									<SubElm>T100</SubElm>
									<SubElm>PA3</SubElm>
									<SubElm>SST</SubElm>
									<SubElm>Frysesnit</SubElm>
								</Elm>
							</SPC>
						</xsl:if>
						<RFF>
							<Elm>
								<SubElm>RTI</SubElm>
								<SubElm>
									<xsl:value-of select="m:RequesterSampleIdentifier"/>
								</SubElm>
							</Elm>
						</RFF>
						<FTX>
							<Elm>
								<SubElm>MAT</SubElm>
							</Elm>
							<Elm><SubElm>P00</SubElm></Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:MaterialDescription"/>
								</SubElm>
							</Elm>
						</FTX>
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
					</S15>
				</xsl:for-each>
				<xsl:for-each select="$ReqAnas">
					<S17 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<xsl:for-each select="m:Analysis">
							<INV>
								<Elm>
									<SubElm>OP</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:AnalysisCode"/>
									</SubElm>
									<SubElm>
										<xsl:value-of select="m:AnalysisCodeType"/>
									</SubElm>
									<SubElm>SST</SubElm>
									<SubElm>
										<xsl:value-of select="m:AnalysisShortName"/>
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
