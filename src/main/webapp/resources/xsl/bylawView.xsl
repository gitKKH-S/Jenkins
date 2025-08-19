<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="euc-kr" indent="yes"/>

<xsl:template match="/AdmRulService">
	<xsl:apply-templates select="행정규칙기본정보"/>
	<xsl:apply-templates select="조문내용"/>
	<xsl:apply-templates select="부칙"/>
	<xsl:apply-templates select="별표"/>
</xsl:template>

<xsl:template match="행정규칙기본정보">
<table style="text-align:center;">
	<tr>
		<td style="padding-top:50px;">
			<h3><xsl:value-of select="행정규칙명"/></h3>
		</td>
	</tr>
	<tr>
		<td>
			<span class="blueText">
			[시행 <xsl:value-of select="substring(발령일자,1,4)"/>.<xsl:value-of select="substring(발령일자,5,2)"/>.<xsl:value-of select="substring(발령일자,7,2)"/>.]
			[<xsl:value-of select="소관부처명"/><xsl:value-of select="행정규칙종류"/> 제 <xsl:value-of select="발령번호"/>호,
			<xsl:value-of select="substring(발령일자,1,4)"/>.<xsl:value-of select="substring(발령일자,5,2)"/>.<xsl:value-of select="substring(발령일자,7,2)"/>.
			,<xsl:value-of select="제개정구분명"/>]
			</span>
		</td>
	</tr>
	<tr>
		<td align="right">
			<font size="2"><xsl:value-of select="소관부처"/></font>
		</td>
	</tr>
</table>
</xsl:template>

<xsl:template match="조문내용">
<table align="center">
	<tr>
		<td style="padding-top: 25px;">
			&#160;<span class="titleText" style="font-size:15px;"><xsl:value-of select="."/></span>
		</td>
	</tr>
</table>
</xsl:template>

<xsl:template match="부칙">
<table style="table-layout:fixed">
	<xsl:for-each select="부칙단위">
	<xsl:variable name="buchickTitle" select="substring-before(substring-after(부칙내용, '부칙'), '&#10;')"></xsl:variable>
	<tr>
		<td>
			<span class="titleText">부&#160;&#160;&#160;&#160;칙</span>
			<span class="blueText">&#160;<xsl:value-of select="$buchickTitle"/></span>
		</td>
	</tr>
	<tr>
		<td>
			<pre class="buchick"><xsl:value-of select="substring-after(부칙내용, '&#10;')"/></pre>
		</td>
	</tr>
	</xsl:for-each>
</table>
</xsl:template>

<xsl:template match="별표">
<table>
	<xsl:for-each select="별표단위">
		<tr>
			<td>
<!-- 				<xsl:choose> -->
<!-- 					<xsl:when test="별표구분 != '별표'"> -->
						[<xsl:value-of select="별표구분"/>
						<xsl:if test="number(별표번호) != 0"> <xsl:value-of select="number(별표번호)"/></xsl:if>
						<xsl:if test="number(별표가지번호) &gt; 0">의<xsl:value-of select="number(별표가지번호)"/></xsl:if>]
<!-- 					</xsl:when> -->
<!-- 					<xsl:otherwise> -->
<!-- 						[별지 제<xsl:value-of select="number(별표번호)"/>호 서식] -->
<!-- 					</xsl:otherwise> -->
<!-- 				</xsl:choose> -->
				<xsl:value-of select="별표제목"/>
			</td>
		</tr>
	</xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>
