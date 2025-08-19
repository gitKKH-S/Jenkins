<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String cnt = request.getAttribute("CNT")==null?"":request.getAttribute("CNT").toString();
	String menu = request.getAttribute("menu")==null?"":request.getAttribute("menu").toString();
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
%>
<script type="text/javascript">
	var cnt = '<%=cnt%>';
	var menu = '<%=menu%>';
	$(document).ready(function(){
		getDept();
		var DEPTCD = '<%=DEPTCD%>';
		goSelDeptUser(DEPTCD);
		$("#srchTxt1").keyup(function(){
			var k = $(this).val();
			$("#deptlist > tbody > .deptinfo").hide();
			var temp = $("#deptlist > tbody > .deptinfo > #deptnm:nth-child(1n+1):contains('" + k + "')");
			$(temp).parent().show();
		});
		
		$("#srchTxt2").keyup(function(){
			var k = $(this).val();
			$("#emplist > tbody > .userinfo").hide();
			var temp = $("#emplist > tbody > .userinfo > #usernm:nth-child(3n+2):contains('" + k + "')");
			$(temp).parent().show();
		});
	});
	
	function getDept(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/selectDeptList.do",
			dataType:"json",
			async:false,
			success:selectDeptCallBack
		});
	}
	
	function selectDeptCallBack(data){
		console.log(data);
		var html = "";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				html += "<tr class=\"deptinfo\">";
				html += "<td class=\"selTd\" id=\"deptnm\" onclick=\"goSelDeptUser('"+val.SOSOK_CD+"',this)\">"+val.CODE_NAME_KR+"</td>";
				html += "</tr>";
			});
		}else{
			html += "<tr><td colspan=\"3\">검색 결과가 없습니다.</td></tr>";
		}
		$("#deptlist").append(html);
	}
	
	function goSelDeptUser(sosokcd,obj){
		$("#infoTr").remove();
		$(".userinfo").remove();
		$(".selTd").css("backgroundColor","white");
		if(obj){
			obj.style.backgroundColor ="#dfe9e9";
		}
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/selectUserList.do",
			data: {"sosokcd":sosokcd},
			dataType:"json",
			async:false,
			success:selectUserCallBack
		});
	}
	
	function selectUserCallBack(data){
		console.log(data.result);
		var html = "";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				console.log(val);
				html += "<tr class=\"userinfo\" onclick=\"selectUser('"+val.USER_ID+"','"+val.USER_NM+"','"+val.SOSOK_CD+"','"+val.SOSOK_NM+"')\">";
				html += "<td>"+val.RNUM+"</td>"; // 순번
				html += "<td class=\"selTd\" id=\"usernm\" >"+val.USER_NM+"</td>"; // user nm
				html += "<td id=\"usernm\">"+val.JIKCHK_NM+"</td>"; // JIKCHK NM
				html += "</tr>";
			});
		}else{
			html += "<tr class=\"userinfo\"><td colspan=\"3\">검색 결과가 없습니다.</td></tr>";
		}
		$("#emplist").append(html);
	}
	
	function selectUser(userid, usernm, sosokcd, sosoknm){
		if(menu == 'consult'){
			opener.document.getElementById("deptsenginsabun").value = userid;
			opener.document.getElementById("deptsenginname").value = usernm;
			//opener.document.getElementById("deptno").value = sosokcd;
			//opener.document.getElementById("deptnm").value = sosoknm;
		}else if(menu == 'consultans'){
			opener.document.getElementById("bubmusenginname").value = usernm;
			opener.document.getElementById("bubmusenginsabun").value = userid;
		}else if(menu == 'consultview'){
			opener.document.getElementById("bubname").value = usernm;
			opener.document.getElementById("bubsabun").value = userid;
		}else if(menu == 'criminal'){
			opener.document.getElementById("executeno").value = userid;
			opener.document.getElementById("executenm").value = usernm;
		}else{
			var empno = "empno"+cnt;
			var empnm = "empnm"+cnt;
			var deptno = "deptno"+cnt;
			var deptnm = "deptnm"+cnt;
			opener.document.getElementById(empno).value = userid;
			opener.document.getElementById(empnm).value = usernm;
			opener.document.getElementById(deptno).value = sosokcd;
			opener.document.getElementById(deptnm).value = sosoknm;
		}
		
		//alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
		alert(usernm+"이(가) 선택되었습니다.");
		window.close();
	}
</script>
<style>
	#srchTxt1{width:90%; height:30px; line-height:0px; margin-top:3px;}
	#srchTxt2{width:90%; height:30px; line-height:0px; margin-top:3px;}
	.popW{height:100%}
	#hidden{display:none;}
	.selTd{cursor:pointer;}
</style>
<strong class="popTT">
	관련부서 검색
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div style="height:74%">
	<div class="popC left">
		<div class="popSrchW">
			<input type="text" id="srchTxt1" placeholder="검색 할 부서명을 입력해주세요">
		</div>
		<div class="popA" style="height:295px;">
			<table class="pop_listTable" id="deptlist">
				<colgroup>
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>부서명</th>
				</tr>
			</table>
		</div>
	</div>
	<div class="popC right">
		<div class="popSrchW">
			<input type="text" id="srchTxt2" placeholder="검색 할 직원명을 입력해주세요">
		</div>
		<div class="popA" style="height:295px;">
			<table class="pop_listTable" id="emplist">
				<colgroup>
					<col style="width:14%;">
					<col style="width:40%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>순번</th>
					<th>이름</th>
					<th>직책명</th>
				</tr>
				<tr id="infoTr">
					<td colspan="3">부서명을 선택 해 주세요</td>
				</tr>
			</table>
		</div>
	</div>
</div>