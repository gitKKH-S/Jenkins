<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:param name="bookid"/>
	<xsl:param name="revcha"/>
	<xsl:output method="html" encoding="euc-kr" indent="yes"/>

	<!-- 루트 template -->

	<xsl:template match="/">
		<xsl:apply-templates select="law"/>
	</xsl:template>

	<!-- 연혁 template -->

	<xsl:template match="history"> </xsl:template>

	<!-- 편 template -->
	<xsl:template match="pyun">
		<xsl:if test="./@endcha&gt;=$revcha">
			<xsl:if test="./@startcha&lt;=$revcha">
			<xsl:if test="./@curstate != 'delete'">
				<xsl:for-each select=".">
					<a>
						<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
						<p class="textBold">제<xsl:value-of select="@contno"/>편 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="@title"/></p>
					</a>
				</xsl:for-each>
				<xsl:call-template name="nvl">
					<xsl:with-param name="param" select="."/>
				</xsl:call-template>
				<xsl:for-each select="./jang">
					<xsl:if test="./@endcha&gt;=$revcha">
					<xsl:if test="./@startcha&lt;=$revcha">
					<xsl:if test="./@curstate != 'delete'">
					<a>
						<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
						<p class="textBold">제<xsl:value-of select="@contno"/>장 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="@title"/></p>
					</a>
					<xsl:call-template name="nvl">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
					<xsl:for-each select="./jeol">
						<xsl:if test="./@endcha&gt;=$revcha">
						<xsl:if test="./@startcha&lt;=$revcha">
						<xsl:if test="./@curstate != 'delete'">
						<a>
							<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
							<p class="textNormal">제<xsl:value-of select="@contno"/>절 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="@title" /></p>
						</a>
						<xsl:call-template name="nvl">
							<xsl:with-param name="param" select="."/>
						</xsl:call-template>
						</xsl:if>
						</xsl:if>
						</xsl:if>
					</xsl:for-each>
					</xsl:if>
					</xsl:if>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="./jeol">
					<xsl:if test="./@endcha&gt;=$revcha">
					<xsl:if test="./@startcha&lt;=$revcha">
					<xsl:if test="./@curstate != 'delete'">
					<a>
						<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
						<p class="textNormal">제<xsl:value-of select="@contno"/>절 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="@title"/></p>
					</a>
					<xsl:call-template name="nvl">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
					</xsl:if>
					</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- 장 template -->

	<xsl:template match="jang">
		<xsl:if test="./@endcha&gt;=$revcha">
			<xsl:if test="./@startcha&lt;=$revcha">
			<xsl:if test="./@curstate != 'delete'">
				<xsl:for-each select=".">
					<a>
						<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
						<p class="textBold"> 제<xsl:value-of select="@contno"/>장 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="@title"/></p>
					</a>
					<xsl:call-template name="nvl">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</xsl:for-each>
				
				<xsl:for-each select="./jeol">
				<xsl:if test="./@endcha&gt;=$revcha">
				<xsl:if test="./@startcha&lt;=$revcha">
				<xsl:if test="./@endcha&gt;=$revcha">
					<a>
						<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
						<p class="textNormal">제<xsl:value-of select="@contno"/>절 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="@title"/></p>
					</a>
					<xsl:call-template name="nvl">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
					<xsl:for-each select="./gwan">
					<a>
						<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
						<p class="textNormal">제<xsl:value-of select="@contno"/>관 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="@title"/></p>
					</a>
					<xsl:call-template name="nvl">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</xsl:for-each>
				</xsl:if>
				</xsl:if>
				</xsl:if>
				</xsl:for-each>
				
				<xsl:for-each select="./gwan">
					<a>
						<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
						<p class="textNormal">제<xsl:value-of select="@contno"/>관 <xsl:if test="./@contsubno > 0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="@title"/></p>
					</a>
					<xsl:call-template name="nvl">
						<xsl:with-param name="param" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- 조 template -->

	<xsl:template match="jo">
		<xsl:for-each select=".">
			<xsl:if test="./@endcha&gt;=$revcha">
				<xsl:if test="./@startcha&lt;=$revcha">
				<xsl:if test="./@curstate != 'delete'">
				<xsl:element name="img">
					<xsl:choose>
						<xsl:when test="./@memoyn = 'Y'">
							<xsl:attribute name="src">../../resources/images/memo12b.png</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="src">../../resources/images/memo12.png</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="class">histIconmemo</xsl:attribute>
					<xsl:attribute name="align">absmiddle</xsl:attribute>
					<xsl:attribute name="onclick">memoView('<xsl:value-of select="@contid"/>','<xsl:value-of select="$bookid"/>');</xsl:attribute>
				</xsl:element>
				
					<p class="textLink">
						<a>
							<xsl:choose>
								<xsl:when test="./@contsubno>0">
									<xsl:attribute name="href">#bon<xsl:value-of select="@contno" />bu<xsl:value-of select="@contsubno"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">#bon<xsl:value-of select="@contno"/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="title">제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno" /></xsl:if> <xsl:if test="@title!=''">(<xsl:value-of select="@title"/>)</xsl:if></xsl:attribute>제<xsl:value-of select="@contno"/>조 <xsl:if test="./@contsubno>0">의 <xsl:value-of select="@contsubno"/></xsl:if><xsl:if test="string-length(@title)>9"> (<xsl:value-of select="substring(@title,0,9)"/>... </xsl:if><xsl:if test="9>=string-length(@title)"> <xsl:if test="@title!=''">(<xsl:value-of select="@title" />)</xsl:if> </xsl:if>
						</a>
					</p>
				</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- 부칙 template -->
	<xsl:template match="buchicklist">
		<xsl:if test="./@endcha&gt;=$revcha">
			<xsl:if test="./@startcha&lt;=$revcha">
				<xsl:apply-templates select="buchick"/>	
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="buchick">
		<xsl:for-each select=".">
			<xsl:if test="./@endcha&gt;=$revcha">
				<xsl:if test="./@startcha&lt;=$revcha">
					<a>
						<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
						<p class="textBold">
							<xsl:value-of select="@title"/>
						</p>
					</a>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="./jang">
			<xsl:if test="./@endcha&gt;=$revcha">
				<xsl:if test="./@startcha&lt;=$revcha">
					<a>
						<xsl:attribute name="href">#<xsl:value-of select="@contid"/></xsl:attribute>
						<p class="textNormal">제<xsl:value-of select="@contno"/>장<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if> <xsl:value-of select="@title"/></p>
					</a>
					<xsl:for-each select="./jang/jo">
						<xsl:if test="./@endcha&gt;=$revcha">
							<xsl:if test="./@startcha&lt;=$revcha">
								<xsl:element name="img">
									<xsl:choose>
										<xsl:when test="./@memoyn = 'Y'">
											<xsl:attribute name="src">../../resources/images/memo12b.png</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="src">../../resources/images/memo12.png</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:attribute name="class">histIconmemo</xsl:attribute>
									<xsl:attribute name="align">absmiddle</xsl:attribute>
									<xsl:attribute name="onclick">memoView('<xsl:value-of select="@contid"/>','<xsl:value-of select="$bookid"/>');</xsl:attribute>
								</xsl:element>
								<p class="textLink">제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if> (<xsl:value-of select="@title"/>)</p>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="./jo">
			<xsl:if test="./@endcha&gt;=$revcha">
				<xsl:if test="./@startcha&lt;=$revcha">
					<xsl:element name="img">
						<xsl:choose>
							<xsl:when test="./@memoyn = 'Y'">
								<xsl:attribute name="src">../../resources/images/memo12b.png</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="src">../../resources/images/memo12.png</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:attribute name="class">histIconmemo</xsl:attribute>
						<xsl:attribute name="align">absmiddle</xsl:attribute>
						<xsl:attribute name="onclick">memoView('<xsl:value-of select="@contid"/>','<xsl:value-of select="$bookid"/>');</xsl:attribute>
					</xsl:element>
					<p class="textLink">
						<a><xsl:attribute name="href">#buc<xsl:value-of select="@contno" /></xsl:attribute> 제<xsl:value-of select="@contno"/>조 <xsl:if test="./@contsubno>0">의<xsl:value-of select="@contsubno"/></xsl:if> (<xsl:value-of select="@title"/>)</a>
					</p>
				</xsl:if>
			</xsl:if>				
		</xsl:for-each>
	</xsl:template>

	<!-- nvl template -->

	<xsl:template name="nvl">
		<xsl:param name="param" select="."/>
		<xsl:for-each select="./jo">
			<xsl:if test="./@endcha&gt;=$revcha">
				<xsl:if test="./@startcha&lt;=$revcha">
				<xsl:if test="./@curstate != 'delete'">
					<xsl:element name="img">
						<xsl:choose>
							<xsl:when test="./@memoyn = 'Y'">
								<xsl:attribute name="src">../../resources/images/memo12b.png</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="src">../../resources/images/memo12.png</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:attribute name="class">histIconmemo</xsl:attribute>
						<xsl:attribute name="align">absmiddle</xsl:attribute>
						<xsl:attribute name="onclick">memoView('<xsl:value-of select="@contid"/>','<xsl:value-of select="$bookid"/>');</xsl:attribute>
					</xsl:element>
					<xsl:element name="p">
						<xsl:attribute name="class">
							<xsl:if test="count(./panList)=0">
							textLink
							</xsl:if>
							<xsl:if test="count(./panList)!=0">
							textLink2
							</xsl:if>
						</xsl:attribute>
						<a>
							<xsl:choose>
								<xsl:when test="./@contsubno>0">
									<xsl:attribute name="href">#bon<xsl:value-of select="@contno" />bu<xsl:value-of select="@contsubno"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">#bon<xsl:value-of select="@contno" /></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="title">제<xsl:value-of select="@contno"/>조 <xsl:if test="./@contsubno>0">의 <xsl:value-of select="@contsubno" /></xsl:if><xsl:if test="@title!=''">(<xsl:value-of select="@title"/>)</xsl:if></xsl:attribute>
								제<xsl:value-of select="@contno"/>조<xsl:if test="./@contsubno>0" >의<xsl:value-of select="@contsubno"/></xsl:if>
							<xsl:if test="string-length(@title)>9"> <xsl:if test="@title!=''">(<xsl:value-of select="substring(@title,0,9)"/>... </xsl:if></xsl:if>
							<xsl:if test="9>=string-length(@title)"> <xsl:if test="@title!=''">(<xsl:value-of select="@title" />)</xsl:if> </xsl:if>
						</a>
					</xsl:element>
				</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- 별첨 template -->

	<xsl:template match="byulch"> </xsl:template>

	<!-- 별표 template -->
	<xsl:template match="byul"> </xsl:template>

	<!-- 별지서식 template -->

	<xsl:template match="byulji"> </xsl:template>

</xsl:stylesheet>
