<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018-12-30
  Time: 오후 5:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	String lawyernm = "["+WRT_DEPT_NM + "] " + WRTR_EMP_NM + "님";
%>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
<%-- <title><%=SYSTITLE %></title> --%>
<title>::::::::::::: 서울시청 고문변호사 법무지원 시스템 :::::::::::::</title>
<meta charset="utf-8">
<%-- 
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/common.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/layout.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/sub.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/table.css">
 --%>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/outcss/common.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/outcss/layout.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/outcss/sub.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/outcss/table.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/outcss/unknown.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/outcss/form_modern.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/web-master/src/fill/style.css">

<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/ext-all-debug.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/src/locale/ext-lang-ko.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/css/ext-all.css" />
<!-- jquery -->
<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/webjars/jquery-ui/1.11.4/jquery-ui.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/jquery-ui/1.11.4/jquery-ui.min.css">

<link rel="stylesheet" type="text/css" href="${resourceUrl}/mnview/css/extgrid.css" />
<style>
	.logoW{cursor:pointer;}
</style>
<script>
	Ext.override(Ext.grid.GridView, {
	    initTemplates : function(){
	        var ts = this.templates || {};
	        if(!ts.master){
	            ts.master = new Ext.Template(
	                '<div class="x-grid3" hidefocus="true">',
	                    '<div class="x-grid3-viewport">',
	                        '<div class="x-grid3-header"><div class="x-grid3-header-inner" style="{ostyle}"><div class="x-grid3-header-offset">{header}</div></div><div class="x-clear"></div></div>',
	                        '<div class="x-grid3-scroller"><div class="x-grid3-body" style="{bstyle}">{body}</div><a></a></div>',
	                    '</div>',
	                    '<div class="x-grid3-resize-marker">&nbsp;</div>',
	                    '<div class="x-grid3-resize-proxy">&nbsp;</div>',
	                '</div>'
	            );
	        }
	        if(!ts.header){
	            ts.header = new Ext.Template(
	                '<table border="0" cellspacing="0" cellpadding="0" style="{tstyle}">',
	                '<thead><tr class="x-grid3-hd-row">{cells}</tr></thead>',
	                '</table>'
	            );
	        }
	        if(!ts.hcell){
	            ts.hcell = new Ext.Template(
	                '<td class="x-grid3-hd x-grid3-cell x-grid3-td-{id} {css}" style="{style}"><div {tooltip} {attr} class="x-grid3-hd-inner x-grid3-hd-{id}" unselectable="on" style="{istyle}">', this.grid.enableHdMenu ? '<a class="x-grid3-hd-btn" href="#"></a>' : '',
	                '{value}<img class="x-grid3-sort-icon" src="', Ext.BLANK_IMAGE_URL, '" />',
	                '</div></td>'
	            );
	        }
	        if(!ts.body){
	            ts.body = new Ext.Template('{rows}');
	        }
	        if(!ts.row){
	            ts.row = new Ext.Template(
	                '<div class="x-grid3-row {alt}" style="{tstyle}"><table class="x-grid3-row-table" border="0" cellspacing="0" cellpadding="0" style="{tstyle}">',
	                '<tbody><tr>{cells}</tr>',
	                (this.enableRowBody ? '<tr class="x-grid3-row-body-tr" style="{bodyStyle}"><td colspan="{cols}" class="x-grid3-body-cell" tabIndex="0" hidefocus="on"><div class="x-grid3-row-body">{body}</div></td></tr>' : ''),
	                '</tbody></table></div>'
	            );
	        }
	        if(!ts.cell){
	            ts.cell = new Ext.Template(
	                '<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} {css}" style="{style}" tabIndex="0" {cellAttr}>',
	                '<div class="x-grid3-cell-inner x-grid3-col-{id}" unselectable="on" {attr}>{value}</div>',
	                '</td>'
	            );
	        }
	        for(var k in ts){
	            var t = ts[k];
	            if(t && typeof t.compile == 'function' && !t.compiled){
	                t.disableFormats = true;
	                t.compile();
	            }
	        }
	        this.templates = ts;
	        this.colRe = new RegExp("x-grid3-td-([^\\s]+)", "");
	    }
	});
	
	$(document).ready(function(){
		var inHei = window.innerHeight-20;
		document.body.style.height = inHei;
		$(window).resize(function() {
			inHei = window.innerHeight-20;
			document.body.style.height = inHei;
		});
		

		$.ajaxSetup({
			error : function(xhr, status, error) {
				console.log("에러 발생", xhr.status, xhr.responseText);
				if (xhr.status === 403) {
					const msg = JSON.parse(xhr.responseText);
					if(msg.errorCode=='PRIVACY_DETECTED'){
						alert(msg.message);
						return;
					}
					
				}
			}
		});		
		

		$(".datepick").datepicker({ 
			showOn:"both", 
			buttonImage:"${pageContext.request.contextPath}/resources/seoul/images/btn_calendar.png",
			dateFormat:'yy-mm-dd',
			buttonImageOnly:false,
			changeMonth:true,
			changeYear:true,
			nextText:'다음 달',
			prevText:'이전 달',
			yearRange:'c-100:c+10',
			showMonthAfterYear:true, 
			dayNamesMin:['일','월','화','수','목','금','토'],
			monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
		});
		
		$(".ui-datepicker-trigger").css({"vertical-align":"middle","margin-left":"1px"});
		$(".ui-datepicker-trigger").mouseover(function(){
			$(this).css('cursor','pointer');
		});
		jQuery.datepicker.setDefaults(jQuery.datepicker.regional['ko']);
		
		$(".logoW").click(function(){
			location.href="${pageContext.request.contextPath}/out/outMain.do";
		});
	});
	
	function comma(str) {
		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
	function uncomma(str) {
		str = String(str);
		return str.replace(/[^\d]+/g, '');
	}
	
	function numFormat(obj){
		obj.value = comma(uncomma(obj.value));
	}
	
	var openWin
	function popOpen(pname,url,wth,hht){
		var cw=wth;
		var ch=hht;
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		var property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=no,status=no,toolbar=no,location=no";
		openWin = window.open(url, pname, property);
		window.openWin.focus();
	}
</script>
</head>
<div class="topW">
	<div class="topC">
		<div class="logoW" style="padding-top:10px; padding-left:20px;">
			<h1 class="outlogo">서울특별시</h1>
		</div>
		<div class="srchW" style="border-radius:0px; height:60px;">
			<div class="topBtnW" style="padding-top:10px; padding-right:20px;">
				<div style="color: white; display: inline-block; font-size: 16px; margin-top: 18px; margin-right: 10px; ">
					<%=lawyernm%>
				</div>
				<a href="${pageContext.request.contextPath}/out/outConsultList.do" class="topBtn admin"><i class="fas fa-user-cog"></i>자문</a>
				<a href="${pageContext.request.contextPath}/out/outSuitList.do"    class="topBtn admin"><i class="fas fa-bookmark"></i>소송</a>
				<a href="${pageContext.request.contextPath}/out/outAgreeList.do"   class="topBtn admin"><i class="fas fa-bookmark"></i>협약</a>
				<a href="${pageContext.request.contextPath}/out/outLawyerInfo.do"  class="topBtn admin"><i class="fas fa-bookmark"></i>마이페이지</a>
			</div>
		</div>
	</div>
</div>
<tiles:insertAttribute name="content"/>