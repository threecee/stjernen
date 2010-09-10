<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:if test="/result/menuitems/menuitem"><!-- /menuitems/menuitem -->
      <div id="topnav">
        <ul>
          <xsl:apply-templates select="/result/menuitems/menuitem"/><!-- /menuitems/menuitem -->
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="menuitem">
    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="@type = 'url'">
          <xsl:value-of select="url"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="portal:createPageUrl(@key, ())"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="name" select="name"/>
    <li>
      <xsl:if test="position() = last()">
        <xsl:attribute name="class">last</xsl:attribute>
      </xsl:if>
      <a href="{$href}">
        <xsl:if test="@active = 'true' and not(@type = 'url')">
          <xsl:attribute name="class">active</xsl:attribute>
        </xsl:if>
        <xsl:if test="@type = 'url' and url/@newwindow = 'yes'">
          <xsl:attribute name="rel">external</xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="/result/context/user/block/firstname and parameters/parameter[@name = 'showUserName'] = 'true'">
            <xsl:value-of select="/result/context/user/block/firstname"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="/result/context/user/block/surname"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$name"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </li>
  </xsl:template>
</xsl:stylesheet>