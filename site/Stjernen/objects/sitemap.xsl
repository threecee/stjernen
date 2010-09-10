<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <div class="sitemap">
      <ul>
        <xsl:for-each select="/result/menus/menu/menuitems/menuitem">
          <li>
            <xsl:if test="position() = 1">
              <xsl:attribute name="class">first</xsl:attribute>
            </xsl:if>
            <xsl:if test="position() = last()">
              <xsl:attribute name="class">end</xsl:attribute>
            </xsl:if>
            <a href="{portal:createPageUrl(@key, ())}">
              <xsl:value-of select="name"/>
            </a>
            <xsl:if test="menuitems/menuitem">
              <ul>
                <xsl:for-each select="menuitems/menuitem">
                  <xsl:call-template name="menu">
                    <xsl:with-param name="curitem" select="."/>
                    <xsl:with-param name="level" select="1"/>
                  </xsl:call-template>
                </xsl:for-each>
              </ul>
            </xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>
  <xsl:template name="menu">
    <xsl:param name="curitem"/>
    <xsl:param name="level"/>
    <li>
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">first</xsl:attribute>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:attribute name="class">end</xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$curitem/@type = 'label'">
                    <xsl:choose>
                        <xsl:when test="$curitem/name = '---'">
                            <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <span>
                                <xsl:value-of select="$curitem/name"/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{portal:createPageUrl($curitem/@key, ())}">
                        <xsl:value-of select="$curitem/name"/>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$curitem/menuitems/menuitem/@key">
                <xsl:for-each select="$curitem/menuitems/menuitem">
                    <ul>
                        <xsl:call-template name="menu">
                            <xsl:with-param name="curitem" select="."/>
                            <xsl:with-param name="level" select="$level + 1"/>
                        </xsl:call-template>
                    </ul>
                </xsl:for-each>
            </xsl:if>
        </li>
        <!-- 
            <xsl:if test="$curitem/menuitems/menuitem/@key">
            <xsl:for-each select="$curitem/menuitems/menuitem">
            <xsl:call-template name="menu">
            <xsl:with-param name="curitem" select="."/>
            <xsl:with-param name="level" select="$level + 1"/>
            </xsl:call-template>
            </xsl:for-each>
            </xsl:if>
        -->
  </xsl:template>
</xsl:stylesheet>