<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='CONTRL' and SubElm[5]='C0230Q']]">
		<xsl:variable name="Unh" select="UNH"/>
		<xsl:variable name="Unt" select="UNT"/>
		<xsl:variable name="EnvReciept" select="BrevIndhold/UCI"/>
		<xsl:variable name="LetterReciepts" select="BrevIndhold/UCM"/>
		<xsl:variable name="IkkeBrugteSegmenter" select="	*[not(name()='UNH' or name()='BrevIndhold' or name()='UNT')]
												|	BrevIndhold/*[not(name()='UCI' or name()='UCM'  or name()='FTX')]"/>
		<xsl:for-each select="$IkkeBrugteSegmenter">
			<xsl:call-template name="Error">
				<xsl:with-param name="Text">Uventet segment: <xsl:value-of select="name()"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<NegativeReceipt>
			<Letter>
				<Identifier>
					<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
				</Identifier>
				<VersionCode>XC0230Q</VersionCode>
				<StatisticalCode>XCTL02</StatisticalCode>
			</Letter>
			<Sender>
				<EANIdentifier>
					<xsl:value-of select="$SenderEAN"/>
				</EANIdentifier>
			</Sender>
			<Receiver>
				<EANIdentifier>
					<xsl:value-of select="$ReceiverEAN"/>
				</EANIdentifier>
			</Receiver>
			<xsl:for-each select="$EnvReciept">
				<xsl:variable name="EnvFTX" select="following-sibling::*[name()='FTX' and position()=1]"/>
				<OriginalEmessage>
					<OriginalEnvelopeIdentifier>
						<xsl:value-of select="Elm[1]/SubElm[1]"/>
					</OriginalEnvelopeIdentifier>
					<OriginalSender>
						<EANIdentifier>
							<xsl:value-of select="Elm[2]/SubElm[1]"/>
						</EANIdentifier>
					</OriginalSender>
					<OriginalReceiver>
						<EANIdentifier>
							<xsl:value-of select="Elm[3]/SubElm[1]"/>
						</EANIdentifier>
					</OriginalReceiver>
					<xsl:for-each select="$EnvFTX">
						<RefuseCode>
							<xsl:variable name="C" select="Elm[1]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$C='NC' ">ikke_specificeret</xsl:when>
								<xsl:when test="$C='LOK' ">ukendt_lokationsnummer</xsl:when>
								<xsl:when test="$C='MID' ">problem_med_modtagerID</xsl:when>
								<xsl:when test="$C='VER' ">problem_med_version</xsl:when>
								<xsl:when test="$C='SYN' ">syntaksfejl</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$C"/>
										<xsl:with-param name="Text">Ukendt afvisningskode</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</RefuseCode>
						<RefuseText>
							<xsl:call-template name="FTXSubElmsToBreakableText">
								<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
							</xsl:call-template>
						</RefuseText>
					</xsl:for-each>
					<xsl:for-each select="$LetterReciepts">
						<OriginalLetter>
							<OriginalLetterIdentifier>
								<xsl:value-of select="Elm[1]/SubElm[1]"/>
							</OriginalLetterIdentifier>
							<OriginalVersionCode><xsl:value-of select="Elm[2]/SubElm[5]"/></OriginalVersionCode>
						<!--	<ReceiptStatus><xsl:value-of select="Elm[3]/SubElm[1]"/></ReceiptStatus> KUN NEGATIVE ER TILLADT-->
							<xsl:variable name="LetterFTX" select="following-sibling::*[name()='FTX' and position()=1]"/>
							<xsl:for-each select="$LetterFTX">
								<RefuseCode>
							<xsl:variable name="C" select="Elm[1]/SubElm[1]"/>
							<xsl:choose>
								<xsl:when test="$C='NC' ">ikke_specificeret</xsl:when>
								<xsl:when test="$C='LOK' ">ukendt_lokationsnummer</xsl:when>
								<xsl:when test="$C='MID' ">problem_med_modtagerID</xsl:when>
								<xsl:when test="$C='VER' ">problem_med_version</xsl:when>
								<xsl:when test="$C='SYN' ">syntaksfejl</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Error">
										<xsl:with-param name="Node" select="$C"/>
										<xsl:with-param name="Text">Ukendt afvisningskode</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</RefuseCode>
						<RefuseText>
							<xsl:call-template name="FTXSubElmsToBreakableText">
								<xsl:with-param name="FTXSubElms" select="Elm[4]/SubElm"/>
							</xsl:call-template>
						</RefuseText>
							</xsl:for-each>
						</OriginalLetter>
					</xsl:for-each>
				</OriginalEmessage>
			</xsl:for-each>
		</NegativeReceipt>
	</xsl:template>
</xsl:stylesheet>
