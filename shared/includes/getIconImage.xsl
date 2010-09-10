<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="getIconImage">
        <xsl:param name="filename"/>
        <xsl:variable name="fileExtension">
            <xsl:text>.</xsl:text>
            <xsl:value-of select="substring-after(substring($filename,string-length($filename)-3), '.')"/>
        </xsl:variable>
        <xsl:variable name="extention" select="translate($fileExtension, 'ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ', 'abcdefghijklmnopqrstuvwxyzæøå')"/>
        <img class="icon text">
            <xsl:attribute name="src">
                <xsl:text>_public/shared/images/icon_</xsl:text>
                <xsl:choose>
                    <xsl:when test="contains('.htm', $extention)">
                        <xsl:text>htm</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.ppt|.pps', $extention)">
                        <xsl:text>ppt</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.gif|.jpg|.tif|.psd', $extention)">
                        <xsl:text>img</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.ai|.eps', $extention)">
                        <xsl:text>ai</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.doc|.dot', $extention)">
                        <xsl:text>doc</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.pdf', $extention)">
                        <xsl:text>pdf</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.avi|.mpg|.wmv', $extention)">
                        <xsl:text>vid</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.xls|.xlt|.csv', $extention)">
                        <xsl:text>xls</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.xml', $extention)">
                        <xsl:text>xml</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.txt|.dat|.text', $extention)">
                        <xsl:text>txt</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.zip|.tar|.gz|.qz|.arj', $extention)">
                        <xsl:text>zip</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>default</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>.gif</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:choose>
                    <xsl:when test="contains('.htm', $extention)">
                        <xsl:text>HTML</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.ppt|.pps', $extention)">
                        <xsl:text>Powerpoint</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.gif|.jpg|.tif|.psd', $extention)">
                        <xsl:text>Image</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.ai|.eps', $extention)">
                        <xsl:text>Vector image</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.doc|.dot', $extention)">
                        <xsl:text>Document</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.pdf', $extention)">
                        <xsl:text>PDF</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.avi|.mpg|.wmv', $extention)">
                        <xsl:text>Video</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.xls|.xlt|.csv', $extention)">
                        <xsl:text>Excel</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.xml', $extention)">
                        <xsl:text>XML</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.txt|.dat|.text', $extention)">
                        <xsl:text>Text</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains('.zip|.tar|.gz|.qz|.arj', $extention)">
                        <xsl:text>ZIP</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Default</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> icon</xsl:text>
            </xsl:attribute>
        </img>
    </xsl:template>
</xsl:stylesheet>