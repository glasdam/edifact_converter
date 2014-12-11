<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- DISCHARGELETTER -->
	<xsl:template match="m:HospitalReferral">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Referrer" select="$Sender/m:Referrer"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="AnswerCCReceiver" select="m:AnswerCCReceiver"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="Relatives" select="m:Relative"/>
		<xsl:variable name="AddInfo" select="m:AdditionalInformation"/>
		<xsl:variable name="Referral" select="m:Referral"/>
		<xsl:variable name="RefDiag" select="$Referral/m:Refer"/>
		<xsl:variable name="RefAddDiags" select="$Referral/m:ReferralAdditional"/>
		<xsl:variable name="RelClinInfo" select="m:RelevantClinicalInformation"/>
		<xsl:variable name="Cave" select="$RelClinInfo/m:Cave"/>
		<xsl:variable name="Anamnesis" select="$RelClinInfo/m:Anamnesis"/>
		<xsl:variable name="Examination" select="$RelClinInfo/m:Examination"/>
		<xsl:variable name="ActMedicine" select="$RelClinInfo/m:ActualMedicine"/>
		<xsl:variable name="Refs" select="m:Reference"/>
		<xsl:variable name="HospVisi" select="m:HospitalVisitation"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>MEDREF</SubElm>
					<SubElm>D</SubElm>
					<SubElm>93A</SubElm>
					<SubElm>UN</SubElm>
					<SubElm>H0130R</SubElm>
				</Elm>
				<Elm>
					<SubElm>REF01</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>HNV</SubElm>
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
									<xsl:if test="count($Adr/m:StreetName)=0">_</xsl:if>
									<xsl:value-of select="$Adr/m:StreetName"/>
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
							<SubElm>REF01</SubElm>
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
									<xsl:if test="count($Adr/m:StreetName)=0">_</xsl:if>
									<xsl:value-of select="$Adr/m:StreetName"/>
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
				<!--Henviser -->
				<S01>
					<xsl:variable name="Participant" select="$Referrer"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>BV</SubElm>
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
									<xsl:when test="count($IC)=0 and count($Participant/m:Identifier)>0">9</xsl:when>
									<xsl:when test="count($IC)=0 and count($Participant/m:Identifier)=0"></xsl:when>
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
								<xsl:value-of select="$Participant/m:PersonTitle"/>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:PersonName"/>
							</SubElm>
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
							<SubElm>3</SubElm>
						</Elm>
					</SEQ>
				</S01>
				<!-- AnswerCCReceiver -->
				<xsl:if test="count($AnswerCCReceiver)=1">
					<S01>
						<xsl:variable name="Participant" select="$AnswerCCReceiver"/>
						<Elm>
							<SubElm>01</SubElm>
						</Elm>
						<NAD>
							<Elm>
								<SubElm>PRH</SubElm>
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
						<!-- Standard for ADR segments -->
						<xsl:variable name="Adr" select="$Participant"/>
						<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:DistrictName)+count($Adr/m:PostCodeIdentifier)>0">
							<ADR>
								<Elm/>
								<Elm>
									<SubElm>US</SubElm>
									<SubElm>
										<xsl:if test="count($Adr/m:StreetName)=0">_</xsl:if>
										<xsl:value-of select="$Adr/m:StreetName"/>
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
								<SubElm>4</SubElm>
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
							<SubElm>N</SubElm>
						</Elm>
					</GIS>
					<RFF>
						<Elm>
							<SubElm>ROI</SubElm>
							<SubElm>
								<xsl:if test="count($Letter/m:EpisodeOfCareIdentifier)=0">_</xsl:if>
								<xsl:value-of select="$Letter/m:EpisodeOfCareIdentifier"/>
							</SubElm>
						</Elm>
					</RFF>
					<DTM>
						<Elm>
							<SubElm>4</SubElm>
							<SubElm>
								<xsl:call-template name="DateTimeToDTM203">
									<xsl:with-param name="DT" select="$Letter/m:Authorisation"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
					<!--DIAGNOSER!-->
					<xsl:if test="count($RefDiag)=1">
						<CIN>
							<xsl:variable name="Diagnose" select="$RefDiag"/>
							<Elm>
								<SubElm>H</SubElm>
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
									<!--
								<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
								<xsl:choose>
									<xsl:when test="$DTC='SKSdiagnosekode' ">SST</xsl:when>
									<xsl:when test="$DTC='uspecificeretkode' "/>
									<xsl:when test="$DTC='ICPCkode' "/>
									<xsl:otherwise>
										<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>-->
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:if>
					<xsl:for-each select="$RefAddDiags">
						<CIN>
							<xsl:variable name="Diagnose" select="."/>
							<Elm>
								<!--RET TIL EN LISTE -->
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
											<FEJL>Ukendt DiagnoseDescriptionCode: <xsl:value-of select="$Desc"/>
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
									<!--
									<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SST</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' "/>
										<xsl:when test="$DTC='ICPCkode' "/>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>-->
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:for-each>
					<!--Henvisningsårsag-->
					<xsl:if test="$AddInfo/m:ClinicalReason">
						<XFTX>
							<Elm>
								<SubElm>DI</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="$AddInfo/m:ClinicalReason/text()|$AddInfo/m:ClinicalReason/*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</xsl:if>
				</S02>
				<!-- Referral -->
				<S06>
					<Elm>
						<SubElm>06</SubElm>
					</Elm>
					<STS>
						<Elm/>
						<Elm>
							<SubElm>NR</SubElm>
						</Elm>
					</STS>
				</S06>
				<S07>
					<xsl:if test="count($Patient//m:CivilRegistrationNumber)=1 and count($Patient/m:AlternativeIdentifier)=1">
						<FEJL>Patient kan ikke både have et CivilRegistrationNumber og et AlternativeIdentifier</FEJL>
					</xsl:if>
					<xsl:if test="count($Patient//m:CivilRegistrationNumber)=0 and count($Patient/m:AlternativeIdentifier)=0">
						<FEJL>Patient skal have et CivilRegistrationNumber eller et AlternativeIdentifier</FEJL>
					</xsl:if>
					<xsl:variable name="Participant" select="$Patient"/>
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
									<xsl:if test="count($Adr/m:StreetName)=0">_</xsl:if>
									<xsl:value-of select="$Adr/m:StreetName"/>
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
					<xsl:if test="count($Participant/m:TelephoneSubscriberIdentifier)>=1">
						<CON>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Participant/m:TelephoneSubscriberIdentifier[1]"/>
								</SubElm>
								<SubElm>TE</SubElm>
							</Elm>
						</CON>
					</xsl:if>
					<xsl:if test="count($Participant/m:TelephoneSubscriberIdentifier)>=2">
						<CON>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Participant/m:TelephoneSubscriberIdentifier[2]"/>
								</SubElm>
								<SubElm>TE</SubElm>
							</Elm>
						</CON>
					</xsl:if>
				</S07>
				<xsl:for-each select="$Relatives">
					<S10>
						<xsl:variable name="Person" select="."/>
						<Elm>
							<SubElm>10</SubElm>
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
								<SubElm/>
								<SubElm/>
								<SubElm>CPR</SubElm>
								<SubElm>IM</SubElm>
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
					</S10>
				</xsl:for-each>
				<S12 maxOccurs="2">
					<Elm>
						<SubElm>12</SubElm>
					</Elm>
					<XFTX maxOccurs="9" comparable="false">
						<xsl:if test="count($Anamnesis)=1">
							<Elm>
								<SubElm>NC</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="$Anamnesis/text()|$Anamnesis/*"/>
								</SubElm>
							</Elm>
						</xsl:if>
						<xsl:if test="count($Examination)=1">
							<Elm>
								<SubElm>CF</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="$Examination/text()|$Examination/*"/>
								</SubElm>
							</Elm>
						</xsl:if>
						<!--	<xsl:if test="count($Pregnancy)=1">  KUN TILLADT I RØNTGEN
							<Elm><SubElm>PR</SubElm></Elm>
							<Elm/>
							<Elm/>
							<Elm><SubElm><xsl:copy-of select="$Pregnancy/text()|$Pregnancy/*"/></SubElm></Elm>
						</xsl:if>-->
						<xsl:if test="count($ActMedicine)=1">
							<Elm>
								<SubElm>MT</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="$ActMedicine/text()|$ActMedicine/*"/>
								</SubElm>
							</Elm>
						</xsl:if>
						<xsl:if test="count($Cave)=1">
							<Elm>
								<SubElm>AL</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="$Cave/text()|$Cave/*"/>
								</SubElm>
							</Elm>
						</xsl:if>
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
				</S12>
				<S18>
					<Elm>
						<SubElm>18</SubElm>
					</Elm>
					<GIS>
						<Elm>
							<SubElm>N</SubElm>
						</Elm>
					</GIS>
					<xsl:if test="count($AddInfo/m:Priority)=1">
						<PTY>
							<Elm>
								<SubElm>PRI</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="P" select="$AddInfo/m:Priority"/>
									<xsl:choose>
										<xsl:when test="$P='elektiv' ">WA</xsl:when>
										<xsl:when test="$P='akut' ">AC</xsl:when>
										<xsl:when test="$P='saerlige_forhold' ">SA</xsl:when>
										<xsl:otherwise>
											<FEJL>
									Kan ikke oversaette Prioritet: <xsl:value-of select="$P"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</PTY>
					</xsl:if>
					<xsl:for-each select="$HospVisi">
						<XFTX>
							<Elm>
								<SubElm>
									<xsl:variable name="HVC" select="m:InformationCode"/>
									<xsl:choose>
										<xsl:when test="$HVC='ustruktureret' ">US</xsl:when>
										<xsl:when test="$HVC='egen_laege' ">EL</xsl:when>
										<xsl:when test="$HVC='henvisning_modtaget' ">HV</xsl:when>
										<xsl:when test="$HVC='visitering' ">VI</xsl:when>
										<xsl:when test="$HVC='indkaldt' ">IK</xsl:when>
										<xsl:when test="$HVC='indlagt_paa' ">AF</xsl:when>
										<xsl:when test="$HVC='udenamts_kaution' ">UA</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte InformationCode: <xsl:value-of select="$HVC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="m:Information/text()|m:Information/*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</xsl:for-each>
					<xsl:if test="count($AddInfo/m:ReferralStatus)=1">
						<PAS>
							<Elm>
								<SubElm>
									<xsl:variable name="RS" select="$AddInfo/m:ReferralStatus"/>
									<xsl:choose>
										<xsl:when test="$RS='ambulant' ">HA</xsl:when>
										<xsl:when test="$RS='indlaeggelse' ">HS</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte ReferralStatus: <xsl:value-of select="$RS"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</PAS>
					</xsl:if>
				</S18>
				<S19>
					<Elm>
						<SubElm>19</SubElm>
					</Elm>
					<STS>
						<Elm/>
						<Elm>
							<SubElm>NR</SubElm>
						</Elm>
					</STS>
					<xsl:if test="count($AddInfo/m:Transport)=1">
						<TDT>
							<Elm>
								<SubElm>PHL</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:variable name="T" select="$AddInfo/m:Transport"/>
									<xsl:choose>
										<xsl:when test="$T='ingen' ">TX</xsl:when>
										<xsl:when test="$T='liggende' ">ST</xsl:when>
										<xsl:when test="$T='siddende' ">SI</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte ReferralStatus: <xsl:value-of select="$T"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</TDT>
					</xsl:if>
					<xsl:if test="count($AddInfo/m:Supplementary)=1">
						<XFTX>
							<Elm>
								<SubElm>COT</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="$AddInfo/m:Supplementary/text()|$AddInfo/m:Supplementary/*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</xsl:if>
				</S19>
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
