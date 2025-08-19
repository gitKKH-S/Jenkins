<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="ImageURL" />
  <xsl:template match="/">
    <html>
      <head>
            <style type="text/css">
	            .jonumber {font-size:10pt; font-weight:bold; color:#8db761;}
				.jotitle {font-size:10pt; font-weight:bold; color:#8db761;}
                .jocontent {font-size:9pt; TEXT-ALIGN:justify;}
                .txt1 {      line-height: 160% ;  font-size: 15pt; font:bold    }    
                .txt2 {    font-size: 15pt; font-weight:bold;     }
                .txt3 {font-size: 12pt;
                       line-height: 160% ; 
                       color: #3399ff;
                       font-family: "굴림", "Arial";  }
                a:link {
                     font-family: "돋움", "돋움체", "굴림", "굴림체";
                     font-size: 10pt;
                     color: #3399ff;
                     text-decoration: none;
                    }
                a:visited {
                     font-family: "돋움", "돋움체", "굴림", "굴림체";
                     font-size: 10pt;
                     color: #3399ff;
                     text-decoration: none;
                    }
                a:hover {
                     font-family: "돋움", "돋움체", "굴림", "굴림체";
                     font-size: 10pt;
                     color: #3399ff;
                     text-decoration: none;
                    }
               a:active { color: #3399ff; font-size: 10pt; text-decoration: none;}
               .txt4 {font-size: 12pt;
                     line-height: 150% ; 
                     color: #3399ff;
                     font-family: "굴림", "Arial";}
               .txt5 {font-size: 12pt;
                     font-weight:bold 
                     line-height: 150% ; 
                     color: #3399ff;
                     font-family: "굴림", "Arial";}
               .txt6 {font-size: 13pt;
                     font-weight:bold ;
                     line-height: 180% ; 
                     color: #3399ff;
                     font-family: "굴림", "Arial";}
		P {
			margin : 0px;
			font-weight:bold ;
		}
            </style>
      </head>
      <body>
        <xsl:apply-templates select="law"/>
        <xsl:apply-templates select="bon"/>
	<xsl:apply-templates select="pyun"/>
	<xsl:apply-templates select="jang"/>
	<xsl:apply-templates select="jeol"/>
	<xsl:apply-templates select="gwan"/>
	<xsl:apply-templates select="jo"/>
	<xsl:apply-templates select="buchick"/>
	<xsl:apply-templates select="bookmark"/>
	<xsl:apply-templates select="image"/>
      </body>
    </html>
</xsl:template>

<xsl:template match="bon">
	<xsl:for-each select=".">
		<xsl:apply-templates select="bookmark"/>
     </xsl:for-each>
</xsl:template>    

<xsl:template match="jo">
	<xsl:for-each select=".">
	제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
				(<xsl:value-of select="@title"/>)
		<xsl:apply-templates select="hang|mok|dan|image|cont"/>
     </xsl:for-each><br/><br/>
</xsl:template>     

<xsl:template match="hang">
    <xsl:for-each select=".">
		<xsl:apply-templates select="ho|mok|dan|cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
		<br/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="ho">
    <xsl:for-each select=".">
		<br/><xsl:apply-templates select="mok|dan|cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok">
    <xsl:for-each select=".">
		<br/><xsl:apply-templates select="dan|cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan">
    <xsl:for-each select=".">
		<br/><xsl:apply-templates select="cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="buchick">
	<xsl:for-each select=".">
		<xsl:apply-templates select="jo|hang|ho|mok|dan|cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont" >
    <xsl:for-each select=".">
		<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
		<xsl:apply-templates select="a5b5"/>
		<xsl:apply-templates select="./text()|FONT" mode="col"/>
		<xsl:apply-templates select="table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="FONT" mode="col">
    <xsl:for-each select=".">
		<xsl:apply-templates select="."/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont/text()" mode="col">
    <xsl:for-each select=".">
		<br/><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text><xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
		<xsl:apply-templates select="."/><xsl:apply-templates select="a5b5"/>
     </xsl:for-each>
</xsl:template>  

<xsl:template match="table" >
		<br/><br/><xsl:value-of disable-output-escaping="yes" select="."/>
</xsl:template>

<!-- 이미지 -->

<xsl:template match="image" >
		<xsl:apply-templates select="." mode="link"/>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
		
	<xsl:element name="image">
	        <xsl:if test="@style!=''">
			<xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
		</xsl:if>
	        <xsl:if test="@height!=''">
			<xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
		</xsl:if>
	        <xsl:if test="@width!=''">
			<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
		</xsl:if>
		<xsl:attribute name="hspace"><xsl:value-of select="@hspace"/></xsl:attribute>
		<xsl:attribute name="src"><xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/></xsl:attribute>
		<xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
	</xsl:element>
</xsl:template>
	
<xsl:template match="cont/a5b5">
<br/>@@@
</xsl:template>	

<xsl:template match="a5b5">
<br/>
</xsl:template>	

<xsl:template match="contno">
<table>
<tr>
<td>
  <span class="jocontent">
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