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
</xsl:template>

<xsl:template match="��Ģ">
</xsl:template>

<xsl:template match="��ǥ">
	<xsl:for-each select="��ǥ����">
		<xsl:element name="div"> 				
				<xsl:attribute name="style">text-align:left;font-size: 12px;color:#06f;cursor:pointer;</xsl:attribute>
				<xsl:attribute name="onclick">goDownLoad('<xsl:value-of select="@��ǥŰ"/>','<xsl:value-of select="��ǥ����"/>')</xsl:attribute>
<!-- 				<xsl:choose> -->
<!-- 					<xsl:when test="��ǥ���� != '��ǥ'"> -->
						[<xsl:value-of select="��ǥ����"/>
						<xsl:if test="number(��ǥ��ȣ) != 0"> <xsl:value-of select="number(��ǥ��ȣ)"/></xsl:if>
						<xsl:if test="number(��ǥ������ȣ) &gt; 0">��<xsl:value-of select="number(��ǥ������ȣ)"/></xsl:if>]
<!-- 					</xsl:when> -->
<!-- 					<xsl:otherwise> -->
<!-- 						[���� ��<xsl:value-of select="number(��ǥ��ȣ)"/>ȣ ����] -->
<!-- 					</xsl:otherwise> -->
<!-- 				</xsl:choose> -->
				
					<xsl:value-of select="��ǥ����"/>
		</xsl:element>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
