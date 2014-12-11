<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2011/02/17/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- Fødselsanmeldelse -->
	<xsl:template match="m:BirthNotification">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="OwnMaternityMother" select="m:OwnMaternityMother"/>
		<xsl:variable name="Practitioner" select="m:Practitioner"/>
		<xsl:variable name="BirthMaternityMother" select="m:BirthMaternityMother"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="Partner" select="m:PartnerRelation"/>
		<xsl:variable name="Child" select="m:ChildRelation"/>
		<xsl:variable name="Pregnancy" select="m:Pregnancy"/>
		<xsl:variable name="Birth" select="m:Birth"/>
		<xsl:variable name="ChildInfo" select="m:ChildInfo"/>

		<Brev>
			<UNH>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
				<Elm>
					<SubElm>MEDDIS</SubElm>
					<SubElm>D</SubElm>
					<SubElm>93A</SubElm>
					<SubElm>UN</SubElm>
					<SubElm>D3234L</SubElm>
				</Elm>
				<Elm>
					<SubElm>DIS32</SubElm>
				</Elm>
			</UNH>
			<BrevIndhold>
				<BGM>
					<Elm>
						<SubElm>EPI</SubElm>
					</Elm>
					<Elm/>
					<Elm>
						<SubElm>9</SubElm>
					</Elm>
					<Elm>
						<SubElm>NA</SubElm>
					</Elm>
				</BGM>
				<DTM>
					<Elm>
						<SubElm>137</SubElm>
						<SubElm>
							<xsl:variable name="DT" select="$Letter/m:Authorisation"/>
							<xsl:variable name="DT203"
								select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
							<xsl:value-of select="$DT203"/>
						</SubElm>
						<SubElm>203</SubElm>
					</Elm>
				</DTM>

				<!-- AFSENDER -->
				<S01>
					<xsl:variable name="Participant" select="$Sender"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>SSP</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:Identifier"/>
							</SubElm>
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SKS</xsl:when>
									<xsl:when test="$IC='ydernummer' ">YNR</xsl:when>
									<xsl:when test="$IC='lokationsnummer' "/>
									<xsl:when test="count($IC)=0 "/>
									<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SOR</xsl:when>
			 <xsl:otherwise>
										<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SST</xsl:when>
									<xsl:when test="$IC='ydernummer' ">SFU</xsl:when>
									<xsl:when test="$IC='lokationsnummer' ">9</xsl:when>
									<xsl:when test="count($IC)=0 ">9</xsl:when>
									<xsl:when test="$IC='kommunenummer' ">IM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SST</xsl:when>
			 <xsl:otherwise>
										<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:OrganisationName"/>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:DepartmentName"/>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:UnitName"/>
							</SubElm>
							<SubElm/>
							<SubElm/>
							<SubElm>US</SubElm>
						</Elm>
					</NAD>
					<!-- Standard for ADR segments -->
					<xsl:variable name="Adr" select="$Participant"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:DistrictName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm/>
							<Elm>
								<SubElm>US</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr//m:StreetName"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr/m:SuburbName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:DistrictName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>
					<xsl:if test="count($Sender/m:TelephoneSubscriberIdentifier)=1">
						<CON>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Sender/m:TelephoneSubscriberIdentifier"/>
								</SubElm>
								<SubElm>TE</SubElm>
							</Elm>
						</CON>
					</xsl:if>
					<SEQ>
						<Elm> </Elm>
						<Elm>
							<SubElm>1</SubElm>
						</Elm>
					</SEQ>
					<SPR>
						<Elm>
							<SubElm>ORG</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:if test="count($Participant/m:MedicalSpecialityCode)=0">99</xsl:if>
								<xsl:if test="count($Participant/m:MedicalSpecialityCode)=1">
									<xsl:variable name="MSC" select="$Participant/m:MedicalSpecialityCode"/>
									<xsl:choose>
										<xsl:when test=" $MSC='ikkeklassificeret'">99</xsl:when>
										<xsl:when test=" $MSC='intern_medicin_sygehus'">1</xsl:when>
										<xsl:when test=" $MSC='geriatri'">2</xsl:when>
										<xsl:when test=" $MSC='hepatologi'">3</xsl:when>
										<xsl:when test=" $MSC='haematologi'">4</xsl:when>
										<xsl:when test=" $MSC='infektionsmedicin'">5</xsl:when>
										<xsl:when test=" $MSC='kardiologi'">6</xsl:when>
										<xsl:when test=" $MSC='med_allergologi'">7</xsl:when>
										<xsl:when test=" $MSC='med_endokrinologi'">8</xsl:when>
										<xsl:when test=" $MSC='med_gastroenterologi'">9</xsl:when>
										<xsl:when test=" $MSC='med_lungesygdomme'">10</xsl:when>
										<xsl:when test=" $MSC='nefrologi'">11</xsl:when>
										<xsl:when test=" $MSC='reumatologi'">12</xsl:when>
										<xsl:when test=" $MSC='dermato_venerologi_sygehus'">18</xsl:when>
										<xsl:when test=" $MSC='neurologi'">20</xsl:when>
										<xsl:when test=" $MSC='onkologi'">22</xsl:when>
										<xsl:when test=" $MSC='kirurgi_sygehus'">30</xsl:when>
										<xsl:when test=" $MSC='karkirurgi'">31</xsl:when>
										<xsl:when test=" $MSC='kir_gastroenterologi'">32</xsl:when>
										<xsl:when test=" $MSC='plastikkirurgi'">33</xsl:when>
										<xsl:when test=" $MSC='thoraxkirurgi'">34</xsl:when>
										<xsl:when test=" $MSC='urologi'">35</xsl:when>
										<xsl:when test=" $MSC='gynaekologi_obstetrik_sygehus'">38</xsl:when>
										<xsl:when test=" $MSC='neurokirurgi'">40</xsl:when>
										<xsl:when test=" $MSC='ortopaedisk_kirurgi_sygehus'">42</xsl:when>
										<xsl:when test=" $MSC='oftalmologi'">44</xsl:when>
										<xsl:when test=" $MSC='oto_rhino_laryngologi'">46</xsl:when>
										<xsl:when test=" $MSC='hospitalsodontologi'">48</xsl:when>
										<xsl:when test=" $MSC='psykiatri_sygehus'">50</xsl:when>
										<xsl:when test=" $MSC='boerne_ungdomspsykiatri'">52</xsl:when>
										<xsl:when test=" $MSC='klin_biokemi'">60</xsl:when>
										<xsl:when test=" $MSC='klin_fys_nuklearmedicin'">61</xsl:when>
										<xsl:when test=" $MSC='klin_immunologi'">62</xsl:when>
										<xsl:when test=" $MSC='klin_mikrobiologi'">63</xsl:when>
										<xsl:when test=" $MSC='klin_neurofysiologi'">64</xsl:when>
										<xsl:when test=" $MSC='patologisk_anatomi'">65</xsl:when>
										<xsl:when test=" $MSC='diagnostisk_radiologi'">66</xsl:when>
										<xsl:when test=" $MSC='klin_farmakologi'">67</xsl:when>
										<xsl:when test=" $MSC='klin_genetik'">68</xsl:when>
										<xsl:when test=" $MSC='anaestesiologi_sygehus'">84</xsl:when>
										<xsl:when test=" $MSC='arbejdsmedicin'">86</xsl:when>
										<xsl:when test=" $MSC='almen_medicin'">90</xsl:when>
										<xsl:when test=" $MSC='samfundsmedicin'">91</xsl:when>
										<xsl:when test=" $MSC='almenlaege_laegevagt'">580</xsl:when>
										<xsl:when test=" $MSC='oejenlaege'">1519</xsl:when>
										<xsl:when test=" $MSC='oere_naese_halslaege'">2021</xsl:when>
										<xsl:when test=" $MSC='anaestesiologi_praksis'">2501</xsl:when>
										<xsl:when test=" $MSC='roentgen_kbh'">2503</xsl:when>
										<xsl:when test=" $MSC='dermato_venerologi_praksis'">2511</xsl:when>
										<xsl:when test=" $MSC='roentgen'">2505</xsl:when>
										<xsl:when test=" $MSC='reumatologi_fysiurgi'">2506</xsl:when>
										<xsl:when test=" $MSC='gynaekologi_obstetrik_praksis'">2507</xsl:when>
										<xsl:when test=" $MSC='intern_medicin_praksis'">2508</xsl:when>
										<xsl:when test=" $MSC='kirurgi_praksis'">2509</xsl:when>
										<xsl:when test=" $MSC='klinisk_kemi'">2511</xsl:when>
										<xsl:when test=" $MSC='neuromedicin'">2518</xsl:when>
										<xsl:when test=" $MSC='ortopaedisk_kirurgi_praksis'">2520</xsl:when>
										<xsl:when test=" $MSC='patologi '">2522</xsl:when>
										<xsl:when test=" $MSC='plastkirurgi'">2523</xsl:when>
										<xsl:when test=" $MSC='psykiatri_praksis'">2524</xsl:when>
										<xsl:when test=" $MSC='paediatri'">2525</xsl:when>
										<xsl:when test=" $MSC='boernepsykiatri'">2526</xsl:when>
										<xsl:when test=" $MSC='tropemedicin'">2528</xsl:when>
										<xsl:when test=" $MSC='tandlaege'">4050</xsl:when>
										<xsl:when test=" $MSC='fysioterapi'">4551</xsl:when>
										<xsl:when test=" $MSC='kiropraktor'">5053</xsl:when>
										<xsl:when test=" $MSC='briller'">5552</xsl:when>
										<xsl:when test=" $MSC='fodterapi'">6054</xsl:when>
										<xsl:when test=" $MSC='fodbehandlking'">6055</xsl:when>
										<xsl:when test=" $MSC='med_laboratorier'">7045</xsl:when>
										<xsl:when test=" $MSC='omegnslaboratorier'">7046</xsl:when>
										<xsl:when test=" $MSC='psykolog'">9463</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte MedicalSpecialityCode: <xsl:value-of select="$MSC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</SubElm>
							<SubElm>SKS</SubElm>
							<SubElm>SST</SubElm>
						</Elm>
						<Elm>
							<SubElm>DIS32</SubElm>
							<SubElm>SKS</SubElm>
							<SubElm>SST</SubElm>
						</Elm>
					</SPR>
				</S01>

				<!-- MODTAGER -->
				<S01>
					<xsl:variable name="Participant" select="$Receiver"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>PO</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:Identifier"/>
							</SubElm>
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SKS</xsl:when>
									<xsl:when test="$IC='ydernummer' ">YNR</xsl:when>
									<xsl:when test="$IC='lokationsnummer' "/>
									<xsl:when test="count($IC)=0"/>
									<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SOR</xsl:when>
			 <xsl:otherwise>
										<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SST</xsl:when>
									<xsl:when test="$IC='ydernummer' ">SFU</xsl:when>
									<xsl:when test="$IC='lokationsnummer' ">9</xsl:when>
									<xsl:when test="count($IC)=0">9</xsl:when>
									<xsl:when test="$IC='kommunenummer' ">IM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SST</xsl:when>
			 <xsl:otherwise>
										<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:if test="count($Participant/m:OrganisationName)=1">
									<xsl:value-of select="$Participant/m:OrganisationName"/>
								</xsl:if>
								<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:DepartmentName"/>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:UnitName"/>
							</SubElm>
							<SubElm/>
							<SubElm/>
							<SubElm>US</SubElm>
						</Elm>
					</NAD>
					<!-- Standard for ADR segments -->
					<xsl:variable name="Adr" select="$Participant"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:DistrictName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm/>
							<Elm>
								<SubElm>US</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr//m:StreetName"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr/m:SuburbName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:DistrictName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>2</SubElm>
						</Elm>
					</SEQ>
				</S01>

				<!-- Egen jordemoder -->
				<S01>
					<xsl:variable name="Participant" select="$OwnMaternityMother"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>PRH</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:Identifier"/>
							</SubElm>
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='lokalt_nummer' ">NCD</xsl:when>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SKS</xsl:when>
									<xsl:when test="$IC='ydernummer' ">YNR</xsl:when>
									<xsl:when test="$IC='lokationsnummer' "/>
									<xsl:when test="count($IC)=0"/>
									<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SOR</xsl:when>
			 <xsl:otherwise>
										<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:if test="count($Participant/m:PersonName)=1">
									<xsl:value-of select="$Participant/m:PersonName"/>
								</xsl:if>
								<xsl:if test="count($Participant/m:PersonName)=0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:OrganisationName"/>
							</SubElm>
							<SubElm/>
							<SubElm/>
							<SubElm/>
							<SubElm>US</SubElm>
						</Elm>
					</NAD>
					<!-- Standard for ADR segments -->
					<xsl:variable name="Adr" select="$Participant"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:DistrictName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm/>
							<Elm>
								<SubElm>US</SubElm>
								<xsl:if test="count($Adr/m:StreetName)>0">
									<SubElm>
										<xsl:value-of select="$Adr//m:StreetName"/>
									</SubElm>
								</xsl:if>
								<xsl:if test="count($Adr/m:SuburbName)>0">
									<SubElm>
										<xsl:value-of select="$Adr/m:SuburbName"/>
									</SubElm>
								</xsl:if>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:DistrictName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>3</SubElm>
						</Elm>
					</SEQ>
				</S01>

				<!-- Egen læge -->
				<S01>
					<xsl:variable name="Participant" select="$Practitioner"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>UGP</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:Identifier"/>
							</SubElm>
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='lokalt_nummer' ">NCD</xsl:when>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SKS</xsl:when>
									<xsl:when test="$IC='ydernummer' ">YNR</xsl:when>
									<xsl:when test="$IC='lokationsnummer' "/>
									<xsl:when test="count($IC)=0"/>
									<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SOR</xsl:when>
			 <xsl:otherwise>
										<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SST</xsl:when>
									<xsl:when test="$IC='ydernummer' ">SFU</xsl:when>
									<xsl:when test="$IC='lokationsnummer' ">9</xsl:when>
									<xsl:when test="count($IC)=0 ">9</xsl:when>
									<xsl:when test="$IC='kommunenummer' ">IM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SST</xsl:when>
			 <xsl:otherwise>
										<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:if test="count($Participant/m:OrganisationName)=1">
									<xsl:value-of select="$Participant/m:OrganisationName"/>
								</xsl:if>
								<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
							</SubElm>
							<SubElm/>
							<SubElm/>
							<SubElm/>
							<SubElm/>
							<SubElm>US</SubElm>
						</Elm>
					</NAD>
					<!-- Standard for ADR segments -->
					<xsl:variable name="Adr" select="$Participant"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:DistrictName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm/>
							<Elm>
								<SubElm>US</SubElm>
								<xsl:if test="count($Adr/m:StreetName)>0">
									<SubElm>
										<xsl:value-of select="$Adr//m:StreetName"/>
									</SubElm>
								</xsl:if>
								<xsl:if test="count($Adr/m:SuburbName)>0">
									<SubElm>
										<xsl:value-of select="$Adr/m:SuburbName"/>
									</SubElm>
								</xsl:if>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:DistrictName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>4</SubElm>
						</Elm>
					</SEQ>
				</S01>

				<!-- Fødselsjordemoder -->
				<S01>
					<xsl:variable name="Participant" select="$BirthMaternityMother"/>
					<Elm>
						<SubElm>01</SubElm>
					</Elm>
					<NAD>
						<Elm>
							<SubElm>BV</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Participant/m:Identifier"/>
							</SubElm>
							<SubElm>
								<xsl:variable name="IC" select="$Participant/m:IdentifierCode"/>
								<xsl:choose>
									<xsl:when test="$IC='lokalt_nummer' ">NCD</xsl:when>
									<xsl:when test="$IC='sygehusafdelingsnummer' ">SKS</xsl:when>
									<xsl:when test="$IC='ydernummer' ">YNR</xsl:when>
									<xsl:when test="$IC='lokationsnummer' "/>
									<xsl:when test="count($IC)=0"/>
									<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
		     <xsl:when test="$IC='sorkode'">SOR</xsl:when>
			 <xsl:otherwise>
										<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:if test="count($Participant/m:PersonName)=1">
									<xsl:value-of select="$Participant/m:PersonName"/>
								</xsl:if>
								<xsl:if test="count($Participant/m:PersonName)=0">_</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Participant/m:OrganisationName"/>
							</SubElm>
							<SubElm/>
							<SubElm/>
							<SubElm/>
							<SubElm>US</SubElm>
						</Elm>
					</NAD>
					<!-- Standard for ADR segments -->
					<xsl:variable name="Adr" select="$Participant"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:DistrictName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm/>
							<Elm>
								<SubElm>US</SubElm>
								<xsl:if test="count($Adr/m:StreetName)>0">
									<SubElm>
										<xsl:value-of select="$Adr//m:StreetName"/>
									</SubElm>
								</xsl:if>
								<xsl:if test="count($Adr/m:SuburbName)>0">
									<SubElm>
										<xsl:value-of select="$Adr/m:SuburbName"/>
									</SubElm>
								</xsl:if>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:DistrictName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>
					<RFF>
						<Elm>
							<SubElm>AHL</SubElm>
							<SubElm>1</SubElm>
						</Elm>
					</RFF>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>5</SubElm>
						</Elm>
					</SEQ>
				</S01>
				<S02>
					<Elm>
						<SubElm>02</SubElm>
					</Elm>
					<xsl:call-template name="GetGIS">
						<xsl:with-param name="StatusCode" select="$Letter/m:StatusCode"/>
					</xsl:call-template>
					<RFF>
						<Elm>
							<SubElm>SRI</SubElm>
							<SubElm>
								<xsl:value-of select="$Letter/m:Identifier"/>
							</SubElm>
						</Elm>
					</RFF>
					<DTM>
						<Elm>
							<SubElm>182</SubElm>
							<SubElm>
								<xsl:variable name="DT" select="$Letter/m:Authorisation"/>
								<xsl:variable name="DT203"
									select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
								<xsl:value-of select="$DT203"/>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
				</S02>

				<!-- Patient -->
				<S07>
					<xsl:if test="count($Patient//m:CivilRegistrationNumber)=1 and count($Patient/m:AlternativeIdentifier)=1">
						<FEJL>Patient kan ikke både have et CivilRegistrationNumber og et AlternativeIdentifier</FEJL>
					</xsl:if>
					<xsl:if test="count($Patient//m:CivilRegistrationNumber)=0 and count($Patient/m:AlternativeIdentifier)=0">
						<FEJL>Patient skal have et CivilRegistrationNumber eller et AlternativeIdentifier</FEJL>
					</xsl:if>
					<xsl:variable name="Person" select="$Patient"/>
					<Elm>
						<SubElm>07</SubElm>
					</Elm>
					<PNA>
						<Elm>
							<SubElm>PAT</SubElm>
						</Elm>
						<Elm>
							<xsl:if test="count($Patient/m:CivilRegistrationNumber)=1">
								<SubElm>
									<xsl:value-of select="$Patient/m:CivilRegistrationNumber"/>
								</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm>CPR</SubElm>
								<SubElm>IM</SubElm>
							</xsl:if>
						</Elm>
						<Elm/>
						<Elm/>
						<Elm>
							<SubElm>SU</SubElm>
							<SubElm>
								<xsl:value-of select="$Person/m:PersonSurnameName"/>
							</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:if test="count($Person/m:PersonGivenName)=1">FO</xsl:if>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Person/m:PersonGivenName"/>
							</SubElm>
						</Elm>
					</PNA>
					<xsl:if test="count($Patient/m:AlternativeIdentifier)=1">
						<RFF>
							<Elm>
								<SubElm>XPI</SubElm>
								<SubElm>
									<xsl:value-of select="$Patient/m:AlternativeIdentifier"/>
								</SubElm>
							</Elm>
						</RFF>
					</xsl:if>
					<!-- Standard for ADR segments -->
					<xsl:variable name="Adr" select="$Person"/>
					<xsl:if test="count($Adr/m:StreetName)+count($Adr/m:SuburbName)+count($Adr/m:DistrictName)+count($Adr/m:PostCodeIdentifier)>0">
						<ADR>
							<Elm/>
							<Elm>
								<SubElm>US</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr//m:StreetName"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Adr/m:SuburbName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:DistrictName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Adr/m:PostCodeIdentifier"/>
								</SubElm>
							</Elm>
						</ADR>
					</xsl:if>

					<!-- Moderens tlf.numre -->
					<xsl:if test="count($Patient/m:TelephoneSubscriber)>0">
						<xsl:if test="count($Patient/m:TelephoneSubscriber/m:PrivateSubscriberIdentifier)>0">
							<CON>
								<Elm>
									<SubElm>HO</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="$Patient/m:TelephoneSubscriber/m:PrivateSubscriberIdentifier"/>
									</SubElm>
									<SubElm>TE</SubElm>
								</Elm>
							</CON>
						</xsl:if>
						<xsl:if test="count($Patient/m:TelephoneSubscriber/m:MobileSubscriberIdentifier)>0">
							<CON>
								<Elm>
									<SubElm>MO</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="$Patient/m:TelephoneSubscriber/m:MobileSubscriberIdentifier"/>
									</SubElm>
									<SubElm>TE</SubElm>
								</Elm>
							</CON>
						</xsl:if>
						<xsl:if test="count($Patient/m:TelephoneSubscriber/m:WorkSubscriberIdentifier)>0">
							<CON>
								<Elm>
									<SubElm>WO</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="$Patient/m:TelephoneSubscriber/m:WorkSubscriberIdentifier"/>
									</SubElm>
									<SubElm>TE</SubElm>
								</Elm>
							</CON>
						</xsl:if>
					</xsl:if>

					<!-- Moderens civilstand -->
					<xsl:if test="count($Patient/m:MaritalStatus)>0">
						<PDI>
							<Elm>
								<SubElm>2</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="MS" select="$Patient/m:MaritalStatus"/>
									<xsl:choose>
										<xsl:when test="$MS='gift' ">MA</xsl:when>
										<xsl:when test="$MS='single' ">SI</xsl:when>
										<xsl:when test="$MS='separeret' ">SP</xsl:when>
										<xsl:when test="$MS='skilt' ">DI</xsl:when>
										<xsl:when test="$MS='samboende' ">LI</xsl:when>
										<xsl:when test="$MS='enke' ">WI</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversaette til MaritalStatus: <xsl:value-of select="$MS"/></FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</PDI>
					</xsl:if>

					<!-- Moderens tolkebehov -->
					<xsl:if test="count($Patient/m:InterpretationNeeds/m:InterpretationIsNeededCode)>0">
						<LAN>
							<Elm>
								<SubElm>
									<xsl:variable name="IC" select="$Patient/m:InterpretationNeeds/m:InterpretationIsNeededCode"/>
									<xsl:choose>
										<xsl:when test="$IC='tolkebehov_nej' ">TN</xsl:when>
										<xsl:when test="$IC='tolkebehov_uafklaret' ">NO</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversaette til InterpretationIsNeededCode: <xsl:value-of select="$IC"/></FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm></SubElm>
								<SubElm></SubElm>
							</Elm>
						</LAN>
					</xsl:if>				
					<xsl:if test="count($Patient/m:InterpretationNeeds/m:ISOLanguageCode)>0">
						<LAN>
							<Elm>
								<SubElm>TJ</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Patient/m:InterpretationNeeds/m:ISOLanguageCode"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Patient/m:InterpretationNeeds/m:ISOLanguageCodeDescription"/>
								</SubElm>
							</Elm>
						</LAN>
					</xsl:if>
					<!-- Moderens stillingsbetegnelse -->
					<xsl:if test="count($Patient/m:OccupancyText)=1">
						<EMP>
							<Elm>
								<SubElm>1</SubElm>
							</Elm>
							<Elm> </Elm>
							<Elm>
								<SubElm/>
								<SubElm/>
								<SubElm/>
								<SubElm>
									<xsl:value-of select="$Patient/m:OccupancyText"/>
								</SubElm>
							</Elm>
						</EMP>
					</xsl:if>
				</S07>

				<!-- Ægtefælle/samlever -->
				<xsl:if test="count($Partner)>0">
					<S09>
						<Elm>
							<SubElm>09</SubElm>
						</Elm>
						<REL>
							<Elm>
								<SubElm>PER</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="RC" select="$Partner/m:RelationCode"/>
									<xsl:choose>
										<xsl:when test="$RC='aegtefaelle' ">PA</xsl:when>
										<xsl:when test="$RC='samboende' ">PA</xsl:when>
										<xsl:when test="$RC='registreret_partner' ">PA</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversaette til Partner RelationCode: <xsl:value-of select="$RC"/></FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</REL>
						<PNA>
							<Elm>
								<SubElm>PAS</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Partner/m:PersonIdentifier"/>
								</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm>CPR</SubElm>
								<SubElm>IM</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>SU</SubElm>
								<SubElm>
									<xsl:value-of select="$Partner/m:PersonSurnameName"/>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:if test="count($Partner/m:PersonGivenName)=1">FO</xsl:if>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Partner/m:PersonGivenName"/>
								</SubElm>
							</Elm>
						</PNA>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>1</SubElm>
							</Elm>
						</SEQ>

						<!-- Partners stillingsbetegnelse -->
						<xsl:if test="count($Partner/m:OccupancyText)=1">
							<EMP>
								<Elm>
									<SubElm>1</SubElm>
								</Elm>
								<Elm> </Elm>
								<Elm>
									<SubElm/>
									<SubElm/>
									<SubElm/>
									<SubElm>
										<xsl:value-of select="$Partner/m:OccupancyText"/>
									</SubElm>
								</Elm>
							</EMP>
						</xsl:if>
					</S09>
				</xsl:if>

				<!-- Børn stamdata -->
				<xsl:for-each select="$Child">
					<S09>
						<xsl:variable name="NC" select="position()"/>

						<Elm>
							<SubElm>09</SubElm>
						</Elm>
						<REL>
							<Elm>
								<SubElm>PER</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="RC" select="$Child[$NC]/m:RelationCode"/>
									<xsl:choose>
										<xsl:when test="$RC='barn' ">SD</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversaette til Child RelationCode: <xsl:value-of select="$RC"/></FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</REL>
						<DTM>
							<Elm>
								<SubElm>PRS</SubElm>
								<SubElm>
									<xsl:variable name="DT" select="$Child[$NC]/m:TimeOfBirth"/>
									<xsl:variable name="DT203"
										select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
									<xsl:value-of select="$DT203"/>
								</SubElm>
								<SubElm>203</SubElm>
							</Elm>
						</DTM>
						<PNA>
							<Elm>
								<SubElm>PAS</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Child[$NC]/m:PersonIdentifier"/>
								</SubElm>
								<SubElm/>
								<SubElm/>
								<SubElm>CPR</SubElm>
								<SubElm>IM</SubElm>
							</Elm>
						</PNA>
						<RFF>
							<Elm>
								<SubElm>K01</SubElm>
								<SubElm>
									<xsl:value-of select="$Child[$NC]/m:BirthStatus1"/>
								</SubElm>
							</Elm>
						</RFF>
						<RFF>
							<Elm>
								<SubElm>K02</SubElm>
								<SubElm>
									<xsl:value-of select="$Child[$NC]/m:BirthStatus2"/>
								</SubElm>
							</Elm>
						</RFF>
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$NC+1"/>
								</SubElm>
							</Elm>
						</SEQ>
						<PDI>
							<Elm>
								<SubElm>
									<xsl:variable name="GD" select="$Child[$NC]/m:Gender"/>
									<xsl:choose>
										<xsl:when test="$GD='pige' ">2</xsl:when>
										<xsl:when test="$GD='dreng' ">1</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversaette til Child Gender: <xsl:value-of select="$GD"/></FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</PDI>
					</S09>
				</xsl:for-each>

				<!-- Graviditeten -->
				<S11>
					<Elm>
						<SubElm>11</SubElm>
					</Elm>
					<xsl:call-template name="GetGIS">
						<xsl:with-param name="StatusCode" select="$Letter/m:StatusCode"/>
					</xsl:call-template>

					<xsl:call-template name="GetEpisodeOfCareIdentifier">
						<xsl:with-param name="EpisodeOfCareIdentifier" select="$Letter/m:EpisodeOfCareIdentifier"/>
					</xsl:call-template>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>1</SubElm>
						</Elm>
					</SEQ>

					<xsl:if test="count($Pregnancy/m:DateOfLastMenstruation)>0">
						<DTM>
							<Elm>
								<SubElm>90</SubElm>
								<SubElm>
									<xsl:variable name="DT" select="$Pregnancy/m:DateOfLastMenstruation"/>
									<xsl:variable name="DT203"
										select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
									<xsl:value-of select="$DT203"/>
								</SubElm>
								<SubElm>203</SubElm>
							</Elm>
						</DTM>
					</xsl:if>
					<DTM>
						<Elm>
							<SubElm>91</SubElm>
							<SubElm>
								<xsl:variable name="DT" select="$Pregnancy/m:DateofDelivery"/>
								<xsl:variable name="DT203"
									select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
								<xsl:value-of select="$DT203"/>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>

					<PAS>
						<Elm>
							<SubElm>
								<xsl:variable name="EOCSC" select="$Patient/m:EpisodeOfCareStatusCode"/>
								<xsl:choose>
									<xsl:when test="count($EOCSC)=0 ">POT</xsl:when>
									<xsl:when test="$EOCSC='forløb' ">POT</xsl:when>
									<xsl:when test="$EOCSC='direkte_hjem_fra_fødegang' ">HJ</xsl:when>
									<xsl:when test="$EOCSC='forventet_udskrevet_inden_24_timer_efter_fødslen' ">HK</xsl:when>
									<xsl:when test="$EOCSC='forventet_udskrevet_senere_end_24_timer_efter_fødslen' ">HL</xsl:when>
									<xsl:otherwise>
										<FEJL>Kan ikke oversaette til EpisodeOfCareStatusCode: <xsl:value-of select="$EOCSC"/></FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
					</PAS>

					<!-- Graviditeten: Aktionsdiagnose-->
					<xsl:if test="count($Pregnancy/m:PregnancyPrincipalDiagnoses)>0">
						<CIN>
							<Elm>
								<SubElm>
									<xsl:call-template name="GetDiagnoseDescriptionCode">
										<xsl:with-param name="DiagnoseDescriptionCode"
											select="$Pregnancy/m:PregnancyPrincipalDiagnoses/m:DiagnoseDescriptionCode"/>
									</xsl:call-template>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Pregnancy/m:PregnancyPrincipalDiagnoses/m:DiagnoseCode"/>
								</SubElm>
								<xsl:call-template name="GetDiagnoseTypeCodeAndOrg">
									<xsl:with-param name="DiagnoseTypeCode" select="$Pregnancy/m:PregnancyPrincipalDiagnoses/m:DiagnoseTypeCode"/>
								</xsl:call-template>
								<SubElm>
									<xsl:value-of select="$Pregnancy/m:PregnancyPrincipalDiagnoses/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:if>

					<!-- Graviditeten: evt. tillægsdiagnoser-->
					<xsl:if test="count($Pregnancy/m:PregnancyAdditionalDiagnoses)>0">
						<xsl:for-each select="$Pregnancy/m:PregnancyAdditionalDiagnoses">
							<xsl:variable name="NC" select="position()"/>
							<xsl:variable name="NCMax" select="5"/>
							<xsl:if test="$NC &lt; $NCMax+1">
								<CIN>
									<Elm>
										<SubElm>
											<xsl:call-template name="GetDiagnoseDescriptionCode">
												<xsl:with-param name="DiagnoseDescriptionCode"
													select="$Pregnancy/m:PregnancyAdditionalDiagnoses[$NC]/m:DiagnoseDescriptionCode"/>
											</xsl:call-template>
										</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="$Pregnancy/m:PregnancyAdditionalDiagnoses[$NC]/m:DiagnoseCode"/>
										</SubElm>
										<xsl:call-template name="GetDiagnoseTypeCodeAndOrg">
											<xsl:with-param name="DiagnoseTypeCode"
												select="$Pregnancy/m:PregnancyAdditionalDiagnoses[$NC]/m:DiagnoseTypeCode"/>
										</xsl:call-template>
										<SubElm>
											<xsl:value-of select="$Pregnancy/m:PregnancyAdditionalDiagnoses[$NC]/m:DiagnoseText"/>
										</SubElm>
									</Elm>
								</CIN>
							</xsl:if>
							<xsl:if test="$NC &gt; $NCMax">
								<xsl:variable name="TXT" select="concat('Max. antal CIN-segmenter=', string($NCMax),' er overskredet på dette sted!')"/>
								<FEJL>
									<xsl:value-of select="$TXT"/>
								</FEJL>
							</xsl:if>

						</xsl:for-each>
					</xsl:if>
				</S11>

				<!-- Graviditeten: evt. undersøgelser og behandlinger max. 10 rep.-->
				<xsl:if test="count($Pregnancy/m:PregnancyInvestigationAndTreatments)>0">
					<xsl:for-each select="$Pregnancy/m:PregnancyInvestigationAndTreatments">
						<xsl:variable name="NC" select="position()"/>
						<xsl:variable name="NCMax" select="10"/>
						<xsl:if test="$NC &lt; $NCMax+1">
							<S14>
								<Elm>
									<SubElm>14</SubElm>
								</Elm>

								<xsl:if test="count($Pregnancy/m:PregnancyInvestigationAndTreatments[$NC]/m:InvestigationAndTreatmentDiagnoses)>0">
									<xsl:for-each select="$Pregnancy/m:PregnancyInvestigationAndTreatments[$NC]/m:InvestigationAndTreatmentDiagnoses">
										<xsl:variable name="ND" select="position()"/>
										<xsl:variable name="NDMax" select="9"/>
										<xsl:if test="$ND &lt; $NDMax+1">
											<CIN>
												<Elm>
													<SubElm>
														<xsl:call-template name="GetDiagnoseDescriptionCode">
															<xsl:with-param name="DiagnoseDescriptionCode"
																select="$Pregnancy/m:PregnancyInvestigationAndTreatments[$NC]/m:InvestigationAndTreatmentDiagnoses[$ND]/m:DiagnoseDescriptionCode"
															/>
														</xsl:call-template>
													</SubElm>
												</Elm>
												<Elm>
													<SubElm>
														<xsl:value-of
															select="$Pregnancy/m:PregnancyInvestigationAndTreatments[$NC]/m:InvestigationAndTreatmentDiagnoses[$ND]/m:DiagnoseCode"
														/>
													</SubElm>
													<xsl:call-template name="GetDiagnoseTypeCodeAndOrg">
														<xsl:with-param name="DiagnoseTypeCode"
															select="$Pregnancy/m:PregnancyInvestigationAndTreatments[$NC]/m:InvestigationAndTreatmentDiagnoses[$ND]/m:DiagnoseTypeCode"
														/>
													</xsl:call-template>
													<SubElm>
														<xsl:value-of
															select="$Pregnancy/m:PregnancyInvestigationAndTreatments[$NC]/m:InvestigationAndTreatmentDiagnoses[$ND]/m:DiagnoseText"
														/>
													</SubElm>
												</Elm>

											</CIN>
										</xsl:if>
										<xsl:if test="$ND &gt; $NDMax">
											<xsl:variable name="TXT"
												select="concat('Max. antal CIN-segmenter=', string($NDMax),' er overskredet på dette sted!')"/>
											<FEJL>
												<xsl:value-of select="$TXT"/>
											</FEJL>
										</xsl:if>


									</xsl:for-each>
								</xsl:if>

								<xsl:if test="count($Pregnancy/m:PregnancyInvestigationAndTreatments[$NC]/m:ClinicalInfoDate)>0">
									<DTM>
										<Elm>
											<SubElm>CIS</SubElm>
											<SubElm>
												<xsl:variable name="DT"
													select="$Pregnancy/m:PregnancyInvestigationAndTreatments[$NC]/m:ClinicalInfoDate"/>
												<xsl:variable name="DT203"
													select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
												<xsl:value-of select="$DT203"/>
											</SubElm>
											<SubElm>203</SubElm>
										</Elm>
									</DTM>
								</xsl:if>
								<xsl:if test="count($Pregnancy/m:PregnancyInvestigationAndTreatments[$NC]/m:InvestigationAndTreatmentText)>0">
									<XFTX maxOccurs="5">
										<Elm>
											<SubElm>NC</SubElm>
										</Elm>
										<Elm/>
										<Elm/>
										<Elm>
											<SubElm>
												<xsl:for-each select="m:InvestigationAndTreatmentText">
													<xsl:for-each select="text() | *">
														<xsl:apply-templates select="."/>
													</xsl:for-each>
												</xsl:for-each>
											</SubElm>
										</Elm>
									</XFTX>
								</xsl:if>
							</S14>
						</xsl:if>
						<xsl:if test="$NC &gt; $NCMax">
							<xsl:variable name="TXT" select="concat('Max. antal S14-segmenter=', string($NCMax),' er overskredet på dette sted!')"/>
							<FEJL>
								<xsl:value-of select="$TXT"/>
							</FEJL>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>

				<!-- Fødslen-->
				<S11>
					<Elm>
						<SubElm>11</SubElm>
					</Elm>
					<xsl:call-template name="GetGIS">
						<xsl:with-param name="StatusCode" select="$Letter/m:StatusCode"/>
					</xsl:call-template>
					<xsl:call-template name="GetEpisodeOfCareIdentifier">
						<xsl:with-param name="EpisodeOfCareIdentifier" select="$Letter/m:EpisodeOfCareIdentifier"/>
					</xsl:call-template>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>2</SubElm>
						</Elm>
					</SEQ>
					<DTM>
						<Elm>
							<SubElm>K03</SubElm>
							<SubElm>
								<xsl:value-of select="concat('00',$Birth/m:PregnancyDuration/m:Weeks,$Birth/m:PregnancyDuration/m:Days)"/>
							</SubElm>
							<SubElm>103</SubElm>
						</Elm>
					</DTM>

					<!-- Fødslen: aktionsdiagnose -->
					<xsl:if test="count($Birth/m:BirthPrincipalDiagnoses)>0">
						<CIN>
							<Elm>
								<SubElm>
									<xsl:call-template name="GetDiagnoseDescriptionCode">
										<xsl:with-param name="DiagnoseDescriptionCode"
											select="$Birth/m:BirthPrincipalDiagnoses/m:DiagnoseDescriptionCode"/>
									</xsl:call-template>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Birth/m:BirthPrincipalDiagnoses/m:DiagnoseCode"/>
								</SubElm>
								<xsl:call-template name="GetDiagnoseTypeCodeAndOrg">
									<xsl:with-param name="DiagnoseTypeCode" select="$Birth/m:BirthPrincipalDiagnoses/m:DiagnoseTypeCode"/>
								</xsl:call-template>
								<SubElm>
									<xsl:value-of select="$Birth/m:BirthPrincipalDiagnoses/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:if>

					<!-- Fødslen: evt. tillægsdiagnoser-->
					<xsl:if test="count($Birth/m:BirthAdditionalDiagnoses)>0">
						<xsl:for-each select="$Birth/m:BirthAdditionalDiagnoses">
							<xsl:variable name="NC" select="position()"/>
							<xsl:variable name="NCMax" select="5"/>
							<xsl:if test="$NC &lt; $NCMax+1">
								<CIN>
									<Elm>
										<SubElm>
											<xsl:call-template name="GetDiagnoseDescriptionCode">
												<xsl:with-param name="DiagnoseDescriptionCode"
													select="$Birth/m:BirthAdditionalDiagnoses[$NC]/m:DiagnoseDescriptionCode"/>
											</xsl:call-template>
										</SubElm>
									</Elm>
									<Elm>
										<SubElm>
											<xsl:value-of select="$Birth/m:BirthAdditionalDiagnoses[$NC]/m:DiagnoseCode"/>
										</SubElm>
										<xsl:call-template name="GetDiagnoseTypeCodeAndOrg">
											<xsl:with-param name="DiagnoseTypeCode" select="$Birth/m:BirthAdditionalDiagnoses[$NC]/m:DiagnoseTypeCode"
											/>
										</xsl:call-template>
										<SubElm>
											<xsl:value-of select="$Birth/m:BirthAdditionalDiagnoses[$NC]/m:DiagnoseText"/>
										</SubElm>
									</Elm>
								</CIN>
							</xsl:if>
							<xsl:if test="$NC &gt; $NCMax">
								<xsl:variable name="TXT" select="concat('Max. antal CIN-segmenter=', string($NCMax),' er overskredet på dette sted!')"/>
								<FEJL>
									<xsl:value-of select="$TXT"/>
								</FEJL>
							</xsl:if>

						</xsl:for-each>
					</xsl:if>
				</S11>

				<!-- Fødslen: evt. undersøgelser og behandlinger max. 5 S14-rep. a max. 9 CIN-segmenter-->
				<xsl:if test="count($Birth/m:BirthInvestigationAndTreatmentDiagnoses)>0">
					<xsl:for-each select="$Birth/m:BirthInvestigationAndTreatmentDiagnoses">
						<xsl:variable name="NC" select="position()"/>
						<xsl:variable name="NCMax" select="45"/>
						<xsl:variable name="Modtest" select="position() mod 9"/>
						<xsl:if test="$NC &lt; $NCMax+1">
							<xsl:choose>
								<xsl:when test="($Modtest=0 or $NC=1) and $NC != count($Birth/m:BirthInvestigationAndTreatmentDiagnoses)">
									<xsl:variable name="Segments" select="$Birth/m:BirthInvestigationAndTreatmentDiagnoses"/>

									<xsl:call-template name="MakeSegmentGroup">
										<xsl:with-param name="StartNbr" select="$NC"/>
										<xsl:with-param name="MaxPerGroup" select="9"/>
										<xsl:with-param name="NodeVar" select="$Birth/m:BirthInvestigationAndTreatmentDiagnoses"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:if>

						<xsl:if test="$NC &gt; $NCMax">
							<xsl:variable name="TXT" select="concat('Max. antal CIN-segmenter=', string($NCMax),' er overskredet på dette sted!')"/>
							<FEJL>
								<xsl:value-of select="$TXT"/>
							</FEJL>
						</xsl:if>

					</xsl:for-each>
				</xsl:if>

				<!-- Fødslen: Blødningsmængde og fostervand-->
				<S14>
					<Elm>
						<SubElm>14</SubElm>
					</Elm>
					<FTX maxOccurs="5">
						<Elm>
							<SubElm>K04</SubElm>
						</Elm>
						<Elm/>
						<Elm/>
						<Elm>
							<SubElm><xsl:for-each select="$Birth/m:BleedingVolume"><xsl:for-each select="text() | *"><xsl:apply-templates select="."/></xsl:for-each></xsl:for-each></SubElm>
						</Elm>
					</FTX>
				  <!--
				  <XFTX maxOccurs="9">
				    <Elm>
				      <SubElm>NC</SubElm>
				    </Elm>
				    <Elm/>
				    <Elm/>
				    <Elm>
				      <SubElm>
				        <xsl:for-each select="$ClinicalInfos[$index]/m:Text01">
				          <xsl:for-each select="text() | *">
				            <xsl:apply-templates select="."/>
				          </xsl:for-each></xsl:for-each>
				      </SubElm>
				    </Elm>
				  </XFTX>
				  -->
					<FTX maxOccurs="5">
						<Elm>
							<SubElm>K05</SubElm>
						</Elm>
						<Elm/>
						<Elm/>
						<Elm>
							<SubElm>
								<xsl:for-each select="$Birth/m:AmnioticFluidDescription">
									<xsl:for-each select="text() | *">
										<xsl:apply-templates select="."/>
									</xsl:for-each>
								</xsl:for-each>
							</SubElm>
						</Elm>
					</FTX>
				</S14>

				<!-- Fødslen: Andre oplysninger og Aftalt tid til jordemoderbesøg-->
				<xsl:if test="count($Birth/m:BirthAdditionalInfo)>0 or count($Birth/m:MaternityMotherAppointment)>0">
					<S14>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<xsl:if test="count($Birth/m:BirthAdditionalInfo)>0">
							<XFTX maxOccurs="9">
								<Elm>
									<SubElm>NC</SubElm>
								</Elm>
								<Elm/>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:for-each select="$Birth/m:BirthAdditionalInfo">
											<xsl:for-each select="text() | *">
												<xsl:apply-templates select="."/>
											</xsl:for-each>
										</xsl:for-each>
									</SubElm>
								</Elm>
							</XFTX>
						</xsl:if>
						<xsl:if test="count($Birth/m:MaternityMotherAppointment)>0">
							<FTX>
								<Elm>
									<SubElm>AFT</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm>
									<SubElm>
										<xsl:value-of select="$Birth/m:MaternityMotherAppointment"/>
									</SubElm>
								</Elm>
							</FTX>
						</xsl:if>
					</S14>
				</xsl:if>

				<!-- Børneoplysninger max. 5 rep.-->
				<xsl:for-each select="$ChildInfo">
					<xsl:variable name="NC" select="position()"/>
					<xsl:call-template name="GetChildInfo">
						<xsl:with-param name="ChildNbr" select="$NC"/>
						<xsl:with-param name="ChildInfo" select="$ChildInfo[$NC]"/>
						<xsl:with-param name="Letter" select="$Letter"/>
					</xsl:call-template>

				</xsl:for-each>

			</BrevIndhold>
			<UNT>
				<Elm>
					<SubElm>1</SubElm>
				</Elm>
				<Elm>
					<SubElm>
						<xsl:value-of select="$Letter/m:Identifier"/>
					</SubElm>
				</Elm>
			</UNT>
		</Brev>
	</xsl:template>

	<xsl:template name="MakeSegmentGroup">
		<xsl:param name="StartNbr"/>
		<xsl:param name="MaxPerGroup"/>
		<xsl:param name="NodeVar"/>
		<S14>
			<Elm>
				<SubElm>14</SubElm>
			</Elm>

			<xsl:for-each select="$NodeVar">
				<xsl:variable name="NC" select="position()"/>

				<xsl:if test="$StartNbr=1">
					<xsl:variable name="NCStart" select="$StartNbr - 1"/>
					<xsl:variable name="NCEnd" select="$StartNbr+$MaxPerGroup"/>

					<xsl:if test="$NC &gt; $NCStart and $NC &lt; $NCEnd">
						<xsl:call-template name="GetBirthCIN">
							<xsl:with-param name="NC" select="$NC"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>

				<xsl:if test="$StartNbr>1">
					<xsl:variable name="NCStart" select="$StartNbr"/>
					<xsl:variable name="NCEnd" select="$StartNbr+$MaxPerGroup+1"/>

					<xsl:if test="$NC &gt; $NCStart and $NC &lt; $NCEnd">
						<xsl:call-template name="GetBirthCIN">
							<xsl:with-param name="NC" select="$NC"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</S14>
	</xsl:template>

	<xsl:template name="GetBirthCIN">
		<xsl:param name="NC"/>
		<CIN>
			<Elm>
				<SubElm>
					<xsl:call-template name="GetDiagnoseDescriptionCode">
						<xsl:with-param name="DiagnoseDescriptionCode"
							select="//m:BirthInvestigationAndTreatmentDiagnoses[$NC]/m:DiagnoseDescriptionCode"/>
					</xsl:call-template>
				</SubElm>
			</Elm>
			<Elm>
				<SubElm>
					<xsl:value-of select="//m:BirthInvestigationAndTreatmentDiagnoses[$NC]/m:DiagnoseCode"/>
				</SubElm>
				<xsl:call-template name="GetDiagnoseTypeCodeAndOrg">
					<xsl:with-param name="DiagnoseTypeCode" select="//m:BirthInvestigationAndTreatmentDiagnoses[$NC]/m:DiagnoseTypeCode"/>
				</xsl:call-template>
				<SubElm>
					<xsl:value-of select="//m:BirthInvestigationAndTreatmentDiagnoses[$NC]/m:DiagnoseText"/>
				</SubElm>
			</Elm>
		</CIN>
	</xsl:template>


	<xsl:template name="GetGIS">
		<xsl:param name="StatusCode"/>
		<GIS>
			<Elm>
				<SubElm>
					<xsl:choose>
						<xsl:when test="$StatusCode='nytbrev' ">N</xsl:when>
						<xsl:when test="$StatusCode='rettetbrev' ">M</xsl:when>
						<xsl:otherwise>
							<FEJL> Kan ikke oversaette fra StatusCode til GIS: <xsl:value-of select="$StatusCode"/>
							</FEJL>
						</xsl:otherwise>
					</xsl:choose>
				</SubElm>
			</Elm>
		</GIS>
	</xsl:template>

	<xsl:template name="GetEpisodeOfCareIdentifier">
		<xsl:param name="EpisodeOfCareIdentifier"/>
		<xsl:if test="count(EpisodeOfCareIdentifier)=1">
			<RFF>
				<Elm>
					<SubElm>REI</SubElm>
					<SubElm>
						<xsl:value-of select="EpisodeOfCareIdentifier"/>
					</SubElm>
				</Elm>
			</RFF>
		</xsl:if>
		<xsl:if test="count(EpisodeOfCareIdentifier)=0">
			<RFF>
				<Elm>
					<SubElm>AHI</SubElm>
					<SubElm>1</SubElm>
				</Elm>
			</RFF>
		</xsl:if>
	</xsl:template>


	<xsl:template name="GetDiagnoseDescriptionCode">
		<xsl:param name="DiagnoseDescriptionCode"/>
		<xsl:choose>
			<xsl:when test="$DiagnoseDescriptionCode='uspec_diagnose' ">DI</xsl:when>
			<xsl:when test="$DiagnoseDescriptionCode='henv_diagnose' ">H</xsl:when>
			<xsl:when test="$DiagnoseDescriptionCode='bidiagnose' ">B</xsl:when>
			<xsl:when test="$DiagnoseDescriptionCode='aktionsdiagnose' ">A</xsl:when>
			<xsl:when test="$DiagnoseDescriptionCode='tillaegsdiagnose' ">DM</xsl:when>
			<xsl:when test="$DiagnoseDescriptionCode='midlertidig_diagnose' ">M</xsl:when>
			<xsl:when test="$DiagnoseDescriptionCode='forloebsdiagnose' ">S</xsl:when>
			<xsl:when test="$DiagnoseDescriptionCode='operation' ">TR</xsl:when>
			<xsl:when test="$DiagnoseDescriptionCode='roentgenundersoegelse' ">IN</xsl:when>
			<xsl:otherwise>
				<FEJL>Kan ikke oversaette DiagnoseDescriptionCode: <xsl:value-of select="$DiagnoseDescriptionCode"/></FEJL>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="GetDiagnoseTypeCodeAndOrg">
		<xsl:param name="DiagnoseTypeCode"/>
		<SubElm>
			<xsl:choose>
				<xsl:when test="$DiagnoseTypeCode='SKSdiagnosekode' ">SKS</xsl:when>
				<xsl:when test="$DiagnoseTypeCode='uspecificeretkode' ">USP</xsl:when>
				<xsl:when test="$DiagnoseTypeCode='ICPCkode' ">ICP</xsl:when>
			</xsl:choose>
		</SubElm>
		<SubElm>
			<xsl:choose>
				<xsl:when test="$DiagnoseTypeCode='SKSdiagnosekode' ">SST</xsl:when>
				<xsl:when test="$DiagnoseTypeCode='uspecificeretkode' ">NCD</xsl:when>
				<xsl:when test="$DiagnoseTypeCode='ICPCkode' ">ICP</xsl:when>
			</xsl:choose>
		</SubElm>
	</xsl:template>

	<xsl:template name="GetChildCIN">
		<xsl:param name="ChildInfo"/>
		<xsl:param name="OD"/>
		<CIN>
			<Elm>
				<SubElm>
					<xsl:call-template name="GetDiagnoseDescriptionCode">
						<xsl:with-param name="DiagnoseDescriptionCode" select="$ChildInfo/m:ChildOtherDiagnoses[$OD]/m:DiagnoseDescriptionCode"/>
					</xsl:call-template>
				</SubElm>
			</Elm>
			<Elm>
				<SubElm>
					<xsl:value-of select="$ChildInfo/m:ChildOtherDiagnoses[$OD]/m:DiagnoseCode"/>
				</SubElm>
				<xsl:call-template name="GetDiagnoseTypeCodeAndOrg">
					<xsl:with-param name="DiagnoseTypeCode" select="$ChildInfo/m:ChildOtherDiagnoses[$OD]/m:DiagnoseTypeCode"/>
				</xsl:call-template>
				<SubElm>
					<xsl:value-of select="$ChildInfo/m:ChildOtherDiagnoses[$OD]/m:DiagnoseText"/>
				</SubElm>
			</Elm>
		</CIN>
	</xsl:template>


	<!-- Børn: Diagnoser mm. -->
	<xsl:template name="GetChildInfo">
		<xsl:param name="ChildNbr"/>
		<xsl:param name="ChildInfo"/>
		<xsl:param name="Letter"/>

		<S11>
			<Elm>
				<SubElm>11</SubElm>
			</Elm>
			<xsl:call-template name="GetGIS">
				<xsl:with-param name="StatusCode" select="$Letter/m:StatusCode"/>
			</xsl:call-template>
			<xsl:call-template name="GetEpisodeOfCareIdentifier">
				<xsl:with-param name="EpisodeOfCareIdentifier" select="$Letter/m:EpisodeOfCareIdentifier"/>
			</xsl:call-template>
			<RFF>
				<Elm>
					<SubElm>PER</SubElm>
					<SubElm>1</SubElm>
				</Elm>
			</RFF>
			<SEQ>
				<Elm/>
				<Elm>
					<SubElm>
						<xsl:value-of select="$ChildNbr+2"/>
					</SubElm>
				</Elm>
			</SEQ>

			<!-- Børn: Aktionsdiagnose -->
			<xsl:if test="count($ChildInfo/m:ChildPrincipalDiagnoses)>0">
				<CIN>
					<Elm>
						<SubElm>
							<xsl:call-template name="GetDiagnoseDescriptionCode">
								<xsl:with-param name="DiagnoseDescriptionCode" select="$ChildInfo/m:ChildPrincipalDiagnoses/m:DiagnoseDescriptionCode"
								/>
							</xsl:call-template>
						</SubElm>
					</Elm>
					<Elm>
						<SubElm>
							<xsl:value-of select="$ChildInfo/m:ChildPrincipalDiagnoses/m:DiagnoseCode"/>
						</SubElm>
						<xsl:call-template name="GetDiagnoseTypeCodeAndOrg">
							<xsl:with-param name="DiagnoseTypeCode" select="$ChildInfo/m:ChildPrincipalDiagnoses/m:DiagnoseTypeCode"/>
						</xsl:call-template>
						<SubElm>
							<xsl:value-of select="$ChildInfo/m:ChildPrincipalDiagnoses/m:DiagnoseText"/>
						</SubElm>
					</Elm>
				</CIN>
			</xsl:if>

			<!-- Børn: Tillægsdiagnoser -->
			<xsl:if test="count($ChildInfo/m:ChildAdditionalDiagnoses)>0">
				<xsl:for-each select="$ChildInfo/m:ChildAdditionalDiagnoses">
					<xsl:variable name="NC" select="position()"/>
					<xsl:variable name="NCMax" select="5"/>
					<xsl:if test="$NC &lt; $NCMax+1">
						<CIN>
							<Elm>
								<SubElm>
									<xsl:call-template name="GetDiagnoseDescriptionCode">
										<xsl:with-param name="DiagnoseDescriptionCode"
											select="$ChildInfo/m:ChildAdditionalDiagnoses[$NC]/m:DiagnoseDescriptionCode"/>
									</xsl:call-template>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ChildAdditionalDiagnoses[$NC]/m:DiagnoseCode"/>
								</SubElm>
								<xsl:call-template name="GetDiagnoseTypeCodeAndOrg">
									<xsl:with-param name="DiagnoseTypeCode" select="$ChildInfo/m:ChildAdditionalDiagnoses[$NC]/m:DiagnoseTypeCode"/>
								</xsl:call-template>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ChildAdditionalDiagnoses[$NC]/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:if>
					<xsl:if test="$NC &gt; $NCMax">
						<xsl:variable name="TXT" select="concat('Max. antal CIN-segmenter=', string($NCMax),' er overskredet på dette sted!')"/>
						<FEJL>
							<xsl:value-of select="$TXT"/>
						</FEJL>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>

			<!-- Børn: Øvrige diagnoser -->
			<xsl:if test="count($ChildInfo/m:ChildOtherDiagnoses)>0">
				<xsl:for-each select="$ChildInfo/m:ChildOtherDiagnoses">
					<xsl:variable name="NC" select="position()"/>
					<xsl:variable name="NCMax" select="27"/>
					<xsl:variable name="Modtest" select="position() mod 9"/>
					<xsl:variable name="MaxPerGroup" select="9"/>
					<xsl:if test="$NC &lt; $NCMax+1">
						<xsl:choose>
							<xsl:when test="($Modtest=0 or $NC=1) and $NC != count($ChildInfo/m:ChildOtherDiagnoses)">
								<S14>
									<Elm>
										<SubElm>14</SubElm>
									</Elm>

									<xsl:for-each select="$ChildInfo/m:ChildOtherDiagnoses">
										<xsl:variable name="OD" select="position()"/>
										<xsl:if test="$NC=1">
											<xsl:variable name="NCStart" select="$NC - 1"/>
											<xsl:variable name="NCEnd" select="$NC+$MaxPerGroup"/>

											<xsl:if test="$OD &gt; $NCStart and $OD &lt; $NCEnd">
												<xsl:call-template name="GetChildCIN">
													<xsl:with-param name="ChildInfo" select="$ChildInfo"/>
													<xsl:with-param name="OD" select="$OD"/>
												</xsl:call-template>
											</xsl:if>
										</xsl:if>

										<xsl:if test="$NC>1">
											<xsl:variable name="NCStart" select="$NC"/>
											<xsl:variable name="NCEnd" select="$NC+$MaxPerGroup+1"/>

											<xsl:if test="$OD &gt; $NCStart and $OD &lt; $NCEnd">
												<xsl:call-template name="GetChildCIN">
													<xsl:with-param name="ChildInfo" select="$ChildInfo"/>
													<xsl:with-param name="OD" select="$OD"/>
												</xsl:call-template>
											</xsl:if>
										</xsl:if>
									</xsl:for-each>
								</S14>

							</xsl:when>
							<xsl:otherwise> </xsl:otherwise>
						</xsl:choose>
					</xsl:if>

					<xsl:if test="$NC &gt; $NCMax">
						<xsl:variable name="TXT" select="concat('Max. antal CIN-segmenter=', string($NCMax),' er overskredet på dette sted!')"/>
						<FEJL>
							<xsl:value-of select="$TXT"/>
						</FEJL>
					</xsl:if>

				</xsl:for-each>

			</xsl:if>
			<!-- Børn: Vægt, længde, hovedomfang og Apgarscore -->
			<xsl:if test="count($ChildInfo/m:ChildDimensions)>0 or count($ChildInfo/m:ApgarScore)>0">
				<S14>
					<Elm>
						<SubElm>14</SubElm>
					</Elm>
					<xsl:if test="count($ChildInfo/m:ChildDimensions)>0">
						<FTX>
							<Elm>
								<SubElm>K06</SubElm>
							</Elm>
							<Elm>
								<SubElm>P00</SubElm>
							</Elm>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ChildDimensions/m:Weight"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ChildDimensions/m:Length"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ChildDimensions/m:HeadCircumference"/>
								</SubElm>
							</Elm>
						</FTX>
					</xsl:if>
					<xsl:if test="count($ChildInfo/m:ApgarScore)>0">
						<FTX>
							<Elm>
								<SubElm>K07</SubElm>
							</Elm>
							<Elm>
								<SubElm>P00</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ApgarScore/m:ScoreAfterOneMin"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ApgarScore/m:ScoreAfterFiveMin"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ApgarScore/m:ScoreAfterTenMin"/>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ApgarScore/m:MinutesAtScoreTen"/>
								</SubElm>
							</Elm>
						</FTX>
					</xsl:if>
				</S14>
			</xsl:if>
			<!-- Børn: Øvrige oplysninger -->
			<xsl:if test="count($ChildInfo/m:ChildAdditionalInfo)>0 or count($ChildInfo/m:ChildTransferral)>0">
				<S14>
					<Elm>
						<SubElm>14</SubElm>
					</Elm>
					<xsl:if test="count($ChildInfo/m:ChildAdditionalInfo)>0">
						<XFTX maxOccurs="9">
							<Elm>
								<SubElm>NC</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:for-each select="$ChildInfo/m:ChildAdditionalInfo">
										<xsl:for-each select="text() | *">
											<xsl:apply-templates select="."/>
										</xsl:for-each>
									</xsl:for-each>
								</SubElm>
							</Elm>
						</XFTX>
					</xsl:if>
					<xsl:if test="count($ChildInfo/m:ChildTransferral)>0">
						<FTX>
							<Elm>
								<SubElm>OVF</SubElm>
							</Elm>
							<Elm>
								<SubElm>P00</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$ChildInfo/m:ChildTransferral"/>
								</SubElm>
							</Elm>
						</FTX>
					</xsl:if>
				</S14>
			</xsl:if>
		</S11>
	</xsl:template>

	<!-- FTX formatted -->
	<xsl:template match="m:Space">
		<Space/>
	</xsl:template>
	<xsl:template match="m:Break">
		<Break/>
	</xsl:template>
	<xsl:template match="m:Bold">
		<Bold>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Bold>
	</xsl:template>
	<xsl:template match="m:Italic">
		<Italic>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Italic>
	</xsl:template>
	<xsl:template match="m:Underline">
		<Underline>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Underline>
	</xsl:template>
	<xsl:template match="m:Right">
		<Right>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Right>
	</xsl:template>
	<xsl:template match="m:Center">
		<Center>
			<xsl:for-each select="text() | *">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</Center>
	</xsl:template>
	<xsl:template match="m:FixedFont"><FixedFont><xsl:for-each select="text() | *"><xsl:apply-templates select="."/></xsl:for-each></FixedFont>
	</xsl:template>

</xsl:stylesheet>
