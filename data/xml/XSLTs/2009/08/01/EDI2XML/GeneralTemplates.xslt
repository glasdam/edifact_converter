<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2009/08/01/">
	<!-- 
	****************************************************
	* Templates til at håndtere fejlmeddelelser  *
	****************************************************
	-->
	<xsl:template name="Error">
		<xsl:param name="Node" select="."/>
		<xsl:param name="Text" select=" 'Uventet fejl' "/>
		<FEJL>
			<xsl:if test="$Node/@linie!='' ">
				<xsl:attribute name="linie"><xsl:value-of select="$Node/@linie"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$Node/@position!='' ">
				<xsl:attribute name="position"><xsl:value-of select="$Node/@position"/></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$Text"/>
		</FEJL>
	</xsl:template>
	<!-- 
	******************************************************************************************************
	* Default fejlmeddelse hvis der ikke kan findes en konvertering til en given type brev *
	******************************************************************************************************
	-->
	<xsl:template match="Brev">
		<xsl:call-template name="Error">
			<xsl:with-param name="Node" select="UNH/Elm[2]"/>
			<xsl:with-param name="Text">Kan ikke konvertere breve af typen: [<xsl:value-of select="UNH/Elm[2]/SubElm[1]"/> ,  <xsl:value-of select="UNH/Elm[2]/SubElm[5]"/>]</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- 
	******************************************************************************************************
	* Default fejlmeddelse hvis der ikke kan findes en konvertering til et givent element *
	******************************************************************************************************
	-->
	<xsl:template match="*">
		<xsl:call-template name="Error">
			<xsl:with-param name="Text">Uventet element: <xsl:value-of select="name"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- 
	********************************************
	* OVERSÆTTELSE AF DATOTIDER *
	********************************************
	-->
	<!-- 
	******************************************************************************
	* Default oværsættelse af Dato-tider i edifact formatet DTM 203 *
	******************************************************************************
	-->
	<xsl:template match="DTM[Elm[1]/SubElm[3]='203'] ">
		<xsl:call-template name="DTM203ToDateTime"/>
	</xsl:template>
	<!-- 
	*********************************************************************
	* Template der oversætter DTM segmenter af typen 203 *
	*********************************************************************
	-->
	<xsl:template name="DTM203ToDateTime">
		<xsl:param name="DTM" select="."/>
		<xsl:variable name="DT203" select="$DTM/Elm[1]/SubElm[2]"/>
		<xsl:if test="$DTM/Elm[1]/SubElm[3]!='203' ">
			<xsl:call-template name="Error">
				<xsl:with-param name="Node" select="$DTM/Elm[1]/SubElm[3]"/>
				<xsl:with-param name="Text">Kun datotider af typen 203 er tilladt</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="string-length($DT203)!=12">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Forkert antal tegn i Datotid:<xsl:value-of select="$DT203"/> - der skal være 12 når kvalifikatoren er 203</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<Date>
			<xsl:value-of select="concat(substring($DT203,1,4),'-',substring($DT203,5,2),'-',substring($DT203,7,2))"/>
		</Date>
		<Time>
			<xsl:value-of select="concat(substring($DT203,9,2),':',substring($DT203,11,2))"/>
		</Time>
	</xsl:template>
	<!-- 
	*********************************************************************
	* Template der oversætter DTM segmenter af typen 204 *
	*********************************************************************
	-->
	<xsl:template name="DTM204ToDateTimeWithSec">
		<xsl:param name="DTM" select="."/>
		<xsl:if test="$DTM/Elm[1]/SubElm[3]!='204' ">
			<xsl:call-template name="Error">
				<xsl:with-param name="Node" select="$DTM/Elm[1]/SubElm[3]"/>
				<xsl:with-param name="Text">Kun datotider af typen 204 er tilladt</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:variable name="DT204" select="$DTM/Elm[1]/SubElm[2]"/>
		<xsl:if test="string-length($DT204)!=14">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Forkert antal tegn i Datotid:<xsl:value-of select="$DT204"/> - der skal være 14 når kvalifikatoren er 204</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<Date>
			<xsl:value-of select="concat(substring($DT204,1,4),'-',substring($DT204,5,2),'-',substring($DT204,7,2))"/>
		</Date>
		<TimeWithSec>
			<xsl:value-of select="concat(substring($DT204,9,2),':',substring($DT204,11,2),':',substring($DT204,13,2))"/>
		</TimeWithSec>
	</xsl:template>
	<xsl:template name="DTM204ToDateTimeWithoutSec">
		<xsl:param name="DTM" select="."/>
		<xsl:if test="$DTM/Elm[1]/SubElm[3]!='204' ">
			<xsl:call-template name="Error">
				<xsl:with-param name="Node" select="$DTM/Elm[1]/SubElm[3]"/>
				<xsl:with-param name="Text">Kun datotider af typen 204 er tilladt</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:variable name="DT204" select="$DTM/Elm[1]/SubElm[2]"/>
		<xsl:if test="string-length($DT204)!=14">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Forkert antal tegn i Datotid:<xsl:value-of select="$DT204"/> - der skal være 14 når kvalifikatoren er 204</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<Date>
			<xsl:value-of select="concat(substring($DT204,1,4),'-',substring($DT204,5,2),'-',substring($DT204,7,2))"/>
		</Date>
		<Time>
			<xsl:value-of select="concat(substring($DT204,9,2),':',substring($DT204,11,2))"/>
		</Time>
	</xsl:template>
	<!--
	*********************************************************************
	* Template der oversætter DTM segmenter af typen 102 *
	*********************************************************************
	-->
	<xsl:template name="DTM102ToDateType">
		<xsl:param name="DTM" select="."/>
		<xsl:if test="$DTM/Elm[1]/SubElm[3]!='102' ">
			<xsl:call-template name="Error">
				<xsl:with-param name="Node" select="$DTM/Elm[1]/SubElm[3]"/>
				<xsl:with-param name="Text">Kun datotider af typen 102 er tilladt</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:variable name="DT102" select="$DTM/Elm[1]/SubElm[2]"/>
		<xsl:if test="string-length($DT102)!=8">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Forkert antal tegn i Datotid:<xsl:value-of select="$DT102"/> - der skal være 8 når kvalifikatoren er 102</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:value-of select="concat(substring($DT102,1,4),'-',substring($DT102,5,2),'-',substring($DT102,7,2))"/>
	</xsl:template>
	<!-- 
	****************************************************************************************************
	* Template til at oversætte diverse DTM segmenter til DateTime elementer i XML'en *
	***************************************************************************************************
	-->
	<!--<xsl:template name="DTMToDateTime">
		<xsl:param name="DTM" select="."/>
		<xsl:choose>
			<xsl:when test="$DTM/Elm[1]/SubElm[3]='203' ">
				<xsl:call-template name="DTM203ToDateTime"/>
			</xsl:when>
			<xsl:when test="$DTM/Elm[1]/SubElm[3]='204' ">
				<xsl:call-template name="DTM204ToDateTime"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Error">
					<xsl:with-param name="Node" select="$DTM"/>
					<xsl:with-param name="Text">Ukendt datoformat:<xsl:value-of select="$DTM/Elm[1]/SubElm[3]"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	<!-- 
	**************************************************
	* OVERSÆTTELSE AF FTXSEGMENTER *
	**************************************************
	-->
	
	<!-- 
	****************************************************************************************************
	* Template der oversætter Tekstelementerne i et FTX segment til en tekst *
	***************************************************************************************************
	-->
	<xsl:template name="FTXSubElmsToText">
		<xsl:param name="FTXSubElms" select="."/>
		<xsl:for-each select="$FTXSubElms">
			<xsl:choose>
				<xsl:when test=".='.'">
				</xsl:when>
				<xsl:when test="string-length(.)>0 and substring(.,string-length(.),1)='\'">
					<xsl:value-of select="substring(.,1,string-length(.)-1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!-- 
	****************************************************************************************************
	* Template der oversætter Tekstelementerne i et FTX segment til en Breakable tekst *
	***************************************************************************************************
	-->
	<xsl:template name="FTXSubElmsToBreakableText">
		<xsl:param name="FTXSubElms" select="."/>
		<xsl:for-each select="$FTXSubElms">
			<xsl:choose>
				<xsl:when test=".='.'">
					<Break/>
				</xsl:when>
				<xsl:when test="string-length(.)>0 and substring(.,string-length(.),1)='\'">
					<xsl:value-of select="substring(.,1,string-length(.)-1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
					<Break/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!-- 
	**************************************************************************************
	* Template der oversætter FTX segmenter til en tekst uden formatering *
	**************************************************************************************
	-->
	<xsl:template name="FTXSegmentsToText">
		<xsl:param name="FTXSegments" select="."/>
		<xsl:for-each select="$FTXSegments/Elm[4]/SubElm">
			<xsl:choose>
				<xsl:when test=".='.'">
				</xsl:when>
				<xsl:when test="string-length(.)>0 and substring(.,string-length(.),1)='\'">
					<xsl:value-of select="substring(.,1,string-length(.)-1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!-- 
	*********************************************************************************
	* FTX segmenter til en breakable tekst uden yderligere formatering *
	*********************************************************************************
	-->
	<xsl:template name="FTXSegmentsToBreakableText">
		<xsl:param name="FTXSegments" select="."/>
		<xsl:call-template name="FTXSubElmsToBreakableText">
			<xsl:with-param name="FTXSubElms" select="$FTXSegments/Elm[4]/SubElm"/>
		</xsl:call-template>
	</xsl:template>
	<!-- 
	*************************************************************************************************
	* Template der oversætter en mængde af FTX segmenter til en formateret tekst *
	*************************************************************************************************
	-->
	<xsl:template name="FTXSegmentsToFormattedText">
		<xsl:param name="FTXSegments" select="."/>
		<xsl:for-each select="$FTXSegments">
			<xsl:choose>
				<xsl:when test="Elm[2]/SubElm[1]='F00' ">
					<FixedFont>
						<xsl:call-template name="FTXSubElmsToBreakableText">
							<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
						</xsl:call-template>
					</FixedFont>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='F0H' ">
					<FixedFont>
						<Right>
							<xsl:call-template name="FTXSubElmsToBreakableText">
								<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
							</xsl:call-template>
						</Right>
					</FixedFont>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='F0M' ">
					<FixedFont>
						<Center>
							<xsl:call-template name="FTXSubElmsToBreakableText">
								<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
							</xsl:call-template>
						</Center>
					</FixedFont>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='FF0' ">
					<FixedFont>
						<Bold>
							<xsl:call-template name="FTXSubElmsToBreakableText">
								<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
							</xsl:call-template>
						</Bold>
					</FixedFont>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='FU0' ">
					<FixedFont>
						<Underline>
							<xsl:call-template name="FTXSubElmsToBreakableText">
								<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
							</xsl:call-template>
						</Underline>
					</FixedFont>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='FK0' ">
					<FixedFont>
						<Italic>
							<xsl:call-template name="FTXSubElmsToBreakableText">
								<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
							</xsl:call-template>
						</Italic>
					</FixedFont>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='P00' ">
					<xsl:call-template name="FTXSubElmsToBreakableText">
						<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='P0H' ">
					<Right>
						<xsl:call-template name="FTXSubElmsToBreakableText">
							<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
						</xsl:call-template>
					</Right>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='P0M' ">
					<Center>
						<xsl:call-template name="FTXSubElmsToBreakableText">
							<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
						</xsl:call-template>
					</Center>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='PF0' ">
					<Bold>
						<xsl:call-template name="FTXSubElmsToBreakableText">
							<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
						</xsl:call-template>
					</Bold>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='PU0' ">
					<Underline>
						<xsl:call-template name="FTXSubElmsToBreakableText">
							<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
						</xsl:call-template>
					</Underline>
				</xsl:when>
				<xsl:when test="Elm[2]/SubElm[1]='PK0' ">
					<Italic>
						<xsl:call-template name="FTXSubElmsToBreakableText">
							<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
						</xsl:call-template>
					</Italic>
				</xsl:when>
				<xsl:otherwise>
					<FixedFont>
						<xsl:call-template name="FTXSubElmsToBreakableText">
							<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
						</xsl:call-template>
					</FixedFont>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!-- 
	********************************************************************
	* OVERSÆTTELSE AF DIVERSE KVALIFIKATORLISTER *
	********************************************************************
	-->
	<!-- 
	*********************************************************************
	* Template for Fejl situationer relateret til kvalifikatorlister *
	*********************************************************************
	-->
	<xsl:template name="ValueListError">
		<xsl:param name="ValueNode" select="."/>
		<xsl:param name="Text" select="'Ikke tilladt værdi'"/>
		<xsl:call-template name="Error">
			<xsl:with-param name="Node" select="$ValueNode"/>
			<xsl:with-param name="Text">
				<xsl:value-of select="$Text"/>: <xsl:value-of select="$ValueNode"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- 
	*********************************************************
	* Template til at oversætte afsenders speciale *
	*********************************************************
	-->
	<xsl:template name="AFSSPECToMedicalSpecialityCode">
		<xsl:param name="AFSSPEC" select="."/>
		<xsl:if test="$AFSSPEC!='' ">
			<MedicalSpecialityCode>
				<xsl:choose>
					<xsl:when test=" $AFSSPEC='99' ">ikkeklassificeret</xsl:when>
					<xsl:when test=" $AFSSPEC='1' ">intern_medicin_sygehus</xsl:when>
					<xsl:when test=" $AFSSPEC='2' ">geriatri</xsl:when>
					<xsl:when test=" $AFSSPEC='3' ">hepatologi</xsl:when>
					<xsl:when test=" $AFSSPEC='4' ">haematologi</xsl:when>
					<xsl:when test=" $AFSSPEC='5' ">infektionsmedicin</xsl:when>
					<xsl:when test=" $AFSSPEC='6' ">kardiologi</xsl:when>
					<xsl:when test=" $AFSSPEC='7' ">med_allergologi</xsl:when>
					<xsl:when test=" $AFSSPEC='8' ">med_endokrinologi</xsl:when>
					<xsl:when test=" $AFSSPEC='9' ">med_gastroenterologi</xsl:when>
					<xsl:when test=" $AFSSPEC='10' ">med_lungesygdomme</xsl:when>
					<xsl:when test=" $AFSSPEC='11' ">nefrologi</xsl:when>
					<xsl:when test=" $AFSSPEC='12' ">reumatologi</xsl:when>
					<xsl:when test=" $AFSSPEC='18' ">dermato_venerologi_sygehus</xsl:when>
					<xsl:when test=" $AFSSPEC='20' ">neurologi</xsl:when>
					<xsl:when test=" $AFSSPEC='22' ">onkologi</xsl:when>
					<xsl:when test=" $AFSSPEC='30' ">kirurgi_sygehus</xsl:when>
					<xsl:when test=" $AFSSPEC='31' ">karkirurgi</xsl:when>
					<xsl:when test=" $AFSSPEC='32' ">kir_gastroenterologi</xsl:when>
					<xsl:when test=" $AFSSPEC='33' ">plastikkirurgi</xsl:when>
					<xsl:when test=" $AFSSPEC='34' ">thoraxkirurgi</xsl:when>
					<xsl:when test=" $AFSSPEC='35' ">urologi</xsl:when>
					<xsl:when test=" $AFSSPEC='38' ">gynaekologi_obstetrik_sygehus</xsl:when>
					<xsl:when test=" $AFSSPEC='40' ">neurokirurgi</xsl:when>
					<xsl:when test=" $AFSSPEC='42' ">ortopaedisk_kirurgi_sygehus</xsl:when>
					<xsl:when test=" $AFSSPEC='44' ">oftalmologi</xsl:when>
					<xsl:when test=" $AFSSPEC='46' ">oto_rhino_laryngologi</xsl:when>
					<xsl:when test=" $AFSSPEC='48' ">hospitalsodontologi</xsl:when>
					<xsl:when test=" $AFSSPEC='50' ">psykiatri_sygehus</xsl:when>
					<xsl:when test=" $AFSSPEC='52' ">boerne_ungdomspsykiatri</xsl:when>
					<xsl:when test=" $AFSSPEC='60' ">klin_biokemi</xsl:when>
					<xsl:when test=" $AFSSPEC='61' ">klin_fys_nuklearmedicin</xsl:when>
					<xsl:when test=" $AFSSPEC='62' ">klin_immunologi</xsl:when>
					<xsl:when test=" $AFSSPEC='63' ">klin_mikrobiologi</xsl:when>
					<xsl:when test=" $AFSSPEC='64' ">klin_neurofysiologi</xsl:when>
					<xsl:when test=" $AFSSPEC='65' ">patologisk_anatomi</xsl:when>
					<xsl:when test=" $AFSSPEC='66' ">diagnostisk_radiologi</xsl:when>
					<xsl:when test=" $AFSSPEC='67' ">klin_farmakologi</xsl:when>
					<xsl:when test=" $AFSSPEC='68' ">klin_genetik</xsl:when>
					<xsl:when test=" $AFSSPEC='84' ">anaestesiologi_sygehus</xsl:when>
					<xsl:when test=" $AFSSPEC='86' ">arbejdsmedicin</xsl:when>
					<xsl:when test=" $AFSSPEC='90' ">almen_medicin</xsl:when>
					<xsl:when test=" $AFSSPEC='91' ">samfundsmedicin</xsl:when>
					<xsl:when test=" $AFSSPEC='580' ">almenlaege_laegevagt</xsl:when>
					<xsl:when test=" $AFSSPEC='1519' ">oejenlaege</xsl:when>
					<xsl:when test=" $AFSSPEC='2021' ">oere_naese_halslaege</xsl:when>
					<xsl:when test=" $AFSSPEC='2501' ">anaestesiologi_praksis</xsl:when>
					<xsl:when test=" $AFSSPEC='2503' ">roentgen_kbh</xsl:when>
					<xsl:when test=" $AFSSPEC='2504' ">dermato_venerologi_praksis</xsl:when>
					<xsl:when test=" $AFSSPEC='2505' ">roentgen</xsl:when>
					<xsl:when test=" $AFSSPEC='2506' ">reumatologi_fysiurgi</xsl:when>
					<xsl:when test=" $AFSSPEC='2507' ">gynaekologi_obstetrik_praksis</xsl:when>
					<xsl:when test=" $AFSSPEC='2508' ">intern_medicin_praksis</xsl:when>
					<xsl:when test=" $AFSSPEC='2509' ">kirurgi_praksis</xsl:when>
					<xsl:when test=" $AFSSPEC='2511' ">klinisk_kemi</xsl:when>
					<xsl:when test=" $AFSSPEC='2518' ">neuromedicin</xsl:when>
					<xsl:when test=" $AFSSPEC='2520' ">ortopaedisk_kirurgi_praksis</xsl:when>
					<xsl:when test=" $AFSSPEC='2522' ">patologi </xsl:when>
					<xsl:when test=" $AFSSPEC='2523' ">plastkirurgi</xsl:when>
					<xsl:when test=" $AFSSPEC='2524' ">psykiatri_praksis</xsl:when>
					<xsl:when test=" $AFSSPEC='2525' ">paediatri</xsl:when>
					<xsl:when test=" $AFSSPEC='2526' ">boernepsykiatri</xsl:when>
					<xsl:when test=" $AFSSPEC='2528' ">tropemedicin</xsl:when>
					<xsl:when test=" $AFSSPEC='4050' ">tandlaege</xsl:when>
					<xsl:when test=" $AFSSPEC='4551' ">fysioterapi</xsl:when>
					<xsl:when test=" $AFSSPEC='5053' ">kiropraktor</xsl:when>
					<xsl:when test=" $AFSSPEC='5552' ">briller</xsl:when>
					<xsl:when test=" $AFSSPEC='6054' ">fodterapi</xsl:when>
					<xsl:when test=" $AFSSPEC='6055' ">fodbehandlking</xsl:when>
					<xsl:when test=" $AFSSPEC='7045' ">med_laboratorier</xsl:when>
					<xsl:when test=" $AFSSPEC='7046' ">omegnslaboratorier</xsl:when>
					<xsl:when test=" $AFSSPEC='9463' ">psykolog</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="ValueListError">
							<xsl:with-param name="ValueNode" select="$AFSSPEC"/>
							<xsl:with-param name="Text">Kan ikke oversætte AFSSPEC til MedicalSpecialityCode</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</MedicalSpecialityCode>
		</xsl:if>
	</xsl:template>
	<xsl:template name="SPRToMedicalSpecialityCode">
		<xsl:param name="SPR" select="."/>
		<xsl:call-template name="AFSSPECToMedicalSpecialityCode">
			<xsl:with-param name="AFSSPEC" select="$SPR/Elm[2]/SubElm[1]"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="SPR31ToMedicalSpecialityCode">
		<xsl:param name="SPR" select="."/>
		<xsl:call-template name="AFSSPECToMedicalSpecialityCode">
			<xsl:with-param name="AFSSPEC" select="$SPR/Elm[3]/SubElm[1]"/>
		</xsl:call-template>
	</xsl:template>
	<!-- 
	******************************************************
	* Template til at oversætte pårørendes rolle *
	******************************************************
	-->
	<xsl:template name="RELToRelationCode">
		<xsl:param name="REL" select="."/>
		<RelationCode>
			<xsl:variable name="RC" select="$REL/Elm[2]/SubElm[1]"/>
			<xsl:choose>
				<xsl:when test="$RC='GU'">uspec_paaroerende</xsl:when>
				<xsl:when test="$RC='MO'">mor</xsl:when>
				<xsl:when test="$RC='FA'">far</xsl:when>
				<xsl:when test="$RC='SD'">barn</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="ValueListError">
						<xsl:with-param name="ValueNode" select="$RC"/>
						<xsl:with-param name="Text">Kan ikke oversætte kode for pårørende</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</RelationCode>
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte NAD segmenter *
	******************************************************
	-->
	<xsl:template name="NADToIdentifier">
		<xsl:param name="NAD" select="."/>
		<xsl:if test="$NAD/Elm[2]/SubElm[1]!='' ">
			<Identifier>
				<xsl:value-of select="$NAD/Elm[2]/SubElm[1]"/>
			</Identifier>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NADToIdentifierCode">
		<xsl:param name="NAD" select="."/>
		<xsl:if test="count($NAD/Elm[2]/SubElm[2])>0">
		<IdentifierCode>
			<xsl:variable name="IC" select="$NAD/Elm[2]/SubElm[2]"/>
			<xsl:choose>
				<xsl:when test="$IC='SKS' ">sygehusafdelingsnummer</xsl:when>
				<xsl:when test="$IC='YNR' ">ydernummer</xsl:when>
				<xsl:when test="$IC='EAN' ">lokationsnummer</xsl:when>
				<xsl:when test="$IC='' ">lokationsnummer</xsl:when>
				<xsl:when test="$IC='KOM' ">kommunenummer</xsl:when>
				<xsl:when test="$IC='SOR'">sorkode</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="Error">
						<xsl:with-param name="Node" select="$IC"/>
						<xsl:with-param name="Text">Kan ikke oversaette til IdentifierCodeType: <xsl:value-of select="$IC"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</IdentifierCode>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NADToOrganisationName">
		<xsl:param name="NAD" select="."/>
		<xsl:if test="$NAD/Elm[4]/SubElm[1]!=''">
			<OrganisationName>
				<xsl:value-of select="$NAD/Elm[4]/SubElm[1]"/>
			</OrganisationName>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NADToDepartmentName">
		<xsl:param name="NAD" select="."/>
		<xsl:if test="$NAD/Elm[4]/SubElm[2]!=''">
			<DepartmentName>
				<xsl:value-of select="$NAD/Elm[4]/SubElm[2]"/>
			</DepartmentName>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NADToUnitName">
		<xsl:param name="NAD" select="."/>
		<xsl:if test="$NAD/Elm[4]/SubElm[3]!=''">
			<UnitName>
				<xsl:value-of select="$NAD/Elm[4]/SubElm[3]"/>
			</UnitName>
		</xsl:if>
	</xsl:template>
	<!-- 
	***********************************
	* Andre NAD oversættelser *
	***********************************
	-->
	<xsl:template name="NADToPersonInitials">
		<xsl:param name="NAD" select="."/>
		<PersonInitials>
			<xsl:value-of select="$NAD/Elm[4]/SubElm[1]"/>
		</PersonInitials>
	</xsl:template>
	<xsl:template name="NADToPersonTitle">
		<xsl:param name="NAD" select="."/>
		<xsl:if test="$NAD/Elm[4]/SubElm[1]!=''">
			<PersonTitle>
				<xsl:value-of select="$NAD/Elm[4]/SubElm[1]"/>
			</PersonTitle>
		</xsl:if>
	</xsl:template>
	<xsl:template name="NADToPersonName">
		<xsl:param name="NAD" select="."/>
		<xsl:if test="$NAD/Elm[4]/SubElm[2]!=''">
			<PersonName>
				<xsl:value-of select="$NAD/Elm[4]/SubElm[2]"/>
			</PersonName>
		</xsl:if>
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte ADR segmenter *
	******************************************************
	-->
	<xsl:template name="ADRToStreetName">
		<xsl:param name="ADR" select="."/>
		<xsl:if test="$ADR/Elm[2]/SubElm[2]!=''">
			<StreetName>
				<xsl:value-of select="$ADR/Elm[2]/SubElm[2]"/>
			</StreetName>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ADRToSuburbName">
		<xsl:param name="ADR" select="."/>
		<xsl:if test="$ADR/Elm[2]/SubElm[3]!='' ">
			<SuburbName>
				<xsl:value-of select="$ADR/Elm[2]/SubElm[3]"/>
			</SuburbName>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ADRToDistrictName">
		<xsl:param name="ADR" select="."/>
		<xsl:if test="$ADR/Elm[3]/SubElm[1]!='' ">
			<DistrictName>
				<xsl:value-of select="$ADR/Elm[3]/SubElm[1]"/>
			</DistrictName>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ADRToPostCodeIdentifier">
		<xsl:param name="ADR" select="."/>
		<xsl:if test="$ADR/Elm[4]/SubElm[1]!='' ">
			<PostCodeIdentifier>
				<xsl:value-of select="$ADR/Elm[4]/SubElm[1]"/>
			</PostCodeIdentifier>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ADRToMunicipalityId">
		<xsl:param name="ADR" select="."/>
		<MunicipalityId>
			<xsl:value-of select="$ADR/Elm[6]/SubElm[1]"/>
		</MunicipalityId>
	</xsl:template>
	<xsl:template name="ADRToMunicipalityName">
		<xsl:param name="ADR" select="."/>
		<MunicipalityName>
			<xsl:value-of select="$ADR/Elm[6]/SubElm[4]"/>
		</MunicipalityName>
	</xsl:template>
	<xsl:template name="ADRToCountryCode">
		<xsl:param name="ADR" select="."/>
		<xsl:if test="$ADR/Elm[5]/SubElm[1]!=''">
			<CountryCode>
				<xsl:value-of select="$ADR/Elm[5]/SubElm[1]"/>
			</CountryCode>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ADRToCountyCode">
		<xsl:param name="ADR" select="."/>
		<xsl:if test="$ADR/Elm[6]/SubElm[1]!=''">
		<CountyCode>
			<xsl:value-of select="$ADR/Elm[6]/SubElm[1]"/>
		</CountyCode>
		</xsl:if>
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte PNA segmenter *
	******************************************************
	-->
	<xsl:template name="PNAToCivilRegistrationNumber">
		<xsl:param name="PNA" select="."/>
		<xsl:if test="$PNA/Elm[2]/SubElm[1]!='' ">
			<CivilRegistrationNumber>
				<xsl:value-of select="$PNA/Elm[2]/SubElm[1]"/>
			</CivilRegistrationNumber>
		</xsl:if>
	</xsl:template>
	<xsl:template name="PNAToAuthorisationIdentifier">
		<xsl:param name="PNA" select="."/>
		<xsl:if test="$PNA/Elm[2]/SubElm[1]!='' ">
			<AuthorisationIdentifier>
				<xsl:value-of select="$PNA/Elm[2]/SubElm[1]"/>
			</AuthorisationIdentifier>
		</xsl:if>
	</xsl:template>
	<xsl:template name="PNAToPersonIdentifier">
		<xsl:param name="PNA" select="."/>
		<xsl:if test="$PNA/Elm[2]/SubElm[1]!=''">
			<PersonIdentifier>
				<xsl:value-of select="$PNA/Elm[2]/SubElm[1]"/>
			</PersonIdentifier>
		</xsl:if>
	</xsl:template>
	<xsl:template name="PNAToPersonSurnameName">
		<xsl:param name="PNA" select="."/>
		<PersonSurnameName>
			<xsl:value-of select="$PNA/Elm[5]/SubElm[2]"/>
		</PersonSurnameName>
	</xsl:template>
	<xsl:template name="PNAToPersonGivenName">
		<xsl:param name="PNA" select="."/>
		<xsl:if test="$PNA/Elm[6]/SubElm[2]!='' ">
			<PersonGivenName>
				<xsl:value-of select="$PNA/Elm[6]/SubElm[2]"/>
			</PersonGivenName>
		</xsl:if>
	</xsl:template>
	<!-- RECEPT SPECIFIKKE OVERSÆTTELSER -->
	<xsl:template name="PNAToEANIdentifier">
		<xsl:param name="PNA" select="."/>
		<EANIdentifier>
			<xsl:value-of select="$PNA/Elm[3]/SubElm[1]"/>
		</EANIdentifier>
	</xsl:template>
	<xsl:template name="PNAToIdentifier">
		<xsl:param name="PNA" select="."/>
		<Identifier>
			<xsl:value-of select="$PNA/Elm[3]/SubElm[1]"/>
		</Identifier>
	</xsl:template>
	<xsl:template name="PNAToIdentifierCode">
		<xsl:param name="PNA" select="."/>
			<IdentifierCode>
				<xsl:variable name="IC" select="$PNA/Elm[3]/SubElm[2]"/>
				<xsl:choose>
					<xsl:when test="$IC='SKS' ">sygehusafdelingsnummer</xsl:when>
					<xsl:when test="$IC='YNR' ">ydernummer</xsl:when>
					<xsl:when test="$IC='EAN' ">lokationsnummer</xsl:when>
					<xsl:when test="$IC='' ">lokationsnummer</xsl:when>
					<xsl:when test="$IC='KOM' ">kommunenummer</xsl:when>
					<xsl:when test="$IC='SOR'">sorkode</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="Error">
							<xsl:with-param name="Node" select="$IC"/>
							<xsl:with-param name="Text">Kan ikke oversaette til IdentifierCodeType: <xsl:value-of select="$IC"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</IdentifierCode>
	</xsl:template>
	<!-- RECEPT relaterede oversættelser -->
	<xsl:template name="PNAToTitleAndName">
		<xsl:param name="PNA" select="."/>
		<TitleAndName>
			<xsl:value-of select="$PNA/Elm[6]/SubElm[2]"/>
		</TitleAndName>
	</xsl:template>
	<xsl:template name="PNA62ToOrganisationName">
		<xsl:param name="PNA" select="."/>
		<xsl:if test="$PNA/Elm[6]/SubElm[2]!='' ">
			<OrganisationName>
				<xsl:value-of select="$PNA/Elm[6]/SubElm[2]"/>
			</OrganisationName>
		</xsl:if>
	</xsl:template>
	<xsl:template name="PNA72ToOrganisationName">
		<xsl:param name="PNA" select="."/>
		<xsl:if test="$PNA/Elm[7]/SubElm[2]!='' ">
			<OrganisationName>
				<xsl:value-of select="$PNA/Elm[7]/SubElm[2]"/>
			</OrganisationName>
		</xsl:if>
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte RFF segmenter *
	******************************************************
	-->
	<xsl:template name="RFFToAlternativeIdentifier">
		<xsl:param name="RFF" select="."/>
		<AlternativeIdentifier>
			<xsl:value-of select="Elm[1]/SubElm[2]"/>
		</AlternativeIdentifier>
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte CON segmenter *
	******************************************************
	-->
	<xsl:template name="CONToTelephoneSubscriberIdentifier">
		<xsl:param name="CON" select="."/>
		<TelephoneSubscriberIdentifier>
			<xsl:value-of select="$CON/Elm[2]/SubElm[1]"/>
		</TelephoneSubscriberIdentifier>
		<!--måske skal der testes for TE-->
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte COM segmenter *
	******************************************************
	-->
	<xsl:template name="COMToTelephoneSubscriberIdentifier">
		<xsl:param name="COM" select="."/>
		<TelephoneSubscriberIdentifier>
			<xsl:value-of select="$COM/Elm[1]/SubElm[1]"/>
		</TelephoneSubscriberIdentifier>
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte HAN segmenter *
	******************************************************
	-->
	<xsl:template name="HANToConsentText">
		<xsl:param name="HAN" select="."/>
		<Text>
			<xsl:value-of select="$HAN/Elm[1]/SubElm[4]"/>
		</Text>
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte EMP segmenter *
	******************************************************
	-->
	<xsl:template name="EMPToOccupancyText">
		<xsl:param name="EMP" select="."/>
		<OccupancyText>
			<xsl:value-of select="$EMP/Elm[3]/SubElm[4]"/>
		</OccupancyText>
	</xsl:template>
	<xsl:template name="EMPToOccupation">
		<xsl:param name="EMP" select="."/>
		<Occupation>
			<xsl:variable name="Occ" select="$EMP/Elm[2]/SubElm[1]"/>
			<xsl:choose>
				<xsl:when test="$Occ='DEN'">tandlaege</xsl:when>
				<xsl:when test="$Occ='PHY'">laege</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="ValueListError">
						<xsl:with-param name="ValueNode" select="$Occ"/>
						<xsl:with-param name="Text">Ukendt UDSTEDERPROF</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</Occupation>
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte PDI segmenter *
	******************************************************
	-->
	<xsl:template name="PDIToPatientSex">
		<xsl:param name="PDI" select="."/>
		<PatientSex>
			<xsl:variable name="PS" select="$PDI/Elm[1]/SubElm[1]"/>
			<xsl:choose>
				<xsl:when test="$PS='1' ">hankoen</xsl:when>
				<xsl:when test="$PS='2' ">hunkoen</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="Error">
						<xsl:with-param name="Node" select="$PS"/>
						<xsl:with-param name="Text">Kan ikke oversaette til PatientSex: <xsl:value-of select="$PS"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</PatientSex>
	</xsl:template>
	<!-- 
	******************************************************
	* Templates til at oversætte CIN segmenter *
	******************************************************
	-->
	<xsl:template name="CINToCode">
		<xsl:param name="CIN" select="."/>
		<xsl:if test="$CIN/Elm[2]/SubElm[1]!=''">
			<Code>
				<xsl:value-of select="$CIN/Elm[2]/SubElm[1]"/>
			</Code>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CINToText">
		<xsl:param name="CIN" select="."/>
		<xsl:if test="$CIN/Elm[2]/SubElm[4]!=''">
			<Text>
				<xsl:value-of select="$CIN/Elm[2]/SubElm[4]"/>
			</Text>
		</xsl:if>
	</xsl:template>
	<!-- 
	*******************************************************************
	* Templates til at oversætte Reference FTX segmenter *
	*******************************************************************
	-->
	<xsl:template name="FTXSegmentToReference">
		<xsl:param name="FTX" select="."/>
		<Reference>
			<RefDescription>
				<xsl:value-of select="$FTX/Elm[4]/SubElm[1]"/>
			</RefDescription>
			<xsl:variable name="RefType" select="$FTX/Elm[1]/SubElm[1]"/>
			<xsl:choose>
				<xsl:when test="$RefType='BIN' ">
					<BIN>
						<ObjectIdentifier>
							<xsl:value-of select="$FTX/Elm[4]/SubElm[2]"/>
						</ObjectIdentifier>
						<xsl:call-template name="FTXToObjectCode">
							<xsl:with-param name="FTX" select="$FTX"/>
						</xsl:call-template>
						<xsl:call-template name="FTXToObjectExtensionCode">
							<xsl:with-param name="FTX" select="$FTX"/>
						</xsl:call-template>
						<OriginalObjectSize>
							<xsl:value-of select="$FTX/Elm[4]/SubElm[5]"/>
						</OriginalObjectSize>
					</BIN>
				</xsl:when>
				<xsl:when test="$RefType='URL' ">
					<URL>
						<xsl:call-template name="FTXSubElmsToText">
							<xsl:with-param name="FTXSubElms" select="$FTX/Elm[4]/SubElm[position()>1]"/>
						</xsl:call-template>
					</URL>
				</xsl:when>
				<xsl:when test="$RefType='SUP' ">
					<SUP>true</SUP>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="Error">
						<xsl:with-param name="Node" select="$RefType"/>
						<xsl:with-param name="Text">Kan ikke oversaette til Referencetype: <xsl:value-of select="$RefType"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</Reference>
	</xsl:template>
	<!-- 
	*******************************************************************
	* Templates til at oversætte UNO segmenter                  *
	*******************************************************************
	-->
	<xsl:template name="ValueToObjectCode">
		<xsl:param name="OC" select="."/>
		<ObjectCode>
			<xsl:choose>
				<xsl:when test="$OC='TXT'">tekstfil</xsl:when>
				<xsl:when test="$OC='IMG'">billede</xsl:when>
				<xsl:when test="$OC='PRG'">program</xsl:when>
				<xsl:when test="$OC='VGR'">vektor_grafik</xsl:when>
				<xsl:when test="$OC='BSG'">biosignaler</xsl:when>
				<xsl:when test="$OC='MUL'">multimedie</xsl:when>
				<xsl:when test="$OC='PRP'">proprietaert_indhold</xsl:when>
				<!--Andre ikke godkendte oversættelser-->
				<xsl:when test="$OC='SND'">multimedie</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="ValueListError">
						<xsl:with-param name="ValueNode" select="$OC"/>
						<xsl:with-param name="Text">Ukendt OBJEKTTYPE</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</ObjectCode>
	</xsl:template>
	<xsl:template name="ValueToObjectExtensionCode">
		<xsl:param name="OEC" select="."/>
		<ObjectExtensionCode>
			<xsl:choose>
				<xsl:when test="$OEC='PCX'">pcx</xsl:when>
				<xsl:when test="$OEC='TIF'">tiff</xsl:when>
				<xsl:when test="$OEC='JPG'">jpeg</xsl:when>
				<xsl:when test="$OEC='GIF'">gif</xsl:when>
				<xsl:when test="$OEC='BMP'">bmp</xsl:when>
				<xsl:when test="$OEC='PNG'">png</xsl:when>
				<xsl:when test="$OEC='MPG'">mpg</xsl:when>
				<xsl:when test="$OEC='DCM'">dcm</xsl:when>
				<xsl:when test="$OEC='SCP'">scp</xsl:when>
				<xsl:when test="$OEC='TXT'">txt</xsl:when>
				<xsl:when test="$OEC='RTF'">rtf</xsl:when>
				<xsl:when test="$OEC='DOC'">doc</xsl:when>
				<xsl:when test="$OEC='XLS'">xsl</xsl:when>
				<xsl:when test="$OEC='WPD'">wpd</xsl:when>
				<xsl:when test="$OEC='EXE'">exe</xsl:when>
				<xsl:when test="$OEC='PDF'">pdf</xsl:when>
				<xsl:when test="$OEC='WAV'">wav</xsl:when>
				<xsl:when test="$OEC='AVI'">avi</xsl:when>
				<xsl:when test="$OEC='MID'">mid</xsl:when>
				<xsl:when test="$OEC='RMI'">rmi</xsl:when>
				<xsl:when test="$OEC='COM'">com</xsl:when>
				<xsl:when test="$OEC='ZIP'">zip</xsl:when>
				<xsl:when test="$OEC='BIN'">bin</xsl:when>
				<xsl:when test="$OEC='INH'">inh</xsl:when>
				<xsl:when test="$OEC='PLO'">plo</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="ValueListError">
						<xsl:with-param name="ValueNode" select="$OEC"/>
						<xsl:with-param name="Text">Ukendt OBJEKTEXTENSIONTYPE</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</ObjectExtensionCode>
	</xsl:template>
	<xsl:template name="UNOToObjectCode">
		<xsl:param name="UNO" select="."/>
		<xsl:for-each select="$UNO/Elm[3]/SubElm[2]">
			<xsl:call-template name="ValueToObjectCode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="UNOToObjectExtensionCode">
		<xsl:param name="UNO" select="."/>
		<xsl:for-each select="$UNO/Elm[3]/SubElm[3]">
			<xsl:call-template name="ValueToObjectExtensionCode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="FTXToObjectCode">
		<xsl:param name="FTX" select="."/>
		<xsl:for-each select="$FTX/Elm[4]/SubElm[3]">
			<xsl:call-template name="ValueToObjectCode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="FTXToObjectExtensionCode">
		<xsl:param name="FTX" select="."/>
		<xsl:for-each select="$FTX/Elm[4]/SubElm[4]">
			<xsl:call-template name="ValueToObjectExtensionCode"/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
