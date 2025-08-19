<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap resultMap = request.getAttribute("resultMap")==null?new HashMap():(HashMap)request.getAttribute("resultMap");
	List cdList = request.getAttribute("codeList")==null?new ArrayList():(ArrayList) request.getAttribute("codeList");
	List caseResultFile = request.getAttribute("caseResultFile")==null?new ArrayList():(ArrayList) request.getAttribute("caseResultFile");
	
	String PRGRS_STTS_CD = resultMap.get("PRGRS_STTS_CD")==null?"":resultMap.get("PRGRS_STTS_CD").toString();
	String JDGM_UP_TYPE_CD = resultMap.get("JDGM_UP_TYPE_CD")==null?"":resultMap.get("JDGM_UP_TYPE_CD").toString();
	String JDGM_LWR_TYPE_CD = resultMap.get("JDGM_LWR_TYPE_CD")==null?"":resultMap.get("JDGM_LWR_TYPE_CD").toString();
	String APLY_INCDNT_YN = resultMap.get("APLY_INCDNT_YN")==null?"":resultMap.get("APLY_INCDNT_YN").toString();
	
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":(String)request.getAttribute("WRTR_EMP_NM");
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":(String)request.getAttribute("WRTR_EMP_NO");
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":(String)request.getAttribute("WRT_DEPT_NM");
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":(String)request.getAttribute("WRT_DEPT_NO");
	
	String gbn = request.getAttribute("gbn")==null?"":(String)request.getAttribute("gbn");
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<style>
	.popW{height:100%;}
	p{color:#57b9ba; font-size:13px; font-weight:bold; float:right; margin-right:370px;}
</style>
<script type="text/javascript">
	function progressChg(value) {
		console.log(value);
		if (value == "10001003") {
			$(".finalCont").css("display", "");
		} else {
			$(".finalCont").css("display", "none");
			$('select[name="APLY_INCDNT_YN"]').find('option[value=""]').attr("selected",true);
		}
	}
	
	function aplyRsnChg(yn) {
		if (yn == "Y") {
			$(".aplyRsn").css("display", "none");
			$("#APLY_INCDNT_FAU_RSN").val("");
		} else {
			$(".aplyRsn").css("display", "");
		}
	}
	
	function goSave(){
		if ($("#PRGRS_STTS_CD").val() == "") {
			return alert("진행상태를 선택하세요");
		}
		
		if ($("#JDGM_UP_TYPE_CD").val() == "") {
			return alert("승패소구분을 선택하세요");
		}
		
		if ($("#JDGM_LWR_TYPE_CD").val() == "") {
			return alert("판결분류를 선택하세요");
		}
		
		if ($("#JDGM_ADJ_YMD").val() == "") {
			return alert("판결선고일을 입력하세요");
		}
		
		$("#JDGM_AMT").val(uncomma($("#JDGM_AMT").val()));
		$("#JDGM_AMT_INT").val(uncomma($("#JDGM_AMT_INT").val()));
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertCaseResultInfo.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				if(fileList.length == 0){
					alert("저장이 완료되었습니다.");
					opener.goReLoad();
					window.close();
				}
				
				for (var i = 0; i < fileList.length; i++) {
					var formData = new FormData();
					formData.append("file"+i, fileList[i]);
					formData.append("LWS_MNG_NO", $("#LWS_MNG_NO").val());
					formData.append("INST_MNG_NO", result.INST_MNG_NO);
					formData.append("TRGT_PST_MNG_NO", result.INST_MNG_NO);
					formData.append("FILE_SE", "RES");
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
			},
			error:function(request, status, error){
				alert("저장에 실패하였습니다. 관리자에게 문의바랍니다.");
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
					opener.goReLoad();
					window.close();
				}
			}
		});
		status.setAbort(jqXHR);
	}
</script>

<strong class="popTT">
	종결정보 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>" />
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"  />
	<input type="hidden" name="gbn"             id="gbn"             value="<%=gbn%>"         />
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_INST"/>
	
	<div class="popC">
		<div class="popA" style="max-height:1000px;">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>진행상태</th>
					<td>
						<select name="PRGRS_STTS_CD" id="PRGRS_STTS_CD" onchange="progressChg(this.value);">
							<option value="">선택</option>
						<%
							for(int i=0; i<cdList.size(); i++) {
								HashMap code = (HashMap) cdList.get(i);
								if ("PROGRESSCD".equals(code.get("CD_LCLSF_ENG_NM"))){
									String codeid = code.get("CD_MNG_NO").toString();
						%>
								<option value="<%=code.get("CD_MNG_NO")%>" <%if(PRGRS_STTS_CD.equals(codeid)) out.println("selected");%>>
									<%=code.get("CD_NM")%>
								</option>
						<%
								}
							}
						%>
						</select>
					</td>
					<th>승/패소 구분</th>
					<td>
						<select name="JDGM_UP_TYPE_CD" id="JDGM_UP_TYPE_CD">
							<option value="">선택</option>
						<%
							for(int i=0; i<cdList.size(); i++) {
								HashMap code = (HashMap) cdList.get(i);
								if ("RESULTGBN".equals(code.get("CD_LCLSF_ENG_NM"))){
									String codeid = code.get("CD_MNG_NO").toString();
						%>
								<option value="<%=code.get("CD_MNG_NO")%>" <%if(PRGRS_STTS_CD.equals(codeid)) out.println("selected");%>>
									<%=code.get("CD_NM")%>
								</option>
						<%
								}
							}
						%>
						</select>
					</td>
					<th>판결분류</th>
					<td>
						<select name="JDGM_LWR_TYPE_CD" id="JDGM_LWR_TYPE_CD">
							<option value="">선택</option>
						<%
							for(int i=0; i<cdList.size(); i++) {
								HashMap code = (HashMap) cdList.get(i);
								if ("JDGMTGBN".equals(code.get("CD_LCLSF_ENG_NM"))){
									String codeid = code.get("CD_MNG_NO").toString();
						%>
								<option value="<%=code.get("CD_MNG_NO")%>" <%if(PRGRS_STTS_CD.equals(codeid)) out.println("selected");%>>
									<%=code.get("CD_NM")%>
								</option>
						<%
								}
							}
						%>
						</select>
					</td>
				</tr>
				<tr>
					<th>판결선고일</th>
					<td>
						<input type="text" class="datepick" name="JDGM_ADJ_YMD" id="JDGM_ADJ_YMD" value="<%=resultMap.get("JDGM_ADJ_YMD")==null?"":resultMap.get("JDGM_ADJ_YMD").toString()%>"style="width: 50%"/>
					</td>
					<th>판결송달일</th>
					<td>
						<input type="text" class="datepick" name="RLNG_TMTL_YMD" id="RLNG_TMTL_YMD" value="<%=resultMap.get("RLNG_TMTL_YMD")==null?"":resultMap.get("RLNG_TMTL_YMD").toString()%>" style="width: 50%"/>
					</td>
					<th>판결확정일</th>
					<td>
						<input type="text" class="datepick" name="JDGM_CFMTN_YMD" id="JDGM_CFMTN_YMD" value="<%=resultMap.get("JDGM_CFMTN_YMD")==null?"":resultMap.get("JDGM_CFMTN_YMD").toString()%>" style="width: 50%"/>
					</td>
				</tr>
				<tr>
					<th>판결금액</th>
					<td>
						<input type="text" name="JDGM_AMT" id="JDGM_AMT" value="<%=resultMap.get("JDGM_AMT")==null?"":resultMap.get("JDGM_AMT").toString()%>" onkeyup="numFormat(this);"/>
					</td>
					<th>판결금 이자</th>
					<td>
						<input type="text" name="JDGM_AMT_INT" id="JDGM_AMT_INT" value="<%=resultMap.get("JDGM_AMT_INT")==null?"":resultMap.get("JDGM_AMT_INT").toString()%>" onkeyup="numFormat(this);"/>
					</td>
					<th>승소율</th>
					<td>
						<input type="text" name="WIN_RT" id="WIN_RT" value="<%=resultMap.get("WIN_RT")==null?"":resultMap.get("WIN_RT").toString()%>"/>
					</td>
				</tr>
				<tr>
					<th>판결내용</th>
					<td colspan="5">
						<textarea rows="7" cols="" id="JDGM_CN" name="JDGM_CN" ><%=resultMap.get("JDGM_CN")==null?"":resultMap.get("JDGM_CN").toString()%></textarea>
					</td>
				</tr>
				<tr class="finalCont" style="display:none;">
					<th>소송비용<br/>확정신청 여부</th>
					<td colspan="5">
						<select id="APLY_INCDNT_YN" name="APLY_INCDNT_YN" onchange="aplyRsnChg(this.value);">
							<option value=""  <%if(APLY_INCDNT_YN.equals(""))  out.println("checked"); %>>선택</option>
							<option value="N" <%if("N".equals(APLY_INCDNT_YN)) out.println("checked"); %>>N</option>
							<option value="Y" <%if("Y".equals(APLY_INCDNT_YN)) out.println("checked"); %>>Y</option>
						</select>
					</td>
				</tr>
				<tr class="aplyRsn" style="display:none;">
					<th>신청사건불이행사유</th>
					<td colspan="5">
						<textarea rows="7" cols="" id="APLY_INCDNT_FAU_RSN" name="APLY_INCDNT_FAU_RSN" ><%=resultMap.get("APLY_INCDNT_FAU_RSN")==null?"":resultMap.get("APLY_INCDNT_FAU_RSN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>판결문</th>
					<td colspan="5">
						<div id="fileUpload" class="dragAndDropDiv">
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:49%;">
							<%
								for(int i=0; i<caseResultFile.size(); i++){
									HashMap result = (HashMap)caseResultFile.get(i);
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'><%=result.get("PHYS_FILE_NM") %></div><div class="abort"><input type="checkbox" name="delfile[]" value="<%=result.get("FILE_MNG_NO") %>"/>　삭제</div>
							</div>
							<%
								}
							%>
						</div>
						<div id="hkk" class="hkk"></div>
					</td>
				</tr>
			</table>
			
			<hr class="margin20">
			<div class="subBtnW center">
				<a href="#none" onclick="goSave();" class="sBtn type1">등록</a>
			</div>
		</div>
	</div>
</form>
