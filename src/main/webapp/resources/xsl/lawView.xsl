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
<table style="text-align:center;">
	<tr>
		<td>
			<h3><xsl:value-of select="법령명_한글"/></h3>
		</td>
	</tr>
	<tr>
		<td>
			<span class="blueText">
			[시행 <xsl:value-of select="substring(시행일자,1,4)"/>.<xsl:value-of select="substring(시행일자,5,2)"/>.<xsl:value-of select="substring(시행일자,7,2)"/>.]
			[<xsl:value-of select="법종구분"/> 제 <xsl:value-of select="공포번호"/>호,
			<xsl:value-of select="substring(공포일자,1,4)"/>.<xsl:value-of select="substring(공포일자,5,2)"/>.<xsl:value-of select="substring(공포일자,7,2)"/>.
			,<xsl:value-of select="제개정구분"/>]
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

<xsl:template match="조문">
<table align="center">
	<xsl:for-each select="조문단위">
		<xsl:variable name="jomunNum" select="concat('제', 조문번호, '조')"/>
		<xsl:variable name="jomunSubNum" select="concat('의', 조문가지번호)"/>
		<xsl:variable name="jomunTitle" select="concat('(', 조문제목, ')')"/>

		<xsl:choose>
			<xsl:when test="조문여부 = '전문'">
				<tr>
					<td style="padding-top: 25px;">
						&#160;<span class="titleText" style="font-size:15px;">
								<xsl:element name="a">
									<xsl:attribute name="name"><xsl:value-of select="@조문키"/></xsl:attribute>
									<xsl:value-of select="조문내용"/>
								</xsl:element>
							</span>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
					<tr>
						<td style="padding-top: 10px;">
							<xsl:element name="a">
							<xsl:attribute name="name">
								<xsl:value-of select="@조문키"/>
							</xsl:attribute>
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
								<xsl:value-of select="substring-after(조문내용, $jomunTitle)"/>
							</xsl:when>
							<xsl:when test="string-length(조문가지번호) != 0">
								<xsl:value-of select="substring-after(조문내용, $jomunSubNum)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(조문내용, $jomunNum)"/>
							</xsl:otherwise>
							</xsl:choose>
							</xsl:element>
						</td>
					</tr>
					
					<xsl:for-each select="항">
						<tr>
							<td style="padding-left:20px;"><xsl:value-of select="./항내용"/></td>
						</tr>
							
						<xsl:for-each select="호">
							<tr>
								<td style="padding-left:40px;"><xsl:value-of select="./호내용"/></td>
							</tr>
								
							<xsl:for-each select="목">
								<tr>
									<td style="padding-left:60px;"><xsl:value-of select="./목내용"/></td>
								</tr>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="string-length(조문참고자료) != 0">
			<tr>
				<td style="padding-left:20px;"><span class="blueText"><xsl:value-of select="조문참고자료"/></span></td>
			</tr>
		</xsl:if>
	</xsl:for-each>
</table>
</xsl:template>

<xsl:template match="부칙">
	<xsl:for-each select="부칙단위">
	<xsl:variable name="buchickTitle" select="substring-before(substring-after(부칙내용, '부칙'), '&#10;')"></xsl:variable>
			<div style="margin-left:50px;text-align:left;">
			<span class="titleText">부&#160;&#160;&#160;&#160;칙</span>
			<span class="blueText">&#160;<xsl:value-of select="$buchickTitle"/></span>
			<div class="buchick"><xsl:value-of select="substring-after(부칙내용, '&#10;')"  disable-output-escaping="yes"/></div>
			</div>
	</xsl:for-each>
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
