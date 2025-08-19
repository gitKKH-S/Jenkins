<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="revcha" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- ��Ʈ template -->

<xsl:template match="bon">
	<p>
		<xsl:for-each select="//jo[@startcha=$revcha and @singugbn='gaejung']">
			<p class="title">
				��<xsl:value-of select="@contno"/>�� <xsl:if test="./@contsubno!='0'"> ��<xsl:value-of select="@contsubno"/></xsl:if> 
				<xsl:if test="./ghist/@to!='null'">�� ����</xsl:if>
				<xsl:apply-templates select="hang|ho|mok|dan|ghist"/>	
				
				<xsl:if test="./@state='new'">
					 ������ ���� �ż� �Ѵ�.<br/>
					<xsl:apply-templates select="all_sin"/>
				</xsl:if>
				
				<xsl:if test="./@state='allrevision'">
					������ ���� ���ΰ����Ѵ�.<br/>
					<xsl:apply-templates select="all_sin"/>
				</xsl:if>
			</p> 
		</xsl:for-each>
	</p>
</xsl:template>
<xsl:template match="all_sin">
	<xsl:apply-templates select="hang|ho|mok|dan|cont" mode="aslink"/>	
</xsl:template>

<xsl:template match="hang" mode="aslink">
	<xsl:apply-templates select="ho|mok|dan|cont"/><br/>		
</xsl:template>

<xsl:template match="ho" mode="aslink">
	<xsl:apply-templates select="mok|dan|cont"/><br/>		
</xsl:template>

<xsl:template match="mok" mode="aslink">
	<xsl:apply-templates select="dan|cont"/><br/>		
</xsl:template>

<xsl:template match="dan" mode="aslink">
	<xsl:apply-templates select="cont"/><br/>		
</xsl:template>

<xsl:template match="cont" mode="aslink">
	<xsl:value-of select="."/><br/>	
</xsl:template>

<xsl:template match="hang">
	<xsl:if test="./ghist/@to!='null'"><xsl:value-of select="@contno"/>��</xsl:if>
	<xsl:if test="./ghist/@to!='null'">�� ����</xsl:if>
	<xsl:apply-templates select="ho|mok|dan|ghist"/>	
</xsl:template>

<xsl:template match="ho">
	<xsl:if test="./ghist/@to!='null'"><xsl:value-of select="@contno"/>ȣ</xsl:if>
	<xsl:if test="./ghist/@to!='null'">�� ����</xsl:if>
	<xsl:apply-templates select="mok|dan|ghist"/>	
</xsl:template>

<xsl:template match="mok">
	<xsl:if test="./ghist/@to!='null'"><xsl:value-of select="@contno"/>��</xsl:if>
	<xsl:if test="./ghist/@to!='null'">�� ����</xsl:if>
	<xsl:apply-templates select="dan|ghist"/>	
</xsl:template>

<xsl:template match="dan">
	<xsl:if test="./ghist/@to!='null'"><xsl:value-of select="@contno"/>��</xsl:if>
	<xsl:if test="./ghist/@to!='null'">�� ����</xsl:if>
	<xsl:apply-templates select="ghist"/>	
</xsl:template>

<xsl:template match="ghist">
	'<xsl:value-of select="@from"/>'(��)�� '<xsl:value-of select="@to"/>' ���� �����Ѵ�.<br>&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</br>
</xsl:template>

<xsl:template match="BU">
<xsl:if test="./@STARTCHA=$revcha">
	<div class="no" style="font-size:18px;" width="100%" align="center"><strong class="no" style="font-size:18px;"><xsl:value-of select="@TITLE"/></strong></div>
<xsl:value-of select="."/>
</xsl:if>
</xsl:template>
<xsl:template match="a5b5" mode="link">
<br>&amp;nbsp;</br>
</xsl:template>	
<xsl:template match="text()" mode="link">
<xsl:value-of select="."/>
</xsl:template>	
</xsl:stylesheet>
