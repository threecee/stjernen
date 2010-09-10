<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/shared/includes/cropText.xsl"/>
  <xsl:include href="/shared/includes/languageForum.xsl"/>
  <xsl:include href="/shared/includes/formatDate.xsl"/>
  <xsl:include href="/shared/includes/navigationMenu.xsl"/>
  <xsl:param name="showNavigationMenu" select="'true'"/>
  <xsl:param name="pagesInNavigation" select="10"/>
  <xsl:param name="contentsPerPage" select="10"/>
  <xsl:param name="prefaceLength" select="200"/>
  <xsl:variable name="language" select="/result/context/@languagecode"/>
  <xsl:variable name="searchinput" select="/result/context/querystring/parameter[@name = 'query']"/>
  <xsl:variable name="searchcount">
    <xsl:choose>
      <xsl:when test="string-length(/result/contents/@searchcount) > 0 and string-length($searchinput) > 3">
        <xsl:value-of select="/result/contents/@searchcount"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="totalCount" select="/result/contents/@totalcount"/>
  <xsl:variable name="contentCount" select="count(/result/contents/content)"/>
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
    <div class="item" style="min-height:300px;">
<xsl:call-template name="search"/>
    </div>
    </xsl:template>
      <xsl:template name="search">
        <div>
      <em>
        <xsl:value-of select="$translations/your_query[1]"/>: "<xsl:value-of select="$searchinput"/>".
      </em>
    </div>
    <xsl:if test="$searchcount > 0">
      <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
        <xsl:call-template name="navigationHeader"/>
      </xsl:if>
      <div>
        <ol class="forum_searchitem" start="{$index + 1}">
          <xsl:for-each select="/result/contents/content">
            <xsl:sort order="descending" select="@publishfrom"/>
            <xsl:variable name="topkey">
              <xsl:choose>
                <xsl:when test="string-length(contentdata/topkey/@key) > 0">
                  <xsl:value-of select="contentdata/topkey/@key"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@key"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

			 <xsl:variable name="heading">
			<xsl:choose>
                <xsl:when test="contentdata/stikktittel != ''">
                  <xsl:value-of select="contentdata/stikktittel"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="contentdata/tittel"/>
                </xsl:otherwise>
              </xsl:choose>
			 </xsl:variable>
			 <xsl:variable name="prefacez">
			<xsl:choose>
                <xsl:when test="contentdata/artikkel/kortingress != ''">
                  <xsl:value-of select="contentdata/artikkel/kortingress"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="contentdata/artikkel/kortingress"/>
                </xsl:otherwise>
              </xsl:choose>
			 </xsl:variable>
			 <xsl:variable name="author">
			<xsl:choose>
                <xsl:when test="contentdata/author != ''">
                    <xsl:value-of select="contentdata/author"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="owner"/>
                </xsl:otherwise>
              </xsl:choose>
			 </xsl:variable>


			
            <li>
              <span class="title">
                <a href="{portal:createContentUrl(@key, ())}">
                 <xsl:value-of select="$heading"/>
				</a>
				 </span>
              <br/>
              <span class="author">
                <xsl:value-of select="concat($translations/by[1], ' ', $author)"/>
                <xsl:text> (</xsl:text>
                <xsl:call-template name="datetimeFull">
                  <xsl:with-param name="date" select="@publishfrom"/>
                </xsl:call-template>
                <xsl:text>)</xsl:text>
              </span>
              <br/>
              <span class="body">
                 <xsl:call-template name="cropText">
                  <xsl:with-param name="sourceText" select="$prefacez"/>
                  <xsl:with-param name="numCharacters" select="$prefaceLength"/>
                </xsl:call-template>
              </span>
            </li>
          </xsl:for-each>
        </ol>
      </div>
      <xsl:if test="$showNavigationMenu = 'true' and $totalCount > $contentsPerPage">
        <xsl:call-template name="navigationMenu"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>