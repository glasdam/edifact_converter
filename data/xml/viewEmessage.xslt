<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gepj="http://medinfo.dk/epj/proj/gepka/20030701/xml/schema"
	xmlns:cpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/"
	xmlns:dkcc="http://rep.oio.dk/ebxml/xml/schemas/dkcc/2003/02/13/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output media-type="text/html"/>
	<xsl:include href="viewCommon.xsl"/>
	<xsl:include href="XSLTs/2013/09/02/stylesheet/viewEmessage.xsl"/>
	<xsl:include href="XSLTs/2012/03/28/stylesheet/viewEmessage.xsl"/>
	<xsl:include href="XSLTs/2011/02/17/stylesheet/viewEmessage.xsl"/>
	<xsl:include href="XSLTs/2008/09/17/stylesheet/viewEmessage.xsl"/>
	<xsl:include href="XSLTs/2007/02/01/stylesheet/viewEmessage.xsl"/>
	<xsl:include href="XSLTs/2006/07/01/stylesheet/viewEmessage.xsl"/>
	<xsl:include href="XSLTs/2005/08/07/stylesheet/viewEmessage.xsl"/>

	<!--<xsl:variable name="analyser" select="m:Emessage/m:LaboratoryReport/m:LaboratoryResults/m:Result/m:Analysis"/>
	<xsl:key name="analysekode2node" match="m:Emessage/m:LaboratoryReport/m:LaboratoryResults/m:Result/m:Analysis" use="m:AnalysisCode"/>
	<xsl:key name="requisitiongroup2result" match="m:Emessage/m:LaboratoryReport/m:LaboratoryResults/m:Result" use="concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)"/>-->
	<!--
		ROD ELEMENTET VISES PÅ FØLGENDENDE MÅDE
	-->

	<xsl:template match="/">
		<html>
			<head>
				<style type="text/css" media="screen">
					#navlist
					{
					    padding:3px 0;
					    margin-left:0;
					    margin-top:1px;
					    margin-bottom:0px;
					    border-bottom:1px solid #778;
					    font:bold 12px Verdana, sans-serif;
					}
					
					#navlist li
					{
					    list-style:none;
					    margin:0;
					    display:inline;
					}
					
					#navlist li a
					{
					    padding:3px 0.5em;
					    margin-left:3px;
					    border:1px solid #778;
					    border-bottom:none;
					    background:#DDE;
					    text-decoration:none;
					}
					
					#navlist li a:link{
					    color:#448;
					}
					#navlist li a:visited{
					    color:#667;
					}
					
					#navlist li a:hover
					{
					    color:#000;
					    background:#AAE;
					    border-color:#227;
					}
					
					#navlist li a#current
					{
					    background:white;
					    border-bottom:1px solid white;
					}
					
					div.hidden{
					    display:none;
					}
					
					div.visible{
					    display:block;
					    border:1px solid black;
					    border-top:none;
					    margin:0px;
					}
					
					table.culturefindings{
					    border-collapse:collapse;
					    margin-left:1px;
					}
					
					table.culturefindings tr td{
					    border:2px solid white;
					    padding:3px 7px 3px 7px;
					
					}
					td.footer, td.footer > table {
					background-color: #001973;
					color: #fff;
					width: 100%
					}
					p.ecareid{
					    font:normal 12px Verdana, sans-serif;
					    font-variant:small-caps;
					    margin:0px 0px 0px 0px;
					    text-align:right
					}
					p.ecareid span{
					    display:inline-block;
					    padding:5px;
					    margin:0px 0px 5px 5px;
					    border:1px solid #AAA;
					    background-color:white;
					}
					td.frame, td.frame div, td.frame table {
					background-color: white;
					color: black;
					}
					td.frame table td:first-child {
					font-weight:bold;
					}
				</style>
			</head>
			<body bgcolor="#F3F7F8">
				<xsl:variable name="episodeofcareid"
					select="/*[1]/*[2]/*[1]/*[local-name() = 'EpisodeOfCareIdentifier']"/>
				<xsl:if test="$episodeofcareid">
					<p class="ecareid">Forløbsnr.<span><xsl:value-of select="$episodeofcareid"
							/></span></p>
				</xsl:if>
				<table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0"
					bgcolor="#000000" width="100%">
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<!-- 
		ALLE GENERELLE ELEMENTER VISES PÅ FØLGENDE MÅDE
	-->
	<xsl:template match="*">
		<xsl:call-template name="ShowFields"/>
	</xsl:template>
	<!-- 
		ALLE NORMALLE ELEMENTER VISES PÅ FØLGENDE MÅDE
	-->
	<xsl:template name="ShowFields">
		<xsl:param name="Fields" select="."/>
		<xsl:for-each select="$Fields">
			<tr>
				<xsl:call-template name="ShowName"/>
				<xsl:call-template name="ShowFieldValue"/>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!--
		TEMPLATE TIL AT VISE ELEMENTVÆRDI 
	-->
	<xsl:template name="ShowFieldValue">
		<xsl:param name="Field" select="."/>
		<xsl:for-each select="$Field">
			<xsl:variable name="isText"
				select="count(*[ (local-name(.)='Break' ) or (local-name(.)='Space') or local-name(.)='Bold' or local-name(.)='Italic' or local-name(.)='Underline' or local-name(.)='Center' or local-name(.)='Right' or local-name(.)='FixedFont'])"/>
			<xsl:if test="$isText = count(*)">
				<td valign="top" width="100%" bgcolor="#000000">
					<table border="0" bordercolor="#dd0000" cellspacing="1" cellpadding="0"
						width="100%">
						<xsl:apply-templates/>
					</table>
				</td>
			</xsl:if>
			<xsl:if test="$isText">
				<td valign="top" width="100%" bgcolor="#ffffff">
					<xsl:apply-templates/>
				</td>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!--
		TEMPLATE TIL AT VISE NAVN (EVT PÅ ET FELT)
	-->
	<xsl:template name="ShowName">
		<xsl:param name="Name" select="name()"/>
		<td valign="top">
			<xsl:attribute name="bgcolor">
				<xsl:value-of select="$namebgcolor"/>
			</xsl:attribute>
			<b>
				<i>
					<font>
						<xsl:attribute name="color">
							<xsl:value-of select="$namefontcolor"/>
						</xsl:attribute>
						<xsl:copy-of select="$Name"/>
					</font>
				</i>
			</b>
		</td>
	</xsl:template>
	<!--
		TEMPLATE TIL AT VISE EN VÆRDI (KOPIERER VÆRDIEN RÅT PÅ SORT BAGGRUND)
	-->
	<xsl:template name="ShowValue">
		<xsl:param name="Value" select="."/>
		<td valign="top" width="100%" bgcolor="#000000">
			<xsl:copy-of select="$Value"/>
		</td>
	</xsl:template>
	<!--
		TEMPLATE TIL AT VISE EN NAVNGIVEN VÆRDI (NAVN OG VÆRDI KOPIERES RÅT - VÆRDI PÅ SORT BAGGRUND)
	-->
	<xsl:template name="ShowNamedValue">
		<xsl:param name="Name" select="name()"/>
		<xsl:param name="Value" select="."/>
		<tr>
			<xsl:call-template name="ShowName">
				<xsl:with-param name="Name" select="$Name"/>
			</xsl:call-template>
			<xsl:call-template name="ShowValue">
				<xsl:with-param name="Value" select="$Value"/>
			</xsl:call-template>
		</tr>
	</xsl:template>
	<xsl:template name="ShowRefName">
		<xsl:param name="Name" select="name()"/>
		<td valign="top" bgcolor="#dddddd">
			<b>
				<i>
					<font color="#FF0000">
						<xsl:value-of select="$Name"/>
					</font>
				</i>
			</b>
		</td>
	</xsl:template>
	<!--
		TEMPLATE TIL AT VISE EN TABEL
	-->
	<xsl:template name="ShowTable">
		<xsl:param name="ColNames"/>
		<xsl:param name="RowNames"/>
		<xsl:param name="ColIdxs"/>
		<xsl:param name="RowIdxs"/>
		<xsl:param name="Values"/>
		<table border="0" bordercolor="#dd0000" cellspacing="1" cellpadding="0">
			<tr>
				<th/>
				<xsl:for-each select="$ColNames">
					<xsl:call-template name="ShowName">
						<xsl:with-param name="Name" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</tr>
			<xsl:for-each select="$RowNames">
				<xsl:variable name="Row" select="position()"/>
				<tr>
					<xsl:call-template name="ShowName">
						<xsl:with-param name="Name" select="."/>
					</xsl:call-template>
					<!--
				<td valign="top" width="100%" bgcolor="#dddddd">
					<xsl:value-of select="."/>
				</td>-->
					<xsl:for-each select="$ColNames">
						<xsl:variable name="Col" select="position()"/>
						<td valign="top" width="100%" bgcolor="#ffffff">
							<xsl:for-each select="$Values">
								<xsl:variable name="Idx" select="position()"/>
								<xsl:if test="$ColIdxs[$Idx]=$Col and $RowIdxs[$Idx]=$Row">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template match="*[local-name(.)='PatternEntry']">
		<xsl:variable name="isFirst" select="count(.|../*[local-name(.)='PatternEntry'][1])=1"/>
		<xsl:if test="$isFirst">
			<xsl:call-template name="ShowNamedValue">
				<xsl:with-param name="Name"
					select="concat(count(../*[local-name(.)='PatternEntry']),'*','PatternEntry (tabelform)')"/>
				<xsl:with-param name="Value">
					<xsl:call-template name="ShowTable">
						<xsl:with-param name="ColNames"
							select="../../*[local-name(.)='Microorganism']/*[local-name(.)='Name']"/>
						<!--<xsl:with-param name="ColNames"><xsl:for-each select="../../m:Microorganism"><xsl:value-of select="m:Name"/></xsl:for-each></xsl:with-param>-->
						<xsl:with-param name="RowNames" select="../*[local-name(.)='Antibiotic']"/>
						<xsl:with-param name="ColIdxs"
							select="../*[local-name(.)='PatternEntry']/*[local-name(.)='RefMicroorganism']"/>
						<xsl:with-param name="RowIdxs"
							select="../*[local-name(.) = 'PatternEntry']/*[local-name(.)='RefAntibiotic']"/>
						<xsl:with-param name="Values"
							select="../*[local-name(.)='PatternEntry']/*[local-name(.)='Sensitivity']"
						/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- 
		Ethvert felt vises ved at lave en række i den omliggende tabel, hvor navnet vises i første kollonne og værdien i anden kollonne
		Hvis værdien er en tekst, så vises den direkte i feltet, ellers oprettes der en tabel så børnene kan sættes ind som rækker i denne tabel
		FELT -> <tr>FELTNAVN FELTVÆRDI </tr>
		FELTNAVN -> <td>NAVN</td>
	     	FELTVÆRDI -><td sort>TEKSTVÆRDI</td> | <td hvid></td>STRUKTVÆRDI </td>
	     	TEKSTVÆRDI ->KALD ALLE BØRN TEMPLATES
	     	STRUKTVÆRDI -><table dd000>KALD ALLE BØRN TEMPLATES</table>
	-->
	<!-- 
		FORMATTED TEXT TEMPLATES 
	-->
	<xsl:template match="*[local-name(.) = 'Break']">
		<br/>
	</xsl:template>
	<xsl:template match="*[local-name(.) = 'Space']">
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	</xsl:template>
	<xsl:template match="*[local-name(.) = 'Bold']">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>
	<xsl:template match="*[local-name(.) = 'Italic']">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>
	<xsl:template match="*[local-name(.) = 'Underline']">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>
	<xsl:template match="*[local-name(.) = 'Center']">
		<div align="center">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="*[local-name(.) = 'Right']">
		<div align="right">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="*[local-name(.) = 'FixedFont']">
		<tt>
			<xsl:apply-templates/>
		</tt>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	
		TEMPLATES TIL AT VISE EN PÆN UDGAVE AF DE ENKELTE MEDCOM STANDARDER
	
	-->
	<!-- 
		TEMPLATE TIL AT FORMATERE DATETIMETYPE 
	-->
	<xsl:template name="FormatDateTime">
		<xsl:param name="DateTime" select="."/>
		<xsl:variable name="date" select="$DateTime/*[local-name(.) = 'Date']"/>
		<xsl:variable name="time" select="$DateTime/*[local-name(.) = 'Time']"/>
		<xsl:value-of
			select="concat('d.',substring($date,9,2),'-',substring($date,6,2),'-',substring($date,1,4),' kl.',$time)"
		/>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT FORMATERE DATETIMETYPE 
	-->
	<xsl:template name="FormatDate">
		<xsl:param name="Date" select="."/>
		<xsl:value-of
			select="concat('d.',substring($Date,9,2),'-',substring($Date,6,2),'-',substring($Date,1,4))"
		/>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT FORMATERE DATETIMETYPE 
	-->
	<xsl:template name="ShortFormatDateTime">
		<xsl:param name="DateTime" select="."/>
		<xsl:variable name="date" select="$DateTime/*[local-name(.) = 'Date']"/>
		<xsl:variable name="time" select="$DateTime/*[local-name(.) = 'Time']"/>
		<xsl:value-of
			select="concat(substring($date,9,2),substring($date,6,2),substring($date,3,2),' ',$time)"
		/>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT FORMATERE DATETIMETYPE 
	-->
	<xsl:template name="ShortFormatDateTime2">
		<xsl:param name="DateTime" select="."/>
		<xsl:variable name="date" select="$DateTime/*[local-name(.) = 'Date']"/>
		<xsl:variable name="time" select="$DateTime/*[local-name(.) = 'Time']"/>
		<xsl:value-of select="concat(substring($date,9,2),'.')"/>
		<xsl:call-template name="ShortFormatMonth">
			<xsl:with-param name="Date" select="$date"/>
		</xsl:call-template>
		<xsl:value-of select="concat('.',substring($date,3,2),' ',$time)"/>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT FORMATERE MAANED 
	-->
	<xsl:template name="ShortFormatMonth">
		<xsl:param name="Date" select="."/>
		<xsl:variable name="Month" select="substring($Date,6,2)"/>
		<xsl:choose>
			<xsl:when test="$Month='01' ">jan</xsl:when>
			<xsl:when test="$Month='02' ">feb</xsl:when>
			<xsl:when test="$Month='03' ">mar</xsl:when>
			<xsl:when test="$Month='04' ">apr</xsl:when>
			<xsl:when test="$Month='05' ">maj</xsl:when>
			<xsl:when test="$Month='06' ">jun</xsl:when>
			<xsl:when test="$Month='07' ">jul</xsl:when>
			<xsl:when test="$Month='08' ">aug</xsl:when>
			<xsl:when test="$Month='09' ">sep</xsl:when>
			<xsl:when test="$Month='10' ">okt</xsl:when>
			<xsl:when test="$Month='11' ">nov</xsl:when>
			<xsl:when test="$Month='12' ">dec</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT VISE EN TABEL (BRUGES TIL RESISTENSTABEL I MIKROBIOLOGISVAR)
	-->
	<xsl:template name="ShowTable2">
		<xsl:param name="ColNames"/>
		<xsl:param name="RowNames"/>
		<xsl:param name="ColIdxs"/>
		<xsl:param name="RowIdxs"/>
		<xsl:param name="Values"/>
		<table border="0" cellspacing="1" cellpadding="0">
			<xsl:attribute name="bordercolor">
				<xsl:value-of select="$table2bordercolor"/>
			</xsl:attribute>
			<tr>
				<th/>
				<xsl:for-each select="$ColNames">
					<!--
					<xsl:call-template name="ShowName">
						<xsl:with-param name="Name" select="concat('(',position(),')')"/>
					</xsl:call-template>
					-->
					<td valign="top">
						<b>
							<xsl:value-of select="concat('(',position(),')')"/>
						</b>
					</td>
				</xsl:for-each>
			</tr>
			<xsl:for-each select="$RowNames">
				<xsl:variable name="Row" select="position()"/>
				<xsl:variable name="isevenrow" select="position() mod 2=0"/>
				<tr>
					<!--
					<xsl:call-template name="ShowName">
						<xsl:with-param name="Name" select="."/>
					</xsl:call-template>
					-->
					<td valign="top">
						<b>
							<xsl:value-of select="."/>
						</b>
					</td>
					<!--
				<td valign="top" width="100%" bgcolor="#dddddd">
					<xsl:value-of select="."/>
				</td>-->
					<xsl:for-each select="$ColNames">
						<xsl:variable name="Col" select="position()"/>
						<td valign="top">
							<xsl:if test="not($isevenrow)">
								<xsl:attribute name="bgcolor">
									<xsl:value-of select="$oddrowbgcolor"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="$isevenrow">
								<xsl:attribute name="bgcolor">
									<xsl:value-of select="$evenrowbgcolor"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:for-each select="$Values">
								<xsl:variable name="Idx" select="position()"/>
								<xsl:if test="$ColIdxs[$Idx]=$Col and $RowIdxs[$Idx]=$Row">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	<!-- 
		TEMPLATE DER VISER EN GENEREL HEADER I ALLE MEDDELELSERNE 
	-->
	<xsl:template name="ShowMessageHeader">
		<xsl:param name="MessageName" select="'Ukendt meddelelse'"/>
		<xsl:param name="Message" select="."/>
		<xsl:param name="FontColor" select="$headerfontcolor"/>
		<xsl:param name="bgcolor" select="$headerbgcolor"/>
		<td width="100%">
			<xsl:attribute name="bgcolor">
				<xsl:value-of select="$bgcolor"/>
			</xsl:attribute>
			<table width="100%">
				<tbody>
					<tr>
						<td>
							<h2>
								<font>
									<xsl:attribute name="color">
										<xsl:value-of select="$FontColor"/>
									</xsl:attribute>
									<xsl:value-of select="$MessageName"/>
								</font>
							</h2>
						</td>
						<td align="right" valign="baseline" nowrap="true">
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<b>Sendt:</b>
								<xsl:for-each
									select="$Message/../*[local-name(.)='Envelope']/*[local-name(.)='Sent']">
									<xsl:call-template name="FormatDateTime"/>
								</xsl:for-each>
							</font>
						</td>
					</tr>
				</tbody>
			</table>
		</td>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT VISE FELTERNE I EN SUNDHEDSFAGLIG INVOLVERET (SENDER,RECEIVER,CCRECEIVER,ANSWERCCRECEIVER, MF.) 
	-->
	<xsl:template name="ShowParticipant">
		<xsl:param name="Participant" select="."/>
		<xsl:param name="FontColor" select="$footerfontcolor"/>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:value-of select="$Participant/*[local-name(.)='OrganisationName']"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:value-of select="$Participant/*[local-name(.)='DepartmentName']"/>
				<xsl:value-of select="$Participant/*[local-name(.)='PersonTitle']"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:value-of select="$Participant/*[local-name(.)='UnitName']"/>
				<xsl:value-of select="$Participant/*[local-name(.)='PersonName']"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:for-each select="$Participant/*[local-name(.)='TelephoneSubscriberIdentifier']">
					<xsl:value-of select="."/>
				</xsl:for-each>
			</font>
		</td>
		<xsl:for-each select="$Participant/*[local-name(.)='Contact']">
			<td valign="top">
				<font>
					<xsl:attribute name="color">
						<xsl:value-of select="$FontColor"/>
					</xsl:attribute>
					<b>Kontakt:</b>
				</font>
			</td>
			<xsl:call-template name="ShowParticipant">
				<xsl:with-param name="FontColor" select="$FontColor"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="$Participant/*[local-name(.)='Physician']">
			<td valign="top">
				<font>
					<xsl:attribute name="color">
						<xsl:value-of select="$FontColor"/>
					</xsl:attribute>
					<b>Kliniker:</b>
				</font>
			</td>
			<td valign="top">
				<font>
					<xsl:attribute name="color">
						<xsl:value-of select="$FontColor"/>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</font>
			</td>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ShowFamilyDoctor">
		<xsl:param name="MedComLetter" select="."/>
		<xsl:param name="FontColor" select="$footerfontcolor"/>
		<xsl:param name="bgcolor" select="$footerbgcolor"/>
		<td valign="top" width="100%">
			<xsl:attribute name="bgcolor">
				<xsl:value-of select="$bgcolor"/>
			</xsl:attribute>
			<table>
				<xsl:for-each select="$MedComLetter/*[local-name(.)='FamilyDoctor']">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<b>Egen læge:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
			</table>
		</td>
	</xsl:template>
	<xsl:template name="ShowParticipants">
		<xsl:param name="MedComLetter" select="."/>
		<xsl:param name="FontColor" select="$footerfontcolor"/>
		<xsl:param name="bgcolor" select="$footerbgcolor"/>
		<td valign="top" width="100%">
			<xsl:attribute name="bgcolor">
				<xsl:value-of select="$bgcolor"/>
			</xsl:attribute>
			<xsl:variable name="sender" select="$MedComLetter/*[local-name(.)='Sender']"/>
			<table>
				<xsl:for-each select="$sender">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<b>Afsender:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$sender/*[local-name(.)='Referrer']">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<b>Henviser:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>

				<xsl:for-each select="$MedComLetter/*[local-name(.)='Receiver']">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<b>Modtager:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$MedComLetter/*[local-name(.)='CCReceiver']">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<b>Kopimodtager:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$MedComLetter/*[local-name(.)='AnswerCCReceiver']">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<b>Svarkopimodtager:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$MedComLetter/*[local-name(.)='Collector']">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<b>Prøvetager:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
			</table>
		</td>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT VISE PATIENTEN OG PATIENTENS PÅRØRENDE 
	-->
	<xsl:template name="ShowCarbonCopyReceiver">
		<xsl:param name="MedComLetter" select="."/>
		<xsl:param name="FontColor" select="$footerfontcolor"/>
		<xsl:param name="bgcolor" select="$footerbgcolor"/>
		<td valign="top" width="100%">
			<xsl:attribute name="bgcolor">
				<xsl:value-of select="$bgcolor"/>
			</xsl:attribute>
			<table class="footer">
				<xsl:for-each
					select="$MedComLetter/*[local-name(.)='RequisitionInformation']/*[local-name(.)='CarbonCopyReceiver']">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<b>Kopimodtager:</b>
							</font>
						</td>
						<td>
							<font>
								<xsl:attribute name="color">
									<xsl:value-of select="$FontColor"/>
								</xsl:attribute>
								<xsl:value-of select="."/>
							</font>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</td>
	</xsl:template>

	<!-- 
		TEMPLATE TIL AT VISE PATIENTEN OG PATIENTENS PÅRØRENDE 
	-->
	<xsl:template name="ShowPatientAndRelatives">
		<xsl:param name="MedComLetter" select="."/>
		<td valign="top" class="footer">
			<table>
					<tr>
						<td width="50%" valign="top">
								<b>Patient</b>
						</td>
						<td width="50%" valign="top">
							<b>Pårørende</b>
						</td>
					</tr>
					<tr>
						<td class="frame">
							<div>
							<table>
							<xsl:for-each select="$MedComLetter/*[local-name(.)='Patient']">
								<xsl:call-template name="ShowPerson"/>
							</xsl:for-each>
							</table>
							</div>
						</td>
						<td class="frame">
							<div>
							<xsl:for-each select="$MedComLetter/*[local-name(.)='Relative']">
								<table>
									<xsl:call-template name="ShowPerson"/>
								</table>
							</xsl:for-each>
							</div>
						</td>
					</tr>				
			</table>
		</td>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT VISE EN PERSON (PATIENTEN; EN PÅRØRENDE O:L) 
	-->
	<xsl:template name="ShowPerson">
		<xsl:apply-templates mode="general" select="*"/>
		<xsl:call-template name="person_address"/>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='CivilRegistrationNumber']">
		<tr>
			<td>CPR-Nummer</td>
			<td>
				<xsl:value-of select="concat(substring(.,1,6),'-',substring(.,7,4))"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='AlternativeIdentifier']">
		<tr>
			<td>Erstatnings CPR</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='OccupancyText']">
		<tr>
			<td>Stilling</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='PersonSurnameName']">
		<tr>
			<td>Efternavn</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='PersonGivenName']">
		<tr>
			<td>Fornavn</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="person_address">
		<xsl:if test="*[local-name() = 'StreetName'] | *[local-name(.)='PostCodeIdentifier'] | *[local-name(.)='DistrictName'] | *[local-name(.)='SubUrbName']">
			<tr>
				<td valign="top">Adresse</td>
				<td>
					<xsl:value-of select="*[local-name(.)='StreetName']"/><br/>
					<xsl:if test="*[local-name(.)='SubUrbName']">
						<xsl:value-of select="*[local-name(.)='SubUrbName']"/><br/>
					</xsl:if>
					<xsl:value-of select="*[local-name(.)='PostCodeIdentifier']"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="*[local-name(.)='DistrictName']"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='StreetName'] | *[local-name(.)='PostCodeIdentifier'] | *[local-name(.)='DistrictName']">
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='EpisodeOfCareStatusCode']">
		<tr>
			<td>Status</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='TelephoneSubscriberIdentifier']">
		<tr>
			<td>Tlf</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='MunicipalityId']">
		<tr>
			<td>Kommunekode</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='MunicipalityName']">
		<tr>
			<td>Kommune</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template mode="general" match="*[local-name(.)='RelationCode']">
		<tr>
			<td>Relation</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template mode="general" match="*[local-name(.)='TelephoneSubscriber']">
		<tr>
			<td>Tlf. <xsl:value-of select="*[2]"/></td>
			<td>
				<xsl:value-of select="*[1]"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template mode="general" match="*[local-name(.)='EmailIdentifier']">
		<tr>
			<td>Email</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template mode="general" match="*[local-name(.)='']">
		<tr>
			<td></td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template mode="general" match="*">
		<tr>
			<td>
				<xsl:value-of select="local-name()"/>
			</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>

	<!-- 
		TEMPLATE TIL AT VISE EN ADRESSE 
	-->
	<xsl:template name="ShowAdress">
		<xsl:param name="Adress" select="."/>
		<xsl:param name="FontColor" select="$footerfontcolor"/>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:value-of select="$Adress/*[local-name(.)='StreetName']"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:value-of select="$Adress/*[local-name(.)='SubUrbName']"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:value-of select="$Adress/*[local-name(.)='PostCodeIdentifier']"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:value-of select="$Adress/*[local-name(.)='DistrictName']"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:value-of select="$Adress/*[local-name(.)='MunicipalityId']"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color">
					<xsl:value-of select="$FontColor"/>
				</xsl:attribute>
				<xsl:value-of select="$Adress/*[local-name(.)='MunicipalityName']"/>
			</font>
		</td>
	</xsl:template>
	<!-- TEMPLATE DER VISER EN GENEREL HEADER I ALLE MEDDELELSERNE -->
	<xsl:template name="ShowViewHeader">
		<xsl:param name="MessageName" select="'Ukendt meddelelse'"/>
		<xsl:param name="Message" select="."/>
		<xsl:param name="FontColor" select="$headerfontcolor"/>
		<xsl:param name="bgcolor" select="$headerbgcolor"/>
		<td width="100%">
			<xsl:attribute name="bgcolor">
				<xsl:value-of select="$bgcolor"/>
			</xsl:attribute>
			<table width="100%">
				<tbody>
					<tr>
						<td>
							<h2>
								<font>
									<xsl:attribute name="color">
										<xsl:value-of select="$FontColor"/>
									</xsl:attribute>
									<xsl:value-of select="$MessageName"/>
								</font>
							</h2>
						</td>
					</tr>
				</tbody>
			</table>
		</td>
	</xsl:template>
	<!--
		Template til at vise Labskema
	-->
	<!--	<xsl:template name="ShowLabSkema">
		<tr>
			<xsl:call-template name="ShowViewHeader">
				<xsl:with-param name="MessageName" select="'Laboratorie skema'"/>
			</xsl:call-template>
		</tr>
		<tr>
			<td bgcolor="#ffffff">
				<table width="0%">
					<tbody>
						<xsl:variable name="labsvar" select="m:Emessage/m:LaboratoryReport"/>
						<tr>
							<td/>
							<xsl:for-each select="$labsvar">
								<xsl:sort select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime/m:Date"/>
								<td>
									<xsl:attribute name="bgcolor"><xsl:value-of select="$headerbgcolor"/></xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="m:RequisitionInformation/m:Comments"/></xsl:attribute>
									<font>
										<xsl:attribute name="color"><xsl:value-of select="$headerfontcolor"/></xsl:attribute>
										<xsl:for-each select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime">
											<xsl:call-template name="ShortFormatDateTime2"/>
										</xsl:for-each>
									</font>
								</td>
							</xsl:for-each>
						</tr>
						<xsl:variable name="Firstanalyser" select="$analyser[count(.|(key('analysekode2node',m:AnalysisCode))[1])=1]"/>
						<xsl:for-each select="$Firstanalyser">
							<xsl:variable name="Key" select="m:AnalysisCode"/>

							<xsl:variable name="isevenrow" select="position() mod 2=0"/>
							<tr>
								<xsl:if test="not($isevenrow)">
									<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
								</xsl:if>
								<xsl:if test="$isevenrow">
									<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
								</xsl:if>
								<td>
									<xsl:attribute name="title"><xsl:value-of select="concat(m:AnalysisCode,':',m:AnalysisCodeType,':',m:AnalysisCodeResponsible) "/></xsl:attribute>
									<xsl:value-of select="m:AnalysisCompleteName"/>
								</td>
								<xsl:for-each select="$labsvar">
									<xsl:sort select="m:LaboratoryResults/m:GeneralResultInformation/m:ResultsDateTime/m:Date"/>
									<xsl:variable name="result" select="m:LaboratoryResults/m:Result[m:Analysis/m:AnalysisCode=$Key]"/>
									<td valign="top">
										<xsl:for-each select="$result[1]">
											<xsl:variable name="RV" select="m:ResultValidation"/>
											<xsl:choose>
												<xsl:when test="$RV='unormal' ">
													<xsl:attribute name="bgcolor"><xsl:value-of select="$valueabnormbgcolor"/></xsl:attribute>
												</xsl:when>
												<xsl:when test="$RV='for_hoej' ">
													<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetohighbgcolor"/></xsl:attribute>
												</xsl:when>
												<xsl:when test="$RV='for_lav' ">
													<xsl:attribute name="bgcolor"><xsl:value-of select="$valuetolowbgcolor"/></xsl:attribute>
												</xsl:when>
											</xsl:choose>
											<table>
												<tbody>
													<tr>
														<td valign="top">
															<xsl:attribute name="title"><xsl:if test="count(m:ReferenceInterval/m:LowerLimit|m:ReferenceInterval/m:UpperLimit)>0"><xsl:value-of select="concat(m:ReferenceInterval/m:LowerLimit,'-',m:ReferenceInterval/m:UpperLimit)"/></xsl:if><xsl:value-of select="m:ReferenceInterval/m:IntervalText"/><xsl:value-of select="concat(' ',m:Unit)"/></xsl:attribute>
															<xsl:variable name="O" select="m:Operator"/>
															<xsl:choose>
																<xsl:when test="$O='mindre_end'">&lt;</xsl:when>
																<xsl:when test="$O='stoerre_end'">&gt;</xsl:when>
															</xsl:choose>
															<xsl:value-of select="m:Value"/>
														</td>
														<td valign="top">
															<xsl:attribute name="title"><xsl:for-each select="m:ResultTextValue|m:ResultComments"><xsl:value-of select="."/></xsl:for-each></xsl:attribute>
															<xsl:if test="count(m:ResultTextValue|m:ResultComments)>0">
																<font size="1" color="#ff0000">

																	<xsl:value-of select="'NB'"/>

																</font>
															</xsl:if>
														</td>
													</tr>
												</tbody>
											</table>
										</xsl:for-each>
									</td>
								</xsl:for-each>
							</tr>
							
						</xsl:for-each>
					</tbody>
				</table>
			</td>
		</tr>
	</xsl:template>
-->
	<xsl:template name="showReferences">
		<xsl:param name="Refs" select="./*[local-name(.)='Reference']"/>
		<xsl:param name="SenderEAN"/>
		<td>
			<table>
				<tbody>
					<xsl:for-each select="$Refs">
						<tr>
							<xsl:call-template name="showReference">
								<xsl:with-param name="SenderEAN" select="$SenderEAN"/>
							</xsl:call-template>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</td>
	</xsl:template>
	<xsl:template name="showReference">
		<xsl:param name="Ref" select="."/>
		<xsl:param name="SenderEAN"/>
		<xsl:variable name="refdesc" select="$Ref/*[local-name(.) = 'RefDescription']"/>
		<td>
			<xsl:if test="count($Ref/*[local-name(.) = 'URL'])>0">
				<img src="img/urlicon.PNG"/>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$Ref/*[local-name(.) = 'URL']"/>
					</xsl:attribute>
					<xsl:value-of select="$refdesc"/>
				</a>
			</xsl:if>
			<xsl:if test="count($Ref/*[local-name(.) = 'SUP'])>0">
				<img src="img/supicon.PNG"/>
				<xsl:value-of select="$refdesc"/>
			</xsl:if>
			<xsl:if test="count($Ref/*[local-name(.) = 'BIN'])>0">
				<xsl:variable name="OC"
					select="$Ref/*[local-name(.) = 'BIN']/*[local-name(.) = 'ObjectCode']"/>
				<xsl:variable name="OEC"
					select="$Ref/*[local-name(.) = 'BIN']/*[local-name(.) = 'ObjectExtensionCode']"/>
				<xsl:variable name="icon">
					<xsl:choose>
						<xsl:when test="$OEC='doc'">
							<xsl:value-of select="'img/wordicon.GIF'"/>
						</xsl:when>
						<xsl:when test="$OEC='xls'">
							<xsl:value-of select="'img/xlicon.GIF'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$OC='multimedie'">
									<xsl:value-of select="'img/multiicon.GIF'"/>
								</xsl:when>
								<xsl:when test="$OC='tekstfil'">
									<xsl:value-of select="'img/texticon.GIF'"/>
								</xsl:when>
								<xsl:when test="$OC='billede'">
									<xsl:value-of select="'img/picicon.GIF'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'img/binicon.PNG'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<img>
					<xsl:attribute name="src">
						<xsl:value-of select="$icon"/>
					</xsl:attribute>
				</img>
				<a target="newwindow">
					<xsl:attribute name="href">
						<xsl:value-of
							select="concat('Binary/',$SenderEAN,'_',$Ref/*[local-name(.) = 'BIN']/*[local-name(.) = 'ObjectIdentifier'],'_',$Ref/*[local-name(.) = 'BIN']/*[local-name(.) = 'ObjectCode'],'.',$Ref/*[local-name(.) = 'BIN']/*[local-name(.) = 'ObjectExtensionCode'])"
						/>
					</xsl:attribute>
					<xsl:value-of select="$refdesc"/>
				</a>
				<xsl:value-of
					select="concat(' (',$Ref/*[local-name(.) = 'BIN']/*[local-name(.) = 'OriginalObjectSize'],' bytes)')"
				/>
			</xsl:if>
		</td>
	</xsl:template>

</xsl:stylesheet>
