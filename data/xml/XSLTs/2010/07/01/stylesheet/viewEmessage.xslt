<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- edited with XMLSPY v5 rel. 4 U (http://www.xmlspy.com) by Henrik Gørup Rasmussen (Acure) -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/" 
xmlns:gepj="http://medinfo.dk/epj/proj/gepka/20030701/xml/schema" xmlns:cpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/" xmlns:dkcc="http://rep.oio.dk/ebxml/xml/schemas/dkcc/2003/02/13/" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output media-type="text/html"/>
	<xsl:variable name="compoundbgcolor" select="'#eeeeee'"/>
	<xsl:variable name="highlightbgcolor" select="'#ffcccc'"/>
	<xsl:variable name="headerbgcolor" select="'#001973'"/>
	<xsl:variable name="headerfontcolor" select="'#ffffff'"/>
	<xsl:variable name="footerbgcolor" select="'#001973'"/>
	<xsl:variable name="footerfontcolor" select="'#ffffff'"/>
	<xsl:variable name="evenrowbgcolor" select="'#eeeeee'"/>
	<xsl:variable name="oddrowbgcolor" select="'#dddddd'"/>
	<xsl:variable name="evenrowhighlightbgcolor" select="'#ffcccc'"/>
	<xsl:variable name="oddrowhighlightbgcolor" select="'#ffbbbb'"/>
	<xsl:variable name="valuetolowbgcolor" select="'aaaaff'"/>
	<xsl:variable name="valuetohighbgcolor" select="'#ffaaaa'"/>
	<xsl:variable name="valueabnormbgcolor" select="'#ffffaa'"/>
	<xsl:variable name="table2bordercolor" select="'#ee0000'"/>
	<xsl:variable name="namebgcolor" select="'#dddddd'"/>
	<xsl:variable name="namefontcolor" select="'#0000ff'"/>
	<xsl:variable name="analyser" select="m:Emessage/m:LaboratoryReport/m:LaboratoryResults/m:Result/m:Analysis"/>
	<xsl:key name="analysekode2node" match="m:Emessage/m:LaboratoryReport/m:LaboratoryResults/m:Result/m:Analysis" use="m:AnalysisCode"/>
	<xsl:key name="requisitiongroup2result" match="m:Emessage/m:LaboratoryReport/m:LaboratoryResults/m:Result" use="concat('key',m:Analysis/m:RequisitionGroup/m:Identifier)"/>
	<!--
		ROD ELEMENTET VISES PÅ FØLGENDENDE MÅDE
	-->
	<xsl:template match="/">
		<html>
			<head/>
			<body bgcolor="#F3F7F8">
				<table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0" bgcolor="#000000" width="100%">
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
			<xsl:variable name="isText" select="count(*)=count(m:Break|m:Space|m:Bold|m:Italic|m:Underline|m:Center|m:Right|m:FixedFont)"/>
			<xsl:if test="not($isText)">
				<td valign="top" width="100%" bgcolor="#000000">
					<table border="0" bordercolor="#dd0000" cellspacing="1" cellpadding="0" width="100%">
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
			<xsl:attribute name="bgcolor"><xsl:value-of select="$namebgcolor"/></xsl:attribute>
			<b>
				<i>
					<font>
						<xsl:attribute name="color"><xsl:value-of select="$namefontcolor"/></xsl:attribute>
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

	<!--xsl:template name="ShowRefName">
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
	</xsl:template-->
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
	
	<xsl:template match="m:PatternEntry">
		<xsl:variable name="isFirst" select="count(.|../m:PatternEntry[1])=1"/>
		<xsl:if test="$isFirst">
			<xsl:call-template name="ShowNamedValue">
				<xsl:with-param name="Name" select="concat(count(../m:PatternEntry),'*','PatternEntry (tabelform)')"/>
				<xsl:with-param name="Value">
					<xsl:call-template name="ShowTable">
						<xsl:with-param name="ColNames" select="../../m:Microorganism/m:Name"/>
						<!--<xsl:with-param name="ColNames"><xsl:for-each select="../../m:Microorganism"><xsl:value-of select="m:Name"/></xsl:for-each></xsl:with-param>-->
						<xsl:with-param name="RowNames" select="../m:Antibiotic"/>
						<xsl:with-param name="ColIdxs" select="../m:PatternEntry/m:RefMicroorganism"/>
						<xsl:with-param name="RowIdxs" select="../m:PatternEntry/m:RefAntibiotic"/>
						<xsl:with-param name="Values" select="../m:PatternEntry/m:Sensitivity"/>
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
	<xsl:template match="m:Break">
		<br/>
	</xsl:template>
	<xsl:template match="m:Space">
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	</xsl:template>
	<xsl:template match="m:Bold">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>
	<xsl:template match="m:Italic">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>
	<xsl:template match="m:Underline">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>
	<xsl:template match="m:Center">
		<div align="center">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="m:Right">
		<div align="right">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="m:FixedFont">
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
		<xsl:value-of select="concat('d.',substring($DateTime/m:Date,9,2),'-',substring($DateTime/m:Date,6,2),'-',substring($DateTime/m:Date,1,4),' kl.',$DateTime/m:Time)"/>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT FORMATERE DATETIMETYPE 
	-->
	<xsl:template name="FormatDate">
		<xsl:param name="Date" select="."/>
		<xsl:value-of select="concat('d.',substring($Date,9,2),'-',substring($Date,6,2),'-',substring($Date,1,4))"/>
	</xsl:template>
	
<!-- 
		TEMPLATE TIL AT FORMATERE DATETIMETYPE 
	-->
	<xsl:template name="ShortFormatDateTime2">
		<xsl:param name="DateTime" select="."/>
		<xsl:value-of select="concat(substring($DateTime/m:Date,9,2),'.')"/>
		<xsl:call-template name="ShortFormatMonth">
			<xsl:with-param name="Date" select="$DateTime/m:Date"/>
		</xsl:call-template>
		<xsl:value-of select="concat('.',substring($DateTime/m:Date,3,2),' ',$DateTime/m:Time)"/>
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
		TEMPLATE TIL AT VISE EN TABEL (BRUGES TIL RESISTENSTABEL I MIKROBIOLOGISVAR).   
	-->
	<xsl:template name="ShowTable2">
		<xsl:param name="ColNames"/>
		<xsl:param name="RowNames"/>
		<xsl:param name="ColIdxs"/>
		<xsl:param name="RowIdxs"/>
		<xsl:param name="Values"/>
		<table border="0" cellspacing="1" cellpadding="0">
			<xsl:attribute name="bordercolor"><xsl:value-of select="$table2bordercolor"/></xsl:attribute>
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
								<xsl:attribute name="bgcolor"><xsl:value-of select="$oddrowbgcolor"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="$isevenrow">
								<xsl:attribute name="bgcolor"><xsl:value-of select="$evenrowbgcolor"/></xsl:attribute>
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
			<xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute>
			<table width="100%">
				<tbody>
					<tr>
						<td>
							<h2>
								<font>
									<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
									<xsl:value-of select="$MessageName"/>
								</font>
							</h2>
						</td>
						<td align="right" valign="baseline" nowrap="true">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
								<b>Sendt:</b>
								<xsl:for-each select="$Message/../m:Envelope/m:Sent">
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
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Participant/m:OrganisationName"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Participant/m:DepartmentName"/><xsl:value-of select="$Participant/m:PersonTitle"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Participant/m:UnitName"/><xsl:value-of select="$Participant/m:PersonName"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:for-each select="$Participant/m:TelephoneSubscriberIdentifier">
					<xsl:value-of select="."/>
				</xsl:for-each>
			</font>
		</td>
		<xsl:for-each select="$Participant/m:Contact">
			<td valign="top">
				<font>
					<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
					<b>Kontakt:</b>
				</font>
			</td>
			<xsl:call-template name="ShowParticipant">
				<xsl:with-param name="FontColor" select="$FontColor"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="$Participant/m:Physician">
			<td valign="top">
				<font>
					<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
					<b>Kliniker:</b>
				</font>
			</td>
			<td valign="top">
				<font>
					<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
					<xsl:value-of select="."/>
				</font>
			</td>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template name="ShowParticipants">
		<xsl:param name="MedComLetter" select="."/>
		<xsl:param name="FontColor" select="$footerfontcolor"/>
		<xsl:param name="bgcolor" select="$footerbgcolor"/>
		<td valign="top" width="100%">
			<xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute>
			<table>
				<xsl:for-each select="$MedComLetter/m:Sender">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
								<b>Afsender:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$MedComLetter/m:Sender/m:Referrer">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
								<b>Henviser:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>

				<xsl:for-each select="$MedComLetter/m:Receiver">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
								<b>Modtager:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$MedComLetter/m:CCReceiver">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
								<b>Kopimodtager:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$MedComLetter/m:AnswerCCReceiver">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
								<b>Svarkopimodtager:</b>
							</font>
						</td>
						<xsl:call-template name="ShowParticipant">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$MedComLetter/m:Collector">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
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
			<xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute>
			<table>
				<xsl:for-each select="$MedComLetter/m:RequisitionInformation/m:CarbonCopyReceiver">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
								<b>Kopimodtager:</b>
							</font>
						</td>
						<td>
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
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
		<xsl:param name="FontColor" select="$footerfontcolor"/>
		<xsl:param name="bgcolor" select="$footerbgcolor"/>
		<td valign="top" width="100%">
			<xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute>
			<table>
				<xsl:for-each select="$MedComLetter/m:Patient">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
								<b>Patient:</b>
							</font>
						</td>
						<xsl:call-template name="ShowPerson">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="$MedComLetter/m:Relative">
					<tr>
						<td valign="top">
							<font>
								<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
								<b>
									<xsl:value-of select="m:RelationCode"/>
								</b>
							</font>
						</td>
						<xsl:call-template name="ShowPerson">
							<xsl:with-param name="FontColor" select="$FontColor"/>
						</xsl:call-template>
					</tr>
				</xsl:for-each>
			</table>
		</td>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT VISE EN PERSON (PATIENTEN; EN PÅRØRENDE O:L) 
	-->
	<xsl:template name="ShowPerson">
		<xsl:param name="Person" select="."/>
		<xsl:param name="FontColor" select="$footerfontcolor"/>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:if test="count($Person/m:CivilRegistrationNumber)>0">
					<xsl:value-of select="concat(substring($Person/m:CivilRegistrationNumber,1,6),'-',substring($Person/m:CivilRegistrationNumber,7,4))"/>
				</xsl:if>
				<xsl:value-of select="$Person/m:AlternativeIdentifier"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Person/m:OccupancyText"/>
			</font>
		</td>
		<!--<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Person/m:AlternativeIdentifier"/>
			</font>
		</td>-->
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Person/m:PersonGivenName"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Person/m:PersonSurnameName"/>
			</font>
		</td>
		<xsl:call-template name="ShowAdress">
			<xsl:with-param name="FontColor" select="$FontColor"/>
		</xsl:call-template>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Person/m:TelephoneSubscriberIdentifier"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Person/m:EpisodeOfCareStatusCode"/>
			</font>
		</td>
	</xsl:template>
	<!-- 
		TEMPLATE TIL AT VISE EN ADRESSE 
	-->
	<xsl:template name="ShowAdress">
		<xsl:param name="Adress" select="."/>
		<xsl:param name="FontColor" select="$footerfontcolor"/>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Adress/m:StreetName"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Adress/m:SubUrbName"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Adress/m:PostCodeIdentifier"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Adress/m:DistrictName"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Adress/m:MunicipalityId"/>
			</font>
		</td>
		<td valign="top">
			<font>
				<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
				<xsl:value-of select="$Adress/m:MunicipalityName"/>
			</font>
		</td>
	</xsl:template>

	<!-- EmergencyLetter -->
	<xsl:template match="m:Emessage[m:EmergencyLetter]">
		<xsl:for-each select="m:EmergencyLetter">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Lægevagtsepikrise'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Besøgsdato (starttidspunkt) for første besøg:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Admission">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Sidste besøg (sluttidspunkt):</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Discharge">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Diagnose)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														Diagnoser/undersøgelser
													</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Diagnose/m:Main">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:MainAdditional">
																<tr>
																	<td valign="top">
																		<b>Bidiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:Other">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:DiagnoseDateTime">
																			<xsl:call-template name="FormatDateTime"/>
																		</xsl:for-each>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
													Epikrise
												</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:ClinicalInformation">
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:Signed">
																		<xsl:call-template name="FormatDateTime"/>
																	</xsl:for-each>
																</td>
																<td valign="top">
																	<xsl:for-each select="m:Text01">
																		<xsl:apply-templates/>
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<xsl:call-template name="showReferences">
								<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
							</xsl:call-template>
						</tr>
						<tr>
							<xsl:call-template name="ShowPatientAndRelatives"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>

    <!-- SpecialistLetter -->
	<xsl:template match="m:Emessage[m:SpecialistLetter]">
		<xsl:for-each select="m:SpecialistLetter">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Udskrivningsepikrise'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Behandling påbegyndt:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Admission">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Behandling afsluttet:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Discharge">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Diagnose)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														Diagnoser/undersøgelser
													</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Diagnose/m:Main">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:MainAdditional">
																<tr>
																	<td valign="top">
																		<b>Bidiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:Other">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:DiagnoseDateTime">
																			<xsl:call-template name="FormatDateTime"/>
																		</xsl:for-each>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
													Epikrise
												</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:ClinicalInformation">
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:Signed">
																		<xsl:call-template name="FormatDateTime"/>
																	</xsl:for-each>
																</td>
																<td valign="top">
																	<xsl:for-each select="m:Text01">
																		<xsl:apply-templates/>
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<xsl:call-template name="showReferences">
								<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
							</xsl:call-template>
						</tr>
						<tr>
							<xsl:call-template name="ShowPatientAndRelatives"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>
		
	<!-- PhysiotherapyLetter -->
	<xsl:template match="m:Emessage[m:PhysiotherapyLetter]">
		<xsl:for-each select="m:PhysiotherapyLetter">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Fysioterapiepikrise'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Påbegyndt behandling:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Admission">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Behandling afsluttet:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Discharge">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Diagnose)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														Diagnoser/undersøgelser
													</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Diagnose/m:Main">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:MainAdditional">
																<tr>
																	<td valign="top">
																		<b>Bidiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:Other">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:DiagnoseDateTime">
																			<xsl:call-template name="FormatDateTime"/>
																		</xsl:for-each>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
													Epikrise
												</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:ClinicalInformation">
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:Signed">
																		<xsl:call-template name="FormatDateTime"/>
																	</xsl:for-each>
																</td>
																<td valign="top">
																	<xsl:for-each select="m:Text01">
																		<xsl:apply-templates/>
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<xsl:call-template name="showReferences">
								<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
							</xsl:call-template>
						</tr>
						<tr>
							<xsl:call-template name="ShowPatientAndRelatives"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>
	
	<!-- PsychologistLetter -->
	<xsl:template match="m:Emessage[m:PsychologistLetter]">
		<xsl:for-each select="m:PsychologistLetter">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Psykologepikrise'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>Påbegyndt behandling:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Admission">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
											<td valign="top">
												<b>Behandling afsluttet:</b>
											</td>
											<td valign="top">
												<xsl:for-each select="m:Discharge">
													<xsl:call-template name="FormatDateTime"/>
												</xsl:for-each>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Diagnose)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
														Diagnoser/undersøgelser
													</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Diagnose/m:Main">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:MainAdditional">
																<tr>
																	<td valign="top">
																		<b>Bidiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Diagnose/m:Other">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:DiagnoseDateTime">
																			<xsl:call-template name="FormatDateTime"/>
																		</xsl:for-each>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
													Epikrise
												</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<table>
													<tbody>
														<xsl:for-each select="m:ClinicalInformation">
															<tr>
																<td valign="top">
																	<xsl:for-each select="m:Signed">
																		<xsl:call-template name="FormatDateTime"/>
																	</xsl:for-each>
																</td>
																<td valign="top">
																	<xsl:for-each select="m:Text01">
																		<xsl:apply-templates/>
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<xsl:call-template name="showReferences">
								<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
							</xsl:call-template>
						</tr>
						<tr>
							<xsl:call-template name="ShowPatientAndRelatives"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>
					
	
	<xsl:template match="m:Emessage[m:SpecialistReferral]">
		<xsl:for-each select="m:SpecialistReferral">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Speciallægehenvisning'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<xsl:for-each select="m:AdditionalInformation/m:Priority">
												<td valign="top">
													<b>Prioritet:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:ReferralStatus">
												<td valign="top">
													<b>Henvisningstype:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:Transport">
												<td valign="top">
													<b>Transport:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:Supplementary">
												<td valign="top">
													<b>Andet:</b>
												</td>
												<td valign="top">
													<xsl:apply-templates/>
												</td>
											</xsl:for-each>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Referral)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Henvisnings diagnoser
											</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Referral/m:Refer">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Referral/m:ReferralAdditional">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
												Ønsket undersøgelse/behandling/problemstilling											</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:attribute name="bgcolor"><xsl:value-of select="$highlightbgcolor"/></xsl:attribute>
												<table>
													<tbody>
														<xsl:for-each select="m:AdditionalInformation/m:ClinicalReason">
															<tr>
																<td valign="top">
																	<xsl:apply-templates/>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table width="100%">
									<tbody>
										<tr>
											<td valign="top" width="100%">
												<b>
												Kliniske oplysninger
											</b>
											</td>
										</tr>
										<tr>
											<xsl:attribute name="bgcolor"><xsl:value-of select="$compoundbgcolor"/></xsl:attribute>
											<td valign="top" width="100%">
												<table width="100%">
													<tbody>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Cave">
															<tr>
																<td>
																	<b>Cave</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Anamnesis">
															<tr>
																<td>
																	<b>Anamnese</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Examination">
															<tr>
																<td>
																	<b>Undersøgelser/behandlinger</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:ActualMedicine">
															<tr>
																<td>
																	<b>Aktuel medicin</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<xsl:call-template name="showReferences">
								<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
							</xsl:call-template>
						</tr>
						<xsl:if test="count(m:HospitalVisitation)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Visitation (udfyldt af modtager)</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:HospitalVisitation">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:InformationCode"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:Information">
																			<xsl:apply-templates/>
																		</xsl:for-each>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<xsl:call-template name="ShowPatientAndRelatives"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>
	
<!-- template til at vise en fysioterapeuthenvisning.  -->		
	<xsl:template match="m:Emessage[m:PhysiotherapyReferral]">
		<xsl:for-each select="m:PhysiotherapyReferral">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Fysioterapeuthenvisning'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<xsl:for-each select="m:AdditionalInformation/m:Priority">
												<td valign="top">
													<b>Prioritet:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:ReferralStatus">
												<td valign="top">
													<b>Behandlingssted:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:Transport">
												<td valign="top">
													<b>Transport:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<xsl:for-each select="m:AdditionalInformation/m:Supplementary">
												<td valign="top">
													<b>Andet:</b>
												</td>
												<td valign="top">
													<xsl:apply-templates/>
												</td>
											</xsl:for-each>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Referral)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Henvisnings diagnoser
											</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Referral/m:Refer">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Referral/m:ReferralAdditional">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
												Ønsket undersøgelse/behandling/problemstilling											</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:attribute name="bgcolor"><xsl:value-of select="$highlightbgcolor"/></xsl:attribute>
												<table>
													<tbody>
														<xsl:for-each select="m:AdditionalInformation/m:ClinicalReason">
															<tr>
																<td valign="top">
																	<xsl:apply-templates/>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table width="100%">
									<tbody>
										<tr>
											<td valign="top" width="100%">
												<b>
												Kliniske oplysninger
											</b>
											</td>
										</tr>
										<tr>
											<xsl:attribute name="bgcolor"><xsl:value-of select="$compoundbgcolor"/></xsl:attribute>
											<td valign="top" width="100%">
												<table width="100%">
													<tbody>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Cave">
															<tr>
																<td>
																	<b>Cave</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Anamnesis">
															<tr>
																<td>
																	<b>Anamnese</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Examination">
															<tr>
																<td>
																	<b>Undersøgelser/behandlinger</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:ActualMedicine">
															<tr>
																<td>
																	<b>Aktuel medicin</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<xsl:call-template name="showReferences">
								<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
							</xsl:call-template>
						</tr>
						<xsl:if test="count(m:HospitalVisitation)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Visitation (udfyldt af modtager)</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:HospitalVisitation">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:InformationCode"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:Information">
																			<xsl:apply-templates/>
																		</xsl:for-each>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<xsl:call-template name="ShowPatientAndRelatives"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>

	<!-- template til at vise en psykologhenvisning.  -->		
	<xsl:template match="m:Emessage[m:PsychologistReferral]">
		<xsl:for-each select="m:PsychologistReferral">
			<td valign="top" width="100%" bgcolor="#ffffff" colspan="2">
				<table width="100%">
					<tbody>
						<tr>
							<xsl:call-template name="ShowMessageHeader">
								<xsl:with-param name="MessageName" select="'Psykologhenvisning'"/>
							</xsl:call-template>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<xsl:for-each select="m:AdditionalInformation/m:Priority">
												<td valign="top">
													<b>Prioritet:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each>
											<!-- xsl:for-each select="m:AdditionalInformation/m:ReferralStatus">
												<td valign="top">
													<b>Henvisningstype:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each-->
											<!-- xsl:for-each select="m:AdditionalInformation/m:Transport">
												<td valign="top">
													<b>Transport:</b>
												</td>
												<td valign="top">
													<xsl:value-of select="."/>
												</td>
											</xsl:for-each-->
											<xsl:for-each select="m:AdditionalInformation/m:Supplementary">
												<td valign="top">
													<b>Andet:</b>
												</td>
												<td valign="top">
													<xsl:apply-templates/>
												</td>
											</xsl:for-each>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<xsl:if test="count(m:Referral)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>
												Henvisningsårsag
											</b>
												</td>
											</tr>
											<tr>
												<td>
													<table>
														<tbody>
															<xsl:for-each select="m:Referral/m:Refer">
																<tr>
																	<td valign="top">
																		<b>Hoveddiagnose:</b>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
															<xsl:for-each select="m:Referral/m:ReferralAdditional">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseDescriptionCode"/>:
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseCode"/>
																	</td>
																	<td valign="top">
																		<xsl:value-of select="m:DiagnoseText"/>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td valign="top" width="100%">
								<table>
									<tbody>
										<tr>
											<td valign="top">
												<b>
												Ønsket undersøgelse/behandling/problemstilling											</b>
											</td>
										</tr>
										<tr>
											<td valign="top">
												<xsl:attribute name="bgcolor"><xsl:value-of select="$highlightbgcolor"/></xsl:attribute>
												<table>
													<tbody>
														<xsl:for-each select="m:AdditionalInformation/m:ClinicalReason">
															<tr>
																<td valign="top">
																	<xsl:apply-templates/>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top" width="100%">
								<table width="100%">
									<tbody>
										<tr>
											<td valign="top" width="100%">
												<b>
												Kliniske oplysninger
											</b>
											</td>
										</tr>
										<tr>
											<xsl:attribute name="bgcolor"><xsl:value-of select="$compoundbgcolor"/></xsl:attribute>
											<td valign="top" width="100%">
												<table width="100%">
													<tbody>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Cave">
															<tr>
																<td>
																	<b>Cave</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Anamnesis">
															<tr>
																<td>
																	<b>Anamnese</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:Examination">
															<tr>
																<td>
																	<b>Undersøgelser/behandlinger</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
														<xsl:for-each select="m:RelevantClinicalInformation/m:ActualMedicine">
															<tr>
																<td>
																	<b>Aktuel medicin</b>
																</td>
															</tr>
															<tr>
																<td>
																	<table>
																		<tbody>
																			<tr>
																				<td valign="top">
																					<xsl:apply-templates/>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</xsl:for-each>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<xsl:call-template name="showReferences">
								<xsl:with-param name="SenderEAN" select="m:Sender/m:EANIdentifier"/>
							</xsl:call-template>
						</tr>
						<xsl:if test="count(m:HospitalVisitation)>0">
							<tr>
								<td valign="top" width="100%">
									<table>
										<tbody>
											<tr>
												<td valign="top">
													<b>Visitation (udfyldt af modtager)</b>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<table>
														<tbody>
															<xsl:for-each select="m:HospitalVisitation">
																<tr>
																	<td valign="top">
																		<xsl:value-of select="m:InformationCode"/>
																	</td>
																	<td valign="top">
																		<xsl:for-each select="m:Information">
																			<xsl:apply-templates/>
																		</xsl:for-each>
																	</td>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<xsl:call-template name="ShowPatientAndRelatives"/>
						</tr>
						<tr>
							<xsl:call-template name="ShowParticipants"/>
						</tr>
					</tbody>
				</table>
			</td>
		</xsl:for-each>
	</xsl:template>

	
<!-- TEMPLATE DER VISER EN GENEREL HEADER I ALLE MEDDELELSERNE -->
	<!--xsl:template name="ShowViewHeader">
		<xsl:param name="MessageName" select="'Ukendt meddelelse'"/>
		<xsl:param name="Message" select="."/>
		<xsl:param name="FontColor" select="$headerfontcolor"/>
		<xsl:param name="bgcolor" select="$headerbgcolor"/>
		<td width="100%">
			<xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute>
			<table width="100%">
				<tbody>
					<tr>
						<td>
							<h2>
								<font>
									<xsl:attribute name="color"><xsl:value-of select="$FontColor"/></xsl:attribute>
									<xsl:value-of select="$MessageName"/>
								</font>
							</h2>
						</td>
					</tr>
				</tbody>
			</table>
		</td>
	</xsl:template-->
	
	
	<xsl:template name="showReferences">
		<xsl:param name="Refs" select="m:Reference"/>
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
		<td>
			<xsl:if test="count($Ref/m:URL)>0">
				<img src="img/urlicon.PNG"/>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$Ref/m:URL"/></xsl:attribute>
					<xsl:value-of select="$Ref/m:RefDescription"/>
				</a>
			</xsl:if>
			<xsl:if test="count($Ref/m:SUP)>0">
				<img src="img/supicon.PNG"/>
				<xsl:value-of select="$Ref/m:RefDescription"/>
			</xsl:if>
			<xsl:if test="count($Ref/m:BIN)>0">
				<xsl:variable name="OC" select="$Ref/m:BIN/m:ObjectCode"/>
				<xsl:variable name="OEC" select="$Ref/m:BIN/m:ObjectExtensionCode"/>
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
					<xsl:attribute name="src"><xsl:value-of select="$icon"/></xsl:attribute>
				</img>
				<a target="newwindow">
					<xsl:attribute name="href"><xsl:value-of select="concat('Binary/',$SenderEAN,'_',$Ref/m:BIN/m:ObjectIdentifier,'_',$Ref/m:BIN/m:ObjectCode,'.',$Ref/m:BIN/m:ObjectExtensionCode)"/></xsl:attribute>
					<xsl:value-of select="$Ref/m:RefDescription"/>
				</a>
				<xsl:value-of select="concat(' (',$Ref/m:BIN/m:OriginalObjectSize,' bytes)')"/>
			</xsl:if>
		</td>
	</xsl:template>
</xsl:stylesheet>
