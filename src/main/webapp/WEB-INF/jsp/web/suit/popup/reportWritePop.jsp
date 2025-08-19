<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	String RPTP_MNG_NO = request.getAttribute("RPTP_MNG_NO")==null?"":request.getAttribute("RPTP_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap reportMap = request.getAttribute("reportMap")==null?new HashMap():(HashMap)request.getAttribute("reportMap");
	List reportFile = request.getAttribute("reportFile")==null?new ArrayList():(ArrayList)request.getAttribute("reportFile");
	
	Date now = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy년 MM월 dd일");
	String formatedNow = formatter.format(now);
	String WRT_YMD = reportMap.get("WRT_YMD")==null?formatedNow:reportMap.get("WRT_YMD").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<style>
	.popW{height:100%; min-width:532px;}
</style>
<script>
	var RPTP_MNG_NO = "<%=RPTP_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	
	$(document).ready(function(){
		
	});
	
	function reportInfoSave(){
		if($("#title").val() == ""){
			return alert("제목을 입력하세요");
		}
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertReportInfo.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				if(fileList.length == 0){
					$("#loading").hide();
					alert("저장이 완료되었습니다.");
					opener.document.getElementById("focus").value = "1";
					opener.goReLoad();
					window.close();
				}
				
				var oseq = result.reportid;
				for (var i = 0; i < fileList.length; i++) {
					var formData = new FormData();
					formData.append("file"+i, fileList[i]);
					formData.append("LWS_MNG_NO",      $("#LWS_MNG_NO").val());
					formData.append("INST_MNG_NO",     $("#INST_MNG_NO").val());
					formData.append("TRGT_PST_MNG_NO", result.RPTP_MNG_NO);
					formData.append("FILE_SE", "REP");
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
</script>
<strong class="popTT">
	보고서 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="RPTP_MNG_NO"     id="RPTP_MNG_NO"     value="<%=RPTP_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NO"        id="WRTR_EMP_NO"        value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"          id="WRTR_EMP_NM"          value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM"        id="WRT_DEPT_NM"        value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"          id="WRT_DEPT_NO"          value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_RPTP"/>
	
	<div class="popC">
		<div class="popA" style="height:100%">
			<table class="pop_infoTable write" style="height:100%">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>제목</th>
					<td>
						<input type="text" id="RPTP_TTL" name="RPTP_TTL" value="<%=reportMap.get("RPTP_TTL")==null?"":reportMap.get("RPTP_TTL").toString()%>" style="width:80%">
					</td>
					<th>작성일</th>
					<td><%out.println(WRT_YMD);%></td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3">
						<textarea name="RPTP_CN" id="RPTP_CN"><%=reportMap.get("RPTP_CN")==null?"":reportMap.get("RPTP_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3">
						<textarea name="RMRK_CN" id="RMRK_CN"><%=reportMap.get("RMRK_CN")==null?"":reportMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td colspan="3">
						<div id="fileUpload" class="dragAndDropDiv" <%if(reportFile.size() > 0) {%>style="width:50%;"<%}%>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:45%;">
							<%
								for(int i=0; i<reportFile.size(); i++){
									HashMap result = (HashMap)reportFile.get(i);
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
			<a href="#none" class="sBtn type1" onclick="reportInfoSave();">등록</a>
		</div>
	</div>
</form>
