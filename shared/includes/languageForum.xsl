<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:saxon="http://exslt.org/common" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="textTemp">
		<translations>
			<thread en="Thread" no="Tråd"/>
			<post_title en="Title" no="Emne"/>
			<forum en="Forum" no="Forum"/>
			<started_by en="Started by" no="Startet av"/>
			<new_post en="New posting" no="Nytt innlegg"/>
			<all_cats en="Show all categories" no="Vis alle kategorier"/>
			<rss en="RSS feed" no="RSS-feed"/>
			<reply en="Reply" no="Svar"/>
			<reply_quote en="Quote" no="Sitér"/>
			<report en="Report" no="Rapporter"/>
			<no_items en="No items found in this category." no="Ingen innlegg ble funnet i denne kategorien."/>
			<name en="Name" no="Navn"/>
			<email en="E-mail" no="Epost"/>
			<subject en="Subject" no="Overskrift"/>
			<content en="Content" no="Innlegg"/>
			<post en="Post content" no="Post innlegg"/>
			<newpost en="New post " no="Nytt innlegg"/>
			<replypost en="Post a reply" no="Svar på innlegget"/>

			<categories en="Forum categories" no="Forumkategorier"/>
			<no_categories en="There are no categories in this forum." no="Det eksisterer for øyeblikket ingen kategorier."/>
			<search en="Search" no="Søk"/>
			<search_forum en="Search forum" no="Søk i forumet"/>
			<latest_postings en="Latest postings" no="Siste innlegg"/>
			<search_results en="Search results" no="Søkeresultater"/>
			<your_query en="Your query" no="Du søkte på"/>
			<by en="By" no="Av"/>
			<your_comment en="Your comment" no="Din kommentar"/>
			<report_this en="Report this posting to the forum moderators" no="Rapporter denne tråden til en forum-moderator"/>
			<user_has_reported en="Bad forum posting reported" no="En bruker har rapportert et støtende innlegg"/>
			<new_forum_posting en="New forum posting" no="Ny forumposting"/>
			<report_success en="Thank you for submitting your report." no="Takk for din rapport."/>
			<close_window en="Close window" no="Lukk vindu"/>
			<submit en="Submit" no="Send"/>
			<preview en="Preview" no="Forhåndsvis"/>
			<reset en="Reset" no="Tilbakestill"/>
		</translations>
	</xsl:variable>
	<xsl:variable name="textTemp2">
		<xsl:apply-templates mode="translations" select="saxon:node-set($textTemp)/translations/*"/>
	</xsl:variable>
	<xsl:variable name="translations" select="saxon:node-set($textTemp2)"/>
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