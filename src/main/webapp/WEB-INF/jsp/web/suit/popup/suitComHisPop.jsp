<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	
%>
<script type="text/javascript">
	$(document).ready(function(){
		getComiUserList();
	});
	function getComiUserList(){
		$("#cInfoTr").remove();
		$(".comInfo").remove();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectEndComList.do",
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				if(result.result.length > 0){
					$.each(result.result, function(index, val){
						html += "<tr class=\"comInfo\" id=\"comiInfo"+val.ROWN+"\">";
						html += "<td>"+val.USER_NM+"</td>"; // user nm
						html += "<td>"+val.JIKNM+"</td>";
						html += "<td>"+val.DEPT_NAME+"</td>";
						html += "<td>"+val.WRITEDT+"</td>";
						html += "<td>"+val.ENDDT+"</td>";
						html += "<td>"+val.OUTYN+"</td>";
						html += "</tr>";
					});
				}else{
					html += "<tr class=\"cInfoTr\"><td colspan=\"6\">심의위원회 구성 이력이 없습니다.</td></tr>";
				}
				$("#comCnt").val(result.result.length+1);
				$("#comList").append(html);
			}
		});
	}
	
</script>
<style>
	.popW{height:100%}
	.subTTW{margin:0px 15px 0px 15px;}
	.popA{margin:10px 15px 0px 15px;}
</style>
<strong class="popTT">
	소송 심의위원회 이력
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form name="frm" id="frm" method="post" action="">
	<div>
		<div class="popA" style="height:505px; overflow-y:scroll;">
			<table class="pop_listTable" id="comList">
				<colgroup>
					<col style="width:*;">
					<col style="width:*;">
					<col style="width:35%;">
					<col style="width:*;">
					<col style="width:*;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>이름</th>
					<th>직책</th>
					<th>부서</th>
					<th>등록일</th>
					<th>해제일</th>
					<th>내/외</th>
				</tr>
			</table>
		</div>
	</div>
</form>