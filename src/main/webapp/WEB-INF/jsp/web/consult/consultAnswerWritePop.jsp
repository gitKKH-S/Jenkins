<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%
	// 자문 위원 목록
	List consultLawyerList = request.getAttribute("consultLawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("consultLawyerList");
	
	// 자문 답변 내용
	HashMap answer = request.getAttribute("answer")==null?new HashMap():(HashMap)request.getAttribute("answer");
	
	// 자문 답변 파일
	List fconsultlist = request.getAttribute("filelist")==null?new ArrayList():(ArrayList)request.getAttribute("filelist");
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	
// 	String consultid = request.getParameter("consultid")==null?"":request.getParameter("consultid");
// 	String chckid = request.getParameter("chckid")==null?"":request.getParameter("chckid");
	String CNSTN_MNG_NO = request.getParameter("CNSTN_MNG_NO")==null?"":request.getParameter("CNSTN_MNG_NO");
	String RVW_OPNN_MNG_NO = request.getParameter("RVW_OPNN_MNG_NO")==null?"":request.getParameter("RVW_OPNN_MNG_NO");
	String menu = request.getParameter("menu")==null?"":request.getParameter("menu");
	String inoutcon = request.getParameter("inoutcon")==null?"":request.getParameter("inoutcon");
	
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
		for(int i=0; i<consultLawyerList.size(); i++){
			HashMap re = (HashMap)consultLawyerList.get(i);
			String ADVISORID = re.get("RVW_TKCG_EMP_NO")==null?"":re.get("RVW_TKCG_EMP_NO").toString();
			if(USERNO.equals(ADVISORID)) {
				RESMNGNO = ADVISORID;
				CONSULTLAWYERID = re.get("RVW_TKCG_MNG_NO")==null?"":re.get("RVW_TKCG_MNG_NO").toString();
				lawname = re.get("RVW_TKCG_EMP_NM")==null?"":re.get("RVW_TKCG_EMP_NM").toString();
			}
		}
	}
	
	if ("I".equals(inoutcon)) {
		inAnswer = (HashMap) consultLawyerList.get(0);
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "); 
		System.out.println(inAnswer);
		// {CONSULTLAWYERID=103121569, INOUTCON=I, CONSULTID=103121562, ADVISORID=10, ADVISORNM=법무10사원}
		inAdvisor = inAnswer.get("RVW_TKCG_EMP_NO")==null?"":inAnswer.get("RVW_TKCG_EMP_NO").toString();
		inConsultlawyerid = inAnswer.get("RVW_TKCG_MNG_NO")==null?"":inAnswer.get("RVW_TKCG_MNG_NO").toString();
		System.out.println("inAdvisor ::: " + inAdvisor); 
		System.out.println("inConsultlawyerid ::: " + inConsultlawyerid); 
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "); 
	}
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	<%-- var conFilenm = "<%=conFilenm%>"; --%>
	var menu = "<%=menu%>";
	var CNSTN_MNG_NO = "<%=CNSTN_MNG_NO%>";
	var RVW_OPNN_MNG_NO = "<%=RVW_OPNN_MNG_NO%>";
	<%-- var conTitle = "<%=conTitle%>"; --%>
	$(document).ready(function(){
		$("#inoutcon").val(opener.document.getElementById("inoutcon").value);
		
		if($("#inoutcon").val() == "I"){
			$("#setlawyer").css("display", "none");
		}
		
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
				if ($("#inoutcon").val() == "O"){
					/* 
					var selData = $("#setlawyer option:selected").val();
					if(selData != "답변을 등록 할 자문위원을 선택하세요"){
						$("#RESMNGNO").val(selData);
					}
					 */
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
				url : "${pageContext.request.contextPath}/web/consult/answerSave.do",
				data : $('#wform').serializeArray(),
// 				beforeSend : function(xhr){
// 					xhr.setRequestHeader(header,token);	
// 				},
				dataType: "json",
				async: false,
				success : function(result){
					if(result.data.msg =='ok'){
						$("#RVW_OPNN_MNG_NO").val(result.data.chckid);
						
						for (var i = 0; i < fileList.length; i++) {
							var formData = new FormData();
							formData.append('file'+i, fileList[i]);
// 							formData.append('gbnid',result.data.chckid);
							formData.append('gbnid',CNSTN_MNG_NO);
							formData.append('TRGT_PST_MNG_NO',result.data.TRGT_PST_MNG_NO);
							
							var other_data = $('#wform').serializeArray();
							$.each(other_data,function(key,input){
								if(input.name != 'RVW_OPNN_MNG_NO'){
									formData.append(input.name,input.value);
								}
							});
							var status = statusList[i];
							
							var uploadURL = "${pageContext.request.contextPath}/web/consult/fileUploadconsult.do"; //Upload URL
							var extraData ={}; //Extra Data.
							var jqXHR=$.ajax({
									xhr: function() {
									var xhrobj = $.ajaxSettings.xhr();
									if (xhrobj.upload) {
										xhrobj.upload.addEventListener('progress', function(event) {
											var percent = 0;
											var position = event.loaded || event.position;
											var total = event.total;
											if (event.lengthComputable) {
												percent = Math.ceil(position / total * 100);
											}
											status.setProgress(percent);
										}, false);
									}
									return xhrobj;
								},
								url: uploadURL,
								type: "POST",
								contentType:false,
								processData: false,
								cache: false,
								data: formData,
// 								beforeSend : function(xhr){
// 									xhr.setRequestHeader(header,token);	
// 								},
								async: false,
								success: function(data){
									status.setProgress(100);
									//$("#status1").append("File upload Done<br>");
								}
							}); 
							status.setAbort(jqXHR);
						}
						
						alert("저장되었습니다.");
						opener.viewReload();
						window.close();
					}else{
						alert(result.data.msg);
					}
				}
			});
		}
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
	자문 답변 작성
	<a href="#none" class="popClose" onclick="closePop();">닫기</a>
</strong>
<form name="wform" id="wform" method="post">
<%-- 	<input type="hidden" name="${_csrf.parameterName}"   value="${_csrf.token}"/> --%>
	<input type="hidden" name="CNSTN_MNG_NO" id="CNSTN_MNG_NO" value="<%=CNSTN_MNG_NO%>"/>
	<input type="hidden" name="consultid" id="consultid" value="<%=CNSTN_MNG_NO%>"/>
	<input type="hidden" name="RVW_OPNN_MNG_NO"    id="RVW_OPNN_MNG_NO"    value="<%=RVW_OPNN_MNG_NO%>"/>
	<input type="hidden" name="filegbn"   id="filegbn"   value="ANSWER">
	<input type="hidden" name="inoutcon"  id="inoutcon"  value=""/>
	<input type="hidden" name="apryn"     id="apryn"     value=""/>
	
	<input type="hidden" name="Menuid"     id="Menuid"     value="<%=Menuid%>">
	<input type="hidden" name="writerid"   id="writerid"   value="<%=writerid%>" />
	<input type="hidden" name="writer"     id="writer"     value="<%=writer%>" />
	<input type="hidden" name="deptid"     id="deptid"     value="<%=deptid%>" />
	<input type="hidden" name="deptname"   id="deptname"   value="<%=deptname%>" />
	
	
	<input type="hidden" id="RESMNGNO"        name="RESMNGNO"         value="<%=RESMNGNO%>">
	<input type="hidden" id="CONSULTLAWYERID" name="CONSULTLAWYERID"  value="<%=CONSULTLAWYERID%>">
	<!-- 
	<input type="hidden" id="LAWFIRMID" name="LAWFIRMID">
	<input type="hidden" id="LAWYERID" name="LAWYERID">
	<input type="hidden" id="LAWYERNM" name="LAWYERNM">
	<input type="hidden" id="OFFICE" name="OFFICE">
	<input type="hidden" id="CONSULTLAWYERID" name="CONSULTLAWYERID">
	 -->
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write" style="height:100%;">
				<colgroup>
					<col style="width:15%;">
					<col style="width:80%;">
				</colgroup>
				<tr>
					<th>작성자</th>
					<td>
				<%
					if ("O".equals(inoutcon)) {
						if(RVW_OPNN_MNG_NO.equals("") || RVW_OPNN_MNG_NO.length() == 0) {
							if((GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("J") > -1 || GRPCD.indexOf("K")>-1) && consultLawyerList.size() > 0){
				%>
						<select id="setlawyer" style="border:1px solid;">
							<option value="">답변을 등록 할 자문위원을 선택하세요</option>
				<%
							for(int i=0; i<consultLawyerList.size(); i++){
								HashMap re = (HashMap)consultLawyerList.get(i);
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
				%>
					</td>
				</tr>
				<tr>
					<th>답변내용</th>
					<td>
						<textarea id="rvw_opnn_cn" name="rvw_opnn_cn" rows="10" cols=""><%=answer.get("RVW_OPNN_CN")==null?"":answer.get("RVW_OPNN_CN") %></textarea>
					</td>
				</tr>
				<tr>
					<th>비고내용</th>
					<td>
						<textarea id="rmrk_cn" name="rmrk_cn" rows="10" cols=""><%=answer.get("RMRK_CN")==null?"":answer.get("RMRK_CN") %></textarea>
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
									String filegbn = result.get("FILE_SE_NM")==null?"":result.get("FILE_SE_NM").toString();
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'><%=result.get("DWNLD_FILE_NM") %> (<%=result.get("VIEW_SZ").toString() %>)</div>
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