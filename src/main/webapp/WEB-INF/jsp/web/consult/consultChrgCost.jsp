<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	List costList = request.getAttribute("costList")==null?new ArrayList():(ArrayList)request.getAttribute("costList");
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script>
	$(document).ready(function(){
		$("#loading").hide();
	});
	
	function reload(){
		document.frm.action = "<%=CONTEXTPATH%>/web/consult/goConsultChrgCost.do";
		document.frm.submit();
	}
	
	//비용 승인여부 처리
	function amtAprv(CNSTN_CST_MNG_NO, RVW_TKCG_EMP_NO, CNSTN_MNG_NO, CNSTN_CST_AMT, gbn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/updateChrgLawyerAmt.do",
			data:{
				CNSTN_CST_MNG_NO:CNSTN_CST_MNG_NO,
				RVW_TKCG_EMP_NO:RVW_TKCG_EMP_NO,
				consultid:CNSTN_MNG_NO,
				CST_PRGRS_STTS_SE:gbn
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("저장되었습니다.");
				reload();
			}
		});
	}
	
	// 비용 지급일자 처리
	function amtAprvYmd(CNSTN_CST_MNG_NO) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/updateChrgLawyerAmt.do",
			data:{
				CNSTN_CST_MNG_NO:CNSTN_CST_MNG_NO,
				CST_APRV_YMD:$("#CST_APRV_YMD").val()
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("저장되었습니다.");
				reload();
			}
		});
	}
	
	// 비용 지급일자 처리
	function amtGiveYmd(CNSTN_CST_MNG_NO) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/updateChrgLawyerAmt.do",
			data:{
				CNSTN_CST_MNG_NO:CNSTN_CST_MNG_NO,
				CST_GIVE_YMD:$("#CST_GIVE_YMD").val()
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("저장되었습니다.");
				reload();
			}
		});
	}
	
	function chkAprvY() {
		// 체크 된 값 승인처리
		$("#loading").show();
		
		setTimeout(function() {
			var checkboxes = document.getElementsByName('chkCost[]');
			var checkedValues = [];
			
			var CNSTN_CST_MNG_NO_LIST = [];
			var RVW_TKCG_EMP_NO_LIST = [];
			var CNSTN_MNG_NO_LIST = [];
			var CNSTN_CST_AMT_LIST = [];
			
			for (let i = 0; i < checkboxes.length; i++) {
				if (checkboxes[i].checked) {
					if ($("#CST_PRGRS_STTS_SE"+checkboxes[i].value).val() != "R" && $("#CST_PRGRS_STTS_SE"+checkboxes[i].value).val() != "Z") {
						$("#loading").hide();
						return alert("승인처리 할 수 없는 상태의 항목이 체크되었습니다.");
					} else {
						CNSTN_CST_MNG_NO_LIST.push($("#CNSTN_CST_MNG_NO"+checkboxes[i].value).val());
						RVW_TKCG_EMP_NO_LIST.push($("#RVW_TKCG_EMP_NO"+checkboxes[i].value).val());
						CNSTN_MNG_NO_LIST.push($("#CNSTN_MNG_NO"+checkboxes[i].value).val());
						CNSTN_CST_AMT_LIST.push($("#CNSTN_CST_AMT"+checkboxes[i].value).val());
					}
				}
			}
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/consult/updateChrgLawyerAmtList.do",
				data:{
					CNSTN_CST_MNG_NO_LIST:CNSTN_CST_MNG_NO_LIST,
					RVW_TKCG_EMP_NO_LIST:RVW_TKCG_EMP_NO_LIST,
					CNSTN_MNG_NO_LIST:CNSTN_MNG_NO_LIST,
					CNSTN_CST_AMT_LIST:CNSTN_CST_AMT_LIST,
					CST_PRGRS_STTS_SE:"A"
				},
				dataType:"json",
				async:false,
				success:function(result){
					alert("저장되었습니다.");
					$("#loading").hide();
					reload();
				}
			});
		}, 0);
	}
	
	function chkGive() {
		// 일괄지급
		$("#loading").show();
		setTimeout(function() {
			var checkboxes = document.getElementsByName('chkCost[]');
			var checkedValues = [];
			
			var CNSTN_CST_MNG_NO_LIST = [];
			var RVW_TKCG_EMP_NO_LIST = [];
			var CNSTN_MNG_NO_LIST = [];
			var CNSTN_CST_AMT_LIST = [];
			
			for (let i = 0; i < checkboxes.length; i++) {
				if (checkboxes[i].checked) {
					if ($("#CST_PRGRS_STTS_SE"+checkboxes[i].value).val() != "A") {
						$("#loading").hide();
						return alert("지급 할 수 없는 상태의 항목이 체크되었습니다.");
					} if ($("#CST_GIVE_YMD"+checkboxes[i].value).val() == "" || $("#CST_APRV_YMD"+checkboxes[i].value).val() == "") {
						$("#loading").hide();
						return alert("지급일 또는 승인일이 등록되지 않은 항목이 체크되었습니다.");
					} else {
						CNSTN_CST_MNG_NO_LIST.push($("#CNSTN_CST_MNG_NO"+checkboxes[i].value).val());
						RVW_TKCG_EMP_NO_LIST.push($("#RVW_TKCG_EMP_NO"+checkboxes[i].value).val());
						CNSTN_MNG_NO_LIST.push($("#CNSTN_MNG_NO"+checkboxes[i].value).val());
						CNSTN_CST_AMT_LIST.push($("#CNSTN_CST_AMT"+checkboxes[i].value).val());
					}
				}
			}
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/consult/updateChrgLawyerAmtList.do",
				data:{
					CNSTN_CST_MNG_NO_LIST : CNSTN_CST_MNG_NO_LIST,
					RVW_TKCG_EMP_NO_LIST  : RVW_TKCG_EMP_NO_LIST,
					CNSTN_MNG_NO_LIST     : CNSTN_MNG_NO_LIST,
					CNSTN_CST_AMT_LIST    : CNSTN_CST_AMT_LIST,
					CST_PRGRS_STTS_SE     : "C"
				},
				dataType:"json",
				async:false,
				success:function(result){
					alert("저장되었습니다.");
					$("#loading").hide();
					reload();
				}
			});
		}, 0);
	}
</script>
<style>
	.infoTable{border: 0px;}
	.infoTable th{text-align: center;}
	#loading{
		height:100%;left:0px;position:fixed;_position:absolute;top:0px;
		width:100%;filter:alpha(opacity=50);-moz-opacity:0.5;opacity:0.5;
	}
	.loading{background-color:white;z-index:9998;}
	#loading_img{
		position:absolute;top:50%;left:50%;height:35px;
		margin-top:-25px;margin-left:0px;z-index:9999;
	}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<div id="loading" class="loading"><img id="loading_img" alt="loading" src="${resourceUrl}/paramquery-3.3.2/images/loading.gif" /></div>
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="subBtnW side" style="float:right; margin-top:10px">
			<div class="subBtnC right">
			<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("F") > -1) {%>
				<a href="#none" class="sBtn type1" onclick="chkAprvY();">일괄승인</a>
				<a href="#none" class="sBtn type4" onclick="chkGive();">일괄지급</a>
			<%}%>
			</div>
		</div>
		<hr class="margin10">
		<div class="innerB">
			<div>
				<div id="subTitle"><strong class="countT">자문료 신청 목록</strong></div>
				<hr class="margin10">
				<table class="infoTable">
					<colgroup>
						<col style="width:3%;">
						<col style="width:*;">
						<col style="width:12%;">
						<col style="width:8%;">
						<col style="width:8%;">
						<col style="width:8%;">
						<col style="width:8%;">
						<col style="width:8%;">
						<col style="width:15%;">
					</colgroup>
					<tr>
						<th></th>
						<th>자문명</th>
						<th>변호사</th>
						<th>신청자문료</th>
						<th>신청일자</th>
						<th>승인일자</th>
						<th>지급일자</th>
						<th>진행상태</th>
						<th></th>
					</tr>
				<%
					if(costList.size() > 0) {
						for (int i=0; i<costList.size(); i++) {
							HashMap map = (HashMap)costList.get(i);
							String CST_PRGRS_STTS_SE = map.get("CST_PRGRS_STTS_SE")==null?"":map.get("CST_PRGRS_STTS_SE").toString();
							String CST_GIVE_YMD = map.get("CST_GIVE_YMD")==null?"":map.get("CST_GIVE_YMD").toString();
							String CST_APRV_YMD = map.get("CST_APRV_YMD")==null?"":map.get("CST_APRV_YMD").toString();
							String CNSTN_CST_AMT = map.get("CNSTN_CST_AMT")==null?"":map.get("CNSTN_CST_AMT").toString();
							
							String CNSTN_CST_MNG_NO = map.get("CNSTN_CST_MNG_NO")==null?"":map.get("CNSTN_CST_MNG_NO").toString();
							String CNSTN_MNG_NO     = map.get("CNSTN_MNG_NO")==null?"":map.get("CNSTN_MNG_NO").toString();
							String RVW_TKCG_MNG_NO  = map.get("RVW_TKCG_MNG_NO")==null?"":map.get("RVW_TKCG_MNG_NO").toString();
							String RVW_TKCG_EMP_NO  = map.get("RVW_TKCG_EMP_NO")==null?"":map.get("RVW_TKCG_EMP_NO").toString();
				%>
					<tr>
						<td>
							<input type="hidden" name="CNSTN_CST_MNG_NO<%=i%>"  id="CNSTN_CST_MNG_NO<%=i%>"  value="<%=CNSTN_CST_MNG_NO%>">
							<input type="hidden" name="CNSTN_MNG_NO<%=i%>"      id="CNSTN_MNG_NO<%=i%>"      value="<%=CNSTN_MNG_NO%>">
							<input type="hidden" name="RVW_TKCG_MNG_NO<%=i%>"   id="RVW_TKCG_MNG_NO<%=i%>"   value="<%=RVW_TKCG_MNG_NO%>">
							<input type="hidden" name="CST_PRGRS_STTS_SE<%=i%>" id="CST_PRGRS_STTS_SE<%=i%>" value="<%=CST_PRGRS_STTS_SE%>">
							<input type="hidden" name="CNSTN_CST_AMT<%=i%>"     id="CNSTN_CST_AMT<%=i%>"     value="<%=CNSTN_CST_AMT%>">
							<input type="hidden" name="CST_APRV_YMD<%=i%>"      id="CST_APRV_YMD<%=i%>"      value="<%=CST_APRV_YMD%>">
							<input type="hidden" name="CST_GIVE_YMD<%=i%>"      id="CST_GIVE_YMD<%=i%>"      value="<%=CST_GIVE_YMD%>">
							<input type="hidden" name="RVW_TKCG_EMP_NO<%=i%>"   id="RVW_TKCG_EMP_NO<%=i%>"   value="<%=RVW_TKCG_EMP_NO%>">
							<input type="checkbox" name="chkCost[]" value="<%=i%>" />
						</td>
						<td><%=map.get("CNSTN_TTL")==null?"":map.get("CNSTN_TTL").toString()%></td>
						<td><%=map.get("LWYR_NM")==null?"":map.get("LWYR_NM").toString()%></td>
						<td style="text-align:center;"><%=map.get("VIEW_CNSTN_CST_AMT")==null?"":map.get("VIEW_CNSTN_CST_AMT").toString()%></td>
						<td style="text-align:center;"><%=map.get("CST_CLM_YMD")==null?"":map.get("CST_CLM_YMD").toString()%></td>
						<td style="text-align:center;"><%=map.get("CST_APRV_YMD")==null?"":map.get("CST_APRV_YMD").toString()%></td>
						<td style="text-align:center;"><%=map.get("CST_GIVE_YMD")==null?"":map.get("CST_GIVE_YMD").toString()%></td>
						<td style="text-align:center;"><%=map.get("CST_PRGRS_STTS_NM")==null?"":map.get("CST_PRGRS_STTS_NM").toString()%></td>
						<td style="text-align:center;">
						<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("F") > -1) {%>
						
						<%
							if ("X".equals(CST_PRGRS_STTS_SE)) {
						%>
							-
						<%
							} else if ("R".equals(CST_PRGRS_STTS_SE) || "Z".equals(CST_PRGRS_STTS_SE)) {
						%>
							<a href="#none" class="innerBtn" onclick="amtAprv('<%=CNSTN_CST_MNG_NO%>', '<%=RVW_TKCG_EMP_NO%>', '<%=CNSTN_MNG_NO%>', '<%=CNSTN_CST_AMT%>', 'A');">승인</a>
							<a href="#none" class="innerBtn" onclick="amtAprv('<%=CNSTN_CST_MNG_NO%>', '<%=RVW_TKCG_EMP_NO%>', '<%=CNSTN_MNG_NO%>', '<%=CNSTN_CST_AMT%>', 'X');">보완요청</a>
						<%
							} else if("A".equals(CST_PRGRS_STTS_SE) && CST_APRV_YMD.equals("")) {
						%>
							승인일 : 
							<input type="text" class="datepick" id="CST_APRV_YMD" name="CST_APRV_YMD" style="width: 80px;" value="">
							<a href="#none" class="innerBtn" onclick="amtAprvYmd('<%=CNSTN_CST_MNG_NO%>');">저장</a>
						<%
							} else if("A".equals(CST_PRGRS_STTS_SE) && !CST_APRV_YMD.equals("") && CST_GIVE_YMD.equals("")) {
						%>
							지급일 : 
							<input type="text" class="datepick" id="CST_GIVE_YMD" name="CST_GIVE_YMD" style="width: 80px;" value="">
							<a href="#none" class="innerBtn" onclick="amtGiveYmd('<%=CNSTN_CST_MNG_NO%>');">저장</a>
						<%
							} else if ("A".equals(CST_PRGRS_STTS_SE) && !CST_GIVE_YMD.equals("")) {
						%>
							<a href="#none" class="innerBtn" onclick="amtAprv('<%=CNSTN_CST_MNG_NO%>', '<%=RVW_TKCG_EMP_NO%>', '<%=CNSTN_MNG_NO%>', '<%=CNSTN_CST_AMT%>', 'C');">지급</a>
						<%
							}
						%>
						
						<%}else{%>
							-
						<%}%>
						</td>
					</tr>
				<%
						}
					} else {
				%>
					<tr>
						<td colspan="9">처리중인 자문료 정보가 없습니다.</td>
					</tr>
				<%
					}
				%>
				</table>
			</div>
		</div>
	</div>
</form>