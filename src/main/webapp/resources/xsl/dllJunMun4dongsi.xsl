<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="ImageURL" />
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="schtxt" />
<xsl:param name="Obookid" />
<xsl:param name="deptname" />
<xsl:param name="ListS" />
<xsl:param name="type" />
<xsl:param name="allcha" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- 루트 template -->

<xsl:template match="/">
<html>
	<head>
		<style xmlns:fo="http://www.w3.org/1999/XSL/Format" type="text/css">
			* {
				font-size:10pt;
			}
		</style>
	</head>	
	<body leftmargin="0" topmargin="5" marginwidth="0" marginheight="0">
		<xsl:apply-templates select="law"/>
	</body>
</html>
</xsl:template>

<!-- 연혁 template 시작 -->

<xsl:template match="history">
<form name="revi" method="post">
<input type="hidden" name="Bookid"/>
<input type="hidden" name="Obookid"/>
<input type="hidden" name="Statecd"/>
<input type="hidden" name="ListS"/>
<input type="hidden" name="type"/>

</form>
</xsl:template>

<!-- 연혁 template 끝 -->

<!-- 내규 template 시작 -->

<!-- 편 / 장 / 절 / 관 / 조 template -->

<xsl:template match="pyun">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<br/>&amp;nbsp;
		<p style=" text-align:center;font-size:12pt;"><strong>제<xsl:value-of select="./@contno"/>편 <xsl:value-of select="./@title"/></strong></p>
		<br/>&amp;nbsp;
	<xsl:apply-templates select="jang|jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
	
</xsl:template>

<xsl:template match="jang">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<br/>&amp;nbsp;
		<p style="font-family:'한컴바탕'; font-size:12pt; text-align:center; ">
		<strong>
			제<xsl:value-of select="./@contno"/>장<xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if>
		 	&amp;nbsp;<xsl:value-of select="./@title"/>
		</strong>
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
		<p style="font-family:'한컴바탕'; font-size:12pt; text-align:center;">
		<strong>
			제<xsl:value-of select="./@contno"/>절 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> 
			&amp;nbsp;<xsl:value-of select="./@title"/>
		</strong>
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
		<p style="font-family:'한컴바탕'; font-size:12pt; text-align:center;justify"><strong>
			제<xsl:value-of select="./@contno"/>관  <xsl:value-of select="./@title"/></strong></p>
		<br/>&amp;nbsp;
	<xsl:apply-templates select="jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jo">
		<xsl:for-each select=".">
			<xsl:if test="./@endcha&gt;=$revcha">
			<xsl:if test="./@startcha&lt;=$revcha">
				<p style="text-align:justify;font-size:10pt;">
				<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if> 
					<xsl:choose> 
						<xsl:when test="contains(./cont/text(),'본조 삭제')">
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
				</strong>
				<xsl:apply-templates select="new" mode="jo"/>
				</p>
			</xsl:if>
			</xsl:if>
		</xsl:for-each>
</xsl:template>

<xsl:template match="new" mode="jo">
		<xsl:for-each select=".">
					<span  style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
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
		</xsl:for-each>
</xsl:template>

<!-- 부칙 -->

<xsl:template match="buchick">
<br/>&amp;nbsp;
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<xsl:for-each select=".">
		<p style="text-align:center;font-size:10pt;" >
			<strong>
			<xsl:choose> 
			<xsl:when test="contains(@title,'7777')">
				부칙
			</xsl:when>
			<xsl:otherwise> 
				<xsl:value-of select="@title"/>
			</xsl:otherwise>
			</xsl:choose> 
			</strong>
		</p>
		<xsl:apply-templates select="new" mode="buchick"/>
		</xsl:for-each>
	</xsl:if> 
	</xsl:if>
</xsl:template>

<xsl:template match="new" mode="buchick">
		<xsl:for-each select=".">
		<xsl:for-each select="./jo">
			<p style="font-weight:normal; text-align:left;font-size:10pt;">
				<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if> 
					<xsl:choose> 
						<xsl:when test="contains(./cont/text(),'본조 삭제')">
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
				</strong>       
				<span  style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
				</span>
				<xsl:choose> 
					<xsl:when test="./cont/text()!=''">
						<div style="font-family:'한컴바탕'; text-align:justify;">
							<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="etc"><xsl:with-param name="param" select="."/></xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</p>
		</xsl:for-each>
		<p style="font-weight:normal; text-align:left;font-size:10pt;">
			<xsl:call-template name="etc">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/><br/>
		</p>
		</xsl:for-each>
</xsl:template>

<!-- 별표 -->

<xsl:template match="byul">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<xsl:for-each select=".">
			<p style="text-align:left;font-weight:normal;" ><xsl:value-of select="./@showtitle"/></p>
		</xsl:for-each>   
	</xsl:if>
	</xsl:if>             
</xsl:template>

<!-- 별지서식 -->

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
				<span style="text-align:left;font-weight:normal;">&lt;<xsl:value-of select="./@byulcd"/>서식&gt;<xsl:value-of select="./@title"/></span>
				<br/>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:if>
	</xsl:if>           
</xsl:template>

<!-- 별첨 -->

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

<!-- 내용 -->

<xsl:template match="cont/text()" mode="link">
	   	<xsl:choose> 
			<xsl:when test="contains(.,'7777')">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise> 
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template> 

<!-- bylaw -->

<xsl:template match="cont/law" mode="link">
        <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="cont/bylaw" mode="link">
	<xsl:value-of select="."/>
</xsl:template>

<!-- 이미지 -->

<xsl:template match="image" >
		<xsl:apply-templates select="." mode="link"/>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
	<xsl:if test="@hspace!='1'">
		<br/>
	</xsl:if>
	<img><xsl:attribute name="src"><xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img>
</xsl:template>
	
<xsl:template match="cont/img" mode="link">
	<div>
        <img>
		<xsl:attribute name="src">
			<xsl:value-of select="$ImageURL"/><xsl:value-of select="./@src"/>
		</xsl:attribute>
		<xsl:attribute name="align">
			<xsl:value-of select="@align"/>
		</xsl:attribute>
        </img>
     </div>
</xsl:template>

<xsl:template match="cont/a5b5" mode="link">
<br>&amp;nbsp;</br>
</xsl:template>	

<xsl:template name="etc">	
	<xsl:param name="param" select="."/>
	<xsl:for-each select="hang">
		<xsl:choose> 
			<xsl:when test=" (position() =1)">
				<span style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;"><!--style="text-indent:1em"0-->
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/> 
					<xsl:for-each select="ho">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
						        <xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
							<xsl:for-each select="mok">
								<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
									<xsl:for-each select="dan">
										<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
											<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
										</div>
									</xsl:for-each>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
					<xsl:for-each select="mok">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
							<xsl:for-each select="dan">
								<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
					<xsl:for-each select="dan">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
						</div>
					</xsl:for-each>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;"><!--style="text-indent:1em"0-->
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/> 
					<xsl:for-each select="ho">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
							<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
							<xsl:for-each select="mok">
								<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
									<xsl:for-each select="dan">
										<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
											<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
										</div>
									</xsl:for-each>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
					<xsl:for-each select="mok">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
							<xsl:for-each select="dan">
								<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
					<xsl:for-each select="dan">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
						</div>
					</xsl:for-each>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	
	<xsl:for-each select="ho">
		<xsl:choose> 
			<xsl:when test=" (position() =1)">
				<span style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
					<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
					<xsl:for-each select="mok">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
							<xsl:for-each select="dan">
								<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
								</div>
							</xsl:for-each>
						</div>
					</xsl:for-each>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
					<xsl:text disable-output-escaping ="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text><xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
					<xsl:for-each select="mok">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
							<xsl:for-each select="dan">
								<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
									<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
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
				<span style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
					<xsl:for-each select="dan">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
						</div>
					</xsl:for-each>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
					<xsl:for-each select="dan">
						<div style="font-family:'한컴바탕'; text-align:justify; font-size:9pt;">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
						</div>
					</xsl:for-each>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>