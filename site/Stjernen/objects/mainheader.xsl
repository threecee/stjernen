<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs" version="2.0" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:include href="/shared/includes/displayImage.xsl"/>
    <xsl:param as="xs:integer" name="imageMaxWidth" select="990"/>
    <xsl:variable name="currentImage" select="/result/contents/relatedcontents/content[@key = /result/contents/content/contentdata/bilde/content/@key]"/>
    <xsl:variable name="url" select="/result/contents/content/contentdata/url"/>
    <xsl:template match="/">
        <xsl:if test="$currentImage != ''">
<xsl:choose>
    <xsl:when test="$url != ''">
        <a>
            <xsl:attribute name="href"><xsl:value-of select="$url" /></xsl:attribute>
            <xsl:call-template name="image"/>
        </a>
        
    </xsl:when>
    <xsl:otherwise>
        <xsl:call-template name="image"/>
    </xsl:otherwise>
</xsl:choose>
            
            
 
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="image">
        <div class="image">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('width: ', $imageMaxWidth, 'px')"/>
            </xsl:attribute>
            <xsl:call-template name="displayImage">
                <xsl:with-param name="image" select="$currentImage"/>
                <xsl:with-param name="imageMaxWidth" select="$imageMaxWidth"/>
            </xsl:call-template>
            <xsl:if test="text != ''">
                <div class="text"><xsl:value-of select="text"/></div>
            </xsl:if>
        </div>   
        
        
    </xsl:template>
    
</xsl:stylesheet>