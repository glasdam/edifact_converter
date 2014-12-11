<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2004/06/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- DISCHARGELETTER -->
	<xsl:template match="m:BinaryLetter">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="SysInfo" select="m:SystemInformation"/>
		<xsl:variable name="Contents" select="m:Contents"/>
		<xsl:variable name="BinObjs" select="m:BinaryObject"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>MEDBIN</SubElm>
					<SubElm>D</SubElm>
					<SubElm>93A</SubElm>
					<SubElm>UN</SubElm>
					<SubElm>B0130X</SubElm>
				</Elm>
				<Elm>
					<SubElm>BIN01</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>OBJ</SubElm>
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
								<xsl:if test="count($Participant/m:DepartmentName)=0 and count($Participant/m:UnitName)>0">_</xsl:if>
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
							<SubElm>BIN01</SubElm>
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
								<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
								<xsl:value-of select="$Participant/m:OrganisationName"/>
							</SubElm>
							<SubElm>
								<xsl:if test="count($Participant/m:DepartmentName)=0 and count($Participant/m:UnitName)>0">_</xsl:if>
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
					<Elm>
						<SubElm>07</SubElm>
					</Elm>
					<xsl:for-each select="$SysInfo">
						<PNA>
							<Elm>
								<SubElm>PAT</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>SU</SubElm>
								<SubElm>Data</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:if test="count($Contents)=1">FO</xsl:if>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Contents"/>
								</SubElm>
							</Elm>
						</PNA>
						<RFF>
							<Elm>
								<SubElm>XPI</SubElm>
								<SubElm>SYSTEMPOST</SubElm>
							</Elm>
						</RFF>
					</xsl:for-each>
					<xsl:for-each select="$Patient">
						<xsl:if test="count(m:CivilRegistrationNumber)=1 and count(m:AlternativeIdentifier)=1">
							<FEJL>Patient kan ikke både have et CivilRegistrationNumber og et AlternativeIdentifier</FEJL>
						</xsl:if>
						<xsl:if test="count(m:CivilRegistrationNumber)=0 and count(m:AlternativeIdentifier)=0">
							<FEJL>Patient skal have et CivilRegistrationNumber eller et AlternativeIdentifier</FEJL>
						</xsl:if>
						<xsl:variable name="Person" select="."/>
						<PNA>
							<Elm>
								<SubElm>PAT</SubElm>
							</Elm>
							<Elm>
								<xsl:if test="count(m:CivilRegistrationNumber)=1">
									<SubElm>
										<xsl:value-of select="m:CivilRegistrationNumber"/>
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
						<xsl:if test="count(m:AlternativeIdentifier)=1">
							<RFF>
								<Elm>
									<SubElm>XPI</SubElm>
									<SubElm>
										<xsl:value-of select="m:AlternativeIdentifier"/>
									</SubElm>
								</Elm>
							</RFF>
						</xsl:if>
					</xsl:for-each>
				</S07>
				<xsl:for-each select="$BinObjs">
					<S11>
						<Elm>
							<SubElm>11</SubElm>
						</Elm>
						<UNO>
							<Elm>
								<SubElm>
									<xsl:value-of select="position()"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>AID</SubElm>
								<SubElm>
									<xsl:value-of select="m:ObjectIdentifier"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>OBJ</SubElm>
								<SubElm>
									<xsl:variable name="OC" select="m:ObjectCode"/>
									<xsl:choose>
										<xsl:when test="$OC='tekstfil'">TXT</xsl:when>
										<xsl:when test="$OC='billede'">IMG</xsl:when>
										<xsl:when test="$OC='program'">PRG</xsl:when>
										<xsl:when test="$OC='vektor_grafik'">VGR</xsl:when>
										<xsl:when test="$OC='biosignaler'">BSG</xsl:when>
										<xsl:when test="$OC='multimedie'">MUL</xsl:when>
										<xsl:when test="$OC='proprietaert_indhold'">PRP</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt OBJEKTTYPE<xsl:value-of select="$OC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:variable name="OEC" select="m:ObjectExtensionCode"/>
									<xsl:choose>
										<xsl:when test="$OEC='pcx'">PCX</xsl:when>
										<xsl:when test="$OEC='tiff'">TIF</xsl:when>
										<xsl:when test="$OEC='jpeg'">JPG</xsl:when>
										<xsl:when test="$OEC='gif'">GIF</xsl:when>
										<xsl:when test="$OEC='bmp'">BMP</xsl:when>
										<xsl:when test="$OEC='png'">PNG</xsl:when>
										<xsl:when test="$OEC='mpg'">MPG</xsl:when>
										<xsl:when test="$OEC='dcm'">DCM</xsl:when>
										<xsl:when test="$OEC='scp'">SCP</xsl:when>
										<xsl:when test="$OEC='txt'">TXT</xsl:when>
										<xsl:when test="$OEC='rtf'">RTF</xsl:when>
										<xsl:when test="$OEC='doc'">DOC</xsl:when>
										<xsl:when test="$OEC='xsl'">XLS</xsl:when>
										<xsl:when test="$OEC='wpd'">WPD</xsl:when>
										<xsl:when test="$OEC='exe'">EXE</xsl:when>
										<xsl:when test="$OEC='pdf'">PDF</xsl:when>
										<xsl:when test="$OEC='wav'">WAV</xsl:when>
										<xsl:when test="$OEC='avi'">AVI</xsl:when>
										<xsl:when test="$OEC='mid'">MID</xsl:when>
										<xsl:when test="$OEC='rmi'">RMI</xsl:when>
										<xsl:when test="$OEC='com'">COM</xsl:when>
										<xsl:when test="$OEC='zip'">ZIP</xsl:when>
										<xsl:when test="$OEC='bin'">BIN</xsl:when>
										<xsl:when test="$OEC='inh'">INH</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt OBJEKTEXTENSIONTYPE<xsl:value-of select="$OEC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>91</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:OriginalObjectSize"/>
								</SubElm>
								<SubElm>14</SubElm>
								<SubElm>1</SubElm>
								<SubElm>A</SubElm>
							</Elm>
						</UNO>
						<OBJ binary="true">
							<Elm>
								<SubElm base64="true">
									<xsl:value-of select="m:Object_Base64Encoded"/>
								</SubElm>
							</Elm>
						</OBJ>
						<UNP>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:OriginalObjectSize"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="position()"/>
								</SubElm>
							</Elm>
						</UNP>
					</S11>
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
