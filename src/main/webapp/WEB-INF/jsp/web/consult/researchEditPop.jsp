<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String satisitemid = request.getAttribute("satisitemid")==null?"":request.getAttribute("satisitemid").toString();
	String item = request.getAttribute("item")==null?"":request.getAttribute("item").toString();
	String useyn = request.getAttribute("useyn")==null?"":request.getAttribute("useyn").toString();
	String writercd = request.getAttribute("writercd")==null?"":request.getAttribute("writercd").toString();


%>
<script>
$(document).ready(function(){
	
});

function editQuestion() {
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/web/consult/addQuestion.do",
		data:$('#detailFrm').serializeArray(),
		dataType:"json",
		async:false,
		success:function(result){
		if(result.data.msg == 'ok'){
			alert("수정되었습니다.");
			window.close();
		}
	}	
});
	
	opener.goReLoad();
}

function deleteQuestion() {
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/web/consult/delQuestion.do",
		data:$('#detailFrm').serializeArray(),
		dataType:"json",
		async:false,
		success:function(result){
			alert("삭제되었습니다.");
			window.close();
	}	
});
	
	opener.goReLoad();
}
</script>

<form name="detailFrm" id="detailFrm" method="post" action="">
<input type="hidden" name="satisitemid" id="satisitemid" value="<%=satisitemid%>"/>

<strong class="popTT">
	질문수정
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
	<div class="popW">
		<div class="popC">
			<div class="popA">
				<table class="pop_infoTable write">
					<colgroup>
						<col style="width:70%;">
						<col style="width:10%;">
						<col style="width:10%;">
						<col style="width:*;">
					</colgroup>
					<tr>
						<th>질문</<th>
						<!-- <th>사용여부</<th> 
						<th>-</<th>
						<th></<th> -->
					</tr>
				</table>
			
				<table class="pop_infoTable write">
					<colgroup>
						<col style="width:70%;">
						<col style="width:10%;">
						<col style="width:10%;">
						<col style="width:*;">
					</colgroup>
					<tr>
						<td><input type="text" id="item" name="item" value="<%=item%>" style="width: 100%;"></td>
						<!-- 
						<td><input type="text" value="<%=useyn%>" style="width: 100%;"></td>
						<td><select><option><%=useyn%></option><option value="Y">Y</option><option value="N">N</option></select></td>
						 
						<td><input type="text" value="<%=writercd%>" style="width: 100%;"></td>
						<td><input type="text" value="" style="width: 100%;"></td>-->
					</tr>
				</table>
			</div>
			<hr class="margin20">
			<input type="button" class="sBtn type1" onclick="editQuestion()" value="저장">
			<input type="button" class="sBtn type2" onclick="deleteQuestion()" value="삭제">
		</div>
	</div>
</form>