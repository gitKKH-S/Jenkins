<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="endcha" />
<xsl:param name="FileDownURL" />
<xsl:param name="ImageURL" />
<xsl:param name="LawKoreaURL" />
<xsl:param name="BylawURL" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- 내규 template 시작 -->

<xsl:template match="/">
	<html>
		<head>
			<style type="text/css">
				<!-- 제목 p class="title --> 
				.jonumber {font-size:16px; font-weight:bold; color:#0066CC;}
				.jotitle {font-size:16px; font-weight:bold; color:#0066CC;}
				.title { font-size:15pt; font-weight:bold; text-align:center; border-bottom:#CCC 1px solid; padding:5px 0 5px 0; margin: 5px 0 0 0;}
				.pyun { font-size:15px; font-weight:bold; padding:10px 0 0 0; text-align:center }
				.jang { font-size:14px; font-weight:bold; padding:3px 0 3px 0; border-bottom:1px dotted #CCC; text-align:center}
				.jeol { font-size:13px; font-weight:bold; padding:3px 0 3px 0px;  text-align:center }
				.gwan { font-size:12px; font-weight:bold; padding:3px 0 3px 0px; text-align:center }
				.mten { text-decoration:underline; color:red;}
				<!-- div id="mok" --> 
				#jo { font-size:12px; margin:4px 0 8px 20px; }
				#jo STRONG { color:#06C; font-weight:bold; }

				#startdt { font-size:12px; margin:0px 0px 0px 45px; }
				#startdt STRONG { color:#A297BD; font-weight:bold; }
				#startdtcur { font-size:12px; margin:0px 0px 0px 45px; }
				#startdtcur STRONG { color:#FFB0D9; font-weight:bold; }

				.histIcon {float:left;margin:3px 0 0 3px; border:0; cursor:pointer;}
				#ho { font-size:12px; margin:0 0 3px 30px; text-indent:-1.2em;}
				#mok { font-size:12px; margin:0 0 2px 50px; text-indent:-1.2em;}
				#dan { font-size:12px; margin:0 0 2px 70px; text-indent:-1.2em;}

				.jocont_guent {font-size:12px; TEXT-ALIGN:justify;}		
				.buchik_title {font-size:14px; font-weight:bold; padding:5px 0 3px 20px; border-bottom:1px dotted #CCC;}


				.byultext 
				{
					 margin:2 0 0 0;background:url(/kribblaw/jsp/lkms3/images/common/icon_file.gif) left center no-repeat;
				}
				.byulText SPAN {font-size:12px; margin:0 0 0 25px; font-weight:bold; color:#03C;}						
					
				
				
				.history {font-size:9pt; color:"#007099"}
				.attachedtitle {font-size:10pt; font-weight:bold;}
				.preambletitle {font-size:10pt; font-weight:bold;}
				.preamble {font-size:10pt; TEXT-ALIGN:justify;}			
				
				.nomalcont_guent {font-size:9pt; TEXT-ALIGN:justify;}
				.fixedcont_guent {line-height:100%; font-size:9pt;margin-top:10px; margin-bottom:10px;}
				.tableLine1 {border: 1px solid #31639C;}
				.tableLine2 {border: 1px solid #ED8A38;}
				.tableLine3 {border: 1px solid #7D7D7D;}
				.list5 {text-decoration: "none"; font-size: "9pt";  color: "#006666"; line-height: "14pt";}
				.list5:hover { text-decoration: "none"; color: "#999900";}
				.list6 {text-decoration: "none"; font-size: "9pt";  color: "#990033"; line-height: "14pt";}
				.list6:hover { text-decoration: "none"; color: "orange";}
				.list7 {text-decoration: "none"; color: "#006666"; font-size: "9pt";  }
				.list7:hover { text-decoration: "underline"; color: "#999900";}
				.listLink {text-decoration: "underline"; font-size: "9pt";  color: "006666"; line-height: "14pt"; font-weight:bold;}
				.listLink:hover {text-decoration: "underline"; color: "orange"; font-weight:bold;}

			</style>
		</head>
		<body>
			<xsl:apply-templates select="law"/>
		</body>
	</html>
</xsl:template>

<!-- 편 / 장 / 절 / 관 / 조 template -->

<xsl:template match="law">
	<table class="singuTable" width="100%" border="0">
	<xsl:apply-templates select="bon|pyun|jang|jeol|gwan|jo|byullist"/>	
	</table>
</xsl:template>

<xsl:template match="bon">
	<xsl:apply-templates select="pyun|jang|jeol|gwan|jo"/>
</xsl:template>

<xsl:template match="jang">
<xsl:if  test="./@startcha &lt;= $revcha">
<xsl:if  test="./@endcha &gt;= $revcha">
	<xsl:apply-templates select="jeol|gwan|jo"/>
</xsl:if>
</xsl:if>
</xsl:template>

<xsl:template match="jeol">
<xsl:if  test="./@startcha &lt;= $revcha">
<xsl:if  test="./@endcha &gt;= $revcha">
	<xsl:apply-templates select="gwan|jo"/>
</xsl:if>
</xsl:if>	
</xsl:template>

<xsl:template match="gwan">
	<xsl:apply-templates select="jo"/>	
</xsl:template>

<xsl:template match="jo">
<xsl:if  test="./@startcha =$revcha">
<tr>
	<xsl:apply-templates select="old|new" mode="link"/>
</tr>
</xsl:if>
</xsl:template>    

<xsl:template match="old" mode="link">
<td valign="top" width="50%" bgcolor="#f4f4f4" style="padding:5px; line-height:1.4em;">
	<span class="jonumber"><strong>제<xsl:value-of select="../@f_contno"/>조<xsl:if test="../@f_contsubno!='0'">의<xsl:value-of select="../@f_contsubno"/></xsl:if>(<xsl:value-of select="../@f_title"/>)</strong></span>
	<xsl:apply-templates select="hang|ho|mok|dan|cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
	<div><xsl:value-of select="text()"/></div>
</td>
</xsl:template>    

<xsl:template match="new" mode="link">
<td valign="top" style="padding:5px; line-height:1.4em;" width="50%">
	<span class="jonumber"><strong>제<xsl:value-of select="../@contno"/>조<xsl:if test="../@contsubno!='0'"> 의<xsl:value-of select="../@contsubno"/></xsl:if>(<xsl:value-of select="../@title"/>)</strong></span>
	<xsl:apply-templates select="hang|ho|mok|dan|cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
</td>
</xsl:template> 

<xsl:template match="hang" mode="link">
	<xsl:choose> 
		<xsl:when test=" (position() =1) and local-name(parent::*)='new|old'">
			<span style=" text-align:justify; font-size:10pt; ">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
			</span>
		</xsl:when>
		<xsl:otherwise>
			<div style="margin-left:10.0pt; text-align:justify; font-size:10pt;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
			</div>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="ho|mok|dan" mode="link"/>
</xsl:template>	
<xsl:template match="ho" mode="link">
	<xsl:choose> 
		<xsl:when test=" (position() =1) and local-name(parent::*)='new|old'">
			<xsl:choose> 
				<xsl:when test="../cont=''">
					<span style=" text-align:justify; font-size:10pt; ">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<div style="margin-left:20.0pt; text-align:justify; font-size:10pt; ">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<div style="margin-left:20.0pt; text-align:justify; font-size:10pt;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
			</div>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="mok|dan" mode="link"/>
</xsl:template>	
<xsl:template match="mok" mode="link">
	<xsl:choose> 
		<xsl:when test=" (position() =1) and local-name(parent::*)='new|old'">
			<xsl:choose> 
				<xsl:when test="../cont=''">
					<span style=" text-align:justify; font-size:10pt; ">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<div style="margin-left:30.0pt; text-align:justify; font-size:10pt; ">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<div style="margin-left:30.0pt; text-align:justify; font-size:10pt;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
			</div>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="dan" mode="link"/>
</xsl:template>	
<xsl:template match="dan" mode="link">
	<xsl:choose> 
		<xsl:when test=" (position() =1) and local-name(parent::*)='new|old'">
			<xsl:choose> 
				<xsl:when test="../cont=''">
					<span style=" text-align:justify; font-size:10pt; ">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<div style="margin-left:40.0pt; text-align:justify; font-size:10pt; ">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:when>
		<xsl:otherwise>
			<div style="margin-left:40.0pt; text-align:justify; font-size:10pt;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/> <xsl:value-of select="@tag"/>
			</div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>	

<xsl:template match="cont/span" mode="link">
	<xsl:element name="span">
	<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
		<xsl:value-of select="text()"/>
		<xsl:apply-templates select="table" mode="tt"/>
		<xsl:apply-templates select="image" mode="link"/>
	</xsl:element>
</xsl:template>

<xsl:template match="cont/text()" mode="link">
	<xsl:value-of select="." disable-output-escaping="yes" />
</xsl:template> 

<!-- bylaw -->

<xsl:template match="cont/law" mode="link">
        <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="cont/bylaw" mode="link">
	<xsl:value-of select="."/>
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
	<table cellpadding='0' cellspacing='0' border='0'>
	<tr><td>
		<p><img><xsl:attribute name="src">http://law.kwater.or.kr/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img></p>
	</td></tr>
	</table>
</xsl:template>
	
<xsl:template match="cont/img" mode="link">
	<div>
        <img>
			<xsl:attribute name="src">http://law.kwater.or.kr/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute>
			<xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
			<xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="@alt"/></xsl:attribute>
        </img>
     </div>
</xsl:template>

<xsl:template match="cont/a5b5" mode="link">
<br>&amp;nbsp;</br>
</xsl:template>	
<xsl:template match="cont/table" mode="link">
	<xsl:value-of select="." disable-output-escaping="yes"/>
</xsl:template>	 
<xsl:template match="table" mode="tt">
	<xsl:value-of select="." disable-output-escaping="yes"/>
</xsl:template>	
<xsl:template match="byullist">
	<xsl:apply-templates select="byulji|byulch|byul" mode="link"/>
</xsl:template>
<xsl:template match="byulji|byulch|byul" mode="link">
	<xsl:if  test="./@startcha =$revcha">
		<tr>
			<xsl:apply-templates select="old|new" mode="byul"/>
		</tr>
	</xsl:if>
</xsl:template>	
<xsl:template match="old" mode="byul">
	<td valign="top" width="50%" bgcolor="#f4f4f4" style="padding:5px; line-height:1.4em;">
		<xsl:apply-templates select="byulji|byulch|byul" mode="byul"/>
		<div><xsl:value-of select="text()"/></div>
	</td>
</xsl:template>	
<xsl:template match="new" mode="byul">
	<td valign="top" width="50%" style="padding:5px; line-height:1.4em;">
		<xsl:apply-templates select="byulji|byulch|byul" mode="byul"/>
	</td>
</xsl:template>
<xsl:template match="byulji|byulch|byul" mode="byul">
	<xsl:value-of select="./@showtitle"/>
</xsl:template>		
</xsl:stylesheet>
