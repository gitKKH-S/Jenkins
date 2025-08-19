<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	List managerList = request.getAttribute("managerList")==null?new ArrayList():(ArrayList)request.getAttribute("managerList");
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
	String srchTxt = request.getAttribute("srchTxt")==null?"":request.getAttribute("srchTxt").toString();
	
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
		$("#srchTxt").keydown(function(key) {
			if (key.keyCode == 13) {
				document.frm.schTxt.value = $("#srchTxt").val();
				document.frm.action="<%=CONTEXTPATH%>/web/suit/searchBankPop.do";
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
	
	function setChrg(userno, usernm){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/setChrgEmpState.do",
			data:{
				"userno" : userno,
				"usernm" : usernm,
				"consultid" : "<%=consultid%>"
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("담당자 변경이 완료되었습니다.");
				opener.viewReload();
				window.close();
			}
		});
	}
	function setManager(empNo, empName, empTelno, empJbgd_nm){
		var gbn = "<%=gbn%>";
		
		if (window.opener && !window.opener.closed) {
			if (gbn == "agree1") {
				window.opener.document.getElementById("CVTN_RQST_LAST_APRVR_NO").value = empNo;
				window.opener.document.getElementById("CVTN_RQST_LAST_APRVR_NM").value = empName;
				window.opener.document.getElementById("CVTN_RQST_DEPT_TMLDR_JBPS_NM").value = empJbgd_nm;
			} else if(gbn == "agree2") {
				window.opener.document.getElementById("CVTN_RQST_DH_EMP_NO").value = empNo;
				window.opener.document.getElementById("CVTN_RQST_DH_NM").value = empName;
				window.opener.document.getElementById("CVTN_RQST_DH_JBPS_NM").value = empJbgd_nm;
			} else if(gbn == "con1") {
				// 부모창의 필드에 값 설정
				window.opener.document.getElementById("cnstn_rqst_dept_tmldr_emp_no").value = empNo;
				window.opener.document.getElementById("cnstn_rqst_dept_tmldr_nm").value = empName;
				window.opener.document.getElementById("cnstn_rqst_dept_tmldr_telno").value = empTelno;
				window.opener.document.getElementById("cnstn_rqst_dept_tmldr_jbps_nm").value = empJbgd_nm;
			} else if (gbn == "con2") {
				window.opener.document.getElementById("cnstn_rqst_dh_emp_no").value = empNo;
				window.opener.document.getElementById("cnstn_rqst_dh_nm").value = empName;
				window.opener.document.getElementById("cnstn_rqst_dh_jbps_nm").value = empJbgd_nm;
				
			}
		}
		
		// 팝업 닫기
		window.close();
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="wrtr_emp_no"     id="wrtr_emp_no"/>
	<input type="hidden" name="wrtr_emp_nm"     id="wrtr_emp_nm"/>
	<input type="hidden" name="wrt_dept_no"     id="wrt_dept_no"/>
	<input type="hidden" name="wrt_dept_nm"     id="wrt_dept_nm"/>
	<input type="hidden" name="gbn"             id="gbn" value="<%=gbn%>"/>
	<strong class="popTT">
		팀장 및 부서장 정보 관리
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
				for(int i=0; i<managerList.size(); i++) {
					HashMap empMap = (HashMap)managerList.get(i);
					String emp_no = empMap.get("EMP_NO")==null?"":empMap.get("EMP_NO").toString();
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
						<a href="#none" class="innerBtn" onclick="setManager('<%=emp_no%>', '<%=empMap.get("EMP_NM")==null?"":empMap.get("EMP_NM").toString()%>', '<%=wrc_telno%>', '<%=jbgd_nm%>');">선택</a>
					</td>
				</tr>
<%
				}
%>
			</table>
		</div>
	</div>
</form>