<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@	page import="com.mten.util.*"%>
<script type="text/javascript">
	document.domain = "<%=MakeHan.File_url("domain")%>";
	
	$(document).ready(function(){
		getEmpUserList();
		
		$("#schTxt").keyup(function(){
			var k = $(this).val();
			$("#empList > tbody > .empInfo").hide();
			var temp = $("#empList > tbody > .empInfo > td:nth-child(4n+2):contains('" + k + "')");
			$(temp).parent().show();
		});
	});
	
	function getEmpUserList(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectEmpUserList.do",
			dataType:"json",
			async:false,
			success:setEmpUserList
		});
	}
	
	function setEmpUserList(data){
		var html = "";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				console.log(val);
				html += "<tr class=\"empInfo\">";
				html += "<td><input type=\"radio\" name=\"chk\" id=\"chk"+index+"\" onclick=\"getUserInfo('"+val.USERNO+"', '"+val.USERNAME+"')\" /></td>";
				html += "<td>"+val.USERNAME+"</td>";
				/* 
				html += "<td>"+val.INGCNT+"</td>";
				html += "<td>"+val.ENDCNT+"</td>";
				 */
				html += "</tr>";
			});
		}
		$("#empList").append(html);
		
	}
	
	function setEmp(){
		var emp = $("#empnm").val();
		if(emp == "undefined" || emp == ""){
			return alert("선정 할 담당자를 선택 해 주세요");
		}else{
			console.log()
			opener.document.getElementById("bondempnm").value = $("#empnm").val();
			opener.document.getElementById("bondempno").value = $("#empno").val();
			
			window.close();
		}
	}
	
	function getUserInfo(userno, usernm){
		$("#empno").val(userno);
		$("#empnm").val(usernm);
	}
</script>
<style>
	.popW{height:100%}
</style>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="empno" id="empno" value=""/>
	<input type="hidden" name="empnm" id="empnm" value=""/>
	<strong class="popTT">
		채권 담당자 관리
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popSrchW">
			<input type="text" id="schTxt" placeholder="검색 할 직원 이름을 입력하세요">
		</div>
		<div class="popA" style="height:195px; overflow-y:scroll;">
			<table class="pop_listTable" id="empList" >
				<colgroup>
					<col style="width:15%;">
					<col style="width:*%;">
					<!-- +
					<col style="width:20%;">
					<col style="width:20%;">
					 -->
				</colgroup>
				<tr>
					<th>선택</th>
					<th>이름</th>
					<!-- 
					<th>진행건수</th>
					<th>완료건수</th>
					 -->
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subTTW">
			<div class="subTTC right">
				<a href="#none" class="sBtn type1" onclick="setEmp();">담당자 선정</a>
			</div>
		</div>
	</div>
</form>