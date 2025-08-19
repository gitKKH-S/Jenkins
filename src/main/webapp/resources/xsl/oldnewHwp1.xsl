<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="bookid" />
<xsl:param name="startcha" />
<xsl:param name="endcha" />
<xsl:param name="FileDownURL" />
<xsl:param name="ImageURL" />
<xsl:param name="LawKoreaURL" />
<xsl:param name="BylawURL" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- ���� template ���� -->

<xsl:template match="/">
			<xsl:apply-templates select="bon"/>
			<xsl:apply-templates select="law"/>
			<xsl:apply-templates select="pyun"/>
			<xsl:apply-templates select="jang"/>
			<xsl:apply-templates select="jeol"/>
			<xsl:apply-templates select="gwan"/>
			<xsl:apply-templates select="jo"/>
			<xsl:apply-templates select="buchicklist"/>
			<xsl:apply-templates select="buchick"/>
			<xsl:apply-templates select="byullist"/>
			<xsl:apply-templates select="byul"/>
			<xsl:apply-templates select="byulch"/>	
			<xsl:apply-templates select="byulji"/>	
</xsl:template>

<!-- �� / �� / �� / �� / �� template -->

<xsl:template match="law">
	<div align="center" width="100%"><font size="20pt" face="�޸����">�š����������ǥ</font></div>
	<table width="560" border="1">
		<tr>
			<td width="280" align="center"><font size="15pt" face="�޸����">����</font></td>
			<td width="280" align="center"><font size="15pt" face="�޸����">������</font></td>
		</tr>
			<xsl:apply-templates select="jo"/>
	</table>
</xsl:template>

<xsl:template match="jo">
	<xsl:for-each select=".">
		<tr>
			<td valign="top">
				<strong>��<xsl:value-of select="@f_contno"/>��<xsl:if test="./@f_contsubno>0">��<xsl:value-of select="@f_contsubno"/></xsl:if>(<xsl:value-of select="@f_title"/>)</strong><br/>
				<xsl:apply-templates select="cont_gu|hang|ho|mok|dan|image" mode="gugu"/>
			</td>
			<td valign="top">
				<strong>��<xsl:value-of select="@contno"/>��<xsl:if test="./@contsubno>0">��<xsl:value-of select="@contsubno"/></xsl:if>(<xsl:value-of select="@title"/>)</strong><br/>
				<xsl:apply-templates select="cont_sinbar|hang|ho|mok|dan|image" mode="sinsin" />
			</td>
		</tr>
    </xsl:for-each>
</xsl:template>     

<xsl:template match="hang" mode="gugu">
    <xsl:for-each select=".">
		<xsl:apply-templates select="cont_gu|ho|mok|dan|image" mode="gugu"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="ho" mode="gugu">
    <xsl:for-each select=".">
		<xsl:apply-templates select="cont_gu|mok|dan|image" mode="gugu"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok" mode="gugu">
    <xsl:for-each select=".">
		<xsl:apply-templates select="cont_gu|dan|image" mode="gugu"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan" mode="gugu">
    <xsl:for-each select=".">
		<xsl:apply-templates select="cont_gu|image" mode="gugu"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="hang" mode="sinsin">
    <xsl:for-each select=".">
		<xsl:apply-templates select="cont_sinbar|ho|mok|dan|image" mode="sinsin"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="ho" mode="sinsin">
    <xsl:for-each select=".">
		<xsl:apply-templates select="cont_sinbar|mok|dan|image" mode="sinsin"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok" mode="sinsin">
    <xsl:for-each select=".">
		<xsl:apply-templates select="cont_sinbar|dan|image" mode="sinsin"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan" mode="sinsin">
    <xsl:for-each select=".">
		<xsl:apply-templates select="cont_sinbar|image" mode="sinsin"/>
     </xsl:for-each>
</xsl:template>  

<xsl:template match="cont_gu" mode="gugu">
	<div>
    <xsl:for-each select=".">
		<xsl:apply-templates select="./text()|u" mode="col"/>
		<xsl:apply-templates select="image"/>
     </xsl:for-each>
     </div>
</xsl:template>     

<xsl:template match="cont_sinbar" mode="sinsin">
	<div>
    <xsl:for-each select=".">
		<xsl:apply-templates select="./text()|u" mode="col"/>
		<xsl:apply-templates select="image"/>
    </xsl:for-each>
    </div>
</xsl:template>     


<xsl:template match="u" mode="col">
	<xsl:element name="u"> 	
		<xsl:apply-templates select="."/>
    </xsl:element>
</xsl:template>     

<!-- �̹��� -->

<xsl:template match="image" >
	<table cellpadding='0' cellspacing='0' border='0'>
	<tr><td>
		<xsl:apply-templates select="." mode="link"/>
	</td></tr>
	</table>
</xsl:template>

<xsl:template match="cont_gu/img" mode="link">
	<div>
	       <img>
	         <xsl:attribute name="src">
	           <xsl:value-of select="./@src"/>
	         </xsl:attribute>
	         <xsl:attribute name="align">
	           <xsl:value-of select="@align"/>
	         </xsl:attribute>
	         <xsl:attribute name="style">
	           <xsl:value-of select="@style"/>
	         </xsl:attribute>
	         <xsl:attribute name="alt">
	           <xsl:value-of select="@alt"/>
	         </xsl:attribute>
	       </img>
	</div>
</xsl:template>

</xsl:stylesheet>
