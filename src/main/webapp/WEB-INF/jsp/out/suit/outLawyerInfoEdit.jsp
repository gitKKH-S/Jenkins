<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap map = request.getAttribute("map")==null?new HashMap():(HashMap)request.getAttribute("map");
	String LWYR_MNG_NO = map.get("LWYR_MNG_NO")==null?"":map.get("LWYR_MNG_NO").toString();
	String WRTR_EMP_NM = map.get("WRTR_EMP_NM")==null?"":map.get("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = map.get("WRTR_EMP_NO")==null?"":map.get("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = map.get("WRT_DEPT_NM")==null?"":map.get("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = map.get("WRT_DEPT_NO")==null?"":map.get("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = map.get("MENU_MNG_NO")==null?"":map.get("MENU_MNG_NO").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	HashMap lawyerMap = request.getAttribute("lawyerMap")==null?new HashMap():(HashMap)request.getAttribute("lawyerMap");
	String lawyerLoginId = lawyerMap.get("LGN_ID")==null?"":lawyerMap.get("LGN_ID").toString();
	
	List bankList = request.getAttribute("bankList")==null?new ArrayList():(ArrayList)request.getAttribute("bankList");
	int ecnt = bankList.size();
	
	HashMap pfFile = request.getAttribute("pfFile")==null?new HashMap():(HashMap)request.getAttribute("pfFile");

	List codeList = request.getAttribute("codeList")==null?new ArrayList():(ArrayList)request.getAttribute("codeList");
	List agtList = request.getAttribute("agtList")==null?new ArrayList():(ArrayList)request.getAttribute("agtList");
%>
<style>
	.chrgList{text-align:center !important;}
	#noti {color: cadetblue; position: relative; margin-left: 10px;}
</style>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var LWYR_MNG_NO = "<%=WRTR_EMP_NO%>";
	var lawyerLoginId = "<%=lawyerLoginId%>";
	
	$(document).ready(function(){  //문서가 로딩될때
		if(LWYR_MNG_NO != "0"){
			$("#chkyn").val("Y");
			
			$("#pwReset").css("display", "");
			$("#pwChg").css("display", "");
		}else{
			$("#pwReset").css("display", "none");
			$("#pwChg").css("display", "none");
			$("#chrgSuit").css("display", "none");
		}
		
		// 전화번호 - 삽입
		$(".telInput").on("keyup", function(){
			$(this).val($(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-"));
		});
		
	});
	
	function goSearchLawfirm(){
		var cw=505;
		var ch=705;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","searchLawfirm",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "searchLawfirm");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchLawfirmPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goSaveInfo(){
		if(confirm("등록 하시겠습니까?")){
			if($("#ASST_LGN_ID").val() != "") {
				if($("#ASST_LGN_ID").val().length < 5) {
					return alert("보조아이디는 5자 이상 입력하세요");
				}
				
				var asstPw = $("#ASST_LGN_PSWD").val();
				var Anum = asstPw.search(/[0-9]/g);
				var Aeng = asstPw.search(/[a-z]/ig);
				var Aspe = asstPw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
				
				if (asstPw != "") {
					if(asstPw.search(/\s/) != -1){
						return alert("비밀번호는 공백을 포함할 수 없습니다.");
					}else if( (Anum < 0 && Aeng < 0) || (Aeng < 0 && Aspe < 0) || (Aspe < 0 && Anum < 0) ){
						return alert("영문, 숫자, 특수문자 중 2가지 이상을 혼합하여 입력하세요.");
					}else{
						$("#ASST_LGN_PSWD").val(asstPw);
					}
				} else {
					return alert("보조계정 비밀번호를 입력하세요");
				}
			}
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/insertLawyerInfo.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					
					$("#INST_MNG_NO").val(result.INST_MNG_NO);
					
					if(fileList.length == 0){
						alert("저장이 완료되었습니다.");
						location.reload(true);
					}
					
					for (var i = 0; i < fileList.length; i++) {
						var formData = new FormData();
						formData.append("file"+i, fileList[i]);
						formData.append("LWS_MNG_NO", result.LWYR_MNG_NO);
						formData.append("INST_MNG_NO", result.LWYR_MNG_NO);
						formData.append("TRGT_PST_MNG_NO", result.LWYR_MNG_NO);
						formData.append("FILE_SE", "PF");
						formData.append("TRGT_PST_TBL_NM", "TB_COM_LWYR");
						formData.append("SORT_SEQ", i);
						
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
					location.reload(true);
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function duchkFunction(){
		var getid = $("#LGN_ID").val();
		if(getid == ""){
			return alert("아이디를 입력하세요");
		}
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH %>/web/suit/duchk.do",
			data:{LGN_ID:getid},
			dataType:'json',
			success:function(data) {
				if(data.SUCCESS=='Y'){
					alert("사용 가능한 아이디입니다.");
					$("#chkyn").val("Y");
				}else{
					alert("이미 사용중인 아이디입니다.");
					$("#LGN_ID").val("");
					$("#chkyn").val("N");
				}
			}
		});
	}
	
	function pwReset(){
		var pw = "seoul123!!!";
		$.ajax({
			type:"POST",
			url:"<%=CONTEXTPATH %>/web/suit/changePassWord.do",
			data:{LWYR_MNG_NO:LWYR_MNG_NO, LGN_PSWD:newPw},
			dataType:'json',
			success:function(data) {
				alert("비밀번호가 초기화 되었습니다.");
				location.reload(true);
			}
		});
	}
	
	function pwChg(){
		var oldPw = $("#LGN_PSWD").val();
		var newPw = $("#newPw").val();
		var num = newPw.search(/[0-9]/g);
		var eng = newPw.search(/[a-z]/ig);
		var spe = newPw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
		if(oldPw != $("#oldPw").val()){
			return alert("기존 비밀번호가 틀렸습니다.");
		}else{
			if(newPw.search(/\s/) != -1){
				return alert("비밀번호는 공백을 포함할 수 없습니다.");
			}else if( (num < 0 && eng < 0) || (eng < 0 && spe < 0) || (spe < 0 && num < 0) ){
				return alert("영문, 숫자, 특수문자 중 2가지 이상을 혼합하여 입력하세요.");
			}else {
				$.ajax({
					type:"POST",
					url:"<%=CONTEXTPATH %>/web/suit/changePassWord.do",
					data:{LWYR_MNG_NO:LWYR_MNG_NO, LGN_PSWD:newPw, LGN_ID:lawyerLoginId},
					dataType:'json',
					success:function(data) {
						alert("비밀번호 변경이 완료되었습니다.");
						location.reload(true);
					}
				});
			}
		}
	}
	
	function pwChgDivShow(){
		$("#pwChgDiv").css("display","");
		$("#chgyn").val("Y");
	}
	
	function addBank(idx) {
		var ecnt = $("#ecnt").val();
		if (ecnt == 0) {
			ecnt = 1;
		}
		var html = "";
		
		html += "<tr id='bank"+ecnt+"'>";
		html += "	<td>";
		html += "		<input type='hidden' name='BACNT_MNG_NO"+ecnt+"'/>";
		html += "		<input type='hidden' name='BANK_SE_CD"+ecnt+"'/>";
		html += "		<input type='text' name='BANK_NM"+ecnt+"' style='width:95%;'/>";
		html += "		<a href='#none' onclick='searchBank("+ecnt+");' class='innerBtn'>삭제</a>";
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='text' name='DPSTR_NM"+ecnt+"' style='width:95%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='text' name='ACTNO"+ecnt+"' style='width:95%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<select name='USE_YN'"+ecnt+">";
		html += "			<option value='Y'>사용</option>";
		html += "			<option value='N'>미사용</option>";
		html += "		</select>";
		html += "	</td>";
		html += "	<td>";
		html += "		<input type='text' name='RMRK_CN"+ecnt+"' style='width:95%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<a href='#none' onclick='delBank("+ecnt+");' class='innerBtn'>삭제</a>";
		html += "		<a href='#none' onclick='addBank("+ecnt+");' class='innerBtn'>추가</a>";
		html += "	</td>";
		html += "</tr>";
		
		$("#bankTable").append(html);
		ecnt++;
		$("#ecnt").val(ecnt);
	}
	
	function delBank(idx) {
		$("bank"+idx).remove();
	}
	
	function searchBank(idx) {
		var cw=500;
		var ch=700;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","bankSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "bankSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchBankPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"idx", value:idx}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
</script>
<style>
	#img_con {
		height:150px;
		width:150px;
		border:1px solid darkgray;
	}
</style>
<form name="frm" id="frm" enctype="multipart/form-data" method="post" action="">
	<input type="hidden" name="LWYR_MNG_NO" id="LWYR_MNG_NO" value="<%=LWYR_MNG_NO%>" />
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM" id="WRTR_EMP_NM" value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO" id="WRT_DEPT_NO" value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="chkyn"       id="chkyn"       value=""/>
	<input type="hidden" name="chgyn"       id="chgyn"       value="N"/>
	<input type="hidden" name="ecnt"        id="ecnt"        value="<%=ecnt+1%>" />
	<input type="hidden" name="profileFile" id="profileFile" value=""/>
	<div class="subCA">
		<strong id="subTT" class="subTT">내 정보 관리</strong>
		<div class="innerB">
			<table class="infoTable write" style="width:100%">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>이름</th>
					<td>
						<input type="text" id="LWYR_NM" name="LWYR_NM" value="<%=lawyerMap.get("LWYR_NM")==null?"":lawyerMap.get("LWYR_NM").toString()%>" readonly="readonly">
					</td>
					<th>소속</th>
					<td>
						<input type="hidden" id="JDAF_CORP_MNG_NO" name ="JDAF_CORP_MNG_NO" value="<%=lawyerMap.get("JDAF_CORP_MNG_NO")==null?"":lawyerMap.get("JDAF_CORP_MNG_NO").toString()%>">
						<input type="text" id="JDAF_CORP_NM" name ="JDAF_CORP_NM" value="<%=lawyerMap.get("JDAF_CORP_NM")==null?"":lawyerMap.get("JDAF_CORP_NM").toString()%>" readonly="readonly">
					</td>
				</tr>
			<%if(GRPCD.indexOf("X") > -1) {%>
				<tr>
					<th>아이디</th>
					<td>
						<input type="text" id="LGN_ID" name="LGN_ID" value="<%=lawyerMap.get("LGN_ID")==null?"":lawyerMap.get("LGN_ID").toString()%>" readonly="readonly">
					</td>
<%
					if(!lawyerLoginId.equals("")){
%>
					<th>비밀번호</th>
					<td>
						<input type="password" id="LGN_PSWD" name="LGN_PSWD" value="<%=lawyerMap.get("LGN_PSWD")==null?"":lawyerMap.get("LGN_PSWD").toString()%>">
						<a href="#none" class="innerBtn" id="pwChg" onclick="pwChgDivShow()">비밀번호 변경</a>
					</td>
<%
					}else{
%>
					<th></th>
					<td></td>
<%
					}
%>
				</tr>
				<tr id="pwChgDiv" style="display:none;">
					<th>기존비밀번호</th>
					<td>
						<input type="password" id="oldPw" name="oldPw">
					</td>
					<th>변경할 비밀번호</th>
					<td>
						<input type="password" id="newPw" name="newPw">
						<a href="#none" class="innerBtn" id="pwChg" onclick="pwChg()">저장</a>
					</td>
				</tr>
			<%}%>
			<%if(GRPCD.indexOf("X") > -1) {%>
				<tr>
					<th>보조아이디</th>
					<td>
						<input type="text" id="ASST_LGN_ID" name="ASST_LGN_ID" value="<%=lawyerMap.get("ASST_LGN_ID")==null?"":lawyerMap.get("ASST_LGN_ID").toString()%>">
					</td>
					<th>보조계정 비밀번호</th>
					<td>
						<input type="password" id="ASST_LGN_PSWD" name="ASST_LGN_PSWD" value="<%=lawyerMap.get("ASST_LGN_PSWD")==null?"":lawyerMap.get("ASST_LGN_PSWD").toString()%>">
						<a href="#none" class="innerBtn" id="pwChg" onclick="goSaveInfo()">보조정보저장</a>
					</td>
				</tr>
			<%}%>
				<tr>
					<th>휴대전화번호</th>
					<td>
						<input type="text" class="telInput" id="MBL_TELNO" name="MBL_TELNO" value="<%=lawyerMap.get("MBL_TELNO")==null?"":lawyerMap.get("MBL_TELNO").toString()%>" readonly="readonly">
					</td>
					<th>이메일</th>
					<td>
						<input type="text" id="EML_ADDR" name="EML_ADDR" value="<%=lawyerMap.get("EML_ADDR")==null?"":lawyerMap.get("EML_ADDR").toString()%>" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th>사무실 전화번호</th>
					<td>
						<input type="text" class="telInput" id="OFC_TELNO" name="OFC_TELNO" value="<%=lawyerMap.get("OFC_TELNO")==null?"":lawyerMap.get("OFC_TELNO").toString()%>" readonly="readonly">
					</td>
					<th>사무실 팩스번호</th>
					<td>
						<input type="text" id="OFC_FXNO" name="OFC_FXNO" value="<%=lawyerMap.get("OFC_FXNO")==null?"":lawyerMap.get("OFC_FXNO").toString()%>" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th>계좌정보</th>
					<td colspan="3">
						<div style="width:100%;">
							<table class="pop_infoTable write" id="bankTable">
								<colgroup>
									<col style="width:15%;">
									<col style="width:15%;">
									<col style="width:*;">
									<col style="width:*;">
									<col style="width:15%">
								</colgroup>
								<tr>
									<th style="text-align:center;">은행명</th>
									<th style="text-align:center;">예금주명</th>
									<th style="text-align:center;">계좌번호</th>
									<th style="text-align:center;">비고</th>
									<th style="text-align:center;"></th>
								</tr>
					<%
						if (bankList.size() > 0) {
							for(int e=0; e<bankList.size(); e++) {
								HashMap bankMap = (HashMap) bankList.get(e);
								
								String BANK_SE_CD = bankMap.get("BANK_SE_CD")==null?"":bankMap.get("BANK_SE_CD").toString();
								String USE_YN = bankMap.get("USE_YN")==null?"":bankMap.get("USE_YN").toString();
					%>
								<tr id="<%="bank"+e %>">
									<td>
										<input type="hidden" name="<%="BACNT_MNG_NO"+e %>" id="<%="BACNT_MNG_NO"+e %>"  value="<%=bankMap.get("BACNT_MNG_NO")==null?"":bankMap.get("BACNT_MNG_NO").toString()%>"/>
										<input type="hidden" name="<%="BANK_SE_CD"+e %>"   id="<%="BANK_SE_CD"+e %>"    value="<%=bankMap.get("BANK_SE_CD")==null?"":bankMap.get("BANK_SE_CD").toString()%>"/>
										<input type="text"   name="<%="BANK_NM"+e %>"      id="<%="BANK_NM"+e %>"       value="<%=bankMap.get("BANK_NM")==null?"":bankMap.get("BANK_NM").toString()%>" style="width:60%;" readonly="readonly"/>
									</td>
									<td>
										<input type="text"   name="<%="DPSTR_NM"+e %>" style="width:95%;" value="<%=bankMap.get("DPSTR_NM")==null?"":bankMap.get("DPSTR_NM").toString()%>" readonly="readonly"/>
									</td>
									<td>
										<input type="text"   name="<%="ACTNO"+e %>" style="width:95%;" value="<%=bankMap.get("ACTNO")==null?"":bankMap.get("ACTNO").toString()%>" readonly="readonly"/>
									</td>
									<td>
										<input type="text"   name="<%="RMRK_CN"+e %>" style="width:95%;" value="<%=bankMap.get("RMRK_CN")==null?"":bankMap.get("RMRK_CN").toString()%>" readonly="readonly"/>
									</td>
									<td>
									</td>
								</tr>
					<%
							}
						}
					%>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</form>
