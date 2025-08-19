<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="bookid" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>
  <xsl:template match="/">
    <html>
      <head></head>
      <body>
        <xsl:apply-templates select="law"/>
      </body>
    </html>
  </xsl:template>
	<xsl:template match="history">
			<!-- 내규 전체 제목 -->
		<p class="title"><xsl:value-of select="/law/@title"/></p>					
	</xsl:template>

	<xsl:template match="pyun">
		<xsl:if test="./@endcha='9999'">
			<p class="pyun">제<xsl:value-of select="./@contno"/>편 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/></p>
		<xsl:apply-templates select="jang|jeol|gwan|jo"/>	
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="jang">
		<xsl:if test="./@endcha='9999'">
			<p class="jang">제<xsl:value-of select="./@contno"/>장 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/></p>	
		<xsl:apply-templates select="jeol|gwan|jo"/>	
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="jeol">
		<xsl:if test="./@endcha='9999'">
			<p class="jeol">제<xsl:value-of select="./@contno"/>절 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/></p>
		<xsl:apply-templates select="gwan|jo"/>	
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="gwan">
		<xsl:if test="./@endcha='9999'">
			<p class="gwan">제<xsl:value-of select="./@contno"/>관 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/></p>
		<xsl:apply-templates select="jo"/>	
		</xsl:if>
	</xsl:template>
	<xsl:template match="jo">
			<xsl:for-each select=".">
				<xsl:if test="./@endcha='9999'">
					<div id="jo">
						<xsl:element name="a">
							<xsl:attribute name="name">bon<xsl:value-of select="@contno"/>
								<xsl:if test="./@contsubno>0">bu<xsl:value-of select="@contsubno"/></xsl:if>
							</xsl:attribute>
							<strong>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
								<xsl:if test="@title!=''">
								(<xsl:value-of select="@title"/>)
								</xsl:if>
							</strong>
						</xsl:element><br/>	
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
						<font color="blue"><xsl:value-of select="@showtag"/></font>
						<xsl:if test="./cont!=''"><br/></xsl:if>
						<xsl:call-template name="etc">
							<xsl:with-param name="param" select="."/>
						</xsl:call-template>
						<br/>
					</div>
				</xsl:if>
			</xsl:for-each>
	</xsl:template>  
	<xsl:template match="buchick">
			<p class="buchik_title">
			<xsl:for-each select=".">
				<xsl:value-of select="@title"/>        
			</xsl:for-each>
			</p>
			<div id="jo">
			<xsl:for-each select="./jo">
				<a><xsl:attribute name="name">buc<xsl:value-of select="@contno"/></xsl:attribute>
					<strong>제<xsl:value-of select="@contno"/>조 <xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
						<xsl:choose> 
							<xsl:when test="contains(./cont/text(),'본조 삭제')">
					        	<br/>
					        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
					    	</xsl:when>
						    <xsl:otherwise>
						    	<xsl:choose> 
						    	<xsl:when test="@title=''">
						    		<br/>
						    		<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
						        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
						        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
						        	<xsl:text disable-output-escaping ="yes">&amp;nbsp;</xsl:text>
						    	</xsl:when>
						    	<xsl:otherwise>
						    	(<xsl:value-of select="@title"/>)
						    	</xsl:otherwise>
						    	</xsl:choose> 
						    </xsl:otherwise>
					    </xsl:choose>
					</strong></a>
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
				<xsl:if test="./cont!=''"><br/></xsl:if>
				<xsl:call-template name="etc">
					<xsl:with-param name="param" select="."/>
				</xsl:call-template>
			</xsl:for-each>
				<xsl:call-template name="etc">
					<xsl:with-param name="param" select="."/>
				</xsl:call-template>
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5" mode="link"/>
			</div>
	</xsl:template>
 
	<!-- 별표 -->
	
	<xsl:template match="byul">
		<xsl:if test="./@endcha='9999'">
		<xsl:for-each select=".">
			<xsl:if test="./@byulcd='별지서식'">
				<xsl:choose> 
				<xsl:when test="./@serverfilename!=''">
					<p class="byulText">
						<xsl:element name="span">
							<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>				
							<xsl:attribute name="style">cursor:pointer;</xsl:attribute>
							&lt;<xsl:value-of select="@byulcd"/> 제<xsl:value-of select="@contno"/><xsl:if test="./@contsubno!='0'">-<xsl:value-of select="@contsubno"/></xsl:if>호&gt;(<xsl:value-of select="@title"/>)
							
						</xsl:element>
					</p>
				</xsl:when>
				<xsl:otherwise> 
					<xsl:if test="./@curstate!='delete'">
						<span class="jocontent3">
						&lt;<xsl:value-of select="@byulcd"/> 제<xsl:value-of select="@contno"/><xsl:if test="./@contsubno!='0'">-<xsl:value-of select="@contsubno"/></xsl:if>호&gt;(<xsl:value-of select="@title"/>)
						</span>
						<br/>
					</xsl:if>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="./@byulcd!='별지서식'">
				<xsl:choose> 
				<xsl:when test="./@serverfilename!=''">
					<p class="byulText">
						<xsl:element name="span">
							<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>				
							<xsl:attribute name="style">cursor:pointer;</xsl:attribute>
							<xsl:value-of select="./@showtitle"/>
						</xsl:element>
					</p>
				</xsl:when>
				<xsl:otherwise> 
					<xsl:if test="./@curstate!='delete'">
						<span class="jocontent3"><xsl:value-of select="./@showtitle"/></span>
						<br/>
					</xsl:if>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>   
	</xsl:if>         
	</xsl:template>
	
	<!-- 별지서식 -->
	
	<xsl:template match="byulji"> 
		<xsl:if test="./@endcha='9999'">    
			<xsl:for-each select=".">
				<xsl:choose> 
				<xsl:when test="./@serverfilename!=''">   
					<p class="byulText">
						<xsl:element name="span">
							<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
							<xsl:attribute name="style">cursor:hand;</xsl:attribute>
							<xsl:value-of select="./@showtitle"/>
						</xsl:element>
					</p>
				</xsl:when>
				<xsl:otherwise> 
					<xsl:if test="./@curstate!='delete'">
						<span class="jocontent3"><xsl:value-of select="./@showtitle"/></span>
						<br/>
					</xsl:if>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>           
	</xsl:template>
	
	<!-- 별첨 -->
	
	<xsl:template match="byulch">
		<xsl:if test="./@endcha='9999'">     
			<xsl:for-each select=".">
			<xsl:choose> 
			<xsl:when test="./@serverfilename!=''">
				<p class="byulText">
					<xsl:element name="span">
						<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
						<xsl:attribute name="style">cursor:hand;</xsl:attribute>
						<xsl:value-of select="./@showtitle"/>
					</xsl:element>
				</p>
			</xsl:when>
			<xsl:otherwise>   
				<xsl:if test="./@curstate!='delete'">
					<span class="jocontent3"><xsl:value-of select="./@showtitle"/></span>
					<br/>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
			</xsl:for-each> 
		</xsl:if>             
	</xsl:template> 
 
	<!-- 내용 -->
	
	<xsl:template match="cont/text()" mode="link">
	  		<xsl:value-of select="."/>
	</xsl:template> 
	
	<!-- 링크 -->
     <xsl:template match="cont/bylaw" mode="link">
        <a  class="lawlk">
            <xsl:attribute name="href">javascript:link('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@jono"/>');</xsl:attribute>
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
	<xsl:template match="cont/law" mode="link">
	    <a class="lawlk">
	        <xsl:attribute name="href">javascript:link_law('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@jono"/>');</xsl:attribute>
	        <xsl:value-of select="."/>
	    </a>
	</xsl:template>
	
	<!-- 이미지 -->
	
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
			<p><img><xsl:attribute name="src">/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img></p>
		</td></tr>
		</table>
	</xsl:template>
	
	<xsl:template name="etc">	
		<xsl:param name="param" select="."/>
		<xsl:for-each select="hang">
			<xsl:value-of select="@showtag"/>
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
			<xsl:for-each select="ho">
				<div id="ho">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
				</div>
				<xsl:for-each select="mok">
					<div id="mok" >
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
					</div>
					<xsl:for-each select="dan">
						<div id="dan" >
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
						</div>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="dan">
					<div id="dan" >
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
					</div>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="mok">
				<div id="mok">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
				</div>
				<xsl:for-each select="dan">
					<div id="dan">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
					</div>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="dan">
				<div class="dan" style="padding-left:20px;padding-top:5px">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="ho">
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
			<xsl:for-each select="mok">
				<div id="mok">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
				</div>
				<xsl:for-each select="dan">
					<div id="dan">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|내용/a5b5|cont/span" mode="link"/><br/>
					</div>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="mok">
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/span" mode="link"/><br/>
			<xsl:for-each select="dan">
				<div id="dan">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|내용/a5b5|cont/span" mode="link"/><br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>		
		<xsl:for-each select="dan">
			<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|내용/a5b5|cont/span" mode="link"/><br/>
		</xsl:for-each>	
	</xsl:template>
	<xsl:include href="util.xsl"/>	
	
 </xsl:stylesheet>
