<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:util="enonic:utilities" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
  <xsl:include href="/libraries/utilities/utilities.xsl"/>
  <xsl:include href="/libraries/utilities/process-html-area.xsl"/>

  <xsl:output indent="no" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/result/contents/content">
        <div id="article" class="clear append-bottom">
          <xsl:apply-templates select="/result/contents/content"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <p class="clear">
          <xsl:value-of select="portal:localize('No-article')"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="content">
    <h1>
      <xsl:value-of select="title"/>
    </h1>
    <xsl:choose>
      <xsl:when test="$device-class = 'mobile'">
        <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image/@key]">
          <div class="related">
            <div class="image">
              <xsl:call-template name="utilities.display-image">
                <xsl:with-param name="region-width" select="$region-width"/>
                <xsl:with-param name="filter" select="$config-filter"/>
                <xsl:with-param name="imagesize" select="$config-imagesize"/>
                <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/contentdata/image/@key]"/>
                <xsl:with-param name="size" select="'full'"/>
              </xsl:call-template>
            </div>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="related-content">
          <xsl:with-param name="size" select="'regular'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="contentdata/stiftet">
      <p class="date">
        Stiftet: <xsl:value-of select="util:format-date(contentdata/stiftet, /result/context/@languagecode, 'short', true())"/>
      </p>
    </xsl:if>
    <xsl:if test="contentdata/arena">
      <p class="arena">
        <xsl:value-of select="contentdata/arena"/>
      </p>
    </xsl:if>
    <xsl:if test="contentdata/url">
      <p class="homepage">
        <a href="{contentdata/url}" rel="external">Besøk hjemmesiden</a>
      </p>
    </xsl:if>
    <xsl:call-template name="process-html-area.process-html-area">
      <xsl:with-param name="region-width" tunnel="yes" select="$region-width"/>
      <xsl:with-param name="filter" tunnel="yes" select="$config-filter"/>
      <xsl:with-param name="imagesize" tunnel="yes" select="$config-imagesize"/>
      <xsl:with-param name="document" select="contentdata/text"/>
      <xsl:with-param name="image" tunnel="yes" select="/result/contents/relatedcontents/content"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="related-content">
    <xsl:param name="size"/>
    <xsl:param name="start" select="1"/>
    <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image/@key]">
      <div class="related">
        <xsl:if test="not($device-class = 'mobile')">
          <xsl:attribute name="style">
            <xsl:value-of select="concat('width: ', floor($region-width * $config-imagesize[@name = $size]/width), 'px;')"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/image/@key]">
          <xsl:for-each select="contentdata/image[@key = /result/contents/relatedcontents/content/@key]">
            <div class="image">
              <xsl:call-template name="utilities.display-image">
                <xsl:with-param name="region-width" select="$region-width"/>
                <xsl:with-param name="filter" select="$config-filter"/>
                <xsl:with-param name="imagesize" select="$config-imagesize"/>
                <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = current()/@key]"/>
                <xsl:with-param name="size" select="$size"/>
              </xsl:call-template>
            </div>
          </xsl:for-each>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
