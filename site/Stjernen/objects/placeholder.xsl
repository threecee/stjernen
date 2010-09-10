<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs" version="2.0" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:param name="text">TEXT</xsl:param>
    
    <xsl:template match="/">
        
            <div style="width:100%;">
                <div class="bannerbox">
                    <h2><xsl:value-of select="$text"></xsl:value-of></h2>
                    <div style="height:60px;">  <p/></div>
        </div>
                </div>
        
    </xsl:template>
</xsl:stylesheet>