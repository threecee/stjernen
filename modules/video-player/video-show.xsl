<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:portal="http://www.enonic.com/cms/xslt/portal" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="no" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>
    
    <xsl:variable name="region-width" select="/result/context/querystring/parameter[@name = '_config-region-width']"/>
    <xsl:variable name="height" select="floor($region-width * 9 div 16)"/>

    <xsl:template match="/">
        <h1>
            <xsl:value-of select="/result/contents/content/title"/>
        </h1>
        <xsl:choose>
            <xsl:when test="/result/contents/relatedcontents/content[@key = /result/contents/content/contentdata/video/file/@key]">
                <xsl:apply-templates select="/result/contents/content"/>
            </xsl:when>
            <xsl:otherwise>
                <div class="error">
                    <xsl:value-of select="portal:localize('Video-not-found')"/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="content">
        <script type="text/javascript" src="{portal:createResourceUrl('/_public/modules/video-player/scripts/soundmanager2-nodebug-jsmin.js')}"/>
        <script type="text/javascript">
            <xsl:comment>
               $(function() {
                   <xsl:text>
                   </xsl:text>
                   <xsl:value-of select="concat('soundManager.url = &quot;', portal:createUrl('/_public/modules/video-player/swf/'), '&quot;;')"/>
                   soundManager.debugMode = false;
                   soundManager.flashVersion = 9;
                   soundManager.useMovieStar = true;
                   soundManager.allowFullScreen = true;
                   soundManager.wmode = 'transparent';
                   soundManager.autoPlay = true;
                       
                   var video;
                   var blinkInterval;
                   var volume = 100;
                       
                   soundManager.onload = function() {
                       video = soundManager.createVideo({
                           id: 'video',
                           <xsl:value-of select="concat('url: &quot;', portal:createAttachmentUrl(contentdata/video/file/@key), '&quot;,')"/>
               
                           onmetadata: function() {
                               if (this.width/this.height &lt; 16/9) {
                                   <xsl:value-of select="concat('var width = Math.round(', $height, '*this.width/this.height);')"/> 
                                   $('#sm2-container').width(width);
                                   <xsl:value-of select="concat('$(&quot;#sm2-container&quot;).height(', $height, ');')"/>
                                   <xsl:value-of select="concat('$(&quot;#sm2-container&quot;).css(&quot;left&quot;,Math.round((', $region-width, '-width)/2)).css(&quot;top&quot;,0);')"/>
                               } else {
                                   <xsl:value-of select="concat('var height = Math.round(', $region-width, '*this.height/this.width);')"/> 
                                   <xsl:value-of select="concat('$(&quot;#sm2-container&quot;).width(', $region-width, ');')"/>
                                   $('#sm2-container').height(height);
                                   <xsl:value-of select="concat('$(&quot;#sm2-container&quot;).css(&quot;top&quot;,Math.round((', $height, '-height)/2)).css(&quot;left&quot;,0);')"/>
                               }
                           },
                           
                           whileloading: function() {
                               $('.progress-bar-loading').width(((this.bytesLoaded/this.bytesTotal)*100)+'%');
                           },
               
                           onload: function() {
                               $('.progress-bar-loading').addClass('finished');
                               $('.progress-bar-loading').html('&lt;div id=&quot;video-player-progress-bar&quot;/&gt;');
                               $('#video-player-progress-bar').slider({
                                   orientation: "horizontal",
                                   range: "min",
                                   min: 0,
                                   max: this.duration,
                                   value: 0,
                                   start: function(event, ui) {
                                       video.pause();
                                   },
                                   slide: function(event, ui) {
                                       video.setPosition(ui.value);
                                       $('.position').text(getTime(ui.value));
                                   },
                                   stop: function(event, ui) {
                                       if (!$('a.play').hasClass('paused')) video.resume();
                                   }
                               });
                           },
                           
                           whileplaying: function() {
                               $('.duration').text(getTime(this.duration));
                               $('.position').text(getTime(this.position));
                               $('#video-player-progress-bar').slider('option', 'value', this.position);
                           },
                           
                           onpause: blink,
                               
                           onresume: function() {
                               clearInterval(blinkInterval);
                               $('.position').css('visibility', 'visible');
                           },
                           
                           onfinish: function() {
                               $('#video-player-progress-bar > .ui-slider-range').attr('style', 'width:100%');
                               $('a.play').addClass('paused');
                           }
                       });
                       video.play('video');
                   }
                       
                   function blink() {
                       blinkInterval = setInterval(function() {
                           if($('.position').css('visibility') == 'visible') {
                               $('.position').css('visibility', 'hidden');
                           } else {
                               $('.position').css('visibility', 'visible');
                           }
                       }, 500);
                   }
                       
                   $('a.play').click(function() {
                       if (video.playState == 0) {
                           video.setPosition(0);
                           video.play();
                           $('a.play').removeClass('paused');
                       } else {
                           video.togglePause();
                           $('a.play').toggleClass('paused');
                       }
                   });
                   
                   $('a.volume').click(function() {
                       if (video.volume != 0) {
                           var sliderValue = (video.muted) ? video.volume : 0;
                           $("#video-player-volume-slider").slider('option', 'value', sliderValue);
                           video.toggleMute();
                           $('a.volume').toggleClass('muted');
                       }
                   });
                       
                   $('a.volume, .video-player-volume-slider').hover(
                       function() {
                           $('.video-player-volume-slider').stop(true).animate({ 
                               paddingTop: '12px',
                               paddingBottom: '12px',
                               height: '100px',
                               <xsl:value-of select="concat('top: &quot;', $height + 10 - 120, 'px&quot;')"/>
                           }, 300, 'swing');
                       }, 
                       function () {
                           $('.video-player-volume-slider').stop(true).pause(800).animate({ 
                               paddingTop: '0',
                               paddingBottom: '0',
                               height: '0',
                               <xsl:value-of select="concat('top: &quot;', $height + 10, 'px&quot;')"/>
                           }, 300, 'swing');
                       }
                   );
                       
                   $.fn.pause = function( time, name ) {
                       return this.queue( ( name || "fx" ), function() {
                           var self = this;
                           setTimeout(function() { $.dequeue(self); } , time );
                       });
                   };
                   
                   $('#video-player-volume-slider').slider({
                       orientation: "vertical",
                       range: "min",
                       min: 0,
                       max: 100,
                       value: 100,
                       slide: function(event, ui) {
                           video.setVolume(ui.value);
                           if (ui.value == 0) {
                               $('a.volume').addClass('muted');
                           } else {
                               video.unmute();
                               $('a.volume').removeClass('muted');
                           }
                       }
                   });
                   
               });
                   
               function getTime(nMSec) {
                   // convert milliseconds to mm:ss, return as object literal or string
                   var nSec = Math.floor(nMSec/1000);
                   var min = Math.floor(nSec/60);
                   var sec = nSec-(min*60);
                   return (min+':'+(sec&lt;10?'0'+sec:sec));
               }

            //</xsl:comment>
        </script>
        <div class="video-player" style="width: {$region-width}px; height: {$height}px;">
            <div class="video-player-volume-slider" style="top: {$height + 10}px;">
                <div id="video-player-volume-slider"/>
            </div>
            <div class="video-controls" style="top: {$height + 10}px;">
                <a href="javascript:void(0);" title="{portal:localize('Play-pause')}" class="play"/>
                <div class="progress-bar-container">
                    <div class="progress-bar-loading"/>
                </div>
                <span class="time-container">
                    <span class="position">-:--</span>
                    <xsl:text> / </xsl:text>
                    <span class="duration">-:--</span>
                </span>
                <a href="javascript:void(0);" title="{portal:localize('helptext-fullscreen')}" class="tooltip fullscreen"/>
                <a href="javascript:void(0);" title="{portal:localize('Volume')}" class="volume"/>
            </div>
            <div id="sm2-container"/>
        </div>
        <xsl:if test="contentdata/description != ''">
            <p>
                <xsl:value-of disable-output-escaping="yes" select="replace(contentdata/description, '\n', '&lt;br /&gt;')"/>
            </p>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
