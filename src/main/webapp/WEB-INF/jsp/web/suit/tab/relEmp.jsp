<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String LWS_MNG_NO = request.getParameter("LWS_MNG_NO")==null?"":request.getParameter("LWS_MNG_NO").toString();
	String SEL_INST_MNG_NO = request.getParameter("SEL_INST_MNG_NO")==null?"":request.getParameter("SEL_INST_MNG_NO").toString();
	if(SEL_INST_MNG_NO.equals("")){
		SEL_INST_MNG_NO = request.getParameter("INST_MNG_NO")==null?"":request.getParameter("INST_MNG_NO").toString();
	}
	
	String tabId = request.getParameter("tabId");
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO");
	String MGBN = request.getParameter("MGBN");
	String adminYn = request.getParameter("adminYn");
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script>
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	var WRTR_EMP_NO = "<%=WRTR_EMP_NO%>";
	var empcnt = 0;
	var grpcd = "<%=GRPCD%>";
	var gridStore;
	var schLawyer;
	
	function setGrid(){
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH%>/web/suit/selectRelEmpList.do",
			data:{LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				$.each(result.result, function(index, entry){
					if (entry.FLFMT_YN == "Y") {
						html += "<tr>";
						html += "<td>"+entry.LWS_FLFMT_DEPT_NM+"</td>";
						html += "<td class=\"selEmp\" onclick=\"goTabView('"+entry.LWS_FLFMT_MNG_NO+"');\">"+entry.LWS_FLFMT_EMP_NM+"</td>";
						html += "<td>"+entry.FLFMT_BGNG+"</td>";
						html += "<td>";
						html += "<a href=\"#none\" class=\"innerBtn center\" onclick=\"goTabWrite('"+entry.LWS_FLFMT_MNG_NO+"')\">수정</a>";
						html += "<a href=\"#none\" class=\"innerBtn center\" onclick=\"empSetEnd('"+entry.LWS_FLFMT_MNG_NO+"','"+entry.LWS_FLFMT_EMP_NO+"', '"+entry.LWS_FLFMT_EMP_NM+"')\">수행종료</a>";
						html += "</td>";
						html += "</tr>";
					}
				});
				$("#relList").append(html);
			}
		});
	}
</script>
<script type="text/javascript">
	function goTabView(LWS_FLFMT_MNG_NO){
		var cw=720;
		var ch=295;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","relViewPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "relViewPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/relEmpInfoPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_FLFMT_MNG_NO", value:LWS_FLFMT_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	//등록페이지
	function goTabWrite(LWS_FLFMT_MNG_NO){
		var cw=650;
		var ch=520;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","relWritePop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "relWritePop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/relEmpWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_FLFMT_MNG_NO", value:LWS_FLFMT_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goRelEmpHis(){
		var cw=650;
		var ch=420;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","relHisPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "relHisPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/relEmpHisPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function empSetEnd(LWS_FLFMT_MNG_NO, LWS_FLFMT_EMP_NO, LWS_FLFMT_EMP_NM){
		if(confirm(LWS_FLFMT_EMP_NM+" 직원의 소송 수행을 종료하시겠습니까?")) {
			$.ajax({
				url: "<%=CONTEXTPATH%>/web/suit/insertRelEmpInfo.do",
				data: {
					gbn:"list",
					LWS_MNG_NO:LWS_MNG_NO,
					INST_MNG_NO:INST_MNG_NO,
					LWS_FLFMT_MNG_NO:LWS_FLFMT_MNG_NO,
					LWS_FLFMT_EMP_NO:LWS_FLFMT_EMP_NO,
					FLFMT_YN:"N"
				},
				dataType: "json",
				async: false,
				type:"POST",
				error: function(){
					alert("처리중 오류가 발생하였습니다.")
				},
				success: function(result){
					alert(result.msg);
					goReLoad();
				}
			});
		}
	}
</script>
<style>
	.selEmp:hover{background-color:#ececf1; cursor:pointer;}
	.undeEmp{text-decoration:line-through;}
</style>
<form name="tabFrm" id="tabFrm" method="post" action="" onsubmit="return false;">
	<input type="hidden" name="selsuit" id="selsuit" value="<%=LWS_MNG_NO%>" />
	<input type="hidden" name="selcase" id="selcase" value="<%=SEL_INST_MNG_NO%>" />
<%
	if(!GRPCD.equals("X")){
%>
	<div class="subBtnW side" style="margin-top:10px;">
		<div class="subBtnC right">
			<%if("Y".equals(adminYn) && "MAIN".equals(MGBN)) {%>
			<a href="#none" class="sBtn type2" onclick="goRelEmpHis();">종료소송수행자</a>
			<a href="#none" class="sBtn type1" onclick="goTabWrite('');">등록</a>
			<%}%>
		</div>
	</div>
<%
	}
%>
	<div class="innerB">
		<!-- <div id="tabGrid"></div> -->
		<table class="infoTable list" style="width:100%" id="relList">
			<colgroup>
				<col style="width:30%;">
				<col style="width:*;">
				<col style="width:*;">
				<col style="width:*;">
			</colgroup>
			<tr>
				<th>부서명</th>
				<th>수행자명</th>
				<th>수행 시작일</th>
				<th></th>
			</tr>
		</table>
	</div>
</form>
