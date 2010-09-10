<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://exslt.org/common">
	<xsl:param name="buttonFirst" select="'|«'"/>
	<xsl:param name="buttonPrevious" select="'«'"/>
	<xsl:param name="buttonNext" select="'»'"/>
	<xsl:param name="buttonLast" select="'»|'"/>
	<xsl:variable name="includesTextTempNavigationMenu">
		<translations>
			<displaying en="Displaying" no="Viser" sv="Displaying"/>
			<of_lc en="of" no="av" sv="ov"/>
			<previous en="Previous" no="Forrige" sv="Previous"/>
			<next en="Next" no="Neste" sv="Next"/>
		</translations>
	</xsl:variable>
	<xsl:variable name="includesTextTempNavigationMenu2">
		<xsl:apply-templates select="$includesTextTempNavigationMenu/translations/*" mode="navtranslation"/>
	</xsl:variable>
	<xsl:variable name="includesTranslationsNavigationMenu" select="$includesTextTempNavigationMenu2"/>
	<xsl:template match="*" mode="navtranslation">
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
	<xsl:template name="navigationHeader">
		<div id="navigation-header">
			<xsl:value-of select="concat($includesTranslationsNavigationMenu/displaying, ' ')"/>
			<b>
				<xsl:value-of select="$index + 1"/>
				<xsl:if test="$contentCount > 1">
					<xsl:text> - </xsl:text>
					<xsl:value-of select="$index + $contentCount"/>
				</xsl:if>
			</b>
			<xsl:value-of select="concat(' ', $includesTranslationsNavigationMenu/of_lc, ' ')"/>
			<b>
				<xsl:value-of select="$totalCount"/>
			</b>
			<xsl:value-of select="concat(' ', $includesTranslationsNavigationMenu/items_lc)"/>
		</div>
	</xsl:template>
	<xsl:template name="navigationMenu">
		<ul id="navigation-menu">
			<!-- First page -->
			<li>
				<xsl:choose>
					<xsl:when test="$index > 0">
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="constructNavigationURL">
									<xsl:with-param name="index" select="0"/>
								</xsl:call-template>
							</xsl:attribute>
                            <xsl:value-of select="$buttonFirst"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
     					<xsl:value-of select="$buttonFirst"/>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<!-- Previous page -->
			<li>
				<xsl:choose>
					<xsl:when test="$index - $contentsPerPage >= 0">
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="constructNavigationURL">
									<xsl:with-param name="index" select="$index - $contentsPerPage"/>
								</xsl:call-template>
							</xsl:attribute>
                            <xsl:value-of select="concat($buttonPrevious,' ',$includesTranslationsNavigationMenu/previous)"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
     					<xsl:value-of select="concat($buttonPrevious,' ',$includesTranslationsNavigationMenu/previous)"/>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<!-- Middle navigation part -->
			<xsl:variable name="tmp" select="floor(($totalCount - ($index + 1)) div $contentsPerPage) - floor(($pagesInNavigation - 1) div 2)"/>
			<xsl:variable name="tmp2">
				<xsl:choose>
					<xsl:when test="$tmp > 0">0</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$tmp"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="tmp3" select="$index - (floor($pagesInNavigation div 2) * $contentsPerPage) + ($tmp2 * $contentsPerPage)"/>
			<xsl:call-template name="navigationMenuMiddle">
				<xsl:with-param name="start">
					<xsl:choose>
						<xsl:when test="$tmp3 &lt; 0">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$tmp3"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="maxCount" select="$pagesInNavigation"/>
			</xsl:call-template>
			<!-- Next page -->
			<li>
				<xsl:choose>
					<xsl:when test="$index + $contentsPerPage &lt; $totalCount">
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="constructNavigationURL">
									<xsl:with-param name="index" select="$index + $contentsPerPage"/>
								</xsl:call-template>
							</xsl:attribute>
                            <xsl:value-of select="concat($includesTranslationsNavigationMenu/next,' ',$buttonNext)"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
     					<xsl:value-of select="concat($includesTranslationsNavigationMenu/next,' ',$buttonNext)"/>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<!-- Last page -->
			<li>
				<xsl:choose>
					<xsl:when test="$index + $contentsPerPage &lt; $totalCount">
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="constructNavigationURL">
									<xsl:with-param name="index" select="ceiling(($totalCount div $contentsPerPage) - 1) * $contentsPerPage"/>
								</xsl:call-template>
							</xsl:attribute>
                            <xsl:value-of select="$buttonLast"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
     					<xsl:value-of select="$buttonLast"/>
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</ul>
	</xsl:template>
	<xsl:template name="navigationMenuMiddle">
		<xsl:param name="start"/>
		<xsl:param name="counter" select="1"/>
		<xsl:param name="maxCount"/>
		<xsl:if test="$counter &lt;= $maxCount and (($start + (($counter - 1) * $contentsPerPage)) &lt; $totalCount)">
			<li class="numbers">
				<xsl:choose>
					<xsl:when test="$start + (($counter - 1) * $contentsPerPage) = $index">
						<xsl:attribute name="class">
							<xsl:text>numbers active</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="($start div $contentsPerPage) + $counter"/>
					</xsl:when>
					<xsl:otherwise>
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="constructNavigationURL">
									<xsl:with-param name="index" select="$start + (($counter - 1) * $contentsPerPage)"/>
								</xsl:call-template>
							</xsl:attribute>
							<xsl:value-of select="($start div $contentsPerPage) + $counter"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<xsl:call-template name="navigationMenuMiddle">
				<xsl:with-param name="start" select="$start"/>
				<xsl:with-param name="counter" select="$counter + 1"/>
				<xsl:with-param name="maxCount" select="$maxCount"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="constructNavigationURL">
		<xsl:param name="index"/>
		<xsl:for-each select="/result/context/querystring/parameter[@name != 'index']">
			<xsl:choose>
				<xsl:when test="position() = 1">
					<xsl:text>page?</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>&amp;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="concat(@name, '=', .)"/>
			<xsl:if test="position() = last()">
				<xsl:value-of select="concat('&amp;index=', $index)"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>