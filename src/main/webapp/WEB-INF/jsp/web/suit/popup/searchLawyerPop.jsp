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
			getLawyerList();
		}
		
		$("#schText").keydown(function(key) {
			if (key.keyCode == 13) {
				getLawyerList();
			}
		});
	});
	
	function getLawyerList(){
		$(".lawyerInfo").remove();
		
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH%>/web/suit/selectLawyerPopList.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				$.each(result.result, function(index, val){
					html += "<tr class=\"lawyerInfo\" onclick=\"selLawyer('"+val.LWYR_MNG_NO+"', '"+val.LWYR_NM+"', '"+val.JDAF_CORP_MNG_NO+"', '"+val.JDAF_CORP_NM+"')\">";
					html += "<td class=\"selLawyer\">";
					html += val.LWYR_NM;
					html += "</td>";
					html += "<td>";
					if(val.JDAF_CORP_NM == "undefined"){
						html += "";
					}else{
						html += val.JDAF_CORP_NM;
					}
					html += "</td>";
					html += "</tr>";
				});
				$("#lawyerList").append(html);
			}
		});
	}
	
	function selLawyer(LWYR_MNG_NO, LWYR_NM, JDAF_CORP_MNG_NO, JDAF_CORP_NM){
		opener.document.getElementById("JDAF_CORP_MNG_NO").value = JDAF_CORP_MNG_NO;
		opener.document.getElementById("JDAF_CORP_NM").value = JDAF_CORP_NM;
		opener.document.getElementById("LWYR_MNG_NO").value = LWYR_MNG_NO;
		opener.document.getElementById("LWYR_NM").value = LWYR_NM;
		alert(LWYR_NM + "이 선택 되었습니다.");
		window.close();
	}
</script>
<style>
	.popC{height:650px;}
	.popA{height:530px;}
	.popW{min-width:100px;}
	table th{text-align:center;}
	.selLawyer:hover{cursor:pointer; text-decoration:underline;}
</style>
<form name="frm" id="frm" method="post" action="">
	<strong class="popTT">
		법무법인 검색
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popSrchW">
			<input type="text" id="schText" name="schText" placeholder="변호사명을 입력 해 주세요">
		</div>
		<div class="popA">
			<table class="pop_listTable" id="lawyerList">
				<colgroup>
					<col style="width:*;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>변호사명</th>
					<th>소속</th>
				</tr>
			</table>
		</div>
	</div>
</form>