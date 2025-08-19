<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>
  <xsl:template match="/">
    <html>
      <head>
          <script langage="javascript">
          <![CDATA[
				function link(lawcode,jo){
					window.open("./law_Popup.jsp?Book_id="+lawcode+"#"+jo, "ocase", "width=562,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no");
				}
				function link_law(lawcode,jo){
					var url = "/jsp/bylaw/law/lawviewPop.jsp?gbn=law&lawsid="+lawcode;
					if(jo!='000100'){
						url = url + "#"+jo+"1";
					}
					//새창의 크기
					 cw=880;
					 ch=670;
					  //스크린의 크기
					 sw=screen.availWidth;
					 sh=screen.availHeight;
					 //열 창의 포지션
					 px=(sw-cw)/2;
					 py=(sh-ch)/2;
					 //창을 여는부분
					property="left="+px+",top="+py+",width=880,height=670,scrollbars=yes,resizable=no,status=no,toolbar=no";
					
					var pop_f;
					
					pop_f = window.open(url,'klaw',property);
					pop_f.focus();
			
				}
				function revision(){
				form=document.revi;
					window.open("./revision_popup.jsp?Book_id="+form.sel.value, "revision", "width=502,height=320,scrollbars=yes,resizable=no,status=no,toolbar=no");
				}
				function move1(){
					form=document.revi;
					location.href="../law_Popup.jsp?Book_id="+form.sel.value;
				}
				]]>
		</script>
      </head>
      <body>
        <xsl:apply-templates select="jo"/>
      </body>
    </html>
  </xsl:template>
<xsl:template match="cont">
    <xsl:for-each select=".">
	        <xsl:apply-templates select="./text()|./bylaw|./law|./image|./img|./a5b5|./strong" mode="link"/><br/>                          
    </xsl:for-each>
</xsl:template>
	<xsl:template match="hang">
		<xsl:for-each select=".">
		<div style="padding: 2px 2px 2px 2px;">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/strong" mode="link"/><br/>
				<xsl:value-of select="@showtag"/>
		</div>
			<xsl:for-each select="ho">
				<div id="ho" >
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/strong" mode="link"/><br/>
				</div>
				<xsl:for-each select="mok">
					<div id="mok">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/strong" mode="link"/><br/>
					</div>
					<xsl:for-each select="dan">
						<div id="dan">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/strong" mode="link"/><br/>
						</div>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="mok">
			<div id="mok">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/strong" mode="link"/><br/>
			</div>
			<xsl:for-each select="dan">
				<div id="dan">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/image|cont/img|cont/a5b5|cont/strong" mode="link"/><br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>			
	</xsl:template>
    <xsl:template match="law" mode="link">
        <a>
            <xsl:attribute name="href">javascript:link_law('<xsl:value-of select="./@lawid"/>','<xsl:value-of select="./@contno"/>');</xsl:attribute>
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
     <xsl:template match="bylaw" mode="link">
       
          <strong style="color:red"><xsl:value-of select="."/></strong>

    </xsl:template>
	
	<xsl:template match="cont/strong" mode="link">
		 <strong style="color:red"><xsl:value-of select="."/></strong>
	</xsl:template>
    <xsl:template match="image" >

		 <xsl:apply-templates select="." mode="link"/>

	</xsl:template>
    <xsl:template match="image|cont/image" mode="link">
	
		<p><img><xsl:attribute name="src">/dataFile/law/img/<xsl:value-of select="./@src"/></xsl:attribute><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></img></p>

	</xsl:template>

<xsl:template match="cont/img" mode="link">
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

<xsl:template match="cont/a5b5" mode="link">
<br/>
</xsl:template>	
 </xsl:stylesheet>
