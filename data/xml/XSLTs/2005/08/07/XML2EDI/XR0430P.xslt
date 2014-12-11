<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/" version="1.0">
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="m:HistopathologyReport">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Examinator" select="$Sender/m:Examinator"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="RPhysician" select="$Receiver/m:Physician"/>
		<xsl:variable name="CCReceiver" select="m:CCReceiver"/>
		<xsl:variable name="CCRPhysician" select="$CCReceiver/m:Physician"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="Relative" select="m:Relative"/>
		<xsl:variable name="ReqInfo" select="m:RequisitionInformation"/>
		<xsl:variable name="LabResults" select="m:LaboratoryResults"/>
		<xsl:variable name="GeneralResultInformation" select="$LabResults/m:GeneralResultInformation"/>
		<xsl:variable name="CodedFormat" select="$LabResults/m:CodedFormat"/>
		<xsl:variable name="Samples" select="$CodedFormat/m:Sample"/>
		<xsl:variable name="TableFormat" select="$LabResults/m:TableFormat"/>
		<xsl:variable name="TextualFormat" select="$LabResults/m:TextualFormat"/>
		<xsl:variable name="Macroscopic" select="$TextualFormat/m:Macroscopic"/>
		<xsl:variable name="Microscopic" select="$TextualFormat/m:Microscopic"/>
		<xsl:variable name="Conclusion" select="$TextualFormat/m:Conclusion"/>
		<xsl:variable name="Hematology" select="$TextualFormat/m:Hematology"/>
		<xsl:variable name="Comments" select="$TextualFormat/m:Comments"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>MEDRPT</SubElm>
					<SubElm>D</SubElm>
					<SubElm>93A</SubElm>
					<SubElm>UN</SubElm>
					<SubElm>R0430P</SubElm>
				</Elm>
				<Elm>
					<SubElm>RPT04</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>LRP</SubElm>
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
								<xsl:value-of select="$Participant/m:OrganisationName"/>
								<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:DepartmentName"/>
								<xsl:if test="count($Participant/m:DepartmentName)=0 and count($Participant/m:UnitName)>0">_</xsl:if>
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
							<SubElm>RPT04</SubElm>
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
								<xsl:value-of select="$Participant/m:OrganisationName"/>
								<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:DepartmentName"/>
								<xsl:if test="count($Participant/m:DepartmentName)=0 and count($Participant/m:UnitName)>0">_</xsl:if>
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
									<xsl:if test="count($Participant/m:DepartmentName)=0 and count($Participant/m:UnitName)>0">_</xsl:if>
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
				<xsl:if test="count($Examinator)=1">
					<S01>
						<xsl:variable name="Participant" select="$Examinator"/>
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
									<xsl:if test="count($CCReceiver)=0">3</xsl:if>
									<xsl:if test="count($CCReceiver)=1">4</xsl:if>
								</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				<xsl:if test="count($RPhysician)=1">
					<S01>
						<xsl:variable name="Participant" select="$RPhysician"/>
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
								<SubElm>2</SubElm>
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
				</xsl:if>
				<xsl:if test="count($CCRPhysician)=1">
					<S01>
						<xsl:variable name="Participant" select="$CCRPhysician"/>
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
								<SubElm>2</SubElm>
							</Elm>
						</RFF>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>6</SubElm>
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
							<SubElm>SRI</SubElm>
							<SubElm>
								<xsl:value-of select="$GeneralResultInformation/m:LaboratoryInternalProductionIdentifier"/>
							</SubElm>
						</Elm>
					</RFF>
					<STS>
						<Elm/>
						<Elm>
							<SubElm>K</SubElm>
						</Elm>
					</STS>
					<DTM>
						<Elm>
							<SubElm>ISR</SubElm>
							<SubElm>
								<xsl:call-template name="DateTimeToDTM203">
									<xsl:with-param name="DT" select="$Letter/m:Authorisation"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
					<xsl:if test="count($ReqInfo/m:Comments)=1">
						<XFTX maxOccurs="1">
							<Elm>
								<SubElm>SPC</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="$ReqInfo/m:Comments/text()|$ReqInfo/m:Comments/*"/>
								</SubElm>
							</Elm>
						</XFTX>
					</xsl:if>
				</S02>
				<S04>
					<Elm>
						<SubElm>04</SubElm>
					</Elm>
					<xsl:for-each select="$ReqInfo/m:RequestersRequisitionIdentifier">
						<RFF>
							<Elm>
								<SubElm>ROI</SubElm>
								<SubElm>
									<xsl:value-of select="."/>
								</SubElm>
							</Elm>
						</RFF>
					</xsl:for-each>
					<RFF>
						<Elm>
							<SubElm>SOI</SubElm>
							<SubElm>
								<xsl:value-of select="$ReqInfo/m:ReceiversRequisitionIdentifier"/>
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
					<DTM>
						<Elm>
							<SubElm>8</SubElm>
							<SubElm>
								<xsl:call-template name="DateTimeToDTM203">
									<xsl:with-param name="DT" select="$ReqInfo/m:SampleReceivedDateTime"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
				</S04>
				<S06>
					<Elm>
						<SubElm>06</SubElm>
					</Elm>
					<xsl:variable name="Person" select="$Patient"/>
					<xsl:variable name="Adr" select="$Person"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm>
								<SubElm/>
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
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr//m:MunicipalityId"/>
								</SubElm>
								<SubElm>KOM</SubElm>
								<SubElm>IM</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr//m:MunicipalityName"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>
				</S06>
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
					<xsl:if test="(count($Patient/m:Consent)=1) and ($Patient/m:Consent/m:Given='true') ">
						<HAN>
							<Elm>
								<SubElm>CDS</SubElm>
								<SubElm>SKS</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>
									<xsl:value-of select="$Patient/m:Consent/m:Text"/>
								</SubElm>
							</Elm>
						</HAN>
					</xsl:if>
				</S07>
				<xsl:if test="count($Relative)=1">
					<S07>
						<xsl:variable name="Person" select="$Relative"/>
						<Elm>
							<SubElm>07</SubElm>
						</Elm>
						<PNA>
							<Elm>
								<SubElm>PER</SubElm>
							</Elm>
							<Elm>
								<xsl:if test="count($Person/m:PersonIdentifier)=1">
									<SubElm>
										<xsl:value-of select="$Person/m:PersonIdentifier"/>
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
									<xsl:variable name="RC" select="$Person/m:RelationCode"/>
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
					</S07>
				</xsl:if>
			  <xsl:if test="count($ReqInfo/m:ClinicalInformation | $ReqInfo/m:Reference)>0">
					<S10>
						<Elm>
							<SubElm>10</SubElm>
						</Elm>
						<XFTX maxOccurs="3">
							<Elm>
								<SubElm>CID</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:copy-of select="$ReqInfo/m:ClinicalInformation/text()|$ReqInfo/m:ClinicalInformation/*"/>
								</SubElm>
							</Elm>
						</XFTX>
					  <xsl:for-each select="$ReqInfo/m:Reference">
					      <xsl:call-template name="Ref2Ftx"/>
					  </xsl:for-each>
					</S10>
				</xsl:if>
				<xsl:for-each select="$Samples">
					<xsl:variable name="pos" select="position()"/>
					<S16>
						<Elm>
							<SubElm>16</SubElm>
						</Elm>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$pos"/>
								</SubElm>
							</Elm>
						</SEQ>
						<SPC>
							<Elm>
								<SubElm>SCI</SubElm>
							</Elm>
							<Elm>
								<SubElm>ATT</SubElm>
							</Elm>
						</SPC>
						<xsl:if test="count(m:RequesterSampleIdentifier)=1">
							<RFF>
								<Elm>
									<SubElm>RTI</SubElm>
									<SubElm>
										<xsl:value-of select="m:RequesterSampleIdentifier"/>
									</SubElm>
								</Elm>
							</RFF>
						</xsl:if>
						<RFF>
							<Elm>
								<SubElm>STI</SubElm>
								<SubElm>
									<xsl:value-of select="m:LaboratoryInternalSampleIdentifier"/>
								</SubElm>
							</Elm>
						</RFF>
						<FTX>
							<Elm>
								<SubElm>SRC</SubElm>
							</Elm>
							<Elm>
								<SubElm>P00</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:MaterialDescription"/>
								</SubElm>
							</Elm>
						</FTX>
					</S16>
				</xsl:for-each>
				<S18 hidden="true">
					<GIS>
						<Elm>
							<SubElm>
								<xsl:variable name="RSC" select="$GeneralResultInformation/m:ResultStatusCode"/>
								<xsl:choose>
									<xsl:when test="$RSC='svar_endeligt' or $RSC='svar_midlertidigt' or $RSC='proeve_modtaget' ">N</xsl:when>
									<xsl:when test="$RSC='svar_rettet' ">M</xsl:when>
									<xsl:otherwise>
										<FEJL>ukendt ResultStatusCode: <xsl:value-of select="$RSC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
					</GIS>
					<INV>
						<Elm>
							<SubElm>OE</SubElm>
						</Elm>
						<Elm>
							<SubElm/>
							<SubElm/>
							<SubElm/>
							<SubElm>
								<xsl:value-of select="$TableFormat/m:ResultHeadline"/>
							</SubElm>
						</Elm>
					</INV>
					<RSL>
						<Elm>
							<SubElm>AV</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$TableFormat/m:TableResult"/>
							</SubElm>
						</Elm>
					</RSL>
					<STS>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:variable name="RSC" select="$GeneralResultInformation/m:ResultStatusCode"/>
								<xsl:choose>
									<xsl:when test="$RSC='svar_endeligt' or $RSC='svar_rettet' ">FR</xsl:when>
									<xsl:when test="$RSC='svar_modtaget' or $RSC='svar_midlertidigt' ">PR</xsl:when>
									<!--	<xsl:when test="$RSC='MR' ">modificeret</xsl:when>-->
									<xsl:otherwise>
										<FEJL>Kan ikke oversætte ResultsStatusCode: <xsl:value-of select="$RSC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
					</STS>
				</S18>
				<xsl:for-each select="$Samples">
					<xsl:variable name="pos" select="position()"/>
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<xsl:if test="$pos=1">
							<INV>
								<Elm>
									<SubElm>OE</SubElm>
								</Elm>
								<Elm>
									<SubElm/>
									<SubElm/>
									<SubElm/>
									<SubElm>
										<xsl:value-of select="$CodedFormat/m:DiagnosisHeadline"/>
									</SubElm>
								</Elm>
							</INV>
						</xsl:if>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:CodedResults/m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
					</S18>
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<xsl:for-each select="m:CodedResults/m:Topography">
							<CIN>
								<Elm>
									<SubElm>CCI</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:Code"/>
									</SubElm>
									<SubElm>SNO</SubElm>
									<SubElm>SST</SubElm>
									<SubElm>
										<xsl:value-of select="m:Text"/>
									</SubElm>
								</Elm>
							</CIN>
							<xsl:if test="count(m:Comment)=1">
								<CIN>
									<Elm>
										<SubElm>SPC</SubElm>
									</Elm>
									<Elm>
										<SubElm/>
										<SubElm/>
										<SubElm/>
										<SubElm>
											<xsl:value-of select="m:Comment"/>
										</SubElm>
									</Elm>
								</CIN>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="m:CodedResults/m:Result">
							<CIN>
								<Elm>
									<SubElm>CCI</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:Code"/>
									</SubElm>
									<SubElm>SNO</SubElm>
									<SubElm>SST</SubElm>
									<SubElm>
										<xsl:value-of select="m:Text"/>
									</SubElm>
								</Elm>
							</CIN>
							<xsl:if test="count(m:Comment)=1">
								<CIN>
									<Elm>
										<SubElm>SPC</SubElm>
									</Elm>
									<Elm>
										<SubElm/>
										<SubElm/>
										<SubElm/>
										<SubElm>
											<xsl:value-of select="m:Comment"/>
										</SubElm>
									</Elm>
								</CIN>
							</xsl:if>
						</xsl:for-each>
						<INV>
							<Elm>
								<SubElm>NR</SubElm>
							</Elm>
						</INV>
						<RFF>
							<Elm>
								<SubElm>ASL</SubElm>
								<SubElm>
									<xsl:value-of select="$pos"/>
								</SubElm>
							</Elm>
						</RFF>
					</S18>
				</xsl:for-each>
				<xsl:for-each select="$Macroscopic">
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
						<xsl:for-each select="m:Text">
							<XFTX maxOccurs="100">
								<Elm>
									<SubElm>MAC</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="./text()|./*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:for-each>
					  <xsl:for-each select="m:Reference">
					    <xsl:call-template name="Ref2Ftx"/>
					  </xsl:for-each>
					</S18>
				</xsl:for-each>
				<xsl:for-each select="$Microscopic">
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
						<xsl:for-each select="m:Text">
							<XFTX maxOccurs="100">
								<Elm>
									<SubElm>MIC</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="./text()|./*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:for-each>
					  <xsl:for-each select="m:Reference">
					    <xsl:call-template name="Ref2Ftx"/>
					  </xsl:for-each>
					    <!--<XFTX>
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
					    </XFTX>-->
					    <!--FTX+BIN+P00++Der vedlægges et billed.jpg:010772-4869_021121SKR0XX0166OBJ001:IMG:JPG:296279'-->
					</S18>
				</xsl:for-each>
				<xsl:for-each select="$Conclusion">
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
						<xsl:for-each select="m:Text">
							<XFTX maxOccurs="30">
								<Elm>
									<SubElm>KON</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="./text()|./*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:for-each>
					</S18>
				</xsl:for-each>
				<xsl:for-each select="$Hematology">
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
					  <FTX>
					    <Elm>
					      <SubElm>HEM</SubElm>
					    </Elm>
					    <Elm>
					      <SubElm>F00</SubElm>
					    </Elm>
					    <Elm/>
					    <Elm>
					      <SubElm>
					        <xsl:for-each select="m:Labels/m:CellTypes">
					          <xsl:call-template name="FIXEDWIDTH"/>
					        </xsl:for-each>
					        <xsl:for-each select="m:Labels/m:Marrow">
					          <xsl:call-template name="FIXEDWIDTH">
					            <xsl:with-param name="length" select="12"/>
					          </xsl:call-template>
					        </xsl:for-each>
					        <xsl:for-each select="m:Labels/m:Peripheral">
					          <xsl:value-of select="text()"/>
					        </xsl:for-each>
					      </SubElm>
					    </Elm>
					  </FTX>
						<xsl:for-each select="m:Result">
							<FTX>
								<Elm>
									<SubElm>HEM</SubElm>
								</Elm>
								<Elm>
									<SubElm>F00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
									  <xsl:for-each select="m:CellType">
									    <xsl:call-template name="FIXEDWIDTH"/>
									  </xsl:for-each>
									  <xsl:for-each select="m:Marrow">
									    <xsl:call-template name="FIXEDWIDTH">
									      <xsl:with-param name="length" select="12"/>
									    </xsl:call-template>
									  </xsl:for-each>
									  <xsl:for-each select="m:Peripheral">
									    <xsl:value-of select="text()"/>
									  </xsl:for-each>
									</SubElm>
								</Elm>
							</FTX>
						</xsl:for-each>
					  <!-- 
						<xsl:for-each select="m:CellTypesPercentage">
							<FTX>
								<Elm>
									<SubElm>HEM</SubElm>
								</Elm>
								<Elm>
									<SubElm>F00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="."/>
									</SubElm>
								</Elm>
							</FTX>
						</xsl:for-each>
					  -->
					</S18>
				</xsl:for-each>
				<xsl:for-each select="$Comments">
					<S18 hidden="true">
						<GIS>
							<Elm>
								<SubElm>N</SubElm>
							</Elm>
						</GIS>
						<INV>
							<Elm>
								<SubElm>OE</SubElm>
							</Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="m:Headline"/>
								</SubElm>
							</Elm>
						</INV>
						<xsl:for-each select="m:Text">
							<XFTX maxOccurs="1">
								<Elm>
									<SubElm>SPC</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:copy-of select="./text()|./*"/>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:for-each>
					</S18>
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
  
  <xsl:template name="FIXEDWIDTH">
    <xsl:param name="length" select="40"/>
    <xsl:variable name="spaces" select="'                                                                                             '"/>
    <xsl:value-of select="substring(concat(text(), $spaces), 1, $length)"/>
  </xsl:template>
  
  <xsl:template name="Ref2Ftx">
    <XFTX>
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
    </XFTX>
  </xsl:template>
</xsl:stylesheet>
