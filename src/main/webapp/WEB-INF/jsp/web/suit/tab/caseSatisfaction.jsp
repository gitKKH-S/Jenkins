<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String LWS_MNG_NO = request.getParameter("LWS_MNG_NO")==null?"":request.getParameter("LWS_MNG_NO").toString();
	String SEL_INST_MNG_NO = request.getParameter("SEL_INST_MNG_NO")==null?"":request.getParameter("SEL_INST_MNG_NO").toString();
	if(SEL_INST_MNG_NO.equals("")){
		SEL_INST_MNG_NO = request.getParameter("INST_MNG_NO")==null?"":request.getParameter("INST_MNG_NO").toString();
	}
	
	String tabId = request.getParameter("tabId");
	String mergeyn = request.getParameter("mergeyn");
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO");
	String writercd = request.getParameter("writercd");
	String progcd = request.getParameter("progcd");
	String MGBN = request.getParameter("MGBN");
	String adminYn = request.getParameter("adminYn");
	
	String SPRVSN_DEPT_NO = request.getParameter("SPRVSN_DEPT_NO");
	System.out.println("progcd >>>>>>>>>>>> " + progcd);
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	//String nFlg = "Y";
	//String lFlg = "Y";
	
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script>
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";
	
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	var writercd = "<%=USERNO%>";
	
	function setGrid(){
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH%>/web/suit/selectSatisfactionList.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO
			},
			dataType:"json",
			async:false,
			success:function(result){
				console.log(result.result);
				var html = "";
				if (result.result.length > 0) {
					for(var i=0; i<result.result.length; i++){
						//if(result.result[i].DGSTFN_SRVY_TRGT_SE == "N"){
						//	// 수행부서 만족도 조사 완료시 버튼 삭제
						//	$("#nSatiBtn").remove();
						//}
						//if(result.result[i].DGSTFN_SRVY_TRGT_SE == "X"){
						//	// 송무팀 만족도 조사 완료시 버튼 삭제
						//	$("#lSatiBtn").remove();
						//}
						console.log(result.result.length);
						
						$("#nSatiBtn").remove();
						var DGSTFN_SRVY_CN = result.result[i].DGSTFN_SRVY_CN;
						if (DGSTFN_SRVY_CN == "기타의견") {
							html += "<tr>";
							html += "<td>기타의견</td>";	// 답변 구분
							html += "<td colspan='3'>"+result.result[i].DGSTFN_ETC_ANS_CN+"</td>";			// 만족도설문내용
							html += "<td>"+result.result[i].JDAF_CORP_NM+"</td>";			// 대상법인명
							html += "</tr>";
						} else {
							html += "<tr>";
							html += "<td>"+result.result[i].DGSTFN_SRVY_TRGT_SE+"</td>";	// 답변 구분
							html += "<td>"+result.result[i].DGSTFN_EVL_TYPE_NM+"</td>";		// 만족도평가유형
							html += "<td>"+result.result[i].DGSTFN_SRVY_CN+"</td>";			// 만족도설문내용
							html += "<td>"+result.result[i].DGSTFN_ANS_SCR+"점</td>";		// 점수
							html += "<td>"+result.result[i].JDAF_CORP_NM+"</td>";			// 대상법인명
							html += "</tr>";
						}
						
					}
					$("#satisInfo").append(html);
				}
			}
		});
	}
</script>

<script type="text/javascript">
	//등록페이지
	function goTabWrite(DGSTFN_ANS_MNG_NO){
		var cw=800;
		var ch=540;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseSatisWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"DGSTFN_ANS_MNG_NO", value:DGSTFN_ANS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"SRVY_SE", value:"SUIT"}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
</script>
<style>
	#nSatiBtn{font-weight:bold; font-size:20px;}
</style>
<form name="tabFrm" id="tabFrm" method="post" action="">
	<div class="innerB">
		<table class="infoTable list" id="satisInfo" style="width:100%">
			<colgroup>
				<col style="width: 10%;">
				<col style="width: 15%;">
				<col style="width: *;">
				<col style="width: 10%;">
				<col style="width: 15%;">
			</colgroup>
			<tr>
				<th>구분</th>
				<th>평가유형</th>
				<th>설문내용</th>
				<th>평가점수</th>
				<th>법무법인</th>
			</tr>
			<tr id="nSatiBtn">
				<td colspan="5">
				<%if(!GRPCD.equals("X") && "MAIN".equals(MGBN) &&
						(SPRVSN_DEPT_NO.equals(WRT_DEPT_NO) || "Y".equals(adminYn))) {%>
					<a href="#none" id="writeBtn" class="sBtn type1" onclick="goTabWrite('');">만족도 평가하기</a>
				<%}%>
				</td>
			</tr>
		</table>
	</div>
</form>