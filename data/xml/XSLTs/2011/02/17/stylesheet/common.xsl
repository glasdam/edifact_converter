<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:mc="http://rep.oio.dk/medcom.dk/xml/schemas/2011/02/17/">
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="mc:Comment">
        <tr>
            <td class="heading" colspan="2">Kommentar</td>
        </tr>
        <tr>
            <td class="field" colspan="2">
                <xsl:apply-templates mode="formattedtext" select="text() | *"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template mode="formattedtext" match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template mode="formattedtext" match="mc:Center">
        <center>
            <xsl:apply-templates mode="formattedtext" select="text() | *"/>
        </center>
    </xsl:template>

    <xsl:template mode="formattedtext" match="mc:Bold">
        <span class="bold">
            <xsl:apply-templates mode="formattedtext" select="text() | *"/>
        </span>
    </xsl:template>

    <xsl:template mode="formattedtext" match="mc:Italic">
        <span class="italic">
            <xsl:apply-templates mode="formattedtext" select="text() | *"/>
        </span>
    </xsl:template>

    <xsl:template mode="formattedtext" match="mc:Right">
        <p class="right">
            <xsl:apply-templates mode="formattedtext" select="text() | *"/>
        </p>
    </xsl:template>

    <xsl:template mode="formattedtext" match="mc:FixedFont">
        <span class="fixedfont">
            <xsl:apply-templates mode="formattedtext" select="text() | *"/>
        </span>
    </xsl:template>

    <xsl:template mode="formattedtext" match="mc:Underline">
        <span class="underline">
            <xsl:apply-templates mode="formattedtext" select="text() | *"/>
        </span>
    </xsl:template>

    <xsl:template mode="formattedtext" match="mc:Space">
        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    </xsl:template>

    <xsl:template mode="formattedtext" match="mc:Break">
        <br/>
    </xsl:template>

    <xsl:template match="mc:Patient">
        <table class="part">
            <xsl:apply-templates select="mc:CivilRegistrationNumber"/>
            <xsl:apply-templates select="mc:AlternativeIdentifier"/>

            <xsl:if test="mc:PersonGivenName | mc:PersonSurnameName">
                <tr>
                    <td class="label">Navn</td>
                    <td class="value">
                        <xsl:if test="mc:PersonGivenName">
                            <xsl:value-of select="mc:PersonGivenName"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="mc:PersonSurnameName"/>
                    </td>
                </tr>
            </xsl:if>

            <xsl:call-template name="Address"/>
            <xsl:call-template name="CoAddress"/>

            <xsl:for-each select="mc:TelephoneSubscriber">
                <tr>
                    <td class="label">Tlf</td>
                    <xsl:if test="mc:PrivateSubscriberIdentifier">
                        <td>
                            <xsl:value-of select="mc:PrivateSubscriberIdentifier"/>
                        </td>
                    </xsl:if>
                    <xsl:if test="mc:FaxSubscriberIdentifier">
                        <tr>
                            <td class="label"/>
                            <td>
                                <xsl:value-of select="mc:FaxSubscriberIdentifier"/>
                            </td>
                        </tr>
                    </xsl:if>
                    <xsl:if test="mc:MobileSubscriberIdentifier">
                        <tr>
                            <td class="label"/>
                            <td>
                                <xsl:value-of select="mc:MobileSubscriberIdentifier"/>
                            </td>
                        </tr>
                    </xsl:if>
                    <xsl:if test="mc:OtherSubscriberIdentifier">
                        <tr>
                            <td class="label"/>
                            <td>
                                <xsl:value-of select="mc:OtherSubscriberIdentifier"/>
                            </td>
                        </tr>
                    </xsl:if>
                    <xsl:if test="mc:WorkSubscriberIdentifier">
                        <tr>
                            <td class="label"/>
                            <td>
                                <xsl:value-of select="mc:WorkSubscriberIdentifier"/>
                            </td>
                        </tr>
                    </xsl:if>
                </tr>
            </xsl:for-each>

            <xsl:if test="mc:TelephoneSubscriberIdentifier">
                <tr>
                    <td class="label">Telefon</td>
                    <td>
                        <xsl:value-of select="mc:TelephoneSubscriberIdentifier"/>
                    </td>
                </tr>
            </xsl:if>

            <xsl:if test="mc:Occupation">
                <tr>
                    <td class="label">Job</td>
                    <td>
                        <xsl:value-of select="mc:Occupation"/>
                    </td>
                </tr>
            </xsl:if>

            <xsl:if test="mc:OccupancyText">
                <tr>
                    <td class="label">Stilling</td>
                    <td>
                        <xsl:value-of select="mc:OccupancyText"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:call-template name="Interpretation"/>

            <xsl:if test="mc:MaritalStatus">
                <tr>
                    <td class="label">Civilstand</td>
                    <td>
                        <xsl:value-of select="mc:MaritalStatus"/>
                    </td>
                </tr>
            </xsl:if>

        </table>
    </xsl:template>


    <xsl:template name="Interpretation">
        <tr>
            <td class="label">Tolkebehov</td>
            <xsl:for-each select="mc:InterpretationNeeds">
                <xsl:choose>
                    <xsl:when test="mc:ISOLanguageCode">
                        <td>
                            <xsl:value-of select="concat(mc:ISOLanguageCodeDescription,' (',mc:ISOLanguageCode,')')"/>
                        </td>
                    </xsl:when>
                    <xsl:when test="mc:InterpretationIsNeededCode='tolkebehov_nej' ">
                        <td>Nej</td>
                    </xsl:when>
                    <xsl:otherwise>
                        <td>Uafklaret</td>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </tr>
    </xsl:template>

    <xsl:template name="Address">
        <xsl:choose>
            <xsl:when test="mc:StreetName">
                <tr>
                    <td class="label">Adresse</td>
                    <td>
                        <xsl:value-of select="mc:StreetName"/>
                        <xsl:if test="mc:DistrictName | mc:PostCodeIdentifier">
                            <br/>
                            <xsl:value-of select="mc:PostCodeIdentifier"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="mc:DistrictName"/>
                        </xsl:if>
                        <xsl:if test="mc:SuburbName">
                            <br/>
                            <xsl:apply-templates select="mc:SuburbName"/>
                        </xsl:if>
                    </td>
                </tr>


            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="mc:DistrictName | mc:PostCodeIdentifier">
                    <tr>
                        <td class="label">By</td>
                        <td>
                            <xsl:value-of select="mc:PostCodeIdentifier"/>
                            <xsl:value-of select="mc:DistrictName"/>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="CoAddress">
        <xsl:if test="mc:CoAddress">
            <tr>
                <td class="label">C/o adresse</td>
                <td>
                    <xsl:value-of select="mc:CoAddress/mc:PersonGivenName"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="mc:CoAddress/mc:PersonSurnameName"/>
                    <br/>
                    <xsl:value-of select="mc:CoAddress/mc:StreetName"/>
                    <xsl:if test="mc:CoAddress/mc:DistrictName | mc:CoAddress/mc:PostCodeIdentifier">
                        <br/>
                        <xsl:value-of select="mc:CoAddress/mc:PostCodeIdentifier"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="mc:CoAddress/mc:DistrictName"/>
                    </xsl:if>
                    <xsl:if test="mc:CoAddress/mc:SuburbName">
                        <br/>
                        <xsl:apply-templates select="mc:CoAddress/mc:SuburbName"/>
                    </xsl:if>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>


    <xsl:template match="mc:CivilRegistrationNumber | mc:PersonIdentifier">
        <tr>
            <td class="label">CPR nr.</td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:OwnMaternityMother  | mc:BirthMaternityMother">
        <table class="part">
            <xsl:apply-templates select="mc:IdentifierCode"/>
            <xsl:apply-templates select="mc:PersonName"/>
            <xsl:apply-templates select="mc:OrganisationName"/>
            <xsl:call-template name="Address"/>
        </table>
    </xsl:template>

    <xsl:template match="mc:Receiver | mc:CCReceiver">
        <table class="part">
            <xsl:apply-templates select="mc:EANIdentifier"/>
            <xsl:apply-templates select="mc:IdentifierCode"/>
            <xsl:apply-templates select="mc:UnitName"/>
            <xsl:apply-templates select="mc:DepartmentName"/>
            <xsl:apply-templates select="mc:OrganisationName"/>
            <xsl:call-template name="Address"/>
        </table>
    </xsl:template>

    <xsl:template match="mc:Sender">
        <table class="part">
            <xsl:apply-templates select="mc:EANIdentifier"/>
            <xsl:apply-templates select="mc:IdentifierCode"/>
            <xsl:apply-templates select="mc:UnitName"/>
            <xsl:apply-templates select="mc:DepartmentName"/>
            <xsl:apply-templates select="mc:OrganisationName"/>
            <xsl:call-template name="Address"/>
            <xsl:apply-templates select="mc:TelephoneSubscriberIdentifier"/>
            <xsl:if test="mc:ContactInformation">
                <tr>
                    <td class="label">Kontaktperson</td>
                    <td>
                        <xsl:apply-templates select="mc:ContactInformation"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="mc:MedicalSpecialityCode">
                <tr>
                    <td class="label">Medicinsk speciale</td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="mc:MedicalSpecialityCode = 'almen_medicin'">Almen medicin</xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mc:MedicalSpecialityCode"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>
            </xsl:if>
        </table>
    </xsl:template>

    <xsl:template match="mc:IdentifierCode">
        <tr>
            <td class="label">
                <xsl:choose>
                    <xsl:when test="text() = 'sygehusafdelingsnummer'">Sygehusafdeling</xsl:when>
                    <xsl:when test="text() = 'kommunenummer'">Kommunenummer</xsl:when>
                    <xsl:when test="text() = 'ydernummer'">Ydernummer</xsl:when>
                    <xsl:when test="text() = 'lokalt_nummer'">Lokalt nr</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:value-of select="../mc:Identifier"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:DepartmentName">
        <tr>
            <td class="label">Afdeling</td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:UnitName">
        <tr>
            <td class="label">Enhed</td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:EANIdentifier">
        <tr>
            <td class="label">Lokationsnr.</td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:OrganisationName">
        <tr>
            <td class="label">Organisation</td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:Practitioner">
        <table class="part">
            <xsl:apply-templates select="mc:EANIdentifier"/>
            <xsl:apply-templates select="mc:IdentifierCode"/>
            <xsl:apply-templates select="mc:OrganisationName"/>
            <xsl:apply-templates select="mc:DepartmentName"/>
            <xsl:apply-templates select="mc:UnitName"/>
            <xsl:apply-templates select="mc:TelephoneSubscriberIdentifier"/>
            <xsl:call-template name="Address"/>
        </table>
    </xsl:template>

    <xsl:template match="mc:CodedTelephoneSubscriberIdentifier">
        <tr>
            <td class="label">
                <xsl:choose>
                    <xsl:when test="mc:TelephoneCode = 'arbejde'">Arbejdsnummer</xsl:when>
                    <xsl:when test="mc:TelephoneCode = 'mobil'">Mobilnummer</xsl:when>
                    <xsl:when test="mc:TelephoneCode = 'privat'">Privatnummer</xsl:when>
                </xsl:choose>
            </td>
            <td class="value">
                <xsl:value-of select="mc:TelephoneSubscriberIdentifier"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:TelephoneSubscriberIdentifier">
        <tr>
            <td class="label"> Tlf. </td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:EmailAddressIdentifier">
        <tr>
            <td class="label"> E-mail </td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mc:PersonName">
        <tr>
            <td class="label"> Navn </td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:ContactInformation">
        <table class="part">
            <xsl:if test="mc:ContactName">
                <tr>
                    <td class="label">Navn</td>
                    <td>
                        <xsl:for-each select="mc:ContactName">
                            <xsl:value-of select="."/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:apply-templates select="mc:TelephoneSubscriberIdentifier"/>
            <xsl:apply-templates select="mc:EmailAddressIdentifier"/>
            <xsl:apply-templates select="mc:ContactTimeText"/>
        </table>
    </xsl:template>

    <xsl:template match="mc:Relative | mc:PartnerRelation">
        <table class="part">
            <xsl:if test="mc:PersonIdentifier">
                <tr>
                    <td class="label">CPR nr.</td>
                    <td>
                        <xsl:value-of select="mc:PersonIdentifier"/>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td class="field">
                    <xsl:if test="mc:PersonGivenName | mc:PersonSurnameName">
                        <tr>
                            <td class="label">Navn</td>
                            <td class="value">
                                <xsl:if test="mc:PersonGivenName">
                                    <xsl:value-of select="mc:PersonGivenName"/>
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="mc:PersonSurnameName"/>
                            </td>
                        </tr>
                    </xsl:if>
                    <xsl:if test="mc:OccupancyText">
                        <tr>
                            <td class="label">Stilling</td>
                            <td>
                                <xsl:value-of select="mc:OccupancyText"/>
                            </td>
                        </tr>
                    </xsl:if>
                    <xsl:call-template name="Address"/>
                </td>
            </tr>
        </table>
    </xsl:template>

<!--    <xsl:template match="mc:PersonGivenName">
        <tr>
            <td class="label">Fornavn</td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:PersonSurnameName">
        <tr>
            <td class="label">Efternavn</td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
-->
    <xsl:template mode="date-time-row-dmy" match="*">
        <xsl:param name="heading" select="'Dato'"/>
        <tr>
            <td class="label">
                <xsl:value-of select="$heading"/>
            </td>
            <td class="field"><xsl:value-of
                    select="concat(substring(string(mc:Date),9,2),'-',substring(string(mc:Date),6,2),'-',substring(string(mc:Date),1,4))"/> kl.
                    <xsl:value-of select="mc:Time"/></td>
        </tr>
    </xsl:template>


    <xsl:template mode="date-row-dmy" match="*">
        <xsl:param name="heading" select="'Dato'"/>
        <tr>
            <td class="label">
                <xsl:value-of select="$heading"/>
            </td>
            <td class="field">
                <xsl:value-of select="concat(substring(string(mc:Date),9,2),'-',substring(string(mc:Date),6,2),'-',substring(string(mc:Date),1,4))"/>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
