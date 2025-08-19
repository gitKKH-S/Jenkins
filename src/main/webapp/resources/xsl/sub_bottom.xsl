<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- 루트 template -->

<xsl:template match="/">
<html>
	<head>
	</head>
	<body>
		<div id="byullist" style="display:''">
		<xsl:apply-templates select="law/byullist"/>
		</div>
		<div id="panlist" class="pbon" style="display:none">
		<xsl:apply-templates select="//jo"/>
		</div>
	</body>
</html>
</xsl:template>

<!-- 장 template -->

<xsl:template match="jang">
</xsl:template>

<!-- 편 template -->

<xsl:template match="pyun">
</xsl:template>

<!-- 조 template -->

<xsl:template match="jo">
	<xsl:if test="count(./panList)!=0">
		<xsl:element name="ul">
			<xsl:attribute name="id"><xsl:value-of select="@contid"/></xsl:attribute>
			<xsl:attribute name="style">display:none</xsl:attribute>
			<xsl:for-each select="./panList/pan">
				<li>
					<xsl:element name="a">
						<xsl:attribute name="style">
							font-size: 12px;
							font-family: "Malgun Gothic", "굴림", "Gulim", "Arial";
						</xsl:attribute>	
						<xsl:attribute name="href">javascript:link_pan('<xsl:value-of select="@pkey"/>');</xsl:attribute>
						· <xsl:value-of select="."/>
					</xsl:element>
				</li>    
			</xsl:for-each>
		</xsl:element>
	</xsl:if>
</xsl:template>

<!-- 부칙 template -->

<xsl:template match="buchick">
</xsl:template>
  
<!-- 별첨 template -->
<xsl:template match="byulch">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">         
		<xsl:for-each select=".">
		<xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
			<p class="attachText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="//law/@title"/>'+'_'+'<xsl:value-of select="$revcha"/>차'+'_'+'<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:when>
		<xsl:otherwise>   
			<xsl:if test="./@curstate!='delete'">
				<span class="jocontent2"><xsl:value-of select="./@showtitle"/></span>
				<br/>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:for-each> 
	</xsl:if>
	</xsl:if>             
</xsl:template>

<!-- 별표 -->

<xsl:template match="byul">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">        
		<xsl:for-each select=".">
		<xsl:if test="./@byulcd='별지서식'">
			<xsl:choose> 
			<xsl:when test="./@serverfilename!=''">
				<p class="attachText">
					<xsl:element name="span">
						<xsl:attribute name="onclick">downpage('<xsl:value-of select="//law/@title"/>'+'_'+'<xsl:value-of select="$revcha"/>차'+'_'+'<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>		
						<xsl:attribute name="style">cursor:pointer;</xsl:attribute>
						<xsl:value-of select="./@showtitle"/>
					</xsl:element>
				</p>
			</xsl:when>
			<xsl:otherwise> 
				<xsl:if test="./@curstate!='delete'">
					<span class="jocontent2">
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
				<p class="attachText">
					<xsl:element name="span">
						<xsl:attribute name="onclick">downpage('<xsl:value-of select="//law/@title"/>'+'_'+'<xsl:value-of select="$revcha"/>차'+'_'+'<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>		
						<xsl:attribute name="style">cursor:pointer;</xsl:attribute>
						<xsl:value-of select="./@showtitle"/>
					</xsl:element>
				</p>
			</xsl:when>
			<xsl:otherwise> 
				<xsl:if test="./@curstate!='delete'">
					<span class="jocontent2"><xsl:value-of select="./@showtitle"/></span>
					<br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		</xsl:for-each>   
	</xsl:if>
	</xsl:if>
</xsl:template>

<!-- 별지서식 template -->

<xsl:template match="byulji">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">        
		<xsl:for-each select=".">
			<xsl:choose> 
			<xsl:when test="./@serverfilename!=''"> 
				<p class="attachText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="//law/@title"/>'+'_'+'<xsl:value-of select="$revcha"/>차'+'_'+'<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
				</p>
			</xsl:when>
			<xsl:otherwise> 
				<xsl:if test="./@curstate!='delete'">
					<span class="jocontent2"><xsl:value-of select="./@showtitle"/></span>
					<br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:if>
	</xsl:if>           
</xsl:template>
 
</xsl:stylesheet>
