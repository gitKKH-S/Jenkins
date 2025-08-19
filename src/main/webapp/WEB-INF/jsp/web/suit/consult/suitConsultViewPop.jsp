<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%
	String tabId = request.getParameter("tabId");
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	System.out.println("*************************************");
	System.out.println(se);
	System.out.println("*************************************");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	HashMap suitMap = request.getAttribute("suitMap")==null?new HashMap():(HashMap)request.getAttribute("suitMap");
	List suitContFile = request.getAttribute("suitContFile")==null?new ArrayList():(ArrayList)request.getAttribute("suitContFile");
	
	String LWS_MNG_NO      = suitMap.get("LWS_MNG_NO")==null?"":suitMap.get("LWS_MNG_NO").toString();
	String LWS_RQST_MNG_NO = suitMap.get("LWS_RQST_MNG_NO")==null?"":suitMap.get("LWS_RQST_MNG_NO").toString();
	String PRGRS_STTS_NM   = suitMap.get("PRGRS_STTS_NM")==null?"":suitMap.get("PRGRS_STTS_NM").toString();
	String LWS_RQST_EMP_NO = suitMap.get("LWS_RQST_EMP_NO")==null?"":suitMap.get("LWS_RQST_EMP_NO").toString();
	
	String MENU_MNG_NO          = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	String WRTR_EMP_NM          = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO        = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM        = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO          = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String searchForm      = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
%>
<style>
	
</style>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script src="${resourceUrl}/js/mten.findword.js"></script>
<script type="text/javascript">
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var GRPCD = "<%=GRPCD%>";
	
	
	$(window).load(function(){
		$("#loading").hide();
	});
	
	function goReLoad(){
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/suitConsultViewPage.do";
		document.frm.submit();
	}
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/goSuitConsultList.do";
		document.frm.submit();
	}
	
	function goEdit(){
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/suitConsultWritePage.do";
		document.frm.submit();
	}
	
	function goDelInfo(gbn){
		if(confirm("소송의뢰정보를 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteSuitConsultInfo.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					goListPage();
				}
			});
		}
	}
	
	function editProgress(prog) {
		if (prog == "접수요청") {
			var size = "<%=suitContFile.size()%>";
			if (size == 0) {
				return alert("입증자료 첨부파일을 업로드 하세요.");
			}
		}
		
		$("#prog").val(prog);
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/updateSuitConsultProg.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				alert(prog+"처리 되었습니다.");
				goReLoad();
			}
		});
	}
	
	function suitView() {
		document.frm.action="<%=CONTEXTPATH%>/web/suit/suitViewPage.do";
		document.frm.submit();
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="searchForm"      id="searchForm"      value="<%=searchForm%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO %>"/>
	<input type="hidden" name="LWS_RQST_MNG_NO" id="LWS_RQST_MNG_NO" value="<%=LWS_RQST_MNG_NO %>"/>
	<input type="hidden" name="MENU_MNG_NO"          id="MENU_MNG_NO"          value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="Grpcd"           id="Grpcd"           value="<%=GRPCD%>"/>
	<input type="hidden" name="WRTR_EMP_NM"          id="WRTR_EMP_NM"          value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"        id="WRTR_EMP_NO"        value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"          id="WRT_DEPT_NO"          value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"        id="WRT_DEPT_NM"        value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="prog"            id="prog"            value="" />
	<input type="hidden" name="${_csrf.parameterName}"               value="${_csrf.token}"/>

<strong class="popTT">
	사건 의뢰 정보
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
	
	<div class="subCA">
		<strong class="subTT" id="subTT"></strong>
		<div class="subBtnC right">
		<%if ("작성중".equals(PRGRS_STTS_NM) && LWS_RQST_EMP_NO.equals(WRTR_EMP_NO)) {%>
			<a href="#none" class="sBtn type1" onclick="goEdit();">수정</a>
			<a href="#none" class="sBtn type1" onclick="goDelInfo();">삭제</a>
			<a href="#none" class="sBtn type1" onclick="editProgress('접수요청');">접수요청</a>
		<%}%>
		<%if ("접수요청".equals(PRGRS_STTS_NM) && GRPCD.indexOf("L") > -1) {%>
			<a href="#none" class="sBtn type1" onclick="editProgress('접수');">접수(소송진행)</a>
			<a href="#none" class="sBtn type1" onclick="editProgress('반려');">반려</a>
		<%}%>
		<%if ("접수".equals(PRGRS_STTS_NM) && (LWS_RQST_EMP_NO.equals(WRTR_EMP_NO) || GRPCD.indexOf("L") > -1)) {%>
			<a href="#none" class="sBtn type1" onclick="suitView();">소송조회</a>
		<%}%>
			<a href="#none" class="sBtn type1" onclick="goListPage();">목록</a>
		</div>
		<div class="innerB">
			<table class="infoTable" style="width:100%;">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>의뢰자</th>
					<td><%= suitMap.get("LWS_RQST_EMP_NM")==null?"":suitMap.get("LWS_RQST_EMP_NM").toString() %></td>
					<th>의뢰부서</th>
					<td><%= suitMap.get("LWS_RQST_DEPT_NM")==null?"":suitMap.get("LWS_RQST_DEPT_NM").toString() %></td>
					<th>의뢰일</th>
					<td><%= suitMap.get("LWS_RQST_YMD")==null?"":suitMap.get("LWS_RQST_YMD").toString() %></td>
				</tr>
				<tr>
					<th>사건명</th>
					<td colspan="5">
						<%= suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString() %>
					</td>
				</tr>
				<tr>
					<th>소송유형</th>
					<td>
						<%= suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString() %>
						-<%= suitMap.get("LWS_LWR_TYPE_NM")==null?"":suitMap.get("LWS_LWR_TYPE_NM").toString() %>
					</td>
					<th>중요소송여부</th>
					<td><%= suitMap.get("IMPT_LWS_YN")==null?"":suitMap.get("IMPT_LWS_YN").toString() %></td>
					<th>소송상대방</th>
					<td><%= suitMap.get("LWS_RLT_NM")==null?"":suitMap.get("LWS_RLT_NM").toString() %></td>
				</tr>
				<tr>
					<th>접수자</th>
					<td><%= suitMap.get("RQST_RCPT_EMP_NM")==null?"":suitMap.get("RQST_RCPT_EMP_NM").toString() %></td>
					<th>접수일</th>
					<td><%= suitMap.get("RQST_RCPT_YMD")==null?"":suitMap.get("RQST_RCPT_YMD").toString() %></td>
					<th>진행상태</th>
					<td><%= suitMap.get("PRGRS_STTS_NM")==null?"":suitMap.get("PRGRS_STTS_NM").toString() %></td>
				</tr>
				<tr>
					<th>사건 개요</th>
					<td colspan="5">
						<%= suitMap.get("INCDNT_OTLN")==null?"":suitMap.get("INCDNT_OTLN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>주요내용</th>
					<td colspan="5">
						<%= suitMap.get("MAIN_CN")==null?"":suitMap.get("MAIN_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>입증자료</th>
					<td colspan="5">
						<%= suitMap.get("LWS_CONF_DATA_CN")==null?"":suitMap.get("LWS_CONF_DATA_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="5">
						<%= suitMap.get("RMRK_CN")==null?"":suitMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>첨부파일(입증자료)</th>
					<td colspan="5">
				<%
					for(int f=0; f<suitContFile.size(); f++) {
						HashMap file = (HashMap)suitContFile.get(f);
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
	</div>
</form>
