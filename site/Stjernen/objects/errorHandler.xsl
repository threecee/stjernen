<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs" version="2.0" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
	<xsl:include href="/site/Stjernen/includes/languageErrorHandler.xsl"/>
	<xsl:param name="webmasterEmail" select="'webmaster@stjernen.no'"/>
	<xsl:variable name="language" select="/result/context/@languagecode"/>
<!--	<xsl:variable as="xs:string" name="error" select="/result/context/querystring/parameter[@name = 'error']"/> -->
	<xsl:variable as="xs:string" name="error" select="/result/context/querystring/parameter[@name = 'http_status_code']"/>
  <xsl:variable as="xs:string" name="exception" select="/result/context/querystring/parameter[@name = 'exception_message']"/>

	<xsl:variable name="errorUserservices" select="/result/context/querystring/parameter[@name = 'error_userservices']"/>
	<xsl:variable name="errorHandlerOperation" select="/result/context/querystring/parameter[@name = 'error_handler_operation']"/>

	<xsl:template match="/">
		<div id="errorhandler" class="item" style="min-height:300px;">
      <!--img alt="error" src="images/404.gif" style="margin:0 0 10px 10px;float:right;"/-->
      <h1><xsl:value-of select="concat('Error ', $error)"/></h1>
      <xsl:value-of select="$exception"/>

<!--
			<xsl:choose>
				<xsl:when test="$error != ''">
					<h2>
						<xsl:value-of select="concat('Error ', $error)"/>
					</h2>
					<xsl:choose>
						<xsl:when test="$error = '100'">
							<xsl:value-of select="$translations/error_100"/>
						</xsl:when>
						<xsl:when test="$error = '101'">
							<xsl:value-of select="$translations/error_101"/>
						</xsl:when>
						<xsl:when test="$error = '102'">
							<xsl:value-of select="$translations/error_102"/>
						</xsl:when>
						<xsl:when test="$error = '103'">
							<xsl:value-of select="$translations/error_103"/>
						</xsl:when>
						<xsl:when test="$error = '104'">
							<xsl:value-of select="$translations/error_104"/>
						</xsl:when>
						<xsl:when test="$error = '105'">
							<xsl:value-of select="$translations/error_105"/>
						</xsl:when>
						<xsl:when test="$error = '106'">
							<xsl:value-of select="$translations/error_106"/>
						</xsl:when>
						<xsl:when test="$error = '107'">
							<xsl:value-of select="$translations/error_107"/>
						</xsl:when>
						<xsl:when test="$error = '108'">
							<xsl:value-of select="$translations/error_108"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$errorUserservices != ''">
					<h2>
						<xsl:value-of select="concat('Error userservices ', $errorUserservices)"/>
					</h2>
					<xsl:choose>
						<xsl:when test="$errorUserservices = 500">
							<xsl:value-of select="$translations/error_userservices_500"/>
						</xsl:when>
						<xsl:when test="$errorUserservices = 501">
							<xsl:value-of select="$translations/error_userservices_501"/>
						</xsl:when>
						<xsl:when test="$errorUserservices = 502">
							<xsl:value-of select="$translations/error_userservices_502"/>
						</xsl:when>
						<xsl:when test="$errorUserservices = 503">
							<xsl:value-of select="$translations/error_userservices_503"/>
						</xsl:when>
						<xsl:when test="$errorUserservices = 504">
							<xsl:value-of select="$translations/error_userservices_504"/>
						</xsl:when>
						<xsl:when test="$errorUserservices = 505">
							<xsl:value-of select="$translations/error_userservices_505"/>
						</xsl:when>
						<xsl:when test="$errorUserservices = 506">
							<xsl:value-of select="$translations/error_userservices_506"/>
						</xsl:when>
						<xsl:when test="$errorUserservices = 507">
							<xsl:value-of select="$translations/error_userservices_507"/>
						</xsl:when>
						<xsl:when test="$errorUserservices = 508">
							<xsl:value-of select="$translations/error_userservices_508"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$errorHandlerOperation != ''">
					<h2>
						<xsl:value-of select="concat('Error handler operation ', $errorHandlerOperation)"/>
					</h2>
					<xsl:choose>
						<xsl:when test="$errorHandlerOperation = 400">
							<xsl:value-of select="$translations/error_handler_operation_400"/>
						</xsl:when>
						<xsl:when test="$errorHandlerOperation = 401">
							<xsl:value-of select="$translations/error_handler_operation_401"/>
						</xsl:when>
						<xsl:when test="$errorHandlerOperation = 402">
							<xsl:value-of select="$translations/error_handler_operation_402"/>
						</xsl:when>
						<xsl:when test="$errorHandlerOperation = 403">
							<xsl:value-of select="$translations/error_handler_operation_403"/>
						</xsl:when>
						<xsl:when test="$errorHandlerOperation = 404">
							<xsl:value-of select="$translations/error_handler_operation_404"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$translations/error_100"/>
				</xsl:otherwise>
			</xsl:choose>
-->
			<br/>
			<br/>
      <xsl:value-of select="concat($translations/please_try_again, ' ')"/>
			<a href="mailto:{$webmasterEmail}">
				<xsl:value-of select="$webmasterEmail"/>
			</a>
			<xsl:text>.</xsl:text>
		</div>
	</xsl:template>

</xsl:stylesheet>