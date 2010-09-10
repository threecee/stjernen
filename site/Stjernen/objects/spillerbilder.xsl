<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:include href="/site/Stjernen/includes/languageArticle.xsl"/>
    <!--xsl:include href="/shared/includes/displayImage.xsl"/-->
    <xsl:include href="/libraries/commons/includes/utilities.xsl"/>
    <xsl:include href="/shared/includes/cropText.xsl"/>
    <xsl:include href="/shared/includes/formatDate.xsl"/>
    <xsl:include href="/shared/includes/replaceSubstring.xsl"/>
    <xsl:include href="/shared/includes/navigationMenu.xsl"/>
    <xsl:param name="showDate" select="'true'"/>
    <xsl:param as="xs:integer" name="prefaceLength" select="1000"/>
    <xsl:param name="showImage" select="'true'"/>
    <xsl:param name="showReadMoreText" select="'true'"/>
    <xsl:param name="showNavigationMenu" select="'true'"/>
    <xsl:param as="xs:integer" name="contentsPerPage" select="10"/>
    <xsl:param as="xs:integer" name="pagesInNavigation" select="10"/>
    <xsl:param as="xs:integer" name="imageMaxWidth" select="625"/>
    <xsl:variable name="language" select="/result/context/@languagecode"/>
    <xsl:variable as="xs:integer" name="totalCount" select="/result/contents/@totalcount"/>
    <xsl:variable as="xs:integer" name="contentCount" select="count(/result/contents/content)"/>
    <xsl:variable name="indexTemp" select="/result/context/querystring/parameter[@name='index']"/>
    <xsl:variable name="index">
        <xsl:choose>
            <xsl:when test="$indexTemp != '' and string(number($indexTemp)) != 'NaN'">
                <xsl:value-of select="number($indexTemp)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/"> 
        <link rel="stylesheet" media="screen" type="text/css" href="{portal:createResourceUrl('/_public/site/Stjernen/styles/ImageOverlay.css')}" />
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/site/Stjernen/scripts/jquery.metadata.js')}"></script>
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/site/Stjernen/scripts/jquery.ImageOverlay.min.js')}"></script>
        
        <script type="text/javascript">
            $(document).ready(function() {
            
            $('.PlayerItem').click(function() {
            var mainImage = $('.fpMainImg');            
            var rollImage = $(this).find('.fpHiddenImg');
            mainImage.attr('src', rollImage.attr('src'));
            $('#fpMainA').attr('href',($(this).find('a').attr('href')));
            $('#fpMainA').trigger('mouseover');      
            return false;
            }
            );
            
                $("#fpUl").ImageOverlay({image_width: "625px", image_height:"341px",always_show_overlay:true});
            });
        </script>
        
        <xsl:choose>
            <xsl:when test="/result/contents/@totalcount = 0">
                <p>
                    <xsl:value-of select="$translations/no_items[1]"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <div class="" style="padding:0px;margin:0px;"> 
                    <xsl:apply-templates select="/result/contents/content[1]" mode="spiller"/>
                    <div id="bilderad" >
                        <ul >
                            <xsl:apply-templates select="/result/contents/content/contentdata/bilder/content" mode="linkline"/>
                        </ul>
                    </div>     
                    
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="content" mode="spiller" >
            <div class="fpitem" id="fpitem" style="height:341px;width:625px;">
                <ul class="image-overlay" id="fpUl" style="padding:0px;margin:0px;">
                    <li style="padding:0px; margin:0px;">
                        <xsl:apply-templates select="contentdata/bilder/content[1]" mode="topimage"/>           
                    </li>
                </ul>
            </div>
    </xsl:template>
    
    
    <xsl:template match="content" mode="topimage">
        <xsl:variable name="url" select="portal:createContentUrl(@key, ())"/>
        <a href="{$url}" id="fpMainA" style="padding:0px;margin:0px;">
            <xsl:if test="position() = 1">
                <xsl:attribute name="class">item first</xsl:attribute>
            </xsl:if>          
            <xsl:if test="/result/contents/relatedcontents/content[@key = current()/@key]">
                
                <xsl:call-template name="display-image">                 
                    <xsl:with-param name="image" select="."/>
                    <xsl:with-param name="filter" select="'scalewidth(625)'"/>
                    <xsl:with-param name="class" select="'fpMainImg'"/>
                    <xsl:with-param name="region-width" select="0"/>
                    
                </xsl:call-template>
                
            </xsl:if>
            <div class="caption" style="height:100px;">                
                <xsl:call-template name="navnognummer"/>                
            </div>
            
        </a>    
    </xsl:template>    
    

    <xsl:template name="navnognummer">
        <div id="spillerbildebyline">
            
        <xsl:value-of select="/result/contents/content[1]/contentdata/draktnummer"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="/result/contents/content[1]/contentdata/fulltnavn"/>                    
        </div>
    </xsl:template>
    
    
    <xsl:template match="content" mode="linkline">
        <xsl:variable name="url" select="portal:createContentUrl(@key, ())"/>    
        <li class="PlayerItem" >
            
            <xsl:call-template name="display-image">                 
                <xsl:with-param name="image" select="."/>
                <xsl:with-param name="filter" select="'scalewidth(625)'"/>
                <xsl:with-param name="class" select="'fpHiddenImg'"/>
                <xsl:with-param name="region-width" select="0"/>
            </xsl:call-template>


            
            <a href="{$url}">
                <xsl:call-template name="display-image">                 
                    <xsl:with-param name="image" select="."/>
                    <xsl:with-param name="filter" select="'scaleheight(130)'"/>
                    <xsl:with-param name="class" select="''"/>
                    <xsl:with-param name="region-width" select="0"/>
                </xsl:call-template>
            </a>
        </li>    
    </xsl:template>    
    
</xsl:stylesheet>
  