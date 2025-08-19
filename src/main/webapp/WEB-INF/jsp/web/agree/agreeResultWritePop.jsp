<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String CVTN_MNG_NO = request.getParameter("CVTN_MNG_NO")==null?"":request.getParameter("CVTN_MNG_NO").toString();
	
	HashMap result = request.getAttribute("result")==null?new HashMap():(HashMap)request.getAttribute("result");
	List agreeResultFile = request.getAttribute("agreeResultFile")==null?new ArrayList():(ArrayList)request.getAttribute("agreeResultFile");
	
	String RFLT_YN_RSLT_WRTR_EMP_NO = result.get("RFLT_YN_RSLT_WRTR_EMP_NO")==null?"":result.get("RFLT_YN_RSLT_WRTR_EMP_NO").toString();
	String RFLT_YN_RSLT_WRTR_EMP_NM = result.get("RFLT_YN_RSLT_WRTR_EMP_NM")==null?"":result.get("RFLT_YN_RSLT_WRTR_EMP_NM").toString();
	if (RFLT_YN_RSLT_WRTR_EMP_NO.equals("")) {
		RFLT_YN_RSLT_WRTR_EMP_NO = WRTR_EMP_NO;
		RFLT_YN_RSLT_WRTR_EMP_NM = WRTR_EMP_NM;
	}
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var CVTN_MNG_NO = "<%=CVTN_MNG_NO%>";
	
	$(document).ready(function(){
		
	});
	
	function saveInfo(sfilenm, vfilenm){
		
		if(confirm("반영결과를 저장하시겠습니까?")){
			
			var frm = document.wform;
			$.ajax({
				type:"POST",
				url : "${pageContext.request.contextPath}/web/agree/agreeResultSave.do",
				data : $('#wform').serializeArray(),
// 				beforeSend : function(xhr){
// 					xhr.setRequestHeader(header,token);	
// 				},
				dataType: "json",
				async: false,
				success : function(result){
					if(result.data.msg =='ok'){
						if(fileList.length == 0){
							alert("저장되었습니다.");
							opener.viewReload();
							window.close();
						}
						
						for (var i = 0; i < fileList.length; i++) {
							var formData = new FormData();
							formData.append("file"+i, fileList[i]);
							formData.append("CVTN_MNG_NO",     CVTN_MNG_NO);
							formData.append("TRGT_PST_MNG_NO", CVTN_MNG_NO);
							formData.append("TRGT_PST_TBL_NM", "TB_CVTN_MNG");
							formData.append("FILE_SE_NM",      "RES");
							formData.append("SORT_SEQ", i);
							
							var status = statusList[i];
							var uploadURL = "${pageContext.request.contextPath}/web/agree/fileUpload.do";
							uploadFileFunction(status, uploadURL, formData, i, fileList.length);
						}
					}else{
						alert(result.data.msg);
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
					alert("저장되었습니다.");
					opener.viewReload();
					window.close();
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function reLoadPop(){
		location.reload(true);
	}
	
	function closePop(){
		opener.viewReload();
		window.close();
	}
</script>
<style>
	.popA{max-height:1000px; overflow-y:hidden;}
	#docBtn {
		background-color: #1b4993; -moz-border-radius: 4px; -webkit-border-radius: 4px;
		border-radius: 4px; display: inline-block; color: #fff; font-family: arial;
		font-size: 13px; font-weight: normal; padding: 4px 8px; cursor: pointer;
		vertical-align: top; border:0px; float:left;
	}
	#msgTxt{font-size: 13px;}
</style>
<strong class="popTT">
	반영결과 등록
	<a href="#none" class="popClose" onclick="closePop();">닫기</a>
</strong>
<form name="wform" id="wform" method="post">
	<input type="hidden" name="CVTN_MNG_NO"  id="CVTN_MNG_NO"  value="<%=CVTN_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NO"  id="WRTR_EMP_NO"  value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"  id="WRTR_EMP_NM"  value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"  id="WRT_DEPT_NO"  value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"  id="WRT_DEPT_NM"  value="<%=WRT_DEPT_NM%>" />
	
	<input type="hidden" name="RFLT_YN_RSLT_WRTR_EMP_NO"  id="RFLT_YN_RSLT_WRTR_EMP_NO"  value="<%=RFLT_YN_RSLT_WRTR_EMP_NO%>" />
	<input type="hidden" name="RFLT_YN_RSLT_WRTR_EMP_NM"  id="RFLT_YN_RSLT_WRTR_EMP_NM"  value="<%=RFLT_YN_RSLT_WRTR_EMP_NM%>" />
	
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write" style="height:100%;">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>반영여부 결과명</th>
					<td>
						<input type="text" name="RFLT_YN_RSLT_TTL" id="RFLT_YN_RSLT_TTL" value="<%=result.get("RFLT_YN_RSLT_TTL")==null?"":result.get("RFLT_YN_RSLT_TTL").toString()%>" style="width:98%"/>
					</td>
				</tr>
				<tr>
					<th>반영여부 내용</th>
					<td>
						<textarea id="RFLT_YN_RSLT_CN" name="RFLT_YN_RSLT_CN" rows="8" cols="" style="width:100%;"><%=result.get("RFLT_YN_RSLT_CN")==null?"":result.get("RFLT_YN_RSLT_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>
						첨부파일
					</th>
					<td>
						<div id="fileUpload" class="dragAndDropDiv" <%if(agreeResultFile.size()>0){ %>style="width:50%"<%} %>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div id="fileList">
							<input type="hidden" />
						</div>
						<div id="hkk" class="hkk"></div>
						<div class="hkk2" style="width:49%;">
							<%
								for(int i=0; i<agreeResultFile.size(); i++){
									HashMap resultF = (HashMap)agreeResultFile.get(i);
									String filegbn = resultF.get("FILE_SE_NM")==null?"":resultF.get("FILE_SE_NM").toString();
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'><%=resultF.get("DWNLD_FILE_NM") %></div>
								<div class="abort"><input type="checkbox" name="delfile[]" value="<%=resultF.get("FILE_MNG_NO") %>"/>　삭제</div>
							</div>
							<%
								}
							%>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="saveInfo('', '')" id="savebtn"><i class="fa-solid fa-file-import"></i> 저장</a>
		</div>
	</div>
</form>