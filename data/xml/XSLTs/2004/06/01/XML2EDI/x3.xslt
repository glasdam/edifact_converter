<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2004/06/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- DISCHARGELETTER -->
	<xsl:template match="m:CasualtyWardLetter">
		<xsl:variable name="Letter" select="m:Letter"/>
		<xsl:variable name="Sender" select="m:Sender"/>
		<xsl:variable name="Contact" select="$Sender/m:Contact"/>
		<xsl:variable name="Receiver" select="m:Receiver"/>
		<xsl:variable name="CCReceiver" select="m:CCReceiver"/>
		<xsl:variable name="Patient" select="m:Patient"/>
		<xsl:variable name="Relatives" select="m:Relative"/>
		<xsl:variable name="Referral" select="m:Referral"/>
		<xsl:variable name="RefDiag" select="$Referral/m:Refer"/>
		<xsl:variable name="RefAddDiags" select="$Referral/m:ReferalAdditional"/>
		<xsl:variable name="CasualtyWardFirstVisit" select="m:CasualtyWardFirstVisit"/>
		<xsl:variable name="CasualtyWardLastVisit" select="m:CasualtyWardLastVisit"/>
		<xsl:variable name="Diags" select="m:Diagnose"/>
		<xsl:variable name="MainDiag" select="$Diags/m:Main"/>
		<xsl:variable name="MainAddDiags" select="$Diags/m:MainAdditional"/>
		<xsl:variable name="OtherDiags" select="$Diags/m:Other"/>
		<xsl:variable name="ClinInfos" select="m:ClinicalInformation"/>
		<xsl:variable name="Refs" select="m:Reference"/>
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
					<SubElm>D0333L</SubElm>
				</Elm>
				<Elm>
					<SubElm>DIS03</SubElm>
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
							<xsl:variable name="DT203" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
							<xsl:value-of select="$DT203"/>
						</SubElm>
						<SubElm>203</SubElm>
					</Elm>
				</DTM>
				<!-- SENDER -->
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
									<xsl:when test="$IC='lokationsnummer' ">EAN</xsl:when>
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
								<SubElm><xsl:value-of select="$Sender/m:TelephoneSubscriberIdentifier"/></SubElm>
								<SubElm>TE</SubElm>
							</Elm>
						</CON>
					</xsl:if>

					<SEQ>
						<Elm>
							</Elm>
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
									<xsl:when test=" $MSC='paediatri_sygehus'">80</xsl:when>
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
							<SubElm>DIS03</SubElm>
							<SubElm>SKS</SubElm>
							<SubElm>SST</SubElm>
						</Elm>
					</SPR>
				</S01>
				<!-- Receiver -->
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
									<xsl:when test="$IC='lokationsnummer' ">EAN</xsl:when>
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
								<xsl:if test="count($Participant/m:OrganisationName)=1"><xsl:value-of select="$Participant/m:OrganisationName"/></xsl:if>
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
				<!-- CCReceiver -->
				<xsl:if test="count($CCReceiver)=1">
					<S01>
						<xsl:variable name="Participant" select="$CCReceiver"/>
						<Elm>
							<SubElm>01</SubElm>
						</Elm>
						<NAD>
							<Elm>
								<SubElm>CCR</SubElm>
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
										<xsl:when test="$IC='lokationsnummer' ">EAN</xsl:when>
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
									<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
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
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>3</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				<xsl:if test="count($Contact)=1">
					<S01>
						<xsl:variable name="Participant" select="$Contact"/>
						<Elm>
							<SubElm>01</SubElm>
						</Elm>
						<NAD>
							<Elm>
								<SubElm>RSP</SubElm>
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
										<xsl:when test="$IC='lokationsnummer' ">EAN</xsl:when>
										<xsl:when test="count($IC)=0"/>
										<xsl:when test="$IC='kommunenummer' ">KOM</xsl:when>
										<xsl:when test="$IC='sorkode'">SOR</xsl:when>
										<xsl:otherwise>
											<FEJL>
												Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$IC"/>
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
									<xsl:if test="count($Participant/m:OrganisationName)=0">_</xsl:if>
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
						<SEQ>
							<Elm/>
							<Elm>
								<SubElm>
									<xsl:if test="count($CCReceiver)=0">3</xsl:if>
									<xsl:if test="count($CCReceiver)=1">4</xsl:if>
								</SubElm>
							</Elm>
						</SEQ>
					</S01>
				</xsl:if>
				<S02>
					<Elm>
						<SubElm>02</SubElm>
					</Elm>
					<GIS>
						<Elm>
							<SubElm>
								<xsl:variable name="C" select="$Letter/m:StatusCode"/>
								<xsl:choose>
									<xsl:when test="$C='nytbrev' ">N</xsl:when>
									<xsl:when test="$C='rettetbrev' ">M</xsl:when>
									<xsl:otherwise>
										<FEJL>
											Kan ikke oversaette fra StatusCode til GIS: <xsl:value-of select="$C"/>
										</FEJL>
									</xsl:otherwise>
								</xsl:choose>
							</SubElm>
						</Elm>
					</GIS>
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
								<xsl:variable name="DT203" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
								<xsl:value-of select="$DT203"/>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
				</S02>
				<!-- Referral -->
				<xsl:if test="count($Referral)=1">
				<S05>
					<Elm>
						<SubElm>05</SubElm>
					</Elm>
					<GIS>
						<Elm>
							<SubElm>N</SubElm>
						</Elm>
					</GIS>
					<xsl:if test="count($Referral/m:Identifier)=1">
						<RFF>
							<Elm>
								<SubElm>ROI</SubElm>
								<SubElm>
									<xsl:value-of select="$Referral/m:Identifier"/>
								</SubElm>
							</Elm>
						</RFF>
					</xsl:if>
					<xsl:if test="count($Referral/m:Received)=1">
						<DTM>
							<Elm>
								<SubElm>8</SubElm>
								<SubElm>
									<xsl:variable name="DT" select="$Referral/m:Received"/>
									<xsl:variable name="DT203" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
									<xsl:value-of select="$DT203"/>
								</SubElm>
								<SubElm>203</SubElm>
							</Elm>
						</DTM>
					</xsl:if>
					<CIN>
						<xsl:variable name="Diagnose" select="$RefDiag"/>
						<Elm>
							<SubElm>DI</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
							</SubElm>
							<SubElm>
								<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SKS</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' ">USP</xsl:when>
										<xsl:when test="$DTC='ICPCkode' ">ICP</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
							</SubElm>
							<SubElm>
								<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SST</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' "></xsl:when>
										<xsl:when test="$DTC='ICPCkode' "></xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
							</SubElm>
							<SubElm>
								<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
							</SubElm>
						</Elm>
					</CIN>
					<xsl:for-each select="$RefAddDiags">
						<CIN>
							<xsl:variable name="Diagnose" select="."/>
							<Elm>
								<SubElm>DM</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
								</SubElm>
								<SubElm>
									<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SKS</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' ">USP</xsl:when>
										<xsl:when test="$DTC='ICPCkode' ">ICP</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
										<xsl:choose>
											<xsl:when test="$DTC='SKSdiagnosekode' ">SST</xsl:when>
											<xsl:when test="$DTC='uspecificeretkode' "></xsl:when>
											<xsl:when test="$DTC='ICPCkode' "></xsl:when>
											<xsl:otherwise>
												<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:for-each>
				</S05>
				</xsl:if>
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
							<SubElm><xsl:if test="count($Person/m:PersonGivenName)=1">FO</xsl:if></SubElm>
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
					<xsl:if test="count($Patient/m:OccupancyText)=1">
						<EMP>
							<Elm>
								<SubElm>1</SubElm>
							</Elm>
							<Elm>
							</Elm>
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
				<!-- Relative -->
				<xsl:for-each select="$Relatives">
					<S09>
						<xsl:variable name="Person" select="."/>
						<Elm>
							<SubElm>09</SubElm>
						</Elm>
						<REL>
							<Elm>
								<SubElm>PER</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:variable name="RC" select="m:RelationCode"/>
									<xsl:choose>
										<xsl:when test="$RC='uspec_paaroerende'">GU</xsl:when>
										<xsl:when test="$RC='mor'">MO</xsl:when>
										<xsl:when test="$RC='far'">FA</xsl:when>
										<xsl:when test="$RC='barn'">SD</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte kode for pårørende: <xsl:value-of select="$RC"/>
											</FEJL>
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
									<xsl:value-of select="m:PersonIdentifier"/>
								</SubElm>
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
								<SubElm><xsl:if test="count($Person/m:PersonGivenName)=1">FO</xsl:if></SubElm>
								<SubElm>
									<xsl:value-of select="$Person/m:PersonGivenName"/>
								</SubElm>
							</Elm>
						</PNA>
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
					</S09>
				</xsl:for-each>
				<!-- -->
				<S11>
					<Elm>
						<SubElm>11</SubElm>
					</Elm>
					<GIS>
						<Elm>
							<SubElm>N</SubElm>
						</Elm>
					</GIS>
					<xsl:if test="count($Letter/m:EpisodeOfCareIdentifier)=1">
						<RFF>
							<Elm>
								<SubElm>REI</SubElm>
								<SubElm>
									<xsl:value-of select="$Letter/m:EpisodeOfCareIdentifier"/>
								</SubElm>
							</Elm>
						</RFF>
					</xsl:if>
					<xsl:if test="count($Letter/m:EpisodeOfCareIdentifier)=0">
						<RFF>
							<Elm>
								<SubElm>AHI</SubElm>
								<SubElm>1</SubElm>
							</Elm>
						</RFF>
					</xsl:if>
					<SEQ>
						<Elm/>
						<Elm>
							<SubElm>1</SubElm>
						</Elm>
					</SEQ>
					<xsl:if test="count($CasualtyWardFirstVisit)=1">
					<DTM>
						<Elm>
							<SubElm>90</SubElm>
							<SubElm>
								<xsl:variable name="DT" select="$CasualtyWardFirstVisit"/>
								<xsl:variable name="DT203" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
								<xsl:value-of select="$DT203"/>
							</SubElm>
							<SubElm>203</SubElm>
						</Elm>
					</DTM>
					</xsl:if>
					<xsl:if test="count($CasualtyWardLastVisit)=1">
						<DTM>
							<Elm>
								<SubElm>91</SubElm>
								<SubElm>
									<xsl:variable name="DT" select="$CasualtyWardLastVisit"/>
									<xsl:variable name="DT203" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
									<xsl:value-of select="$DT203"/>
								</SubElm>
								<SubElm>203</SubElm>
							</Elm>
						</DTM>
					</xsl:if>
						<PAS>
							<Elm>
								<SubElm>
									<xsl:variable name="EOCSC" select="$Patient/m:EpisodeOfCareStatusCode"/>
									<xsl:choose>
										<xsl:when test="count($EOCSC)=0 ">POT</xsl:when>
										<xsl:when test="$EOCSC='inaktiv' ">POT</xsl:when>
										<xsl:when test="$EOCSC='indlagt' ">HS</xsl:when>
										<xsl:when test="$EOCSC='ambulant' ">HA</xsl:when>
										<xsl:when test="$EOCSC='doed' ">DA</xsl:when>
										<xsl:when test="$EOCSC='ambulant_roentgen' ">REQ</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversaette til EpisodeOfCareStatusCode: <xsl:value-of select="$EOCSC"/></FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
						</PAS>
					
					<xsl:if test="count($MainDiag)=1">
					<CIN>
						<xsl:variable name="Diagnose" select="$MainDiag"/>
						<Elm>
							<SubElm>A</SubElm>
						</Elm>
						<Elm>
							<SubElm>
								<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
							</SubElm>
							<SubElm>SKS</SubElm>
							<SubElm>SST</SubElm>
							<SubElm>
								<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
							</SubElm>
						</Elm>
					</CIN>
					
					</xsl:if>
					<xsl:for-each select="$MainAddDiags">
						<CIN>
							<xsl:variable name="Diagnose" select="."/>
							<Elm>
								<SubElm>DM</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
								</SubElm>
								<SubElm>SKS</SubElm>
								<SubElm>SST</SubElm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
					</xsl:for-each>
				</S11>
				<!-- Other Diagnoses -->
				<xsl:for-each select="$OtherDiags">
					<S14>
						<xsl:variable name="Diagnose" select="."/>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<CIN>
							<Elm>
								<SubElm>
									<xsl:variable name="Desc" select="$Diagnose/m:DiagnoseDescriptionCode"/>
									<xsl:choose>
										<xsl:when test="$Desc='uspec_diagnose'">DI</xsl:when>
										<xsl:when test="$Desc='henv_diagnose'">H</xsl:when>
										<xsl:when test="$Desc='bidiagnose'">B</xsl:when>
										<xsl:when test="$Desc='tillaegsdiagnose'">DM</xsl:when>
										<xsl:when test="$Desc='aktionsdiagnose'">A</xsl:when>
										<xsl:when test="$Desc='grundmorbus'">G</xsl:when>
										<xsl:when test="$Desc='midlertidig_diagnose'">M</xsl:when>
										<xsl:when test="$Desc='forloebsdiagnose'">S</xsl:when>
										<xsl:when test="$Desc='operation'">TR</xsl:when>
										<xsl:when test="$Desc='roentgenundersoegelse'">IN</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseDescriptionCode: <xsl:value-of select="$Desc"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
							</Elm>
							<Elm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseCode"/>
								</SubElm>
								<SubElm>
									<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SKS</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' ">USP</xsl:when>
										<xsl:when test="$DTC='ICPCkode' ">ICP</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
										<xsl:choose>
											<xsl:when test="$DTC='SKSdiagnosekode' ">SST</xsl:when>
											<xsl:when test="$DTC='uspecificeretkode' "></xsl:when>
											<xsl:when test="$DTC='ICPCkode' "></xsl:when>
											<xsl:otherwise>
												<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
												</FEJL>
											</xsl:otherwise>
										</xsl:choose>
								</SubElm>
								<SubElm>
									<xsl:value-of select="$Diagnose/m:DiagnoseText"/>
								</SubElm>
							</Elm>
						</CIN>
						<xsl:if test="count($Diagnose/m:DiagnoseDateTime)=1">
							<DTM>
								<Elm>
									<SubElm>CIS</SubElm>
									<SubElm>
										<xsl:variable name="DT" select="$Diagnose/m:DiagnoseDateTime"/>
										<xsl:variable name="DT203" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
										<xsl:value-of select="$DT203"/>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:if>
					</S14>
				</xsl:for-each>
			<!--	<TEST>
						<Elm>
							<SubElm></SubElm>
							<SubElm></SubElm>
							<SubElm>x</SubElm>
							<SubElm></SubElm>
							<SubElm></SubElm>
							<SubElm></SubElm>
						</Elm>
						<Elm>
							<SubElm></SubElm>
							<SubElm>y</SubElm>
							<SubElm></SubElm>
							<SubElm></SubElm>
							<SubElm></SubElm>
							<SubElm></SubElm>
						</Elm>
						<Elm>
							<SubElm></SubElm>
							<SubElm></SubElm>
							<SubElm></SubElm>
							<SubElm></SubElm>
							<SubElm></SubElm>
							<SubElm></SubElm>
						</Elm>
					</TEST>-->
				<xsl:for-each select="$ClinInfos">
					<S14>
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<xsl:if test="count(m:Signed)>0">
							<DTM>
								<Elm>
									<SubElm>CIC</SubElm>
									<SubElm>
										<xsl:variable name="DT" select="m:Signed"/>
										<xsl:variable name="DT203" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
										<xsl:value-of select="$DT203"/>
									</SubElm>
									<SubElm>203</SubElm>
								</Elm>
							</DTM>
						</xsl:if>
						<XFTX maxOccurs="9">
							<Elm>
								<SubElm>NC</SubElm>
							</Elm>
							<Elm/>
							<Elm/>
							<Elm>
								<SubElm><xsl:for-each select="m:Text01"><xsl:for-each select="text() | *"><xsl:apply-templates select="."/></xsl:for-each></xsl:for-each>
									<!--<xsl:value-of select="m:Text01"/>-->
								</SubElm>
							</Elm>
						</XFTX>
					</S14>
					<xsl:if test="count($Refs)>0">
					<S14 maxOccurs="2">
						<Elm>
							<SubElm>14</SubElm>
						</Elm>
						<XFTX maxOccurs="9">
							<xsl:for-each select="$Refs">
								<Elm>
									<SubElm>
										<xsl:choose>
											<xsl:when test="count(m:SUP)=1">SUP</xsl:when>
											<xsl:when test="count(m:URL)=1">URL</xsl:when>
											<xsl:when test="count(m:BIN)=1">BIN</xsl:when>
											<xsl:otherwise>
									</xsl:otherwise>
										</xsl:choose>
									</SubElm>
								</Elm>
								<Elm>
									<SubElm>P00</SubElm>
								</Elm>
								<Elm/>
								<Elm>
									<SubElm>
										<xsl:value-of select="m:RefDescription"/>
										<Break/>
										<xsl:choose>
											<xsl:when test="count(m:SUP)=1"/>
											<xsl:when test="count(m:URL)=1">
												<xsl:value-of select="m:URL"/>
											</xsl:when>
											<xsl:when test="count(m:BIN)">
												<xsl:value-of select="m:BIN/m:ObjectIdentifier"/>
												<Break/>
												<xsl:for-each select="m:BIN/m:ObjectCode"><xsl:call-template name="ObjectCodeToValue"/></xsl:for-each>
												<Break/>
												<xsl:for-each select="m:BIN/m:ObjectExtensionCode">
													<xsl:call-template name="ObjectExtensionCodeToValue"/>
												</xsl:for-each>
												<Break/>
												<xsl:value-of select="m:BIN/m:OriginalObjectSize"/>
											</xsl:when>
											<xsl:otherwise></xsl:otherwise>
										</xsl:choose>
									</SubElm>
								</Elm>
							</xsl:for-each>
						</XFTX>
					</S14>
				</xsl:if>

				</xsl:for-each>
			</BrevIndhold>
			<UNT>
				<Elm>
					<SubElm>1</SubElm>
				</Elm>
				<Elm>
					<SubElm><xsl:value-of select="$Letter/m:Identifier"/></SubElm>
				</Elm>
			</UNT>
		</Brev>
	</xsl:template>
	<xsl:template match="m:Space"><Space/></xsl:template>
	<xsl:template match="m:Break"><Break/></xsl:template>
	<xsl:template match="m:Bold"><Bold><xsl:for-each select="text() | *"><xsl:apply-templates select="."/></xsl:for-each></Bold></xsl:template>
	<xsl:template match="m:Italic"><Italic><xsl:for-each select="text() | *"><xsl:apply-templates select="."/></xsl:for-each></Italic></xsl:template>
	<xsl:template match="m:Underline"><Underline><xsl:for-each select="text() | *"><xsl:apply-templates select="."/></xsl:for-each></Underline></xsl:template>
	<xsl:template match="m:Right"><Right><xsl:for-each select="text() | *"><xsl:apply-templates select="."/></xsl:for-each></Right></xsl:template>
	<xsl:template match="m:Center"><Center><xsl:for-each select="text() | *"><xsl:apply-templates select="."/></xsl:for-each></Center></xsl:template>
	<xsl:template match="m:FixedFont"><FixedFont><xsl:for-each select="text() | *"><xsl:apply-templates select="."/></xsl:for-each></FixedFont></xsl:template>


</xsl:stylesheet>
<!--	<xsl:variable name="DTC" select="$Diagnose/m:DiagnoseTypeCode"/>
									<xsl:choose>
										<xsl:when test="$DTC='SKSdiagnosekode' ">SKS</xsl:when>
										<xsl:when test="$DTC='uspecificeretkode' ">USP</xsl:when>
										<xsl:when test="$DTC='ICPCkode' ">ICP</xsl:when>
										<xsl:otherwise>
											<FEJL>Kan ikke oversætte DiagnoseTypeCode: <xsl:value-of select="$DTC"/>
											</FEJL>
										</xsl:otherwise>
									</xsl:choose>-->