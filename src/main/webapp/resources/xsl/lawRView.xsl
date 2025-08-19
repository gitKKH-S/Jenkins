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
<table align="left">
	<xsl:for-each select="조문단위">
		<xsl:variable name="jomunNum" select="concat('제', 조문번호, '조')"/>
		<xsl:variable name="jomunSubNum" select="concat('의', 조문가지번호)"/>
		<xsl:variable name="jomunTitle" select="concat('(', 조문제목, ')')"/>

		<xsl:choose>
			<xsl:when test="조문여부 = '전문'">
				<tr>
					<td>
						&#160;<div class="titleText" style="font-size:12px;text-align:left;">
								<a style="text-decoration:none;">
								<xsl:attribute name="href">#<xsl:value-of select="@조문키"/></xsl:attribute>
									<xsl:value-of select="조문내용"/>
								</a>
							</div>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
					<tr>
						<td style="font-size:12px;text-align:left;">
							<a style="text-decoration:none;">
								<xsl:attribute name="href">#<xsl:value-of select="@조문키"/></xsl:attribute>
								<span class="titleText">
									<xsl:value-of select="$jomunNum"/>
									<xsl:if test="string-length(조문가지번호) != 0">
										<xsl:value-of select="$jomunSubNum"/>
									</xsl:if>
									<xsl:if test="string-length(조문제목) != 0">
										<xsl:value-of select="$jomunTitle"/>
									</xsl:if>
								</span>
								<xsl:choose>
								<xsl:when test="string-length(조문제목) != 0">
								</xsl:when>
								<xsl:when test="string-length(조문가지번호) != 0">
								</xsl:when>
								<xsl:otherwise>
								</xsl:otherwise>
								</xsl:choose>
							</a>
						</td>
					</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</table>
</xsl:template>

<xsl:template match="부칙">
</xsl:template>
<xsl:template match="별표">
</xsl:template>
</xsl:stylesheet>
