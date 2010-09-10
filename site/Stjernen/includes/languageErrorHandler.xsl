<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="textTemp">
        <translations>
            <error_100 en="An unexpected error occurred" no="En uventet feil har oppstått" sv="An unexpected error occurred"/>
            <error_101 en="An error occurred while rendering the page" no="Malfeil på siden" sv="An error occurred while rendering the page"/>
            <error_102 en="Negative page id" no="Negativ side-id" sv="Negative page id"/>
            <error_103 en="The page does not exist" no="Siden eksisterer ikke" sv="The page does not exist"/>
            <error_104 en="The page does not exist in this site" no="Siden eksisterer ikke i denne siten" sv="The page does not exist in this site"/>
            <error_105 en="Access denied" no="Manglende rettigheter" sv="Access denied"/>
            <error_106 en="Wrong sitekey" no="Feil site-key" sv="Wrong sitekey"/>
            <error_107 en="Login page is not accessible" no="Loginsiden er ikke tilgjengelig" sv="Login page is not accessible"/>
            <error_108 en="Invalid page id" no="Ugyldig side-id" sv="Invalid page id"/>
            <error_userservices_500 en="Userservices: Unexpected error." no="Userservices: Uventet feil." sv="Userservices: Unexpected error."/>
            <error_userservices_501 en="Userservices: Handler not defined." no="Userservices: Handler ikke definert." sv="Userservices: Handler not defined."/>
            <error_userservices_502 en="Userservices: Unknown handler." no="Userservices: Ukjent handler." sv="Userservices: Unknown handler."/>
            <error_userservices_503 en="Userservices: Dispatch to handler failed." no="Userservices: Dispatch til handler feilet." sv="Userservices: Dispatch to handler failed."/>
            <error_userservices_504 en="Userservices: Backend operation failed." no="Userservices: Backendoperasjon feilet." sv="Userservices: Backend operation failed."/>
            <error_userservices_505 en="Userservices: Handler operation failed." no="Userservices: Handleroperasjon feilet." sv="Userservices: Handler operation failed."/>
            <error_userservices_506 en="Userservices: Permission denied." no="Userservices: Ingen tillatelse." sv="Userservices: Permission denied."/>
            <error_userservices_507 en="Userservices: Bean not found." no="Userservices: Bean ikke funnet." sv="Userservices: Bean not found."/>
            <error_userservices_508 en="Userservices: Bean lookup failed." no="Userservices: Bean lookup feilet." sv="Userservices: Bean lookup failed."/>
            <error_handler_operation_400 en="Userservices: Missing parameters." no="Userservices: Manglende parametre." sv="Userservices: Missing parameters."/>
            <error_handler_operation_401 en="Userservices: Illegal values in parameters." no="Userservices: Ulovlige verdier i parametre." sv="Userservices: Illegal values in parameters."/>
            <error_handler_operation_402 en="Userservices: Failed sending e-mail." no="Userservices: Sending av e-post feilet." sv="Userservices: Failed sending e-mail."/>
            <error_handler_operation_403 en="Userservices: Missing ticket." no="Userservices: Manglende ticket." sv="Userservices: Missing ticket."/>
            <error_handler_operation_404 en="Userservices: Invalid ticket." no="Userservices: Ugyldig ticket." sv="Userservices: Invalid ticket."/>
            <please_try_again en="Please try again. If the problem persists please contact" no="Vennligst forsøk igjen. Dersom problemet vedvarer vennligst kontakt" sv="Please try again. If the problem persists please contact"/>
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