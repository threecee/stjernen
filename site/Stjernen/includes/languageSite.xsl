<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="textTemp">
        <translations>
            <close_window en="Close window" no="Lukk vindu" ru="Закрыть окно" sv="Stäng fönstret"/>
            <close_icon en="Close icon" no="Lukkeikon" ru="" sv="Stänk ikonen"/>
            <print_page en="Print page" no="Skriv ut" ru="Печатать страницу" sv="Skriv ut sidan"/>
            <printer_icon en="Printer icon" no="Printerikon" ru="" sv="Skrivarikon"/>
            <logo en="Logo" no="Logo" ru="Логотип" sv="Logo"/>
            <printer_version en="Printer-version" no="Utskriftsversjon" ru="Версия для печати" sv="utskriftsversion"/>
            <printer_version_icon en="Printer-version icon" no="Utskriftsversjonsikon" ru="" sv="utskriftsversionsikon"/>
            <login en="Login" no="Logg inn" ru="Логин" sv="Logga in"/>
            <username en="Username" no="Brukernavn" ru="Имя пользователя" sv="Användarnamn"/>
            <password en="Password" no="Passord" ru="Пароль" sv="Lösenord"/>
            <required_input en="Required input" no="Påkrevd felt" ru="Поля, обязательные для заполнения" sv="Detta fält måste fyllas i"/>
            <user_already_logged_in en="User already logged in" no="Bruker allerede logget inn" ru="Пользователь уже зарегистрирован" sv="Användaren är redan inloggad"/>
            <logout en="Logout" no="Logg ut" ru="Выйти" sv="Logga ut"/>
            <error_user_login_105 en="Failed to authenticate user" no="Kunne ikke autentisere bruker" ru="Не удалось распознать пользователя" sv="Kunde inte autentisiera användaren"/>
            <error_user_login_106 en="Wrong username or password" no="Feil brukernavn eller passord" ru="Неверное имя пользователя или пароль" sv="Fel användarnamn eller lösenord"/>
            <forgotten_password en="Forgotten your password" no="Glemt passord" ru="Забыли пароль" sv="Glömt ditt lösenord"/>
            <error_user_resetpwd_103 en="User not found" no="Bruker ikke funnet" ru="Пользователь не найден" sv="Användare finns inte"/>
            <username_or_email en="Username or email address" no="Brukernavn eller e-postadresse" ru="Имя пользователя или e-mail" sv="Användarnamn eller epost adress"/>
            <get_password en="Get password" no="Send passord" ru="Получить пароль" sv="Skicka lösenord"/>
            <remember_me en="Remember me" no="Husk meg" ru="Запомнить меня" sv="Kom ihåg mig"/>
            <your_password en="Your password" no="Ditt passord" ru="Ваш пароль" sv="Ditt lösenord"/>
            <password_sent en="Password is sent" no="Passordet er sendt" ru="Пароль отправлен" sv="Lösenordet är skickat"/>
            <logged_in_as en="Logged in as" no="Logget inn som" ru="Зарегистрирован как" sv="Inloggad som"/>
            <tip_friend en="Tip a friend" no="Tips en venn" ru="Отправить другу" sv="Tipsa en vän"/>
            <powered_by_VS en="Powered by" no="Drives av" ru="Поддержка:" sv="Utvecklat av"/>
            <back en="Back" no="Tilbake"/>
            <tip_confirmation en="Your tip has been sendt" no="Tipset er sendt"/>
            <tip_failure en="An error occured while sending you tip. Please try again. If the problem persists, contact" no="Det oppsto en feil ved sending av tipset ditt. Vennligst forsøk igjen. Dersom feilen gjentar seg, kontakt"/>
            <missing_or_invalid_email en="Input missing or invalid format (use name@domain.com)" no="Informasjon mangler eller formatet er feil (bruk navn@domene.no)"/>
            <tip_from en="Tip from" no="Tips fra"/>
            <tip en="Tip" no="Tips"/>
            <email_text1 en="would like to tell you about a page on" no="vil gjerne tipse om en side på"/>
            <email_text2 en="The address to the page is" no="Adressen til siden er"/>
            <writes en="writes" no="skriver"/>
            <reciever_name en="Friend's name" no="Vennens navn"/>
            <reciever_email en="Friend's e-mail address" no="Vennens e-postadresse"/>
            <from_name en="Your name" no="Ditt navn"/>
            <from_email en="Your e-mail address" no="Din e-postadresse"/>
            <greeting en="Greeting" no="Hilsen"/>
            <send_tip en="Send tip" no="Send tips"/>
            <you_are_here en="You are here" no="Du er her"/>
            <frontpage en="Home" no="Forsiden"/>
            
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