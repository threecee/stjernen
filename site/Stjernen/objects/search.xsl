<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="xsl portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:portal="http://www.enonic.com/cms/xslt/portal">
  <xsl:output indent="yes" method="xhtml"/>
  <xsl:include href="/shared/includes/languageForum.xsl"/>
  <xsl:param name="searchPage">
    <type>page</type>
  </xsl:param>
  <xsl:variable name="language" select="/result/context/@languagecode"/>

  <xsl:template match="/">
    <div class="frame">
      <!--h2 class="leftmenutitle"-->
      <h4>
        <xsl:value-of select="$translations/search_forum[1]"/>
      </h4>
      <form action="{portal:createPageUrl($searchPage, ('cat','hei'))}" method="get">
        <div class="box">
          <input id="query" name="query" style="width: 113px;" type="text" value="{/result/context/querystring/parameter[@name = 'query']}"/>
          <input class="search-button" type="submit" value="{$translations/search[1]}"/>
        </div>
      </form>
    </div>
  </xsl:template>
</xsl:stylesheet>