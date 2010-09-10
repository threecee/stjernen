<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xalan" version="1.0" xmlns:xalan="http://xml.apache.org/xalan" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:include href="/shared/includes/getAbrDayMonthNames.xsl"/>
    <xsl:output encoding="utf-8" method="xhtml"/>
    <xsl:variable name="rssVersion" select="'2.0'"/>
    <xsl:param name="channelTitle"/>
    <xsl:param name="channelLink"/>
    <xsl:param name="channelDescription"/>
    <xsl:param name="channelLanguage"/>
    <xsl:param name="channelManagingEditor"/>
    <xsl:param name="channelWebMaster"/>
    <xsl:param name="channelImageUrl"/>
    <xsl:param name="channelImageTitle"/>
    <xsl:param name="channelImageWidth"/>
    <xsl:param name="channelImageHeight"/>
    <xsl:param name="itemXpathTitle" select="'title'"/>
    <xsl:param name="itemXpathDescription"/>
    <xsl:param name="timeZone" select="'+0100'"/>
    <xsl:param name="baseUrl"/>
    <xsl:template match="/">
        <xsl:element name="rss">
            <xsl:attribute name="version">
                <xsl:value-of select="$rssVersion"/>
            </xsl:attribute>
            <xsl:element name="channel">
                <xsl:element name="title">
                    <xsl:value-of select="$channelTitle"/>
                </xsl:element>
                <xsl:element name="link">
                    <xsl:value-of select="$channelLink"/>
                </xsl:element>
                <xsl:element name="description">
                    <xsl:value-of select="$channelDescription"/>
                </xsl:element>
                <xsl:element name="lastBuildDate">
                    <xsl:variable name="tempDay">
                        <xsl:choose>
                            <xsl:when test="substring(/result/contents/content[1]/@publishfrom,9,2) &lt; 10">
                                <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,10,1)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,9,2)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="tempMonth">
                        <xsl:choose>
                            <xsl:when test="substring(/result/contents/content[1]/@publishfrom,6,2) &lt; 10">
                                <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,7,1)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,6,2)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="tempYear" select="substring(/result/contents/content[1]/@publishfrom,1,4)"/>
                    <xsl:variable name="dow">
                        <xsl:call-template name="calculate-day-of-the-week">
                            <xsl:with-param name="year" select="$tempYear"/>
                            <xsl:with-param name="month" select="$tempMonth"/>
                            <xsl:with-param name="day" select="$tempDay"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="dayName">
                        <xsl:call-template name="get-day-of-the-week-abbreviation">
                            <xsl:with-param name="day-of-the-week" select="$dow"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="monthName">
                        <xsl:call-template name="get-month-abbreviation">
                            <xsl:with-param name="month" select="$tempMonth"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$dayName"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,9,2)"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$monthName"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,1,4)"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="substring(/result/contents/content[1]/@publishfrom,12,5)"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$timeZone"/>
                </xsl:element>
                
                <xsl:element name="generator">
                    Vertical Site
                </xsl:element>
                <xsl:element name="docs">
                    http://backend.userland.com/rss
                </xsl:element>
                <xsl:if test="$channelLanguage !=''">
                    <xsl:element name="language">
                        <xsl:value-of select="$channelLanguage"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$channelManagingEditor !=''">
                    <xsl:element name="managingEditor">
                        <xsl:value-of select="$channelManagingEditor"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$channelWebMaster !=''">
                    <xsl:element name="webMaster">
                        <xsl:value-of select="$channelWebMaster"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="$channelImageUrl !=''">
                    <xsl:element name="image">
                        <xsl:element name="url">
                            <xsl:value-of select="$channelImageUrl"/>
                        </xsl:element>
                        <xsl:element name="title">
                            <xsl:value-of select="$channelImageTitle"/>
                        </xsl:element>
                        <xsl:element name="link">
                            <xsl:value-of select="$channelLink"/>
                        </xsl:element>
                        <xsl:element name="width">
                            <xsl:value-of select="$channelImageWidth"/>
                        </xsl:element>
                        <xsl:element name="height">
                            <xsl:value-of select="$channelImageHeight"/>
                        </xsl:element>
                        <xsl:element name="description">
                            <xsl:value-of select="$channelDescription"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:for-each select="/result/contents/content">
                    <xsl:element name="item">
                        <xsl:element name="title">
                            <xsl:value-of select="xalan:evaluate($itemXpathTitle)"/>
                        </xsl:element>
                        <xsl:element name="link">
                            <xsl:value-of select="concat($baseUrl,@key,'.cms')"/>
                        </xsl:element>
                        <xsl:element name="description">
                            <xsl:value-of select="xalan:evaluate($itemXpathDescription)"/>
                        </xsl:element>
                        <xsl:element name="pubDate">
                            <xsl:variable name="tempDay">
                                <xsl:choose>
                                    <xsl:when test="substring(@publishfrom,9,2) &lt; 10">
                                        <xsl:value-of select="substring(@publishfrom,10,1)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring(@publishfrom,9,2)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="tempMonth">
                                <xsl:choose>
                                    <xsl:when test="substring(@publishfrom,6,2) &lt; 10">
                                        <xsl:value-of select="substring(@publishfrom,7,1)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring(@publishfrom,6,2)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="tempYear" select="substring(@publishfrom,1,4)"/>
                            <xsl:variable name="dow">
                                <xsl:call-template name="calculate-day-of-the-week">
                                    <xsl:with-param name="year" select="$tempYear"/>
                                    <xsl:with-param name="month" select="$tempMonth"/>
                                    <xsl:with-param name="day" select="$tempDay"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="dayName">
                                <xsl:call-template name="get-day-of-the-week-abbreviation">
                                    <xsl:with-param name="day-of-the-week" select="$dow"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="monthName">
                                <xsl:call-template name="get-month-abbreviation">
                                    <xsl:with-param name="month" select="$tempMonth"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="$dayName"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="substring(@publishfrom,9,2)"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$monthName"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring(@publishfrom,1,4)"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring(@publishfrom,12,5)"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$timeZone"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>