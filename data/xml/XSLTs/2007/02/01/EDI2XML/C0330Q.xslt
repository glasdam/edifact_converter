<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2007/02/01/">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="Brev[UNH/Elm[2][SubElm[1]='CONTRL' and SubElm[5]='C0330Q']]">
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
		<PositiveReceipt>
			<Letter>
				<Identifier>
					<xsl:value-of select="$Unh/Elm[1]/SubElm[1]"/>
				</Identifier>
				<VersionCode>XC0330Q</VersionCode>
				<StatisticalCode>XCTL03</StatisticalCode>
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
						<xsl:call-template name="Error">
									<xsl:with-param name="Text">Der kan ikke sendes afvisningsårsag i Positive controller</xsl:with-param>
								</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each select="$LetterReciepts">
						<OriginalLetter>
							<OriginalLetterIdentifier>
								<xsl:value-of select="Elm[1]/SubElm[1]"/>
							</OriginalLetterIdentifier>
							<OriginalVersionCode>
								<xsl:value-of select="Elm[2]/SubElm[5]"/>
							</OriginalVersionCode>
							<!--	<ReceiptStatus><xsl:value-of select="Elm[3]/SubElm[1]"/></ReceiptStatus> KUN NEGATIVE ER TILLADT-->
							<xsl:variable name="LetterFTX" select="following-sibling::*[name()='FTX' and position()=1]"/>
							<xsl:for-each select="$LetterFTX">
								<xsl:call-template name="Error">
									<xsl:with-param name="Text">Der kan ikke sendes afvisningsårsag i Positive controller</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</OriginalLetter>
					</xsl:for-each>
				</OriginalEmessage>
			</xsl:for-each>
		</PositiveReceipt>
	</xsl:template>
</xsl:stylesheet>
