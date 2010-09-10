<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="cropText">
        <xsl:param name="sourceText"/>
        <xsl:param name="numCharacters"/>
        <xsl:choose>
            <xsl:when test="string-length($sourceText) &lt;= $numCharacters">
                <xsl:value-of select="$sourceText"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="findSpace">
                    <xsl:with-param name="src" select="substring($sourceText, 1, $numCharacters - 3)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="findSpace">
        <xsl:param name="src"/>
        <xsl:choose>
            <xsl:when test="substring($src, string-length($src), 1) = ' ' or string-length($src) = 0">
                <xsl:value-of select="concat(substring($src, 1, string-length($src) - 1), '...')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="findSpace">
                    <xsl:with-param name="src" select="substring($src, 1, string-length($src) - 1)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>