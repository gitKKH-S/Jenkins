<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO");
%>
<script type="text/javascript">
	$(document).ready(function(){
		getRelEmpHistory();
	});
	function getRelEmpHistory(){
		
		$(".rInfoTr").remove();
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH%>/web/suit/selectRelEmpList.do",
			data:{
				"INST_MNG_NO":<%=INST_MNG_NO%>,
				"LWS_MNG_NO":<%=LWS_MNG_NO%>
			},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				$.each(result.result, function(index, entry){
					console.log(entry);
					
					if(entry.FLFMT_YN == "N"){//RELWRT_DEPT_NO
						html += "<tr class=\"rInfoTr\">";
						html += "<td>"+entry.LWS_FLFMT_DEPT_NM+"</td>";
						html += "<td>"+entry.LWS_FLFMT_EMP_NM+"</td>";
						html += "<td>"+entry.FLFMT_BGNG+"</td>";
						if(entry.FLFMT_END == undefined){
							html += "<td>0000-00-00</td>";
						}else{
							html += "<td>"+entry.FLFMT_END+"</td>";
						}
						html += "<td><a href=\"#none\" class=\"innerBtn\" onclick=\"delHistory('"+<%=LWS_MNG_NO%>+"', '"+<%=INST_MNG_NO%>+"', '"+entry.LWS_FLFMT_MNG_NO+"', '"+entry.LWS_FLFMT_EMP_NO+"');\">이력삭제</a></td>";
						html += "</tr>";
					}
				});
				if(html == ""){
					html += "<tr class=\"rInfoTr\"><td colspan=\"5\">소송수행자 종료 이력이 없습니다.</td></tr>";
				}
				$("#relList").append(html);
			}
		});
	}
	
	
	function delHistory(LWS_MNG_NO, INST_MNG_NO, LWS_FLFMT_MNG_NO, LWS_FLFMT_EMP_NO){
		if(confirm("해당 수행 이력 데이터를 삭제하시겠습니까?")) {
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteRelEmpInfo.do",
				data:{
					LWS_FLFMT_MNG_NO:LWS_FLFMT_MNG_NO,
					LWS_FLFMT_EMP_NO:LWS_FLFMT_EMP_NO,
					LWS_MNG_NO:LWS_MNG_NO,
					INST_MNG_NO:INST_MNG_NO
				},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					getRelEmpHistory();
				}
			});
		}
	}
</script>
<style>
	.popW{height:100%}
	.subTTW{margin:0px 15px 0px 15px;}
	.popA{margin:10px 15px 0px 15px;}
	th {text-align: center;}
</style>
<strong class="popTT">
	소송 수행자 이력
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form name="frm" id="frm" method="post" action="">
	<div>
		<div class="popA" style="height:350px; overflow-y:scroll;">
			<table class="pop_listTable" id="relList">
				<colgroup>
					<col style="width:*;">
					<col style="width:*;">
					<col style="width:*;">
					<col style="width:*;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>부서명</th>
					<th>이름</th>
					<th>수행시작일</th>
					<th>수행종료일</th>
					<th></th>
				</tr>
			</table>
		</div>
	</div>
</form>