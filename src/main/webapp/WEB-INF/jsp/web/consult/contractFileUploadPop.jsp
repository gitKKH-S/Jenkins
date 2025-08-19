<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String consultid = request.getParameter("consultid")==null?"":request.getParameter("consultid");
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<style>
	.filename{width:250px;}
</style>
<script type="text/javascript">
var consultid = "<%=consultid%>";

//console.log("dfdasfsdafsadfsdafsdafdsfasdf"+sourcetableid);
	$(document).ready(function(){
		selectFileList();
	});
	
	function selectFileList(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/selectFileList.do",
			data:{sourcetableid:consultid, filecd:'계약서'},
			//data:{consultid:sourcetableid, filecd:'의견서'},
			dataType:"json",
			async:false,
			success:setFileList
		});
	}
	
	function setFileList(data){
		if(data.flist.length != "0"){
			$(".dragAndDropDiv").css("width", "50%");
			$(".dragAndDropDiv").css("font-size", "85%");
		}
		var html = "";
		$.each(data.flist, function(key,input){
			html += "<div class=\"statusbar odd\">";
			html += "<div class=\"filename\" onclick=\"downFile('"+input.SERVERFILENAME+"','"+input.PCFILENAME+"')\" style=\"width:74%;cursor:pointer;\">";
			html += input.PCFILENAME;
			html += "</div>";
			html += "<div class=\"abort\" style=\"float:none; width:25%;\" onclick=\"delfile('"+input.FILEID+"')\">";
			html += "삭제";
			html += "</div>";
			html += "</div>";
		});
		$(".hkk").css("width", "50%");
		$(".hkk").append(html);
	}
	
	function delfile(FILEID){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/deleteTB_SU_C_FILE.do",
			data:{FILEID:FILEID},
			//data:{consultid:sourcetableid, filecd:'의견서'},
			dataType:"json",
			async:false,
			success:function(result){
				document.location.reload();
			}
		});
	}
	
	function saveContractFile(){
		
		for (var i = 0; i < fileList.length; i++) {
			var formData = new FormData();
			formData.append("file"+i, fileList[i]);
			formData.append("sourcetableid", consultid);
			
			var status = statusList[i];
			var uploadURL = "${pageContext.request.contextPath}/web/consult/contractFileUpload.do";
			uploadFileFunction(status, uploadURL, formData);
		}
		document.location.reload();
		opener.goSch();
		alert("문서가 저장 되었습니다.");
		window.close();
	}
	
	function uploadFileFunction(status, uploadURL, formData){
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
				
			}
		});
		status.setAbort(jqXHR);
	}
	
	function downFile(sf,pcf){ 
		var frm = document.filefrm;
		frm.Pcfilename.value = pcf;
		frm.Serverfile.value = sf;
		frm.folder.value = "CONSULT";
		frm.action = "${pageContext.request.contextPath}/Download.do";
		frm.submit();
	}
</script>
<strong class="popTT">
	계약서 첨부
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="filefrm" name="filefrm" method="post">
	<input type="hidden" id="consultid" name="consultid" value="<%=consultid%>" />
	<input type="hidden" name="Serverfile" id="Serverfile" value=""/>
	<input type="hidden" name="Pcfilename" id="Pcfilename" value=""/>
	<input type="hidden" name="folder" id="folder" value=""/>
	<div class="popC" style="height:350px;">
		<div class="popA" style="height:255px;">
			<div id="fileUpload" class="dragAndDropDiv" style="height:100%; padding:50px 0px 10px 10px; font-size:160%;">
				<input type="file" multiple style="display:none" id="filesel"/>
				<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
				<!-- <label for="filesel">(드래그 앤 드롭으로 파일 첨부가 가능합니다.)</label> -->
			</div>
			<div id="fileList">
				<input type="hidden" />
			</div>
			<div id="hkk" class="hkk">
			</div>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" onclick="saveContractFile();" class="sBtn type1">등록</a>
		</div>
	</div>
</form>
