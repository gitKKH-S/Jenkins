<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.mten.util.*"%>
<%
	String catid = request.getParameter("catid")==null?"0":request.getParameter("catid");
	String startdt = request.getParameter("startdt")==null?MakeHan.get_data():request.getParameter("startdt");
	if(catid.equals("")){
		catid = "0";
	}
	if(startdt.equals("")){
		startdt = MakeHan.get_data();
	}
	System.out.println("startdt=====>"+startdt);
%>

<script>
var userid = suserid;
var paracatid = "<%=catid%>";

</script>
<script src="${pageContext.request.contextPath}/webjars/jquery-ui/1.11.4/jquery-ui.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/jquery-ui/1.11.4/jquery-ui.min.css">
<script language=javascript src="${resourceUrl}/appjs/cdmake/map/corelib_util_JException.js"></script>
<script language=javascript src="${resourceUrl}/appjs/cdmake/map/corelib_util_JMap.js"></script>
<script type="text/javascript" src="${resourceUrl}/appjs/cdmake/two-trees.js"></script>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/appjs/cdmake/examples.css" />
<link rel="stylesheet" type="text/css" href="${resourceUrl}/css/bylaw/topMenu.css" />
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<style type="text/css">
    #tree, #tree2 {
    	float:left;
    	margin:10px;
    	border:1px solid #c3daf9;
    	overflow:auto;
    }
    .folder .x-tree-node-icon{
		background:transparent url(${resourceUrl}/images/folder.gif);
	}
	.x-tree-node-expanded .x-tree-node-icon{${resourceUrl}/images/folder-open.gif);
	}
	.admin .x-tree-node-icon{background-image:url(${resourceUrl}/images/common/tree/tree-node-admin.gif) !important}
	.btnStyle2.midBlue{
		background:#1447a6;
	    margin-left: 5px;
	}
	.btnStyle2{
		display:inline-block;
		height:25px;
		line-height:28px;
		padding:0 12px;
		color:#fff;
		border-radius:5px;
		vertical-align:middle;
		cursor:pointer;
	}
</style>
<script>
$(document).ready(function() {
	$.datepicker.regional['ko'] = { //기본 datePicker 셋팅
		dateFormat:'yy-mm-dd',
	    prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    yearSuffix: '년',
	  	changeMonth: true,
	  	changeYear: true
	};
	$.datepicker.setDefaults($.datepicker.regional['ko']);
	$("#startdt").datepicker(); //페이지 처음 올라올때 엘리먼트에 datePicker 붙임
});
function reloadTree(){
	var frm = document.reTree;
	frm.startdt.value = $("#startdt").val();
	frm.submit();
}
</script>
<form name="reTree" action="mtree.do" method="post">
	<input type="hidden" name="catid" value="<%=catid%>">
	<input type="hidden" name="startdt" value="<%=startdt%>">
</form>
<div id="tree"></div>
<div id="tree2"></div>
<div id="buttonHolder" align="center">
	<input id="startdt" type="text" value="<%=startdt%>">
	<a class="btnStyle2 midBlue"  onclick="reloadTree();">기준일 검색</a>
	<a class="btnStyle2 midBlue"  onclick="goWrite();">선택저장</a>
</div>
