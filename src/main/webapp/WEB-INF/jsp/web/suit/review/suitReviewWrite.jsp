<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="net.sf.json.JSONArray"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	System.out.println(se);
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	String Menuid = request.getParameter("Menuid")==null?"":request.getParameter("Menuid");
	
	HashMap reviewInfo = request.getAttribute("reviewInfo")==null?new HashMap():(HashMap)request.getAttribute("reviewInfo");
	List commiteeList = request.getAttribute("commiteeList")==null?new ArrayList():(ArrayList)request.getAttribute("commiteeList");
	HashMap opinionCnt = request.getAttribute("opinionCnt")==null?new HashMap():(HashMap)request.getAttribute("opinionCnt");
	List fileList = request.getAttribute("fileList")==null?new ArrayList():(ArrayList)request.getAttribute("fileList");
	
	if(reviewInfo != null && reviewInfo.size() > 0){
		WRTR_EMP_NM = reviewInfo.get("RQST_EMP_NM")==null?WRTR_EMP_NM:reviewInfo.get("RQST_EMP_NM").toString();
		WRTR_EMP_NO = reviewInfo.get("RQST_EMP_NO")==null?WRTR_EMP_NO:reviewInfo.get("RQST_EMP_NO").toString();
		WRT_DEPT_NM = reviewInfo.get("RQST_DEPT_NM")==null?WRT_DEPT_NM:reviewInfo.get("RQST_DEPT_NM").toString();
		WRT_DEPT_NO = reviewInfo.get("RQST_DEPT_NO")==null?WRT_DEPT_NO:reviewInfo.get("RQST_DEPT_NO").toString();
	}
	
	String LWS_DLBR_MNG_NO = reviewInfo.get("LWS_DLBR_MNG_NO")==null?"":reviewInfo.get("LWS_DLBR_MNG_NO").toString();
	String PRGRS_STTS_NM   = reviewInfo.get("PRGRS_STTS_NM")==null?"작성중":reviewInfo.get("PRGRS_STTS_NM").toString();
	String DLBR_SE_NM      = reviewInfo.get("DLBR_SE_NM")==null?"":reviewInfo.get("DLBR_SE_NM").toString();
	String LWS_MNG_NO      = reviewInfo.get("LWS_MNG_NO")==null?"":reviewInfo.get("LWS_MNG_NO").toString();
	String LWS_INCDNT_NM   = reviewInfo.get("LWS_INCDNT_NM")==null?"":reviewInfo.get("LWS_INCDNT_NM").toString();
	String INST_MNG_NO     = reviewInfo.get("INST_MNG_NO")==null?"":reviewInfo.get("INST_MNG_NO").toString();
	String INCDNT_NO       = reviewInfo.get("INCDNT_NO")==null?"":reviewInfo.get("INCDNT_NO").toString();
	String DLBR_NO         = reviewInfo.get("DLBR_NO")==null?"":reviewInfo.get("DLBR_NO").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var LWS_DLBR_MNG_NO = "<%=LWS_DLBR_MNG_NO%>";
	var DLBR_NO = "<%=DLBR_NO%>"
	
	var filegbnList = new Array();
	
	$(document).ready(function(){
		if(LWS_DLBR_MNG_NO != ""){
			var str = DLBR_NO.split('@');
			for(var i=0; i<str.length; i++){
				$("#DLBR_NO"+(i+1)).val(str[i]);
			}
		}
		
		$("#loading").hide();
	});
	
	function schSuit(cnt){
		var cw=1200;
		var ch=620;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","CaseSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "CaseSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseSearchPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"review"}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/goSuitReviewList.do";
		document.frm.submit();
	}
	
	function saveReviewInfo(){
		
		$("#loading").show();
		
		if($("#DLBR_NO1").val() == ""){
			$("#loading").hide();
			return alert("심의번호의 첫번째 칸은 공백으로 저장할 수 없습니다.");
		}else{
			var reviewno = $("#DLBR_NO1").val()+"@"+$("#DLBR_NO2").val()+"@"+$("#DLBR_NO3").val();
			$("#DLBR_NO").val(reviewno);
		}
		
		var DLBR_SE_NM = $('input:radio[name="DLBR_SE_NM"]:checked').val();
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/reviewInfoSave.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				if(fileList.length > 0){
					for (var i = 0; i < fileList.length; i++) {
						var formData = new FormData();
						formData.append("file"+i, fileList[i]);
						formData.append("LWS_MNG_NO", result.LWS_DLBR_MNG_NO);
						formData.append("INST_MNG_NO", result.LWS_DLBR_MNG_NO);
						formData.append("TRGT_PST_MNG_NO", result.LWS_DLBR_MNG_NO);
						formData.append("TRGT_PST_TBL_NM", "TB_LWS_DLBR");
						formData.append("FILE_SE", "FST");
						formData.append("SORT_SEQ", i);
						
						var other_data = $('#frm').serializeArray();
						$.each(other_data,function(key,input){
							if(input.name != 'LWS_MNG_NO' && input.name != 'INST_MNG_NO'){
								formData.append(input.name,input.value);
							}
						});
						
						var status = statusList[i];
						var uploadURL = "${pageContext.request.contextPath}/web/suit/fileUpload.do";
						uploadFileFunction(status, uploadURL, formData, i, fileList.length);
					}
				}else{
					$("#loading").hide();
					alert("저장이 완료되었습니다.");
					goListPage();
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
					goListPage();
				}
			}
		});
		status.setAbort(jqXHR);
	}
</script>
<style>
	.suitInput{margin-right:5px;}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	
	<input type="hidden" name="LWS_DLBR_MNG_NO" id="LWS_DLBR_MNG_NO" value="<%=LWS_DLBR_MNG_NO%>"/>
	<input type="hidden" name="PRGRS_STTS_NM"   id="PRGRS_STTS_NM"   value="<%=PRGRS_STTS_NM%>"/>
	
	<input type="hidden" name="LWS_INCDNT_NM" id="LWS_INCDNT_NM" value="<%=LWS_INCDNT_NM%>" ><!-- onclick="schSuit();" -->
	<input type="hidden" name="INCDNT_NO"     id="INCDNT_NO"     value="<%=INCDNT_NO%>">
	<input type="hidden" name="LWS_MNG_NO"    id="LWS_MNG_NO"    value="<%=LWS_MNG_NO%>">
	<input type="hidden" name="INST_MNG_NO"   id="INST_MNG_NO"   value="<%=INST_MNG_NO%>">
	
	<input type="hidden" name="DLBR_NO"         id="DLBR_NO"         value=""/>
	<div id="loading" class="loading"><img id="loading_img" alt="loading" src="${resourceUrl}/paramquery-3.3.2/images/loading.gif" /></div>
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="innerB">
			<table class="infoTable write">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>의뢰부서</th>
					<td>
						<input type="hidden" name="RQST_DEPT_NO" id="RQST_DEPT_NO" value="<%=WRT_DEPT_NO%>" readonly="readonly">
						<input type="text" name="RQST_DEPT_NM" id="RQST_DEPT_NM" value="<%=WRT_DEPT_NM%>" readonly="readonly">
					</td>
					<th>의뢰인</th>
					<td>
						<input type="hidden" name="RQST_EMP_NO" id="RQST_EMP_NO" value="<%=WRTR_EMP_NO%>" readonly="readonly">
						<input type="text" name="RQST_EMP_NM" id="RQST_EMP_NM" value="<%=WRTR_EMP_NM%>" readonly="readonly">
					</td>
					<th colspan="2"></th>
				</tr>
				<tr>
					<th>안건명</th>
					<td colspan="5">
						<input type="text" name="DLBR_AGND_NM" id="DLBR_AGND_NM" value="<%=reviewInfo.get("DLBR_AGND_NM")==null?"":reviewInfo.get("DLBR_AGND_NM").toString()%>" style="width:80%">
					</td>
				</tr>
				<tr>
					<th>심의번호</th>
					<td>
						<input type="text" name="DLBR_NO1" id="DLBR_NO1" style="width:70px" />
						<input type="text" name="DLBR_NO2" id="DLBR_NO2" style="width:50px" />
						<input type="text" name="DLBR_NO3" id="DLBR_NO3" style="width:50px"/>
					</td>
					<th>심의일자</th>
					<td colspan="3">
						<input type="text" class="datepick" name=DLBR_BGNG_YMD id="DLBR_BGNG_YMD" value="<%=reviewInfo.get("DLBR_BGNG_YMD")==null?"":reviewInfo.get("DLBR_BGNG_YMD").toString()%>">
						~
						<input type="text" class="datepick" name=DLBR_END_YMD id="DLBR_END_YMD" value="<%=reviewInfo.get("DLBR_END_YMD")==null?"":reviewInfo.get("DLBR_END_YMD").toString()%>">
					</td>
				</tr>
				<tr>
					<th>심의 구분</th>
					<td colspan="5">
						<input type="radio" name="DLBR_SE_NM" id="DLBR_SE_NM1" value="중요소송" <%if("중요소송".equals(DLBR_SE_NM)) out.println("checked");%>> 중요소송
						<input type="radio" name="DLBR_SE_NM" id="DLBR_SE_NM2" value="직원지원" <%if("직원지원".equals(DLBR_SE_NM)) out.println("checked");%>> 직원지원
						<input type="radio" name="DLBR_SE_NM" id="DLBR_SE_NM3" value="구상권"   <%if("구상권".equals(DLBR_SE_NM)) out.println("checked");%>> 구상권
						<input type="radio" name="DLBR_SE_NM" id="DLBR_SE_NM4" value="추심포기" <%if("추심포기".equals(DLBR_SE_NM)) out.println("checked");%>> 소송비용 추심 포기
						<input type="radio" name="DLBR_SE_NM" id="DLBR_SE_NM5" value="기타"     <%if("기타".equals(DLBR_SE_NM)) out.println("checked");%>> 기타
					</td>
				</tr>
				<tr id="contTr">
					<th>심의의결<br/>요청사항</th>
					<td colspan="5">
						<textarea id="DLBR_DMND_CN" name="DLBR_DMND_CN" rows="8" cols=""><%=reviewInfo.get("DLBR_DMND_CN")==null?"":reviewInfo.get("DLBR_DMND_CN").toString()%></textarea>
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
								for(int i=0; i<fileList.size(); i++){
									HashMap result = (HashMap)fileList.get(i);
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
		<div class="subBtnW center">
			<a id="saveBtn" href="#none" class="sBtn type1" onclick="saveReviewInfo();">등록</a>
			<a href="#none" class="sBtn type2" onclick="goListPage();">목록</a>
		</div>
	</div>
</form>
