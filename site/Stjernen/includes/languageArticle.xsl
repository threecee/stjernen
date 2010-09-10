<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="textTemp">
        <translations>
            <items_lc en="articles" no="artikler" ru="статьи" sv="artiklar"/>
            <no_items en="No articles" no="Ingen artikler" ru="Нет статей" sv="Inga artiklar"/>
            <and en="and" no="og" ru="и" sv="och"/>
            <read_more en="Read more" no="Les mer" ru="Подробнее" sv="Läs mera"/>
            <photo en="Photo" no="Foto" ru="Фото" sv="Foto"/>
            <related_links en="Related links" no="Relaterte lenker" ru="Схожие ссылки" sv="Relaterade länkar"/>
            <link en="Links" no="Lenker" ru="Ссылка" sv="Länker"/>
            <description en="Description" no="Beskrivelse" ru="Описание" sv="Beskrivning"/>
            <related_files en="Related files" no="Relaterte filer" ru="Схожие файлы" sv="Relaterade filer"/>
            <filename en="Files" no="Filer" ru="Название файла" sv="Filer"/>
            <date en="Date" no="Dato" ru="Дата" sv="Datum"/>
            <size en="Size" no="Str" ru="Размер" sv="Storlek"/>
            <back en="Back" no="Tilbake" ru="Назад" sv="Tillbaka"/>
            <to_top en="Top" no="Til toppen" ru="Наверх" sv="Till toppen"/>
            <related_items en="Related articles" no="Relaterte artikler" ru="Схожие статьи" sv="Relaterade artiklar"/>
<related_articles en="Related articles" no="Relaterte artikler" ru="Схожие статьи" sv="Relaterade artiklar"/>
            <item en="Article" no="Artikkel" ru="Статья" sv="Artikel"/>
            <text_by en="by" no="av" ru="" sv="av"/>
            <published en="Published" no="Publisert" ru="" sv=""/>
        </translations>
    </xsl:variable>
    <xsl:variable name="textTemp2">
        <xsl:apply-templates mode="translations" select="$textTemp/translations/*"/>
    </xsl:variable>
    <xsl:variable name="translations" select="$textTemp2"/>
    <xsl:template match="*" mode="translations">
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
</xsl:stylesheet>