<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
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
	
	ResourceBundle bundles   =  ResourceBundle.getBundle("egovframework.property.url");
	String path = bundles.getString("mten.SUIT");
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
	<input type="hidden" name="LWYR_MNG_NO" id="LWYR_MNG_NO" value="<%=LWYR_MNG_NO%>" />
	
	<input type="hidden" name="MENU_MNG_NO"   id="MENU_MNG_NO"   value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"   id="WRTR_EMP_NO"   value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"   id="WRT_DEPT_NM"   value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="searchForm"    id="searchForm"    value="<%=searchForm%>"/>
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="subBtnC right">
		<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("I") > -1){%>
			<a href="#none" class="sBtn type1" onclick="editLawyerInfo();">수정</a>
			<a href="#none" class="sBtn type3" onclick="delLawyerInfo();">삭제</a>
		<%}%>
			<a href="#none" class="sBtn type2" onclick="goList();">목록</a>
		</div>
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
					<th>메모</th>
					<td colspan="4" style="color: red;">
						<%=lawyerMap.get("MEMO_CN")==null?"":lawyerMap.get("MEMO_CN").toString()%>
					</td>
				</tr>
				<tr>
					<td rowspan="7">
					<%
						String filenm = lawyerMap.get("PHOTO_MNG_PATH_NM")==null?"":lawyerMap.get("PHOTO_MNG_PATH_NM").toString();
						if (filenm.equals("")) {
					%>
						등록된 프로필 사진이 없습니다.
					<%
						} else {
					%>
						<img style="width:100%;" id="profile" src="<%=CONTEXTPATH%>/dataFile/suit/<%=lawyerMap.get("PHOTO_MNG_PATH_NM")==null?"":lawyerMap.get("PHOTO_MNG_PATH_NM").toString()%>">
					<%
						}
					%>
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
						<%
							String testSeNm = lawyerMap.get("TEST_SE_NM")==null?"":lawyerMap.get("TEST_SE_NM").toString();
							String testPassYr = lawyerMap.get("TEST_PASS_YR")==null?"":lawyerMap.get("TEST_PASS_YR").toString();
							String testPassCycl = lawyerMap.get("TEST_PASS_CYCL")==null?"":lawyerMap.get("TEST_PASS_CYCL").toString();
							String viewText = "";
							
							if("사법시험".equals(testSeNm)) {
								viewText = testPassYr+"(제"+testPassCycl+"회)";
							} else if ("변호사시험".equals(testSeNm)) {
								viewText = testPassYr+"(변시"+testPassCycl+"회)";
							} else if ("군법무관".equals(testSeNm)) {
								viewText = "군법무관(제"+testPassCycl+"기)";
							}
							
							out.println(viewText);
						%>
						<%-- 
						<%=lawyerMap.get("TEST_SE_NM")==null?"":lawyerMap.get("TEST_SE_NM").toString()%>&nbsp;
						<%=lawyerMap.get("TEST_PASS_YR")==null?"":lawyerMap.get("TEST_PASS_YR").toString()%>년&nbsp;
						<%=lawyerMap.get("TEST_PASS_CYCL")==null?"":lawyerMap.get("TEST_PASS_CYCL").toString()%>차
						 --%>
					</td>
				</tr>
				
				<tr>
					<td colspan="4">
						<table class="infoTable" style="width:100%">
							<colgroup>
								<col style="width:13%">
								<col style="width:*;">
								<col style="width:13%">
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
					<td>
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
					<th>아이디</th>
					<td>
						<%=lawyerMap.get("LGN_ID")==null?"":lawyerMap.get("LGN_ID").toString()%>
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
				<tr id="chrgSuit">
					<th>담당 업무</th>
					<td>
						<table class="infoTable" style="margin:10px; width:98%;" id="suitList">
							<colgroup>
								<col style="width:10%;">
								<col style="width:*;">
								<col style="width:20%;">
								<col style="width:10%;">
								<col style="width:10%;">
							</colgroup>
							<tr>
								<th class="chrgList">문서구분</th>
								<th class="chrgList">문서명</th>
								<th class="chrgList">요청부서</th>
								<th class="chrgList">진행상태</th>
								<th class="chrgList">열람권한</th>
							</tr>
					<%
						if(agtList.size() > 0) {
							for(int i=0; i<agtList.size(); i++) {
								HashMap agtMap = (HashMap)agtList.get(i);
								String PRSL_PSBLTY_YN = agtMap.get("PRSL_PSBLTY_YN")==null?"":agtMap.get("PRSL_PSBLTY_YN").toString();
								String LAWYER_PK = agtMap.get("LAWYER_PK")==null?"":agtMap.get("LAWYER_PK").toString();
								String DOC_GBN = agtMap.get("DOC_GBN")==null?"":agtMap.get("DOC_GBN").toString();
								String DOC_NO1 = agtMap.get("DOC_NO1")==null?"":agtMap.get("DOC_NO1").toString();
								String DOC_NO2 = agtMap.get("DOC_NO2")==null?"":agtMap.get("DOC_NO2").toString();
								String DocGbnHan = "";
								if ("SUIT".equals(DOC_GBN)) {
									DocGbnHan = "소송";
								} else if ("AGREE".equals(DOC_GBN)) {
									DocGbnHan = "협약";
								} else if ("CONSULT".equals(DOC_GBN)) {
									DocGbnHan = "자문";
								}
					%>
							<tr>
								<td><%=DocGbnHan%></td>
								<td onclick="goAgtPop('<%=DOC_GBN%>', '<%=DOC_NO1%>', '<%=DOC_NO2%>')">
									<%=agtMap.get("DOC_NM")==null?"":agtMap.get("DOC_NM").toString()%>
								</td>
								<td><%=agtMap.get("EMP_NM")==null?"":agtMap.get("EMP_NM").toString()%></td>
								<td><%=agtMap.get("PRGRS_STTS")==null?"":agtMap.get("PRGRS_STTS").toString()%></td>
								<td>
									<select name="PRSL_PSBLTY_YN" onchange="setViewYn('<%=DOC_GBN%>', '<%=LAWYER_PK%>', this.value);">
										<option value="Y" <%if("Y".equals(PRSL_PSBLTY_YN) || PRSL_PSBLTY_YN.equals("")) out.println("selected");%>>Y</option>
										<option value="N" <%if("N".equals(PRSL_PSBLTY_YN)) out.println("selected");%>>N</option>
									</select>
								</td>
							</tr>
					<%
							}
						} else {
					%>
							<tr>
								<td colspan="5">담당중인 업무가 없습니다.</td>
							</tr>
					<%
						}
					%>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div class="subBtnW center">
		<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("I") > -1){%>
			<a href="#none" class="sBtn type1" onclick="editLawyerInfo();">수정</a>
			<a href="#none" class="sBtn type3" onclick="delLawyerInfo();">삭제</a>
		<%}%>
			<a href="#none" class="sBtn type2" onclick="goList();">목록</a>
		</div>
	</div>
</form>