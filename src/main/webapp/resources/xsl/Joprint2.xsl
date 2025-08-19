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
                a.active {text-decoration: "none"; font-family: "����,arial"; font-size: "8pt";  color: "#1956a1"; line-height: "100%";}
				a:link {font-family: "����", "����ü", "����", "����ü"; font-size: "8pt"; color:"#1956a1"; text-decoration: none; line-height: "100%";}
	            a:visited {font-family: "����", "����ü", "����", "����ü"; font-size: "8pt"; color: "#1956a1"; text-decoration: none; line-height: "100%";}
	            a:hover {font-family: "����", "����ü", "����", "����ü"; font-size: "8pt"; color: "#1956a1"; text-decoration: none; line-height: "100%";}
                .br{line-height:1%;}
            </style>
            <script langage="javascript">
				function gopage(filename){
					//��â�� ũ��
					 cw=750;
					 ch=420;
					  //��ũ���� ũ��
					 sw=screen.availWidth;
					 sh=screen.availHeight;
					 //�� â�� ������
					 px=(sw-cw)/2;
					 py=(sh-ch)/2;
					 //â�� ���ºκ�
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
<xsl:template match="bon">
	<xsl:variable name="abc">bon1</xsl:variable>
	<xsl:element name='li'>
	<xsl:attribute name="id">show-bon1</xsl:attribute>
		<xsl:element name='input'>
			<xsl:attribute name="id">check-bon1</xsl:attribute>
			<xsl:attribute name="type">checkbox</xsl:attribute>
			<xsl:attribute name="value">1</xsl:attribute>
			<xsl:attribute name="checked">checked</xsl:attribute>
		</xsl:element>
	       ����                             
	    <xsl:call-template name="bon2">
	    	<xsl:with-param name="abc" select="$abc"/>
           </xsl:call-template>
	</xsl:element>
</xsl:template>

<xsl:template name="bon2">
	<xsl:param name="abc"/>
	<xsl:element name='ul'>
		<xsl:attribute name="id">tree-<xsl:value-of select="$abc"/></xsl:attribute>
		<xsl:apply-templates select="pyun|jang|jeol|gwan|jo"/>
	</xsl:element>
</xsl:template>

<xsl:template match="pyun">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">
		<xsl:variable name="abc">pyun<xsl:value-of select="@contno"/></xsl:variable>
		<xsl:element name='li'>
		<xsl:attribute name="id">show-pyun<xsl:value-of select="@contno"/></xsl:attribute>
			<xsl:element name='input'>
				<xsl:attribute name="id">check-pyun<xsl:value-of select="@contno"/></xsl:attribute>
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@contid"/></xsl:attribute>
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:element>
		       ��<xsl:value-of select="@contno"/>�� <xsl:value-of select="@title"/>                              
		    <xsl:call-template name="pyun2">
		    	<xsl:with-param name="abc" select="$abc"/>
            </xsl:call-template>
		</xsl:element>		
    </xsl:if>
    </xsl:if> 
</xsl:template>

<xsl:template name="pyun2">
	<xsl:param name="abc"/>
	<xsl:element name='ul'>
		<xsl:attribute name="id">tree-<xsl:value-of select="$abc"/></xsl:attribute>
		<xsl:apply-templates select="jang|jeol|gwan|jo"/>
	</xsl:element>
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
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:element>
		       ��<xsl:value-of select="@contno"/>�� <xsl:value-of select="@title"/>                              
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
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:element>
		       ��<xsl:value-of select="@contno"/>�� <xsl:value-of select="@title"/>                              
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
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:element>
	       	��<xsl:value-of select="@contno"/>�� <xsl:value-of select="@title"/>                              
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
		  	<xsl:attribute name="title">��<xsl:value-of select="@contno"/>��<xsl:if test="./@contsubno>0">��<xsl:value-of select="@contsubno"/></xsl:if>(<xsl:value-of select="@title"/>)</xsl:attribute>
			<xsl:element name='input'>
				<xsl:attribute name="name">jo</xsl:attribute>
				<xsl:attribute name="type">checkbox</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@contid"/></xsl:attribute>
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:element>
			<span class="txt1" style="cursor:hand;">��<xsl:value-of select="@contno"/>��<xsl:if test="./@contsubno>0">��<xsl:value-of select="@contsubno"/></xsl:if>
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

<xsl:template match="buchicklist">
<xsl:if test="count(child::*)>0">  
	<xsl:variable name="abc">buchicklist2</xsl:variable>
	<xsl:element name='li'>
	<xsl:attribute name="id">show-buchicklist2</xsl:attribute>
		<xsl:element name='input'>
			<xsl:attribute name="id">check-buchicklist2</xsl:attribute>
			<xsl:attribute name="type">checkbox</xsl:attribute>
			<xsl:attribute name="value">2</xsl:attribute>
		</xsl:element>
	       ��Ģ                             
	    <xsl:call-template name="buchicklist2">
	    	<xsl:with-param name="abc" select="$abc"/>
           </xsl:call-template>
	</xsl:element>
</xsl:if>
</xsl:template>

<xsl:template name="buchicklist2">
	<xsl:param name="abc"/>
	<xsl:element name='ul'>
		<xsl:attribute name="id">tree-<xsl:value-of select="$abc"/></xsl:attribute>
		<xsl:apply-templates select="buchick"/>
	</xsl:element>
</xsl:template>

  <xsl:template match="buchick">
  	<xsl:element name='li'>
  		<xsl:attribute name="id">show-buchick<xsl:value-of select="@contid"/></xsl:attribute>
        <xsl:attribute name="style">padding-left:20px</xsl:attribute>
	            <xsl:if test="./@startcha&lt;=$revcha">    
		            <xsl:for-each select=".">
							<xsl:element name='input'>
								<xsl:attribute name="id">check-buchick</xsl:attribute>
								<xsl:attribute name="name">buch</xsl:attribute>
								<xsl:attribute name="type">checkbox</xsl:attribute>
								<xsl:attribute name="value"><xsl:value-of select="@contid"/></xsl:attribute>
								<xsl:if test="./@startcha=$revcha">   
								<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:element>
		                	<xsl:value-of select="@title"/>
		            </xsl:for-each>
	            </xsl:if>        
            <xsl:if test="./@startcha&lt;=$revcha">
            <xsl:for-each select="./jang">
                <span class="txt1"><br/>��<xsl:value-of select="@contno"/>��<xsl:if test="./@contsubno>0">��<xsl:value-of select="@contsubno"/></xsl:if>
                <xsl:value-of select="@title"/></span>  
                    <xsl:for-each select="./jang/jo">
                        <span class="txt1"><br/>��<xsl:value-of select="@contno"/>��<xsl:if test="./@contsubno>0">��<xsl:value-of select="@contsubno"/></xsl:if>
                        (<xsl:value-of select="@title"/>)</span>  
                    </xsl:for-each>
            </xsl:for-each>

            <xsl:for-each select="./jo">
			<div style="padding-left:20px" class="txt1">��<xsl:value-of select="@contno"/>��<xsl:if test="./@contsubno>0">��<xsl:value-of select="@contsubno"/></xsl:if>
			(<xsl:value-of select="@title"/>)</div>  
            </xsl:for-each>
      		</xsl:if>
      	</xsl:element>
  </xsl:template>

<xsl:template match="byullist">
<xsl:if test="count(child::*)>0">  
	<xsl:variable name="abc">byullist3</xsl:variable>
	<xsl:element name='li'>
	<xsl:attribute name="id">show-byullist3</xsl:attribute>
		<xsl:element name='input'>
			<xsl:attribute name="id">check-byullist3</xsl:attribute>
			<xsl:attribute name="type">checkbox</xsl:attribute>
			<xsl:attribute name="value">3</xsl:attribute>
			<xsl:attribute name="checked">checked</xsl:attribute>
		</xsl:element>
	    ��ǥ                             
	    <xsl:call-template name="byullist2">
	    	<xsl:with-param name="abc" select="$abc"/>
           </xsl:call-template>
	</xsl:element>
</xsl:if>
</xsl:template>

<xsl:template name="byullist2">
	<xsl:param name="abc"/>
	<xsl:element name='ul'>
		<xsl:attribute name="id">tree-<xsl:value-of select="$abc"/></xsl:attribute>
		<xsl:apply-templates select="byul|byulji|byulch"/>
	</xsl:element>
</xsl:template>

<!-- ��ǥ -->

<xsl:template match="byul">
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">        
		<xsl:for-each select=".">
		<xsl:choose> 
		<xsl:when test="./@serverfilename!=''">
			<nobr style="text-overflow:ellipsis;overflow:hidden;width=100%">
				<xsl:element name='input'>
					<xsl:attribute name="name">filenames</xsl:attribute>
					<xsl:attribute name="type">checkbox</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@serverfilename"/></xsl:attribute>
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:element>
				<xsl:element name="span">
				<xsl:attribute name="style">text-align:left</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</nobr>
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

<!-- �������� -->

<xsl:template match="byulji"> 
	<xsl:if test="./@endcha&gt;=$revcha">
	<xsl:if test="./@startcha&lt;=$revcha">       
		<xsl:for-each select=".">
			<xsl:choose> 
			<xsl:when test="./@serverfilename!=''">   
				<nobr style="text-overflow:ellipsis;overflow:hidden;width=100%">
				<xsl:element name='input'>
					<xsl:attribute name="name">filenames</xsl:attribute>
					<xsl:attribute name="type">checkbox</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@serverfilename"/></xsl:attribute>
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:element>
				<xsl:element name="span">
				<xsl:attribute name="style">text-align:left</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
				</nobr>
			</xsl:when>
			<xsl:otherwise> 
				<div class="jocontent">&lt;<xsl:value-of select="./@byulcd"/>����&gt;
				<xsl:value-of select="./@title"/>
				</div>
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
			<nobr style="text-overflow:ellipsis;overflow:hidden;width=100%">
				<xsl:element name='input'>
					<xsl:attribute name="name">filenames</xsl:attribute>
					<xsl:attribute name="type">checkbox</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@serverfilename"/></xsl:attribute>
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:element>
				<xsl:element name="span">
					<xsl:attribute name="style">text-align:left</xsl:attribute>
					<xsl:value-of select="./@showtitle"/>
				</xsl:element>
			</nobr>
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

