<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="bookid" />
<xsl:param name="revcha" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>
  <xsl:template match="/">
    <html>
      <head>
            <style type="text/css">
            	body{
					scrollbar-shadow-color:#FFFFFF;
					scrollbar-highlight-color:#FFFFFF;
					scrollbar-face-color:#9EBFEB;
					scrollbar-3dlight-color:#9EBFEB;
					scrollbar-darkshadow-color:#9EBFEB;
					scrollbar-track-color:#FFFFFF;
					scrollbar-arrow-color:#FFFFFF;
				}
                .txt1 {      line-height: 130% ;  font-size: 9pt;    }    
                a.active {text-decoration: "none"; font-family: "굴림,arial"; font-size: "8pt";  color: "#1956a1"; line-height: "100%";}
				a:link {font-family: "돋움", "돋움체", "굴림", "굴림체"; font-size: "8pt"; color:"#1956a1"; text-decoration: none; line-height: "100%";}
	            a:visited {font-family: "돋움", "돋움체", "굴림", "굴림체"; font-size: "8pt"; color: "#1956a1"; text-decoration: none; line-height: "100%";}
	            a:hover {font-family: "돋움", "돋움체", "굴림", "굴림체"; font-size: "8pt"; color: "#1956a1"; text-decoration: none; line-height: "100%";}
                .br{line-height:1%;}
            </style>
            <script langage="javascript">
				function gopage(filename){
					//새창의 크기
					 cw=750;
					 ch=420;
					  //스크린의 크기
					 sw=screen.availWidth;
					 sh=screen.availHeight;
					 //열 창의 포지션
					 px=(sw-cw)/2;
					 py=(sh-ch)/2;
					 //창을 여는부분
					property="left="+px+",top="+py+",width=750,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no";
					window.open("/kribblaw/jsp/lkms3/jsp/regulation/hwpPrint.jsp?filename="+filename, "ocase",property);
				}
		</script>
      </head>
      <body>
      	<ul id="tree-checkmenu" class="checktree">
        	<xsl:apply-templates select="law"/>
        </ul>
      </body>
    </html>
  </xsl:template>

<xsl:template match="history">
</xsl:template>
<xsl:template match="pyun">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<div class="txt1">
		<xsl:element name='input'>
			<xsl:attribute name="type">checkbox</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@contid"/></xsl:attribute>
		</xsl:element>
	       제<xsl:value-of select="@contno"/>편 <xsl:value-of select="@title"/>                              
	    <xsl:apply-templates select="jang|jeol|gwan|jo"/>
	</div>
    </xsl:if>
    </xsl:if> 
</xsl:template>

<xsl:template match="jang">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<xsl:variable name="abc">jang<xsl:value-of select="@contno"/></xsl:variable>
		<xsl:element name='li'>
		<xsl:attribute name="id">show-jang<xsl:value-of select="@contno"/></xsl:attribute>
			<xsl:element name='input'>
				<xsl:attribute name="id">check-jang<xsl:value-of select="@contno"/></xsl:attribute>
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@contid"/></xsl:attribute>
			</xsl:element>
		       제<xsl:value-of select="@contno"/>장 <xsl:value-of select="@title"/>                              
		    <xsl:call-template name="jang2">
		    	<xsl:with-param name="abc" select="$abc"/>
            </xsl:call-template>
		</xsl:element>		
    </xsl:if>
    </xsl:if> 
</xsl:template>

<xsl:template name="jang2">
	<xsl:param name="abc"/>
	<xsl:element name='ul'>
		<xsl:attribute name="id">tree-<xsl:value-of select="$abc"/></xsl:attribute>
		<xsl:apply-templates select="jeol|gwan|jo"/>
	</xsl:element>
</xsl:template>

<xsl:template match="jeol">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
	<xsl:variable name="abc">jeol<xsl:value-of select="@contid"/></xsl:variable>
		<xsl:element name='li'>
		<xsl:attribute name="id">show-jeol<xsl:value-of select="@contid"/></xsl:attribute>
			<xsl:element name='input'>
				<xsl:attribute name="id">check-jeol<xsl:value-of select="@contid"/></xsl:attribute>
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@contid"/></xsl:attribute>
			</xsl:element>
		       제<xsl:value-of select="@contno"/>절 <xsl:value-of select="@title"/>                              
		    <xsl:call-template name="jeol2">
		    	<xsl:with-param name="abc" select="$abc"/>
            </xsl:call-template>
		</xsl:element>		
    </xsl:if>
    </xsl:if> 
</xsl:template>

<xsl:template name="jeol2">
	<xsl:param name="abc"/>
	<xsl:element name='ul'>
		<xsl:attribute name="id">tree-<xsl:value-of select="$abc"/></xsl:attribute>
		<xsl:apply-templates select="gwan|jo"/>
	</xsl:element>
</xsl:template>

<xsl:template match="gwan">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<div class="txt1">
			<xsl:element name='input'>
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@contid"/></xsl:attribute>
			</xsl:element>
	       	제<xsl:value-of select="@contno"/>관 <xsl:value-of select="@title"/>                              
		    <xsl:apply-templates select="jo"/>
		</div>
    </xsl:if>
    </xsl:if> 
</xsl:template>

<xsl:template match="jo">             
	<xsl:for-each select=".">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<xsl:element name='li'>
        	<xsl:attribute name="style">padding-left:20px</xsl:attribute>
		  	<xsl:attribute name="title">제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>(<xsl:value-of select="@title"/>)</xsl:attribute>
			<xsl:element name='input'>
				<xsl:attribute name="name">jo</xsl:attribute>
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@contid"/></xsl:attribute>
			</xsl:element>
			<span class="txt1" style="cursor:hand;">제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
				<xsl:if test="string-length(@title)&gt;14">
					(<xsl:value-of select="substring(@title,1,14)"/>...)
				</xsl:if>
				<xsl:if test="string-length(@title)&lt;=14">
					(<xsl:value-of select="@title"/>)
				</xsl:if>
			</span>  
		</xsl:element>
	</xsl:if>
	</xsl:if>
	</xsl:for-each>       
</xsl:template>

  <xsl:template match="buchick">
            <div class="txt1"> 
	            <xsl:if test="./@startcha&lt;=$revcha">    
		            <xsl:for-each select=".">
		                <span class="txt1">
		                	<span class="txt1">
							<xsl:element name='input'>
								<xsl:attribute name="name">buch</xsl:attribute>
								<xsl:attribute name="type">checkbox</xsl:attribute>
								<xsl:attribute name="value"><xsl:value-of select="@contid"/></xsl:attribute>
							</xsl:element>
							</span>
		                	<xsl:value-of select="@title"/>
		                </span>           
		            </xsl:for-each>
	            </xsl:if>        
            </div>
            <xsl:if test="./@startcha&lt;=$revcha">
            <xsl:for-each select="./jang">
                <span class="txt1"><br/>제<xsl:value-of select="@contno"/>장<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
                <xsl:value-of select="@title"/></span>  
                    <xsl:for-each select="./jang/jo">
                        <span class="txt1"><br/>제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
                        (<xsl:value-of select="@title"/>)</span>  
                    </xsl:for-each>
            </xsl:for-each>

            <xsl:for-each select="./jo">
			<div style="padding-left:20px" class="txt1">제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>
			(<xsl:value-of select="@title"/>)</div>  
            </xsl:for-each>
      		</xsl:if>
  </xsl:template>

<!-- 별표 -->

<xsl:template match="byul">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">        
		<xsl:for-each select=".">
		<xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
			<p class="byulText">
			<nobr style="text-overflow:ellipsis;overflow:hidden;width=100%">
				<xsl:element name='input'>
					<xsl:attribute name="name">filenames</xsl:attribute>
					<xsl:attribute name="type">checkbox</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@serverfilename"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="span">
				<xsl:attribute name="style">text-align:left</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</nobr>
			</p>
		</xsl:when>
		<xsl:otherwise> 
			<div class="jocontent">&lt;<xsl:value-of select="./@byulcd"/>&gt;
			<xsl:value-of select="./@title"/>
			</div>
		</xsl:otherwise>
		</xsl:choose>
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
				<p class="byulText">
				<nobr style="text-overflow:ellipsis;overflow:hidden;width=100%">
				<xsl:element name='input'>
					<xsl:attribute name="name">filenames</xsl:attribute>
					<xsl:attribute name="type">checkbox</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@serverfilename"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="span">
				<xsl:attribute name="style">text-align:left</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
				</nobr>
				</p>
			</xsl:when>
			<xsl:otherwise> 
				<div class="jocontent">&lt;<xsl:value-of select="./@byulcd"/>서식&gt;
				<xsl:value-of select="./@title"/>
				</div>
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
			<p class="byulText">
			<nobr style="text-overflow:ellipsis;overflow:hidden;width=100%">
				<xsl:element name='input'>
					<xsl:attribute name="name">filenames</xsl:attribute>
					<xsl:attribute name="type">checkbox</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@serverfilename"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="span">
					<xsl:attribute name="style">text-align:left</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</nobr>
			</p>
		</xsl:when>
		<xsl:otherwise>   
			<div class="jocontent">&lt;<xsl:value-of select="./@byulcd"/>&gt;
			<xsl:value-of select="./@title"/>
			</div>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:for-each> 
	</xsl:if>
	</xsl:if>             
</xsl:template>

</xsl:stylesheet>

