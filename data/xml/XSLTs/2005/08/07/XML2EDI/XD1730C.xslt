<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- NOTIFICATIONOFDISCHARGE -->
	<xsl:template match="m:NotificationOfDischarge">
		<!--<xsl:if test="$Envelope/m:AcknowledgementCode!='minuspositivkvitt' ">
			<FEJL>AcknowledgementCode kan kun være 'minuspositivkvitt' i NotifacationOfDischarge breve</FEJL>
		</xsl:if>-->
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="AnswerTo" select="$Sender/m:AnswerTo"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="Discharge" select="m:Discharge"/>
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
					<SubElm>D1730C</SubElm>
				</Elm>
				<Elm>
					<SubElm>DIS17</SubElm>
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
					<xsl:if test="count($Participant/m:TelephoneSubscriberIdentifier)>0">
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
					<RFF>
						<Elm>
							<SubElm>LOC</SubElm>
							<SubElm>
								<xsl:value-of select="$AnswerTo/m:EANIdentifier"/>
							</SubElm>
						</Elm>
					</RFF>
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
					  <Elm/>
						<Elm>
							<SubElm>DIS17</SubElm>
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
							<SubElm>ROR</SubElm>
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
					<DTM>
						<Elm>
							<SubElm>90</SubElm>
							<SubElm>
								<xsl:for-each select="$Discharge">
									<xsl:call-template name="DateTimeToDTM203"/>
								</xsl:for-each>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
					<PAS>
						<Elm>
							<SubElm>
								<xsl:variable name="EOCSC" select="$Patient/m:EpisodeOfCareStatusCode"/>
								<xsl:choose>
									<!--<xsl:when test="count($EOCSC)=0 ">POT</xsl:when>
										<xsl:when test="$EOCSC='inaktiv' ">POT</xsl:when>
										<xsl:when test="$EOCSC='indlagt' ">HS</xsl:when>
										<xsl:when test="$EOCSC='ambulant' ">HA</xsl:when>
										<xsl:when test="$EOCSC='doed' ">DA</xsl:when>
										<xsl:when test="$EOCSC='ambulant_roentgen' ">REQ</xsl:when>-->
									<xsl:when test="$EOCSC='udskrevet_til_hjemmet' ">DH</xsl:when>
									<xsl:when test="$EOCSC='udskrevet_til_andet' ">DX</xsl:when>
									<xsl:when test="$EOCSC='flyttet_til_sygehusafd' ">MW</xsl:when>
									<xsl:when test="$EOCSC='uoplyst' ">UP</xsl:when>
									<xsl:when test="$EOCSC='flyttet_til_sygehus' ">MH</xsl:when>
									<xsl:when test="$EOCSC='doed' ">DE</xsl:when>
									<xsl:otherwise>
										<FEJL>Kan ikke oversaette til EpisodeOfCareStatusCode: <xsl:value-of select="$EOCSC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
					</PAS>
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
