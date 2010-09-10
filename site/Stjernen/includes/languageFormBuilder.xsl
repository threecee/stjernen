<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="textTemp">
        <translations>
            <select en="Select" no="Velg" ru="Выбрать"/>
            <confirmation en="Confirmation" no="Bekreftelse" ru="Подтверждение"/>
            <required_input en="Required input" no="Påkrevd felt" ru="Поля, обязательные для заполнения"/>
            <invalid_email_address en="Invalid e-mail address" no="Ugyldig e-postadresse" ru="Неверный e-mail"/>
            <not_integer en="Not an integer" no="Ikke et heltall" ru=""/>
            <incorrect_format en="Incorrect format" no="Feil format" ru="Неверный формат"/>
            <submit_form en="Submit form" no="Send skjema" ru="Отправить анкету"/>
            <reset en="Reset" no="Nullstill" ru="Обновить"/>
            <error_icon en="Error icon" no="Feilikon" ru=""/>
            <help_icon en="Help icon" no="Hjelpeikon" ru=""/>
        </translations>
    </xsl:variable>
    <xsl:variable name="textTemp2">
        <xsl:apply-templates mode="translations" select="$textTemp/translations/*"/>
    </xsl:variable>
    <xsl:variable name="translations" select="$textTemp2"/>
    <xsl:template match="*" mode="translations">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="@*[name() = $language] != ''">
                    <xsl:value-of select="@*[name() = $language]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>[NOT TRANSLATED]</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>