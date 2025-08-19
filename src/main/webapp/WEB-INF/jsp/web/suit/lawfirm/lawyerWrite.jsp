<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
	Date now = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy");
	String formatedNow = formatter.format(now);
	
	String LWYR_MNG_NO = request.getAttribute("LWYR_MNG_NO")==null?"":request.getAttribute("LWYR_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	
	HashMap lawyerMap = request.getAttribute("lawyerMap")==null?new HashMap():(HashMap)request.getAttribute("lawyerMap");
	String lawyerLoginId = lawyerMap.get("LGN_ID")==null?"":lawyerMap.get("LGN_ID").toString();
	String LWYR_SE = lawyerMap.get("LWYR_SE")==null?"":lawyerMap.get("LWYR_SE").toString();
	String GNDR_SE = lawyerMap.get("GNDR_SE")==null?"":lawyerMap.get("GNDR_SE").toString();
	String ARSP_NM = lawyerMap.get("ARSP_NM")==null?"":lawyerMap.get("ARSP_NM").toString();
	String LWYR_CTRT_STTS_NM = lawyerMap.get("LWYR_CTRT_STTS_NM")==null?"":lawyerMap.get("LWYR_CTRT_STTS_NM").toString();
	String SPC_FLD_CD = lawyerMap.get("SPC_FLD_CD")==null?"":lawyerMap.get("SPC_FLD_CD").toString();
	String [] SPC_FLD_CD_LIST = SPC_FLD_CD.split(",");
	
	String JDAF_CORP_MNG_NO = lawyerMap.get("JDAF_CORP_MNG_NO")==null?"":lawyerMap.get("JDAF_CORP_MNG_NO").toString();
	
	List cdList = request.getAttribute("cdList")==null?new ArrayList():(ArrayList) request.getAttribute("cdList");
	
	List bankList = request.getAttribute("bankList")==null?new ArrayList():(ArrayList)request.getAttribute("bankList");
	int ecnt = bankList.size();
	
	List tnrList = request.getAttribute("tnrList")==null?new ArrayList():(ArrayList)request.getAttribute("tnrList");
	int tcnt = tnrList.size();
	
	HashMap pfFile = request.getAttribute("pfFile")==null?new HashMap():(HashMap)request.getAttribute("pfFile");
	List codeList  = request.getAttribute("codeList")==null?new ArrayList():(ArrayList)request.getAttribute("codeList");
	List agtList   = request.getAttribute("agtList")==null?new ArrayList():(ArrayList)request.getAttribute("agtList");
%>
<style>
	.chrgList{text-align:center !important;}
	#noti {color: cadetblue; position: relative; margin-left: 10px;}
</style>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var LWYR_MNG_NO = "<%=LWYR_MNG_NO%>";
	var lawyerLoginId = "<%=lawyerLoginId%>";
	var formatedNow = "<%=formatedNow%>";
	var SPC_FLD_CD = "<%=SPC_FLD_CD%>";
	
	$(document).ready(function(){  //문서가 로딩될때
		if(LWYR_MNG_NO != "0"){
			$("#chkyn").val("Y");
			
			$("#pwReset").css("display", "");
			$("#pwChg").css("display", "");
			
			var term = document.getElementsByName("SPC_FLD_NM[]");
			var leng = term.length;
			var cnt = 0;
			for(var i=0; i < leng; i++ ){
				if(SPC_FLD_CD.indexOf(term[i].value) > -1){
					term[i].checked = true;
				}
			}
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
	
	function setCal() {
		$(".datepick").datepicker({ 
			showOn:"both", 
			buttonImage:"${pageContext.request.contextPath}/resources/seoul/images/btn_calendar.png",
			dateFormat:'yy-mm-dd',
			buttonImageOnly:false,
			changeMonth:true,
			changeYear:true,
			nextText:'다음 달',
			prevText:'이전 달',
			yearRange:'c-100:c+10',
			showMonthAfterYear:true, 
			dayNamesMin:['일','월','화','수','목','금','토'],
			monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
		});
	}
	
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
			
			if($("#LWYR_NM").val() == ""){
				return alert("변호사 이름을 입력하세요");
			}
			
			if($("#JDAF_CORP_MNG_NO").val() == ""){
				return alert("소속을 법인조회를 통해 선택 해 주세요");
			}
			
			if($("#chkyn").val() == "" || $("#chkyn").val() == "N"){
				if(lawyerLoginId != $("#LGN_ID").val()){
					return alert("아이디 중복체크 후 저장하세요");
				}
			}
			
			var oldPw = $("#LGN_PSWD").val();
			var newPw = $("#newPw").val();
			var num = newPw.search(/[0-9]/g);
			var eng = newPw.search(/[a-z]/ig);
			var spe = newPw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
			
			if($("#chgyn").val() == "Y"){
				if(oldPw != $("#oldPw").val()){
					return alert("기존 비밀번호가 틀렸습니다.");
				}else{
					if(newPw.search(/\s/) != -1){
						return alert("비밀번호는 공백을 포함할 수 없습니다.");
					}else if( (num < 0 && eng < 0) || (eng < 0 && spe < 0) || (spe < 0 && num < 0) ){
						return alert("영문, 숫자, 특수문자 중 2가지 이상을 혼합하여 입력하세요.");
					}else{
						$("#LGN_PSWD").val(newPw);
					}
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
						goListPage();
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
					goListPage();
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/golawyerList.do";
		document.frm.submit();
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
			data:{LWYR_MNG_NO:LWYR_MNG_NO, LGN_PSWD:pw, LGN_ID:lawyerLoginId, MBL_TELNO:$("#MBL_TELNO").val()},
			dataType:'json',
			success:function(data) {
				alert("비밀번호가 초기화 되었습니다.");
				goListPage();
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
					data:{LWYR_MNG_NO:LWYR_MNG_NO, LGN_PSWD:newPw},
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
		html += "		<input type='hidden' name='BANK_SE_NO"+ecnt+"'/>";
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
	
	function addTnr(idx) {
		var tcnt = $("#tcnt").val();
		if (tcnt == 0) {
			tcnt = 1;
		}
		var html = "";
		
		html += "<tr id='tnr"+tcnt+"'>";
		html += "	<th>위촉일</th>";
		html += "	<td>";
		html += "		<input type='hidden' name='TNR_MNG_NO"+tcnt+"'/>";
		html += "		<input type='text' name='ENTRST_BGNG_YMD"+tcnt+"' class='datepick' style='width:80%;' onchange=\"endymdSet(this.value, '"+tcnt+"');\"/>";
		html += "	</td>";
		html += "	<th>임기만료(해촉일)</th>";
		html += "	<td>";
		html += "		<input type='text' name='ENTRST_END_YMD"+tcnt+"' class='datepick' style='width:80%;'/>";
		html += "	</td>";
		html += "	<td>";
		html += "		<a href='#none' onclick='delTnr("+tcnt+");' class='innerBtn'>삭제</a>";
		html += "		<a href='#none' onclick='addTnr("+tcnt+");' class='innerBtn'>추가</a>";
		html += "	</td>";
		html += "</tr>";
		
		$("#tnrTable").append(html);
		tcnt++;
		$("#tcnt").val(tcnt);
		
		setCal();
	}
	
	function delTnr(idx) {
		$("tnr"+idx).remove();
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
	
	var testSeNm = "";
	function chgTestSeNm(seNm) {
		$("#TEST_PASS_YR").children('option').remove();
		testSeNm = seNm;
		
		var yrOptionText = "";
		if (seNm == "사법시험") {
			// 합격 년도를 1970~2017까지 중에서 선택할 수 있게 하되,
			// 1970년도 선택 시, 회수는 제12회
			// 년도가 1년 증가하면 회수도 증가하게하여 디폴트로 세팅되게하되
			// 수정하여 선택할 수도 있게(2017년도 선택 시, 회수는 제59회)
			
			yrOptionText += "<option value=''>선택</option>";
			for (var i=1970; i<=2017; i++) {
				yrOptionText += "<option value='"+i+"'>"+i+"년</option>";
			}
			$("#TEST_PASS_YR").append(yrOptionText);
		} else if (seNm == "변호사시험") {
			// 합격 년도를 2012년부터 현재 연도까지 선택할 수 있게 하되,
			// 2012년도 선택 시, 변시1회로 디폴트 선택되게 하되,
			// 다른 값을 선택할 수도 있게
			yrOptionText += "<option value=''>선택</option>";
			for (var i=2012; i<=formatedNow; i++) {
				yrOptionText += "<option value='"+i+"'>"+i+"년</option>";
			}
			
			$("#TEST_PASS_YR").append(yrOptionText);
		} else if (seNm == "군법무관") {
			// 제N기 또는 제N회 중에 자유롭게 선택할 수 있게 하되, N의 범위는 1~20으로 해주세요.
			yrOptionText += "<option value=''>-</option>";
			$("#TEST_PASS_YR").append(yrOptionText);
			
			chgTestPassYr('');
		}
	}
	
	function chgTestPassYr(yr) {
		$("#TEST_PASS_CYCL").children('option').remove();
		
		var cyclOptionText = "";
		
		if (testSeNm == "사법시험") {
			var cnt = yr-1958;
			
			cyclOptionText += "<option value=''>선택</option>";
			for(var i=12; i<=59; i++) {
				console.log("cnt : " + cnt);
				console.log("i : " + i);
				if (cnt == i) {
					cyclOptionText += "<option value='"+i+"' selected>제"+i+"회</option>";
				} else {
					cyclOptionText += "<option value='"+i+"'>제"+i+"회</option>";
				}
			}
		} else if (testSeNm == "변호사시험") {
			var cnt = yr-2011;
			
			cyclOptionText += "<option value=''>선택</option>";
			for(var i=1; i<=(formatedNow-2011); i++) {
				if (cnt == i) {
					cyclOptionText += "<option value='"+i+"' selected>"+i+"회</option>";
				} else {
					cyclOptionText += "<option value='"+i+"'>"+i+"회</option>";
				}
			}
		} else if (testSeNm == "군법무관") {
			cyclOptionText += "<option value=''>선택</option>";
			for(var i=1; i<=20; i++) {
				cyclOptionText += "<option value='"+i+"'>제"+i+"기</option>";
			}
		}
		
		console.log(cyclOptionText);
		$("#TEST_PASS_CYCL").append(cyclOptionText);
	}
	
	function endymdSet(val, idx) {
		var getDate = val;
		var dateObj = new Date(getDate);
		dateObj.setFullYear(dateObj.getFullYear() + 2);
		
		var returnDate = dateObj.getFullYear()+"-"+(String(dateObj.getMonth()+1).padStart(2,'0'))+"-"+(String(dateObj.getDate()).padStart(2,'0'));
		
		$("#ENTRST_END_YMD"+idx).val(returnDate);
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
	<input type="hidden" name="searchForm"  id="searchForm"  value="<%=searchForm%>"/>
	<input type="hidden" name="chkyn"       id="chkyn"       value=""/>
	<input type="hidden" name="chgyn"       id="chgyn"       value="N"/>
	<input type="hidden" name="ecnt"        id="ecnt"        value="<%=ecnt+1%>" />
	<input type="hidden" name="tcnt"        id="tcnt"        value="<%=tcnt+1%>" />
	<input type="hidden" name="profileFile" id="profileFile" value=""/>
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="innerB">
			<table class="infoTable write" style="width:100%">
				<colgroup>
					<col style="width:25%;">
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>메모</th>
					<td colspan="4">
						<input type="text" style="width:90%" name="MEMO_CN" id="MEMO_CN" value="<%=lawyerMap.get("MEMO_CN")==null?"":lawyerMap.get("MEMO_CN").toString()%>">
					</td>
				</tr>
				<tr>
					<td rowspan="8">
						<div id="fileUpload" class="dragAndDropDiv">
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div class="hkk2" style="width:49%;">
							<%
								if(pfFile.size() > 0) {
							%>
							<div class="statusbar odd">
								<div class="filename" style='width:80%'><%=pfFile.get("PHYS_FILE_NM") %></div><div class="abort"><input type="checkbox" name="delfile[]" value="<%=pfFile.get("FILE_MNG_NO") %>"/>　삭제</div>
							</div>
							<%
								}
							%>
						</div>
						<div id="hkk" class="hkk"></div>
					</td>
					<th>이름</th>
					<td>
						<input type="text" id="LWYR_NM" name="LWYR_NM" value="<%=lawyerMap.get("LWYR_NM")==null?"":lawyerMap.get("LWYR_NM").toString()%>">
					</td>
					<th>소속</th>
					<td>
						<input type="hidden" id="JDAF_CORP_MNG_NO" name ="JDAF_CORP_MNG_NO" value="<%=lawyerMap.get("JDAF_CORP_MNG_NO")==null?"":lawyerMap.get("JDAF_CORP_MNG_NO").toString()%>">
						<input type="text" id="JDAF_CORP_NM" name ="JDAF_CORP_NM" value="<%=lawyerMap.get("JDAF_CORP_NM")==null?"":lawyerMap.get("JDAF_CORP_NM").toString()%>" onclick="goSearchLawfirm()">
						<a href="#none" class="innerBtn" id="searchBtn" onclick="goSearchLawfirm()">조회</a>
					</td>
				</tr>
				<tr>
					<th>구분</th>
					<td>
						<input type="radio" name="LWYR_SE" id="LWYR_SE_Y" value="Y" <%if(LWYR_SE.equals("") || "Y".equals(LWYR_SE)) out.println("checked");%>/> 고문
						<input type="radio" name="LWYR_SE" id="LWYR_SE_N" value="N" <%if("N".equals(LWYR_SE)) out.println("checked");%>/> 일반
					</td>
					<th>성별</th>
					<td>
						<input type="radio" name="GNDR_SE" id="GNDR_SE_M" value="남" <%if(GNDR_SE.equals("") || "남".equals(GNDR_SE)) out.println("checked");%>/> 남성
						<input type="radio" name="GNDR_SE" id="GNDR_SE_W" value="여" <%if("여".equals(GNDR_SE)) out.println("checked");%>/> 여성
					</td>
				</tr>
				<tr>
					<th>아이디</th>
					<td>
						<input type="text" id="LGN_ID" name="LGN_ID" value="<%=lawyerMap.get("LGN_ID")==null?"":lawyerMap.get("LGN_ID").toString()%>" onkeyup="$('#chkyn').val('N');">
						<a href="#none" class="innerBtn" id="duchk" onclick="duchkFunction()">중복확인</a>
					</td>
<%
					if(!lawyerLoginId.equals("")){
%>
					<th>비밀번호</th>
					<td>
						<input type="password" id="LGN_PSWD" name="LGN_PSWD" value="<%=lawyerMap.get("LGN_PSWD")==null?"":lawyerMap.get("LGN_PSWD").toString()%>">
						<a href="#none" class="innerBtn" id="pwReset" onclick="pwReset()">비밀번호 초기화</a>
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
					</td>
				</tr>
				<tr>
					<th>출생연도</th>
					<td><input type="text" style="width:120px;" id="BRDT" name="BRDT" value="<%=lawyerMap.get("BRDT")==null?"":lawyerMap.get("BRDT").toString()%>"></td>
					<th>합격연도</th>
					<td>
						<select name="TEST_SE_NM" id="TEST_SE_NM" onchange="chgTestSeNm(this.value);">
							<option value="">선택</option>
							<option value="사법시험">사법시험</option>
							<option value="변호사시험">변호사시험</option>
							<option value="군법무관">군법무관</option>
						</select>
						<select name="TEST_PASS_YR" id="TEST_PASS_YR" onchange="chgTestPassYr(this.value);"></select>
						<select name="TEST_PASS_CYCL" id="TEST_PASS_CYCL"></select>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<div style="width:100%;">
							<table class="infoTable write" id="tnrTable" style="font-size:13px;">
								<colgroup>
									<col style="width:10%">
									<col style="width:*;">
									<col style="width:10%">
									<col style="width:*;">
									<col style="width:15%">
								</colgroup>
					<%
						if (tnrList.size() > 0) {
							for(int e=0; e<tnrList.size(); e++) {
								HashMap tnrMap = (HashMap) tnrList.get(e);
								
					%>
								<tr id="<%="tnr"+e %>">
									<th>위촉일</th>
									<td>
										<input type="hidden" name="<%="TNR_MNG_NO"+e %>" id="<%="TNR_MNG_NO"+e %>"  value="<%=tnrMap.get("TNR_MNG_NO")==null?"":tnrMap.get("TNR_MNG_NO").toString()%>"/>
										<input type="text" name="<%="ENTRST_BGNG_YMD"+e%>" id="<%="ENTRST_BGNG_YMD"+e%>" class="datepick" style='width:80%;' value="<%=tnrMap.get("ENTRST_BGNG_YMD")==null?"":tnrMap.get("ENTRST_BGNG_YMD").toString()%>" onchange="endymdSet(this.value, '<%=e%>');" />
									</td>
									<th>임기만료(해촉일)</th>
									<td>
										<input type="text" name="<%="ENTRST_END_YMD"+e%>" id="<%="ENTRST_END_YMD"+e%>" class="datepick" style='width:80%;' value="<%=tnrMap.get("ENTRST_END_YMD")==null?"":tnrMap.get("ENTRST_END_YMD").toString()%>" />
									</td>
									<td>
										<a href="#none" onclick="delTnr('<%=e%>');" class="innerBtn">삭제</a>
										<a href="#none" onclick="addTnr('<%=e%>');" class="innerBtn">추가</a>
									</td>
								</tr>
					<%
							}
						} else {
					%>
								<tr id="tnr0">
									<th>위촉일</th>
									<td>
										<input type="hidden" name="TNR_MNG_NO0" id="TNR_MNG_NO0" value=""/>
										<input type="text" name="ENTRST_BGNG_YMD0" id="ENTRST_BGNG_YMD0" class="datepick" value="" onchange="endymdSet(this.value, '0');"/>
									</td>
									<th>임기만료(해촉일)</th>
									<td>
										<input type="text" name="ENTRST_END_YMD0" id="ENTRST_END_YMD0" class="datepick" value="" />
									</td>
									<td>
										<a href="#none" onclick="delTnr('0');" class="innerBtn">삭제</a>
										<a href="#none" onclick="addTnr('0');" class="innerBtn">추가</a>
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
					<th>계약상태</th>
					<td>
						<input type="radio" name="LWYR_CTRT_STTS_NM" id="LWYR_CTRT_STTS_NM_Y" value="Y" <%if(LWYR_CTRT_STTS_NM.equals("") || "Y".equals(LWYR_CTRT_STTS_NM)) out.println("checked");%>/> 임기중
						<input type="radio" name="LWYR_CTRT_STTS_NM" id="LWYR_CTRT_STTS_NM_N" value="N" <%if("N".equals(LWYR_CTRT_STTS_NM)) out.println("checked");%>/> 해촉
						<input type="radio" name="LWYR_CTRT_STTS_NM" id="LWYR_CTRT_STTS_NM_A" value="A" <%if("A".equals(LWYR_CTRT_STTS_NM)) out.println("checked");%>/> 해촉(사임)
					</td>
				</tr>
				<tr>
					<th>휴대전화번호</th>
					<td>
						<input type="text" class="telInput" id="MBL_TELNO" name="MBL_TELNO" value="<%=lawyerMap.get("MBL_TELNO")==null?"":lawyerMap.get("MBL_TELNO").toString()%>">
						<p id="noti">※ 알림문자를 전송할 전화번호를 입력하세요</p>
					</td>
					<th>이메일</th>
					<td><input type="text" id="EML_ADDR" name="EML_ADDR" value="<%=lawyerMap.get("EML_ADDR")==null?"":lawyerMap.get("EML_ADDR").toString()%>"></td>
				</tr>
				<tr>
					<th>사무실 전화번호</th>
					<td>
						<input type="text" class="telInput" id="OFC_TELNO" name="OFC_TELNO" value="<%=lawyerMap.get("OFC_TELNO")==null?"":lawyerMap.get("OFC_TELNO").toString()%>">
					</td>
					<th>사무실 팩스번호</th>
					<td><input type="text" id="OFC_FXNO" name="OFC_FXNO" value="<%=lawyerMap.get("OFC_FXNO")==null?"":lawyerMap.get("OFC_FXNO").toString()%>"></td>
				</tr>
			</table>
			
			<table class="infoTable write" style="width:100%">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>전문분야</th>
					<td>
<%
					for(int i=0; i<cdList.size(); i++) {
						HashMap map = (HashMap) cdList.get(i);
						if ("ARSP_NM".equals(map.get("CD_LCLSF_ENG_NM"))){
							if (ARSP_NM.equals(map.get("CD_MNG_NO").toString())) {
								//out.println("<option value='"+map.get("CD_MNG_NO").toString()+"' selected>"+map.get("CD_NM").toString()+"</option>");
								out.println("<input type='checkbox' name='ARSP_NM[]' value='"+map.get("CD_MNG_NO").toString()+"' checked> "+map.get("CD_NM").toString());
							} else {
								//out.println("<option value='"+map.get("CD_MNG_NO").toString()+"'>"+map.get("CD_NM").toString()+"</option>");
								out.println("<input type='checkbox' name='ARSP_NM[]' value='"+map.get("CD_MNG_NO").toString()+"'> "+map.get("CD_NM").toString());
							}
						}
					}
%>
					</td>
				</tr>
				<tr>
					<th>특별분야</th>
					<td>
<%
					for(int i=0; i<cdList.size(); i++) {
						HashMap map = (HashMap) cdList.get(i);
						if ("SPC_FLD_NM".equals(map.get("CD_LCLSF_ENG_NM"))){
							out.println("<input type='checkbox' name='SPC_FLD_NM[]' value='"+map.get("CD_MNG_NO").toString()+"'> "+map.get("CD_NM").toString());
						}
					}
%>
					</td>
				</tr>
				<tr>
					<th>국제법률자문</th>
					<td>
						<div>
							<table class="infoTable write">
								<tr>
									<th>법률고문</th>
									<td>
										<input type="text" id="LWYR_INTL_CNSTN_CN" name="LWYR_INTL_CNSTN_CN" value="<%=lawyerMap.get("LWYR_INTL_CNSTN_CN")==null?"":lawyerMap.get("LWYR_INTL_CNSTN_CN").toString()%>">
									</td>
								</tr>
							<%
							if(!LWYR_MNG_NO.equals("")) {
							%>
								<tr>
									<th>소속법인</th>
									<td>
										<input type="text" id="CORP_INTL_CNSTN_CN" name="CORP_INTL_CNSTN_CN" <%if(JDAF_CORP_MNG_NO.equals("")) out.println("disabled");%> value="<%=lawyerMap.get("CORP_INTL_CNSTN_CN")==null?"":lawyerMap.get("CORP_INTL_CNSTN_CN").toString()%>">
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
					<th>지적재산권법률자문</th>
					<td>
						<div>
							<table class="infoTable write">
								<tr>
									<th>법률고문</th>
									<td>
										<input type="text" id="LWYR_IPR_CNSTN_CN" name="LWYR_IPR_CNSTN_CN" value="<%=lawyerMap.get("LWYR_IPR_CNSTN_CN")==null?"":lawyerMap.get("LWYR_IPR_CNSTN_CN").toString()%>">
									</td>
								</tr>
								<%
								if(!LWYR_MNG_NO.equals("")) {
								%>
								<tr>
									<th>소속법인</th>
									<td>
										<input type="text" id="CORP_IPR_CNSTN_CN" name="CORP_IPR_CNSTN_CN" <%if(JDAF_CORP_MNG_NO.equals("")) out.println("disabled");%> value="<%=lawyerMap.get("CORP_IPR_CNSTN_CN")==null?"":lawyerMap.get("CORP_IPR_CNSTN_CN").toString()%>">
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
					<th>소속법인 변호사수(명)</th>
					<td>
						<input type="text" id="OGDP_CORP_LWYR_CNT" name="OGDP_CORP_LWYR_CNT" value="<%=lawyerMap.get("OGDP_CORP_LWYR_CNT")==null?"":lawyerMap.get("OGDP_CORP_LWYR_CNT").toString()%>">
					</td>
				</tr>
				<tr>
					<th>담당직원 이메일</th>
					<td>
						<textarea id="TKCG_EMP_EML_ADDR_CN" name="TKCG_EMP_EML_ADDR_CN" rows="3" cols="3"><%=lawyerMap.get("TKCG_EMP_EML_ADDR_CN")==null?"":lawyerMap.get("TKCG_EMP_EML_ADDR_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>경력</th>
					<td>
						<textarea id="CRR_MTTR" name="CRR_MTTR" rows="3" cols="3"><%=lawyerMap.get("CRR_MTTR")==null?"":lawyerMap.get("CRR_MTTR").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>학력</th>
					<td>
						<textarea id="ACBG_CN" name="ACBG_CN" rows="3" cols="3"><%=lawyerMap.get("ACBG_CN")==null?"":lawyerMap.get("ACBG_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td>
						<textarea rows="5" cols="200" name="RMRK_CN" id="RMRK_CN"><%=lawyerMap.get("RMRK_CN")==null?"":lawyerMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>24.7.10.이후<br/>(누적5회)<br/> 민원야기</th>
					<td>
						<textarea rows="5" cols="200" name="CVLCPT_CN" id="CVLCPT_CN"><%=lawyerMap.get("CVLCPT_CN")==null?"":lawyerMap.get("CVLCPT_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>24.7.10.이후<br/>(소송자문 거절 10회이상)<br/>거절횟수</th>
					<td>
						<textarea rows="5" cols="200" name="ACAP_RFSL_CN" id="ACAP_RFSL_CN"><%=lawyerMap.get("ACAP_RFSL_CN")==null?"":lawyerMap.get("ACAP_RFSL_CN").toString()%></textarea>
					</td>
				</tr>
				<tr>
					<th>계좌정보</th>
					<td>
						<div style="width:100%;">
							<table class="pop_infoTable write" id="bankTable">
								<colgroup>
									<col style="width:15%;">
									<col style="width:15%;">
									<col style="width:*;">
									<col style="width:10%">
									<col style="width:*;">
									<col style="width:15%">
								</colgroup>
								<tr>
									<th style="text-align:center;">은행명</th>
									<th style="text-align:center;">예금주명</th>
									<th style="text-align:center;">계좌번호</th>
									<th style="text-align:center;">사용여부</th>
									<th style="text-align:center;">비고</th>
									<th style="text-align:center;"></th>
								</tr>
					<%
						if (bankList.size() > 0) {
							for(int e=0; e<bankList.size(); e++) {
								HashMap bankMap = (HashMap) bankList.get(e);
								
								String BANK_SE_NO = bankMap.get("BANK_SE_NO")==null?"":bankMap.get("BANK_SE_NO").toString();
								String USE_YN = bankMap.get("USE_YN")==null?"":bankMap.get("USE_YN").toString();
					%>
								<tr id="<%="bank"+e %>">
									<td>
										<input type="hidden" name="<%="BACNT_MNG_NO"+e %>" id="<%="BACNT_MNG_NO"+e %>"  value="<%=bankMap.get("BACNT_MNG_NO")==null?"":bankMap.get("BACNT_MNG_NO").toString()%>"/>
										<input type="hidden" name="<%="BANK_SE_NO"+e %>"   id="<%="BANK_SE_NO"+e %>"    value="<%=bankMap.get("BANK_SE_NO")==null?"":bankMap.get("BANK_SE_NO").toString()%>"/>
										<input type="text"   name="<%="BANK_NM"+e %>"      id="<%="BANK_NM"+e %>"       value="<%=bankMap.get("BANK_NM")==null?"":bankMap.get("BANK_NM").toString()%>" style="width:60%;" readonly="readonly" onclick="searchBank('<%=e%>');"/>
										<a href="#none" onclick="searchBank('<%=e%>');" class="innerBtn">검색</a>
									</td>
									<td>
										<input type="text"   name="<%="DPSTR_NM"+e %>" style="width:95%;" value="<%=bankMap.get("DPSTR_NM")==null?"":bankMap.get("DPSTR_NM").toString()%>"/>
									</td>
									<td>
										<input type="text"   name="<%="ACTNO"+e %>" style="width:95%;" value="<%=bankMap.get("ACTNO")==null?"":bankMap.get("ACTNO").toString()%>"/>
									</td>
									<td>
										<select name="<%="USE_YN"+e %>">
											<option value="Y" <%if(USE_YN.equals("") || "Y".equals(USE_YN)) out.println("selected"); %>>사용</option>
											<option value="N" <%if("N".equals(USE_YN)) out.println("selected"); %>>미사용</option>
										</select>
									</td>
									<td>
										<input type="text"   name="<%="RMRK_CN"+e %>" style="width:95%;" value="<%=bankMap.get("RMRK_CN")==null?"":bankMap.get("RMRK_CN").toString()%>"/>
									</td>
									<td>
										<a href="#none" onclick="delBank('<%=e%>');" class="innerBtn">삭제</a>
										<a href="#none" onclick="addBank('<%=e%>');" class="innerBtn">추가</a>
									</td>
								</tr>
					<%
							}
						} else {
					%>
								<tr id="bank0">
									<td>
										<input type="hidden" name="BACNT_MNG_NO0" id="BACNT_MNG_NO0" value=""/>
										<input type="hidden" name="BANK_SE_NO0"   id="BANK_SE_NO0"   value=""/>
										<input type="text"   name="BANK_NM0"      id="BANK_NM0"      style="width:60%;" value="" readonly="readonly" onclick="searchBank('0');"/>
										<a href="#none" onclick="searchBank('0');" class="innerBtn">검색</a>
									</td>
									<td>
										<input type="text"   name="DPSTR_NM0" style="width:95%;" value=""/>
									</td>
									<td>
										<input type="text"   name="ACTNO0" style="width:95%;" value=""/>
									</td>
									<td>
										<select name="USE_YN0">
											<option value="Y">사용</option>
											<option value="N">미사용</option>
										</select>
									</td>
									<td>
										<input type="text"   name="RMRK_CN0" style="width:95%;" value=""/>
									</td>
									<td>
										<a href="#none" onclick="delBank('0');" class="innerBtn">삭제</a>
										<a href="#none" onclick="addBank('0');" class="innerBtn">추가</a>
									</td>
								</tr>
					<%
						}
					%>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC right">
				<a href="#none" class="sBtn type1" onclick="goSaveInfo();">등록</a>
				<a href="#none" class="sBtn type2" onclick="goListPage();">목록</a>
			</div>
		</div>
	</div>
</form>
