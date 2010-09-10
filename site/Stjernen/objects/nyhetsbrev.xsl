<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
	
	
	<xsl:variable name="pagetitle" select="/result/contents/content/contentdata/title"/>	
	<xsl:variable name="embed" select="/result/contents/content/contentdata/embed"/>
	
	<xsl:template match="/">

		<div class="bannerbox">			
			<h2><xsl:value-of select="$pagetitle"/></h2>
			<xsl:value-of select="$embed" disable-output-escaping="yes"/>
		</div>
		
	</xsl:template>
	
	
	
	
	
</xsl:stylesheet>