<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2014/10/08/"
	xmlns:cpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/"
	xmlns:dkcc="http://rep.oio.dk/ebxml/xml/schemas/dkcc/2003/02/13/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output media-type="text/html"/>
	
	<!-- 	LABORATORYREPORT -->
	<xsl:key name="requisitiongroup2result" match="m:Emessage/m:LaboratoryReport/m:LaboratoryResults/m:Result" use="concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)"/>
	<xsl:template match="m:Emessage[m:LaboratoryReport]">
		<xsl:for-each select="m:LaboratoryReport">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Laboratoriesvar'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SamplingDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<xsl:call-template name="ShowReqStatus"/>
											<td valign="top">
												<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:RequisitionInformation/m:Comments)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top" width="100%">
													<b>Kommentarer til rekvisitionen</b>
												</td>
											</tr>
											<tr>
												<td valign="top" width="100%">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:RequisitionInformation/m:Comments">
																		<xsl:apply-templates/>
																	</xsl:for-each>
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
						</xsl:if>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Resultater</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<tr bgcolor="#cccccc">
															<td valign="top">
																<b>Analyse</b>
															</td>
															<td valign="top">
																<b>Værdi</b>
															</td>
															<td valign="top">
																<b>Bem.</b>
															</td>
															<td valign="top">
																<b>Enhed</b>
															</td>
															<td valign="top">
																<b>Reference</b>
															</td>
															<td valign="top">
																<b>Status</b>
															</td>
															<td valign="top">
																<b>Sendeprøve</b>
															</td>
															<td/>
														</tr>
														<xsl:variable name="Results2" select="m:LaboratoryResults/m:Result"/>
														<xsl:variable name="Firstresults2" select="$Results2[count(.|(key('requisitiongroup2result',concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)))[1])=1]"/>
														<xsl:for-each select="$Firstresults2">
															<xsl:sort select="m:Analysis/m:RequisitionGroup/m:Identifier"/>
															<xsl:variable name="GNr" select="position()"/>
															<xsl:variable name="Key" select="concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)"/>
															<xsl:variable name="ResultsInGrp" select="key('requisitiongroup2result',$Key)"/>
															<tr>
																<td colspan="7">
																	<b>
																		<i>
																			<xsl:value-of select="m:Analysis/m:RequisitionGroup/m:Name"/>
																		</i>
																	</b>
																</td>
															</tr>
															<xsl:for-each select="$ResultsInGrp">
																<xsl:sort select="Analysis/m:Order"/>
																<xsl:variable name="NrInG" select="position()"/>
																<xsl:variable name="isevenrow" select="position() mod 2 = 0"/>
																<tr>
																	<xsl:if test="not($isevenrow)">
																		<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																	</xsl:if>
																	<xsl:if test="$isevenrow">
																		<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																	</xsl:if>
																	<td valign="top">
																	       <xsl:choose>
																	         <xsl:when test="m:Analysis/m:AnalysisShortName">
																	           <xsl:value-of select="m:Analysis/m:AnalysisShortName"/>
																	         </xsl:when>
																	         <xsl:otherwise>
																	           <xsl:value-of select="concat(m:Analysis/m:AnalysisCompleteName,' (',m:Analysis/m:AnalysisCode,':',m:Analysis/m:AnalysisCodeResponsible,')')"/>
																	         </xsl:otherwise>
																	       </xsl:choose>
																	</td>
																	<td valign="top">
																	  <xsl:attribute name="title">
																	    <xsl:if test="m:ResultTextValue">
																	      <xsl:text>Tekstværdi: </xsl:text><xsl:value-of select="m:ResultTextValue"/><xsl:text>, 
</xsl:text>
																	    </xsl:if>
																	    <xsl:text>Producent: </xsl:text><xsl:value-of select="m:ProducerOfLabResult"/>
																	  </xsl:attribute>
																	  <xsl:choose>
																	    <xsl:when test="m:ResultValidation">
																	      <xsl:variable name="RV" select="m:ResultValidation"/>
																	      <xsl:choose>
																	        <xsl:when test="$RV='unormal' ">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valueabnormbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	        <xsl:when test="$RV='for_hoej' ">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valuetohighbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	        <xsl:when test="$RV='for_lav' ">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valuetolowbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	      </xsl:choose>
																	    </xsl:when>
																	    <xsl:when test="m:ResultType = 'numerisk'">
																	      <xsl:choose>
																	        <xsl:when test="m:Value > m:ReferenceInterval/m:UpperLimit">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valuetohighbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	        <xsl:when test="m:Value &lt; m:ReferenceInterval/m:LowerLimit">
																	          <xsl:attribute name="bgcolor"><xsl:value-of select="$valuetolowbgcolor"/></xsl:attribute>
																	        </xsl:when>
																	      </xsl:choose>
																	    </xsl:when>
																	  </xsl:choose>
																		<xsl:variable name="O" select="m:Operator"/>
																		<xsl:choose>
																			<xsl:when test="$O='mindre_end'">&lt;</xsl:when>
																			<xsl:when test="$O='stoerre_end'">&gt;</xsl:when>
																		</xsl:choose>
																		<xsl:value-of select="m:Value"/>
																	</td>
																	<td valign="top">
																		<xsl:if test="count(m:ResultTextValue|m:ResultComments)>0">
																			<font size="1">
																				<xsl:attribute name="title"><xsl:value-of select="m:ResultComments"/></xsl:attribute>
																				<xsl:value-of select="concat($GNr,',',$NrInG)"/>
																			</font>
																		</xsl:if>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Unit"/>
																	</td>
																	<td valign="top">
																		<xsl:if test="count(m:ReferenceInterval/m:LowerLimit|m:ReferenceInterval/m:UpperLimit)>1">
																			<xsl:value-of select="concat(m:ReferenceInterval/m:LowerLimit,'-',m:ReferenceInterval/m:UpperLimit)"/>
																		</xsl:if>
																		<xsl:if test="count(m:ReferenceInterval/m:LowerLimit|m:ReferenceInterval/m:UpperLimit)=1">
																		  	<xsl:if test="count(m:ReferenceInterval/m:LowerLimit)=1">
																		  	   <xsl:value-of select="concat('&gt;',m:ReferenceInterval/m:LowerLimit)"/>
																		  	</xsl:if>
																		  	<xsl:if test="count(m:ReferenceInterval/m:UpperLimit)=1">
																		  	   <xsl:value-of select="concat('&lt;',m:ReferenceInterval/m:UpperLimit)"/>
																		  	</xsl:if>

																		</xsl:if>
																		<xsl:value-of select="m:ReferenceInterval/m:IntervalText"/>
																	</td>
																	<td>
																		<xsl:variable name="RS" select="m:ResultStatusCode"/>
																		<xsl:choose>
																			<xsl:when test="$RS='svar_endeligt'">Endeligt resultat</xsl:when>
																			<xsl:when test="$RS='svar_midlertidigt'">Midlertidigt resultat</xsl:when>
																			<xsl:when test="$RS='svar_rettet'">Rettet resultat</xsl:when>
																			<xsl:when test="$RS='proeve_modtaget'">Prøvemodtaget</xsl:when>
																		</xsl:choose>
																	</td>
																	<td>
																		<xsl:value-of select="m:ToLabIdentifier"/>
																	</td>
																	<td>
																		<xsl:for-each select="m:Reference[m:URL]">
																			<a>
																				<xsl:attribute name="href"><xsl:value-of select="m:URL"/></xsl:attribute>
																				<img src="img/urlicon.PNG">
																					<xsl:attribute name="alt"><xsl:value-of select="m:RefDescription"/></xsl:attribute>
																				</img>
																			</a>
																		</xsl:for-each>
																	</td>
																</tr>
															</xsl:for-each>
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
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Bemærkninger</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
												        <xsl:for-each select="m:LaboratoryResults">
											            <xsl:variable name="GNr" select="position()"/>
														<xsl:variable name="Results" select="m:Result"/>
														<xsl:variable name="Firstresults" select="$Results[count(.|(key('requisitiongroup2result',m:Analysis/m:RequisitionGroup/m:Identifier))[1])=1]"/>
														<xsl:for-each select="$Firstresults">
															<xsl:sort select="m:Analysis/m:RequisitionGroup/m:Identifier"/>
															
															<xsl:variable name="Key" select="concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)"/>
																<xsl:variable name="NrInG" select="position()"/>
																<xsl:if test="count(m:ResultTextValue|m:ResultComments)>0">
																	<tr>
																		<td valign="top">
																			<font size="1">
																				<xsl:value-of select="concat($GNr,',',$NrInG)"/>
																			</font>
																		</td>
																		<td valign="top">
																			<table>
																				<tbody>
																					<xsl:for-each select="m:ResultTextValue|m:ResultComments">
																						<tr>
																							<td valign="top">
																								<xsl:if test="name()='ResultTextValue' ">Værdi</xsl:if>
																								<xsl:if test="name()='ResultComments' ">Bem.</xsl:if>
																							</td>
																							<td valign="top">
																								<xsl:apply-templates/>
																							</td>
																						</tr>
																					</xsl:for-each>
																				</tbody>
																			</table>
																		</td>
																	</tr>
																</xsl:if>
														</xsl:for-each>
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

	<!--  MICROBIOLOGYREPORT -->
	<xsl:template match="m:Emessage[m:MicrobiologyReport]">
		<xsl:for-each select="m:MicrobiologyReport">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Mikrobiologisvar'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SamplingDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Prøve modtaget:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SampleReceivedDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<xsl:call-template name="ShowReqStatus"/>
											<td valign="top">
												<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:for-each select="m:RequisitionInformation/m:Comments">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Kommentarer til rekvisitionen
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select=".">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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
						</xsl:for-each>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Resultater</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<tr>
															<td valign="top">
																<b>Analysetype</b>
															</td>
															<td valign="top">
																<b>Analyse</b>
															</td>
															<td valign="top">
																<b>Undersøgelse</b>
															</td>
															<td valign="top">
																<b>Materiale</b>
															</td>
															<td valign="top">
																<b>Lokation</b>
															</td>
															<td valign="top">
																<b>Værdi</b>
															</td>
															<td valign="top">
																<b>Bem.</b>
															</td>
															<td valign="top">
																<b>Enhed</b>
															</td>
															<td valign="top">
																<b>Reference</b>
															</td>
															<td valign="top">
																<b>Status</b>
															</td>
															<td valign="top">
																<b>Sendeprøve</b>
															</td>
														</tr>
														<xsl:for-each select="m:LaboratoryResults/m:Result">
															<xsl:variable name="RNr" select="position()"/>
															<xsl:variable name="CNr" select="count(../m:Result[position()&lt;=$RNr and count(m:ResultTextValue|m:ResultComments)>0])"/>
															<xsl:variable name="isevenrow" select="position() mod 2 = 0"/>
															<tr>
																<xsl:if test="not($isevenrow)">
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																</xsl:if>
																<xsl:if test="$isevenrow">
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																</xsl:if>
																<td valign="top">
																	<xsl:value-of select="m:Analysis/m:ExaminationTypeCode"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="concat(m:Analysis/m:AnalysisShortName,' (',m:Analysis/m:MICAnalysisCode,':',m:Analysis/m:AnalysisCodeResponsible,')')"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Analysis/m:AnalysisMDSName/m:Examination"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Analysis/m:AnalysisMDSName/m:Material"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Analysis/m:AnalysisMDSName/m:Location"/>
																</td>
																<td valign="top">
																	<xsl:variable name="RV" select="m:ResultValidation"/>
																  <xsl:if test="m:ProducerOfLabResult">
																    <xsl:attribute name="title"><xsl:text>Producent: </xsl:text><xsl:value-of select="m:ProducerOfLabResult"/></xsl:attribute>
																  </xsl:if>
																	<xsl:choose>
																		<xsl:when test="$RV='unormal' ">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$valueabnormbgcolor"/></xsl:attribute>
																		</xsl:when>
																		<xsl:when test="$RV='for_hoej' ">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetohighbgcolor"/></xsl:attribute>
																		</xsl:when>
																		<xsl:when test="$RV='for_lav' ">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetolowbgcolor"/></xsl:attribute>
																		</xsl:when>
																	</xsl:choose>
																	<xsl:variable name="O" select="m:Operator"/>
																	<xsl:choose>
																		<xsl:when test="$O='mindre_end'">&amp;lt;</xsl:when>
																		<xsl:when test="$O='stoerre_end'">&amp;gt;</xsl:when>
																	</xsl:choose>
																	<xsl:value-of select="m:Value"/>
																  
																</td>
																<td valign="top">
																	<font size="1">
																		<xsl:if test="count(m:ResultTextValue|m:ResultComments)>0">
																			<xsl:value-of select="$CNr"/>
																		</xsl:if>
																	</font>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Unit"/>
																</td>
																<td valign="top">
																	<xsl:if test="count(m:ReferenceInterval/m:LowerLimit|m:ReferenceInterval/m:UpperLimit)>0">
																		<xsl:value-of select="concat(m:ReferenceInterval/m:LowerLimit,'-',m:ReferenceInterval/m:UpperLimit)"/>
																	</xsl:if>
																	<xsl:value-of select="m:ReferenceInterval/m:IntervalText"/>
																</td>
																<td>
																	<xsl:variable name="RS" select="m:ResultStatusCode"/>
																	<xsl:choose>
																		<xsl:when test="$RS='svar_endeligt'">Endeligt resultat</xsl:when>
																		<xsl:when test="$RS='svar_midlertidigt'">Midlertidigt resultat</xsl:when>
																		<xsl:when test="$RS='svar_rettet'">Rettet resultat</xsl:when>
																		<xsl:when test="$RS='proeve_modtaget'">Prøvemodtaget</xsl:when>
																	</xsl:choose>
																</td>
																<td>
																	<xsl:value-of select="m:ToLabIdentifier"/>
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
						<xsl:if test="count(m:LaboratoryResults/m:Result/m:ResultComments)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Bemærkninger</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:LaboratoryResults/m:Result[count(m:ResultTextValue|m:ResultComments)>0]">
																<xsl:variable name="RNr" select="position()"/>
																<tr>
																	<td valign="top">
																		<font size="1">
																			<xsl:value-of select="$RNr"/>
																		</font>
																	</td>
																	<td valign="top">
																		<table>
																			<tbody>
																				<xsl:for-each select="m:ResultTextValue|m:ResultComments">
																					<tr>
																						<td valign="top">
																							<xsl:if test="name()='ResultTextValue' ">Værdi</xsl:if>
																							<xsl:if test="name()='ResultComments' ">Bem.</xsl:if>
																						</td>
																						<td valign="top">
																							<xsl:apply-templates/>
																						</td>
																					</tr>
																				</xsl:for-each>
																			</tbody>
																		</table>
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
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
													<xsl:value-of select="m:LaboratoryResults/m:MicroscopicFindings/m:Headline"/>
												</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:apply-templates select="m:LaboratoryResults/m:MicroscopicFindings/m:Comments/text()|m:LaboratoryResults/m:MicroscopicFindings/m:Comments/*"/>
											</td>
										</tr>
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
												<b>
													<xsl:value-of select="m:LaboratoryResults/m:CultureWithoutFindings/m:Headline"/>
												</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:apply-templates select="m:LaboratoryResults/m:CultureWithoutFindings/m:Comments/text()|m:LaboratoryResults/m:CultureWithoutFindings/m:Comments/*"/>
											</td>
										</tr>
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
												<b>
													<xsl:value-of select="m:LaboratoryResults/m:CultureWithFindings/m:Headline"/>
												</b>
											</td>
										</tr>
										<xsl:for-each select="m:LaboratoryResults/m:CultureWithFindings/m:Microorganism">
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">(<xsl:value-of select="position()"/>)</td>
																<td valign="top">
																	<xsl:value-of select="m:GrowthValue"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Name"/>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:MultiResistance"/>
																</td>
															</tr>
														</tbody>
													</table>
												</td>
											</tr>
										</xsl:for-each>
										<tr>
											<xsl:for-each select="m:LaboratoryResults/m:CultureWithFindings/m:Pattern/m:PatternEntry[1]">
												<tr>
													<td valign="top">
														<xsl:call-template name="ShowTable2">
															<xsl:with-param name="ColNames" select="../../m:Microorganism/m:Name"/>
															<xsl:with-param name="RowNames" select="../m:Antibiotic"/>
															<xsl:with-param name="ColIdxs" select="../m:PatternEntry/m:RefMicroorganism"/>
															<xsl:with-param name="RowIdxs" select="../m:PatternEntry/m:RefAntibiotic"/>
															<xsl:with-param name="Values" select="../m:PatternEntry/m:Sensitivity"/>
														</xsl:call-template>
													</td>
												</tr>
											</xsl:for-each>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<tr>
															<xsl:for-each select="m:LaboratoryResults/m:CultureWithFindings/m:Pattern/m:SensitivityInterpretation/text()">
																<td valign="top">
																	<xsl:value-of select="."/>
																</td>
															</xsl:for-each>
														</tr>
													</tbody>
												</table>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:apply-templates select="m:LaboratoryResults/m:CultureWithFindings/m:Comments/text()|m:LaboratoryResults/m:CultureWithFindings/m:Comments/*"/>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:RequisitionInformation/m:ClinicalInformation)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Klinisk information
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:RequisitionInformation/m:ClinicalInformation">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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
						<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation[m:Comments]">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:Comments">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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
						</xsl:for-each>
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
	<xsl:include href="WebReport.xsl"/>

	<!--  
		CERVIXCYTOLOGYREPORT  
	-->
	<xsl:template match="m:Emessage[m:CervixcytologyReport]">
		<xsl:for-each select="m:CervixcytologyReport">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Cervixcytologisvar'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:SamplingDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Prøve modtaget:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:SampleReceivedDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Tabelsvar:</b>
											</td>
											<td valign="top">
												<xsl:value-of select="m:LaboratoryResults/m:TableFormat/m:TableResult"/>
											</td>
											<xsl:if test="m:LaboratoryResults/m:GeneralResultInformation/m:ToLabIdentifier">
												<td valign="top">
													<xsl:value-of select="m:LaboratoryResults/m:GeneralResultInformation/m:ToLabIdentifier"/>
												</td>	
											</xsl:if>											
											<xsl:if test="m:LaboratoryResults/m:TableFormat/m:ResultValidation">
												<td valign="top">
													<b>Ref:</b>
												</td>
												<td valign="top">
													<xsl:attribute name="bgcolor"><xsl:value-of select="$valueabnormbgcolor"/></xsl:attribute>
													<xsl:value-of select="m:LaboratoryResults/m:TableFormat/m:ResultValidation"/>
												</td>
											</xsl:if>
											<xsl:call-template name="ShowReqStatus"/>
											<td valign="top">
												<b>Prøvestatus:</b>
											</td>
											<td valign="top">
												<xsl:variable name="RSC" select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultStatusCode"/>
												<xsl:choose>
													<xsl:when test="$RSC='svar_endeligt'">Endeligt resultat</xsl:when>
													<xsl:when test="$RSC='svar_midlertidigt'">Midlertidigt resultat</xsl:when>
													<xsl:when test="$RSC='svar_rettet'">Rettet resultat</xsl:when>
													<xsl:when test="$RSC='proeve_modtaget'">Prøvemodtaget</xsl:when>
												</xsl:choose>
											</td>
											<td valign="top">
												<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:for-each select="m:RequisitionInformation/m:Comments">
							<tr>
								<td valign="top" width="100%">
									<table width="100%">
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Kommentarer til rekvisitionen
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select=".">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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
						</xsl:for-each>
						<xsl:for-each select="m:LaboratoryResults/m:CodedFormat">
							<tr>
								<td valign="top" width="100%">
									<table width="100%">
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:DiagnosisHeadline"/>
													</b>
												</td>
											</tr>
											<xsl:for-each select="m:Sample">
												<tr>
													<td valign="top">
														<table>
															<tbody>
																<tr>
																	<td valign="top">
																		<b>Materiale:</b>
																		<td valign="top"/>
																		<xsl:value-of select="m:MaterialDescription"/>
																	</td>
																	<td>
																		<b>Rekvirentens ID:</b>
																	</td>
																	<td>
																		<xsl:value-of select="m:RequesterSampleIdentifier"/>
																	</td>
																	<td>
																		<b>Laboratoriets ID:</b>
																	</td>
																	<td>
																		<xsl:value-of select="m:LaboratoryInternalSampleIdentifier"/>
																	</td>
																</tr>
															</tbody>
														</table>
													</td>
												</tr>
												<xsl:for-each select="m:CodedResults">
													<tr>
														<td valign="top">
															<table>
																<tbody>
																	<xsl:for-each select="m:Topography">
																		<tr>
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																			<td valign="top">
																				<b>Topografi:</b>
																			</td>
																			<td>
																				<xsl:value-of select="m:Code"/>
																			</td>
																			<td>
																				<xsl:value-of select="m:Text"/>
																			</td>
																			<td>
																				<xsl:value-of select="m:Comment"/>
																			</td>
																		</tr>
																	</xsl:for-each>
																	<xsl:for-each select="m:Result">
																		<xsl:variable name="isevenrow" select="not(position() mod 2=0)"/>
																		<tr>
																			<xsl:if test="not($isevenrow)">
																				<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																			</xsl:if>
																			<xsl:if test="$isevenrow">
																				<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																			</xsl:if>
																			<td valign="top">
																				<b>Resultat:</b>
																			</td>
																			<td>
																				<xsl:value-of select="m:Code"/>
																			</td>
																			<td>
																				<xsl:value-of select="m:Text"/>
																			</td>
																			<td>
																				<xsl:value-of select="m:Comment"/>
																			</td>
																		</tr>
																	</xsl:for-each>
																</tbody>
															</table>
														</td>
													</tr>
												</xsl:for-each>
											</xsl:for-each>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:for-each>
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Microscopic">
							<tr>
								<td valign="top" width="100%">
									<table width="100%">
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates select="m:Text/text()|m:Text/*"/>
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
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Conclusion">
							<tr>
								<td valign="top" width="100%">
									<table width="100%">
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates select="m:Text/text()|m:Text/*"/>
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
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Comments">
							<tr>
								<td valign="top" width="100%">
									<table width="100%">
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates select="m:Text/text()|m:Text/*"/>
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
						<xsl:if test="count(m:RequisitionInformation/m:ClinicalInformation)>0">
							<tr>
								<td valign="top" width="100%">
									<table width="100%">
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Klinisk information
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:RequisitionInformation/m:ClinicalInformation">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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

	<!--  
		HISTOPATHOLOGYREPORT  
	-->
	<xsl:template match="m:Emessage[m:HistopathologyReport]">
		<xsl:for-each select="m:HistopathologyReport">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Patologisvar'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:SamplingDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Prøve modtaget:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:SampleReceivedDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											
											<td valign="top">
												<b>Tabelsvar:</b>
											</td>
											<td valign="top">
												<xsl:value-of select="m:LaboratoryResults/m:TableFormat/m:TableResult"/>
											</td>
											<xsl:if test="m:LaboratoryResults/m:GeneralResultInformation/m:ToLabIdentifier">
												<td valign="top">
													<xsl:value-of select="m:LaboratoryResults/m:GeneralResultInformation/m:ToLabIdentifier"/>
												</td>	
											</xsl:if>											
											<xsl:if test="m:LaboratoryResults/m:TableFormat/m:ResultValidation">
												<td valign="top">
													<b>Ref:</b>
												</td>
												<td valign="top">
													<xsl:attribute name="bgcolor"><xsl:value-of select="$valueabnormbgcolor"/></xsl:attribute>
													<xsl:value-of select="m:LaboratoryResults/m:TableFormat/m:ResultValidation"/>
												</td>
											</xsl:if>
											<xsl:call-template name="ShowReqStatus"/>
											<td valign="top">
												<b>Prøvestatus:</b>
											</td>
											<td valign="top">
												<xsl:variable name="RSC" select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultStatusCode"/>
												<xsl:choose>
													<xsl:when test="$RSC='svar_endeligt'">Endeligt resultat</xsl:when>
													<xsl:when test="$RSC='svar_midlertidigt'">Midlertidigt resultat</xsl:when>
													<xsl:when test="$RSC='svar_rettet'">Rettet resultat</xsl:when>
													<xsl:when test="$RSC='proeve_modtaget'">Prøvemodtaget</xsl:when>
												</xsl:choose>
											</td>
											<td valign="top">
												<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:for-each select="m:RequisitionInformation/m:Comments">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Kommentarer til rekvisitionen
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select=".">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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
						</xsl:for-each>
						<xsl:for-each select="m:LaboratoryResults/m:CodedFormat">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:DiagnosisHeadline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:Sample">
																<tr>
																	<td valign="top">
																		<table>
																			<tbody>
																				<tr>
																					<td valign="top">
																						<b>Materiale: </b>
																					</td>
																					<td valign="top">
																						<xsl:value-of select="m:MaterialDescription"/>
																					</td>
																					<td>
																						<b>Rekvirentens ID:</b>
																					</td>
																					<td>
																						<xsl:value-of select="m:RequesterSampleIdentifier"/>
																					</td>
																					<td>
																						<b>Laboratoriets ID:</b>
																					</td>
																					<td>
																						<xsl:value-of select="m:LaboratoryInternalSampleIdentifier"/>
																					</td>
																				</tr>
																			</tbody>
																		</table>
																	</td>
																</tr>
																<xsl:for-each select="m:CodedResults">
																	<tr>
																		<td valign="top">
																			<table>
																				<tbody>
																					<xsl:for-each select="m:Topography">
																						<tr>
																							<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																							<td valign="top">
																								<b>Topografi:</b>
																							</td>
																							<td>
																								<xsl:value-of select="m:Code"/>
																							</td>
																							<td>
																								<xsl:value-of select="m:Text"/>
																							</td>
																							<td>
																								<xsl:value-of select="m:Comment"/>
																							</td>
																						</tr>
																					</xsl:for-each>
																					<xsl:for-each select="m:Result">
																						<xsl:variable name="isevenrow" select="not(position() mod 2=0)"/>
																						<tr>
																							<xsl:if test="not($isevenrow)">
																								<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																							</xsl:if>
																							<xsl:if test="$isevenrow">
																								<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																							</xsl:if>
																							<td valign="top">
																								<b>Resultat:</b>
																							</td>
																							<td>
																								<xsl:value-of select="m:Code"/>
																							</td>
																							<td>
																								<xsl:value-of select="m:Text"/>
																							</td>
																							<td>
																								<xsl:value-of select="m:Comment"/>
																							</td>
																						</tr>
																					</xsl:for-each>
																				</tbody>
																			</table>
																		</td>
																	</tr>
																</xsl:for-each>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:for-each>
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Macroscopic">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates select="m:Text/text()|m:Text/*"/>
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
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Microscopic">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates select="m:Text/text()|m:Text/*"/>
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
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Conclusion">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates select="m:Text/text()|m:Text/*"/>
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
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Hematology">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
														  <tr>
														    <th>
														      <xsl:value-of select="m:Labels/m:CellTypes"/>
														    </th>
														    <th>
														      <xsl:value-of select="m:Labels/m:Marrow"/>
														    </th>
														    <th>
														      <xsl:value-of select="m:Labels/m:Peripheral"/>
														    </th>
														  </tr>
														  <xsl:for-each select="m:Result">
														    <xsl:variable name="isevenrow" select="not(position() mod 2=0)"/>
														    <tr>
														      <xsl:if test="not($isevenrow)">
														        <xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
														      </xsl:if>
														      <xsl:if test="$isevenrow">
														        <xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
														      </xsl:if>
														      <td>
														        <xsl:value-of select="m:CellType"/>
														      </td>
														      <td align="right">
														        <xsl:value-of select="m:Marrow"/>
														      </td>
														      <td align="right">
														        <xsl:value-of select="m:Peripheral"/>
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
						</xsl:for-each>
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Comments">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates select="m:Text/text()|m:Text/*"/>
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
						<xsl:if test="count(m:RequisitionInformation/m:ClinicalInformation)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Klinisk information
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:RequisitionInformation/m:ClinicalInformation">
																<tr>
																	<td valign="top">
																		<xsl:apply-templates/>
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

	<!--  
		GENETICSREPORT  
	-->
	<xsl:template match="m:Emessage[m:GeneticsReport]">
		<xsl:for-each select="m:GeneticsReport">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Klinisk Genetiske svar'"
								/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget:</b>
											</td>
											<td valign="top">
												<xsl:for-each
												select="m:RequisitionInformation/m:SamplingDateTime">
												<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Prøve modtaget:</b>
											</td>
											<td valign="top">
												<xsl:for-each
												select="m:RequisitionInformation/m:SampleReceivedDateTime">
												<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Tabelsvar:</b>
											</td>
											<td valign="top">
												<xsl:value-of select="m:LaboratoryResults/m:TableFormat/m:TableResult"/>
											</td>
											<xsl:if test="m:LaboratoryResults/m:GeneralResultInformation/m:ToLabIdentifier">
												<td valign="top">
													<xsl:value-of select="m:LaboratoryResults/m:GeneralResultInformation/m:ToLabIdentifier"/>
												</td>	
											</xsl:if>											
											<xsl:call-template name="ShowReqStatus"/>
											<td valign="top">
												<b>Prøvestatus:</b>
											</td>
											<td valign="top">
												<xsl:variable name="RSC" select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultStatusCode"/>
												<xsl:choose>
													<xsl:when test="$RSC='svar_endeligt'">Endeligt resultat</xsl:when>
													<xsl:when test="$RSC='svar_midlertidigt'">Midlertidigt resultat</xsl:when>
													<xsl:when test="$RSC='svar_rettet'">Rettet resultat</xsl:when>
													<xsl:when test="$RSC='proeve_modtaget'">Prøvemodtaget</xsl:when>
												</xsl:choose>
											</td>
											<td valign="top">
												<xsl:for-each
													select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:for-each select="m:RequisitionInformation/m:Comments">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
												<b>
												Kommentarer til rekvisitionen
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
												<table>
												<tbody>
												<xsl:for-each select=".">
												<tr>
												<td valign="top">
												<xsl:apply-templates/>
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
						</xsl:for-each>
						
						<xsl:for-each select="m:LaboratoryResults/m:CodedFormat">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
												<table>
												<tbody>
												<xsl:for-each select="m:Sample">
												<tr>
												<td valign="top">
												<table>
												<tbody>
												<tr>
												<td valign="top">
												<b>Materiale:</b>
												</td>
												<td valign="top">
												<xsl:value-of select="m:MaterialDescription"/>
												</td>
												<td>
												<b>Rekvirentens ID:</b>
												</td>
												<td>
												<xsl:value-of select="m:RequesterSampleIdentifier"
												/>
												</td>
												<td>
												<b>Laboratoriets ID:</b>
												</td>
												<td>
												<xsl:value-of
												select="m:LaboratoryInternalSampleIdentifier"/>
												</td>
												</tr>
												</tbody>
												</table>
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
						</xsl:for-each>
						
						<xsl:if test="count(m:RequisitionInformation/m:ClinicalInformation)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
												<b>
														Kliniske oplysninger, indikation
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
												<table>
												<tbody>
												<xsl:for-each
												select="m:RequisitionInformation/m:ClinicalInformation">
												<tr>
												<td valign="top">
												<xsl:apply-templates/>
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

						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:AnalysisHeadline">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates
																		select="m:Text/text()|m:Text/*"/>
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
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:InternalReference">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates
																		select="m:Text/text()|m:Text/*"/>
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
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:GenomeReference">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														<xsl:value-of select="m:Headline"/>
													</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:apply-templates
																		select="m:Text/text()|m:Text/*"/>
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
						
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:AnalysisMethod">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
												<b>
												<xsl:value-of select="m:Headline"/>
												</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
												<table>
												<tbody>
												<tr>
												<td valign="top">
												<xsl:apply-templates
												select="m:Text/text()|m:Text/*"/>
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
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:AnalysisResults">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
												<b>
												<xsl:value-of select="m:Headline"/>
												</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
												<table>
												<tbody>
												<tr>
												<td valign="top">
												<xsl:apply-templates
												select="m:Text/text()|m:Text/*"/>
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
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Conclusion">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
												<b>
												<xsl:value-of select="m:Headline"/>
												</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
												<table>
												<tbody>
												<tr>
												<td valign="top">
												<xsl:apply-templates
												select="m:Text/text()|m:Text/*"/>
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
						
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Comments">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
												<b>
												<xsl:value-of select="m:Headline"/>
												</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
												<table>
												<tbody>
												<tr>
												<td valign="top">
												<xsl:apply-templates
												select="m:Text/text()|m:Text/*"/>
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
							<xsl:call-template name="ShowPatient"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>

	<!-- DIABETICFOOTSTATUS -->
	<xsl:template match="m:Emessage[m:DiabeticFootStatus]">
		<xsl:for-each select="m:DiabeticFootStatus">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Årlig fodstatus for diabetikere'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SamplingDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Svaret:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:RequisitionInformation/m:Comments)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top" width="100%">
													<b>Kommentarer til fodstatus</b>
												</td>
											</tr>
											<tr>
												<td valign="top" width="100%">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:RequisitionInformation/m:Comments">
																		<xsl:apply-templates/>
																	</xsl:for-each>
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
						</xsl:if>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Resultater</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<tr bgcolor="#cccccc">
															<td valign="top">
																<b>Analyse</b>
															</td>
															<td valign="top">
																<b>Værdi</b>
															</td>
															<td valign="top">
																<b>Bem.</b>
															</td>
															<td valign="top">
																<b>Enhed</b>
															</td>
															<td valign="top">
																<b>Status</b>
															</td>
															<td/>
														</tr>
														<xsl:for-each select="m:LaboratoryResults/m:Result">
															<xsl:variable name="GNr" select="position()"/>
															<xsl:variable name="isevenrow" select="position() mod 2 = 0"/>
															<tr>
																<xsl:if test="not($isevenrow)">
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																</xsl:if>
																<xsl:if test="$isevenrow">
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																</xsl:if>
																<td valign="top">
																	<xsl:choose>
																		<xsl:when test="m:Analysis/m:AnalysisShortName">
																			<xsl:value-of select="m:Analysis/m:AnalysisShortName"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="concat(m:Analysis/m:AnalysisCompleteName,' (',m:Analysis/m:AnalysisCode,':',m:Analysis/m:AnalysisCodeResponsible,')')"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</td>
																<td valign="top">
																	<xsl:attribute name="title">
																		<xsl:if test="m:ResultTextValue">
																			<xsl:text>Tekstværdi: </xsl:text><xsl:value-of select="m:ResultTextValue"/><xsl:text>, 
</xsl:text>
																		</xsl:if>
																		<xsl:text>Producent: </xsl:text><xsl:value-of select="m:ProducerOfLabResult"/>
																	</xsl:attribute>
																	<xsl:choose>
																		<xsl:when test="m:ResultValidation">
																			<xsl:variable name="RV" select="m:ResultValidation"/>
																			<xsl:choose>
																				<xsl:when test="$RV='unormal' ">
																					<xsl:attribute name="bgcolor"><xsl:value-of select="$valueabnormbgcolor"/></xsl:attribute>
																				</xsl:when>
																				<xsl:when test="$RV='for_hoej' ">
																					<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetohighbgcolor"/></xsl:attribute>
																				</xsl:when>
																				<xsl:when test="$RV='for_lav' ">
																					<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetolowbgcolor"/></xsl:attribute>
																				</xsl:when>
																			</xsl:choose>
																		</xsl:when>
																	</xsl:choose>
																	<xsl:variable name="O" select="m:Operator"/>
																	<xsl:choose>
																		<xsl:when test="$O='mindre_end'">&lt;</xsl:when>
																		<xsl:when test="$O='stoerre_end'">&gt;</xsl:when>
																	</xsl:choose>
																	<xsl:value-of select="m:Value"/>
																</td>
																<td valign="top">
																	<xsl:if test="count(m:ResultComments)>0">
																		<font size="1">
																			<xsl:attribute name="title"><xsl:value-of select="m:ResultComments"/></xsl:attribute>
																			<xsl:value-of select="$GNr"/>
																		</font>
																	</xsl:if>
																</td>
																<td valign="top">
																	<xsl:value-of select="m:Unit"/>
																</td>
																<td valign="top">
																	<xsl:variable name="RSC" select="m:ResultStatusCode"/>
																	<xsl:choose>
																		<xsl:when test="$RSC='svar_endeligt'">Endeligt resultat</xsl:when>
																		<xsl:when test="$RSC='svar_midlertidigt'">Midlertidigt resultat</xsl:when>
																		<xsl:when test="$RSC='svar_rettet'">Rettet resultat</xsl:when>
																		<xsl:when test="$RSC='proeve_modtaget'">Prøvemodtaget</xsl:when>
																	</xsl:choose>
																</td>
																<td>
																	<xsl:for-each select="m:Reference[m:URL]">
																		<a>
																			<xsl:attribute name="href"><xsl:value-of select="m:URL"/></xsl:attribute>
																			<img src="img/urlicon.PNG">
																				<xsl:attribute name="alt"><xsl:value-of select="m:RefDescription"/></xsl:attribute>
																			</img>
																		</a>
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
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Bemærkninger</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
													    <xsl:for-each select="m:LaboratoryResults">
													    	<xsl:for-each select="m:Result">
													    		<xsl:variable name="GNr" select="position()"/>
													    		<xsl:if test="count(m:ResultComments)>0">
													    			<tr>
													    				<td valign="top">
													    					<font size="1">
													    						<xsl:value-of select="$GNr"/>
													    					</font>
													    				</td>
													    				<td valign="top">
													    					<table>
													    						<tbody>
													    							<xsl:for-each select="m:ResultComments">
													    								<tr>
													    									<td valign="top">
													    										<xsl:apply-templates/>
													    									</td>
													    								</tr>
													    							</xsl:for-each>
													    						</tbody>
													    					</table>
													    				</td>
													    			</tr>
													    		</xsl:if>
												    		</xsl:for-each>
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


	<xsl:template name="ShowReqStatus">
		<td valign="top">
			<b>Status:</b>
		</td>
		<td valign="top">
			<xsl:variable name="RS" select="m:LaboratoryResults/m:GeneralResultInformation/m:ReportStatusCode"/>
			<table border="0">
				<tbody>
					<tr>
						<xsl:choose>
							<xsl:when test="$RS='komplet_svar'">
								<td valign="top">Komplet svar</td>
								<td><img src="img/Ikon_Komplet.PNG"></img></td>
							</xsl:when>
							<xsl:when test="$RS='del_svar'">
								<td valign="top">Delsvar</td>
								<td><img src="img/Ikon_Delsvar.PNG"></img></td>
							</xsl:when>
							<xsl:when test="$RS='modtaget'">
								<td valign="top">Prøvemodtaget</td>
								<td><img src="img/Ikon_Modtaget.PNG"></img></td>
							</xsl:when>
							<xsl:otherwise>
								<td>Bestilt</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</tbody>
			</table>
		</td>
	</xsl:template>

	<xsl:template name="ShowPatient">
		<xsl:param name="MedComLetter" select="."/>
		<td valign="top" class="footer">
			<table>
				<tr>
					<td width="50%" valign="top">
						<b>Patient</b>
					</td>
				</tr>
				<tr>
					<td class="frame">
						<div>
							<table>
								<xsl:for-each select="$MedComLetter/*[local-name(.)='Patient']">
									<xsl:call-template name="ShowPerson"/>
								</xsl:for-each>
							</table>
						</div>
					</td>
				</tr>				
			</table>
		</td>
	</xsl:template>
	
	<!--  
		LABORATORYANALYSISFILE  
	-->
	<xsl:template match="m:Emessage[m:LaboratoryAnalysisFile]">
		<xsl:for-each select="m:LaboratoryAnalysisFile">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Analysekatalog'" />
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">Laboratorium: <xsl:value-of select="m:GeneralInformation/m:LaboratoryShortName"/></td>
											<td valign="top">Ref.nr.: <xsl:value-of select="m:GeneralInformation/m:ReferenceNumber"/></td>
											<td valign="top">Forrige ref.nr.: <xsl:value-of select="m:GeneralInformation/m:Previous/m:ReferenceNumber"/></td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>

						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<th>Analysekode</th>
											<th>Status</th>
											<th>Gyldig fra</th>
											<th>Type</th>
											<th>Ansv.</th>
											<th>Analysenavn</th>
											<th>Kort analysenavn</th>
											<th>Prioritet</th>
											<th>Anvendelse</th>
											<th>Solitær</th>
											<th>Glas</th>
											<th>Glasgruppe</th>
											<th>Etikettegruppe</th>
											<th>Etikettetekst</th>
											<th>Glasantal</th>
											<th>Etikettetype</th>
											<th>Prompt</th>
											<th>Rekv.gruppekode</th>
											<th>Sortering</th>
										</tr>
										<xsl:for-each select="m:AnalysisDetails">
											<xsl:variable name="isevenrow" select="position() mod 2 = 0"/>
											<tr>
												<xsl:if test="not($isevenrow)">
													<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
												</xsl:if>
												<xsl:if test="$isevenrow">
													<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
												</xsl:if>
												<td valign="top"><xsl:value-of select="m:Code"/></td>
												<td valign="top"><xsl:value-of select="m:StatusCode"/></td>
												<td valign="top">
													<xsl:for-each select="m:ValidFrom">
														<xsl:call-template name="FormatDateTime"/>
													</xsl:for-each>
												</td>
												<td valign="top"><xsl:value-of select="m:CodeType"/></td>
												<td valign="top"><xsl:value-of select="m:CodeResponsible"/></td>
												<td valign="top"><xsl:value-of select="m:FullName"/></td>
												<td valign="top"><xsl:value-of select="m:ShortName"/></td>
												<td valign="top"><xsl:value-of select="m:MaxResultPriority"/></td>
												<td valign="top"><xsl:value-of select="m:RequestInformation"/></td>
												<td valign="top">
													<xsl:variable name="Sol" select="m:IsASingleAnalysis"/>
													<xsl:choose>
														<xsl:when test="$Sol='true'">Ja</xsl:when>
														<xsl:when test="$Sol='false'">Nej</xsl:when>
													</xsl:choose>
												</td>

												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:TypeOfTestTubes">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:ShortName"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:ShortNameResponsible"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Description"/>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:TestTubeGroup">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:Identifier"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:IdentifierResponsible"/>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
												
												<td valign="top"><xsl:value-of select="m:LabelType"/></td>
												<td valign="top"><xsl:value-of select="m:LabelTextCode"/></td>
												<td valign="top"><xsl:value-of select="m:NumberOfTestTubes"/></td>
												<td valign="top">
													<xsl:value-of select="m:BarcodeType"/>
													<xsl:if test="m:LabelTypeInBarcode != ''">
													<br/>
													</xsl:if>	
													<xsl:value-of select="m:LabelTypeInBarcode"/>
												</td>

												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:Prompt">
																<xsl:variable name="SpmJN" select="m:Question/m:ToBeAnsweredWithBooleanValue/m:Code"/>
																<xsl:if test="$SpmJN != ''">
																	<tr>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithBooleanValue/m:Code"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithBooleanValue/m:TextValue"/>
																		</td>
																	</tr>
																</xsl:if>	
																<xsl:variable name="SpmDa" select="m:Question/m:ToBeAnsweredWithDateValue/m:Code"/>
																<xsl:if test="$SpmDa != ''">
																	<tr>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithDateValue/m:Code"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithDateValue/m:TextValue"/>
																		</td>
																	</tr>
																</xsl:if>	
																<xsl:variable name="SpmDi" select="m:Question/m:ToBeAnsweredWithDiagnoseValue/m:Code"/>
																<xsl:if test="$SpmDi != ''">
																	<tr>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithDiagnoseValue/m:Code"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithDiagnoseValue/m:TextValue"/>
																		</td>
																	</tr>
																</xsl:if>	
																<xsl:variable name="SpmN" select="m:Question/m:ToBeAnsweredWithNumericValue/m:Code"/>
																<xsl:if test="$SpmN != ''">
																	<tr>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithNumericValue/m:Code"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithNumericValue/m:TextValue"/>
																		</td>
																	</tr>
																</xsl:if>	
																<xsl:variable name="SpmT" select="m:Question/m:ToBeAnsweredWithTextValue/m:Code"/>
																<xsl:if test="$SpmT != ''">
																	<tr>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithTextValue/m:Code"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithTextValue/m:TextValue"/>
																		</td>
																	</tr>
																</xsl:if>	
																<xsl:variable name="SpmJNT" select="m:Question/m:ToBeAnsweredWithBooleanAndTextValue/m:Code"/>
																<xsl:if test="$SpmJNT != ''">
																	<tr>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithBooleanAndTextValue/m:Code"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:ToBeAnsweredWithBooleanAndTextValue/m:TextValue"/>
																		</td>
																	</tr>
																</xsl:if>	
																<xsl:variable name="SpmS" select="m:Question/m:ToBeAnsweredWithSelection/m:Choice/m:Code"/>
																<xsl:if test="$SpmS != ''">
																	<xsl:for-each select="m:Question/m:ToBeAnsweredWithSelection/m:Choice">
																	<tr>
																		<td valign="top">
																			<xsl:value-of select="m:Code"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:TextValue"/>
																		</td>
																	</tr>
																	</xsl:for-each>
																</xsl:if>	
															</xsl:for-each>
														</tbody>
													</table>
												</td>
												
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:RequisitionGroup">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:Identifier"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:IdentifierResponsible"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Name"/>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:Order">
																<tr>
																	<td valign="top"><xsl:apply-templates/></td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</td>
						</tr>

						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>

	<!-- PATHOLOGYREQUEST -->
	<xsl:template match="m:Emessage[m:PathologyRequest]">
		<xsl:for-each select="m:PathologyRequest">
			<tr>
				<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
					<table width="100%">
						<tbody>
							<tr>
								<xsl:call-template name="ShowMessageHeader">
									<xsl:with-param name="MessageName" select="'Patologirekvisition'"/>
								</xsl:call-template>
							</tr>
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Rekvisition:</b>
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
													<xsl:value-of select="m:RequisitionInformation/m:RequestersRequisitionIdentifier"/>
												</td>
												<xsl:if test="m:RequisitionInformation/m:SampleIdentifierType='nationaltproevenummer'">
													<td>NPN</td>
												</xsl:if>
											</tr>
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
														<b>Klinisk information</b>
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
							<xsl:for-each select="m:RequisitionInformation/m:CodedClinicalInformation">
								<tr>
									<td valign="top" width="100%">
										<table>
											<tbody>
												<tr>
													<td valign="top">
														<b>Kodet klinisk information</b>
													</td>
												</tr>
												<tr>
													<td valign="top">
														<table>
															<tbody>
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:IndicationCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:IndicationText"/>
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
														<b>Kommentarer</b>
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
													<b>Prøver</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td>
																	<b>Prøve ID</b>
																</td>
																<td></td>
																<td>
																	<b>Materiale</b>
																</td>
																<td>
																	<b>Forbehandling</b>
																</td>
																<td>
																	<b>Referencer</b>
																</td>
															</tr>
															<xsl:for-each select="m:RequisitionInformation/m:Sample">
																<xsl:variable name="isevenrow" select="position() mod 2=0"/>
																<xsl:variable name="npn" select="m:SampleIdentifierType"/>
																<tr>
																	<xsl:if test="not($isevenrow)">
																		<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																	</xsl:if>
																	<xsl:if test="$isevenrow">
																		<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																	</xsl:if>
																	<td valign="top">
																		<xsl:value-of select="m:RequesterSampleIdentifier"/>
																	</td>
																	<td>
																		<xsl:choose>
																			<xsl:when test="$npn='nationaltproevenummer'">NPN</xsl:when>
																		</xsl:choose>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:MaterialDescription"/>
																	</td>
																	<td valign="top">
																	  <xsl:for-each select="m:MaterialPreTreatment">
																		<xsl:value-of select="."/><xsl:text> </xsl:text>
																	  </xsl:for-each>
																	</td>
																	<td>
																		<table>
																			<tbody>
																				<tr>
																					<xsl:call-template name="showReferences">
																						<xsl:with-param name="Refs" select="m:Reference"/>
																						<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
																					</xsl:call-template>
																				</tr>
																			</tbody>
																		</table>
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
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Ønsket analyse</b>
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
																	<b>AnalyseTekst</b>
																</td>
																<td>
																	<b>Ønsket svartidspunkt</b>
																</td>
															</tr>
															<xsl:for-each select="m:Requests/m:RequestedAnalysis">
																<xsl:variable name="isevenrow" select="position() mod 2=0"/>
																<tr>
																	<xsl:if test="not($isevenrow)">
																		<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowhighlightbgcolor"/></xsl:attribute>
																	</xsl:if>
																	<xsl:if test="$isevenrow">
																		<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowhighlightbgcolor"/></xsl:attribute>
																	</xsl:if>
																	<td valign="top">
																		<xsl:value-of select="m:ResultPriority"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Analysis/m:AnalysisCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Analysis/m:AnalysisCodeType"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Analysis/m:AnalysisShortName"/>
																	</td>
																	<td valign="top">
																		<xsl:if test="m:AnswerAtLatestDateTime">
																			<xsl:for-each select="m:AnswerAtLatestDateTime">
																				<xsl:call-template name="FormatDateTime"/>
																			</xsl:for-each>
																		</xsl:if>
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
																			<xsl:for-each select="m:Answer/m:Logical">
																				<xsl:variable name="SvarJN" select="."/>
																				<xsl:if test="translate(substring($SvarJN,1,1),'YNTFtf10','ynynynyn')='y'">Ja</xsl:if>
																				<xsl:if test="translate(substring($SvarJN,1,1),'YNTFtf10','ynynynyn')='n'">Nej</xsl:if>
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
								<xsl:call-template name="ShowCarbonCopyReceiver"/>
							</tr>
							<tr>
								<xsl:call-template name="ShowPatientAndRelatives"/>
							</tr>
							<tr>
								<xsl:call-template name="ShowParticipants"/>
							</tr>
							<tr>
								 <xsl:variable name="MedComLetter" select="."/>
						         <xsl:variable name="FontColor" select="$footerfontcolor"/>
						         <xsl:variable name="bgcolor" select="$footerbgcolor"/>
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
							
						</tbody>
					</table>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
