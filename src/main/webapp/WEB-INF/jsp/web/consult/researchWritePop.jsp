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



function addQuestion() {
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/web/consult/addQuestion.do",
		data:$('#detailFrm').serializeArray(),
		dataType:"json",
		async:false,
		success:function(result){
		if(result.data.msg == 'ok'){
			alert("저장되었습니다.");
			window.close();
			
		}
	}	
});
	opener.goReLoad();
}

function deleteQuestion() {
	alert("삭제되었습니다.");
	window.close();
}
</script>

<form name="detailFrm" id="detailFrm" method="post" action="">
<input type="hidden" name="satisitemid" id="satisitemid" value="<%=satisitemid%>"/>

<strong class="popTT">
	질문추가
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
						<th>USEYN</<th>
						<th>WRITERCD</<th>

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
						<td><input type="text" id="item" name="item" value="" style="width: 100%;"></td>
						<td><select id="useyn" name="useyn"><option value="Y">Y</option><option value="N">N</option></select>
						<td><select id="writercd" name="writercd"><option value="U">사용자</option><option value="L">담당자</option></select>
					</tr>
				</table>
			</div>
			<hr class="margin20">
			<input type="button" class="sBtn type1" onclick="addQuestion()" value="저장">
		</div>
	</div>
</form>