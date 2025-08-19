<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="schtxt" />
<xsl:param name="Obookid" />
<xsl:param name="deptname" />
<xsl:param name="ListS" />
<xsl:param name="type" />
<xsl:param name="type2" />
<xsl:param name="allcha" />
<xsl:param name="selectBox" />
<xsl:param name="Topcont" />
<xsl:param name="statehistoryid" />
<xsl:param name="menuType" />
<xsl:param name="sysdate" />

<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- 루트 template -->



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
<input type="hidden" name="type2"/>
<input type="hidden" name="menuType"/>
<!-- 내규 전체 제목 -->
	<xsl:for-each select="./hisitem">
		<xsl:if test="./@bookid=$bookid">
			<p class="title"><xsl:value-of select="@title"/></p>
			<p class="jang"><xsl:value-of select="//law/@subtitle"/></p>
		</xsl:if>
	</xsl:for-each>

	<!-- 내규 제개정 select box -->
	<xsl:if test="$statehistoryid = ''">
			<xsl:element name="p"> 				
				<xsl:attribute name="class">selBox</xsl:attribute>
				<xsl:value-of select="$selectBox" disable-output-escaping="yes"></xsl:value-of>
			</xsl:element>
	</xsl:if>
</form>
<p class="title">
	<xsl:if test="count(//jo)=0"> 
		선택하신 문서는  자료가 DB화 되지 않았습니다.
	</xsl:if>
</p>
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
	<xsl:if test="./@curstate != 'delete'">
	<p class="pyun">
		<xsl:element name="a">
			<xsl:attribute name="name"><xsl:value-of select="@contid"/></xsl:attribute>
			<xsl:attribute name="style">padding-top:10px</xsl:attribute>
			제<xsl:value-of select="./@contno"/>편<xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if>
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./@title"/>
			<xsl:if test="@showtag!=''">
			<span style="color:blue"><xsl:value-of select="@showtag"/></span>
			</xsl:if>
		</xsl:element>
	</p>
	<xsl:apply-templates select="jang|jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jang">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<xsl:if test="./@curstate != 'delete'">
	<p class="jang">
		<xsl:element name="a">
			<xsl:attribute name="name"><xsl:value-of select="@contid"/></xsl:attribute>
			<xsl:attribute name="style">padding-top:10px</xsl:attribute>
			제<xsl:value-of select="./@contno"/>장<xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if>
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./@title"/>
			<xsl:if test="@showtag!=''">
			<span style="color:blue"><xsl:value-of select="@showtag"/></span>
			</xsl:if>
		</xsl:element>
	</p>
	<xsl:apply-templates select="jeol|gwan|jo"/>
	</xsl:if>
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jeol">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="jeol">
		<xsl:element name="a">
			<xsl:attribute name="name"><xsl:value-of select="@contid"/></xsl:attribute>
			<xsl:attribute name="style">padding-top:10px</xsl:attribute>
			제<xsl:value-of select="./@contno"/>절<xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if>
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./@title"/>
			<xsl:if test="@showtag!=''">
			<span style="color:blue"><xsl:value-of select="@showtag"/></span>
			</xsl:if>
		</xsl:element>
	</p>
	<xsl:apply-templates select="gwan|jo"/>
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="gwan">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<xsl:if test="./@curstate != 'delete'">
	<p class="gwan">
		<xsl:element name="a">
			<xsl:attribute name="name"><xsl:value-of select="@contid"/></xsl:attribute>
			<xsl:attribute name="style">padding-top:10px</xsl:attribute>
			제<xsl:value-of select="./@contno"/>관<xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if>
			<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:value-of select="./@title"/>
			<xsl:if test="@showtag!=''">
			<span style="color:blue"><xsl:value-of select="@showtag"/></span>
			</xsl:if>
		</xsl:element>
	</p>
	<xsl:apply-templates select="jo"/>	
	</xsl:if>
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jo">
	<xsl:variable name="the_min">
		<xsl:for-each select="//history/hisitem">
			<xsl:sort data-type="number" order="ascending" select="@revcha" />
			<xsl:if test="position()=1">
				<xsl:value-of select="@revcha" />
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
		<xsl:for-each select=".">
			<xsl:if test="@sihangend &gt; $sysdate">	
				<xsl:if test="$revcha!=0">
					<!-- xsl:choose>
						<xsl:when test="./@startcha &gt; $the_min">  and (./@state='revision' or ./@oldstate='revision') 
						<xsl:if test="@startcha &gt; $allcha"> -->
						<xsl:if test="@bcontid != '0'">
							<xsl:element name="img">
								<xsl:attribute name="src">../../resources/images/btn_hi.gif</xsl:attribute>
								<xsl:attribute name="class">histIcon</xsl:attribute>
								<xsl:attribute name="align">absmiddle</xsl:attribute>
								<xsl:attribute name="onclick">old('<xsl:value-of select="$bookid"/>','<xsl:value-of select="@contno"/>','<xsl:value-of select="@contsubno"/>','<xsl:value-of select="$allcha"/>','<xsl:value-of select="@bcontid"/>');</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<!-- </xsl:if>
						</xsl:when>
					</xsl:choose> -->
				</xsl:if>
				<xsl:if test="@jocnt!=0">
					<xsl:element name="img">
						<xsl:attribute name="src">../../resources/images/btn_rel.gif</xsl:attribute>
						<xsl:attribute name="class">histIcon</xsl:attribute>
						<xsl:attribute name="align">absmiddle</xsl:attribute>
						<xsl:attribute name="onclick">reJo('<xsl:value-of select="$bookid"/>','<xsl:value-of select="@contid"/>','bon<xsl:value-of select="@contno"/><xsl:if test="./@contsubno>0">bu<xsl:value-of select="@contsubno"/></xsl:if>');</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<div id="jo">
					<xsl:element name="a">
						<xsl:attribute name="name">bon<xsl:value-of select="@contno"/>
							<xsl:if test="./@contsubno>0">bu<xsl:value-of select="@contsubno"/></xsl:if>
						</xsl:attribute>
						<xsl:attribute name="style">padding-top:10px</xsl:attribute>
						<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if><xsl:if test="@title!=''">(<xsl:value-of select="@title"/>)</xsl:if>
						</strong>
					</xsl:element>
					<xsl:apply-templates select="cont/text()|cont/byullink|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
					<xsl:if test="./cont/@showtag!=''">
					<span class="jotag"><xsl:value-of select="./cont/@showtag"/></span>
					</xsl:if>
					<xsl:if test="./cont!=''"><br/></xsl:if>
					<xsl:call-template name="etc">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</div>
			</xsl:if>	
			<xsl:if test="./@curstate != 'delete'">
			<xsl:if test="./@endcha &gt;= $revcha">
			<xsl:if test="./@startcha &lt;= $revcha">
				<xsl:if test="$revcha != 0">
					<!-- xsl:choose>
						<xsl:when test="./@startcha &gt; $the_min">  and (./@state='revision' or ./@oldstate='revision') 
						<xsl:if test="@startcha &gt; $allcha"> -->
						<xsl:if test="@bcontid != '0'">
							<xsl:element name="img">
								<xsl:attribute name="src">../../resources/images/btn_hi.gif</xsl:attribute>
								<xsl:attribute name="class">histIcon</xsl:attribute>
								<xsl:attribute name="align">absmiddle</xsl:attribute>
								<xsl:attribute name="onclick">old('<xsl:value-of select="$bookid"/>','<xsl:value-of select="@contno"/>','<xsl:value-of select="@contsubno"/>','<xsl:value-of select="$allcha"/>','<xsl:value-of select="@bcontid"/>');</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<!-- </xsl:if>
						</xsl:when>
					</xsl:choose> -->
				</xsl:if>
				<xsl:if test="@jocnt!=0">
					<xsl:element name="img">
						<xsl:attribute name="src">../../resources/images/btn_rel.gif</xsl:attribute>
						<xsl:attribute name="class">histIcon</xsl:attribute>
						<xsl:attribute name="align">absmiddle</xsl:attribute>
						<xsl:attribute name="onclick">reJo('<xsl:value-of select="$bookid"/>','<xsl:value-of select="@contid"/>','bon<xsl:value-of select="@contno"/><xsl:if test="./@contsubno>0">bu<xsl:value-of select="@contsubno"/></xsl:if>');</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<div id="jo">
					<xsl:if test="@sihangstart &gt; $sysdate">
					<xsl:attribute name="style">
						background-color:#d2d2d2;
					</xsl:attribute>
					</xsl:if>
					<xsl:element name="a">
						<xsl:attribute name="name">bon<xsl:value-of select="@contno"/>
							<xsl:if test="./@contsubno>0">bu<xsl:value-of select="@contsubno"/></xsl:if>
						</xsl:attribute>
						<xsl:attribute name="style">padding-top:10px</xsl:attribute>
						<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if><xsl:if test="@title!=''">(<xsl:value-of select="@title"/>)</xsl:if>
						</strong>
					</xsl:element>
					<xsl:apply-templates select="cont/text()|cont/byullink|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
					<xsl:if test="./cont/@showtag!=''">
					<span class="jotag"><xsl:value-of select="./cont/@showtag"/></span>
					</xsl:if>
					<xsl:if test="./cont!=''"><br/></xsl:if>
					<xsl:call-template name="etc">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
					<xsl:if test="@sihangstart &gt; $sysdate">
						<b><font style="color:red;">[시행예정 : <xsl:value-of select="substring(@sihangstart,0,5)"/>-<xsl:value-of select="substring(@sihangstart,5,2)"/>-<xsl:value-of select="substring(@sihangstart,7,2)"/>]</font></b>
					</xsl:if>
				</div>
				<xsl:if test="@showtag!=''">
				<div class="jotag">
				<xsl:value-of select="@showtag"/>
				</div>
				</xsl:if>
				
				<xsl:if test="count(./bylawList)!=0"> 
				<div id="hang"  class="pbon" style="padding:10px">
				<xsl:if test="count(./bylawList)!=0"> 
					☞관련 규정정보
					<ul>
					<xsl:for-each select="./bylawList/bylaw">
						<li>
							<xsl:element name="a">
								<xsl:attribute name="href">javascript:link_bylaw('<xsl:value-of select="@pkey"/>','<xsl:value-of select="@noformyn"/>');</xsl:attribute>
								<xsl:value-of select="."/>
							</xsl:element>
						</li>    
					</xsl:for-each>
					</ul>
				</xsl:if>
				</div>
				</xsl:if>
				
				<xsl:if test="count(./panList)!=0"> 
				<div id="hang" class="pbon" style="padding:10px">
				<xsl:if test="count(./panList)!=0"> 
					☞관련 판례정보
					<ul>
					<xsl:for-each select="./panList/pan">
						<li>
							<xsl:element name="a">
								<xsl:attribute name="href">javascript:link_pan('<xsl:value-of select="@pkey"/>');</xsl:attribute>
								<xsl:value-of select="."/>
							</xsl:element>
						</li>    
					</xsl:for-each>
					</ul>
				</xsl:if>
				</div>
				</xsl:if>
				
				<xsl:if test="./@fchk='Y'"> 
				<div id="hang"  class="pbon" style="padding:10px;">
					<a style="cursor:pointer;color:red;">
						<xsl:attribute name="onclick">contfileView('<xsl:value-of select="@contid"/>')</xsl:attribute>
						☞ 관련 문서정보 확인
					</a>
				</div>
				</xsl:if>
				<br/>
			</xsl:if>
			</xsl:if>
			</xsl:if>
		</xsl:for-each>
</xsl:template>

<!-- 부칙 -->
<xsl:template match="buchicklist">
	<xsl:if test="./@endcha&gt;=$revcha">
		<xsl:if test="./@startcha&lt;=$revcha">
			<xsl:apply-templates select="buchick"/>	
		</xsl:if>
	</xsl:if>
</xsl:template>
<xsl:template match="buchick">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="buchik_title">
		<xsl:for-each select=".">
			<xsl:element name="a">
				<xsl:attribute name="name"><xsl:value-of select="@contid"/>
				</xsl:attribute>
				<xsl:value-of select="@title"/>
			</xsl:element>    
		</xsl:for-each>
	</p>
	
		<xsl:for-each select="./jo">
		<div id="jo">
			<a><xsl:attribute name="name">buc<xsl:value-of select="@contno"/></xsl:attribute>
				<strong>제<xsl:value-of select="@contno"/>조 <xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>(<xsl:value-of select="@title"/>)
				</strong></a>
			<xsl:apply-templates select="cont/text()|cont/byullink|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
			<xsl:if test="./cont!=''"><br/></xsl:if>
			<xsl:call-template name="etc">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
		</div>
		</xsl:for-each>
		<div style="line-height: 150%;">
		<xsl:call-template name="etc">
			<xsl:with-param name="param" select="."/>
		</xsl:call-template>
		<xsl:apply-templates select="cont/text()|cont/byullink|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
		</div>
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
<!-- 
<xsl:template match="byul">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">        
		<xsl:for-each select=".">
		<xsl:if test="./@byulcd='별지서식'">
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
					<span class="jocontent3">
					<xsl:value-of select="./@showtitle"/>
					</span>
					<br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="./@byulcd!='별지서식'">
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
		</xsl:if>
		</xsl:for-each>   
	</xsl:if>
	</xsl:if>            
</xsl:template>
 -->
<xsl:template match="byul">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">        
		<xsl:for-each select=".">
		<xsl:if test="./@byulcd='별지서식'">
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
				<xsl:if test="./@curstate = 'delete'">
					<span class="jocontent3">
					<xsl:value-of select="./@showtitle"/><xsl:value-of select="./@revisiontag"/>
					</span>
					<br/>
				</xsl:if>
				<xsl:if test="./@curstate = 'deletemark'">
					<span class="jocontent3">
					<xsl:value-of select="./@showtitle"/><xsl:value-of select="./@revisiontag"/>
					</span>
					<br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="./@byulcd!='별지서식'">
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
				<xsl:if test="./@curstate ='deletemark'">
					<span class="jocontent3"><xsl:value-of select="./@showtitle"/><xsl:value-of select="./@revisiontag"/></span>
					<br/>
				</xsl:if>
				<xsl:if test="./@curstate ='delete'">
					<span class="jocontent3"><xsl:value-of select="./@showtitle"/><xsl:value-of select="./@revisiontag"/></span>
					<br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
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
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="//law/@title"/>'+'_'+'<xsl:value-of select="$revcha"/>차'+'_'+'<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
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
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="//law/@title"/>'+'_'+'<xsl:value-of select="$revcha"/>차'+'_'+'<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
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
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
		<xsl:apply-templates select="." mode="link"/>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
	<img><xsl:attribute name="src">../../dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img>
</xsl:template>
	
<xsl:include href="util.xsl"/>
<xsl:include href="common.xsl"/>
<!-- 항 / 호 / 목 / 단 (반복사용을 위해 common.xsl 로 분리 : call-template 으로 호출)-->

</xsl:stylesheet>
