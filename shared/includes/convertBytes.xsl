<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="convertBytes">
        <xsl:param name="bytes"/>
        <xsl:param name="GBformat" select="'0.#'"/>
        <xsl:param name="MBformat" select="'0.#'"/>
        <xsl:param name="KBformat" select="'0'"/>
        <xsl:choose>
            <xsl:when test="$bytes > 1073741824">
                <xsl:value-of select="format-number($bytes div 1073741824, $GBformat)"/>
                <xsl:text>GB</xsl:text>
            </xsl:when>
            <xsl:when test="$bytes > 1048576">
                <xsl:value-of select="format-number($bytes div 1048576, $MBformat)"/>
                <xsl:text>MB</xsl:text>
            </xsl:when>
            <xsl:when test="$bytes > 1024">
                <xsl:value-of select="format-number($bytes div 1024, $KBformat)"/>
                <xsl:text>KB</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$bytes"/>
                <xsl:text>B</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>