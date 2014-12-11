<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- LaboratoryAnalysisFile-->
	<xsl:template match="m:LaboratoryAnalysisFile">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="OrigEmsg" select="m:OriginalEmessage"/>
		<xsl:variable name="AnaDetails" select="m:AnalysisDetails"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>PRODAT</SubElm>
					<SubElm>D</SubElm>
					<SubElm>96B</SubElm>
					<SubElm>ZZ</SubElm>
					<SubElm>A0132Z</SubElm>
				</Elm>
				<Elm>
					<SubElm>DAO01</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>DAO</SubElm>
						<SubElm>91</SubElm>
						<SubElm>
							<xsl:value-of select="$AnaDetails/m:GeneralInformation/LaboratoryShortName"/>
						</SubElm>
					</Elm>
					<Elm>
						<SubElm>
							<xsl:value-of select="$AnaDetails/m:GeneralInformation/m:RefNumber"/>
						</SubElm>
					</Elm>
					<Elm/>
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
				<PGI>
					<Elm>
						<SubElm>2</SubElm>
					</Elm>
					<Elm>
						<SubElm>ANA</SubElm>
						<SubElm>SKS</SubElm>
						<SubElm>SST</SubElm>
					</Elm>
				</PGI>
				<S03 hidden="true">
					<RFF>
						<Elm>Letter
						<SubElm>ACW</SubElm>
							<SubElm>
								<xsl:value-of select="$AnaDetails/m:GeneralInformation/m:Previous/m:RefNumber"/>
							</SubElm>
						</Elm>
					</RFF>
					<DTM>
						<Elm>
							<SubElm>171</SubElm>
							<SubElm>
								<xsl:call-template name="DateTimeToDTM203">
									<xsl:with-param name="DT" select="$AnaDetails/m:GeneralInformation/m:Previous/m:DateTime"/>
								</xsl:call-template>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
				</S03>
				<xsl:for-each select="$Sender">
					<S04 hidden="true">
						<NAD>
							<Elm>
								<SubElm>FR</SubElm>
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
						</NAD>
					</S04>
				</xsl:for-each>
				<xsl:for-each select="$AnalysisDetails">
					<S08 hidden="true">
						<LIN>
							<Elm linie="10" position="5">
								<SubElm>
									<xsl:value-of select="position()"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="SC" select="m:StatusCode"/>
									<xsl:choose>
										<xsl:when test="$SC='ny' ">1</xsl:when>
										<xsl:when test="$SC='rettelse' ">3</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt StatusCode<xsl:value-of select="$SC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:Code"/>
								</SubElm>
								<SubElm>ANA</SubElm>
								<SubElm>
									<xsl:variable name="ACT" select="m:CodeType"/>
									<xsl:choose>
										<xsl:when test="$ACT='iupac' ">CQU</xsl:when>
										<xsl:when test="$ACT='lokal' ">91</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt  AnalysisCodeType: <xsl:value-of select="$ACT"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:value-of select="CodeResponsible"/>
								</SubElm>
							</Elm>
						</LIN>
						<xsl:for-each select="m:ValidFrom">
							<DTM>
								<Elm>
									<SubElm>157</SubElm>
									<SubElm>
										<xsl:call-template name="DateTimeToDTM203"/>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:for-each>
						<xsl:for-each select="m:ValidUntil">
							<DTM>
								<Elm>
									<SubElm>36</SubElm>
									<SubElm>
										<xsl:call-template name="DateTimeToDTM203"/>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:for-each>
						<xsl:for-each select="m:Changed">
							<DTM>
								<Elm>
									<SubElm>334</SubElm>
									<SubElm>
										<xsl:call-template name="DateTimeToDTM203"/>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:for-each>
						<S09 hidden="true">
							<IMD>
								<Elm>
									<SubElm>A</SubElm>
								</Elm>
							</IMD>
							<XFTX>
								<Elm>
									<SubElm>
										<xsl:for-each select="m:IsASingleAnalysis">MQ</xsl:for-each>
										<xsl:for-each select="m:IsAnAnalysisGroup">ANG</xsl:for-each>
									</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:FullName"/>
									</SubElm>
								</Elm>
							</XFTX>
							<xsl:for-each select="ShortName">
								<FTX>
									<Elm>
										<SubElm>KNA</SubElm>
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
							<FTX>
								<Elm>
									<SubElm>ABS</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:variable name="RI" select="m:RequestInformation"/>
										<xsl:choose>
											<xsl:when test="$RI='kan_bestilles_og_besvares'">FULL</xsl:when>
											<xsl:when test="$RI='kan_bestilles'">REK</xsl:when>
											<xsl:when test="$RI='tages_paa_laboratorie'">NOX</xsl:when>
											<xsl:otherwise>
												<FEJL>Ukendt RequestInformation : <xsl:value-of select="$RI"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
									</SubElm>
								</Elm>
							</FTX>
							<xsl:for-each select="m:TypeOfTestTubes">
								<FTX>
									<Elm>
										<SubElm>EMB</SubElm>
									</Elm>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:ShortName"/>
										</SubElm>
										<SubElm>91</SubElm>
										<SubElm>
											<xsl:value-of select="m:ShortNameResponsible"/>
										</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:Description"/>
										</SubElm>
									</Elm>
								</FTX>
							</xsl:for-each>
							<xsl:for-each select="m:LabelType">
								<FTX>
									<Elm>
										<SubElm>LBL</SubElm>
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
							<xsl:for-each select="m:LabelTypeInBarcode='true'">
								<FTX>
									<Elm>
										<SubElm>TID</SubElm>
									</Elm>
									<Elm/>
									<Elm/>
									<Elm>
										<SubElm>1</SubElm>
									</Elm>
								</FTX>
							</xsl:for-each>
							<xsl:for-each select="m:BarcodeType">
								<FTX>
									<Elm>
										<SubElm>BAR</SubElm>
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
							<xsl:for-each select="m:TestTubeGroup">
								<FTX>
									<Elm>
										<SubElm>PTG</SubElm>
									</Elm>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:Identifier"/>
										</SubElm>
										<SubElm>91</SubElm>
										<SubElm>
											<xsl:value-of select="m:IdentifierResponsible"/>
										</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:Name"/>
										</SubElm>
									</Elm>
								</FTX>
							</xsl:for-each>
							<xsl:for-each select="m:NumberOfTestTubes">
								<FTX>
									<Elm>
										<SubElm>ANT</SubElm>
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
							<xsl:for-each select="m:Order">
								<FTX>
									<Elm>
										<SubElm>SOR</SubElm>
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
							<xsl:for-each select="m:RequisitionGroup">
								<FTX>
									<Elm>
										<SubElm>AGR</SubElm>
									</Elm>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:Identifier"/>
										</SubElm>
										<SubElm>91</SubElm>
										<SubElm>
											<xsl:value-of select="m:IdentifierResponsible"/>
										</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:Name"/>
										</SubElm>
									</Elm>
								</FTX>
							</xsl:for-each>
							<xsl:for-each select="m:LaboratoryInformation">
								<XFTX>
									<Elm>
										<SubElm>AAI</SubElm>
									</Elm>
									<Elm/>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="."/>
										</SubElm>
									</Elm>
								</XFTX>
							</xsl:for-each>
							<xsl:for-each select="m:Handling">
								<FTX>
									<Elm>
										<SubElm>HAN</SubElm>
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
							<xsl:for-each select="Prompt">
								<xsl:for-each select="m:QuestionToBeAnsweredWithBooleanValue">
									<FTX>
										<Elm>
											<SubElm>SPB</SubElm>
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
								<xsl:for-each select="m:QuestionToBeAnsweredWithDateValue">
									<FTX>
										<Elm>
											<SubElm>SPD</SubElm>
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
								<xsl:for-each select="m:QuestionToBeAnsweredWithDiagnoseValue">
									<FTX>
										<Elm>
											<SubElm>SPK</SubElm>
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
								<xsl:for-each select="m:QuestionToBeAnsweredWithNumericValue">
									<FTX>
										<Elm>
											<SubElm>SPN</SubElm>
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
								<xsl:for-each select="m:QuestionToBeAnsweredWithTextValue">
									<FTX>
										<Elm>
											<SubElm>SPT</SubElm>
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
							</xsl:for-each>
							<xsl:for-each select="m:AnalysisInGroup">
								<FTX>
									<Elm>
										<SubElm>PAI</SubElm>
									</Elm>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:Code"/>
										</SubElm>
										<SubElm>
											<xsl:variable name="ACT" select="m:CodeType"/>
											<xsl:choose>
												<xsl:when test="$ACT='iupac' ">CQU</xsl:when>
												<xsl:when test="$ACT='lokal' ">91</xsl:when>
												<xsl:otherwise>
													<FEJL>Ukendt  AnalysisCodeType: <xsl:value-of select="$ACT"/>
													</FEJL>
												</xsl:otherwise>
											</xsl:choose>
										</SubElm>
										<SubElm>
											<xsl:value-of select="m:CodeResponsible"/>
										</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="m:FullName"/>
										</SubElm>
									</Elm>
								</FTX>
							</xsl:for-each>
							<!--SKABELON
							<xsl:for-each select="xxx">
								<FTX>
									<Elm>
										<SubElm>x</SubElm>
									</Elm>
									<Elm/>
									<Elm>
										<SubElm>
											<xsl:value-of select="xxx"/>
										</SubElm>
										<SubElm>
											<xsl:value-of select="xxx"/>
										</SubElm>
										<SubElm>
											<xsl:value-of select="xxx"/>
										</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="xxx"/>
										</SubElm>
									</Elm>
								</FTX>
							</xsl:for-each>
							SKABELON SLUT-->
						</S09>
					</S08>
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
</xsl:stylesheet>
