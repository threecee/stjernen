<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs" version="2.0" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:include href="/site/Stjernen/includes/globalVars.xsl"/>
    <xsl:param name="season" select="3005"/>
    <xsl:param name="preSeason" select="3202"/>
    <xsl:param name="team" select="137830"/>
    <xsl:param name="playOff" select="3713"/>
    <xsl:param name="flashHeading" select="Statistikk"/>
    <xsl:template match="/">
        
        <div class="bannerbox">  
            <h2>Statistikk</h2>
            <object type="application/x-shockwave-flash" data="{$GamecenterFlash}" width="306" height="145">
                <param name="flashvars" value="teamID={$team}&amp;seasonID={$season}&amp;preSeasonId={$preSeason}&amp;playOffId={$playOff}"/>
                <param name="Transparent" value="WMode" />
                
            </object>
        </div>
    </xsl:template>
</xsl:stylesheet>