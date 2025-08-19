<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String AGT_MNG_NO = request.getAttribute("AGT_MNG_NO")==null?"":request.getAttribute("AGT_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":(String)request.getAttribute("WRTR_EMP_NM");
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":(String)request.getAttribute("WRTR_EMP_NO");
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":(String)request.getAttribute("WRT_DEPT_NM");
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":(String)request.getAttribute("WRT_DEPT_NO");
	
	HashMap chrgMap = request.getAttribute("chrgMap")==null?new HashMap():(HashMap)request.getAttribute("chrgMap");
	List chrgFile = request.getAttribute("chrgFile")==null?new ArrayList():(ArrayList)request.getAttribute("chrgFile");
	
	String APRV_YN = chrgMap.get("APRV_YN")==null?"":chrgMap.get("APRV_YN").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	
	var AGT_MNG_NO = "<%=AGT_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var APRV_YN = "<%=APRV_YN%>";
	
	$(document).ready(function(){
		
	});
	function goInfoSave(){
		if ($("#ACAP_AMT").val() == "") {
			return alert("수임료를 입력하세요.");
		}
		
		if ($("#ACTNO").val() == "") {
			return alert("지급받을 계좌정보를 선택하세요.");
		}
			
		$("#OTST_AMT").val(uncomma($("#OTST_AMT").val()));
		$("#SCS_PAY_AMT").val(uncomma($("#SCS_PAY_AMT").val()));
		$("#ACAP_AMT").val(uncomma($("#ACAP_AMT").val()));
		
		if (APRV_YN == "N") {
			// 최초등록일 때
			$("#APRV_YN").val("G");	// 최초 지급 요청
		} else if (APRV_YN == "R") {
			$("#APRV_YN").val("T");	// 보완 지급 요청
		}
		
		$.ajax({
			url: "<%=CONTEXTPATH%>/web/suit/insertChrgCost.do",
			data: $("#frm").serialize(),
			dataType: "json",
			async: false,
			type:"POST",
			error: function(){
				alert("처리중 오류가 발생하였습니다.")
			},
			success: function(result){
				$("#AGT_MNG_NO").val(result.AGT_MNG_NO);
				
				if(fileList.length == 0){
					alert("저장이 완료되었습니다.");
					opener.document.getElementById("focus").value = "1";
					opener.goReLoad();
					window.close();
				}
				
				for (var i = 0; i < fileList.length; i++) {
					var formData = new FormData();
					formData.append("file"+i, fileList[i]);
					formData.append("LWS_MNG_NO",      $("#LWS_MNG_NO").val());
					formData.append("INST_MNG_NO",     $("#INST_MNG_NO").val());
					formData.append("TRGT_PST_MNG_NO", result.AGT_MNG_NO);
					formData.append("FILE_SE", "COST");
					formData.append("SORT_SEQ", i);
					
					var other_data = $('#frm').serializeArray();
					$.each(other_data,function(key,input){
						if(input.name != 'INST_MNG_NO' && input.name != 'LWS_MNG_NO'){
							formData.append(input.name, input.value);
						}
					});
					
					var status = statusList[i];
					var uploadURL = "${pageContext.request.contextPath}/web/suit/fileUpload.do";
					uploadFileFunction(status, uploadURL, formData, i, fileList.length);
				}
			}
		});
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
					opener.document.getElementById("focus").value = "1";
					opener.goReLoad();
					window.close();
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function searchAccount(LWYR_MNG_NO) {
		var cw=600;
		var ch=700;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","bankSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "bankSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/lawyerAccInfoPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"SUIT"}));
		newForm.append($("<input/>", {type:"hidden", name:"LWYR_MNG_NO", value:LWYR_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
</script>
<style>

</style>
<strong class="popTT">
	위임 비용 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="AGT_MNG_NO"  id="AGT_MNG_NO"  value="<%=AGT_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="APRV_YN"     id="APRV_YN"     value=""/>
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM" id="WRTR_EMP_NM" value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO" id="WRT_DEPT_NO" value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_AGT"/>
	<div class="popC">
		<div class="popA" style="overflow:hidden;">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>대리인</th>
					<td>
						<%=chrgMap.get("JDAF_CORP_NM")==null?"":chrgMap.get("JDAF_CORP_NM").toString()%>&nbsp;<%=chrgMap.get("LWYR_NM")==null?"":chrgMap.get("LWYR_NM").toString()%>
					</td>
					<th>위임시작일</th>
					<td>
						<%=chrgMap.get("DLGT_YMD")==null?"":chrgMap.get("DLGT_YMD").toString()%>
					</td>
					<th>위임종료일</th>
					<td>
						<%=chrgMap.get("DLGT_END_YMD")==null?"":chrgMap.get("DLGT_END_YMD").toString()%>
					</td>
				</tr>
				<tr>
					<th>착수금</th>
					<td>
						<input type="text" name="OTST_AMT" id="OTST_AMT" value="<%=chrgMap.get("OTST_AMT")==null?"":chrgMap.get("OTST_AMT").toString()%>" onkeyup="numFormat(this);"/>
					</td>
					<th>성공보수</th>
					<td>
						<input type="text" name="SCS_PAY_AMT" id="SCS_PAY_AMT" value="<%=chrgMap.get("SCS_PAY_AMT")==null?"":chrgMap.get("SCS_PAY_AMT").toString()%>" onkeyup="numFormat(this);"/>
					</td>
					<th>수임료</th>
					<td>
						<input type="text" name="ACAP_AMT" id="ACAP_AMT" value="<%=chrgMap.get("ACAP_AMT")==null?"":chrgMap.get("ACAP_AMT").toString()%>" onkeyup="numFormat(this);"/>
					</td>
				</tr>
				<tr>
					<th>은행명</th>
					<td>
						<input type="hidden" name=BACNT_MNG_NO id="BACNT_MNG_NO" value="<%=chrgMap.get("BACNT_MNG_NO")==null?"":chrgMap.get("BACNT_MNG_NO").toString()%>" readonly="readonly"/>
						<input type="text" name=BANK_NM id="BANK_NM" value="<%=chrgMap.get("BANK_NM")==null?"":chrgMap.get("BANK_NM").toString()%>" readonly="readonly"/>
					</td>
					<th>예금주</th>
					<td>
						<input type="text" name=DPSTR_NM id="DPSTR_NM" value="<%=chrgMap.get("DPSTR_NM")==null?"":chrgMap.get("DPSTR_NM").toString()%>" readonly="readonly"/>
					</td>
					<th>계좌번호</th>
					<td>
						<input type="text" name=ACTNO id="ACTNO" value="<%=chrgMap.get("ACTNO")==null?"":chrgMap.get("ACTNO").toString()%>" readonly="readonly"/>
						<a href="#none" class="innerBtn" onclick="searchAccount('<%=WRTR_EMP_NO%>');">조회</a>
					</td>
				</tr>
				<tr id="file">
					<th>첨부파일</th>
					<td colspan="5">
						<div id="fileUpload" class="dragAndDropDiv">
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:49%;">
							<%
								for(int i=0; i<chrgFile.size(); i++){
									HashMap result = (HashMap)chrgFile.get(i);
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'>
									<%=result.get("PHYS_FILE_NM") %> (<%=result.get("VIEW_SZ").toString()%>)
								</div>
								<div class="abort">
									<input type="checkbox" name="delfile[]" value="<%=result.get("FILE_MNG_NO") %>"/>　삭제
								</div>
							</div>
							<%
								}
							%>
						</div>
						<div id="hkk" class="hkk"></div>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="goInfoSave();">비용신청</a>
		</div>
	</div>
</form>