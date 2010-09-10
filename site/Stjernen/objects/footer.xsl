<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"
  xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal"
  xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/shared/includes/displayImage.xsl"/>
  <xsl:include href="/site/Stjernen/includes/globalVars.xsl"/>
  <xsl:param as="xs:integer" name="imageMaxWidth" select="400"/>
   <xsl:template match="/">
     <div class="footerText">
     Ansvarlig redaktør: Rolf E. Halvorsen | © Stjernen Hockey 2009 Postadresse: Postboks 85, 1601 Fredrikstad | Telefon: 69 36 83 00 | Fax: 69 36 83 01<br/>
     Kopiering av innhold er ikke tillatt uten avtale med Stjernen Hockey. Tekst fra nyhetssidene våre skal ikke gjengis uten henvisning og link til stjernen.no<br/>
     Bilder fra bildegalleriet kan ikke benyttes uten avtale. 
     </div>
  <!--
     <div class="rss">
       <a href="{portal:createPageUrl($rssPage, ())}" title="RSS Feed">
       <img alt="RSS Feed" class="feedicon" src="{portal:createResourceUrl($feedIcon)}"/>
       </a>
       </div>
       <span>Copyright © 2009 Stjernen Hockey | Utsikten 16, 1614 Fredrikstad | <a
       href="mailto:post@stjernen.no">post@stjernen.no</a> | telefon 69 84 35 00 | <a
       href="{portal:createPageUrl($contactPage, ())}" title="Kontakt oss">Kontakt oss</a> |
       Powered by <a href="http://www.Enonic.com">Enonic Vertical Site</a> | Developed and Designed
       by <a href="http://www.bekk.no">Bekk Consulting AS</a>
       </span>-->
       
</xsl:template>
</xsl:stylesheet>