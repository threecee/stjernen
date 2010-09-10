<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/libraries/commons/includes/utilities.xsl"/>
  <xsl:variable name="icalAddress">
        <xsl:value-of select="/result/contents/content/contentdata/ical"/>
  </xsl:variable>
  <xsl:variable name="tittel">
    <xsl:value-of select="/result/contents/content/contentdata/title"/>
  </xsl:variable>
  <xsl:variable name="width" select="252"/>
  <xsl:variable name="height" select="220"/>
  
  <xsl:template match="/">
 <!-- 
    <p width="100%" align="center">
      <embed pluginspage="http://www.adobe.com/go/getflashplayer" 
        src="http://www.yourminis.com/Dir/GetContainer.api?uri=yourminis/yourminis/mini:calendar"  
        wmode="transparent" width="{$width}" height="{$height}" 
        FlashVars="iCalUrl={$icalAddress}&amp;alpha=84&amp;mytitle={$tittel}&amp;mininame=calendar&amp;height={$height - 10}&amp;width={$width - 10}&amp;xheight={$width}&amp;xwidth={$height}&amp;dayoffset=0&amp;uri=yourminis%2Fyourminis%2Fmini%3Acalendar&amp;swfurl=%2Fwidget%5Fcalendar%2Eswf&amp;" 
        type="application/x-shockwave-flash" allowScriptAccess="always">
        
      </embed>
      </p> 
    <iframe src="http://www.google.com/calendar/embed?usa@holiday.calendar.google.com&amp;ctz=Europe/Oslo" style="border: 0" width="300" height="200" frameborder="0" scrolling="no"></iframe>
 -->
    <iframe src="http://www.google.com/calendar/embed?src=5gstpfg5ekj498ct0p0k9epl2c%40group.calendar.google.com&amp;ctz=Europe/Oslo" style="border: 0" width="800" height="600" frameborder="0" scrolling="no"></iframe>  </xsl:template>

</xsl:stylesheet>