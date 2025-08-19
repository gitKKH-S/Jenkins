<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="startcha" />
<xsl:param name="gbn2" />
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>

<!-- 내규 template 시작 -->

<xsl:template match="/">
		<body>
			<xsl:apply-templates select="law"/>
		</body>
</xsl:template>

<!-- 편 / 장 / 절 / 관 / 조 template -->

<xsl:template match="law">
	<xsl:apply-templates select="bon|pyun|jang|jeol|gwan|jo"/>	
</xsl:template>

<xsl:template match="bon">
	<xsl:apply-templates select="pyun|jang|jeol|gwan|jo"/>	
</xsl:template>

<xsl:template match="pyun">
	<xsl:variable name="gbn" select="name()"/>	
	<xsl:call-template name="joesang">
		<xsl:with-param name="gbn" select="."/>
	</xsl:call-template>
	<xsl:apply-templates select="jang|jeol|gwan|jo"/>	
</xsl:template>

<xsl:template match="jang">
	<xsl:variable name="gbn" select="장"/>	
	<xsl:call-template name="joesang">
		<xsl:with-param name="gbn" select="."/>
	</xsl:call-template>
	<xsl:apply-templates select="jeol|gwan|jo"/>
</xsl:template>

<xsl:template match="jeol">
	<xsl:variable name="gbn" select="name()"/>	
	<xsl:call-template name="joesang">
		<xsl:with-param name="gbn" select="."/>
	</xsl:call-template>
	<xsl:apply-templates select="gwan|jo"/>
</xsl:template>

<xsl:template match="gwan">
	<xsl:variable name="gbn" select="name()"/>	
	<xsl:call-template name="joesang">
		<xsl:with-param name="gbn" select="."/>
	</xsl:call-template>
	<xsl:apply-templates select="jo"/>
</xsl:template>

<xsl:template name="joesang">
		<xsl:if  test="./@startcha =$startcha">
				<xsl:variable name="gbn" select="name()"/>
				<jul>
				   <xsl:attribute name="node">
			           <xsl:value-of select="name()"/>
				   </xsl:attribute>
				   <xsl:attribute name="f_title">
					<xsl:choose>
						<xsl:when test="./@endcha='9999'"> 
							<xsl:choose>
								<xsl:when test="./@curstate!='new'"> 
									제<xsl:value-of select="@f_contno"/><xsl:value-of select="$gbn2"/><xsl:choose><xsl:when test="$gbn='pyun'">편</xsl:when><xsl:when test="$gbn='jang'">장</xsl:when><xsl:when test="$gbn='jeol'">절</xsl:when><xsl:when test="$gbn='gwan'">관</xsl:when></xsl:choose><xsl:if test="./@f_contsubno>0">의<xsl:value-of select="@f_contsubno"/></xsl:if>(<xsl:value-of select="@f_title"/>)
								</xsl:when>
								<xsl:otherwise>
									""
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="./@createstate!='new'"> 
									제<xsl:value-of select="@f_contno"/><xsl:value-of select="$gbn2"/><xsl:choose><xsl:when test="$gbn='pyun'">편</xsl:when><xsl:when test="$gbn='jang'">장</xsl:when><xsl:when test="$gbn='jeol'">절</xsl:when><xsl:when test="$gbn='gwan'">관</xsl:when></xsl:choose><xsl:if test="./@f_contsubno>0">의<xsl:value-of select="@f_contsubno"/></xsl:if>(<xsl:value-of select="@f_title"/>)
								</xsl:when>
								<xsl:otherwise>
									""
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose> 
				   </xsl:attribute>
				   <xsl:attribute name="title">
					제<xsl:value-of select="@contno"/><xsl:choose><xsl:when test="$gbn='pyun'">편</xsl:when><xsl:when test="$gbn='jang'">장</xsl:when><xsl:when test="$gbn='jeol'">절</xsl:when><xsl:when test="$gbn='gwan'">관</xsl:when></xsl:choose><xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>(<xsl:value-of select="@title"/>)
				   </xsl:attribute>
   			           <xsl:value-of select="@contid"/>
				</jul>
		</xsl:if>
</xsl:template>

<xsl:template match="jo">
	<xsl:for-each select=".">
		<xsl:if  test="./@startcha =$startcha">
			<jul node="jo">
				<old node="title">
					<xsl:choose>
						<xsl:when test="./@endcha='9999'"> 
							<xsl:if test="./@curstate!='new'">
								제<xsl:value-of select="@f_contno"/>조<xsl:if test="./@f_contsubno>0">의<xsl:value-of select="@f_contsubno"/></xsl:if>(<xsl:value-of select="@f_title"/>)
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="./@createstate!='new'">
								제<xsl:value-of select="@f_contno"/>조<xsl:if test="./@f_contsubno>0">의<xsl:value-of select="@f_contsubno"/></xsl:if>(<xsl:value-of select="@f_title"/>)
							</xsl:if>						
						</xsl:otherwise>
					</xsl:choose>
				</old>
				<new node="title">
					제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if>(<xsl:value-of select="@title"/>)
				</new>
			</jul>
			
			
			<xsl:choose>
				<xsl:when test="./@endcha='9999'"> 
					<xsl:choose>
						<xsl:when test="./@curstate='revision'"> 
							<xsl:apply-templates select="gaejung" mode="ilbu"/>
						</xsl:when>
						<xsl:otherwise>
							<jul node="jo">
								<xsl:apply-templates select="old" mode="all"/>
								<xsl:apply-templates select="new" mode="all"/>
							</jul>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="./@createstate='revision'"> 
							<xsl:apply-templates select="gaejung" mode="ilbu"/>
						</xsl:when>
						<xsl:otherwise>
							<jul node="jo">
								<xsl:apply-templates select="old" mode="all"/>
								<xsl:apply-templates select="new" mode="all"/>
							</jul>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose> 
		</xsl:if>
	</xsl:for-each>
</xsl:template>    

<xsl:template match="new" mode="all">
        <new state="allrevision">  
	<xsl:for-each select=".">
		<xsl:value-of select="./text()"/>
		<xsl:apply-templates select="cont|hang|ho|mok|dan|image" mode="all"/>
     </xsl:for-each>
        </new>  
</xsl:template>     

<xsl:template match="old" mode="all">
        <old state="allrevision">  
	<xsl:for-each select=".">
	        <xsl:value-of select="./text()"/>
		<xsl:apply-templates select="cont|hang|ho|mok|dan|image" mode="all"/>
     </xsl:for-each>
        </old>  
</xsl:template>     

<xsl:template match="gaejung"  mode="ilbu">
	<xsl:for-each select=".">
		<jul node="jo">
		<xsl:apply-templates select="cont_gu|cont_sinbar" mode="ilbu"/>
		</jul>
		<xsl:apply-templates select="hang|ho|mok|dan|image" mode="ilbu"/>
     </xsl:for-each>
</xsl:template>    

<xsl:template match="hang" mode="ilbu">
	<xsl:for-each select=".">
	<jul node="hang">
		<xsl:apply-templates select="cont_gu|cont_sinbar|ho|mok|dan|image" mode="ilbu"/>
	</jul>
	</xsl:for-each>
</xsl:template>     

<xsl:template match="ho" mode="ilbu">
    <xsl:for-each select=".">
	<jul node="ho">
		<xsl:apply-templates select="cont_gu|cont_sinbar|mok|dan|image" mode="ilbu"/>
		</jul>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok" mode="ilbu">
    <xsl:for-each select=".">
	<jul node="mok">
		<xsl:apply-templates select="cont_gu|cont_sinbar|dan|image" mode="ilbu"/>
		</jul>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan" mode="ilbu">
    <xsl:for-each select=".">
    <jul node="dan">
		<xsl:apply-templates select="cont_gu|cont_sinbar|image" mode="ilbu"/>
		</jul>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="hang" mode="all">
	<xsl:for-each select=".">
		$space<xsl:apply-templates select="cont|ho|mok|dan|image" mode="all"/>
	</xsl:for-each>
</xsl:template>     


<xsl:template match="ho" mode="all">
    <xsl:for-each select=".">
		$space$space<xsl:apply-templates select="cont|ho|mok|dan|image" mode="all"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="mok" mode="all">
    <xsl:for-each select=".">
		$space$space<xsl:apply-templates select="cont|ho|mok|dan|image" mode="all"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="dan" mode="all">
    <xsl:for-each select=".">
		$space$space$space<xsl:apply-templates select="cont|ho|mok|dan|image" mode="all"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont_gu" mode="ilbu">
    <xsl:for-each select="."> 
        <old>  
		<xsl:apply-templates select="./text()|FONT" mode="col"/>
		<xsl:apply-templates select="image"/>
		</old>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont_sinbar" mode="ilbu">
    <xsl:for-each select=".">
        <new>  
		<xsl:apply-templates select="./text()|FONT" mode="col"/>
		<xsl:apply-templates select="image"/>
		</new>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="cont" mode="all">
    <xsl:for-each select=".">
  		<xsl:apply-templates select="./text()|FONT" mode="col"/><br/>
		<xsl:apply-templates select="image"/>
     </xsl:for-each>
</xsl:template>     

<xsl:template match="text()" mode="link">필요없는부분같어2
			    <xsl:choose> 
			  		<xsl:when test="contains(.,'&amp;lt;')">
			            <xsl:value-of select="substring-before(.,'&amp;lt;')"/>
						<xsl:value-of select="substring-after(.,'&amp;lt;')"/>
			    	</xsl:when>
				    <xsl:otherwise>
				    	<xsl:value-of select="."/>
				    </xsl:otherwise>
			    </xsl:choose>
</xsl:template> 


<xsl:template match="FONT" mode="col">
    <xsl:for-each select=".">
		<br/>66<xsl:apply-templates select="."/>
     </xsl:for-each>
</xsl:template>     

<!-- 이미지 -->

<xsl:template match="image|cont/image" mode="link">
	$$IMGFILESTART$$<xsl:value-of select="./@src"/>$$IMGFILEEND$$<br/>
</xsl:template>

<xsl:template match="image" >
	$$IMGFILESTART$$<xsl:value-of select="./@src"/>$$IMGFILEEND$$<br/>
</xsl:template>

<xsl:template match="cont_gu/img" mode="link">
	$$IMGFILESTART$$<xsl:value-of select="./@src"/>$$IMGFILEEND$$<br/>
</xsl:template>


</xsl:stylesheet>
