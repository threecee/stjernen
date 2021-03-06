<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:util="enonic:utilities" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" encoding="utf-8" indent="yes" method="xhtml" omit-xml-declaration="yes"/>

  <xsl:include href="passport.xsl"/>
  <xsl:include href="error-handler.xsl"/>
  <xsl:include href="/libraries/utilities/google-analytics.xsl"/>
  <xsl:include href="/libraries/utilities/utilities.xsl"/>

  <xsl:param name="north">
    <type>region</type>
  </xsl:param>
  <xsl:param name="west">
    <type>region</type>
  </xsl:param>
  <xsl:param name="center">
    <type>region</type>
  </xsl:param>
  <xsl:param name="east">
    <type>region</type>
  </xsl:param>
  <xsl:param name="south">
    <type>region</type>
  </xsl:param>

  <xsl:variable name="language" as="xs:string" select="/result/context/@languagecode"/>
  <xsl:variable name="current-resource" as="element()" select="/result/context/resource"/>
  <xsl:variable name="url" as="xs:string" select="/result/context/querystring/@url"/>
  <xsl:variable name="path" as="xs:string" select="concat('/', string-join(/result/context/resource/path/resource/name, '/'))"/>
  <xsl:variable name="skin" as="xs:string?" select="/result/preferences/preference[@basekey = 'skin']"/>
  <!-- Site configuration -->
  <xsl:variable name="config-site" as="element()" select="document(concat(/result/context/site/path-to-home-resources, '/config.xml'))/config"/>
  <xsl:variable name="config-parameter" as="element()*" select="$config-site/parameters/parameter"/>
  <xsl:variable name="config-group" as="element()*" select="$config-site/passport/groups/group"/>
  <xsl:variable name="config-skin" as="element()" select="if ($config-site/skins/skin[@name = $skin]) then document(concat('/skins/', $skin, '/skin.xml'))/skin else document(concat('/skins/', $config-site/skins/skin[1]/@name, '/skin.xml'))/skin"/>
  <xsl:variable name="config-device-class" as="element()" select="if ($config-skin/device-classes/device-class[tokenize(@name, ',')[. = $device-class]]) then $config-skin/device-classes/device-class[tokenize(@name, ',')[. = $device-class]] else $config-skin/device-classes/device-class[1]"/>
  <xsl:variable name="config-filter">
    <xsl:value-of select="string-join($config-device-class/image/filters/filter, ';')"/>
    <xsl:if test="$config-device-class/image/filters/filter != ''">;</xsl:if>
  </xsl:variable>
  <xsl:variable name="config-style" as="element()*" select="$config-device-class/styles/style"/>
  <xsl:variable name="front-page" select="util:get-scoped-parameter('front-page', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="search-result-page" select="util:get-scoped-parameter('search-result', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="sitemap-page" select="util:get-scoped-parameter('sitemap', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="rss-page" select="util:get-scoped-parameter('rss', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="google-tracker" select="util:get-scoped-parameter('google-tracker', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="google-verify" select="util:get-scoped-parameter('google-verify', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="toplevel" as="element()*" select="$config-device-class/menu/toplevels/toplevel"/>
  <xsl:variable name="sublevel" as="element()*" select="$config-device-class/menu/sublevels/sublevel"/>
  <xsl:variable name="layout-width" as="xs:integer" select="xs:integer($config-device-class/layout/width)"/>
  <xsl:variable name="layout-margin" as="xs:integer" select="xs:integer($config-device-class/layout/margin)"/>
  <xsl:variable name="layout-region-north" as="element()?" select="$config-device-class/layout/regions/region[@name = 'north']"/>
  <xsl:variable name="layout-region-west" as="element()?" select="$config-device-class/layout/regions/region[@name = 'west']"/>
  <xsl:variable name="layout-region-center" as="element()?" select="$config-device-class/layout/regions/region[@name = 'center']"/>
  <!-- Calculate center column width and right margin -->
  <xsl:variable name="center-column-attribute" as="xs:anyAtomicType+">
    <xsl:choose>
      <!-- 3 columns -->
      <xsl:when test="($region-west-count > 0 or $sub-menu) and $region-east-count > 0">
        <xsl:sequence select="xs:integer($layout-region-center/width - $layout-region-center/padding * 2), $layout-margin"/>
      </xsl:when>
      <!-- 2 columns, west + center -->
      <xsl:when test="$region-west-count > 0 or $sub-menu">
        <xsl:sequence select="xs:integer($layout-region-east/width + $layout-margin + $layout-region-center/width - $layout-region-center/padding * 2), 0"/>
      </xsl:when>
      <!-- 2 columns, center + east -->
      <xsl:when test="$region-east-count > 0">
        <xsl:sequence select="xs:integer($layout-region-west/width + $layout-margin + $layout-region-center/width - $layout-region-center/padding * 2), $layout-margin"/>
      </xsl:when>
      <!-- 1 column -->
      <xsl:otherwise>
        <xsl:sequence select="xs:integer($layout-region-west/width + $layout-margin + $layout-region-center/width - $layout-region-center/padding * 2 + $layout-margin + $layout-region-east/width), 0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="layout-region-east" as="element()?" select="$config-device-class/layout/regions/region[@name = 'east']"/>
  <xsl:variable name="layout-region-south" as="element()?" select="$config-device-class/layout/regions/region[@name = 'south']"/>
  <xsl:variable name="standard-region-parameters" as="xs:anyAtomicType*">
    <xsl:sequence select="'_config-skin', $config-skin/@name, '_config-site'"/>
  </xsl:variable>
  <xsl:variable name="path-to-skin" select="concat('/_public/skins/', $config-skin/@name)"/>
  <xsl:variable name="rendered-page" as="element()" select="/result/context/page"/>
  <!-- Number of portlet windows in region north -->
  <xsl:variable name="region-north-count" as="xs:integer" select="count($rendered-page/regions/region[name = 'north']/windows/window)"/>
  <!-- Number of portlet windows in region west -->
  <xsl:variable name="region-west-count" as="xs:integer" select="count($rendered-page/regions/region[name = 'west']/windows/window)"/>
  <!-- Number of portlet windows in region east -->
  <xsl:variable name="region-east-count" as="xs:integer" select="count($rendered-page/regions/region[name = 'east']/windows/window)"/>
  <!-- Number of portlet windows in region south -->
  <xsl:variable name="region-south-count" as="xs:integer" select="count($rendered-page/regions/region[name = 'south']/windows/window)"/>
  <!-- Page mode: set to 'submenu' to display sub menu for mobile menu ajax call -->
  <xsl:variable name="page-mode" as="xs:string?" select="/result/context/querystring/parameter[@name = 'page-mode']"/>
  <xsl:variable name="site-search-term" as="xs:string?" select="/result/context/querystring/parameter[@name = 'q']"/>
  <xsl:variable name="device-class" as="xs:string" select="/result/context/device-class"/>
  <xsl:variable name="site-name" as="xs:string" select="/result/context/site/name"/>
  <!-- Menu items on level 1 -->
  <xsl:variable name="menu" as="element()*" select="/result/menu/menus/menu/menuitems/menuitem"/>
  <!-- First menu level to display -->
  <xsl:variable name="main-menu" as="element()*" select="if ($config-site/multilingual = 'true') then $menu[@path = 'true']/menuitems/menuitem else $menu"/>
  <!-- Sub menu start level -->
  <xsl:variable name="sub-menu" as="element()*">
    <!-- Only if sublevel exists in skin config -->
    <xsl:if test="$sublevel">
      <xsl:choose>
        <!-- No toplevels, start submenu at menu level 1 -->
        <xsl:when test="count($toplevel) = 0 and $main-menu">
          <xsl:sequence select="$main-menu"/>
        </xsl:when>
        <!-- Start submenu at correct level, calculated from number of toplevels and multilingual -->
        <xsl:when test="$main-menu/descendant::menuitems[count(ancestor::menuitems) = (count($toplevel) + count($config-site/multilingual[. = 'true'])) and parent::menuitem/@path = 'true']/menuitem">
          <xsl:sequence select="$main-menu/descendant::menuitems[count(ancestor::menuitems) = (count($toplevel) + count($config-site/multilingual[. = 'true'])) and parent::menuitem/@path = 'true']/menuitem"/>
        </xsl:when>
        <!-- No regular sub menuitems and active menuitem is at last toplevel, start custom submenu at level 1 -->
        <xsl:when test="count($current-menuitem/ancestor::menuitems) = count($toplevel) + count($config-site/multilingual[. = 'true'])">
          <xsl:sequence select="$custom-menu"/>
        </xsl:when>
        <!-- No regular sub menuitems, start custom submenu at correct level -->
        <xsl:otherwise>
          <xsl:sequence select="/result/custom-menu/menuitems/descendant::menuitem[ancestor::menuitem[1]/@path = 'true' and count(ancestor::menuitems) = count($toplevel) + count($config-site/multilingual[. = 'true'])]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>
  <!-- Menu items under current menu item. Used by mobile menu ajax call. -->
  <xsl:variable name="current-menuitem" as="element()?" select="/result/menu/menuitems/descendant::menuitem[@key = portal:getPageKey()]"/>
  <!-- Custom menu -->
  <xsl:variable name="custom-menu" as="element()*" select="/result/custom-menu/menuitems/menuitem/menuitems/menuitem"/>
  <xsl:variable name="custom-menu-active-menuitem" as="element()?" select="$custom-menu/descendant-or-self::menuitem[@custom-key = /result/context/querystring/parameter[@name = 'page']]"/>
  <!-- Breadcrumb path -->
  <xsl:variable name="breadcrumb-path" as="element()*">
    <xsl:choose>
      <xsl:when test="$config-site/multilingual = 'true'">
        <xsl:sequence select="$current-resource/path/resource[position() &gt; 1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$current-resource/path/resource"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$custom-menu-active-menuitem">
      <xsl:sequence select="$custom-menu/descendant-or-self::menuitem[@path = 'true']"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="login-page" as="element()?" select="/result/context/site/login-page/resource"/>
  <xsl:variable name="error-page" as="element()?" select="/result/context/site/error-page/resource"/>
  <xsl:variable name="user" as="element()?" select="/result/context/user"/>
  <xsl:variable name="error-user" as="element()?" select="/result/context/querystring/parameter[contains(@name, 'error_user_')]"/>
  <xsl:variable name="success" as="element()?" select="/result/context/querystring/parameter[@name ='success']"/>
  <!-- Meta data -->
  <xsl:variable name="meta-generator" select="util:get-scoped-parameter('meta-generator', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="meta-author" select="util:get-scoped-parameter('meta-author', $path, $config-parameter)" as="element()?"/>
  <xsl:variable name="meta-description">
    <xsl:choose>
      <xsl:when test="/result/contents/content/contentdata/meta-description != ''">
        <xsl:value-of select="/result/contents/content/contentdata/meta-description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$current-resource/description"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="meta-keywords">
    <xsl:choose>
      <xsl:when test="/result/contents/content/contentdata/meta-keywords != ''">
        <xsl:value-of select="/result/contents/content/contentdata/meta-keywords"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$current-resource/keywords"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="meta-content-key">
      <xsl:value-of select="/result/context/resource[@type = 'content']/@key"/>
  </xsl:variable>
  <xsl:variable name="meta-content-type">
      <xsl:value-of select="/result/context/resource[@type = 'content']/type"/>
  </xsl:variable>

  <xsl:template match="/">
    <!-- Error casting -->
    <xsl:if test="not($config-site)">
      <xsl:value-of select="error(missingConfig, concat('Required sites/advanced/config.xml not found in: ', /result/context/site/path-to-home-resources))"/>
    </xsl:if>
    <xsl:if test="not($config-device-class)">
      <xsl:value-of select="error(missingDeviceClassConfig, 'Required config-device-class not resolved correctly.')"/>
    </xsl:if>
    <xsl:choose>
      <!-- Display submenu, used by mobile menu ajax call -->
      <xsl:when test="$page-mode = 'submenu'">
        <xsl:call-template name="sub-menu"/>
      </xsl:when>
      <!-- Display framework for device class mobile -->
      <xsl:when test="$device-class = 'mobile'">
        <xsl:call-template name="mobile-page"/>
      </xsl:when>
      <!-- Display framework for device class pc (default) -->
      <xsl:otherwise>
        <xsl:call-template name="pc-page"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Framework for device class pc (default) -->
  <xsl:template name="pc-page">
    <html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="{$language}" xml:lang="{$language}">
      <head>
        <title>
          <xsl:call-template name="title"/>
        </title>
        <meta name="robots" content="all"/>
        <meta http-equiv="X-UA-Compatible" content="chrome=1" />
        <xsl:if test="$meta-generator != ''">
          <meta name="generator" content="{$meta-generator}"/>
        </xsl:if>
        <meta http-equiv="content-language" content="{$language}"/>
        <xsl:if test="$meta-author != ''">
          <meta name="author" content="{$meta-author}"/>
        </xsl:if>
        <xsl:if test="$meta-description != ''">
          <meta name="description" content="{$meta-description}"/>
        </xsl:if>
        <xsl:if test="$meta-keywords != ''">
          <meta name="keywords" content="{$meta-keywords}"/>
        </xsl:if>
        <xsl:if test="$google-verify != ''">
          <meta content="{$google-verify}" name="google-site-verification"/>
        </xsl:if>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery-1.4.2.min.js')}"/>
       	<script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery.validate.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery-ui-1.7.2.custom.min.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery.tooltip.min.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery.cookie.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery.slideshow.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/sites/stjernen/scripts/common-all.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/sites/stjernen/scripts/common-pc.js')}"/>
        <script type="text/javascript">
          <xsl:comment>
            
            $(function() {
            
              <!-- Validates all forms -->
              $('form:not(.dont-validate)').each(function() {
                $(this).validate({
                  ignoreTitle: true,
                  errorPlacement: function(label, element) {
                    label.insertBefore(element.prev());
                  }
                });
              });
            
              <!-- Adds and localizes datepicker for all date inputs -->
              <xsl:value-of select="concat('$(&quot;.datepicker&quot;).datepicker($.extend({dateFormat: &quot;', portal:localize('jquery-datepicker-date-format'), '&quot;}, $.datepicker.regional[&quot;', $language, '&quot;]));')"/>
              <!-- , onSelect: function(dateText, inst) {$(this).trigger(&quot;focus&quot;);} -->
              $.validator.addMethod('datepicker', function(value, element) {
                var isValid = true;
                try {
                  $.datepicker.parseDate($(element).datepicker('option', 'dateFormat'), value)
                }
                catch(err) {
                  isValid = false;
                }
                return isValid;
              }, $.validator.messages.date);
            
              if ($('.datepicker').length &amp;&amp; $('.datepicker').rules) {
                $('.datepicker').rules('add', {
                  datepicker: true
                });
              }
            
              <!-- Localization of standard jquery.validate messages -->
              jQuery.extend(jQuery.validator.messages, {
                <xsl:value-of select="concat('required: &quot;', portal:localize('jquery-validate-required'), '&quot;,')"/>
                <xsl:value-of select="concat('maxlength: jQuery.validator.format(&quot;', portal:localize('jquery-validate-maxlength'), '&quot;),')"/>
                <xsl:value-of select="concat('minlength: jQuery.validator.format(&quot;', portal:localize('jquery-validate-minlength'), '&quot;),')"/>
                <xsl:value-of select="concat('rangelength: jQuery.validator.format(&quot;', portal:localize('jquery-validate-rangelength'), '&quot;),')"/>
                <xsl:value-of select="concat('email: &quot;', portal:localize('jquery-validate-email'), '&quot;,')"/>
                <xsl:value-of select="concat('url: &quot;', portal:localize('jquery-validate-url'), '&quot;,')"/>
                <xsl:value-of select="concat('date: &quot;', portal:localize('jquery-validate-date'), '&quot;,')"/>
                <xsl:value-of select="concat('dateISO: &quot;', portal:localize('jquery-validate-dateISO'), '&quot;,')"/>
                <xsl:value-of select="concat('number: &quot;', portal:localize('jquery-validate-number'), '&quot;,')"/>
                <xsl:value-of select="concat('digits: &quot;', portal:localize('jquery-validate-digits'), '&quot;,')"/>
                <xsl:value-of select="concat('equalTo: &quot;', portal:localize('jquery-validate-equalTo'), '&quot;,')"/>
                <xsl:value-of select="concat('range: jQuery.validator.format(&quot;', portal:localize('jquery-validate-range'), '&quot;),')"/>
                <xsl:value-of select="concat('max: jQuery.validator.format(&quot;', portal:localize('jquery-validate-max'), '&quot;),')"/>
                <xsl:value-of select="concat('min: jQuery.validator.format(&quot;', portal:localize('jquery-validate-min'), '&quot;),')"/>
                <xsl:value-of select="concat('creditcard: &quot;', portal:localize('jquery-validate-creditcard'), '&quot;')"/>
              });
            
            });
            
          //</xsl:comment>
        </script>
        <link rel="shortcut icon" type="image/x-icon" href="{portal:createResourceUrl(concat($path-to-skin, '/images/favicon.ico'))}"/>
        <!-- CSS -->
        <xsl:for-each select="$config-style[not(@condition != '')]">
          <link rel="stylesheet" href="{portal:createResourceUrl(.)}" type="text/css"/>
        </xsl:for-each>
        <xsl:if test="$config-style[@condition != '']">
          <xsl:text disable-output-escaping="yes">&lt;!--[if </xsl:text>
          <xsl:for-each-group select="$config-style[@condition != '']" group-by="@condition">
            <xsl:value-of select="@condition"/>
            <xsl:text disable-output-escaping="yes">]&gt;</xsl:text>
            <xsl:for-each select="$config-style[@condition = current()/@condition]">
              <xsl:text disable-output-escaping="yes">&lt;link rel="stylesheet" type="text/css" href="</xsl:text>
              <xsl:value-of select="portal:createResourceUrl(.)"/>
              <xsl:text disable-output-escaping="yes">"/&gt;</xsl:text>
            </xsl:for-each>
            <xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>
          </xsl:for-each-group>
        </xsl:if>

      </head>
      <body>
        <xsl:comment>googleoff: index</xsl:comment>
        <xsl:comment>stopindex</xsl:comment>
        <!-- Accessibility links -->
        <ul id="accessibility-links" class="screen">
          <xsl:if test="$main-menu and count($toplevel) &gt; 0">
            <li>
              <a href="{tokenize($url, '#')[1]}#main-menu" accesskey="m">
                <xsl:value-of select="portal:localize('accessibility-text-main-menu')"/>
              </a>
            </li>
          </xsl:if>
          <xsl:if test="$sub-menu">
            <li>
              <a href="{tokenize($url, '#')[1]}#sub-menu" accesskey="s">
                <xsl:value-of select="portal:localize('accessibility-text-sub-menu')"/>
              </a>
            </li>
          </xsl:if>
          <li>
            <a href="{tokenize($url, '#')[1]}#center" accesskey="c">
              <xsl:value-of select="portal:localize('accessibility-text-center')"/>
            </a>
          </li>
        </ul>
        <!-- Header with logo, top menu, user menu and search box -->
        <div id="header">
          <a class="screen" href="{portal:createUrl($front-page)}">
            <img alt="{$site-name}-{portal:localize('logo')}" id="logo-screen" src="{portal:createResourceUrl(concat($path-to-skin, '/images/logo-screen.png'))}" title="{$site-name}"/>
          </a>
          <img alt="{$site-name}-{portal:localize('logo')}" id="logo-print" class="print" src="{portal:createResourceUrl(concat($path-to-skin, '/images/logo-print.gif'))}" title="{$site-name}"/>
          <xsl:if test="$config-site/multilingual = 'true' or $config-site/accessibility-contrast = 'true' or $config-site/accessibility-text-size = 'true' or $user or $login-page or $sitemap-page != '' or $search-result-page != '' or (count($config-site/skins/skin) &gt; 1 and $user)">
            <div id="header-content" class="screen">
              <xsl:choose>
                <xsl:when test="$config-site/multilingual = 'true' or $config-site/accessibility-contrast = 'true' or $config-site/accessibility-text-size = 'true'">
                  <div class="header-content top clearfix">
                    <ul class="menu horizontal flags screen">
                      <xsl:if test="$config-site/accessibility-contrast = 'true'">
                        <li>
                          <a href="#" id="contrast">
                            <xsl:value-of select="portal:localize('High-contrast')"/>
                          </a>
                          <span class="link-divider">|</span>
                        </li>
                      </xsl:if>
                      <xsl:if test="$config-site/accessibility-text-size = 'true'">
                        <li id="text-size">
                          <a href="#">A</a>
                          <a href="#" class="large-text">A</a>
                          <a href="#" class="largest-text">A</a>
                        </li>
                      </xsl:if>
                      <xsl:if test="$config-site/multilingual = 'true'">
                        <xsl:for-each select="$menu">
                          <li>
                            <a href="{portal:createPageUrl(@key, ())}" class="tooltip" title="{parameters/parameter[@name = 'display-name']}">
                              <xsl:variable name="flag">
                                <xsl:value-of select="concat(concat($path-to-skin, '/images/flag-'), name)"/>
                                <xsl:if test="@path = 'true'">-active</xsl:if>
                                <xsl:text>.png</xsl:text>
                              </xsl:variable>
                              <img src="{portal:createResourceUrl($flag)}" alt="{parameters/parameter[@name = 'display-name']}"/>
                            </a>
                          </li>
                        </xsl:for-each>
                      </xsl:if>
                      </ul>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">only-bottom screen</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="$user or $login-page or $sitemap-page != '' or $search-result-page != '' or (count($config-site/skins/skin) &gt; 1 and $user)">
                <div class="header-content bottom clear clearfix">
                  <xsl:if test="$user">
                    <xsl:attribute name="class">header-content bottom clear clearfix logged-in</xsl:attribute>
                    <img src="{if ($user/photo/@exists = 'true') then portal:createImageUrl(concat('user/', $user/@key), 'scalesquare(48);rounded(2)') else portal:createResourceUrl(concat($path-to-skin, '/images/dummy-user-small.png'))}" title="{$user/display-name}" alt="{concat(portal:localize('Image-of'), ' ', $user/display-name)}" class="user-image">
                      <xsl:if test="$login-page">
                        <xsl:attribute name="class">user-image clickable</xsl:attribute>
                        <xsl:attribute name="onclick">
                          <xsl:value-of select="concat('location.href = &quot;', portal:createPageUrl($login-page/@key, ()), '&quot;;')"/>
                        </xsl:attribute>
                      </xsl:if>
                    </img>
                  </xsl:if>
                  <xsl:if test="/result/submenu/menuitems/menuitem">
                    <ul class="menu horizontal">
                      <xsl:choose>
                        <!-- User logged in -->
                        <xsl:when test="$user">
                          <li>
                            <xsl:choose>
                              <xsl:when test="$login-page">
                                <a href="{portal:createPageUrl($login-page/@key, ())}">
                                  <xsl:value-of select="$user/display-name"/>
                                </a>
                              </xsl:when>
                              <xsl:otherwise>
                                <div>
                                  <xsl:value-of select="$user/display-name"/>
                                </div>
                              </xsl:otherwise>
                            </xsl:choose>
                          </li>
                          <li>
                            <a href="{portal:createServicesUrl('user', 'logout')}">
                              <xsl:value-of select="portal:localize('Logout')"/>
                            </a>
                          </li>
                        </xsl:when>
                      </xsl:choose>
                      <xsl:apply-templates select="/result/submenu/menuitems/menuitem/menuitems/menuitem" mode="shortcuts"/>
                    </ul>
                  </xsl:if>
                  <!-- Skin selector -->
                  <xsl:if test="count($config-site/skins/skin) &gt; 1 and $user">
                    <form action="{portal:createServicesUrl('user', 'setpreferences')}" method="post" id="skin-selector">
                      <fieldset>
                        <label for="skin-selector-list">
                          <xsl:value-of select="portal:localize('Select-skin')"/>
                        </label>
                        <select name="SITE$skin" onchange="document.getElementById('skin-selector').submit();" id="skin-selector-list">
                          <xsl:for-each select="$config-site/skins/skin">
                            <option value="{@name}">
                              <xsl:if test="$skin = @name">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                              </xsl:if>
                              <xsl:value-of select="concat(translate(substring(@name, 1, 1), 'abcdefghijklmnopqrstuvwxyzæøå', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ'), substring(@name, 2))"/>
                            </option>
                          </xsl:for-each>
                        </select>
                      </fieldset>
                    </form>
                  </xsl:if>
                </div>
              </xsl:if>
            </div>
          </xsl:if>
        </div>
        <div id="outer-container" class="clear clearfix">
          <!-- Main menu -->
          <xsl:if test="$main-menu and count($toplevel) &gt; 0">
            <div class="clear clearfix" id="main-menu">
              <script type="text/javascript">
								$(function(){
									$('#carousel .image').each(function(){
										var t = $(this).text();
										var img = $(this).find('img').attr('title', t).clone();
										$(this).empty().append(img);
									});
									$('#carousel').nivoSlider();
								})
                <!-- suckerfish menu -->
//            sfHover = function() {
//             	var sfEls = document.getElementById("#main-menu ul").getElementsByTagName("LI");
//             	for (var i=0; i&lt;sfEls.length; i++) {
//             		sfEls[i].onmouseover=function() {
//             			this.className+=" sfhover";
//             		}
//             		sfEls[i].onmouseout=function() {
//             			this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
//             		}
//             	}
//             }
//             if (window.attachEvent) window.attachEvent("onload", sfHover)
              </script>
              <xsl:call-template name="main-menu"/>
              <!-- Search box -->
              <xsl:if test="$search-result-page != ''">
                <form action="{portal:createUrl($search-result-page)}" method="get">
                  <fieldset>
                    <label for="page-search-box">
                      <xsl:value-of select="portal:localize('Search')"/>
                    </label>
                    <input type="text" class="text" name="q" id="page-search-box" value="{$site-search-term}"/>
                    <input type="submit" class="submit" value="{portal:localize('Search')}"/>
                  </fieldset>
                </form>
              </xsl:if>
            </div>
          </xsl:if>
          <!-- Breadcrumb trail -->
          <xsl:if test="$config-device-class/menu/breadcrumb = 'true'">
            <div id="breadcrumb-trail" class="clear screen">
              <xsl:value-of select="concat(portal:localize('You-are-here'), ': ')"/>
              <!-- Always start with front page -->
              <xsl:choose>
                <xsl:when test="$breadcrumb-path[(show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) and not(@key = $front-page/@key)]">
                  <a href="{portal:createUrl($front-page)}">
                    <xsl:value-of select="$site-name"/>
                  </a>
                  <xsl:text> - </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$site-name"/>
                </xsl:otherwise>
              </xsl:choose>
              <!-- Loop through path -->
              <xsl:for-each select="$breadcrumb-path[((show-in-menu = 'true' or (position() = last() and @type = 'menuitem')) or @type = 'custom') and not(@key = $front-page/@key)]">
                <xsl:choose>
                  <xsl:when test="type = 'label' or type = 'section' or (position() = last() and @key = $current-resource/@key)">
                    <xsl:value-of select="util:menuitem-name(.)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:choose>
                          <xsl:when test="@type = 'custom'">
                            <xsl:value-of select="portal:createPageUrl(@key, ('page', @custom-key))"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="portal:createPageUrl(@key, ())"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:value-of select="util:menuitem-name(.)"/>
                    </a>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="not(position() = last() and @key = $current-resource/@key)">
                  <xsl:text> - </xsl:text>
                </xsl:if>
                <xsl:if test="position() = last() and @key != $current-resource/@key">
                  <xsl:value-of select="util:menuitem-name($current-resource)"/>
                </xsl:if>
              </xsl:for-each>
            </div>
          </xsl:if>
          <xsl:comment>googleon: index</xsl:comment>
          <xsl:comment>startindex</xsl:comment>
          <div id="middle-container" class="clear clearfix">
            <!-- Region north -->
            <xsl:if test="$region-north-count > 0">
              <div id="north" class="clear clearfix">
                <xsl:call-template name="render-region">
                  <xsl:with-param name="region" select="'north'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', xs:integer($layout-region-north/width - $layout-region-north/padding * 2), $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
            </xsl:if>
            <div id="inner-container" class="clear clearfix">
              <!-- Sub menu and region west -->
              <xsl:if test="$region-west-count > 0 or $sub-menu">
                <div id="west" class="column clear clearfix screen">
                  <xsl:if test="$sub-menu">
                    <xsl:comment>googleoff: index</xsl:comment>
                    <xsl:comment>stopindex</xsl:comment>
                    <ul class="menu sub append-bottom" id="sub-menu">
                      <xsl:choose>
                        <xsl:when test="count($toplevel) &gt; 0">
                          <xsl:variable name="parent-menuitem" as="item()">
                            <xsl:choose>
                              <xsl:when test="$sub-menu/ancestor::*[4]/name() = 'custom-menu'">
                                <xsl:sequence select="$current-menuitem"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:sequence select="$sub-menu/ancestor::menuitem[1]"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:variable>
                          <li>
                            <xsl:choose>
                              <xsl:when test="$parent-menuitem/@type = 'label' or $parent-menuitem/@type = 'section'">
                                <div class="first">
                                  <xsl:value-of select="util:menuitem-name($parent-menuitem)"/>
                                </div>
                              </xsl:when>
                              <xsl:otherwise>
                                <a href="{if ($parent-menuitem/@type = 'custom') then portal:createPageUrl($parent-menuitem/@key, ('page', $parent-menuitem/@custom-key)) else portal:createPageUrl($parent-menuitem/@key, ())}" class="first">
                                  <xsl:value-of select="util:menuitem-name($parent-menuitem)"/>
                                </a>
                              </xsl:otherwise>
                            </xsl:choose>
                            <ul class="clearfix">
                              <xsl:apply-templates select="$sub-menu" mode="menu">
                                <xsl:with-param name="levels" tunnel="yes" select="count($sublevel)"/>
                              </xsl:apply-templates>
                            </ul>
                          </li>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="$sub-menu" mode="menu">
                            <xsl:with-param name="levels" tunnel="yes" select="count($sublevel)"/>
                          </xsl:apply-templates>
                        </xsl:otherwise>
                      </xsl:choose>
                    </ul>
                    <xsl:comment>googleon: index</xsl:comment>
                    <xsl:comment>startindex</xsl:comment>
                  </xsl:if>
                  <xsl:call-template name="render-region">
                    <xsl:with-param name="region" select="'west'"/>
                    <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                      <xsl:sequence select="'_config-region-width', xs:integer($layout-region-west/width - $layout-region-west/padding * 2), $standard-region-parameters"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </div>
              </xsl:if>
              <!-- Region center -->
              <div id="center" class="column clearfix">
                <!-- If current page is login and error page -->
                <xsl:if test="$login-page/@key = portal:getPageKey() or $error-page/@key = portal:getPageKey()">
                  <h1>
                    <xsl:value-of select="util:menuitem-name($current-resource)"/>
                  </h1>
                  <xsl:choose>
                    <xsl:when test="$login-page/@key = portal:getPageKey()">
                      <xsl:call-template name="passport.passport">
                        <xsl:with-param name="user-image-src" tunnel="yes">
                          <xsl:if test="$user/photo/@exists = 'true'">
                            <xsl:value-of select="portal:createImageUrl(concat('user/', $user/@key), $config-filter)"/>
                          </xsl:if>
                        </xsl:with-param>
                        <xsl:with-param name="dummy-user-image-src" tunnel="yes" select="portal:createResourceUrl(concat($path-to-skin, '/images/dummy-user.png'))"/>
                        <xsl:with-param name="user" select="$user"/>
                        <xsl:with-param name="email-login" tunnel="yes" select="$config-site/passport/email-login"/>
                        <xsl:with-param name="edit-display-name" tunnel="yes" select="$config-site/passport/edit-display-name"/>
                        <xsl:with-param name="set-password" tunnel="yes" select="$config-site/passport/set-password"/>
                        <xsl:with-param name="userstore" tunnel="yes" select="/result/userstores/userstore"/>
                        <xsl:with-param name="time-zone" tunnel="yes" select="/result/time-zones/time-zone"/>
                        <xsl:with-param name="locale" tunnel="yes" select="/result/locales/locale"/>
                        <xsl:with-param name="country" tunnel="yes" select="/result/countries/country"/>
                        <xsl:with-param name="language" select="$language"/>
                        <xsl:with-param name="error" tunnel="yes" select="$error-user"/>
                        <xsl:with-param name="success" tunnel="yes" select="$success"/>
                        <xsl:with-param name="session-parameter" tunnel="yes" select="/result/context/session/attribute[@name = 'error_user_create']/form/parameter"/>
                        <xsl:with-param name="group" select="$config-group"/>
                        <xsl:with-param name="join-group-key" tunnel="yes" select="$config-site/passport/join-group-keys/join-group-key"/>
                        <xsl:with-param name="admin-name" tunnel="yes" select="$config-site/passport/admin-name"/>
                        <xsl:with-param name="admin-email" tunnel="yes" select="$config-site/passport/admin-email"/>
                        <xsl:with-param name="site-name" select="$site-name"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="error-handler.error-handler">
                        <xsl:with-param name="error" select="/result/context/querystring/parameter[@name = 'http_status_code']"/>
                        <xsl:with-param name="url" select="$url"/>
                        <xsl:with-param name="exception-message" select="/result/context/querystring/parameter[@name = 'exception_message']"/>
                        <xsl:with-param name="admin-name" select="$config-site/passport/admin-name"/>
                        <xsl:with-param name="admin-email" select="$config-site/passport/admin-email"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <xsl:call-template name="render-region">
                  <xsl:with-param name="region" select="'center'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', $center-column-attribute[1], $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
              <!-- Region east -->
              <xsl:if test="$region-east-count > 0">
                <div id="east" class="column clearfix screen">
                  <xsl:call-template name="render-region">
                    <xsl:with-param name="region" select="'east'"/>
                    <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                      <xsl:sequence select="'_config-region-width', xs:integer($layout-region-east/width - $layout-region-east/padding * 2), $standard-region-parameters"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </div>
              </xsl:if>
            </div>
            <!-- Region south -->
            <xsl:if test="$region-south-count > 0">
              <div id="south" class="clear clearfix">
                <xsl:call-template name="render-region">
                  <xsl:with-param name="region" select="'south'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', xs:integer($layout-region-south/width - $layout-region-south/padding * 2), $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
            </xsl:if>
          </div>
        </div>
        <xsl:comment>googleoff: index</xsl:comment>
        <xsl:comment>stopindex</xsl:comment>
        <!-- Footer -->
        <div id="footer" class="clear clearfix">
          <img alt="{$site-name}-{portal:localize('logo')}" src="{portal:createResourceUrl(concat($path-to-skin, '/images/logo-footer.png'))}" title="{$site-name}" class="screen"/>
          <xsl:if test="$rss-page">
            <a href="{portal:createUrl($rss-page)}" class="screen">
              <img src="{portal:createResourceUrl(concat($path-to-skin, '/images/icon-rss-large.png'))}" alt="RSS {portal:localize('icon')}"/>
            </a>
          </xsl:if>
          <p>
            <xsl:value-of select="portal:localize('footer-text', (year-from-date(current-date())))"/>
          </p>
          <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'mobile', 'lifetime', 'session'))}" class="device-class screen" rel="nofollow">
            <img src="{portal:createResourceUrl(concat($path-to-skin, '/images/icon-mobile.png'))}" alt="{portal:localize('Mobile-version')}" class="icon text"/>
            <xsl:value-of select="portal:localize('Change-to-mobile-version')"/>
          </a>
        </div>
        <xsl:if test="$google-tracker != ''">
          <xsl:call-template name="google-analytics.google-analytics">
            <xsl:with-param name="google-tracker" select="$google-tracker"/>
          </xsl:call-template>
        </xsl:if>
      </body>
    </html>
  </xsl:template>

  <!-- Display current sub menu for mobile menu ajax call -->
  <xsl:template match="menuitem" mode="sub-menu-current">
    <xsl:variable name="href" select="if (@type = 'custom') then portal:createPageUrl(@key, ('page', @custom-key)) else portal:createPageUrl(@key, ())"/>
    <li>
      <xsl:if test="position() = 1 or ((@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and $custom-menu[@path = 'true']))">
        <xsl:attribute name="class">
          <xsl:if test="position() = 1">
            <xsl:text>first</xsl:text>
          </xsl:if>
          <xsl:if test="(@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and $custom-menu[@path = 'true'])">
            <xsl:attribute name="class"> active</xsl:attribute>
          </xsl:if>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@type = 'label' or @type = 'section'">
          <div>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$href}">
            <xsl:choose>
              <xsl:when test="@type = 'url' and url/@newwindow = 'yes'">
                <xsl:attribute name="rel">external</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">
                  <xsl:text>nav</xsl:text>
                  <xsl:choose>
                    <xsl:when test="(@path = 'true' and menuitems/menuitem) or (parameters/parameter[@name = 'custom-menu'] = 'true' and $custom-menu)"> open</xsl:when>
                    <xsl:when test="menuitems/@child-count &gt; 0 or parameters/parameter[@name = 'custom-menu'] = 'true'"> closed</xsl:when>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </a>
          <a href="{$href}" class="bullet arrow">
            <xsl:if test="url/@newwindow = 'yes'">
              <xsl:attribute name="rel">external</xsl:attribute>
            </xsl:if>
            <br/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="(@path = 'true' and menuitems/menuitem) or (@type != 'custom' and @active = 'true' and $custom-menu)">
        <xsl:variable name="menuitem" as="element()+">
          <xsl:sequence select="menuitems/menuitem"/>
          <xsl:if test="@type != 'custom' and @active = 'true' and $custom-menu">
            <xsl:sequence select="$custom-menu"/>
          </xsl:if>
        </xsl:variable>
        <ul>
          <xsl:apply-templates select="$menuitem" mode="sub-menu-current"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <!-- Styles for fixed horizontal menu -->
  <xsl:template name="main-menu-styles">
    <xsl:param name="current-menuitem" select="$main-menu"/>
    <xsl:param name="level" select="1"/>
    <xsl:if test="$toplevel[$level]/@fixed = 'true'">
      <xsl:variable name="current-menu-level" select="concat('.menu.main.level', $level)"/>
      <xsl:variable name="width-per-menuitem" select="floor($layout-width div count($current-menuitem))"/>
      <xsl:value-of select="concat($current-menu-level, ' .fixed-add-one { width: ', $width-per-menuitem + 1, 'px; } ', $current-menu-level, ' .fixed { width: ', $width-per-menuitem, 'px; }')"/>
    </xsl:if>
    <xsl:if test="($current-menuitem[@path = 'true']/menuitems/menuitem or ($current-menuitem[@active = 'true'] and $custom-menu)) and $level &lt; count($toplevel)">
      <xsl:variable name="menuitem" as="element()+">
        <xsl:sequence select="$current-menuitem[@path = 'true']/menuitems/menuitem"/>
        <xsl:if test="$current-menuitem[@active = 'true'] and $custom-menu">
          <xsl:sequence select="$custom-menu"/>
        </xsl:if>
      </xsl:variable>
      <xsl:call-template name="main-menu-styles">
        <xsl:with-param name="current-menuitem" select="$menuitem"/>
        <xsl:with-param name="level" select="$level + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Horizontal menu -->
  <xsl:template name="main-menu">
    <xsl:param name="current-menuitem" select="$main-menu"/>
    <xsl:param name="level" select="1"/>
    <ul class="menu horizontal main screen clearfix level{$level}">
      <xsl:choose>
        <!-- Fixed menu - calculate menuitem width -->
        <xsl:when test="$toplevel[$level]/@fixed = 'true'">
          <xsl:apply-templates select="$current-menuitem" mode="menu">
            <xsl:with-param name="levels" tunnel="yes" select="1"/>
            <xsl:with-param name="fixed" tunnel="yes" select="true()"/>
            <xsl:with-param name="rest" select="$layout-width mod count($current-menuitem)"/>
          </xsl:apply-templates>
        </xsl:when>
        <!-- Non-fixed menu -->
        <xsl:otherwise>
          <xsl:apply-templates select="$current-menuitem[not(parameters/parameter[@name = 'hidden'])]" mode="menu">
            <xsl:with-param name="levels" tunnel="yes" select="1"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
    <xsl:if test="($current-menuitem[@path = 'true']/menuitems/menuitem or ($current-menuitem[@active = 'true'] and $custom-menu)) and $level &lt; count($toplevel)">
      <xsl:variable name="menuitem" as="element()+">
        <xsl:sequence select="$current-menuitem[@path = 'true']/menuitems/menuitem"/>
        <xsl:if test="$current-menuitem[@active = 'true'] and $custom-menu">
          <xsl:sequence select="$custom-menu"/>
        </xsl:if>
      </xsl:variable>
      <xsl:call-template name="main-menu">
        <xsl:with-param name="current-menuitem" select="$menuitem"/>
        <xsl:with-param name="level" select="$level + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Display menu -->
  <xsl:template match="menuitem" mode="menu">
    <xsl:param name="levels" select="1000" tunnel="yes"/>
    <xsl:param name="level" select="1"/>
    <xsl:param name="fixed" tunnel="yes" select="false()"/>
    <xsl:param name="rest" select="0"/>
    <xsl:variable name="href" select="if (@type = 'custom') then portal:createPageUrl(@key, ('page', @custom-key)) else portal:createPageUrl(@key, ())"/>
    <li>
      <xsl:if test="$fixed">
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="position() &lt;= $rest">fixed-add-one</xsl:when>
            <xsl:otherwise>fixed</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@type = 'label' or @type = 'section'">
          <div>
            <xsl:if test="position() = 1 or position() = last() or @path = 'true' or ((@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and $custom-menu[@path = 'true']))">
              <xsl:attribute name="class">
                <xsl:if test="position() = 1">
                  <xsl:text>first</xsl:text>
                </xsl:if>
                <xsl:if test="position() = last()">
                  <xsl:text> last</xsl:text>
                </xsl:if>
                <xsl:if test="@path = 'true'">
                  <xsl:text> path</xsl:text>
                </xsl:if>
                <xsl:if test="(@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and $custom-menu[@path = 'true'])">
                  <xsl:attribute name="class"> active</xsl:attribute>
                </xsl:if>
              </xsl:attribute>
            </xsl:if>
            <!-- Includes title to support the case of horizontal menu and a long menuitem name that doesn't fit in the design -->
            <xsl:attribute name="title">
              <xsl:value-of select="util:menuitem-name(.)"/>
            </xsl:attribute>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$href}">
            <xsl:if test="url/@newwindow = 'yes'">
              <xsl:attribute name="rel">external</xsl:attribute>
            </xsl:if>
            <xsl:if test="position() = 1 or position() = last() or @path = 'true' or ((@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and $custom-menu[@path = 'true']))">
              <xsl:attribute name="class">
                <xsl:if test="position() = 1">
                  <xsl:text>first</xsl:text>
                </xsl:if>
                <xsl:if test="position() = last()">
                  <xsl:text> last</xsl:text>
                </xsl:if>
                <xsl:if test="@path = 'true'">
                  <xsl:text> path</xsl:text>
                </xsl:if>
                <xsl:if test="(@active = 'true' or (@path = 'true' and not(menuitems/menuitem))) and not(@type != 'custom' and $custom-menu[@path = 'true'])">
                  <xsl:attribute name="class"> active</xsl:attribute>
                </xsl:if>
              </xsl:attribute>
            </xsl:if>
            <!-- Includes title to support the case of horizontal menu and a long menuitem name that doesn't fit in the design -->
            <xsl:attribute name="title">
              <xsl:value-of select="util:menuitem-name(.)"/>
            </xsl:attribute>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <!-- Display next menu level -->
      <xsl:if test="(menuitems/menuitem)">
        <xsl:variable name="menuitem" as="element()+">
          <xsl:sequence select="menuitems/menuitem"/>
          <xsl:if test="@type != 'custom' and @active = 'true' and $custom-menu">
            <xsl:sequence select="$custom-menu"/>
          </xsl:if>
        </xsl:variable>
        <ul class="clearfix">
          <xsl:choose>
            <!-- Fixed width -->
            <xsl:when test="$fixed">
              <xsl:apply-templates select="$menuitem" mode="menu">
                <xsl:with-param name="level" select="$level + 1"/>
                <xsl:with-param name="rest" select="$layout-width mod count($menuitem)"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$menuitem" mode="menu">
                <xsl:with-param name="level" select="$level + 1"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  
  <!-- Submenu only, used by mobile menu ajax call -->
  <xsl:template name="sub-menu">
    <xsl:variable name="menuitem" as="element()*">
      <xsl:choose>
        <xsl:when test="$current-menuitem/menuitems/menuitem">
          <xsl:sequence select="$current-menuitem/menuitems/menuitem"/>
        </xsl:when>
        <xsl:when test="$custom-menu-active-menuitem/menuitems/menuitem">
          <xsl:sequence select="$custom-menu-active-menuitem/menuitems/menuitem"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$custom-menu"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$menuitem">
      <div xmlns="http://www.w3.org/1999/xhtml">
        <div>
          <ul>
            <xsl:apply-templates select="$menuitem" mode="sub-menu-current"/>
          </ul>
        </div>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- Framework for device class mobile -->
  <xsl:template name="mobile-page">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="{$language}" xml:lang="{$language}">
      <head>
        <title>
          <xsl:call-template name="title"/>
        </title>
        <meta content="minimum-scale=1.0, width=device-width, user-scalable=yes" name="viewport"/>
        <meta name="apple-mobile-web-app-capable" content="yes"/>
        <xsl:if test="$meta-generator != ''">
          <meta name="generator" content="{$meta-generator}"/>
        </xsl:if>
        <meta http-equiv="content-language" content="{$language}"/>
        <xsl:if test="$meta-author != ''">
          <meta name="author" content="{$meta-author}"/>
        </xsl:if>
        <xsl:if test="$google-verify != ''">
          <meta content="{$google-verify}" name="google-site-verification"/>
        </xsl:if>
        <xsl:if test="$meta-content-key != ''">
            <meta name="_key" content="{$meta-content-key}"/>
        </xsl:if>
        <xsl:if test="$meta-content-type != ''">
            <meta name="_cty" content="{$meta-content-type}"/>
        </xsl:if>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery-1.4.2.min.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery.validate.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery-ui-1.7.2.custom.min.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery.cookie.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/libraries/jquery/jquery.slideshow.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/sites/advanced/scripts/common-all.js')}"/>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/sites/advanced/scripts/common-mobile.js')}"/>
        <script type="text/javascript">
          <xsl:comment>
            
            $(function() {
            
              <!-- Mobile menu: Toggle -->
              $('#navigation a').click(function (event) {
                event.preventDefault();
                var navBar = $(this);
                $('#menu').slideToggle('fast', function() {
                  navBar.toggleClass('plus');
                  navBar.toggleClass('minus');
                  <xsl:value-of select="concat('if (navBar.text() == &quot;', portal:localize('Show-menu'), '&quot;) {')"/>
                  <xsl:text>
                    </xsl:text>
                    <xsl:value-of select="concat('navBar.text(&quot;', portal:localize('Hide-menu'), '&quot;);')"/>
                  } else {
                    <xsl:value-of select="concat('navBar.text(&quot;', portal:localize('Show-menu'), '&quot;);')"/>
                  }
                });
              });
            
              <!-- Validates all forms -->
              $('form:not(.dont-validate)').each(function() {
                $(this).validate({
                  ignoreTitle: true,
                  errorPlacement: function(label, element) {
                    label.insertBefore(element);
                  }
                });
              });
            
              <!-- Adds and localizes datepicker for all date inputs -->
              <xsl:value-of select="concat('$(&quot;.datepicker&quot;).datepicker($.extend({dateFormat: &quot;', portal:localize('jquery-datepicker-date-format'), '&quot;}, $.datepicker.regional[&quot;', $language, '&quot;]));')"/>
              $.validator.addMethod('datepicker', function(value, element) {
                var isValid = true;
                try {
                  $.datepicker.parseDate($(element).datepicker('option', 'dateFormat'), value)
                }
                catch(err) {
                  isValid = false;
                }
                return isValid;
              }, $.validator.messages.date);
            
              if ($('.datepicker').length &amp;&amp; $('.datepicker').rules) {
                $('.datepicker').rules('add', {
                  datepicker: true
                });
              }
            
              <!-- Localization of standard jquery.validate messages -->
              jQuery.extend(jQuery.validator.messages, {
                <xsl:value-of select="concat('required: &quot;', portal:localize('jquery-validate-required'), '&quot;,')"/>
                <xsl:value-of select="concat('maxlength: jQuery.validator.format(&quot;', portal:localize('jquery-validate-maxlength'), '&quot;),')"/>
                <xsl:value-of select="concat('minlength: jQuery.validator.format(&quot;', portal:localize('jquery-validate-minlength'), '&quot;),')"/>
                <xsl:value-of select="concat('rangelength: jQuery.validator.format(&quot;', portal:localize('jquery-validate-rangelength'), '&quot;),')"/>
                <xsl:value-of select="concat('email: &quot;', portal:localize('jquery-validate-email'), '&quot;,')"/>
                <xsl:value-of select="concat('url: &quot;', portal:localize('jquery-validate-url'), '&quot;,')"/>
                <xsl:value-of select="concat('date: &quot;', portal:localize('jquery-validate-date'), '&quot;,')"/>
                <xsl:value-of select="concat('dateISO: &quot;', portal:localize('jquery-validate-dateISO'), '&quot;,')"/>
                <xsl:value-of select="concat('number: &quot;', portal:localize('jquery-validate-number'), '&quot;,')"/>
                <xsl:value-of select="concat('digits: &quot;', portal:localize('jquery-validate-digits'), '&quot;,')"/>
                <xsl:value-of select="concat('equalTo: &quot;', portal:localize('jquery-validate-equalTo'), '&quot;,')"/>
                <xsl:value-of select="concat('range: jQuery.validator.format(&quot;', portal:localize('jquery-validate-range'), '&quot;),')"/>
                <xsl:value-of select="concat('max: jQuery.validator.format(&quot;', portal:localize('jquery-validate-max'), '&quot;),')"/>
                <xsl:value-of select="concat('min: jQuery.validator.format(&quot;', portal:localize('jquery-validate-min'), '&quot;),')"/>
                <xsl:value-of select="concat('creditcard: &quot;', portal:localize('jquery-validate-creditcard'), '&quot;')"/>
              });
            
            });
            
          //</xsl:comment>
        </script>
        <!-- iPhone icon -->
        <link rel="apple-touch-icon" href="{portal:createResourceUrl(concat($path-to-skin, '/images-mobile/apple-touch-icon.png'))}"/>
        <!-- CSS -->
        <xsl:for-each select="$config-style[not(@type = 'conditional')]">
          <link rel="stylesheet" href="{portal:createResourceUrl(.)}" type="text/css"/>
        </xsl:for-each>
        <style type="text/css">
          <!-- Width settings, for screen only -->
          <xsl:text>@media screen { #header, #page-search-form, #center, #footer {</xsl:text>
          <xsl:value-of select="concat('width: ', $layout-region-center/width - $layout-region-center/padding * 2, 'px;')"/>
          <xsl:value-of select="concat('padding: ', $layout-region-center/padding, 'px;')"/>
          <xsl:text>} #outer-container, #navigation, #menu {</xsl:text>
          <xsl:value-of select="concat('width: ', $layout-width, 'px;')"/>
          <xsl:text>} #north {</xsl:text>
          <xsl:value-of select="concat('width: ', $layout-region-north/width - $layout-region-north/padding * 2, 'px;')"/>
          <xsl:value-of select="concat('padding: ', $layout-region-north/padding, 'px;')"/>
          <xsl:text>} #south {</xsl:text>
          <xsl:value-of select="concat('width: ', $layout-region-south/width - $layout-region-south/padding * 2, 'px;')"/>
          <xsl:value-of select="concat('padding: ', $layout-region-south/padding, 'px;')"/>
          <xsl:text>}}</xsl:text>
          <!-- Frame settings, for all media -->
          <xsl:for-each select="$config-device-class/layout/regions/region[framepadding &gt; 0 or frameborder &gt; 0]">
            <xsl:value-of select="concat('#', @name, ' .frame {')"/>
            <xsl:if test="framepadding &gt; 0">
              <xsl:value-of select="concat('padding: ', framepadding, 'px;')"/>
            </xsl:if>
            <xsl:if test="frameborder &gt; 0">
              <xsl:value-of select="concat('border-width: ', frameborder, 'px;')"/>
            </xsl:if>
            <xsl:text>}</xsl:text>
          </xsl:for-each>
        </style>
      </head>
      <body>
        <!-- Header with logo and search box -->
        <div id="header" class="clearfix">
          <a href="{portal:createUrl($front-page)}">
            <img alt="{$site-name}-{portal:localize('logo')}" id="logo" src="{portal:createResourceUrl(concat($path-to-skin, '/images-mobile/logo.png'))}" title="{$site-name}"/>
          </a>
          <xsl:if test="$user or $login-page or $config-site/multilingual = 'true'">
            <div id="top-menu" class="screen">
              <xsl:choose>
                <!-- User logged in -->
                <xsl:when test="$user">
                  <img src="{if ($user/photo/@exists = 'true') then portal:createImageUrl(concat('user/', $user/@key), 'scalesquare(28);rounded(2)') else portal:createResourceUrl(concat($path-to-skin, '/images/dummy-user-smallest.png'))}" title="{$user/display-name}" alt="{concat(portal:localize('Image-of'), ' ', $user/display-name)}">
                    <xsl:if test="$login-page">
                      <xsl:attribute name="class">user-image clickable</xsl:attribute>
                      <xsl:attribute name="onclick">
                        <xsl:value-of select="concat('location.href = &quot;', portal:createPageUrl($login-page/@key, ()), '&quot;;')"/>
                      </xsl:attribute>
                    </xsl:if>
                  </img>
                  <xsl:comment>googleoff: anchor</xsl:comment>
                  <a href="{portal:createServicesUrl('user', 'logout')}">
                    <xsl:value-of select="portal:localize('Logout')"/>
                  </a>
                  <xsl:comment>googleon: anchor</xsl:comment>
                </xsl:when>
                <!-- User not logged in -->
                <xsl:when test="$login-page">
                  <a href="{portal:createPageUrl($login-page/@key, ())}">
                    <xsl:value-of select="portal:localize('Login')"/>
                  </a>
                </xsl:when>
              </xsl:choose>
              <xsl:if test="$config-site/multilingual = 'true'">
                <select onchange="location.href = this.value;">
                  <xsl:for-each select="$menu">
                    <option value="{portal:createPageUrl(@key, ())}">
                      <xsl:if test="@path = 'true'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="parameters/parameter[@name = 'display-name']"/>
                    </option>
                  </xsl:for-each>
                </select>
              </xsl:if>
            </div>
          </xsl:if>
        </div>
        <div id="outer-container" class="clear clearfix">
          <!-- Mobile menu and search -->
          <xsl:if test="$main-menu">
            <div id="navigation" class="clearfix">
              <a href="#" class="bullet plus">
                <xsl:value-of select="portal:localize('Show-menu')"/>
              </a>
            </div>
            <!-- Menu -->
            <ul id="menu" class="clear">
              <!-- Does not support submenus under labels/sections, because the ajax request to a label page will fail -->
              <xsl:apply-templates select="$main-menu" mode="sub-menu-current"/>
            </ul>
          </xsl:if>
          <!-- Search box -->
          <xsl:if test="$search-result-page != ''">
            <form action="{portal:createUrl($search-result-page)}" method="get" class="clear" id="page-search-form">
              <fieldset>
                <label for="page-search-box">
                  <xsl:value-of select="portal:localize('Search')"/>
                </label>
                <input type="text" class="text" name="q" id="page-search-box" value="{$site-search-term}"/>
                <input type="submit" class="button" value="{portal:localize('Go')}"/>
              </fieldset>
            </form>
          </xsl:if>
          <div id="middle-container" class="clear clearfix">
            <!-- Region north -->
            <xsl:if test="$region-north-count > 0">
              <div id="north" class="clear clearfix">
                <xsl:call-template name="render-region">
                  <xsl:with-param name="region" select="'north'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', xs:integer($layout-region-north/width - $layout-region-north/padding * 2), $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
            </xsl:if>
            <div id="inner-container" class="clear clearfix">
              <!-- Region center -->
              <div id="center" class="clear clearfix">
                <xsl:if test="$login-page/@key = portal:getPageKey() or $error-page/@key = portal:getPageKey()">
                  <h1>
                    <xsl:value-of select="util:menuitem-name($current-resource)"/>
                  </h1>
                  <xsl:choose>
                    <xsl:when test="$login-page/@key = portal:getPageKey()">
                      <xsl:call-template name="passport.passport">
                        <xsl:with-param name="user-image-src" tunnel="yes">
                          <xsl:if test="$user/photo/@exists = 'true'">
                            <xsl:value-of select="portal:createImageUrl(concat('user/', $user/@key), concat($config-filter, 'scalewidth(200)'))"/>
                          </xsl:if>
                        </xsl:with-param>
                        <xsl:with-param name="dummy-user-image-src" tunnel="yes" select="portal:createResourceUrl(concat($path-to-skin, '/images/dummy-user-mobile.png'))"/>
                        <xsl:with-param name="user" select="$user"/>
                        <xsl:with-param name="email-login" tunnel="yes" select="$config-site/passport/email-login"/>
                        <xsl:with-param name="edit-display-name" tunnel="yes" select="$config-site/passport/edit-display-name"/>
                        <xsl:with-param name="set-password" tunnel="yes" select="$config-site/passport/set-password"/>
                        <xsl:with-param name="userstore" tunnel="yes" select="/result/userstores/userstore"/>
                        <xsl:with-param name="time-zone" tunnel="yes" select="/result/time-zones/time-zone"/>
                        <xsl:with-param name="locale" tunnel="yes" select="/result/locales/locale"/>
                        <xsl:with-param name="country" tunnel="yes" select="/result/countries/country"/>
                        <xsl:with-param name="language" select="$language"/>
                        <xsl:with-param name="error" tunnel="yes" select="$error-user"/>
                        <xsl:with-param name="success" tunnel="yes" select="$success"/>
                        <xsl:with-param name="session-parameter" tunnel="yes" select="/result/context/session/attribute[@name = 'error_user_create']/form/parameter"/>
                        <xsl:with-param name="group" select="$config-group"/>
                        <xsl:with-param name="join-group-key" tunnel="yes" select="$config-site/passport/join-group-keys/join-group-key"/>
                        <xsl:with-param name="admin-name" tunnel="yes" select="$config-site/passport/admin-name"/>
                        <xsl:with-param name="admin-email" tunnel="yes" select="$config-site/passport/admin-email"/>
                        <xsl:with-param name="site-name" select="$site-name"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="error-handler.error-handler">
                        <xsl:with-param name="error" select="/result/context/querystring/parameter[@name = 'http_status_code']"/>
                        <xsl:with-param name="url" select="$url"/>
                        <xsl:with-param name="exception-message" select="/result/context/querystring/parameter[@name = 'exception_message']"/>
                        <xsl:with-param name="admin-name" select="$config-site/passport/admin-name"/>
                        <xsl:with-param name="admin-email" select="$config-site/passport/admin-email"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <xsl:call-template name="render-region">
                  <xsl:with-param name="region" select="'center'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', xs:integer($layout-region-center/width - $layout-region-center/padding * 2), $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
            </div>
            <!-- Region south -->
            <xsl:if test="$region-south-count > 0">
              <div id="south" class="clear clearfix">
                <xsl:call-template name="render-region">
                  <xsl:with-param name="region" select="'south'"/>
                  <xsl:with-param name="parameters" as="xs:anyAtomicType*">
                    <xsl:sequence select="'_config-region-width', xs:integer($layout-region-south/width - $layout-region-south/padding * 2), $standard-region-parameters"/>
                  </xsl:with-param>
                </xsl:call-template>
              </div>
            </xsl:if>
          </div>
        </div>
        <!-- Footer -->
        <div id="footer">
          <p>
            <xsl:if test="$rss-page">
              <a href="{portal:createUrl($rss-page)}">
                <img src="{portal:createResourceUrl(concat($path-to-skin, '/images/icon-rss-large.png'))}" alt="RSS {portal:localize('icon')}"/>
              </a>
            </xsl:if>
            <xsl:value-of select="portal:localize('footer-text', (year-from-date(current-date())))"/>
          </p>
          <p>
            <a href="{portal:createServicesUrl('portal','forceDeviceClass', ('deviceclass', 'pc', 'lifetime', 'session'))}">
              <img src="{portal:createResourceUrl(concat($path-to-skin, '/images-mobile/icon-pc.png'))}" alt="{portal:localize('PC-version')}" class="icon text"/>
              <xsl:value-of select="portal:localize('Change-to-pc-version')"/>
            </a>
          </p>
        </div>
        <xsl:if test="$google-tracker != ''">
          <xsl:call-template name="google-analytics.google-analytics">
            <xsl:with-param name="google-tracker" select="$google-tracker"/>
          </xsl:call-template>
        </xsl:if>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="menuitem" mode="shortcuts">
    <xsl:variable name="href" select="portal:createPageUrl(@key, ())"/>
    <li>
      <xsl:if test="(@active = 'true' or (@path = 'true'))">
        <xsl:attribute name="class"> active</xsl:attribute>
      </xsl:if>      
      <xsl:choose>
        <xsl:when test="@type = 'label' or @type = 'section'">
          <div>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <a href="{$href}">
            <xsl:if test="@type = 'url' and url/@newwindow = 'yes'">
              <xsl:attribute name="rel">external</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="util:menuitem-name(.)"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <!-- Create portlet placeholder for region -->
  <xsl:template name="render-region">
    <xsl:param name="region"/>
    <xsl:param name="parameters" as="xs:anyAtomicType*"/>
    <xsl:for-each select="$rendered-page/regions/region[name = $region]/windows/window">
      <xsl:value-of select="portal:createWindowPlaceholder(@key, $parameters)"/>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Title tag content -->
  <xsl:template name="title">
    <xsl:choose>
      <xsl:when test="$custom-menu-active-menuitem">
        <xsl:value-of select="util:menuitem-name($custom-menu-active-menuitem)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="util:menuitem-name($current-resource)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="concat(' - ', $site-name)"/>
  </xsl:template>

</xsl:stylesheet>
