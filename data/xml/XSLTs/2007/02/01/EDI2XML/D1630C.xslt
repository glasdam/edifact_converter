<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='MEDDIS' and SubElm[5]='D1630C']]">		
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="Bgm" select="BrevIndhold/BGM"/>
		<xsl:variable name="Dtm" select="BrevIndhold/DTM"/>
		<xsl:variable name="S01Sender" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='SSP']"/>
		<xsl:variable name="S01SignedBy" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='OMI']"/>
		<xsl:variable name="S01ContactInformation" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='BV']"/>
		<xsl:variable name="S01Receiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='PO']"/>
		<xsl:variable name="S01CCReceiver" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='CCR']"/>
		<xsl:variable name="S01Practitioner" select="BrevIndhold/S01[NAD/Elm[1]/SubElm[1]='UGP']"/>
		<xsl:variable name="S02LetterInfo" select="BrevIndhold/S02"/>
		<xsl:variable name="S07Patient" select="BrevIndhold/S07"/>
		<xsl:variable name="S09Relatives" select="BrevIndhold/S09"/>
		<xsl:variable name="S11" select="BrevIndhold/S11"/>
		<xsl:variable name="S14Auxiliaries" select="BrevIndhold/S14[CIN/Elm[1]/SubElm[1]='NC' or FTX/Elm[1]/SubElm[1]='HK']"/>					   
		<xsl:variable name="S14ServicesComment" select="BrevIndhold/S14/FTX[Elm[1]/SubElm[1]='YK']"/>																					
		<xsl:variable name="S14Services" select="BrevIndhold/S14[FTX/Elm[1]/SubElm[1]&gt;='001' and FTX/Elm[1]/SubElm[1]&lt;='028']"/>
		<xsl:variable name="S14Medicine" select="BrevIndhold/S14[FTX/Elm[1]/SubElm[1]='MED' or FTX/Elm[1]/SubElm[1]='MEK']"/>		
		<xsl:variable name="S14MotionEvaluation" select="BrevIndhold/S14[FTX/Elm[1]/SubElm[1]='FV']"/>
		<xsl:variable name="S14PatientHealthSummary" select="BrevIndhold/S14[FTX/Elm[1]/SubElm[1]='RS']"/>
		<xsl:variable name="S14CauseOfAdmission" select="BrevIndhold/S14[FTX/Elm[1]/SubElm[1]='PR']"/>
		<xsl:variable name="S14InformedRelative" select="BrevIndhold/S14[FTX/Elm[1]/SubElm[1]='AP']"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='DTM' or name()='BGM' or name()='S01' or name()='S02' or name()='S07' or name()='S09' or name()='S11' or name()='S14')]
												|	BrevIndhold/S01[not(NAD/Elm[1]/SubElm[1]='SSP' or NAD/Elm[1]/SubElm[1]='PO' or NAD/Elm[1]/SubElm[1]='CCR' or NAD/Elm[1]/SubElm[1]='UGP' or NAD/Elm[1]/SubElm[1]='OMI' or NAD/Elm[1]/SubElm[1]='BV')]
												|	BrevIndhold/S02[not(GIS or RFF or DTM)]
												|	BrevIndhold/S07[not(PNA or ADR)]
												|	BrevIndhold/S09[not(REL or PNA or ADR or CON)]
												|	BrevIndhold/S11[not(GIS or RFF or PAS)]
												|	BrevIndhold/S14[not(CIN or FTX)]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<ReportOfAdmission>
			<xsl:for-each select="$S02LetterInfo">				
				<Letter>
					<Identifier>
						<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
					</Identifier>
					<VersionCode>XD1630C</VersionCode>
					<StatisticalCode>XDIS16</StatisticalCode>
					<xsl:for-each select="$Dtm">
						<Authorisation>
							<xsl:call-template name="DTM203ToDateTime"/>
						</Authorisation>
					</xsl:for-each>
					<TypeCode>XDIS16</TypeCode>
					<StatusCode>
						<xsl:variable name="C" select="GIS/Elm[1]/SubElm[1]"/>
						<xsl:choose>
							<xsl:when test="$C='N' ">nytbrev</xsl:when>
							<xsl:when test="$C='M' ">rettetbrev</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="Error">
									<xsl:with-param name="Node" select="$C"/>
									<xsl:with-param name="Text">Kan ikke oversaette fra GIS til StatusCode: <xsl:value-of select="$C"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</StatusCode>
					<xsl:for-each select="$S11/RFF[Elm[1]/SubElm[1]='REI'] ">
						<EpisodeOfCareIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</EpisodeOfCareIdentifier>
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
						<TelephoneSubscriberIdentifier>
							<xsl:value-of select="Elm[2]/SubElm[1]"/>
						</TelephoneSubscriberIdentifier>
					</xsl:for-each>
					<xsl:for-each select="$S01SignedBy">
						<SignedBy>
							<xsl:for-each select="NAD">
								<PersonGivenName>
									<xsl:value-of select="Elm[4]/SubElm[1]"/>
								</PersonGivenName>
								<PersonSurnameName>
									<xsl:value-of select="Elm[4]/SubElm[2]"/>
								</PersonSurnameName>
								<PersonTitle>
									<xsl:value-of select="Elm[4]/SubElm[3]"/>
								</PersonTitle>
							</xsl:for-each>
						</SignedBy>
					</xsl:for-each>
					<xsl:for-each select="SPR">
						<xsl:call-template name="SPRToMedicalSpecialityCode"/>
					</xsl:for-each>
					<xsl:for-each select="$S01ContactInformation">
						<ContactInformation>
							<xsl:for-each select="NAD">
								<ContactNamePrimary>
									<xsl:value-of select="Elm[4]/SubElm[1]"/>
								</ContactNamePrimary>								
								<ContactNameSecondary>
									<xsl:value-of select="Elm[4]/SubElm[2]"/>
								</ContactNameSecondary>
							</xsl:for-each>
							<xsl:for-each select="CON">
								<xsl:if test="Elm[2]/SubElm[2]='TE'">
									<TelephoneSubscriberIdentifier>
										<xsl:value-of select="Elm[2]/SubElm[1]"/>
									</TelephoneSubscriberIdentifier>
								</xsl:if>
								<xsl:if test="Elm[2]/SubElm[2]='FX'">
									<TelefaxSubscriberIdentifier>
										<xsl:value-of select="Elm[2]/SubElm[1]"/>
									</TelefaxSubscriberIdentifier>
								</xsl:if>
								<xsl:if test="Elm[2]/SubElm[2]='EM'">
									<EmailAddressIdentifier>
										<xsl:value-of select="Elm[2]/SubElm[1]"/>
									</EmailAddressIdentifier>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="RFF">								
								<xsl:if test="Elm[1]/SubElm[1]='BUH'">
									<ContactTimeText>
										<xsl:value-of select="Elm[1]/SubElm[2]"/>
									</ContactTimeText>
								</xsl:if>
							</xsl:for-each>
						</ContactInformation>
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
			<xsl:for-each select="$S01CCReceiver">
				<CCReceiver>
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
				</CCReceiver>
			</xsl:for-each>
			<xsl:for-each select="$S01Practitioner">
				<Practitioner>
					<xsl:for-each select="NAD">
						<xsl:call-template name="NADToIdentifier"/>
						<xsl:call-template name="NADToIdentifierCode"/>
						<xsl:if test="Elm[4]/SubElm[1]!='' ">
							<PersonName>
								<xsl:value-of select="Elm[4]/SubElm[1]"/>
							</PersonName>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="CON">
						<xsl:if test="Elm[2]/SubElm[1]!='' ">
							<TelephoneSubscriberIdentifier>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</TelephoneSubscriberIdentifier>
						</xsl:if>
					</xsl:for-each>					
				</Practitioner>
			</xsl:for-each>
			<xsl:for-each select="$S07Patient">
				<Patient>
					<xsl:if test="count(RFF)=0 and PNA/Elm[2]/SubElm[1]='' ">
						<FEJL>En patient skal enten have et lovligt cpr eller et alternativt ID</FEJL>
					</xsl:if>
					<xsl:for-each select="PNA">
						<xsl:if test="Elm[2]/SubElm[1]!='' ">
							<CivilRegistrationNumber>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</CivilRegistrationNumber>
						</xsl:if>
						<xsl:if test="Elm[5]/SubElm[2]!=''">
							<PersonSurnameName>
								<xsl:value-of select="Elm[5]/SubElm[2]"/>
							</PersonSurnameName>
						</xsl:if>						
						<xsl:if test="Elm[6]/SubElm[2]!=''">
							<PersonGivenName>
								<xsl:value-of select="Elm[6]/SubElm[2]"/>
							</PersonGivenName>
						</xsl:if>
                    </xsl:for-each>
					<xsl:for-each select="RFF">
						<AlternativeIdentifier>
							<xsl:value-of select="Elm[1]/SubElm[2]"/>
						</AlternativeIdentifier>
					</xsl:for-each>
					<xsl:for-each select="ADR">
						<xsl:call-template name="ADRToStreetName"/>
						<xsl:call-template name="ADRToSuburbName"/>
						<xsl:call-template name="ADRToDistrictName"/>
						<xsl:call-template name="ADRToPostCodeIdentifier"/>
					</xsl:for-each>
					<xsl:for-each select="EMP">
						<OccupancyText>
							<xsl:value-of select="Elm[3]/SubElm[4]"/>
						</OccupancyText>
					</xsl:for-each>
				</Patient>
			</xsl:for-each>
			<xsl:if test="$S09Relatives!=''">
				<Relatives>
				<xsl:for-each select="$S09Relatives">
					<Relative>
						<xsl:for-each select="REL">
							<xsl:call-template name="RELToRelationCode"/>
						</xsl:for-each>
						<xsl:for-each select="PNA">
							<xsl:if test="Elm[2]/SubElm[1]!='_' and Elm[2]/SubElm[1]!='' ">
								<PersonIdentifier>
									<xsl:value-of select="Elm[2]/SubElm[1]"/>
								</PersonIdentifier>
							</xsl:if>
							<PersonSurnameName>
								<xsl:value-of select="Elm[5]/SubElm[2]"/>
							</PersonSurnameName>
							<PersonGivenName>
								<xsl:value-of select="Elm[6]/SubElm[2]"/>
							</PersonGivenName>
						</xsl:for-each>
						<xsl:for-each select="ADR">
							<xsl:call-template name="ADRToStreetName"/>
							<xsl:call-template name="ADRToSuburbName"/>
							<xsl:call-template name="ADRToDistrictName"/>
							<xsl:call-template name="ADRToPostCodeIdentifier"/>
						</xsl:for-each>
						<xsl:if test="CON">
							<xsl:for-each select="CON">
								<TelephoneSubscriber>
									<xsl:variable name="TLFTYPE" select="Elm[1]/SubElm[1]"/>
									<xsl:if test="$TLFTYPE!=''">
										<xsl:choose>
											<xsl:when test="$TLFTYPE='HO'">
												<TelephoneType>
													<xsl:value-of select="Elm[1]/SubElm[1]"/>
												</TelephoneType>
											</xsl:when>
											<xsl:when test="$TLFTYPE='WO'">
												<TelephoneType>
													<xsl:value-of select="Elm[1]/SubElm[1]"/>
												</TelephoneType>
											</xsl:when>
											<xsl:when test="$TLFTYPE='MO'">
												<TelephoneType>
													<xsl:value-of select="Elm[1]/SubElm[1]"/>
												</TelephoneType>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="Error">
													<xsl:with-param name="Node" select="$TLFTYPE"/>
													<xsl:with-param name="Text">Kan ikke oversaette til TelephoneSubscriber: <xsl:value-of select="$TLFTYPE"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
										<TelephoneNumber>
											<xsl:value-of select="Elm[2]/SubElm[1]"/>
										</TelephoneNumber>
									</xsl:if>										
								</TelephoneSubscriber>
							</xsl:for-each>
						</xsl:if>
					</Relative>
				</xsl:for-each>
				</Relatives>
			</xsl:if>
			<xsl:if test="$S14Auxiliaries!=''">
				<Auxiliaries>
					<xsl:for-each select="$S14Auxiliaries/CIN[Elm[1]/SubElm[1]='NC']">
						<Auxiliary>						
							<AuxiliaryCode>
								<xsl:value-of select="Elm[2]/SubElm[1]"/>
							</AuxiliaryCode>
							<Identifier>
								<xsl:value-of select="Elm[2]/SubElm[2]"/>
							</Identifier>
							<IdentifierCode>
								<xsl:value-of select="Elm[2]/SubElm[3]"/>
							</IdentifierCode>
							<AuxiliaryText>
								<xsl:value-of select="Elm[2]/SubElm[4]"/>
							</AuxiliaryText>
						</Auxiliary>
					</xsl:for-each>
					<xsl:if test="$S14Auxiliaries/FTX/Elm[1]/SubElm[1]='HK'">
						<Comment>
							<xsl:call-template name="FTXSegmentsToFormattedText">
								<xsl:with-param name="FTXSegments" select="$S14Auxiliaries/FTX[Elm[1]/SubElm[1]='HK']"/>
							</xsl:call-template>
						</Comment>
					</xsl:if>
				</Auxiliaries>
			</xsl:if>
			<xsl:if test="$S14Services or $S14ServicesComment">
				<Services>
					<xsl:for-each select="$S14Services/FTX">
							<xsl:choose>
								<!-- 2 linier, første gang-->
								<xsl:when test="following-sibling::node()[1]/Elm[1]/SubElm[1]=Elm[1]/SubElm[1]">
									<Service>
										<ServiceHeadline>										
											<xsl:apply-templates mode="serviceHeadLine" select="Elm[4]/SubElm[1]" />										
										</ServiceHeadline>
										<ServiceText>
											<xsl:apply-templates mode="serviceTextFirstLine" select="Elm[4]/SubElm[position()!=1]" />
											<xsl:apply-templates mode="serviceTextLastLine" select="following-sibling::node()[1]/Elm[4]/SubElm" />
										</ServiceText>
									</Service>			
								</xsl:when>
								<!-- kun en linie-->
								<xsl:when test="preceding-sibling::node()[1]/Elm[1]/SubElm[1]!=Elm[1]/SubElm[1]">
									<Service>			 
										<ServiceHeadline>	
											<xsl:apply-templates mode="serviceHeadLine" select="Elm[4]/SubElm[1]" />										
										</ServiceHeadline>
										<ServiceText>
											<xsl:apply-templates mode="serviceTextLastLine" select="Elm[4]/SubElm[position()!=1]" />
										</ServiceText>
									</Service>												
								</xsl:when>
								<!-- 2 linier anden gang: do noting  -->
								<xsl:otherwise/>
							</xsl:choose>			
					</xsl:for-each>					
					<xsl:if test="$S14ServicesComment">
						<Comment>
							<xsl:call-template name="FTXSegmentsToFormattedText">
								<xsl:with-param name="FTXSegments" select="$S14ServicesComment"/>																
							</xsl:call-template>
						</Comment>
					</xsl:if>
				</Services>
			</xsl:if>
			<xsl:if test="$S14Medicine">
				<Medicine>
					<xsl:for-each select="$S14Medicine/FTX[Elm[1]/SubElm[1]='MED']">
						<Drug>
							<NameOfDrug>													  
								<xsl:value-of select="Elm[4]/SubElm[1]"/>													 
							</NameOfDrug>
							<DosageForm>
								<xsl:value-of select="Elm[4]/SubElm[2]"/>
							</DosageForm>
							<DrugStrength>
								<xsl:value-of select="Elm[4]/SubElm[3]"/>
							</DrugStrength>
							<Dosage>
								<xsl:value-of select="Elm[4]/SubElm[4]"/>
							</Dosage>
							<Indication>
								<xsl:value-of select="Elm[4]/SubElm[5]"/>
							</Indication>
						</Drug>
					</xsl:for-each>
					<xsl:if test="$S14Medicine/FTX/Elm[1]/SubElm[1]='MEK'">
						<Comment>
							<xsl:call-template name="FTXSegmentsToFormattedText">
								<xsl:with-param name="FTXSegments" select="$S14Medicine/FTX[Elm[1]/SubElm[1]='MEK']"/>
							</xsl:call-template>
						</Comment>
					</xsl:if>
				</Medicine>
			</xsl:if>
			<xsl:for-each select="$S14MotionEvaluation">
				<MotionEvaluation>
						<xsl:call-template name="FTXSegmentsToFormattedText">
							<xsl:with-param name="FTXSegments" select="$S14MotionEvaluation/FTX[Elm[1]/SubElm[1]='FV']"/>
						</xsl:call-template>
				</MotionEvaluation>
			</xsl:for-each>
			<xsl:for-each select="$S14PatientHealthSummary">
				<PatientHealthSummary>
						<xsl:call-template name="FTXSegmentsToFormattedText">
							<xsl:with-param name="FTXSegments" select="$S14PatientHealthSummary/FTX[Elm[1]/SubElm[1]='RS']"/>
						</xsl:call-template>
				</PatientHealthSummary>
			</xsl:for-each>
			<xsl:for-each select="$S14CauseOfAdmission">
				<CauseOfAdmission>
						<xsl:call-template name="FTXSegmentsToFormattedText">
							<xsl:with-param name="FTXSegments" select="$S14CauseOfAdmission/FTX[Elm[1]/SubElm[1]='PR']"/>
						</xsl:call-template>
				</CauseOfAdmission>
			</xsl:for-each>
			<xsl:for-each select="$S14InformedRelative">
				<InformedRelative>
						<xsl:call-template name="FTXSegmentsToFormattedText">
							<xsl:with-param name="FTXSegments" select="$S14InformedRelative/FTX[Elm[1]/SubElm[1]='AP']"/>
						</xsl:call-template>
				</InformedRelative>
			</xsl:for-each>
		</ReportOfAdmission>
	</xsl:template>
	
	<xsl:template match="SubElm" mode="serviceHeadLine">
		<xsl:value-of select="." xml:space="preserve"/>
	</xsl:template>
	
	<xsl:template match="SubElm" mode="serviceTextFirstLine">
		<xsl:value-of select="." xml:space="preserve"/>
		<Break/>
	</xsl:template>
		
	<xsl:template match="SubElm" mode="serviceTextLastLine">
		<xsl:value-of select="." xml:space="preserve"/>
		<xsl:if test="count(following-sibling::node())>0">
			<Break/>		
		</xsl:if>
	</xsl:template>
		
</xsl:stylesheet>
