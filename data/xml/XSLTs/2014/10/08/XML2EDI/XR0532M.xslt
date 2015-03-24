<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2014/10/08/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="m:MicrobiologyWebReport">
		<Brev serializeable="no">
			<xsl:for-each select="m:GEPJ_Elements">
				<FEJL>Der må ikke sendes GEPJ_Elements i MicrobiologyWebReport</FEJL>
			</xsl:for-each>
		</Brev>
	</xsl:template>
</xsl:stylesheet>
