<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- 
	Hvis der detekteres en fejl i oversættelsen  indsaettes en fejlinformation som senere sendes tilbage til brugeren
	
	<FEJL>
		<xsl:attribute name="linie"><xsl:value-of select="<node>/@linie"/></xsl:attribute>
		<xsl:attribute name="position"><xsl:value-of select="<node>/@position"/></xsl:attribute>
		Der er noget galt: <xsl:value-of select="<node>"/>
	</FEJL>
	
	eller bare
	
	<FEJL>Der er noget galt</FEJL>
-->

<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/">
	<xsl:include href="Breve.xslt"/>
	<xsl:include href="GeneralTemplates.xslt"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="Unb" select="Edifact/UNB"/>
	<xsl:variable name="SenderEAN" select="$Unb/Elm[2]/SubElm[1]"/>
	<xsl:variable name="ReceiverEAN" select="$Unb/Elm[3]/SubElm[1]"/>
	<xsl:variable name="Unz" select="Edifact/UNZ"/>
	<xsl:variable name="Breve" select="Edifact/Brev"/>

<!-- Oversættelse af XML 1-1, som svarer til  en edifact -->	
<xsl:template match="Edifact">
<Emessage>
	<Envelope>
		<Sent>
			<Date>
				<xsl:variable name="D" select="$Unb/Elm[4]/SubElm[1]"/>
				<xsl:if test="string-length($D)!=6">
					<xsl:call-template name="Error">
						<xsl:with-param name="Node" select="$D"/>
						<xsl:with-param name="Text">Forkert antal tegn i Dato:<xsl:value-of select="$D"/></xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="substring($D,1,2)&lt;=20">20</xsl:if><xsl:if test="substring($D,1,2)>20">19</xsl:if><xsl:value-of select="concat(substring($D,1,2),'-',substring($D,3,2),'-',substring($D,5,2))"/>
			</Date>
			<Time>
				<xsl:variable name="T" select="$Unb/Elm[4]/SubElm[2]"/>
				<xsl:if test="string-length($T)!=4">
					<xsl:call-template name="Error">
						<xsl:with-param name="Node" select="$T"/>
						<xsl:with-param name="Text">Forkert antal tegn i Tid:<xsl:value-of select="$T"/></xsl:with-param>
					</xsl:call-template>
				</xsl:if>	
				<xsl:value-of select="concat(substring($T,1,2),':',substring($T,3,2))"/>
			</Time>
		</Sent>
		<Identifier><xsl:value-of select="$Unb/Elm[5]/SubElm[1]"/></Identifier>
		<AcknowledgementCode>
			<xsl:variable name="C" select="$Unb/Elm[9]/SubElm[1]"/>
			<xsl:choose>
				<xsl:when test="$C='1' ">pluspositivkvitt</xsl:when>
				<xsl:when test="$C='0' ">minuspositivkvitt</xsl:when>
				<xsl:when test="$C='' ">minuspositivkvitt</xsl:when>
				<xsl:when test="count($C)=0">minuspositivkvitt</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="Error">
						<xsl:with-param name="Node" select="$C"/>
						<xsl:with-param name="Text">Kan ikke oversætte til AcknowledgementCode</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</AcknowledgementCode>
	</Envelope>
	<xsl:apply-templates select="$Breve"/>
</Emessage>
</xsl:template>

</xsl:stylesheet>
