<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	List empList = request.getAttribute("empList")==null?new ArrayList():(ArrayList)request.getAttribute("empList");
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
	
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
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="wrtr_emp_no"   id="wrtr_emp_no"/>
	<input type="hidden" name="wrtr_emp_nm"     id="wrtr_emp_nm"/>
	<input type="hidden" name="wrt_dept_no"   id="wrt_dept_no"/>
	<input type="hidden" name="wrt_dept_nm"     id="wrt_dept_nm"/>
<%-- 	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
	<strong class="popTT">
		자문팀 담당자 관리
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popA">
			<table class="pop_listTable" style="width:97.95%;">
				<colgroup>
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:10%;">
				</colgroup>
				<tr>
					<th>이름</th>
					<th>직급</th>
					<th>진행중</th>
					<th>상태</th>
					<th>마지막배정일</th>
					<th></th>
				</tr>
			</table>
		</div>
		<div class="popA" style="height:260px; overflow-y:scroll;">
			<table class="pop_listTable">
				<colgroup>
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:10%;">
				</colgroup>
<%
				for(int i=0; i<empList.size(); i++) {
					HashMap empMap = (HashMap)empList.get(i);
					String state = empMap.get("STATE")==null?"Y":empMap.get("STATE").toString();
					String emp_no = empMap.get("EMP_NO")==null?"":empMap.get("EMP_NO").toString();
%>
				<tr>
					<td>
						<%=empMap.get("EMP_NM")==null?"":empMap.get("EMP_NM").toString()%>
					</td>
					<td>
						<%=empMap.get("JBGD_NM")==null?"":empMap.get("JBGD_NM").toString()%>
					</td>
					<td>
						<%=empMap.get("TKCG_CNSTN_CNT")==null?"":empMap.get("TKCG_CNSTN_CNT").toString()%>건
					</td>
					<td>
						<%if("Y".equals(state)) {out.println("배정중");}else{out.println("미배정");}%>
					</td>
					<td>
						<%=empMap.get("RCNT_ALTMNT_YMD")==null?"-":empMap.get("RCNT_ALTMNT_YMD").toString()%>
					</td>
<%
				if ("state".equals(gbn)) {
%>
					<td>
						<%if("Y".equals("STATE")) { %>
						<a href="#none" class="innerBtn" onclick="setState('<%=emp_no%>', 'N');">비활성화</a>
						<%} else {%>
						<a href="#none" class="innerBtn" onclick="setState('<%=emp_no%>', 'Y');">활성화</a>
						<%}%>
					</td>
<%
				} else {
					String chrgyn = empMap.get("CHRGYN")==null?"N":empMap.get("CHRGYN").toString();
%>
					<td>
<%-- 						<%if("N".equals(chrgyn) && "Y".equals("STATE")) { %> --%>
						<%if("N".equals(chrgyn)) { %>
						<a href="#none" class="innerBtn" onclick="setChrg('<%=emp_no%>', '<%=empMap.get("EMP_NM")==null?"":empMap.get("EMP_NM").toString()%>');">담당자지정</a>
						<%}%>
					</td>
<%
				}
%>
				</tr>
<%
				}
%>
			</table>
		</div>
	</div>
</form>