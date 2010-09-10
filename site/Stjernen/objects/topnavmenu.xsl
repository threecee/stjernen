<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/shared/includes/languageForum.xsl"/>
    <xsl:param name="menuOrientation" select="'vertical'"/>
    <xsl:param as="xs:integer" name="horizontalMenuFullWidth" select="990"/>
    <xsl:param as="xs:integer" name="startLevel" select="0"/>
    <xsl:param as="xs:integer" name="openTilLevel" select="0"/>
    <xsl:param name="bullet" select="'»'"/>
    <xsl:param name="bulletImagePosition" select="'left'"/>
    <xsl:param name="listPage">
        <type>page</type>
    </xsl:param>
  <xsl:param name="searchPage">
    <type>page</type>
  </xsl:param>
    <xsl:variable name="key" select="/result/context/querystring/parameter[@name = 'key']"/>
   <xsl:variable name="language" select="/result/context/@languagecode"/>
   
    <xsl:template match="/">
        <script type="text/javascript">
            <xsl:comment>//</xsl:comment>
            $(document).ready(function()
                    {
                     //   $("li[hassubmenu='true']").mouseover(function () {$(this).find('ul:first').show();});
                     //   $("li[hassubmenu='true']").mouseout(function () {$(this).find('ul:first').hide();});
                    }
                );
            
        </script>
        <xsl:variable name="activeFolderName" select="result/menuitems/menuitem/name"/>
        <xsl:if test="/result/menus/menu/menuitems/menuitem or /result/menuitems/menuitem">
                    <ul class="menu {$menuOrientation} navigation-1" id="menu-horizontal">
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
                <li style="width: 180px;">
                    <!--class="searchbox"-->


                    <div>
                        <form action="{portal:createPageUrl($searchPage, ())}" name="searchForm" method="get">

                            <input id="query" name="query" 
                                type="text"
                                value="{/result/context/querystring/parameter[@name = 'query']}"/>
                            <div id="querySubmitLeft">
                                <span id="querySubmit" onclick="javascript:document.searchForm.submit()">
                                    <xsl:value-of select="$translations/search[1]"/>
                                </span>
                            </div>
                        </form>
                    </div>
                </li>
                            
                    </ul>
        </xsl:if>
    </xsl:template>
    <xsl:template name="applyItems">
        <xsl:param name="level" select="0"/>
        <xsl:choose>
            <xsl:when test="$level = $startLevel and menuitems/menuitem">
                <xsl:variable name="numberOfMenuitems"><xsl:value-of select="count(menuitems/menuitem[@key > 0])"/></xsl:variable>
                <xsl:variable name="tempWidthPerMenuitem" select="floor(($horizontalMenuFullWidth - 180) div $numberOfMenuitems)"/>
                <xsl:variable name="rest" select="$horizontalMenuFullWidth - (180) - ($numberOfMenuitems * $tempWidthPerMenuitem)"/>
                <xsl:apply-templates select="menuitems/menuitem[@key > 0]">
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
        <xsl:variable name="hasSubMenu" select="($level &lt; $openTilLevel or (@path = 'true' and menuitems/menuitem) and not($menuOrientation = 'horizontal')) and menuitems/menuitem"/>
        <li>
            <xsl:if test="$menuOrientation = 'horizontal' and $horizontalMenuFullWidth > 0">
                <xsl:attribute name="style">
                    <xsl:value-of select="concat('width: ', $width, 'px;')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">first</xsl:attribute>
            </xsl:if>
            <xsl:if test="$hasSubMenu">
                <xsl:attribute name="hasSubMenu">true</xsl:attribute>
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
                <xsl:if test="@path = 'true'">
                    <xsl:attribute name="class">
                        <xsl:text>path</xsl:text>
                        <xsl:if test="position() = 1">
                            <xsl:attribute name="class"> first</xsl:attribute>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="@active = 'true'">
                    <xsl:attribute name="class">active</xsl:attribute>                    
                </xsl:if>
                
                <xsl:value-of select="$name"/>
                <xsl:if test="$hasSubMenu and $level &gt; 0">
                    <span>>></span>
                </xsl:if>
            </a>
            <xsl:if test="$hasSubMenu">
                <ul class="navigation-{$level+2}" >
                    <xsl:variable name="numberOfMenuitems"><xsl:value-of select="count(menuitems/menuitem)"/></xsl:variable>
                    <xsl:variable name="tempWidthPerMenuitem2" select="floor($horizontalMenuFullWidth div $numberOfMenuitems)"/>
                    <xsl:variable name="rest" select="$horizontalMenuFullWidth - ($numberOfMenuitems * $tempWidthPerMenuitem)"/>
                    <xsl:apply-templates select="menuitems/menuitem">
                        <xsl:with-param name="level" select="$level + 1"/>
                        <xsl:with-param name="tempWidthPerMenuitem" select="114"/>
                        <xsl:with-param name="rest" select="$rest"/>
                    </xsl:apply-templates>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
</xsl:stylesheet>