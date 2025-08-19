<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="bookid" />
<xsl:param name="startcha" />
<xsl:param name="endcha" />
<xsl:param name="DownLoadFile" />
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

				.jocontent {font-size:12px; TEXT-ALIGN:justify;}		
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
				
				.nomalcontent {font-size:9pt; TEXT-ALIGN:justify;}
				.fixedcontent {line-height:100%; font-size:9pt;margin-top:10px; margin-bottom:10px;}
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
					function downpage(Pcfilename,Serverfile,folder,DownLoadFile){
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
						window.open("http://192.25.84.36:8080/bpalaw/jsp/bylaw/existing/hwp.jsp?fileUrl="+Serverfile+"&amp;folder="+folder,"download",property);
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
					function goPop(id){
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
					 window.open('http://lms.kwater.or.kr/jsp/bylaw/dllreq/alPop.jsp?id='+id,'bbspop',property);
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
		</body>
	</html>
</xsl:template>

<!-- 편 / 장 / 절 / 관 / 조 template -->

<xsl:template match="law">
	<xsl:for-each select="history/hisitem">
		<xsl:if test="./@bookid=$bookid">
			<p class="title"><xsl:value-of select="@title"/>
				<span id="startdtcur"><strong>
					(<xsl:value-of select="@bookcd"/><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="@bookcode"/><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					<xsl:if test="@revcd!='제정'">
						제<xsl:value-of select="@revcha"/>차
					</xsl:if>
					<xsl:value-of select="@revcd"/><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					<xsl:value-of select="@promuldt"/><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					<xsl:value-of select="@statecd"/>)
				</strong></span>
			</p>
		</xsl:if>
	</xsl:for-each>
	<xsl:apply-templates select="history|bon|buchicklist|jo"/>	
</xsl:template>

<xsl:template match="pyun">
	<xsl:if test="@startcha &lt;= $startcha"><xsl:if test="@endcha &gt;= $endcha">
		<p class="pyun">
			제<xsl:value-of select="./@contno"/>편
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
				<xsl:if test="@curstate!='deletemark'">
					<xsl:value-of select="./@title"/>
				</xsl:if>
				<xsl:value-of select="@showtag"/>
			<!--
			<xsl:choose>
				<xsl:when test="@endcha =9999"> 
					<span id="startdtcur"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span id="startdt"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</span>
				</xsl:otherwise>
			</xsl:choose>
			-->
		</p>
		<xsl:apply-templates select="jang|jeol|gwan|jo"/>
	</xsl:if></xsl:if>
</xsl:template>

<xsl:template match="jang">
	<xsl:if test="@startcha &lt;= $startcha"><xsl:if test="@endcha &gt;= $endcha">
		<p class="jang">
			제<xsl:value-of select="./@contno"/>장<xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if>
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>

			<xsl:value-of select="./@title"/><xsl:value-of select="@showtag"/>
			<!--
			<xsl:choose>
				<xsl:when test="@endcha =9999"> 
					<span id="startdtcur"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span id="startdt"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</span>
				</xsl:otherwise>
			</xsl:choose>
			-->
		</p>
		<!--<xsl:if test="@curstate !='deletemark'"><xsl:if test="@curstate !='delete'"><xsl:apply-templates select="jeol|gwan|jo"/></xsl:if></xsl:if>-->
		<xsl:apply-templates select="jeol|gwan|jo"/>
	</xsl:if></xsl:if>
</xsl:template>

<xsl:template match="jeol">
	<xsl:if test="@startcha &lt;= $startcha"><xsl:if test="@endcha &gt;= $endcha">
		<p class="jeol">
			제<xsl:value-of select="./@contno"/>절<xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if>
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./@title"/><xsl:value-of select="@showtag"/>
			<!--
			<xsl:choose>
				<xsl:when test="@endcha =9999"> 
					<span id="startdtcur"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span id="startdt"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</span>
				</xsl:otherwise>
			</xsl:choose>
			-->
		</p>
		<xsl:apply-templates select="gwan|jo"/>
	</xsl:if></xsl:if>
</xsl:template>

<xsl:template match="gwan">
	<xsl:if test="@startcha &lt;= $startcha"><xsl:if test="@endcha &gt;= $endcha">
		<p class="gwan">
			제<xsl:value-of select="./@contno"/>관
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./@title"/><xsl:value-of select="@showtag"/>
			<!--
			<xsl:choose>
				<xsl:when test="@endcha =9999"> 
					<span id="startdtcur"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span id="startdt"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</span>
				</xsl:otherwise>
			</xsl:choose>
			-->
		</p>
		<xsl:apply-templates select="jo"/>
	</xsl:if></xsl:if>
</xsl:template>

<!-- 조 -->
<xsl:template match="jo">
	<xsl:for-each select=".">
		<xsl:if test="@startcha &lt;= $startcha"><xsl:if test="@endcha &gt;= $endcha">
			<!--
			<xsl:choose>
				<xsl:when test="@endcha =9999"> 
					<div id="startdtcur"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div id="startdt"><strong>
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)
						</strong>
					</div>
				</xsl:otherwise>
			</xsl:choose>
			-->
			<div id="jo">
				<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
				<xsl:if test="@curstate!='deletemark'">
					(<xsl:value-of select="@title"/>)
				</xsl:if>
				
				</strong>
				
				<xsl:apply-templates select="cont"/>
				
				<xsl:if test="./cont!=''"><br/></xsl:if>
				<xsl:call-template name="etc">
					<xsl:with-param name="param" select="."/>
				</xsl:call-template>
				<xsl:if test="@curstate!='deletemark'">
					<xsl:value-of select="@showtag"/>
				</xsl:if>
				<xsl:value-of select="@revisiontag"/>
			</div>
		</xsl:if></xsl:if>
	</xsl:for-each>
</xsl:template>




<!-- 별표 -->
<xsl:template match="byullist">
	<xsl:apply-templates select="byul"/>	
	<xsl:apply-templates select="byulch"/>	
	<xsl:apply-templates select="byulji"/>	
</xsl:template>

<!-- 부칙 -->
<xsl:template match="buchicklist">
	<xsl:apply-templates select="buchick"/>	
</xsl:template>

<xsl:template match="buchick">
	<p class="buchik_title">
		<xsl:for-each select=".">
			<xsl:value-of select="@title"/>        
		</xsl:for-each>
	</p>
	<div id="jo">
		
		
		<xsl:call-template name="etc">
			<xsl:with-param name="param" select="."/>
		</xsl:call-template>
		<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
		<br/>
		<xsl:for-each select="./jo">
			<strong>제<xsl:value-of select="@contno"/>조 <xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
			(<xsl:value-of select="@title"/>)
			</strong>

			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>

			<xsl:if test="./cont!=''"><br/></xsl:if>
			<xsl:call-template name="etc">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</div>
</xsl:template>

<!-- 별표 -->

<xsl:template name="byul">
		<xsl:for-each select=".">
		<xsl:if test="@startcha &lt;= $startcha"><xsl:if test="@endcha &gt;= $endcha">
		<xsl:choose> 
			<xsl:when test="./@serverfilename!=''">
				<p class="byulText">
					<xsl:element name="span">
						<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH','<xsl:value-of select="$DownLoadFile"/>');</xsl:attribute>
						<xsl:attribute name="style">cursor:pointer;</xsl:attribute>
						<xsl:value-of select="./@showtitle"/>-<xsl:value-of select="./@pcfilename"/>
					</xsl:element>
						<xsl:choose>
							<xsl:when test="@endcha =9999"> 
								<span id="startdtcur"><strong>
									<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
									<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)<xsl:value-of select="./@showtag"/>
									</strong>
								</span>
							</xsl:when>
							<xsl:otherwise>
								<span id="startdt"><strong>
									<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>시작일 (차수) : <xsl:value-of select="./@startdt"/> (<xsl:value-of select="./@startcha"/>) |
									<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>종료일 (차수) : <xsl:value-of select="./@enddt"/> (<xsl:value-of select="./@endcha"/>)<xsl:value-of select="./@showtag"/>
									</strong>
								</span>
							</xsl:otherwise>
						</xsl:choose> 
				</p>
			</xsl:when>
			<xsl:otherwise> 
				<span class="jocontent"><xsl:value-of select="./@showtitle"/></span>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:if></xsl:if>
		</xsl:for-each>   
</xsl:template>

<xsl:template match="byul">
	<xsl:call-template name="byul">
		<xsl:with-param name="param" select="."/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="byulch">
	<xsl:call-template name="byul">
		<xsl:with-param name="param" select="."/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="byulji">
	<xsl:call-template name="byul">
		<xsl:with-param name="param" select="."/>
	</xsl:call-template>
</xsl:template>

<!-- 내용 -->

<xsl:template match="cont">
    <xsl:for-each select=".">
		<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
		<xsl:apply-templates select="a5b5|text()|table|image"/>
		
     </xsl:for-each>
     <xsl:choose>
	<xsl:when test="@showtag!=''"> 
	   <xsl:value-of select="@showtag"/>
	</xsl:when>
	<xsl:otherwise>
	   <xsl:value-of select="@tag"/>
	</xsl:otherwise>
     </xsl:choose> 
</xsl:template>     

<xsl:template match="text()" mode="col">
   	<xsl:value-of select="."/><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
</xsl:template> 

<!-- 이미지 -->

<xsl:template match="image" >
	<table cellpadding='0' cellspacing='0' border='0'>
	<tr><td>
	<xsl:element name="image">
	        <xsl:if test="@style!=''">
			<xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
		</xsl:if>
	        <xsl:if test="@height!=''">
			<xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
		</xsl:if>
	        <xsl:if test="@width!=''">
			<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="contains(@src, ':')"> 
				<xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="src"><xsl:value-of select="$ImageURL"/><xsl:value-of select="@src"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose> 
		<xsl:attribute name="hspace"><xsl:value-of select="@hspace"/></xsl:attribute>
		<xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
	</xsl:element>
	</td></tr>
	</table>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
        
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if> 
	<xsl:element name="image">
	        <xsl:if test="@style!=''">
			<xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
		</xsl:if>
	        <xsl:if test="@height!=''">
			<xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
		</xsl:if>
	        <xsl:if test="@width!=''">
			<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="contains(@src, ':')"> 
				<xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="src"><xsl:value-of select="$ImageURL"/><xsl:value-of select="@src"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose> 
		<xsl:attribute name="hspace"><xsl:value-of select="@hspace"/></xsl:attribute>
		<xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
	</xsl:element>
</xsl:template>
	
<xsl:template match="cont/img" mode="link">
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>

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
</xsl:template>

<xsl:template match="a5b5">
<br/>
</xsl:template>	

<xsl:template name="etc">	
	<xsl:param name="param" select="."/>
	<xsl:for-each select="hang">
		<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
		<xsl:for-each select="ho">
			<div id="ho">
				<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
			</div>
			<xsl:for-each select="mok">
				<div id="mok" >
					<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
				</div>
				<xsl:for-each select="dan">
					<div id="dan" >
						<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
					</div>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="dan">
				<div id="dan" >
					<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="mok">
			<div id="mok">
				<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
			</div>
			<xsl:for-each select="dan">
				<div id="dan">
					<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="dan">
			<div class="dan" style="padding-left:20px;padding-top:5px">
				<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
			</div>
		</xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="ho">
		<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
		<xsl:for-each select="mok">
			<div id="mok">
				<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
			</div>
			<xsl:for-each select="dan">
				<div id="dan">
					<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="mok">
		<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
		<xsl:for-each select="dan">
			<div id="dan">
				<xsl:apply-templates select="cont"/><br/>
			</div>
		</xsl:for-each>
	</xsl:for-each>		
	<xsl:for-each select="dan">
		<xsl:apply-templates select="cont"/><xsl:value-of select="@showtag"/><br/>
	</xsl:for-each>	
</xsl:template>
<xsl:template match="table">
		<xsl:value-of disable-output-escaping="yes" select="."/>
</xsl:template>
</xsl:stylesheet>
