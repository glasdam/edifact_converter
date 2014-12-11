<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDPRE' and SubElm[5]='LMS016']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[PNA/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[PNA/Elm[1]/SubElm[1]='SE']"/>
		<xsl:variable name="S02" select="BrevIndhold/S02"/>
		<xsl:variable name="S03PatOrRel" select="BrevIndhold/S03"/>
		<xsl:variable name="S04Drug" select="BrevIndhold/S04"/>
		<xsl:variable name="S08Delivery" select="BrevIndhold/S08"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM'  or name()='S01'  or name()='S02'  or name()='S03'  or name()='S04' or name()='S08')]
												|	BrevIndhold/S01[not(PNA/Elm[1]/SubElm[1]='PO' or PNA/Elm[1]/SubElm[1]='SE')]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<!--PRESCRIPTION -->
		<Prescription>
			<Letter>
				<Identifier>
					<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
				</Identifier>
				<VersionCode>XLMS016</VersionCode>
				<StatisticalCode>XPRE01</StatisticalCode>
				<xsl:for-each select="$Dtm">
					<Authorisation>
						<xsl:call-template name="DTM204ToDateTimeWithSec"/>
					</Authorisation>
				</xsl:for-each>
				<TypeCode>XPRE01</TypeCode>
			</Letter>
			<xsl:for-each select="$S01Sender">
				<Sender>
					<EANIdentifier>
						<xsl:value-of select="$SenderEAN"/>
					</EANIdentifier>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNAToIdentifier"/>
						<xsl:call-template name="PNAToIdentifierCode"/>
					</xsl:for-each>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNA72ToOrganisationName"/>
					</xsl:for-each>
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="COM">
						<xsl:call-template name="COMToTelephoneSubscriberIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="SPR">
						<xsl:call-template name="SPR31ToMedicalSpecialityCode"/>
					</xsl:for-each>
					<Issuer>
						<xsl:for-each select="PNA">
							<xsl:call-template name="PNAToAuthorisationIdentifier"/>
							<xsl:call-template name="PNAToTitleAndName"/>
						</xsl:for-each>
						<xsl:for-each select="QUA">
							<SpecialityCode>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</SpecialityCode>
						</xsl:for-each>
						<xsl:for-each select="EMP">
							<xsl:call-template name="EMPToOccupation"/>
						</xsl:for-each>
					</Issuer>
				</Sender>
			</xsl:for-each>
			<xsl:for-each select="$S01Receiver">
				<Receiver>
					<xsl:for-each select="PNA">
						<xsl:call-template name="PNAToEANIdentifier"/>
						<xsl:call-template name="PNA62ToOrganisationName"/>
					</xsl:for-each>
				</Receiver>
			</xsl:for-each>
			<xsl:for-each select="$S03PatOrRel">
				<PatientOrRelative>
					<xsl:for-each select="PNA">
						<Type>
							<xsl:variable name="T" select="Elm[1]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$T='PAT'">patient</xsl:when>
								<xsl:when test="$T='PAS'">patienttilknyttet_person</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ValueListError">
										<xsl:with-param name="ValueNode" select="$T"/>
										<xsl:with-param name="Text">Ukendt PART</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</Type>
						<xsl:call-template name="PNAToCivilRegistrationNumber"/>
						<xsl:variable name="Name" select="Elm[6]/SubElm[2]"/>
						<xsl:variable name="Seperator" select="','"/>
						<PersonSurnameName>
							<xsl:value-of select="substring-before($Name,$Seperator)"/>
						</PersonSurnameName>
						<PersonGivenName>
							<xsl:value-of select="substring-after($Name,$Seperator)"/>
						</PersonGivenName>
					</xsl:for-each>
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
						<xsl:call-template name="ADRToCountryCode"/>
						<xsl:call-template name="ADRToCountyCode"/>
					</xsl:for-each>
					<xsl:for-each select="DTM">
						<PatientDateOfBirth>
							<xsl:call-template name="DTM102ToDateType"/>
						</PatientDateOfBirth>
					</xsl:for-each>
					<xsl:for-each select="PDI">
						<xsl:call-template name="PDIToPatientSex"/>
					</xsl:for-each>
					
				</PatientOrRelative>
			</xsl:for-each>
			<xsl:for-each select="$S02/INP">
						<xsl:variable name="Instr" select="Elm[2]/SubElm[2]"/>
						<xsl:choose>
							<xsl:when test="$Instr='AUP'"><ForGPUse>true</ForGPUse></xsl:when>
							<xsl:when test="$Instr='UIS'"><ForGPClinicUse>true</ForGPClinicUse></xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="ValueListError">
									<xsl:with-param name="ValueNode" select="$Instr"/>
									<xsl:with-param name="Text">Kan ikke oversætte INP til InstructionCode</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
			<PrescriptionInformation>
				<xsl:for-each select="$S02/RFF[Elm[1]/SubElm[1]='SYS'] ">
					<SenderComputerSystem>
						<xsl:value-of select="Elm[1]/SubElm[2]"/>
					</SenderComputerSystem>
				</xsl:for-each>
				<xsl:for-each select="$Bgm">
					<MessageStatusCode>
						<xsl:variable name="MSC" select="Elm[3]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$MSC='9'">original</xsl:when>
							<xsl:when test="$MSC='7'">kopi</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="ValueListError">
									<xsl:with-param name="ValueNode" select="$MSC"/>
									<xsl:with-param name="Text">Ukendt MEDDELELSESFUNKTION</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</MessageStatusCode>
				</xsl:for-each>
				<xsl:for-each select="$S02/RFF[Elm[1]/SubElm[1]='CH'] ">
					<DrugDatabaseVersion>
						<xsl:value-of select="Elm[1]/SubElm[2]"/>
					</DrugDatabaseVersion>
				</xsl:for-each>
				<xsl:for-each select="$S02[RFF[Elm[1]/SubElm[1]='DOS' or Elm[1]/SubElm[1]='COP']]">
					<DoseDispenseInformation>
						<Status>
							<xsl:variable name="DOS" select="RFF[Elm[1]/SubElm[1]='DOS']"/>
							<xsl:if test="count($DOS)>0">dosisdispensering</xsl:if>
							<xsl:if test="count($DOS)=0">seponeres</xsl:if>
						</Status>
						<CopyRequired>
							<xsl:value-of select="count(RFF[Elm[1]/SubElm[1]='COP'])>0"/>
						</CopyRequired>
					</DoseDispenseInformation>
				</xsl:for-each>
				<xsl:for-each select="$S02/FTX">
					<xsl:variable name="TextSubject" select="Elm[1]/SubElm[1]"/>
					<xsl:choose>
						<xsl:when test="$TextSubject='ORI' ">
							<OrderInstruction>
								<xsl:call-template name="FTXSegmentsToText"/>
							</OrderInstruction>
						</xsl:when>
						<xsl:when test="$TextSubject='DEL' ">
							<DeliveryInformation>
								<xsl:call-template name="FTXSegmentsToText"/>
							</DeliveryInformation>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="ValueListError">
								<xsl:with-param name="ValueNode" select="$TextSubject"/>
								<xsl:with-param name="Text">Ukendt TEKSTEMNE</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:for-each select="$S08Delivery">
					<Delivery>
						<xsl:for-each select="TOD">
							<PriorityOfDelivery>
								<xsl:variable name="POD" select="Elm[3]/SubElm[1]"/>
								<xsl:choose>
									<xsl:when test="$POD='OAD'">send_til_anden_adresse_samme_dag</xsl:when>
									<xsl:when test="$POD='OAM'">send_til_anden_adresse_pr_post</xsl:when>
									<xsl:when test="$POD='PAD'">send_til_patientadresse_samme_dag</xsl:when>
									<xsl:when test="$POD='PAM'">send_til_patientadresse_pr_post</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="ValueListError">
											<xsl:with-param name="ValueNode" select="$POD"/>
											<xsl:with-param name="Text">Ukendt LEVERING</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</PriorityOfDelivery>
						</xsl:for-each>
						<xsl:for-each select="ADR">
							<xsl:if test="Elm[2]/SubElm[1]='1' ">
								<StreetName>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</StreetName>
							</xsl:if>
							<xsl:if test="Elm[2]/SubElm[1]='US' ">
								<PseudoAddress>
									<xsl:value-of select="Elm[2]/SubElm[2]"/>
								</PseudoAddress>
							</xsl:if>
							<xsl:call-template name="ADRToPostCodeIdentifier"/>
						</xsl:for-each>
						<xsl:for-each select="PNA">
							<ContactName>
								<xsl:value-of select="Elm[6]/SubElm[2]"/>
							</ContactName>
						</xsl:for-each>
					</Delivery>
				</xsl:for-each>
			</PrescriptionInformation>
			<xsl:for-each select="$S04Drug">
				<Drug>
					<xsl:for-each select="LIN">
						<PackageIdentifier>
							<xsl:value-of select="Elm[3]/SubElm[1]"/>
						</PackageIdentifier>
					</xsl:for-each>
					<xsl:for-each select="IMD[Elm[2]/SubElm[1]='DNM']">
						<NameOfDrug>
							<xsl:value-of select="Elm[3]/SubElm[4]"/>
						</NameOfDrug>
					</xsl:for-each>
					<xsl:for-each select="IMD[Elm[2]/SubElm[1]='DDP']">
						<DosageForm>
							<xsl:value-of select="Elm[3]/SubElm[4]"/>
						</DosageForm>
					</xsl:for-each>
					<xsl:for-each select="MEA[Elm[1]/SubElm[1]='AAU']">
						<PackageSize>
							<xsl:value-of select="Elm[2]/SubElm[4]"/>
						</PackageSize>
					</xsl:for-each>
					<xsl:for-each select="MEA[Elm[1]/SubElm[1]='DEN']">
						<DrugStrength>
							<xsl:value-of select="Elm[2]/SubElm[4]"/>
						</DrugStrength>
					</xsl:for-each>
					<xsl:for-each select="PNA">
						<Importer>
							<xsl:if test="Elm[6]/SubElm[1]='AB'">
								<ShortName>
									<xsl:value-of select="Elm[6]/SubElm[2]"/>
								</ShortName>
							</xsl:if>
							<xsl:if test="Elm[6]/SubElm[1]='US'">
								<LongName>
									<xsl:value-of select="Elm[6]/SubElm[2]"/>
								</LongName>
							</xsl:if>
						</Importer>
					</xsl:for-each>
					<xsl:for-each select="QTY">
						<NumberOfPackings>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</NumberOfPackings>
					</xsl:for-each>
					<xsl:for-each select="ALC">
					<ReimbursementClause><xsl:variable name="RC" select="Elm[2]/SubElm[2]"/>
								<xsl:choose>
									<xsl:when test="$RC='CLA'">klausulbetingelse_opfyldt</xsl:when>
									<xsl:when test="$RC='CRD'">varig_lidelse</xsl:when>
<xsl:when test="$RC='PEN'">pensionist</xsl:when>
<xsl:when test="$RC='SPG'">bevilling_fra_laegemiddelstyrelsen</xsl:when>

									<xsl:otherwise>
									<xsl:call-template name="ValueListError">
										<xsl:with-param name="ValueNode" select="$RC"/>
										<xsl:with-param name="Text">Ukendt TILSKUDSKODE</xsl:with-param>
									</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
</ReimbursementClause>
					</xsl:for-each>
					<xsl:for-each select="PGI">
						<SubstitutionCode>
							<xsl:variable name="Subst" select="Elm[2]/SubElm[1]"/>
							<xsl:choose>
								<!--<xsl:when test="$Subst='NA'">ikke_analog_substitution</xsl:when> Bruges ikke endnu-->
								<xsl:when test="$Subst='NG'">ikke_generisk_substitution</xsl:when>
								<xsl:when test="$Subst='NO'">ikke_original_substitution</xsl:when>
								<xsl:when test="$Subst='NS'">ikke_substitution</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ValueListError">
										<xsl:with-param name="ValueNode" select="$Subst"/>
										<xsl:with-param name="Text">Kan ikke oversætte PGI til SubstitutionCode</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</SubstitutionCode>
					</xsl:for-each>
					<xsl:for-each select="S07">
						<Dosage>
							<xsl:for-each select="DSG">
							   	<xsl:if test="Elm[2]/SubElm[1]!=''">
								<DosageCode>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</DosageCode>
								</xsl:if>
								<DosageText>
									<xsl:value-of select="Elm[2]/SubElm[4]"/>
								</DosageText>
							</xsl:for-each>
							<xsl:for-each select="DTM[Elm[1]/SubElm[1]='48']">
								<Period>
									<xsl:value-of select="Elm[1]/SubElm[2]"/>
								</Period>
								<PeriodUnit>
									<xsl:variable name="PU" select="Elm[1]/SubElm[3]"/>
									<xsl:choose>
										<!--<xsl:when test="$PU='802'">maaned</xsl:when>-->
										<xsl:when test="$PU='803'">uge</xsl:when>
										<xsl:when test="$PU='804'">dag</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="ValueListError">
												<xsl:with-param name="ValueNode" select="$PU"/>
												<xsl:with-param name="Text">Ukendt ENHEDSFORMAT</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</PeriodUnit>
							</xsl:for-each>
						</Dosage>
					</xsl:for-each>
					<xsl:for-each select="CIN">
						<Indication>
							<xsl:call-template name="CINToCode"/>
							<xsl:call-template name="CINToText"/>
						</Indication>
					</xsl:for-each>
					<xsl:for-each select="S06">
						<Iteration>
							<xsl:for-each select="EQN">
								<Number>
									<xsl:value-of select="Elm[1]/SubElm[1]"/>
								</Number>
							</xsl:for-each>
							<xsl:for-each select="DTM">
								<Interval>
									<xsl:value-of select="Elm[1]/SubElm[2]"/>
								</Interval>
								<IntervalUnit>
									<xsl:variable name="IU" select="Elm[1]/SubElm[3]"/>
									<xsl:choose>
										<xsl:when test="$IU='802'">maaned</xsl:when>
										<xsl:when test="$IU='803'">uge</xsl:when>
										<xsl:when test="$IU='804'">dag</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="ValueListError">
												<xsl:with-param name="ValueNode" select="$IU"/>
												<xsl:with-param name="Text">Ukendt ENHEDSFORMAT</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</IntervalUnit>
							</xsl:for-each>
						</Iteration>
					</xsl:for-each>
					<xsl:for-each select="S07/FTX">
						<SupplementaryInformation>
							<xsl:call-template name="FTXSegmentsToText"/>
						</SupplementaryInformation>
					</xsl:for-each>
					<xsl:for-each select="S07[DTM/Elm[1]/SubElm[1]='91' or Elm[1]/SubElm[1]='90']">
						<DoseDispensing>
							<xsl:for-each select="DTM[Elm[1]/SubElm[1]='90']">
								<StartDate>
									<xsl:call-template name="DTM102ToDateType"/>
								</StartDate>
							</xsl:for-each>
							<xsl:for-each select="DTM[Elm[1]/SubElm[1]='91']">
								<EndDate>
									<xsl:call-template name="DTM102ToDateType"/>
								</EndDate>
							</xsl:for-each>
						</DoseDispensing>
					</xsl:for-each>
				</Drug>
			</xsl:for-each>
		</Prescription>
	</xsl:template>
</xsl:stylesheet>
