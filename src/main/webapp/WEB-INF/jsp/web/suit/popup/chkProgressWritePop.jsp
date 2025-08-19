<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String RVW_MNG_NO = request.getAttribute("RVW_MNG_NO")==null?"":request.getAttribute("RVW_MNG_NO").toString();
	String UP_RVW_MNG_NO = request.getAttribute("UP_RVW_MNG_NO")==null?"":request.getAttribute("UP_RVW_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	
	HashMap chkMap = request.getAttribute("chkMap")==null?new HashMap():(HashMap)request.getAttribute("chkMap");
	HashMap upChkMap = request.getAttribute("upChkMap")==null?new HashMap():(HashMap)request.getAttribute("upChkMap");
	List chkFile = request.getAttribute("chkFile")==null?new ArrayList():(ArrayList)request.getAttribute("chkFile");
	
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var RVW_MNG_NO = "<%=RVW_MNG_NO%>";
	var UP_RVW_MNG_NO = "<%=UP_RVW_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	var gbn = "<%=gbn%>";
	$(document).ready(function(){
		
	});
	
	function goSaveProgress(){
		if($("#RVW_DMND_TTL").val() == ""){
			return alert("제목을 입력하세요");
		}
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertChkInfo.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
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
					formData.append("TRGT_PST_MNG_NO", result.RVW_MNG_NO);
					formData.append("FILE_SE", "CHK");
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
<style>
	.popW{height:100%; min-width:580px;}
</style>
<form name="frm" id="frm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="RVW_MNG_NO"      id="RVW_MNG_NO"      value="<%=RVW_MNG_NO%>"/>
	<input type="hidden" name="UP_RVW_MNG_NO"   id="UP_RVW_MNG_NO"   value="<%=UP_RVW_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="gbn"             id="gbn"             value="<%=gbn%>"/>
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_RVW_PRGRS"/>
	
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	
	<strong class="popTT">
		검토 진행 관리
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC" style="height:80%">
		<div class="popA" style="height:435px;">
			<table class="pop_infoTable write" style="height:100%">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<%
						if("reply".equals(gbn)){
					%>
						<th>답변 제목</th>
						<td><input type="text" id="RVW_DMND_TTL" name="RVW_DMND_TTL" value="<%=upChkMap.get("RVW_DMND_TTL")==null?"":upChkMap.get("RVW_DMND_TTL").toString()%>" style="width:90%"></td>
					<%
						} else {
					%>
						<th>제목</th>
						<td><input type="text" id="RVW_DMND_TTL" name="RVW_DMND_TTL" value="<%=chkMap.get("RVW_DMND_TTL")==null?"":chkMap.get("RVW_DMND_TTL").toString()%>" style="width:90%"></td>
					<%
						}
					%>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<textarea id="RVW_DMND_CN" name="RVW_DMND_CN"><%=chkMap.get("RVW_DMND_CN")==null?"":chkMap.get("RVW_DMND_CN").toString()%></textarea>
					</td>
				</tr>
				<%
					if("reply".equals(gbn)){
				%>
					<th>원본내용</th>
					<td>
						<div id="reCont" style="height: 100px; overflow: auto">
							<%=upChkMap.get("RVW_DMND_CN")==null?"":upChkMap.get("RVW_DMND_CN").toString().replaceAll("\n","<br/>")%>
						</div>
					</td>
				<%
					}
				%>
				<tr>
					<th>첨부파일</th>
					<td>
						<div id="fileUpload" class="dragAndDropDiv" <%if(chkFile.size() > 0) {%>style="width:50%;"<%}%>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:45%;">
							<%
								for(int i=0; i<chkFile.size(); i++){
									HashMap result = (HashMap)chkFile.get(i);
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'>
									<%=result.get("PHYS_FILE_NM") %> (<%=result.get("VIEW_SZ").toString()%>)
								</div><div class="abort">
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
			<a href="#none" class="sBtn type1" onclick="goSaveProgress();">등록</a>
		</div>
	</div>
</form>
