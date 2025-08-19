<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	HashMap costMap = request.getAttribute("costMap")==null?new HashMap():(HashMap)request.getAttribute("costMap");
	List targetList = request.getAttribute("targetList")==null?new ArrayList():(ArrayList)request.getAttribute("targetList");
	List costFile = request.getAttribute("costFile")==null?new ArrayList():(ArrayList)request.getAttribute("costFile");
	
	String CST_SE = costMap.get("CST_SE")==null?"":costMap.get("CST_SE").toString();
	String APRV_YN = costMap.get("APRV_YN")==null?"":costMap.get("APRV_YN").toString();
	String GIVE_YN = costMap.get("GIVE_YN")==null?"":costMap.get("GIVE_YN").toString();
	String GIVE_YMD = costMap.get("GIVE_YMD")==null?"":costMap.get("GIVE_YMD").toString();
	
	String CST_MNG_NO = request.getAttribute("CST_MNG_NO")==null?"":request.getAttribute("CST_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
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
	
	
	
	
	function amtAprv(CST_MNG_NO, LWS_MNG_NO, INST_MNG_NO, gbn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/setOutCostState.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				CST_MNG_NO:CST_MNG_NO,
				APRV_YN:gbn
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				location.reload(true);
			}
		});
	}
	
	// 비용 지급여부 처리
	function amtGive(CST_MNG_NO, LWS_MNG_NO, INST_MNG_NO, gbn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/setOutCostState.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				CST_MNG_NO:CST_MNG_NO,
				GIVE_YN:gbn,
				APRV_YN:APRV_YN
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				location.reload(true);
			}
		});
	}
	
	// 비용 지급일자 처리
	function amtGiveYmd(CST_MNG_NO, LWS_MNG_NO, INST_MNG_NO) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/setOutCostState.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				CST_MNG_NO:CST_MNG_NO,
				GIVE_YMD:$("#GIVE_YMD").val(),
				APRV_YN:APRV_YN
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				location.reload(true);
			}
		});
	}
</script>
<strong class="popTT">
	비용 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="CST_MNG_NO"  id="CST_MNG_NO"  value="<%=CST_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM" id="WRTR_EMP_NM" value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO" id="WRT_DEPT_NO" value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="Serverfile"  id="Serverfile"  value="" />
	<input type="hidden" name="Pcfilename"  id="Pcfilename"  value="" />
	<input type="hidden" name="folder"      id="folder"      value="SUIT" />
	
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
					<th>구분</th>
					<td><%=costMap.get("CST_PRCS_NM")==null?"":costMap.get("CST_PRCS_NM").toString()%></td>
					<th>예산구분</th>
					<td><%=costMap.get("CST_SE_NM")==null?"":costMap.get("CST_SE_NM").toString()%></td>
				</tr>
				<tr>
					<th>금액</th>
					<td><%=costMap.get("PRCS_AMT")==null?"":costMap.get("PRCS_AMT").toString()%></td>
					<th>비용대상</th>
					<td><%=costMap.get("CST_TRGT_MNG_NM")==null?"":costMap.get("CST_TRGT_MNG_NM").toString()%></td>
				</tr>
				<tr>
				</tr>
				<%if("M".equals(CST_SE)) {%>
				<tr>
					<th>처리완료여부</th>
					<td><%=costMap.get("CST_PRCS_CMPTN_YN")==null?"":costMap.get("CST_PRCS_CMPTN_YN").toString()%></td>
					<th>처리일자</th>
					<td><%=costMap.get("CST_PRCS_YMD")==null?"":costMap.get("CST_PRCS_YMD").toString()%></td>
				</tr>
				<%}else{%>
				<tr>
					<th>신청일자</th>
					<td><%=costMap.get("GIVE_APLY_YMD")==null?"":costMap.get("GIVE_APLY_YMD").toString()%></td>
					<th colspan="2"></th>
				</tr>
				<tr>
					<th>승인여부</th>
					<td>
						<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1) {%>
							<%=costMap.get("APRV_NM")==null?"":costMap.get("APRV_NM").toString()%>
							
							<%if ("G".equals(APRV_YN) || "T".equals(APRV_YN)) {%>
							<a href="#none" class="innerBtn" onclick="amtAprv('<%=CST_MNG_NO%>', '<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>', 'Y');">승인</a>
							<a href="#none" class="innerBtn" onclick="amtAprv('<%=CST_MNG_NO%>', '<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>', 'R');">보완요청</a>
							<%}%>
						<%}%>
					</td>
					<th>승인일자</th>
					<td><%=costMap.get("APRV_YMD")==null?"":costMap.get("APRV_YMD").toString()%></td>
				</tr>
				<tr>
					<th>지급여부</th>
					<td>
						<%=costMap.get("GIVE_YN")==null?"":costMap.get("GIVE_YN").toString()%>
						
						<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("D") > -1) {%>
							<%if ("Y".equals(APRV_YN) && !GIVE_YMD.equals("") && "N".equals(GIVE_YN)) {%>
							<a href="#none" class="innerBtn" onclick="amtGive('<%=CST_MNG_NO%>', '<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>', 'Y');">지급</a>
							<%}%>
						<%}%>
					</td>
					<th>지급일자</th>
					<td>
					<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("D") > -1) {%>
						<%if("Y".equals(APRV_YN) && GIVE_YMD.equals("")) {%>
							<input type="text" class="datepick" id="GIVE_YMD" name="GIVE_YMD" style="width: 80px;" value="">
							<a href="#none" class="innerBtn" onclick="amtGiveYmd('<%=CST_MNG_NO%>', '<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">저장</a>
						<%} else if ("Y".equals(APRV_YN) && !GIVE_YMD.equals("")) {%>
							<%=costMap.get("GIVE_YMD")==null?"":costMap.get("GIVE_YMD").toString()%>
						<%} else {%>
							-
						<%}%>
					<%}%>
					</td>
				</tr>
				<%}%>
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
			<a href="#none" class="sBtn type2" onclick="editCostInfo();">수정</a>
			<a href="#none" class="sBtn type3" onclick="delCostInfo();">삭제</a>
		</div>
	</div>
</form>