<xsl:stylesheet exclude-result-prefixes="portal xs" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

   <xsl:template name="passport">
      <xsl:param name="user-image-src" tunnel="yes" as="xs:string?"/>
      <xsl:param name="dummy-user-image-src" tunnel="yes" as="xs:string?"/>
      <xsl:param name="user" as="element()?"/>
      <xsl:param name="email-login" tunnel="yes" as="xs:string?"/>
      <xsl:param name="edit-display-name" tunnel="yes" as="xs:string?"/>
      <xsl:param name="userstore" tunnel="yes" as="element()"/>
      <xsl:param name="time-zone" tunnel="yes" as="element()*"/>
      <xsl:param name="locale" tunnel="yes" as="element()*"/>
      <xsl:param name="country" tunnel="yes" as="element()*"/>
      <xsl:param name="language" as="xs:string?"/>
      <xsl:param name="error" tunnel="yes" as="element()?"/>
      <xsl:param name="success" tunnel="yes" as="element()?"/>
      <xsl:param name="group" as="element()*"/>
      <xsl:param name="join-group-key" tunnel="yes" as="element()*"/>
      <xsl:param name="admin-name" tunnel="yes" as="xs:string"/>
      <xsl:param name="admin-email" tunnel="yes" as="xs:string"/>
      <xsl:param name="site-name" as="xs:string"/>
      <xsl:variable name="operation">
         <xsl:choose>
            <xsl:when test="$error">
               <xsl:value-of select="substring-after($error/@name, 'error_user_')"/>
            </xsl:when>
            <xsl:when test="$success and not($success = 'resetpwd') and not($success = 'create')">
               <xsl:value-of select="$success"/>
            </xsl:when>
            <xsl:when test="$user">update</xsl:when>
            <xsl:otherwise>login</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <script type="text/javascript">
         <xsl:comment>
            
            $(function() {
               <!-- Selects correct tab -->
               <xsl:value-of select="concat('$(&quot;.tabs&quot;).tabs(&quot;select&quot;, &quot;#tabs-', $operation, '&quot;);')"/>
            });
            
         //</xsl:comment>
      </script>
      <div id="passport" class="tabs">
         <!-- Tabs -->
         <ul>
            <xsl:choose>
               <!-- User logged in -->
               <xsl:when test="$user">
                  <li>
                     <a href="#tabs-update">
                        <xsl:value-of select="portal:localize('Update-account')"/>
                     </a>
                  </li>
                  <xsl:if test="$group">
                     <li>
                        <a href="#tabs-setgroups">
                           <xsl:value-of select="portal:localize('Change-group-membership')"/>
                        </a>
                     </li>
                  </xsl:if>
                  <li>
                     <a href="#tabs-changepwd">
                        <xsl:value-of select="portal:localize('Change-password')"/>
                     </a>
                  </li>
                  <li>
                     <a href="{portal:createServicesUrl('user', 'logout', portal:createPageUrl(portal:getPageKey(), ()), ())}">
                        <xsl:value-of select="portal:localize('Logout')"/>
                     </a>
                  </li>
               </xsl:when>
               <!-- User not logged in -->
               <xsl:otherwise>
                  <li>
                     <a href="#tabs-login">
                        <xsl:value-of select="portal:localize('Login')"/>
                     </a>
                  </li>
                  <li>
                     <a href="#tabs-create">
                        <xsl:value-of select="portal:localize('Register')"/>
                     </a>
                  </li>
                  <li>
                     <a href="#tabs-resetpwd">
                        <xsl:value-of select="portal:localize('Forgot-your-password')"/>
                     </a>
                  </li>
               </xsl:otherwise>
            </xsl:choose>
         </ul>
         <!-- Tabs content -->
         <xsl:choose>
            <!-- User logged in -->
            <xsl:when test="$user">
               <!-- Update account -->
               <div id="tabs-update">
                  <xsl:call-template name="user-feedback">
                     <xsl:with-param name="error-operation" select="'update'"/>
                  </xsl:call-template>
                  <xsl:call-template name="user-form">
                     <xsl:with-param name="operation" select="'update'"/>
                  </xsl:call-template>
               </div>
               <!-- Change group membership -->
               <xsl:if test="$group">
                  <div id="tabs-setgroups">
                     <xsl:call-template name="user-feedback">
                        <xsl:with-param name="error-operation" select="'setgroups'"/>
                     </xsl:call-template>
                     <form action="{portal:createServicesUrl('user', 'setgroups', portal:createPageUrl(portal:getPageKey(), ('success', 'setgroups')), ())}" method="post">
                        <fieldset>
                           <legend>
                              <xsl:value-of select="portal:localize('Groups')"/>
                           </legend>
                           <input name="allgroupkeys" type="hidden" value="{string-join($group/@key, ',')}"/>
                           <xsl:for-each select="$group">
                              <xsl:variable name="pos" select="position()"/>
                              <label for="setgroups-group{@key}">
                                 <xsl:value-of select="."/>
                              </label>
                              <input name="joingroupkey" id="setgroups-group{@key}" type="checkbox" class="checkbox" value="{@key}">
                                 <xsl:if test="$user/groups/group[@key = current()/@key]">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                 </xsl:if>
                              </input>
                           </xsl:for-each>
                        </fieldset>
                        <p class="clearfix">
                           <input type="submit" class="button" value="{portal:localize('Change')}"/>
                        </p>
                     </form>
                  </div>
               </xsl:if>
               <!-- Change password -->
               <div id="tabs-changepwd">
                  <script type="text/javascript">
                     <xsl:comment>
                        $(function() {
                           $('#changepwd-newpassword2').rules('add', {
                              equalTo: '#changepwd-newpassword1'
                           });
                        });
                     //</xsl:comment>
                  </script>
                  <xsl:call-template name="user-feedback">
                     <xsl:with-param name="error-operation" select="'changepwd'"/>
                  </xsl:call-template>
                  <form action="{portal:createServicesUrl('user', 'changepwd', portal:createPageUrl(portal:getPageKey(), ('success', 'changepwd')), ())}" method="post">
                     <fieldset>
                        <legend>
                           <xsl:value-of select="portal:localize('Change-password')"/>
                        </legend>
                        <label for="changepwd-password">
                           <xsl:value-of select="portal:localize('Old-password')"/>
                        </label>
                        <input type="password" id="changepwd-password" name="password" class="text required"/>
                        <label for="changepwd-newpassword1">
                           <xsl:value-of select="portal:localize('New-password')"/>
                        </label>
                        <input type="password" id="changepwd-newpassword1" name="newpassword1" class="text required"/>
                        <label for="changepwd-newpassword2">
                           <xsl:value-of select="portal:localize('Repeat-new-password')"/>
                        </label>
                        <input type="password" id="changepwd-newpassword2" name="newpassword2" class="text required"/>
                     </fieldset>
                     <p class="clearfix">
                        <input type="submit" class="button" value="{portal:localize('Change')}"/>
                     </p>
                  </form>
               </div>
            </xsl:when>
            <!-- User not logged in -->
            <xsl:otherwise>
               <!-- Login -->
               <div id="tabs-login">
                  <xsl:call-template name="user-feedback">
                     <xsl:with-param name="error-operation" select="'login'"/>
                     <xsl:with-param name="success-operation" select="'create', 'resetpwd'"/>
                  </xsl:call-template>
                  <form action="{portal:createServicesUrl('user', 'login')}" method="post">
                     <fieldset>
                        <legend>
                           <xsl:value-of select="portal:localize('Login')"/>
                        </legend>
                        <xsl:choose>
                           <xsl:when test="$email-login = 'true'">
                              <label for="login-email">
                                 <xsl:value-of select="portal:localize('E-mail')"/>
                              </label>
                              <input type="text" id="login-email" name="email" class="text required email"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <label for="login-uid">
                                 <xsl:value-of select="portal:localize('Username')"/>
                              </label>
                              <input type="text" id="login-uid" name="uid" class="text required"/>
                           </xsl:otherwise>
                        </xsl:choose>
                        <label for="login-password">
                           <xsl:value-of select="portal:localize('Password')"/>
                        </label>
                        <input type="password" id="login-password" name="password" class="text required"/>
                        <label for="login-rememberme">
                           <span class="tooltip" title="{concat(portal:localize('Remember-me'), ' - ', portal:localize('helptext-remember-me'))}">
                              <xsl:value-of select="portal:localize('Remember-me')"/>
                           </span>
                        </label>
                        <input name="rememberme" id="login-rememberme" type="checkbox" class="checkbox tooltip" value="true" title="{concat(portal:localize('Remember-me'), ' - ', portal:localize('helptext-remember-me'))}"/>
                     </fieldset>
                     <p class="clearfix">
                        <input type="submit" class="button" value="{portal:localize('Login')}"/>
                     </p>
                  </form>
               </div>
               <!-- Register -->
               <div id="tabs-create">
                  <xsl:call-template name="user-feedback">
                     <xsl:with-param name="error-operation" select="'create'"/>
                     <xsl:with-param name="success-operation" select="''"/>
                  </xsl:call-template>
                  <xsl:call-template name="user-form">
                     <xsl:with-param name="operation" select="'create'"/>
                  </xsl:call-template>
               </div>
               <!-- Forgot your password -->
               <div id="tabs-resetpwd">
                  <xsl:if test="$email-login = 'true'">
                     <script type="text/javascript">
                        <xsl:comment>
                           $(function() {
                              $('#resetpwd-form').submit(function () {
                                 var mailBody = $('#resetpwd-mail-body').val();
                                 $('#resetpwd-mail-body').val(mailBody.replace('%email%', $('#resetpwd-id').val()));
                              });
                           });
                        //</xsl:comment>
                     </script>
                  </xsl:if>
                  <xsl:call-template name="user-feedback">
                     <xsl:with-param name="error-operation" select="'resetpwd'"/>
                     <xsl:with-param name="success-operation" select="''"/>
                  </xsl:call-template>
                  <form action="{portal:createServicesUrl('user', 'resetpwd', portal:createPageUrl(portal:getPageKey(), ('success', 'resetpwd')), ())}" method="post" id="resetpwd-form">
                     <fieldset>
                        <legend>
                           <xsl:value-of select="portal:localize('Forgot-your-password')"/>
                        </legend>
                        <input type="hidden" name="from_name" value="{$admin-name}"/>
                        <input type="hidden" name="from_email" value="{$admin-email}"/>
                        <input name="mail_subject" type="hidden" value="{portal:localize('Your-password')}"/>
                        <xsl:variable name="uid">
                           <xsl:choose>
                              <xsl:when test="$email-login = 'true'">
                                 <xsl:value-of select="concat(portal:localize('E-mail'), ': %email%')"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="concat(portal:localize('Username'), ': %username%')"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <input name="mail_body" id="resetpwd-mail-body" type="hidden" value="{portal:localize('resetpwd-mailbody', ($site-name, $uid))}"/>
                        <label for="resetpwd-id">
                           <span class="tooltip" title="{concat(portal:localize('E-mail'), ' - ', portal:localize('user-notice-resetpwd'))}">
                              <xsl:value-of select="portal:localize('E-mail')"/>
                           </span>
                        </label>
                        <input type="text" id="resetpwd-id" name="id" class="text email required tooltip" title="{concat(portal:localize('E-mail'), ' - ', portal:localize('user-notice-resetpwd'))}"/>
                     </fieldset>
                     <p class="clearfix">
                        <input type="submit" class="button" value="{portal:localize('Reset-password')}"/>
                     </p>
                  </form>
               </div>
            </xsl:otherwise>
         </xsl:choose>
      </div>
   </xsl:template>

   <xsl:template name="user-form">
      <xsl:param name="operation" as="xs:string"/>
      <xsl:param name="userstore" tunnel="yes" as="element()"/>
      <xsl:param name="join-group-key" tunnel="yes" as="element()*"/>
      <xsl:param name="admin-name" tunnel="yes" as="xs:string"/>
      <xsl:param name="admin-email" tunnel="yes" as="xs:string"/>
      <xsl:param name="email-login" tunnel="yes" as="xs:string?"/>
      <xsl:param name="edit-display-name" tunnel="yes" as="xs:string?"/>
      <xsl:param name="time-zone" tunnel="yes" as="element()*"/>
      <xsl:param name="locale" tunnel="yes" as="element()*"/>
      <xsl:param name="country" tunnel="yes" as="element()*"/>
      <xsl:param name="user-image-src" tunnel="yes" as="xs:string?"/>
      <xsl:param name="dummy-user-image-src" tunnel="yes" as="xs:string?"/>
      <script type="text/javascript">
         <xsl:comment>
            $(function() {
               $('#create-email2').rules('add', {
                  equalTo: '#create-email'
               });
               <xsl:if test="$operation = 'create'">
                  $('#create-password2').rules('add', {
                     equalTo: '#create-password'
                  });
               </xsl:if>
               <xsl:if test="$userstore/config/user-fields/address/@iso = 'true'">
                  $('#create-address-country').change(function () {
                     $('.create-address-region:visible').hide();
                     $('.create-address-region:enabled').attr('disabled','disabled');
                     $('#create-address-region-'+this.value+',label[for = create-address-region-'+this.value+']').show();
                     $('#create-address-region-'+this.value+'').removeAttr('disabled');
                  });
               </xsl:if>
               <xsl:if test="$userstore/config/user-fields/birthday">
                  $('#create-gui-birthday').datepicker('option', 'changeYear', true);
                  $('#create-gui-birthday').datepicker('option', 'changeMonth', true);
               </xsl:if>
               <xsl:if test="$operation = 'create' or $userstore/config/user-fields/birthday">
                  $('#user-form').submit(function () {
                     <xsl:if test="$operation = 'create'">
                        if ($('#create-password').val() == '') {
                           $('#create-password').attr('disabled','disabled');
                        }
                     </xsl:if>
                     <xsl:if test="$userstore/config/user-fields/birthday">
                       if ($('#create-gui-birthday').val() != '') {
                          $('#create-birthday').removeAttr('disabled');
                          var dateIn = $('#create-gui-birthday').val();
                          <xsl:choose>
                             <xsl:when test="$language = 'no'">
                                var finalDate = dateIn.split('.')[2] + '-' + dateIn.split('.')[1] + '-' + dateIn.split('.')[0]; 
                             </xsl:when>
                             <xsl:otherwise>
                                var finalDate = dateIn.replace('/', '-');
                             </xsl:otherwise>
                          </xsl:choose>
                          $('#create-birthday').val(finalDate);
                       }
                    </xsl:if>
                  });
               </xsl:if>
            });
         //</xsl:comment>
      </script>
      <form action="{portal:createServicesUrl('user', $operation, portal:createPageUrl(portal:getPageKey(), ('success', $operation)), ())}" id="user-form" method="post" enctype="multipart/form-data">
         <fieldset>
            <legend>
               <xsl:value-of select="portal:localize('User')"/>
            </legend>
            <xsl:if test="$operation = 'create'">
               <input type="hidden" name="userstore" value="{$userstore/@key}"/>
               <xsl:for-each select="$join-group-key">
                  <input type="hidden" name="joingroupkey" value="{.}"/>
               </xsl:for-each>
              <!-- E-mail receipt -->
              <input type="hidden" name="from_name" value="{$admin-name}"/>
              <input type="hidden" name="from_email" value="{$admin-email}"/>
              <input type="hidden" name="admin_name" value="{$admin-name}"/>
              <input type="hidden" name="admin_email" value="{$admin-email}"/>
              <input type="hidden" name="admin_mail_subject" value="{concat('New user registered on ', $site-name)}"/>
              <input type="hidden" name="admin_mail_body">
                 <xsl:attribute name="value">
                    <xsl:value-of select="concat('Site: ', $site-name, '\nUserstore: ', $userstore/@name, '\nUsername: %username%')"/>
                    <xsl:if test="$join-group-key">
                       <xsl:text>\n\nAuto-joined the following groups:</xsl:text>
                       <xsl:for-each select="$join-group-key">
                          <xsl:value-of select="concat('\n', .)"/>
                       </xsl:for-each>
                    </xsl:if>
                 </xsl:attribute>
              </input>
              <input type="hidden" name="user_mail_subject" value="{portal:localize('create-mail-subject', ($site-name))}"/>
              <xsl:variable name="uid">
                 <xsl:choose>
                    <xsl:when test="$email-login = 'true'">
                       <xsl:value-of select="concat(portal:localize('E-mail'), ': %email%')"/>
                    </xsl:when>
                    <xsl:otherwise>
                       <xsl:value-of select="concat(portal:localize('Username'), ': %username%')"/>
                    </xsl:otherwise>
                 </xsl:choose>
              </xsl:variable>
              <input type="hidden" name="user_mail_body" value="{portal:localize('create-mailbody', ($site-name, $uid))}"/>
            </xsl:if>
            <!-- Display name -->
            <xsl:if test="$edit-display-name = 'true'">
               <label for="create-display-name">
                  <xsl:value-of select="portal:localize('Display-name')"/>
               </label>
               <input type="text" id="create-display-name" name="display_name" class="text required" value="{$user/display-name}"/>
            </xsl:if>
            <!-- E-mail -->
            <label for="create-email">
               <xsl:value-of select="portal:localize('E-mail')"/>
            </label>
            <input type="text" id="create-email" name="email" class="text required email" value="{$user/email}"/>
            <label for="create-email2">
               <xsl:value-of select="portal:localize('Repeat-email')"/>
            </label>
            <input type="text" id="create-email2" name="email2" class="text required email" value="{$user/email}"/>
            <!-- Password -->
            <xsl:if test="$operation = 'create'">
               <label for="create-password">
                  <span class="tooltip" title="{concat(portal:localize('Password'), ' - ', portal:localize('helptext-password'))}">
                     <xsl:value-of select="portal:localize('Password')"/>
                  </span>
               </label>
               <input type="password" id="create-password" name="password" class="text tooltip" title="{concat(portal:localize('Password'), ' - ', portal:localize('helptext-password'))}"/>
               <label for="create-password2">
                  <xsl:value-of select="portal:localize('Repeat-password')"/>
               </label>
               <input type="password" id="create-password2" name="create-password2" class="text"/>
            </xsl:if>
         </fieldset>
         <xsl:if test="$userstore/config/user-fields/prefix or $userstore/config/user-fields/first-name or $userstore/config/user-fields/middle-name or $userstore/config/user-fields/last-name or $userstore/config/user-fields/suffix or $userstore/config/user-fields/initials or $userstore/config/user-fields/nick-name">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Name')"/>
               </legend>
               <!-- Prefix -->
               <xsl:if test="$userstore/config/user-fields/prefix">
                  <label for="create-prefix">
                     <xsl:value-of select="portal:localize('Prefix')"/>
                  </label>
                  <input type="text" id="create-prefix" name="prefix" value="{$user/prefix}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/prefix/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- First name -->
               <xsl:if test="$userstore/config/user-fields/first-name">
                  <label for="create-first-name">
                     <xsl:value-of select="portal:localize('First-name')"/>
                  </label>
                  <input type="text" id="create-first-name" name="first-name" value="{$user/first-name}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/first-name/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Middle name -->
               <xsl:if test="$userstore/config/user-fields/middle-name">
                  <label for="create-middle-name">
                     <xsl:value-of select="portal:localize('Middle-name')"/>
                  </label>
                  <input type="text" id="create-middle-name" name="middle-name" value="{$user/middle-name}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/middle-name/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Last name -->
               <xsl:if test="$userstore/config/user-fields/last-name">
                  <label for="create-last-name">
                     <xsl:value-of select="portal:localize('Last-name')"/>
                  </label>
                  <input type="text" id="create-last-name" name="last-name" value="{$user/last-name}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/last-name/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Suffix -->
               <xsl:if test="$userstore/config/user-fields/suffix">
                  <label for="create-suffix">
                     <xsl:value-of select="portal:localize('Suffix')"/>
                  </label>
                  <input type="text" id="create-suffix" name="suffix" value="{$user/suffix}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/suffix/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Initials -->
               <xsl:if test="$userstore/config/user-fields/initials">
                  <label for="create-initials">
                     <xsl:value-of select="portal:localize('Initials')"/>
                  </label>
                  <input type="text" id="create-initials" name="initials" value="{$user/initials}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/initials/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Nick name -->
               <xsl:if test="$userstore/config/user-fields/nick-name">
                  <label for="create-nick-name">
                     <xsl:value-of select="portal:localize('Nick-name')"/>
                  </label>
                  <input type="text" id="create-nick-name" name="nick-name" value="{$user/nick-name}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/nick-name/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <xsl:if test="$userstore/config/user-fields/photo">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Photo')"/>
               </legend>
               <!-- Photo -->
               <xsl:if test="$userstore/config/user-fields/photo">
                  <xsl:if test="$operation = 'update' and ($user-image-src != '' or $dummy-user-image-src != '')">
                     <label>
                        <xsl:value-of select="portal:localize('Photo')"/>
                     </label>
                     <img alt="{concat(portal:localize('Image-of'), ' ', $user/display-name)}" src="{if ($user-image-src != '') then $user-image-src else $dummy-user-image-src}"/>
                  </xsl:if>
                  <label for="create-photo">
                     <xsl:value-of select="if ($operation = 'update' and ($user-image-src != '' or $dummy-user-image-src != '')) then portal:localize('Replace-photo') else portal:localize('Photo')"/>
                  </label>
                  <input type="file" id="create-photo" name="photo">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/photo/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <xsl:if test="$userstore/config/user-fields/personal-id or $userstore/config/user-fields/member-id or $userstore/config/user-fields/organization or $userstore/config/user-fields/birthday or $userstore/config/user-fields/gender or $userstore/config/user-fields/title or $userstore/config/user-fields/description or $userstore/config/user-fields/html-email or $userstore/config/user-fields/home-page">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Personal-information')"/>
               </legend>
               <!-- Personal ID -->
               <xsl:if test="$userstore/config/user-fields/personal-id">
                  <label for="create-personal-id">
                     <xsl:value-of select="portal:localize('Personal-id')"/>
                  </label>
                  <input type="text" id="create-personal-id" name="personal-id" value="{$user/personal-id}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/personal-id/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Member ID -->
               <xsl:if test="$userstore/config/user-fields/member-id">
                  <label for="create-member-id">
                     <xsl:value-of select="portal:localize('Member-id')"/>
                  </label>
                  <input type="text" id="create-member-id" name="member-id" value="{$user/member-id}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/member-id/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Organization -->
               <xsl:if test="$userstore/config/user-fields/organization">
                  <label for="create-organization">
                     <xsl:value-of select="portal:localize('Organization')"/>
                  </label>
                  <input type="text" id="create-organization" name="organization" value="{$user/organization}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/organization/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Birthday -->
               <xsl:if test="$userstore/config/user-fields/birthday">
                  <label for="create-gui-birthday">
                     <xsl:value-of select="portal:localize('Birthday')"/>
                  </label>
                  <input type="text" id="create-gui-birthday" value="{$user/birthday}">
                     <xsl:attribute name="class">
                        <xsl:text>text datepicker</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/birthday/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
                  <input type="hidden" name="birthday" id="create-birthday" disabled="disabled"/>
               </xsl:if>
               <!-- Gender -->
               <xsl:if test="$userstore/config/user-fields/gender">
                  <label for="create-gender-female">
                     <xsl:value-of select="portal:localize('Gender')"/>
                  </label>
                  <input type="radio" id="create-gender-female" name="gender" value="female">
                     <xsl:attribute name="class">
                        <xsl:text>radio</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/gender/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                     <xsl:if test="$user/gender = 'female'">
                        <xsl:attribute name="checked">checked</xsl:attribute>
                     </xsl:if>
                  </input>
                  <label class="radio" for="create-gender-female">
                     <xsl:value-of select="portal:localize('Female')"/>
                  </label>
                  <input type="radio" class="radio clear" id="create-gender-male" name="gender" value="male">
                     <xsl:if test="$user/gender = 'male'">
                        <xsl:attribute name="checked">checked</xsl:attribute>
                     </xsl:if>
                  </input>
                  <label class="radio" for="create-gender-male">
                     <xsl:value-of select="portal:localize('Male')"/>
                  </label>
               </xsl:if>
               <!-- Title -->
               <xsl:if test="$userstore/config/user-fields/title">
                  <label for="create-title">
                     <xsl:value-of select="portal:localize('Title')"/>
                  </label>
                  <input type="text" id="create-title" name="title" value="{$user/title}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/title/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Description -->
               <xsl:if test="$userstore/config/user-fields/description">
                  <label for="create-description">
                     <xsl:value-of select="portal:localize('Description')"/>
                  </label>
                  <textarea rows="5" cols="5" id="create-description" name="description">
                     <xsl:if test="$userstore/config/user-fields/title/@required = 'true'">
                        <xsl:attribute name="class">required</xsl:attribute>
                     </xsl:if>
                     <xsl:value-of select="$user/description"/>
                  </textarea>
               </xsl:if>
               <!-- HTML e-mail -->
               <xsl:if test="$userstore/config/user-fields/html-email">
                  <label for="create-html-email">
                     <xsl:value-of select="portal:localize('Html-email')"/>
                  </label>
                  <input type="checkbox" class="checkbox" id="create-html-email" name="html-email">
                     <xsl:if test="$userstore/config/user-fields/html-email/@required = 'true'">
                        <xsl:attribute name="class">required</xsl:attribute>
                     </xsl:if>
                     <xsl:if test="$user/html-email = 'true'">
                        <xsl:attribute name="checked">checked</xsl:attribute>
                     </xsl:if>
                  </input>
               </xsl:if>
               <!-- Home page -->
               <xsl:if test="$userstore/config/user-fields/home-page">
                  <label for="create-home-page">
                     <xsl:value-of select="portal:localize('Home-page')"/>
                  </label>
                  <input type="text" id="create-home-page" name="home-page" value="{$user/home-page}">
                     <xsl:attribute name="class">
                        <xsl:text>text url</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/home-page/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <xsl:if test="($userstore/config/user-fields/time-zone and $time-zone) or ($userstore/config/user-fields/locale and $locale) or ($userstore/config/user-fields/country and $country) or $userstore/config/user-fields/global-position">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Location')"/>
               </legend>
               <!-- Time zone -->
               <xsl:if test="$userstore/config/user-fields/time-zone and $time-zone">
                  <label for="create-time-zone">
                     <xsl:value-of select="portal:localize('Time-zone')"/>
                  </label>
                  <select id="create-time-zone" name="time-zone">
                     <xsl:choose>
                        <xsl:when test="$userstore/config/user-fields/time-zone/@required = 'true'">
                           <xsl:attribute name="class">required</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                           <option>
                              <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                           </option>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:for-each select="$time-zone">
                        <option value="{@ID}">
                           <xsl:if test="$user/time-zone = @ID">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="concat(display-name, ' (', hours-from-utc-as-human-readable, ')')"/>
                        </option>
                     </xsl:for-each>
                  </select>
               </xsl:if>
               <!-- Locale -->
               <xsl:if test="$userstore/config/user-fields/locale and $locale">
                  <label for="create-locale">
                     <xsl:value-of select="portal:localize('Language')"/>
                  </label>
                  <select id="create-locale" name="locale">
                     <xsl:choose>
                        <xsl:when test="$userstore/config/user-fields/locale/@required = 'true'">
                           <xsl:attribute name="class">required</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                           <option>
                              <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                           </option>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:for-each select="$locale">
                        <option value="{name}">
                           <xsl:if test="$user/locale = name">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="display-name"/>
                        </option>
                     </xsl:for-each>
                  </select>
               </xsl:if>
               <!-- Country -->
               <xsl:if test="$userstore/config/user-fields/country and $country">
                  <label for="create-country">
                     <xsl:value-of select="portal:localize('Country')"/>
                  </label>
                  <select id="create-country" name="country">
                     <xsl:choose>
                        <xsl:when test="$userstore/config/user-fields/country/@required = 'true'">
                           <xsl:attribute name="class">required</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                           <option>
                              <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                           </option>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:for-each select="$country">
                        <option value="{@code}">
                           <xsl:if test="$user/country = @code">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="english-name"/>
                           <xsl:if test="local-name != '' and local-name != english-name">
                              <xsl:value-of select="concat(' (', local-name, ')')"/>
                           </xsl:if>
                        </option>
                     </xsl:for-each>
                  </select>
               </xsl:if>
               <!-- Global position -->
               <xsl:if test="$userstore/config/user-fields/global-position">
                  <label for="create-global-position">
                     <xsl:value-of select="portal:localize('Global-position')"/>
                  </label>
                  <input type="text" id="create-global-position" name="global-position" value="{$user/global-position}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/global-position/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <xsl:if test="$userstore/config/user-fields/phone or $userstore/config/user-fields/mobile or $userstore/config/user-fields/fax">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Communication')"/>
               </legend>
               <!-- Phone -->
               <xsl:if test="$userstore/config/user-fields/phone">
                  <label for="create-phone">
                     <xsl:value-of select="portal:localize('Phone')"/>
                  </label>
                  <input type="text" id="create-phone" name="phone" value="{$user/phone}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/phone/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Mobile -->
               <xsl:if test="$userstore/config/user-fields/mobile">
                  <label for="create-mobile">
                     <xsl:value-of select="portal:localize('Mobile')"/>
                  </label>
                  <input type="text" id="create-mobile" name="mobile" value="{$user/mobile}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/mobile/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
               <!-- Fax -->
               <xsl:if test="$userstore/config/user-fields/fax">
                  <label for="create-fax">
                     <xsl:value-of select="portal:localize('Fax')"/>
                  </label>
                  <input type="text" id="create-fax" name="fax" value="{$user/fax}">
                     <xsl:attribute name="class">
                        <xsl:text>text</xsl:text>
                        <xsl:if test="$userstore/config/user-fields/fax/@required = 'true'">
                           <xsl:text> required</xsl:text>
                        </xsl:if>
                     </xsl:attribute>
                  </input>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <!-- Address -->
         <xsl:if test="$userstore/config/user-fields/address">
            <fieldset>
               <legend>
                  <xsl:value-of select="portal:localize('Address')"/>
               </legend>
               <label for="create-address-name">
                  <xsl:value-of select="portal:localize('Label')"/>
               </label>
               <input type="text" id="create-address-name" name="address[0].label" value="{$user/addresses/address[1]/label}">
                  <xsl:attribute name="class">
                     <xsl:text>text</xsl:text>
                     <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                        <xsl:text> required</xsl:text>
                     </xsl:if>
                  </xsl:attribute>
               </input>
               <label for="create-address-street">
                  <xsl:value-of select="portal:localize('Street')"/>
               </label>
               <input type="text" id="create-address-street" name="address[0].street" value="{$user/addresses/address[1]/street}">
                  <xsl:attribute name="class">
                     <xsl:text>text</xsl:text>
                     <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                        <xsl:text> required</xsl:text>
                     </xsl:if>
                  </xsl:attribute>
               </input>
               <label for="create-address-postal-code">
                  <xsl:value-of select="portal:localize('Postal-code')"/>
               </label>
               <input type="text" id="create-address-postal-code" name="address[0].postal_code" value="{$user/addresses/address[1]/postal-code}">
                  <xsl:attribute name="class">
                     <xsl:text>text</xsl:text>
                     <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                        <xsl:text> required</xsl:text>
                     </xsl:if>
                  </xsl:attribute>
               </input>
               <label for="create-address-postal-address">
                  <xsl:value-of select="portal:localize('Postal-address')"/>
               </label>
               <input type="text" id="create-address-postal-address" name="address[0].postal_address" value="{$user/addresses/address[1]/postal-address}">
                  <xsl:attribute name="class">
                     <xsl:text>text</xsl:text>
                     <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                        <xsl:text> required</xsl:text>
                     </xsl:if>
                  </xsl:attribute>
               </input>
               <xsl:if test="$country">
                  <label for="create-address-country">
                     <xsl:value-of select="portal:localize('Country')"/>
                  </label>
                  <xsl:choose>
                     <xsl:when test="$userstore/config/user-fields/address/@iso = 'true'">
                        <select id="create-address-country" name="address[0].iso_country">
                           <xsl:choose>
                              <xsl:when test="$userstore/config/user-fields/address/@required = 'true'">
                                 <xsl:attribute name="class">required</xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                 <option>
                                    <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                                 </option>
                              </xsl:otherwise>
                           </xsl:choose>
                           <xsl:for-each select="$country">
                              <option value="{@code}">
                                 <xsl:if test="$user/addresses/address[1]/iso-country = @code">
                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                 </xsl:if>
                                 <xsl:value-of select="english-name"/>
                                 <xsl:if test="local-name != '' and local-name != english-name">
                                    <xsl:value-of select="concat(' (', local-name, ')')"/>
                                 </xsl:if>
                              </option>
                           </xsl:for-each>
                        </select>
                     </xsl:when>
                     <xsl:otherwise>
                        <input type="text" id="create-address-country" name="address[0].country" value="{$user/addresses/address[1]/country}">
                           <xsl:attribute name="class">
                              <xsl:text>text</xsl:text>
                              <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                                 <xsl:text> required</xsl:text>
                              </xsl:if>
                           </xsl:attribute>
                        </input>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                     <xsl:when test="$userstore/config/user-fields/address/@iso = 'true'">
                        <xsl:for-each select="$country[regions/region]">
                           <label for="create-address-region-{@code}" class="create-address-region">
                              <xsl:if test="not(@code = $user/addresses/address[1]/iso-country)">
                                 <xsl:attribute name="style">display: none;</xsl:attribute>
                              </xsl:if>
                              <xsl:value-of select="portal:localize('Region')"/>
                           </label>
                           <select id="create-address-region-{@code}" name="address[0].iso_region" class="create-address-region">
                              <xsl:if test="not(@code = $user/addresses/address[1]/iso-country)">
                                 <xsl:attribute name="style">display: none;</xsl:attribute>
                                 <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                              <option>
                                 <xsl:value-of select="concat('-- ', portal:localize('Select'), ' --')"/>
                              </option>
                              <xsl:for-each select="regions/region">
                                 <option value="{@code}">
                                    <xsl:if test="$user/addresses/address[1]/iso-region = @code">
                                       <xsl:attribute name="selected">selected</xsl:attribute>
                                    </xsl:if>
                                    <xsl:choose>
                                       <xsl:when test="local-name != ''">
                                          <xsl:value-of select="local-name"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="english-name"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </option>
                              </xsl:for-each>
                           </select>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <label for="create-address-region">
                           <xsl:value-of select="portal:localize('Region')"/>
                        </label>
                        <input type="text" id="create-address-region" name="address[0].region" value="{$user/addresses/address[1]/region}">
                           <xsl:attribute name="class">
                              <xsl:text>text</xsl:text>
                              <xsl:if test="$userstore/config/user-fields/address/@required = 'true'">
                                 <xsl:text> required</xsl:text>
                              </xsl:if>
                           </xsl:attribute>
                        </input>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
            </fieldset>
         </xsl:if>
         <p class="clearfix">
            <input type="submit" class="button">
               <xsl:attribute name="value">
                  <xsl:choose>
                     <xsl:when test="$operation = 'create'">
                        <xsl:value-of select="portal:localize('Register')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="portal:localize('Update')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
            </input>
         </p>
      </form>
   </xsl:template>

   <xsl:template name="user-feedback">
      <xsl:param name="error" tunnel="yes" as="element()?"/>
      <xsl:param name="success" tunnel="yes" as="element()?"/>
      <xsl:param name="error-operation" as="xs:string"/>
      <xsl:param name="success-operation" as="xs:string+" select="$error-operation"/>
      <!-- User feedback -->
      <xsl:choose>
         <xsl:when test="substring-after($error/@name, 'error_user_') = $error-operation">
            <div class="error">
               <xsl:value-of select="portal:localize(concat('user-error-', $error))"/>
            </div>
         </xsl:when>
         <xsl:when test="$success = $success-operation">
            <div class="success">
               <xsl:value-of select="portal:localize(concat('user-success-', $success))"/>
            </div>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
