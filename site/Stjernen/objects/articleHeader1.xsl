<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/site/Stjernen/includes/languageArticle.xsl"/>
  <xsl:include href="/shared/includes/displayImage.xsl"/>
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
  <xsl:param as="xs:integer" name="imageMaxWidth" select="196"/>
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
        <xsl:apply-templates select="/result/contents/content"/>
  </xsl:template>
  <xsl:template match="content">
    <xsl:variable name="url" select="portal:createContentUrl(@key, ())"/>
    <div class="item">
      <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/teaser/image/@key] and $showImage != 'false'">
        <div class="wideimage"><a href="{$url}">
          <xsl:call-template name="displayImage">
            <xsl:with-param name="key" select="contentdata/teaser/image/@key"/>
            <xsl:with-param name="imageMaxWidth" select="$imageMaxWidth"/>
          </xsl:call-template>
        </a>
        </div>
      </xsl:if>
            <h2>
        <a href="{$url}">
          <xsl:choose>
            <xsl:when test="contentdata/teaser/heading != ''">
              <xsl:value-of select="contentdata/teaser/heading"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="contentdata/heading"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </h2>
      <xsl:if test="string-length(contentdata/teaser/preface) > 0 or string-length(contentdata/article/preface) > 0">
        <xsl:variable name="preface">
          <xsl:call-template name="cropText">
            <xsl:with-param name="sourceText">
              <xsl:choose>
                <xsl:when test="contentdata/teaser/preface != ''">
                  <xsl:value-of disable-output-escaping="yes" select="contentdata/teaser/preface"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="contentdata/article/preface"/>
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