<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String RPTP_MNG_NO = request.getAttribute("RPTP_MNG_NO")==null?"":request.getAttribute("RPTP_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap reportMap = request.getAttribute("reportMap")==null?new HashMap():(HashMap)request.getAttribute("reportMap");
	List reportFile = request.getAttribute("reportFile")==null?new ArrayList():(ArrayList)request.getAttribute("reportFile");
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<style>
	.popW{height:100%; min-width:532px;}
	.selFileDiv{cursor:pointer; text-decoration:underline;}
</style>
<script>
	var RPTP_MNG_NO = "<%=RPTP_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	
	$(document).ready(function(){
		
	});
	
	function editReportInfo(){
		opener.goTabWrite(RPTP_MNG_NO);
		window.close();
	}
	
	function delReportInfo(){
		if(confirm("보고서를 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteReportInfo.do",
				data:{LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO, RPTP_MNG_NO:RPTP_MNG_NO},
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
	보고서 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="RPTP_MNG_NO"     id="RPTP_MNG_NO"     value="<%=RPTP_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NO"        id="WRTR_EMP_NO"        value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"          id="WRTR_EMP_NM"          value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM"        id="WRT_DEPT_NM"        value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"          id="WRT_DEPT_NO"          value="<%=WRT_DEPT_NO%>" />
	<div class="popC">
		<div class="popA" style="height:100%">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>제목</th>
					<td colspan="3">
						<%=reportMap.get("RPTP_TTL")==null?"":reportMap.get("RPTP_TTL").toString()%>
					</td>
				</tr>
				<tr>
					<th>작성자</th>
					<td><%=reportMap.get("WRTR_EMP_NM")==null?"":reportMap.get("WRTR_EMP_NM").toString()%></td>
					<th>작성일</th>
					<td><%=reportMap.get("WRT_YMD")==null?"":reportMap.get("WRT_YMD").toString()%></td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3" style="height:150px">
						<%=reportMap.get("RPTP_CN")==null?"":reportMap.get("RPTP_CN").toString()%>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3" style="height:150px">
						<%=reportMap.get("RMRK_CN")==null?"":reportMap.get("RMRK_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td id="fileList" height="150px" colspan="3">
					<%
						for(int f=0; f<reportFile.size(); f++) {
							HashMap file = (HashMap)reportFile.get(f);
					%>
							<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
								<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
							</div>
					<%
						}
					%>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type2" onclick="editReportInfo();">수정</a>
			<a href="#none" class="sBtn type3" onclick="delReportInfo();">삭제</a>
		</div>
	</div>
</form>
