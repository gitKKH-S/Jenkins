<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@	page import="com.mten.util.*"%>
<%
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	String cnt = request.getAttribute("cnt")==null?"":request.getAttribute("cnt").toString();
%>
<style>
	#hidden{display:none;}
	th{text-align:center;}
	#suitnm:hover{cursor:pointer; text-decoration:underline;}
</style>
<script type="text/javascript">
	var gbn = "<%=gbn%>";
	var cnt = "<%=cnt%>";
	var suitid = "";
	var maxcasecd = "";
	document.domain = "<%=MakeHan.File_url("domain")%>";
	
	$(document).ready(function(){
		
		// 병합 할 사건 조회 할 때
		if(gbn == "merge"){
			suitid = opener.document.getElementById("suitid").value;
			maxcasecd = opener.document.getElementById("maxcasecd").value;
		}
		
		getCaseList();
		
		$("#schTxt").keyup(function(){
			var k = $(this).val();
			$("#caseList > tbody > .caseinfo").hide();
			var temp = $("#caseList > tbody > .caseinfo > #suitnm:nth-child(6n+4):contains('" + k + "')");
			$(temp).parent().show();
		});
	});
	
	function getCaseList(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectMerCaseList.do",
			data: {"suitid": suitid, "maxcasecd":maxcasecd},
			dataType:"json",
			async:false,
			success:setCaseList
		});
	}
	
	function setCaseList(data){
		var html = "";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				var suitid = data.result[index].SUITID;
				var caseid = data.result[index].CASEID;
				var casenum = data.result[index].CASENUM;
				var suitnm = data.result[index].SUITNM;
				var suitgbn = data.result[index].SUITGBN;
				var casecdnm = data.result[index].CASECDNM;
				var empnm = data.result[index].EMPNM;
				var progress = data.result[index].PROGRESSNM;
				
				html += "<tr class=\"caseinfo\">"
				html += "<td id=\"hidden\">"+suitid+"</td>";
				html += "<td id=\"hidden\">"+caseid+"</td>";
				html += "<td>"+casenum+"</td>";
				html += "<td id=\"suitnm\" onclick=\"goSelect('"+suitid+"','"+caseid+"','"+casenum+"','"+suitnm+"')\">"+suitnm+"</td>";
				html += "<td>"+suitgbn+"</td>";
				html += "<td>"+casecdnm+"</td>";
				html += "<td>"+progress+"</td>";
				html += "<td>"+isEmpty(empnm)+"</td>";
				html += "</tr>"
			});
		}
		$("#caseList").append(html);
	}
	
	function goSelect(suitid, caseid, casenum, suitnm){
		if(gbn == "merge"){
			var index = opener.document.getElementById("meridx").value;
			for(var i=0; i<index; i++){
				if(opener.document.getElementById("idmergecase"+i).value == caseid){
					return alert("이미 선택 된 사건입니다.");
				}
			}
			opener.document.getElementById("mergecase"+index).value = "("+casenum+")"+suitnm;
			opener.document.getElementById("idmergecase"+index).value = caseid;
		}else if(gbn == "bond"){
			opener.document.getElementById("suitnm").value = suitnm;
			opener.document.getElementById("suitid").value = suitid;
			opener.document.getElementById("caseid").value = caseid;
			opener.document.getElementById("casenum").value = casenum;
		}else if(gbn == "review"){
			
			opener.document.getElementById("suitnm"+cnt).value = suitnm;
			opener.document.getElementById("suitid"+cnt).value = suitid;
			opener.document.getElementById("caseid"+cnt).value = caseid;
			opener.document.getElementById("casenum"+cnt).value = casenum;
		}else{
			opener.document.getElementById("suitnm").value = suitnm;
			opener.document.getElementById("suitid").value = suitid;
			opener.document.getElementById("caseid").value = caseid;
		}
		alert(suitnm + "이(가) 선택되었습니다.");
		window.close();
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="cnt" id="cnt" value="0"/>
	<input type="hidden" name="suitid" id="suitid" value=""/>
	<input type="hidden" name="caseid" id="caseid" value=""/>
	
	<strong class="popTT">
		사건 검색
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC" style="height:450px;">
		<div class="popSrchW">
			<input type="text" id="schTxt" placeholder="검색 할 사건명을 입력하세요">
		</div>
		<div class="popA" style="height:350px;">
			<table class="pop_listTable" id="caseList" >
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:5%;">
					<col style="width:10%;">
					<col style="width:10%;">
					<col style="width:10%;">
				</colgroup>
				<tr>
					<th>사건번호</th>
					<th>사건명</th>
					<th>구분</th>
					<th>심급</th>
					<th>담당자</th>
					<th>진행상태</th>
				</tr>
			</table>
		</div>
	</div>
</form>