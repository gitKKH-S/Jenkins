<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="contno" />
<xsl:param name="contsubno" />
<xsl:param name="allcha" />
<xsl:param name="Contid" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<xsl:template match="history">
<!-- 내규 전체 제목 -->
	<xsl:for-each select="./hisitem">
		<xsl:if test="./@bookid=$bookid">
			<div style="background-color:#d9e7f8;padding:3px;border=1px solid #d9e7f8; margin-bottom:3px;">
			<div style="text-align:center; margin:7px;"><span style="font-weight:bold;ALIGN:center;"><xsl:value-of select="@title"/></span></div>
			<span style="font-size:9pt; TEXT-ALIGN:justify;"> 
				[시행 : <span style="font-size:9pt; font-family: '돋움'; color:'#007099'"><xsl:value-of select="@startdt"/></span>][<xsl:value-of select="@revcd"/> : <span style="font-size:9pt; font-family: '돋움'; color:'#007099'"><xsl:value-of select="@promuldt"/></span>]
			</span>
			</div>
		</xsl:if>
	</xsl:for-each>

</xsl:template>
<!-- 연혁 template 끝 -->

<!-- 내규 template 시작 -->

<xsl:template match="jo">
			<xsl:if test="./@contid=$Contid">
			<xsl:if test="./@endcha&gt;=$revcha">
			<xsl:if test="./@startcha&lt;=$revcha">
					<xsl:element name="a">
						<span style="font-size:9pt; font-weight:bold; color:#1956a1;">제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
							<span style="font-size:9pt; font-weight:bold; color:#1956a1;">(<xsl:value-of select="@title"/>)</span>
						</span>
					</xsl:element>
					<span style="font-size:9pt; TEXT-ALIGN:justify;">
					<xsl:apply-templates select="cont/text()|cont/image|cont/img|cont/a5b5|cont/table|cont/hang|cont/ho|cont/mok|cont/dan" mode="link"/><br />
					<xsl:call-template name="etc">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
					<xsl:value-of select="@showtag"/>
					</span>
					<br/>
			</xsl:if>
			</xsl:if>
			</xsl:if>
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
<xsl:template match="buchick">
</xsl:template>
<xsl:include href="util.xsl"/>
<xsl:include href="common.xsl"/>
<!-- 항 / 호 / 목 / 단 (반복사용을 위해 common.xsl 로 분리 : call-template 으로 호출)-->
</xsl:stylesheet>
