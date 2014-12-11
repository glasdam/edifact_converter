<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/medcom.dk/xml/schemas/2004/06/01/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDRPT' and SubElm[5]='R0230M']]">
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
		<xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
		<xsl:variable name="S10KlinInfo" select="BrevIndhold/S10"/>
		<xsl:variable name="S16Sample" select="BrevIndhold/S16"/>
		<xsl:variable name="S18" select="BrevIndhold/S18"/>
		<xsl:variable name="S18Bakt" select="$S18[RSL/Elm[1]/SubElm[1]='TV']"/>
		<!-- Kommer egentligt senere, men kan bruges til at drage konklussioner-->
		<xsl:variable name="S18Result" select="$S18[STS]"/>
		<!--0-5-->
		<xsl:variable name="S18MDD" select="$S18[position()>count($S18Result) and position()&lt;=count($S18Result)+3 and INV/Elm[1]/SubElm[1]='OE']"/>
		<!--0-1-->
		<!--0-1-->
		<!--0-1-->
		<xsl:variable name="S18Kommtekstfund" select="$S18[INV/Elm[1]/SubElm[1]='NR' and not(FTX/Elm[1]/SubElm[1]='ACM')]"/>
		<xsl:variable name="TableRoot" select="$S18[RSL/Elm[1]/SubElm[1]='SB']"/>
		<!--S18 SOM ANGIVER RODEN I TABELLEN, tableheader findes ved at tage foregående sibling-->
		<xsl:variable name="TableRootSeqNr" select="$TableRoot/SEQ/Elm[2]/SubElm[1]"/>
		<!--IDENTIFIKATION AF RODEN I TABELLEN-->
		<xsl:variable name="Columns" select="$S18[RFF/Elm[1]/SubElm[2]=$TableRootSeqNr and not(RSL/Elm[1]/SubElm[1]='SS')]"/>
		<!--S18s SOM ANGIVER BAKTERIENAVNENE (SKAL MAPPES OP MOD $Bakt)-->
		<xsl:variable name="Columns1SeqNr" select="$Columns[1]/SEQ/Elm[2]/SubElm[1]"/>
		<!--IDENTIFIKATION AF KOLONNEN SOM SKAL HAVE ALLE ANTIBIOTIKANAVNE-->
		<xsl:variable name="Rows" select="$S18[RFF/Elm[1]/SubElm[2]=$Columns1SeqNr]"/>
		<!--HERFRA KAN ALLE ANTIBIOTIKA FINDES-->
		<xsl:variable name="S18Fritekster" select="$S18[position()>count($S18Result) and INV/Elm[1]/SubElm[1]='OE' and not(RSL/Elm[1]/SubElm[1]='SB')]"/>
		<xsl:variable name="B1andS" select="$S18Bakt[1]|$TableRoot"/>
		<xsl:variable name="BorS" select="$B1andS[1]"/>
		<xsl:variable name="hasBorS" select="count($BorS)>0"/>
		<xsl:variable name="hasS" select="count($TableRoot)>0"/>
		<xsl:variable name="BorSIdx" select="$BorS/SEQ/Elm[2]/SubElm[1]"/>
		<xsl:variable name="MuligeMDFTekster" select="$S18Fritekster[3>=position() and (not($hasBorS) or SEQ/Elm[2]/SubElm[1]&lt;$BorSIdx)]"/>
		<xsl:variable name="MuligeMDTekster" select="$MuligeMDFTekster[2>=position() and count($MuligeMDFTekster)-count($BorS)>=position()]"/>
		<!--de 2 første af mulige MDF, som ikke obligatorisk skal være F-->
		<xsl:variable name="S18Micro" select="$MuligeMDTekster[position()=1 and (count($MuligeMDTekster)>=2 or substring(FTX/Elm[4]/SubElm[1],1,1)='+' or not(hasBorS))]"/>
		<xsl:variable name="S18Dyrk" select="$MuligeMDTekster[position()=1+count($S18Micro)]"/>
		<xsl:variable name="S18DyrkMedFund" select="$S18MDD[position()=1+count($S18Micro)+count($S18Dyrk)]"/>
		<xsl:variable name="SKTekster" select="$S18Fritekster[position()>count($S18Micro)+count($S18Dyrk)+count($S18DyrkMedFund)]"/>
		<xsl:variable name="S18SensInt" select="$SKTekster[position()=1 and ($hasS or count($SKTekster)>=2)]"/>
		<xsl:variable name="S18Konkl" select="$SKTekster[position()>count($S18SensInt)]"/>
		<!--<xsl:variable name="S18KomFol" select="$S18[position()>count($S18)-2 and INV/Elm[1]/SubElm[1]='OE' " />
		
		
		
		
		DE mulige 5 TEKSTER
		<xsl:variable name="S18MDDKF" select="$18[position()>[position()>count($S18Result) and INV/Elm[1]/SubElm[1]='OE' and not(RSL/Elm[1]/SubElm[1]='SB']"/>
		
		<xsl:variable name="SensInt" select=""/>
		-->
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
		<MicrobiologyReport>
			<!--
			<xsl:for-each select="$S18Fritekster">
				<Fritekst>
					<xsl:call-template name="FTXSegmentsToBreakableText">
						<xsl:with-param name="FTXSegments" select="FTX"/>
					</xsl:call-template>
				</Fritekst>
			</xsl:for-each>
			<xsl:for-each select="$MuligeMDFTekster">
				<MuligMDFTekst>
					<xsl:call-template name="FTXSegmentsToBreakableText">
						<xsl:with-param name="FTXSegments" select="FTX"/>
					</xsl:call-template>
				</MuligMDFTekst>
			</xsl:for-each>
			<xsl:for-each select="$MuligeMDTekster">
				<MuligMDTekst>
					<xsl:call-template name="FTXSegmentsToBreakableText">
						<xsl:with-param name="FTXSegments" select="FTX"/>
					</xsl:call-template>
				</MuligMDTekst>
			</xsl:for-each>
			<xsl:for-each select="$SKTekster">
				<SKTekst>
					<xsl:call-template name="FTXSegmentsToBreakableText">
						<xsl:with-param name="FTXSegments" select="FTX"/>
					</xsl:call-template>
				</SKTekst>
			</xsl:for-each>
			<xsl:for-each select="$S18SensInt">
				<SensTekst>
					<xsl:call-template name="FTXSegmentsToBreakableText">
						<xsl:with-param name="FTXSegments" select="FTX"/>
					</xsl:call-template>
				</SensTekst>
			</xsl:for-each>-->
			<xsl:for-each select="$S02LetterInfo">
				<Letter>
					<Identifier>
						<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
					</Identifier>
					<VersionCode>XR0230M</VersionCode>
					<StatisticalCode>XRPT02</StatisticalCode>
					<xsl:for-each select="$Dtm">
						<Authorisation>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Authorisation>
					</xsl:for-each>
					<TypeCode>XRPT02</TypeCode>
				</Letter>
			</xsl:for-each>
			<xsl:for-each select="$S01Sender">
				<Sender>
					<EANIdentifier>
						<xsl:value-of select="$SenderEAN"/>
					</EANIdentifier>
					<xsl:for-each select="NAD">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCode"/>
						<xsl:call-template name="NADToOrganisationName"/>
						<xsl:call-template name="NADToDepartmentName"/>
						<xsl:call-template name="NADToUnitName"/>
					</xsl:for-each>
					<xsl:for-each select="SPR">
						<xsl:call-template name="SPRToMedicalSpecialityCode"/>
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
						<xsl:call-template name="NADToIdentifierCode"/>
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
						<xsl:call-template name="NADToIdentifierCode"/>
						<xsl:call-template name="NADToOrganisationName"/>
						<xsl:call-template name="NADToDepartmentName"/>
						<xsl:call-template name="NADToUnitName"/>
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
			</Patient>
			<RequisitionInformation>
				<xsl:for-each select="$S10KlinInfo">
					<xsl:if test="count(FTX)>0">
						<ClinicalInformation>
							<xsl:for-each select="FTX">
								<xsl:call-template name="FTXSegmentsToBreakableText">
									<xsl:with-param name="FTXSegments" select="."/>
								</xsl:call-template>
							</xsl:for-each>
						</ClinicalInformation>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="$S02LetterInfo">
					<xsl:for-each select="FTX">
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
					<xsl:for-each select="$SampleRecDTM">
						<SampleReceivedDateTime>
							<xsl:call-template name="DTM203ToDateTime"/>
						</SampleReceivedDateTime>
					</xsl:for-each>
				</Sample>
			</RequisitionInformation>
			<!--SKABELON-->
			<!--END SKABELON-->
			<LaboratoryResults>
				<GeneralResultInformation>
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
					<xsl:for-each select="$S02Answer">
						<xsl:if test="count($S18Konkl)>0">
							<Headline>
								<xsl:value-of select="$S18Konkl/INV/Elm[2]/SubElm[4]"/>
							</Headline>
							<Comment>
								<xsl:call-template name="FTXSegmentsToBreakableText">
									<xsl:with-param name="FTXSegments" select="$S18Konkl/FTX"/>
								</xsl:call-template>
							</Comment>
						</xsl:if>
						<ResultStatus>
							<xsl:variable name="RS" select="STS/Elm[2]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$RS='K' ">komplet</xsl:when>
								<xsl:when test="$RS='D' ">delvis</xsl:when>
								<xsl:when test="$RS='M' ">modtaget</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$RS"/>
										<xsl:with-param name="Text">Kan ikke oversætte fra STATUS til ResultatStatus: <xsl:value-of select="$RS"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</ResultStatus>
					</xsl:for-each>
				</GeneralResultInformation>
				<xsl:for-each select="$S18Result">
					<Result>
						<ResultStatusCode>
							<xsl:variable name="RStatC" select="GIS/Elm[1]/SubElm[1]"/>
							<xsl:variable name="RServC" select="STS/Elm[2]/SubElm[1]"/>
							<xsl:variable name="IsTemp" select="INV/Elm[2]/SubElm[1]='*****'"/>
							<xsl:choose>
								<xsl:when test="$RStatC='N' and $RServC='FR' ">svar_endeligt</xsl:when>
								<xsl:when test="$RStatC='M' and $RServC='FR' ">svar_rettet</xsl:when>
								<xsl:when test="$RStatC='N' and $RServC='PR' and $IsTemp ">proeve_modtaget</xsl:when>
								<xsl:when test="$RStatC='N' and $RServC='PR' and not($IsTemp)">svar_midlertidigt</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$RServC"/>
										<xsl:with-param name="Text">Kan ikke overætte fra SERVICETYPE til ResultServiceCode: <xsl:value-of select="$RServC"/> og STATUS 2: <xsl:value-of select="$RStatC"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</ResultStatusCode>
						<!--
						<xsl:for-each select="GIS">
							<ResultServiceCode>
								<xsl:variable name="RSC" select="Elm[1]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$RSC='N' ">nyt</xsl:when>
									<xsl:when test="$RSC='M' ">rettet</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="$RSC"/>
											<xsl:with-param name="Text">Kan ikke overætte fra SERVICETYPE til ResultServiceCode: <xsl:value-of select="$RSC"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</ResultServiceCode>
						</xsl:for-each>
						<xsl:for-each select="STS">
							<ResultStatusCode>
								<xsl:variable name="RSC" select="Elm[2]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$RSC='FR' ">endeligt</xsl:when>
									<xsl:when test="$RSC='PR' ">foreloebigt</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="$RSC"/>
											<xsl:with-param name="Text">Kan ikke oversætte fra STATUS2 til ResultsStatusCode: <xsl:value-of select="$RSC"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</ResultStatusCode>
						</xsl:for-each>-->
						<Analysis>
							<xsl:for-each select="INV">
								<ExaminationTypeCode>
									<xsl:variable name="ETC" select="Elm[1]/SubElm[1]"/>
									<xsl:choose>
										<xsl:when test="$ETC='MM' ">maalemetode</xsl:when>
										<xsl:when test="$ETC='MP' ">maaleprocedure</xsl:when>
										<xsl:when test="$ETC='MQ' ">maalbar_kvantitet</xsl:when>
										<xsl:when test="$ETC='PR' ">kvantitet</xsl:when>
										<xsl:when test="$ETC='OE' ">overskrift</xsl:when>
										<xsl:when test="$ETC='OP' ">observerbar_egenskab</xsl:when>
										<xsl:when test="$ETC='CO' ">antibiotika_sammensaetning</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="Error">
												<xsl:with-param name="Node" select="$ETC"/>
												<xsl:with-param name="Text">Kan ikke oversætte fra UNDERSØGELSESKODE til ExaminationTypeCode: <xsl:value-of select="$ETC"/>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</ExaminationTypeCode>
								<MICAnalysisCode>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</MICAnalysisCode>
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
								<AnalysisMDSName>
									<Examination>
										<xsl:value-of select="Elm[4]/SubElm[1]"/>
									</Examination>
									<Material>
										<xsl:value-of select="Elm[4]/SubElm[2]"/>
									</Material>
									<Location>
										<xsl:value-of select="Elm[4]/SubElm[3]"/>
									</Location>
								</AnalysisMDSName>
							</xsl:for-each>
						</Analysis>
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
										<xsl:when test="$O='6'">mindre_end</xsl:when>
										<xsl:when test="$O='7'">stoerre_end</xsl:when>
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
						<xsl:if test="count(FTX[Elm[1]/SubElm[1]!='ACM'])>0">
							<ResultComments>
								<xsl:call-template name="FTXSegmentsToBreakableText">
									<xsl:with-param name="FTXSegments" select="FTX[Elm[1]/SubElm[1]!='ACM']"/>
								</xsl:call-template>
							</ResultComments>
						</xsl:if>
						<xsl:variable name="RefFTXs" select="FTX[Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL']"/>
						<xsl:for-each select="$RefFTXs">
							<xsl:call-template name="FTXSegmentToReference"/>
						</xsl:for-each>
					</Result>
				</xsl:for-each>
				<xsl:for-each select="$S18Micro">
					<MicroscopicFindings>
						<Headline>
							<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
						</Headline>
						<xsl:for-each select="FTX">
							<Comments>
								<xsl:call-template name="FTXSegmentsToBreakableText"/>
							</Comments>
						</xsl:for-each>
					</MicroscopicFindings>
				</xsl:for-each>
				<xsl:for-each select="$S18Dyrk">
					<GrowthWithoutFindings>
						<Headline>
							<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
						</Headline>
						<xsl:for-each select="FTX">
							<Comments>
								<xsl:call-template name="FTXSegmentsToBreakableText"/>
							</Comments>
						</xsl:for-each>
					</GrowthWithoutFindings>
				</xsl:for-each>
				<xsl:for-each select="$S18DyrkMedFund">
					<GrowthWithFindings>
						<Headline>
							<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
						</Headline>
						<xsl:for-each select="$S18Bakt">
							<Microorganism>
								<Name>
									<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
								</Name>
								<GrowthValue>
									<xsl:value-of select="RSL/Elm[2]/SubElm[6]"/>
								</GrowthValue>
								<xsl:if test="count(FTX/Elm[4]/SubElm[1])>0 and FTX/Elm[4]/SubElm[1]!=''">
									<MultiResistancy>
										<xsl:value-of select="FTX/Elm[4]/SubElm[1]"/>
									</MultiResistancy>
								</xsl:if>
							</Microorganism>
						</xsl:for-each>
						<xsl:for-each select="$S18Kommtekstfund">
							<Comments>
								<xsl:for-each select="FTX">
									<xsl:call-template name="FTXSegmentsToBreakableText"/>
								</xsl:for-each>
							</Comments>
						</xsl:for-each>
						<Pattern>
							<xsl:for-each select="$TableRoot">
								<Headline>
									<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
								</Headline>
							</xsl:for-each>
							<xsl:for-each select="$Rows">
								<Antibiotic>
									<Name>
										<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>
									</Name>
								</Antibiotic>
							</xsl:for-each>
							<xsl:for-each select="$Columns">
								<!--find ud hvilken position den tilsvarende bakterie har-->
								<xsl:variable name="BPos" select="position()"/>
								<xsl:variable name="BaktNavn" select="INV/Elm[2]/SubElm[4]"/>
								<xsl:variable name="BaktsMedNavn" select="$S18Bakt[INV/Elm[2]/SubElm[4]=$BaktNavn]"/>
								<xsl:variable name="BSeenBefore" select="count($Columns[position()&lt;$BPos and INV/Elm[2]/SubElm[4]=$BaktNavn])"/>
								<xsl:variable name="Bakt" select="$BaktsMedNavn[position()=1+$BSeenBefore]"/>
								<xsl:variable name="BIndex" select="count($S18Bakt[SEQ/Elm[2]/SubElm[1]&lt;=$Bakt/SEQ/Elm[2]/SubElm[1]])"/>
								<xsl:if test="$BIndex=0">
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="INV/Elm[2]/SubElm[4]"/>
										<xsl:with-param name="Text">Kolonnerne [<xsl:for-each select="$Columns">
												<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>, </xsl:for-each>] kan  ikke matches med de angivne bakterier [<xsl:for-each select="$S18Bakt">
												<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>, </xsl:for-each>]</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:variable name="ColumnSeqNr" select="SEQ/Elm[2]/SubElm[1]"/>
								<xsl:variable name="Entries" select="$S18[RFF/Elm[1]/SubElm[2]=$ColumnSeqNr]"/>
								<xsl:for-each select="$Entries">
									<!--find ud af hvilken position det tilsvarende antibiotica har-->
									<xsl:variable name="APos" select="position()"/>
									<xsl:variable name="AntiNavn" select="INV/Elm[2]/SubElm[4]"/>
									<xsl:variable name="AntiMedNavn" select="$Rows[INV/Elm[2]/SubElm[4]=$AntiNavn]"/>
									<xsl:variable name="ASeenBefore" select="count($Entries[position()&lt;$APos and INV/Elm[2]/SubElm[4]=$AntiNavn])"/>
									<xsl:variable name="Anti" select="$AntiMedNavn[position()=1+$ASeenBefore]"/>
									<xsl:variable name="AIndex" select="count($Rows[SEQ/Elm[2]/SubElm[1]&lt;=$Anti/SEQ/Elm[2]/SubElm[1]])"/>
									<xsl:if test="$AIndex=0">
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="INV/Elm[2]/SubElm[4]"/>
											<xsl:with-param name="Text">De angivne antibiotika refereret fra kolonne <xsl:value-of select="$BPos"/> [<xsl:for-each select="$Entries">
													<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>, </xsl:for-each>]   kan ikke matches med de i 1. kollonne angivne antibiotika [<xsl:for-each select="$Rows">
													<xsl:value-of select="INV/Elm[2]/SubElm[4]"/>, </xsl:for-each>]</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<PatternEntry>
										<RefMicroorganism>
											<xsl:value-of select="$BIndex"/>
										</RefMicroorganism>
										<RefAntibiotic>
											<xsl:value-of select="$AIndex"/>
										</RefAntibiotic>
										<Sensitivity>
											<xsl:value-of select="RSL/Elm[2]/SubElm[3]"/>
										</Sensitivity>
									</PatternEntry>
								</xsl:for-each>
							</xsl:for-each>
							<SensitivityInterpretation>
								<xsl:call-template name="FTXSegmentsToBreakableText">
									<xsl:with-param name="FTXSegments" select="$S18SensInt/FTX"/>
								</xsl:call-template>
							</SensitivityInterpretation>
						</Pattern>
					</GrowthWithFindings>
				</xsl:for-each>
			</LaboratoryResults>
		</MicrobiologyReport>
	</xsl:template>
</xsl:stylesheet>
