<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://rep.oio.dk/medcom.dk/xml/schemas/2004/06/01/" xmlns:gepj="http://medinfo.dk/epj/proj/gepka/20030701/xml/schema" xmlns:cpr="http://rep.oio.dk/cpr.dk/xml/schemas/core/2002/06/28/" xmlns:dkcc="http://rep.oio.dk/ebxml/xml/schemas/dkcc/2003/02/13/" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--ROD ELEMENTET VISES PÅ FØLGENDENDE MÅDE-->
	<xsl:template match="/">
		<html>
			<head/>
			<body bgcolor="#F3F7F8">
				<table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0" bgcolor="#eeeeee">
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
	</xsl:template>
	<!-- ALLE GENERELLE ELEEMENTER VISES PÅ FØLGENDE MÅDE-->
	<xsl:template match="*">
		<xsl:call-template name="ShowFields"/>
	</xsl:template>
	<!-- ALLE NORMALLE ELEMENTER VISES PÅ FØLGENDE MÅDE-->
	<xsl:template name="ShowFields">
		<xsl:param name="Fields" select="."/>
		<xsl:for-each select="$Fields">
			<tr>
				<xsl:call-template name="ShowName"/>
				<xsl:call-template name="ShowFieldValue"/>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!--TEMPLATE TIL AT VISE ELEMENTVÆRDI -->
	<xsl:template name="ShowFieldValue">
		<xsl:param name="Field" select="."/>
		<xsl:for-each select="$Field">
			<xsl:variable name="isText" select="count(text()|m:Break|m:Space|m:Bold|m:Italic|m:Underline|m:Center|m:Right|m:FixedFont)>0"/>
			<xsl:if test="not($isText)">
				<td valign="top" width="100%" bgcolor="#000000">
					<table border="0" bordercolor="#dd0000" cellspacing="1" cellpadding="0">
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
	<!--TEMPLATE TIL AT VISE NAVN (EVT PÅ ET FELT)-->
	<xsl:template name="ShowName">
		<xsl:param name="Name" select="name()"/>
		<td valign="top" bgcolor="#dddddd">
			<b>
				<i>
					<font color="#0000FF">
						<xsl:copy-of select="$Name"/>
					</font>
				</i>
			</b>
		</td>
	</xsl:template>
	<!--TEMPLATE TIL AT VISE EN VÆRDI (KOPIERER VÆRDIEN RÅT PÅ SORT BAGGRUND)-->
	<xsl:template name="ShowValue">
		<xsl:param name="Value" select="."/>
		<td valign="top" width="100%" bgcolor="#000000">
			<xsl:copy-of select="$Value"/>
		</td>
	</xsl:template>
	<!--TEMPLATE TIL AT VISE EN NAVNGIVEN VÆRDI (NAVN OG VÆRDI KOPIERES RÅT - VÆRDI PÅ SORT BAGGRUND)-->
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
	<!--TEMPLATE TIL AT VISE EN TABEL-->
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
	<!--TEMPLATE TIL AT VISE EN VÆRDI (EVT PÅ ET FELT)-->
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
	<!-- FORMATTED TEXT TEMPLATES -->
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
</xsl:stylesheet>
