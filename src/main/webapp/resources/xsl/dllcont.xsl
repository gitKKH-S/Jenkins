<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="ImageURL" />
  <xsl:template match="/">
    <html>
      <head>
            <style type="text/css">
	    body { font-family:batang; font-size:13px;}
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
		table td {word-wrap:break-word;word-break:break-all;}
		P.HStyle0, LI.HStyle0, DIV.HStyle0
			{style-name:"바탕글"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle1, LI.HStyle1, DIV.HStyle1
			{style-name:"본문"; margin-left:15.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle2, LI.HStyle2, DIV.HStyle2
			{style-name:"개요 1"; margin-left:10.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle3, LI.HStyle3, DIV.HStyle3
			{style-name:"개요 2"; margin-left:20.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle4, LI.HStyle4, DIV.HStyle4
			{style-name:"개요 3"; margin-left:30.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle5, LI.HStyle5, DIV.HStyle5
			{style-name:"개요 4"; margin-left:40.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle6, LI.HStyle6, DIV.HStyle6
			{style-name:"개요 5"; margin-left:50.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle7, LI.HStyle7, DIV.HStyle7
			{style-name:"개요 6"; margin-left:60.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle8, LI.HStyle8, DIV.HStyle8
			{style-name:"개요 7"; margin-left:70.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle9, LI.HStyle9, DIV.HStyle9
			{style-name:"쪽 번호"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:굴림; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle10, LI.HStyle10, DIV.HStyle10
			{style-name:"머리말"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:150%; font-size:9.0pt; font-family:굴림; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle11, LI.HStyle11, DIV.HStyle11
			{style-name:"각주"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:바탕; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle12, LI.HStyle12, DIV.HStyle12
			{style-name:"미주"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:바탕; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle13, LI.HStyle13, DIV.HStyle13
			{style-name:"메모"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:9.0pt; font-family:굴림; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
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

<xsl:template match="hang">
    <xsl:for-each select=".">
		<xsl:apply-templates select="ho|mok|dan|cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
		<br/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="ho">
    <xsl:for-each select=".">
		<br/><xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="mok|dan|cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok">
    <xsl:for-each select=".">
		<br/><xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="dan|cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan">
    <xsl:for-each select=".">
		<br/><xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="cont/image|cont/a5b5|cont/text()|FONT|cont/table"/>
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
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
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