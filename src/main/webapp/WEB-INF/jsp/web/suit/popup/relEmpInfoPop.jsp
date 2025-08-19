<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	HashMap empMap = request.getAttribute("empMap")==null?new HashMap():(HashMap)request.getAttribute("empMap");
	String FLFMT_YN = empMap.get("FLFMT_YN")==null?"":empMap.get("FLFMT_YN").toString();
	String LWS_FLFMT_EMP_NO = empMap.get("LWS_FLFMT_EMP_NO")==null?"":empMap.get("LWS_FLFMT_EMP_NO").toString();
	
	String LWS_FLFMT_MNG_NO = request.getAttribute("LWS_FLFMT_MNG_NO")==null?"":request.getAttribute("LWS_FLFMT_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":(String)request.getAttribute("WRTR_EMP_NM");
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":(String)request.getAttribute("WRTR_EMP_NO");
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":(String)request.getAttribute("WRT_DEPT_NM");
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":(String)request.getAttribute("WRT_DEPT_NO");
%>
<script type="text/javascript">
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var LWS_FLFMT_MNG_NO = "<%=LWS_FLFMT_MNG_NO%>";
	var FLFMT_YN = "<%=FLFMT_YN%>";
	var LWS_FLFMT_EMP_NO = "<%=LWS_FLFMT_EMP_NO%>";
	
	$(document).ready(function(){
		
	});
	
	function goInfoEdit(){
		opener.goTabWrite(LWS_FLFMT_MNG_NO);
		window.close();
	}
	
	function goInfoDel(){
		if(confirm("수행자 정보를 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteRelEmpInfo.do",
				data:{
					LWS_FLFMT_MNG_NO:LWS_FLFMT_MNG_NO,
					LWS_FLFMT_EMP_NO:LWS_FLFMT_EMP_NO,
					LWS_MNG_NO:LWS_MNG_NO,
					INST_MNG_NO:INST_MNG_NO
				},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					opener.goReLoad();
					window.close();
				}
			});
		}
	}
</script>
<strong class="popTT">
	소송수행자 정보
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="LWS_FLFMT_MNG_NO" id="LWS_FLFMT_MNG_NO" value="<%=LWS_FLFMT_MNG_NO%>" />
	<input type="hidden" name="LWS_MNG_NO"       id="LWS_MNG_NO"       value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO"      id="INST_MNG_NO"      value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM"           id="WRTR_EMP_NM"           value="<%=WRTR_EMP_NM%>"/>
	<input type="hidden" name="WRTR_EMP_NO"         id="WRTR_EMP_NO"         value="<%=WRTR_EMP_NO%>"/>
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write" style="width:100%">
				<colgroup>
					<col style="width:20%;">
					<col style="width:*;">
					<col style="width:20%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>수행부서</th>
					<td><%=empMap.get("LWS_FLFMT_DEPT_NM")==null?"":empMap.get("LWS_FLFMT_DEPT_NM").toString()%></td>
					<th>소송수행자</th>
					<td><%=empMap.get("LWS_FLFMT_EMP_NM")==null?"":empMap.get("LWS_FLFMT_EMP_NM").toString()%></td>
				</tr>
				<tr>
					<th>사용여부</th>
					<td><%=empMap.get("FLFMT_YN")==null?"":empMap.get("FLFMT_YN").toString()%></td>
					<th>수행기간</th>
					<td><%=empMap.get("FLFMT_BGNG")==null?"":empMap.get("FLFMT_BGNG").toString()%> ~ <%=empMap.get("FLFMT_END")==null?"":empMap.get("FLFMT_END").toString()%></td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3">
						<%=empMap.get("RMRK_CN")==null?"":empMap.get("RMRK_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type2" onclick="goInfoEdit();">수정</a>
			<a href="#none" class="sBtn type3" onclick="goInfoDel();">삭제</a>
		</div>
	</div>
</form>