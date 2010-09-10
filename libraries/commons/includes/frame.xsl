<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="portal xs" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:template name="frame">
        <xsl:param name="padding" as="xs:integer?"/>
        <xsl:param name="border" as="xs:integer?"/>
        <xsl:param name="content"/>
        <xsl:param name="frame-heading" as="xs:string?"/>
        <xsl:if test="$content/*">
            <div class="frame clear clearfix">
                <xsl:if test="$padding &gt; 0 or $border &gt; 0">
                    <xsl:attribute name="style">
                        <xsl:if test="$padding &gt; 0">
                            <xsl:value-of select="concat('padding: ', $padding, 'px;')"/>
                        </xsl:if>
                        <xsl:if test="$border &gt; 0">
                            <xsl:value-of select="concat('border-width: ', $border, 'px;')"/>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$frame-heading != ''">
                    <h3>
                        <xsl:value-of select="$frame-heading"/>
                    </h3>
                </xsl:if>
                <xsl:copy-of select="$content"/>
            </div>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
