<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"

    xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal"

    xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema"

    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="yes"  method="xhtml" omit-xml-declaration="yes"/>

    

<xsl:template name="javascript">
    <xsl:variable name="javascript" select="'/_public/shared/scripts/standard.js'"/>
    <xsl:variable name="javascript2" select="'/_public/site/Stjernen/scripts/jquery-1.3.2.min.js'"/>
    <!--xsl:variable name="javascript3" select="'/_public/site/Stjernen/scripts/jquery.dimensions.min.js'"/>
    <xsl:variable name="javascript4" select="'/_public/site/Stjernen/scripts/jquery.menu.pack.js'"/-->
    
    <script src="{portal:createResourceUrl($javascript)}" type="text/javascript">
        <xsl:comment>//</xsl:comment>
    </script>
    <script src="{portal:createResourceUrl($javascript2)}" type="text/javascript">
        <xsl:comment>//</xsl:comment>
    </script>
    <!--script src="{portal:createResourceUrl($javascript3)}" type="text/javascript">
        <xsl:comment>//</xsl:comment>
    </script>
    <script src="{portal:createResourceUrl($javascript4)}" type="text/javascript">
        <xsl:comment>//</xsl:comment>
    </script-->
    
    
</xsl:template>

    

    

    <xsl:variable name="printCSS" select="'/_public/site/Stjernen/styles/print.css'"/>

    <xsl:variable name="screencss" select="'/_public/site/Stjernen/styles/screen.css'"/>  

    <xsl:variable name="logoScreen" select="'/_public/site/Stjernen/images/stjernenlogo.jpg'"/>

    <xsl:variable name="logoPrint" select="'/_public/site/Stjernen/images/logo_print.gif'"/>

    <xsl:variable name="feedIcon" select="'/_public/site/Stjernen/images/feedicon12.gif'"/>

    <xsl:variable name="GamecenterFlash" select="'http://www.tomrino.com/komponenter/Gamecenter.swf'"/>

    <xsl:variable name="LitenTabellFlash" select="'http://www.tomrino.com/komponenter/LitenTabell.swf'"/>

    <xsl:variable name="PoenglederFlash" select="'http://www.tomrino.com/komponenter/Poengleder.swf'"/>

    <xsl:variable name="SpillerStatistikkFlash" select="'http://www.tomrino.com/komponenter/Spillerstatistikk.swf'"/>

    

    <xsl:variable name="lagprofilcontenttype" select="'Lagprofil'"/>

    

    

    <xsl:variable name="language" select="/result/context/@languagecode"/>

    <xsl:variable name="siteName" select="/result/context/site/name"/>

    <xsl:variable name="referer"    select="/result/context/querystring/parameter[@name = 'referer']"/>

    <xsl:variable name="user" select="/result/context/user"/>

    <xsl:variable name="currentPageId"    select="/result/context/querystring/parameter[@name = 'id']"/>

    <xsl:variable name="content" select="/result/contents[1]/content"/>

    <xsl:variable name="category" select="/result/categories/category"/>

    <xsl:variable name="menuitem" select="/result/menuitems//menuitem[@key = $currentPageId]"/>

    <xsl:variable name="pageDescription" select="$menuitem/description"/>

    <xsl:variable name="pageKeywords" select="$menuitem/keywords"/>

    <xsl:variable name="heading"    select="/result/context/querystring/parameter[@name = 'heading']"/>

    <!-- needed for crumbs -->

    <xsl:variable name="firstPageKey" select="/result/menus/menu/firstpage/@key"/>

    <xsl:variable name="pagetitle"

        select="/result/context/querystring/parameter[@name = 'pagetitle']"/>

    <!-- /needed for crumbs -->

    <xsl:variable name="rssPage" select="5"/>

    <xsl:variable name="contactPage" select="2"/>

    

    <xsl:variable name="spillerinformasjonTittel" select="'Spillerinformasjon'"/>

    

    <xsl:variable name="fullContentWidth" select="930"/>

    <xsl:variable name="rightColumnWidth" select="306"/>

    <xsl:variable name="rightColumnImageWidth" select="294"/>

    

</xsl:stylesheet>