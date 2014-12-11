<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/" xmlns:gepj="http://medinfo.dk/epj/proj/gepka/20030701/xml/schema" xmlns:cpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/" xmlns:dkcc="http://rep.oio.dk/ebxml/xml/schemas/dkcc/2003/02/13/" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output media-type="text/html"/>

	<!-- 	DISCHARGELETTER -->
	<xsl:template match="m:Emessage[m:DischargeLetter]">
		<xsl:for-each select="m:DischargeLetter">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Udskrivningsepikrise'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Indlæggelse<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Admission">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Udskrivning<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Discharge">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Diagnose)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Diagnoser/undersøgelser
											</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Diagnose/m:Main">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:MainAdditional">
																<tr>
																	<td valign="top">
																		<b>Bidiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:Other">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:DiagnoseDateTime">
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
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
												Epikrise
											</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:ClinicalInformation">
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:Signed">
																		<xsl:call-template name="FormatDateTime"/>
																	</xsl:for-each>
																</td>
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
	<!-- 	OUTPATIENTDISCHARGELETTER	-->
	<xsl:template match="m:Emessage[m:OutPatientDischargeLetter]">
		<xsl:for-each select="m:OutPatientDischargeLetter">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Ambulantepikrise'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Første besøg<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:OutPatientFirstVisit">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Sidste besøg<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:OutPatientLastVisit">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Diagnose)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Diagnoser/undersøgelser
											</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Diagnose/m:Main">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:MainAdditional">
																<tr>
																	<td valign="top">
																		<b>Bidiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:Other">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:DiagnoseDateTime">
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
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
												Epikrise
											</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:ClinicalInformation">
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:Signed">
																		<xsl:call-template name="FormatDateTime"/>
																	</xsl:for-each>
																</td>
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
	<!-- CASUALTYWARDLETTER -->
	<xsl:template match="m:Emessage[m:CasualtyWardLetter]">
		<xsl:for-each select="m:CasualtyWardLetter">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Skadestueepikrise'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Første besøg<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:CasualtyWardFirstVisit">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Sidste besøg<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:CasualtyWardLastVisit">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Diagnose)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Diagnoser/undersøgelser
											</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Diagnose/m:Main">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:MainAdditional">
																<tr>
																	<td valign="top">
																		<b>Bidiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:Other">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:DiagnoseDateTime">
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
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
												Epikrise
											</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:ClinicalInformation">
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:Signed">
																		<xsl:call-template name="FormatDateTime"/>
																	</xsl:for-each>
																</td>
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
	<!-- 	BOOKINGCONFIRMATION -->
	<xsl:template match="m:Emessage[m:BookingConfirmation]">
		<xsl:for-each select="m:BookingConfirmation">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Bookingsvar'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Anmodning</b>
											</td>
											<td valign="top">
												<xsl:value-of select="m:Referral/m:Identifier"/>
											</td>
											<td valign="top">
												<b>modtaget</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Referral/m:Received">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Confirmation)>0">
												
											</xsl:if>
						<xsl:for-each select="m:Confirmation">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>og er booket til</b>
												</td>
												<td valign="top">
													<xsl:for-each select=".">
														<xsl:call-template name="FormatDateTime"/>
													</xsl:for-each>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:for-each>
						<xsl:for-each select="m:ClinicalInformation">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:for-each>
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
	<!-- 	CLINICALEMAIL -->
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
												<b>
												Brevtekst
											</b>
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
	<!-- 	NOTIFICATIONOFADMISSION -->
	<xsl:template match="m:Emessage[m:NotificationOfAdmission]">
		<xsl:for-each select="m:NotificationOfAdmission">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Indlæggelsessadvis'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Indlæggelse<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Admission">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
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
	<!-- 	NOTIFICATIONOFDISCHARGE -->
	<xsl:template match="m:Emessage[m:NotificationOfDischarge]">
		<xsl:for-each select="m:NotificationOfDischarge">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Udskrivningsadvis'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Udskrivning<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Discharge">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
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
	<!-- 	ANSWEROFADMISSION -->
	<xsl:template match="m:Emessage[m:AnswerOfAdmission]">
		<xsl:for-each select="m:AnswerOfAdmission">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Indlæggelsessvar'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<xsl:for-each select="m:Sender/m:ContactInformation">
											<tr>
												<td valign="top">
													<b>Kontaktinformation:</b>
												</td>
												<td valign="top">
													<xsl:for-each select="m:ContactName">
														<xsl:value-of select="concat(.,' ')"/>
													</xsl:for-each>
												</td>
												<td>
													<xsl:for-each select="m:TelephoneSubscriberIdentifier">
														<xsl:value-of select="concat('Tlf: ',.)"/>
													</xsl:for-each>
												</td>
												<td>
													<xsl:for-each select="m:ContactTimeText">
														<xsl:value-of select="."/>
													</xsl:for-each>
												</td>
											</tr>
										</xsl:for-each>
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
	<!-- 	WARNINGOFDISCHARGE -->
	<xsl:template match="m:Emessage[m:WarningOfDischarge]">
		<xsl:for-each select="m:WarningOfDischarge">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Varsling af færdigbehandling'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Indlæggelse<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Admission">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Forventet udskrivning<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:PlannedDischarge">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<b>Plankonference<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:PlanConfererence">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Behandlingsafslutning<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:EndOfTreatment">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:for-each select="m:CareDescription">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Kommentarer
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:CommentsText">
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
						</xsl:for-each>
						<tr>
							<xsl:call-template name="showReferences">
								<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
							</xsl:call-template>
						</tr>
						<tr>
							<xsl:call-template name="ShowPatientAndRelatives"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowFamilyDoctor"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>
	<!--	HOSPITALREFERRAL -->
	<xsl:template match="m:Emessage[m:HospitalReferral]">
		<xsl:for-each select="m:HospitalReferral">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Sygehushenvisning'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<xsl:for-each select="m:AdditionalInformation/m:Priority">
												<td valign="top">
													<b>Prioritet:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:ReferralStatus">
												<td valign="top">
													<b>Henvisningstype:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:Transport">
												<td valign="top">
													<b>Transport:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:Supplementary">
												<td valign="top">
													<b>Andet:</b>
												</td>
												<td valign="top">
													<xsl:apply-templates/>
												</td>
											</xsl:for-each>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Referral)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Henvisnings diagnoser
											</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Referral/m:Refer">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Referral/m:ReferralAdditional">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
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
												Ønsket undersøgelse/behandling/problemstilling											</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:attribute name="bgcolor"><xsl:value-of select="$highlightbgcolor"/></xsl:attribute>
												<table>
													<tbody>
														<xsl:for-each select="m:AdditionalInformation/m:ClinicalReason">
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
						<tr>
							<td valign="top" width="100%">
								<table width="100%">
									<tbody>
										<tr>
											<td valign="top" width="100%">
												<b>
												Kliniske oplysninger
											</b>
											</td>
										</tr>
										<tr>
											<xsl:attribute name="bgcolor"><xsl:value-of select="$compoundbgcolor"/></xsl:attribute>
											<td valign="top" width="100%">
												<table width="100%">
													<tbody>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Cave">
															<tr>
																<td>
																	<b>Cave</b>
																</td>
															</tr>
															<tr>
																<td>
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
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Anamnesis">
															<tr>
																<td>
																	<b>Anamnese</b>
																</td>
															</tr>
															<tr>
																<td>
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
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Examination">
															<tr>
																<td>
																	<b>Undersøgelser/behandlinger</b>
																</td>
															</tr>
															<tr>
																<td>
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
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:ActualMedicine">
															<tr>
																<td>
																	<b>Aktuel medicin</b>
																</td>
															</tr>
															<tr>
																<td>
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
						<xsl:if test="count(m:HospitalVisitation)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Visitation (udfyldt af modtager)</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:HospitalVisitation">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:InformationCode"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:Information">
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
	<!--	XRAYREQUEST -->
	<xsl:template match="m:Emessage[m:XrayRequest]">
		<xsl:for-each select="m:XrayRequest">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Røntgenhenvisning'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<xsl:for-each select="m:AdditionalInformation/m:Priority">
												<td valign="top">
													<b>Prioritet:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:ReferralStatus">
												<td valign="top">
													<b>Henvisningstype:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:Transport">
												<td valign="top">
													<b>Transport:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:Supplementary">
												<td valign="top">
													<b>Andet:</b>
												</td>
												<td valign="top">
													<xsl:apply-templates/>
												</td>
											</xsl:for-each>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Referral)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Henvisnings diagnoser
											</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Referral/m:Refer">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Referral/m:ReferralAdditional">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
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
												Ønsket undersøgelse/behandling/problemstilling											</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:attribute name="bgcolor"><xsl:value-of select="$highlightbgcolor"/></xsl:attribute>
												<table>
													<tbody>
														<xsl:for-each select="m:AdditionalInformation/m:ClinicalReason">
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
						<tr>
							<td valign="top" width="100%">
								<table width="100%">
									<tbody>
										<tr>
											<td valign="top" width="100%">
												<b>
												Kliniske oplysninger
											</b>
											</td>
										</tr>
										<tr>
											<xsl:attribute name="bgcolor"><xsl:value-of select="$compoundbgcolor"/></xsl:attribute>
											<td valign="top" width="100%">
												<table width="100%">
													<tbody>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Cave">
															<tr>
																<td>
																	<b>Cave</b>
																</td>
															</tr>
															<tr>
																<td>
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
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Anamnesis">
															<tr>
																<td>
																	<b>Anamnese</b>
																</td>
															</tr>
															<tr>
																<td>
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
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Examination">
															<tr>
																<td>
																	<b>Undersøgelser/behandlinger</b>
																</td>
															</tr>
															<tr>
																<td>
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
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:ActualMedicine">
															<tr>
																<td>
																	<b>Aktuel medicin</b>
																</td>
															</tr>
															<tr>
																<td>
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
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:FirstDateOfPeriod">
															<tr>
																<td>
																	<b>Graviditetsoplysninger</b>
																</td>
															</tr>
															<tr>
																<td>
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
						<xsl:if test="count(m:HospitalVisitation)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Visitation (udfyldt af modtager)</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:HospitalVisitation">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:InformationCode"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:Information">
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
	<!-- 	LABORATORYREQUEST -->
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
													<xsl:value-of select="m:RequisitionInformation/m:Sample/m:RequesterSampleIdentifier"/>
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
														<b>
												Klinisk information
											</b>
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
														<b>
												Kommentarer
											</b>
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
													<b>
												Ønskede analyser
											</b>
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
																		<xsl:value-of select="m:Analysis/m:AnalysisCodeResponsible"/>
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
														<b>
												Svar på analyserelevante spørgsmål
											</b>
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
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																		</xsl:if>
																		<xsl:if test="$isevenrow">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																		</xsl:if>
																		<td valign="top">
																			<xsl:value-of select="m:Question"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:Answer/m:Text"/>
																			<xsl:for-each select="m:Answer/m:Numerical">
																				<xsl:value-of select="concat(m:Value,' ',m:Unit)"/>
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
						</tbody>
					</table>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- 	MICROBIOLOGYREQUEST -->
	<xsl:template match="m:Emessage[m:MicrobiologyRequest]">
		<xsl:for-each select="m:MicrobiologyRequest">
			<tr>
				<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
					<table width="100%">
						<tbody>
							<tr>
								<xsl:call-template name="ShowMessageHeader">
									<xsl:with-param name="MessageName" select="'Mikrobiologirekvisition'"/>
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
													<xsl:value-of select="m:RequisitionInformation/m:Sample/m:RequesterSampleIdentifier"/>
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
														<b>
												Klinisk information
											</b>
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
														<b>
												Kommentarer
											</b>
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
													<b>
												Ønsket analyse
											</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td>
																	<b>Analysekode</b>
																</td>
																<td>
																	<b>Kodetype</b>
																</td>
																<td>
																	<b>Kodeansvarlig</b>
																</td>
																<td>
																	<b>Supplerende analyse</b>
																</td>
															</tr>
															<xsl:for-each select="m:Requests/m:RequestedAnalysis">
																<tr>
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$highlightbgcolor"/></xsl:attribute>
																	<td valign="top">
																		<xsl:value-of select="m:Analysis/m:AnalysisCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Analysis/m:AnalysisCodeType"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:Analysis/m:AnalysisCodeResponsible"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:SupplementaryAnalysis"/>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<tr>
																<td>
																	<b>MDS Undersøgelse</b>
																</td>
																<td>
																	<b>MDS Materiale</b>
																</td>
																<td>
																	<b>MDS Lokation</b>
																</td>
																<td>
																	<b>Supplerende lokation</b>
																</td>
															</tr>
															<xsl:for-each select="m:Requests/m:RequestedAnalysis">
																<tr>
																	<xsl:attribute name="bgcolor"><xsl:value-of select="$highlightbgcolor"/></xsl:attribute>
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
																		<xsl:value-of select="m:SupplementaryLocation"/>
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
														<b>
												Svar på analyserelevante spørgsmål
											</b>
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
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
																		</xsl:if>
																		<xsl:if test="$isevenrow">
																			<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
																		</xsl:if>
																		<td valign="top">
																			<xsl:value-of select="m:Question/m:CodeText"/>
																		</td>
																		<td valign="top">
																			<xsl:value-of select="m:Answer/m:Text"/>
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
						</tbody>
					</table>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- 	PATHOLOGYREQUEST  -->
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
													<xsl:value-of select="m:RequisitionInformation/m:RequestersRequisitionIdentifier"/>
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
														<b>
												Klinisk information
											</b>
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
														<b>	Kodet klinisk information</b>
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
														<b>
												Kommentarer
											</b>
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
													<b>
												Prøver
											</b>
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
													<b>
												Ønsket analyse
											</b>
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
							<xsl:for-each select="m:Requests/m:SupplementaryCervixInformations">
								<tr>
									<td valign="top" width="100%">
										<table>
											<tbody>
												<tr>
													<td valign="top">
														<b>	Svar på analyserelevante spørgsmål</b>
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
																<xsl:for-each select="m:Condyloma">
																	<tr>
																		<td>Kondylomer</td>
																		<td>
																			<xsl:call-template name="ConvertBoolean">
																				<xsl:with-param name="value" select="."/> 
																			</xsl:call-template>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:IUD">
																	<tr>
																		<td>IUD</td>
																		<td>
																			<xsl:call-template name="ConvertBoolean">
																				<xsl:with-param name="value" select="."/> 
																			</xsl:call-template>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:Pregnant">
																	<tr>
																		<td>Gravid</td>
																		<td>
																			<xsl:call-template name="ConvertBoolean">
																				<xsl:with-param name="value" select="."/> 
																			</xsl:call-template>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:DateOfPeriod">
																	<tr>
																		<td>sidste menstr.</td>
																		<td>
																			<xsl:call-template name="FormatDate"/>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:HormonThrerapy">
																	<tr>
																		<td>Hormonterapi</td>
																		<td>
																			<xsl:value-of select="."/>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:DateOfCryoTherapy">
																	<tr>
																		<td>Dato for kryoterapi</td>
																		<td>
																			<xsl:call-template name="FormatDate"/>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:DateOfLaser">
																	<tr>
																		<td>Dato for laserbehandling</td>
																		<td>
																			<xsl:call-template name="FormatDate"/>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:DateOfConisation">
																	<tr>
																		<td>Dato for konisation</td>
																		<td>
																			<xsl:call-template name="FormatDate"/>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:DateOfHysterectomy">
																	<tr>
																		<td>Dato for hysterectomi</td>
																		<td>
																			<xsl:call-template name="FormatDate"/>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:DateOfIrradiation">
																	<tr>
																		<td>Dato for strålebehandling</td>
																		<td>
																			<xsl:call-template name="FormatDate"/>
																		</td>
																	</tr>
																</xsl:for-each>
																<xsl:for-each select="m:DateOfChemoTherapy">
																	<tr>
																		<td>Dato for kemoterapi</td>
																		<td>
																			<xsl:call-template name="FormatDate"/>
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
								<xsl:call-template name="ShowCarbonCopyReceiver"/>
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
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- 	LABORATORYREPORT -->
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
						<!--<tr>
							<td>
								<xsl:variable name="patientcpr" select="m:Patient/m:CivilRegistrationNumber"/>
								<xsl:variable name="url">
									https://www.sundhed.dk/wps/myportal/_s.155/4518?parameter_navn=cprnr_field&amp;cprnrfield=<xsl:value-of select="$patientcpr"/>
								</xsl:variable>
								<a><xsl:attribute name="href"><xsl:value-of select="$url"/></xsl:attribute>Beskrivelse på Sundhed.dk</a>
							</td>
						</tr>-->
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SamplingDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Svaret<!--tidspunkt-->:</b>
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
																<td colspan="6">
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
																<!--<xsl:variable name="CNr" select="count(../m:Result[(concat('X',m:Analysis/m:RequisitionGroup/m:Identifier)&lt;concat('X',$Id))])"/>-->
																<!-- and count(m:ResultTextValue|m:ResultComments)>0-->
																<!-- or (m:Analysis/m:RequisitionGroup/m:Identifier=$Id and concat(' ',m:Analysis/m:Order) &lt;concat(' ',$Order))-->
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
																	  <xsl:attribute name="title"><xsl:text>Tekstværdi: </xsl:text><xsl:value-of select="m:ResultTextValue"/><xsl:text>
Producent: </xsl:text><xsl:value-of select="m:ProducerOfLabResult"/></xsl:attribute>
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
																		  	   <xsl:value-of select="concat('>',m:ReferenceInterval/m:LowerLimit)"/>
																		  	</xsl:if>
																		  	<xsl:if test="count(m:ReferenceInterval/m:UpperLimit)=1">
																		  	   <xsl:value-of select="concat('&lt;',m:ReferenceInterval/m:UpperLimit)"/>
																		  	</xsl:if>

																		</xsl:if>
																		<xsl:value-of select="m:ReferenceInterval/m:IntervalText"/>
																	</td>
																	<td>
																		<xsl:value-of select="m:ResultStatusCode"/>
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
													    <xsl:for-each select="m:LaboratoryResults/m:Result[not(m:Analysis/m:RequisitionGroup)]">
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
													                <xsl:value-of select="concat(m:Analysis/m:AnalysisCompleteName,' (',m:Analysis/m:AnalysisCode,':',m:Analysis/m:AnalysisCodeResponsible,')')"/>
													            </td>
													            <td valign="top">
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
													                        <xsl:attribute name="title"><xsl:value-of select="m:ResultTextValue|m:ResultComments"/></xsl:attribute>
													                        <xsl:value-of select="$CNr"/>
													                    </font>
													                </xsl:if>
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
													                <xsl:value-of select="m:ResultStatusCode"/>
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
														<xsl:variable name="Results" select="m:LaboratoryResults/m:Result"/>
														<xsl:variable name="Firstresults" select="$Results[count(.|(key('requisitiongroup2result',m:Analysis/m:RequisitionGroup/m:Identifier))[1])=1]"/>
														<xsl:for-each select="$Firstresults">
															<xsl:sort select="m:Analysis/m:RequisitionGroup/m:Identifier"/>
															<xsl:variable name="GNr" select="position()"/>
															<xsl:variable name="Key" select="concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)"/>
															<xsl:variable name="ResultsInGrp" select="key('requisitiongroup2result',$Key)"/>
															<xsl:for-each select="$ResultsInGrp">
																<xsl:sort select="Analysis/m:Order"/>
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
																							<!--<xsl:if test="not($isevenrow)"><xsl:attribute name="bgcolor">dddddd</xsl:attribute></xsl:if>-->
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
	<!-- RADIOLOGYREPORT -->
	<xsl:template match="m:Emessage[m:RadiologyReport]">
		<xsl:for-each select="m:RadiologyReport">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Billeddiagnostisk epikrise'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Undersøgelsesstart<!--tidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:ExaminationStart">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Undersøgelsesafslutning<!--tidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:ExaminationEnd">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Diagnose)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Diagnoser/undersøgelser
											</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Diagnose/m:Main">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:MainAdditional">
																<tr>
																	<td valign="top">
																		<b>Bidiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:Other">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:DiagnoseDateTime">
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
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
												Epikrise
											</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:ClinicalInformation">
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:Signed">
																		<xsl:call-template name="FormatDateTime"/>
																	</xsl:for-each>
																</td>
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
							<td>
								<xsl:variable name="patientcpr" select="m:Patient/m:CivilRegistrationNumber"/>
								<xsl:variable name="url">
									https://www.sundhed.dk/wps/myportal/_s.155/4518?parameter_navn=cprnr_field&amp;cprnrfield=<xsl:value-of select="$patientcpr"/>
								</xsl:variable>
								<a><xsl:attribute name="href"><xsl:value-of select="$url"/></xsl:attribute>Beskrivelse på Sundhed.dk</a>
							</td>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Prøve taget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SamplingDateTime">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Prøve modtaget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:Sample/m:SampleReceivedDateTime">
													<!--ikke som i microbiologi (der er det under sample)-->
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<xsl:variable name="RS" select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultStatus"/>
												<xsl:choose>
													<xsl:when test="$RS='modtaget'">
														<b>Modtagelse bekræftet:</b>
													</xsl:when>
													<xsl:when test="$RS='delvis'">
														<b>Delvist svar:</b>
													</xsl:when>
													<xsl:when test="$RS='komplet'">
														<b>Komplet svar:</b>
													</xsl:when>
													<xsl:otherwise>
														<b>Svaret:</b>
													</xsl:otherwise>
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
																		<xsl:when test="$O='mindre_end'">&lt;</xsl:when>
																		<xsl:when test="$O='stoerre_end'">&gt;</xsl:when>
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
																	<xsl:value-of select="m:ResultStatusCode"/>
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
																						<!--<xsl:if test="not($isevenrow)"><xsl:attribute name="bgcolor">dddddd</xsl:attribute></xsl:if>-->
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
												<b>Prøve taget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:SamplingDateTime">
													<!--ikke som i microbiologi (der er det under sample)-->
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Prøve modtaget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:SampleReceivedDateTime">
													<!--ikke som i microbiologi (der er det under sample)-->
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<xsl:variable name="RSC" select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultStatusCode"/>
												<xsl:choose>
													<xsl:when test="$RSC='proeve_modtaget'">
														<b>Modtagelse bekræftet:</b>
													</xsl:when>
													<xsl:when test="$RSC='svar_midlertidigt'">
														<b>Midlertidigt svar</b>
													</xsl:when>
													<xsl:when test="$RSC='svar_endeligt'">
														<b>Endeligt svar:</b>
													</xsl:when>
													<xsl:when test="$RSC='svar_rettet'">
														<b>Rettet svar</b>
													</xsl:when>
													<xsl:otherwise>
														<b>Svaret</b>
													</xsl:otherwise>
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
						<!--<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Macroscopic">
							<tr>
								<td valign="top">
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
						</xsl:for-each>-->
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
						<!--HISTO
						<xsl:for-each select="m:LaboratoryResults/m:TextualFormat/m:Hematology">
						<tr>
							<td valign="top">
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
													<xsl:value-of select="m:CellTypes"/>
											</td>
										</tr>
										<xsl:for-each select="m:CellTypesPercentage"/>
										<tr>
											<td valign="top">
												<xsl:value-of select="."/>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						</xsl:for-each>
						-->
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
												<b>Prøve taget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:SamplingDateTime">
													<!--ikke som i microbiologi (der er det under sample)-->
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Prøve modtaget<!--stidspunkt-->:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:RequisitionInformation/m:SampleReceivedDateTime">
													<!--ikke som i microbiologi (der er det under sample)-->
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<xsl:variable name="RSC" select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultStatusCode"/>
												<xsl:choose>
													<xsl:when test="$RSC='proeve_modtaget'">
														<b>Modtagelse bekræftet:</b>
													</xsl:when>
													<xsl:when test="$RSC='svar_midlertidigt'">
														<b>Midlertidigt svar</b>
													</xsl:when>
													<xsl:when test="$RSC='svar_endeligt'">
														<b>Endeligt svar:</b>
													</xsl:when>
													<xsl:when test="$RSC='svar_rettet'">
														<b>Rettet svar</b>
													</xsl:when>
													<xsl:otherwise>
														<b>Svaret:</b>
													</xsl:otherwise>
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
		PRESCRIPTION 
	-->
	<xsl:template match="m:Emessage[m:Prescription]">
		<xsl:for-each select="m:Prescription">
			<tr>
				<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
					<xsl:variable name="P" select="."/>
					<xsl:variable name="L" select="m:Letter"/>
					<xsl:variable name="S" select="m:Sender"/>
					<xsl:variable name="I" select="$S/m:Issuer"/>
					<xsl:variable name="R" select="m:Receiver"/>
					<xsl:variable name="PoR" select="m:PatientOrRelative"/>
					<xsl:variable name="PI" select="m:PrescriptionInformation"/>
					<xsl:variable name="Ds" select="m:Drug"/>
					<xsl:for-each select="m:Drug[position() mod 3 = 1]">
						<xsl:variable name="SideNr" select="position()"/>
						<span style="position:relative;left:0mm;top:0mm;width:144mm;height:210mm;margin:0px;background-image:url(img\recept.gif);border:1pt solid black;font-size:8pt;font-family:sans-serif">
							<!--Sender area -->
							<span style="position:absolute;left:14mm;top:9mm;width:88mm;height:22mm;margin:3mm;line-height:9pt">
								<xsl:value-of select="$S/m:Identifier"/>
								<br/>
								<xsl:value-of select="$S/m:OrganisationName"/>
								<br/>
								<xsl:value-of select="$S/m:StreetName"/>
								<br/>
								<br/>
								<xsl:value-of select="concat($S/m:PostCodeIdentifier,' ','--------------',' Tlf. ',$S/m:TelephoneSubscriberIdentifier)"/>
								<span style="position:absolute;left:0mm;top:0mm;width:82mm;height:16mm;margin:0mm;text-align:right">
									<xsl:value-of select="$S/../m:PrescriptionInformation/m:SenderComputerSystem"/>
								</span>
							</span>
							<!-- Patient area -->
							<span style="position:absolute;left:6mm;top:32mm;width:97mm;height:22mm;margin:3mm;line-height:9pt">
								<xsl:if test="../m:ForGPClinicUse='true' ">Til brug i klinikken</xsl:if>
								<xsl:if test="count($PoR)>0">
									<xsl:if test="count($PoR/m:CivilRegistrationNumber)>0">
										<xsl:value-of select="concat(substring($PoR/m:CivilRegistrationNumber,1,6),'-',substring($PoR/m:CivilRegistrationNumber,7,4))"/>
									</xsl:if>
									<xsl:if test="count($PoR/m:CivilRegistrationNumber)=0">
										<xsl:value-of select="concat('f. ',substring($PoR/m:PatientDateOfBirth,9,2),'.',substring($PoR/m:PatientDateOfBirth,6,2),'.',substring($PoR/m:PatientDateOfBirth,1,4),' ')"/>
										<xsl:choose>
											<xsl:when test="$PoR/m:PatientSex='hankoen' ">Mand</xsl:when>
											<xsl:when test="$PoR/m:PatientSex='hunkoen' ">Kvinde</xsl:when>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="$PoR/m:ForGPUse='true' ">
										<xsl:value-of select="'   Til lægens eget brug'"/>
									</xsl:if>
									<br/>
									<xsl:value-of select="concat($PoR/m:PersonGivenName,' ',$PoR/m:PersonSurnameName)"/>
									<br/>
									<xsl:value-of select="$PoR/m:StreetName"/>
									<br/>
									<br/>
									<xsl:value-of select="concat($PoR/m:PostCodeIdentifier,' ',$PoR/m:DistrictName)"/>
								</xsl:if>
							</span>
							<!-- Child area -->
							<span style="position:absolute;left:6mm;top:54mm;width:97mm;height:6mm;margin:3mm;line-height:9pt">
								<xsl:if test="$PoR/m:Type='patienttilknyttet_person' ">
									<xsl:value-of select="concat('f. ',substring($PoR/m:PatientDateOfBirth,9,2),'.',substring($PoR/m:PatientDateOfBirth,6,2),'.',substring($PoR/m:PatientDateOfBirth,1,4),' ')"/>
									<xsl:choose>
										<xsl:when test="$PoR/m:PatientSex='hankoen' ">Dreng</xsl:when>
										<xsl:when test="$PoR/m:PatientSex='hunkoen' ">Pige</xsl:when>
									</xsl:choose>
								</xsl:if>
							</span>
							<!--County area -->
							<span style="position:absolute;left:103mm;top:54mm;width:34mm;height:6mm;margin:3mm;line-height:9pt">
								<xsl:value-of select="$PoR/m:CountyCode"/>
							</span>
							<!-- Information area -->
							<span style="position:absolute;left:6mm;top:60mm;width:121mm;height:16mm;margin:3mm;line-height:9pt">
								<!--burde være 131 i bredden, men for at undgå at der skrives ud over kanten så...-->
								<xsl:for-each select="$PI">
									<xsl:for-each select="m:OrderInstruction">
										<xsl:value-of select="concat('* ',.,'   ')"/>
									</xsl:for-each>
									<br/>
									<xsl:variable name="PoD" select="m:Delivery/m:PriorityOfDelivery"/>
									<xsl:choose>
										<xsl:when test="$PoD='send_til_anden_adresse_samme_dag'  ">Send pr. bud til </xsl:when>
										<xsl:when test="$PoD='send_til_anden_adresse_pr_post'  ">Send pr. post til </xsl:when>
										<xsl:when test="$PoD='send_til_patientadresse_samme_dag'  ">Send pr. bud </xsl:when>
										<xsl:when test="$PoD='send_til_patientadresse_pr_post'  ">Send pr. post </xsl:when>
									</xsl:choose>
									<xsl:value-of select="concat(' ',m:Delivery/m:ContactName,' ',m:Delivery/m:StreetName,m:Delivery/m:PseudoAddress,' ',m:Delivery/m:PostCodeIdentifier)"/>
									<xsl:for-each select="m:DeliveryInformation">
										<xsl:value-of select="concat('  * ',.)"/>
									</xsl:for-each>
									<br/>
									<xsl:value-of select="concat(' ',m:DoseDispenseInformation/m:Status)"/>
									<xsl:if test="m:DoseDispenseInformation/m:CopyRequired">
										<xsl:value-of select="' kopi ønskes '"/>
									</xsl:if>
								</xsl:for-each>
								<span style="position:absolute;left:0mm;top:0mm;width:125mm;height:10mm;margin:0mm;text-align:right;vertical-align:bottom">
									<br/>
									<br/>
									<xsl:if test="$PoR/m:PrivateInsurance='true'">DK</xsl:if>
									<xsl:if test="$PoR/m:PrivateInsurance='true' and $PoR/m:LocalAuthorityGrant='true'">/</xsl:if>
									<xsl:if test="$PoR/m:LocalAuthorityGrant='true'">MK</xsl:if>
								</span>
							</span>
							<!-- Apotek area -->
							<span style="position:absolute;left:103mm;top:32mm;width:34mm;height:22mm;margin:3mm;line-height:9pt">
								<xsl:value-of select="$R/m:OrganisationName"/>
								<br/>
								<br/>
								<br/>
								<br/>Side: <xsl:value-of select="$SideNr"/>
							</span>
							<!-- drug area -->
							<span style="position:absolute;left:6mm;top:80mm;width:131mm;height:91mm;margin:3mm;line-height:9pt">
								<xsl:for-each select="$Ds[((($SideNr - 1)*3+1)&lt;=position()) and (position()&lt;=($SideNr * 3))]">
									<span style="position:relative;left:0mm;top:0mm;width:125mm;height:29mm;margin:0px;">
										<xsl:value-of select="concat(m:PackageIdentifier,' ')"/>
										<xsl:if test="count(m:Dosage/m:DosageCode)>0">
											<xsl:value-of select="concat('[D-',m:Dosage/m:DosageCode,'] ')"/>
										</xsl:if>
										<xsl:if test="count(m:Indication/m:Code)>0">
											<xsl:value-of select="concat('[I-',m:Indication/m:Code,'] ' ) "/>
										</xsl:if>
										<!--<xsl:value-of select="concat(m:PackageIdentifier,'  ','[D-',m:Dosage/m:DosageCode,'] ','   ','[I-',m:Indication/m:Code,'] ' ) "/>-->
										<br/>
										<xsl:value-of select="concat(m:NameOfDrug,' ',m:DosageForm,' ',m:DrugStrength,' ',m:Importer/m:LongName)"/>
										<!--<xsl:if test="count(m:Importer)=0">
									<xsl:value-of select="' direkte forhandlet '"/>
								</xsl:if>-->
										<br/>
										<xsl:value-of select="concat(m:PackageSize,' x ',m:NumberOfPackings)"/>
										<br/>
										<xsl:choose>
											<xsl:when test="m:SubstitutionCode='ikke_substitution' ">Ikke substitution</xsl:when>
											<xsl:when test="m:SubstitutionCode='ikke_generisk_substitution' ">Ikke generisk substitution</xsl:when>
											<xsl:when test="m:SubstitutionCode='ikke_original_substitution' ">Ikke original substitution</xsl:when>
										</xsl:choose>
										<br/>
										<xsl:variable name="RC" select="m:ReimbursementClause"/>
										<xsl:choose>
											<xsl:when test="$RC='klausulbetingelse_opfyldt' ">Tilskud</xsl:when>
											<xsl:when test="$RC='varig_lidelse' ">Varig lidelse</xsl:when>
											<xsl:when test="$RC='pensionist' ">Pensionist</xsl:when>
											<xsl:when test="$RC='bevilling_fra_laegemiddelstyrelsen' ">Bevilling fra lægemiddelstyrelsen</xsl:when>
											<xsl:when test="count($RC)=0"/>
											<xsl:otherwise>Ukendt ReimbursmentClause : <xsl:value-of select="$RC"/>
											</xsl:otherwise>
										</xsl:choose>
										<br/>
										<xsl:value-of select="concat(m:Dosage/m:DosageText,' ',m:Dosage/m:Period,' ',m:Dosage/m:PeriodUnit)"/>
										<br/>
										<xsl:value-of select="m:Indication/m:Text"/>
										<br/>
										<xsl:value-of select="m:SublementaryInformation"/>
										<br/>
										<xsl:for-each select="m:Iteration">
											<xsl:value-of select="concat('Udleveres ',m:Number+1,' ')"/>
											<xsl:if test="m:Number=1">gang</xsl:if>
											<xsl:if test="m:Number!=1">gange</xsl:if>
											<xsl:value-of select="concat(' med ',m:Interval,' ')"/>
											<xsl:choose>
												<xsl:when test="m:IntervalUnit='dag' and m:Interval=1">dags</xsl:when>
												<xsl:when test="m:IntervalUnit='dag' and m:Interval!=1">dages</xsl:when>
												<xsl:when test="m:IntervalUnit='uge' and m:Interval=1">uges</xsl:when>
												<xsl:when test="m:IntervalUnit='uge' and m:Interval!=1">ugers</xsl:when>
												<xsl:when test="m:IntervalUnit='maaned' and m:Interval=1">måneds</xsl:when>
												<xsl:when test="m:IntervalUnit='maaned' and m:Interval!=1">måneders</xsl:when>
											</xsl:choose>
											<xsl:value-of select="' mellemrum '"/>
										</xsl:for-each>
										<xsl:for-each select="m:DoseDispensing">
											<xsl:value-of select="concat('Startdato: ',substring(m:StartDate,9,2),'.',substring(m:StartDate,6,2),'.',substring(m:StartDate,1,4),' Slutdato: ',substring(m:EndDate,9,2),'.',substring(m:EndDate,6,2),'.',substring(m:EndDate,1,4))"/>
										</xsl:for-each>
										<span style="position:absolute;left:60mm;top:0mm;width:71mm;height:30mm;margin:0px">#</span>
									</span>
								</xsl:for-each>
							</span>
							<!-- Signing area -->
							<span style="position:absolute;left:6mm;top:171mm;width:131mm;height:13mm;margin:3mm;line-height:9pt">
								<xsl:value-of select="concat(substring($L/m:Authorisation/m:Date,9,2),'.',substring($L/m:Authorisation/m:Date,6,2),'.',substring($L/m:Authorisation/m:Date,1,4),' ',$L/m:Authorisation/m:TimeWithSec,' ',$I/m:TitleAndName)"/>
								<br/>
								<xsl:if test="count($I/m:AuthorisationIdentifier)>0">
									<xsl:value-of select="concat($I/m:AuthorisationIdentifier,' ')"/>
								</xsl:if>
								<xsl:if test="count($I/m:SpecialityCode)>0">
									<xsl:value-of select="concat('Speciallæge i ',$I/m:SpecialityCode)"/>
								</xsl:if>
							</span>
							<!-- COPY area -->
							<xsl:if test="$PI/m:MessageStatusCode='kopi'">
								<span style="position:absolute;left:103mm;top:9mm;width:34mm;height:22mm;margin:3mm;text-align:center;font-size:14pt;color:red">KOPI</span>
							</xsl:if>
							<!-- XML area -->
							<span style="position:absolute;left:104mm;top:24mm;width:13mm;height:5mm;margin:0mm;text-align:center;font-size:9pt;background:#ffffff;border:1px solid black">Edifact -</span>
						</span>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- 
		BinaryLetter 
	-->
	<xsl:template match="m:Emessage[m:BinaryLetter]">
		<xsl:for-each select="m:BinaryLetter">
			<xsl:variable name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select=" 'Binær dokumenttransport' "/>
							</xsl:call-template>
						</tr>
						<xsl:for-each select="m:BinaryObject">
							<tr>
								<td>
									<xsl:attribute name="bgcolor"><xsl:value-of select="$compoundbgcolor"/></xsl:attribute>
									<xsl:variable name="OC" select="m:ObjectCode"/>
									<xsl:variable name="OEC" select="m:ObjectExtensionCode"/>
									<xsl:variable name="icon">
										<xsl:choose>
											<xsl:when test="$OEC='doc'">
												<xsl:value-of select="'img/wordicon.GIF'"/>
											</xsl:when>
											<xsl:when test="$OC='multimedie'">
												<xsl:value-of select="'img/multiicon.GIF'"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'img/binicon.PNG'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$OC='billede'">
											<img>
												<xsl:attribute name="src"><xsl:value-of select="concat('Binary/',$SenderEAN,'_',m:ObjectIdentifier,'_',m:ObjectCode,'.',m:ObjectExtensionCode)"/></xsl:attribute>
											</img>
										</xsl:when>
										<xsl:when test="$OC='multimedie'">
											<object ID="MediaPlayer1" classid="CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95" codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701" standby="Loading Microsoft® Windows® Media Player components..." type="application/x-oleobject">
												<param name="AudioStream" value="true"/>
												<param name="AutoSize" value="true"/>
												<param name="AutoStart" value="0"/>
												<param name="AnimationAtStart" value="true"/>
												<param name="AllowScan" value="true"/>
												<param name="AllowChangeDisplaySize" value="true"/>
												<param name="AutoRewind" value="0"/>
												<param name="Balance" value="0"/>
												<param name="BaseURL" value=""/>
												<param name="BufferingTime" value="5"/>
												<param name="CaptioningID" value=""/>
												<param name="ClickToPlay" value="true"/>
												<param name="CursorType" value="1"/>
												<param name="CurrentPosition" value="true"/>
												<param name="CurrentMarker" value="0"/>
												<param name="DefaultFrame" value=""/>
												<param name="DisplayBackColor" value="0"/>
												<param name="DisplayForeColor" value="16777215"/>
												<param name="DisplayMode" value="0"/>
												<param name="DisplaySize" value="0"/>
												<param name="Enabled" value="true"/>
												<param name="EnableContextMenu" value="0"/>
												<param name="EnablePositionControls" value="true"/>
												<param name="EnableFullScreenControls" value="true"/>
												<param name="EnableTracker" value="true"/>
												<param name="Filename">
													<xsl:attribute name="value"><xsl:value-of select="concat('Binary/',$SenderEAN,'_',m:ObjectIdentifier,'_',m:ObjectCode,'.',m:ObjectExtensionCode)"/></xsl:attribute>
												</param>
												<param name="InvokeURLs" value="true"/>
												<param name="Language" value="true"/>
												<param name="Mute" value="0"/>
												<param name="PlayCount" value="1"/>
												<param name="PreviewMode" value="0"/>
												<param name="Rate" value="1"/>
												<param name="SAMILang" value=""/>
												<param name="SAMIStyle" value=""/>
												<param name="SAMIFileName" value=""/>
												<param name="SelectionStart" value="true"/>
												<param name="SelectionEnd" value="true"/>
												<param name="SendOpenStateChangeEvents" value="true"/>
												<param name="SendWarningEvents" value="true"/>
												<param name="SendErrorEvents" value="true"/>
												<param name="SendKeyboardEvents" value="0"/>
												<param name="SendMouseClickEvents" value="0"/>
												<param name="SendMouseMoveEvents" value="0"/>
												<param name="SendPlayStateChangeEvents" value="true"/>
												<param name="ShowCaptioning" value="0"/>
												<param name="ShowControls" value="true"/>
												<param name="ShowAudioControls" value="true"/>
												<param name="ShowDisplay" value="0"/>
												<param name="ShowGotoBar" value="0"/>
												<param name="ShowPositionControls" value="true"/>
												<param name="ShowStatusBar" value="true"/>
												<param name="ShowTracker" value="0"/>
												<param name="TransparentAtStart" value="0"/>
												<param name="VideoBorderWidth" value="0"/>
												<param name="VideoBorderColor" value="0"/>
												<param name="VideoBorder3D" value="0"/>
												<param name="Volume" value="-600"/>
												<param name="WindowlessVideo" value="0"/>
												<embed type="application/x-mplayer2" pluginspage="http://www.microsoft.com/Windows/MediaPlayer/" autostart="0" showcontrols="0">
													<xsl:attribute name="src"><xsl:value-of select="concat('Binary/',$SenderEAN,'_',m:ObjectIdentifier,'_',m:ObjectCode,'.',m:ObjectExtensionCode)"/></xsl:attribute>
												</embed>
											</object>
										</xsl:when>
										<xsl:otherwise>
											<img>
												<xsl:attribute name="src"><xsl:value-of select="$icon"/></xsl:attribute>
											</img>
											<a target="newwindow">
												<xsl:attribute name="href"><xsl:value-of select="concat('Binary/',$SenderEAN,'_',m:ObjectIdentifier,'_',m:ObjectCode,'.',m:ObjectExtensionCode)"/></xsl:attribute>
												<xsl:value-of select="concat(m:ObjectIdentifier,' (',m:OriginalObjectSize,' bytes)')"/>
											</a>
										</xsl:otherwise>
									</xsl:choose>
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
  <!-- 
        PRESCRIPTION REQUEST
    -->
    <xsl:template match="m:Emessage[m:PrescriptionRequest]">
        <xsl:for-each select="m:PrescriptionRequest">
            <tr>
                <td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
                    <xsl:variable name="P" select="."/>
                    <xsl:variable name="L" select="m:Letter"/>
                    <xsl:variable name="S" select="m:Sender"/>
                    <xsl:variable name="I" select="$S/m:Issuer"/>
                    <xsl:variable name="R" select="m:Receiver"/>
                    <xsl:variable name="PoR" select="m:PatientOrRelative"/>
                    <xsl:variable name="PI" select="m:PrescriptionInformation"/>
                    <xsl:variable name="Ds" select="m:Drug"/>
                    <xsl:variable name="PP" select="m:PreferredPharmacy"></xsl:variable>
                    <xsl:for-each select="m:Drug[position() mod 3 = 1]">
                        <xsl:variable name="SideNr" select="position()"/>
                        <span style="position:relative;left:0mm;top:0mm;width:144mm;height:210mm;margin:0px;background-image:url(img\receptforny.GIF);border:1pt solid black;font-size:8pt;font-family:sans-serif">
                            <!--Sender area -->
                            <span style="position:absolute;left:56mm;top:9mm;width:88mm;height:22mm;margin:3mm;line-height:9pt">
                                <xsl:value-of select="$S/m:Identifier"/>
                                <br/>
                                <xsl:value-of select="$S/m:OrganisationName"/>
                                <br/>
                                <xsl:value-of select="$S/m:StreetName"/>
                                <br/>
                                <xsl:value-of select="concat($S/m:PostCodeIdentifier,' ','---',' Tlf. ',$S/m:TelephoneSubscriberIdentifier)"/>
                                <span style="position:absolute;left:0mm;top:0mm;width:41mm;height:16mm;margin:0mm;text-align:right">
                                    <xsl:value-of select="$PI/m:SenderComputerSystem"/>
                                </span>
                                <br/>
                                <xsl:value-of select="$S/m:PersonInOrganisation/m:TitleAndName"/>
                            </span>
                            <!-- Patient area -->
                            <span style="position:absolute;left:6mm;top:32mm;width:97mm;height:22mm;margin:3mm;line-height:9pt">
                                <xsl:if test="../m:ForGPClinicUse='true' ">Til brug i klinikken</xsl:if>
                                <xsl:if test="count($PoR)>0">
                                    <xsl:if test="count($PoR/m:CivilRegistrationNumber)>0">
                                        <xsl:value-of select="concat(substring($PoR/m:CivilRegistrationNumber,1,6),'-',substring($PoR/m:CivilRegistrationNumber,7,4))"/>
                                    </xsl:if>
                                    <xsl:if test="count($PoR/m:CivilRegistrationNumber)=0">
                                        <xsl:value-of select="concat('f. ',substring($PoR/m:PatientDateOfBirth,9,2),'.',substring($PoR/m:PatientDateOfBirth,6,2),'.',substring($PoR/m:PatientDateOfBirth,1,4),' ')"/>
                                        <xsl:choose>
                                            <xsl:when test="$PoR/m:PatientSex='hankoen' ">Mand</xsl:when>
                                            <xsl:when test="$PoR/m:PatientSex='hunkoen' ">Kvinde</xsl:when>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="$PoR/m:ForGPUse='true' ">
                                        <xsl:value-of select="'   Til lægens eget brug'"/>
                                    </xsl:if>
                                    <br/>
                                    <xsl:value-of select="concat($PoR/m:PersonGivenName,' ',$PoR/m:PersonSurnameName)"/>
                                    <br/>
                                    <xsl:value-of select="$PoR/m:StreetName"/>
                                    <br/>
                                    <xsl:value-of select="concat($PoR/m:PostCodeIdentifier,' ',$PoR/m:DistrictName)"/>
                                    <br/>
                                    <xsl:value-of select="$PoR/m:EmailIdentifier"/>
                                    <xsl:value-of select="concat(' (',$PoR/m:EmailStatus, ')')"/>
                                </xsl:if>
                            </span>
                            <!-- Child area -->
                            <span style="position:absolute;left:6mm;top:54mm;width:97mm;height:6mm;margin:3mm;line-height:9pt">
                                <xsl:if test="$PoR/m:Type='patienttilknyttet_person' ">
                                    <xsl:value-of select="concat('f. ',substring($PoR/m:PatientDateOfBirth,9,2),'.',substring($PoR/m:PatientDateOfBirth,6,2),'.',substring($PoR/m:PatientDateOfBirth,1,4),' ')"/>
                                    <xsl:choose>
                                        <xsl:when test="$PoR/m:PatientSex='hankoen' ">Dreng</xsl:when>
                                        <xsl:when test="$PoR/m:PatientSex='hunkoen' ">Pige</xsl:when>
                                    </xsl:choose>
                                </xsl:if>
                            </span>
                            <!--County area -->
                            <span style="position:absolute;left:103mm;top:54mm;width:34mm;height:6mm;margin:3mm;line-height:9pt">
                                <xsl:value-of select="$PoR/m:CountyCode"/>
                            </span>
                            <!-- Information area -->
                            <span style="position:absolute;left:6mm;top:60mm;width:121mm;height:16mm;margin:3mm;line-height:9pt">
                                <!--burde være 131 i bredden, men for at undgå at der skrives ud over kanten så...-->
                                <xsl:for-each select="$PI">
                                    <xsl:for-each select="m:OrderInstruction">
                                        <xsl:value-of select="concat('* ',.,'   ')"/>
                                    </xsl:for-each>
                                    <br/>
                                    <xsl:variable name="PoD" select="m:Delivery/m:PriorityOfDelivery"/>
                                    <xsl:choose>
                                        <xsl:when test="$PoD='send_til_anden_adresse_samme_dag'  ">Send pr. bud til </xsl:when>
                                        <xsl:when test="$PoD='send_til_anden_adresse_pr_post'  ">Send pr. post til </xsl:when>
                                        <xsl:when test="$PoD='send_til_patientadresse_samme_dag'  ">Send pr. bud </xsl:when>
                                        <xsl:when test="$PoD='send_til_patientadresse_pr_post'  ">Send pr. post </xsl:when>
                                    </xsl:choose>
                                    <xsl:value-of select="concat(' ',m:Delivery/m:ContactName,' ',m:Delivery/m:StreetName,m:Delivery/m:PseudoAddress,' ',m:Delivery/m:PostCodeIdentifier)"/>
                                    <xsl:for-each select="m:DeliveryInformation">
                                        <xsl:value-of select="concat('  * ',.)"/>
                                    </xsl:for-each>
                                    <br/>
                                    <xsl:value-of select="concat(' ',m:DoseDispenseInformation/m:Status)"/>
                                    <xsl:if test="m:DoseDispenseInformation/m:CopyRequired">
                                        <xsl:value-of select="' kopi ønskes '"/>
                                    </xsl:if>
                                </xsl:for-each>
                                <span style="position:absolute;left:0mm;top:0mm;width:125mm;height:10mm;margin:0mm;text-align:right;vertical-align:bottom">
                                    <br/>
                                    <br/>
                                    <xsl:if test="$PoR/m:PrivateInsurance='true'">DK</xsl:if>
                                    <xsl:if test="$PoR/m:PrivateInsurance='true' and $PoR/m:LocalAuthorityGrant='true'">/</xsl:if>
                                    <xsl:if test="$PoR/m:LocalAuthorityGrant='true'">MK</xsl:if>
                                </span>
                            </span>
                            <!-- Apotek area -->
                            <span style="position:absolute;left:10mm;top:9mm;width:34mm;height:22mm;margin:3mm;line-height:9pt">
                                <xsl:value-of select="$R/m:Identifier"/>
                                <br/>
                                <xsl:value-of select="$R/m:OrganisationName"/>
                                <br/>
                                <br/>
                                <xsl:value-of select="$R/m:Issuer/m:AuthorisationIdentifier"/><xsl:value-of select="' '"/><xsl:value-of select="$R/m:Issuer/m:Occupation"/>
                                <br/>
                                <xsl:value-of select="$R/m:Issuer/m:TitleAndName"/>
                            </span>
                            <span style="position:absolute;left:103mm;top:32mm;width:34mm;height:22mm;margin:3mm;line-height:9pt">
                                <xsl:value-of select="$PP/m:EANIdentifier"/>
                                <br/>
                                <xsl:value-of select="$PP/m:OrganisationName"/>
                                <br/>
                                <br/>
                                <br/>Side: <xsl:value-of select="$SideNr"/>
                            </span>
                            <!-- drug area -->
                            <span style="position:absolute;left:6mm;top:80mm;width:131mm;height:91mm;margin:3mm;line-height:9pt">
                                <xsl:for-each select="$Ds[((($SideNr - 1)*3+1)&lt;=position()) and (position()&lt;=($SideNr * 3))]">
                                    <span style="position:relative;left:0mm;top:0mm;width:125mm;height:29mm;margin:0px;">
                                        <xsl:value-of select="concat(m:PackageIdentifier,' ')"/>
                                        <xsl:if test="count(m:Dosage/m:DosageCode)>0">
                                            <xsl:value-of select="concat('[D-',m:Dosage/m:DosageCode,'] ')"/>
                                        </xsl:if>
                                        <xsl:if test="count(m:Indication/m:Code)>0">
                                            <xsl:value-of select="concat('[I-',m:Indication/m:Code,'] ' ) "/>
                                        </xsl:if>
                                        <!--<xsl:value-of select="concat(m:PackageIdentifier,'  ','[D-',m:Dosage/m:DosageCode,'] ','   ','[I-',m:Indication/m:Code,'] ' ) "/>-->
                                        <br/>
                                        <xsl:value-of select="concat(m:NameOfDrug,' ',m:DosageForm,' ',m:DrugStrength,' ',m:Importer/m:LongName)"/>
                                        <!--<xsl:if test="count(m:Importer)=0">
                                            <xsl:value-of select="' direkte forhandlet '"/>
                                            </xsl:if>-->
                                        <br/>
                                        <xsl:value-of select="concat(m:PackageSize,' x ',m:NumberOfPackings)"/>
                                        <br/>
                                        <xsl:choose>
                                            <xsl:when test="m:SubstitutionCode='ikke_substitution' ">Ikke substitution</xsl:when>
                                            <xsl:when test="m:SubstitutionCode='ikke_generisk_substitution' ">Ikke generisk substitution</xsl:when>
                                            <xsl:when test="m:SubstitutionCode='ikke_original_substitution' ">Ikke original substitution</xsl:when>
                                        </xsl:choose>
                                        <br/>
                                        <xsl:variable name="RC" select="m:ReimbursementClause"/>
                                        <xsl:choose>
                                            <xsl:when test="$RC='klausulbetingelse_opfyldt' ">Tilskud</xsl:when>
                                            <xsl:when test="$RC='varig_lidelse' ">Varig lidelse</xsl:when>
                                            <xsl:when test="$RC='pensionist' ">Pensionist</xsl:when>
                                            <xsl:when test="$RC='bevilling_fra_laegemiddelstyrelsen' ">Bevilling fra lægemiddelstyrelsen</xsl:when>
                                            <xsl:when test="count($RC)=0"/>
                                            <xsl:otherwise>Ukendt ReimbursmentClause : <xsl:value-of select="$RC"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <br/>
                                        <xsl:value-of select="concat(m:Dosage/m:DosageText,' ',m:Dosage/m:Period,' ',m:Dosage/m:PeriodUnit)"/>
                                        <br/>
                                        <xsl:value-of select="m:Indication/m:Text"/>
                                        <br/>
                                        <xsl:value-of select="m:SublementaryInformation"/>
                                        <br/>
                                        <xsl:for-each select="m:Iteration">
                                            <xsl:value-of select="concat('Udleveres ',m:Number+1,' ')"/>
                                            <xsl:if test="m:Number=1">gang</xsl:if>
                                            <xsl:if test="m:Number!=1">gange</xsl:if>
                                            <xsl:value-of select="concat(' med ',m:Interval,' ')"/>
                                            <xsl:choose>
                                                <xsl:when test="m:IntervalUnit='dag' and m:Interval=1">dags</xsl:when>
                                                <xsl:when test="m:IntervalUnit='dag' and m:Interval!=1">dages</xsl:when>
                                                <xsl:when test="m:IntervalUnit='uge' and m:Interval=1">uges</xsl:when>
                                                <xsl:when test="m:IntervalUnit='uge' and m:Interval!=1">ugers</xsl:when>
                                                <xsl:when test="m:IntervalUnit='maaned' and m:Interval=1">måneds</xsl:when>
                                                <xsl:when test="m:IntervalUnit='maaned' and m:Interval!=1">måneders</xsl:when>
                                            </xsl:choose>
                                            <xsl:value-of select="' mellemrum '"/>
                                        </xsl:for-each>
                                        <xsl:for-each select="m:DoseDispensing">
                                            <xsl:value-of select="concat('Startdato: ',substring(m:StartDate,9,2),'.',substring(m:StartDate,6,2),'.',substring(m:StartDate,1,4),' Slutdato: ',substring(m:EndDate,9,2),'.',substring(m:EndDate,6,2),'.',substring(m:EndDate,1,4))"/>
                                        </xsl:for-each>
                                        <span style="position:absolute;left:60mm;top:0mm;width:71mm;height:30mm;margin:0px">#</span>
                                    </span>
                                </xsl:for-each>
                            </span>
                            <!-- Signing area -->
                            <span style="position:absolute;left:6mm;top:171mm;width:131mm;height:13mm;margin:3mm;line-height:9pt">
                                <xsl:value-of select="concat(substring($L/m:Authorisation/m:Date,9,2),'.',substring($L/m:Authorisation/m:Date,6,2),'.',substring($L/m:Authorisation/m:Date,1,4),' ',$L/m:Authorisation/m:TimeWithSec,' ',$I/m:TitleAndName)"/>
                                <br/>
                                <xsl:if test="count($I/m:AuthorisationIdentifier)>0">
                                    <xsl:value-of select="concat($I/m:AuthorisationIdentifier,' ')"/>
                                </xsl:if>
                                <xsl:if test="count($I/m:SpecialityCode)>0">
                                    <xsl:value-of select="concat('Speciallæge i ',$I/m:SpecialityCode)"/>
                                </xsl:if>
                            </span>
                            <!-- COPY area -->
                            <xsl:if test="$PI/m:MessageStatusCode='kopi'">
                                <span style="position:absolute;left:103mm;top:9mm;width:34mm;height:22mm;margin:3mm;text-align:center;font-size:14pt;color:red">KOPI</span>
                            </xsl:if>
                            <!-- XML area -->
                            <span style="position:absolute;left:104mm;top:24mm;width:13mm;height:5mm;margin:0mm;text-align:center;font-size:9pt;background:#ffffff;border:1px solid black">Edifact -</span>
                        </span>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>
 
</xsl:stylesheet>
