<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- BOOKINGCONFIRMATION-->
	<xsl:template match="m:BookingConfirmation">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Contact" select="$Sender/m:Contact"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="CCReceiver" select="m:CCReceiver"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="Referral" select="m:Referral"/>
		<xsl:variable name="Confirmation" select="m:Confirmation"/>
		<xsl:variable name="ClinInfos" select="m:ClinicalInformation"/>
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
					<SubElm>D1333L</SubElm>
				</Elm>
				<Elm>
					<SubElm>DIS13</SubElm>
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
							<xsl:for-each select="$Letter/m:Authorisation">
								<xsl:call-template name="DateTimeToDTM203"/>
							</xsl:for-each>
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
							<SubElm>DIS13</SubElm>
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
							<xsl:call-template name="identifierCode2edi">
								<xsl:with-param name="code" select="$Participant/m:IdentifierCode"/>
							</xsl:call-template>
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
								<xsl:for-each select="$Letter/m:Authorisation">
									<xsl:call-template name="DateTimeToDTM203"/>
								</xsl:for-each>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
				</S02>
				<!-- Referral -->
				<xsl:if test="count($Referral)=1">
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
										<xsl:for-each select="$Referral/m:Received">
											<xsl:call-template name="DateTimeToDTM203"/>
										</xsl:for-each>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:if>
					</S05>
				</xsl:if>
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
				<!-- -->
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
					<xsl:if test="count($Confirmation)=1">
						<DTM>
							<Elm>
								<SubElm>90</SubElm>
								<SubElm>
									<xsl:for-each select="$Confirmation">
										<xsl:call-template name="DateTimeToDTM203"/>
									</xsl:for-each>
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
				</S11>
				<xsl:for-each select="$ClinInfos">
					<S14>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<XFTX maxOccurs="9">
							<Elm>
								<SubElm>NC</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:for-each select="m:Text03">
										<xsl:for-each select="text() | *">
											<xsl:apply-templates select="."/>
										</xsl:for-each>
									</xsl:for-each>
								</SubElm>
							</Elm>
						</XFTX>
					</S14>
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
	<xsl:template match="m:Space">
		<Space/>
	</xsl:template>
	<xsl:template match="m:Break">
		<Break/>
	</xsl:template>
	<xsl:template match="m:Bold">
		<Bold>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Bold>
	</xsl:template>
	<xsl:template match="m:Italic">
		<Italic>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Italic>
	</xsl:template>
	<xsl:template match="m:Underline">
		<Underline>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Underline>
	</xsl:template>
	<xsl:template match="m:Right">
		<Right>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Right>
	</xsl:template>
	<xsl:template match="m:Center">
		<Center>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Center>
	</xsl:template>
	<xsl:template match="m:FixedFont">
		<FixedFont>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</FixedFont>
	</xsl:template>
</xsl:stylesheet>
