<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:include href="/shared/includes/replaceSubstring.xsl"/>

<xsl:template match="/">

    <link type="text/css" href="{portal:createResourceUrl('/_public/site/Stjernen/styles/jquery-ui-1.7.2.custom.css')}" rel="stylesheet" />

    <script src="{portal:createResourceUrl('/_public/site/Stjernen/scripts/jquery-ui-1.7.2.custom.min.js')}" type="text/javascript">
        <xsl:comment>//</xsl:comment>
    </script>

    <script type="text/javascript">

        $(document).ready(function(){
        $("#accordion").accordion({ icons: { 'header': 'ui-icon-circle-triangle-e', 'headerSelected': 'ui-icon-circle-triangle-s' } });
        $("#accordion").show();
        });

    </script>

    <div id="accordion" class="ui-accordion" >
        <xsl:apply-templates select="/result/contents/content/contentdata/information/element"></xsl:apply-templates>
    </div>


</xsl:template>

<xsl:template match="element">
    <a class="ui-accordion-header" href="#" style="display:block; width:100%;"><span style="padding-left:30px;"><xsl:value-of select="overskrift"/></span></a>
    <div class="ui-accordion-content">
        <xsl:copy-of select="tekst/node()" />
    </div>

</xsl:template>

    <xsl:template match="tekst">
        <xsl:apply-templates select="*|text()"/>
    </xsl:template>
</xsl:stylesheet>
