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
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	
	var AGT_MNG_NO = "<%=AGT_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	
	$(document).ready(function(){
		
	});
	
	function goSearchLawyer(){
		var cw=500;
		var ch=700;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","lawyerpop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "lawyerpop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchLawyerPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goInfoSave(){
		$.ajax({
			url: "<%=CONTEXTPATH%>/web/suit/insertChrgLawyer.do",
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
					formData.append("FILE_SE", "CHRG");
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
</script>
<style>
	.popW{height:100%}
	.popC{height:100%}
	.popA{height:470px}
	.pop_infoTable{height:100%}
	span{font-size:10px; vertical-align:bottom;}
	#liTitle{padding-left:10px;}
	.ord{float:left; cursor:pointer;}
</style>
<strong class="popTT">
	소송 위임 관리 <span style="font-size:13px; color:#57b9ba";">(변호사/법무법인은 관리 화면에 등록 후 사용하세요)</span>
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="AGT_MNG_NO"  id="AGT_MNG_NO"  value="<%=AGT_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_AGT"/>
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>법무법인</th>
					<td>
						<input type="hidden" id="JDAF_CORP_MNG_NO" name="JDAF_CORP_MNG_NO" value="<%=chrgMap.get("JDAF_CORP_MNG_NO")==null?"":chrgMap.get("JDAF_CORP_MNG_NO").toString()%>"/>
						<input type="text"   id="JDAF_CORP_NM" name="JDAF_CORP_NM" value="<%=chrgMap.get("JDAF_CORP_NM")==null?"":chrgMap.get("JDAF_CORP_NM").toString()%>" readonly="readonly"/>
					</td>
					<th>변호사명</th>
					<td>
						<input type="hidden" id="LWYR_MNG_NO" name="LWYR_MNG_NO" value="<%=chrgMap.get("LWYR_MNG_NO")==null?"":chrgMap.get("LWYR_MNG_NO").toString()%>"/>
						<input type="text" id="LWYR_NM" name="LWYR_NM" value="<%=chrgMap.get("LWYR_NM")==null?"":chrgMap.get("LWYR_NM").toString()%>" readonly="readonly" onclick="goSearchLawyer()" style="width:70%"/>
						<a href="#none" class="innerBtn" id="searchBtn" onclick="goSearchLawyer()">조회</a>
					</td>
				</tr>
				<tr>
					<th>위임일</th>
					<td>
						<input type="text" class="datepick" id="DLGT_YMD" name="DLGT_YMD" style="width: 80px;" value="<%=chrgMap.get("DLGT_YMD")==null?"":chrgMap.get("DLGT_YMD").toString()%>">
					</td>
					<th>위임종료일</th>
					<td>
						<input type="text" class="datepick" id="DLGT_END_YMD" name="DLGT_END_YMD" style="width: 80px;" value="<%=chrgMap.get("DLGT_END_YMD")==null?"":chrgMap.get("DLGT_END_YMD").toString()%>">
					</td>
				</tr>
				
				<tr id="file">
					<th>첨부파일</th>
					<td colspan="3">
						<div id="fileUpload" class="dragAndDropDiv" <%if(chrgFile.size() > 0) {%>style="width:50%;"<%}%>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:45%;">
							<%
							System.out.println("======> 5");
								for(int i=0; i<chrgFile.size(); i++){
									System.out.println("======> 6");
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
				<tr>
					<th>비고</th>
					<td colspan="3">
						<textarea rows="7" cols="" id="RMRK_CN" name="RMRK_CN" placeholder="사임, 재선임 등 특이사항 기재"><%=chrgMap.get("RMRK_CN")==null?"":chrgMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="goInfoSave();">저장</a>
		</div>
	</div>
</form>