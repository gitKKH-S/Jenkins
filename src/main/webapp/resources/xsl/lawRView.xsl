<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="euc-kr" indent="yes"/>


<xsl:template match="/����">
	<xsl:apply-templates select="�⺻����"/>
	<xsl:apply-templates select="����"/>
	<xsl:apply-templates select="��Ģ"/>
	<xsl:apply-templates select="��ǥ"/>
</xsl:template>

<xsl:template match="�⺻����">
</xsl:template>

<xsl:template match="����">
<table align="left">
	<xsl:for-each select="��������">
		<xsl:variable name="jomunNum" select="concat('��', ������ȣ, '��')"/>
		<xsl:variable name="jomunSubNum" select="concat('��', ����������ȣ)"/>
		<xsl:variable name="jomunTitle" select="concat('(', ��������, ')')"/>

		<xsl:choose>
			<xsl:when test="�������� = '����'">
				<tr>
					<td>
						&#160;<div class="titleText" style="font-size:12px;text-align:left;">
								<a style="text-decoration:none;">
								<xsl:attribute name="href">#<xsl:value-of select="@����Ű"/></xsl:attribute>
									<xsl:value-of select="��������"/>
								</a>
							</div>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
					<tr>
						<td style="font-size:12px;text-align:left;">
							<a style="text-decoration:none;">
								<xsl:attribute name="href">#<xsl:value-of select="@����Ű"/></xsl:attribute>
								<span class="titleText">
									<xsl:value-of select="$jomunNum"/>
									<xsl:if test="string-length(����������ȣ) != 0">
										<xsl:value-of select="$jomunSubNum"/>
									</xsl:if>
									<xsl:if test="string-length(��������) != 0">
										<xsl:value-of select="$jomunTitle"/>
									</xsl:if>
								</span>
								<xsl:choose>
								<xsl:when test="string-length(��������) != 0">
								</xsl:when>
								<xsl:when test="string-length(����������ȣ) != 0">
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

<xsl:template match="��Ģ">
</xsl:template>
<xsl:template match="��ǥ">
</xsl:template>
</xsl:stylesheet>
