<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String BND_RTRVL_MNG_NO = request.getAttribute("BND_RTRVL_MNG_NO")==null?"":request.getAttribute("BND_RTRVL_MNG_NO").toString();
	String BND_MNG_NO = request.getAttribute("BND_MNG_NO")==null?"":request.getAttribute("BND_MNG_NO").toString();
	String BONDBAL = request.getAttribute("BONDBAL")==null?"":request.getAttribute("BONDBAL").toString();
	String BND_AMT = request.getAttribute("BND_AMT")==null?"":request.getAttribute("BND_AMT").toString();
	String BND_DBT_SE = request.getAttribute("BND_DBT_SE")==null?"":request.getAttribute("BND_DBT_SE").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap recMap = request.getAttribute("recMap")==null?new HashMap():(HashMap)request.getAttribute("recMap");
	
	if("".equals(BONDBAL)){
		BONDBAL = BND_AMT;
	}
%>
<script>
	var BND_MNG_NO = "<%=BND_MNG_NO%>";
	var BND_RTRVL_MNG_NO = "<%=BND_RTRVL_MNG_NO%>";
	var BND_DBT_SE = "<%=BND_DBT_SE%>";
	var BONDBAL = "<%=BONDBAL%>";
	
	$(document).ready(function(){
		
	});
	
	// 입력 내용 insert
	function recEditSave(){
		var msg = "";
		if(BND_DBT_SE == "B"){
			msg = "회수";
		}else{
			msg = "지급";
		}
		
		if($("#GIVE_RTRVL_AMT").val() == ""){
			alert(msg+" 금액을 입력하세요");
			return;
		}
		if($("#GIVE_RTRVL_YMD").val() == ""){
			alert(msg+" 일자를 입력하세요");
			return;
		}
		
		var recovamt = uncomma($("#GIVE_RTRVL_AMT").val());
		if((BONDBAL - recovamt) < 0){
			alert(msg+" 금액이 채권 잔액보다 많습니다.\n"+msg+" 금액을 확인 해 주세요");
			return;
		}
		
		$("#GIVE_RTRVL_AMT").val(uncomma($("#GIVE_RTRVL_AMT").val()));
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertRecInfo.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				opener.reLoadPop();
				window.close();
			}
		});
	}
</script>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="BND_MNG_NO"       id="BND_MNG_NO"       value="<%=BND_MNG_NO%>" />
	<input type="hidden" name="BND_RTRVL_MNG_NO" id="BND_RTRVL_MNG_NO" value="<%=BND_RTRVL_MNG_NO%>" />
	<input type="hidden" name="BND_AMT"          id="BND_AMT"          value="<%=BND_AMT%>" />
	<input type="hidden" name="BONDBAL"          id="BONDBAL"          value="<%=BONDBAL%>" />
	<input type="hidden" name="WRTR_EMP_NM"         id="WRTR_EMP_NM"         value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"         id="WRTR_EMP_NO"         value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"         id="WRT_DEPT_NO"         value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"         id="WRT_DEPT_NM"         value="<%=WRT_DEPT_NM%>" />
	
	<strong class="popTT">
		<%if("B".equals(BND_DBT_SE)){ %>
		채권 회수금 관리
		<%}else{ %>
		채무 지급금 관리
		<%} %>
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC" style="height:60%">
		<div class="popA" style="height:100%">
			<table class="pop_infoTable write" style="height:100%">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<%if("B".equals(BND_DBT_SE)){ %>
					<th>회수금액</th>
					<%}else{ %>
					<th>지급금액</th>
					<%} %>
					<td>
						<input type="text" id="GIVE_RTRVL_AMT" name="GIVE_RTRVL_AMT" value="<%=recMap.get("GIVE_RTRVL_AMT")==null?"":recMap.get("GIVE_RTRVL_AMT").toString()%>" onkeyup="numFormat(this);" style="width:95%;">
					</td>
					<%if("B".equals(BND_DBT_SE)){ %>
					<th>회수일자</th>
					<%}else{ %>
					<th>지급일자</th>
					<%} %>
					<td><input type="text" id="GIVE_RTRVL_YMD" name="GIVE_RTRVL_YMD" value="<%=recMap.get("GIVE_RTRVL_YMD")==null?"":recMap.get("GIVE_RTRVL_YMD").toString()%>" class="datepick" style="width:80%;"></td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="recEditSave();">등록</a>
		</div>
	</div>
</form>
