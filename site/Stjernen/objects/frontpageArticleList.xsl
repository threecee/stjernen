<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:include href="/site/Stjernen/includes/languageArticle.xsl"/>
  <!--xsl:include href="/shared/includes/displayImageHover.xsl"/-->
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
  <xsl:param as="xs:integer" name="imageMaxWidth" select="100"/>
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

<div class="bannerbox frontpagenews">
  
  <script type="text/javascript">
    $(document).ready(function() {
    
    $('.rollImg').each(function()
    {
      imageObj = new Image();
      imageObj.src = $(this).attr('src');
    });
    
    $('.rollover').hover(function() {
    
    var rollImage = $(this).find('.rollImg');
       var currentImg = rollImage.attr('src');
       rollImage.attr('src', rollImage.attr('hover'));
       rollImage.attr('hover', currentImg);
      }, 
      function() 
      {
      var rollImage = $(this).find('.rollImg');
      var currentImg = rollImage.attr('src');
      rollImage.attr('src', rollImage.attr('hover'));
      rollImage.attr('hover', currentImg);
      }
      );
    });
  </script>
  
  <h2>Nyheter</h2>

  <xsl:choose>
      <xsl:when test="/result/contents/@totalcount = 0">
        <p>
          <xsl:value-of select="$translations/no_items[1]"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        
        <xsl:apply-templates select="/result/contents/content"/>
      </xsl:otherwise>
    </xsl:choose>
</div>   
   
  </xsl:template>
  <xsl:template match="content">
    <xsl:variable name="url" select="portal:createContentUrl(@key, ())"/>
    <a href="{$url}" class="rollover">
        <div class="item">
      <xsl:if test="position() = 1">
        <xsl:attribute name="class">item first</xsl:attribute>
      </xsl:if>
        <xsl:apply-templates select="current()" mode="inner"/>
    </div>
        </a>
  </xsl:template>
  
  
  <xsl:template match="content" mode="inner">
    <xsl:if test="/result/contents/relatedcontents/content[@key = current()/contentdata/artikkel/bilder/bilde/binary/content[1]/@key] and $showImage != 'false'">
<div class="imageItem"> 
      <!--xsl:call-template name="displayImageHover">
        <xsl:with-param name="key" select="contentdata/artikkel/bilder/bilde[1]/binary/content/@key"/>
        <xsl:with-param name="imageMaxWidth" select="$imageMaxWidth"/>
        <xsl:with-param name="filters" select="'grayscale;hsbadjust(0.0, 0.0, 0.2)'"/>
        <xsl:with-param name="hoverFilters" select="''"/>
        <xsl:with-param name="hoverImage" select="true"/>
        <xsl:with-param name="class" select="'rollImg'"/>
      </xsl:call-template-->
  <xsl:variable name="image" select="contentdata/artikkel/bilder/bilde/binary/content[1]"/>
  <xsl:variable name="hoverFilter" select="'scalewidth($imageMaxWidth)'"/>
  <xsl:variable name="filter" select="'grayscale;hsbadjust(0.0, 0.0, 0.2);scalewidth($imageMaxWidth)'"/>
  <xsl:variable name="alt" select="$image/contentdata/description"/>
  <xsl:variable name="title" select="$image/title"/>
  
  <img src="{portal:createImageUrl($image/@key, $filter)}" title="{$title}" alt="{if ($alt != '') then $alt else $title}">
      <xsl:attribute name="class">
        <xsl:value-of select="'rollImg'"/>
      </xsl:attribute>
    <xsl:attribute name="hover">
      <xsl:value-of select="portal:createImageUrl($image/@key, $hoverFilter,'','','')"/> 
    </xsl:attribute>                                
  </img>
  
  

</div>
    </xsl:if>
<div class="descriptionItem">
  
    <h3>
        <xsl:choose>
          <xsl:when test="contentdata/stikktittel != ''">
            <xsl:value-of select="contentdata/stikktittel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="contentdata/tittel"/>
          </xsl:otherwise>
        </xsl:choose>
    </h3>
    <xsl:if test="string-length(contentdata/artikkel/kortingress) > 0 or string-length(contentdata/artikkel/langingress) > 0">
      <xsl:variable name="preface">
        <xsl:call-template name="cropText">
          <xsl:with-param name="sourceText">
            <xsl:choose>
              <xsl:when test="contentdata/artikkel/kortingress != ''">
                <xsl:value-of disable-output-escaping="yes" select="contentdata/artikkel/kortingress"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="contentdata/artikkel/langingress"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="numCharacters" select="$prefaceLength"/>
        </xsl:call-template>
      </xsl:variable>
      <p>
        <xsl:if test="$showDate != 'false'">
          <span class="byline">
            <xsl:if test="$showDate != 'false'">
              <xsl:call-template name="formatDate">
                <xsl:with-param name="date" select="@publishfrom"/>
                <xsl:with-param name="format" select="'short'"/>
              </xsl:call-template>
            </xsl:if>
          </span>
        </xsl:if>
        <xsl:call-template name="replaceSubstring">
          <xsl:with-param name="inputString" select="$preface"/>
        </xsl:call-template>
      </p>
    </xsl:if>
    <xsl:if test="$showReadMoreText != 'false'">
      <p>
        <span class="read-more">
          
            <xsl:choose>
              <xsl:when test="contentdata/teaser/read_more != ''">
                <xsl:value-of select="concat('» ',contentdata/teaser/read_more)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('» ',$translations/read_more)"/>
              </xsl:otherwise>
            </xsl:choose>
          
        </span>
      </p>
    </xsl:if>
</div>

    
  </xsl:template>
</xsl:stylesheet>