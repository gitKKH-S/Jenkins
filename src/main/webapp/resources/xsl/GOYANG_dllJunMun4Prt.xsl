<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="allGongpoil" />
<xsl:param name="showTag" />
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="schtxt" />
<xsl:param name="Obookid" />
<xsl:param name="deptname" />
<xsl:param name="ALLFILE" />
<xsl:param name="ListS" />
<xsl:param name="type" />
<xsl:param name="allcha" />
<xsl:param name="ImageURL" />
<xsl:param name="selectBox" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- 루트 template -->

<xsl:template match="/">
<html>
	<head>
		<style>
  	 .바탕글_00{
          text-align: left;
		  padding-left:0px;
          font-family: "신명조, monospace",serif;
          font-size:14px;
		  line-height:160%;
          color:#000000;
		  text-indent : 0px;
      }
      .타이틀_01{
          text-align: center;
          font-family: "HY견고딕, monospace",serif;
          font-size:20pt;
          color:#000000;
		  line-height: 20px;
          font-weight: bold;
		  padding-bottom:00px;
      }
	 
	  .공포일_02{
          text-align: right;
          font-family: "신명조, monospace",serif;
          font-size:14pt;
          color:#000000;
		  line-height: 130%;
		  font-weight: bold;
      }
	  .장절_03{
          text-align: center;
          font-family: "신명조, monospace",serif;
          font-size:18pt;
          color:#000000;
		  line-height: 20px;
          font-weight: bold;
  		  margin-top:10pt;
		  margin-bottom:2pt;
      }
      .조내용N{
          text-align: justify;
		  padding-left:10px;
          font-family: "신명조, monospace",serif;
          font-size:14pt;
		  line-height:160%;
          color:#000000;
		  text-indent : -14pt;
		  margin-top:10pt;

      }
	  .항_05{
          text-align: justify;
		  margin-left:14pt;
          font-family: "신명조, monospace",serif;
          font-size:14pt;
		  line-height:180%;
          color:#000000;
      }
	  .호_06{
          text-align: justify;
		  margin-left:15pt;
          font-family: "신명조, monospace",serif;
          font-size:14pt;
		  line-height:180%;
          color:#000000;
          text-indent : -18pt;
      }
	  .목_07{
           text-align: justify;
		  margin-left:33pt;
          font-family: "신명조, monospace",serif;
          font-size:14pt;
		  line-height:180%;
          color:#000000;
          text-indent : -18pt;
      }
	  .단_08{
          text-align: justify;
		  margin-left:48pt;
          font-family: "신명조, monospace",serif;
          font-size:14pt;
		  line-height:180%;
          color:#000000;
          text-indent : -15pt;

      }
	  .부칙_10{
          text-align: center;
          font-family: "신명조, monospace",serif;
          font-size:14pt;
          color:#000000;
		  line-height:180%;
          font-weight: bold;
  		  margin-top:10pt;
		  margin-bottom:2pt;
      }
	  .본문_11{
          text-align: justify;
		  padding-left:0px;
          font-family: "신명조, monospace",serif;
          font-size:14pt;
		  line-height:180%;
          color:#000000;
		  text-indent : 0px;
      }
	  .backcolor{
          background-color: rgb(241, 208, 167);
      }
	  .jotag{
	      text-align: left;
		  font-family: "신명조, monospace",serif;
          font-size:14pt;
		  line-height:180%;
          color:#000000;
      }
	  .hangtag{
          text-align: left;
		  font-family: "신명조, monospace",serif;
          font-size:14pt;
		  line-height:180%;
          color:#000000;
		  
      }
	  .joTitle{
          font-weight: bold;
		  color:#000000;
      }
	  .allrev{
		  color:blue;
      }
	 <!--font-weight: bold;-->
    </style>
	</head>	
	<body leftmargin="0" topmargin="5" marginwidth="0" marginheight="0">
		<xsl:apply-templates select="law"/>
	</body>
</html>
</xsl:template>

<!-- 연혁 template 시작 -->

<xsl:template match="history">
<form name="revi" method="post">
<input type="hidden" name="Bookid"/>
<input type="hidden" name="Obookid"/>
<input type="hidden" name="Statecd"/>
<input type="hidden" name="ListS"/>
<input type="hidden" name="type"/>

	<!-- 내규 전체 제목 -->
	<xsl:for-each select="./hisitem">
	    <!-- 
	    <xsl:if test="./@bookid=$bookid">
			<p class="타이틀_01"><strong><xsl:value-of select="@title"/></strong></p><p>&amp;nbsp;</p>
			<br/>
		</xsl:if>
		-->
<!--
		<xsl:if test="./@bookid=$bookid or $allGongpoil='Y'">
			<p class="공포일_02">
			    <xsl:value-of select="./@prtTitle"/>
			</p>
		</xsl:if>
		-->
	</xsl:for-each>
	
	
</form>
</xsl:template>

<!-- 연혁 template 끝 -->

<!-- 내규 template 시작 -->

<!-- 편 / 장 / 절 / 관 / 조 template -->

<xsl:template match="pyun">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<xsl:if test="./@print='Y' or $ALLFILE ='ALLFILE'">
		<p class="장절_03">
		<strong>제<xsl:value-of select="./@contno"/>편 <xsl:value-of select="./@title"/>
		<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
		</strong></p>
		<br/>
		</xsl:if>
	<xsl:apply-templates select="jang|jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
	
</xsl:template>



<xsl:template match="jang">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	        <xsl:if test="./@print='Y' or $ALLFILE ='ALLFILE'">
		<p class="장절_03">
		<strong>
			제<xsl:value-of select="./@contno"/>장<xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if>
		 	&amp;nbsp;<xsl:value-of select="./@title"/>
			<!--<br/><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>-->
		</strong>
		</p>
		<br/>&amp;nbsp;
		</xsl:if>
	<xsl:apply-templates select="jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jeol">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
                <xsl:if test="./@print='Y' or $ALLFILE ='ALLFILE'">
		<p class="장절_03">
		<strong>
			제<xsl:value-of select="./@contno"/>절 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> 
			&amp;nbsp;<xsl:value-of select="./@title"/>
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
		</strong>
		</p>
		<br/>
		</xsl:if>
	<xsl:apply-templates select="gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="gwan">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	        <xsl:if test="./@print='Y' or $ALLFILE ='ALLFILE'">
		<p class="장절_03"><strong>
			제<xsl:value-of select="./@contno"/>관  <xsl:value-of select="./@title"/>
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
			</strong></p>
			<br/>
			</xsl:if>
	<xsl:apply-templates select="jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jo">
		<xsl:for-each select=".">
			<xsl:if test="./@endcha&gt;=$revcha">
			<xsl:if test="./@startcha&lt;=$revcha">
     			<xsl:if test="./@print='Y' or $ALLFILE ='ALLFILE'">
			<xsl:if test="./@curstate != 'delete'">
			    
				<p class="조내용N">
				<xsl:if test="./@title !=''">
					<span  class="joTitle">제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
							<xsl:if test="./@curstate != 'deletemark'">(<xsl:value-of select="@title"/>)
							</xsl:if>
					</span>
				</xsl:if>
				    <xsl:if test="./@startcha =$revcha and ./@curstate ='new'">$cc$</xsl:if> 
					<span  class="조내용N">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
					</span>
					<xsl:choose> 
						<xsl:when test="./cont/text()!=''">
							<div>
								<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="./@startcha =$revcha and ./@curstate ='new'">#cc#</xsl:if>
					<xsl:if test="@revisiontag!='' and $showTag ='Y'">
					<!--<div><span style="color:blue;font-size:12pt;"><xsl:value-of select="@revisiontag"/></span></div>-->
					<div><span class="jotag"><xsl:value-of select="@revisiontag"/></span></div>
					</xsl:if>
				</p>
				<br/>
			</xsl:if>
			</xsl:if>
			</xsl:if>
			</xsl:if>
		</xsl:for-each>
</xsl:template>

<!-- 부칙 -->

<xsl:template match="buchick">

	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<xsl:if test="./@print='Y' or $ALLFILE ='ALLFILE'">
		<xsl:for-each select=".">
		<p class="부칙_10" >
			<strong><xsl:value-of select="@prtTitle"/></strong>
		</p>
		</xsl:for-each>
	</xsl:if>
	</xsl:if> 
	</xsl:if>
	<!--
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	-->
	<xsl:if test="./@print='Y' or $ALLFILE ='ALLFILE'">
		<xsl:for-each select="./jo">
			<p class="조내용N">
			<span  class="joTitle"><xsl:value-of select="@prtTitle"/></span><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text> 
			<!--
			<xsl:if test="@title !=''">
				<strong>제<xsl:value-of select="@contno"/>조
				    <xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if> 
					<xsl:choose> 
						<xsl:when test="contains(./cont/text(),'본조 삭제')">
				        	<br/>&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;
				    	</xsl:when>
					    <xsl:otherwise>
					    	<xsl:choose> 
					    	<xsl:when test="@title=''">
					    		<br>&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</br>
					    	</xsl:when>
					    	<xsl:otherwise>
								(<xsl:value-of select="@title"/>)
					    	</xsl:otherwise>
					    	</xsl:choose> 
					    </xsl:otherwise>
				    </xsl:choose> 
				</strong>
			</xsl:if> 
			-->
				<span  class="조내용N">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				</span>
				<xsl:choose> 
					<xsl:when test="./cont/text()!=''">
						<div class="조내용N">
							<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</p>
		</xsl:for-each>
		<p style="font-family:'신명조'; text-align:left;font-size:12pt;line-height:180%;">
			<xsl:call-template name="etc">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/><br/>
		</p>
	</xsl:if>
	<!--
	</xsl:if>
	</xsl:if>
	-->
	
</xsl:template>

<!-- 내용 -->

<xsl:template match="cont/text()" mode="link">
	<xsl:value-of select="."/><!--  disable-output-escaping="yes" -->
</xsl:template> 

<!-- bylaw -->

<xsl:template match="cont/law" mode="link">
        <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="cont/bylaw" mode="link">
	<xsl:value-of select="."/>
</xsl:template>

<!-- 이미지 <image border="0" hspace="0" alt="" align="baseline" src="100017863.PNG" width="442" height="387" style="HEIGHT: 387px; WIDTH: 442px" />-->

<xsl:template match="image" >
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
		<xsl:apply-templates select="." mode="link"/>
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
	<img><xsl:attribute name="src">/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
	<xsl:attribute name="height"><xsl:value-of select="./@height"/></xsl:attribute>
	<xsl:attribute name="width"><xsl:value-of select="./@width"/></xsl:attribute>
	</img>
		<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
</xsl:template>
	
<!-- 이미지 -->

<xsl:template match="image" >
	<table cellpadding='0' cellspacing='0' border='0'>
	<tr><td>
		<xsl:apply-templates select="." mode="link"/>
	</td></tr>
	</table>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>

	<img><xsl:attribute name="src"><xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
	<xsl:attribute name="height"><xsl:value-of select="./@height"/></xsl:attribute>
	<xsl:attribute name="width"><xsl:value-of select="./@width"/></xsl:attribute>
	</img>
		<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
</xsl:template>
	
<xsl:template match="cont/img" mode="link">
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if> 
        <img>
		<xsl:attribute name="src">
			<xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/>
		</xsl:attribute>
		<xsl:attribute name="align">
			<xsl:value-of select="@align"/>
		</xsl:attribute>
        </img>
			<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
</xsl:template>

<xsl:template match="cont/a5b5" mode="link">
<br>&amp;nbsp;</br>
</xsl:template>

<xsl:template match="hang" mode="link">
	<xsl:choose> 
		<xsl:when test=" (position() =1) and local-name(parent::*)='jo'">
			<span class="조내용N">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
				<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
				</xsl:if>
			</span>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose> 
				<xsl:when test="local-name(parent::*)='buchick'">
					<span class="항_05">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@tag!=''  and $showTag ='Y'">
						<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
					</span>
					<br/>
				</xsl:when>
				<xsl:otherwise>
					<div class="항_05"><!-- margin-left:10.0pt; -->
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
						<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="ho|mok|dan" mode="link"/>
</xsl:template>	

<xsl:template match="ho" mode="link">
	<xsl:choose> 
		<xsl:when test=" (position() =1) and local-name(parent::*)='jo'">
			<xsl:choose> 
				<xsl:when test="../cont=''">
					<span class="호_06">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
						<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<div class="호_06">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
						<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<div class="호_06">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				<xsl:if test="./@tag!='' and $showTag ='Y'">
				<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./@tag"/></span>
				</xsl:if>
			</div>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="mok|dan" mode="link"/>
</xsl:template>	
<xsl:template match="mok" mode="link">
	<xsl:choose> 
		<xsl:when test=" (position() =1) and local-name(parent::*)='jo'">
			<xsl:choose> 
				<xsl:when test="../cont=''">
					<span class="목_07">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
						<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<div class="목_07">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
						<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<div class="목_07">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
				<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
				</xsl:if>
			</div>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="dan" mode="link"/>
</xsl:template>	
<xsl:template match="dan" mode="link">
	<xsl:choose> 
		<xsl:when test=" (position() =1) and local-name(parent::*)='jo'">
			<xsl:choose> 
				<xsl:when test="../cont=''">
					<span class="단_08">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
						<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<div class="단_08">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
						<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
					</div>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:when>
		<xsl:otherwise>
			<div class="단_08">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				<xsl:if test="./cont/@tag!='' and $showTag ='Y'">
						<span class="hangtag"><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
			</div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>	
<xsl:template name="etc">	
	<xsl:param name="param" select="."/>
	<xsl:apply-templates select="hang|ho|mok|dan" mode="link"/>
</xsl:template>
<xsl:template match="cont/table" mode="link">
	<xsl:value-of select="." disable-output-escaping="yes"/>
    <xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
</xsl:template>	
</xsl:stylesheet>