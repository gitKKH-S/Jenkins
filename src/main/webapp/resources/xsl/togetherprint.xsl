<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:param name="selectBox" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<xsl:template match="history">
	<xsl:for-each select="./hisitem">
		<xsl:if test="./@bookid=$bookid">
			<p class="title"><xsl:value-of select="@title"/></p> 
		</xsl:if>
	</xsl:for-each>
	<p style="font-size:11px; color:#666; margin:5px 0 0 15px;">
	<xsl:value-of select="$selectBox" disable-output-escaping="yes"></xsl:value-of>
	</p>
</xsl:template>

<!-- 편 template -->

<xsl:template match="pyun">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="pyun">
		제<xsl:value-of select="./@contno"/>편 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/>
	</p>
	<xsl:apply-templates select="jang|jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jang">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="jang">
		제<xsl:value-of select="./@contno"/>장 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if><xsl:value-of select="./@title"/>
	</p>
	<xsl:apply-templates select="jeol|gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jeol">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="jeol">
		제<xsl:value-of select="./@contno"/>절 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/>
	</p>
	<xsl:apply-templates select="gwan|jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="gwan">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<p class="gwan">
		제<xsl:value-of select="./@contno"/>관 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="./@title"/>
	</p>
	<xsl:apply-templates select="jo"/>	
	</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="jo">
	<xsl:variable name="cha" select="./@startcha"/>
	<xsl:choose> 
		<xsl:when test="./@endcha='9999'">
			<div style="border:1px solid #71bf44; padding:5px 5px 5px 5px; margin:2px 0 10px 0;">		
			<a>
	            <xsl:attribute name="name">bon<xsl:value-of select="@contno"/></xsl:attribute>
	            <span class="hyunheng">[현행]/시행일 :<xsl:value-of select="//history/hisitem[@revcha=$cha]/@startdt"/></span>
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
					    	<xsl:if test="@title!=''">
							(<xsl:value-of select="@title"/>)
							</xsl:if>
					    	</xsl:otherwise>
					    	</xsl:choose> 
					    </xsl:otherwise>
				    </xsl:choose>					
				</span></span>
            </a>
 			<span class="jocontent"> 
             	<xsl:for-each select="./new">
					<xsl:apply-templates select="text()|hang|ho|mok|dan|image|cont" mode="link"/>
					<xsl:value-of select="@showtag"/>
				</xsl:for-each>
             	<xsl:if test="./cont!=''"><br/></xsl:if>
             	<xsl:call-template name="etc">
		 			<xsl:with-param name="param" select="."/>
				</xsl:call-template>
 			</span>
			</div>
			<hr/>
		</xsl:when>
		<xsl:otherwise>
			<div style="background-color:#efefef; border:1px dotted #ccc; padding:5px 5px 5px 5px; margin:2px 0 2px 0;">											
				<a> 
		            <xsl:attribute name="name">bon<xsl:value-of select="@contno"/></xsl:attribute>
		            <p class="yunhyuk">[연혁]/시행일 :<xsl:value-of select="//history/hisitem[@revcha=$cha]/@startdt"/></p>            
		            <span class="jonumber">제<xsl:value-of select="@contno"/>조<span class="jotitle"><xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
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
					    	<xsl:if test="@title!=''">
							(<xsl:value-of select="@title"/>)
							</xsl:if>
					    	</xsl:otherwise>
					    	</xsl:choose> 
					    </xsl:otherwise>
				    </xsl:choose>
					</span></span>
				</a>
            	<span class="jocontent"> 
             		<xsl:for-each select="./new">
						<xsl:apply-templates select="text()|hang|ho|mok|dan|image|cont" mode="link"/>
						<xsl:value-of select="@showtag"/>
					</xsl:for-each>
             		<xsl:if test="./cont!=''"><br/></xsl:if>
                 	<xsl:call-template name="etc">
		 				<xsl:with-param name="param" select="."/>
					</xsl:call-template>
            	</span>
				</div>
         </xsl:otherwise>
	</xsl:choose>
</xsl:template>

	<xsl:template match="buchick">
		<xsl:if test="./@startcha&lt;=$revcha">
			<p class="buchik_title">
				<xsl:for-each select=".">
					<xsl:value-of select="@title"/>        
				</xsl:for-each>
			</p>
			<span class="jocontent"> 
             	<xsl:for-each select="./new">
					<xsl:apply-templates select="jo|text()|hang|ho|mok|dan|image|cont" mode="link"/>
					<xsl:value-of select="@showtag"/>
				</xsl:for-each>
             	<xsl:if test="./cont!=''"><br/></xsl:if>
             	<xsl:call-template name="etc">
		 			<xsl:with-param name="param" select="."/>
				</xsl:call-template>
 			</span>
		</xsl:if>
	</xsl:template>
  <xsl:template match="byullist">
<xsl:if test="count(child::*)>0">  
<p class="buchik_title">
별표 및 서식
</p>
	<xsl:apply-templates select="byul|byulji|byulch"/>
</xsl:if>
</xsl:template>
   <xsl:template match="byul"> 
   <xsl:variable name="cha" select="./@startcha"/>
   <xsl:choose> 	 
		<xsl:when test="./@endcha='9999'">
		<p class="hyunheng">[현행]/시행일 :<xsl:value-of select="//history/hisitem[@revcha=$cha]/@startdt"/></p>
	      <xsl:for-each select=".">
	      <xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
	          <p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="//law/@title"/>'+'_'+'<xsl:value-of select="$revcha"/>차'+'_'+'<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>		
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p><hr/>
	          </xsl:when>
		<xsl:otherwise>  
			<xsl:if test="./@curstate!='delete'">
				<span class="3"><xsl:value-of select="./@showtitle"/></span>
				<br/>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose> 
	      </xsl:for-each> 
	      </xsl:when> 
	      <xsl:otherwise>
	      <p class="yunhyuk">[연혁]/시행일 :<xsl:value-of select="//history/hisitem[@revcha=$cha]/@startdt"/></p>
	      <xsl:for-each select=".">
	      <xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
	         <p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="//law/@title"/>'+'_'+'<xsl:value-of select="$revcha"/>차'+'_'+'<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>		
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
	      </xsl:otherwise>
	      </xsl:choose>              
  </xsl:template>
  <xsl:template match="byulji">
  <xsl:variable name="cha" select="./@startcha"/>
  <xsl:choose>
	<xsl:when test="./@endcha='9999'">
	<p class="hyunheng">[현행]/시행일 :<xsl:value-of select="//history/hisitem[@revcha=$cha]/@startdt"/></p>
      <xsl:for-each select=".">
      <xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
          <p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p><hr/>
          </xsl:when>
		<xsl:otherwise>  
			<xsl:if test="./@curstate!='delete'">
				<span class="jocontent3"><xsl:value-of select="./@showtitle"/></span>
				<br/>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose> 
      </xsl:for-each> <br/>
	</xsl:when> 
	<xsl:otherwise>
		<p class="yunhyuk">[연혁]/시행일 :<xsl:value-of select="//history/hisitem[@revcha=$cha]/@startdt"/></p>
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
      </xsl:for-each> <br/>
	</xsl:otherwise>
   </xsl:choose>            
  </xsl:template>
  <xsl:template match="byulch">
  <xsl:variable name="cha" select="./@startcha"/>
  <xsl:choose>
	<xsl:when test="./@endcha='9999'">
	<p class="hyunheng">[현행]/시행일 :<xsl:value-of select="//history/hisitem[@revcha=$cha]/@startdt"/></p>
      <xsl:for-each select=".">
      <xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
          <p class="byulText">
				<xsl:element name="span">
					<xsl:attribute name="onclick">downpage('<xsl:value-of select="./@pcfilename"/>','<xsl:value-of select="./@serverfilename"/>','ATTACH');</xsl:attribute>
					<xsl:attribute name="style">cursor:hand;</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</p><hr/>
          </xsl:when>
		<xsl:otherwise>  
   			<xsl:if test="./@curstate!='delete'">
				<span class="jocontent3"><xsl:value-of select="./@showtitle"/></span>
				<br/>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose> 
      </xsl:for-each> <br/>
	</xsl:when> 
	<xsl:otherwise>
		<p class="yunhyuk">[연혁]/시행일 :<xsl:value-of select="//history/hisitem[@revcha=$cha]/@startdt"/></p>
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
      </xsl:for-each> <br/>
	</xsl:otherwise>
   </xsl:choose>            
  </xsl:template>
    <xsl:template match="bylaw" mode="link">
        <a>
            <xsl:attribute name="href">javascript:link_law('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@contno"/>');</xsl:attribute>
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
     <xsl:template match="law" mode="link">
        <a>
            <xsl:attribute name="href">javascript:link('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@contno"/>');</xsl:attribute>
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
	
    <xsl:template match="image" >
		<table width="100%" cellpadding='0' cellspacing='0' border='0'>
		<tr><td>
		 <xsl:apply-templates select="." mode="link"/>
		</td></tr>
		</table>
	</xsl:template>

    <xsl:template match="image|cont/image" mode="link">
		<p><img><xsl:attribute name="src">/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img></p>
	</xsl:template>
		

<xsl:template match="cont" mode="link">
    <xsl:for-each select=".">
		<xsl:apply-templates select="./text()|law|bylaw|image|img|a5b5|span|table" mode="link"/>
     </xsl:for-each>
</xsl:template>     
 <xsl:template match="span" mode="link">
	<xsl:element name="span">
	<xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute>
		<xsl:apply-templates select="text()|image|table" mode="link"/>
	</xsl:element>
</xsl:template>


<xsl:template match="table" mode="link">
	<xsl:value-of select="." disable-output-escaping="yes"/>
</xsl:template>	
 <xsl:template match="hang" mode="link">
	<xsl:for-each select="."><br/>
		<xsl:apply-templates select="cont|cont_gu|cont_sinbar|ho|mok|dan|image|span" mode="link"/>
	</xsl:for-each>
</xsl:template>     

<xsl:template match="ho" mode="link">
    <xsl:for-each select="."><br/>
		<xsl:apply-templates select="cont|cont_gu|cont_sinbar|mok|dan|image|span" mode="link"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok" mode="link">
    <xsl:for-each select="."><br/>
		<xsl:apply-templates select="cont|cont_gu|cont_sinbar|dan|image|span" mode="link"/>
     </xsl:for-each>
</xsl:template>     

<xsl:include href="util.xsl"/>		
<xsl:include href="common.xsl"/>
</xsl:stylesheet>
