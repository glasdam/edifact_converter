<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="m:MedicalSpecialityCode">
		<xsl:variable name="MSC" select="."/>
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
	</xsl:template>
</xsl:stylesheet>
