<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:template name="replaceSubstring">
        <xsl:param name="inputString"/>
        <xsl:param name="inputSubstring">
            <xsl:text>
</xsl:text>
        </xsl:param>
        <xsl:param name="outputSubstring" select="'&lt;br />'"/>
        <xsl:choose>
            <xsl:when test="contains($inputString, $inputSubstring)">
                <xsl:value-of disable-output-escaping="yes" select="concat(substring-before($inputString, $inputSubstring), $outputSubstring)"/>
                <xsl:call-template name="replaceSubstring">
                    <xsl:with-param name="inputString" select="substring-after($inputString, $inputSubstring)"/>
                    <xsl:with-param name="inputSubstring" select="$inputSubstring"/>
                    <xsl:with-param name="outputSubstring" select="$outputSubstring"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="$inputString"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>