<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="euc-kr" indent="yes"/>
<!-- 내규 template 시작 -->

<xsl:template match="/">
			<xsl:apply-templates select="law"/>
</xsl:template>

<!-- 편 / 장 / 절 / 관 / 조 template -->

<xsl:template match="law">
	<xsl:apply-templates select="cont_gu|cont_gu4sin|cont_sin"/>
</xsl:template>

<xsl:template match="cont_gu">
	<xsl:for-each select=".">
		<xsl:apply-templates select="text()|image|table|a5b5"/>
	</xsl:for-each>
</xsl:template>     

<xsl:template match="cont_gu4sin">
	<xsl:for-each select=".">
		<xsl:apply-templates select="text()|image|table|a5b5"/>
	</xsl:for-each>
</xsl:template>     

<xsl:template match="cont_sin">
	<xsl:for-each select=".">
		<xsl:apply-templates select="text()|image|table|a5b5"/>
	</xsl:for-each>
</xsl:template>     

<xsl:template match="text()">
   	<xsl:value-of select="."/>
</xsl:template> 

<xsl:template match="table" >
		$$TABLESTART$$<xsl:value-of disable-output-escaping="yes" select="."/>$$TABLEEND$$<br/>
</xsl:template>

<xsl:template match="a5b5" >
<br/>$$A5B5$$
</xsl:template>	

<xsl:template match="image" >
	<xsl:if test="@hspace!='1'">
			<xsl:text disable-output-escaping ="yes">ENTER</xsl:text>
	</xsl:if>
	$$IMGFILESTART$$<xsl:value-of select="./@src"/>$$IMGFILEEND$$<br/>
</xsl:template>


</xsl:stylesheet>
