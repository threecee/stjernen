<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" 

    xmlns:portal="http://www.enonic.com/cms/xslt/portal" 
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
    <xsl:include href="/shared/includes/displayImage.xsl"/>
    <xsl:include href="/site/Stjernen/includes/globalVars.xsl"/>
    <xsl:include href="/shared/includes/formatDate.xsl"/>
    <xsl:param as="xs:integer" name="imageMaxWidth" select="306"/>

   
    <xsl:template match="/">
        <div class="bannerbox">
            <h2><xsl:value-of select="$spillerinformasjonTittel"></xsl:value-of></h2>
            <xsl:comment>spillerinformasjon</xsl:comment>
            <xsl:apply-templates select="/result/contents/content"/>
        </div>
    </xsl:template>
    
    <xsl:template match="content">

<ul class="spiller">
    <li>
        <div class="detalj">
            Navn:
        </div>
        <div class="verdi">
            <xsl:value-of select="contentdata/fulltnavn"></xsl:value-of>
        </div>        
    </li>
    <li>
        <div class="detalj">
            Født:
        </div>
        <div class="verdi">
            <xsl:value-of select="contentdata/birthdate"></xsl:value-of>
        </div>        
    </li>
    <li>
        <div class="detalj">
            Alder:
       </div>
       <div class="verdi">
 <xsl:variable name="alderIDager" select="(days-from-duration( current-dateTime() - dateTime(contentdata/birthdate, current-time())))" as="xs:integer"></xsl:variable>
            <xsl:value-of select="xs:integer($alderIDager div 365)"></xsl:value-of> år
        </div>        
    </li>
    <li>
        <div class="detalj">
            Nasjonalitet:
        </div>
        <div class="verdi">
            <xsl:value-of select="/result/contents/relatedcontents/content[@key = current()/contentdata/nasjonalitet/@key]/contentdata/nasjonalitet"></xsl:value-of>
        </div>        
       
    </li>
    <li>
        <div class="detalj">
           Moderklubb:
        </div>
        <div class="verdi">
           <xsl:value-of select="contentdata/moderklubb"></xsl:value-of>
       </div>        
    </li>
    <li>
       <div class="detalj">
            Posisjon:
       </div>
        <div class="verdi">
            <xsl:value-of select="contentdata/posisjon"></xsl:value-of>
        </div>        
    </li>
    <li>
        <div class="detalj">
            Fatning:
        </div>
       <div class="verdi">
            <xsl:value-of select="contentdata/fatning"></xsl:value-of>
        </div>        
    </li>
    <li>
        <div class="detalj">
            Høyde:
        </div>
        <div class="verdi">
            <xsl:value-of select="contentdata/hoyde"></xsl:value-of>
        </div>        
    </li>
    <li>
        <div class="detalj">
            Vekt:
        </div>
        <div class="verdi">
            <xsl:value-of select="contentdata/vekt"></xsl:value-of>
        </div>        
    </li>
    <li>
       <div class="detalj">
           Kontrakt:
        </div>
        <div class="verdi">
            <xsl:value-of select="contentdata/kontrakt"></xsl:value-of>
        </div>        
    </li>
    <li>
        <div class="detalj">
            Ant. sesonger:
        </div>
        <div class="verdi">
           <xsl:value-of select="contentdata/sesonger"></xsl:value-of>
        </div>        
    </li>
    
</ul>
        <div class="clearer bottomMargin"/>

<xsl:if test="contentdata/sponsor/@key">
    <xsl:variable name="psponsor" select="/result/contents/relatedcontents/content[@key = current()/contentdata/sponsor/@key]"></xsl:variable>
    <xsl:variable name="currentImage" select="/result/contents/relatedcontents/content[@key = $psponsor/contentdata/bilde/content/@key]"/>
    <xsl:variable name="url" select="$psponsor/contentdata/url"/>

    <div class="venstreannonsebox">
        <h2>Personlig sponsor:</h2>
        <a>
            <xsl:attribute name="href"><xsl:value-of select="$url" /></xsl:attribute>
            <div class="image">
                <xsl:attribute name="style">
                    <xsl:value-of select="concat('width: ', $imageMaxWidth, 'px')"/>
                </xsl:attribute>
                <xsl:call-template name="displayImage">
                    <xsl:with-param name="image" select="$currentImage"/>
                    <xsl:with-param name="imageMaxWidth" select="$imageMaxWidth"/>
                </xsl:call-template>
            </div>
        </a>
    </div>
</xsl:if>
    </xsl:template>
</xsl:stylesheet>