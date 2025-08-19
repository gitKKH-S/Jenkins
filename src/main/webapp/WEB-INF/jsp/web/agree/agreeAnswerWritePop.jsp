<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%
	// 자문 위원 목록
	List agreeLawyerList = request.getAttribute("agreeLawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("agreeLawyerList");
	
	// 자문 답변 내용
	HashMap answer = request.getAttribute("answer")==null?new HashMap():(HashMap)request.getAttribute("answer");
	
	// 자문 답변 파일
	List fconsultlist = request.getAttribute("filelist")==null?new ArrayList():(ArrayList)request.getAttribute("filelist");
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	
	String CVTN_MNG_NO = request.getParameter("CVTN_MNG_NO")==null?"":request.getParameter("CVTN_MNG_NO");
	String RVW_OPNN_MNG_NO = request.getParameter("RVW_OPNN_MNG_NO")==null?"":request.getParameter("RVW_OPNN_MNG_NO");
	String menu = request.getParameter("menu")==null?"":request.getParameter("menu");
	String INSD_OTSD_TASK_SE = request.getParameter("INSD_OTSD_TASK_SE")==null?"":request.getParameter("INSD_OTSD_TASK_SE");
	String CVTN_CTRT_TYPE_CD_NM = request.getParameter("CVTN_CTRT_TYPE_CD_NM")==null?"":request.getParameter("CVTN_CTRT_TYPE_CD_NM");
	
	String AGRE_YN = answer.get("AGRE_YN")==null?"N":answer.get("AGRE_YN").toString();
	
	String Menuid = request.getParameter("Menuid")==null?"":request.getParameter("Menuid");
	String writer = request.getAttribute("writer")==null?"":request.getAttribute("writer").toString();
	String writerid = request.getAttribute("writerid")==null?"":request.getAttribute("writerid").toString();
	String deptname = request.getAttribute("deptname")==null?"":request.getAttribute("deptname").toString();
	String deptid = request.getAttribute("deptid")==null?"":request.getAttribute("deptid").toString();
	
	HashMap inAnswer = new HashMap();
	String inAdvisor = "";
	String inConsultlawyerid = "";
	
	String RESMNGNO = "";
	String CONSULTLAWYERID = "";
	String lawname = "";
	
	if("X".equals(GRPCD)) {
		for(int i=0; i<agreeLawyerList.size(); i++){
			HashMap re = (HashMap)agreeLawyerList.get(i);
			String ADVISORID = re.get("RVW_TKCG_EMP_NO")==null?"":re.get("RVW_TKCG_EMP_NO").toString();
			if(USERNO.equals(ADVISORID)) {
				RESMNGNO = ADVISORID;
				CONSULTLAWYERID = re.get("RVW_TKCG_MNG_NO")==null?"":re.get("RVW_TKCG_MNG_NO").toString();
				lawname = re.get("RVW_TKCG_EMP_NM")==null?"":re.get("RVW_TKCG_EMP_NM").toString();
			}
		}
	}
	
	if ("I".equals(INSD_OTSD_TASK_SE)) {
		inAnswer = (HashMap) agreeLawyerList.get(0);
		inAdvisor = inAnswer.get("RVW_TKCG_EMP_NO")==null?"":inAnswer.get("RVW_TKCG_EMP_NO").toString();
		inConsultlawyerid = inAnswer.get("RVW_TKCG_MNG_NO")==null?"":inAnswer.get("RVW_TKCG_MNG_NO").toString();
	}
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var menu = "<%=menu%>";
	var CVTN_MNG_NO = "<%=CVTN_MNG_NO%>";
	var RVW_OPNN_MNG_NO = "<%=RVW_OPNN_MNG_NO%>";
	
	$(document).ready(function(){
		if($("#INSD_OTSD_TASK_SE").val() == "I"){
			$("#setlawyer").css("display", "none");
		}
		
		$("#CHK_AGRE_YN").change(function(){
			if(this.checked) {
				$("#AGRE_YN").val("Y");
			} else {
				$("#AGRE_YN").val("N");
			}
		});
		
		$("#setlawyer").change(function(){
			if ($("#setlawyer option:selected").attr("vo1") != "") {
				alert("이미답변을 완료한 법인입니다. 다시 선택하시기 바랍니다.");
				$("#setlawyer").val("");
			} else {
				$("#RESMNGNO").val($(this).val());
				$("#CONSULTLAWYERID").val($("#setlawyer option:selected").attr("vo2"));
				$("#lawname").text($("#setlawyer option:selected").attr("vo3"));
			}
		});
	});
	
	function saveInfo(sfilenm, vfilenm){
		
		if(confirm("내용을 저장하시겠습니까?")){
			if (RVW_OPNN_MNG_NO == "") {
				if ($("#INSD_OTSD_TASK_SE").val() == "O"){
					
					if($("#RESMNGNO").val() == ''){
						alert("답변을 등록 할 자문위원을 선택하셔야 합니다.");
						return;
					}
				} else {
					$("#RESMNGNO").val("<%=inAdvisor%>");
					$("#CONSULTLAWYERID").val("<%=inConsultlawyerid%>");
				}
			}
			
			var frm = document.wform;
			$.ajax({
				type:"POST",
				url : "${pageContext.request.contextPath}/web/agree/answerSave.do",
				data : $('#wform').serializeArray(),
// 				beforeSend : function(xhr){
// 					xhr.setRequestHeader(header,token);	
// 				},
				dataType: "json",
				async: false,
				success : function(result){
					if(result.data.msg =='ok'){
						$("#RVW_OPNN_MNG_NO").val(result.data.RVW_OPNN_MNG_NO);
						
						if(fileList.length == 0){
							alert("저장되었습니다.");
							opener.viewReload();
							window.close();
						}
						
						for (var i = 0; i < fileList.length; i++) {
							var formData = new FormData();
							formData.append("file"+i, fileList[i]);
							formData.append("CVTN_MNG_NO",     CVTN_MNG_NO);
							formData.append("TRGT_PST_MNG_NO", result.data.RVW_OPNN_MNG_NO);
							formData.append("TRGT_PST_TBL_NM", "TB_CVTN_RVW_OPNN");
							formData.append("FILE_SE_NM",      "OPNN");
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
	협약 답변 작성
	<a href="#none" class="popClose" onclick="closePop();">닫기</a>
</strong>
<form name="wform" id="wform" method="post">
	<input type="hidden" name="CVTN_MNG_NO"          id="CVTN_MNG_NO"          value="<%=CVTN_MNG_NO%>"/>
	<input type="hidden" name="RVW_OPNN_MNG_NO"      id="RVW_OPNN_MNG_NO"      value="<%=RVW_OPNN_MNG_NO%>"/>
	<input type="hidden" name="filegbn"              id="filegbn"              value="ANSWER">
	<input type="hidden" name="inoutcon"             id="inoutcon"             value=""/>
	<input type="hidden" name="apryn"                id="apryn"                value=""/>
	<input type="hidden" name="Menuid"               id="Menuid"               value="<%=Menuid%>">
	<input type="hidden" name="writerid"             id="writerid"             value="<%=writerid%>" />
	<input type="hidden" name="writer"               id="writer"               value="<%=writer%>" />
	<input type="hidden" name="deptid"               id="deptid"               value="<%=deptid%>" />
	<input type="hidden" name="deptname"             id="deptname"             value="<%=deptname%>" />
	<input type="hidden" name="RESMNGNO"             id="RESMNGNO"             value="<%=RESMNGNO%>">
	<input type="hidden" name="CONSULTLAWYERID"      id="CONSULTLAWYERID"      value="<%=CONSULTLAWYERID%>">
	<input type="hidden" name="INSD_OTSD_TASK_SE"    id="INSD_OTSD_TASK_SE"    value="<%=INSD_OTSD_TASK_SE%>">
	<input type="hidden" name="CVTN_CTRT_TYPE_CD_NM" id="CVTN_CTRT_TYPE_CD_NM" value="<%=CVTN_CTRT_TYPE_CD_NM%>">
	<input type="hidden" name="AGRE_YN"              id="AGRE_YN"              value="">
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write" style="height:100%;">
				<colgroup>
					<col style="width:15%;">
					<col style="width:80%;">
					<col style="width:15%;">
					<col style="width:80%;">
				</colgroup>
				<tr>
					<th>작성자</th>
				<%
				if (!CVTN_CTRT_TYPE_CD_NM.equals("의회 동의 여부 사전검토")) {
				%>
					<td colspan="3">
				<%
				} else {
				%>
					<td>
				<%
				}
				%>
				<%
					if ("O".equals(INSD_OTSD_TASK_SE)) {
						if(RVW_OPNN_MNG_NO.equals("") || RVW_OPNN_MNG_NO.length() == 0) {
							if((GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N")>-1) && agreeLawyerList.size() > 0){
				%>
						<select id="setlawyer" style="border:1px solid;">
							<option value="">답변을 등록 할 자문위원을 선택하세요</option>
				<%
							for(int i=0; i<agreeLawyerList.size(); i++){
								HashMap re = (HashMap)agreeLawyerList.get(i);
								String ADVISORID = re.get("RVW_TKCG_EMP_NO")==null?"":re.get("RVW_TKCG_EMP_NO").toString();
				%>
							<option value="<%=ADVISORID%>" 
								vo1="<%=re.get("RVW_OPNN_MNG_NO")==null?"":re.get("RVW_OPNN_MNG_NO").toString()%>" 
								vo2="<%=re.get("RVW_TKCG_MNG_NO")==null?"":re.get("RVW_TKCG_MNG_NO").toString()%>"
								vo3="<%=re.get("RVW_TKCG_EMP_NM")==null?"":re.get("RVW_TKCG_EMP_NM").toString()%>">
								<%=re.get("RVW_TKCG_EMP_NM")==null?"":re.get("RVW_TKCG_EMP_NM").toString()%>
							</option>
				<%
							}
				%>
						</select>
				<%
							} else {
								out.println(lawname);
							}
						} else {
				%>
						<div style="float: left;" id="lawname">
							<%=answer.get("RVW_TKCG_EMP_NM")==null?"":answer.get("RVW_TKCG_EMP_NM").toString()%>
						</div>
				<%
						}
					} else {
				%>
						<div style="float: left;" id="lawname">
							<%=inAnswer.get("RVW_TKCG_EMP_NM")==null?"":inAnswer.get("RVW_TKCG_EMP_NM").toString()%>
						</div>
				<%
					}
					
					if ("의회 동의 여부 사전검토".equals(CVTN_CTRT_TYPE_CD_NM)) {
				%>
					<th>동의여부</th>
					<td>
						<input type="checkbox" name="CHK_AGRE_YN" id="CHK_AGRE_YN" <%if("Y".equals(AGRE_YN)) out.println("checked");%>>
					</td>
				<%
					}
				%>
					</td>
				</tr>
				<tr>
					<th>답변내용</th>
					<td colspan="3">
						<textarea id="RVW_OPNN_CN" name="RVW_OPNN_CN" rows="10" cols=""><%=answer.get("RVW_OPNN_CN")==null?"":answer.get("RVW_OPNN_CN") %></textarea>
					</td>
				</tr>
				<tr>
					<th>비고내용</th>
					<td colspan="3">
						<textarea id="RMRK_CN" name="RMRK_CN" rows="10" cols=""><%=answer.get("RMRK_CN")==null?"":answer.get("RMRK_CN") %></textarea>
					</td>
				</tr>
				<tr>
					<th>
						첨부파일
					</th>
					<td colspan="3">
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
									String filegbn = result.get("FILE_SE_NM")==null?"":result.get("FILE_SE_NM").toString();
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
			<a href="#none" class="sBtn type1" onclick="saveInfo('', '')" id="savebtn"><i class="fa-solid fa-file-import"></i> 저장</a>
		</div>
	</div>
</form>