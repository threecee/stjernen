<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:param name="menuOrientation" select="'vertical'"/>
    <xsl:param as="xs:integer" name="horizontalMenuFullWidth" select="990"/>
    <xsl:param as="xs:integer" name="startLevel" select="0"/>
    <xsl:param as="xs:integer" name="openTilLevel" select="0"/>
    <xsl:param name="bullet" select="'»'"/>
    <xsl:param name="bulletImagePosition" select="'left'"/>
    <xsl:param name="listPage">
        <type>page</type>
    </xsl:param>
    <xsl:variable name="key" select="/result/context/querystring/parameter[@name = 'key']"/>
    
    <xsl:template match="/">
        <xsl:variable name="activeFolderName" select="result/menuitems/menuitem/name"/>
        <xsl:if test="/result/menus/menu/menuitems/menuitem or /result/menuitems/menuitem">
            <xsl:choose>
                <xsl:when test="$menuOrientation = 'horizontal'">
                    <ul class="menu {$menuOrientation}" id="menu-horizontal">
                        <xsl:if test="$menuOrientation = 'horizontal' and $horizontalMenuFullWidth > 0">
                            <xsl:attribute name="style">
                                <xsl:value-of select="concat('width: ', $horizontalMenuFullWidth, 'px;')"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:comment>stopindex</xsl:comment>
                        <xsl:for-each select="/result | /result/menus/menu">
                            <xsl:call-template name="applyItems"/>
                        </xsl:for-each>
                        <xsl:comment>startindex</xsl:comment>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="/result/menuitems/menuitem/menuitems/menuitem">
                        <h2 class="leftmenutitle"><xsl:value-of select="$activeFolderName"/></h2>
                        <ul class="menu {$menuOrientation}">
                            <xsl:comment>stopindex</xsl:comment>
                            <xsl:for-each select="/result | /result/menus/menu">
                                <xsl:call-template name="applyItems"/>
                            </xsl:for-each>
                            <xsl:comment>startindex</xsl:comment>
                        </ul>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="applyItems">
        <xsl:param name="level" select="0"/>
        <xsl:choose>
            <xsl:when test="$level = $startLevel and menuitems/menuitem">
                <xsl:variable name="numberOfMenuitems"><xsl:value-of select="count(menuitems/menuitem)"/></xsl:variable>
                <xsl:variable name="tempWidthPerMenuitem" select="floor($horizontalMenuFullWidth div $numberOfMenuitems)"/>
                <xsl:variable name="rest" select="$horizontalMenuFullWidth - ($numberOfMenuitems * $tempWidthPerMenuitem)"/>
                <xsl:apply-templates select="menuitems/menuitem">
                    <xsl:with-param name="level" select="$level"/>
                    <xsl:with-param name="tempWidthPerMenuitem" select="$tempWidthPerMenuitem"/>
                    <xsl:with-param name="rest" select="$rest"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="menuitems/menuitem[@path = 'true']/menuitems/menuitem">
                <xsl:for-each select="menuitems/menuitem[@path = 'true']">
                    <xsl:call-template name="applyItems">
                        <xsl:with-param name="level" select="$level + 1"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="menuitem">
        <xsl:param name="level"/>
        <xsl:param name="tempWidthPerMenuitem"/>
        <xsl:param name="rest"/>
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
        <xsl:variable name="name"><xsl:value-of select="name"/></xsl:variable>
        <xsl:variable name="width">
            <xsl:choose>
                <xsl:when test="position() &lt;= $rest">
                    <xsl:value-of select="$tempWidthPerMenuitem + 1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$tempWidthPerMenuitem"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <li>
            <xsl:if test="$menuOrientation = 'horizontal' and $horizontalMenuFullWidth > 0">
                <xsl:attribute name="style">
                    <xsl:value-of select="concat('width: ', $width, 'px;')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">first</xsl:attribute>
            </xsl:if>
            <xsl:if test="@path = 'true'">
                <xsl:attribute name="class">
                    <xsl:text>path</xsl:text>
                    <xsl:if test="position() = 1">
                        <xsl:attribute name="class"> first</xsl:attribute>
                    </xsl:if>
                </xsl:attribute>
            </xsl:if>
            <a href="{$href}">
                <xsl:if test="@active = 'true'">
                    <xsl:attribute name="class">active</xsl:attribute>
                    <xsl:if test="$menuOrientation = 'vertical'">
                        <xsl:choose>
                            <xsl:when test="$bullet = 'icon'">
                                <xsl:attribute name="class">
                                    <xsl:value-of select="concat('active bullet ', $bulletImagePosition)"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$bullet != 'false'">
                                <span id="bullet">
                                    <xsl:value-of select="$bullet"/>
                                </span>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:if>
                <xsl:value-of select="$name"/>
            </a>
            <xsl:if test="($level &lt; $openTilLevel or (@path = 'true' and menuitems/menuitem) and not($menuOrientation = 'horizontal'))">
                <ul>
                    <xsl:variable name="numberOfMenuitems"><xsl:value-of select="count(menuitems/menuitem)"/></xsl:variable>
                    <xsl:variable name="tempWidthPerMenuitem2" select="floor($horizontalMenuFullWidth div $numberOfMenuitems)"/>
                    <xsl:variable name="rest" select="$horizontalMenuFullWidth - ($numberOfMenuitems * $tempWidthPerMenuitem)"/>
                    <xsl:apply-templates select="menuitems/menuitem">
                        <xsl:with-param name="level" select="$level + 1"/>
                        <xsl:with-param name="tempWidthPerMenuitem" select="$tempWidthPerMenuitem2"/>
                        <xsl:with-param name="rest" select="$rest"/>
                    </xsl:apply-templates>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
</xsl:stylesheet>