<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"
  xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal"
  xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/xhtml1-strict.dtd" encoding="utf-8" indent="yes"
    method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/site/Stjernen/includes/globalVars.xsl"/>
  <xsl:include href="/site/Stjernen/includes/languageSite.xsl"/>
  <xsl:param name="miniheader">
    <type>object</type>
  </xsl:param>
  <xsl:param name="mainheader">
    <type>object</type>
  </xsl:param>
  <xsl:param name="menu">
    <type>object</type>
  </xsl:param>
  
  <xsl:param name="mainColumnWide">
    <type>object</type>
  </xsl:param>
  <xsl:param name="mainColumn">
    <type>object</type>
  </xsl:param>
  <xsl:param name="twoColumnLeft">
    <type>object</type>
  </xsl:param>
  <xsl:param name="twoColumnRight">
    <type>object</type>
  </xsl:param>
  <xsl:param name="mainColumnBottom">
    <type>object</type>
  </xsl:param>
  <xsl:param name="threeColumnLeft">
    <type>object</type>
  </xsl:param>
  <xsl:param name="threeColumnMiddle">
    <type>object</type>
  </xsl:param>
  <xsl:param name="threeColumnRight">
    <type>object</type>
  </xsl:param>
  <xsl:param name="rightColumn">
    <type>object</type>
  </xsl:param>
  <xsl:param name="starclub">
    <type>object</type>
  </xsl:param>
  <xsl:param name="footer">
    <type>object</type>
  </xsl:param>
  
  <xsl:variable name="leftColumn" />
  
  
  <xsl:param name="META-author" select="'Stjernen'"/>
  <xsl:param name="META-copyright" select="'Stjernen'"/>
  <xsl:param name="META-keywords"/>
  <xsl:param name="META-description"/>
  <xsl:param name="IECSS"/>
  <xsl:param name="includeFavoriteIcon" select="'true'"/>
  <xsl:param name="showBreadcrumbPath" select="'true'"/>

  <xsl:template match="/">
    <html dir="ltr" xml:lang="{$language}" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="head"/>
      <xsl:call-template name="body"/>
    </html>
  </xsl:template>

  <xsl:template name="head">
    <head>
      <xsl:call-template name="title"/>
      <xsl:call-template name="meta"/>
      <xsl:if test="$includeFavoriteIcon = 'true'">
        <!--link href="favicon.ico" rel="shortcut icon" type="image/x-icon"/-->
      </xsl:if>
      <xsl:call-template name="css"/>
      <xsl:call-template name="javascript"/>
      <xsl:if test="$rssPage">
        <link href="{portal:createPageUrl($rssPage, ())}" rel="alternate"
          title="{$siteName} RSS feed" type="application/rss+xml"/>
      </xsl:if>

    </head>
  </xsl:template>

  <xsl:template name="body">
    <body class="stjernen">
      <div class="outer_framework">
        <xsl:call-template name="miniheader"/>
        <xsl:call-template name="header"/>
        <xsl:call-template name="menu"/>
        <div>
          <xsl:attribute name="class">
            <xsl:text>framework</xsl:text>
            <!--<xsl:choose>
              <xsl:when test="not($rightColumn != '') and not($leftColumn != '')">
                <xsl:text> oneColumn</xsl:text>
              </xsl:when>
              <xsl:when test="not($rightColumn != '')">
                <xsl:text> twoColumnsLeft</xsl:text>
              </xsl:when>
              <xsl:when test="not($leftColumn != '')">
                <xsl:text> twoColumnsRight</xsl:text>
              </xsl:when>
            </xsl:choose>-->
          </xsl:attribute>
          <xsl:call-template name="breadcrumbs"/>

          <div class="content">
            <xsl:if test="not($rightColumn != '')">
              <xsl:attribute name="class">content twoColumns</xsl:attribute>
            </xsl:if>
            <div class="inner-content">
              <xsl:call-template name="heading"/>
              <xsl:call-template name="mainColumnWide"/>
              <xsl:call-template name="mainColumn"/>
              <xsl:call-template name="twoColumns"/>
              <xsl:call-template name="threeColumns"/>
              <xsl:call-template name="mainColumnBottom"/>
              
            </div>
          </div>
          <xsl:call-template name="rightColumn"/>
          <xsl:call-template name="starclub"/>
          <xsl:comment>stopindex</xsl:comment>
          <xsl:call-template name="footer"/>
          <xsl:comment>startindex</xsl:comment>
        </div>
      </div>
      <xsl:call-template name="google-analytics"/>
    </body>
  </xsl:template>


  <xsl:template name="miniheader">
    <a id="top" name="top"/>
    <div id="miniheader">
      <xsl:if test="$miniheader != ''">
        <xsl:value-of disable-output-escaping="yes" select="$miniheader"/>
      </xsl:if>
    </div>
    
  </xsl:template>

  <xsl:template name="starclub">
    <div class="starclub">
      <xsl:if test="$starclub != ''">
        <xsl:value-of disable-output-escaping="yes" select="$starclub"/>
      </xsl:if>
    </div>
    
  </xsl:template>
  


  <xsl:template name="header">
    <div id="header">
      <xsl:if test="$mainheader != ''">
        <xsl:value-of disable-output-escaping="yes" select="$mainheader"/>
      </xsl:if>
</div>      
      <!-- 
      <a class="screen"
        href="{portal:createPageUrl(/result/menus/menu/firstpage/@key, ())}">
        <img alt="{$siteName} {$translations/logo}" id="logoScreen"
          src="{portal:createResourceUrl($logoScreen)}" title="{$siteName}"/>
      </a>
      <img alt="{$siteName} {$translations/logo}" class="print" id="logoPrint"
        src="{portal:createResourceUrl($logoPrint)}" title="{$siteName}"/>
        </div> -->
    <!-- end of header -->
    
  </xsl:template>
  <xsl:template name="menu">
    <div class="menubar">
    <xsl:choose>
      <xsl:when test="$menu != ''">
        <xsl:value-of disable-output-escaping="yes" select="$menu"/>
      </xsl:when>
      <xsl:otherwise>
        <div style="height: 40px;">
          <xsl:comment>//</xsl:comment>
        </div>
      </xsl:otherwise>
     
    </xsl:choose>
    </div>
  </xsl:template>
  


<xsl:template name="mainColumnWide">
  <xsl:if test="not($mainColumnWide = '')">   
  <div class="mainColumnWide">
  <xsl:value-of disable-output-escaping="yes" select="$mainColumnWide"/>
  </div>
  </xsl:if>
</xsl:template>
  
  
  <xsl:template name="mainColumn">
    <xsl:if test="not($mainColumn = '')">   
      <div class="mainColumn leftMargin"><xsl:comment>mainColumn start</xsl:comment>
        <xsl:value-of disable-output-escaping="yes" select="$mainColumn"/>
      </div><xsl:comment>mainColumn end</xsl:comment>
      </xsl:if>
  </xsl:template>
  <xsl:template name="twoColumns">
    <xsl:if test="not($twoColumnLeft = '') and not($twoColumnRight = '')">   
      
    <div class="twoContentColumns leftMargin clearer">
      <div class="twoContentColumnsLeft rightMargin onethird">
        <xsl:value-of disable-output-escaping="yes" select="$twoColumnLeft"/>        
      </div>
      <div class="twoContentColumnsRight onethird">
      <xsl:value-of disable-output-escaping="yes" select="$twoColumnRight"/>        
      </div>
    </div>
      </xsl:if>
  </xsl:template>
  <xsl:template name="threeColumns">
    <xsl:if test="not($threeColumnLeft = '') and not($threeColumnMiddle = '') and not($threeColumnRight = '')">         
    <div class="threeColumns leftMargin clearer">
      <div class="threeColumnsLeft rightMargin onefourth">        
        <xsl:value-of disable-output-escaping="yes" select="$threeColumnLeft"/>
      </div>
      <div class="threeColumnsMiddle rightMargin onefourth">              
        <xsl:value-of disable-output-escaping="yes" select="$threeColumnMiddle"/>
        </div>
      <div class="threeColumnsRight onefourth">        
    <xsl:value-of disable-output-escaping="yes" select="$threeColumnRight"/>
          </div>
    </div>
      </xsl:if> 
  </xsl:template>
  <xsl:template name="mainColumnBottom"> 
    <xsl:if test="$mainColumnBottom and not($mainColumnBottom = '')">         
      <div class="threeColumns leftMargin clearer">
          <xsl:value-of disable-output-escaping="yes" select="$mainColumnBottom"/>
      </div>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template name="rightColumn">
    <xsl:if test="$rightColumn != ''">
      <div id="rightColumn" class="leftMargin rightMargin">
        <xsl:value-of disable-output-escaping="yes" select="$rightColumn"/>
        <br/>
      </div><xsl:comment>rightColumn end</xsl:comment>
    </xsl:if>    
  </xsl:template>
  


  <xsl:template name="css">
    <link href="{portal:createResourceUrl($screencss)}"
      media="screen" rel="stylesheet" type="text/css"/>
    <xsl:if test="$IECSS != ''">
      <xsl:text disable-output-escaping="yes">
        &lt;!--[if IE]&gt;
          &lt;link rel="stylesheet" type="text/css" media="screen" href="</xsl:text>
      <xsl:value-of select="$IECSS"/>
      <xsl:text disable-output-escaping="yes">" /&gt;
        &lt;![endif]--&gt;
      </xsl:text>
    </xsl:if>
    <xsl:if test="$printCSS != ''">
      <link href="{portal:createResourceUrl($printCSS)}" media="print" rel="stylesheet"
        type="text/css"/>
    </xsl:if>

  </xsl:template>

  <xsl:template name="meta">
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type"/>
    <xsl:if test="$content/keywords != '' or $pageKeywords != '' or $META-keywords != ''">
      <meta name="keywords">
        <xsl:attribute name="content">
          <xsl:choose>
            <xsl:when test="$content/keywords != ''">
              <xsl:value-of select="$content/keywords"/>
            </xsl:when>
            <xsl:when test="$pageKeywords != ''">
              <xsl:value-of select="$pageKeywords"/>
            </xsl:when>
            <xsl:when test="$META-keywords != ''">
              <xsl:value-of select="$META-keywords"/>
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </meta>
    </xsl:if>
    <xsl:if test="$content/description != '' or $pageDescription != '' or $META-description != ''">
      <meta name="description">
        <xsl:attribute name="content">
          <xsl:choose>
            <xsl:when test="$content/description != ''">
              <xsl:value-of select="$content/description"/>
            </xsl:when>
            <xsl:when test="$pageDescription != ''">
              <xsl:value-of select="$pageDescription"/>
            </xsl:when>
            <xsl:when test="$META-description != ''">
              <xsl:value-of select="$META-description"/>
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </meta>
    </xsl:if>
    <xsl:if test="$META-author != ''">
      <meta content="{$META-author}" name="author"/>
    </xsl:if>
    <xsl:if test="$META-copyright != ''">
      <meta content="{$META-copyright}" name="copyright"/>
    </xsl:if>
    <meta content="{$language}" http-equiv="content-language"/>
    <meta content="text/javascript" http-equiv="content-script-type"/>
    <meta content="text/css" http-equiv="content-style-type"/>
    <meta content="index,follow" name="robots"/>
    <meta content="false" http-equiv="imagetoolbar"/>
    <meta content="true" name="MSSmartTagsPreventParsing"/>
    <meta content="yes" http-equiv="MSThemeCompatible"/>
    <meta content="document" name="resource-type"/>
    <meta content="1 days" name="revisit-after"/>
    <meta content="Global" name="distribution"/>
    <meta content="Enonic Vertical Site" name="generator"/>
    <meta content="General" name="rating"/>
  </xsl:template>

  <xsl:template name="title">
    <title>
      <xsl:choose>
        <xsl:when test="$currentPageId = $firstPageKey">
          <xsl:value-of select="$translations/welcome"/>
          <xsl:text> </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$content">
            <xsl:value-of select="concat($content/title,' - ')"/>
          </xsl:if>
          <xsl:call-template name="pageTitle">
            <xsl:with-param name="currentMenuitem" select="/result/menuitems/menuitem"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$siteName"/>
    </title>
  </xsl:template>

  <xsl:template name="google-analytics"> </xsl:template>

  <xsl:template name="pageTitle">
    <xsl:param name="currentMenuitem"/>
    <xsl:if test="$currentMenuitem/@visible != 'no'">
      <xsl:value-of select="concat($currentMenuitem/name, ' - ')"/>
    </xsl:if>
    <xsl:if test="$currentMenuitem/menuitems/menuitem">
      <xsl:call-template name="pageTitle">
        <xsl:with-param name="currentMenuitem" select="$currentMenuitem/menuitems/menuitem"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- navigationpath or breadcrums -->
  <xsl:template name="navigationPath">
    <xsl:param name="currentItem"/>
    <xsl:text> / </xsl:text>
    <xsl:choose>
      <xsl:when test="$currentItem/@visible != 'no'">
        <a href="{portal:createPageUrl($currentItem/@key, ())}">
          <xsl:value-of select="$currentItem/name"/>
        </a>
        <xsl:call-template name="navigationPath">
          <xsl:with-param name="currentItem" select="$currentItem/menuitems/menuitem"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$pagetitle != ''">
            <xsl:value-of select="$pagetitle"/>
          </xsl:when>
          <xsl:when test="$category">
            <xsl:value-of select="$category/@name"/>
          </xsl:when>
          <xsl:when test="$content">
            <xsl:value-of select="$content/title"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$currentItem/@key != $firstPageKey">
              <xsl:value-of select="$currentItem/name"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="heading">
    <xsl:if
      test="not($heading = 'false') and not(/result/context/querystring/parameter[@name = 'key'] != '')">
      <!--h1>
        <xsl:choose>
          <xsl:when test="$heading = 'contentTitle' and $content">
            <xsl:value-of select="$content/title"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$menuitem/subtitle != ''">
                <xsl:value-of select="$menuitem/subtitle"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$menuitem/name"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </h1-->
    </xsl:if>
  </xsl:template>

  <xsl:template name="footer">
    <xsl:if test="$footer != ''">
      <div id="footer">
        
      <xsl:value-of disable-output-escaping="yes" select="$footer"/>
        </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="breadcrumbs">
    <xsl:if test="$showBreadcrumbPath = 'true'">
      <div id="breadcrumbs" class="rightMargin">
        <div>
          <span>
            <xsl:value-of select="concat($translations/you_are_here, ':')"/>
          </span>
          <xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when
              test="/result/menuitems/menuitem[@key = $firstPageKey]/menuitems/menuitem">
              <xsl:call-template name="navigationPath">
                <xsl:with-param name="currentItem" select="/result/menuitems/menuitem"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$currentPageId != $firstPageKey">
              <a href="{portal:createPageUrl($firstPageKey, ())}">
                <xsl:value-of select="/result/menus/menu/name"/>
              </a>
              <xsl:call-template name="navigationPath">
                <xsl:with-param name="currentItem" select="/result/menuitems/menuitem"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/result/menus/menu/name"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="/result/contents/content">
            <xsl:value-of select="/result/contents/content/contentdata/name"/>
          </xsl:if>
        </div>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
