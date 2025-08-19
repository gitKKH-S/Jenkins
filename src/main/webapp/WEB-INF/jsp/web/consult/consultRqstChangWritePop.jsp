<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	List empList = request.getAttribute("empList")==null?new ArrayList():(ArrayList)request.getAttribute("empList");
	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
	String cnstn_rqst_emp_no = request.getAttribute("cnstn_rqst_emp_no")==null?"":request.getAttribute("cnstn_rqst_emp_no").toString();
	String srchTxt = request.getAttribute("srchTxt")==null?"":request.getAttribute("srchTxt").toString();
	
	System.out.println("22222" + consultid);
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	System.out.println(se);
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String OPHONE = se.get("INPHONE")==null?"":se.get("INPHONE").toString();
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String DEPTNAME = se.get("DEPTNAME")==null?"":se.get("DEPTNAME").toString();
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
%>
<style>
	#hidden{display:none;}
	th{text-align:center;}
	#suitnm:hover{cursor:pointer; text-decoration:underline;}
</style>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css3/table.css">
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css3/popup.css">
<script type="text/javascript">
	var consultid = "<%=consultid%>";
	$(document).ready(function(){
		$("#srchTxt").keydown(function(key) {
			if (key.keyCode == 13) {
				document.frm.schTxt.value = $("#srchTxt").val();
<%-- 				document.frm.action="<%=CONTEXTPATH%>/web/suit/searchBankPop.do"; --%>
				document.frm.submit();
			}
		});
	});
	
	function viewReload() {
		var frm = document.frm;
		frm.action = "selectChrgEmpPop.do";
		frm.submit();
	}
	
	function setState(userno, state) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/setChrgEmpState.do",
			data:{
				"userno" : userno,
				"state" : state
			},
			beforeSend : function(xhr){
				xhr.setRequestHeader(header,token);
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("설정이 변경되었습니다.");
				viewReload();
			}
		});
	}
	
	function setRqstEmp(userno, usernm, deptno, deptnm){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/consultRqstChang.do",
			data:{
				userno : userno
				,usernm : usernm
				,deptno : deptno
				,deptnm : deptnm
				,consultid : consultid
				
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("자문 의뢰자 변경이 완료되었습니다.");
				opener.viewReload();
				window.close();
			}
		});
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="wrtr_emp_no"     id="wrtr_emp_no"/>
	<input type="hidden" name="wrtr_emp_nm"     id="wrtr_emp_nm"/>
	<input type="hidden" name="wrt_dept_no"     id="wrt_dept_no"/>
	<input type="hidden" name="wrt_dept_nm"     id="wrt_dept_nm"/>
	<input type="hidden" name="consultid"     id="consultid" value="<%=consultid%>"/>
	<strong class="popTT">
		의뢰자 변경
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popA">
			<div class="popSrchW">
				<input type="text" id="srchTxt" name="srchTxt" value="<%=srchTxt%>" placeholder="검색 할 직원명/부서명을 입력해주세요.">
			</div>
			<table class="pop_listTable" style="width:98%;">
				<colgroup>
					<col style="width:30%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:25%;">
					<col style="width:15%;">
				</colgroup>
				<tr>
					<th>부서명</th>
					<th>이름</th>
					<th>직급</th>
					<th>내선번호</th>
					<th></th>
				</tr>
			</table>
		</div>
		<div class="popA" style="height:260px; overflow-y:scroll;">
			<table class="pop_listTable">
				<colgroup>
					<col style="width:30%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:25%;">
					<col style="width:15%;">
				</colgroup>
<%
				for(int i=0; i<empList.size(); i++) {
					HashMap empMap = (HashMap)empList.get(i);
					String emp_no = empMap.get("EMP_NO")==null?"":empMap.get("EMP_NO").toString();
					String emp_nm = empMap.get("EMP_NM")==null?"":empMap.get("EMP_NM").toString();
					String dept_no = empMap.get("DEPT_NO")==null?"":empMap.get("DEPT_NO").toString();
					String dept_nm = empMap.get("DEPT_NM")==null?"":empMap.get("DEPT_NM").toString();
					String formatted_telno = empMap.get("FORMATTED_TELNO")==null?"":empMap.get("FORMATTED_TELNO").toString();
					String wrc_telno = empMap.get("WRC_TELNO")==null?"":empMap.get("WRC_TELNO").toString();
					String jbgd_nm = empMap.get("JBGD_NM")==null?"":empMap.get("JBGD_NM").toString();
%>
				<tr>
					<td>
						<%=empMap.get("DEPT_NM")==null?"":empMap.get("DEPT_NM").toString()%>
					</td>
					<td>
						<%=empMap.get("EMP_NM")==null?"":empMap.get("EMP_NM").toString()%>
					</td>
					<td>
						<%=jbgd_nm%>
					</td>
					<td>
						<%=wrc_telno%>
					</td>
					<td>
						<%
						if(!cnstn_rqst_emp_no.equals(emp_no)){
						%>
						<a href="#none" class="innerBtn" onclick="setRqstEmp('<%=emp_no%>', '<%=emp_nm%>', '<%=dept_no%>', '<%=dept_nm%>');">선택</a>
						<%
						}
						%>
					</td>
				</tr>
<%
				}
%>
			</table>
		</div>
	</div>
</form>