<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="m:SocialMedicalFollowUpAnswer">
		<xsl:variable name="RFTC" select="m:RehabilitationFromTreatmentCode"/>
		<xsl:variable name="RFCC" select="m:RehabilitationFromCombinedCode"/>
		<Brev serializeable="no">
			<xsl:if test="$RFTC and count($RFCC)>0">
				<FEJL>Når RehabilitationFromTreatmentCode er "<xsl:value-of select="$RFTC"/>" må RehabilitationFromCombinedCode ikke udfyldes</FEJL>
			</xsl:if>
			<xsl:if test="not($RFTC) and count($RFCC)=0">
				<FEJL>Når RehabilitationFromTreatmentCode er  "<xsl:value-of select="$RFTC"/>" skal RehabilitationFromCombinedCode udfyldes</FEJL>
			</xsl:if>
		</Brev>
	</xsl:template>
</xsl:stylesheet>