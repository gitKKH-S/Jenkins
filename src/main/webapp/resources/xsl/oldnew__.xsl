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
					 margin:2 0 0 0;background:url(/kribblaw/jsp/lkms3/images/common/icon_file.giff) left center no-repeat;
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
	<xsl:apply-templates select="jeol|gwan|jo"/>	
</xsl:template>

<xsl:template match="jeol">
	<xsl:apply-templates select="gwan|jo"/>	
</xsl:template>

<xsl:template match="gwan">
	<xsl:apply-templates select="jo"/>	
</xsl:template>

<xsl:template match="jo">
	<xsl:for-each select=".">
		<xsl:if  test="./@startcha =$revcha">
			<xsl:apply-templates select="gaejung"/>
		</xsl:if>
	</xsl:for-each>
</xsl:template>    

<xsl:template match="gaejung">
	<xsl:for-each select=".">
		<xsl:apply-templates select="jo" mode="real"/>
     </xsl:for-each>
</xsl:template>    

<xsl:template match="jo" mode="real">
	<xsl:for-each select=".">
		<tr>
			<td bgcolor="#f4f4f4" style="padding:5px; line-height:1.4em;">
				<xsl:if test="./@state!='new'">
					<strong>제<xsl:value-of select="@f_contno"/>조<xsl:if test="./@f_contsubno>0">의<xsl:value-of select="@f_contsubno"/></xsl:if>
					(<xsl:value-of select="@f_title"/>)
					</strong>
				</xsl:if>

			</td>
			<td width="50%" bgcolor="#f4f4f4" style="padding:5px; line-height:1.4em;">
				<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
			(<xsl:value-of select="@title"/>)
			</strong>
			<xsl:if test="./@state='new'">신설</xsl:if>
			<xsl:if test="./@state='revision'">개정</xsl:if>
			<xsl:if test="./@state='allrevision'">전부개정</xsl:if>
			<xsl:if test="./@state='delete'">삭제</xsl:if>
			</td>
		</tr>
		<xsl:apply-templates select="hang|ho|mok|dan|image|cont_gu|cont_sin"/>
		<xsl:apply-templates select="all_sin|all_gu"/>
	</xsl:for-each>
</xsl:template>    


<xsl:template match="hang">
	<xsl:for-each select=".">
	<tr>
		<xsl:apply-templates select="cont|cont_gu|cont_sin|ho|mok|dan|image"/>
		<xsl:value-of select="@tag"/>
	</tr>
	</xsl:for-each>
</xsl:template>     

<xsl:template match="ho">
    <xsl:for-each select=".">
	<tr>
		<xsl:apply-templates select="cont|cont_gu|cont_sin|mok|dan|image"/>
		</tr>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok">
    <xsl:for-each select=".">
	<tr>
		<xsl:apply-templates select="cont|cont_gu|cont_sin|dan|image"/>
		</tr>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan">
    <xsl:for-each select=".">
    <tr>
		<xsl:apply-templates select="cont|cont_gu|cont_sin|image"/>
		</tr>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont_gu" >
    <xsl:for-each select="."> 
        <td width="50%" bgcolor="#f4f4f4" style="padding:5px; line-height:1.4em;">
		<xsl:apply-templates select="./text()|FONT|span" mode="col"/>
		<xsl:apply-templates select="image"/>
		</td>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont_sin" >
    <xsl:for-each select=".">
        <td style="padding:5px; line-height:1.4em;" width="50%">
		<xsl:apply-templates select="./text()|FONT|span" mode="col"/>
		<xsl:apply-templates select="image"/>
		</td>
     </xsl:for-each>
</xsl:template>     
<xsl:template match="span" mode="col">
	<xsl:element name="span">
	<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>
<xsl:template match="all_sin">
<td valign="top"  width="50%">  
	<xsl:for-each select=".">
		<xsl:apply-templates select="cont|hang|ho|mok|dan|image" mode="all"/>
     </xsl:for-each>
   </td>
</xsl:template>     

<xsl:template match="all_gu">
<td valign="top" width="50%">  
	<xsl:for-each select=".">
		<xsl:apply-templates select="./text()|cont|hang|ho|mok|dan|image" mode="all"/>
     </xsl:for-each>
    </td>
</xsl:template>     

<xsl:template match="byullist">
	<xsl:apply-templates select="byul|byulch|byulji"/>	
</xsl:template>

<xsl:template match="byul">
<xsl:if test="./@singugbn='gaejung'">
	<xsl:if test="./@startcha=$revcha">
<tr>
		<xsl:apply-templates select="./text()|all_gu|all_sin" mode="byul"/>
		</tr>
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="byulji">
<xsl:if test="./@singugbn='gaejung'">
	<xsl:if test="./@startcha=$revcha">
<tr>
		<xsl:apply-templates select="./text()|all_gu|all_sin" mode="byul"/>
		</tr>
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="byulch">
<xsl:if test="./@singugbn='gaejung'">
	<xsl:if test="./@startcha=$revcha">
<tr>
		<xsl:apply-templates select="./text()|all_gu|all_sin" mode="byul"/>
		</tr>
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="all_sin" mode="byul">
	<td style="padding:5px; line-height:1.4em;" width="50%">
	<xsl:for-each select=".">
	
		<xsl:apply-templates select="byul|byulji|byulch" mode="real"/>
		
     </xsl:for-each>
   </td>
</xsl:template>     

<xsl:template match="all_gu"  mode="byul">
	<td width="50%" bgcolor="#f4f4f4" style="padding:5px; line-height:1.4em;">
	<xsl:for-each select=".">
	
		<xsl:apply-templates select="byul|byulji|byulch" mode="real"/>
		
     </xsl:for-each>
    </td>
</xsl:template>     

<xsl:template match="byul" mode="real">
	<xsl:call-template name="allbyul">
					<xsl:with-param name="param" select="."/>
				</xsl:call-template>
</xsl:template>

<xsl:template match="byulji" mode="real">
	<xsl:call-template name="allbyul">
					<xsl:with-param name="param" select="."/>
				</xsl:call-template>
</xsl:template>

<xsl:template match="byulch" mode="real">
	<xsl:call-template name="allbyul">
					<xsl:with-param name="param" select="."/>
				</xsl:call-template>
</xsl:template>

<xsl:template name="allbyul">
	<xsl:value-of select="./@showtitle"/>-<xsl:value-of select="./@pcfilename"/>
</xsl:template>

<xsl:template match="cont" >
    <xsl:for-each select=".">
      <xsl:if test="./@gbn ='cont_new'">
        <td valign="top"  width="50%">  
		<xsl:apply-templates select="./text()|FONT" mode="col"/>
		<xsl:apply-templates select="image"/>
		</td>
      </xsl:if>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="text()" mode="link">
   	<xsl:value-of select="."/>
</xsl:template> 

<xsl:template match="cont" mode="all">
    <xsl:for-each select=".">
       <br/>
		<xsl:apply-templates select="./text()|FONT" mode="col"/>
		<xsl:apply-templates select="image"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="FONT" mode="col">
    <xsl:for-each select=".">
		<br/>66<xsl:apply-templates select="."/>
     </xsl:for-each>
</xsl:template>     

<!-- 이미지 -->

<xsl:template match="image" >
	<div>
	       <img>
	         <xsl:attribute name="src">
	           <xsl:value-of select="./@src"/>
	         </xsl:attribute>
	         <xsl:attribute name="align">
	           <xsl:value-of select="@align"/>
	         </xsl:attribute>
	         <xsl:attribute name="style">
	           <xsl:value-of select="@style"/>
	         </xsl:attribute>
	         <xsl:attribute name="alt">
	           <xsl:value-of select="@alt"/>
	         </xsl:attribute>
	       </img>
	</div>
</xsl:template>

<xsl:template match="cont_gu/img" mode="link">
	<div>
	       <img>
	         <xsl:attribute name="src">
	           <xsl:value-of select="./@src"/>
	         </xsl:attribute>
	         <xsl:attribute name="align">
	           <xsl:value-of select="@align"/>
	         </xsl:attribute>
	         <xsl:attribute name="style">
	           <xsl:value-of select="@style"/>
	         </xsl:attribute>
	         <xsl:attribute name="alt">
	           <xsl:value-of select="@alt"/>
	         </xsl:attribute>
	       </img>
	</div>
</xsl:template>


</xsl:stylesheet>
