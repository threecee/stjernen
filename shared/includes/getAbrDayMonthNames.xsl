<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="calculate-day-of-the-week">
        <xsl:param name="year"/>
        <xsl:param name="month"/>
        <xsl:param name="day"/>
        <xsl:variable name="a" select="floor((14 - $month) div 12)"/>
        <xsl:variable name="y" select="$year - $a"/>
        <xsl:variable name="m" select="$month + 12 * $a - 2"/>
        <xsl:value-of select="($day + $y + floor($y div 4) - floor($y div 100) + floor($y div 400) + floor((31 * $m) div 12)) mod 7"/>
    </xsl:template>
    
    <xsl:template name="get-day-of-the-week-abbreviation">
        <xsl:param name="day-of-the-week"/>
        <xsl:choose>
            <xsl:when test="$day-of-the-week = 0">Sun</xsl:when>
            <xsl:when test="$day-of-the-week = 1">Mon</xsl:when>
            <xsl:when test="$day-of-the-week = 2">Tue</xsl:when>
            <xsl:when test="$day-of-the-week = 3">Wed</xsl:when>
            <xsl:when test="$day-of-the-week = 4">Thu</xsl:when>
            <xsl:when test="$day-of-the-week = 5">Fri</xsl:when>
            <xsl:when test="$day-of-the-week = 6">Sat</xsl:when>
            <xsl:otherwise>error: <xsl:value-of select="$day-of-the-week"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="get-month-abbreviation">
        <xsl:param name="month"/>
        <xsl:choose>
            <xsl:when test="$month = 1">Jan</xsl:when>
            <xsl:when test="$month = 2">Feb</xsl:when>
            <xsl:when test="$month = 3">Mar</xsl:when>
            <xsl:when test="$month = 4">Apr</xsl:when>
            <xsl:when test="$month = 5">May</xsl:when>
            <xsl:when test="$month = 6">Jun</xsl:when>
            <xsl:when test="$month = 7">Jul</xsl:when>
            <xsl:when test="$month = 8">Aug</xsl:when>
            <xsl:when test="$month = 9">Sep</xsl:when>
            <xsl:when test="$month = 10">Oct</xsl:when>
            <xsl:when test="$month = 11">Nov</xsl:when>
            <xsl:when test="$month = 12">Dec</xsl:when>
            <xsl:otherwise>error: <xsl:value-of select="$month"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>