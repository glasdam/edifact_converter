<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDBIN' and SubElm[5]='B0130X']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SSP']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
		<xsl:variable name="S11Binary" select="BrevIndhold/S11"/>
		<xsl:variable name="IkkeBrugteSegmenter"
			select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S07'  or name()='S11')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='SSP' or NAD/Elm[1]/SubElm[1]='PO')]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<BinaryLetter>
			<xsl:for-each select="$S02LetterInfo">
				<Letter>
					<Identifier>
						<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
					</Identifier>
					<VersionCode>XB0130X</VersionCode>
					<StatisticalCode>XBIN01</StatisticalCode>
					<xsl:for-each select="$Dtm">
						<Authorisation>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Authorisation>
					</xsl:for-each>
					<TypeCode>XBIN01</TypeCode>
					<StatusCode>
						<xsl:variable name="C" select="GIS/Elm[1]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$C='N' ">nytbrev</xsl:when>
							<xsl:when test="$C='M' ">rettetbrev</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="Error">
									<xsl:with-param name="Node" select="$C"/>
									<xsl:with-param name="Text">Kan ikke oversaette fra GIS til
										StatusCode: <xsl:value-of select="$C"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</StatusCode>
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
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="CON">
						<TelephoneSubscriberIdentifier>
							<xsl:value-of select="Elm[2]/SubElm[1]"/>
						</TelephoneSubscriberIdentifier>
					</xsl:for-each>
					<xsl:for-each select="SPR">
						<xsl:call-template name="SPRToMedicalSpecialityCode"/>
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
						<xsl:call-template name="NADToUnitName"/>
					</xsl:for-each>
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
				</Receiver>
			</xsl:for-each>
			<xsl:for-each select="$S07Patient">
				<xsl:if test="PNA/Elm[5]/SubElm[2]='Data'">
					<SystemInformation>true</SystemInformation>
					<xsl:if test="not(PNA/Elm[6]/SubElm[2]='' or PNA/Elm[6]/SubElm[2]='_')">
						<Contents>
							<xsl:value-of select="PNA/Elm[6]/SubElm[2]"/>
						</Contents>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not(PNA/Elm[5]/SubElm[2]='Data')">
					<Patient>
						<xsl:if test="count(RFF)=0 and PNA/Elm[2]/SubElm[1]='' ">
							<FEJL>En patient skal enten have et lovligt cpr eller et alternativt
							ID</FEJL>
						</xsl:if>
						<xsl:for-each select="PNA">
							<xsl:if test="Elm[2]/SubElm[1]!='' ">
								<CivilRegistrationNumber>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</CivilRegistrationNumber>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="RFF">
							<AlternativeIdentifier>
								<xsl:value-of select="Elm[1]/SubElm[2]"/>
							</AlternativeIdentifier>
						</xsl:for-each>
						<xsl:for-each select="PNA">
							<PersonSurnameName>
								<xsl:value-of select="Elm[5]/SubElm[2]"/>
							</PersonSurnameName>
							<xsl:if test="Elm[6]/SubElm[2]!='' ">
								<PersonGivenName>
									<xsl:value-of select="Elm[6]/SubElm[2]"/>
								</PersonGivenName>
							</xsl:if>
						</xsl:for-each>
					</Patient>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="$S11Binary">
				<xsl:for-each select="UNO">
					<BinaryObject>
						<ObjectIdentifier>
							<xsl:value-of select="Elm[2]/SubElm[2]"/>
						</ObjectIdentifier>
						<xsl:call-template name="UNOToObjectCode"/>
						<xsl:call-template name="UNOToObjectExtensionCode"/>
						<!--
						<ObjectCode>
							<xsl:variable name="OC" select="Elm[3]/SubElm[2]"/>
							<xsl:choose>
								<xsl:when test="$OC='TXT'">tekstfil</xsl:when>
								<xsl:when test="$OC='IMG'">billede</xsl:when>
								<xsl:when test="$OC='PRG'">program</xsl:when>
								<xsl:when test="$OC='VGR'">vektor_grafik</xsl:when>
								<xsl:when test="$OC='BSG'">biosignaler</xsl:when>
								<xsl:when test="$OC='MUL'">multimedie</xsl:when>
								<xsl:when test="$OC='PRP'">proprietaert_indhold</xsl:when>
								<xsl:when test="$OC='SND'">multimedie</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ValueListError">
										<xsl:with-param name="ValueNode" select="$OC"/>
										<xsl:with-param name="Text">Ukendt OBJEKTTYPE</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</ObjectCode>
						<ObjectExtensionCode>
							<xsl:variable name="OEC" select="Elm[3]/SubElm[3]"/>
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
								<xsl:otherwise>
									<xsl:call-template name="ValueListError">
										<xsl:with-param name="ValueNode" select="$OEC"/>
										<xsl:with-param name="Text">Ukendt OBJEKTEXTENSIONTYPE</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</ObjectExtensionCode>-->
						<OriginalObjectSize>
							<xsl:value-of select="Elm[4]/SubElm[1]"/>
						</OriginalObjectSize>
						<xsl:variable name="OBJ" select="following::*[position()= 1]"/>
						<xsl:choose>
							<xsl:when test="local-name($OBJ) = 'OBJ'">
								<Object_Base64Encoded>
									<xsl:value-of select="$OBJ/Elm[1]/SubElm[1]"/>
								</Object_Base64Encoded>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="Error">
									<xsl:with-param name="Node" select="."/>
									<xsl:with-param name="Text">Mangler det binære objekt
									(OBJ)</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</BinaryObject>
				</xsl:for-each>
				<!--<xsl:for-each select="OBJ">
						<Object_Base64Encoded>
							<xsl:value-of select="Elm[1]/SubElm[1]"/>
						</Object_Base64Encoded>
					</xsl:for-each>-->
			</xsl:for-each>
		</BinaryLetter>
	</xsl:template>
</xsl:stylesheet>
