<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@	page import="java.util.*"%>
<%@	page import="com.mten.util.*"%>
<%
	String searchForm  = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String getCvtnCtrtTypeNm = request.getAttribute("getCvtnCtrtTypeNm")==null?"":request.getAttribute("getCvtnCtrtTypeNm").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	HashMap agreeMap = request.getAttribute("agreeMap")==null?new HashMap():(HashMap)request.getAttribute("agreeMap");
	List agreeFileList = request.getAttribute("agreeRqstFile")==null?new ArrayList():(ArrayList)request.getAttribute("agreeRqstFile");
	String CVTN_MNG_NO = agreeMap.get("CVTN_MNG_NO")==null?"":agreeMap.get("CVTN_MNG_NO").toString();
	
	String CVTN_RQST_LAST_ATRZ_JBPS_SE = agreeMap.get("CVTN_RQST_LAST_ATRZ_JBPS_SE")==null?"":agreeMap.get("CVTN_RQST_LAST_ATRZ_JBPS_SE").toString();	// 최종결재자구분
	String CVTN_RQST_LAST_APRVR_NO = agreeMap.get("CVTN_RQST_LAST_APRVR_NO")==null?"":agreeMap.get("CVTN_RQST_LAST_APRVR_NO").toString();				// 최종결재자사번
	String CVTN_RQST_LAST_APRVR_NM = agreeMap.get("CVTN_RQST_LAST_APRVR_NM")==null?"":agreeMap.get("CVTN_RQST_LAST_APRVR_NM").toString();				// 최종결재자이름
	String INSD_OTSD_TASK_SE = agreeMap.get("INSD_OTSD_TASK_SE")==null?"":agreeMap.get("INSD_OTSD_TASK_SE").toString();									// 내외부구분
	String CVTN_CTRT_TYPE_CD_NM = agreeMap.get("CVTN_CTRT_TYPE_CD_NM")==null?"":agreeMap.get("CVTN_CTRT_TYPE_CD_NM").toString();						// 협약유형
	String RLS_YN = agreeMap.get("RLS_YN")==null?"":agreeMap.get("RLS_YN").toString();																	// 공개여부
	String OTSD_RQST_RSN = agreeMap.get("OTSD_RQST_RSN")==null?"":agreeMap.get("OTSD_RQST_RSN").toString();												// 외부의뢰사유
	String EMRG_YN = agreeMap.get("EMRG_YN")==null?"":agreeMap.get("EMRG_YN").toString();																// 긴급여부
	String CVTN_SE = agreeMap.get("CVTN_SE")==null?"":agreeMap.get("CVTN_SE").toString();																// 협약구분(일반/국제)

	String CVTN_RQST_DH_EMP_NO = agreeMap.get("CVTN_RQST_DH_EMP_NO")==null?"":agreeMap.get("CVTN_RQST_DH_EMP_NO").toString();
	String CVTN_RQST_DH_NM = agreeMap.get("CVTN_RQST_DH_NM")==null?"":agreeMap.get("CVTN_RQST_DH_NM").toString();
	String CVTN_RQST_DH_JBPS_NM = agreeMap.get("CVTN_RQST_DH_JBPS_NM")==null?"":agreeMap.get("CVTN_RQST_DH_JBPS_NM").toString();
	String CVTN_RQST_DEPT_TMLDR_JBPS_NM = agreeMap.get("CVTN_RQST_DEPT_TMLDR_JBPS_NM")==null?"":agreeMap.get("CVTN_RQST_DEPT_TMLDR_JBPS_NM").toString();
	
	// 의뢰서 작성시 등록일 위한 날짜 구하기
	LocalDate today = LocalDate.now();
	// 원하는 포맷 지정
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String regDate = today.format(formatter);
	
	String CVTN_RQST_EMP_NM  = WRTR_EMP_NM;
	String CVTN_RQST_EMP_NO  = WRTR_EMP_NO;
	String CVTN_RQST_DEPT_NM = WRT_DEPT_NM;
	String CVTN_RQST_DEPT_NO = WRT_DEPT_NO;
	String CVTN_RQST_REG_YMD = regDate;
	String CVTN_RQST_CN      = "";
	
	if(!CVTN_MNG_NO.equals("")){
		CVTN_RQST_EMP_NM  = agreeMap.get("CVTN_RQST_EMP_NM")==null?"":agreeMap.get("CVTN_RQST_EMP_NM").toString();
		CVTN_RQST_EMP_NO  = agreeMap.get("CVTN_RQST_EMP_NO")==null?"":agreeMap.get("CVTN_RQST_EMP_NO").toString();
		CVTN_RQST_DEPT_NM = agreeMap.get("CVTN_RQST_DEPT_NM")==null?"":agreeMap.get("CVTN_RQST_DEPT_NM").toString();
		CVTN_RQST_DEPT_NO = agreeMap.get("CVTN_RQST_DEPT_NO")==null?"":agreeMap.get("CVTN_RQST_DEPT_NO").toString();
		CVTN_RQST_REG_YMD = agreeMap.get("CVTN_RQST_REG_YMD")==null?"":agreeMap.get("CVTN_RQST_REG_YMD").toString();
		CVTN_RQST_CN      = agreeMap.get("CVTN_RQST_CN")==null?"":agreeMap.get("CVTN_RQST_CN").toString();
	} else {
		System.out.println("여길 타야하는데?");
		CVTN_CTRT_TYPE_CD_NM = getCvtnCtrtTypeNm;
		CVTN_RQST_CN = "  ○ 추진 경위\n     - \n\n  ○ 사업 내용(예산 편성 여부 등)\n     - 예산이 편성되어 있는 경우, 증빙 내역 첨부\n\n  ○ 근거 법령 등(권리포기나 의무부담의 근거법령 및 추진근거 등)\n     - OOO에 관한 법률 제O조\n     - 서울특별시 OOO에 관한 조례 제O조 제O항";
	}
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<style>
	*:disabled {
		background-color: darkgray;
	}
</style>
<script type="text/javascript">
	var EMRG_YN = "<%=EMRG_YN%>";
	var INSD_OTSD_TASK_SE = "<%=INSD_OTSD_TASK_SE%>";
	
	$(document).ready(function(){
		radioChg('EMRG_YN');
		radioChg('INSD_OTSD_TASK_SE');
		
		$("#listbtn").click(function(){
			var frm = document.wform;
			frm.action = "${pageContext.request.contextPath}/web/agree/goAgreeList.do";
			frm.submit();
		});
	});
	
	function agreeInfoSave() {
		if(confirm("협약 요청내용을 저장하시겠습니까?")) {
			var emrgyn = $('input[name="EMRG_YN"]:checked').val();
			
			if (emrgyn == "Y" && $("#EMRG_RQST_RSN").val() == "") {
				return alert("긴급의뢰사유를 입력하세요.");
			}
			
			$.ajax({
				type:"POST",
				url : "${pageContext.request.contextPath}/web/agree/agreeSave.do",
				data:$('#wform').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					console.log(result);
					$("#CVTN_MNG_NO").val(result.CVTN_MNG_NO);
					
					if(fileList.length == 0){
						alert(result.msg);
						document.wform.action="<%=CONTEXTPATH%>/web/agree/agreeView.do";
						document.wform.submit();
					}
					
					for (var i = 0; i < fileList.length; i++) {
						var formData = new FormData();
						formData.append("file"+i, fileList[i]);
						formData.append("CVTN_MNG_NO",     result.CVTN_MNG_NO);
						formData.append("TRGT_PST_MNG_NO", result.CVTN_MNG_NO);
						formData.append("TRGT_PST_TBL_NM", "TB_CVTN_MNG");
						formData.append("FILE_SE_NM",      "RQST");
						formData.append("SORT_SEQ", i);
						
						var status = statusList[i];
						var uploadURL = "${pageContext.request.contextPath}/web/agree/fileUpload.do";
						uploadFileFunction(status, uploadURL, formData, i, fileList.length);
					}
				}
			});
		}
	}
	
	function uploadFileFunction(status, uploadURL, formData, idx, maxIdx){
		var jqXHR = $.ajax({
			xhr:function() {
				var xhrobj = $.ajaxSettings.xhr();
				if (xhrobj.upload) {
					xhrobj.upload.addEventListener('progress', function(event) {
						var percent = 0;
						var position = event.loaded || event.position;
						var total = event.total;
						if (event.lengthComputable) {
							percent = Math.ceil(position / total * 100);
						}
						var progressBarWidth = percent * status.progressBar.width() / 100;
						status.progressBar.find('div').css({width:progressBarWidth}, 10).html(percent + "% ");
						if(parseInt(percent) >= 100){
							status.abort.hide();
						}
					}, true);
				}
				return xhrobj;
			},
			url:uploadURL,
			type:"POST",
			contentType:false,
			processData:false,
			cache:false,
			data:formData,
			async:true,
			success:function(data){
				if(idx == (maxIdx-1)){
					alert("저장이 완료되었습니다.");
					document.wform.action="<%=CONTEXTPATH%>/web/agree/agreeView.do";
					document.wform.submit();
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function selectManager(chkVal) {
		var selectedAprvrJbps = $('input[name="CVTN_RQST_LAST_ATRZ_JBPS_SE"]:checked').val();
		var firstCheck = 'Y';
		
		var cw=800;
		var ch=460;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/selectRqstDeptManagerPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"jbgd_nm",   value:selectedAprvrJbps}));
		if (chkVal == 'TM') {
			newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"agree1"}));
		} else {
			newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"agree2"}));
		}
		
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:""}));
		newForm.append($("<input/>", {type:"hidden", name:"firstCheck", value:firstCheck}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function radioChg(gbn) {
		var getData = $('input[name="'+gbn+'"]:checked').val();
		
		if(gbn == "EMRG_YN") {
			// 긴급여부
			if (getData == "Y") {
				$("#EMRG_RQST_RSN").removeAttr("disabled");
			} else {
				$("#EMRG_RQST_RSN").val("");
				$('#EMRG_RQST_RSN').attr("disabled", "disabled");
			}
		}
		
		if (gbn == "INSD_OTSD_TASK_SE") {
			// 내외부구분
			if (getData == "O") {
				$("#OTSD_RQST_RSN").removeAttr("disabled");
				$("#EXCL_DMND_JDAF_CORP_NM").removeAttr("disabled");
			} else {
				$("#OTSD_RQST_RSN").val("").prop("selected", true);
				$("#EXCL_DMND_JDAF_CORP_NM").val("");
				$('#OTSD_RQST_RSN').attr("disabled", "disabled");
				$('#EXCL_DMND_JDAF_CORP_NM').attr("disabled", "disabled");
			}
		}
	}
</script>
<style>
	
</style>
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">의회 동의 여부 사전검토 요청</strong>
		</div>
		<div class="subBtnC right" id="test">
			<a href="#none" class="sBtn type1" id="savebtn" onclick="agreeInfoSave();">저장</a>
			<a href="#none"class="sBtn type2"  id="listbtn">목록</a>
		</div>
	</div>	
	<hr class="margin40">
	<strong class="subST">의회 동의 여부 사전검토 의뢰 내용</strong>
	<div class="innerB" >
		<form name="wform" id="wform" method="post">
			<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
			<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
			<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
			<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
			<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=MENU_MNG_NO%>"/>
			<input type="hidden" name="searchForm"      id="searchForm"      value="<%=searchForm%>"/>
			<input type="hidden" name="CVTN_MNG_NO"     id="CVTN_MNG_NO"     value="<%=CVTN_MNG_NO%>"/>
			
			<input type="hidden" name="CVTN_SE"           id="CVTN_SE"           value="일반"/>
			<input type="hidden" name="INSD_OTSD_TASK_SE" id="INSD_OTSD_TASK_SE" value="I"/>
			
			<input type="hidden" name="getCvtnCtrtTypeNm"     id="getCvtnCtrtTypeNm"     value="<%=getCvtnCtrtTypeNm%>"/>
			<input type="hidden" name="CVTN_CTRT_TYPE_CD_NM"     id="CVTN_CTRT_TYPE_CD_NM"     value="<%=CVTN_CTRT_TYPE_CD_NM%>"/>
			
			<table class="infoTable write" style="width: 100%">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>의뢰자</th>
					<td>
						<input type="hidden" name="CVTN_RQST_EMP_NO" id="CVTN_RQST_EMP_NO" value="<%=CVTN_RQST_EMP_NO%>" />
						<input type="text"   name="CVTN_RQST_EMP_NM" id="CVTN_RQST_EMP_NM" value="<%=CVTN_RQST_EMP_NM%>"  readonly />
					</td>
					<th>의뢰부서</th>
					<td>
						<input type="hidden" name="CVTN_RQST_DEPT_NO" id="CVTN_RQST_DEPT_NO" value="<%=CVTN_RQST_DEPT_NO%>" />
						<input type="text" name="CVTN_RQST_DEPT_NM" id="CVTN_RQST_DEPT_NM" value="<%=CVTN_RQST_DEPT_NM%>"  readonly />
					</td>
					<th>의뢰등록일</th>
					<td>
						<input type="text" name="CVTN_RQST_REG_YMD" id="CVTN_RQST_REG_YMD" value="<%=CVTN_RQST_REG_YMD%>"  readonly />
					</td>
				</tr>
				<tr>
					<th>의뢰부서 최종검토자</th>
					<td>
						<label><input type="radio" name="CVTN_RQST_LAST_ATRZ_JBPS_SE" id="CVTN_RQST_LAST_ATRZ_JBPS_SE" value="과장" <%if(CVTN_RQST_LAST_ATRZ_JBPS_SE.equals("과장") || CVTN_RQST_LAST_ATRZ_JBPS_SE.equals(""))out.println("checked");%>>과장</label>&nbsp;
						<label><input type="radio" name="CVTN_RQST_LAST_ATRZ_JBPS_SE" id="CVTN_RQST_LAST_ATRZ_JBPS_SE" value="팀장" <%if(CVTN_RQST_LAST_ATRZ_JBPS_SE.equals("팀장"))out.println("checked");%>>팀장</label>
					</td>
					<!-- 작성자가 팀장이면 필수 등록안해도 되지만, 주무관은 팀장을 필수 입력해야함. -->
					<th>의뢰부서 과장</th>
					<td>
						<input type="hidden" name="CVTN_RQST_DH_EMP_NO" id="CVTN_RQST_DH_EMP_NO" value="<%=CVTN_RQST_DH_EMP_NO %>" readonly="readonly">
						<input type="text" name="CVTN_RQST_DH_NM" id="CVTN_RQST_DH_NM" value="<%=CVTN_RQST_DH_NM%>" readonly="readonly"/>
						<a href="#none" class="innerBtn" style="height:20px;line-height:20px;" onclick="selectManager('DH');">조회</a>
					</td>
					<th>과장 직위명</th>
					<td>
						<input type="text" name="CVTN_RQST_DH_JBPS_NM" id="CVTN_RQST_DH_JBPS_NM" style="width:100%;" value="<%=CVTN_RQST_DH_JBPS_NM%>"/>
					</td>
				</tr>
				<tr>
					<th>공개여부</th>
					<td>
						<label><input type="radio" name="RLS_YN" id="RLS_YN" value="Y" <%if(RLS_YN.equals("") || "Y".equals(RLS_YN))out.println("checked");%>>공개</label>&nbsp;
						<label><input type="radio" name="RLS_YN" id="RLS_YN" value="N" <%if("N".equals(RLS_YN))out.println("checked");%>>비공개</label>
					</td>
					<th>의뢰부서 팀장</th>
					<td>
						<input type="hidden" name="CVTN_RQST_LAST_APRVR_NO" id="CVTN_RQST_LAST_APRVR_NO" value="<%=CVTN_RQST_LAST_APRVR_NO%>" />
						<input type="text"   name="CVTN_RQST_LAST_APRVR_NM" id="CVTN_RQST_LAST_APRVR_NM" value="<%=CVTN_RQST_LAST_APRVR_NM%>"  readonly />
						<a href="#none" class="innerBtn" style="height:20px;line-height:20px;" onclick="selectManager('TM');">조회</a>
					</td>
					<th>팀장 직위명</th>
					<td>
						<input type="text" name="CVTN_RQST_DEPT_TMLDR_JBPS_NM" id="CVTN_RQST_DEPT_TMLDR_JBPS_NM" style="width:100%;" value="<%=CVTN_RQST_DEPT_TMLDR_JBPS_NM%>"/>
					</td>
				</tr>
				<tr>
					<th>관리자 검색 키워드</th>
					<td colspan="5">
						<input type="text" id="PRVT_SRCH_KYWD_CN" name="PRVT_SRCH_KYWD_CN"  value="<%=agreeMap.get("PRVT_SRCH_KYWD_CN")==null?"":agreeMap.get("PRVT_SRCH_KYWD_CN").toString()%>" style="width:100%;"/>
					</td>
				</tr>
				<tr>
					<th>협약(MOU)명</th>
					<td colspan="3">
						<input type="text" id="CVTN_TTL" name="CVTN_TTL" value="<%=agreeMap.get("CVTN_TTL")==null?"":agreeMap.get("CVTN_TTL").toString()%>" style="width:100%;"/>
					</td>
					<th>협약체결예정일</th>
					<td>
						<input type="text" id="CVTN_CNCLS_PRNMNT_YMD" name="CVTN_CNCLS_PRNMNT_YMD" value="<%=agreeMap.get("CVTN_CNCLS_PRNMNT_YMD")==null?"":agreeMap.get("CVTN_CNCLS_PRNMNT_YMD").toString()%>" style="width:80%;" class="datepick" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th>근거 법률 또는 조례</th>
					<td colspan="5">
						<textarea id="CVTN_SRNG_DMND_CN" name="CVTN_SRNG_DMND_CN" rows="8" cols="" style="width:100%;"><%=agreeMap.get("CVTN_SRNG_DMND_CN")==null?"":agreeMap.get("CVTN_SRNG_DMND_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>예산 편성 여부</th>
					<td colspan="5">
						<textarea id="RMRK_CN" name="RMRK_CN" rows="8" cols="" style="width:100%;"><%=agreeMap.get("RMRK_CN")==null?"":agreeMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>의뢰배경</th>
					<td colspan="5">
						<textarea id="CVTN_RQST_CN" name="CVTN_RQST_CN" rows="8" cols="" style="width:100%;"><%=CVTN_RQST_CN%></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td colspan="5">
						<div id="fileUpload" class="dragAndDropDiv">
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:49%;">
							<%
								for(int i=0; i<agreeFileList.size(); i++){
									HashMap result = (HashMap)agreeFileList.get(i);
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'><%=result.get("PHYS_FILE_NM") %></div><div class="abort"><input type="checkbox" name="delfile[]" value="<%=result.get("FILE_MNG_NO") %>"/>　삭제</div>
							</div>
							<%
								}
							%>
						</div>
						<div id="hkk" class="hkk"></div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
