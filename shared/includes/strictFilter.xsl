<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon" version="2.0" xmlns:saxon="http://icl.com/saxon" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- generic language/style container -->
    <xsl:template match="div">
      <div><xsl:apply-templates select="*|text()"/></div>
    </xsl:template>
    <!-- Paragraphs -->
    <xsl:template match="p">
      <p><xsl:apply-templates select="*|text()"/></p>
    </xsl:template>
    <!-- Headings -->
    <xsl:template match="h1">
      <h1><xsl:apply-templates/></h1>
    </xsl:template>
    <xsl:template match="h2">
      <h2><xsl:apply-templates/></h2>
    </xsl:template>
    <xsl:template match="h3">
      <h3><xsl:apply-templates/></h3>
    </xsl:template>
    <xsl:template match="h4">
      <h4><xsl:apply-templates/></h4>
    </xsl:template>
    <xsl:template match="h5">
      <h5><xsl:apply-templates/></h5>
    </xsl:template>
    <xsl:template match="h6">
      <h6><xsl:apply-templates/></h6>
    </xsl:template>
    <!--=================== Lists ============================================-->
    <!-- Unordered list -->
    <xsl:template match="ul">
      <ul>
        <xsl:apply-templates/>
      </ul>
    </xsl:template>
    <!-- Ordered (numbered) list -->
    <xsl:template match="ol">
      <ol>
        <xsl:apply-templates/>
      </ol>
    </xsl:template>
    <!-- list item -->
    <xsl:template match="li">
      <li><xsl:apply-templates/></li>
    </xsl:template>
    <!-- definition lists - dt for term, dd for its definition -->
    <xsl:template match="dl">
      <dl>
        <xsl:apply-templates/>
      </dl>
    </xsl:template>
    <xsl:template match="dt">
      <dt>
        <xsl:apply-templates/>
      </dt>
    </xsl:template>
    <xsl:template match="dd">
      <dd>
        <xsl:apply-templates/>
      </dd>
    </xsl:template>
    <!--=================== Address ==========================================-->
    <!-- information on author -->
    <xsl:template match="address">
      <address><xsl:apply-templates/></address>
    </xsl:template>
    <!--=================== Horizontal Rule ==================================-->
    <xsl:template match="hr">
      <hr/>
    </xsl:template>
    <!--=================== Preformatted Text ================================-->
    <xsl:template match="pre">
      <pre><xsl:apply-templates/></pre>
    </xsl:template>
    <!--=================== Block-like Quotes ================================-->
    <xsl:template match="blockquote">
      <blockquote><xsl:apply-templates select="*|text()"/></blockquote>
    </xsl:template>
    <!--=================== Inserted/Deleted Text ============================-->
    <!--
      ins/del are allowed in block and inline content, but its
      inappropriate to include block content within an ins element
      occurring in inline content.
    -->
    <xsl:template match="ins">
      <ins><xsl:apply-templates/></ins>
    </xsl:template>
    <xsl:template match="del">
      <del><xsl:apply-templates/></del>
    </xsl:template>
    <!--================== The Anchor Element ================================-->
    <xsl:template match="a">
      <a href="{@href}">
        <xsl:if test="@title">
          <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@rel">
          <xsl:attribute name="rel"><xsl:value-of select="@rel"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </a>
    </xsl:template>
    <xsl:template match="a[@target='_blank']">
      <a href="{@href}">
        <xsl:if test="@title">
          <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="rel">external</xsl:attribute>
        <xsl:attribute name="class">external</xsl:attribute>
        <xsl:apply-templates/>
       </a>
    </xsl:template>
    <xsl:template match="a[@target='_self']">
      <a href="{@href}">
        <xsl:if test="@title">
          <xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@rel">
          <xsl:attribute name="rel"><xsl:value-of select="@rel"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </a>
    </xsl:template>
    <!--===================== Inline Elements ================================-->
    <xsl:template match="span">
    <!-- generic language/style container -->
      <span><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="bdo">
    <!-- I18N BiDi over-ride -->
      <bdo><xsl:apply-templates/></bdo>
    </xsl:template>
    <xsl:template match="br">
    <!-- forced line break -->
      <br/>
    </xsl:template>
    <xsl:template match="em">
    <!-- emphasis -->
      <em><xsl:apply-templates/></em>
    </xsl:template>
    <xsl:template match="strong">
    <!-- strong emphasis -->
      <strong><xsl:apply-templates/></strong>
    </xsl:template>
    <xsl:template match="dfn">
    <!-- definitional -->
      <dfn><xsl:apply-templates/></dfn>
    </xsl:template>
    <xsl:template match="code">
    <!-- program code -->
      <code><xsl:apply-templates/></code>
    </xsl:template>
    <xsl:template match="samp">
    <!-- sample -->
      <samp><xsl:apply-templates/></samp>
    </xsl:template>
    <xsl:template match="kbd">
    <!-- something user would type -->
      <kbd><xsl:apply-templates/></kbd>
    </xsl:template>
    <xsl:template match="var">
    <!-- variable -->
      <var><xsl:apply-templates/></var>
    </xsl:template>
    <xsl:template match="cite">
    <!-- citation -->
      <cite><xsl:apply-templates/></cite>
    </xsl:template>
    <xsl:template match="abbr">
    <!-- abbreviation -->
      <abbr><xsl:apply-templates/></abbr>
    </xsl:template>
    <xsl:template match="acronym">
    <!-- acronym -->
      <acronym><xsl:apply-templates/></acronym>
    </xsl:template>
    <xsl:template match="q">
    <!-- inlined quote -->
      <q><xsl:apply-templates/></q>
    </xsl:template>
    <xsl:template match="sub">
    <!-- subscript -->
      <sub><xsl:apply-templates/></sub>
    </xsl:template>
    <xsl:template match="sup">
    <!-- superscript -->
      <sup><xsl:apply-templates/></sup>
    </xsl:template>
    <xsl:template match="tt">
    <!-- fixed pitch font -->
      <tt><xsl:apply-templates/></tt>
    </xsl:template>
    <xsl:template match="i">
    <!-- italic font -->
      <i><xsl:apply-templates/></i>
    </xsl:template>
    <xsl:template match="b">
    <!-- bold font -->
      <b><xsl:apply-templates/></b>
    </xsl:template>
    <xsl:template match="big">
    <!-- bigger font -->
      <big><xsl:apply-templates/></big>
    </xsl:template>
    <xsl:template match="small">
    <!-- smaller font -->
      <small><xsl:apply-templates/></small>
    </xsl:template>
    <!--==================== Object ======================================-->
    <!--
      object is used to embed objects as part of HTML pages.
      param elements should precede other content. Parameters
      can also be expressed as attribute/value pairs on the
      object element itself when brevity is desired.
    -->
    <xsl:template match="object">
      <object>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </object>
    </xsl:template>
    <xsl:template match="param">
      <param>
        <xsl:copy-of select="@*"/>
      </param>
    </xsl:template>
    <!-- egentlig FY FY, men pokker heller -->
    <xsl:template match="embed">
      <embed>
        <xsl:copy-of select="@*"/>
      </embed>
    </xsl:template>
    <!--=================== Images ===========================================-->
    <xsl:template match="img">
      <img>
        <xsl:copy-of select="@*"/>
      </img>
    </xsl:template>
<!--================== Client-side image maps ============================-->
    <xsl:template match="map">
      <map>
        <xsl:copy-of select="@*"/>
      </map>
    </xsl:template>
    <xsl:template match="area">
      <area>
        <xsl:copy-of select="@*"/>
      </area>
    </xsl:template>
    <!--==================== Tables ======================================-->
    <xsl:template match="table">
      <xsl:variable name="width" select="@width"/>
      <xsl:variable name="border" select="@border"/>
      <xsl:variable name="class" select="@class"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="cellspacing" select="@cellspacing"/>
      <xsl:variable name="cellpadding" select="@cellpadding"/>
      <xsl:variable name="bgcolor" select="@bgcolor"/>
      <xsl:variable name="style" select="translate(@style,$ucase,$lcase)"/>
      <xsl:element name="table">
        <xsl:if test="$bgcolor != '' or $style != ''">
          <xsl:attribute name="style"><xsl:if test="$bgcolor != ''">background-color:<xsl:value-of select="$bgcolor"/>;</xsl:if><xsl:if test="$style != ''"><xsl:value-of select="$style"/></xsl:if>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$cellpadding != ''">
          <xsl:attribute name="cellpadding"><xsl:value-of select="$cellpadding"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$cellspacing != ''">
          <xsl:attribute name="cellspacing"><xsl:value-of select="$cellspacing"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$id != ''">
          <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$class != ''">
          <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$width != ''">
          <xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="*|text()"/>
      </xsl:element>
    </xsl:template>
    <xsl:template match="colgroup">
      <colgroup>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </colgroup>
    </xsl:template>
    <xsl:template match="col">
      <col>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </col>
    </xsl:template>
    <xsl:template match="thead">
      <thead>
        <xsl:apply-templates/>
      </thead>
    </xsl:template>
    <xsl:template match="tbody">
      <tbody>
        <xsl:apply-templates/>
      </tbody>
    </xsl:template>
    <xsl:template match="tfoot">
      <tfoot>
        <xsl:apply-templates/>
      </tfoot>
    </xsl:template>
    <xsl:template match="tr">
      <xsl:variable name="bgcolor" select="@bgcolor"/>
      <xsl:variable name="style" select="translate(@style,$ucase,$lcase)"/>
      <tr>
        <xsl:if test="$bgcolor != '' or $style != ''">
          <xsl:attribute name="style">
            <xsl:if test="$bgcolor != ''">background-color:<xsl:value-of select="$bgcolor"/>;</xsl:if>
            <xsl:if test="$style != ''"><xsl:value-of select="$style"/></xsl:if>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </tr>
    </xsl:template>
    <xsl:template match="th">
      <xsl:variable name="width" select="@width"/>
      <xsl:variable name="style" select="translate(@style,$ucase,$lcase)"/>
      <xsl:variable name="bgcolor" select="@bgcolor"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="align" select="@align"/>
      <xsl:variable name="valign" select="@valign"/>
      <xsl:variable name="class" select="@class"/>
      <xsl:variable name="colspan" select="@colspan"/>
      <xsl:variable name="rowspan" select="@rowspan"/>
      <td>
        <xsl:if test="$valign != '' or $align != '' or $width != '' or $bgcolor != '' or $style != ''">
          <xsl:attribute name="style">
            <xsl:if test="$width != ''">width:<xsl:value-of select="$width"/>;</xsl:if>
            <xsl:if test="$bgcolor != ''">background-color:<xsl:value-of select="$bgcolor"/>;</xsl:if>
            <xsl:if test="$align != ''">text-align:<xsl:value-of select="$align"/>;</xsl:if>
            <xsl:if test="$valign != ''">vertical-align:<xsl:value-of select="$valign"/>;</xsl:if>
            <xsl:if test="$style != ''"><xsl:value-of select="$style"/></xsl:if>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$id != ''">
          <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$class != ''">
          <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$colspan != ''">
          <xsl:attribute name="colspan"><xsl:value-of select="$colspan"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$rowspan != ''">
          <xsl:attribute name="rowspan"><xsl:value-of select="$rowspan"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </td>
    </xsl:template>
    <xsl:template match="td">
      <xsl:variable name="width" select="@width"/>
      <xsl:variable name="style" select="translate(@style,$ucase,$lcase)"/>
      <xsl:variable name="bgcolor" select="@bgcolor"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="align" select="@align"/>
      <xsl:variable name="valign" select="@valign"/>
      <xsl:variable name="class" select="@class"/>
      <xsl:variable name="colspan" select="@colspan"/>
      <xsl:variable name="rowspan" select="@rowspan"/>
      <td>
        <xsl:if test="$valign != '' or $align != '' or $width != '' or $bgcolor != '' or $style != ''">
          <xsl:attribute name="style">
            <xsl:if test="$width != ''">width:<xsl:value-of select="$width"/>;</xsl:if>
            <xsl:if test="$bgcolor != ''">background-color:<xsl:value-of select="$bgcolor"/>;</xsl:if>
            <xsl:if test="$align != ''">text-align:<xsl:value-of select="$align"/>;</xsl:if>
            <xsl:if test="$valign != ''">vertical-align:<xsl:value-of select="$valign"/>;</xsl:if>
            <xsl:if test="$style != ''"><xsl:value-of select="$style"/></xsl:if>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$id != ''">
          <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$class != ''">
          <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$colspan != ''">
          <xsl:attribute name="colspan"><xsl:value-of select="$colspan"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$rowspan != ''">
          <xsl:attribute name="rowspan"><xsl:value-of select="$rowspan"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </td>
    </xsl:template>
  <!-- OLD and DEPRECATED ELEMENTS -->
    <xsl:template match="strike">
      <span style="text-decoration:line-through;"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="u">
      <span style="text-decoration:underline;"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="font">
      <xsl:value-of select="*|text()"/>
    </xsl:template>
    <xsl:template match="marquee">
      <xsl:value-of select="*|text()"/>
    </xsl:template>
    <xsl:template match="blink">
      <xsl:value-of select="*|text()"/>
    </xsl:template>
</xsl:stylesheet>