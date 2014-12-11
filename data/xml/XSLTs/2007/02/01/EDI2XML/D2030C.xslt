<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDDIS' and SubElm[5]='D2030C' ] or  (UNH/Elm[2][SubElm[1]='MEDDIS' and SubElm[5]='K98100'] and BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SOR']/SPR/Elm[3]/SubElm[4]='indlæggelsesadvis')]">
		<!--	<xsl:if test="$Unb/Elm[9]/SubElm[1]!='0' ">
		<FEJL>
			<xsl:attribute name="linie"><xsl:value-of select="$Unb/@linie"/></xsl:attribute>
			<xsl:attribute name="position"><xsl:value-of select="$Unb/@position"/></xsl:attribute>
			Der kan ikke bestilles kuvertkvittering for DIS20
		</FEJL>	
	</xsl:if>-->
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SOR']"/>
		<xsl:variable name="AnswerTo" select="$S01Sender/RFF"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='ROR']"/>
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
		<xsl:variable name="S11" select="BrevIndhold/S11"/>
		<xsl:variable name="DTMAdmission" select="$S11/DTM[Elm[1]/SubElm[1]='90']"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S07'  or name()='S11' )]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='SOR' or NAD/Elm[1]/SubElm[1]='ROR')]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<FEJL>
				<xsl:attribute name="linie"><xsl:value-of select="./@linie"/></xsl:attribute>
				<xsl:attribute name="position"><xsl:value-of select="./@position"/></xsl:attribute>
		Uventet segment: <xsl:value-of select="name()"/>
			</FEJL>
		</xsl:for-each>
		<NotificationOfAdmission>
			<xsl:for-each select="$S02LetterInfo">
				<Letter>
					<Identifier>
						<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
					</Identifier>
					<VersionCode>XD2030C</VersionCode>
					<StatisticalCode>XDIS20</StatisticalCode>
					<xsl:for-each select="$Dtm">
						<Authorisation>
							<xsl:call-template name="DTM204ToDateTimeWithSec"/>
						</Authorisation>
					</xsl:for-each>
					<TypeCode>XDIS20</TypeCode>
					<StatusCode>
						<xsl:variable name="C" select="$S11/GIS[1]/Elm[1]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$C='N' ">nytbrev</xsl:when>
							<xsl:when test="$C='M' ">rettetbrev</xsl:when>
							<xsl:when test="$C='C' ">annulleretbrev</xsl:when>
							<xsl:otherwise>
								<FEJL>
									<xsl:attribute name="linie"><xsl:value-of select="$C/@linie"/></xsl:attribute>
									<xsl:attribute name="position"><xsl:value-of select="$C/@position"/></xsl:attribute>
							Kan ikke oversaette fra GIS til StatusCode: <xsl:value-of select="$C"/>
								</FEJL>
							</xsl:otherwise>
						</xsl:choose>
					</StatusCode>
					<xsl:for-each select="$S11/RFF[Elm[1]/SubElm[1]='REI'] ">
						<NotificationIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</NotificationIdentifier>
					</xsl:for-each>
				</Letter>
			</xsl:for-each>
			<xsl:for-each select="$S01Sender">
				<Sender>
					<EANIdentifier>
						<xsl:value-of select="$SenderEAN"/>
					</EANIdentifier>
					<xsl:for-each select="NAD">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCode"/>
						<xsl:call-template name="NADToOrganisationName"/>
						<xsl:call-template name="NADToDepartmentName"/>
						<xsl:call-template name="NADToUnitName"/>
					</xsl:for-each>
					<xsl:for-each select="CON">
						<TelephoneSubscriberIdentifier>
							<xsl:value-of select="Elm[2]/SubElm[1]"/>
						</TelephoneSubscriberIdentifier>
					</xsl:for-each>
					<xsl:for-each select="$AnswerTo">
						<AnswerTo>
							<EANIdentifier>
								<xsl:value-of select="Elm[1]/SubElm[2]"/>
							</EANIdentifier>
						</AnswerTo>
					</xsl:for-each>
				</Sender>
			</xsl:for-each>
			<xsl:for-each select="$S01Receiver">
				<Receiver>
					<EANIdentifier>
						<xsl:value-of select="$ReceiverEAN"/>
					</EANIdentifier>
					<xsl:for-each select="NAD">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCode"/>
						<xsl:call-template name="NADToOrganisationName"/>
						<xsl:call-template name="NADToDepartmentName"/>
					</xsl:for-each>
				</Receiver>
			</xsl:for-each>
			<xsl:for-each select="$S07Patient">
				<Patient>
					<xsl:for-each select="PNA">
						<xsl:if test="Elm[2]/SubElm[1]!='' ">
							<CivilRegistrationNumber>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</CivilRegistrationNumber>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="$S11/PAS">
						<EpisodeOfCareStatusCode>
							<xsl:variable name="EOCSC" select="Elm[1]/SubElm[1]"/>
							<xsl:choose>
								<!--	<xsl:when test="$EOCSC='POT' ">inaktiv</xsl:when>
					<xsl:when test="$EOCSC='HS' ">indlagt</xsl:when>
					<xsl:when test="$EOCSC='HA' ">ambulant</xsl:when>
					<xsl:when test="$EOCSC='DA' ">doed</xsl:when>
					<xsl:when test="$EOCSC='REQ' ">ambulant_roentgen</xsl:when>-->
								<xsl:when test="$EOCSC='HS' ">indlagt</xsl:when>
								<xsl:when test="$EOCSC='DA' ">doed</xsl:when>
								<!--	<xsl:when test="$EOCSC='MW' ">flyttet_til_sygehusafd</xsl:when>
					<xsl:when test="$EOCSC='UP' ">uoplyst</xsl:when>
					<xsl:when test="$EOCSC='MH' ">flyttet_til_sygehus</xsl:when>
					<xsl:when test="$EOCSC='DE' ">doed_e</xsl:when>-->
								<xsl:otherwise>
									<FEJL>
										<xsl:attribute name="linie"><xsl:value-of select="$EOCSC/@linie"/></xsl:attribute>
										<xsl:attribute name="position"><xsl:value-of select="$EOCSC/@position"/></xsl:attribute>
							Kan ikke oversaette til EpisodeOfCareStatusCode: <xsl:value-of select="$EOCSC"/>
									</FEJL>
								</xsl:otherwise>
							</xsl:choose>
						</EpisodeOfCareStatusCode>
					</xsl:for-each>
				</Patient>
			</xsl:for-each>
			<xsl:for-each select="$DTMAdmission">
				<Admission>
					<xsl:call-template name="DTM203ToDateTime"/>
				</Admission>
			</xsl:for-each>
		</NotificationOfAdmission>
	</xsl:template>
</xsl:stylesheet>
