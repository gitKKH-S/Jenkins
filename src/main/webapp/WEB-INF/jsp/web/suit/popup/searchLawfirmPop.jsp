<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String schText = request.getAttribute("schText")==null?"":request.getAttribute("schText").toString();
%>
<script type="text/javascript">
	var schText = "<%=schText%>";
	$(document).ready(function(){
		if (schText == "") {
			selectLawfirmList();
		}
		
		$("#schText").keydown(function(key) {
			if (key.keyCode == 13) {
				selectLawfirmList();
			}
		});
	});
	
	function selectLawfirmList(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectLawfirmPopList.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			error:setLawfirmList,
			success:setLawfirmList
		});
	}
	
	function setLawfirmList(data){
		$(".lawfirmInfo").remove();
		var html = "";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				html += "<tr class=\"lawfirmInfo\"><td>"+index+"</td><td id=\"selLawfirm\" onclick=\"goSelect('"+val.JDAF_CORP_MNG_NO+"', '"+val.JDAF_CORP_NM+"')\">"+val.JDAF_CORP_NM+"</td></tr>";
			});
		}
		$("#lawfirmList").append(html);
	}
	
	function goSelect(num, name){
		opener.document.getElementById("JDAF_CORP_MNG_NO").value = num;
		opener.document.getElementById("JDAF_CORP_NM").value = name;
		/* 
		if(name.indexOf("송무팀") > -1){
			opener.document.getElementById("retfee").value = "";
			opener.document.getElementById("confee").value = "";
			opener.document.getElementById("attfee").value = "";
			opener.document.getElementById("retfee").style.display = "none";
			opener.document.getElementById("confee").style.display = "none";
			opener.document.getElementById("attfee").style.display = "none";
		}else{
			opener.document.getElementById("retfee").style.display = "block";
			opener.document.getElementById("confee").style.display = "block";
			opener.document.getElementById("attfee").style.display = "block";
		}
		 */
		alert(name + "이 선택 되었습니다.");
		window.close();
	}
</script>
<style>
	.popW{min-width:100px;}
	table th{text-align:center;}
	#selLawfirm:hover{cursor:pointer; text-decoration:underline;}
</style>
<form name="frm" id="frm" method="post" action="">
	<strong class="popTT">
		법무법인 검색
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC" style="height:650px;">
		<div class="popSrchW">
			<input type="text" id="schText" name="schText" value="<%=schText%>" placeholder="법인명을 입력 해 주세요">
		</div>
		<div class="popA" style="height:550px;">
			<table class="pop_listTable" id="lawfirmList" style="max-height:550px; width:100%">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>번호</th>
					<th>법무법인명</th>
				</tr>
			</table>
		</div>
	</div>
</form>