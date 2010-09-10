<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="portal xs" xmlns="http://www.w3.org/1999/xhtml" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:variable name="filter-delimiter" select="';'"/>

    <xsl:template name="process-html-area">
        <xsl:param name="region-width" tunnel="yes" as="xs:integer"/>
        <xsl:param name="filter" tunnel="yes" as="xs:string?"/>
        <xsl:param name="imagesize" tunnel="yes" as="element()*"/>
        <xsl:param name="document" as="element()"/>
        <xsl:apply-templates select="$document/*|$document/text()" mode="process-html-area"/>
    </xsl:template>

    <xsl:template match="element()" mode="process-html-area">
        <xsl:param name="region-width" tunnel="yes" as="xs:integer"/>
        <xsl:param name="filter" tunnel="yes" as="xs:string?"/>
        <xsl:param name="imagesize" tunnel="yes" as="element()*"/>
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="*|text()|@*" mode="process-html-area"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text()|@*" mode="process-html-area">
        <xsl:copy/>
    </xsl:template>
        
    <!-- Replaces @target=_blank with @rel=external -->
    <xsl:template match="@target" mode="process-html-area">
        <xsl:if test=". = '_blank'">
            <xsl:attribute name="rel">external</xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <!-- Replaces td, th @align with @style -->
    <xsl:template match="td/@align|th/@align" mode="process-html-area">
        <xsl:attribute name="style">
            <xsl:value-of select="concat('text-align: ', .)"/>
        </xsl:attribute>
    </xsl:template>

    <!-- Replaces @align with @style -->
    <xsl:template match="@align" mode="process-html-area">
        <xsl:attribute name="style">
            <xsl:value-of select="concat('float: ', .)"/>
        </xsl:attribute>
    </xsl:template>
    
    <!-- Replaces @valign with @style -->
    <xsl:template match="@valign" mode="process-html-area">
        <xsl:attribute name="style">
            <xsl:value-of select="concat('vertical-align: ', .)"/>
        </xsl:attribute>
    </xsl:template>

    <!-- Matches img/@src, a/@href, object/@data and param/@src, sorts out native urls -->
    <xsl:template match="@src[parent::img]|@href[parent::a]|@data[parent::object]|@src[parent::param]" mode="process-html-area">
        <xsl:param name="region-width" tunnel="yes" as="xs:integer"/>
        <xsl:param name="filter" tunnel="yes" as="xs:string?"/>
        <xsl:param name="imagesize" tunnel="yes" as="element()*"/>
        <xsl:variable name="url-part" select="tokenize(., '://|\?|&amp;')"/>
        <xsl:variable name="url-type" select="$url-part[1]"/>
        <xsl:variable name="url-key" select="$url-part[2]"/>
        <xsl:variable name="url-parameter" select="$url-part[position() &gt; 2]"/>
        <xsl:variable name="_size" select="substring-after($url-parameter[contains(., '_size=')], '=')"/>
        <xsl:variable name="_filter" select="substring-after($url-parameter[contains(., '_filter=')], '=')"/>
        <xsl:variable name="_background" select="substring-after($url-parameter[contains(., '_background=')], '=')"/>
        <xsl:variable name="_format" select="substring-after($url-parameter[contains(., '_format=')], '=')"/>
        <xsl:variable name="_quality" select="substring-after($url-parameter[contains(., '_quality=')], '=')"/>
        <xsl:variable name="selected-imagesize" select="$imagesize[@name = $_size]"/>
        <xsl:variable name="final-filter">
            <xsl:choose>
                <!-- If custom image size definitions exists -->
                <xsl:when test="$selected-imagesize">
                    <xsl:value-of select="concat($selected-imagesize/filter, '(', floor($region-width * $selected-imagesize/width))"/>
                    <xsl:if test="$selected-imagesize/height != ''">
                        <xsl:value-of select="concat(',', floor($region-width * $selected-imagesize/height))"/>
                    </xsl:if>
                    <xsl:text>);</xsl:text>
                </xsl:when>
                <!-- If no custom image size definitions exists default sizes are used -->
                <xsl:when test="$_size = 'full'">
                    <xsl:value-of select="concat('scalewidth(', $region-width * 1, ');')"/>
                </xsl:when>
                <xsl:when test="$_size = 'wide'">
                    <xsl:value-of select="concat('scalewide(', $region-width * 1, ',', $region-width * 0.4, ');')"/>
                </xsl:when>
                <xsl:when test="$_size = 'regular'">
                    <xsl:value-of select="concat('scalewidth(', $region-width * 0.4, ');')"/>
                </xsl:when>
                <xsl:when test="$_size = 'list'">
                    <xsl:value-of select="concat('scalewidth(', $region-width * 0.3, ');')"/>
                </xsl:when>
                <xsl:when test="$_size = 'square'">
                    <xsl:value-of select="concat('scalesquare(', $region-width * 0.4, ');')"/>
                </xsl:when>
                <xsl:when test="$_size = 'thumbnail'">
                    <xsl:value-of select="concat('scalesquare(', $region-width * 0.1,');')"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="$_filter != ''">
                <xsl:value-of select="concat($_filter, ';')"/>
            </xsl:if>
            <xsl:if test="$filter != ''">
                <xsl:value-of select="$filter"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="url-parameters" as="xs:anyAtomicType*">
            <xsl:for-each select="$url-parameter">
                <xsl:sequence select="substring-after(tokenize(., '=')[1], '_'), tokenize(., '=')[2]"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:attribute name="{name()}">
            <xsl:choose>
                <xsl:when test="$url-type = 'image'">
                    <xsl:value-of select="portal:createImageUrl($url-key, $final-filter, $_background, $_format, $_quality)"/>
                </xsl:when>
                <xsl:when test="$url-type = 'attachment'">
                    <xsl:value-of select="portal:createAttachmentUrl($url-key, $url-parameters)"/>
                </xsl:when>
                <xsl:when test="$url-type = 'page'">
                    <xsl:value-of select="portal:createPageUrl($url-key, $url-parameters)"/>
                </xsl:when>
                <xsl:when test="$url-type = 'content'">
                    <xsl:value-of select="portal:createContentUrl($url-key, $url-parameters)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

</xsl:stylesheet>
