<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- DISCHARGELETTER -->
	<xsl:template match="m:Prescription">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Issuer" select="$Sender/m:Issuer"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
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
					<SubElm>LMS015</SubElm>
				</Elm>
				<Elm>
					<SubElm>PRE01</SubElm>
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
									<FEJL>Kan ikke oversætte MessageStatusCode: <xsl:value-of select="$MSC"/></FEJL>
								</xsl:otherwise>
							</xsl:choose>
						</SubElm>
					</Elm>
				</BGM>
				<DTM>
					<Elm>
						<SubElm>137</SubElm>
						<SubElm>
							<xsl:call-template name="DateTimeToDTM204">
								<xsl:with-param name="DT" select="$Letter/m:Authorisation"/>
							</xsl:call-template>
						</SubElm>
						<SubElm>204</SubElm>
					</Elm>
				</DTM>
				<!-- SENDER -->
				<S01>
					<xsl:variable name="Participant" select="$Sender"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<PNA>
						<Elm><SubElm>PO</SubElm></Elm>
						<Elm>
							<xsl:if test="$Issuer/m:CivilRegistrationNumber!='' ">
							<SubElm><xsl:value-of select="$Issuer/m:CivilRegistrationNumber"/></SubElm><SubElm>CPR</SubElm>
							</xsl:if>
						</Elm>
						<Elm>
							<SubElm><xsl:value-of select="$Participant/m:Identifier"/></SubElm>
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SKS</xsl:when>
									<xsl:when test="$IC='ydernummer' ">YNR</xsl:when>
									<xsl:when test="$IC='lokationsnummer' "></xsl:when>
									<xsl:when test="count($IC)=0 "/>
									<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
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
							<SubElm><xsl:value-of select="$Issuer/m:TitleAndName"/></SubElm>
						</Elm>
						<xsl:if test="$Participant/m:OrganisationName!=''">
						<Elm><SubElm>US</SubElm><SubElm><xsl:value-of select="$Participant/m:OrganisationName"/></SubElm></Elm>
						</xsl:if>
							
					</PNA>
	<!--				<NAD>
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
									<xsl:when test="$IC='lokationsnummer' "></xsl:when>
									<xsl:when test="count($IC)=0 "/>
									<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
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
							<SubElm>DIS01</SubElm>
							<SubElm>SKS</SubElm>
							<SubElm>SST</SubElm>
						</Elm>
					</SPR>
-->					
				</S01>
				<!-- Receiver -->
<!--				<S01>
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
-->					<!-- Standard for ADR segments -->
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
-->				<!-- CCReceiver -->
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
-->						<!-- Standard for ADR segments -->
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
-->				<!-- Referral -->
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
-->				<!-- Patient -->
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
-->					<!-- Standard for ADR segments -->
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
-->				<!-- Relative -->
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
-->						<!-- Standard for ADR segments -->
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
-->				<!-- -->
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
-->				<!-- Other Diagnoses -->
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
-->						<!-- 1 gang for hver ClinicalInformation - 10 gange ialt -->
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
-->			</BrevIndhold>
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
