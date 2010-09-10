<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/site/Stjernen/includes/languageArticle.xsl"/>
  <!--xsl:include href="/shared/includes/displayImage.xsl"/-->
  <xsl:include href="/libraries/commons/includes/utilities.xsl"/>
  <xsl:include href="/shared/includes/cropText.xsl"/>
  <xsl:include href="/shared/includes/formatDate.xsl"/>
  <xsl:include href="/shared/includes/replaceSubstring.xsl"/>
  <xsl:include href="/shared/includes/navigationMenu.xsl"/>
  <xsl:param name="showDate" select="'true'"/>
  <xsl:param as="xs:integer" name="prefaceLength" select="1000"/>
  <xsl:param name="showImage" select="'true'"/>
  <xsl:param name="showReadMoreText" select="'true'"/>
  <xsl:param name="showNavigationMenu" select="'true'"/>
  <xsl:param as="xs:integer" name="contentsPerPage" select="10"/>
  <xsl:param as="xs:integer" name="pagesInNavigation" select="10"/>
  <xsl:param as="xs:integer" name="imageMaxWidth" select="620"/>
  <xsl:variable name="language" select="/result/context/@languagecode"/>
  <xsl:variable as="xs:integer" name="totalCount" select="/result/contents/@totalcount"/>
  <xsl:variable as="xs:integer" name="contentCount" select="count(/result/contents/content)"/>
  <xsl:variable name="indexTemp" select="/result/context/querystring/parameter[@name='index']"/>
  <xsl:variable name="index">
    <xsl:choose>
      <xsl:when test="$indexTemp != '' and string(number($indexTemp)) != 'NaN'">
        <xsl:value-of select="number($indexTemp)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/result/contents/@totalcount = 0">
        <p>
          <xsl:value-of select="$translations/no_items[1]"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
          <xsl:call-template name="navigationHeader"/>
        </xsl:if>
        <xsl:apply-templates select="/result/contents/content"/>
        <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
          <xsl:call-template name="navigationMenu"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="content">
    <xsl:variable name="url" select="portal:createContentUrl(@key, ())"/>
    <div class="item">
      <xsl:if test="position() = 1">
        <xsl:attribute name="class">item first</xsl:attribute>
      </xsl:if>
      <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/artikkel/bilder/bilde/binary/content[1]/@key] and $showImage != 'false'">
        <a href="{$url}">
          <xsl:call-template name="display-image">
            <xsl:with-param name="image" select="contentdata/artikkel/bilder/bilde/binary/content[1]"/>
            <xsl:with-param name="filter" select="'scalewidth(300)'"/>
            <xsl:with-param name="class" select="'img'"/>
            <xsl:with-param name="region-width" select="0"/>
          </xsl:call-template>
        </a>
      </xsl:if>
      <h2>
        <a href="{$url}">
          <xsl:choose>
            <xsl:when test="contentdata/stikktittel != ''">
              <xsl:value-of select="contentdata/stikktittel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="contentdata/stikktittel"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </h2>
      <xsl:if test="string-length(contentdata/artikkel/kortingress) > 0 or string-length(contentdata/artikkel/langingress) > 0">
        <xsl:variable name="preface">
          <xsl:call-template name="cropText">
            <xsl:with-param name="sourceText">
              <xsl:choose>
                <xsl:when test="contentdata/artikkel/kortingress != ''">
                  <xsl:value-of disable-output-escaping="yes" select="contentdata/artikkel/kortingress"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="contentdata/artikkel/langingress"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="numCharacters" select="$prefaceLength"/>
          </xsl:call-template>
        </xsl:variable>
        <p>
          <xsl:if test="$showDate != 'false'">
            <span class="byline">
              <xsl:if test="$showDate != 'false'">
                <xsl:call-template name="formatDate">
                  <xsl:with-param name="date" select="@publishfrom"/>
                  <xsl:with-param name="format" select="'short'"/>
                </xsl:call-template>
              </xsl:if>
            </span>
          </xsl:if>
          <xsl:call-template name="replaceSubstring">
            <xsl:with-param name="inputString" select="$preface"/>
          </xsl:call-template>
        </p>
      </xsl:if>
      <xsl:if test="$showReadMoreText != 'false'">
        <p>
          <span class="read-more">
          <a href="{$url}">
            <xsl:choose>
              <xsl:when test="contentdata/teaser/read_more != ''">
                <xsl:value-of select="concat('» ',contentdata/teaser/read_more)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('» ',$translations/read_more)"/>
              </xsl:otherwise>
            </xsl:choose>
          </a>
          </span>
        </p>
      </xsl:if>
    </div>
  </xsl:template>
</xsl:stylesheet>