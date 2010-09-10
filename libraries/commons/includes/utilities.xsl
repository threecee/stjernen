<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="util portal xs" version="2.0" 
    xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:util="enonic:utilities" 
    xmlns:portal="http://www.enonic.com/cms/xslt/portal" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <!-- Returns scoped parameter from config as element()?  -->
    <xsl:function name="util:get-scoped-parameter" as="element()?">
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:param name="parameter" as="element()*"/>
        <xsl:call-template name="get-parameter">
            <xsl:with-param name="name" select="$name" tunnel="yes"/>
            <xsl:with-param name="path" select="$path"/>
            <xsl:with-param name="parameter" select="$parameter" tunnel="yes"/>
        </xsl:call-template>
    </xsl:function>

    <xsl:template name="get-parameter">
        <xsl:param name="name" tunnel="yes" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:param name="parameter" tunnel="yes" as="element()*"/>
        <xsl:choose>
            <xsl:when test="$parameter[@name = $name and @path = $path]">
                <xsl:sequence select="$parameter[@name = $name and @path = $path][1]"/>
            </xsl:when>
            <xsl:when test="$path != ''">
                <xsl:call-template name="get-parameter">
                    <xsl:with-param name="path" select="substring-before($path, concat('/', tokenize($path, '/')[last()]))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$parameter[@name = $name]">
                <xsl:sequence select="$parameter[@name = $name][1]"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Displays image -->
    <xsl:template name="display-image">
        <xsl:param name="region-width" as="xs:integer"/>
        <xsl:param name="filter" as="xs:string?"/>
        <xsl:param name="imagesize" as="element()*"/>
        <xsl:param name="image" as="element()"/>
        <xsl:param name="size" as="xs:string?"/>
        <xsl:param name="background" as="xs:string?"/>
        <xsl:param name="format" as="xs:string?"/>
        <xsl:param name="quality" as="xs:string?"/>
        <xsl:param name="title" select="$image/title" as="xs:string?"/>
        <xsl:param name="alt" select="$image/contentdata/description" as="xs:string?"/>
        <xsl:param name="class" as="xs:string?"/>
        <xsl:param name="style" as="xs:string?"/>
        <xsl:param name="id" as="xs:string?"/>
        <xsl:variable name="selected-imagesize" select="$imagesize[@name = $size]"/>
        <xsl:variable name="final-filter">
            <xsl:choose>
                <xsl:when test="$filter != ''">
                        <xsl:value-of select="$filter"/>
                </xsl:when>
                <xsl:otherwise>
                    
            
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
                <xsl:when test="$size = 'full'">
                    <xsl:value-of select="concat('scalewidth(', $region-width * 1, ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'wide'">
                    <xsl:value-of select="concat('scalewide(', $region-width * 1, ',', $region-width * 0.4, ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'regular'">
                    <xsl:value-of select="concat('scalewidth(', $region-width * 0.4, ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'list'">
                    <xsl:value-of select="concat('scalewidth(', $region-width * 0.3, ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'square'">
                    <xsl:value-of select="concat('scalesquare(', $region-width * 0.4, ');')"/>
                </xsl:when>
                <xsl:when test="$size = 'thumbnail'">
                    <xsl:value-of select="concat('scalesquare(', $region-width * 0.1,');')"/>
                </xsl:when>
            </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:variable>
        <xsl:if test="$image">
            <img src="{portal:createImageUrl($image/@key, $final-filter, $background, $format, $quality)}" title="{$title}" alt="{if ($alt != '') then $alt else $title}">
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
                <xsl:if test="$id != ''">
                    <xsl:attribute name="id">
                        <xsl:value-of select="$id"/>
                    </xsl:attribute>
                </xsl:if>
            </img>
        </xsl:if>
    </xsl:template>

    <!--
        Formats time
        
        Possible formats for the 'time' parameter:
        'hh:mm'
        'hh:mm:ss'
    -->
    <xsl:template name="format-time">
        <xsl:param name="time" as="xs:string"/>
        <xsl:param name="language" as="xs:string?"/>
        <xsl:variable name="time-final">
            <xsl:value-of select="$time"/>
            <xsl:if test="count(tokenize($time, ':')) &lt; 3">:00</xsl:if>
            <xsl:text>Z</xsl:text>
        </xsl:variable>
        <xsl:variable name="format-string">
            <xsl:choose>
                <!-- Norwegian -->
                <xsl:when test="$language = 'no'">[H01].[m01]</xsl:when>
                <!-- English is default -->
                <xsl:otherwise>[h]:[m01] [Pn]</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!-- Supplied time is erroneous format -->
            <xsl:when test="not($time-final castable as xs:time)">Erroneous time format</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-time(xs:time($time-final), $format-string, $language, (), ())"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        Formats date
        
        Possible formats for the 'date' parameter:
            'yyyy-mm-dd hh:mm'
            'yyyy-mm-dd'
        Possible values for the 'format' parameter:
            'long' (default)
            'short'
        possible values for the 'include-time' parameter:
            true()
            false() (default)
    -->
    <xsl:template name="format-date">
        <xsl:param name="date" as="xs:string"/>
        <xsl:param name="format" as="xs:string?"/>
        <xsl:param name="include-time" as="xs:boolean" select="false()"/>
        <xsl:param name="language"/>
        <xsl:variable name="format-string">
            <xsl:choose>
                <!-- Norwegian -->
                <xsl:when test="$language = 'no'">
                    <xsl:choose>
                        <!-- Short date format -->
                        <xsl:when test="$format = 'short'">[D01].[M01].[Y0001]</xsl:when>
                        <!-- Long date format -->
                        <xsl:otherwise>[D1]. [MNn] [Y0001]</xsl:otherwise>
                    </xsl:choose>
                    <!-- Include time? -->
                    <xsl:if test="$include-time and concat(tokenize($date, '\s+')[2], ':00Z') castable as xs:time"> [H01].[m01]</xsl:if>
                </xsl:when>
                <!-- English is default -->
                <xsl:otherwise>
                    <xsl:choose>
                        <!-- Short date format -->
                        <xsl:when test="$format = 'short'">[M]/[D]/[Y0001]</xsl:when>
                        <!-- Long date format -->
                        <xsl:otherwise>[MNn] [D], [Y0001]</xsl:otherwise>
                    </xsl:choose>
                    <!-- Include time? -->
                    <xsl:if test="$include-time and concat(tokenize($date, '\s+')[2], ':00Z') castable as xs:time"> [h]:[m01] [Pn]</xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!-- Supplied date is erroneous format -->
            <xsl:when test="not(tokenize($date, '\s+')[1] castable as xs:date)">Erroneous date format</xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- Time included -->
                    <xsl:when test="$include-time and concat(tokenize($date, '\s+')[2], ':00Z') castable as xs:time">
                        <xsl:value-of select="format-dateTime(dateTime(xs:date(tokenize($date, '\s+')[1]), xs:time(concat(tokenize($date, '\s+')[2], ':00Z'))), $format-string, $language, (), ())"/>
                    </xsl:when>
                    <!-- No time -->
                    <xsl:otherwise>
                        <xsl:value-of select="format-date(xs:date(tokenize($date, '\s+')[1]), $format-string, $language, (), ())"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Displays menu item name -->
    <xsl:function name="util:menuitem-name" as="xs:string">
        <xsl:param name="menuitem" as="element()?"/>
        <xsl:value-of select="if ($menuitem/display-name != '') then $menuitem/display-name else if ($menuitem/alternative-name != '') then $menuitem/alternative-name else $menuitem/name"/>
    </xsl:function>

    <!-- Formats bytes -->
    <xsl:function name="util:format-bytes" as="xs:string">
        <xsl:param name="bytes" as="xs:integer"/>
        <xsl:value-of select="if ($bytes > 1073741824) then concat(format-number($bytes div 1073741824, '0.#'), ' GB') else if ($bytes > 1048576) then concat(format-number($bytes div 1048576, '0.#'), ' MB') else if ($bytes > 1024) then concat(format-number($bytes div 1024, '0'), ' KB') else concat($bytes, ' B')"/>
    </xsl:function>

    <!-- Displays icon image -->
    <xsl:template name="icon-image">
        <xsl:param name="file-name" as="xs:string"/>
        <xsl:param name="icon-folder-path" select="'/_public/libraries/commons/images'" as="xs:string"/>
        <xsl:param name="icon-image-prefix" select="'icon-'" as="xs:string"/>
        <xsl:param name="icon-image-file-extension" select="'png'" as="xs:string"/>
        <xsl:param name="icon-class" select="'icon text'" as="xs:string?"/>
        <xsl:variable name="file-extension" select="lower-case(tokenize($file-name, '\.')[last()])"/>
        <xsl:variable name="image-url">
            <xsl:value-of select="$icon-folder-path"/>
            <xsl:if test="not(ends-with($icon-folder-path, '/'))">/</xsl:if>
            <xsl:value-of select="$icon-image-prefix"/>
            <xsl:choose>
                <xsl:when test="contains('htm', $file-extension)">
                    <xsl:text>htm</xsl:text>
                </xsl:when>
                <xsl:when test="contains('ppt|pps', $file-extension)">
                    <xsl:text>ppt</xsl:text>
                </xsl:when>
                <xsl:when test="contains('gif|jpg|tif|psd', $file-extension)">
                    <xsl:text>img</xsl:text>
                </xsl:when>
                <xsl:when test="contains('doc|dot', $file-extension)">
                    <xsl:text>doc</xsl:text>
                </xsl:when>
                <xsl:when test="contains('pdf', $file-extension)">
                    <xsl:text>pdf</xsl:text>
                </xsl:when>
                <xsl:when test="contains('avi|mpg|wmv', $file-extension)">
                    <xsl:text>vid</xsl:text>
                </xsl:when>
                <xsl:when test="contains('xls|xlt|csv', $file-extension)">
                    <xsl:text>xls</xsl:text>
                </xsl:when>
                <xsl:when test="contains('xml', $file-extension)">
                    <xsl:text>xml</xsl:text>
                </xsl:when>
                <xsl:when test="contains('txt|dat|text', $file-extension)">
                    <xsl:text>txt</xsl:text>
                </xsl:when>
                <xsl:when test="contains('zip|tar|gz|qz|arj', $file-extension)">
                    <xsl:text>zip</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>file</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="not(starts-with($icon-image-file-extension, '.'))">.</xsl:if>
            <xsl:value-of select="$icon-image-file-extension"/>
        </xsl:variable>
        <img src="{portal:createResourceUrl($image-url)}" alt="{concat(util:file-type($file-name), ' ', portal:localize('icon'))}">
            <xsl:if test="$icon-class != ''">
                <xsl:attribute name="class">
                    <xsl:value-of select="$icon-class"/>
                </xsl:attribute>
            </xsl:if>
        </img>
    </xsl:template>

    <!-- Displays file type -->
    <xsl:function name="util:file-type" as="xs:string">
        <xsl:param name="file-name" as="xs:string"/>
        <xsl:variable name="file-extension" select="lower-case(tokenize($file-name, '\.')[last()])"/>
        <xsl:choose>
            <xsl:when test="contains('htm', $file-extension)">
                <xsl:value-of select="portal:localize('HTML')"/>
            </xsl:when>
            <xsl:when test="contains('ppt|pps', $file-extension)">
                <xsl:value-of select="portal:localize('Powerpoint')"/>
            </xsl:when>
            <xsl:when test="contains('gif|jpg|tif|psd', $file-extension)">
                <xsl:value-of select="portal:localize('Image')"/>
            </xsl:when>
            <xsl:when test="contains('doc|dot', $file-extension)">
                <xsl:value-of select="portal:localize('Document')"/>
            </xsl:when>
            <xsl:when test="contains('pdf', $file-extension)">
                <xsl:value-of select="portal:localize('PDF')"/>
            </xsl:when>
            <xsl:when test="contains('avi|mpg|wmv', $file-extension)">
                <xsl:value-of select="portal:localize('Video')"/>
            </xsl:when>
            <xsl:when test="contains('xls|xlt|csv', $file-extension)">
                <xsl:value-of select="portal:localize('Excel')"/>
            </xsl:when>
            <xsl:when test="contains('xml', $file-extension)">
                <xsl:value-of select="portal:localize('XML')"/>
            </xsl:when>
            <xsl:when test="contains('txt|dat|text', $file-extension)">
                <xsl:value-of select="portal:localize('Text')"/>
            </xsl:when>
            <xsl:when test="contains('zip|tar|gz|qz|arj', $file-extension)">
                <xsl:value-of select="portal:localize('ZIP')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="portal:localize('File')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Crops text -->
    <xsl:function name="util:crop-text" as="xs:string">
        <xsl:param name="source-text" as="xs:string"/>
        <xsl:param name="num-characters" as="xs:integer"/>
        <xsl:value-of disable-output-escaping="yes" select="concat(string-join(tokenize(substring($source-text, 1, $num-characters - 3), ' ')[position() != last()], ' '), '...')"/>
    </xsl:function>

</xsl:stylesheet>
