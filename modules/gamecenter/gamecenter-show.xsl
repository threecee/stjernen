<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
                xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:stjernen="http://stjernen.no/2010/xpath-functions"
        >

  <xsl:import href="/libraries/utilities/standard-variables.xsl"/>
  <xsl:include href="/libraries/utilities/utilities.xsl"/>

  <xsl:output indent="no" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/result/contents/content">
        <div class="gamecenter">
            <xsl:call-template name="kamper" />
        </div>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <xsl:template name="kamper">
        <ul class="games">
            <xsl:for-each-group select="/result/contents/content/contentdata/games" group-by="year-from-date(gamedate)">
                <xsl:for-each-group select="current-group()" group-by="month-from-date(gamedate)">
                    <xsl:for-each select="current-group()"><xsl:sort select="gametime" order="ascending"/>
                        <xsl:apply-templates select="current()"/>
                    </xsl:for-each>
               </xsl:for-each-group>
            </xsl:for-each-group>
        </ul>
    </xsl:template>

  <xsl:template match="games">
    <li class="game">
        <span class="gamedate"><xsl:value-of select="stjernen:capitalize(format-date(gamedate, '[FNn] [D01].[M01].[Y0001]', 'no', (), ()))"/></span>
        <span class="gametime"><xsl:value-of select="gametime"/></span>

        <span class="hometeam">
            <a href="{portal:createContentUrl(current()/hometeam/@key,())}" >
                <xsl:value-of select="/result/contents/relatedcontents/content[@key = current()/hometeam/@key]/contentdata/heading"/>
            </a>
        </span>
        <span class="opponent">
            <a href="{portal:createContentUrl(current()/opponent/@key,())}" >
                <xsl:value-of select="/result/contents/relatedcontents/content[@key = current()/opponent/@key]/contentdata/heading"/>
            </a>
        </span>
        <span class="arena">
            <xsl:choose>
            <xsl:when test="arena != ''">
                <xsl:value-of select="arena"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/result/contents/relatedcontents/content[@key = current()/hometeam/@key]/contentdata/arena"/>
            </xsl:otherwise>
            </xsl:choose>
        </span>
        <span class="matchinfo">
            <xsl:choose>
                <xsl:when test="match-report/@key != ''">
                    <a href="{portal:createContentUrl(match-report/@key, ())}">referat</a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{portal:createContentUrl(before/@key, ())}">før kampen</a>
                </xsl:otherwise>
            </xsl:choose>
        </span>
        <span class="logo">
            <xsl:call-template name="utilities.display-image">
                            <xsl:with-param name="region-width" select="$region-width"/>
                            <xsl:with-param name="filter">scalewide(100, 100, 0)</xsl:with-param>
                            <xsl:with-param name="title" select="title"/>
                            <xsl:with-param name="image" select="/result/contents/relatedcontents/content[@key = /result/contents/relatedcontents/content[@key = current()/hometeam/@key]/contentdata/image/@key]"/>
            </xsl:call-template>

        </span>

    </li>
  </xsl:template>
<xsl:function name="stjernen:capitalize" as="xs:string">
    <xsl:param name="string"/>
    <xsl:value-of select="concat(upper-case(substring($string,1,1)),substring($string,2))"/>
</xsl:function>
</xsl:stylesheet>
