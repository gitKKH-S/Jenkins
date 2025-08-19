<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="schtxt" />
<xsl:param name="Obookid" />
<xsl:param name="deptname" />
<xsl:param name="ListS" />
<xsl:param name="type" />
<xsl:param name="allcha" />
<xsl:param name="ImageURL" />
<xsl:param name="selectBox" />
<xsl:param name="Topcont" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- 루트 template -->

<xsl:template match="/">
<html>
	<head>
		<style xmlns:fo="http://www.w3.org/1999/XSL/Format" type="text/css">
			* {
				font-size:13pt;
				line-height:180%;
			}
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
		<xsl:if test="./@bookid=$bookid">
			<p style="font-family:'한컴바탕'; text-align:center; font-size:20pt;"><strong><xsl:value-of select="@title"/></strong></p><p>&amp;nbsp;</p>
		</xsl:if>
	</xsl:for-each>
			<p style="text-align:right;font-size:9pt;">
				<xsl:value-of select="$selectBox" disable-output-escaping="yes"></xsl:value-of>
			</p>
	<br/>&amp;nbsp;
	
</form>
<div>
	<xsl:value-of select="$Topcont" disable-output-escaping="yes"></xsl:value-of>
</div>
</xsl:template>

<!-- 연혁 template 끝 -->

<!-- 내규 template 시작 -->

<!-- 편 / 장 / 절 / 관 / 조 template -->

<xsl:template match="pyun">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<p style=" text-align:center;font-size:14pt;"><strong>제<xsl:value-of select="./@contno"/>편 <xsl:value-of select="./@title"/></strong></p>
		<br/>
	<xsl:apply-templates select="jang|jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
	
</xsl:template>

<xsl:template match="jang">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<p style="font-family:'한컴바탕'; font-size:14pt; text-align:center; ">
		<strong>
			제<xsl:value-of select="./@contno"/>장<xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if>
		 	&amp;nbsp;<xsl:value-of select="./@title"/>
		</strong>
		</p>
		<br/>
	<xsl:apply-templates select="jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jeol">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<p style="font-family:'한컴바탕'; font-size:14pt; text-align:center;">
		<strong>
			제<xsl:value-of select="./@contno"/>절 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> 
			&amp;nbsp;<xsl:value-of select="./@title"/>
		</strong>
		</p>
		<br/>
	<xsl:apply-templates select="gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="gwan">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<p style="font-family:'한컴바탕'; font-size:14pt; text-align:center;justify"><strong>
			제<xsl:value-of select="./@contno"/>관  <xsl:value-of select="./@title"/></strong></p>
			<br/>
	<xsl:apply-templates select="jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jo">
		<xsl:for-each select=".">
			<xsl:if test="./@endcha&gt;=$revcha">
			<xsl:if test="./@startcha&lt;=$revcha">
			<xsl:if test="./@curstate != 'delete'">
				<p style="margin-left:0pt;text-align:justify;font-size:12pt;line-height:180%;">
				<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
						(<xsl:value-of select="@title"/>)
				</strong>
					<span  style="font-family:'한컴바탕'; text-align:justify; font-size:12pt;line-height:180%;">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
					<xsl:if test="./cont/@showtag!=''">
								<span style="color:blue"><xsl:value-of select="./cont/@showtag"/></span>
								</xsl:if>
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
					<xsl:if test="@showtag!=''">
					<span style="color:blue;font-size:12pt;"><xsl:value-of select="@showtag"/></span>
					</xsl:if>
				</p>
				<br/>
			</xsl:if>
			</xsl:if>
			</xsl:if>
		</xsl:for-each>
</xsl:template>

<!-- 부칙 -->

<xsl:template match="buchick">
<br/>&amp;nbsp;
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<xsl:for-each select=".">
		<p style="text-align:center;font-size:12pt;" >
			<strong><xsl:value-of select="@title"/></strong>
		</p>
		</xsl:for-each>
	</xsl:if> 
	</xsl:if>
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<xsl:for-each select="./jo">
			<p style="margin-left:0pt;font-weight:normal; text-align:left;font-size:12pt;line-height:180%;">
				<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if> 
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
				<span  style="font-family:'한컴바탕'; text-align:justify; font-size:12pt;line-height:180%;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				</span>
				<xsl:choose> 
					<xsl:when test="./cont/text()!=''">
						<div style="font-family:'한컴바탕'; text-align:justify;line-height:180%;">
							<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</p>
		</xsl:for-each>
		<p style="font-weight:normal; text-align:left;font-size:12pt;line-height:180%;">
			<xsl:call-template name="etc">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/><br/>
		</p>
	</xsl:if>
	</xsl:if>
</xsl:template>

<!-- 별표 -->

<xsl:template match="byul">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<xsl:if test="./@curstate != 'delete'"> 
		<xsl:for-each select=".">
			<xsl:choose> 
			<xsl:when test="./@serverfilename!=''">   
				<p style="text-align:left;font-weight:normal;" >
					<xsl:element name="span">
						<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
						<xsl:attribute name="style">cursor:hand;</xsl:attribute>
						<xsl:value-of select="./@showtitle"/>
					</xsl:element>
				</p>
			</xsl:when>
			<xsl:otherwise> 
				<xsl:if test="./@curstate!='delete'">
					<span style="text-align:left;font-weight:normal;"><xsl:value-of select="./@showtitle"/></span>
					<br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>  
	</xsl:if>
	</xsl:if>      
	</xsl:if>        
</xsl:template>

<!-- 별지서식 -->

<xsl:template match="byulji"> 
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">  
	<xsl:if test="./@curstate != 'delete'"> 
		<xsl:for-each select=".">
			<xsl:choose> 
			<xsl:when test="./@serverfilename!=''">   
				<p style="text-align:left;font-weight:normal;" >
					<xsl:element name="span">
						<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
						<xsl:attribute name="style">cursor:hand;</xsl:attribute>
						<xsl:value-of select="./@showtitle"/>
					</xsl:element>
				</p>
			</xsl:when>
			<xsl:otherwise> 
				<xsl:if test="./@curstate!='delete'">
					<span style="text-align:left;font-weight:normal;"><xsl:value-of select="./@showtitle"/></span>
					<br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:if>
	</xsl:if>           
	</xsl:if> 
</xsl:template>

<!-- 별첨 -->

<xsl:template match="byulch">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">  
	<xsl:if test="./@curstate != 'delete'"> 
		<xsl:for-each select=".">
		<xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
			<p style="text-align:left;font-weight:normal;" >
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:when>
		<xsl:otherwise>   
			<xsl:if test="./@curstate!='delete'">
				<span style="text-align:left;font-weight:normal;"><xsl:value-of select="./@showtitle"/></span>
				<br/>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:for-each> 
	</xsl:if>
	</xsl:if>     
	</xsl:if>         
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

<!-- 이미지 -->

<xsl:template match="image" >
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
		<xsl:apply-templates select="." mode="link"/>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
	<img><xsl:attribute name="src">/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img>
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

	<img><xsl:attribute name="src"><xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img>
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
</xsl:template>

<xsl:template match="cont/a5b5" mode="link">
<br>&amp;nbsp;</br>
</xsl:template>	
<xsl:template match="hang" mode="link">
	<xsl:choose> 
		<xsl:when test=" (position() =1) and local-name(parent::*)='jo'">
			<span style="font-family:'한컴바탕'; text-align:justify; font-size:12pt;line-height:180%; ">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				<xsl:if test="./cont/@showtag!=''">
				<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
				</xsl:if>
			</span>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose> 
				<xsl:when test="local-name(parent::*)='buchick'">
					<span style="font-family:'한컴바탕'; text-align:justify; font-size:12pt; line-height:180%;">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@showtag!=''">
						<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
						</xsl:if>
					</span>
					<br/>
				</xsl:when>
				<xsl:otherwise>
					<div style="font-family:'한컴바탕'; text-align:justify; font-size:12pt;line-height:180%;"><!-- margin-left:10.0pt; -->
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@showtag!=''">
						<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
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
					<span style="font-family:'한컴바탕'; text-align:justify; font-size:12pt;line-height:180%; ">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@showtag!=''">
						<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
						</xsl:if>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<div style="margin-left:20.0pt;font-family:'한컴바탕'; text-align:justify; font-size:12pt; line-height:180%;">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@showtag!=''">
						<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
						</xsl:if>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<div style="margin-left:20.0pt;font-family:'한컴바탕'; text-align:justify; font-size:12pt;line-height:180%;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				<xsl:if test="./cont/@showtag!=''">
				<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
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
					<span style="font-family:'한컴바탕'; text-align:justify; font-size:12pt; line-height:180%;">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@showtag!=''">
						<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
						</xsl:if>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<div style="margin-left:30.0pt;font-family:'한컴바탕'; text-align:justify; font-size:12pt; line-height:180%;">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@showtag!=''">
						<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
						</xsl:if>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<div style="margin-left:30.0pt;font-family:'한컴바탕'; text-align:justify; font-size:12pt;line-height:180%;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				<xsl:if test="./cont/@showtag!=''">
				<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
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
					<span style="font-family:'한컴바탕'; text-align:justify; font-size:12pt; line-height:180%;">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@showtag!=''">
						<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
						</xsl:if>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<div style="margin-left:40.0pt;font-family:'한컴바탕'; text-align:justify; font-size:12pt; line-height:180%;">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						<xsl:if test="./cont/@showtag!=''">
						<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
						</xsl:if>
					</div>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:when>
		<xsl:otherwise>
			<div style="margin-left:40.0pt;font-family:'한컴바탕'; text-align:justify; font-size:12pt;line-height:180%;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				<xsl:if test="./cont/@showtag!=''">
						<span style="color:blue">　<xsl:value-of select="./cont/@showtag"/></span>
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
</xsl:template>	
</xsl:stylesheet>