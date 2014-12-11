<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template name="DRError">
		<xsl:param name="Text"/>
		<xsl:param name="Node" select="."/>
		<FEJL>
		       <xsl:attribute name="envid"><xsl:apply-templates select="$Node" mode="get-envelopeidentifier"/></xsl:attribute>
		       <xsl:attribute name="letterid"><xsl:apply-templates select="$Node" mode="get-letteridentifier"/></xsl:attribute>
		       <xsl:attribute name="versioncode"><xsl:apply-templates select="$Node" mode="get-letterversioncode"/></xsl:attribute>
		   	<xsl:attribute name="path"><xsl:apply-templates select="$Node" mode="get-full-path"/></xsl:attribute>
		   	<xsl:attribute name="cpr"><xsl:apply-templates select="$Node" mode="get-patient"/></xsl:attribute>
		   	
			<xsl:value-of select="$Text"/>
			<!--(Felt: <xsl:apply-templates select="$Node" mode="get-full-path"/>)
			(Patient: <xsl:apply-templates select="$Node" mode="get-patient"/>)-->
		</FEJL>
	</xsl:template>
	
	<xsl:template match="*|@*" mode="get-full-path">
			<xsl:apply-templates select="parent::*" mode="get-full-path"/>
			<xsl:text>/</xsl:text>
			<xsl:if test="count(. | ../@*) = count(../@*)">@</xsl:if>
			<xsl:value-of select="name()"/>
			<xsl:text>[</xsl:text>
	  		<xsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
	  		<xsl:text>]</xsl:text>
       </xsl:template>
       
	<xsl:template match="*|@*" mode="get-patient">
			<xsl:if test="count(m:Patient)>0">
				<xsl:value-of select="m:Patient/m:CivilRegistrationNumber"/>
			</xsl:if>
			<xsl:if test="count(m:Patient)=0">
				<xsl:apply-templates select="parent::*" mode="get-patient"/>
			</xsl:if>
       </xsl:template>
       
      <xsl:template match="*|@*" mode="get-letteridentifier">
			<xsl:if test="count(m:Letter)>0">
				<xsl:value-of select="m:Letter/m:Identifier"/>
			</xsl:if>
			<xsl:if test="count(m:Letter)=0">
				<xsl:apply-templates select="parent::*" mode="get-letteridentifier"/>
			</xsl:if>
       </xsl:template>
       
       <xsl:template match="*|@*" mode="get-letterversioncode">
			<xsl:if test="count(m:Letter)>0">
				<xsl:value-of select="m:Letter/m:VersionCode"/>
			</xsl:if>
			<xsl:if test="count(m:Letter)=0">
				<xsl:apply-templates select="parent::*" mode="get-letterversioncode"/>
			</xsl:if>
       </xsl:template>
       
       

      <xsl:template match="*|@*" mode="get-envelopeidentifier">
			<xsl:if test="count(m:Envelope)>0">
				<xsl:value-of select="m:Envelope/m:Identifier"/>
			</xsl:if>
			<xsl:if test="count(m:Envelope)=0">
				<xsl:apply-templates select="parent::*" mode="get-envelopeidentifier"/>
			</xsl:if>
       </xsl:template>
       
      



	<xsl:template match="m:DiabetesReport">
		<!--<xsl:variable name="RFTC" select="m:RehabilitationFromTreatmentCode"/>
		<xsl:variable name="RFCC" select="m:RehabilitationFromCombinedCode"/>-->
		<Brev serializeable="no">
			<xsl:for-each select="m:Report">
			</xsl:for-each>
		</Brev>
	</xsl:template>
</xsl:stylesheet>
