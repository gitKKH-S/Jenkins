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
	String MGBN = request.getParameter("MGBN");
	String adminYn = request.getParameter("adminYn");
	
	String SPRVSN_DEPT_NO = request.getParameter("SPRVSN_DEPT_NO");
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script type="text/javascript">
	var grpcd = "<%=GRPCD%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";
	
	function setGrid(){
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH%>/web/suit/selectMemoList.do",
			data:{"INST_MNG_NO":<%=SEL_INST_MNG_NO%>, "LWS_MNG_NO":<%=LWS_MNG_NO%>},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				for(var i=0; i<result.result.length; i++){
					var rlsYn = result.result[i].RLS_YN;
					var writer = result.result[i].WRTR_EMP_NO;
					if ((rlsYn == "N" && writer == "<%=WRTR_EMP_NO%>") || rlsYn == "" || rlsYn == "Y") {
						html += "<tr>";
						html += "<td>"+result.result[i].MEMO_CN+"</td>";
						html += "<td>"+result.result[i].WRTR_EMP_NM+"</td>";
						html += "<td>"+result.result[i].WRT_YMD+"</td>";
						html += "<td>";
						if(grpcd != "X"){
						html += "<a href=\"#none\" class=\"innerBtn center\" onclick=\"goTabUpdate('"+result.result[i].MEMO_MNG_NO+"', '"+result.result[i].MEMO_CN+"', '"+result.result[i].RLS_YN+"')\">수정</a>";
						html += "<a href=\"#none\" class=\"innerBtn center\" onclick=\"goTabDel("+result.result[i].MEMO_MNG_NO+")\">삭제</a>";
						}
						html += "</td>";
						html += "</tr>";
					} else {
						html += "<tr>";
						html += "<td colspan='4'>";
						html += '<span style="color:#999;">🔒 작성자만 확인할 수 있는 메모입니다.</span>';
						html += "</td>";
						html += "</tr>";
					}
				}
				$("#memoList").append(html);
			}
		});
	}
	
	function goTabUpdate(memoid, memo, rls_yn){
		$("#memoWriteDiv").css("display", "");
		$("#MEMO_CN").val(memo);
		$("#MEMO_MNG_NO").val(memoid);
		
		if (rls_yn == "N") {
			$("#RLS_YN").prop("checked", true);
		}
	}
	
	function goTabDel(MEMO_MNG_NO){
		if(confirm("메모를 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteMemo.do",
				data:{LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO, MEMO_MNG_NO:MEMO_MNG_NO},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					goReLoad();
				}
			});
		}
	}
	
	//등록페이지
	function goTabWrite(){
		$("#memoWriteDiv").css("display", "");
		$("#MEMO_CN").focus();
	}
	
	function goSave(){
		if($("#MEMO_CN").val() == ""){
			return alert("메모를 입력해주세요");
		}
		var memo = $('#memotxt').text().replace(/\n/g, '<br>');
		$('#MEMO_CN').text(memo);
		
		saveMemo();
	}
	
	function saveMemo(){
		var RLS_YN = "";
		if ($("#RLS_YN").is(":checked")) {
			RLS_YN = "N";
		} else {
			RLS_YN = "Y";
		}
			
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertMemo.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				MEMO_MNG_NO:$("#MEMO_MNG_NO").val(),
				MEMO_CN:$("#MEMO_CN").val(),
				RLS_YN : RLS_YN
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				$("#memoWriteDiv").css("display", "none");
				goReLoad();
			}
		});
	}
	
	function goCancel(){
		$("#MEMO_CN").text("");
		$("#memoWriteDiv").css("display", "none");
	}
</script>
<style>
	#MEMO_CN {
		width:90%; float:left;
	}


</style>
<form name="tabFrm" id="tabFrm" method="post" action="">
	<input type="hidden" name="WRTR_EMP_NM"  id="WRTR_EMP_NM"  value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"  id="WRTR_EMP_NO"  value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"  id="WRT_DEPT_NO"  value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"  id="WRT_DEPT_NM"  value="<%=WRT_DEPT_NM%>" />
	<div class="subBtnW side" style="margin-top:10px;">
		<div class="subBtnC right">
			<a href="#none" class="sBtn type1" onclick="goTabWrite()">등록</a>
		</div>
	</div>
	<hr class="margin10">
	<div class="innerB">
		<table class="infoTable list" id="memoList" style="width:100%">
			<colgroup>
				<col style="width:*;">
				<col style="width:10%;">
				<col style="width:10%;">
				<col style="width:10%;">
			</colgroup>
			<tr>
				<th>메모</th>
				<th>작성자</th>
				<th>작성일</th>
				<th></th>
			</tr>
			
		</table>
	</div>
	<div id="memoWriteDiv" style="display: none">
		<table class="infoTable list" style="width:100%">
			<tr>
				<td>
					<input type="hidden" name="MEMO_MNG_NO" id="MEMO_MNG_NO">
					<textarea rows="" cols="" id="MEMO_CN" name="MEMO_CN"></textarea>
					<input type="checkbox" name="RLS_YN" id="RLS_YN" value="N"> 비공개여부
				</td>
			</tr>
		</table>
		<hr class="margin10">
		<%if((SPRVSN_DEPT_NO.equals(WRT_DEPT_NO) || "Y".equals(adminYn) || GRPCD.indexOf("X") > -1) && "MAIN".equals(MGBN)){%>
		<a href="#" class="innerBtn center" onclick="goSave()">저장</a>
		<a href="#" class="innerBtn center" onclick="goCancel()">취소</a>
		<%}%>
	</div>
</form>

