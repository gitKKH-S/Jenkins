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
<xsl:param name="selectBox" />
<xsl:param name="Topcont" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- 루트 template -->

<xsl:template match="/">
<html>
	<head>
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
<input type="hidden" name="folder"/>
<input type="hidden" name="Serverfile"/>
<input type="hidden" name="Pcfilename"/>
<!-- 내규 전체 제목 -->
	<select class="select_fontsize" name="FontCh" onchange="setFontP(this.value)">
		<option value="9pt">9pt</option>
		<option value="10pt">10pt</option>
		<option value="11pt">11pt</option>
		<option value="12pt">12pt</option>
		<option value="13pt">13pt</option>
		<option value="14pt">14pt</option>
		<option value="15pt">15pt</option>
	</select>
	<xsl:for-each select="./hisitem">
		<xsl:if test="./@bookid=$bookid">
			<p class="title"><xsl:value-of select="@title"/></p>
		</xsl:if>
	</xsl:for-each>

	<!-- 내규 제개정 select box -->
			<xsl:element name="p">
				<xsl:attribute name="class">selBox</xsl:attribute>
				<xsl:value-of select="$selectBox" disable-output-escaping="yes"/>
			</xsl:element>
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
	<p class="pyun">
		제<xsl:value-of select="./@contno"/>편 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/>
	</p>
	<xsl:apply-templates select="jang|jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jang">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="jang">
		제<xsl:value-of select="./@contno"/>장 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/>
	</p>
	<xsl:apply-templates select="jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jeol">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="jeol">
		제<xsl:value-of select="./@contno"/>절 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/>
	</p>
	<xsl:apply-templates select="gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="gwan">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="gwan">
		제<xsl:value-of select="./@contno"/>관 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/>
	</p>
	<xsl:apply-templates select="jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jo">
		<xsl:for-each select=".">
			<xsl:if test="./@endcha&gt;=$revcha">
			<xsl:if test="./@startcha&lt;=$revcha">
				<xsl:if test="$revcha!=0">
					<xsl:choose>
						<xsl:when test="./@startcha&gt;0">
						<xsl:if test="@startcha &gt; $allcha">
							<xsl:element name="img">
								<xsl:attribute name="src">/krisslaw/images/btn_hi.gif</xsl:attribute>
								<xsl:attribute name="class">histIcon</xsl:attribute>
								<xsl:attribute name="align">absmiddle</xsl:attribute>
								<xsl:attribute name="onclick">old('<xsl:value-of select="$bookid"/>','<xsl:value-of select="@contno"/>','<xsl:value-of select="@contsubno"/>','<xsl:value-of select="$allcha"/>');</xsl:attribute>
							</xsl:element>
						</xsl:if>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<div id="jo">
					<xsl:element name="a">
						<xsl:attribute name="name">bon<xsl:value-of select="@contno"/>
							<xsl:if test="./@contsubno>0">bu<xsl:value-of select="@contsubno"/></xsl:if>
						</xsl:attribute>
						<xsl:attribute name="style">padding-top:10px</xsl:attribute>
						<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
							<xsl:if test="@title!=''">
							(<xsl:value-of select="@title"/>)
							</xsl:if>
						</strong>
					</xsl:element>	
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/>
					<xsl:if test="./cont!=''"><br/></xsl:if>
					<xsl:call-template name="etc">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
					<xsl:if test="@showtag!=''">
					<span style="color:blue"><xsl:value-of select="@showtag"/></span>
					</xsl:if>
					<br/>
				</div>
				
			</xsl:if>
			</xsl:if>
		</xsl:for-each>
</xsl:template>

<!-- 부칙 -->

<xsl:template match="buchick">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="buchik_title">
		<xsl:for-each select=".">
			<xsl:value-of select="@title"/>        
		</xsl:for-each>
	</p>
	</xsl:if> 
	</xsl:if>
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	
		<xsl:for-each select="./jo">
		<div id="jo">
			<a><xsl:attribute name="name">buc<xsl:value-of select="@contno"/></xsl:attribute>
				<strong>제<xsl:value-of select="@contno"/>조 <xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
					<xsl:choose> 
						<xsl:when test="contains(./cont/text(),'본조 삭제')">
				        	<br/>
				        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
				        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
				        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
				        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
				    	</xsl:when>
					    <xsl:otherwise>
					    	<xsl:choose> 
					    	<xsl:when test="@title=''">
					    		<br/>
					    		<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					    	</xsl:when>
					    	<xsl:otherwise>
					    	(<xsl:value-of select="@title"/>)
					    	</xsl:otherwise>
					    	</xsl:choose> 
					    </xsl:otherwise>
				    </xsl:choose>
				</strong></a>
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5" mode="link"/>
			<xsl:if test="./cont!=''"><br/></xsl:if>
			<xsl:call-template name="etc">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
		</div>
		</xsl:for-each>
		<xsl:call-template name="etc">
			<xsl:with-param name="param" select="."/>
		</xsl:call-template>
		<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5" mode="link"/>
		
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="byullist">
<xsl:if test="count(child::*)>0">  
<p class="buchik_title">
별표 및 서식
</p>
	<xsl:apply-templates select="byul|byulji|byulch"/>
</xsl:if>
</xsl:template>
<!-- 별표 -->

<xsl:template match="byul">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">        
		<xsl:for-each select=".">
		<xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
			<p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="//law/@title"/>'+'_'+'<xsl:value-of select="$revcha"/>차'+'_'+'<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>		
					<xsl:attribute name="style">cursor:pointer;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:when>
		<xsl:otherwise> 
			<xsl:if test="./@curstate!='delete'">
				<span class="jocontent3"><xsl:value-of select="./@showtitle"/></span>
				<br/>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:for-each>   
	</xsl:if>
	</xsl:if>             
</xsl:template>

<!-- 별지서식 -->

<xsl:template match="byulji"> 
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">       
		<xsl:for-each select=".">
			<xsl:choose> 
			<xsl:when test="./@serverfilename!=''">   
				<p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
				</p>
			</xsl:when>
			<xsl:otherwise> 
				<xsl:if test="./@curstate!='delete'">
					<span class="jocontent3"><xsl:value-of select="./@showtitle"/></span>
					<br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:if>
	</xsl:if>           
</xsl:template>

<!-- 별첨 -->

<xsl:template match="byulch">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">        
		<xsl:for-each select=".">
		<xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
			<p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:when>
		<xsl:otherwise>   
			<xsl:if test="./@curstate!='delete'">
				<span class="jocontent3"><xsl:value-of select="./@showtitle"/></span>
				<br/>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:for-each> 
	</xsl:if>
	</xsl:if>             
</xsl:template>

<!-- 내용 -->

<xsl:template match="cont/text()" mode="link">
<xsl:choose> 
<xsl:when test="$schtxt!=''">
    <xsl:choose> 
  		<xsl:when test="contains(.,$schtxt)">
            <xsl:value-of select="substring-before(.,$schtxt)"/>
    			<span class="highlite"><xsl:value-of select="$schtxt"/></span>
			<xsl:value-of select="substring-after(.,$schtxt)"/>
    	</xsl:when>
	    <xsl:otherwise>
	    	<xsl:value-of select="."/>
	    </xsl:otherwise>
    </xsl:choose>
</xsl:when>
<xsl:otherwise>
   	<xsl:value-of select="."/>
</xsl:otherwise>
</xsl:choose>
</xsl:template> 

<!-- 링크 -->
<xsl:template match="cont/byullink" mode="link">
    <a class="lawlk">
        <xsl:attribute name="href">javascript:link_file('<xsl:value-of select="./@filename"/>');</xsl:attribute>
        <xsl:value-of select="."/>
    </a>
</xsl:template>
<xsl:template match="cont/law" mode="link">
    <a class="lawlk">
        <xsl:attribute name="href">javascript:link_law('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@jono"/>');</xsl:attribute>
        <xsl:value-of select="."/>
    </a>
</xsl:template>

<xsl:template match="cont/bylaw" mode="link">
    <a class="lawlk">
        <xsl:attribute name="href">javascript:onclick=link('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@jono"/>');</xsl:attribute>
        <!-- 
        <xsl:if test="./@jono!='bon0'">
        <xsl:attribute name="onmousemove">loca(10,-13,event) </xsl:attribute> 
	    <xsl:attribute name="onmouseover">msg('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@jono"/>') </xsl:attribute> 
	    <xsl:attribute name="onmouseout">notshow() </xsl:attribute> 
	    </xsl:if> -->
        <xsl:choose> 
	<xsl:when test="$schtxt!=''">
    <xsl:choose> 
  		<xsl:when test="contains(.,$schtxt)">
            <xsl:value-of select="substring-before(.,$schtxt)"/>
    			<span class="highlite"><xsl:value-of select="$schtxt"/></span>
			<xsl:value-of select="substring-after(.,$schtxt)"/>
    	</xsl:when>
	    <xsl:otherwise>
	    	<xsl:value-of select="."/>
	    </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <xsl:otherwise>
   <xsl:value-of select="."/>
   </xsl:otherwise>
   </xsl:choose>
    </a>
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
		<p><img><xsl:attribute name="src">/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img></p>
	</td></tr>
	</table>
</xsl:template>

<xsl:template name="etc">	
	<xsl:param name="param" select="."/>
	<xsl:for-each select="hang">
		<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><xsl:value-of select="@showtag"/><br/>
		<xsl:for-each select="ho">
			<div id="ho">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
			</div>
			<xsl:for-each select="mok">
				<div id="mok" >
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
				</div>
				<xsl:for-each select="dan">
					<div id="dan" >
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
					</div>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="dan">
				<div id="dan" >
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="mok">
			<div id="mok">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
			</div>
			<xsl:for-each select="dan">
				<div id="dan">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="dan">
			<div class="dan" style="padding-left:20px;padding-top:5px">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
			</div>
		</xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="ho">
			<div id="ho" >
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
			</div>
		<xsl:for-each select="mok">
			<div id="mok">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
			</div>
			<xsl:for-each select="dan">
				<div id="dan">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="mok">
		<div id="mok">
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
		</div>
		<xsl:for-each select="dan">
			<div id="dan">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
			</div>
		</xsl:for-each>
	</xsl:for-each>		
	<xsl:for-each select="dan">
		<div id="dan">
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/span|cont/table" mode="link"/><br/>
		</div>
	</xsl:for-each>	
</xsl:template>
<xsl:include href="util.xsl"/>
</xsl:stylesheet>
