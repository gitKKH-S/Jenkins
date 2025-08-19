<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="net.sf.json.JSONArray"%>
<%
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
	
	List cdList = request.getAttribute("codeList")==null?new ArrayList():(ArrayList) request.getAttribute("codeList");
	HashMap suitMap = request.getAttribute("suitMap")==null?new HashMap():(HashMap)request.getAttribute("suitMap");
	List suitContFile = request.getAttribute("suitContFile")==null?new ArrayList():(ArrayList)request.getAttribute("suitContFile");
	
	String LWS_RQST_MNG_NO = suitMap.get("LWS_RQST_MNG_NO")==null?"":suitMap.get("LWS_RQST_MNG_NO").toString();
	String LWS_UP_TYPE_CD  = suitMap.get("LWS_UP_TYPE_CD")==null?"":suitMap.get("LWS_UP_TYPE_CD").toString();
	String LWS_LWR_TYPE_CD = suitMap.get("LWS_LWR_TYPE_CD")==null?"":suitMap.get("LWS_LWR_TYPE_CD").toString();
	String LWS_MNG_NO      = suitMap.get("LWS_MNG_NO")==null?"":suitMap.get("LWS_MNG_NO").toString();
	String IMPT_LWS_YN     = suitMap.get("IMPT_LWS_YN")==null?"":suitMap.get("IMPT_LWS_YN").toString();
	
	Date now = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy년 MM월 dd일");
	String formatedNow = formatter.format(now);
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var LWS_UP_TYPE_CD = "<%=LWS_UP_TYPE_CD%>";
	var LWS_LWR_TYPE_CD = "<%=LWS_LWR_TYPE_CD%>";
	var LWS_RQST_MNG_NO = "<%=LWS_RQST_MNG_NO%>";
	
	$(document).ready(function(){
		if (LWS_RQST_MNG_NO != "") {
			chgUpTypeCd(LWS_UP_TYPE_CD);
		}
	});
	
	function saveSuitInfo(){
		if(confirm("등록 하시겠습니까?")){
			
			if($("#LWS_INCDNT_NM").val() == ""){
				return alert("소송명을 입력하세요");
			}
			
			if($("#LWS_UP_TYPE_CD").val() == "" || $("#LWS_LWR_TYPE_CD").val() == ""){
				return alert("사건유형을 선택하세요");
			}
			
			if($("#LWS_RLT_NM").val() == ""){
				return alert("소송상대방을 입력하세요");
			}
			
			if($("#LWS_CONF_DATA_CN").val() == ""){
				return alert("입증자료를 입력하세요");
			}
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/insertSuitConsultInfo.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					$("#LWS_RQST_MNG_NO").val(result.LWS_RQST_MNG_NO);
					
					if(fileList.length == 0){
						alert(result.msg);
						document.frm.action="<%=CONTEXTPATH%>/web/suit/suitConsultViewPage.do";
						document.frm.submit();
					}
					
					for (var i = 0; i < fileList.length; i++) {
						var formData = new FormData();
						formData.append("file"+i, fileList[i]);
						formData.append("LWS_MNG_NO", result.LWS_RQST_MNG_NO);
						formData.append("INST_MNG_NO", result.LWS_RQST_MNG_NO);
						formData.append("TRGT_PST_MNG_NO", result.LWS_RQST_MNG_NO);
						formData.append("FILE_SE", "CONT");
						formData.append("SORT_SEQ", i);
						
						var other_data = $('#frm').serializeArray();
						$.each(other_data,function(key,input){
							if(input.name != 'LWS_RQST_MNG_NO'){
								formData.append(input.name, input.value);
							}
						});
						
						var status = statusList[i];
						var uploadURL = "${pageContext.request.contextPath}/web/suit/fileUpload.do";
						uploadFileFunction(status, uploadURL, formData, i, fileList.length);
					}
				},
				error:function(request, status, error){
					alert("저장에 실패하였습니다. 관리자에게 문의바랍니다.");
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
					alert("저장이 완료되었습니다.");
					document.frm.action="<%=CONTEXTPATH%>/web/suit/suitConsultViewPage.do";
					document.frm.submit();
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/goSuitConsultList.do";
		document.frm.submit();
	}
	
	function chgUpTypeCd (uptypecd) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectLwsLwrTypeCdList.do",
			data: {type:uptypecd},
			dataType:"json",
			async:false,
			success:setOptionList
		});
	}
	
	function setOptionList(data){
		$("#LWS_LWR_TYPE_CD").children('option').remove();
		var html="";
		
		if(data.result.length > 0){
			html += "<option value=''>선택</option>";
			$.each(data.result, function(index, val){
				if(LWS_LWR_TYPE_CD == val.CD_MNG_NO){
					html += "<option value='"+val.CD_MNG_NO+"' selected>"+val.CD_NM+"</option>";
				}else{
					html += "<option value='"+val.CD_MNG_NO+"'>"+val.CD_NM+"</option>";
				}
			});
		}
		
		$("#LWS_LWR_TYPE_CD").append(html);
	}
</script>
<style>
	#mergecaseadd tr td{border:0px;}
	.merInput{width:60%;}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="${_csrf.parameterName}"   value="${_csrf.token}"/>
	<input type="hidden" name="LWS_RQST_MNG_NO" id="LWS_RQST_MNG_NO" value="<%=LWS_RQST_MNG_NO%>" />
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_RQST"/>
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="searchForm"      id="searchForm"      value="<%=searchForm%>"/>
	
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="innerB">
			<table class="infoTable write">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>의뢰자</th>
					<td>
						<input type="hidden" name="LWS_RQST_EMP_NO" id="LWS_RQST_EMP_NO" value="<%=WRTR_EMP_NO%>" />
						<input type="hidden" name="LWS_RQST_EMP_NM" id="LWS_RQST_EMP_NM" value="<%=WRTR_EMP_NM%>"/>
						<%out.println(WRTR_EMP_NM);%>
					</td>
					<th>의뢰부서</th>
					<td>
						<input type="hidden" name="LWS_RQST_DEPT_NO" id="LWS_RQST_DEPT_NO" value="<%=WRT_DEPT_NO%>" />
						<input type="hidden" name="LWS_RQST_DEPT_NM" id="LWS_RQST_DEPT_NM" value="<%=WRT_DEPT_NM%>"/>
						<%out.println(WRT_DEPT_NM);%>
					</td>
					<th>의뢰일</th>
					<td>
						<%out.println(formatedNow);%>
					</td>
				</tr>
				<tr>
					<th>사건명</th>
					<td colspan="5">
						<input type="text" name="LWS_INCDNT_NM" id="LWS_INCDNT_NM" value="<%=suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString()%>" style="width:95%">
					</td>
				</tr>
				<tr>
					<th>소송유형</th>
					<td>
						<select name="LWS_UP_TYPE_CD" id="LWS_UP_TYPE_CD" onchange="chgUpTypeCd(this.value);">
							<option>선택</option>
<%
						for(int i=0; i<cdList.size(); i++) {
							HashMap map = (HashMap) cdList.get(i);
							String codeType = map.get("CD_LCLSF_ENG_NM")==null?"":map.get("CD_LCLSF_ENG_NM").toString();
							
							if ("LWSTYPECD".equals(codeType)) {
								if (LWS_UP_TYPE_CD.equals(map.get("CD_MNG_NO").toString())) {
									out.println("<option value='"+map.get("CD_MNG_NO").toString()+"' selected>"+map.get("CD_NM").toString()+"</option>");
								} else {
									out.println("<option value='"+map.get("CD_MNG_NO").toString()+"'>"+map.get("CD_NM").toString()+"</option>");
								}
							}
						}
%>
						</select>
						<select name="LWS_LWR_TYPE_CD" id="LWS_LWR_TYPE_CD">
							<option>선택</option>
						</select>
					</td>
					<th>중요소송여부</th>
					<td>
						<label><input type="radio" name="IMPT_LWS_YN" id="IMPT_LWS_YN" value="N" <%if(IMPT_LWS_YN.equals("N") || IMPT_LWS_YN.equals("")) out.println("checked");%>>N</label>&nbsp;
						<label><input type="radio" name="IMPT_LWS_YN" id="IMPT_LWS_YN" value="Y" <%if(IMPT_LWS_YN.equals("Y")) out.println("checked");%>>Y</label>
					</td>
					<th>소송 상대방</th>
					<td>
						<input type="text" name="LWS_RLT_NM" id="LWS_RLT_NM" value="<%=suitMap.get("LWS_RLT_NM")==null?"":suitMap.get("LWS_RLT_NM").toString()%>" style="width:95%" />
					</td>
				</tr>
				<tr>
					<th>사건 개요</th>
					<td colspan="5">
						<textarea rows="5" cols="200" name="INCDNT_OTLN" id="INCDNT_OTLN"><%=suitMap.get("INCDNT_OTLN")==null?"":suitMap.get("INCDNT_OTLN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>주요내용</th>
					<td colspan="5">
						<textarea rows="5" cols="200" name="MAIN_CN" id="MAIN_CN"><%=suitMap.get("MAIN_CN")==null?"":suitMap.get("MAIN_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>입증자료</th>
					<td colspan="5">
						<textarea rows="5" cols="200" name="LWS_CONF_DATA_CN" id="LWS_CONF_DATA_CN"><%=suitMap.get("LWS_CONF_DATA_CN")==null?"":suitMap.get("LWS_CONF_DATA_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="5">
						<textarea rows="5" cols="200" name="RMRK_CN" id="RMRK_CN"><%=suitMap.get("RMRK_CN")==null?"":suitMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일(입증자료)</th>
					<td colspan="5">
						<div id="fileUpload" class="dragAndDropDiv" <%if(suitContFile.size() > 0) {%>style="width:50%;"<%}%>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:45%;">
							<%
								for(int i=0; i<suitContFile.size(); i++){
									HashMap result = (HashMap)suitContFile.get(i);
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'>
									<%=result.get("PHYS_FILE_NM") %> (<%=result.get("VIEW_SZ") %>)
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
		<div class="subBtnW center">
			<a id="saveBtn" href="#none" class="sBtn type1" onclick="saveSuitInfo();">등록</a>
			<a href="#none" class="sBtn type2" onclick="goListPage();">목록</a>
		</div>
	</div>
</form>
