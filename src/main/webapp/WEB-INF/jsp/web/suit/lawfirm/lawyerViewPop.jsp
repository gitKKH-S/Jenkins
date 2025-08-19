<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String LWYR_MNG_NO = request.getAttribute("LWYR_MNG_NO")==null?"":request.getAttribute("LWYR_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	
	HashMap lawyerMap = request.getAttribute("lawyerMap")==null?new HashMap():(HashMap)request.getAttribute("lawyerMap");
	List bankList = request.getAttribute("bankList")==null?new ArrayList():(ArrayList)request.getAttribute("bankList");
	List agtList = request.getAttribute("agtList")==null?new ArrayList():(ArrayList)request.getAttribute("agtList");
	List tnrList = request.getAttribute("tnrList")==null?new ArrayList():(ArrayList)request.getAttribute("tnrList");
	
	String LWYR_SE = lawyerMap.get("LWYR_SE")==null?"":lawyerMap.get("LWYR_SE").toString();
	String LWYR_CTRT_STTS_NM = lawyerMap.get("LWYR_CTRT_STTS_NM")==null?"":lawyerMap.get("LWYR_CTRT_STTS_NM").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();	
%>
<style>
	.chrgSuit{max-height:150px; overflow-y:scroll;}
</style>
<script type="text/javascript">
	var LWYR_MNG_NO = '<%=LWYR_MNG_NO%>';
	
	function goList(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/golawyerList.do";
		document.frm.submit();
	}
	
	function editLawyerInfo(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/lawyerWritePage.do";
		document.frm.submit();
	}
	
	function delLawyerInfo(){
		if(confirm("등록 된 변호사 정보를 삭제 하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteLawyerInfo.do",
				data:{LWYR_MNG_NO:LWYR_MNG_NO},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					goList();
				}
			});
		}
	}
	
	function setViewYn(gbn, agtNo, yn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/setViewYn.do",
			data:{AGT_MNG_NO:agtNo, PRSL_PSBLTY_YN:yn, gbn:gbn},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				location.reload(true);
			}
		});
	}
	
	function goAgtPop(gbn, pk1, pk2) {
		if(gbn == "SUIT") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "agtInfo");
			newForm.attr("action", CONTEXTPATH+"/web/suit/caseViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:pk1}));
			newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:pk2}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "AGREE") {
			// 자문 팝업
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","agtInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "agtInfo");
			newForm.attr("action", CONTEXTPATH+"/web/agree/agreeViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:pk1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "CONSULT") {
			// 자문 팝업
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "agtInfo");
			newForm.attr("action", CONTEXTPATH+"/web/consult/consultViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"consultid", value:pk1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	}
	
	$(document).ready(function(){
		
	});
</script>
<form id="frm" name="frm" method="post" action=""> 
	<input type="hidden" name="LWYR_MNG_NO"   id="LWYR_MNG_NO"   value="<%=LWYR_MNG_NO%>" />
	<input type="hidden" name="MENU_MNG_NO"   id="MENU_MNG_NO"   value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"   id="WRTR_EMP_NO"   value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"   id="WRT_DEPT_NM"   value="<%=WRT_DEPT_NM%>" />
	<div class="subCA">
		<strong id="subTT" class="subTT"><%=lawyerMap.get("LWYR_NM")==null?"":lawyerMap.get("LWYR_NM").toString()%> 변호사 정보</strong>
		<div class="innerB">
			<table class="infoTable" style="width:100%">
				<colgroup>
					<col style="width:15%;">
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<td rowspan="7">
						<img style="width:100%;" id="profile" src="<%=CONTEXTPATH%>/dataFile/suit/<%=lawyerMap.get("PHOTO_MNG_PATH_NM")==null?"":lawyerMap.get("PHOTO_MNG_PATH_NM").toString()%>">
					</td>
					<th>이름</th>
					<td><%=lawyerMap.get("LWYR_NM")==null?"":lawyerMap.get("LWYR_NM").toString()%></td>
					<th>소속</th>
					<td><%=lawyerMap.get("JDAF_CORP_NM")==null?"":lawyerMap.get("JDAF_CORP_NM").toString()%></td>
				</tr>
				<tr>
					<th>구분</th>
					<td>
						<%
							if("Y".equals(LWYR_SE)) {
								out.println("고문");
							} else {
								out.println("일반");
							}
						%>
					</td>
					<th>성별</th>
					<td>
						<%=lawyerMap.get("GNDR_SE")==null?"":lawyerMap.get("GNDR_SE").toString()%>
					</td>
				</tr>
				<tr>
					<th>출생연도</th>
					<td><%=lawyerMap.get("BRDT")==null?"":lawyerMap.get("BRDT").toString()%></td>
					<th>합격연도</th>
					<td>
						<%=lawyerMap.get("TEST_SE_NM")==null?"":lawyerMap.get("TEST_SE_NM").toString()%>&nbsp;
						<%=lawyerMap.get("TEST_PASS_YR")==null?"":lawyerMap.get("TEST_PASS_YR").toString()%>년&nbsp;
						<%=lawyerMap.get("TEST_PASS_CYCL")==null?"":lawyerMap.get("TEST_PASS_CYCL").toString()%>차
					</td>
				</tr>
				
				<tr>
					<td colspan="4">
						<table class="infoTable" style="width:100%">
							<colgroup>
								<col style="width:10%">
								<col style="width:*;">
								<col style="width:10%">
								<col style="width:*;">
							</colgroup>
						<%
							if(tnrList.size() > 0) {
								for (int i=0; i<tnrList.size(); i++) {
									HashMap tnrMap = (HashMap)tnrList.get(i);
						%>
								<tr>
									<th>위촉일</th>
									<td><%=tnrMap.get("ENTRST_BGNG_YMD")==null?"":tnrMap.get("ENTRST_BGNG_YMD").toString()%></td>
									<th>임기만료(해촉일)</th>
									<td><%=tnrMap.get("ENTRST_END_YMD")==null?"":tnrMap.get("ENTRST_END_YMD").toString()%></td>
								</tr>
						<%
								}
							} else {
						%>
								<tr>
									<td colspan="4">등록 된 임기 정보가 없습니다.</td>
								</tr>
						<%
							}
						%>
						</table>
					</td>
				</tr>
				
				<tr>
					<th>계약상태</th>
					<td colspan="3">
					<%
						if ("Y".equals(LWYR_CTRT_STTS_NM)) {
							out.println("임기중");
						} else if ("N".equals(LWYR_CTRT_STTS_NM)) {
							out.println("해촉");
						} else if ("A".equals(LWYR_CTRT_STTS_NM)) {
							out.println("해촉(사임)");
						}
					%>
					</td>
				</tr>
				
				<tr>
					<th>휴대전화번호</th>
					<td><%=lawyerMap.get("MBL_TELNO")==null?"":lawyerMap.get("MBL_TELNO").toString()%></td>
					<th>이메일</th>
					<td><%=lawyerMap.get("EML_ADDR")==null?"":lawyerMap.get("EML_ADDR").toString()%></td>
				</tr>
				<tr>
					<th>사무실 전화번호</th>
					<td><%=lawyerMap.get("OFC_TELNO")==null?"":lawyerMap.get("OFC_TELNO").toString()%></td>
					<th>사무실 팩스번호</th>
					<td><%=lawyerMap.get("OFC_FXNO")==null?"":lawyerMap.get("OFC_FXNO").toString()%></td>
				</tr>
			</table>
			
			<table class="infoTable" style="width:100%">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>전문분야</th>
					<td>
						<%=lawyerMap.get("ARSP_NM_NM")==null?"":lawyerMap.get("ARSP_NM_NM").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>경력</th>
					<td>
						<%=lawyerMap.get("CRR_MTTR")==null?"":lawyerMap.get("CRR_MTTR").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>학력</th>
					<td>
						<%=lawyerMap.get("ACBG_CN")==null?"":lawyerMap.get("ACBG_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>특별분야</th>
					<td>
						<%=lawyerMap.get("SPC_FLD_NM")==null?"":lawyerMap.get("SPC_FLD_NM").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				
				<tr>
					<th>국제법률자문</th>
					<td>
						<table class="infoTable" style="width:100%">
							<colgroup>
								<col style="width:12%;">
								<col style="width:*;">
							</colgroup>
							<tr>
								<th>법률고문</th>
								<td>
									<%=lawyerMap.get("LWYR_INTL_CNSTN_CN")==null?"":lawyerMap.get("LWYR_INTL_CNSTN_CN").toString()%>
								</td>
							</tr>
							<tr>
								<th>소속법인</th>
								<td>
									<%=lawyerMap.get("CORP_INTL_CNSTN_CN")==null?"":lawyerMap.get("CORP_INTL_CNSTN_CN").toString()%>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>지적재산권법률자문</th>
					<td>
						<table class="infoTable" style="width:100%">
							<colgroup>
								<col style="width:12%;">
								<col style="width:*;">
							</colgroup>
							<tr>
								<th>법률고문</th>
								<td>
									<%=lawyerMap.get("LWYR_IPR_CNSTN_CN")==null?"":lawyerMap.get("LWYR_IPR_CNSTN_CN").toString()%>
								</td>
							</tr>
							<tr>
								<th>소속법인</th>
								<td>
									<%=lawyerMap.get("CORP_IPR_CNSTN_CN")==null?"":lawyerMap.get("CORP_IPR_CNSTN_CN").toString()%>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>소속법인 변호사수(명)</th>
					<td>
						<%=lawyerMap.get("OGDP_CORP_LWYR_CNT")==null?"":lawyerMap.get("OGDP_CORP_LWYR_CNT").toString()%>
					</td>
				</tr>
				<tr>
					<th>담당직원 이메일</th>
					<td>
						<%=lawyerMap.get("TKCG_EMP_EML_ADDR_CN")==null?"":lawyerMap.get("TKCG_EMP_EML_ADDR_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td>
						<%=lawyerMap.get("RMRK_CN")==null?"":lawyerMap.get("RMRK_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>24.7.10.이후<br/>(누적5회)<br/> 민원야기</th>
					<td>
						<%=lawyerMap.get("CVLCPT_CN")==null?"":lawyerMap.get("CVLCPT_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>24.7.10.이후<br/>(소송자문 거절 10회이상)<br/>거절횟수</th>
					<td>
						<%=lawyerMap.get("ACAP_RFSL_CN")==null?"":lawyerMap.get("ACAP_RFSL_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>계좌정보</th>
					<td>
						<table class="infoTable" id="empTable">
							<colgroup>
								<col style="width:10%;">
								<col style="width:15%;">
								<col style="width:*;">
								<col style="width:*;">
								<col style="width:20%;">
							</colgroup>
							<tr>
								<th style="text-align:center;">은행명</th>
								<th style="text-align:center;">예금주명</th>
								<th style="text-align:center;">계좌번호</th>
								<th style="text-align:center;">사용여부</th>
								<th style="text-align:center;">비고</th>
							</tr>
						<%
							if(bankList.size() > 0) {
								for (int i=0; i<bankList.size(); i++) {
									HashMap bankMap = (HashMap)bankList.get(i);
						%>
								<tr>
									<td><%=bankMap.get("BANK_NM")==null?"":bankMap.get("BANK_NM").toString()%></td>
									<td><%=bankMap.get("DPSTR_NM")==null?"":bankMap.get("DPSTR_NM").toString()%></td>
									<td><%=bankMap.get("ACTNO")==null?"":bankMap.get("ACTNO").toString()%></td>
									<td><%=bankMap.get("USE_YN")==null?"":bankMap.get("USE_YN").toString()%></td>
									<td><%=bankMap.get("RMRK_CN")==null?"":bankMap.get("RMRK_CN").toString()%></td>
								</tr>
						<%
								}
							} else {
						%>
								<tr>
									<td colspan="5">등록 된 계좌 정보가 없습니다.</td>
								</tr>
						<%
							}
						%>
							</table>
					</td>
				</tr>
			</table>
		</div>
	</div>
</form>