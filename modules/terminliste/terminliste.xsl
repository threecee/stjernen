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

  <xsl:variable name="url-parameters" select="/result/context/querystring/parameter[not(@name = 'index' or @name = 'id' or starts-with(@name, '_config-'))]"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/result/contents/content">
        <div class="terminliste">
            <h2><xsl:value-of select="/result/contents/content/title"/></h2>

            <xsl:call-template name="kamper"><xsl:with-param name="type">Seriekamp</xsl:with-param></xsl:call-template>
            <xsl:call-template name="kamper"><xsl:with-param name="type">Treningskamp</xsl:with-param></xsl:call-template>
            <xsl:call-template name="kamper"><xsl:with-param name="type">Sluttspill</xsl:with-param></xsl:call-template>
            <xsl:call-template name="kamper"><xsl:with-param name="type">Kvalifiseringsspill</xsl:with-param></xsl:call-template>
        </div>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <xsl:template name="kamper">
        <xsl:param name="type" select="null"/>
        <h3><xsl:value-of select="$type"/></h3>
        <ul>
            <xsl:for-each-group select="/result/contents/content/contentdata/kamper/kamp[type=$type]" group-by="year-from-date(dato)">
                <xsl:for-each-group select="current-group()" group-by="month-from-date(dato)">
                    <h1><xsl:value-of select="stjernen:capitalize(format-date(dato, '[MNn] [Y]', 'no', (), ()))"/></h1>
                    <xsl:for-each select="current-group()"><xsl:sort select="klokkeslett" order="ascending"/>
                        <xsl:apply-templates select="current()"/>
                    </xsl:for-each>
               </xsl:for-each-group>
            </xsl:for-each-group>
        </ul>
    </xsl:template>

  <xsl:template match="kamp">
    <li>
        <span><xsl:value-of select="stjernen:capitalize(format-date(dato, '[FNn] [D01].[M01].[Y0001]', 'no', (), ()))"/></span>
        <span><xsl:value-of select="klokkeslett"/></span>

        <span><xsl:value-of select="/result/contents/relatedcontents/content[@key = current()/hjemmelag/@key]/contentdata/tittel"/></span>
        <span><xsl:value-of select="/result/contents/relatedcontents/content[@key = current()/bortelag/@key]/contentdata/tittel"/></span>
        <span>
            <xsl:choose>
            <xsl:when test="arena != ''">
                <xsl:value-of select="arena"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/result/contents/relatedcontents/content[@key = current()/hjemmelag/@key]/contentdata/arena"/>                
            </xsl:otherwise>
            </xsl:choose>
        </span>
        <span><xsl:value-of select="/result/contents/relatedcontents/content[@key = current()/kampreferat/@key]/contentdata/goal-hjemme"/></span>-
        <span><xsl:value-of select="/result/contents/relatedcontents/content[@key = current()/kampreferat/@key]/contentdata/goal-borte"/></span>
        <span><a href="{portal:createContentUrl(forkampen/@key, ())}">referat</a></span>

    </li>
  </xsl:template>
<xsl:function name="stjernen:capitalize" as="xs:string">
    <xsl:param name="string"/>
    <xsl:value-of select="concat(upper-case(substring($string,1,1)),substring($string,2))"/>
</xsl:function>
</xsl:stylesheet>
