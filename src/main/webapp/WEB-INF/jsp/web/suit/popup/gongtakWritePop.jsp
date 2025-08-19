<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String depositid = request.getAttribute("depositid")==null?"":request.getAttribute("depositid").toString();
	String suitid = request.getAttribute("suitid")==null?"":request.getAttribute("suitid").toString();
	String caseid = request.getAttribute("caseid")==null?"":request.getAttribute("caseid").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<style>
	/* .popW{min-width:537px;} */
	/* .popC{height:500px;} */
	.popA{height:535px;}
</style>

<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr" />
<script type="text/javascript">
	
	var depositid = "<%=depositid%>";
	var suitid = "<%=suitid%>";
	var caseid = "<%=caseid%>";
	var fileidList = new Array();
	
	$(document).ready(function(){
		$("#loading").hide();
		
		selectCauseOption();
		
		if(suitid != "0" && depositid == "0"){
			$("#suitnm").val(opener.document.getElementById("getSuitnm").value.trim());
			$("#suitid").val(suitid);
			$("#caseid").val(caseid);
		}
		
		if(depositid != "0"){
			$("#suitid").val(suitid);
			$("#caseid").val(caseid);
			getGongtakInfo();
		}
	});
	
	$(function(){
		$("#hkk").sortable();
	});
	
	function getGongtakInfo(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectGongtakInfo.do",
			data:{depositid:depositid, suitid:suitid, caseid:caseid},
			dataType:"json",
			async:false,
			success:setGongTakInfo
		});
	}
	
	function selectCauseOption(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectOptionList.do",
			data: {"type": "CAUSECD"},
			dataType:"json",
			async:false,
			success:setOptionList
		});
	}
	
	function setGongTakInfo(data){
		$.each(data.result, function(key,val){
			$("#type").val(val.TYPE).attr("selected", "selected");
			$("#courtnm").val(val.COURTNM);
			$("#suitnm").val(val.SUITNM);
			$("#courtid").val(val.COURTCD);
			$("#gongtakdt").val(val.GONGTAKDT);
			$("#gongtakamt").val(comma(val.GONGTAKAMT));
			$("#causecd").val(val.CAUSECD).attr("selected", "selected");
			$("#recoveryyn").val(val.RECOVERYYN).attr("selected", "selected");
		});
		
		selectFileList();
	}
	

	function selectFileList(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectFileList.do",
			data:{oseq:depositid, tableid:'TB_SU_DEPOSIT'},
			dataType:"json",
			async:false,
			success:setFileList
		});
	}
	
	function setFileList(data){
		if(data.flist.length != "0"){
			$(".dragAndDropDiv").css("width", "45%");
			$(".hkk").css("width", "55%");
			$(".dragAndDropDiv").css("font-size", "85%");
		}
		var html = "";
		$.each(data.flist, function(key,input){
			html += "<div class=\"statusbar odd\">";
			html += "<input type=\"hidden\" name=\"fileid\" value=\""+input.FILEID+"\" />";
			html += "<div class=\"filename\" style=\"width:160px;\">";
			html += input.VIEWFILENM;
			html += "</div>";
			html += "<div class=\"abort\" style=\"float:none; width:80px;\" >";
			html += "<input type=\"checkbox\" name=\"delfile[]\" value=\""+input.FILEID+"\")\"> 삭제";
			html += "</div>";
			html += "</div>";
		});
		$(".hkk").append(html);
	}
	/* 
	function delFile(fileid, serverfilenm){
		if(confirm("파일을 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/fileDelete.do",
				data:{fileid:fileid, serverfilenm:serverfilenm},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					location.reload();
				}
			});
		}
	}
	 */
	
	function setOptionList(data){
		var html="";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				html += "<option value='"+val.CODEID+"'>"+val.CODE+"</option>"
			});
		}
		$("#causecd").append(html);
	}
	
	function goSearchCourt(){
		var url = '<%=CONTEXTPATH%>/web/suit/searchCourtPop.do?gbn=court';
		var wth = "500";
		var hht = "700";
		var pnm = "newEdit2";
		popOpen(pnm,url,wth,hht);
	}
	
	function saveGongTakInfo(){
		
		$("#loading").show();
		
		var len = $("input[name=fileid]").length;
		if(len > 0){
			for(var i=0; i<len; i++){
				fileidList[i] = $("input[name=fileid]").eq(i).attr("value");
				console.log($("input[name=fileid]").eq(i).attr("value"));
			}
		}
		
		$("#gongtakamt").val(uncomma($("#gongtakamt").val()));
		
		if($("#courtid").val() == ""){
			$("#loading").hide();
			return alert("법원을 검색을 통해 선택 해 주세요");
		}
		
		if($("#gongtakdt").val() == ""){
			$("#loading").hide();
			return alert("공탁 일자를 입력하세요");
		}
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/gongTakInfoSave.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				var setOrd = "N";
				if(fileidList.length > 0){
					setOrd = "Y";
				}
				
				if(fileList.length == 0 && fileidList.length == 0){
					$("#loading").hide();
					alert("저장이 완료되었습니다.");
					opener.goReLoad();
					window.close();
				}
				
				var oseq = result.depositid;
				for (var i = 0; i < fileList.length; i++) {
					var formData = new FormData();
					formData.append("file"+i, fileList[i]);
					formData.append("suitid", suitid);
					formData.append("caseid", caseid);
					formData.append("oseq", oseq);
					formData.append("filegbn", "");
					formData.append("ord", i);
					
					var other_data = $('#frm').serializeArray();
					$.each(other_data,function(key,input){
						if(input.name != 'suitid' && input.name != 'caseid'){
							formData.append(input.name,input.value);
						}
					});
					
					var status = statusList[i];
					var uploadURL = "${pageContext.request.contextPath}/web/suit/fileUpload.do";
					uploadFileFunction(status, uploadURL, formData, i, fileList.length, setOrd);
				}
				
				if(fileidList.length > 0){
					for(var f=0; f<fileidList.length; f++){
						var formData = new FormData();
						formData.append("fileid", fileidList[f]);
						formData.append("suitid", suitid);
						formData.append("caseid", caseid);
						formData.append("ord", f);
						
						var uploadURL = "${pageContext.request.contextPath}/web/suit/fileOrdUpdate.do";
						setFileOrd(uploadURL, formData, f, fileidList.length);
					}
				}
			}
		});
	}
	

	function uploadFileFunction(status, uploadURL, formData, idx, maxIdx, setOrd){
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
				if(idx == (maxIdx-1) && setOrd == "N"){
					$("#loading").hide();
					alert("저장이 완료되었습니다.");
					opener.goReLoad();
					window.close();
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function setFileOrd(uploadURL, formData, idx, maxidx){
		$.ajax({
			url:uploadURL,
			type:"POST",
			contentType:false,
			processData:false,
			cache:false,
			data:formData,
			async:true,
			success:function(data){
				if(idx == (maxidx-1)){
					$("#loading").hide();
					alert("저장이 완료되었습니다.");
					opener.goReLoad();
					window.close();
				}
			}
		});
	}
	
	function schSuit(){
		var url = '<%=CONTEXTPATH%>/web/suit/caseSearchPop2.do?gbn=gong';
		var wth = "1200";
		var hht = "620";
		var pnm = "CaseSearch";
		popOpen(pnm,url,wth,hht);
	}
</script>
<strong class="popTT">
	공탁금 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="depositid" id="depositid" value="<%=depositid%>"/>
<%--
	<input type="hidden" name="caseid" id="caseid" value="<%=caseid%>"/>
	<input type="hidden" name="suitid" id="suitid" value="<%=suitid%>"/>
--%>
	
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />

	<input type="hidden" name="fileTable" id="fileTable" value="TB_SU_DEPOSIT"/>
	<div id="loading" class="loading"><img id="loading_img" alt="loading" src="${resourceUrl}/paramquery-3.3.2/images/loading.gif" /></div>
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>사건명</th> <!-- 사건 선택? -->
					<td>
						<input type="text" id="suitnm" name="suitnm" style="width:80%" onclick="schSuit();">
						<input type="hidden" id="suitid" name="suitid" value=""/>
						<input type="hidden" id="caseid" name="caseid" value=""/>
						<a href="#none" onclick="schSuit();" class="innerBtn">사건검색</a>
					</td>
				</tr>
				<tr>
					<th>공탁유형</th>
					<td>
						<select id="type" name="type">
							<option value="0">공탁자</option>
							<option value="1">피공탁자</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>법원</th>
					<td>
						<input type="text" id="courtnm" name="courtnm">
						<input type="hidden" id="courtid" name="courtid">
						<a href="#none" class="innerBtn" id="searchBtn" onclick="goSearchCourt();">검색</a>
					</td>
				</tr>
				<tr>
					<th>공탁일자</th>
					<td>
						<input type="text" class="datepick" id="gongtakdt" name="gongtakdt">
					</td>
				</tr>
				<tr>
					<th>공탁금액</th>
					<td>
						<input type="text" id="gongtakamt" name="gongtakamt" onkeyup="numFormat(this);">
					</td>
				</tr>
				<tr>
					<th>공탁사유</th>
					<td>
						<select id="causecd" name="causecd"></select>
					</td>
				</tr>
				<tr>
					<th>회수여부</th>
					<td>
						<select id="recoveryyn" name="recoveryyn">
							<option value="N">N</option>
							<option value="Y">Y</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td>
						<div id="fileUpload" class="dragAndDropDiv">
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div id="hkk" class="hkk" style="width:50%;">
						</div>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="saveGongTakInfo();">등록</a>
		</div>
	</div>
</form>
