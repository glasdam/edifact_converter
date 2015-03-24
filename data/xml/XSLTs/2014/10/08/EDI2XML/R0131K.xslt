<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/medcom.dk/xml/schemas/2014/10/08/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRPT' and SubElm[5]='R0131K']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SLA']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01CCReceiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='CCR']"/>
		<xsl:variable name="S01RPhysician" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV' and RFF/Elm[1]/SubElm[2]='2']"/>
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<xsl:variable name="S02Answer" select="BrevIndhold/S02"/>
		<xsl:variable name="S04Sample" select="BrevIndhold/S04"/>
		<xsl:variable name="DocRekvNrRFF" select="$S04Sample/RFF[Elm[1]/SubElm[1]='ROI']"/>
		<xsl:variable name="LabRekvNrRFF" select="$S04Sample/RFF[Elm[1]/SubElm[1]='SOI']"/>
		<xsl:variable name="SamplingDTM" select="$S04Sample/DTM[Elm[1]/SubElm[1]='4']"/>
		<xsl:variable name="SampleRecDTM" select="$S04Sample/DTM[Elm[1]/SubElm[1]='8']"/>
		<xsl:variable name="S06Patient" select="BrevIndhold/S06"/>
		<xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
		<xsl:variable name="S16Sample" select="BrevIndhold/S16"/>
		<xsl:variable name="S18Result" select="BrevIndhold/S18"/>
		<!--
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S05'  or name()='S07' or name()='S09'  or name()='S11'  or name()='S14')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='SSP' or NAD/Elm[1]/SubElm[1]='PO' or NAD/Elm[1]/SubElm[1]='CCR' or NAD/Elm[1]/SubElm[1]='RSP')]
												|	BrevIndhold/S14[not(CIN or FTX)]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>-->
		<LaboratoryReport>
			<xsl:for-each select="$S02LetterInfo">
				<Letter>
					<Identifier>
						<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
					</Identifier>
					<VersionCode>XR0131K</VersionCode>
					<StatisticalCode>XRPT01</StatisticalCode>
					<xsl:for-each select="$Dtm">
						<Authorisation>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Authorisation>
					</xsl:for-each>
					<TypeCode>XRPT01</TypeCode>
				</Letter>
			</xsl:for-each>
			<xsl:for-each select="$S01Sender">
				<Sender>
					<EANIdentifier>
						<xsl:value-of select="$SenderEAN"/>
					</EANIdentifier>
					<xsl:for-each select="NAD">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCodeOrLocal"/>
						<xsl:call-template name="NADToOrganisationName"/>
						<xsl:call-template name="NADToDepartmentName"/>
						<xsl:call-template name="NADToUnitName"/>
					</xsl:for-each>
					<xsl:for-each select="SPR">
						<xsl:call-template name="SPRToMedicalSpecialityCode"/>
					</xsl:for-each>
					<xsl:for-each select="RFF">
						<FromLabIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</FromLabIdentifier>
					</xsl:for-each>	
				</Sender>
			</xsl:for-each>
			<xsl:for-each select="$S01Receiver">
				<Receiver>
					<EANIdentifier>
						<xsl:value-of select="$ReceiverEAN"/>
					</EANIdentifier>
					<xsl:for-each select="NAD">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCodeOrLocal"/>
						<xsl:call-template name="NADToOrganisationName"/>
						<xsl:call-template name="NADToDepartmentName"/>
						<xsl:call-template name="NADToUnitName"/>
					</xsl:for-each>
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="$S01RPhysician">
						<Physician>
							<xsl:for-each select="NAD">
								<xsl:call-template name="NADToPersonInitials"/>
							</xsl:for-each>
						</Physician>
					</xsl:for-each>
				</Receiver>
			</xsl:for-each>
			<xsl:for-each select="$S01CCReceiver">
				<CCReceiver>
					<xsl:for-each select="NAD">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCodeOrLocal"/>
						<xsl:call-template name="NADToOrganisationName"/>
						<xsl:call-template name="NADToDepartmentName"/>
					</xsl:for-each>
				</CCReceiver>
			</xsl:for-each>
			<Patient>
				<xsl:for-each select="$S07Patient">
					<xsl:if test="count(RFF)=0 and PNA/Elm[2]/SubElm[1]='' ">
						<FEJL>En patient skal enten have et lovligt cpr eller et alternativt ID</FEJL>
					</xsl:if>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNAToCivilRegistrationNumber"/>
					</xsl:for-each>
					<xsl:for-each select="RFF">
						<xsl:call-template name="RFFToAlternativeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNAToPersonSurnameName"/>
						<xsl:call-template name="PNAToPersonGivenName"/>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="$S06Patient">
					<!--
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
						<xsl:call-template name="ADRToMunicipalityId"/>
						<xsl:call-template name="ADRToMunicipalityName"/>
					</xsl:for-each>
					-->
					<xsl:for-each select="$S07Patient">
						<xsl:for-each select="HAN">
							<Consent>
								<Given>false</Given>
							</Consent>
						</xsl:for-each>
						<xsl:if test="count(HAN)=0">
							<Consent>
								<Given>true</Given>
							</Consent>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</Patient>
			<RequisitionInformation>
				<xsl:for-each select="$S02LetterInfo">
					<xsl:for-each select="FTX[Elm[1]/SubElm[1]='SPC']">
						<Comments>
							<xsl:call-template name="FTXSegmentsToBreakableText">
								<xsl:with-param name="FTXSegments" select="."/>
							</xsl:call-template>
						</Comments>
					</xsl:for-each>
				</xsl:for-each>
				<Sample>
					<xsl:for-each select="$LabRekvNrRFF">
						<LaboratoryInternalSampleIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</LaboratoryInternalSampleIdentifier>
					</xsl:for-each>
					<xsl:for-each select="$DocRekvNrRFF">
						<RequesterSampleIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</RequesterSampleIdentifier>
					</xsl:for-each>
					<xsl:for-each select="$SamplingDTM">
						<SamplingDateTime>
							<xsl:call-template name="DTM203ToDateTime"/>
						</SamplingDateTime>
					</xsl:for-each>
					<xsl:for-each select="$S16Sample/QTY">
						<xsl:if test="Elm[1]/SubElm[2]!='' ">
							<Volume>
								<xsl:value-of select="Elm[1]/SubElm[2]"/>
							</Volume>
						</xsl:if>
						<xsl:if test="Elm[2]/SubElm[1]!='' ">
							<UnitOfVolume>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</UnitOfVolume>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="count($S16Sample/DTM)>0">
						<SamplingInterval>
							<xsl:for-each select="$S16Sample/DTM[Elm[1]/SubElm[1]='SCS'] ">
								<StartDateTime>
									<xsl:call-template name="DTM203ToDateTime"/>
								</StartDateTime>
							</xsl:for-each>
							<xsl:for-each select="$S16Sample/DTM[Elm[1]/SubElm[1]='SCE'] ">
								<EndDateTime>
									<xsl:call-template name="DTM203ToDateTime"/>
								</EndDateTime>
							</xsl:for-each>
						</SamplingInterval>
					</xsl:if>
				</Sample>
			</RequisitionInformation>
			<LaboratoryResults>
				<GeneralResultInformation>
					<ReportStatusCode>
						<xsl:variable name="SStatC" select="$S02LetterInfo/STS/Elm[2]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$SStatC='K'">komplet_svar</xsl:when>
							<xsl:when test="$SStatC='D'">del_svar</xsl:when>
							<xsl:when test="$SStatC='M'">modtaget</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="Error">
									<xsl:with-param name="Node" select="$SStatC"/>
									<xsl:with-param name="Text">Kan ikke overætte fra STATUS:<xsl:value-of select="$SStatC"/> til ReportStatusCode
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</ReportStatusCode>
					<xsl:for-each select="$S02Answer/RFF">
						<LaboratoryInternalProductionIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</LaboratoryInternalProductionIdentifier>
					</xsl:for-each>
					<xsl:for-each select="$S02Answer/DTM">
						<ResultsDateTime>
							<xsl:call-template name="DTM203ToDateTime"/>
						</ResultsDateTime>
					</xsl:for-each>
				</GeneralResultInformation>
				<xsl:for-each select="$S18Result">
					<Result>
						<ResultStatusCode>
							<xsl:variable name="RStatC" select="GIS/Elm[1]/SubElm[1]"/>
							<xsl:variable name="RServC" select="STS/Elm[2]/SubElm[1]"/>
							<xsl:variable name="IsTemp" select="RSL//Elm[2]/SubElm[1]='*****'"/>
							<xsl:choose>
								<xsl:when test="$RStatC='N' and $RServC='FR' ">svar_endeligt</xsl:when>
								<xsl:when test="$RStatC='M' and $RServC='FR' ">svar_rettet</xsl:when>
							    <xsl:when test="$RStatC='M' and $RServC='MR' ">svar_rettet</xsl:when>
								<xsl:when test="$RStatC='N' and $RServC='PR' and $IsTemp ">proeve_modtaget</xsl:when>
								<xsl:when test="$RStatC='N' and $RServC='PR' and not($IsTemp)">svar_midlertidigt</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$RStatC"/>
										<xsl:with-param name="Text">Kan ikke overætte fra SERVICETYPE:<xsl:value-of select="$RServC"/> og STATUS 2: <xsl:value-of select="$RStatC"/> til ResultStatusCode
										</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</ResultStatusCode>
						<Analysis>
							<xsl:for-each select="INV">
								<AnalysisCode>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</AnalysisCode>
								<AnalysisCodeType>
									<xsl:variable name="ACT" select="Elm[2]/SubElm[2]"/>
									<xsl:choose>
										<xsl:when test="$ACT='CQU'">iupac</xsl:when>
										<xsl:when test="$ACT='91'">lokal</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="ValueListError">
												<xsl:with-param name="ValueNode" select="$ACT"/>
												<xsl:with-param name="Text">Ukendt KODETABEL</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</AnalysisCodeType>
								<AnalysisCodeResponsible>
									<xsl:value-of select="Elm[2]/SubElm[3]"/>
								</AnalysisCodeResponsible>
								<xsl:if test="Elm[2]/SubElm[4]!='' ">
									<AnalysisShortName>
										<xsl:value-of select="Elm[2]/SubElm[4]"/>
									</AnalysisShortName>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='ACM'] ">
								<AnalysisCompleteName>
									<xsl:call-template name="FTXSegmentsToBreakableText"/>
								</AnalysisCompleteName>
							</xsl:for-each>
						</Analysis>
					        <xsl:for-each select="REL">
					          <ProducerOfLabResult>
					             <Identifier>
					               <xsl:value-of select="Elm[2]/SubElm[4]"/>
					             </Identifier>
					            <IdentifierCode>
					              <xsl:value-of select="Elm[2]/SubElm[3]"/>
					            </IdentifierCode>
					          </ProducerOfLabResult>
					        </xsl:for-each>
						<xsl:for-each select="S20">
							<ReferenceInterval>
								<xsl:for-each select="RND">
									<TypeOfInterval>
										<xsl:variable name="TOI" select="Elm[1]/SubElm[1]"/>
										<xsl:choose>
											<xsl:when test="$TOI='F'">fysiologisk</xsl:when>
											<xsl:when test="$TOI='T'">terapeutisk</xsl:when>
											<xsl:when test="$TOI='U'">uspecificeret</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="ValueListError">
													<xsl:with-param name="ValueNode" select="$TOI"/>
													<xsl:with-param name="Text">Ukendt INTERVALTYPE</xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</TypeOfInterval>
									<xsl:if test="Elm[2]/SubElm[1]!='' ">
										<LowerLimit>
											<xsl:value-of select="Elm[2]/SubElm[1]"/>
										</LowerLimit>
									</xsl:if>
									<xsl:if test="Elm[3]/SubElm[1]!='' ">
										<UpperLimit>
											<xsl:value-of select="Elm[3]/SubElm[1]"/>
										</UpperLimit>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="FTX">
									<IntervalText>
										<xsl:call-template name="FTXSegmentsToText"/>
									</IntervalText>
								</xsl:for-each>
							</ReferenceInterval>
						</xsl:for-each>
						<xsl:for-each select="RSL">
							<ResultType>
								<xsl:variable name="RT" select="Elm[1]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$RT='NV'">numerisk</xsl:when>
									<xsl:when test="$RT='AV'">alfanumerisk</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="ValueListError">
											<xsl:with-param name="ValueNode" select="$RT"/>
											<xsl:with-param name="Text">Ukendt RESULTATTYPE</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</ResultType>
							<xsl:if test="Elm[2]/SubElm[2]!=''">
								<Operator>
									<xsl:variable name="O" select="Elm[2]/SubElm[2]"/>
									<xsl:choose>
										<xsl:when test="$O='7'">mindre_end</xsl:when>
										<xsl:when test="$O='6'">stoerre_end</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="ValueListError">
												<xsl:with-param name="ValueNode" select="$O"/>
												<xsl:with-param name="Text">Ukendt OPERATOR</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</Operator>
							</xsl:if>
							<Value>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</Value>
							<xsl:if test="Elm[4]/SubElm[4]!=''">
								<Unit>
									<xsl:value-of select="Elm[4]/SubElm[4]"/>
								</Unit>
							</xsl:if>
							<xsl:if test="Elm[5]/SubElm[1]!=''">
								<ResultValidation>
									<xsl:variable name="RV" select="Elm[5]/SubElm[1]"/>
									<xsl:choose>
										<xsl:when test="$RV='HI'">for_hoej</xsl:when>
										<xsl:when test="$RV='LO'">for_lav</xsl:when>
										<xsl:when test="$RV='UN'">unormal</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="ValueListError">
												<xsl:with-param name="ValueNode" select="$RV"/>
												<xsl:with-param name="Text">Ukendt ABNORM</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</ResultValidation>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]!='ACM']">
							<xsl:if test="Elm[1]/SubElm[1]='SPC' ">
								<ResultComments>
									<xsl:call-template name="FTXSegmentsToBreakableText">
										<xsl:with-param name="FTXSegments" select="."/>
									</xsl:call-template>
								</ResultComments>
							</xsl:if>
							<xsl:if test="Elm[1]/SubElm[1]='RIT'">
								<ResultTextValue>
									<xsl:call-template name="FTXSegmentsToBreakableText">
										<xsl:with-param name="FTXSegments" select="."/>
									</xsl:call-template>
								</ResultTextValue>
							</xsl:if>
						</xsl:for-each>
						<xsl:variable name="RefFTXs" select="FTX[Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL']"/>
						<xsl:for-each select="$RefFTXs">
							<xsl:call-template name="FTXSegmentToReference"/>
						</xsl:for-each>
						<xsl:for-each select="RFF[Elm[1]/SubElm[1]='AHI']">
							<ToLabIdentifier>
								<xsl:value-of select="Elm[1]/SubElm[2]"/>
							</ToLabIdentifier>
						</xsl:for-each>	
					</Result>
				</xsl:for-each>
			</LaboratoryResults>
		</LaboratoryReport>
	</xsl:template>
	
	<xsl:template name="NADToIdentifierCodeOrLocal">
		<xsl:param name="NAD" select="."/>
		<xsl:variable name="Code" select="$NAD/Elm[2]/SubElm[2]"/>
		<xsl:choose>
			<xsl:when test="$Code='91'">
				<IdentifierLocal>
					<xsl:value-of select="$NAD/Elm[2]/SubElm[3]"/>
				</IdentifierLocal>
			</xsl:when>
			<xsl:otherwise>
				<IdentifierCode>
					<xsl:variable name="IC" select="$NAD/Elm[2]/SubElm[2]"/>
					<xsl:choose>
						<xsl:when test="$IC='SKS' ">sygehusafdelingsnummer</xsl:when>
						<xsl:when test="$IC='YNR' ">ydernummer</xsl:when>
						<xsl:when test="$IC='EAN' ">lokationsnummer</xsl:when>
						<xsl:when test="$IC='' ">lokationsnummer</xsl:when>
						<xsl:when test="not($IC)">lokationsnummer</xsl:when>
						<xsl:when test="$IC='KOM' ">kommunenummer</xsl:when>
						<xsl:when test="$IC='SOR'">sorkode</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="Error">
								<xsl:with-param name="Node" select="$IC"/>
								<xsl:with-param name="Text">Kan ikke oversaette til IdentifierCodeType: <xsl:value-of select="$IC"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</IdentifierCode>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
</xsl:stylesheet>
