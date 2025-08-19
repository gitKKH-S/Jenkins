<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>
  <xsl:template match="/">
    <html>
    <head>	
    </head>
      <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <xsl:apply-templates select="law"/>
      </body>
    </html>
  </xsl:template>
	
<xsl:template match="cont/img" mode="link">
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
<xsl:template match="cont/table" mode="link">
	<div style='text-indent:0'>
	<xsl:value-of select="." disable-output-escaping="yes"/>
	</div>
</xsl:template>	
<xsl:template match="cont/a5b5" mode="link">
<br/>
</xsl:template>	


</xsl:stylesheet>
