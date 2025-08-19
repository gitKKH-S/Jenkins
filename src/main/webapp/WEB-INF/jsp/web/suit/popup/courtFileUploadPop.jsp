<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String filePath = request.getAttribute("filePath")==null?"":request.getAttribute("filePath").toString();
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<style>
	.filename{width:250px;}
	#loading{
		height:100%;
		left:0px;
		position:fixed;
		_position:absolute;
		top:0px;
		width:100%;
		filter:alpha(opacity=50);
		-moz-opacity:0.5;
		opacity:0.5;
	}
	
	.loading{
		background-color:white;
		z-index:9998;
	}
	
	#loading_img{
		position:absolute;
		top:50%;
		left:50%;
		height:35px;
		margin-top:-25px;
		margin-left:0px;
		z-index:9999;
	}
</style>
<script type="text/javascript">
	var LWS_MNG_NO  = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";

	$(document).ready(function(){
		$(".popTT").append("전자 소송 파일 업로드");
		$("#loading").hide();
	});
	
	function saveCourtFile(){
		$("#loading").show();
		
		for (var i = 0; i < fileList.length; i++) {
			var formData = new FormData();
			formData.append("file"+i, fileList[i]);
			formData.append("LWS_MNG_NO", LWS_MNG_NO);
			formData.append("INST_MNG_NO", INST_MNG_NO);
			
			var status = statusList[i];
			var uploadURL = "${pageContext.request.contextPath}/web/suit/courtFileUpload.do";
			uploadFileFunction(status, uploadURL, formData, i, fileList.length);
		}
	}
	
	function uploadFileFunction(status, uploadURL, formData, idx, maxIdx){
		var getPercent = 0;
		
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
							getPercent = percent;
						}
						var progressBarWidth = percent * status.progressBar.width() / 100;
						status.progressBar.find('div').css({width:progressBarWidth}, 10).html(percent + "% ");
						if(parseInt(percent) >= 100){
							status.abort.hide();
							getPercent = 9999;
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
				$("#filedel"+idx).focus();
				console.log(getPercent);
				if(idx == (maxIdx-1) && parseInt(getPercent) == 9999){
					$("#loading").hide();
					alert("저장이 완료되었습니다.");
					opener.reLoadPop();
					window.close();
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function closePop(){
		opener.reLoadPop();
		window.close();
	}
</script>
<strong class="popTT">

	<a href="#none" class="popClose" onclick="closePop();">닫기</a>
</strong>
<form id="filefrm" name="filefrm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="INST_MNG_NO"  id="INST_MNG_NO"  value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"   id="LWS_MNG_NO"   value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"       id="WRTR_EMP_NM"       value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"       id="WRT_DEPT_NO"       value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="serverfilenm" id="serverfilenm" value=""/>
	<input type="hidden" name="viewfilenm"   id="viewfilenm"   value=""/>
	<div id="loading" class="loading"><img id="loading_img" alt="loading" src="${resourceUrl}/paramquery-3.3.2/images/loading.gif" /></div>
	<div class="popC" style="height:346px;">
		<div class="popA" style="height:255px;">
			<div id="fileUpload" class="dragAndDropDiv" style="height:100%; padding:50px 0px 10px 10px; font-size:160%; width:50%">
				<input type="file" multiple style="display:none" id="filesel"/>
				<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
			</div>
			<div id="fileList">
				<input type="hidden" />
			</div>
			<div id="hkk" class="hkk" style="height:100%; overflow-y:scroll; width:50%">
			</div>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" onclick="saveCourtFile();" class="sBtn type1">등록</a>
		</div>
	</div>
</form>
