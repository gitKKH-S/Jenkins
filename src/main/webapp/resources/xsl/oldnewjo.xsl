<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="Contno" />
<xsl:param name="Contsubno" />
<xsl:param name="allcha" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>
  <xsl:template match="/">
    <html>
        <xsl:apply-templates select="/law"/>
    </html>
  </xsl:template>
  
  <xsl:template match="law">
	<xsl:element name="body"> 
		<xsl:attribute name="onload">wid('<xsl:value-of select="count(//jo[@contno=$Contno])"/>','<xsl:if test="$Contsubno!=0"><xsl:value-of select="count(//jo[@contsubno=$Contsubno])"/></xsl:if>');</xsl:attribute>
	</xsl:element>
	
  	<xsl:for-each select="jo">
  	<!-- xsl:sort select="@startcha" lang="kr" order="ascending" /-->
  	<xsl:sort select="@startcha" lang="kr" order="descending" data-type="number"/>
  		<td class="xslk" valign="top">
		<xsl:call-template name="nvl4">
	 		<xsl:with-param name="ab" select="@startcha"/>
	 		<xsl:with-param name="cb" select="@curstate"/>
		</xsl:call-template>
		<div class="ds" style="padding:5px;">
		<span class="jonumber">제<xsl:value-of select="@contno"/>조<span class="jotitle"><xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>(<xsl:value-of select="@title"/>)
		</span>
		</span>
		<span class="jocontent"> 
			<xsl:for-each select="./new">
						<xsl:apply-templates select="hang|ho|mok|dan|image|cont" mode="real"/>
			</xsl:for-each>
			<xsl:call-template name="etc">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
		</span>
		</div>
		</td>
  	</xsl:for-each>
  </xsl:template>
<xsl:template match="jo">
	<xsl:if test="substring(translate(../@jotitle,' ',''),1,2)!='buchick'">
	<xsl:if test="@startcha >= $allcha">
		<xsl:element name="body"> 
			<xsl:attribute name="onload">wid('<xsl:value-of select="count(//jo[@contno=$Contno])"/>','<xsl:if test="$Contsubno!=0"><xsl:value-of select="count(//jo[@contsubno=$Contsubno])"/></xsl:if>');</xsl:attribute>
		</xsl:element>
			
		<td class="xslk" valign="top">
		<xsl:call-template name="nvl4">
	 		<xsl:with-param name="ab" select="@startcha"/>
	 		<xsl:with-param name="cb" select="@curstate"/>
		</xsl:call-template>
			<xsl:for-each select=".">
				<xsl:sort select="@startcha" lang="kr" order="descending" />
				<div class="ds" style="padding:5px;">
				<span class="jonumber">제<xsl:value-of select="@contno"/>조<span class="jonumber"><xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>(<xsl:value-of select="@title"/>)
				</span>
				</span>
				<span class="jocontent"> 
					<xsl:for-each select="./new">
						<xsl:apply-templates select="text()|hang|ho|mok|dan|image|cont" mode="real"/>
					</xsl:for-each>
					<xsl:call-template name="etc">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</span>
				</div>
			</xsl:for-each>
		</td>
	</xsl:if>
	</xsl:if>
</xsl:template>
<xsl:template match="cont" mode="real">
    <xsl:for-each select=".">
		<xsl:apply-templates select="./text()|law|bylaw|image|img|a5b5|span|table" mode="real"/>
     </xsl:for-each>
</xsl:template>     
 <xsl:template match="span" mode="real">
	<xsl:element name="span">
	<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
		<xsl:apply-templates select="./text()|table" mode="real"/>
	</xsl:element>
</xsl:template>
 <xsl:template match="hang" mode="real">
	<xsl:for-each select="."><br/>
		<xsl:apply-templates select="cont|ho|mok|dan|image|span" mode="real"/>
	</xsl:for-each>
</xsl:template>     

<xsl:template match="ho" mode="real">
    <xsl:for-each select="."><br/>
		<xsl:apply-templates select="cont|mok|dan|image|span" mode="real"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok" mode="real">
    <xsl:for-each select="."><br/>
		<xsl:apply-templates select="cont|dan|image|span" mode="real"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan" mode="real">
    <xsl:for-each select="."><br/>
		<xsl:apply-templates select="cont|image|span" mode="real"/>
     </xsl:for-each>
</xsl:template>   
<!-- allrevision -->
<xsl:template name="nvl4">	
<xsl:param name="param" select="."/>
<xsl:param name="ab"/>
<xsl:param name="cb"/>
	<xsl:for-each select="//history/hisitem">
	<xsl:if test="./@revcha=$ab">
		<div style="background-color:#d9e7f8;padding:5px;border=1px solid #d9e7f8;">
	    	<span style="font-weight:bold;"> <xsl:value-of select="@title"/></span><br/>
	    	<span class="jocontent2"> 
	    	[시행 : <span class="yunhyuk"><xsl:value-of select="@startdt"/></span>][<!-- xsl:value-of select="@revcd"/> -->개정
	    	: <span class="yunhyuk"><xsl:value-of select="@promuldt"/></span>]
	    	<xsl:if test="$cb='allrevision'">
	    		[조전부개정]
	    	</xsl:if>
	    	</span>
    	</div>
	</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template match="buchick">
</xsl:template>

<!-- xsl:template match="법bylaw" mode="link">
    <a>
        <xsl:attribute name="href">javascript:link_('<xsl:value-of select="./@id"/>','<xsl:value-of select="./@조번호"/>');</xsl:attribute>
        <xsl:value-of select="."/>
    </a>
</xsl:template>
<xsl:template match="bylaw" mode="link">
    <a>
        <xsl:attribute name="href">javascript:onclick=link('<xsl:value-of select="./@id"/>','<xsl:value-of select="./@조번호"/>');</xsl:attribute>
        <xsl:if test="./@조번호!='bon0'">
        <xsl:attribute name="onmousemove">loca(10,-13,event) </xsl:attribute> 
	    <xsl:attribute name="onmouseover">msg('<xsl:value-of select="./@id"/>','<xsl:value-of select="./@조번호"/>') </xsl:attribute> 
	    <xsl:attribute name="onmouseout">notshow() </xsl:attribute> 
	    </xsl:if>
        <xsl:value-of select="."/>
    </a>
</xsl:template -->

<xsl:template match="image" >
	<table cellpadding='0' cellspacing='0' border='0'>
	<tr><td>
		<xsl:apply-templates select="." mode="link"/>
	</td></tr>
	</table>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
	<table cellpadding='0' cellspacing='0' border='0'>
	<tr><td>
		<p><img><xsl:attribute name="src">/kribblaw/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img></p>
	</td></tr>
	</table>
</xsl:template>
<xsl:template match="cont/span" mode="link">
	<xsl:element name="span">
	<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

<xsl:template match="image" mode="real">
	<table cellpadding='0' cellspacing='0' border='0'>
	<tr><td>
		<p><img><xsl:attribute name="src">/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img></p>
	</td></tr>
	</table>
</xsl:template>	
<xsl:template match="table" mode="real">
	<xsl:value-of select="." disable-output-escaping="yes"/>
</xsl:template>	

<xsl:include href="util.xsl"/>
<xsl:include href="common.xsl"/>
</xsl:stylesheet>
