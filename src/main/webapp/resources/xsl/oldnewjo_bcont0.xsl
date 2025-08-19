<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="Contno" />
<xsl:param name="Contsubno" />
<xsl:param name="allcha" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>
	<xsl:template match="law">
		<xsl:value-of select="@title"/><span style="margin-left:15px"><xsl:apply-templates select="history"/></span><br/>
		<xsl:apply-templates select="bon"/>	
	</xsl:template>

	<xsl:template match="history">
		<xsl:apply-templates select="hisitem"/>
	</xsl:template>
	
	<xsl:template match="hisitem">
		<xsl:if test="@bookid = $bookid">
			<xsl:value-of select="@revcha"/>차 / <xsl:value-of select="@revcd"/> / <xsl:value-of select="@promuldt"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="bon">
		<xsl:choose>
			<xsl:when test="count(pyun)>1">
				<xsl:apply-templates select="pyun"/>	
			</xsl:when>
			<xsl:when test="count(jang)>1">
				<xsl:apply-templates select="jang"/>
			</xsl:when>
			<xsl:when test="count(jeol)>1">
				<xsl:apply-templates select="jeol"/>
			</xsl:when>
			<xsl:when test="count(gwan)>1">
				<xsl:apply-templates select="gwan"/>
			</xsl:when>
			<xsl:when test="count(jo)>1">
				<xsl:apply-templates select="jo"/>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="pyun">
		<xsl:if test="@endcha='9999'">
			<xsl:apply-templates select="jang|jeol|gwan|jo"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="jang">
		<xsl:if test="@endcha='9999'">
			<xsl:apply-templates select="jeol|gwan|jo"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="jeol">
		<xsl:if test="@endcha='9999'">
			<xsl:apply-templates select="gwan|jo"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="gwan">
		<xsl:if test="@endcha='9999'">
			<xsl:apply-templates select="jo"/>
		</xsl:if>			
	</xsl:template>
	
	<xsl:template match="jo">
		<xsl:if test="@contno = $Contno">
				<xsl:if test="@endcha='9999'">
					<span style="color:blue;font-size:12pt">
					제 <xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>(<xsl:value-of select="@title"/>)
					</span>
					<xsl:value-of select="cont"/><br/>
					<xsl:apply-templates select="hang|ho|mok|dan"></xsl:apply-templates>
				</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="hang">
		<xsl:value-of select="cont"/><br/>
   		<xsl:apply-templates select="ho"></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="ho">
		<xsl:value-of select="cont"/><br/>
		<xsl:apply-templates select="mok"></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="mok">
		<xsl:value-of select="cont"/><br/>
		<xsl:apply-templates select="dan"></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="dan">
		<xsl:value-of select="cont"/><br/>
	</xsl:template>
	
	<xsl:template match="buchicklist">
		<xsl:apply-templates select="buchick"/>
	</xsl:template>
	
</xsl:stylesheet>
