<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="euc-kr" indent="yes"/>

<xsl:template match="/AdmRulService">
	<xsl:apply-templates select="������Ģ�⺻����"/>
	<xsl:apply-templates select="��������"/>
	<xsl:apply-templates select="��Ģ"/>
	<xsl:apply-templates select="��ǥ"/>
</xsl:template>

<xsl:template match="������Ģ�⺻����">
<table style="text-align:center;">
	<tr>
		<td style="padding-top:50px;">
			<h3><xsl:value-of select="������Ģ��"/></h3>
		</td>
	</tr>
	<tr>
		<td>
			<span class="blueText">
			[���� <xsl:value-of select="substring(�߷�����,1,4)"/>.<xsl:value-of select="substring(�߷�����,5,2)"/>.<xsl:value-of select="substring(�߷�����,7,2)"/>.]
			[<xsl:value-of select="�Ұ���ó��"/><xsl:value-of select="������Ģ����"/> �� <xsl:value-of select="�߷ɹ�ȣ"/>ȣ,
			<xsl:value-of select="substring(�߷�����,1,4)"/>.<xsl:value-of select="substring(�߷�����,5,2)"/>.<xsl:value-of select="substring(�߷�����,7,2)"/>.
			,<xsl:value-of select="���������и�"/>]
			</span>
		</td>
	</tr>
	<tr>
		<td align="right">
			<font size="2"><xsl:value-of select="�Ұ���ó"/></font>
		</td>
	</tr>
</table>
</xsl:template>

<xsl:template match="��������">
<table align="center">
	<tr>
		<td style="padding-top: 25px;">
			&#160;<span class="titleText" style="font-size:15px;"><xsl:value-of select="."/></span>
		</td>
	</tr>
</table>
</xsl:template>

<xsl:template match="��Ģ">
<table style="table-layout:fixed">
	<xsl:for-each select="��Ģ����">
	<xsl:variable name="buchickTitle" select="substring-before(substring-after(��Ģ����, '��Ģ'), '&#10;')"></xsl:variable>
	<tr>
		<td>
			<span class="titleText">��&#160;&#160;&#160;&#160;Ģ</span>
			<span class="blueText">&#160;<xsl:value-of select="$buchickTitle"/></span>
		</td>
	</tr>
	<tr>
		<td>
			<pre class="buchick"><xsl:value-of select="substring-after(��Ģ����, '&#10;')"/></pre>
		</td>
	</tr>
	</xsl:for-each>
</table>
</xsl:template>

<xsl:template match="��ǥ">
<table>
	<xsl:for-each select="��ǥ����">
		<tr>
			<td>
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
			</td>
		</tr>
	</xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>
