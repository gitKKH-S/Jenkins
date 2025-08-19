<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	HashMap costMap = request.getAttribute("costMap")==null?new HashMap():(HashMap)request.getAttribute("costMap");
	List costFile = request.getAttribute("costFile")==null?new ArrayList():(ArrayList)request.getAttribute("costFile");
	
	String APRV_YN = costMap.get("APRV_YN")==null?"":costMap.get("APRV_YN").toString();
	
	String CST_MNG_NO  = request.getAttribute("CST_MNG_NO")==null?"":request.getAttribute("CST_MNG_NO").toString();
	String LWS_MNG_NO  = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String CST_TRGT_MNG_NO = request.getAttribute("CST_TRGT_MNG_NO")==null?"":request.getAttribute("CST_TRGT_MNG_NO").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr" />
<style>
	.selFileDiv{cursor:pointer; text-decoration:underline;}
	.popW{height:100%}
</style>
<script type="text/javascript">
	var CST_MNG_NO = "<%=CST_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var APRV_YN = "<%=APRV_YN%>";
	
	$(document).ready(function(){
		
	});
	
	function confCostInfo() {
		if(confirm("비용 신청이 승인되면 정보수정이나 삭제가 불가능합니다.\n신청하시겠습니까?")){
			
			var CHG_APRV_YN = '';
			if (APRV_YN == "N") {
				CHG_APRV_YN = 'G';
			} else if (APRV_YN == "R") {
				CHG_APRV_YN = 'T';
			}
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/setOutCostState.do",
				data:{
					APRV_YN:CHG_APRV_YN,
					CST_MNG_NO:CST_MNG_NO,
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
	
	function editCostInfo(){
		opener.goTabWrite(CST_MNG_NO);
		window.close();
	}
	
	function delCostInfo(){
		if(confirm("등록 된 첨부파일도 함께 삭제됩니다.\n삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteCostInfo.do",
				data:{
					CST_MNG_NO:CST_MNG_NO,
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
	비용 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="CST_MNG_NO"      id="CST_MNG_NO"      value="<%=CST_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"/>

	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	
	<input type="hidden" name=CST_TRGT_MNG_NO     id="CST_TRGT_MNG_NO"   value="<%=CST_TRGT_MNG_NO%>" />
	<input type="hidden" name="CST_PRCS_SE"       id="CST_PRCS_SE"       value="J"/>
	<input type="hidden" name="CST_PRCS_YMD"      id="CST_PRCS_YMD"      value=""/>
	<input type="hidden" name="CST_PRCS_CMPTN_YN" id="CST_PRCS_CMPTN_YN" value="N"/>
	<input type="hidden" name="APRV_YN" id="APRV_YN" value="<%=APRV_YN%>"/>
	
	<input type="hidden" name="Serverfile" id="Serverfile" value="" />
	<input type="hidden" name="Pcfilename" id="Pcfilename" value="" />
	<input type="hidden" name="folder" id="folder" value="SUIT" />
	
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>예산구분</th>
					<td colspan="3"><%=costMap.get("CST_SE_NM")==null?"":costMap.get("CST_SE_NM").toString()%></td>
				</tr>
				<tr>
					<th>금액</th>
					<td><%=costMap.get("PRCS_AMT")==null?"":costMap.get("PRCS_AMT").toString()%></td>
					<th>신청일자</th>
					<td><%=costMap.get("GIVE_APLY_YMD")==null?"":costMap.get("GIVE_APLY_YMD").toString()%></td>
				</tr>
				<tr>
					<th>승인여부</th>
					<td><%=costMap.get("APRV_NM")==null?"":costMap.get("APRV_NM").toString()%></td>
					<th>승인일자</th>
					<td><%=costMap.get("APRV_YMD")==null?"":costMap.get("APRV_YMD").toString()%></td>
				</tr>
				<tr>
					<th>지급여부</th>
					<td><%=costMap.get("GIVE_YN")==null?"":costMap.get("GIVE_YN").toString()%></td>
					<th>지급일자</th>
					<td><%=costMap.get("GIVE_YMD")==null?"":costMap.get("GIVE_YMD").toString()%></td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3">
						<%= costMap.get("RMRK_CN")==null?"":costMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td id="fileList" height="150px" colspan="3">
					<%
						for(int f=0; f<costFile.size(); f++) {
							HashMap file = (HashMap)costFile.get(f);
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
			<%if ("N".equals(APRV_YN) || "R".equals(APRV_YN)) {%>
			<a href="#none" class="sBtn type2" onclick="confCostInfo();">비용신청</a>
			<a href="#none" class="sBtn type2" onclick="editCostInfo();">수정</a>
			<a href="#none" class="sBtn type3" onclick="delCostInfo();">삭제</a>
			<%}%>
		</div>
	</div>
</form>