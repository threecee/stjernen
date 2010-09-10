<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet exclude-result-prefixes="saxon xs" version="2.0" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>

    <xsl:param name="text">Starclub</xsl:param>

    <xsl:param name="rader" as="xs:integer">2</xsl:param>
    <xsl:param name="maxWidth" as="xs:integer">300</xsl:param>
    
    <xsl:include href="/shared/includes/displayImage.xsl"/>

    <xsl:include href="/site/Stjernen/includes/globalVars.xsl"/>

    

    

    <!-- 

    Hvis det er under 8 bilder, vis alle på en rad. 

    Hvis det er over 8 bilder, del i 2.

    

    -->

     

        <xsl:variable name="boxWidth" select="$fullContentWidth"/>

        <xsl:variable name="imagecount" select="count(/result/contents/content)"/>

        <xsl:variable name="imageBreakLowerLimit" select="0"/>

        

        <xsl:variable name="breakatposition" as="xs:integer">
                    <xsl:value-of select="$imagecount idiv $rader"></xsl:value-of>
</xsl:variable>            

    <xsl:variable name="imageMaxWidth" as="xs:integer">
        <xsl:choose>
            <xsl:when test="($fullContentWidth idiv $breakatposition)&gt;$maxWidth">
                <xsl:value-of select="$maxWidth"></xsl:value-of>
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="($fullContentWidth idiv $breakatposition)"></xsl:value-of>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:variable>            
    
        

    <xsl:template match="/">
        <div class="bannerbox" id="starclub" style="float:left; width:100%">
                <h2>
                    <xsl:value-of select="$text"/>
                </h2>

            <div style="minheight:60px;    " >
                <ul style="clear:both; padding:5px; list-decoration:none; margin-left: auto;  margin-right: auto;">
                        <xsl:apply-templates
                            select="/result/contents/content[position() = (1 to $breakatposition)]"
                            mode="img"/>
                    </ul>

                    <xsl:if test="$breakatposition &lt; $imagecount">
                        <ul style="clear:both; padding:5px; list-decoration:none;margin-left: auto;  margin-right: auto;">
                            <xsl:apply-templates
                                select="/result/contents/content[position() = (($breakatposition+1) to $imagecount)]"
                                mode="img"/>
                        </ul>
                    </xsl:if>
                </div>
            </div>
    </xsl:template>



<xsl:template match="content" mode="img">
    <xsl:variable name="currentImage" select="/result/contents/relatedcontents/content[@key = current()/contentdata/bilde/content/@key]"/>
    <xsl:variable name="url" select="contentdata/url"/>
    <li style="">
    <a style="">
        <xsl:attribute name="href"><xsl:value-of select="$url" /></xsl:attribute>
        <div class="image">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('width: ', $imageMaxWidth, 'px')"/>
            </xsl:attribute>
            
            <xsl:call-template name="displayImage">
                <xsl:with-param name="image" select="$currentImage"/>
                <xsl:with-param name="imageMaxWidth" select="$imageMaxWidth"/>
            </xsl:call-template>
        </div>
    </a>
</li>    
</xsl:template>





</xsl:stylesheet>