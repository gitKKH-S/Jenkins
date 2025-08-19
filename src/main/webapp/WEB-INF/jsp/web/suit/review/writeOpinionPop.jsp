<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String LWS_DLBR_MNG_NO = request.getAttribute("LWS_DLBR_MNG_NO")==null?"":request.getAttribute("LWS_DLBR_MNG_NO").toString();
	String DLBR_CMT_MNG_NO = request.getAttribute("DLBR_CMT_MNG_NO")==null?"":request.getAttribute("DLBR_CMT_MNG_NO").toString();
	String DLBR_MBCMT_MNG_NO = request.getAttribute("DLBR_MBCMT_MNG_NO")==null?"":request.getAttribute("DLBR_MBCMT_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	$(document).ready(function(){
		$("#loading").hide();
	});
	
	function saveOpinion(){
		$("#loading").show();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/suitOpinionSave.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				var DLBR_MBCMT_MNG_NO = $("#DLBR_MBCMT_MNG_NO").val();
				if(fileList.length > 0){
					for (var i = 0; i < fileList.length; i++) {
						var formData = new FormData();
						formData.append("file"+i, fileList[i]);
						formData.append("LWS_MNG_NO", DLBR_MBCMT_MNG_NO);
						formData.append("INST_MNG_NO", DLBR_MBCMT_MNG_NO);
						formData.append("TRGT_PST_MNG_NO", DLBR_MBCMT_MNG_NO);
						formData.append("TRGT_PST_TBL_NM", "TB_LWS_DLBR_MBCMT");
						formData.append("SORT_SEQ", i);
						formData.append("FILE_SE", "");
						
						formData.append("WRTR_EMP_NM", $("#WRTR_EMP_NM").val());
						formData.append("WRTR_EMP_NO", $("#WRTR_EMP_NO").val());
						formData.append("WRT_DEPT_NM", $("#WRT_DEPT_NM").val());
						formData.append("WRT_DEPT_NO", $("#WRT_DEPT_NO").val());
						
						var status = statusList[i];
						var uploadURL = "${pageContext.request.contextPath}/web/suit/fileUpload.do";
						uploadFileFunction(status, uploadURL, formData, i, fileList.length);
					}
				}else{
					$("#loading").hide();
					alert("저장이 완료되었습니다.");
					opener.goReload();
					window.close();
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
					$("#loading").hide();
					alert("저장이 완료되었습니다.");
					opener.goReload();
					window.close();
				}
			}
		});
		status.setAbort(jqXHR);
	}
</script>
<style>
	.popC{height:435px}
	.popW{height:100%}
</style>
<strong class="popTT">
	소송 심의 의결
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="LWS_DLBR_MNG_NO"   id="LWS_DLBR_MNG_NO"   value="<%=LWS_DLBR_MNG_NO%>"/>
	<input type="hidden" name="DLBR_CMT_MNG_NO"   id="DLBR_CMT_MNG_NO"   value="<%=DLBR_CMT_MNG_NO%>"/>
	<input type="hidden" name="DLBR_MBCMT_MNG_NO" id="DLBR_MBCMT_MNG_NO" value="<%=DLBR_MBCMT_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NO"       id="WRTR_EMP_NO"       value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"       id="WRTR_EMP_NM"       value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"       id="WRT_DEPT_NO"       value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"       id="WRT_DEPT_NM"       value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="TRGT_PST_TBL_NM"   id="TRGT_PST_TBL_NM"   value="TB_LWS_DLBR_MBCMT"/>
	<input type="hidden" name="FILE_SE"           id="FILE_SE"           value=""/>
	<div class="popC">
		<div class="popA">
			<table class="pop_listTable">
				<colgroup>
					<col style="width:20%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>의견</th>
					<td>
						<input type="radio" name="DLBR_RSLT_NM" id="DLBR_RSLT_NM0" value="Y"><label>찬성</label>
						<input type="radio" name="DLBR_RSLT_NM" id="DLBR_RSLT_NM1" value="N"><label>반대</label>
						<input type="radio" name="DLBR_RSLT_NM" id="DLBR_RSLT_NM2" value="I"><label>보류</label>
						<input type="radio" name="DLBR_RSLT_NM" id="DLBR_RSLT_NM3" value="A"><label>미참석</label>
					</td>
				</tr>
				<tr>
					<th>의견내용</th>
					<td>
						<textarea id="DLBR_OPNN_CN" name="DLBR_OPNN_CN" rows="3" cols="100"></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td>
						<div id="fileUpload" class="dragAndDropDiv">
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div id="hkk" class="hkk">
						</div>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subTTW">
			<div class="subTTC right">
				<a href="#none" class="sBtn type2" onclick="saveOpinion();">저장</a>
			</div>
		</div>
	</div>
</form>