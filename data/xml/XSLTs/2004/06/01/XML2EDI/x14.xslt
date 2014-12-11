<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2004/06/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- ANSWEROFADMISSION -->
	<xsl:template match="m:AnswerOfAdmission">
		<!--
		<xsl:if test="$Envelope/m:AcknowledgementCode!='minuspositivkvitt' ">
			<FEJL>AcknowledgementCode kan kun være 'minuspositivkvitt' i AnswerOfAdmission breve</FEJL>
		</xsl:if>-->
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="ContactInfos" select="$Sender/m:ContactInformation"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="Patient" select="m:Patient"/>
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
					<SubElm>D1431C</SubElm>
				</Elm>
				<Elm>
					<SubElm>DIS14</SubElm>
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
								<xsl:call-template name="DateTimeWithSecToDTM204"/>
							</xsl:for-each>
						</SubElm>
						<SubElm>204</SubElm>
					</Elm>
				</DTM>
				<!-- Receiver -->
				<S01>
					<xsl:variable name="Participant" select="$Receiver"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>ROR</SubElm>
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
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>1</SubElm>
						</Elm>
					</SEQ>
				</S01>
				<!-- SENDER -->
				<S01>
					<xsl:variable name="Participant" select="$Sender"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>SOR</SubElm>
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
							<SubElm/>
							<SubElm/>
							<SubElm/>
							<SubElm/>
							<SubElm>US</SubElm>
						</Elm>
					</NAD>
					<SEQ>
						<Elm>
							</Elm>
						<Elm>
							<SubElm>2</SubElm>
						</Elm>
					</SEQ>
					<SPR>
						<Elm>
							<SubElm>ORG</SubElm>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>DIS14</SubElm>
							<SubElm>SKS</SubElm>
							<SubElm>SST</SubElm>
							<SubElm>Indlæggelsessvar</SubElm>
						</Elm>
					</SPR>
				</S01>
				<xsl:for-each select="$ContactInfos">
					<S01>
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
									<xsl:if test="count(m:ContactName)>0">
										<xsl:value-of select="m:ContactName[1]"/>
									</xsl:if>
								</SubElm>
								<SubElm>
									<xsl:if test="count(m:ContactName)>1">
										<xsl:value-of select="m:ContactName[2]"/>
									</xsl:if>
								</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>US</SubElm>
							</Elm>
						</NAD>
						<xsl:if test="count(m:TelephoneSubscriberIdentifier)=1">
							<CON>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:TelephoneSubscriberIdentifier"/>
									</SubElm>
									<SubElm>TE</SubElm>
								</Elm>
							</CON>
						</xsl:if>
						<RFF>
							<Elm>
								<SubElm>AHL</SubElm>
								<SubElm>2</SubElm>
							</Elm>
						</RFF>
						<xsl:if test="count(m:ContactTimeText)>0">
						<RFF>
							<Elm>
								<SubElm>BUH</SubElm>
								<SubElm>
									<xsl:value-of select="m:ContactTimeText"/>
								</SubElm>
							</Elm>
						</RFF>
						</xsl:if>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="2+position()"/>
								</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:for-each>
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
								<xsl:for-each select="$Letter/m:Authorisation">
									<xsl:call-template name="DateTimeWithSecToDTM204"/>
								</xsl:for-each>
							</SubElm>
							<SubElm>204</SubElm>
						</Elm>
					</DTM>
				</S02>
				<!-- Patient -->
				<S07>
					<Elm>
						<SubElm>07</SubElm>
					</Elm>
					<PNA>
						<Elm>
							<SubElm>PAT</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Patient/m:CivilRegistrationNumber"/>
							</SubElm>
							<SubElm/>
							<SubElm/>
							<SubElm>CPR</SubElm>
							<SubElm>IM</SubElm>
						</Elm>
					</PNA>
				</S07>
				<S11>
					<Elm>
						<SubElm>11</SubElm>
					</Elm>
					<GIS>
						<Elm>
							<SubElm>
								<xsl:variable name="C" select="$Letter/m:StatusCode"/>
								<xsl:choose>
									<xsl:when test="$C='nytbrev' ">N</xsl:when>
									<xsl:when test="$C='rettetbrev' ">M</xsl:when>
									<xsl:when test="$C='annulleretbrev' ">C</xsl:when>
									<xsl:otherwise>
										<FEJL>
											Kan ikke oversaette fra StatusCode til GIS: <xsl:value-of select="$C"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
					</GIS>
					<GIS>
						<Elm>
							<SubElm>P</SubElm>
						</Elm>
					</GIS>
					<RFF>
						<Elm>
							<SubElm>ADY</SubElm>
							<SubElm>0<!--<xsl:value-of select="$Letter/m:Identifier"/>-->
							</SubElm>
						</Elm>
					</RFF>
					<RFF>
						<Elm>
							<SubElm>REI</SubElm>
							<SubElm>
								<xsl:value-of select="$Letter/m:NotificationIdentifier"/>
							</SubElm>
						</Elm>
					</RFF>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>1</SubElm>
						</Elm>
					</SEQ>
				</S11>
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
