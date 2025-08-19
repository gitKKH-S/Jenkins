<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" encoding="euc-kr" indent="yes"/>
  <xsl:template match="/">
    <html>
    <head>
    <script langage="javascript">
    	var CONTEXTPATH = window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
		if(CONTEXTPATH!='/goynag'){
			CONTEXTPATH = ""
		}
    			function link_file(filename){
					//새창의 크기
					 cw=562;
					 ch=420;
					  //스크린의 크기
					 sw=screen.availWidth;
					 sh=screen.availHeight;
					 //열 창의 포지션
					 px=(sw-cw)/2;
					 py=(sh-ch)/2;
					 //창을 여는부분
					property="left="+px+",top="+py+",width=562,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no";
					window.open("/jsp/bylaw/existing/hwp.jsp?fileUrl="+filename, "ocase",property);
				}
				function link(lawcode,jo){
					//새창의 크기
					 cw=1200;
					 ch=900;
					  //스크린의 크기
					 sw=screen.availWidth;
					 sh=screen.availHeight;
					 //열 창의 포지션
					 px=(sw-cw)/2;
					 py=(sh-ch)/2;
					 //창을 여는부분
					property="left="+px+",top="+py+",width=1500,height=900,scrollbars=no,resizable=yes,status=no,toolbar=no";
					window.open(CONTEXTPATH + "/web/regulation/regulationViewPop.do?OBOOKID="+lawcode+"#"+jo, "ocase",property);
				}
				<![CDATA[
				function link_law(lawcode,jo){
					var url = CONTEXTPATH + "/web/law/lawViewPagePop.do?LAWID="+lawcode;
					if(jo!='000100'){
						//url = url + "#"+jo+"1";
						url = url + "&JO="+jo;
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
					property="left="+px+",top="+py+",width=1300,height=870,scrollbars=no,resizable=yes,status=no,toolbar=no";
					
					var pop_f;
					
					pop_f = window.open(url,'klaw',property);
					pop_f.focus();
				}
				
				function link_pan(key){
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
					window.open("/jsp/lkms3/jsp/pan/panView.jsp?JDPR_MNNO="+key, "ocase", property);
				}
				
				function link_bylaw(key,noformyn){
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
					property="left="+px+",top="+py+",width=1180,height=770,scrollbars=yes,resizable=no,status=no,toolbar=no";
					var url = '';
					if(noformyn=='Y'){
						url = '/jsp/bylaw/regulation/regul_board_noForm.jsp';
					}else{
						url = '/jsp/bylaw/regulation/regulationView.jsp';
					}
					window.open(url+"?Bookid="+key, "ocase", property);
				}
				]]>
				function revision(bookid){
					var pstate = "mp";
					//새창의 크기
					cw=502;
					ch=320;
					//스크린의 크기
					sw=screen.availWidth;
					sh=screen.availHeight;
					//열 창의 포지션
					px=(sw-cw)/2;
					py=(sh-ch)/2;
					//창을 여는부분
					property="left="+px+",top="+py+",width=627,height=388,scrollbars=yes,resizable=no,status=no,toolbar=no";
					form=document.revi;
					var book_id = form.sel.value.substring(0,form.sel.value.length-1);
					window.open("./popup/revisionPop.jsp?Bookid="+bookid, "revision", property);
				}
				function move1(Statecd,asd,Obookid,ListS,type,type2,menuType){
					form=document.revi;
					if(form.sel.value==''){
						alert('연혁데이터가 존재하지 않습니다.');
						form.sel.options[0].selected = true;
						return;
					}else{
						var bookid = form.sel.value.substring(0,form.sel.value.length-1);
						var noform=form.sel.value.substring(form.sel.value.length-1,form.sel.value.length);
						if(noform=='N'){
							form.Bookid.value=bookid;
							form.Obookid.value=Obookid;
							form.Statecd.value=Statecd;
							form.ListS.value=ListS;
							form.type.value=type;
							form.type2.value=type2;
							form.menuType.value=menuType;
							form.action="regulationView.jsp";
							form.submit();
						}else if(noform=='Y'){
							document.location.href="regul_board_noForm.jsp?Bookid="+bookid+"&amp;Statecd="+Statecd+"&amp;ListS="+ListS+"&amp;type="+type+"&amp;menuType="+menuType;
						}
					}
				}
				function old(bookid,contno,contsubno,allcha,bcontid){
					//새창의 크기
					cw=502;
					ch=320;
					//스크린의 크기
					sw=screen.availWidth;
					sh=screen.availHeight;
					//열 창의 포지션
					px=(sw-cw)/2;
					py=(sh-ch)/2;
					//창을 여는부분
					property="left="+px+",top="+py+",width=950,height=400,scrollbars=yes,resizable=yes,status=no,toolbar=no";
					form=document.revi;
					window.open("joPop.do?Bookid="+bookid+"&amp;Contno="+contno+"&amp;Contsubno="+contsubno+"&amp;allcha="+allcha+"&amp;bcontid="+bcontid, contno, property);
				}

				function reJo(bookid,Contid,linkJono){
					//새창의 크기
					cw=502;
					ch=320;
					//스크린의 크기
					sw=screen.availWidth;
					sh=screen.availHeight;
					//열 창의 포지션
					px=(sw-cw)/2;
					py=(sh-ch)/2;
					//창을 여는부분
					property="left="+px+",top="+py+",width=900,height=652,scrollbars=yes,resizable=no,status=no,toolbar=no";
					form=document.revi;
					window.open("./popup/relJoView.jsp?Bookid="+bookid+"&amp;Contid="+Contid+"&amp;linkJono="+linkJono, Contid, property);
				}
				
				function fileView(contid){
					var url = "joFileList.do?contid="+contid;
					//새창의 크기
					 cw=550;
					 ch=370;
					  //스크린의 크기
					 sw=screen.availWidth;
					 sh=screen.availHeight;
					 //열 창의 포지션
					 px=(sw-cw)/2;
					 py=(sh-ch)/2;
					 //창을 여는부분
					property="left="+px+",top="+py+",width=550,height=470,scrollbars=no,resizable=yes,status=no,toolbar=no";
					
					var pop_f;
					
					pop_f = window.open(url,contid,property);
					pop_f.focus();
				}
		</script>
    </head>
      <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
        <xsl:apply-templates select="law"/>
      </body>
    </html>
  </xsl:template>

<xsl:template name="etc">
	<xsl:param name="param" select="."/>
	<xsl:for-each select="hang">
			<xsl:choose> 
				<xsl:when test=" (position() =1) and local-name(parent::*)='jo'">
							<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
							<xsl:if test="./cont/@tag!=''">
							<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
							</xsl:if>
							<br/>
				</xsl:when>
				<xsl:otherwise>
					<div id="hang">
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
						<xsl:if test="./cont/@tag!=''">
						<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
						<br/>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		<xsl:for-each select="ho">
			<div id="ho" >
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
				<xsl:if test="./cont/@tag!=''">
				<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
				</xsl:if>
				<br/>
			</div>
			<xsl:for-each select="mok">
				<div id="mok" >
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
					<xsl:if test="./cont/@tag!=''">
					<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
					</xsl:if>
					<br/>
				</div>
				<xsl:for-each select="dan">
					<div id="dan" >
						<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
						<xsl:if test="./cont/@tag!=''">
						<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
						</xsl:if>
						<br/>
					</div>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="dan">
				<div id="dan" >
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
					<xsl:if test="./cont/@tag!=''">
					<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
					</xsl:if>
					<br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="mok">
			<div id="mok">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
				<xsl:if test="./cont/@tag!=''">
				<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
				</xsl:if>
				<br/>
			</div>
			<xsl:for-each select="dan">
				<div id="dan">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
					<xsl:if test="./cont/@tag!=''">
					<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
					</xsl:if>
					<br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="dan">
			<div class="dan" style="padding-left:20px;padding-top:5px">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
				<xsl:if test="./cont/@tag!=''">
				<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
				</xsl:if>
				<br/>
			</div>
		</xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="ho">
		<div id="ho" >
		<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
		<xsl:if test="./cont/@tag!=''">
		<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
		</xsl:if>
		<br/>
		</div>
		<xsl:for-each select="mok">
			<div id="mok">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
				<xsl:if test="./cont/@tag!=''">
				<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
				</xsl:if>
				<br/>
			</div>
			<xsl:for-each select="dan">
				<div id="dan">
					<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
					<xsl:if test="./cont/@tag!=''">
					<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
					</xsl:if>
					<br/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="mok">
		<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
		<xsl:if test="./cont/@tag!=''">
		<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
		</xsl:if>
		<br/>
		<xsl:for-each select="dan">
			<div id="dan">
				<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
				<xsl:if test="./cont/@tag!=''">
				<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
				</xsl:if>
				<br/>
			</div>
		</xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="dan">
		<xsl:apply-templates select="cont/text()|cont/law|cont/bylaw|cont/byullink|cont/image|cont/img|cont/a5b5|cont/table|cont/span" mode="link"/>
		<xsl:if test="./cont/@tag!=''">
		<span class="jotag2"><xsl:value-of select="./cont/@tag"/></span>
		</xsl:if>
		<br/>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
