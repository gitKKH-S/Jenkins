<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%
	String Book_id_r = ServletRequestUtils.getStringParameter(request,"Book_id_r","");
	String Book_id_c = ServletRequestUtils.getStringParameter(request,"Book_id_c","");
	String Book_id_l = ServletRequestUtils.getStringParameter(request,"Book_id_l","");
	String Obookid = ServletRequestUtils.getStringParameter(request,"Obookid","");
%>
<script>
<!--
	window.focus();
//--> 
	function next_top(){
		form_t.target = "frm1";
		form_t.action = "3_compare.do";
		form_t.submit();
	}
	function next_top2(){
		form_t.target = "pop";
		form_t.Print_yn.value="Y";
		form_t.action = "3_compare.do";
		form_t.submit();
	}
	function MoveFocus()
	{
		if(event.keyCode == 13)
			findtext.focus();
	}
var n   = 0;
function search(str) {
 var txt, i, found;
	  if (str == "")
		return false;
		//txt = win.document.body.createTextRange();
		txt = main.document.body.createTextRange();//프레임 아이디로 교체
		for (i = 0; i <= n && (found = txt.findText(str)) != false; i++) {
		  txt.moveStart("character", 1);
		  txt.moveEnd("textedit");
	  }
		if (found) {
		  txt.moveStart("character", -1);
		  txt.findText(str);
		  txt.select();
		  txt.scrollIntoView();
		  n++;
		}
		else {
		  if (n > 0) {
			n = 0;
			search(str);
		  }
		  else
			alert("문자열을 찾을수 없습니다.");
		}
	  
	  return false;
}
function KeyEvent(str)
{
	if(event.keyCode==13){
		search(str);}
}
</script>
<script language="JavaScript">
function winMaximizer() {
if (document.layers) {
larg = screen.availWidth - 10;
altez = screen.availHeight - 20;
} else {
var larg = screen.availWidth;
var altez = screen.availHeight;
}
self.resizeTo(larg, altez);
self.moveTo(0, 0);
}
</script>


<style type="text/css"> 
/* 본문내용 */
	.gestonblack {
	 font-size: 9pt;
	 line-height: 160% ; 
	 color: #333333;
	 font-family: "굴림", "Arial";
	}
	.input2 {
	 font-family: "gulim";
	 font-size: 9pt;
	 color: #666666;
	}
</style>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>연결조문 비교보기</title>
<link href="${resourceUrl}/mnview/css/main.css" rel="stylesheet" type="text/css" media="screen">
<link href="${resourceUrl}/mnview/css/layout.css" rel="stylesheet" type="text/css" media="screen">
<link href="${resourceUrl}/mnview/css/poplayout.css" rel="stylesheet" type="text/css" media="screen">
<style type="text/css">
<!--
* {
	font-family:  "돋움", "굴림";
	color: #333;
	margin:0px;
	padding:0px;
}
-->
</style>
</head>
<body leftmargin="0" topmargin="0" onkeydown="MoveFocus()" onLoad="next_top();winMaximizer()">

<form name="form_t" method="post"  onSubmit="return false;">
<input type="hidden" name="Book_id_r" value="<%=Book_id_r %>">
<input type="hidden" name="Book_id_c" value="<%=Book_id_c %>">
<input type="hidden" name="Book_id_l" value="<%=Book_id_l %>">
<input type="hidden" name="obookid" value="<%=Obookid %>">
<input type="hidden" name="Print_yn">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="1px;">
<div id="topLinked">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" background="${resourceUrl}/mnview/img/regul/bg_popHeader.gif">
		<tr>
			<td><p class="popTitle">연결조문 비교보기</p></td>
			<td width="128" height="52"></td>
		</tr>
	</table>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background-color:#efefef; border-bottom:1px dotted #CCC; font-size:12px;" height="30" width="61%" valign="middle">&nbsp;&nbsp;&nbsp;<img src="${resourceUrl}/mnview/img/regul/dot01.gif" align="absmiddle">&nbsp;연결조문 비교보기는 법률/시행령/시행규칙 상호간 연결되는 조문을 나란히 배치한 비교보기입니다.</td>
			<td style="background-color:#efefef; border-bottom:1px dotted #CCC; font-size:12px;" width="39%" valign="middle" align="right"><span class="printAll" ><a href="javascript:next_top2();">인쇄하기</a></span>&nbsp;|&nbsp;<span class="title_chaSrc">문자열검색</span>&nbsp;&nbsp;:&nbsp;&nbsp;
				<input name="idata" type="text" style="ime-mode:active;" class="input2" size="22"  onkeypress="KeyEvent(idata.value);">
				&nbsp; <img src="${resourceUrl}/mnview/img/regul/btn_search.gif" border="0" align="absmiddle" alt="검색하기" style="padding-left:3px" id="findtext" onClick="search(idata.value)">&nbsp; </td>
		</tr>
	</table>
</div>		
		</td>
	</tr>
	<tr>
		<td  style="padding:3px 3px 3px 3px;">
<iframe id="main"  name="frm1" frameborder="0" width="100%" height="100%" scrolling="auto" src=""></iframe>
		</td>
	</tr>
	<tr>
		<td height="1px;">
<div id="popButtonPrint">
	<img style="cursor:hand;" onClick="window.self.close();" src="${resourceUrl}/mnview/img/regul/but-all-close.gif" width="57" height="21" alt="닫기">
</div>		
		</td>
	</tr>
</table>
</form>

</body>
</html>