<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="ImageURL" />
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
			<script langage="javascript">
					function downpage(Pcfilename,Serverfile,folder,FileDownURL){
						form=document.ViewForm;
						form.Pcfilename.value=Pcfilename;
						form.Serverfile.value=Serverfile;
						form.folder.value=folder;
						form.action=FileDownURL;
						form.submit();
					}
					function link(lawcode,jo,url){
						//새창의 크기
						 cw=562;
						 ch=420;
						  //스크린의 크기
						 sw=screen.availWidth;
						 sh=screen.availHeight;
						 //열 창의 포지션
						 px=(sw-cw)/2;
						 py=(sh-ch)/2;
						 //창을 여는부분		
						property="left="+px+",top="+py+",width=562,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no";
						window.open(url+"?Bookid="+lawcode+"#"+jo, "ocase",property);
					}

					function link_law(lawcode,jo,url){
						//새창의 크기
						 cw=880;
						 ch=670;
						  //스크린의 크기
						 sw=screen.availWidth;
						 sh=screen.availHeight;
						 //열 창의 포지션
						 px=(sw-cw)/2;
						 py=(sh-ch)/2;
						 //창을 여는부분		
						property="left="+px+",top="+py+",width=880,height=670,scrollbars=yes,resizable=no,status=no,toolbar=no";
						window.open(url+"?type=l&amp;fontsize=14&amp;lawcode="+lawcode+"&amp;jo="+jo, "ocase", property);
					}
			</script>
		</head>
		<body>
			<form name="ViewForm" method="post">
				<input type="hidden" name="Bookid"/>
				<input type="hidden" name="Obookid"/>
				<input type="hidden" name="Statecd"/>
				<input type="hidden" name="ListS"/>
				<input type="hidden" name="type"/>
				<input type="hidden" name="folder"/>
				<input type="hidden" name="Serverfile"/>
				<input type="hidden" name="Pcfilename"/>
			</form>
			<xsl:apply-templates select="bon"/>
			<xsl:apply-templates select="law"/>
			<xsl:apply-templates select="pyun"/>
			<xsl:apply-templates select="jang"/>
			<xsl:apply-templates select="jeol"/>
			<xsl:apply-templates select="gwan"/>
			<xsl:apply-templates select="jo"/>
			<xsl:apply-templates select="buchicklist"/>
			<xsl:apply-templates select="buchick"/>
			<xsl:apply-templates select="byullist"/>
			<xsl:apply-templates select="byul"/>
			<xsl:apply-templates select="byulch"/>	
			<xsl:apply-templates select="byulji"/>	
		</body>
	</html>
</xsl:template>

<!-- 편 / 장 / 절 / 관 / 조 template -->

<xsl:template match="law">
	<table  align="center" border="0">
	<xsl:apply-templates select="bon|pyun|jang|jeol|gwan|jo"/>	
	</table>
</xsl:template>

<xsl:template match="bon">
	<table  align="center" border="0">
	<xsl:apply-templates select="pyun|jang|jeol|gwan|jo"/>	
	</table>
</xsl:template>

<xsl:template match="jang">
	<table  align="center" border="0">
	<xsl:apply-templates select="jeol|gwan|jo"/>	
	</table>
</xsl:template>

<xsl:template match="jo">
<tr>
	<xsl:for-each select=".">
	<table  align="center"  border="1">
	<tr>
		<xsl:apply-templates select="hang|ho|mok|dan|image|all_sin|all_gu|cont_gu|cont_sinbar"/>
		</tr>
		</table>
     </xsl:for-each>
     </tr>
</xsl:template>    



<xsl:template match="hang">
    <xsl:for-each select=".">
	<tr>
		<xsl:apply-templates select="cont|cont_gu|cont_sinbar|ho|mok|dan|image"/>
		</tr>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="ho">
    <xsl:for-each select=".">
	<tr>
		<xsl:apply-templates select="cont|cont_gu|cont_sinbar|mok|dan|image"/>
		</tr>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok">
    <xsl:for-each select=".">
	<tr>
		<xsl:apply-templates select="cont|cont_gu|cont_sinbar|dan|image"/>
		</tr>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan">
    <xsl:for-each select=".">
    <tr>
		<xsl:apply-templates select="cont|cont_gu|cont_sinbar|image"/>
		</tr>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont_gu" >
    <xsl:for-each select="."> 
        <td valign="top" width="50%">  
		<xsl:apply-templates select="./text()|FONT" mode="col"/>
		<xsl:apply-templates select="image"/>
		</td>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont_sinbar" >
    <xsl:for-each select=".">
        <td valign="top" width="50%">  
		<xsl:apply-templates select="./text()|FONT" mode="col"/>
		<xsl:apply-templates select="image"/>
		</td>
     </xsl:for-each>
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
		<xsl:apply-templates select="cont|hang|ho|mok|dan|image" mode="all"/>
     </xsl:for-each>
    </td>
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
	<table cellpadding='0' cellspacing='0' border='0'>
	<tr><td>
			<img>
				<xsl:attribute name="src">
					<xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/>
				</xsl:attribute>
				<xsl:attribute name="align">
					<xsl:value-of select="@align"/>
				</xsl:attribute>
			</img>
	</td></tr>
	</table>
</xsl:template>

<xsl:template match="cont_gu/img" mode="link">
	<div>
			<img>
				<xsl:attribute name="src">
					<xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/>
				</xsl:attribute>
				<xsl:attribute name="align">
					<xsl:value-of select="@align"/>
				</xsl:attribute>
			</img>
	</div>
</xsl:template>

</xsl:stylesheet>
