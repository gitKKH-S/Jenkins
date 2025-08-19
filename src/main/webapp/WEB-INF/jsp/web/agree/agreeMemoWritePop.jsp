<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%
	String writer = request.getAttribute("writer")==null?"":request.getAttribute("writer").toString();
	String writerid = request.getAttribute("writerid")==null?"":request.getAttribute("writerid").toString();
	String deptname = request.getAttribute("deptname")==null?"":request.getAttribute("deptname").toString();
	String deptid = request.getAttribute("deptid")==null?"":request.getAttribute("deptid").toString();
	HashMap memoMap = request.getAttribute("memo")==null?new HashMap():(HashMap)request.getAttribute("memo");
	List fconsultlist = request.getAttribute("filelist")==null?new ArrayList():(ArrayList)request.getAttribute("filelist");
	
	String CVTN_MNG_NO = request.getAttribute("CVTN_MNG_NO")==null?"":request.getAttribute("CVTN_MNG_NO").toString();
	String CVTN_MEMO_MNG_NO = memoMap.get("CVTN_MEMO_MNG_NO")==null?"":memoMap.get("CVTN_MEMO_MNG_NO").toString();
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var CVTN_MNG_NO = "<%=CVTN_MNG_NO%>";
	$(document).ready(function(){
		
	});
	
	function saveProgInfo(sfilenm, vfilenm){
		if(confirm("내용을 저장하시겠습니까?")){
			if ($("#MEMO_TTL").val() == "") {
				return alert("제목을 입력하세요.");
			}
			
			if ($("#MEMO_CN").val() == "") {
				return alert("내용을 입력하세요.");
			}
			
			var frm = document.wform;
			$.ajax({
				type:"POST",
				url : "${pageContext.request.contextPath}/web/agree/saveMemoInfo.do",
				data : $('#wform').serializeArray(),
				dataType: "json",
				async: false,
				success : function(result){
					if(result.data.msg =='ok'){
						$("#CVTN_MEMO_MNG_NO").val(result.data.CVTN_MEMO_MNG_NO);
						
						if(fileList.length == 0){
							alert("저장되었습니다.");
							opener.viewReload();
							window.close();
						}
						
						for (var i = 0; i < fileList.length; i++) {
							var formData = new FormData();
							formData.append("file"+i, fileList[i]);
							formData.append("CVTN_MNG_NO",     CVTN_MNG_NO);
							formData.append("TRGT_PST_MNG_NO", result.data.TRGT_PST_MNG_NO);
							formData.append("TRGT_PST_TBL_NM", "TB_CVTN_MEMO");
							formData.append("FILE_SE_NM",      "");
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
	협약 메모
	<a href="#none" class="popClose" onclick="closePop();">닫기</a>
</strong>
<form name="wform" id="wform" method="post">
<%-- 	<input type="hidden" name="${_csrf.parameterName}"   value="${_csrf.token}"/> --%>
	<input type="hidden" name="CVTN_MNG_NO"      id="CVTN_MNG_NO"      value="<%=CVTN_MNG_NO%>"/>
	<input type="hidden" name="CVTN_MEMO_MNG_NO" id="CVTN_MEMO_MNG_NO" value="<%=CVTN_MEMO_MNG_NO%>"/>
	<input type="hidden" name="inoutcon"  id="inoutcon"  value=""/>
	<input type="hidden" name="apryn"     id="apryn"     value=""/>
	
	<input type="hidden" name="writerid"   id="writerid"   value="<%=writerid%>" />
	<input type="hidden" name="writer"     id="writer"     value="<%=writer%>" />
	<input type="hidden" name="deptid"     id="deptid"     value="<%=deptid%>" />
	<input type="hidden" name="deptname"   id="deptname"   value="<%=deptname%>" />
	
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write" style="height:100%;">
				<colgroup>
					<col style="width:15%;">
					<col style="width:80%;">
				</colgroup>
				<tr>
					<th>제목</th>
					<td>
						<input type="text" id=MEMO_TTL name="MEMO_TTL" style="width:90%" value="<%=memoMap.get("MEMO_TTL")==null?"":memoMap.get("MEMO_TTL").toString()%>">
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<textarea id="MEMO_CN" name="MEMO_CN" rows="10" cols=""><%=memoMap.get("MEMO_CN")==null?"":memoMap.get("MEMO_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>
						첨부파일
					</th>
					<td>
						<div id="fileUpload" class="dragAndDropDiv" <%if(fconsultlist.size()>0){ %>style="width:50%"<%} %>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div id="fileList">
							<input type="hidden" />
						</div>
						<div id="hkk" class="hkk"></div>
						<div class="hkk2" style="width:49%;">
							<%
								for(int i=0; i<fconsultlist.size(); i++){
									HashMap result = (HashMap)fconsultlist.get(i);
									String filegbn = result.get("FILE_SE")==null?"":result.get("FILE_SE").toString();
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'><%=result.get("DWNLD_FILE_NM") %></div>
								<div class="abort"><input type="checkbox" name="delfile[]" value="<%=result.get("FILE_MNG_NO") %>"/>　삭제</div>
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
			<a href="#none" class="sBtn type1" onclick="saveProgInfo('', '')" id="savebtn"><i class="fa-solid fa-file-import"></i> 저장</a>
		</div>
	</div>
</form>