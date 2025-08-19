<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	List DanList = request.getAttribute("list")==null?new ArrayList():(List)request.getAttribute("list");
	String Obookid = param.get("obookid")==null?"":param.get("obookid").toString();
	String gbn = param.get("gbn")==null?"":param.get("gbn").toString();
	
	
	String Book_id_l="";//왼쪽
	String Book_id_c="";//중앙
	String Book_id_r="";//오른쪽
	String Book_id_r2="";//오른쪽
	for(int k=0;k<DanList.size();k++){
		HashMap bylaw=(HashMap)DanList.get(k);
		String Dan=bylaw.get("DAN")==null?"":bylaw.get("DAN").toString();
		String Danorder=bylaw.get("ORD")==null?"":bylaw.get("ORD").toString();
		if(Dan.equals("1")){
			Book_id_l=bylaw.get("BOOKID")==null?"":bylaw.get("BOOKID").toString();
		}
		if(Dan.equals("2")&&Danorder.equals("1")){
			Book_id_c=bylaw.get("BOOKID")==null?"":bylaw.get("BOOKID").toString();
		}
		if(Dan.equals("3")&&Danorder.equals("1")){
			Book_id_r=bylaw.get("BOOKID")==null?"":bylaw.get("BOOKID").toString();
		}		
		if(Dan.equals("4")&&Danorder.equals("1")){
			Book_id_r2=bylaw.get("BOOKID")==null?"":bylaw.get("BOOKID").toString();
		}
	} 
	
%>
<html>
<head>
<title>4단보기</title>
<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.js" type="text/javascript"></script>
<script language="javascript">
<!--
	window.focus();
//--> 
	// 삼단보기 창 줄이기 처리
	function frame(id){
		if(id=="a"){
			if(document.all.b.style.display == "" && document.all.c.style.display == ""  && document.all.d.style.display == ""){
				alert("규정,세칙,기준중하나는 화면에 있어야 합니다.");
				return;
			}
			document.all.a.style.display = "";
			document.all.a1.style.display = "none";
		}else if(id=="a1"){
			document.all.a.style.display = "none";
			document.all.a1.style.display = "";
		}else if(id=="b"){
			if(document.all.a.style.display == "" && document.all.c.style.display == ""  && document.all.d.style.display == ""){
					alert("규정,세칙,기준중하나는 화면에 있어야 합니다.");
					return;
				}
			document.all.b.style.display = "";
			document.all.b1.style.display = "none";
		}else if(id=="b1"){
			document.all.b.style.display = "none";
			document.all.b1.style.display = "";
		}else if(id=="c"){
			if(document.all.a.style.display == "" && document.all.b.style.display == "" && document.all.d.style.display == ""){
				alert("규정,세칙,기준중하나는 화면에 있어야 합니다.");
				return;
			}
			document.all.c.style.display = "";
			document.all.c1.style.display = "none";
		}else if(id=="c1"){
			document.all.c.style.display = "none";
			document.all.c1.style.display = "";		
		}else if(id=="d"){
			if(document.all.a.style.display == "" && document.all.b.style.display == ""  && document.all.c.style.display == ""){
				alert("규정,세칙,기준중하나는 화면에 있어야 합니다.");
				return;
			}
			document.all.d.style.display = "";
			document.all.d1.style.display = "none";
		}else if(id=="d1"){
			document.all.d.style.display = "none";
			document.all.d1.style.display = "";		
		}
	}
	//파일 저장
	function fncSaveAs1(Bookid){ 
		window.open('createHwp.do?Bookid='+Bookid,'','');
	} 
	
	// 본문 Print 
	function print1(Book_id_r,Book_id_c,Book_id_l,Book_id_l2){
		if(document.all.a.style.display == ""){
			window.open("Dan_print.do?Book_id_c="+Book_id_c+"&Book_id_l="+Book_id_l ,"ocase", "width=562,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no");
		}else if(document.all.b.style.display == ""){
			window.open("Dan_print.do?Book_id_r="+Book_id_r+"&Book_id_l="+Book_id_l ,"ocase", "width=562,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no");
		}else if(document.all.c.style.display == ""){
			window.open("Dan_print.do?Book_id_r="+Book_id_r+"&Book_id_c="+Book_id_c ,"ocase", "width=562,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no");
		}else if(document.all.d.style.display == ""){
			window.open("Dan_print.do?Book_id_r="+Book_id_r+"&Book_id_c="+Book_id_c ,"ocase", "width=562,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no");
		}else{
			window.open("Dan_print.do?Book_id_l="+Book_id_l+"&Book_id_c="+Book_id_c+"&Book_id_r="+Book_id_r+"&Book_id_l2="+Book_id_l2 ,"ocase", "width=562,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no");
		}
	}
	// 본문 Print 
	function print(Bookid){
		window.open("Dan_print.do?Bookid="+Bookid ,"ocase", "width=562,height=420,scrollbars=yes,resizable=no,status=no,toolbar=no");
	}
	function selectcon2(sel){
		document.sel.Book_id_l.value=<%=Book_id_l%>;
		document.sel.Book_id_c.value=sel;
		document.sel.gbn.value='center';
		form=document.sel;
		form.target = "b12";
		form.action = "frameBon.do";
		form.submit();
		selectcon3(document.sel.rig.value);
	}
	function selectcon3(sel){
		document.sel.Book_id_r.value=sel;
		document.sel.Book_id_c.value=document.sel.cen.value;
		document.sel.gbn.value='right';
		document.sel.target = "c12";
		document.sel.action = "frameBon.do";
		document.sel.submit();
	}
	function selectcon4(sel){
		document.sel.Book_id_r2.value=sel;
		document.sel.Book_id_r.value=document.sel.rig.value;
		document.sel.Book_id_c.value=document.sel.cen.value;
		document.sel.gbn.value='right2';
		document.sel.target = "d12";
		document.sel.action = "frameBon.do";
		document.sel.submit();
	}
	function next(){
		sel.Book_id_l.value=<%=Book_id_l%>;
		sel.gbn.value='left';
		sel.target = "a12";
		sel.action = "frameBon.do";
		sel.submit();
	}
	function next2(){
		sel.Book_id_c.value=<%=Book_id_c%>;
		sel.Book_id_l.value=<%=Book_id_l%>;
		sel.gbn.value='center';
		sel.target = "b12";
		sel.action = "frameBon.do";
		sel.submit();
	}
	function next3(){
		sel.Book_id_r.value=<%=Book_id_r%>;
		sel.Book_id_c.value=<%=Book_id_c%>;
		sel.Book_id_l.value=<%=Book_id_l%>;
		sel.gbn.value='right';
		sel.target = "c12";
		sel.action = "frameBon.do";
		sel.submit();
	}
	function next4(){
		sel.Book_id_r2.value=<%=Book_id_r2%>;
		sel.Book_id_r.value=<%=Book_id_r%>;
		sel.Book_id_c.value=<%=Book_id_c%>;
		sel.Book_id_l.value=<%=Book_id_l%>;
		sel.gbn.value='right2';
		sel.target = "d12";
		sel.action = "frameBon.do";
		sel.submit();
	}
	function compare(){
		sel.Book_id_l.value='<%=Book_id_l%>';
		sel.Book_id_c.value=document.sel.cen.value;
		sel.Book_id_r.value=document.sel.rig.value;
		sel.Book_id_r2.value=document.sel.rig2.value;
		sel.Obookid.value='<%=Obookid%>';
	
		form = document.sel;
		window.open("","new_popup","scrollbars=no,resizable=yes");          // 빈 페이지를 창이름 'new_popup' 으로 띄웁니다.
		form.target = "new_popup";                    // 폼의 타겟을 'new_popup'으로  하고
		form.action = "dan_fram4.do";
		form.method = "post";
		form.submit();                         

		
	}
	$(window).load(function(){
		$("#pop2ViewBody").css("height",$("#ppop2ViewBody").css("height"));
	})
	$(window).resize(function() {
		$("#pop2ViewBody").css("height",$("#ppop2ViewBody").css("height"));
    });
</script>

<link href="${resourceUrl}/mnview/css/main.css" rel="stylesheet" type="text/css" media="screen">
<link href="${resourceUrl}/mnview/css/poplayout.css" rel="stylesheet" type="text/css" media="screen">
<link id="cssCont" href="${resourceUrl}/mnview/css/view9pt.css" rel="stylesheet" type="text/css">
<link href="${resourceUrl}/mnview/css/viewEtc.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
* {
	font-family:  "돋움", "굴림";
	color: #333;
	margin:0px;
	padding:0px;
	font-size:12px;
}
-->
</style>
</head>
<BODY topmargin="0" leftmargin="10" onLoad ="next4();next3();next2();next();">

<form name="sel" method="post">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="1%">
<div id="top3dnaView">
<table width="100%" border="0" cellspacing="0" cellpadding="0" background="${resourceUrl}/mnview/img/regul/bg_popHeader.gif">
		<tr>
			<td><p class="popTitle">4단보기</p></td>
			<td width="128" height="52"></td>
		</tr>
	</table>
</div>
<div id="topButt" style="border-bottom:#CCC 1px solid; margin-bottom:5px;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="10">&nbsp;</td>
		<td width="100" id="a" style="display:none;"><img onClick="frame('a1');" style="cursor:hand;" src="${resourceUrl}/mnview/img/regul/but-show-rule.gif" width="90" height="18" alt="규정보이기"></td>
		<td width="100" id="b" style="display:none;"><img onClick="frame('b1');" style="cursor:hand;" src="${resourceUrl}/mnview/img/regul/but-show-detRule.gif" width="90" height="18" alt="세칙보이기"></td>
		<td width="100" id="c" style="display:none;"><img onClick="frame('c1');" style="cursor:hand;" src="${resourceUrl}/mnview/img/regul/but-show-detRule.gif" width="90" height="18" alt="기준보이기"></td>
		<td width="100" id="d" style="display:none;"><img onClick="frame('d1');" style="cursor:hand;" src="${resourceUrl}/mnview/img/regul/but-show-detRule.gif" width="90" height="18" alt="기준보이기"></td>
		<td height="28">&nbsp;</td>
		<td width="120" class="linkedRule"><a href="javascript:compare();">연결조문비교보기</a></td>
		<td width="80" class="printAll"><a href="javascript:print1('<%=Book_id_l %>',document.sel.cen.value,document.sel.rig.value,document.sel.rig2.value);" >전체인쇄</a></td>
		</tr>
</table>
</div>	
		</td>
	</tr>
	<tr>
		<td style="vertical-align:top;" id="ppop2ViewBody">
<div id="pop2ViewBody" style="padding: 0 5px 0 5px; text-align:center;">
	<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="a1" style="display:'';width:25%"><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="1%" style="text-align:left;" background="${resourceUrl}/mnview/img/regul/bg_3danTitle.gif"><img src="${resourceUrl}/mnview/img/regul/tab1.gif" width="125" height="36" alt="규정탭"></td>
			</tr>
			<tr>
				<td height="28" align="right" style="padding-right:10px; border-bottom:#CCC 1px dotted"><img src="${resourceUrl}/mnview/img/regul/btn_18.gif" border="0" align="absmiddle" style="cursor:hand;" onClick="frame('a')">&nbsp;
													<img src="${resourceUrl}/mnview/img/regul/btn_38.gif" align="absmiddle" style="cursor:hand;" onClick="fncSaveAs1(<%=Book_id_l%>)">&nbsp;
													<img src="${resourceUrl}/mnview/img/regul/btn_20.gif" align="absmiddle" style="cursor:hand;" onClick="print(<%=Book_id_l%>)"></td>
			</tr>
			<tr>
				<td><iframe id="a2" name="a12" src="" scrolling="yes" frameborder="0" width="100%" height="100%" > </iframe></td>
			</tr>
		</table></td>
		<td valign="top" id="b1" style="display:'';width:25%"><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="1%" style="text-align:left;" background="${resourceUrl}/mnview/img/regul/bg_3danTitle.gif"><img src="${resourceUrl}/mnview/img/regul/tab2.gif" width="125" height="36" alt="규정탭"></td>
			</tr>
			<tr>
				<td height="28" align="right" style="padding-right:10px; border-bottom:#CCC 1px dotted"><select class="selectBox" name="cen" setDisplayCount="5" 
													tooltip='다른 세칙을 선택할수 있습니다.' onChange="selectcon2(this.value);"
													setImage="${resourceUrl}/mnview/img/regul/arrow_image2.gif" setColor="#000000,#FFFFFF,#000000,#E6E4E4,#C0C0C0,#000000"><!-- select style="width:100;"은 가로길이를 정해준것이니 수정가능합니다-->
													<%
														for(int k=0;k<DanList.size();k++){
															HashMap bylaw=(HashMap)DanList.get(k);
															String Dan=bylaw.get("DAN")==null?"":bylaw.get("DAN").toString();
															String Danorder=bylaw.get("ORD")==null?"":bylaw.get("ORD").toString();
															if(Dan.equals("2")){
													%>	
														<option value="<%=bylaw.get("BOOKID") %>"tooltip="<%=bylaw.get("TITLE") %>"><%=bylaw.get("TITLE") %></option>
													<%
															}
														}
													%>
													</select>&nbsp;&nbsp;<img src="${resourceUrl}/mnview/img/regul/btn_18.gif" border="0" align="absmiddle" style="cursor:hand;"onclick="frame('b')">&nbsp;
													<img src="${resourceUrl}/mnview/img/regul/btn_38.gif" align="absmiddle" style="cursor:hand;" onClick="fncSaveAs1(document.sel.cen.value)">&nbsp;
							<img src="${resourceUrl}/mnview/img/regul/btn_20.gif" align="absmiddle" style="cursor:hand;" onClick="print(document.sel.cen.value)"></td>
			</tr>
			<tr>
				<td><iframe id="b2" name="b12" src="" scrolling="yes" frameborder="0" width="100%" height="100%" marginheight="10" marginwidth="10"> </iframe></td>
			</tr>
		</table></td>
		<td valign="top" id="c1" style="display:'';width:25%"><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="1%" style="text-align:left;" background="${resourceUrl}/mnview/img/regul/bg_3danTitle.gif"><img src="${resourceUrl}/mnview/img/regul/tab3.gif" width="125" height="36" alt="규정탭"></td>
			</tr>
			<tr>
				<td height="28" align="right" style="padding-right:10px; border-bottom:#CCC 1px dotted"><select class="selectBox" name="rig" setDisplayCount="5" 
													tooltip='다른 기준을 선택할수 있습니다.' onChange="selectcon3(this.value);"
													setImage="${resourceUrl}/mnview/img/regul/arrow_image2.gif" setColor="#000000,#FFFFFF,#000000,#E6E4E4,#C0C0C0,#000000">
													<%
														for(int k=0;k<DanList.size();k++){
															HashMap bylaw=(HashMap)DanList.get(k);
															String Dan=bylaw.get("DAN")==null?"":bylaw.get("DAN").toString();
															String Danorder=bylaw.get("ORD")==null?"":bylaw.get("ORD").toString();
															if(Dan.equals("3")){
													%>	
														<option value="<%=bylaw.get("BOOKID") %>"tooltip="<%=bylaw.get("TITLE") %>"><%=bylaw.get("TITLE") %></option>
													<%
															}
														}
													%>
													</select>&nbsp;&nbsp;<img src="${resourceUrl}/mnview/img/regul/btn_18.gif" border="0" align="absmiddle" style="cursor:hand;"onclick="frame('c')">&nbsp;
													<img src="${resourceUrl}/mnview/img/regul/btn_38.gif" align="absmiddle" style="cursor:hand;" onClick="fncSaveAs1(document.sel.rig.value)">&nbsp;
							<img src="${resourceUrl}/mnview/img/regul/btn_20.gif" align="absmiddle" style="cursor:hand;" onClick="print(document.sel.rig.value)"></td>
			</tr>
			<tr>
				<td><iframe id="c2" name="c12"  src="" scrolling="yes" frameborder="0" width="100%" height="100%" marginheight="10" marginwidth="10">
							</iframe></td>
			</tr>
		</table></td>
		<td valign="top" id="d1" style="display:'';width:25%"><table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="1%" style="text-align:left;" background="${resourceUrl}/mnview/img/regul/bg_3danTitle.gif"><img src="${resourceUrl}/mnview/img/regul/tab3.gif" width="125" height="36" alt="규정탭"></td>
			</tr>
			<tr>
				<td height="28" align="right" style="padding-right:10px; border-bottom:#CCC 1px dotted"><select class="selectBox" name="rig2" setDisplayCount="5" 
													tooltip='다른 기준을 선택할수 있습니다.' onChange="selectcon4(this.value);"
													setImage="${resourceUrl}/mnview/img/regul/arrow_image2.gif" setColor="#000000,#FFFFFF,#000000,#E6E4E4,#C0C0C0,#000000">
													<%
														for(int k=0;k<DanList.size();k++){
															HashMap bylaw=(HashMap)DanList.get(k);
															String Dan=bylaw.get("DAN")==null?"":bylaw.get("DAN").toString();
															String Danorder=bylaw.get("ORD")==null?"":bylaw.get("ORD").toString();
															if(Dan.equals("4")){
													%>	
														<option value="<%=bylaw.get("BOOKID") %>"tooltip="<%=bylaw.get("TITLE") %>"><%=bylaw.get("TITLE") %></option>
													<%
															}
														}
													%>
													</select>&nbsp;&nbsp;<img src="${resourceUrl}/mnview/img/regul/btn_18.gif" border="0" align="absmiddle" style="cursor:hand;"onclick="frame('d')">&nbsp;
													<img src="${resourceUrl}/mnview/img/regul/btn_38.gif" align="absmiddle" style="cursor:hand;" onClick="fncSaveAs1(document.sel.rig2.value)">&nbsp;
							<img src="${resourceUrl}/mnview/img/regul/btn_20.gif" align="absmiddle" style="cursor:hand;" onClick="print(document.sel.rig2.value)"></td>
			</tr>
			<tr>
				<td><iframe id="d2" name="d12"  src="" scrolling="yes" frameborder="0" width="100%" height="100%" marginheight="10" marginwidth="10">
							</iframe></td>
			</tr>
		</table></td>
	</tr>
</table>
</div>		
		</td>
	</tr>
	<tr>
		<td height="1%">
<div id="popButtonPrint">
	<img style="cursor:hand;" onClick="window.self.close();" src="${resourceUrl}/mnview/img/regul/but-all-close.gif" width="57" height="21" alt="닫기">
</div>
		</td>
	</tr>
</table>
<input type="hidden" name="Book_id_r2" >
<input type="hidden" name="Book_id_r" >
<input type="hidden" name="Book_id_c">
<input type="hidden" name="Book_id_l" value='<%=Book_id_l %>'>
<input type="hidden" name="Book_id">
<input type="hidden" name="Obookid">
<input type="hidden" name="gbn" value="<%=gbn %>">
</form>
</BODY>
</HTML>
