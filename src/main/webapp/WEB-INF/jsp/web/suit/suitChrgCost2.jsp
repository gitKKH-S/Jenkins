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
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/goSuitChrgCost.do";
		document.frm.submit();
	}
	
	//비용 승인여부 처리
	function amtAprv(AGT_MNG_NO, LWS_MNG_NO, INST_MNG_NO, gbn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/updateChrgLawyerAmt.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				AGT_MNG_NO:AGT_MNG_NO,
				APRV_YN:gbn
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				reload();
			}
		});
	}
	
	// 비용 지급여부 처리
	function amtGive(AGT_MNG_NO, LWS_MNG_NO, INST_MNG_NO, gbn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/updateChrgLawyerAmt.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				AGT_MNG_NO:AGT_MNG_NO,
				GIVE_YN:gbn
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				reload();
			}
		});
	}
	
	// 비용 지급일자 처리
	function amtGiveYmd(AGT_MNG_NO, LWS_MNG_NO, INST_MNG_NO) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/updateChrgLawyerAmt.do",
			data:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				AGT_MNG_NO:AGT_MNG_NO,
				GIVE_YMD:$("#GIVE_YMD").val()
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
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
			
			var LWS_MNG_NO_LIST  = [];
			var INST_MNG_NO_LIST = [];
			var AGT_MNG_NO_LIST  = [];
			
			for (let i = 0; i < checkboxes.length; i++) {
				if (checkboxes[i].checked) {
					if ($("#APRV_YN"+checkboxes[i].value).val() == "N" 
							|| $("#APRV_YN"+checkboxes[i].value) == "R" 
							|| $("#APRV_YN"+checkboxes[i].value) == "Y") {
						$("#loading").hide();
						return alert("승인처리 할 수 없는 상태의 항목이 체크되었습니다.");
					} else {
						LWS_MNG_NO_LIST.push($("#LWS_MNG_NO"+checkboxes[i].value).val());
						INST_MNG_NO_LIST.push($("#INST_MNG_NO"+checkboxes[i].value).val());
						AGT_MNG_NO_LIST.push($("#AGT_MNG_NO"+checkboxes[i].value).val());
					}
				}
			}
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/updateChrgLawyerAmtList.do",
				data:{
					LWS_MNG_NO_LIST:LWS_MNG_NO_LIST,
					INST_MNG_NO_LIST:INST_MNG_NO_LIST,
					AGT_MNG_NO_LIST:AGT_MNG_NO_LIST,
					APRV_YN:"Y"
				},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
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
			
			var LWS_MNG_NO_LIST  = [];
			var INST_MNG_NO_LIST = [];
			var AGT_MNG_NO_LIST  = [];
			
			for (let i = 0; i < checkboxes.length; i++) {
				if (checkboxes[i].checked) {
					if ($("#APRV_YN"+checkboxes[i].value).val() != "Y") {
						$("#loading").hide();
						return alert("지급 할 수 없는 상태의 항목이 체크되었습니다.");
					} if ($("#GIVE_YMD"+checkboxes[i].value).val() == "") {
						$("#loading").hide();
						return alert("지급일이 등록되지 않은 항목이 체크되었습니다.");
					} else {
						LWS_MNG_NO_LIST.push($("#LWS_MNG_NO"+checkboxes[i].value).val());
						INST_MNG_NO_LIST.push($("#INST_MNG_NO"+checkboxes[i].value).val());
						AGT_MNG_NO_LIST.push($("#AGT_MNG_NO"+checkboxes[i].value).val());
					}
				}
			}
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/updateChrgLawyerAmtList.do",
				data:{
					LWS_MNG_NO_LIST:LWS_MNG_NO_LIST,
					INST_MNG_NO_LIST:INST_MNG_NO_LIST,
					AGT_MNG_NO_LIST:AGT_MNG_NO_LIST,
					GIVE_YN:"Y"
				},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
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
			<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1) {%>
				<a href="#none" class="sBtn type1" onclick="chkAprvY();">일괄승인</a>
			<%}%>
			<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("D") > -1) {%>
				<a href="#none" class="sBtn type4" onclick="chkGive();">일괄지급</a>
			<%}%>
			</div>
		</div>
		<hr class="margin10">
		<div class="innerB">
			<div>
				<div id="subTitle"><strong class="countT">수임료 신청 목록</strong></div>
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
						<col style="width:8%;">
						<col style="width:8%;">
						<col style="width:12%;">
					</colgroup>
					<tr>
						<th></th>
						<th>사건명</th>
						<th>변호사</th>
						<th>신청착수금</th>
						<th>신청성공보수</th>
						<th>신청수임료</th>
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
							String APRV_YN = map.get("APRV_YN")==null?"":map.get("APRV_YN").toString();
							String GIVE_YMD = map.get("GIVE_YMD")==null?"":map.get("GIVE_YMD").toString();
							
							String AGT_MNG_NO = map.get("AGT_MNG_NO")==null?"":map.get("AGT_MNG_NO").toString();
							String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
							String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
				%>
					<tr>
						<td>
							<input type="hidden" name="AGT_MNG_NO<%=i%>"  id="AGT_MNG_NO<%=i%>"  value="<%=AGT_MNG_NO%>">
							<input type="hidden" name="LWS_MNG_NO<%=i%>"  id="LWS_MNG_NO<%=i%>"  value="<%=LWS_MNG_NO%>">
							<input type="hidden" name="INST_MNG_NO<%=i%>" id="INST_MNG_NO<%=i%>" value="<%=INST_MNG_NO%>">
							<input type="hidden" name="APRV_YN<%=i%>"     id="APRV_YN<%=i%>"     value="<%=APRV_YN%>">
							<input type="hidden" name="GIVE_YMD<%=i%>"    id="GIVE_YMD<%=i%>"    value="<%=GIVE_YMD%>">
							<input type="checkbox" name="chkCost[]" value="<%=i%>" />
						</td>
						<td><%=map.get("CASE_NAME")==null?"":map.get("CASE_NAME").toString()%></td>
						<td><%=map.get("LWYR_NM")==null?"":map.get("LWYR_NM").toString()%></td>
						<td style="text-align:center;"><%=map.get("VIEW_OTST_AMT")==null?"":map.get("VIEW_OTST_AMT").toString()%></td>
						<td style="text-align:center;"><%=map.get("VIEW_SCS_PAY_AMT")==null?"":map.get("VIEW_SCS_PAY_AMT").toString()%></td>
						<td style="text-align:center;"><%=map.get("VIEW_ACAP_AMT")==null?"":map.get("VIEW_ACAP_AMT").toString()%></td>
						<td style="text-align:center;"><%=map.get("GIVE_APLY_YMD")==null?"":map.get("GIVE_APLY_YMD").toString()%></td>
						<td style="text-align:center;"><%=map.get("APRV_YMD")==null?"":map.get("APRV_YMD").toString()%></td>
						<td style="text-align:center;"><%=map.get("GIVE_YMD")==null?"":map.get("GIVE_YMD").toString()%></td>
						<td style="text-align:center;"><%=map.get("VIEW_APRV_YN")==null?"":map.get("VIEW_APRV_YN").toString()%></td>
						<td style="text-align:center;">
						<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1) {%>
							<%if ("N".equals(APRV_YN) || "R".equals(APRV_YN)) {%>
							-
							<%} else if ("G".equals(APRV_YN) || "T".equals(APRV_YN)) {%>
							<a href="#none" class="innerBtn" onclick="amtAprv('<%=AGT_MNG_NO%>', '<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>', 'Y');">승인</a>
							<a href="#none" class="innerBtn" onclick="amtAprv('<%=AGT_MNG_NO%>', '<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>', 'R');">보완요청</a>
							<%}%>
						<%}%>
						
						<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("D") > -1) {%>
							<%if("Y".equals(APRV_YN) && GIVE_YMD.equals("")) {%>
							<input type="text" class="datepick" id="GIVE_YMD" name="GIVE_YMD" style="width: 80px;" value="">
							<a href="#none" class="innerBtn" onclick="amtGiveYmd('<%=AGT_MNG_NO%>', '<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">저장</a>
							<%} else if ("Y".equals(APRV_YN) && !GIVE_YMD.equals("") {%>
							<a href="#none" class="innerBtn" onclick="amtGive('<%=AGT_MNG_NO%>', '<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>', 'Y');">지급</a>
							<%} else {%>
								-
							<%}%>
						<%}%>
						
						<%if(GRPCD.indexOf("Y") == -1 && GRPCD.indexOf("C") == -1 && GRPCD.indexOf("D") == -1) {%>
							-
						<%}%>
						</td>
					</tr>
				<%
						}
					} else {
				%>
					<tr>
						<td colspan="10">처리중인 수임료 정보가 없습니다.</td>
					</tr>
				<%
					}
				%>
				</table>
			</div>
		</div>
	</div>
</form>