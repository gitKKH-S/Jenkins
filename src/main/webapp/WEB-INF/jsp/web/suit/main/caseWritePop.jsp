<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String WRTR_EMP_NM     = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO     = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM     = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO     = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap caseMap = request.getAttribute("caseMap")==null?new HashMap():(HashMap)request.getAttribute("caseMap");
	List cdList = request.getAttribute("codeList")==null?new ArrayList():(ArrayList) request.getAttribute("codeList");
	List empList = request.getAttribute("empList")==null?new ArrayList():(ArrayList) request.getAttribute("empList");
	List caseFile = request.getAttribute("caseFile")==null?new ArrayList():(ArrayList) request.getAttribute("caseFile");
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	int ecnt = empList.size();
	
	String INST_CD = caseMap.get("INST_CD")==null?"":caseMap.get("INST_CD").toString();
	String INST_MNG_NO = caseMap.get("INST_MNG_NO")==null?"":caseMap.get("INST_MNG_NO").toString();
	String INCDNT_NO = caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString();
	String INCDNT_SE_CD = caseMap.get("INCDNT_SE_CD")==null?"":caseMap.get("INCDNT_SE_CD").toString();
	String WINCDNT_NO = caseMap.get("WINCDNT_NO")==null?"":caseMap.get("WINCDNT_NO").toString();
	String JNT_FLFMT_YN = caseMap.get("JNT_FLFMT_YN")==null?"N":caseMap.get("JNT_FLFMT_YN").toString();
	
	String PRGRS_STTS_CD = caseMap.get("PRGRS_STTS_CD")==null?"":caseMap.get("PRGRS_STTS_CD").toString();
	String JDGM_UP_TYPE_CD = caseMap.get("JDGM_UP_TYPE_CD")==null?"":caseMap.get("JDGM_UP_TYPE_CD").toString();
	String JDGM_LWR_TYPE_CD = caseMap.get("JDGM_LWR_TYPE_CD")==null?"":caseMap.get("JDGM_LWR_TYPE_CD").toString();
	String APLY_INCDNT_YN = caseMap.get("APLY_INCDNT_YN")==null?"":caseMap.get("APLY_INCDNT_YN").toString();
	String gbn = request.getAttribute("gbn")==null?"":(String)request.getAttribute("gbn");
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<style>
	td div{ width:285px; }
	#delBtn{ margin-top:1px; margin-left:10px; }
	.popW{min-height:834px;}
	.statusbar{width:355px;}
	.filename{width:300px;}
	.abort{width:55px;}
	.filename get{width:300px;}
	.abort get{width:75px;}
	.progressBar{width:175px;}
	#dtcoment{float:right; margin-right:30px;}
</style>
<script type="text/javascript">
	var WINCDNT_NO = "<%=WINCDNT_NO%>";
	var filegbnList = new Array();
	var fileidList = new Array();
	
	function setList(val, row){
		filegbnList[row] = val;
	}
	
	$(document).ready(function(){
		$("#casenum1").focus();
		
		setDocgbnSel("CASE");
		
		if(WINCDNT_NO != '' && WINCDNT_NO != null){
			var str = WINCDNT_NO.split('@');
			console.log(str);
			for(var i=0; i<str.length; i++){
				$("#casenum"+(i+1)).val(str[i]);
			}
		}
	});
	
	function goSearchCourt(){
		var cw=500;
		var ch=700;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","courtSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "courtSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchCourtPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function addEmp(idx) {
		var ecnt = $("#ecnt").val();
		var html = "";
		
		html += "<tr id='emp"+ecnt+"'>";
		html += "	<td>";
		html += "		<select name='LWS_CNCPR_SE"+ecnt+"'>"
		html += "			<option value=''    >선택</option>";
		html += "			<option value='WON' >원고</option>";
		html += "			<option value='PI'  >피고</option>";
		html += "			<option value='SWON'>원고보조</option>";
		html += "			<option value=SPI'' >피고보조</option>";
		html += "		</select>"
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='hidden' name='LWS_CNCPR_MNG_NO"+ecnt+"'/>";
		html += "		<input type='text' name='LWS_CNCPR_NM"+ecnt+"' style='width:95%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='text' name='LWS_CNCPR_CNPL"+ecnt+"' style='width:95%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='text' name='LWS_CNCPR_ADDR"+ecnt+"' style='width:95%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='text' name='RMRK_CN"+ecnt+"' style='width:95%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<a href='#none' onclick='delEmp("+ecnt+");' class='innerBtn'>삭제</a>";
		html += "		<a href='#none' onclick='addEmp("+ecnt+");' class='innerBtn'>추가</a>";
		html += "	</td>";
		html += "</tr>";
		
		$("#empTable").append(html);
		ecnt++;
		$("#ecnt").val(ecnt);
	}
	
	function delEmp(idx) {
		$("emp"+idx).remove();
	}
	
	function aplyRsnChg(yn) {
		if (yn == "N") {
			$(".aplyRsn").css("display", "");
		} else {
			$(".aplyRsn").css("display", "none");
			$("#APLY_INCDNT_FAU_RSN").val("");
		}
	}
	
	function saveInfo(){
		if(fileList.length != filegbnList.length){
			return alert("첨부파일의 구분을 선택 해 주세요");
		}
		
		if($("#INST_CD").val() == ""){
			return alert("심급을 선택 해 주세요");
		}
		
		if($("#CT_CD").val() == ""){
			return alert("관할 법원을 선택 해 주세요");
		}
		
		if($("#FLGLW_YMD").val() == ""){
			return alert("소제기일을 입력 해 주세요");
		}
		
		if ($("#INCDNT_NO").val() == "") {
			return alert("사건번호를 입력하세요");
		}
		/* 
		if($("#casenum2").val() == "" || $("#casenum3").val() == ""){
			return alert("사건번호를 입력하세요");
		}
		var casenum = $("#casenum1").val()+"@"+$("#casenum2").val()+"@"+$("#casenum3").val();
		$("#INCDNT_NO").val(casenum);
		 */
		$("#LWS_EQVL").val(uncomma($("#LWS_EQVL").val()));
		$("#CHG_LWS_EQVL").val(uncomma($("#CHG_LWS_EQVL").val()));
		$("#JDGM_AMT").val(uncomma($("#JDGM_AMT").val()));
		$("#JDGM_AMT_INT").val(uncomma($("#JDGM_AMT_INT").val()));
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/insertCaseInfo.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				if (result.res == "X") {
					alert(result.msg);
				} else {
					$("#INST_MNG_NO").val(result.INST_MNG_NO);
					
					if(fileList.length == 0){
						alert("저장이 완료되었습니다.");
						opener.document.getElementById("focus").value = "2";
						opener.goReLoad();
						window.close();
					}
					
					for (var i = 0; i < fileList.length; i++) {
						var formData = new FormData();
						formData.append("file"+i,          fileList[i]);
						formData.append("LWS_MNG_NO",      $("#LWS_MNG_NO").val());
						formData.append("INST_MNG_NO",     result.INST_MNG_NO);
						formData.append("TRGT_PST_MNG_NO", result.INST_MNG_NO);
						formData.append("FILE_SE",         filegbnList[i]);
						formData.append("SORT_SEQ",        i);
						
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
					opener.document.getElementById("focus").value = "2";
					opener.goReLoad();
					window.close();
				}
			}
		});
		status.setAbort(jqXHR);
	}
</script>
<strong class="popTT">
	심급 정보 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" enctype="multipart/form-data" method="post" action="">
	<input type="hidden" name="${_csrf.parameterName}"               value="${_csrf.token}"/>
	<input type="hidden" name="ecnt"            id="ecnt"            value="<%=ecnt+1%>" />
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="gbn"             id="gbn"             value="<%=gbn%>"         />
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="TRGT_PST_TBL_NM" id="TRGT_PST_TBL_NM" value="TB_LWS_INST"/>
	<div class="popC">
		<div class="popA" style="max-height:700px;">
			<table class="pop_infoTable write" style="height:100%;">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th colspan="6">심급정보</th>
				</tr>
				<tr>
					<th>심급</th>
					<td>
						<select name="INST_CD" id="INST_CD" style="width:120px;">
							<option value="">선택</option>
						<%
							for(int i=0; i<cdList.size(); i++) {
								HashMap code = (HashMap) cdList.get(i);
								if ("CASECD".equals(code.get("CD_LCLSF_ENG_NM"))){
									String codeid = code.get("CD_MNG_NO").toString();
						%>
								<option value="<%=code.get("CD_MNG_NO")%>" <%if(INST_CD.equals(codeid)) out.println("selected");%>>
									<%=code.get("CD_NM")%>
								</option>
						<%
								}
							}
						%>
						</select>
					</td>
					<th>소제기일</th>
					<td>
						<input type="text" name="FLGLW_YMD" id="FLGLW_YMD" class="datepick" value="<%=caseMap.get("FLGLW_YMD")==null?"":caseMap.get("FLGLW_YMD").toString()%>" style="width:120px;">
					</td>
					<th>사건번호</th>
					<td>
						<input type="text" name="INCDNT_NO" id="INCDNT_NO" />
						<!-- 
						<input type="text" name="casenum1" id="casenum1" style="width:70px" />
						<input type="text" name="casenum2" id="casenum2" style="width:70px" />
						<input type="text" name="casenum3" id="casenum3" style="width:70px"/>
						 -->
					</td>
				</tr>
				<tr>
					<th>관할법원</th>
					<td>
						<input type="hidden" name="CT_CD" id="CT_CD" value="<%=caseMap.get("CT_CD")==null?"":caseMap.get("CT_CD").toString()%>">
						<input type="text"   name="CT_NM" id="CT_NM" value="<%=caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString()%>" onclick="goSearchCourt()" style="width:70%;">
						<a href="#none" onclick="goSearchCourt()" class="innerBtn">검색</a>
					</td>
					<th>재판부</th>
					<td>
						<input type="text" name="JSDP_NM" id="JSDP_NM" value="<%=caseMap.get("JSDP_NM")==null?"":caseMap.get("JSDP_NM").toString()%>" maxlength="200">
					</td>
					<th>사건구분</th>
					<td>
						<label><input type="radio" name="INCDNT_SE_CD" id="INCDNT_SE_CD_A" value="A" <%if("A".equals(INCDNT_SE_CD) || INCDNT_SE_CD.equals("")) out.println("checked");%>>일반</label>&nbsp;
						<label><input type="radio" name="INCDNT_SE_CD" id="INCDNT_SE_CD_B" value="B" <%if("B".equals(INCDNT_SE_CD)) out.println("checked");%>>주요소송</label>&nbsp;
						<label><input type="radio" name="INCDNT_SE_CD" id="INCDNT_SE_CD_C" value="C" <%if("C".equals(INCDNT_SE_CD)) out.println("checked");%>>특별관리소송</label>&nbsp;
					</td>
				</tr>
				<tr>
					<th>소송당사자</th>
					<td colspan="5">
						<div style="width:100%;">
							<table class="pop_infoTable write" id="empTable">
								<colgroup>
									<col style="width:10%;">
									<col style="width:15%;">
									<col style="width:15%;">
									<col style="width:*;">
									<col style="width:20%;">
								</colgroup>
								<tr>
									<th style="text-align:center;">구분</th>
									<th style="text-align:center;">이름</th>
									<th style="text-align:center;">연락처</th>
									<th style="text-align:center;">주소</th>
									<th style="text-align:center;">비고</th>
									<th style="text-align:center;"></th>
								</tr>
					<%
						System.out.println(empList.size());
						if (empList.size() > 0) {
							for(int e=0; e<empList.size(); e++) {
								HashMap empMap = (HashMap) empList.get(e);
								String gbn2 = empMap.get("LWS_CNCPR_SE")==null?"":empMap.get("LWS_CNCPR_SE").toString();
					%>
								<tr id="<%="emp"+e %>">
									<td>
										<select name="<%="LWS_CNCPR_SE"+e %>">
											<option value=""     <%if(gbn2.equals("")) out.println("selected");     %>>선택</option>
											<option value="WON"  <%if("WON".equals(gbn2)) out.println("selected");  %>>원고</option>
											<option value="PI"   <%if("PI".equals(gbn2)) out.println("selected");   %>>피고</option>
											<option value="SWON" <%if("SWON".equals(gbn2)) out.println("selected"); %>>원고보조</option>
											<option value="SPI"  <%if("SPI".equals(gbn2)) out.println("selected");  %>>피고보조</option>
										</select>
									</td>
									<td>
										<input type="hidden" name="<%="LWS_CNCPR_MNG_NO"+e%>" value="<%=empMap.get("LWS_CNCPR_MNG_NO")==null?"":empMap.get("LWS_CNCPR_MNG_NO").toString()%>"/>
										<input type="text"   name="<%="LWS_CNCPR_NM"+e %>" style="width:95%;" value="<%=empMap.get("LWS_CNCPR_NM")==null?"":empMap.get("LWS_CNCPR_NM").toString()%>"/>
									</td>
									<td><input type="text" name="<%="LWS_CNCPR_CNPL"+e %>" style="width:95%;" value="<%=empMap.get("LWS_CNCPR_CNPL")==null?"":empMap.get("LWS_CNCPR_CNPL").toString()%>"/></td>
									<td><input type="text" name="<%="LWS_CNCPR_ADDR"+e %>" style="width:95%;" value="<%=empMap.get("LWS_CNCPR_ADDR")==null?"":empMap.get("LWS_CNCPR_ADDR").toString()%>"/></td>
									<td><input type="text" name="<%="RMRK_CN"+e %>" style="width:95%;" value="<%=empMap.get("RMRK_CN")==null?"":empMap.get("RMRK_CN").toString()%>"/></td>
									<td>
										<a href="#none" onclick="delEmp('<%=e%>');" class="innerBtn">삭제</a>
										<a href="#none" onclick="addEmp('<%=e%>');" class="innerBtn">추가</a>
									</td>
								</tr>
					<%
							}
						} else {
					%>
								<tr id="emp0">
									<td>
										<select name="LWS_CNCPR_SE0">
											<option value=""    >선택</option>
											<option value="WON" >원고</option>
											<option value="PI"  >피고</option>
											<option value="SWON">원고보조</option>
											<option value="SPI" >피고보조</option>
										</select>
									</td>
									<td>
										<input type="hidden" name="LWS_CNCPR_MNG_NO0"/>
										<input type="text" name="LWS_CNCPR_NM0"   style="width:95%;">
									</td>
									<td><input type="text" name="LWS_CNCPR_CNPL0" style="width:95%;"></td>
									<td><input type="text" name="LWS_CNCPR_ADDR0" style="width:95%;"></td>
									<td><input type="text" name="RMRK_CN0" style="width:95%;"></td>
									<td>
										<a href="#none" onclick="delEmp('0');" class="innerBtn">삭제</a>
										<a href="#none" onclick="addEmp('0');" class="innerBtn">추가</a>
									</td>
								</tr>
					<%
						}
					%>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<th>소송가액</th>
					<td>
						<input type="text" id="LWS_EQVL" name="LWS_EQVL" value="<%=caseMap.get("LWS_EQVL")==null?"0":caseMap.get("LWS_EQVL").toString().trim() %>" onkeyup="numFormat(this);">
					</td>
					<th>변경소송가액</th>
					<td>
						<input type="text" id="CHG_LWS_EQVL" name="CHG_LWS_EQVL" value="<%=caseMap.get("CHG_LWS_EQVL")==null?"0":caseMap.get("CHG_LWS_EQVL").toString().trim() %>" onkeyup="numFormat(this);">
					</td>
					<td colspan="2"></td>
				</tr>
				<tr>
					<th>검찰청 사건번호</th>
					<td>
						<input type="text" name="PPOF_INCDNT_NO" id="PPOF_INCDNT_NO" value="<%=caseMap.get("PPOF_INCDNT_NO")==null?"":caseMap.get("PPOF_INCDNT_NO").toString()%>" maxlength="200">
					</td>
					<th>공동수행여부</th>
					<td>
						<input type="radio" name="JNT_FLFMT_YN" value="Y" <%if("Y".equals(JNT_FLFMT_YN)) out.println("checked"); %>>Y
						<input type="radio" name="JNT_FLFMT_YN" value="N" <%if("N".equals(JNT_FLFMT_YN)) out.println("checked"); %>>N
					</td>
					<th>검찰청<br/>소송수행자</th>
					<td>
						<input type="text" name="PPOF_LWS_FLFMT_EMP_NM" id="PPOF_LWS_FLFMT_EMP_NM" value="<%=caseMap.get("PPOF_LWS_FLFMT_EMP_NM")==null?"":caseMap.get("PPOF_LWS_FLFMT_EMP_NM").toString()%>" maxlength="200">
					</td>
				</tr>
				<tr>
					<th>담당검사</th>
					<td>
						<input type="text" name="TKCG_PROC_NM" id="TKCG_PROC_NM" value="<%=caseMap.get("TKCG_PROC_NM")==null?"":caseMap.get("TKCG_PROC_NM").toString()%>" maxlength="200">
					</td>
					<td colspan="4"></td>
				</tr>
				<tr>
					<th>특이사항</th>
					<td colspan="5">
						<textarea rows="5" cols="200" name="RMRK_CN" id="RMRK_CN"><%=caseMap.get("RMRK_CN")==null?"":caseMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th colspan="6">판결정보</th>
				</tr>
				<tr>
					<th>판결분류</th>
					<td colspan="5">
						<select name="JDGM_UP_TYPE_CD" id="JDGM_UP_TYPE_CD">
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
						<input type="text" class="datepick" name="JDGM_ADJ_YMD" id="JDGM_ADJ_YMD" value="<%=caseMap.get("JDGM_ADJ_YMD")==null?"":caseMap.get("JDGM_ADJ_YMD").toString()%>"style="width: 50%"/>
					</td>
					<th>판결송달일</th>
					<td>
						<input type="text" class="datepick" name="RLNG_TMTL_YMD" id="RLNG_TMTL_YMD" value="<%=caseMap.get("RLNG_TMTL_YMD")==null?"":caseMap.get("RLNG_TMTL_YMD").toString()%>" style="width: 50%"/>
					</td>
					<th>판결확정일</th>
					<td>
						<input type="text" class="datepick" name="JDGM_CFMTN_YMD" id="JDGM_CFMTN_YMD" value="<%=caseMap.get("JDGM_CFMTN_YMD")==null?"":caseMap.get("JDGM_CFMTN_YMD").toString()%>" style="width: 50%"/>
					</td>
				</tr>
				<tr>
					<th>판결금액</th>
					<td>
						<input type="text" name="JDGM_AMT" id="JDGM_AMT" value="<%=caseMap.get("JDGM_AMT")==null?"":caseMap.get("JDGM_AMT").toString()%>" onkeyup="numFormat(this);"/>
					</td>
					<th>판결금 이자</th>
					<td>
						<input type="text" name="JDGM_AMT_INT" id="JDGM_AMT_INT" value="<%=caseMap.get("JDGM_AMT_INT")==null?"":caseMap.get("JDGM_AMT_INT").toString()%>" onkeyup="numFormat(this);"/>
					</td>
					<th>승소율</th>
					<td>
						<input type="text" name="WIN_RT" id="WIN_RT" value="<%=caseMap.get("WIN_RT")==null?"":caseMap.get("WIN_RT").toString()%>"/>
					</td>
				</tr>
				<tr>
					<th>판결내용</th>
					<td colspan="5">
						<textarea rows="7" cols="" id="JDGM_CN" name="JDGM_CN" ><%=caseMap.get("JDGM_CN")==null?"":caseMap.get("JDGM_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
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
						<textarea rows="7" cols="" id="APLY_INCDNT_FAU_RSN" name="APLY_INCDNT_FAU_RSN" ><%=caseMap.get("APLY_INCDNT_FAU_RSN")==null?"":caseMap.get("APLY_INCDNT_FAU_RSN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td colspan="5">
						<div id="fileUpload" class="dragAndDropDiv"  <%if(caseFile.size() > 0) {%>style="width:50%;"<%}%>>
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:45%;">
							<%
								for(int i=0; i<caseFile.size(); i++){
									HashMap result = (HashMap)caseFile.get(i);
									String FILE_SE = result.get("FILE_SE")==null?"":result.get("FILE_SE").toString();
									String fileGbn = "";
									if ("CA".equals(FILE_SE)) {
										fileGbn = "[소장]";
									} else if ("RE".equals(FILE_SE)) {
										fileGbn = "[판결문]";
									} else if ("ET".equals(FILE_SE)) {
										fileGbn = "[기타]";
									}
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'><%=fileGbn%> <%=result.get("PHYS_FILE_NM") %> (<%=result.get("VIEW_SZ") %>)</div>
								<div class="abort"><input type="checkbox" name="delfile[]" value="<%=result.get("FILE_MNG_NO") %>"/>　삭제</div>
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
			<a href="#none" onclick="saveInfo();" class="sBtn type1">등록</a>
		</div>
	</div>
</form>