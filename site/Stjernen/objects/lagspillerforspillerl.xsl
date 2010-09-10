<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:include href="/shared/includes/displayImage.xsl"/>
    <xsl:include href="/site/Stjernen/includes/globalVars.xsl"/>
    <xsl:param as="xs:integer" name="imageMaxWidth" select="180"/>

    <xsl:template match="/">
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
        <div id="SpillerforSpiller">
    <h2>Spiller for spiller</h2>
    
    <ul>
                <xsl:apply-templates select="/result/contents/content[@contenttype='Spiller']" mode="spiller"/>		
		</ul>
</div>

    </xsl:template>        


	<xsl:template match="content" mode="spiller">
	    <li>
		<a href="{portal:createContentUrl(@key,())}" class="rollover">
		    <xsl:variable name="image" select="/result/contents/relatedcontents/content[@key = current()/contentdata/bilder/content[1]/@key]"/>
		    <xsl:variable name="hoverFilter" select="'scalewidth($imageMaxWidth)'"/>
		    <xsl:variable name="filter" select="'grayscale;hsbadjust(0.0, 0.0, 0.2);scalewidth($imageMaxWidth)'"/>
		    <xsl:variable name="alt" select="$image/contentdata/description"/>
		    <xsl:variable name="title" select="$image/title"/>
		    <xsl:if test="$image/@key">
		      <div class="bilde">
		          
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
		    
		    
		<div class="navn">
		    <xsl:value-of select="contentdata/fulltnavn"/>		    
		</div>
		    <div class="posisjon">
		        <xsl:value-of select="contentdata/posisjon"></xsl:value-of>		        
		    </div>
		</a>
	</li>
	</xsl:template>

	
</xsl:stylesheet>
