<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM   = request.getAttribute("WRTR_EMP_NM")==null?"":(String)request.getAttribute("WRTR_EMP_NM");
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":(String)request.getAttribute("WRTR_EMP_NO");
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":(String)request.getAttribute("WRT_DEPT_NM");
	String WRT_DEPT_NO   = request.getAttribute("WRT_DEPT_NO")==null?"":(String)request.getAttribute("WRT_DEPT_NO");
%>
<style>
	#hidden{display:none;}
	th{text-align:center;}
	#suitnm:hover{cursor:pointer; text-decoration:underline;}
</style>
<script type="text/javascript">
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
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
				html += "<tr class=\"empInfo\">";
				html += "<td><input type=\"checkbox\" name=\"chkUser[]\" id=\"chk"+index+"\" value=\""+val.EMP_NO+"\"/></td>";
				html += "<td>"+val.MNGR_EMP_NM+"</td>";
				html += "<td>"+val.INGCNT+"</td>";
				html += "<td>"+val.ENDCNT+"</td>";
				html += "</tr>";
			});
		}
		$("#empList").append(html);
		
		getEmpList(caseid);
	}
	
	function getEmpList(caseid){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectEmpList.do",
			data:{INST_MNG_NO:INST_MNG_NO},
			dataType:"json",
			async:false,
			success:setEmpList
		});
	}
	
	function setEmpList(data){
		$.each(data.result, function(index, val){
			var chk = document.getElementsByName("chkUser[]");
			var leng = chk.length;
			for(var i=0; i < leng; i++ ){
				if(chk[i].value == val.EMPNO){
					chk[i].checked = true;
				}
			}
		});
	}
	
	function setEmp(){
		
		var chk = document.getElementsByName("chkUser[]");
		var leng = chk.length;
		var sum = 0;
		for(var i=0; i < leng; i++ ){
			if(chk[i].checked == true){
				sum += 1;
			}
		}
		
		if(sum == 0){
			return alert("지정 할 담당자를 체크하세요.");
		}else{
			selEmpSave();
		}
	}
	
	function getUserInfo(userno, usernm, WRT_DEPT_NO, deptnm){
		$("#empno").val(userno);
		$("#empnm").val(usernm);
		$("#WRT_DEPT_NO").val(WRT_DEPT_NO);
		$("#deptnm").val(deptnm);
	}
	
	function selEmpSave(){
		// 담당자 선정 시 기존 담당자의 사용여부는 N으로 변경
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/chgEmpInfoSave.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				opener.goReLoad();
				window.close();
			}
		});
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>"/>
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>"/>
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>"/>
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>"/>
	<input type="hidden" name="LWS_MNG_NO"    id="LWS_MNG_NO"   value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO"   id="INST_MNG_NO"   value="<%=INST_MNG_NO%>"/>
	<strong class="popTT">
		담당자 선정
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popSrchW">
			<input type="text" id="schTxt" placeholder="검색 할 직원 이름을 입력하세요">
		</div>
		<table class="pop_listTable" style="width:97.2%">
			<colgroup>
				<col style="width:15%;">
				<col style="width:35%;">
				<col style="width:20%;">
				<col style="width:20%;">
			</colgroup>
			<tr>
				<th>선택</th>
				<th>이름</th>
				<th>진행건수</th>
				<th>완료건수</th>
			</tr>
		</table>
		<div class="popA" style="height:148px; overflow-y:scroll;">
			<table class="pop_listTable" id="empList" >
				<colgroup>
					<col style="width:15%;">
					<col style="width:35%;">
					<col style="width:20%;">
					<col style="width:20%;">
				</colgroup>
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