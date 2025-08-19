<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="buchickText" />
<xsl:param name="ImageURL" />
<xsl:param name="buchickTitle" />
<xsl:param name="paraFont" />
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="schtxt" />
<xsl:param name="Obookid" />
<xsl:param name="deptname" />
<xsl:param name="ListS" />
<xsl:param name="type" />
<xsl:param name="allcha" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- ��Ʈ template -->
<!-- ������ ���� ���ΰ������� -->

<xsl:template match="/">
<html>
	<head>
		<style xmlns:fo="http://www.w3.org/1999/XSL/Format" type="text/css">
			* {
				font-size:14pt;
			}
		table td {word-wrap:break-word;word-break:break-all;}
		P.HStyle0, LI.HStyle0, DIV.HStyle0
			{style-name:"������"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle1, LI.HStyle1, DIV.HStyle1
			{style-name:"����"; margin-left:15.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle2, LI.HStyle2, DIV.HStyle2
			{style-name:"���� 1"; margin-left:10.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle3, LI.HStyle3, DIV.HStyle3
			{style-name:"���� 2"; margin-left:20.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle4, LI.HStyle4, DIV.HStyle4
			{style-name:"���� 3"; margin-left:30.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle5, LI.HStyle5, DIV.HStyle5
			{style-name:"���� 4"; margin-left:40.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle6, LI.HStyle6, DIV.HStyle6
			{style-name:"���� 5"; margin-left:50.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle7, LI.HStyle7, DIV.HStyle7
			{style-name:"���� 6"; margin-left:60.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle8, LI.HStyle8, DIV.HStyle8
			{style-name:"���� 7"; margin-left:70.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle9, LI.HStyle9, DIV.HStyle9
			{style-name:"�� ��ȣ"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle10, LI.HStyle10, DIV.HStyle10
			{style-name:"�Ӹ���"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:150%; font-size:9.0pt; font-family:����; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle11, LI.HStyle11, DIV.HStyle11
			{style-name:"����"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:����; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle12, LI.HStyle12, DIV.HStyle12
			{style-name:"����"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:����; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
		P.HStyle13, LI.HStyle13, DIV.HStyle13
			{style-name:"�޸�"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:9.0pt; font-family:����; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
            </style>
	</head>	
	<body leftmargin="0" topmargin="5" marginwidth="0" marginheight="0">
		<xsl:apply-templates select="law"/>
	</body>
</html>
</xsl:template>

<!-- ���� template ���� -->

<xsl:template match="history">
<form name="revi" method="post">
<input type="hidden" name="Bookid"/>
<input type="hidden" name="Obookid"/>
<input type="hidden" name="Statecd"/>
<input type="hidden" name="ListS"/>
<input type="hidden" name="type"/>

	<!-- ���� ��ü ���� -->
	<xsl:for-each select="./hisitem">
		<xsl:if test="./@bookid=$bookid">
			<p style="font-family:'$paraFont'; text-align:center; font-size:14pt;"><xsl:value-of select="@title"/></p><p>&amp;nbsp;</p>
		</xsl:if>
	</xsl:for-each>
	<!-- ���� ������ select box -->
	<xsl:for-each select="./hisitem">
		<xsl:sort select="@startdt" order="ascending" />
		<xsl:if test="./@revcha&lt;=$revcha">
			<p style="text-align:right;font-size:14pt;">��<xsl:value-of select="./@revcha"/>��/<xsl:value-of select="./@revcd"/>&amp;nbsp;&amp;nbsp;<xsl:value-of select="./@promuldt"/><xsl:if test="./@otherlaw!=''">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;(<xsl:value-of select="./@otherlaw"/>)</xsl:if></p>
		</xsl:if>
	</xsl:for-each>
	<br/>&amp;nbsp;
	
</form>
</xsl:template>

<!-- ���� template �� -->

<!-- ���� template ���� -->

<!-- �� / �� / �� / �� / �� template -->

<xsl:template match="pyun">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<br/>&amp;nbsp;
		<p style=" text-align:center;font-size:14pt;">��<xsl:value-of select="./@contno"/>�� <xsl:value-of select="./@title"/></p>
		<br/>&amp;nbsp;
	<xsl:apply-templates select="jang|jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
	
</xsl:template>

<xsl:template match="jang">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<br/>&amp;nbsp;
		<p style="font-family:'$paraFont'; font-size:14pt; text-align:center; ">
			��<xsl:value-of select="./@contno"/>��<xsl:if test="./@contsubno > 0">��<xsl:value-of select="@contsubno"/></xsl:if>
		 	&amp;nbsp;<xsl:value-of select="./@title"/>
		</p>
		<br/>&amp;nbsp;
	<xsl:apply-templates select="jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jeol">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<br/>&amp;nbsp;
		<p style="font-family:'$paraFont'; font-size:14pt; text-align:center;">
			��<xsl:value-of select="./@contno"/>�� <xsl:if test="./@contsubno > 0">��<xsl:value-of select="@contsubno"/></xsl:if> 
			&amp;nbsp;<xsl:value-of select="./@title"/>
		</p>
		<br/>&amp;nbsp;
	<xsl:apply-templates select="gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="gwan">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<br/>&amp;nbsp;
		<p style="font-family:'$paraFont'; font-size:14pt; text-align:center;justify">
			��<xsl:value-of select="./@contno"/>��  <xsl:value-of select="./@title"/></p>
		<br/>&amp;nbsp;
	<xsl:apply-templates select="jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jo">
		<xsl:for-each select=".">
				<p style="font-family:'$paraFont'; text-align:ParagraphShapeAlignJustify;font-size:14pt;">
				��<xsl:value-of select="@contno"/>��<xsl:if test="./@contsubno>0">��<xsl:value-of select="@contsubno"/></xsl:if> 
					<xsl:choose> 
						<xsl:when test="contains(./cont/text(),'���� ����')">
				        	<br>&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</br>
				    	</xsl:when>
					    <xsl:otherwise>
					    	<xsl:choose> 
					    	<xsl:when test="@title=''">
					    		<br>&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</br>
					    	</xsl:when>
					    	<xsl:otherwise>
					    	(<xsl:value-of select="@title"/>)
					    	</xsl:otherwise>
					    	</xsl:choose> 
					    </xsl:otherwise>
				    </xsl:choose>
					<span  style="font-family:'$paraFont'; text-align:ParagraphShapeAlignJustify; font-size:14pt;">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/table|cont/img|cont/a5b5" mode="link"/>
					</span>
					<xsl:choose> 
						<xsl:when test="./cont/text()!=''">
							<div>
								<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</p>
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

<!-- ��Ģ -->

<xsl:template match="buchick">
<br/>&amp;nbsp;
		<p style="text-align:left;font-size:14pt;" >
			<xsl:value-of select="$buchickText"/>
		</p>
		<xsl:for-each select=".">
		<xsl:if test="$buchickTitle='yes'">
		<p style="text-align:center;font-size:14pt;" >
			<xsl:value-of select="@title"/>
		</p>
		</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="./jo">
			<p style="font-weight:normal; text-align:left;font-size:14pt;">
				��<xsl:value-of select="@contno"/>��<xsl:if test="./@contsubno>0">��<xsl:value-of select="@contsubno"/></xsl:if> 
					<xsl:choose> 
						<xsl:when test="contains(./cont/text(),'���� ����')">
				        	<br/>&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;
				    	</xsl:when>
					    <xsl:otherwise>
					    	<xsl:choose> 
					    	<xsl:when test="@title=''">
					    		<br>&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</br>
					    	</xsl:when>
					    	<xsl:otherwise>
					    	(<xsl:value-of select="@title"/>)
					    	</xsl:otherwise>
					    	</xsl:choose> 
					    </xsl:otherwise>
				    </xsl:choose> 
				<span  style="font-family:'$paraFont'; text-align:justify;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
				</span>
				<xsl:choose> 
					<xsl:when test="./cont/text()!=''">
						<div style="font-family:'$paraFont'; text-align:justify;">
							<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</p>
		</xsl:for-each>
		<p style="font-weight:normal; text-align:left;font-size:14pt;">
			<xsl:call-template name="etc">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/><br/>
		</p>
</xsl:template>

<!-- ��ǥ -->

<xsl:template match="byul">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<xsl:for-each select=".">
			<p style="text-align:left;font-weight:normal;" ><xsl:value-of select="./@showtitle"/></p>
		</xsl:for-each>   
	</xsl:if>
	</xsl:if>             
</xsl:template>

<!-- �������� -->

<xsl:template match="byulji"> 
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">  
		<xsl:for-each select=".">
			<xsl:choose> 
			<xsl:when test="./@serverfilename!=''">   
				<p style="text-align:left;font-weight:normal;" >
					<xsl:element name="span">
						<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
						<xsl:attribute name="style">cursor:hand;</xsl:attribute>
						<xsl:value-of select="./@showtitle"/>
					</xsl:element>
				</p>
			</xsl:when>
			<xsl:otherwise> 
				<span style="text-align:left;font-weight:normal;">&lt;<xsl:value-of select="./@byulcd"/>����&gt;<xsl:value-of select="./@title"/></span>
				<br/>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:if>
	</xsl:if>           
</xsl:template>

<!-- ��÷ -->

<xsl:template match="byulch">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">  
		<xsl:for-each select=".">
		<xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
			<p style="text-align:left;font-weight:normal;" >
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:when>
		<xsl:otherwise>   
			<span style="text-align:left;font-weight:normal;"><xsl:value-of select="./@showtitle"/></span>
			<br/>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:for-each> 
	</xsl:if>
	</xsl:if>             
</xsl:template>

<!-- ���� -->

<xsl:template match="cont/text()" mode="link">
	<xsl:value-of select="."/><!--  disable-output-escaping="yes" -->
</xsl:template> 

<!-- bylaw -->

<xsl:template match="cont/law" mode="link">
        <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="cont/bylaw" mode="link">
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="cont/table" mode="link">
		<xsl:value-of disable-output-escaping="yes" select="."/>
</xsl:template>

<!-- �̹��� -->

<xsl:template match="image" >
	<table cellpadding='0' cellspacing='0' border='0'>
	<tr><td>
		<xsl:apply-templates select="." mode="link"/>
	</td></tr>
	</table>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>

	<img><xsl:attribute name="src"><xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img>
</xsl:template>
	
<xsl:template match="cont/img" mode="link">
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

<xsl:template match="cont/a5b5" mode="link">
<br>&amp;nbsp;</br>
</xsl:template>	

<xsl:template name="etc">	
	<xsl:param name="param" select="."/>
	<xsl:for-each select="hang">
		<xsl:choose> 
			<xsl:when test=" (position() =1)">
				<span style="font-family:'$paraFont'; text-align:justify; font-size:14pt;"><!--style="text-indent:1em"0-->
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/> 
					<xsl:for-each select="ho">
						<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
							<xsl:for-each select="mok">
								<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
									<xsl:for-each select="dan">
										<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
											<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
										</div>
									</xsl:for-each>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
					<xsl:for-each select="mok">
						<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
							<xsl:for-each select="dan">
								<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
					<xsl:for-each select="dan">
						<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						</div>
					</xsl:for-each>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;"><!--style="text-indent:1em"0-->
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/> 
					<xsl:for-each select="ho">
						<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
							<xsl:for-each select="mok">
								<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
									<xsl:for-each select="dan">
										<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
											<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
										</div>
									</xsl:for-each>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
					<xsl:for-each select="mok">
						<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
							<xsl:for-each select="dan">
								<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b|cont/table" mode="link"/>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
					<xsl:for-each select="dan">
						<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						</div>
					</xsl:for-each>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	
	<xsl:for-each select="ho">
		<xsl:choose> 
			<xsl:when test=" (position() =1)">
				<span  style="font-family:'$paraFont'; text-align:ParagraphShapeAlignJustify; font-size:14pt;">
					<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
					<xsl:for-each select="mok">
						<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
							<xsl:for-each select="dan">
								<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<div  style="font-family:'$paraFont'; text-align:ParagraphShapeAlignJustify; font-size:14pt;">
					<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
					<xsl:for-each select="mok">
						<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
							<xsl:for-each select="dan">
								<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	
	<xsl:for-each select="mok">
		<xsl:choose> 
			<xsl:when test=" (position() =1)">
				<span  style="font-family:'$paraFont'; text-align:ParagraphShapeAlignJustify; font-size:14pt;">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
					<xsl:for-each select="dan">
						<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						</div>
					</xsl:for-each>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<div  style="font-family:'$paraFont'; text-align:ParagraphShapeAlignJustify; font-size:14pt;">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
					<xsl:for-each select="dan">
						<div style="font-family:'$paraFont'; text-align:justify; font-size:14pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/table" mode="link"/>
						</div>
					</xsl:for-each>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>