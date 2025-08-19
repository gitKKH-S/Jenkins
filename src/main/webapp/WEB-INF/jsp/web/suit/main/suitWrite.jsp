<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
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
	List suitConfFile = request.getAttribute("suitConfFile")==null?new ArrayList():(ArrayList)request.getAttribute("suitConfFile");
	
	List merList = request.getAttribute("merList")==null?new ArrayList():(ArrayList)request.getAttribute("merList");
	int mcnt = merList.size();
	
	String LWS_UP_TYPE_CD  = suitMap.get("LWS_UP_TYPE_CD")==null?"":suitMap.get("LWS_UP_TYPE_CD").toString();
	String LWS_LWR_TYPE_CD  = suitMap.get("LWS_LWR_TYPE_CD")==null?"":suitMap.get("LWS_LWR_TYPE_CD").toString();
	String LWS_MNG_NO = suitMap.get("LWS_MNG_NO")==null?"":suitMap.get("LWS_MNG_NO").toString();
	String LWS_SE = suitMap.get("LWS_SE")==null?"":suitMap.get("LWS_SE").toString();
	String MER_YN = suitMap.get("MER_YN")==null?"":suitMap.get("MER_YN").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var LWS_UP_TYPE_CD = "<%=LWS_UP_TYPE_CD%>";
	var LWS_LWR_TYPE_CD = "<%=LWS_LWR_TYPE_CD%>";
	
	$(document).ready(function(){
		if (LWS_MNG_NO != "") {
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
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/insertSuitInfo.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					$("#LWS_MNG_NO").val(result.LWS_MNG_NO);
					
					if(fileList.length == 0){
						alert(result.msg);
						document.frm.action="<%=CONTEXTPATH%>/web/suit/suitViewPage.do";
						document.frm.submit();
					}
					
					for (var i = 0; i < fileList.length; i++) {
						var formData = new FormData();
						formData.append("file"+i, fileList[i]);
						formData.append("LWS_MNG_NO", result.LWS_MNG_NO);
						formData.append("INST_MNG_NO", result.LWS_MNG_NO);
						formData.append("TRGT_PST_MNG_NO", result.LWS_MNG_NO);
						formData.append("FILE_SE", "CONF");
						formData.append("SORT_SEQ", i);
						
						var other_data = $('#frm').serializeArray();
						$.each(other_data,function(key,input){
							if(input.name != 'LWS_MNG_NO'){
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
					document.frm.action="<%=CONTEXTPATH%>/web/suit/suitViewPage.do";
					document.frm.submit();
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/goSuitList.do";
		document.frm.submit();
	}
	
	
	function schMerCase(idx) {
		// 사건 검색
		var cw=1200;
		var ch=620;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","caseSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "caseSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/mergeCaseSearchPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:$("#LWS_MNG_NO").val()}));
		newForm.append($("<input/>", {type:"hidden", name:"cnt", value:idx}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function addMer(idx) {
		// 병합사건 행 추가
		var mcnt = $("#mcnt").val();
		var html = "";
		html += "<tr id='mer"+mcnt+"'>";
		html += "	<td>";
		html += "		<input type='hidden' id='MER_LWS_MNG_NO"+mcnt+"' name='MER_LWS_MNG_NO"+mcnt+"'/>";
		html += "		<input type='text' id='MER_LWS_INCDNT_NM"+mcnt+"' readonly style='width:85%;' />";
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='text' id='MER_INST_NM"+mcnt+"' readonly style='width:85%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='text' id='MER_INCDNT_NO"+mcnt+"' readonly style='width:85%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='text' id='MER_YMD"+mcnt+"' name='MER_YMD"+mcnt+"' class='datepick' style='width:85%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<a href='#none' class='innerBtn' onclick=\"schMerCase('"+mcnt+"')\" >조회</a>";
		html += "		<a href='#none' class='innerBtn' onclick=\"addMer('"+mcnt+"')\" >추가</a>";
		html += "		<a href='#none' class='innerBtn' onclick=\"delMer('"+mcnt+"')\" >삭제</a>";
		html += "	</td>";
		
		$("#merTable").append(html);
		mcnt++;
		$("#mcnt").val(mcnt);
	}
	
	function delMer(idx) {
		// 병합사건 행 삭제
		$("mer"+idx).remove();
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
	
	function searchDept(gbn){
		var deptno = "";
		if (gbn == "B") {
			deptno = $("#SPRVSN_DEPT_NO").val();
			
		}
		
		var cw=900;
		var ch=900;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","relViewPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "relViewPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchDeptPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"menu", value:"suit"}));
		newForm.append($("<input/>", {type:"hidden", name:"deptno", value:deptno}));
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:gbn}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
</script>
<style>
	#mergecaseadd tr td{border:0px;}
	.merInput{width:60%;}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="${_csrf.parameterName}"               value="${_csrf.token}"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>" />
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_MNG"/>
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="searchForm"      id="searchForm"      value="<%=searchForm%>"/>
	<input type="hidden" name="mcnt" id="mcnt" value="<%=mcnt+1%>"/>
	
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
					<th>주관부서</th>
					<td>
						<input type="hidden" id="SPRVSN_DEPT_NO" name="SPRVSN_DEPT_NO" value="<%=suitMap.get("SPRVSN_DEPT_NO")==null?"":suitMap.get("SPRVSN_DEPT_NO").toString()%>"/>
						<input type="text" id="SPRVSN_DEPT_NM" name="SPRVSN_DEPT_NM" value="<%=suitMap.get("SPRVSN_DEPT_NM")==null?"":suitMap.get("SPRVSN_DEPT_NM").toString()%>" readonly="readonly" onclick="searchDept()" style="width:70%"/>
					</td>
					<th>주관부서 담당자</th>
					<td>
						<input type="hidden" id="SPRVSN_EMP_NO" name="SPRVSN_EMP_NO" value="<%=suitMap.get("SPRVSN_EMP_NO")==null?"":suitMap.get("SPRVSN_EMP_NO").toString()%>"/>
						<input type="text" id="SPRVSN_EMP_NM" name="SPRVSN_EMP_NM" value="<%=suitMap.get("SPRVSN_EMP_NM")==null?"":suitMap.get("SPRVSN_EMP_NM").toString()%>" readonly="readonly" onclick="searchDept()"/>
						<a href="#none" class="innerBtn" id="searchBtn" onclick="searchDept('A')">조회</a>
					</td>
					<th>주관부서 팀장</th>
					<td>
						<input type="hidden" id="SPRVSN_TMLDR_NO" name="SPRVSN_TMLDR_NO" value="<%=suitMap.get("SPRVSN_TMLDR_NO")==null?"":suitMap.get("SPRVSN_TMLDR_NO").toString()%>"/>
						<input type="text" id="SPRVSN_TMLDR_NM" name="SPRVSN_TMLDR_NM" value="<%=suitMap.get("SPRVSN_TMLDR_NM")==null?"":suitMap.get("SPRVSN_TMLDR_NM").toString()%>" readonly="readonly" onclick="searchDept()"/>
						<a href="#none" class="innerBtn" id="searchBtn" onclick="searchDept('B')">조회</a>
					</td>
				</tr>
				<tr>
					<th>기타주관부서</th>
					<td colspan="5">
						<input type="text" name="ETC_SPRVSN_DEPT_NM" id="ETC_SPRVSN_DEPT_NM" value="<%=suitMap.get("ETC_SPRVSN_DEPT_NM")==null?"":suitMap.get("ETC_SPRVSN_DEPT_NM").toString()%>" style="width:95%">
					</td>
				</tr>
				<tr>
					<th>구분</th>
					<td>
						<label><input type="radio" name="LWS_SE" id="LWS_SE" value="J" <%if(LWS_SE.equals("J") || LWS_SE.equals("")) out.println("checked");%>>제소</label>&nbsp;
						<label><input type="radio" name="LWS_SE" id="LWS_SE" value="P" <%if(LWS_SE.equals("P")) out.println("checked");%>>피소</label>
					</td>
					<th>소제기일자</th>
					<td>
						<input type="text" name="FLGLW_YMD" id="FLGLW_YMD" class="datepick" value="<%=suitMap.get("FLGLW_YMD")==null?"":suitMap.get("FLGLW_YMD").toString()%>" style="width:120px;">
					</td>
					<th>행정청접수일자</th>
					<td>
						<input type="text" name="ADMA_RCPT_YMD" id="ADMA_RCPT_YMD" class="datepick" value="<%=suitMap.get("ADMA_RCPT_YMD")==null?"":suitMap.get("ADMA_RCPT_YMD").toString()%>" style="width:120px;">
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
					<td colspan="3">
						<select name="LWS_UP_TYPE_CD" id="LWS_UP_TYPE_CD" onchange="chgUpTypeCd(this.value);" <%if(!LWS_MNG_NO.equals("")) out.println("disabled");%>>
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
					<th>사건관련토지</th>
					<td>
						<input type="text" name="INCDNT_REL_LAND_NM" id="INCDNT_REL_LAND_NM" value="<%=suitMap.get("INCDNT_REL_LAND_NM")==null?"":suitMap.get("INCDNT_REL_LAND_NM").toString()%>" style="width:95%">
					</td>
				</tr>
				<%
				if(!LWS_MNG_NO.equals("")) {
				%>
				<tr>
					<th>병합 여부</th>
					<td>
						<select id="MER_YN" name="MER_YN">
							<option value="N" <%if(MER_YN.equals("") || "N".equals(MER_YN)) out.println("selected");%>>N</option>
							<option value="Y" <%if("Y".equals(MER_YN)) out.println("selected");%>>Y</option>
						</select>
					</td>
					<th colspan="4"></th>
				</tr>
				<tr>
					<th>병합문서</th>
					<td colspan="5">
						<div style="width:100%;">
							<table class="pop_infoTable write" id="merTable">
								<colgroup>
									<col style="width:*;">
									<col style="width:10%;">
									<col style="width:15%;">
									<col style="width:15%;">
									<col style="width:15%;">
								</colgroup>
								<tr>
									<th>사건명</th>
									<th>심급</th>
									<th>사건번호</th>
									<th>병합일자</th>
									<th></th>
								</tr>
					<%
						if(merList.size() > 0) {
							for(int i=0; i<merList.size(); i++) {
								HashMap merMap = (HashMap)merList.get(i);
					%>
								<tr>
									<td><%=merMap.get("LWS_INCDNT_NM")==null?"":merMap.get("LWS_INCDNT_NM").toString()%></td>
									<td><%=merMap.get("INST_NM")==null?"":merMap.get("INST_NM").toString()%></td>
									<td><%=merMap.get("INCDNT_NO")==null?"":merMap.get("INCDNT_NO").toString()%></td>
									<td><%=merMap.get("MER_YMD")==null?"":merMap.get("MER_YMD").toString()%></td>
									<td>
										<a href="#none" onclick="addMer('<%=i%>');" class="innerBtn">추가</a>
									</td>
								</tr>
					<%
							}
						} else {
					%>
								<tr id="mer0">
									<td>
										<input type="hidden" id="MER_LWS_MNG_NO0" name="MER_LWS_MNG_NO0" />
										<input type="text" id="MER_LWS_INCDNT_NM0" value="" readonly="readonly" style="width:85%;" />
									</td>
									<td>
										<input type="text" id="MER_INST_NM0" value="" readonly="readonly" style="width:85%;"/>
									</td>
									<td>
										<input type="text" id="MER_INCDNT_NO0" value="" readonly="readonly" style="width:85%;"/>
									</td>
									<td>
										<input type="text" class="datepick" id="MER_YMD0" name="MER_YMD0" value="" style="width:85%;"/>
									</td>
									<td>
										<a href="#none" onclick="schMerCase('0');" class="innerBtn">조회</a>
										<a href="#none" onclick="addMer('0');" class="innerBtn">추가</a>
										<a href="#none" onclick="delMer('0');" class="innerBtn">삭제</a>
									</td>
								</tr>
					<%
						}
					%>
							</table>
						</div>
					</td>
				</tr>
				<%
				}
				%>
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
					<th>소송입증내용</th>
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
						<div id="fileUpload" class="dragAndDropDiv" <%if(suitConfFile.size() > 0) {%>style="width:50%;"<%}%>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:45%;">
							<%
								for(int i=0; i<suitConfFile.size(); i++){
									HashMap result = (HashMap)suitConfFile.get(i);
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
