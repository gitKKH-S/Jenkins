<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="startcha" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- 내규 template 시작 -->

<xsl:template match="/">
		<body>
			<xsl:apply-templates select="law"/>
		</body>
</xsl:template>

<xsl:template match="law">
	<xsl:apply-templates select="byullist"/>	
</xsl:template>

<xsl:template match="byullist">
	<xsl:apply-templates select="byul|byulch|byulji"/>	
</xsl:template>


<xsl:template match="byul">
		<xsl:call-template name="allbyul">
			<xsl:with-param name="param" select="."/>
		</xsl:call-template>
</xsl:template>

<xsl:template match="byulji">
		<xsl:call-template name="allbyul">
			<xsl:with-param name="param" select="."/>
		</xsl:call-template>
</xsl:template>

<xsl:template match="byulch">
		<xsl:call-template name="allbyul">
			<xsl:with-param name="param" select="."/>
		</xsl:call-template>
</xsl:template>

<xsl:template name="allbyul">
	<xsl:if test="./@startcha&lt;=$startcha">
	    <xsl:if test="./@endcha&gt;=$startcha">
		<xsl:if test="./@serverfilename != ''">	
			<jul node="byul">
				<xsl:value-of select="./@showtitle"/>$<xsl:value-of select="./@pcfilename"/>$<xsl:value-of select="./@serverfilename"/>$
			</jul> 
		</xsl:if>
	    </xsl:if>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
