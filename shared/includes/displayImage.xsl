<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="displayImage">
        <xsl:param name="key" select="0"/>
        <xsl:param name="image" select="/result/contents/relatedcontents/content[@key = $key]"/>
        <xsl:param name="title" select="$image/title"/>
        <xsl:param name="alt" select="$image/contentdata/description"/>
        <xsl:param name="class"/>
        <xsl:param name="addHeightAttribute" select="'true'"/>
        <xsl:param name="addWidthAttribute" select="'true'"/>
        <xsl:param name="style"/>
        <xsl:param name="id" select="concat('image', $image/@key)"/>
        <xsl:param name="popupPage"/>
        <xsl:param name="imageMaxWidth" select="1600"/>
        <xsl:param name="hoverFilters"/>
        <xsl:param name="hoverImage" select="false"/>
        <xsl:param name="filters"/>
        <xsl:param name="imageMaxHeight" select="1200"/>
        <xsl:param name="imageMaxArea" select="$imageMaxWidth * $imageMaxHeight"/>
        <xsl:variable name="imagelist" select="$image/contentdata/images/image[number(height) &lt;= number($imageMaxHeight) and number(width) &lt;= number($imageMaxWidth) and number(width * height) &lt;= number($imageMaxArea)]"/>
        
        <xsl:for-each select="$imagelist">
            <xsl:sort data-type="number" order="ascending" select="width"/>
            <xsl:choose>
                <xsl:when test="position() = last()">
                    <xsl:variable name="imageKey" select="concat('1/binary/', binarydata/@key)"/>
                    <!--img  src="{portal:createImageUrl(, ($filters))}"-->
                    <img  src="{portal:createImageUrl($imageKey, $filters)}">
                            <xsl:if test="../@border = 'yes'">
                            <xsl:attribute name="class">
                                <xsl:text>border</xsl:text>
                            </xsl:attribute>
                            </xsl:if>
                        
                        <xsl:if test="$addHeightAttribute = 'true'">
                            <xsl:attribute name="height" select="height"/>                            
                        </xsl:if>
                        <xsl:if test="$addWidthAttribute = 'true'">
                            <xsl:attribute name="width" select="width"/>                            
                        </xsl:if>
                        
                        <xsl:attribute name="title">
                            <xsl:value-of select="$title"/>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            <xsl:choose>
                                <xsl:when test="$alt != ''">
                                    <xsl:value-of disable-output-escaping="yes" select="$alt"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:if test="$class != ''">
                            <xsl:attribute name="class">
                                <xsl:value-of select="$class"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$style != ''">
                            <xsl:attribute name="style">
                                <xsl:value-of select="$style"/>
                            </xsl:attribute>
                        </xsl:if>
                    </img>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>