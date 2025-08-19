<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="euc-kr" indent="yes"/>


<xsl:template match="/법령">
	<xsl:apply-templates select="기본정보"/>
	<xsl:apply-templates select="조문"/>
	<xsl:apply-templates select="부칙"/>
	<xsl:apply-templates select="별표"/>
</xsl:template>

<xsl:template match="기본정보">
</xsl:template>

<xsl:template match="조문">
</xsl:template>

<xsl:template match="부칙">
</xsl:template>

<xsl:template match="별표">
	<xsl:for-each select="별표단위">
		<xsl:element name="div"> 				
				<xsl:attribute name="style">text-align:left;font-size: 12px;color:#06f;cursor:pointer;</xsl:attribute>
				<xsl:attribute name="onclick">goDownLoad('<xsl:value-of select="@별표키"/>','<xsl:value-of select="별표구분"/>')</xsl:attribute>
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
		</xsl:element>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
