<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2015/02/16/" version="1.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="*">
    <FEJL>Ukendt element: <xsl:value-of select="name()"/>
    </FEJL>
  </xsl:template>
  <xsl:template name="DateToDTM102">
    <xsl:param name="D" select="."/>
    <xsl:variable name="D102" select="concat(substring($D,1,4),substring($D,6,2),substring($D,9,2))"/>
    <xsl:value-of select="$D102"/>
  </xsl:template>
  <xsl:template name="DateTimeToDTM203">
    <xsl:param name="DT" select="."/>
    <xsl:variable name="DT203"
      select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
    <xsl:value-of select="$DT203"/>
  </xsl:template>
  <xsl:template name="DateTimeWithSecToDTM204">
    <xsl:param name="DT" select="."/>
    <xsl:variable name="DT204"
      select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:TimeWithSec,1,2),substring($DT/m:TimeWithSec,4,2),substring($DT/m:TimeWithSec,7,2))"/>
    <xsl:if test="string-length($DT204)=14">
      <xsl:value-of select="$DT204"/>
    </xsl:if>
    <xsl:if test="string-length($DT204)=12">
      <xsl:value-of select="concat($DT204,'00')"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="m:MedicalSpecialityCode">
    <xsl:call-template name="MedicalSpecialityCodeToAFSSPEC"/>
  </xsl:template>
  <xsl:template name="MedicalSpecialityCodeToAFSSPEC">
    <xsl:param name="MSC" select="."/>
    <xsl:if test="count($MSC)=1">
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
	<xsl:when test=" $MSC='patologi'">2522</xsl:when>
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
	<xsl:when test=" $MSC='blandet'">00</xsl:when>
	<xsl:when test=" $MSC='palliativ'">14</xsl:when>
	<xsl:when test=" $MSC='akut'">15</xsl:when>
	<xsl:when test=" $MSC='sexologi'">39</xsl:when>
	<xsl:when test=" $MSC='paediatri_sygehus'">80</xsl:when>
	<xsl:when test=" $MSC='retsmedicin'">92</xsl:when>
	<xsl:when test=" $MSC='fysioterapi_sygehus'">98</xsl:when>
	<xsl:when test=" $MSC='almenlaege_vagtkoersel'">0581</xsl:when>
	<xsl:when test=" $MSC='almenlaege_vagtlaegehjaelp'">0582</xsl:when>
	<xsl:when test=" $MSC='vagtlaege'">1080</xsl:when>
	<xsl:when test=" $MSC='vagtlaegehjaelp'">1083</xsl:when>
	<xsl:when test=" $MSC='vagtlaegehjaelp_kbh'">1082</xsl:when>
	<xsl:when test=" $MSC='neurokirurgi_praksis'">2517</xsl:when>
	<xsl:when test=" $MSC='tandplejere'">4049</xsl:when>
	<xsl:when test=" $MSC='ridefysioterapi'">4557</xsl:when>
	<xsl:when test=" $MSC='fysioterapi_vederlagsfri'">4562</xsl:when>
	<xsl:when test=" $MSC='ridefysioterapi_vederlagsfri'">4565</xsl:when>
	<xsl:when test=" $MSC='teddy'">4658</xsl:when>
	<xsl:when test=" $MSC='kiropraktor_64'">5064</xsl:when>
	<xsl:when test=" $MSC='fodterapi_radioaktiv'">6059</xsl:when>
	<xsl:when test=" $MSC='fodterapi_leddegigt'">6060</xsl:when>
	<xsl:when test=" $MSC='med_laboratorier_kpll'">7044</xsl:when>
	<xsl:when test=" $MSC='med_laboratorier_ssi'">7048</xsl:when>
        <xsl:otherwise>
          <FEJL>Ukendt MedicalSpecialityCode: <xsl:value-of select="$MSC"/>
          </FEJL>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <!-- Afregning fra Mikkel Kruse -->
  <xsl:template name="SpecialityCodeToAFSSPEC">
    <xsl:param name="SC" select="."/>
    <xsl:if test="count($SC)=1">
      <xsl:choose>
        <xsl:when test=" $SC='anaestesi'">01</xsl:when>
        <xsl:when test=" $SC='diagnostisk_radiologi_koebenhavn'">03</xsl:when>
        <xsl:when test=" $SC='dermatologi_venerologi'">04</xsl:when>
        <xsl:when test=" $SC='radiologi'">05</xsl:when>
        <xsl:when test=" $SC='reumatologi'">06</xsl:when>
        <xsl:when test=" $SC='gynaekologi_obstetrik'">07</xsl:when>
        <xsl:when test=" $SC='intern_medicin'">08</xsl:when>
        <xsl:when test=" $SC='kirurgi'">09</xsl:when>
        <xsl:when test=" $SC='neuromedicin'">18</xsl:when>
        <xsl:when test=" $SC='oejenlaege'">19</xsl:when>
        <xsl:when test=" $SC='ortopaedisk_kirurgi'">20</xsl:when>
        <xsl:when test=" $SC='oere_naese_halslaege'">21</xsl:when>
        <xsl:when test=" $SC='patologi'">22</xsl:when>
        <xsl:when test=" $SC='plastikkirurgi'">23</xsl:when>
        <xsl:when test=" $SC='psykiatri'">24</xsl:when>
        <xsl:when test=" $SC='paediatri'">25</xsl:when>
        <xsl:when test=" $SC='boernepsykiatri'">26</xsl:when>
        <xsl:when test=" $SC='tropemedicin'">28</xsl:when>
        <xsl:when test=" $SC='tandlaege'">50</xsl:when>
        <xsl:when test=" $SC='fysioterapi'">51</xsl:when>
        <xsl:when test=" $SC='kiropraktor'">53</xsl:when>
        <xsl:when test=" $SC='fodterapi_sukkersyge'">54</xsl:when>
        <xsl:when test=" $SC='fodterapi_unquis_incarnatus'">55</xsl:when>
        <xsl:when test=" $SC='ridefysioterapi'">57</xsl:when>
        <xsl:when test=" $SC='fodterapi_foelger_radioaktiv_bestraaling'">59</xsl:when>
        <xsl:when test=" $SC='vederlagsfri_fysioterapi'">62</xsl:when>
        <xsl:when test=" $SC='psykolog'">63</xsl:when>
        <xsl:when test=" $SC='kiropraktik_ordning_64'">64</xsl:when>
        <xsl:when test=" $SC='vederlagsfri_ridefysioterapi'">65</xsl:when>
        <xsl:when test=" $SC='alment_praktiserende_laege'">80</xsl:when>
        <xsl:otherwise>
          <FEJL>Ukendt SpecialityCode: <xsl:value-of select="$SC"/>
          </FEJL>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template name="VersionCodeToType">
    <xsl:param name="VersionCode" select="."/>
    <xsl:choose>
      <xsl:when test="$VersionCode='D0633L' ">MEDDIS</xsl:when>
      <xsl:when test="$VersionCode='D0733L' ">MEDDIS</xsl:when>
      <xsl:when test="$VersionCode='XD0633L' ">XMEDDIS</xsl:when>
      <xsl:when test="$VersionCode='XD0733L' ">XMEDDIS</xsl:when>
      <xsl:otherwise>Ukendt</xsl:otherwise>
      <!--<FEJL>Ukendt version <xsl:value-of select="$VersionCode"/>
				</FEJL>-->
    </xsl:choose>
  </xsl:template>
  <xsl:template name="ObjectCodeToValue">
    <xsl:param name="OC" select="."/>
    <xsl:choose>
      <xsl:when test="$OC='tekstfil'">TXT</xsl:when>
      <xsl:when test="$OC='billede'">IMG</xsl:when>
      <xsl:when test="$OC='program'">PRG</xsl:when>
      <xsl:when test="$OC='vektor_grafik'">VGR</xsl:when>
      <xsl:when test="$OC='biosignaler'">BSG</xsl:when>
      <xsl:when test="$OC='multimedie'">MUL</xsl:when>
      <xsl:when test="$OC='proprietaert_indhold'">PRP</xsl:when>
      <xsl:otherwise>
        <FEJL>Ukendt OBJEKTTYPE<xsl:value-of select="$OC"/>
        </FEJL>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="ObjectExtensionCodeToValue">
    <xsl:param name="OEC" select="."/>
    <xsl:choose>
      <xsl:when test="$OEC='pcx'">PCX</xsl:when>
      <xsl:when test="$OEC='tiff'">TIF</xsl:when>
      <xsl:when test="$OEC='jpeg'">JPG</xsl:when>
      <xsl:when test="$OEC='gif'">GIF</xsl:when>
      <xsl:when test="$OEC='bmp'">BMP</xsl:when>
      <xsl:when test="$OEC='png'">PNG</xsl:when>
      <xsl:when test="$OEC='mpg'">MPG</xsl:when>
      <xsl:when test="$OEC='dcm'">DCM</xsl:when>
      <xsl:when test="$OEC='scp'">SCP</xsl:when>
      <xsl:when test="$OEC='txt'">TXT</xsl:when>
      <xsl:when test="$OEC='rtf'">RTF</xsl:when>
      <xsl:when test="$OEC='doc'">DOC</xsl:when>
      <xsl:when test="$OEC='xsl'">XLS</xsl:when>
      <xsl:when test="$OEC='wpd'">WPD</xsl:when>
      <xsl:when test="$OEC='exe'">EXE</xsl:when>
      <xsl:when test="$OEC='pdf'">PDF</xsl:when>
      <xsl:when test="$OEC='wav'">WAV</xsl:when>
      <xsl:when test="$OEC='avi'">AVI</xsl:when>
      <xsl:when test="$OEC='mid'">MID</xsl:when>
      <xsl:when test="$OEC='rmi'">RMI</xsl:when>
      <xsl:when test="$OEC='com'">COM</xsl:when>
      <xsl:when test="$OEC='zip'">ZIP</xsl:when>
      <xsl:when test="$OEC='bin'">BIN</xsl:when>
      <xsl:when test="$OEC='inh'">INH</xsl:when>
      <xsl:otherwise>
        <FEJL>Ukendt OBJEKTEXTENSIONTYPE<xsl:value-of select="$OEC"/>
        </FEJL>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
