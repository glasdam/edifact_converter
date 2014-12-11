<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2006/07/01/" xmlns:gepj="http://medinfo.dk/epj/proj/gepka/20030701/xml/schema" xmlns:cpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/" xmlns:dkcc="http://rep.oio.dk/ebxml/xml/schemas/dkcc/2003/02/13/" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output media-type="text/html"/>

	<!-- 
		LABORATORYREQUEST
	-->
	<xsl:template match="m:Emessage[m:LaboratoryRequest]">
		<xsl:for-each select="m:LaboratoryRequest">
			<tr>
				<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
					<table width="100%">
						<tbody>
							<tr>
								<xsl:call-template name="ShowMessageHeader">
									<xsl:with-param name="MessageName" select="'Laboratorierekvisition'"/>
								</xsl:call-template>
							</tr>
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Rekvisition<!--stidspunkt-->:</b>
												</td>
												<td valign="top">
													<xsl:for-each select="m:RequisitionInformation/m:RequisitionDateTime">
														<xsl:call-template name="FormatDateTime"/>
													</xsl:for-each>
												</td>
												<td>
													<b>Rekvisitions ID: </b>
												</td>
												<td>
												  <xsl:if test="m:RequisitionInformation/m:Sample/m:SampleIdentifierType">
												    <xsl:attribute name="title">
												      <xsl:text>Nationalt Prøvenummer</xsl:text>
												    </xsl:attribute>
												  </xsl:if>
													<xsl:value-of select="m:RequisitionInformation/m:Sample/m:RequesterSampleIdentifier"/>
												</td>
											</tr>
											<xsl:if test="m:RequisitionInformation/m:Sample/m:OriginalRequesterSampleIdentifier">
											<tr>
												<td valign="top"/>
												
												<td valign="top"/>
												

													<td>
														<b>Orig. Rekvisitions ID: </b>
													</td>
													<td>
													  <xsl:if test="m:RequisitionInformation/m:Sample/m:SampleIdentifierType">
													  <xsl:attribute name="title">
													    <xsl:text>Nationalt Prøvenummer</xsl:text>
													  </xsl:attribute>
													  </xsl:if>
														<xsl:value-of select="m:RequisitionInformation/m:Sample/m:OriginalRequesterSampleIdentifier"/>
													</td>

											</tr>
											</xsl:if>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<xsl:if test="m:RequisitionInformation/m:SamplingDateTimeType='oensket' ">
														<b>Prøve</b> ønskes <b>taget</b>
													</xsl:if>
													<xsl:if test="not(m:RequisitionInformation/m:SamplingDateTimeType='oensket') ">
														<b>Prøve</b> er <b>taget</b>
													</xsl:if>
												</td>
												<td valign="top">
													<xsl:for-each select="m:RequisitionInformation/m:SamplingDateTime">
														<xsl:call-template name="FormatDateTime"/>
													</xsl:for-each>
												</td>
												<td valign="top">
													<b>af</b>
												</td>
												<td valign="top">
													<xsl:value-of select="m:RequisitionInformation/m:SamplingLocationCode"/>
												</td>
												<td valign="top">
													<b> i </b>
												</td>
												<td valign="top">
													<xsl:value-of select="m:RequisitionInformation/m:NumberOfTestTubes"/>
												</td>
												<td valign="top">
													<b> glas</b>
												</td>



											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							<xsl:for-each select="m:RequisitionInformation/m:ClinicalInformation">
								<tr>
									<td valign="top" width="100%">
										<table>
											<tbody>
												<tr>
													<td valign="top">
														<b> Klinisk information </b>
													</td>
												</tr>
												<tr>
													<td valign="top">
														<table>
															<tbody>
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
																	</td>
																</tr>
															</tbody>
														</table>
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
							</xsl:for-each>
							<xsl:for-each select="m:RequisitionInformation/m:Comments">
								<tr>
									<td valign="top" width="100%">
										<table>
											<tbody>
												<tr>
													<td valign="top">
														<b> Kommentarer </b>
													</td>
												</tr>
												<tr>
													<td valign="top">
														<table>
															<tbody>
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
																	</td>
																</tr>
															</tbody>
														</table>
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
							</xsl:for-each>
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b> Ønskede analyser </b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td>
																	<b>Prioritet</b>
																</td>
																<td>
																	<b>Analysekode</b>
																</td>
																<td>
																	<b>Kodetype</b>
																</td>
																<td>
																	<b>Kodeansvarlig</b>
																</td>
																<xsl:if test="m:Requests/m:RequestedAnalysis/m:TestTubeIdentifier">
																	<td>
																		<b>Glas Id</b>
																	</td>
																</xsl:if>
															</tr>
															<xsl:for-each select="m:Requests/m:RequestedAnalysis">
																<xsl:variable name="isevenrow" select="position() mod 2=0"/>
																<tr>
																	<xsl:if test="not($isevenrow)">
																		<xsl:attribute name="bgcolor">
																			<xsl:value-of select="$oddrowhighlightbgcolor"/>
																		</xsl:attribute>
																	</xsl:if>
																	<xsl:if test="$isevenrow">
																		<xsl:attribute name="bgcolor">
																			<xsl:value-of select="$evenrowhighlightbgcolor"/>
																		</xsl:attribute>
																	</xsl:if>
																	<td valign="top">
																		<xsl:value-of select="m:ResultPriority"/>
																	</td>
																	<td valign="top">
																	  <xsl:attribute name="title">
																	    <xsl:value-of select="m:Analysis/m:AnalysisShortName"/>
																	    <xsl:if test="m:Analysis/m:LineComment">
																	      <xsl:text> (</xsl:text>
																	      <xsl:value-of select="m:Analysis/m:LineComment"/>
																	      <xsl:text>)</xsl:text>
																	    </xsl:if>
																	  </xsl:attribute>
																		<xsl:value-of select="m:Analysis/m:AnalysisCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Analysis/m:AnalysisCodeType"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Analysis/m:AnalysisCodeResponsible"/>
																	</td>
																	<xsl:if test="m:TestTubeIdentifier">
																		<td>
																		  <xsl:if test="m:SampleIdentifierType">
																		    <xsl:attribute name="title">
																		      <xsl:text>Nationalt Prøvenummer</xsl:text>
																		    </xsl:attribute>
																		  </xsl:if>
																			<xsl:value-of select="m:TestTubeIdentifier"/>
																		</td>
																	</xsl:if>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							<xsl:variable name="MedComLetter" select="."/>
							<xsl:variable name="FontColor" select="$footerfontcolor"/>
							<xsl:variable name="bgcolor" select="$footerbgcolor"/>
							<xsl:if test="count(m:Requests/m:Prompt)>0">
								<tr>
									<td valign="top" width="100%">
										<table>
											<tbody>
												<tr>
													<td valign="top">
														<b> Svar på analyserelevante spørgsmål </b>
													</td>
												</tr>
												<tr>
													<td valign="top">
														<table>
															<tbody>
																<tr>
																	<td>
																		<b>Spørgsmål</b>
																	</td>
																	<td>
																		<b>Svar</b>
																	</td>
																</tr>
																<xsl:for-each select="m:Requests/m:Prompt">
																	<xsl:variable name="isevenrow" select="position() mod 2=0"/>
																	<tr>
																		<xsl:if test="not($isevenrow)">
																			<xsl:attribute name="bgcolor">
																				<xsl:value-of select="$oddrowbgcolor"/>
																			</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="$isevenrow">
																			<xsl:attribute name="bgcolor">
																				<xsl:value-of select="$evenrowbgcolor"/>
																			</xsl:attribute>
																		</xsl:if>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:CodeText"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:Answer/m:Text"/>
																			<xsl:for-each select="m:Answer/m:Numerical">
																				<xsl:value-of select="."/>
																			</xsl:for-each>
																			<xsl:for-each select="m:Answer/m:DiagnoseCode">
																				<xsl:value-of select="concat('diagnosekode: ',.)"/>
																			</xsl:for-each>
																			<xsl:for-each select="m:Answer/m:DateTime">
																				<xsl:call-template name="FormatDateTime"/>
																			</xsl:for-each>
																		</td>
																	</tr>
																</xsl:for-each>
															</tbody>
														</table>
													</td>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
							</xsl:if>
							<tr>
								<xsl:call-template name="showReferences">
									<xsl:with-param name="Refs" select="m:RequisitionInformation/m:Sample/m:Reference"/>
									<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
								</xsl:call-template>
							</tr>
							<tr>
								<xsl:call-template name="ShowCarbonCopyReceiver"/>
							</tr>
							<tr>
								<xsl:call-template name="ShowPatientAndRelatives"/>
							</tr>
							<tr>
								<xsl:call-template name="ShowParticipants"/>
							</tr>
							<tr>
								<!--						         <xsl:variable name="MedComLetter" select="."/>
						         <xsl:variable name="FontColor" select="$footerfontcolor"/>
						         <xsl:variable name="bgcolor" select="$footerbgcolor"/>-->
								<td valign="top" width="100%">
									<xsl:attribute name="bgcolor">
										<xsl:value-of select="$bgcolor"/>
									</xsl:attribute>
									<table>
										<xsl:for-each select="$MedComLetter/m:OriginalRequester">
											<tr>
												<td valign="top">
													<font>
														<xsl:attribute name="color">
															<xsl:value-of select="$FontColor"/>
														</xsl:attribute>
														<b>Original Rekvirent:</b>
													</font>
												</td>
												<xsl:call-template name="ShowParticipant">
													<xsl:with-param name="FontColor" select="$FontColor"/>
												</xsl:call-template>
											</tr>
										</xsl:for-each>
									</table>
								</td>
							</tr>
							<tr>
								<!--						    <xsl:variable name="MedComLetter" select="."/>
						    <xsl:variable name="FontColor" select="$footerfontcolor"/>
						    <xsl:variable name="bgcolor" select="$footerbgcolor"/>-->
								<td valign="top" width="100%">
									<xsl:attribute name="bgcolor">
										<xsl:value-of select="$bgcolor"/>
									</xsl:attribute>
									<table>
										<tr>
											<td valign="top">
												<font>
													<xsl:attribute name="color">
														<xsl:value-of select="$FontColor"/>
													</xsl:attribute>
													<b>Resultatet sendes til: </b>
												</font>
											</td>
											</tr>
											<xsl:if test="$MedComLetter/m:Sender/m:ReplyTo/text() = 'true'">
												<tr>
												<td>
													<font>
														<xsl:attribute name="color">
															<xsl:value-of select="$FontColor"/>
														</xsl:attribute>
														<xsl:value-of select="'Afsender'"/>

													</font>
												</td>
													</tr>
											</xsl:if>
											<xsl:if test="$MedComLetter/m:OriginalRequester/m:ReplyTo/text() = 'true'">
												<tr>
												<td>
													<font>
														<xsl:attribute name="color">
															<xsl:value-of select="$FontColor"/>
														</xsl:attribute>
														<xsl:value-of select="'Original rekvirent'"/>

													</font>
												</td>
												</tr>
											</xsl:if>
											<xsl:if test="$MedComLetter/m:CCReceiver">
												<tr>
												<td>
													<font>
														<xsl:attribute name="color">
															<xsl:value-of select="$FontColor"/>
														</xsl:attribute>
														<xsl:value-of select="'Kopimodtager'"/>
														
													</font>
												</td>
												</tr>
											</xsl:if>


									</table>
								</td>
							</tr>
							<tr>
								<!--<xsl:variable name="MedComLetter" select="."/>
						    <xsl:variable name="FontColor" select="$footerfontcolor"/>
						    <xsl:variable name="bgcolor" select="$footerbgcolor"/>-->
								<td valign="top" width="100%">
									<xsl:attribute name="bgcolor">
										<xsl:value-of select="$bgcolor"/>
									</xsl:attribute>
									<table>
										<xsl:for-each select="$MedComLetter/m:Payer">
											<tr>
												<td valign="top">
													<font>
														<xsl:attribute name="color">
															<xsl:value-of select="$FontColor"/>
														</xsl:attribute>
														<b>Betaler: </b>
													</font>
												</td>
												<td>
													<font>
														<xsl:attribute name="color">
															<xsl:value-of select="$FontColor"/>
														</xsl:attribute>
														<xsl:value-of select="m:PayersTypeCode"/>
														<xsl:if test="m:OrganisationName">
															<xsl:value-of select="', '"/>
															<xsl:value-of select="m:OrganisationName"/>
														</xsl:if>
													</font>
												</td>
												<xsl:if test="m:Identifier">
													<td>
														<font>
															<xsl:attribute name="color">
																<xsl:value-of select="$FontColor"/>
															</xsl:attribute>
															<b>
																<xsl:value-of select="m:IdentifierCode"/>
																<xsl:value-of select="': '"/>
															</b>
															<xsl:value-of select="m:Identifier"/>
															<xsl:value-of select="' '"/>
														</font>
													</td>
												</xsl:if>
												<xsl:if test="m:OrderIdentifier">
													<td>
														<font>
															<xsl:attribute name="color">
																<xsl:value-of select="$FontColor"/>
															</xsl:attribute>
															<b>
																<xsl:value-of select="'Ordrenr: '"/>
															</b>
															<xsl:value-of select="m:OrderIdentifier"/>
														</font>
													</td>
												</xsl:if>
												<xsl:if test="m:AccountIdentifier">
													<td>
														<font>
															<xsl:attribute name="color">
																<xsl:value-of select="$FontColor"/>
															</xsl:attribute>
															<b>
																<xsl:value-of select="'Kontonr: '"/>
															</b>
															<xsl:value-of select="m:AccountIdentifier"/>
														</font>
													</td>
												</xsl:if>
											</tr>
										</xsl:for-each>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<!-- 
    CLINICALEMAIL NY 
  -->
	<xsl:template match="m:Emessage[m:ClinicalEmail]">
		<xsl:for-each select="m:ClinicalEmail">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Korrespondance'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:AdditionalInformation">
															<tr>
																<td valign="top">
																	<b>Emne: </b>
																</td>
																<td valign="top">
																	<xsl:value-of select="./m:Subject"/>
																</td>
																<td> </td>
																<td valign="top">
																	<b> Prioritet: </b>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Priority"/>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<b> Brevtekst </b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:ClinicalInformation">
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:Text01">
																		<xsl:apply-templates/>
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<xsl:call-template name="showReferences">
								<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
							</xsl:call-template>
						</tr>
						<tr>
							<xsl:call-template name="ShowPatientAndRelatives"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
