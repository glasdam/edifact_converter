<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- PrescriptionRequest -->
	<xsl:template match="m:PrescriptionRequest">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="PersonInOrg" select="$Sender/m:PersonInOrganisation"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="Issuer" select="$Receiver/m:Issuer"/>
		<xsl:variable name="PrefPharmacy" select="m:PreferedPharmacy"/>
		<xsl:variable name="CCReceiver" select="m:CCReceiver"/>
		<xsl:variable name="PatOrRel" select="m:PatientOrRelative"/>
		<xsl:variable name="PreInfo" select="m:PrescriptionInformation"/>
		<xsl:variable name="Drugs" select="m:Drug"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>MEDPRE</SubElm>
					<SubElm>0</SubElm>
					<SubElm>962</SubElm>
					<SubElm>RT</SubElm>
					<SubElm>R6031W</SubElm>
				</Elm>
				<Elm>
					<SubElm>PRE60</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>PRS</SubElm>
						<SubElm>SKL</SubElm>
						<SubElm>SST</SubElm>
					</Elm>
					<Elm/>
					<Elm>
						<SubElm>
							<xsl:variable name="MSC" select="$PreInfo/m:MessageStatusCode"/>
							<xsl:choose>
								<xsl:when test="$MSC='original' ">9</xsl:when>
								<xsl:when test="$MSC='kopi' ">7</xsl:when>
								<xsl:otherwise>
									<FEJL>Kan ikke oversætte MessageStatusCode: <xsl:value-of select="$MSC"/>
									</FEJL>
								</xsl:otherwise>
							</xsl:choose>
						</SubElm>
					</Elm>
				</BGM>
				<DTM>
					<Elm>
						<SubElm>137</SubElm>
						<SubElm>
							<xsl:call-template name="DateTimeWithSecToDTM204">
								<xsl:with-param name="DT" select="$Letter/m:Authorisation"/>
							</xsl:call-template>
						</SubElm>
						<SubElm>204</SubElm>
					</Elm>
				</DTM>
				<!-- SENDER -->
				<S01 hidden="true">
					<xsl:variable name="Participant" select="$Sender"/>
					<PNA>
						<Elm>
							<SubElm>PO</SubElm>
						</Elm>
						<Elm/>
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
						<Elm/>
						<Elm>
							<SubElm>US</SubElm>
							<SubElm>
								<xsl:value-of select="$PersonInOrg/m:TitleAndName"/>
							</SubElm>
						</Elm>
						<xsl:if test="$Participant/m:OrganisationName!=''">
							<Elm>
								<SubElm>US</SubElm>
								<SubElm>
									<xsl:value-of select="$Participant/m:OrganisationName"/>
								</SubElm>
							</Elm>
						</xsl:if>
					</PNA>
					<xsl:variable name="Adr" select="$Participant"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm/>
							<Elm>
								<xsl:if test="count($Adr/m:StreetName)>0">
									<SubElm>1</SubElm>
									<SubElm>
										<xsl:value-of select="$Adr//m:StreetName"/>
									</SubElm>
								</xsl:if>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>
					<COM>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:TelephoneSubscriberIdentifier"/>
							</SubElm>
							<SubElm>TE</SubElm>
						</Elm>
					</COM>
				</S01>
				<!-- Receiver -->
				<S01 hidden="true">
					<xsl:variable name="Participant" select="$Receiver"/>
					<PNA>
						<Elm>
							<SubElm>SSP</SubElm>
						</Elm>
						<Elm>
							<xsl:if test="count($Issuer)>0">
								<SubElm>
									<xsl:value-of select="$Issuer/m:AuthorisationIdentifier"/>
								</SubElm>
								<SubElm>AUT</SubElm>	
							</xsl:if>
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
						<Elm/>
							<Elm>
								<xsl:if test="$Issuer/m:TitleAndName!=''">
								<SubElm>US</SubElm>
								<SubElm>
									<xsl:value-of select="$Issuer/m:TitleAndName"/>
								</SubElm>
								</xsl:if>
							</Elm>
						<xsl:if test="$Participant/m:OrganisationName!=''">
							<Elm>
								<SubElm>US</SubElm>
								<SubElm>
									<xsl:value-of select="$Participant/m:OrganisationName"/>
								</SubElm>
							</Elm>
						</xsl:if>
					</PNA>
					<xsl:if test="count($Issuer/m:SpecialityCode)>0">
						<QUA>
							<Elm>
								<SubElm>1</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Issuer/m:SpecialityCode"/>
								</SubElm>
								<SubElm>SPC</SubElm>
								<SubElm>SFU</SubElm>
							</Elm>
						</QUA>
					</xsl:if>
					<xsl:if test="count($Issuer/m:Occupation)>0">
						<EMP>
							<Elm>
								<SubElm>4</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="Occ" select="$Issuer/m:Occupation"/>
									<xsl:choose>
										<xsl:when test="$Occ='tandlage'">DEN</xsl:when>
										<xsl:when test="$Occ='laege'">PHY</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt Occupation: <xsl:value-of select="$Occ"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>SKL</SubElm>
								<SubElm>SST</SubElm>
							</Elm>
						</EMP>
					</xsl:if>
				</S01>
				<xsl:for-each select="$PrefPharmacy">
					<S01 hidden="true">
						<xsl:variable name="Participant" select="$PrefPharmacy"/>
						<PNA>
							<Elm>
								<SubElm>SE</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Participant/m:EANIdentifier"/>
								</SubElm>
								<SubElm/>
								<SubElm>9</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<xsl:if test="$Participant/m:OrganisationName!=''">
								<Elm>
									<SubElm>US</SubElm>
									<SubElm>
										<xsl:value-of select="$Participant/m:OrganisationName"/>
									</SubElm>						
								</Elm>
							</xsl:if>
						</PNA>
					</S01>
				</xsl:for-each>
				<S02 hidden="true">
					<DTM>
						<Elm>
							<SubElm>97</SubElm>
							<SubElm>
								<xsl:call-template name="DateToDTM102">
									<xsl:with-param name="D" select="$Letter/m:Authorisation/m:Date"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>102</SubElm>
						</Elm>
					</DTM>
					<RFF>
						<Elm>
							<SubElm>CH</SubElm>
							<SubElm>
								<xsl:value-of select="$PreInfo/m:DrugDatabaseVersion"/>
							</SubElm>
						</Elm>
					</RFF>
					<RFF>
						<Elm>
							<SubElm>SYS</SubElm>
							<SubElm>
								<xsl:value-of select="$PreInfo/m:SenderComputerSystem"/>
							</SubElm>
						</Elm>
					</RFF>
					<xsl:if test="$PreInfo/m:DoseDispenseInformation/m:Status='dosisdispensering' ">
						<RFF>
							<Elm>
								<SubElm>DOS</SubElm>
								<SubElm>NR</SubElm>
							</Elm>
						</RFF>
						<xsl:if test="$PreInfo/m:DoseDispenseInformation/m:CopyRequired='true' ">
							<RFF>
								<Elm>
									<SubElm>COP</SubElm>
									<SubElm>NR</SubElm>
								</Elm>
							</RFF>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$PreInfo/m:DoseDispenseInformation/m:Status='seponeres' ">
						<RFF>
							<Elm>
								<SubElm>SEP</SubElm>
								<SubElm>NR</SubElm>
							</Elm>
						</RFF>
						<xsl:if test="$PreInfo/m:DoseDispenseInformation/m:CopyRequired='true' ">
							<RFF>
								<Elm>
									<SubElm>COP</SubElm>
									<SubElm>NR</SubElm>
								</Elm>
							</RFF>
						</xsl:if>
					</xsl:if>
					<xsl:if test="count(m:ForGPUse)>0">
						<INP>
							<Elm/>
							<Elm>
								<SubElm>SPP</SubElm>
								<SubElm>AUP</SubElm>
								<SubElm>SKL</SubElm>
								<SubElm>SST</SubElm>
							</Elm>
						</INP>
					</xsl:if>
					<xsl:if test="count(m:ForGPClinicUse)>0">
						<INP>
							<Elm/>
							<Elm>
								<SubElm>SPP</SubElm>
								<SubElm>UIS</SubElm>
								<SubElm>SKL</SubElm>
								<SubElm>SST</SubElm>
							</Elm>
						</INP>
					</xsl:if>
					<xsl:for-each select="$PreInfo/m:OrderInstruction">
						<FTX>
							<Elm>
								<SubElm>ORI</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="text()"/>
								</SubElm>
							</Elm>
						</FTX>
					</xsl:for-each>
					<xsl:for-each select="$PreInfo/m:DeliveryInformation">
						<FTX>
							<Elm>
								<SubElm>DEL</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="text()"/>
								</SubElm>
							</Elm>
						</FTX>
					</xsl:for-each>
				</S02>
				<xsl:for-each select="$PatOrRel">
					<S03 hidden="true">
						<GIS>
							<Elm>
								<SubElm>ZZZ</SubElm>
								<SubElm>SKL</SubElm>
								<SubElm>SST</SubElm>
							</Elm>
						</GIS>
						<PNA>
							<Elm>
								<SubElm>
									<xsl:variable name="T" select="m:Type"/>
									<xsl:choose>
										<xsl:when test="$T='patient' ">PAT</xsl:when>
										<xsl:when test="$T='patienttilknyttet_person' ">PAS</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt Patient or Relative type: <xsl:value-of select="$T"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:CivilRegistrationNumber"/>
								</SubElm>
								<SubElm>
									<xsl:if test="count(m:CivilRegistrationNumber)>0">CPR</xsl:if>
								</SubElm>
							</Elm>
							<Elm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>SCC</SubElm>
								<SubElm>
									<xsl:value-of select="concat(m:PersonSurnameName,',',m:PersonGivenName)"/>
								</SubElm>
							</Elm>
						</PNA>
						<ADR>
							<Elm>
								<SubElm>1</SubElm>
							</Elm>
							<Elm>
								<SubElm>1</SubElm>
								<SubElm>
									<xsl:value-of select="m:StreetName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:DistrictName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:CountryCode"/>
								</SubElm>
							</Elm>
							<xsl:if test="count(m:CountyCode)>0">
								<Elm>
									<SubElm>
										<xsl:value-of select="m:CountyCode"/>
									</SubElm>
									<SubElm>SKL</SubElm>
									<SubElm>SST</SubElm>
								</Elm>
							</xsl:if>
						</ADR>
						<xsl:if test="count(m:EmailIdentifier)>0">
							<COM>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:EmailIdentifier"/>
									</SubElm>
									<SubElm>
										<xsl:variable name="ES" select="m:EmailStatus"/>
											<xsl:choose>
												<xsl:when test="$ES='permanent' ">PEM</xsl:when>
												<xsl:when test="$ES='midlertidig' ">TEM</xsl:when>
												<xsl:otherwise>
													<FEJL>Kan ikke oversætte EmailStatus: <xsl:value-of select="$ES"/>
													</FEJL>
												</xsl:otherwise>
											</xsl:choose>
									</SubElm>
								</Elm>
							</COM>
						</xsl:if>
						<xsl:if test="count(m:PatientDateOfBirth)>0">
							<DTM>
								<Elm>
									<SubElm>329</SubElm>
									<SubElm>
										<xsl:call-template name="DateToDTM102">
											<xsl:with-param name="D" select="m:PatientDateOfBirth"/>
										</xsl:call-template>
									</SubElm>
									<SubElm>102</SubElm>
								</Elm>
							</DTM>
						</xsl:if>
						<xsl:if test="count(m:PatientSex)>0">
							<PDI>
								<Elm>
									<SubElm>
										<xsl:variable name="PS" select="m:PatientSex"/>
										<xsl:choose>
											<xsl:when test="$PS='hankoen' ">1</xsl:when>
											<xsl:when test="$PS='hunkoen' ">2</xsl:when>
											<xsl:otherwise>
												<FEJL>Ukendt PatientSex: <xsl:value-of select="$PS"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</SubElm>
								</Elm>
							</PDI>
						</xsl:if>
					</S03>
				</xsl:for-each>
				<xsl:for-each select="$Drugs">
					<S04 hidden="true">
						<LIN>
							<Elm>
								<SubElm>
									<xsl:value-of select="position()"/>
								</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:PackageIdentifier"/>
								</SubElm>
								<SubElm>AK</SubElm>
								<SubElm>NVN</SubElm>
								<SubElm>LMS</SubElm>
							</Elm>
						</LIN>
						<IMD>
							<Elm>
								<SubElm>A</SubElm>
							</Elm>
							<Elm>
								<SubElm>DNM</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:NameOfDrug"/>
								</SubElm>
							</Elm>
						</IMD>
						<IMD>
							<Elm>
								<SubElm>A</SubElm>
							</Elm>
							<Elm>
								<SubElm>DDP</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:DosageForm"/>
								</SubElm>
							</Elm>
						</IMD>
						<MEA>
							<Elm>
								<SubElm>AAU</SubElm>
							</Elm>
							<Elm>
								<SubElm>CT</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:PackageSize"/>
								</SubElm>
							</Elm>
						</MEA>
						<xsl:if test="count(m:DrugStrength)>0">
							<MEA>
								<Elm>
									<SubElm>DEN</SubElm>
								</Elm>
								<Elm>
									<SubElm>S</SubElm>
									<SubElm/>
									<SubElm/>
									<SubElm>
										<xsl:value-of select="m:DrugStrength"/>
									</SubElm>
								</Elm>
							</MEA>
						</xsl:if>
						<xsl:if test="count(m:SubstitutionCode)>0">
							<PGI>
								<Elm>
									<SubElm>10</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:variable name="Subst" select="m:SubstitutionCode"/>
										<xsl:choose>
											<!--<xsl:when test="$Subst='ikke_analog_substitution'">NA</xsl:when> Bruges ikke endnu-->
											<xsl:when test="$Subst='ikke_generisk_substitution'">NG</xsl:when>
											<xsl:when test="$Subst='ikke_original_substitution'">NO</xsl:when>
											<xsl:when test="$Subst='ikke_substitution'">NS</xsl:when>
											<xsl:otherwise>
												<FEJL>Ukendt SubstitutionCode: <xsl:value-of select="$Subst"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</SubElm>
									<SubElm>SKL</SubElm>
									<SubElm>SST</SubElm>
								</Elm>
							</PGI>
						</xsl:if>
						<QTY>
							<Elm>
								<SubElm>189</SubElm>
								<SubElm>
									<xsl:value-of select="m:NumberOfPackings"/>
								</SubElm>
								<SubElm>NMB</SubElm>
							</Elm>
						</QTY>
						<xsl:for-each select="m:Importer/m:ShortName">
							<PNA>
								<Elm>
									<SubElm>GZ</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>AB</SubElm>
									<SubElm>
										<xsl:value-of select="."/>
									</SubElm>
								</Elm>
							</PNA>
						</xsl:for-each>
						<xsl:for-each select="m:Importer/m:LongName">
							<PNA>
								<Elm>
									<SubElm>GZ</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>US</SubElm>
									<SubElm>
										<xsl:value-of select="."/>
									</SubElm>
								</Elm>
							</PNA>
						</xsl:for-each>
						<!-- ReimbursementClause -->
						<xsl:for-each select="m:ReimbursementClause">
							<ALC>
								<Elm>
									<SubElm>H</SubElm>
								</Elm>
								<Elm>
									<SubElm/>
									<SubElm>
										<xsl:variable name="RC" select="."/>
										<xsl:choose>
											<xsl:when test="$RC='klausulbetingelse_opfyldt'">CLA</xsl:when>
											<xsl:when test="$RC='varig_lidelse'">CRD</xsl:when>
											<xsl:when test="$RC='pensionist'">PEN</xsl:when>
											<xsl:when test="$RC='bevilling_fra_laegemiddelstyrelsen'">SPG</xsl:when>
											<xsl:otherwise>
												<FEJL>Ukendt ReimbursementClause: <xsl:value-of select="$RC"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</SubElm>
								</Elm>
							</ALC>
						</xsl:for-each>
						<CIN>
							<Elm>
								<SubElm>9</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:Indication/m:Code"/>
								</SubElm>
								<SubElm>
									<xsl:if test="count(m:Indication/m:Code)>0">LDD</xsl:if>
								</SubElm>
								<SubElm>
									<xsl:if test="count(m:Indication/m:Code)>0">LMS</xsl:if>
								</SubElm>
								<SubElm>
									<xsl:value-of select="m:Indication/m:Text"/>
								</SubElm>
							</Elm>
						</CIN>
						<xsl:for-each select="m:Iteration">
							<S06 hidden="true">
								<EQN>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:Number"/>
										</SubElm>
										<SubElm>ITE</SubElm>
									</Elm>
								</EQN>
								<DTM>
									<Elm>
										<SubElm>264</SubElm>
										<SubElm>
											<xsl:value-of select="m:Interval"/>
										</SubElm>
										<SubElm>
											<xsl:variable name="IU" select="m:IntervalUnit"/>
											<xsl:choose>
												<xsl:when test="$IU='maaned'">802</xsl:when>
												<xsl:when test="$IU='uge'">803</xsl:when>
												<xsl:when test="$IU='dag'">804</xsl:when>
												<xsl:otherwise>
													<FEJL>Ukendt IntervalUnit <xsl:value-of select="$IU"/>
													</FEJL>
												</xsl:otherwise>
											</xsl:choose>
										</SubElm>
									</Elm>
								</DTM>
							</S06>
						</xsl:for-each>
						<S07 hidden="true">
							<xsl:for-each select="m:Dosage">
								<DSG>
									<Elm>
										<SubElm>5</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:DosageCode"/>
										</SubElm>
										<SubElm>
											<xsl:if test="count(m:DosageCode)>0">LDD</xsl:if>
										</SubElm>
										<SubElm>
											<xsl:if test="count(m:DosageCode)>0">LMS</xsl:if>
										</SubElm>
										<SubElm>
											<xsl:value-of select="m:DosageText"/>
										</SubElm>
									</Elm>
								</DSG>
								<xsl:if test="count(m:Period)+count(m:PeriodUnit)>0">
									<DTM>
										<Elm>
											<SubElm>48</SubElm>
											<SubElm>
												<xsl:value-of select="m:Period"/>
											</SubElm>
											<SubElm>
												<xsl:variable name="PU" select="m:PeriodUnit"/>
												<xsl:choose>
													<!--	<xsl:when test="$PU='maaned'">802</xsl:when>-->
													<xsl:when test="$PU='uge'">803</xsl:when>
													<xsl:when test="$PU='dag'">804</xsl:when>
													<xsl:otherwise>
														<FEJL>Ukendt PeriodUnit <xsl:value-of select="$PU"/>
														</FEJL>
													</xsl:otherwise>
												</xsl:choose>
											</SubElm>
										</Elm>
									</DTM>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="m:DoseDispensing">
								<xsl:if test="m:StartDate">
								<DTM>
									<Elm>
										<SubElm>90</SubElm>
										<SubElm>
											<xsl:call-template name="DateToDTM102">
												<xsl:with-param name="D" select="m:StartDate"/>
											</xsl:call-template>
										</SubElm>
										<SubElm>102</SubElm>
									</Elm>
								</DTM>
								</xsl:if>
								<DTM>
									<Elm>
										<SubElm>91</SubElm>
										<SubElm>
											<xsl:call-template name="DateToDTM102">
												<xsl:with-param name="D" select="m:EndDate"/>
											</xsl:call-template>
										</SubElm>
										<SubElm>102</SubElm>
									</Elm>
								</DTM>
							</xsl:for-each>
							<xsl:for-each select="m:SupplementaryInformation">
								<FTX>
									<Elm>
										<SubElm>ACF</SubElm>
									</Elm>
									<Elm/>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="."/>
										</SubElm>
									</Elm>
								</FTX>
							</xsl:for-each>
						</S07>
					</S04>
				</xsl:for-each>
				<xsl:for-each select="$PreInfo/m:Delivery">
					<S08 hidden="true">
						<TOD>
							<Elm>
								<SubElm>2</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:variable name="POD" select="m:PriorityOfDelivery"/>
									<xsl:choose>
										<xsl:when test="$POD='send_til_anden_adresse_samme_dag'">OAD</xsl:when>
										<xsl:when test="$POD='send_til_anden_adresse_pr_post'">OAM</xsl:when>
										<xsl:when test="$POD='send_til_patientadresse_samme_dag'">PAD</xsl:when>
										<xsl:when test="$POD='send_til_patientadresse_pr_post'">PAM</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt PriorityOfDelivery: <xsl:value-of select="$POD"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>SKL</SubElm>
								<SubElm>SST</SubElm>
							</Elm>
						</TOD>
						<xsl:if test="count(m:StreetName)>0 or (count(m:PostCodeIdentifier)>0 and count(m:PseudoAddress)=0)">
							<ADR>
								<Elm>
									<SubElm>5</SubElm>
								</Elm>
								<Elm>
									<xsl:if test="count(m:StreetName)>0">
										<SubElm>1</SubElm>
										<SubElm>
											<xsl:value-of select="m:StreetName"/>
										</SubElm>
									</xsl:if>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:PostCodeIdentifier"/>
									</SubElm>
								</Elm>
							</ADR>
						</xsl:if>
						<xsl:if test="count(m:PseudoAddress)>0">
							<ADR>
								<Elm>
									<SubElm>5</SubElm>
								</Elm>
								<Elm>
									<SubElm>US</SubElm>
									<SubElm>
										<xsl:value-of select="m:PseudoAddress"/>
									</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:PostCodeIdentifier"/>
									</SubElm>
								</Elm>
							</ADR>
						</xsl:if>
						<xsl:for-each select="m:ContactName">
							<PNA>
								<Elm>
									<SubElm>AB</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>US</SubElm>
									<SubElm>
										<xsl:value-of select="."/>
									</SubElm>
								</Elm>
							</PNA>
						</xsl:for-each>
					</S08>
				</xsl:for-each>
				<!--	<Elm>
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
-->
				<!-- Standard for ADR segments -->
				<!--					<xsl:variable name="Adr" select="$Participant"/>
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
-->
				<!-- CCReceiver -->
				<!--				<xsl:if test="count($CCReceiver)=1">
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
-->
				<!-- Standard for ADR segments -->
				<!--						<xsl:variable name="Adr" select="$Participant"/>
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
				<xsl:if test="count($Contact)=1">
					<S01>
						<xsl:variable name="Participant" select="$Contact"/>
						<Elm>
							<SubElm>01</SubElm>
						</Elm>
						<NAD>
							<Elm>
								<SubElm>RSP</SubElm>
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
											<FEJL>
												Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
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
				<S02>
					<Elm>
						<SubElm>02</SubElm>
					</Elm>
					<GIS>
						<Elm>
							<SubElm>
								<xsl:variable name="C" select="$Letter/m:StatusCode"/>
								<xsl:choose>
									<xsl:when test="$C='nytbrev' ">N</xsl:when>
									<xsl:when test="$C='rettetbrev' ">M</xsl:when>
									<xsl:otherwise>
										<FEJL>
											Kan ikke oversaette fra StatusCode til GIS: <xsl:value-of select="$C"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
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
-->
				<!-- Referral -->
				<!--				<xsl:if test="count($Referral)=1">
					<S05>
						<Elm>
							<SubElm>05</SubElm>
						</Elm>
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<xsl:if test="count($Referral/m:Identifier)=1">
							<RFF>
								<Elm>
									<SubElm>ROI</SubElm>
									<SubElm>
										<xsl:value-of select="$Referral/m:Identifier"/>
									</SubElm>
								</Elm>
							</RFF>
						</xsl:if>
						<xsl:if test="count($Referral/m:Received)=1">
							<DTM>
								<Elm>
									<SubElm>8</SubElm>
									<SubElm>
										<xsl:call-template name="DateTimeToDTM203">
											<xsl:with-param name="DT" select="$Referral/m:Received"/>
										</xsl:call-template>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:if>
						<CIN>
							<xsl:variable name="Diagnose" select="$RefDiag"/>
							<Elm>
								<SubElm>DI</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
								</SubElm>
								<SubElm>
									<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SKS</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' ">USP</xsl:when>
										<xsl:when test="$DTC='ICPCkode' ">ICP</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SST</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' "/>
										<xsl:when test="$DTC='ICPCkode' "/>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
						<xsl:for-each select="$RefAddDiags">
							<CIN>
								<xsl:variable name="Diagnose" select="."/>
								<Elm>
									<SubElm>DM</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
									</SubElm>
									<SubElm>
										<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
										<xsl:choose>
											<xsl:when test="$DTC='SKSdiagnosekode' ">SKS</xsl:when>
											<xsl:when test="$DTC='uspecificeretkode' ">USP</xsl:when>
											<xsl:when test="$DTC='ICPCkode' ">ICP</xsl:when>
											<xsl:otherwise>
												<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</SubElm>
									<SubElm>
										<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
										<xsl:choose>
											<xsl:when test="$DTC='SKSdiagnosekode' ">SST</xsl:when>
											<xsl:when test="$DTC='uspecificeretkode' "/>
											<xsl:when test="$DTC='ICPCkode' "/>
											<xsl:otherwise>
												<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</SubElm>
									<SubElm>
										<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
									</SubElm>
								</Elm>
							</CIN>
						</xsl:for-each>
					</S05>
				</xsl:if>
-->
				<!-- Patient -->
				<!--				<S07>
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
-->
				<!-- Standard for ADR segments -->
				<!--					<xsl:variable name="Adr" select="$Person"/>
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
							<Elm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="$Patient/m:OccupancyText"/>
								</SubElm>
							</Elm>
						</EMP>
					</xsl:if>
				</S07>
-->
				<!-- Relative -->
				<!--				<xsl:for-each select="$Relatives">
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
-->
				<!-- Standard for ADR segments -->
				<!--						<xsl:variable name="Adr" select="$Person"/>
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
					</S09>
				</xsl:for-each>
-->
				<!-- -->
				<!--				<S11>
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
					<xsl:if test="count($Admission)=1">
						<DTM>
							<Elm>
								<SubElm>90</SubElm>
								<SubElm>
									<xsl:call-template name="DateTimeToDTM203">
										<xsl:with-param name="DT" select="$Admission"/>
									</xsl:call-template>
								</SubElm>
								<SubElm>203</SubElm>
							</Elm>
						</DTM>
					</xsl:if>
					<xsl:if test="count($Discharge)=1">
						<DTM>
							<Elm>
								<SubElm>91</SubElm>
								<SubElm>
									<xsl:call-template name="DateTimeToDTM203">
										<xsl:with-param name="DT" select="$Discharge"/>
									</xsl:call-template>
								</SubElm>
								<SubElm>203</SubElm>
							</Elm>
						</DTM>
					</xsl:if>
					<PAS>
						<Elm>
							<SubElm>
								<xsl:variable name="EOCSC" select="$Patient/m:EpisodeOfCareStatusCode"/>
								<xsl:choose>
									<xsl:when test="count($EOCSC)=0 ">POT</xsl:when>
									<xsl:when test="$EOCSC='inaktiv' ">POT</xsl:when>
									<xsl:when test="$EOCSC='indlagt' ">HS</xsl:when>
									<xsl:when test="$EOCSC='ambulant' ">HA</xsl:when>
									<xsl:when test="$EOCSC='doed' ">DA</xsl:when>
									<xsl:when test="$EOCSC='ambulant_roentgen' ">REQ</xsl:when>
									<xsl:otherwise>
										<FEJL>Kan ikke oversaette til EpisodeOfCareStatusCode: <xsl:value-of select="$EOCSC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
					</PAS>
					<xsl:if test="count($MainDiag)=1">
						<CIN>
							<xsl:variable name="Diagnose" select="$MainDiag"/>
							<Elm>
								<SubElm>A</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
								</SubElm>
								<SubElm>SKS</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:if>
					<xsl:for-each select="$MainAddDiags">
						<CIN>
							<xsl:variable name="Diagnose" select="."/>
							<Elm>
								<SubElm>DM</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
								</SubElm>
								<SubElm>SKS</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:for-each>
				</S11>
-->
				<!-- Other Diagnoses -->
				<!--				<xsl:for-each select="$OtherDiags">
					<S14>
						<xsl:variable name="Diagnose" select="."/>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<CIN>
							<Elm>
								<SubElm>
									<xsl:variable name="Desc" select="$Diagnose/m:DiagnoseDescriptionCode"/>
									<xsl:choose>
										<xsl:when test="$Desc='uspec_diagnose'">DI</xsl:when>
										<xsl:when test="$Desc='henv_diagnose'">H</xsl:when>
										<xsl:when test="$Desc='bidiagnose'">B</xsl:when>
										<xsl:when test="$Desc='tillaegsdiagnose'">DM</xsl:when>
										<xsl:when test="$Desc='aktionsdiagnose'">A</xsl:when>
										<xsl:when test="$Desc='grundmorbus'">G</xsl:when>
										<xsl:when test="$Desc='midlertidig_diagnose'">M</xsl:when>
										<xsl:when test="$Desc='forloebsdiagnose'">S</xsl:when>
										<xsl:when test="$Desc='operation'">TR</xsl:when>
										<xsl:when test="$Desc='roentgenundersoegelse'">IN</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseDescriptionCode: <xsl:value-of select="$Desc"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
								</SubElm>
								<SubElm>
									<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SKS</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' ">USP</xsl:when>
										<xsl:when test="$DTC='ICPCkode' ">ICP</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SST</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' "/>
										<xsl:when test="$DTC='ICPCkode' "/>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
						<xsl:if test="count($Diagnose/m:DiagnoseDateTime)=1">
							<DTM>
								<Elm>
									<SubElm>CIS</SubElm>
									<SubElm>
										<xsl:call-template name="DateTimeToDTM203">
											<xsl:with-param name="DT" select="$Diagnose/m:DiagnoseDateTime"/>
										</xsl:call-template>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:if>
					</S14>
				</xsl:for-each>
				<xsl:for-each select="$ClinInfos">
					<S14 maxOccurs="1">
-->
				<!-- 1 gang for hver ClinicalInformation - 10 gange ialt -->
				<!--						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<xsl:if test="count(m:Signed)>0">
							<DTM>
								<Elm>
									<SubElm>CIC</SubElm>
									<SubElm>
										<xsl:call-template name="DateTimeToDTM203">
											<xsl:with-param name="DT" select="m:Signed"/>
										</xsl:call-template>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:if>
						<XFTX maxOccurs="9">
							<Elm>
								<SubElm>NC</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="m:Text01/text()|m:Text01/*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</S14>
				</xsl:for-each>
-->
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
