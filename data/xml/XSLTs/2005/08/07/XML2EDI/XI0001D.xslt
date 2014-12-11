<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/" version="1.0">
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
			
			     <!--OBLIGATORISKE HVIS AARSRAPPORT -->
				<xsl:if test="m:ReportType ='aarsrapport'  ">
					<xsl:if test="count(m:CareStatus)=0">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">CareStatus er obligatorisk når der er tale om en aarsrapport</xsl:with-param> 
							<xsl:with-param name="Node" select="m:ReportType"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="m:Examinations/m:EyeExamination[m:Examinated='ikke_relevant']">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">EyeExamination  kan ikke være ikke_relevant når der er tale om en aarsrapport </xsl:with-param> 
							<xsl:with-param name="Node" select="m:Examinations/m:EyeExamination/m:Examinated"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="m:Examinations/m:FootExamination[m:Examinated='ikke_relevant']">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">FootExamination kan ikke være ikke_relevant når der er tale om en aarsrapport </xsl:with-param> 
							<xsl:with-param name="Node" select="m:Examinations/m:FootExamination/m:Examinated"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				
				  <!--MÅ IKKE VÆRE TILSTEDE HVIS IKKE AARSRAPPORT -->
				<xsl:if test="m:ReportType !='aarsrapport'  ">
					<xsl:if test="count(m:CareStatus)>0">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">CareStatus skal kun angives når der er tale om en aarsrapport</xsl:with-param> 
							<xsl:with-param name="Node" select="m:CareStatus"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="m:Examinations/m:EyeExamination[m:Examinated!='ikke_relevant']">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">EyeExamination/Examinated skal være ikke_relevant når der ikke er tale om en aarsrapport </xsl:with-param> 
							<xsl:with-param name="Node" select="m:Examinations/m:EyeExamination/m:Examinated"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="m:Examinations/m:FootExamination[m:Examinated!='ikke_relevant']">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">FootExamination skal være ikke_relevant når der ikke er tale om en aarsrapport </xsl:with-param> 
							<xsl:with-param name="Node" select="m:Examinations/m:FootExamination/m:Examinated"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				
				  <!--OBLIGATORISKE HVIS EXAMINATED=JA -->
				<xsl:for-each select="m:Examinations/*[name()!='BMI' and m:Examinated = 'ja']">
					<xsl:if test="count(*)&lt;=1">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">Øvrige felter skal angives hvis Examinated = ja</xsl:with-param> 
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
				
				  <!--MÅ IKKE VÆRE TILSTEDE HVIS EXMINATED<>JA -->
				<xsl:for-each select="m:Examinations/*[name()!='BMI' and m:Examinated != 'ja'] ">
					<xsl:if test="count(*)>1">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text"><xsl:value-of select="name(*[2])"/> og øvrige felter må kun angives hvis Examinated er ja</xsl:with-param> 
							<xsl:with-param name="Node" select="*[2]"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
				
				  <!--OBLIGATORISKE HVIS BMI/EXAMINATED=JA -->
				<xsl:for-each select="m:Examinations/m:BMI[m:Examinated = 'ja']">
					<xsl:if test="count(../m:Height/m:Value)=0">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">Height skal angives hvis BMI/Examinated = ja </xsl:with-param> 
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="count(../m:Weight/m:Value)=0">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">Height skal angives hvis BMI/Examinated = ja </xsl:with-param> 
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
				
				 <!--OBLIGATORISK HVIS INSULIN/Treatment=JA -->
				<xsl:for-each select="m:CurrentTreatment/m:Insulin[m:Treatment = 'ja'] ">
					<xsl:if test="count(m:StartYear)=0">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">StartYear skal angives hvis Insulin/Treatment = ja </xsl:with-param> 
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
				
				 <!--MÅ IKKE VÆRE TILSTEDE HVIS INSULIN/Treatment<>JA -->
				<xsl:for-each select="m:CurrentTreatment/m:Insulin[m:Treatment != 'ja'] ">
					<xsl:if test="count(m:StartYear)>0">
						<xsl:call-template name="DRError">
							<xsl:with-param name="Text">StartYear må kun angives hvis Insulin/Treatment = ja </xsl:with-param> 
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
				
			</xsl:for-each>
		</Brev>
	</xsl:template>
</xsl:stylesheet>