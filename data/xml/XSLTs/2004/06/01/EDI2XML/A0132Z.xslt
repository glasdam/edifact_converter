<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/medcom.dk/xml/schemas/2004/06/01/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='PRODAT' and SubElm[5]='A0132Z']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="Pgi" select="BrevIndhold/PGI"/>
		<xsl:variable name="S03" select="BrevIndhold/S03"/>
		<xsl:variable name="S04Sender" select="BrevIndhold/S04"/>
		<xsl:variable name="S08AnaDetails" select="BrevIndhold/S08"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='PGI' or name()='S03'  or name()='S04'  or name()='S08')]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<LaboratoryAnalysisFile>
			<Letter>
				<Identifier>
					<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
				</Identifier>
				<VersionCode>XA0132Z</VersionCode>
				<StatisticalCode>XDAO01</StatisticalCode>
				<xsl:for-each select="$Dtm">
					<Authorisation>
						<xsl:call-template name="DTM203ToDateTime"/>
					</Authorisation>
				</xsl:for-each>
				<TypeCode>XDAO01</TypeCode>
				<StatusCode>nytbrev</StatusCode>
			</Letter>
			<xsl:for-each select="$S04Sender">
				<Sender>
					<EANIdentifier>
						<xsl:value-of select="$SenderEAN"/>
					</EANIdentifier>
					<xsl:for-each select="NAD">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCode"/>
					</xsl:for-each>
				</Sender>
			</xsl:for-each>
			<Receiver>
				<EANIdentifier>
					<xsl:value-of select="$ReceiverEAN"/>
				</EANIdentifier>
			</Receiver>
			<GeneralInformation>
				<LaboratoryShortName>
					<xsl:value-of select="$Bgm/Elm[1]/SubElm[3]"/>
				</LaboratoryShortName>
				<ReferenceNumber>
					<xsl:value-of select="$Bgm/Elm[2]/SubElm[1]"/>
				</ReferenceNumber>
				<xsl:for-each select="$S03">
					<Previous>
						<xsl:for-each select="RFF">
							<ReferenceNumber>
								<xsl:value-of select="Elm[1]/SubElm[2]"/>
							</ReferenceNumber>
						</xsl:for-each>
						<xsl:for-each select="DTM">
							<DateTime>
								<xsl:call-template name="DTM203ToDateTime"/>
							</DateTime>
						</xsl:for-each>
					</Previous>
				</xsl:for-each>
			</GeneralInformation>
			<xsl:for-each select="$S08AnaDetails">
				<AnalysisDetails>
					<xsl:for-each select="LIN">
						<StatusCode>
							<xsl:variable name="SC" select="Elm[2]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$SC='1' ">ny</xsl:when>
								<xsl:when test="$SC='3' ">rettelse</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ValueListError">
										<xsl:with-param name="Node" select="$SC"/>
										<xsl:with-param name="Text">Ukendt AKTKODE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</StatusCode>
					</xsl:for-each>
					<xsl:for-each select="DTM[Elm[1]/SubElm[1]='157']">
						<ValidFrom>
							<xsl:call-template name="DTM203ToDateTime"/>
						</ValidFrom>
					</xsl:for-each>
					<xsl:for-each select="DTM[Elm[1]/SubElm[1]='36']">
						<ValidUntil>
							<xsl:call-template name="DTM203ToDateTime"/>
						</ValidUntil>
					</xsl:for-each>
					<xsl:for-each select="DTM[Elm[1]/SubElm[1]='334']">
						<Changed>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Changed>
					</xsl:for-each>
					<xsl:for-each select="LIN">
						<Code>
							<xsl:value-of select="Elm[3]/SubElm[1]"/>
						</Code>
						<CodeType>
							<xsl:variable name="ACT" select="Elm[3]/SubElm[3]"/>
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
						</CodeType>
						<CodeResponsible>
							<xsl:value-of select="Elm[3]/SubElm[4]"/>
						</CodeResponsible>
					</xsl:for-each>
					<xsl:for-each select="S09">
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='ANG' or Elm[1]/SubElm[1]='MQ']">
							<FullName>
								<xsl:call-template name="FTXSegmentsToBreakableText"/>
							</FullName>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='KNA']">
							<ShortName>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
							</ShortName>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='AAI']">
							<LaboratoryInformation>
								<xsl:call-template name="FTXSegmentsToBreakableText"/>
							</LaboratoryInformation>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='ABS']">
							<RequestInformation>
								<xsl:variable name="RI" select="Elm[4]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$RI='FULL' ">kan_bestilles_og_besvares</xsl:when>
									<xsl:when test="$RI='REK' ">kan_bestilles</xsl:when>
									<xsl:when test="$RI='NOX' ">tages_paa_laboratorie</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="ValueListError">
											<xsl:with-param name="ValueNode" select="$RI"/>
											<xsl:with-param name="Text">Ukendt ReqFull</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</RequestInformation>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='HAN']">
							<Handling>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
							</Handling>
						</xsl:for-each>
						<xsl:if test="count(FTX[Elm[1]/SubElm[1]='MQ'])>0">
							<!--TJEK FOR OBLIGATORISK SEGMENTER (TJEKKES OGSÅ AF SKEMA)-->
							<xsl:if test="count(FTX[Elm[1]/SubElm[1]='EMB'])=0">
								<xsl:call-template name="Error"><xsl:with-param name="Text">Der skal være angivet Glastype i SG09 for enkeltanlyser</xsl:with-param></xsl:call-template>
							</xsl:if>
							<xsl:if test="count(FTX[Elm[1]/SubElm[1]='PTG'])=0">
								<xsl:call-template name="Error"><xsl:with-param name="Text">Der skal være angivet GlasGruppe i SG09 for enkeltanlyser</xsl:with-param></xsl:call-template>
							</xsl:if>
							<xsl:if test="count(FTX[Elm[1]/SubElm[1]='LBL'])=0">
								<xsl:call-template name="Error"><xsl:with-param name="Text">Der skal være angivet Etikettype i SG09 for enkeltanlyser</xsl:with-param></xsl:call-template>
							</xsl:if>
							<!--TJEK FOR IKKE LOVLIGE SEGMENTER (TJEKKES OGSÅ AF SKEMA)-->
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='PAI']">
								<xsl:call-template name="Error">
									<xsl:with-param name="Text">Analyser kan kun angives til en analysegruppe</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
							<!--OVERSÆT-->
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='MQ']">
								<IsASingleAnalysis>true</IsASingleAnalysis>
							</xsl:for-each>
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='EMB']">
								<TypeOfTestTubes>
									<ShortName>
										<xsl:value-of select="Elm[3]/SubElm[1]"/>
									</ShortName>
									<ShortNameResponsible>
										<xsl:value-of select="Elm[3]/SubElm[3]"/>
									</ShortNameResponsible>
									<xsl:if test="Elm[4]/SubElm[1]!=''">
										<Description>
											<xsl:value-of select="Elm[4]/SubElm[1]"/>
										</Description>
									</xsl:if>
								</TypeOfTestTubes>
							</xsl:for-each>
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='PTG']">
								<TestTubeGroup>
									<Identifier>
										<xsl:value-of select="Elm[3]/SubElm[1]"/>
									</Identifier>
									<IdentifierResponsible>
										<xsl:value-of select="Elm[3]/SubElm[3]"/>
									</IdentifierResponsible>
									<xsl:if test="Elm[4]/SubElm[1]!=''">
										<Name>
											<xsl:value-of select="Elm[4]/SubElm[1]"/>
										</Name>
									</xsl:if>
								</TestTubeGroup>
							</xsl:for-each>
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='LBL'  and Elm[4]/SubElm[1]!='_']">
								<LabelType>
									<xsl:value-of select="Elm[4]/SubElm[1]"/>
								</LabelType>
							</xsl:for-each>
							
						</xsl:if>
						<xsl:if test="count(FTX[Elm[1]/SubElm[1]='ANG'])>0">
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='ANG']">
								<IsAnAnalysisGroup>true</IsAnAnalysisGroup>
							</xsl:for-each>
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='PAI']">
								<AnalysisInGroup>
									<Code>
										<xsl:value-of select="Elm[3]/SubElm[1]"/>
									</Code>
									<CodeType>
										<xsl:variable name="ACT" select="Elm[3]/SubElm[2]"/>
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
									</CodeType>
									<CodeResponsible>
										<xsl:value-of select="Elm[3]/SubElm[3]"/>
									</CodeResponsible>
									<FullName>
										<xsl:value-of select="Elm[4]/SubElm[1]"/>
									</FullName>
								</AnalysisInGroup>
							</xsl:for-each>
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='EMB']">
								<xsl:call-template name="Error">
									<xsl:with-param name="Text">Der kan ikke angives glastype til en analysegruppe</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='PTG']">
								<xsl:call-template name="Error">
									<xsl:with-param name="Text">Der kan ikke angives glasgruppe til en analysegruppe</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
							<xsl:for-each select="FTX[Elm[1]/SubElm[1]='LBL']">
								<xsl:call-template name="Error">
									<xsl:with-param name="Text">Der kan ikke angives etikettetype til en analysegruppe</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:if>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='ANT']">
							<NumberOfTestTubes>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
							</NumberOfTestTubes>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='BAR']">
							<BarcodeType>
								<xsl:variable name="BT" select="Elm[4]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$BT='A'">interleaved_2of5</xsl:when>
									<xsl:when test="$BT='B'">code_128c</xsl:when>
									<xsl:when test="$BT='C'">code_39</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="ValueListError">
											<xsl:with-param name="ValueNode" select="$BT"/>
											<xsl:with-param name="Text">Ukendt BARCODETYPE</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</BarcodeType>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='TID']">
							<LabelTypeInBarcode>
								<xsl:value-of select="Elm[4]/SubElm[1]='1'"/>
							</LabelTypeInBarcode>
						</xsl:for-each>
						<xsl:if test="FTX/Elm[1][SubElm[1]='SPB' or SubElm[1]='SPD'  or SubElm[1]='SPK' or SubElm[1]='SPN' or SubElm[1]='SPT']">
							<Prompt>
								<xsl:for-each select="FTX[Elm[1]/SubElm[1]='SPB']">
									<QuestionToBeAnsweredWithBooleanValue>
										<xsl:value-of select="Elm[4]/SubElm[1]"/>
									</QuestionToBeAnsweredWithBooleanValue>
								</xsl:for-each>
								<xsl:for-each select="FTX[Elm[1]/SubElm[1]='SPD']">
									<QuestionToBeAnsweredWithDateValue>
										<xsl:value-of select="Elm[4]/SubElm[1]"/>
									</QuestionToBeAnsweredWithDateValue>
								</xsl:for-each>
								<xsl:for-each select="FTX[Elm[1]/SubElm[1]='SPK']">
									<QuestionToBeAnsweredWithDiagnoseValue>
										<xsl:value-of select="Elm[4]/SubElm[1]"/>
									</QuestionToBeAnsweredWithDiagnoseValue>
								</xsl:for-each>
								<xsl:for-each select="FTX[Elm[1]/SubElm[1]='SPN']">
									<QuestionToBeAnsweredWithNumericValue>
										<xsl:value-of select="Elm[4]/SubElm[1]"/>
									</QuestionToBeAnsweredWithNumericValue>
								</xsl:for-each>
								<xsl:for-each select="FTX[Elm[1]/SubElm[1]='SPT']">
									<QuestionToBeAnsweredWithTextValue>
										<xsl:value-of select="Elm[4]/SubElm[1]"/>
									</QuestionToBeAnsweredWithTextValue>
								</xsl:for-each>
							</Prompt>
						</xsl:if>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='AGR']">
							<RequisitionGroup>
								<Identifier>
									<xsl:value-of select="Elm[3]/SubElm[1]"/>
								</Identifier>
								<IdentifierResponsible>
									<xsl:value-of select="Elm[3]/SubElm[3]"/>
								</IdentifierResponsible>
								<Name>
									<xsl:value-of select="Elm[4]/SubElm[1]"/>
								</Name>
							</RequisitionGroup>
						</xsl:for-each>
						<xsl:for-each select="FTX[Elm[1]/SubElm[1]='SOR' and Elm[4]/SubElm[1]!='_']">
							<Order>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
							</Order>
						</xsl:for-each>
					</xsl:for-each>
				</AnalysisDetails>
			</xsl:for-each>
		</LaboratoryAnalysisFile>
	</xsl:template>
</xsl:stylesheet>
