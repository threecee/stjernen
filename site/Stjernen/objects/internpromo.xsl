<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  
  <xsl:template match="/">
          <ul class="internpromo">
            <xsl:for-each select="/result | /result/menus/menu">
              <xsl:apply-templates select="menuitems/menuitem"/>
              </xsl:for-each>
          </ul>
  </xsl:template>
  <xsl:template match="menuitem">

    <xsl:variable name="href">
          <xsl:value-of select="link"/>
    </xsl:variable>
    <xsl:variable name="name"><xsl:value-of select="heading"/></xsl:variable>
    <li>
      <a href="{$href}">
        <xsl:value-of select="$name"/>
      </a>
    </li>
  </xsl:template>
</xsl:stylesheet>