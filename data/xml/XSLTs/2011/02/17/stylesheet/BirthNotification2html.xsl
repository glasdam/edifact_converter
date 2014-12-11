<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:mc="http://rep.oio.dk/medcom.dk/xml/schemas/2011/02/17/">
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="mc:BirthNotification">
        <h4>Fødselsanmeldelse <small>v.<xsl:value-of select="mc:Letter/mc:VersionCode"/> (<xsl:value-of select="mc:Letter/mc:Identifier"
            />)</small></h4>

        <table>
            <tr>
                <td class="heading">Modtager</td>
                <td class="heading">Afsender</td>
            </tr>
            <tr valign="top">
                <td class="field">
                    <xsl:apply-templates select="mc:Receiver"/>
                </td>
                <td class="field">
                    <xsl:apply-templates select="mc:Sender"/>
                </td>
            </tr>
        </table>

        <xsl:if test="mc:CCReceiver">
            <table>
                <tr>
                    <td class="heading">Kopimodtager</td>
                    <td class="container"/>
                </tr>
                <tr valign="top">
                    <td class="field">
                        <xsl:apply-templates select="mc:CCReceiver"/>
                    </td>
                </tr>
            </table>
        </xsl:if>

        <table>
            <tr>
                <td class="heading">Patient</td>
                <td class="heading">Egen læge</td>
            </tr>
            <tr valign="top">
                <td class="field">
                    <xsl:apply-templates select="mc:Patient"/>
                </td>
                <td class="field">
                    <xsl:apply-templates select="mc:Practitioner"/>
                </td>
            </tr>
        </table>

        <table>
            <tr>
                <td class="heading">Egen jordemoder</td>
                <td class="heading">Fødselsjordemoder</td>
            </tr>
            <tr valign="top">
                <td class="field">
                    <xsl:apply-templates select="mc:OwnMaternityMother"/>
                </td>
                <td class="field">
                    <xsl:apply-templates select="mc:BirthMaternityMother"/>
                </td>
            </tr>
        </table>


        <table>
            <tr>
                <td class="heading">Ægtefælle/samlever</td>
            </tr>
            <tr valign="top">
                <td class="field">
                    <xsl:apply-templates select="mc:PartnerRelation"/>
                </td>
            </tr>
        </table>

        <table>
            <tr>
                <td class="heading">Graviditet</td>
            </tr>
            <tr valign="top">
                <td class="field">
                    <xsl:apply-templates select="mc:Pregnancy"/>
                </td>
            </tr>
        </table>

        <table>
            <tr>
                <td class="heading">Fødsel</td>
            </tr>
            <tr valign="top">
                <td class="field">
                    <xsl:apply-templates select="mc:Birth"/>
                </td>
            </tr>
        </table>

        <xsl:for-each select="mc:ChildRelation">
            <xsl:call-template name="ChildRelationAndInfoPart1"/>
            <xsl:call-template name="ChildRelationAndInfoPart2"/>
            <xsl:call-template name="ChildRelationAndInfoPart3"/>
        </xsl:for-each>


    </xsl:template>

    <xsl:template name="ChildRelationAndInfoPart1">

        <xsl:variable name="NC" select="position()"/>
        <table>
            <tr>
                <td class="heading">Barn <xsl:text> </xsl:text>
                    <xsl:value-of select="$NC"/>
                </td>
            </tr>
        </table>
        <table>
            <tr valign="top">
                <td class="field">
                    <xsl:call-template name="ChildRelationLeftSidePart1">
                        <xsl:with-param name="ChildNbr" select="$NC"/>
                    </xsl:call-template>
                </td>
                <td class="field">
                    <xsl:call-template name="ChildRelationRightSidePart1">
                        <xsl:with-param name="ChildNbr" select="$NC"/>
                    </xsl:call-template>
                </td>
            </tr>
        </table>

    </xsl:template>

    <xsl:template name="ChildRelationLeftSidePart1">
        <xsl:param name="ChildNbr"/>
        <table class="part">
            <tr>
                <td class="label">Cpr.nr</td>
                <td>
                    <xsl:value-of select="mc:PersonIdentifier"/>
                </td>
            </tr>
            <xsl:apply-templates select="mc:Gender"/>
        </table>
    </xsl:template>

    <xsl:template name="ChildRelationRightSidePart1">
        <xsl:param name="ChildNbr"/>
        <table class="part">
            <xsl:apply-templates select="mc:TimeOfBirth"/>
            <xsl:call-template name="BirthStatus">
                <xsl:with-param name="Status2" select="mc:BirthStatus1"/>
                <xsl:with-param name="Status1" select="mc:BirthStatus2"/>
            </xsl:call-template>
        </table>
    </xsl:template>

    <xsl:template name="ChildRelationAndInfoPart2">

        <xsl:variable name="NC" select="position()"/>
        <table>
            <tr>
                <td class="heading"/>
                <td class="heading"/>
            </tr>
            <tr valign="top">
                <td class="field">
                    <xsl:call-template name="ApgarScore">
                        <xsl:with-param name="ChildNbr" select="$NC"/>
                    </xsl:call-template>
                </td>
                <td class="field">
                    <xsl:call-template name="Dimensions">
                        <xsl:with-param name="ChildNbr" select="$NC"/>
                    </xsl:call-template>
                </td>
            </tr>
        </table>

    </xsl:template>

    <xsl:template name="ApgarScore">
        <xsl:param name="ChildNbr"/>
        <xsl:variable name="Info" select="parent::node()/mc:ChildInfo[$ChildNbr]"/>

        <xsl:variable name="Apgar" select="$Info/mc:ApgarScore"/>
        <table class="table" rules="all" width="100%">
            <thead>
                <tr>
                    <th>Apgar</th>
                    <th>Score</th>
                    <th>Minutter</th>
                </tr>
            </thead>
            <tr>
                <td>Første</td>
                <td>
                    <xsl:value-of select="$Apgar/mc:ScoreAfterOneMin"/>
                </td>
                <td>1</td>
            </tr>
            <tr>
                <td>Anden</td>
                <td>
                    <xsl:value-of select="$Apgar/mc:ScoreAfterFiveMin"/>
                </td>
                <td>5</td>
            </tr>
            <tr>
                <td>Tredje</td>
                <td>
                    <xsl:value-of select="$Apgar/mc:ScoreAfterTenMin"/>
                </td>
                <td>10</td>
            </tr>
            <tr>
                <td>Minutter v/score 10</td>
                <td>n/a</td>
                <td>
                    <xsl:choose>
                        <xsl:when test="$Apgar/mc:MinutesAtScoreTen">
                            <xsl:value-of select="$Apgar/mc:MinutesAtScoreTen"/>
                        </xsl:when>
                        <xsl:otherwise>n/a</xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="Dimensions">
        <xsl:param name="ChildNbr"/>
        <xsl:variable name="Info" select="parent::node()/mc:ChildInfo[$ChildNbr]"/>

        <xsl:variable name="Dim" select="$Info/mc:ChildDimensions"/>
        <table class="table" rules="all">
            <thead>
                <tr>
                    <th>Mål og Vægt</th>
                    <th/>
                    <th/>
                </tr>
            </thead>
            <tr>
                <td>Vægt</td>
                <td>
                    <xsl:value-of select="$Dim/mc:Weight"/>
                </td>
                <td>Gram</td>
            </tr>
            <tr>
                <td>Længde</td>
                <td>
                    <xsl:value-of select="$Dim/mc:Length"/>
                </td>
                <td>cm</td>
            </tr>
            <tr>
                <td>Hovedomfang</td>
                <td>
                    <xsl:value-of select="$Dim/mc:HeadCircumference"/>
                </td>
                <td>cm</td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="ChildRelationAndInfoPart3">

        <xsl:variable name="ChildNbr" select="position()"/>
        <xsl:variable name="Info" select="parent::node()/mc:ChildInfo[$ChildNbr]"/>
        <xsl:variable name="Prin" select="$Info/mc:ChildPrincipalDiagnoses"/>
        <xsl:variable name="Add" select="$Info/mc:ChildAdditionalDiagnoses"/>
        <xsl:variable name="Other" select="$Info/mc:ChildOtherDiagnoses"/>
        <xsl:variable name="Trans" select="$Info/mc:ChildTransferral"/>
        <xsl:variable name="Remarks" select="$Info/mc:ChildAdditionalInfo"/>
        <table>
            <tr>
                <td class="heading">Diagnoser mm.</td>
            </tr>
            <tr valign="top">
                <td class="field">
                    <!-- This is it -->
                    <table class="part">
                        <tr>
                            <td class="label">Aktionsdiagnoser:</td>
                        </tr>
                        <xsl:call-template name="ShowDiagnoses">
                            <xsl:with-param name="Diagnoses" select="$Prin"/>
                        </xsl:call-template>
                        <tr>
                            <td class="label">Tillægsdiagnoser:</td>
                        </tr>
                        <xsl:call-template name="ShowDiagnoses">
                            <xsl:with-param name="Diagnoses" select="$Add"/>
                        </xsl:call-template>
                        <tr>
                            <td class="label">Øvrige diagnoser:</td>
                        </tr>
                        <xsl:call-template name="ShowDiagnoses">
                            <xsl:with-param name="Diagnoses" select="$Other"/>
                        </xsl:call-template>
                        <xsl:if test="$Trans">
                            <tr>
                                <td class="label">Barn overflyttes</td>
                                <td class="field">
                                    <xsl:value-of select="$Trans"/>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="$Remarks">
                            <tr>
                                <td class="label">Bemærkninger fra fødested:</td>
                            </tr>
                            <table>
                                <xsl:for-each select="$Remarks">
                                    <xsl:variable name="NC" select="position()"/>
                                    <xsl:call-template name="ChildAdditionalInfo">
                                        <xsl:with-param name="Info" select="$Remarks[$NC]"/>
                                    </xsl:call-template>
                                 </xsl:for-each>
                            </table>
                        </xsl:if>
                   </table>
                    <!-- This is it end -->
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="ChildAdditionalInfo">
        <xsl:param name="Info"/>
        <tr>
            <td>
                <xsl:apply-templates mode="formattedtext" select="$Info"/>
            </td>
        </tr>

    </xsl:template>

    <xsl:template name="BirthStatus">
        <xsl:param name="Status1"/>
        <xsl:param name="Status2"/>
        <tr>
            <td class="label">Fødselsstatus</td>
            <td>
                <xsl:value-of select="$Status1"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="$Status2"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="mc:TimeOfBirth">
        <tr>
            <td>
                <xsl:apply-templates mode="date-time-row-dmy" select=".">
                    <xsl:with-param name="heading" select="'Fødselstidspunkt'"/>
                </xsl:apply-templates>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mc:Gender">
        <tr>
            <td class="label">Køn</td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mc:Birth">
        <table class="part">
            <tr>
                <td class="label">Gestationsalder</td>
                <td class="field">
                    <xsl:value-of select="mc:PregnancyDuration/mc:Weeks"/>
                    <xsl:text> uger, </xsl:text>
                    <xsl:value-of select="mc:PregnancyDuration/mc:Days"/>
                    <xsl:text> dage</xsl:text>
                </td>
            </tr>
            <tr>
                <td class="label">Aktionsdiagnoser:</td>
            </tr>
            <xsl:call-template name="ShowDiagnoses">
                <xsl:with-param name="Diagnoses" select="mc:BirthPrincipalDiagnoses"/>
            </xsl:call-template>
            <xsl:if test="mc:BirthAdditionalDiagnoses">
                <tr>
                    <td class="label">Tillægsdiagnoser:</td>
                </tr>
                <xsl:call-template name="ShowDiagnoses">
                    <xsl:with-param name="Diagnoses" select="mc:BirthAdditionalDiagnoses"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="mc:BirthInvestigationAndTreatmentDiagnoses">
                <tr>
                    <td class="label">Undersøgelser og behandlinger:</td>
                </tr>
                <xsl:call-template name="ShowDiagnoses">
                    <xsl:with-param name="Diagnoses" select="mc:BirthInvestigationAndTreatmentDiagnoses"/>
                </xsl:call-template>
            </xsl:if>
            <tr>
                <td class="label">Blødningsmængde</td>
                <td class="field">
                    <xsl:apply-templates mode="formattedtext" select="mc:BleedingVolume"/>
                </td>
            </tr>
            <tr>
                <td class="label">Fostervand</td>
                <td class="field">
                    <xsl:apply-templates mode="formattedtext" select="mc:AmnioticFluidDescription"/>
                </td>
            </tr>
            <xsl:if test="mc:MaternityMotherAppointment">
                <tr>
                    <td class="label">Jordemoderbesøg</td>
                    <td class="field">
                        <xsl:value-of select="mc:MaternityMotherAppointment"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="mc:BirthAdditionalInfo">
                <tr>
                    <td class="label">Bemærkninger:</td>
                </tr>
                <table>
                    <xsl:apply-templates select="mc:BirthAdditionalInfo"/>
                </table>
            </xsl:if>
        </table>
    </xsl:template>

    <xsl:template match="mc:BirthAdditionalInfo">
        <tr>
            <td>
                <xsl:apply-templates mode="formattedtext" select="../mc:BirthAdditionalInfo"/>
            </td>
        </tr>

    </xsl:template>


    <xsl:template match="mc:Pregnancy">
        <xsl:variable name="Status" select="parent::node()/mc:Patient/mc:EpisodeOfCareStatusCode"/>
        <xsl:variable name="Stat" select="$Status/mc:EpisodeOfCareStatusCode"/>

        <table class="part">
            <xsl:if test="mc:DateOfLastMenstruation">
                <xsl:apply-templates mode="date-row-dmy" select="mc:DateOfLastMenstruation">
                    <xsl:with-param name="heading" select="'Sidste menstruation'"/>
                </xsl:apply-templates>
            </xsl:if>
            <xsl:if test="mc:DateofDelivery">
                <xsl:apply-templates mode="date-row-dmy" select="mc:DateofDelivery">
                    <xsl:with-param name="heading" select="'Fastsat termin'"/>
                </xsl:apply-templates>
            </xsl:if>
            <xsl:if test="$Status">
                <tr>
                    <td class="label">Udskrivelse</td>
                    <td class="field">
                        <xsl:choose>
                            <xsl:when test="$Status='direkte_hjem_fra_fødegang' ">Direkte hjem fra fødegang</xsl:when>
                            <xsl:when test="$Status='forventet_udskrevet_inden_24_timer_efter_fødslen' ">Forventet udskrevet inden 24 timer efter
                                fødslen</xsl:when>
                            <xsl:when test="$Status='forventet_udskrevet_senere_end_24_timer_efter_fødslen' ">Forventet udskrevet senere end 24 timer
                                efter fødslen</xsl:when>
                            <xsl:otherwise>Ikke defineret!</xsl:otherwise>
                        </xsl:choose>

                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td class="label">Aktionsdiagnoser:</td>
            </tr>
            <xsl:call-template name="ShowDiagnoses">
                <xsl:with-param name="Diagnoses" select="mc:PregnancyPrincipalDiagnoses"/>
            </xsl:call-template>
            <tr>
                <td class="label">Tillægsdiagnoser:</td>
            </tr>

            <xsl:call-template name="ShowDiagnoses">
                <xsl:with-param name="Diagnoses" select="mc:PregnancyAdditionalDiagnoses"/>
            </xsl:call-template>
            <tr>
                <td class="label">Undersøgelser og behandlinger:</td>
            </tr>
            <xsl:apply-templates select="mc:PregnancyInvestigationAndTreatments"/>
            <tr>
                <td class="label">Bemærkninger:</td>
            </tr>
            <table>
                <xsl:apply-templates select="mc:PregnancyInvestigationAndTreatments/mc:InvestigationAndTreatmentText"/>
            </table>
        </table>

    </xsl:template>

    <xsl:template match="mc:PregnancyInvestigationAndTreatments">
        <xsl:call-template name="ShowDiagnoses">
            <xsl:with-param name="Diagnoses" select="mc:InvestigationAndTreatmentDiagnoses"/>
        </xsl:call-template>
        <xsl:if test="mc:ClinicalInfoDate">
            <xsl:apply-templates mode="date-time-row-dmy" select="mc:ClinicalInfoDate">
                <xsl:with-param name="heading" select="' '"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mc:PregnancyInvestigationAndTreatments/mc:InvestigationAndTreatmentText">
        <tr>
            <td>
                <xsl:apply-templates mode="formattedtext" select="../mc:InvestigationAndTreatmentText"/>
            </td>
        </tr>

    </xsl:template>

    <xsl:template name="ShowDiagnoses">
        <xsl:param name="Diagnoses"/>
        <tr>
            <td>
                <xsl:for-each select="$Diagnoses">
                    <xsl:variable name="NC" select="position()"/>
                    <tr>
                        <td>
                            <xsl:value-of select="$Diagnoses[$NC]/mc:DiagnoseCode"/>
                        </td>
                        <td>
                            <xsl:value-of select="$Diagnoses[$NC]/mc:DiagnoseText"/>
                        </td>
                    </tr>
                    <xsl:if test="$Diagnoses[$NC]/mc:DiagnoseDateTime">
                        <xsl:apply-templates mode="date-time-row-dmy" select="$Diagnoses[$NC]/mc:DiagnoseDateTime">
                            <xsl:with-param name="heading" select="' '"/>
                        </xsl:apply-templates>
                    </xsl:if>
                </xsl:for-each>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mc:PregnancyPrincipalDiagnoses">
        <h5>Diagnoser</h5>
        <table>
            <tr>
                <td class="field" colspan="2">
                    <table class="table" rules="all">
                        <thead>
                            <tr>
                                <th>Diagnosekode</th>
                                <th style="width: 18%">Klassifikation</th>
                                <th style="width: 60%">Beskrivelse</th>
                            </tr>
                        </thead>
                        <xsl:for-each select="mc:PregnancyPricipalDiagnoses">
                            <tr>
                                <td>
                                    <xsl:value-of select="mc:DiagnoseCode"/>
                                </td>
                                <td>
                                    <xsl:choose>
                                        <xsl:when test="mc:DiagnoseTypeCode = 'SKSdiagnosekode'">SKS Diagnosekode</xsl:when>
                                        <xsl:when test="mc:DiagnoseTypeCode = 'uspecificeretkode'">Uspecificeret</xsl:when>
                                        <xsl:when test="mc:DiagnoseTypeCode = 'ICPCkode'">ICPC kode</xsl:when>
                                        <xsl:when test="mc:DiagnoseTypeCode = 'speciallaegehenvisning'">Speciallægehenvisningskode</xsl:when>
                                        <xsl:when test="mc:DiagnoseTypeCode = 'fysioterapihenvisning'">Fysioterapihenvisningskode</xsl:when>
                                        <xsl:when test="mc:DiagnoseTypeCode = 'psykologhenvisning'">Psykologhenvisningskode</xsl:when>
                                        <xsl:when test="mc:DiagnoseTypeCode = 'Fysioterapihenvisningsdiagnose'"
                                            >Fysioterapihenvisningsdiagnose</xsl:when>
                                        <xsl:when test="mc:DiagnoseTypeCode = 'Psykologhenvisningsdiagnose'">Psykologhenvisningsdiagnose</xsl:when>
                                    </xsl:choose>
                                </td>
                                <td>
                                    <xsl:value-of select="mc:DiagnoseText"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template>


</xsl:stylesheet>
