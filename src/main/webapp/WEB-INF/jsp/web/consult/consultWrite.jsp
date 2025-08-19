<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>

<%

	HashMap se = (HashMap)session.getAttribute("userInfo");
	System.out.println(se);
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String OPHONE = se.get("INPHONE")==null?"":se.get("INPHONE").toString();
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String DEPTNAME = se.get("DEPTNAME")==null?"":se.get("DEPTNAME").toString();
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
	String writer = request.getAttribute("writer")==null?"":request.getAttribute("writer").toString();
	String writerid = request.getAttribute("writerid")==null?"":request.getAttribute("writerid").toString();
	String deptname = request.getAttribute("deptname")==null?"":request.getAttribute("deptname").toString();
	String deptid = request.getAttribute("deptid")==null?"":request.getAttribute("deptid").toString();
	
	// 자문 기본 정보
	HashMap consultinfo = request.getAttribute("consultinfo")==null?new HashMap():(HashMap)request.getAttribute("consultinfo");
	String consultid = consultinfo.get("CNSTN_MNG_NO")==null?"":consultinfo.get("CNSTN_MNG_NO").toString();
	String rls_yn = consultinfo.get("RLS_YN")==null?"":consultinfo.get("RLS_YN").toString();
	String insd_otsd_task_se = consultinfo.get("INSD_OTSD_TASK_SE")==null?"":consultinfo.get("INSD_OTSD_TASK_SE").toString();
// 	String phone = consult.get("PHONE")==null?"":consult.get("PHONE").toString();
	String emrg_yn = consultinfo.get("EMRG_YN")==null?"":consultinfo.get("EMRG_YN").toString();
	String rqst_dept_last_aprvr_jbps_nm = consultinfo.get("RQST_DEPT_LAST_APRVR_JBPS_NM")==null?"":consultinfo.get("RQST_DEPT_LAST_APRVR_JBPS_NM").toString();
	String prvt_srch_kywd_cn = consultinfo.get("PRVT_SRCH_KYWD_CN")==null?"":consultinfo.get("PRVT_SRCH_KYWD_CN").toString();
	String otsd_rqst_rsn = consultinfo.get("OTSD_RQST_RSN")==null?"":consultinfo.get("OTSD_RQST_RSN").toString();
	String cnstn_ttl = consultinfo.get("CNSTN_TTL")==null?"":consultinfo.get("CNSTN_TTL").toString();
	String cnstn_rqst_cn = consultinfo.get("CNSTN_RQST_CN")==null?"":consultinfo.get("CNSTN_RQST_CN").toString();
	String cnstn_rqst_subst_cn = consultinfo.get("CNSTN_RQST_SUBST_CN")==null?"":consultinfo.get("CNSTN_RQST_SUBST_CN").toString();
	String rmrk_cn = consultinfo.get("RMRK_CN")==null?"":consultinfo.get("RMRK_CN").toString();
	String cnstn_rqst_dept_tmldr_nm = consultinfo.get("CNSTN_RQST_DEPT_TMLDR_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_TMLDR_NM").toString();
	String cnstn_rqst_dept_tmldr_emp_no = consultinfo.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO")==null?"":consultinfo.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO").toString();
	String excl_dmnd_jdaf_corp_nm = consultinfo.get("EXCL_DMND_JDAF_CORP_NM")==null?"":consultinfo.get("EXCL_DMND_JDAF_CORP_NM").toString();
	String emrg_rsn = consultinfo.get("EMRG_RSN")==null?"":consultinfo.get("EMRG_RSN").toString();
	String cnstn_se_nm = consultinfo.get("CNSTN_SE_NM")==null?"":consultinfo.get("CNSTN_SE_NM").toString();
	String cnstn_rqst_dh_emp_no = consultinfo.get("CNSTN_RQST_DH_EMP_NO")==null?"":consultinfo.get("CNSTN_RQST_DH_EMP_NO").toString();
	String cnstn_rqst_dh_nm = consultinfo.get("CNSTN_RQST_DH_NM")==null?"":consultinfo.get("CNSTN_RQST_DH_NM").toString();
	String cnstn_rqst_dh_jbps_nm = consultinfo.get("CNSTN_RQST_DH_JBPS_NM")==null?"":consultinfo.get("CNSTN_RQST_DH_JBPS_NM").toString();
	String cnstn_rqst_dept_tmldr_telno = consultinfo.get("CNSTN_RQST_DEPT_TMLDR_TELNO")==null?"":consultinfo.get("CNSTN_RQST_DEPT_TMLDR_TELNO").toString();
	String cnstn_rqst_dept_tmldr_jbps_nm = consultinfo.get("CNSTN_RQST_DEPT_TMLDR_JBPS_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_TMLDR_JBPS_NM").toString();
	
	HashMap deptHeadInfo = request.getAttribute("deptHeadinfo")==null?new HashMap():(HashMap)request.getAttribute("deptHeadinfo");
	String dept_head_emp_no = deptHeadInfo.get("EMP_NO")==null?"":deptHeadInfo.get("EMP_NO").toString();
	String dept_head_emp_nm = deptHeadInfo.get("EMP_NM")==null?"":deptHeadInfo.get("EMP_NM").toString();
	String dept_head_wrc_telno = deptHeadInfo.get("WRC_TELNO")==null?"":deptHeadInfo.get("WRC_TELNO").toString();
	String dept_head_wrc_jbgd_nm = deptHeadInfo.get("JBGD_NM")==null?"":deptHeadInfo.get("JBGD_NM").toString();
	
	// 의뢰서 작성시 등록일 위한 날짜 구하기
    LocalDate today = LocalDate.now();
    // 원하는 포맷 지정
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
//     DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년MM월dd일");
    String regDate = today.format(formatter);
	
	//자문 기본 정보
// 	HashMap consult = consultinfo.get("consult")==null?new HashMap():(HashMap)consultinfo.get("consult");
	List fileList = request.getAttribute("fileList")==null?new ArrayList():(ArrayList)request.getAttribute("fileList");
	
	writer = USERNAME;
	String writerNo = USERNO;
	String deptnm = DEPTNAME;
	String deptnmNo = DEPTCD;
// 	String phone = OPHONE;
	rls_yn = "Y";
	cnstn_se_nm = "일반";
	
	String reqcsttypecd = "";
	String inoutcon = "";
	
	
	if(consultinfo!=null && consultinfo.size()>0){
		
		deptnm = consultinfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NM").toString();
		deptnmNo = consultinfo.get("CNSTN_RQST_DEPT_NO")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NO").toString();
		writer = consultinfo.get("CNSTN_RQST_EMP_NM")==null?"":consultinfo.get("CNSTN_RQST_EMP_NM").toString();
		writerNo = consultinfo.get("CNSTN_RQST_EMP_NO")==null?"":consultinfo.get("CNSTN_RQST_EMP_NO").toString();
		regDate = consultinfo.get("CNSTN_RQST_REG_YMD")==null?"":consultinfo.get("CNSTN_RQST_REG_YMD").toString();
		rls_yn = consultinfo.get("RLS_YN")==null?"":consultinfo.get("RLS_YN").toString();
		cnstn_se_nm = consultinfo.get("CNSTN_SE_NM")==null?"":consultinfo.get("CNSTN_SE_NM").toString();
		
		dept_head_emp_no = cnstn_rqst_dh_emp_no;
		dept_head_emp_nm = cnstn_rqst_dh_nm;
		dept_head_wrc_jbgd_nm = cnstn_rqst_dh_jbps_nm;
	}
	
%>


<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<script type="text/javascript" src="${resourceUrl}/js/plugin/jquery.number.js"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	$(document).ready(function(){
		$("#savebtn").click(function(){
			if(confirm("등록 하시겠습니까?")){
// 				if($("#cnstn_hope_rply_ymd").val() == "") {
// 					return alert("자문회신 희망일자를 입력하세요.");
// 				}
				if($("#cnstn_ttl").val()==''){
					alert('자문제목을 입력하세요.');
					return;
				}
				
			    var tel = document.getElementById("cnstn_rqst_dept_tmldr_telno").value;
				
				// 긴급여부 N이면 긴급사유 값 없애주기
				var emrgYnValue = $('input[name="emrg_yn"]:checked').val();
				if (emrgYnValue == 'N') {
					$("#emrg_rsn").val('');
				}
				
				// 자문유형 내부면 기피 변호사 값 없애주기
				var insdOtsdValue = $('#insd_otsd_task_se').val();
				if (insdOtsdValue == 'I') {
					$("#excl_dmnd_jdaf_corp_nm").val('');
				} 
				
				// 자문유형 외부 아니면 외부자문사유 값 없애주기
				if (insdOtsdValue != 'O') {
					$("#otsd_rqst_rsn").val('');
				}
				
				// 직급이 팀장이 아니면 담당팀장 값 기재  여부 확인
// 				if (condition) {
					
// 				}
				
				$("#MENU_MNG_NO").val('<%=MENU_MNG_NO%>');
				$("#consultid").val('<%=consultid%>');
				$("#cnstn_rqst_emp_no").val('<%=writerNo%>');
				$("#cnstn_rqst_emp_nm").val('<%=writer%>');
				$("#cnstn_rqst_dept_no").val('<%=deptnmNo%>');
				$("#cnstn_rqst_dept_nm").val('<%=deptnm%>');
				$("#wrtr_emp_no").val('<%=writerNo%>');
				$("#wrtr_emp_nm").val('<%=writer%>');
				$("#wrt_dept_no").val('<%=deptnmNo%>');
				$("#wrt_dept_nm").val('<%=deptnm%>');
				$.ajax({
					type:"POST",
					url : "${pageContext.request.contextPath}/web/consult/consultSave.do",
					data : $('#wform').serializeArray(),
					dataType: "json",
					async: false,
					success : function(result){
						$("#consultid").val(result.data.CNSTN_MNG_NO);
						
						if(fileList.length > 0){
							for(var i=0; i<fileList.length; i++){
								
								var formData = new FormData();
								formData.append('file'+i, fileList[i]);
								//formData.append("filenm", $("#filename"+i).val());
								formData.append('CNSTN_MNG_NO', result.data.CNSTN_MNG_NO);
								formData.append('consultid', result.data.CNSTN_MNG_NO);
								formData.append('filegbn', 'CONSULT');
								
								var other_data = $('#wform').serializeArray();
								$.each(other_data,function(key,input){
									if(input.name != 'consultid'){
										formData.append(input.name, input.value);
									}
								});
								
								var status = statusList[i];
								uploadFile(status, formData, i, fileList.length);
							}
						}else{
							alert("저장되었습니다.");
							wform.consultid.value = result.data.CNSTN_MNG_NO;
							wform.action = "${pageContext.request.contextPath}/web/consult/consultView.do";
							wform.submit();
						}
					}
				});
			}
		});
		var jbAry = new Array();
		var jbAry2 = new Array();
		function uploadFile(status,formData, idx, maxidx){
			var uploadURL = "${pageContext.request.contextPath}/web/consult/fileUploadconsult.do"; //Upload URL
			var extraData ={}; //Extra Data.
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
					if(idx == (maxidx-1)){
						var frm = document.wform;
						alert("저장되었습니다.");
						wform.action = "${pageContext.request.contextPath}/web/consult/consultView.do";
						wform.submit();
					}
				}
			});
			status.setAbort(jqXHR);
		}
		
		$("#listbtn").click(function(){
			var frm = document.wform;
			frm.action = "${pageContext.request.contextPath}/web/consult/goConsultList.do";
			frm.submit();
		});
		$("#hwpBtn").click(function(){
			
			downFile("법률자문의뢰서.hwp",'10000.hwp','CONSULT');
			
		});
		
	    // 긴급사유 항목 페이지 로딩 시 초기 상태 반영
	    toggle_emrg_rsn_row();

	    // 긴급사유 라디오 버튼 변경 시 처리
	    $('input[name="emrg_yn"]').on('change', function() {
			toggle_emrg_rsn_row();
	    });
	    
	    // 기피변호사 항목 페이지 로딩 시 초기 상태 반영
	    toggle_excl_rsn_row();

	    // 자문유형변경 시 처리
        $('#insd_otsd_task_se').on('change', function() {
	    	toggle_excl_rsn_row();
	    });
	    
	    // 자문유형에 따라 외부자문사유 조작하기
        toggle_otsd_rqst_rsn(); // 페이지 로딩 시 초기값에 따라 동작
        document.getElementById("insd_otsd_task_se").addEventListener("change", toggle_otsd_rqst_rsn)

		$("#cnstn_rqst_dept_tmldr_telno, #cnstn_rqst_dh_telno").on("input", function () {
			const original = $(this).val();
			const numbersOnly = original.replace(/[^0-9]/g, '');
			
			if (original !== numbersOnly) {
		  		alert("숫자만 입력할 수 있습니다.");
			}
			
			if (numbersOnly.length > 11) {
		  		alert("최대 11자리까지만 입력할 수 있습니다.");
			}
			
			$(this).val(numbersOnly.slice(0, 11));
		});
		        
	});
	
	// 의뢰부서 팀장 선택 팝업
	function selectManager(chkVal) {
		var selectedAprvrJbps = $('input[name="rqst_dept_last_aprvr_jbps_nm"]:checked').val();
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
		newForm.append($("<input/>", {type:"hidden", name:"jbgd_nm", value:selectedAprvrJbps}));
		if (chkVal == 'TM') {
			newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"con1"}));
		} else {
			newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"con2"}));
		}
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"firstCheck", value:firstCheck}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 긴급 여부 선택에 따른 긴급 사유 항목 노출 여부 토글
	function toggle_emrg_rsn_row() {
// 		var selectedValue = $('input[name="emrg_yn"]:checked').val();
// 		if (selectedValue == "Y") {
// 			$('#emrg_rsn').removeAttr("disabled");
// 		} else {
// 			$("#emrg_rsn").val("");
// 			$('#emrg_rsn').attr("disabled", "disabled");
// 		}

	    var selectedValue = $('input[name="emrg_yn"]:checked').val();
	    var $emrgRsn = $('#emrg_rsn');
	
	    if (selectedValue == "Y") {
	        $emrgRsn.css("display", "inline-block").prop("disabled", false);
	    } else {
	        $emrgRsn.css("display", "none").prop("disabled", true).val("");
	    }
	}
	
	// 자문 유형 선택에 따른 기피 변호사 및 기피사유 항목 노출 여부 토글
	function toggle_excl_rsn_row() {
		
	    var selectedValue = $('#insd_otsd_task_se').val();
	    
	    if (selectedValue == "O" || selectedValue == "") {
			$('#excl_rsn_row').show();
		} else {
			$('#excl_rsn_row').hide();
		}
	}
	
	// 자문 유형 선택에 따른 외부의뢰사유 콤보박스 활성화
	function toggle_otsd_rqst_rsn() {
	    var selected = document.getElementById("insd_otsd_task_se").value;
	    var rsnSelect = document.getElementById("otsd_rqst_rsn");

	    if (selected === "O") {
	        rsnSelect.style.display = "inline-block";
	        rsnSelect.disabled = false;
	    } else {
	        rsnSelect.style.display = "none";
	        rsnSelect.disabled = true;
	    }
	}
	// 입력 중: 숫자만 유지, 11자리로 자르기
	function limitTo11Digits(input) {
		input.value = input.value.replace(/[^0-9]/g, '');
	    
	    // 11자리 초과 시 알림 + 자르기
	    if (input.value.length > 11) {
	        alert("전화번호는 숫자로만 최대 11자리까지만 입력할 수 있습니다.");
	        input.value = input.value.slice(0, 11);
	    }
	}
	
	
</script>
<style>
	.innerBtn {
		display: inline-block;
		height: 25px;
		line-height: 25px;
		text-align: center;
		padding: 0 10px;
		border-radius: 15px;
		background: #fff;
		font-size: 11px;
		border: 1px solid #009475;
		color: #009475;
		font-weight: bold;
	}
	.innerBtn {float: right;}
	
	.flex-align {
		
	  	display: flex;
	  	align-items: center; /* 수직 가운데 정렬 */
	  	gap: 8px; /* 간격 여유 */
	}
	.flex-align input[type="text"] {
	  	flex: 1;
	}
</style>

<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">자문의뢰 요청</strong>
		</div>
		<div class="subBtnC right" id="test">
<%-- 		<%if(consultinfo.size()==0 && !Menuid.equals("10118691")){ %> --%>
<!-- 			<a href="#none" class="sBtn type1" id="callbtn">전화상담신청</a> -->
<%-- 		<%} %> --%>
			<a href="#none" class="sBtn type1" id="savebtn">저장</a>
			<a href="#none"class="sBtn type2" id="listbtn">목록</a>
		</div>
		
	</div>	
	<hr class="margin40">
	<strong class="subST">법률자문 의뢰 신청서</strong>
	<div class="innerB" >
		<form name="wform" id="wform" method="post" action="${pageContext.request.contextPath}/web/consult/consultSave.do">
			<input type="hidden" name="searchForm" id="searchForm" value="<%=searchForm%>"/>
			<input type="hidden" name="consultid"  id="consultid"  value="<%=consultid%>"/>
			<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=MENU_MNG_NO%>">
			<input type="hidden" name="cnstn_rqst_emp_no" id="cnstn_rqst_emp_no">
			<input type="hidden" name="cnstn_rqst_emp_nm" id="cnstn_rqst_emp_nm">
			<input type="hidden" name="cnstn_rqst_dept_no" id="cnstn_rqst_dept_no">
			<input type="hidden" name="cnstn_rqst_dept_nm" id="cnstn_rqst_dept_nm">
			<input type="hidden" name="wrtr_emp_no"   id="wrtr_emp_no"/>
			<input type="hidden" name="wrtr_emp_nm"     id="wrtr_emp_nm"/>
			<input type="hidden" name="wrt_dept_no"   id="wrt_dept_no"/>
			<input type="hidden" name="wrt_dept_nm"     id="wrt_dept_nm"/>
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width:13%;">
				<col style="width:20%;">
				<col style="width:10%;">
				<col style="width:23%;">
				<col style="width:10%;">
				<col style="width:24%;">
			</colgroup>
			<tr>
				<th>의뢰부서</th>
				<td>
					<input type="text" value="<%=deptnm %>" style="width: 100%;" readonly="readonly" />
				</td>
				
				<th>의뢰자</th>
				<td>
					<input type="text" value="<%=writer %>" style="width: 100%;" readonly="readonly" />
				</td>
				<th>등록일</th>
				<td>
					<input type="text" value="<%=regDate %>" style="width: 100%;" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<th>의뢰부서 최종 검토자 </th>
				<td>
					<label><input type="radio" name="rqst_dept_last_aprvr_jbps_nm" id="rqst_dept_last_aprvr_jbps_nm" value="과장" <%if(rqst_dept_last_aprvr_jbps_nm.equals("과장") || rqst_dept_last_aprvr_jbps_nm.equals(""))out.println("checked");%>>과장</label>&nbsp;
					<label><input type="radio" name="rqst_dept_last_aprvr_jbps_nm" id="rqst_dept_last_aprvr_jbps_nm" value="팀장" <%if(rqst_dept_last_aprvr_jbps_nm.equals("팀장"))out.println("checked");%>>팀장</label>
				</td>
				<th>부서장</th>
				<td>
					<div class="flex-align">
						<input type="text" name="cnstn_rqst_dh_nm" id="cnstn_rqst_dh_nm" value="<%=dept_head_emp_nm%>" style="width: 100%;" readonly="readonly"/>
						<input type="hidden" name="cnstn_rqst_dh_emp_no" id="cnstn_rqst_dh_emp_no" value="<%=dept_head_emp_no %>" readonly="readonly">
						<a href="#none" class="innerBtn" style="height:20px;line-height:20px;" onclick="selectManager('DH');">선택</a>
					</div>
				</td>
				<th>부서장 직위명</th>
				<td>
					<input type="text" name="cnstn_rqst_dh_jbps_nm" id="cnstn_rqst_dh_jbps_nm" style="width:100%;" value="<%=dept_head_wrc_jbgd_nm%>"/>
				</td>
			</tr>
			<tr>
				
				<th>담당팀장</th>
				<td>
					<div class="flex-align">
						<input type="text" name="cnstn_rqst_dept_tmldr_nm" id="cnstn_rqst_dept_tmldr_nm" value="<%=cnstn_rqst_dept_tmldr_nm%>" style="width: 100%;" readonly="readonly"/>
						<input type="hidden" name="cnstn_rqst_dept_tmldr_emp_no" id="cnstn_rqst_dept_tmldr_emp_no" value="<%=cnstn_rqst_dept_tmldr_emp_no %>" readonly="readonly">
						<a href="#none" class="innerBtn" style="height:20px;line-height:20px;" onclick="selectManager('TM');">선택</a>
					</div>
				</td>
				<th>담당팀장 행정번호</th>
				<td>
					<input type="text" name="cnstn_rqst_dept_tmldr_telno" id="cnstn_rqst_dept_tmldr_telno" style="width:100%;" value="<%=cnstn_rqst_dept_tmldr_telno%>" placeholder="숫자만 11자리 입력" oninput="limitTo11Digits(this)"/>
				</td>
				<th>담당팀장 직위명</th>
				<td>
					<input type="text" name="cnstn_rqst_dept_tmldr_jbps_nm" id="cnstn_rqst_dept_tmldr_jbps_nm" style="width:100%;" value="<%=cnstn_rqst_dept_tmldr_jbps_nm%>"/>
				</td>
			</tr>
			<tr>
				<th>자문유형</th>
				<td>
					<select id="insd_otsd_task_se" name="insd_otsd_task_se" style="width: 50%;">
						<option value="" <%if("".equals(insd_otsd_task_se) || "미지정".equals(insd_otsd_task_se)) out.println("selected");%>>상관없음</option>
						<option value="I" <%if("I".equals(insd_otsd_task_se)) out.println("selected");%>>내부</option>
						<option value="O" <%if("O".equals(insd_otsd_task_se)) out.println("selected");%>>외부</option>
					</select>
				</td>
				<th>외부자문사유</th>
				<td>
					<select id="otsd_rqst_rsn" name="otsd_rqst_rsn" style="<% if(!"O".equals(insd_otsd_task_se)) out.print("display:none;"); %> width: 50%;">
						<option value="" <%if("".equals(otsd_rqst_rsn)) out.println("selected");%>>선택하세요.</option>
						<option value="특수분야 전문지식 필요" <%if("특수분야 전문지식 필요".equals(otsd_rqst_rsn)) out.println("selected");%>>특수분야 전문지식 필요</option>
						<option value="외부의 객관적 시각 필요" <%if("외부의 객관적 시각 필요".equals(otsd_rqst_rsn)) out.println("selected");%>>외부의 객관적 시각 필요</option>
						<option value="기타" <%if("기타".equals(otsd_rqst_rsn)) out.println("selected");%>>기타</option>
					</select>
				</td>
				<th></th>
				<td></td>
			</tr>
			<tr>
				<th>긴급여부</th>
				<td>
					<label><input type="radio" name="emrg_yn" id="emrg_yn" value="N" <%if(emrg_yn.equals("N") || emrg_yn.equals(""))out.println("checked");%>>일반</label>&nbsp;
					<label><input type="radio" name="emrg_yn" id="emrg_yn" value="Y" <%if(emrg_yn.equals("Y"))out.println("checked");%>>긴급</label>
				</td>
				<th>긴급 사유</th>
				<td>
					<input type="text" name="emrg_rsn" id="emrg_rsn" style="width:100%;" value="<%=emrg_rsn%>"/>
				</td>
				<th></th>
				<td></td>
			</tr>
			<%
			if(GRPCD.indexOf("Y")>-1||GRPCD.indexOf("G")>-1||GRPCD.indexOf("Q")>-1||GRPCD.indexOf("J")>-1||GRPCD.indexOf("M")>-1){
			%>
			<tr>
				<th>자문구분 </th>
				<td>
					<select id="cnstn_se_nm" name="cnstn_se_nm">
						<option value="일반" <%if("일반".equals(cnstn_se_nm) || cnstn_se_nm.equals("")) out.println("selected");%>>일반</option>
						<option value="국제" <%if("국제".equals(cnstn_se_nm)) out.println("selected");%>>국제</option>
					</select>
				</td>
				<th>관리자 검색 키워드</th>
				<td>
					<input type="text" id="prvt_srch_kywd_cn" name="prvt_srch_kywd_cn" style="width:100%;" value="<%=prvt_srch_kywd_cn%>"/>
				</td>
				<th>공개여부 </th>
				<td>
					<select id="rls_yn" name="rls_yn">
						<option value="Y" <%if("Y".equals(rls_yn) || rls_yn.equals("")) out.println("selected");%>>부서공개</option>
						<option value="N" <%if("N".equals(rls_yn)) out.println("selected");%>>비공개</option>
					</select>
				</td>
			</tr>
			<%
			}
			%>
			<tr id="excl_rsn_row" style="display: none;">
				<th>기피 변호사 및 기피사유</th>
				<td colspan="5">
					<input type="text" id="excl_dmnd_jdaf_corp_nm" name="excl_dmnd_jdaf_corp_nm" style="width:100%;" value="<%=excl_dmnd_jdaf_corp_nm%>"/>
				</td>
			</tr>
			<tr>
				<th>자문건명<sup><font color=red>*</font></sup></th>
				<td colspan="5">
					<input type="text" id="cnstn_ttl" name="cnstn_ttl" style="width:100%;" value="<%=cnstn_ttl%>"/>
				</td>
				
			</tr>
		    <tr>
		    	<th>자문 배경</th>
		        <td colspan="5"><textarea id="cnstn_rqst_cn" name="cnstn_rqst_cn" rows="8" cols="" style="width:100%;"><%=cnstn_rqst_cn%></textarea></td>
		    </tr>
			<tr>
		    	<th>자문 요지</th>
		        <td colspan="5"><textarea id="cnstn_rqst_subst_cn" name="cnstn_rqst_subst_cn" rows="8" cols="" style="width:100%;"><%=cnstn_rqst_subst_cn%></textarea></td>
		    </tr>
			<%
			if((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("K")>-1)){
			%>
	     	<tr>
		    	<th>비고</th>
		        <td colspan="5"><textarea id="rmrk_cn" name="rmrk_cn" rows="8" cols="" style="width:100%;"><%=rmrk_cn%></textarea></td>
		    </tr>
		    <%
		    }
		    %>
			<tr>
				<th>파일첨부</th>
				<td colspan="5">
					<div id="fileUpload" class="dragAndDropDiv" <%if(fileList.size()>0){ %>style="width:50%"<%} %>>
						<input type="file" multiple style="display:none" id="filesel"/>
						<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
<!-- 						<label for="filesel">(드래그 앤 드롭으로 파일 첨부가 가능합니다.)</label> -->
<!-- 					    <div><strong>업로드 할 파일을 선택 하세요</strong> -->
<!-- 					    (드래그 앤 드롭으로 파일 첨부가 가능합니다.)</div> -->
					</div>
<!-- 					<li>※ 좌측 의뢰서양식을 다운로드 받아 작성하여 꼭 첨부 해 주세요</li> -->
					<div id="fileList">
						<input type="hidden" />
					</div>
					<div id="hkk" class="hkk"></div>
					<div class="hkk2" style="width:49%;">
						<%
							for(int i=0; i<fileList.size(); i++){
								HashMap result = (HashMap)fileList.get(i);
						%>
						<div class="statusbar odd">
							<div class="filename" style='width:80%'>
								<%=result.get("DWNLD_FILE_NM") %> (<%=result.get("VIEW_SZ").toString()%>)
							</div>
							<div class="abort">
								<input type="checkbox" name="delfile[]" value="<%=result.get("FILE_MNG_NO") %>"/>　삭제
							</div>
						</div>
						<%
							}
						%>
					</div>
				</td>
			</tr>
		</table>
		</form>
	</div>
</div>
