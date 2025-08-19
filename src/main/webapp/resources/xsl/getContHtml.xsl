<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="ImageURL" />
  <xsl:template match="/">
    <html>
      <head>
      </head>
      <body>
        <xsl:apply-templates select="law"/>
        <xsl:apply-templates select="bon"/>
	<xsl:apply-templates select="pyun"/>
	<xsl:apply-templates select="jang"/>
	<xsl:apply-templates select="jeol"/>
	<xsl:apply-templates select="gwan"/>
	<xsl:apply-templates select="jo"/>
	<xsl:apply-templates select="hang"/>
	<xsl:apply-templates select="ho"/>
	<xsl:apply-templates select="mok"/>
	<xsl:apply-templates select="dan"/>
	<xsl:apply-templates select="buchick"/>
	<xsl:apply-templates select="bookmark"/>
	<xsl:apply-templates select="image"/>
	<xsl:apply-templates select="hang"/>
      </body>
    </html>
</xsl:template>

<xsl:template match="jo">
	<xsl:for-each select=".">
		<xsl:apply-templates select="hang|ho|mok|dan|cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
     </xsl:for-each>
</xsl:template>    

<xsl:template match="law">
	<xsl:for-each select=".">
		<p>
			<xsl:apply-templates select="jo|hang|ho|mok|dan|cont|new"/>
		</p>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="hang">
    <xsl:for-each select=".">
		<br/><xsl:apply-templates select="ho|mok|dan|cont/image|cont/a5b5|cont/text()|FONT"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="new">
    <xsl:for-each select=".">
		<br/><xsl:apply-templates select="hang|ho|mok|dan|cont/image|cont/a5b5|cont/text()|FONT"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="ho">
    <xsl:for-each select=".">
		<br/><xsl:apply-templates select="mok|dan|cont/image|cont/a5b5|cont/text()|FONT"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok">
    <xsl:for-each select=".">
		<br/><xsl:apply-templates select="dan|cont/image|cont/a5b5|cont/text()|FONT"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan">
    <xsl:for-each select=".">
		<br/><xsl:apply-templates select="cont/image|cont/a5b5|cont/text()|FONT"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="buchick">
	<xsl:for-each select=".">
		<xsl:apply-templates select="jo|hang|ho|mok|dan|cont/image|cont/a5b5|cont/text()|FONT"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="FONT">
    <xsl:for-each select=".">
		<xsl:apply-templates select="."/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont/text()">
		<xsl:value-of select="."/>
</xsl:template>  

<xsl:template match="table" >
		<xsl:value-of disable-output-escaping="yes" select="."/>
</xsl:template>

<!-- 이미지 -->

<xsl:template match="image" >
		<xsl:apply-templates select="." mode="link"/>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
			<xsl:if test="@hspace!='1'">
				<br/>
			</xsl:if> 
			<img>
				<xsl:attribute name="src">
					<xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/>
				</xsl:attribute>
				<xsl:attribute name="align">
					<xsl:value-of select="@align"/>
				</xsl:attribute>
			</img>
</xsl:template>
	
<xsl:template match="cont/a5b5">
<br/>
</xsl:template>	

<xsl:template match="a5b5">
<br/>
</xsl:template>	

<xsl:template match="contno">
<table>
<tr>
<td>
  <span>
    <xsl:for-each select=".">
      <strong><xsl:value-of select="."/></strong>
      <xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
      <xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
	<xsl:apply-templates select="image"/>
    </xsl:for-each>
  </span>
</td>
</tr>
</table>
</xsl:template>


</xsl:stylesheet>