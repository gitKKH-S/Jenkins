<?xml version="1.0" encoding="euc-kr"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>
	
<!-- 루트 template -->
 <!--xsl:template match="/">
   <html>
     <body>
     <center>
       <xsl:apply-templates select="law"/>
     </center>
     </body>
   </html>
 </xsl:template-->
	
<!-- 연혁 template -->
<xsl:template match="history">
	<xsl:for-each select="./hisitem">
		<xsl:if test="./@bookid=$bookid">
			<p class="title"><xsl:value-of select="@title"/></p>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template match="pyun">
		<xsl:for-each select="./jeol">
			<xsl:call-template name="nvl">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
		</xsl:for-each>
</xsl:template>
  
<xsl:template match="jang">
	<xsl:for-each select=".">
		<xsl:call-template name="nvl">
			<xsl:with-param name="param" select="."/>
		</xsl:call-template>
		<xsl:for-each select="./jeol">
			<xsl:call-template name="nvl">
				<xsl:with-param name="param" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="./gwan">
		<xsl:call-template name="nvl">
			<xsl:with-param name="param" select="."/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template match="jo">
	<xsl:for-each select=".">
		<xsl:call-template name="nvl2">
			<xsl:with-param name="param" select="."/>
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template match="buchick">
	<xsl:call-template name="bul">
		<xsl:with-param name="param" select="."/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="법링크" mode="link">
	<table border="0" width="100%">
	<a>
		<xsl:attribute name="href">javascript:link_law('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@contno"/>');</xsl:attribute>
		<xsl:value-of select="."/>
	</a>
	</table>
</xsl:template>

<xsl:template match="링크" mode="link">
	<table border="0" width="100%">
	<a>
		<xsl:attribute name="href">javascript:link('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@contno"/>');</xsl:attribute>
		<xsl:value-of select="."/>
	</a>
	</table>
</xsl:template>

<xsl:template match="cont/span/a5b5" mode="link">
	<table border="0" width="100%">
	<br/>
	</table>
</xsl:template>
<xsl:template match="cont/span" mode="link">
	<xsl:element name="span">
	<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

<xsl:template match="image" >
	<table cellpadding='0' cellspacing='0' border='0'  width="100%" valign="top">
		<tr><td>
		<xsl:apply-templates select="." mode="link"/>
		</td></tr>
	</table>
</xsl:template>

<xsl:template match="image|cont/image" mode="link">
	<table cellpadding='0' cellspacing='0' border='0'  width="100%" valign="top">
	<tr><td>
	<p><img><xsl:attribute name="src">/kribblaw/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img></p>
	</td></tr>
	</table>
</xsl:template>

<xsl:template match="cont/span/img" mode="link">
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


<xsl:template match="byulch">
	<table border="0" width="100%">
	<xsl:call-template name="nv15">
		<xsl:with-param name="param" select="."/>
	</xsl:call-template>
	</table>
</xsl:template>

<xsl:template match="byul">
	<table border="0" width="100%">
	<xsl:call-template name="nvl4">
		<xsl:with-param name="param" select="."/>
	</xsl:call-template>
	</table>
</xsl:template>

<xsl:template match="byulji">
	<table border="0" width="100%"> 
	<xsl:call-template name="nvl3">
		<xsl:with-param name="param" select="."/>
	</xsl:call-template>
	</table>
</xsl:template>


<xsl:template name="nv15">
	<xsl:param name="param" select="."/>
	<xsl:param name="abc2"/>
	<xsl:param name="jo2"/>
    <xsl:variable name="abc"><xsl:value-of select="$revcha"/></xsl:variable>                	                 	
    <xsl:variable name="jo1"><xsl:value-of select="@byulcd"/></xsl:variable>   
	<xsl:if test="./@startcha=$abc">
		<table  width="100%" valign="top">
			<tr>
				<td width="50%" bgcolor="#f4f4f4" valign="top">
					<xsl:call-template name="left3">
						<xsl:with-param name="abc2" select="$abc"/>
						<xsl:with-param name="jo2" select="$jo1"/>
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</td>
				<td width="50%" valign="top">
					<xsl:call-template name="right3">
						<xsl:with-param name="abc2" select="$abc"/>
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</td>
			</tr>
		</table>
	</xsl:if>
</xsl:template>

<xsl:template name="left3">	
	<xsl:param name="param" select="."/>
	<xsl:param name="abc2"/>
	<xsl:param name="jo2"/>
		<xsl:for-each select="//byulch">
		<xsl:if test="./@byulcd=$jo2">
		<xsl:if test="./@endcha=$abc2+(-1)">
			<span class="yunhyuk">효력 종료일자 :<xsl:value-of select="./@enddt"/></span><br/>
			<p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:if>
		</xsl:if>
		</xsl:for-each>
</xsl:template>

<xsl:template name="right3">
	<xsl:param name="param" select="."/>	
	<xsl:param name="abc2"/>   
		<xsl:if test="./byulch/@startcha=$abc2"> 
			<span class="hyunheng">효력 시작일자 :<xsl:value-of select="@startdt"/></span><br/>
			<p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:if>
</xsl:template> 

<xsl:template name="nvl4">
<xsl:param name="param" select="."/>
<xsl:param name="abc2"/>
<xsl:param name="jo2"/>
    <xsl:variable name="abc"><xsl:value-of select="$revcha"/></xsl:variable>                	                 	
    <xsl:variable name="jo1"><xsl:value-of select="@byulcd"/></xsl:variable>   
	<xsl:if test="./@startcha=$abc">
	<table  width="100%" valign="top">
        <tr>
            <td width="50%" bgcolor="#f4f4f4" valign="top">
                <xsl:call-template name="left2">
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="jo2" select="$jo1"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>
            <td width="50%" valign="top">
                <xsl:call-template name="right2">
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>    
        </tr>
    </table>
	</xsl:if>
</xsl:template>

<xsl:template name="left2">	
	<xsl:param name="param" select="."/>
	<xsl:param name="abc2"/>
	<xsl:param name="jo2"/>
		<xsl:for-each select="//byul">
		<xsl:if test="./@byulcd=$jo2">
		<xsl:if test="./@endcha=$abc2+(-1)">
			<span class="yunhyuk">효력 종료일자 :<xsl:value-of select="./@enddt"/></span><br/>
			<p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:if>
		</xsl:if>
		</xsl:for-each>
</xsl:template>

<xsl:template name="right2">
	<xsl:param name="param" select="."/>
	<xsl:param name="abc2"/>
		<xsl:if test="@startcha=$abc2"> 
			<span class="hyunheng">효력 시작일자 :<xsl:value-of select="@startdt"/></span><br/>
			<p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:if>
</xsl:template> 

<xsl:template name="nvl3">
<xsl:param name="param" select="."/>
<xsl:param name="abc2"/>
<xsl:param name="jo2"/>
    <xsl:variable name="abc"><xsl:value-of select="$revcha"/></xsl:variable>                	                 	
    <xsl:variable name="jo1"><xsl:value-of select="@byulcd"/></xsl:variable>   
	<xsl:if test="./@startcha=$abc">
	<table  width="100%" valign="top">
        <tr>
            <td width="50%" bgcolor="#f4f4f4" valign="top">
                <xsl:call-template name="left1">
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="jo2" select="$jo1"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>
            <td width="50%" valign="top">
                <xsl:call-template name="right1">
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>    
        </tr>
    </table>
	</xsl:if>
</xsl:template>

<xsl:template name="left1">	
	<xsl:param name="param" select="."/>
	<xsl:param name="abc2"/>
	<xsl:param name="jo2"/>
		<xsl:for-each select="//byulji">
		<xsl:if test="./@byulcd=$jo2">
		<xsl:if test="./@endcha=$abc2+(-1)">
			<span class="yunhyuk">효력 종료일자 :<xsl:value-of select="./@enddt"/></span><br/>
			<p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					&lt;<xsl:value-of select="./@byulcd"/>서식&gt;<xsl:value-of select="./@title"/>
				</xsl:element>
			</p>
		</xsl:if>
		</xsl:if>
		</xsl:for-each>
</xsl:template>

<xsl:template name="right1">
	<xsl:param name="param" select="."/>
	<xsl:param name="abc2"/>   
		<xsl:if test="@startcha=$abc2"> 
			<span class="hyunheng">효력 시작일자 :<xsl:value-of select="@startdt"/></span><br/>
			<p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p>
		</xsl:if>
</xsl:template>  

<xsl:template name="nvl">	
<xsl:param name="param" select="."/>
<xsl:param name="jo2"/>
<xsl:param name="subjo2"/>
<xsl:param name="abc2"/>
<table  width="100%"  valign="top">
    <xsl:variable name="abc"><xsl:value-of select="$revcha"/></xsl:variable>                	                 	
    <xsl:for-each select="./jo">
        <xsl:if test="./@startcha=$abc">
        <xsl:variable name="jo1"><xsl:value-of select="./@contno"/></xsl:variable>
        <xsl:variable name="subjo1"><xsl:value-of select="./@contsubno"/></xsl:variable>
        <tr>
            <td width="50%" bgcolor="#f4f4f4" valign="top">
                <xsl:call-template name="left">
                    <xsl:with-param name="jo2" select="$jo1"/>
                    <xsl:with-param name="subjo2" select="$subjo1"/>
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>
            <td width="50%" valign="top">
                <xsl:call-template name="right">
                    <xsl:with-param name="jo2" select="$jo1"/>
                    <xsl:with-param name="subjo2" select="$subjo1"/>
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>    
        </tr>
        </xsl:if>
    </xsl:for-each>
</table>
</xsl:template>

<xsl:template name="nvl2">	
<xsl:param name="param" select="."/>
<xsl:param name="jo2"/>
<xsl:param name="subjo2"/>
<xsl:param name="abc2"/>
<table  width="100%" valign="top">
    <xsl:variable name="abc"><xsl:value-of select="$revcha"/></xsl:variable>                	                 	
    <xsl:for-each select=".">
        <xsl:if test="./@startcha=$abc">
        <xsl:variable name="jo1"><xsl:value-of select="./@contno"/></xsl:variable>
        <xsl:variable name="subjo1"><xsl:value-of select="./@contsubno"/></xsl:variable>
        <tr>
            <td width="50%" bgcolor="#f4f4f4" valign="top">
                <xsl:call-template name="left">
                    <xsl:with-param name="jo2" select="$jo1"/>
                    <xsl:with-param name="subjo2" select="$subjo1"/>
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>
            <td width="50%" valign="top">
                <xsl:call-template name="right">
                    <xsl:with-param name="jo2" select="$jo1"/>
                    <xsl:with-param name="subjo2" select="$subjo1"/>
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>    
        </tr>
        </xsl:if>
    </xsl:for-each>
</table>
</xsl:template>

<xsl:template name="left">	
<xsl:param name="param" select="."/>
<xsl:param name="jo2"/>
<xsl:param name="subjo2"/>
<xsl:param name="abc2"/>
<xsl:for-each select="//jo">
    <xsl:if test="./@contno=$jo2">
        <xsl:if test="./@contsubno=$subjo2">        
            <xsl:if test="./@endcha=$abc2+(-1)">
                <a><xsl:attribute name="name">bon<xsl:value-of select="@contno"/></xsl:attribute>
                <span class="yunhyuk">효력 종료일자 :<xsl:value-of select="@enddt"/></span>
                <br/><span class="jonumber">제<xsl:value-of select="@contno"/>조<span class="jotitle"><xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
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
                </span></span></a>
                <span class="jocontent"> 
					<xsl:apply-templates select="cont/text()|cont/법링크|cont/링크|cont/image|cont/span/img|cont/img|cont/a5b5|cont/span/a5b5|cont/span" mode="link"/>
					<xsl:if test="./cont!=''"><br/></xsl:if>
					<xsl:call-template name="etc">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</span>
            </xsl:if>		
        </xsl:if> 
    </xsl:if>		
</xsl:for-each>
</xsl:template>

<xsl:template name="right">	
<xsl:param name="param" select="."/>
<xsl:param name="jo2"/>
<xsl:param name="subjo2"/>
<xsl:param name="abc2"/>
	<xsl:if test="./@contno=$jo2">
	    <xsl:if test="./@contsubno=$subjo2">            
	        <xsl:if test="./@startcha=$abc2">
	            <a><xsl:attribute name="name">bon<xsl:value-of select="@contno"/></xsl:attribute>
	            <span class="hyunheng">효력 시작일자 :<xsl:value-of select="@startdt"/></span>
	            <br/><span class="jonumber">제<xsl:value-of select="@contno"/>조<span class="jotitle"><xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
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
	            </span></span></a>
	            <span class="jocontent"> 
					<xsl:apply-templates select="cont/text()|cont/법링크|cont/링크|cont/image|cont/span/img|cont/img|cont/a5b5|cont/span/a5b5|cont/span" mode="link"/>
					<xsl:if test="./cont!=''"><br/></xsl:if>
					<xsl:call-template name="etc">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</span>
	        </xsl:if> 
	    </xsl:if> 
	</xsl:if>
</xsl:template> 

<xsl:template name="bul">	
<xsl:param name="param" select="."/>
<xsl:param name="jo2"/>
<xsl:param name="subjo2"/>
<xsl:param name="abc2"/>
<table width="100%" valign="top">
    <xsl:variable name="abc"><xsl:value-of select="$revcha"/></xsl:variable>                	                 	
    <xsl:for-each select="./jo">
        <xsl:if test="./@startcha=$abc">
        <xsl:variable name="jo1"><xsl:value-of select="./@contno"/></xsl:variable>
        <xsl:variable name="subjo1"><xsl:value-of select="./@contsubno"/></xsl:variable>
        <tr>
            <td width="50%" bgcolor="#f4f4f4" valign="top">
                <xsl:call-template name="buleft">
                    <xsl:with-param name="jo2" select="$jo1"/>
                    <xsl:with-param name="subjo2" select="$subjo1"/>
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>
            <td width="50%" valign="top">
                <xsl:call-template name="buright">
                    <xsl:with-param name="jo2" select="$jo1"/>
                    <xsl:with-param name="subjo2" select="$subjo1"/>
                    <xsl:with-param name="abc2" select="$abc"/>
                    <xsl:with-param name="param" select="."/>
                </xsl:call-template>		
            </td>    
        </tr>
        </xsl:if>
    </xsl:for-each>
</table>
</xsl:template>

<xsl:template name="buleft">	
<xsl:param name="param" select="."/>
<xsl:param name="jo2"/>
<xsl:param name="subjo2"/>
<xsl:param name="abc2"/>
<xsl:for-each select="//jo">
    <xsl:if test="./@contno=$jo2">
        <xsl:if test="./@contsubno=$subjo2">        
            <xsl:if test="./@endcha=$abc2+(-1)">
                <a><xsl:attribute name="name">bon<xsl:value-of select="@contno"/></xsl:attribute>
                <span class="jocontent"> &lt;부칙&gt;</span><br/>
                <span class="yunhyuk">효력 종료일자 :<xsl:value-of select="@enddt"/></span>
                <br/><span class="jonumber">제<xsl:value-of select="@contno"/>조<span class="jotitle"><xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
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
                </span></span></a>
                <span class="jocontent"> 
					<xsl:apply-templates select="cont/text()|cont/법링크|cont/링크|cont/image|cont/span/img|cont/img|cont/a5b5|cont/span/a5b5|cont/span" mode="link"/>
					<xsl:if test="./cont!=''"><br/></xsl:if>
					<xsl:call-template name="etc">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</span>
            </xsl:if>		
        </xsl:if> 
    </xsl:if>		
</xsl:for-each>
</xsl:template>
<xsl:template name="buright">	
<xsl:param name="param" select="."/>
<xsl:param name="jo2"/>
<xsl:param name="subjo2"/>
<xsl:param name="abc2"/>
<xsl:if test="./@contno=$jo2">
    <xsl:if test="./@contsubno=$subjo2">
        <xsl:if test="./@startcha=$abc2">
            <a><xsl:attribute name="name">bon<xsl:value-of select="@contno"/></xsl:attribute>
            <span class="jocontent"> &lt;부칙&gt;</span><br/>
            <span class="hyunheng">효력 시작일자 :<xsl:value-of select="@startdt"/></span>
            <br/><span class="jonumber"> 제<xsl:value-of select="@contno"/>조<span class="jotitle"><xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
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
            </span></span></a>
            <span class="jocontent"> 
				<xsl:apply-templates select="cont/text()|cont/법링크|cont/링크|cont/image|cont/span/img|cont/img|cont/a5b5|cont/span/a5b5|cont/span" mode="link"/>
				<xsl:if test="./cont!=''"><br/></xsl:if>
				<xsl:call-template name="etc">
					<xsl:with-param name="param" select="."/>
				</xsl:call-template>
			</span>
        </xsl:if> 
    </xsl:if> 
</xsl:if>
</xsl:template> 
<xsl:include href="util.xsl"/>
<xsl:include href="common.xsl"/>
</xsl:stylesheet>