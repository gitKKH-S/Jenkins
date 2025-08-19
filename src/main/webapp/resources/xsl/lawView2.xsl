<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="contid" />
<xsl:output method="html" encoding="euc-kr" indent="yes"/>


<xsl:template match="/����">
	<xsl:apply-templates select="�⺻����"/>
	<xsl:apply-templates select="����"/>
	<xsl:apply-templates select="��Ģ"/>
	<xsl:apply-templates select="��ǥ"/>
</xsl:template>

<xsl:template match="�⺻����">
<table style="text-align:center;">
	<tr>
		<td>
			<h3><xsl:value-of select="���ɸ�_�ѱ�"/></h3>
		</td>
	</tr>
	<tr>
		<td>
			<span class="blueText">
			[���� <xsl:value-of select="substring(��������,1,4)"/>.<xsl:value-of select="substring(��������,5,2)"/>.<xsl:value-of select="substring(��������,7,2)"/>.]
			[<xsl:value-of select="��������"/> �� <xsl:value-of select="������ȣ"/>ȣ,
			<xsl:value-of select="substring(��������,1,4)"/>.<xsl:value-of select="substring(��������,5,2)"/>.<xsl:value-of select="substring(��������,7,2)"/>.
			,<xsl:value-of select="����������"/>]
			</span>
		</td>
	</tr>
	<tr>
		<td align="right">
			<font size="2"><xsl:value-of select="�Ұ���ó"/></font>
		</td>
	</tr>
</table>
</xsl:template>

<xsl:template match="����">
			<table align="center">
				<xsl:for-each select="��������">
					<xsl:choose>
						<xsl:when test="$contid != ''">
							<xsl:if test="@����Ű = $contid">
								<xsl:variable name="jomunNum" select="concat('��', ������ȣ, '��')"/>
								<xsl:variable name="jomunSubNum" select="concat('��', ����������ȣ)"/>
								<xsl:variable name="jomunTitle" select="concat('(', ��������, ')')"/>
						
								<xsl:choose>
									<xsl:when test="�������� = '����'">
										<tr>
											<td style="padding-top: 25px;">
												&#160;<span class="titleText" style="font-size:15px;">
														<xsl:element name="a">
															<xsl:attribute name="name"><xsl:value-of select="@����Ű"/></xsl:attribute>
															<xsl:value-of select="��������"/>
														</xsl:element>
													</span>
											</td>
										</tr>
									</xsl:when>
									<xsl:otherwise>
											<tr>
												<td style="padding-top: 10px;">
													<xsl:element name="a">
													<xsl:attribute name="name">
														<xsl:value-of select="@����Ű"/>
													</xsl:attribute>
													<span class="titleText">
														<xsl:value-of select="$jomunNum"/>
														<xsl:if test="string-length(����������ȣ) != 0">
															<xsl:value-of select="$jomunSubNum"/>
														</xsl:if>
														<xsl:if test="string-length(��������) != 0">
															<xsl:value-of select="$jomunTitle"/>
														</xsl:if>
													</span>
													<xsl:choose>
													<xsl:when test="string-length(��������) != 0">
														<xsl:value-of select="substring-after(��������, $jomunTitle)"/>
													</xsl:when>
													<xsl:when test="string-length(����������ȣ) != 0">
														<xsl:value-of select="substring-after(��������, $jomunSubNum)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="substring-after(��������, $jomunNum)"/>
													</xsl:otherwise>
													</xsl:choose>
													</xsl:element>
												</td>
											</tr>
											
											<xsl:for-each select="��">
												<tr>
													<td style="padding-left:20px;"><xsl:value-of select="./�׳���"/></td>
												</tr>
													
												<xsl:for-each select="ȣ">
													<tr>
														<td style="padding-left:40px;"><xsl:value-of select="./ȣ����"/></td>
													</tr>
														
													<xsl:for-each select="��">
														<tr>
															<td style="padding-left:60px;"><xsl:value-of select="./�񳻿�"/></td>
														</tr>
													</xsl:for-each>
												</xsl:for-each>
											</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="string-length(���������ڷ�) != 0">
									<tr>
										<td style="padding-left:20px;"><span class="blueText"><xsl:value-of select="���������ڷ�"/></span></td>
									</tr>
								</xsl:if>
						</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="jomunNum" select="concat('��', ������ȣ, '��')"/>
								<xsl:variable name="jomunSubNum" select="concat('��', ����������ȣ)"/>
								<xsl:variable name="jomunTitle" select="concat('(', ��������, ')')"/>
						
								<xsl:choose>
									<xsl:when test="�������� = '����'">
										<tr>
											<td style="padding-top: 25px;">
												&#160;<span class="titleText" style="font-size:15px;">
														<xsl:element name="a">
															<xsl:attribute name="name"><xsl:value-of select="@����Ű"/></xsl:attribute>
															<xsl:value-of select="��������"/>
														</xsl:element>
													</span>
											</td>
										</tr>
									</xsl:when>
									<xsl:otherwise>
											<tr>
												<td style="padding-top: 10px;">
													<xsl:element name="a">
													<xsl:attribute name="name">
														<xsl:value-of select="@����Ű"/>
													</xsl:attribute>
													<span class="titleText">
														<xsl:value-of select="$jomunNum"/>
														<xsl:if test="string-length(����������ȣ) != 0">
															<xsl:value-of select="$jomunSubNum"/>
														</xsl:if>
														<xsl:if test="string-length(��������) != 0">
															<xsl:value-of select="$jomunTitle"/>
														</xsl:if>
													</span>
													<xsl:choose>
													<xsl:when test="string-length(��������) != 0">
														<xsl:value-of select="substring-after(��������, $jomunTitle)"/>
													</xsl:when>
													<xsl:when test="string-length(����������ȣ) != 0">
														<xsl:value-of select="substring-after(��������, $jomunSubNum)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="substring-after(��������, $jomunNum)"/>
													</xsl:otherwise>
													</xsl:choose>
													</xsl:element>
												</td>
											</tr>
											
											<xsl:for-each select="��">
												<tr>
													<td style="padding-left:20px;"><xsl:value-of select="./�׳���"/></td>
												</tr>
													
												<xsl:for-each select="ȣ">
													<tr>
														<td style="padding-left:40px;"><xsl:value-of select="./ȣ����"/></td>
													</tr>
														
													<xsl:for-each select="��">
														<tr>
															<td style="padding-left:60px;"><xsl:value-of select="./�񳻿�"/></td>
														</tr>
													</xsl:for-each>
												</xsl:for-each>
											</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="string-length(���������ڷ�) != 0">
									<tr>
										<td style="padding-left:20px;"><span class="blueText"><xsl:value-of select="���������ڷ�"/></span></td>
									</tr>
								</xsl:if>
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:for-each>
			</table>
		
		
	
</xsl:template>

<xsl:template match="��Ģ">
	
</xsl:template>

<xsl:template match="��ǥ">
	
</xsl:template>
</xsl:stylesheet>
