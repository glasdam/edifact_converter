<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2004/06/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- NegativeVansReceipt-->
	<xsl:template match="m:NegativeReceipt">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="OrigEmsg" select="m:OriginalEmessage"/>
		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>CONTRL</SubElm>
					<SubElm>D</SubElm>
					<SubElm>93A</SubElm>
					<SubElm>ZZ</SubElm>
					<SubElm>C0230Q</SubElm>
				</Elm>
				<Elm>
					<SubElm>CTL02</SubElm>
				</Elm>

			</UNH>
			<BrevIndhold>
				<xsl:for-each select="$OrigEmsg">
					<UCI>
						<Elm>
							<SubElm>
								<xsl:value-of select="m:OriginalEnvelopeIdentifier"/>
							</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="m:OriginalSender/m:EANIdentifier"/>
							</SubElm>
							<SubElm>14</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="m:OriginalReceiver/m:EANIdentifier"/>
							</SubElm>
							<SubElm>14</SubElm>
						</Elm>
						<Elm>
							<SubElm>4</SubElm>
						</Elm>
					</UCI>
					<xsl:if test="count(m:RefuseCode)+count(m:RefuseText)>0">
						<XFTX>
							<Elm>
								<SubElm>
									<xsl:variable name="C" select="m:RefuseCode"/>
									<xsl:choose>
										<xsl:when test="$C='ikke_specificeret' ">NC</xsl:when>
										<xsl:when test="$C='ukendt_lokationsnummer' ">LOK</xsl:when>
										<xsl:when test="$C='problem_med_modtagerID' ">MID</xsl:when>
										<xsl:when test="$C='problem_med_version' ">VER</xsl:when>
										<xsl:when test="$C='syntaksfejl' ">SYN</xsl:when>
										<xsl:otherwise>
											<FEJL>Ukendt RefuseCode: <xsl:value-of select="$C"/>
											</FEJL>
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
									<xsl:if test="count(m:RefuseText)>0">
										<xsl:copy-of select="m:RefuseText/text()|m:RefuseText/*"/>
									</xsl:if>
									<xsl:if test="count(m:RefuseText)=0">Ingen fejltekst</xsl:if>
								</SubElm>
							</Elm>
						</XFTX>
					</xsl:if>
					<xsl:for-each select="m:OriginalLetter">
						<UCM>
							<Elm>
								<SubElm>
									<xsl:value-of select="m:OriginalLetterIdentifier"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm><xsl:call-template name="VersionCodeToType"><xsl:with-param name="VersionCode" select="m:OriginalVersionCode"/></xsl:call-template></SubElm>
								<SubElm>D</SubElm>
								<SubElm>93A</SubElm>
								<SubElm>UN</SubElm>
								<SubElm>
									<xsl:value-of select="m:OriginalVersionCode"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>4</SubElm>
							</Elm>
							
						</UCM>
						<xsl:if test="count(m:RefuseCode)+count(m:RefuseText)>0">
								<XFTX>
									<Elm>
										<SubElm>
											<xsl:variable name="C" select="m:RefuseCode"/>
											<xsl:choose>
												<xsl:when test="$C='ikke_specificeret' ">NC</xsl:when>
												<xsl:when test="$C='ukendt_lokationsnummer' ">LOK</xsl:when>
												<xsl:when test="$C='problem_med_modtagerID' ">MID</xsl:when>
												<xsl:when test="$C='problem_med_version' ">VER</xsl:when>
												<xsl:when test="$C='syntaksfejl' ">SYN</xsl:when>
												<xsl:otherwise>
													<FEJL>Ukendt RefuseCode: <xsl:value-of select="$C"/>
													</FEJL>
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
											<xsl:if test="count(m:RefuseText)>0">
												<xsl:copy-of select="m:RefuseText/text()|m:RefuseText/*"/>
											</xsl:if>
											<xsl:if test="count(m:RefuseText)=0">Ingen fejltekst</xsl:if>
										</SubElm>
									</Elm>
								</XFTX>
							</xsl:if>
					</xsl:for-each>
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
