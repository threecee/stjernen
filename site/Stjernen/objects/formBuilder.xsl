<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="saxon xs portal" version="2.0" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:saxon="http://icl.com/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="/site/Stjernen/includes/languageFormBuilder.xsl"/>
  <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes"/>
  <xsl:param name="tooltipJavascript" select="'/_public/shared/scripts/toolTip.js'"/>
  <xsl:param name="formStyle" select="'opera'"/>
  <xsl:variable name="language" select="/result/context/@languagecode"/>
  <xsl:variable name="labelColumnWidth" select="/result/context/querystring/parameter[@name = 'labelColumnWidth']"/>
  <xsl:variable name="inputColumnWidth" select="/result/context/querystring/parameter[@name = 'inputColumnWidth']"/>
  <xsl:variable name="currentMenuitem" select="/result/menuitems/menuitem"/>
  <xsl:variable name="formId" select="$currentMenuitem/@key"/>

  <xsl:template match="/">
    <xsl:variable name="pagetitle" select="/result/menuitems/menuitem/name"/>
    <xsl:variable name="subtitle" select="/result/menuitems/menuitem/subtitle"/>
    <xsl:if test="string-length($subtitle) > 0">
      <span class="subtitle"><xsl:value-of select="$subtitle"/></span>
    </xsl:if>
    <xsl:choose>
			<xsl:when test="/result/context/querystring/parameter[@name = 'submit'] = 'ok'">
				<h2>
					<xsl:value-of select="$translations/confirmation"/>
				</h2>
				<xsl:copy-of select="$currentMenuitem/data/form/confirmation/node()"/>
			</xsl:when>
			<xsl:when test="/result/context/querystring/parameter[@name = 'error_form_create']">
        <xsl:choose>
          <xsl:when test="$formStyle = 'opera'">
    				<xsl:call-template name="displayformOperaStyle">
    					<xsl:with-param name="form" select="/result/context/session/attribute[@name = 'error_form_create']/content/contentdata/form"/>
    					<xsl:with-param name="errorHandling" select="'true'"/>
    				</xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
    				<xsl:call-template name="displayform">
    					<xsl:with-param name="form" select="/result/context/session/attribute[@name = 'error_form_create']/content/contentdata/form"/>
    					<xsl:with-param name="errorHandling" select="'true'"/>
    				</xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
			</xsl:when>
			<xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$formStyle = 'opera'">
            <xsl:call-template name="displayformOperaStyle">
    					<xsl:with-param name="form" select="$currentMenuitem/data/form"/>
    				</xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="displayform">
    					<xsl:with-param name="form" select="$currentMenuitem/data/form"/>
    				</xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="displayform">
		<xsl:param name="form"/>
		<xsl:param name="errorHandling"/>
    <xsl:variable name="redirectUrl" select="portal:createPageUrl(/result/menuitems/menuitem/@key, ('submit','ok'))"/>
		<form action="{portal:createServicesUrl('form','create',())}" enctype="multipart/form-data" method="post">
      <div>
			<input name="redirect" type="hidden" value="{$redirectUrl}"/>
			<input name="_form_id" type="hidden" value="{$formId}"/>
			<input name="categorykey" type="hidden" value="{$form/@categorykey}"/>
			<xsl:for-each select="$form/recipients/e-mail">
				<input name="{concat($formId, '_form_recipient')}" type="hidden" value="{.}"/>
			</xsl:for-each>
			<xsl:if test="$currentMenuitem/document != ''">
	            <xsl:choose>
	                <xsl:when test="$currentMenuitem/document/*[1] != ''">
	                    <xsl:for-each select="$currentMenuitem/document/*[1]">
	                        <xsl:if test="not(name() = 'p' or name() = 'h1' or name() = 'h2' or name() = 'h3' or name() = 'div')">
	                            <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
	                        </xsl:if>
	                    </xsl:for-each>
	                </xsl:when>
	                <xsl:otherwise>
	                    <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
	                </xsl:otherwise>
	            </xsl:choose>
				<xsl:copy-of select="$currentMenuitem/document/node()"/>
	            <xsl:choose>
	                <xsl:when test="$currentMenuitem/document/*[1] != ''">
	                    <xsl:for-each select="$currentMenuitem/document/*[1]">
	                        <xsl:if test="not(name() = 'p' or name() = 'h1' or name() = 'h2' or name() = 'h3' or name() = 'div')">
	                            <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
	                        </xsl:if>
	                    </xsl:for-each>
	                </xsl:when>
	                <xsl:otherwise>
	                    <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
	                </xsl:otherwise>
	            </xsl:choose>
			</xsl:if>
			<table cellpadding="0" cellspacing="0" class="list form">
				<tr>
					<th class="title" colspan="2">
						<xsl:value-of select="$form/title"/>
					</th>
				</tr>
				<xsl:call-template name="displaySeparator"/>
				<xsl:for-each select="$form/item">
					<xsl:variable name="inputName" select="concat($formId, concat('_form_', position()))"/>
					<xsl:variable name="inputId" select="concat('label_', $formId, concat('_form_', position()))"/>
					<xsl:variable name="radioGroup" select="position()"/>
					<xsl:choose>
						<xsl:when test="@type = 'separator'">
							<xsl:call-template name="displayFormSeparator">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'text'">
							<xsl:call-template name="displayText">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'textarea'">
							<xsl:call-template name="displayTextarea">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'checkbox'">
							<xsl:call-template name="displayCheckbox">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'radiobuttons'">
							<xsl:call-template name="displayRadiobuttons">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
								<xsl:with-param name="errorHandling" select="$errorHandling"/>
								<xsl:with-param name="radioGroup" select="$radioGroup"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'dropdown'">
							<xsl:call-template name="displayDropdown">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
								<xsl:with-param name="errorHandling" select="$errorHandling"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'checkboxes'">
							<xsl:call-template name="displayCheckboxes">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
								<xsl:with-param name="errorHandling" select="$errorHandling"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'fileattachment'">
							<xsl:call-template name="displayFileattachment">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<xsl:call-template name="displaySeparator"/>
				<tr>
					<td style="width: 50%">
						<xsl:if test="$labelColumnWidth != ''">
							<xsl:attribute name="style">
								<xsl:value-of select="concat('width: ', $labelColumnWidth)"/>
							</xsl:attribute>
						</xsl:if>
						<br/>
					</td>
					<td style="width: 50%">
						<xsl:if test="$inputColumnWidth != ''">
							<xsl:attribute name="style">
								<xsl:value-of select="concat('width: ', $inputColumnWidth)"/>
							</xsl:attribute>
						</xsl:if>
						<input class="button" type="submit" value="{$translations/submit_form}"/>
						<input class="button" type="reset" value="{$translations/reset}"/>
					</td>
				</tr>
			</table>
      </div>
		</form>
                                           <br/>
		<script src="{portal:createResourceUrl($tooltipJavascript)}" type="text/javascript"><xsl:comment>//</xsl:comment></script>
	</xsl:template>

	<xsl:template name="displayformOperaStyle">
		<xsl:param name="form"/>
		<xsl:param name="errorHandling"/>
    <xsl:variable name="redirectUrl" select="portal:createPageUrl(/result/menuitems/menuitem/@key, ('submit','ok'))"/>
    <form action="{portal:createServicesUrl('form','create',())}" enctype="multipart/form-data" method="post">
      <div>
			<input name="redirect" type="hidden" value="{$redirectUrl}"/>
			<input name="_form_id" type="hidden" value="{$formId}"/>
			<input name="categorykey" type="hidden" value="{$form/@categorykey}"/>
			<xsl:for-each select="$form/recipients/e-mail">
				<input name="{concat($formId, '_form_recipient')}" type="hidden" value="{.}"/>
			</xsl:for-each>
			<xsl:if test="$currentMenuitem/document != ''">
        <xsl:choose>
            <xsl:when test="$currentMenuitem/document/*[1] != ''">
                <xsl:for-each select="$currentMenuitem/document/*[1]">
                    <xsl:if test="not(name() = 'p' or name() = 'h1' or name() = 'h2' or name() = 'h3' or name() = 'div')">
                        <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
				<xsl:copy-of select="$currentMenuitem/document/node()"/>
        <xsl:choose>
            <xsl:when test="$currentMenuitem/document/*[1] != ''">
                <xsl:for-each select="$currentMenuitem/document/*[1]">
                    <xsl:if test="not(name() = 'p' or name() = 'h1' or name() = 'h2' or name() = 'h3' or name() = 'div')">
                        <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
			</xsl:if>
      <h2 class="blue"><xsl:value-of select="$form/title"/></h2>
			<table class="operaform">

				<!-- <xsl:call-template name="displaySeparator"/>-->
				<xsl:for-each select="$form/item">
					<xsl:variable name="inputName" select="concat($formId, concat('_form_', position()))"/>
					<xsl:variable name="inputId" select="concat('label_', $formId, concat('_form_', position()))"/>
					<xsl:variable name="radioGroup" select="position()"/>
					<xsl:choose>
						<xsl:when test="@type = 'separator'">
							<xsl:call-template name="displayFormSeparatorOperaStyle">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'text'">
							<xsl:call-template name="displayText">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'textarea'">
							<xsl:call-template name="displayTextarea">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'checkbox'">
							<xsl:call-template name="displayCheckbox">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'radiobuttons'">
							<xsl:call-template name="displayRadiobuttons">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
								<xsl:with-param name="errorHandling" select="$errorHandling"/>
								<xsl:with-param name="radioGroup" select="$radioGroup"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'dropdown'">
							<xsl:call-template name="displayDropdown">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
								<xsl:with-param name="errorHandling" select="$errorHandling"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'checkboxes'">
							<xsl:call-template name="displayCheckboxes">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
								<xsl:with-param name="errorHandling" select="$errorHandling"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@type = 'fileattachment'">
							<xsl:call-template name="displayFileattachment">
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="inputId" select="$inputId"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				</table>
        <p class="enter-button">
    		  <input type="submit" value="{$translations/submit_form}"/>
					<input type="reset" value="{$translations/reset}"/>
			  </p>
      </div>
		</form>
<br/>
		<script src="{portal:createResourceUrl($tooltipJavascript)}" type="text/javascript"><xsl:comment>//</xsl:comment></script>
	</xsl:template>

	<xsl:template name="displayFormSeparator">
    <xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<tr class="form-separator">
			<td colspan="2">
				<div>
					<xsl:value-of select="@label"/>
				</div>
			</td>
		</tr>
	</xsl:template>
 	<xsl:template name="displayFormSeparatorOperaStyle">
    <xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<tr class="form-separator">
			<th colspan="2"><div><xsl:value-of disable-output-escaping="yes" select="@label"/></div></th>
		</tr>
	</xsl:template>
	<xsl:template name="displayText">
		<xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<xsl:call-template name="displayErrorMessage"/>
		<tr>
			<xsl:call-template name="displayLabel">
				<xsl:with-param name="inputId" select="$inputId"/>
			</xsl:call-template>
			<td>
				<input class="text" id="{$inputId}" name="{$inputName}" type="text">
					<xsl:attribute name="value">
						<xsl:choose>
							<xsl:when test="data">
								<xsl:value-of select="data"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@default"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:if test="@width">
						<xsl:attribute name="style">
							<xsl:value-of select="concat('width: ', @width)"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="error">
						<xsl:attribute name="class">text error</xsl:attribute>
					</xsl:if>
				</input>
				<xsl:if test="@title = 'true'">
					<input name="{concat($formId, '_form_title')}" type="hidden" value="{$inputName}"/>
				</xsl:if>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="displayTextarea">
		<xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<xsl:call-template name="displayErrorMessage"/>
    <tr>
  		<xsl:call-template name="displayLabel">
  			<xsl:with-param name="inputId" select="$inputId"/>
  		</xsl:call-template>
		  <td>
        <xsl:element name="textarea">
          <xsl:attribute name="cols">10</xsl:attribute>
          <xsl:attribute name="rows">5</xsl:attribute>
          <xsl:attribute name="id"><xsl:value-of select="$inputId"/></xsl:attribute>
          <xsl:attribute name="name"><xsl:value-of select="$inputName"/></xsl:attribute>
    			<xsl:if test="@width or @height">
    				<xsl:attribute name="style">
    					<xsl:if test="@width">
    						<xsl:value-of select="concat('width: ', @width,';')"/>
    					</xsl:if>
    					<xsl:if test="@height">
    						<xsl:value-of select="concat('height: ', @height,';')"/>
    					</xsl:if>
    				</xsl:attribute>
    			</xsl:if>
    			<xsl:if test="error">
    				<xsl:attribute name="class">error</xsl:attribute>
    			</xsl:if>
    			<xsl:value-of select="data"/><xsl:text> </xsl:text></xsl:element>
      </td>
    </tr>
	</xsl:template>
	<xsl:template name="displayCheckbox">
		<xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<tr>
			<xsl:call-template name="displayLabel">
				<xsl:with-param name="inputId" select="$inputId"/>
			</xsl:call-template>
			<td>
				<input id="{$inputId}" name="{$inputName}" type="checkbox">
					<xsl:if test="data = '1' or (not(data) and @default = 'checked')">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="displayRadiobuttons">
		<xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<xsl:param name="errorHandling"/>
		<xsl:param name="radioGroup"/>
		<xsl:call-template name="displayErrorMessage"/>
		<tr>
			<xsl:call-template name="displayLabel"/>
			<td>
				<xsl:for-each select="data/option">
					<xsl:variable name="inputName" select="concat($formId, concat('_form_', $radioGroup))"/>
					<xsl:variable name="inputId" select="concat('radio', $radioGroup ,'_', $formId, concat('_form_', position()))"/>
					<input class="radio" id="{$inputId}" name="{$inputName}" type="radio" value="{@value}">
						<xsl:if test="(not($errorHandling) and @default = 'true') or ($errorHandling = 'true' and @selected = 'true')">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="{$inputId}">
						<xsl:value-of select="@value"/>
					</label>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="displayDropdown">
		<xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<xsl:param name="errorHandling"/>
		<xsl:call-template name="displayErrorMessage"/>
		<tr>
			<xsl:call-template name="displayLabel">
				<xsl:with-param name="inputId" select="$inputId"/>
			</xsl:call-template>
			<td>
				<select id="{$inputId}" name="{$inputName}">
					<xsl:if test="error">
						<xsl:attribute name="class">error</xsl:attribute>
					</xsl:if>
					<option>
						<xsl:value-of select="concat('-- ', $translations/select, ' --')"/>
					</option>
					<xsl:for-each select="data/option">
						<option value="{@value}">
							<xsl:if test="(not($errorHandling) and @default = 'true') or ($errorHandling = 'true' and @selected = 'true')">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="@value"/>
						</option>
					</xsl:for-each>
				</select>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="displayCheckboxes">
		<xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<xsl:param name="errorHandling"/>
		<tr>
			<xsl:call-template name="displayLabel">
				<xsl:with-param name="inputId" select="$inputId"/>
			</xsl:call-template>
			<td>
				<xsl:for-each select="data/option">
					<input id="{$inputId}" name="{$inputName}" type="checkbox" value="{@value}">
						<xsl:if test="(not($errorHandling) and @default = 'true') or ($errorHandling = 'true' and @selected = 'true')">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<xsl:value-of select="@value"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="displayFileattachment">
		<xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<xsl:call-template name="displayErrorMessage"/>
		<tr>
			<xsl:call-template name="displayLabel">
				<xsl:with-param name="inputId" select="$inputId"/>
			</xsl:call-template>
			<td>
				<input class="text" id="{$inputId}" name="{$inputName}" type="file" value="{data}">
					<xsl:if test="error">
						<xsl:attribute name="class">text error</xsl:attribute>
					</xsl:if>
				</input>
				<xsl:if test="@title = 'true'">
					<input name="{concat($formId, '_form_title')}" type="hidden" value="{$inputName}"/>
				</xsl:if>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="displayLabel">
    <xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<th class="left">
			<xsl:choose>
				<xsl:when test="$inputId != ''">
					<label for="{$inputId}">
						<xsl:if test="help">
							<xsl:attribute name="onmouseover">
								<xsl:value-of select="concat('return escape(&quot;', help, '&quot;)')"/>
							</xsl:attribute>
							<xsl:attribute name="class">help</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="concat(@label, ':')"/>
					</label>
				</xsl:when>
				<xsl:otherwise>
					<span>
						<xsl:if test="help">
							<xsl:attribute name="onmouseover">
								<xsl:value-of select="concat('return escape(&quot;', help, '&quot;)')"/>
							</xsl:attribute>
							<xsl:attribute name="class">help</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="concat(@label, ':')"/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="@required = 'true'">
				<span class="required">*</span>
			</xsl:if>
		</th>
	</xsl:template>
	<xsl:template name="displayErrorMessage">
  	<xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<xsl:if test="error">
			<tr>
				<th>
					<br/>
				</th>
				<td class="error"><img alt="Error - Required Field" class="icon_required" height="15" src="images/required.gif" width="15"/>
					<xsl:choose>
						<xsl:when test="error[@id = 1]">
							<xsl:value-of select="$translations/required_input"/>
						</xsl:when>
						<xsl:when test="error[@id = 2]">
							<xsl:choose>
								<xsl:when test="@validationtype = 'email'">
									<xsl:value-of select="$translations/invalid_email_address"/>
								</xsl:when>
								<xsl:when test="@validationtype = 'integer'">
									<xsl:value-of select="$translations/not_integer"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$translations/incorrect_format"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<xsl:template name="displaySeparator">
    <xsl:param name="inputName"/>
		<xsl:param name="inputId"/>
		<tr class="separator">
			<td colspan="2">
				<br/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>