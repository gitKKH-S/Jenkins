<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	List managerList = request.getAttribute("managerList")==null?new ArrayList():(ArrayList)request.getAttribute("managerList");
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	String agreeid = request.getAttribute("agreeid")==null?"":request.getAttribute("agreeid").toString();
	
	System.out.println("팝업에서 managerList 뭐로 오나  :::::  " + managerList.toString());
	
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
	$(document).ready(function(){
		
	});
	
	function viewReload() {
		var frm = document.frm;
		frm.action = "selectChrgEmpPop.do";
		frm.submit();
	}
	
	function setManager(empNo, empName){
	    // 부모창의 필드에 값 설정
	    if (window.opener && !window.opener.closed) {
	        window.opener.document.getElementById("cvtn_rqst_dept_tmldr_emp_no").value = empNo;
	        window.opener.document.getElementById("cvtn_rqst_dept_tmldr_nm").value = empName;
	    }
	    
	    // 팝업 닫기
	    window.close();
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="wrtr_emp_no"   id="wrtr_emp_no"/>
	<input type="hidden" name="wrtr_emp_nm"     id="wrtr_emp_nm"/>
	<input type="hidden" name="wrt_dept_no"   id="wrt_dept_no"/>
	<input type="hidden" name="wrt_dept_nm"     id="wrt_dept_nm"/>
<%-- 	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
	<strong class="popTT">
		자문담당자 관리
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popA">
			<table class="pop_listTable" style="width:97.7%;">
				<colgroup>
					<col style="width:30%;">
					<col style="width:20%;">
					<col style="width:20%;">
					<col style="width:25%;">
					<col style="width:25%;">
					<col style="width:25%;">
				</colgroup>
				<tr>
					<th>부서명</th>
					<th>이름</th>
					<th>직급</th>
					<th>내선번호</th>
					<th>이메일주소</th>
					<th></th>
				</tr>
			</table>
		</div>
		<div class="popA" style="height:260px; overflow-y:scroll;">
			<table class="pop_listTable">
				<colgroup>
					<col style="width:30%;">
					<col style="width:20%;">
					<col style="width:20%;">
					<col style="width:25%;">
					<col style="width:25%;">
					<col style="width:25%;">
				</colgroup>
<%
				for(int i=0; i<managerList.size(); i++) {
					HashMap empMap = (HashMap)managerList.get(i);
					String emp_no = empMap.get("EMP_NO")==null?"":empMap.get("EMP_NO").toString();
%>
				<tr>
					<td>
						<%=empMap.get("DEPT_NM")==null?"":empMap.get("DEPT_NM").toString()%>
					</td>
					<td>
						<%=empMap.get("EMP_NM")==null?"":empMap.get("EMP_NM").toString()%>
					</td>
					<td>
						<%=empMap.get("JBGD_NM")==null?"":empMap.get("JBGD_NM").toString()%>
					</td>
					<td>
						<%=empMap.get("FORMATTED_TELNO")==null?"":empMap.get("FORMATTED_TELNO").toString()%>
					</td>
					<td>
						<%=empMap.get("EML_ADDR")==null?"-":empMap.get("EML_ADDR").toString()%>
					</td>
					<td>
						<a href="#none" class="innerBtn" onclick="setManager('<%=emp_no%>', '<%=empMap.get("EMP_NM")==null?"":empMap.get("EMP_NM").toString()%>');">선택</a>
					</td>
				</tr>
<%
				}
%>
			</table>
		</div>
	</div>
</form>