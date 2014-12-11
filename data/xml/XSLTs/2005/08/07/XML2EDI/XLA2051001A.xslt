<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="m:WorkingDisabilityAnswer">
		<xsl:variable name="WDFC" select="m:WorkingDisabilityFromCode"/>
		<xsl:variable name="POFWDC" select="m:PartlyOrFullWorkingDisabilityCode"/>
		<xsl:variable name="EDID" select="m:ExpectedDurationInDays"/>
		<xsl:variable name="SWAC" select="m:StartedWorkingAgainCode"/>
		<Brev serializeable="no">
			<xsl:if test="not($WDFC) and count($POFWDC)>0">
				<FEJL>Når WorkingDisabilityFromCode er "<xsl:value-of select="$WDFC"/>må PartlyOrFullWorkingDisabilityCode ikke udfyldes</FEJL>
			</xsl:if>
			<xsl:if test="count($EDID)>0 and count($SWAC)=0">
				<FEJL>Når ExpectedDurationInDays er udfyldt skal StartedWorkingAgainCode udfyldes</FEJL>
			</xsl:if>
		</Brev>
	</xsl:template>
</xsl:stylesheet>