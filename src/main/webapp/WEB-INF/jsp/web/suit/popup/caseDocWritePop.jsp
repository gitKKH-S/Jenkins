<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String DOC_MNG_NO = request.getAttribute("DOC_MNG_NO")==null?"":request.getAttribute("DOC_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	
	HashMap docMap = request.getAttribute("docMap")==null?new HashMap():(HashMap)request.getAttribute("docMap");
	List dateList = request.getAttribute("dateList")==null?new ArrayList():(ArrayList)request.getAttribute("dateList");
	List codeList = request.getAttribute("codeList")==null?new ArrayList():(ArrayList)request.getAttribute("codeList");
	List docFile = request.getAttribute("docFile")==null?new ArrayList():(ArrayList)request.getAttribute("docFile");
	
	String DOC_SE = docMap.get("DOC_SE")==null?"":docMap.get("DOC_SE").toString();
	String DATE_MNG_NO = docMap.get("DATE_MNG_NO")==null?"":docMap.get("DATE_MNG_NO").toString();
	String DOC_TYPE_CD = docMap.get("DOC_TYPE_CD")==null?"":docMap.get("DOC_TYPE_CD").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr" />
<style>
	.filesize{display:none;}
	.filename{width:90px;}
	.gbnBar{float:right;}
	.abort{float:right;}
	#filegbn{height:25px;}
	/* .statusbar{height:65px;}
	.progressBar{width:140px;} */
</style>
<script type="text/javascript">
	var DOC_MNG_NO  = "<%=DOC_MNG_NO%>";
	var LWS_MNG_NO  = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	$(document).ready(function(){
		
	});
	
	function DocInfoSave(){
		
		if($("#DOC_TYPE_CD").val() == ""){
			return alert("문서 종류를 선택하세요");
		}
		
		if($("#DOC_YMD").val() == ""){
			return alert("제출/송달 일자를 입력하세요");
		}
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertDocInfo.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				$("#DOC_MNG_NO").val(result.DOC_MNG_NO);
				
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
					formData.append("TRGT_PST_MNG_NO", result.DOC_MNG_NO);
					formData.append("FILE_SE", "DOC");
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
<form id="frm" name="frm" method="post" action="" enctype="multipart/form-data">
	<input type="hidden" name="DOC_MNG_NO"  id="DOC_MNG_NO"  value="<%=DOC_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="<%=LWS_MNG_NO%>"/>
	
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_SBMSN_TMTL"/>
	
	<strong class="popTT"> 제출/송달 서면 관리 <a href="#none"
		class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popA" style="max-height:750px;">
			<table class="pop_infoTable write">
				<colgroup>
					<col style="width: 18%;">
					<col style="width: 25%;">
					<col style="width: 18%;">
					<col style="width: *;">
				</colgroup>
				<tr>
					<th colspan="4" style="text-align: center">
						<input type="radio" name="DOC_SE" value="J" <%if("J".equals(DOC_SE) || DOC_SE.equals("")) out.println("checked");%>>제출
						<input type="radio" name="DOC_SE" value="S" <%if("S".equals(DOC_SE) ) out.println("checked");%>>송달
						<input type="radio" name="DOC_SE" value="C" <%if("C".equals(DOC_SE) ) out.println("checked");%>>명령
					</th>
				</tr>
				<tr>
					<th>관련기일</th>
					<td>
						<select id="DATE_MNG_NO" name="DATE_MNG_NO">
							<option value="0">기일없음</option>
<%
						if (dateList.size() > 0) {
							for (int d=0; d<dateList.size(); d++) {
								HashMap date = (HashMap) dateList.get(d);
								String getDateid = date.get("DATE_MNG_NO")==null?"":date.get("DATE_MNG_NO").toString();
%>
							<option value="<%=date.get("DATE_MNG_NO")==null?"":date.get("DATE_MNG_NO").toString()%>">
								<%=date.get("DATE_TYPE_NM")==null?"":date.get("DATE_TYPE_NM").toString()%>/<%=date.get("DATE_YMD")==null?"-":date.get("DATE_YMD").toString()%>
							</option>
<%
							}
						}
%>
						</select>
					</td>
					<th>문서종류</th>
					<td>
						<select id="DOC_TYPE_CD" name="DOC_TYPE_CD">
							<option value="">선택</option>
						<%
							System.out.println("======> 2");
							
							for(int i=0; i<codeList.size(); i++) {
								HashMap code = (HashMap) codeList.get(i);
								System.out.println("======> 3");
								if ("DOCGBN".equals(code.get("CD_LCLSF_ENG_NM"))){
								System.out.println("======> 4");
									String codeid = code.get("CD_MNG_NO").toString();
						%>
								<option value="<%=code.get("CD_MNG_NO")%>" <%if(DOC_TYPE_CD.equals(codeid)) out.println("selected");%>>
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
					<th>제출/송달 일자</th>
					<td>
						<input type="text" class="datepick" id="DOC_YMD" name="DOC_YMD" style="width: 80px;" value="<%=docMap.get("DOC_YMD")==null?"":docMap.get("DOC_YMD").toString()%>">
					</td>
					<th></th>
					<td></td>
				</tr>
				<tr>
					<th>문서결과</th>
					<td colspan="3">
						<textarea name="DOC_RSLT_CN" id="DOC_RSLT_CN"><%=docMap.get("DOC_RSLT_CN")==null?"":docMap.get("DOC_RSLT_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>문서내용</th>
					<td colspan="3">
						<textarea name="DOC_CN" id="DOC_CN"><%=docMap.get("DOC_CN")==null?"":docMap.get("DOC_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3">
						<textarea name="RMRK_CN" id="RMRK_CN"><%=docMap.get("RMRK_CN")==null?"":docMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td colspan="3">
						<div id="fileUpload" class="dragAndDropDiv" <%if(docFile.size() > 0) {%>style="width:50%;"<%}%>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:45%;">
							<%
							System.out.println("======> 5");
								for(int i=0; i<docFile.size(); i++){
									System.out.println("======> 6");
									HashMap result = (HashMap)docFile.get(i);
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
			<a href="#none" class="sBtn type1" onclick="DocInfoSave();">등록</a>
		</div>
	</div>
</form>
