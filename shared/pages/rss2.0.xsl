<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml"/>
  <xsl:include href="/shared/includes/getAbrDayMonthNames.xsl"/>
  <!--
    DOCUMENTASJON, 2007-11-13, sist oppdatert av Per Allan Johansson, seniorkonsulent, Enonic AS
    - oppdaterte til XSLT versjon 2.0 på objektmal
    - oppdaterte til XSLT versjon 2.0 på inkludert mal getAbrDayMonthNames, denne ble noe modifisert
    
    Dette er en sidemal som bør ligge på SHARED-området under Side XSL (Page XSL) slik at den kan
    gjenbrukes på tvers av nettsteder. Selve malen er lik som alle, men man må overstyre med lokale
    paremetre i selve sidemalen. Navn på nettsted, url og slike ting.

    Dette eksempelet bruker en standard getContentBySection-metode for å hente ut artikler fra et nyhetsarkiv.
    Det fine da er at man kan bruke portal-lenker til innholdet via createContentUrl().
    Man er også avhengig av en xpath for å dra ut en eventuell ingress. Hvis man blander innholdstypene kan xpathen variere,
    men man vil uansett alltid kunne trekke ut tittel, url og dato.

    Skal man bruke en getContentsByCategory så må man skrive om måten man genererer lenker på!

  -->
  <xsl:param name="channelTitle" select="'Enonic Packages'"/>
  <xsl:param name="channelLink" select="'http://dev.enonic.com/enonic_packages/site/0/'"/>
  <xsl:param name="channelDescription" select="'Lastest news from Enonic Packages'"/>
  <xsl:param name="channelLanguage" select="'NO-no'"/>
  <xsl:param name="channelManagingEditor" select="'Enonic Webmaster'"/>
  <xsl:param name="channelWebMaster" select="'webmaster@enonic.com'"/>
  <xsl:param name="channelImageUrl" select="'http://www.enonic.com/images/logo_rss.gif'"/>
  <xsl:param name="channelImageTitle" select="'Enonic Packages'"/>
  <xsl:param as="xs:integer" name="channelImageWidth" select="47"/>
  <xsl:param as="xs:integer" name="channelImageHeight" select="46"/>
  <xsl:param name="itemXpathTitle" select="'title'"/>
  <xsl:param name="itemXpathDescription" select="'contentdata/article/preface'"/>
  <xsl:param as="xs:string" name="timeZone" select="'+0100'"/>
  <xsl:param name="baseUrl" select="'http://dev.enonic.com/enonic_packages/site/0/'"/>
  <!--<xsl:variable name="rssVersion" select="2.0" as="xs:double"/>-->

  <xsl:template match="/">
    <xsl:element name="rss">
      <xsl:attribute name="version">
        <!-- <xsl:value-of select="$rssVersion"/> --><xsl:text>2.0</xsl:text>
      </xsl:attribute>
      <xsl:element name="channel">
        <xsl:element name="title">
          <xsl:value-of select="$channelTitle"/>
        </xsl:element>
        <xsl:element name="link">
          <xsl:value-of select="$channelLink"/>
        </xsl:element>
        <xsl:element name="description">
          <xsl:value-of select="$channelDescription"/>
        </xsl:element>
        <xsl:element name="lastBuildDate">
          <xsl:variable name="tempDay">
            <xsl:choose>
              <xsl:when test="substring(/result/contents/content[1]/@publishfrom,9,2) &lt; '10'">
                <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,10,1)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,9,2)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="tempMonth">
            <xsl:choose>
              <xsl:when test="substring(/result/contents/content[1]/@publishfrom,6,2) &lt; '10'">
                <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,7,1)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,6,2)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="tempYear" select="substring(/result/contents/content[1]/@publishfrom,1,4)"/>
          <xsl:variable name="dow">
            <xsl:call-template name="calculate-day-of-the-week">
              <xsl:with-param name="year" select="$tempYear"/>
              <xsl:with-param name="month" select="$tempMonth"/>
              <xsl:with-param name="day" select="$tempDay"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="dayName">
            <xsl:call-template name="get-day-of-the-week-abbreviation">
              <xsl:with-param name="day-of-the-week" select="$dow"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="monthName">
            <xsl:call-template name="get-month-abbreviation">
              <xsl:with-param name="month" select="$tempMonth"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$dayName"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,9,2)"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$monthName"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,1,4)"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,12,5)"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$timeZone"/>
        </xsl:element>

        <xsl:element name="generator">
          Vertical Site
        </xsl:element>
        <xsl:element name="docs">
          http://backend.userland.com/rss
        </xsl:element>
        <xsl:if test="$channelLanguage !=''">
          <xsl:element name="language">
            <xsl:value-of select="$channelLanguage"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="$channelManagingEditor !=''">
          <xsl:element name="managingEditor">
            <xsl:value-of select="$channelManagingEditor"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="$channelWebMaster !=''">
          <xsl:element name="webMaster">
            <xsl:value-of select="$channelWebMaster"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="$channelImageUrl !=''">
          <xsl:element name="image">
            <xsl:element name="url">
              <xsl:value-of select="$channelImageUrl"/>
            </xsl:element>
            <xsl:element name="title">
              <xsl:value-of select="$channelImageTitle"/>
            </xsl:element>
            <xsl:element name="link">
              <xsl:value-of select="$channelLink"/>
            </xsl:element>
            <xsl:element name="width">
              <xsl:value-of select="$channelImageWidth"/>
            </xsl:element>
            <xsl:element name="height">
              <xsl:value-of select="$channelImageHeight"/>
            </xsl:element>
            <xsl:element name="description">
              <xsl:value-of select="$channelDescription"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:for-each select="/result/contents/content">
          <xsl:element name="item">
            <xsl:element name="title">    
              <xsl:value-of select="saxon:evaluate($itemXpathTitle)"/>
            </xsl:element>
            <xsl:element name="link">
              <!--<xsl:value-of select="concat($baseUrl,@key,'.cms')"/>-->
              <xsl:value-of select="portal:createContentUrl(@key, ())"/>
            </xsl:element>
            <xsl:element name="guid">
              <xsl:attribute name="isPermaLink">
                <xsl:text>true</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="portal:createContentUrl(@key, ())"/>
            </xsl:element>
              <xsl:element name="description">
              <xsl:value-of select="saxon:evaluate($itemXpathDescription)"/>
            </xsl:element>
            <xsl:element name="pubDate">
              <xsl:variable name="tempDay">
                <xsl:choose>
                  <xsl:when test="substring(@publishfrom,9,2) &lt; '10'">
                    <xsl:value-of select="substring(@publishfrom,10,1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring(@publishfrom,9,2)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="tempMonth">
                <xsl:choose>
                  <xsl:when test="substring(@publishfrom,6,2) &lt; '10'">
                    <xsl:value-of select="substring(@publishfrom,7,1)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring(@publishfrom,6,2)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="tempYear" select="substring(@publishfrom,1,4)"/>
              <xsl:variable name="dow">
                <xsl:call-template name="calculate-day-of-the-week">
                  <xsl:with-param name="year" select="$tempYear"/>
                  <xsl:with-param name="month" select="$tempMonth"/>
                  <xsl:with-param name="day" select="$tempDay"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:variable name="dayName">
                <xsl:call-template name="get-day-of-the-week-abbreviation">
                  <xsl:with-param name="day-of-the-week" select="$dow"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:variable name="monthName">
                <xsl:call-template name="get-month-abbreviation">
                  <xsl:with-param name="month" select="$tempMonth"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="$dayName"/>
              <xsl:text>, </xsl:text>
              <xsl:value-of select="substring(@publishfrom,9,2)"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$monthName"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="substring(@publishfrom,1,4)"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="substring(@publishfrom,12,5)"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$timeZone"/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>