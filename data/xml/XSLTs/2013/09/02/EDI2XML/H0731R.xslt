<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/medcom.dk/xml/schemas/2013/09/02/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDREF' and SubElm[5]='H0731R']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SSP']"/>
		<xsl:variable name="S01AnswerCCReceiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PRH']"/>
		<!-- ubrugt -->
		<xsl:variable name="S01Referrer" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV']"/>
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<!--xsl:variable name="ClinicalReason" select="$S02LetterInfo/FTX"/-->
		<xsl:variable name="RefDiag" select="$S02LetterInfo/CIN[Elm[1]/SubElm[1]='H']"/>
		<xsl:variable name="RefAddDiags" select="$S02LetterInfo/CIN[Elm[1]/SubElm[1]!='H']"/>
		<xsl:variable name="ClinicalReason" select="$S02LetterInfo/FTX[Elm[1]/SubElm[1]='DI']"/>
		<xsl:variable name="S06Dummy" select="BrevIndhold/S06"/>
		<xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
		<xsl:variable name="S10Relatives" select="BrevIndhold/S10"/>
		<!-- ubrugt -->
		<xsl:variable name="S12Anamnesis" select="BrevIndhold/S12"/>
		<xsl:variable name="Anamnesis" select="$S12Anamnesis/FTX[Elm[1]/SubElm[1]='NC']"/>
		<xsl:variable name="Examination" select="$S12Anamnesis/FTX[Elm[1]/SubElm[1]='CF']"/>
		<xsl:variable name="Pregnant" select="$S12Anamnesis/FTX[Elm[1]/SubElm[1]='PR']"/>
		<xsl:variable name="ActualMedicine" select="$S12Anamnesis/FTX[Elm[1]/SubElm[1]='MT']"/>
		<xsl:variable name="Cave" select="$S12Anamnesis/FTX[Elm[1]/SubElm[1]='AL']"/>
		<xsl:variable name="S12RefFTXs" select="BrevIndhold/S12/FTX[Elm[1]/SubElm[1]='BIN' or Elm[1]/SubElm[1]='SUP' or Elm[1]/SubElm[1]='URL']"/>
		<xsl:variable name="S18" select="BrevIndhold/S18"/>
		<xsl:variable name="Priority" select="$S18/PTY"/>
		<!-- ubrugt -->
		<xsl:variable name="HospitalVisitations" select="$S18/FTX"/>
		<!-- ubrugt -->
		<xsl:variable name="RefStatus" select="$S18/PAS"/>
		<xsl:variable name="S19" select="BrevIndhold/S19"/>
		<xsl:variable name="Transport" select="$S19/TDT"/>
		<!-- ubrugt -->
		<xsl:variable name="Supplementary" select="$S19/FTX"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
		
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S06'  or name()='S07' or name()='S10'  or name()='S12'  or name()='S18' or name()='S19')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='PO' or NAD/Elm[1]/SubElm[1]='SSP' or NAD/Elm[1]/SubElm[1]='PRH' or NAD/Elm[1]/SubElm[1]='BV')]"/>

		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>

		<PhysiotherapyReferral>
			<xsl:for-each select="$S02LetterInfo">
				<Letter>
					<Identifier>
						<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
					</Identifier>
					<VersionCode>XH0731R</VersionCode>
					<StatisticalCode>REF07</StatisticalCode>
					<xsl:for-each select="$Dtm">
						<Authorisation>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Authorisation>
					</xsl:for-each>
					<TypeCode>XREF07</TypeCode>
					<StatusCode>
						<xsl:variable name="C" select="GIS/Elm[1]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$C='N' ">nytbrev</xsl:when>
							<!--	<xsl:when test="$C='M' ">rettetbrev</xsl:when>-->
							<xsl:otherwise>
								<xsl:call-template name="Error">
									<xsl:with-param name="Node" select="$C"/>
									<xsl:with-param name="Text">Kan ikke oversaette fra GIS til StatusCode: <xsl:value-of select="$C"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</StatusCode>
					<xsl:for-each select="RFF[Elm[1]/SubElm[1]='ROI'] ">
						<xsl:if test="Elm[1]/SubElm[2]!='' and Elm[1]/SubElm[2]!='_'">
							<EpisodeOfCareIdentifier>
								<xsl:value-of select="Elm[1]/SubElm[2]"/>
							</EpisodeOfCareIdentifier>
						</xsl:if>
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
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="CON">
						<xsl:call-template name="CONToTelephoneSubscriberIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="SPR">
						<xsl:call-template name="SPRToMedicalSpecialityCode"/>
					</xsl:for-each>
					<xsl:for-each select="$S01Referrer">
						<Referrer>
							<xsl:for-each select="NAD">
								<xsl:call-template name="NADToIdentifier"/>
								<xsl:call-template name="NADToIdentifierCode"/>
								<xsl:call-template name="NADToPersonName"/>
								<xsl:call-template name="NADToPersonTitle"/>
							</xsl:for-each>
						</Referrer>
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
			<xsl:for-each select="$S01AnswerCCReceiver">
				<AnswerCCReceiver>
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
						<xsl:call-template name="CONToTelephoneSubscriberIdentifier"/>
					</xsl:for-each>
				</AnswerCCReceiver>
			</xsl:for-each>
			<xsl:for-each select="$S07Patient">
				<Patient>
					<xsl:if test="count(RFF)=0 and PNA/Elm[2]/SubElm[1]='' ">
						<FEJL>En patient skal enten have et lovligt cpr eller et alternativt ID</FEJL>
					</xsl:if>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNAToCivilRegistrationNumber"/>
					</xsl:for-each>
					<xsl:for-each select="RFF">
						<xsl:call-template name="RFFToAlternativeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNAToPersonSurnameName"/>
						<xsl:call-template name="PNAToPersonGivenName"/>
					</xsl:for-each>
					<xsl:for-each select="EMP">
						<PersonTitle>
							<xsl:value-of select="Elm[3]/SubElm[4]"/>
						</PersonTitle>
					</xsl:for-each>
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="CON">
						<xsl:call-template name="CONToTelephoneSubscriberIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="$S12Anamnesis/FTX[Elm[1]/SubElm[1] = 'IN']">
						<EmailIdentifier>
							<xsl:value-of select="Elm[4]/SubElm[1]"/>
						</EmailIdentifier>
					</xsl:for-each>
				</Patient>
			</xsl:for-each>
			<xsl:for-each select="$S10Relatives">
				<Relative>
					<xsl:for-each select="REL">
						<xsl:call-template name="RELToRelationCode"/>
					</xsl:for-each>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNAToPersonIdentifier"/>
						<xsl:call-template name="PNAToPersonSurnameName"/>
						<xsl:call-template name="PNAToPersonGivenName"/>
					</xsl:for-each>
				</Relative>
			</xsl:for-each>
			<xsl:if test="(count($Priority)+count($RefStatus)+count($Supplementary)+count($Transport)+count($ClinicalReason)) > 0">
				<AdditionalInformation>
					<xsl:for-each select="$Priority">
						<Priority>
							<xsl:variable name="P" select="Elm[2]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$P='WA' ">elektiv</xsl:when>
								<xsl:when test="$P='AC' ">akut</xsl:when>
								<xsl:when test="$P='SA' ">saerlige_forhold</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$P"/>
										<xsl:with-param name="Text">Kan ikke oversaette Prioritet: <xsl:value-of select="$P"/></xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</Priority>
					</xsl:for-each>
					<xsl:for-each select="$RefStatus">
						<ReferralStatus>
							<xsl:variable name="RS" select="Elm[1]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$RS='HA' ">ambulant</xsl:when>
								<xsl:when test="$RS='HS' ">indlaeggelse</xsl:when>
								<xsl:when test="$RS='HO' ">hjemmet</xsl:when>

								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$RS"/>
										<xsl:with-param name="Text">Kan ikke oversaette PAS til ReferralStatus: <xsl:value-of select="$RS"/></xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</ReferralStatus>
					</xsl:for-each>
					<xsl:for-each select="$Transport">
						<Transport>
							<xsl:variable name="T" select="Elm[3]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$T='TX' ">ingen</xsl:when>
								<xsl:when test="$T='ST' ">liggende</xsl:when>
								<xsl:when test="$T='SI' ">siddende</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$T"/>
										<xsl:with-param name="Text">Kan ikke oversaette TDT til Transport: <xsl:value-of select="$T"/></xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</Transport>
					</xsl:for-each>
					<xsl:for-each select="$Supplementary">
						<Supplementary>
							<xsl:call-template name="FTXSegmentsToFormattedText"/>
						</Supplementary>
					</xsl:for-each>
					<xsl:for-each select="$ClinicalReason">
						<ClinicalReason>
							<xsl:call-template name="FTXSegmentsToFormattedText"/>
						</ClinicalReason>
					</xsl:for-each>
				</AdditionalInformation>
			</xsl:if>
			<xsl:if test="count($RefDiag)+count($RefAddDiags)>0">
				<Referral>
					<xsl:for-each select="$RefDiag">
						<Refer>
							<xsl:if test="Elm[2]/SubElm[1]!=''">
								<DiagnoseCode>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</DiagnoseCode>
							</xsl:if>
							<DiagnoseTypeCode>
								<xsl:variable name="DTC" select="Elm[2]/SubElm[2]"/>
								<xsl:choose>
									<xsl:when test="$DTC='SKS' ">SKSdiagnosekode</xsl:when>
									<xsl:when test="$DTC='USP' ">uspecificeretkode</xsl:when>
									<xsl:when test="$DTC='ICP' ">ICPCkode</xsl:when>
									<xsl:when test="$DTC='HET' ">fysioterapihenvisning</xsl:when>
									<!-- kan også oversættes til psykologhenvisning/speciallægehenvisning-->
									<xsl:when test="$DTC='SFU' ">Fysioterapihenvisningsdiagnose</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="$DTC"/>
											<xsl:with-param name="Text">Kan ikke oversaette til DiagnoseTypeCode: <xsl:value-of select="$DTC"/></xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</DiagnoseTypeCode>
							<DiagnoseText>
								<xsl:value-of select="Elm[2]/SubElm[4]"/>
							</DiagnoseText>
						</Refer>
					</xsl:for-each>
					<xsl:for-each select="$RefAddDiags">
						<ReferralAdditional>
							<DiagnoseDescriptionCode>
								<xsl:variable name="Desc" select="Elm[1]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$Desc='DI'">uspec_diagnose</xsl:when>
									<xsl:when test="$Desc='H'">henv_diagnose</xsl:when>
									<xsl:when test="$Desc='B'">bidiagnose</xsl:when>
									<xsl:when test="$Desc='DM'">tillaegsdiagnose</xsl:when>
									<xsl:when test="$Desc='A'">aktionsdiagnose</xsl:when>
									<xsl:when test="$Desc='G'">grundmorbus</xsl:when>
									<xsl:when test="$Desc='M'">midlertidig_diagnose</xsl:when>
									<xsl:when test="$Desc='S'">forloebsdiagnose</xsl:when>
									<xsl:when test="$Desc='TR'">operation</xsl:when>
									<xsl:when test="$Desc='IN'">roentgenundersoegelse</xsl:when>
									<xsl:when test="$Desc='XI' ">fysioterapihenvisningspgruppe</xsl:when>
									<xsl:when test="$Desc='HI' ">fysioterapihenvisning</xsl:when>
									<!-- kan også oversættes til psykologhenvisning/speciallægehenvisning -->
									<xsl:otherwise>
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="$Desc"/>
											<xsl:with-param name="Text">Kan ikke oversaette til DiagnoseDescriptionCode: <xsl:value-of select="$Desc"/></xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</DiagnoseDescriptionCode>
							<xsl:if test="Elm[2]/SubElm[1]!=''">
								<DiagnoseCode>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</DiagnoseCode>
							</xsl:if>
							<DiagnoseTypeCode>
								<xsl:variable name="DTC" select="Elm[2]/SubElm[2]"/>
								<xsl:choose>
									<xsl:when test="$DTC='SKS' ">SKSdiagnosekode</xsl:when>
									<xsl:when test="$DTC='USP' ">uspecificeretkode</xsl:when>
									<xsl:when test="$DTC='ICP' ">ICPCkode</xsl:when>
									<xsl:when test="$DTC='HET' ">fysioterapihenvisning</xsl:when>
									<!-- kan også oversættes til speciallægehenvisning/psykologhenvisning -->
									<xsl:when test="$DTC='SFU' ">Fysioterapihenvisningsdiagnose</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="Error">
											<xsl:with-param name="Node" select="$DTC"/>
											<xsl:with-param name="Text">Kan ikke oversaette til DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</DiagnoseTypeCode>
							<DiagnoseText>
								<xsl:variable name="DTC" select="Elm[2]/SubElm[2]"/>
								<xsl:choose>
									<!-- Hvis der er tale om en fysioterapihenvisningsdiagnose, skal diagnosekoden oversættes til en passende diagnosetekst.
								 Hvis der ikke er tale om en fysioterapihenvisningsdiagnose, anvendes teksten fra edi'en direkte som diagnosetekst. -->
									<xsl:when test="$DTC='SFU' ">
										<xsl:call-template name="DiacodeToPhysiotherapyDiagnosisTextTemplate"><!-- TODO kun hvis det er en SFU kode! -->
											<!--xsl:with-param name="DC" select="Elm[2]/SubElm[1]"/>
									<xsl:with-param name="DT" select="Elm[2]/SubElm[4]"/-->
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="Elm[2]/SubElm[4]"/>
									</xsl:otherwise>
								</xsl:choose>
							</DiagnoseText>
						</ReferralAdditional>
					</xsl:for-each>
				</Referral>
			</xsl:if>
			<xsl:if test="count($Anamnesis)+count($Cave)+count($ActualMedicine)+count($Examination)+count($Pregnant)>0">
				<RelevantClinicalInformation>
					<xsl:if test="count($Cave)>0">
						<Cave>
							<xsl:call-template name="FTXSegmentsToFormattedText">
								<xsl:with-param name="FTXSegments" select="$Cave"/>
							</xsl:call-template>
						</Cave>
					</xsl:if>
					<xsl:if test="count($Anamnesis)>0">
						<Anamnesis>
							<xsl:call-template name="FTXSegmentsToFormattedText">
								<xsl:with-param name="FTXSegments" select="$Anamnesis"/>
							</xsl:call-template>
						</Anamnesis>
					</xsl:if>
					<xsl:if test="count($Examination)>0">
						<Examination>
							<xsl:call-template name="FTXSegmentsToFormattedText">
								<xsl:with-param name="FTXSegments" select="$Examination"/>
							</xsl:call-template>
						</Examination>
					</xsl:if>
					<xsl:if test="count($ActualMedicine)>0">
						<ActualMedicine>
							<xsl:call-template name="FTXSegmentsToFormattedText">
								<xsl:with-param name="FTXSegments" select="$ActualMedicine"/>
							</xsl:call-template>
						</ActualMedicine>
					</xsl:if>
					<xsl:if test="count($Pregnant)>0">
						<xsl:for-each select="$Pregnant">
							<xsl:call-template name="Error">
								<xsl:with-param name="Text">Sygehushenvisninger kan ikke indeholde graviditetsoplysninger</xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
						<!--<FirstDateOfPeriod>
						<xsl:call-template name="FTXSegmentsToFormattedText">
							<xsl:with-param name="FTXSegments" select="$Pregnant"/>
						</xsl:call-template>
					</FirstDateOfPeriod>>-->
					</xsl:if>
				</RelevantClinicalInformation>
			</xsl:if>
			<xsl:for-each select="$S12RefFTXs">
				<xsl:call-template name="FTXSegmentToReference"/>
			</xsl:for-each>
			<xsl:for-each select="$HospitalVisitations">
				<HospitalVisitation>
					<InformationCode>
						<xsl:variable name="IC" select="Elm[1]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$IC='US' ">ustruktureret</xsl:when>
							<xsl:when test="$IC='EL' ">egen_laege</xsl:when>
							<xsl:when test="$IC='HV' ">henvisning_modtaget</xsl:when>
							<xsl:when test="$IC='VI' ">visitering</xsl:when>
							<xsl:when test="$IC='IK' ">indkaldt</xsl:when>
							<xsl:when test="$IC='AF' ">indlagt_paa</xsl:when>
							<xsl:when test="$IC='UA' ">udenamts_kaution</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="Error">
									<xsl:with-param name="Node" select="$IC"/>
									<xsl:with-param name="Text">Kan ikke oversaette TEXTNR til InformationCode: <xsl:value-of select="$IC"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</InformationCode>
					<Information>
						<xsl:call-template name="FTXSegmentsToFormattedText"/>
					</Information>
				</HospitalVisitation>
			</xsl:for-each>
		</PhysiotherapyReferral>
	</xsl:template>

	<xsl:template name="DiacodeToPhysiotherapyDiagnosisTextTemplate">
		<xsl:param name="DC" select="Elm[2]/SubElm[1]"/>
		<xsl:param name="DT" select="Elm[2]/SubElm[4]"/>
		<xsl:choose>
			<xsl:when test="not($DT)">
				<xsl:choose>
					<xsl:when test=" $DC='1A' ">Spastisk lammelse (cerebral parese)</xsl:when>
					<xsl:when test=" $DC='1B' ">Rygmarvsbrok (spina bifida)</xsl:when>
					<xsl:when test=" $DC='1C' ">Infantil hydrocelphalus</xsl:when>
					<xsl:when test=" $DC='1D' ">Tuberøs skelrose</xsl:when>
					<xsl:when test=" $DC='1E' ">Neurofibromatosis Recklinghausen</xsl:when>
					<xsl:when test=" $DC='1F' ">Hereditære ataksier og paraplegier, herunder Friedrichs ataksi</xsl:when>
					<xsl:when test=" $DC='1G' ">Chorea Huntington</xsl:when>
					<xsl:when test=" $DC='1H' ">Hereditære neuropatier</xsl:when>
					<xsl:when test=" $DC='1I' ">Muskeldystrofi og andre medfødte eller arvelige muskelsygdomme</xsl:when>
					<xsl:when test=" $DC='1J' ">Primær dystoni</xsl:when>
					<xsl:when test=" $DC='1K' ">Andre medfødte eller arvelige sygdomme med motoriske handicaps</xsl:when>
					<xsl:when test=" $DC='1L' ">Kongenit hofteluksation</xsl:when>
					<xsl:when test=" $DC='1M' ">Idiopatisk skoliose med Cobbs vinkel større end 20 grader</xsl:when>
					<xsl:when test=" $DC='1N' ">Arthrogryposis multiplex congenita</xsl:when>
					<xsl:when test=" $DC='1O' ">Arvelige bindevævssygdomme</xsl:when>
					<xsl:when test=" $DC='1P' ">Blødersygdom</xsl:when>
					<xsl:when test=" $DC='1Q' ">Cystisk fibrose</xsl:when>
					<xsl:when test=" $DC='1R' ">Hæmakromatose</xsl:when>
					<xsl:when test=" $DC='11' ">Funktionsevnenedsættelse som følge af progressiv sygdom</xsl:when>
					<xsl:when test=" $DC='2A' ">Følger efter hjerte-, rygmarvs- og hjernehindebetændelse</xsl:when>
					<xsl:when test=" $DC='2B' ">Neurologiske kompl. til AIDS</xsl:when>
					<xsl:when test=" $DC='2C' ">Følger efter poliomyelitis</xsl:when>
					<xsl:when test=" $DC='2D' ">Følger efter hjerneblødning</xsl:when>
					<xsl:when test=" $DC='2E' ">Følger efter andre kredsløbssygdomme i hjerne og rygmarv</xsl:when>
					<xsl:when test=" $DC='2F' ">Følger efter iskæmisk eller anoksisk hjerneskade</xsl:when>
					<xsl:when test=" $DC='2G' ">Parkinsons sygdom og andre sygdomme i hjernens basale ganglier</xsl:when>
					<xsl:when test=" $DC='2H' ">Primære og sekundære dystonier, herunder torticollis spasmodica</xsl:when>
					<xsl:when test=" $DC='2I' ">Dissemineret sklerose og andre demyeliniserende sygdomme</xsl:when>
					<xsl:when test=" $DC='2J' ">ALS, amyotrof lateral sklerose</xsl:when>
					<xsl:when test=" $DC='2K' ">Myastenia gravis</xsl:when>
					<xsl:when test=" $DC='2L' ">Mono- og polyneuropatier og pleksopatier</xsl:when>
					<xsl:when test=" $DC='2M' ">Hemi-, tetra- og paraplegier</xsl:when>
					<xsl:when test=" $DC='2N' ">Hydrocephalus</xsl:when>
					<xsl:when test=" $DC='2O' ">Syringomyeli</xsl:when>
					<xsl:when test=" $DC='2P' ">Følger efter hjerne- og rygmarvssvulster</xsl:when>
					<xsl:when test=" $DC='3A' ">Hemi/para- eller tetraplegi efter læsion af hjerne eller rygmarv</xsl:when>
					<xsl:when test=" $DC='3B' ">Større amputationer (bortset fra ablatio mammae)</xsl:when>
					<xsl:when test=" $DC='3C' ">Andre varige og omfattende lammelser</xsl:when>
					<xsl:when test=" $DC='4A' ">Kronisk leddegigt (reumatoid artrit)</xsl:when>
					<xsl:when test=" $DC='4B' ">Psoriasisgigt</xsl:when>
					<xsl:when test=" $DC='4C' ">Morbus Bechterew</xsl:when>
					<xsl:when test=" $DC='4D' ">Kronisk polyarthritis</xsl:when>
					<xsl:when test=" $DC='5A' ">Anden diagnose</xsl:when>
					<xsl:when test=" $DC='2O' ">Syringomyeli</xsl:when>
				    <xsl:when test=" $DC='511' ">Alm fysioterapi</xsl:when>
				    <xsl:when test=" $DC='621' ">Vederlagsfri fysioterapi</xsl:when>
				    <xsl:when test=" $DC='624' ">Vederlagsfri fysioterapi, fortsat behandling</xsl:when>
				    <xsl:when test=" $DC='571' ">Ridefysioterapi</xsl:when>
				    <xsl:when test=" $DC='651' ">Vederlagsfri ridefysioterapi</xsl:when>
				    <xsl:when test=" $DC='654' ">Vederlagsfri ridefysioterapi, fortsat behandling</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="ValueListError">
							<xsl:with-param name="ValueNode" select="$DC"/>
							<xsl:with-param name="Text">Kan ikke oversætte CIN til PhysiotherapyDiagnosisCodeText</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$DT"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
