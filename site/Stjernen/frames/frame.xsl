<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:param name="header"/>
    <xsl:param name="box" select="'false'"/>
    <xsl:param name="content">
        <type>content</type>
    </xsl:param>
    <xsl:template match="/">
        <div class="frame">
            <h4>
                <xsl:value-of select="$header"/>
            </h4>
            <div>
                <xsl:if test="$box = 'true'">
                    <xsl:attribute name="class">box</xsl:attribute>
                </xsl:if>
                <xsl:value-of disable-output-escaping="yes" select="$content"/>
            </div>
       </div>
    </xsl:template>
</xsl:stylesheet>