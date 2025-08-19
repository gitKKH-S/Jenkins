<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@	page import="java.util.*"%>
<%@	page import="com.mten.util.*"%>
<script type="text/javascript" src="${resourceUrl}/goyang/js/jquery.number.js"></script>
<%
	String BND_MNG_NO = request.getAttribute("BND_MNG_NO")==null?"":request.getAttribute("BND_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap bondMap = request.getAttribute("bondMap")==null?new HashMap():(HashMap)request.getAttribute("bondMap");
	List bondFile = request.getAttribute("bondFile")==null?new ArrayList():(ArrayList)request.getAttribute("bondFile");
	
	String BND_DBT_SE = bondMap.get("BND_DBT_SE")==null?"":bondMap.get("BND_DBT_SE").toString();
	String TXPR_SE_NO = bondMap.get("TXPR_SE_NO")==null?"":bondMap.get("TXPR_SE_NO").toString();
	String TXTN_NO = bondMap.get("TXTN_NO")==null?"":bondMap.get("TXTN_NO").toString();
	String disYn = "N";
	if (!TXTN_NO.equals("")) {
		disYn = "Y";
	}
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var BND_MNG_NO = "<%=BND_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	
	$(document).ready(function(){
		// 전화번호 - 삽입
		$("#CNCPR_TELNO").on("keyup", function(){
			$(this).val($(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-"));
		});
	});
	
	function goSaveBondInfo(){
		$("#BND_AMT").val(uncomma($("#BND_AMT").val()));
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertBondInfo.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				if(fileList.length == 0){
					alert("저장이 완료되었습니다.");
					opener.document.getElementById("focus").value = "1";
					opener.goReLoad();
					opener.goBondView(result.BND_MNG_NO);
					window.close();
				}
				
				for (var i = 0; i < fileList.length; i++) {
					var formData = new FormData();
					
					formData.append("file"+i, fileList[i]);
					formData.append("LWS_MNG_NO",      $("#LWS_MNG_NO").val());
					formData.append("INST_MNG_NO",     $("#INST_MNG_NO").val());
					formData.append("TRGT_PST_MNG_NO", result.BND_MNG_NO);
					formData.append("FILE_SE", "BOND");
					formData.append("SORT_SEQ", i);
					
					var other_data = $('#frm').serializeArray();
					$.each(other_data,function(key,input){
						if(input.name != 'LWS_MNG_NO' && input.name != 'INST_MNG_NO'){
							formData.append(input.name,input.value);
						}
					});
					
					var status = statusList[i];
					var uploadURL = "${pageContext.request.contextPath}/web/suit/fileUpload.do";
					uploadFileFunction(status, uploadURL, formData, i, fileList.length, result.BND_MNG_NO);
				}
			}
		});
	}
	
	function uploadFileFunction(status, uploadURL, formData, idx, maxIdx, BND_MNG_NO){
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
					opener.goBondView(result.BND_MNG_NO);
					window.close();
				}
			}
		});
		status.setAbort(jqXHR);
	}
</script>
<style>
	.datepick{width:80%}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="BND_MNG_NO"      id="BND_MNG_NO"      value="<%=BND_MNG_NO%>" />
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_BND"/>
	<strong class="popTT">
		채권관리
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popA" style="max-height:1000px; overflow-y:hidden;">
			<table class="pop_infoTable write" style="height:100%">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>구분</th>
					<td>
						<select name="BND_DBT_SE" id="BND_DBT_SE">
							<option <%if("B".equals(BND_DBT_SE) || BND_DBT_SE.equals("")) out.println("selected");%> value="B">채권</option>
							<option <%if("D".equals(BND_DBT_SE)) out.println("selected");%> value="D">채무</option>
						</select>
					</td>
					<th>금액</th>
					<td>
						<input type="text" id="BND_AMT" name="BND_AMT" value="<%=bondMap.get("BND_AMT")==null?"":bondMap.get("BND_AMT").toString()%>" onkeyup="numFormat(this);">
					</td>
				</tr>
				<tr>
					<th>당사자명</th>
					<td>
						<input type="text" id="CNCPR_NM" name="CNCPR_NM" value="<%=bondMap.get("CNCPR_NM")==null?"":bondMap.get("CNCPR_NM").toString()%>">
					</td>
					<th>당사자전화번호</th>
					<td>
						<input type="text" id="CNCPR_TELNO" name="CNCPR_TELNO" value="<%=bondMap.get("CNCPR_TELNO")==null?"":bondMap.get("CNCPR_TELNO").toString()%>">
					</td>
				</tr>
				<tr>
					<th>당사자 우편번호</th>
					<td>
						<input type="text" id="CNCPR_ZIP" name="CNCPR_ZIP" style="width:85%;" value="<%=bondMap.get("CNCPR_ZIP")==null?"":bondMap.get("CNCPR_ZIP").toString()%>">
					</td>
					<th>당사자 주소</th>
					<td>
						* 도로명주소로 입력하세요
						<input type="text" id="CNCPR_ADDR" name="CNCPR_ADDR" style="width:85%;" value="<%=bondMap.get("CNCPR_ADDR")==null?"":bondMap.get("CNCPR_ADDR").toString()%>">
					</td>
				</tr>
				<tr>
					<th>채권발행일</th>
					<td>
						<input type="text" name="BND_PBLCN_YMD" id="BND_PBLCN_YMD" class="datepick" value="<%=bondMap.get("BND_PBLCN_YMD")==null?"":bondMap.get("BND_PBLCN_YMD").toString()%>" style="width:100px;">
					</td>
					<th>판결확정일</th>
					<td>
						<input type="text" name="JDGM_CFMTN_YMD" id="JDGM_CFMTN_YMD" class="datepick" value="<%=bondMap.get("JDGM_CFMTN_YMD")==null?"":bondMap.get("JDGM_CFMTN_YMD").toString()%>" style="width:100px;">
					</td>
				</tr>
				<tr>
					<th colspan="4">세외수입 부과정보</th>
				</tr>
				<tr>
					<th>세외수입 계정번호</th>
					<td>
						<input type="text" id="SYS_ID" name="SYS_ID" value="<%=bondMap.get("SYS_ID")==null?"":bondMap.get("SYS_ID").toString()%>" <%if("Y".equals(disYn)){out.println("disabled");}%>>
					</td>
					<th>개인여부</th>
					<td>
						<select name="TXPR_SE_NO" id="TXPR_SE_NO" <%if("Y".equals(disYn)){out.println("disabled");}%>>
							<option value=""   <%if(TXPR_SE_NO.equals("")) out.println("selected");%>>선택</option>
							<option value="10" <%if("10".equals(TXPR_SE_NO)) out.println("selected");%>>개인</option>
							<option value="12" <%if("12".equals(TXPR_SE_NO)) out.println("selected");%>>외국인</option>
							<option value="20" <%if("20".equals(TXPR_SE_NO)) out.println("selected");%>>단체(종교, 문종, 기타 등)</option>
							<option value="30" <%if("30".equals(TXPR_SE_NO)) out.println("selected");%>>법인(회사, 학교법인, 의료법인 등)</option>
							<option value="40" <%if("40".equals(TXPR_SE_NO)) out.println("selected");%>>공공기관(국가, 자치단체 등)</option>
							<option value="50" <%if("50".equals(TXPR_SE_NO)) out.println("selected");%>>외국기관(외국정보 및 주한국제기관 등)</option>
							<option value="99" <%if("99".equals(TXPR_SE_NO)) out.println("selected");%>>기타</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>과세일자</th>
					<td>
						<input type="text" name="TXTN_YMD" id="TXTN_YMD" class="datepick" value="<%=bondMap.get("TXTN_YMD")==null?"":bondMap.get("TXTN_YMD").toString()%>" style="width:100px;" <%if("Y".equals(disYn)){out.println("disabled");}%>>
					</td>
					<th>납기일자</th>
					<td>
						<input type="text" name="DUDT_YMD" id="DUDT_YMD" class="datepick" value="<%=bondMap.get("DUDT_YMD")==null?"":bondMap.get("DUDT_YMD").toString()%>" style="width:100px;" <%if("Y".equals(disYn)){out.println("disabled");}%>>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3">
						<textarea rows="5" cols="200" name="RMRK_CN" id="RMRK_CN"><%=bondMap.get("RMRK_CN")==null?"":bondMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td colspan="3">
						<div id="fileUpload" class="dragAndDropDiv" <%if(bondFile.size() > 0) {%>style="width:50%;"<%}%>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:45%;">
							<%
								for(int i=0; i<bondFile.size(); i++){
									HashMap result = (HashMap)bondFile.get(i);
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
			<a href="#none" class="sBtn type1" onclick="goSaveBondInfo();">등록</a>
		</div>
	</div>
</form>