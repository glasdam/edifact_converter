<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/" version="1.0">
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
		<xsl:variable name="DT203" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:Time,1,2),substring($DT/m:Time,4,2))"/>
		<xsl:value-of select="$DT203"/>
	</xsl:template>
	<xsl:template name="DateTimeWithSecToDTM204">
		<xsl:param name="DT" select="."/>
		<xsl:variable name="DT204" select="concat(substring($DT/m:Date,1,4),substring($DT/m:Date,6,2),substring($DT/m:Date,9,2),substring($DT/m:TimeWithSec,1,2),substring($DT/m:TimeWithSec,4,2),substring($DT/m:TimeWithSec,7,2))"/>
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
					<FEJL>Ukendt MedicalSpecialityCode: <xsl:value-of select="$MSC"/>
					</FEJL>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="VersionCodeToType">
		<xsl:param name="VersionCode" select="."/>
		<xsl:choose>
			<xsl:when test="$VersionCode='D0133L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D0233L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D0333L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D0533L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D0633L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D0733L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D1333L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D0833L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D9133L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D9134L' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='H0130R' ">MEDREF</xsl:when>
			<xsl:when test="$VersionCode='H0230R' ">MEDREF</xsl:when>
			<xsl:when test="$VersionCode='H0630R' ">MEDREF</xsl:when>
			<xsl:when test="$VersionCode='R0130K' ">MEDRPT</xsl:when>
			<xsl:when test="$VersionCode='R0430P' ">MEDRPT</xsl:when>
			<xsl:when test="$VersionCode='R0330P' ">MEDRPT</xsl:when>
			<xsl:when test="$VersionCode='R0230M' ">MEDRPT</xsl:when>
			<xsl:when test="$VersionCode='Q0130K' ">MEDREQ</xsl:when>
			<xsl:when test="$VersionCode='Q0230M' ">MEDREQ</xsl:when>
			<xsl:when test="$VersionCode='Q0330P' ">MEDREQ</xsl:when>
			<xsl:when test="$VersionCode='A0130Z' ">PRODAT</xsl:when>
			<xsl:when test="$VersionCode='U0130U' ">????</xsl:when>
			<xsl:when test="$VersionCode='U0230U' ">????</xsl:when>
			<xsl:when test="$VersionCode='U0330U' ">????</xsl:when>
			<xsl:when test="$VersionCode='U0430U' ">????</xsl:when>
			<xsl:when test="$VersionCode='U0530U' ">????</xsl:when>
			<xsl:when test="$VersionCode='D2030C' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D1430C' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D1730C' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D1830C' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='D1930C' ">MEDDIS</xsl:when>
			<xsl:when test="$VersionCode='I0130D' ">????</xsl:when>
			<xsl:when test="$VersionCode='I0230D' ">????</xsl:when>
			<xsl:when test="$VersionCode='I0330D' ">????</xsl:when>
			<xsl:when test="$VersionCode='I0430D' ">????</xsl:when>
			<xsl:when test="$VersionCode='SST012' ">????</xsl:when>
			<xsl:when test="$VersionCode='XD0133L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD0233L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD0333L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD0533L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD0633L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD0733L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD1333L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD0833L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD9133L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD9134L' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XH0130R' ">XMEDREF</xsl:when>
			<xsl:when test="$VersionCode='XH0230R' ">XMEDREF</xsl:when>
			<xsl:when test="$VersionCode='XH0630R' ">XMEDREF</xsl:when>
			<xsl:when test="$VersionCode='XR0130K' ">XMEDRPT</xsl:when>
			<xsl:when test="$VersionCode='XR0430P' ">XMEDRPT</xsl:when>
			<xsl:when test="$VersionCode='XR0330P' ">XMEDRPT</xsl:when>
			<xsl:when test="$VersionCode='XR0230M' ">XMEDRPT</xsl:when>
			<xsl:when test="$VersionCode='XQ0130K' ">XMEDREQ</xsl:when>
			<xsl:when test="$VersionCode='XQ0230M' ">XMEDREQ</xsl:when>
			<xsl:when test="$VersionCode='XQ0330P' ">XMEDREQ</xsl:when>
			<xsl:when test="$VersionCode='XA0130Z' ">XPRODAT</xsl:when>
			<xsl:when test="$VersionCode='XU0130U' ">Ukendt</xsl:when>
			<xsl:when test="$VersionCode='XU0230U' ">Ukendt</xsl:when>
			<xsl:when test="$VersionCode='XU0330U' ">Ukendt</xsl:when>
			<xsl:when test="$VersionCode='XU0430U' ">Ukendt</xsl:when>
			<xsl:when test="$VersionCode='XU0530U' ">Ukendt</xsl:when>
			<xsl:when test="$VersionCode='XD2030C' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD1430C' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD1730C' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD1830C' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XD1930C' ">XMEDDIS</xsl:when>
			<xsl:when test="$VersionCode='XI0130D' ">Ukendt</xsl:when>
			<xsl:when test="$VersionCode='XI0230D' ">Ukendt</xsl:when>
			<xsl:when test="$VersionCode='XI0330D' ">Ukendt</xsl:when>
			<xsl:when test="$VersionCode='XI0430D' ">Ukendt</xsl:when>
			<xsl:when test="$VersionCode='XSST012' ">Ukendt</xsl:when>
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
	
	<xsl:template name="identifierCode2edi">
		<xsl:param name="code" select="unknown"/>
			<SubElm>
				<xsl:choose>
					<xsl:when test="$code='sygehusafdelingsnummer' ">SKS</xsl:when>
					<xsl:when test="$code='ydernummer' ">YNR</xsl:when>
					<xsl:when test="$code='lokationsnummer' "></xsl:when>
					<xsl:when test="$code='sorkode' ">SOR</xsl:when>
					<xsl:when test="count($code)=0 "/>
					<xsl:when test="$code='kommunenummer' ">KOM</xsl:when>
					<xsl:otherwise>
						<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$code"/></FEJL>
					</xsl:otherwise>
				</xsl:choose>
			</SubElm>
			<SubElm>
				<xsl:choose>
					<xsl:when test="$code='sygehusafdelingsnummer' ">SST</xsl:when>
					<xsl:when test="$code='sorkode' ">SST</xsl:when>
					<xsl:when test="$code='ydernummer' ">SFU</xsl:when>
					<xsl:when test="$code='lokationsnummer' ">9</xsl:when>
					<xsl:when test="count($code)=0 ">9</xsl:when>
					<xsl:when test="$code='kommunenummer' ">IM</xsl:when>
					<xsl:otherwise>
						<FEJL>Kan ikke oversætte IdentifierCodeType: <xsl:value-of select="$code"/></FEJL>
					</xsl:otherwise>
				</xsl:choose>
			</SubElm>
	</xsl:template>
	
</xsl:stylesheet>
