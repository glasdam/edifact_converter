<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2004/06/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:include href="GeneralTemplates.xslt"/>
	<xsl:include href="Letters.xslt"/>
	<!-- VARIABLE -->
	<xsl:variable name="Emsg" select="m:Emessage"/>
	<xsl:variable name="Envelope" select="$Emsg/m:Envelope"/>
	<xsl:variable name="Letters" select="$Emsg/*[position()>=2]"/>
	<xsl:variable name="FirstMsg" select="$Emsg/*[2]"/>
	<xsl:variable name="FirstSender" select="$FirstMsg/m:Sender"/>
	<xsl:variable name="FirstReceiver" select="$FirstMsg/m:Receiver"/>
	<!-- EMESSAGE -->
	<xsl:template match="m:Emessage">
		<Edifact>
			<UNB>
				<Elm>
					<SubElm>UNOC</SubElm>
					<SubElm>3</SubElm>
				</Elm>
				<Elm>
					<SubElm>
						<xsl:value-of select="$FirstSender/m:EANIdentifier"/>
					</SubElm>
					<SubElm>14</SubElm>
				</Elm>
				<Elm>
					<SubElm>
						<xsl:value-of select="$FirstReceiver/m:EANIdentifier"/>
					</SubElm>
					<SubElm>14</SubElm>
				</Elm>
				<Elm>
					<SubElm>
						<xsl:variable name="Dato" select="$Envelope/m:Sent/m:Date"/>
						<xsl:variable name="Datoyymmdd" select="concat(substring($Dato,3,2),substring($Dato,6,2),substring($Dato,9,2))"/>
						<xsl:value-of select="$Datoyymmdd"/>
					</SubElm>
					<SubElm>
						<xsl:variable name="Tid" select="$Envelope/m:Sent/m:Time"/>
						<xsl:variable name="Tidhhmm" select="concat(substring($Tid,1,2),substring($Tid,4,2))"/>
						<xsl:value-of select="$Tidhhmm"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Envelope/m:Identifier"/>
					</SubElm>
				</Elm>
				<xsl:variable name="IsCtrl" select="substring($FirstMsg/m:Letter/m:VersionCode,1,2)='XC' "/>
				<xsl:if test="not ($IsCtrl)">
					<Elm/>
					<Elm/>
					<Elm/>
					<Elm>
						<SubElm>
							<xsl:variable name="C" select="$Envelope/m:AcknowledgementCode"/>
							<xsl:choose>
								<xsl:when test="$C='minuspositivkvitt' ">0</xsl:when>
								<xsl:when test="$C='pluspositivkvitt' ">1</xsl:when>
								<xsl:otherwise>
									<FEJL>Kan ikke oversætte AcknowledgementCode: <xsl:value-of select="$C"/>
									</FEJL>
								</xsl:otherwise>
							</xsl:choose>
						</SubElm>
					</Elm>
				</xsl:if>
				<xsl:if test="$IsCtrl">
					<xsl:variable name="C" select="$Envelope/m:AcknowledgementCode"/>
					<xsl:choose>
						<xsl:when test="$C='minuspositivkvitt' "/>
						<xsl:otherwise>
							<FEJL>AcknowledgementCode værdien er ikke tilladt i CONTROL: <xsl:value-of select="$C"/></FEJL>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</UNB>
			<xsl:apply-templates select="$Letters"/>
			<UNZ>
				<Elm>
					<SubElm>1</SubElm>
				</Elm>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Envelope/m:Identifier"/>
					</SubElm>
				</Elm>
			</UNZ>
		</Edifact>
	</xsl:template>
	<!-- Ignorer GEPJ_Elements -->
	<xsl:template match="m:GEPJ_Elements"/>
</xsl:stylesheet>
