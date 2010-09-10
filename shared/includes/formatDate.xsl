<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="includesTextTempFormatDate">
		<translations>
			<months>
				<month1 en="January" no="januar" ru="января" sv="januari"/>
				<month2 en="February" no="februar" ru="февраля" sv="februari"/>
				<month3 en="March" no="mars" ru="марта" sv="mars"/>
				<month4 en="April" no="april" ru="апреля" sv="april"/>
				<month5 en="May" no="mai" ru="мая" sv="maj"/>
				<month6 en="June" no="juni" ru="июня" sv="juni"/>
				<month7 en="July" no="juli" ru="июля" sv="juli"/>
				<month8 en="August" no="august" ru="августа" sv="augusti"/>
				<month9 en="September" no="september" ru="сентября" sv="september"/>
				<month10 en="October" no="oktober" ru="октября" sv="oktober"/>
				<month11 en="November" no="november" ru="ноября" sv="november"/>
				<month12 en="December" no="desember" ru="декабря" sv="december"/>
			</months>
		</translations>
	</xsl:variable>
	<xsl:variable name="includesTextTempFormatDate2">
		<xsl:apply-templates select="$includesTextTempFormatDate/translations/*" mode="translations"/>
	</xsl:variable>
	<xsl:variable name="includesTranslationsFormatDate" select="$includesTextTempFormatDate2"/>
	<xsl:template match="*" mode="translation">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="@*[name() = $language] != ''">
					<xsl:value-of select="@*[name() = $language]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>[NOT TRANSLATED]</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'long'"/>
		<xsl:param name="includeTime" select="'false'"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="time" select="substring($date, 12, 5)"/>
		<xsl:if test="number($month) and number($day) and number($year)">
			<xsl:variable name="monthname" select="$includesTranslationsFormatDate/months/*[name() = concat('month', number($month))]"/>
          <xsl:choose>
				<xsl:when test="$language = 'no'">
					<xsl:choose>
						<xsl:when test="$format = 'short'">
							<xsl:value-of select="concat($day, '.', $month, '.', $year)"/>
						</xsl:when>
						<xsl:when test="$format = 'month'">
							<xsl:value-of select="$monthname"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(number($day), '. ', $monthname, ' ', $year)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$format = 'short'">
							<xsl:value-of select="concat($day, '/', $month, '/', $year)"/>
						</xsl:when>
						<xsl:when test="$format = 'month'">
							<xsl:value-of select="$monthname"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($day, ' ', $monthname, ' ', $year)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$includeTime = 'true'">
				<xsl:value-of select="concat(' ', $time)"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
  <xsl:template name="datetimeFull">
    <xsl:param name="date"/>
    <xsl:choose>
      <xsl:when test="$language = 'no'">
        <xsl:value-of select="concat(substring($date, 9, 2), '.', substring($date, 6, 2), '.', substring($date, 1, 4), ' kl ', substring($date, 12, 2), ':', substring($date, 15, 2))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(substring($date, 9, 2), '.', substring($date, 6, 2), '.', substring($date, 1, 4), ' ', substring($date, 12, 2), ':', substring($date, 15, 2))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>