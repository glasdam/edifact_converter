<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2009/08/01/" xmlns:gepj="http://medinfo.dk/epj/proj/gepka/20030701/xml/schema" xmlns:cpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/" xmlns:dkcc="http://rep.oio.dk/ebxml/xml/schemas/dkcc/2003/02/13/" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output media-type="text/html"/>

	<!-- 
    CLINICALEMAIL NY 
  -->
  <xsl:template match="m:Emessage[m:AdministrativeEmail]">
    <xsl:for-each select="m:AdministrativeEmail">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Administrativ Korrespondance'"/>
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
