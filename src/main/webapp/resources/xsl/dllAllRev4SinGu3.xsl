<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="ImageURL" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>
<xsl:template match="/">
        <xsl:apply-templates select="law"/>
</xsl:template>

<xsl:template match="law">
	<xsl:apply-templates select="old|new"/>
</xsl:template>     

<xsl:template match="old">
		<xsl:apply-templates select="text()|jo|hang|ho|mok|dan|cont/image|cont/a5b5|cont/text()|cont/table"/>
</xsl:template>     

<xsl:template match="new">
		<xsl:apply-templates select="text()|jo|hang|ho|mok|dan|cont/image|cont/a5b5|cont/text()|cont/table"/>
</xsl:template>   

<xsl:template match="jo">
	<xsl:for-each select=".">
		제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
		(<xsl:value-of select="@title"/>)
		<xsl:choose> 
			<xsl:when test="./cont/text()!=''">
				<xsl:apply-templates select="text()|hang|ho|mok|dan|cont/image|cont/a5b5|cont/text()|cont/table"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="text()|hang|ho|mok|dan|cont/image|cont/a5b5|cont/text()|cont/table"/>
			</xsl:otherwise>
		</xsl:choose>
		ENTER
	</xsl:for-each>
</xsl:template>

<xsl:template match="hang">
    <xsl:for-each select=".">
                <xsl:text disable-output-escaping ="yes">ENTER</xsl:text>
                <xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
		<xsl:apply-templates select="ho|mok|dan|cont/image|cont/a5b5|cont/text()|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="ho">
    <xsl:for-each select=".">
                <xsl:text disable-output-escaping ="yes">ENTER</xsl:text>
		<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;</xsl:text>
		<br/><xsl:apply-templates select="mok|dan|cont/image|cont/a5b5|cont/text()|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok">
    <xsl:for-each select=".">
                <xsl:text disable-output-escaping ="yes">ENTER</xsl:text>
		<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
		<br/><xsl:apply-templates select="dan|cont/image|cont/a5b5|cont/text()|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan">
    <xsl:for-each select=".">
                <xsl:text disable-output-escaping ="yes">ENTER</xsl:text>
		<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
		<br/><xsl:apply-templates select="cont/image|cont/a5b5|cont/text()|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont/text()">
		<xsl:value-of select="."/>
</xsl:template>  

<xsl:template match="text()">
   	<xsl:value-of select="."/>
</xsl:template>  

<xsl:template match="cont/table" >
		$$TABLESTART$$<xsl:value-of disable-output-escaping="yes" select="."/>$$TABLEEND$$<br/>
</xsl:template>

<xsl:template match="image|cont/image">
		<xsl:if test="@hspace!='1'">
			<xsl:text disable-output-escaping ="yes">ENTER</xsl:text>
		</xsl:if>$$IMGFILESTART$$<xsl:value-of select="./@src"/>$$IMGFILEEND$$<br/>
</xsl:template>
	
<xsl:template match="cont/a5b5">
	<xsl:text disable-output-escaping ="yes">ENTER&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
</xsl:template>	
</xsl:stylesheet>