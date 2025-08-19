<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap costMap = request.getAttribute("costMap")==null?new HashMap():(HashMap)request.getAttribute("costMap");
	List targetList = request.getAttribute("targetList")==null?new ArrayList():(ArrayList)request.getAttribute("targetList");
	List codeList = request.getAttribute("codeList")==null?new ArrayList():(ArrayList)request.getAttribute("codeList");
	List costFile = request.getAttribute("costFile")==null?new ArrayList():(ArrayList)request.getAttribute("costFile");
	
	String CST_PRCS_SE = costMap.get("CST_PRCS_SE")==null?"":costMap.get("CST_PRCS_SE").toString();
	String CST_SE_CD = costMap.get("CST_SE_CD")==null?"":costMap.get("CST_SE_CD").toString();
	String CST_TRGT_MNG_NO = costMap.get("CST_TRGT_MNG_NO")==null?"":costMap.get("CST_TRGT_MNG_NO").toString();
	String CST_PRCS_CMPTN_YN = costMap.get("CST_PRCS_CMPTN_YN")==null?"":costMap.get("CST_PRCS_CMPTN_YN").toString();
	
	
	String CST_MNG_NO = request.getAttribute("CST_MNG_NO")==null?"":request.getAttribute("CST_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr" />
<script type="text/javascript">
	var CST_MNG_NO = "<%=CST_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	
	$(document).ready(function(){
		
	});
	
	function goCalPop(){
		var gbn = $("#CST_SE_CD").val();
		
		var cw=500;
		var ch=320;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","cal",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "cal");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/calPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:gbn}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function costInfoSave(){
		
		$("#PRCS_AMT").val(uncomma($("#PRCS_AMT").val()));
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertCostInfo.do",
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
				
				var oseq = result.CST_MNG_NO;
				for (var i = 0; i < fileList.length; i++) {
					var formData = new FormData();
					
					formData.append("file"+i, fileList[i]);
					formData.append("LWS_MNG_NO",      $("#LWS_MNG_NO").val());
					formData.append("INST_MNG_NO",     $("#INST_MNG_NO").val());
					formData.append("TRGT_PST_MNG_NO", result.CST_MNG_NO);
					formData.append("FILE_SE", "COST");
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
	
	function setCalBtn(text) {
		if (text == "착수금" || text == "인지대") {
			$("#calPop").css("display", "");
		} else {
			$("#calPop").css("display", "none");
		}
	}
</script>
<strong class="popTT">
	비용 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="CST_MNG_NO"      id="CST_MNG_NO"      value="<%=CST_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NO"        id="WRTR_EMP_NO"        value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"          id="WRTR_EMP_NM"          value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM"        id="WRT_DEPT_NM"        value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"          id="WRT_DEPT_NO"          value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_CST"/>
	<input type="hidden" name="CST_SE"            id="CST_SE"            value="M"/>
	<div class="popC">
		<div class="popA" style="max-height:700px; overflow-y:hidden;">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>구분</th>
					<td>
						<label><input type="radio" name="CST_PRCS_SE" value="J" <%if(CST_PRCS_SE.equals("") || "J".equals(CST_PRCS_SE)) out.println("checked");%> checked="checked"/> 지급</label>&nbsp;
						<label><input type="radio" name="CST_PRCS_SE" value="H" <%if("H".equals(CST_PRCS_SE)) out.println("checked");%>/> 회수</label>
					</td>
					<th>예산구분</th>
					<td>
						<select id="CST_SE_CD" name="CST_SE_CD" onchange="setCalBtn(this.options[this.selectedIndex].text);">
							<option value="">선택</option>
						<%
							for(int i=0; i<codeList.size(); i++) {
								HashMap code = (HashMap) codeList.get(i);
								if ("COSTGBN".equals(code.get("CD_LCLSF_ENG_NM"))){
									String codeid = code.get("CD_MNG_NO").toString();
						%>
								<option value="<%=code.get("CD_MNG_NO")%>" <%if(CST_SE_CD.equals(codeid)) out.println("selected");%>>
									<%=code.get("CD_NM")%>
								</option>
						<%
								}
							}
						%>
						</select>
						<a href="#none" class="innerBtn" onclick="goCalPop()" id="calPop" style="display:none;">계산기</a>
					</td>
				</tr>
				<tr>
					<th>비용대상</th>
					<td>
						<select id="CST_TRGT_MNG_NO" name="CST_TRGT_MNG_NO">
							<option value="">선택</option>
						<%
							for(int i=0; i<targetList.size(); i++) {
								HashMap target = (HashMap) targetList.get(i);
								String AGT_MNG_NO = target.get("AGT_MNG_NO")==null?"":target.get("AGT_MNG_NO").toString();
						%>
								<option value="<%=target.get("AGT_MNG_NO")%>" <%if(CST_TRGT_MNG_NO.equals(AGT_MNG_NO)) out.println("selected");%>>
									<%=target.get("LWYR_NM")%>
								</option>
						<%
							}
						%>
						</select>
					</td>
					<th>금액</th>
					<td>
						<input type="text" id="PRCS_AMT" name="PRCS_AMT" value="<%=costMap.get("PRCS_AMT")==null?"":costMap.get("PRCS_AMT").toString()%>" onkeyup="numFormat(this);">
					</td>
				</tr>
				<tr>
					<th>처리일자</th>
					<td>
						<input type="text" class="datepick" id="CST_PRCS_YMD" name="CST_PRCS_YMD" value="<%=costMap.get("CST_PRCS_YMD")==null?"":costMap.get("CST_PRCS_YMD").toString()%>" style="width:80px;">
					</td>
					<th>처리완료여부</th>
					<td>
						<select id="CST_PRCS_CMPTN_YN" name="CST_PRCS_CMPTN_YN">
							<option value=""  <%if(CST_PRCS_CMPTN_YN.equals("")) out.println("selected");%>>선택하세요</option>
							<option value="N" <%if("N".equals(CST_PRCS_CMPTN_YN)) out.println("selected");%>>N</option>
							<option value="Y" <%if("Y".equals(CST_PRCS_CMPTN_YN)) out.println("selected");%>>Y</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3">
						<textarea rows="3" cols="20" id="RMRK_CN" name="RMRK_CN"><%=costMap.get("RMRK_CN")==null?"":costMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td colspan="3">
						<div id="fileUpload" class="dragAndDropDiv" <%if(costFile.size() > 0) {%>style="width:50%;"<%}%>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:45%;">
							<%
								for(int i=0; i<costFile.size(); i++){
									HashMap result = (HashMap)costFile.get(i);
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
			<a href="#none" class="sBtn type1" onclick="costInfoSave();">등록</a>
		</div>
	</div>
</form>