<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/site/Stjernen/includes/languageArticle.xsl"/>
  <xsl:include href="/shared/includes/displayImage.xsl"/>
  <xsl:include href="/shared/includes/cropText.xsl"/>
  <xsl:include href="/shared/includes/formatDate.xsl"/>
  <xsl:include href="/shared/includes/convertBytes.xsl"/>
  <xsl:include href="/shared/includes/getIconImage.xsl"/>
  <xsl:include href="/shared/includes/replaceSubstring.xsl"/>
  <xsl:include href="/shared/includes/strictFilter.xsl"/>
  <xsl:param name="showRelatedArticle">
    <type>page</type>
  </xsl:param>
  <xsl:param name="showDate" select="'true'"/>
  <xsl:param name="showAuthor" select="'false'"/>
  <xsl:param as="xs:integer" name="imageMaxWidth" select="620"/>
  <xsl:param as="xs:integer" name="fileDescriptionLength" select="100"/>
  <xsl:param name="showFileDate" select="'false'"/>
  <xsl:param name="showFileSize" select="'true'"/>
  <xsl:variable name="language" select="/result/context/@languagecode"/>
  <xsl:variable name="ucase">ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ1234567890</xsl:variable>
  <xsl:variable name="lcase">abcdefghijklmnopqrstuvwxyzæøå1234567890</xsl:variable>

  <xsl:template match="/">
    <div class="item">
      <xsl:comment>articleShow</xsl:comment>
      <xsl:apply-templates select="/result/contents/content"/>
    </div>
  </xsl:template>

  <xsl:template match="content">
    <xsl:if test="$showDate != 'false'">
      <span class="byline">
        <xsl:value-of select="concat($translations/published,' ')"/>
        <xsl:if test="$showDate != 'false'">
          <xsl:call-template name="formatDate">
            <xsl:with-param name="date" select="@publishfrom"/>
            <xsl:with-param name="format" select="'short'"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$showAuthor != 'false' and /result/contents/relatedcontents/content[@key = current()/contentdata/authors/content/@key]">
          <xsl:variable name="currentAuthor" select="/result/contents/relatedcontents/content[@key = current()/contentdata/authors/content/@key]/contentdata/thumbnail/@key"/>
          <xsl:value-of select="concat(' ',$translations/text_by, ' ')"/>
          <xsl:apply-templates mode="author" select="contentdata/authors/content[@key = /result/contents/relatedcontents/content/@key]"/>
        </xsl:if>
      </span>
    </xsl:if>
    <h1><xsl:value-of select="contentdata/tittel"/></h1>
    <xsl:if test="contentdata/links/link/url != '' or contentdata/files/file/binary/file or contentdata/articles/content/@key or contentdata/artikkel/bilder/bilde/binary/content/@key">
      <div id="relations">
        <xsl:attribute name="style">
        	<xsl:value-of select="concat('width: ', $imageMaxWidth, 'px')"/>
        </xsl:attribute>
        <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/artikkel/bilder/bilde/binary/content/@key]">
          <xsl:call-template name="relatedImages"/>
        </xsl:if>
        <xsl:if test="contentdata/links/link/url != ''">
          <xsl:call-template name="relatedLinks"/>
        </xsl:if>
        <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/files/file/binary/file/@key]">
          <xsl:call-template name="relatedFiles"/>
        </xsl:if>
        <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/articles/content/@key]">
          <xsl:call-template name="relatedArticles"/>
        </xsl:if>
      </div>
    </xsl:if>
    <!-- ingress / preface -->
    <xsl:if test="string-length(contentdata/artikkel/langingress) > 0">
      <p class="preface">
        <xsl:call-template name="replaceSubstring">
          <xsl:with-param name="inputString" select="contentdata/article/langingress"/>
        </xsl:call-template>
      </p>
    </xsl:if>
    <!-- innhold / content from the editor -->
    <xsl:if test="contentdata/artikkel/tekst/*">
      <div class="editor">
        <xsl:comment>content from the editor</xsl:comment>
        <xsl:apply-templates select="contentdata/artikkel/tekst"/>
      </div>
    </xsl:if>
    <div id="back-top"><a href="#top"><xsl:value-of select="$translations/to_top"/></a></div>
  </xsl:template>

  <xsl:template match="content" mode="author">
    <xsl:variable name="currentAuthor" select="/result/contents/relatedcontents/content[@key = current()/@key]"/>
    <xsl:if test="$currentAuthor/contentdata/email != ''">
      <xsl:text disable-output-escaping="yes">&lt;a href="mailto:</xsl:text>
      <xsl:value-of select="$currentAuthor/contentdata/email"/>
      <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
    </xsl:if>
    <xsl:value-of select="concat($currentAuthor/contentdata/firstname, ' ', $currentAuthor/contentdata/surname)"/>
    <xsl:if test="$currentAuthor/contentdata/email != ''">
      <xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="position() = (last() - 1)">
        <xsl:value-of select="concat(' ', $translations/and, ' ')"/>
      </xsl:when>
      <xsl:when test="position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tekst">
    <xsl:apply-templates select="*|text()"/>
  </xsl:template>

  <!-- diffenrent relations -->
  <xsl:template name="relatedImages">
    <div id="images">
      <xsl:for-each select="contentdata/artikkel/bilder/bilde/binary/content[@key = /result/contents/relatedcontents/content/@key]">
        <xsl:variable name="currentImage" select="/result/contents/relatedcontents/content[@key = current()/@key]"/>
        <div class="image">
          <xsl:attribute name="style">
            <xsl:value-of select="concat('width: ', $imageMaxWidth, 'px')"/>
          </xsl:attribute>
          <xsl:call-template name="displayImage">
            <xsl:with-param name="image" select="$currentImage"/>
            <xsl:with-param name="imageMaxWidth" select="$imageMaxWidth"/>
          </xsl:call-template>
          <xsl:if test="text != ''">
            <div class="text"><xsl:value-of select="text"/></div>
          </xsl:if>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template name="relatedArticles">
    <div class="related-frame">
      <h4><xsl:value-of select="$translations/related_articles"/></h4>
      <div class="related-inner">
        <ul class="related">
        <xsl:for-each select="contentdata/articles/content[@key = /result/contents/relatedcontents/content/@key]">
          <xsl:variable name="currentItem" select="/result/contents/relatedcontents/content[@key = current()/@key]"/>
          <xsl:variable name="articleUrl" select="portal:createContentUrl($currentItem/@key, ())"/>
          <li>
            <xsl:if test="position() mod 2 = 0">
              <xsl:attribute name="class">dark</xsl:attribute>
            </xsl:if>
            <a>
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="$currentItem/sectionnames/sectionname"><xsl:value-of select="$articleUrl"/></xsl:when>
                  <xsl:otherwise>page?id=<xsl:value-of select="$showRelatedArticle"/>&amp;key=<xsl:value-of select="@key"/></xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            <xsl:value-of select="$currentItem/title"/></a>
          </li>
        </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="relatedLinks">
    <div class="related-frame">
      <h4><xsl:value-of select="$translations/link"/></h4>
      <div class="related-inner">
        <ul class="related">
        <xsl:for-each select="contentdata/links/link">
          <li>
            <xsl:if test="position() mod 2 = 0">
              <xsl:attribute name="class">dark</xsl:attribute>
            </xsl:if>
            <a href="{url}">
              <xsl:if test="target = 'new'"><xsl:attribute name="rel">external</xsl:attribute><xsl:attribute name="class">external</xsl:attribute></xsl:if>
              <xsl:choose>
                <xsl:when test="description != ''">
                  <xsl:attribute name="title"><xsl:value-of select="description"/></xsl:attribute>
                  <xsl:value-of select="description"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="url"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </li>
        </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="relatedFiles">
    <div class="related-frame">
      <h4><xsl:value-of select="$translations/filename"/></h4>
      <div class="related-inner">
        <ul class="related">
        <xsl:for-each select="contentdata/files/file">
          <xsl:variable name="currentFile" select="/result/contents/relatedcontents/content[@key = current()/binary/file/@key]"/>
          <li>
            <xsl:if test="position() mod 2 = 0">
              <xsl:attribute name="class">dark</xsl:attribute>
            </xsl:if><xsl:call-template name="getIconImage"><xsl:with-param name="filename" select="$currentFile/title"/></xsl:call-template>
            <a href="{portal:createBinaryUrl($currentFile/contentdata/binarydata/@key, ())}/?download=true">
            <xsl:choose>
              <xsl:when test="description != ''">
                <xsl:call-template name="cropText">
                  <xsl:with-param name="sourceText" select="description"/>
                  <xsl:with-param name="numCharacters" select="$fileDescriptionLength"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$currentFile/title"/>
              </xsl:otherwise>
            </xsl:choose>
            </a><xsl:if test="$showFileSize != 'false'"><xsl:text> </xsl:text>(<xsl:call-template name="convertBytes"><xsl:with-param name="bytes" select="$currentFile/binaries/binary/@filesize"/></xsl:call-template>)</xsl:if>
          </li>
        </xsl:for-each>
        </ul>
      </div>
    </div>
    <!-- <xsl:call-template name="getIconImage"><xsl:with-param name="filename" select="$currentFile/title"/></xsl:call-template> -->
    <!-- <xsl:if test="$showFileDate != 'false'"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="$currentFile/@publishfrom"/><xsl:with-param name="format" select="'short'"/></xsl:if> -->
  </xsl:template>

</xsl:stylesheet>