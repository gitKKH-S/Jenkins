<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	
	HashMap reviewInfo = request.getAttribute("reviewInfo")==null?new HashMap():(HashMap)request.getAttribute("reviewInfo");
	List commiteeList = request.getAttribute("commiteeList")==null?new ArrayList():(ArrayList)request.getAttribute("commiteeList");
	HashMap opinionCnt = request.getAttribute("opinionCnt")==null?new HashMap():(HashMap)request.getAttribute("opinionCnt");
	List fileList = request.getAttribute("fileList")==null?new ArrayList():(ArrayList)request.getAttribute("fileList");

	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	int fstCnt = 0;
	int secCnt = 0;
	int thrCnt = 0;
	
	if(fileList.size() > 0){
		for(int i=0; i<fileList.size(); i++){
			HashMap file = (HashMap)fileList.get(i);
			String gbn = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
			if("FST".equals(gbn)){
				fstCnt = fstCnt+1;
			}else if("SEC".equals(gbn)){
				secCnt = secCnt+1;
			}else if("THR".equals(gbn)){
				thrCnt = thrCnt+1;
			}
		}
	}

	String LWS_DLBR_MNG_NO = reviewInfo.get("LWS_DLBR_MNG_NO")==null?"":reviewInfo.get("LWS_DLBR_MNG_NO").toString();
	String DLBR_END_CN     = reviewInfo.get("DLBR_END_CN")==null?"":reviewInfo.get("DLBR_END_CN").toString();
	String PRGRS_STTS_NM   = reviewInfo.get("PRGRS_STTS_NM")==null?"작성중":reviewInfo.get("PRGRS_STTS_NM").toString();
	String DLBR_SE_NM      = reviewInfo.get("DLBR_SE_NM")==null?"":reviewInfo.get("DLBR_SE_NM").toString();
	String DLBR_AGND_NM    = reviewInfo.get("DLBR_AGND_NM")==null?"":reviewInfo.get("DLBR_AGND_NM").toString();
	String LWS_MNG_NO      = reviewInfo.get("LWS_MNG_NO")==null?"":reviewInfo.get("LWS_MNG_NO").toString();
	String LWS_INCDNT_NM   = reviewInfo.get("LWS_INCDNT_NM")==null?"":reviewInfo.get("LWS_INCDNT_NM").toString();
	String INST_MNG_NO     = reviewInfo.get("INST_MNG_NO")==null?"":reviewInfo.get("INST_MNG_NO").toString();
	String INCDNT_NO       = reviewInfo.get("INCDNT_NO")==null?"":reviewInfo.get("INCDNT_NO").toString();
	String DLBR_NO         = reviewInfo.get("DLBR_NO")==null?"":reviewInfo.get("DLBR_NO").toString();
	DLBR_NO = DLBR_NO.replaceAll("@", "");
	
	String reviewWriter = reviewInfo.get("RQST_EMP_NO")==null?"":reviewInfo.get("RQST_EMP_NO").toString();
	
	String ycnt = opinionCnt.get("YCNT")==null?"0":opinionCnt.get("YCNT").toString();
	String ncnt = opinionCnt.get("NCNT")==null?"0":opinionCnt.get("NCNT").toString();
	String icnt = opinionCnt.get("ICNT")==null?"0":opinionCnt.get("ICNT").toString();
	String acnt = opinionCnt.get("ACNT")==null?"0":opinionCnt.get("ACNT").toString();
	
	int yycnt = Integer.parseInt(ycnt);
	int nncnt = Integer.parseInt(ncnt);
	int iicnt = Integer.parseInt(icnt);
	
	String endState = "";
	
	if(yycnt > nncnt){
		endState = "가결";
	}else if(yycnt <= nncnt){
		endState = "부결";
	}else if((yycnt+nncnt) < iicnt){
		endState = "보류";
	}
	
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script src="${resourceUrl}/js/mten.findword.js"></script>
<script src="${resourceUrl}/PDFObject-master/pdfobject.min.js" type="text/javascript"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var LWS_DLBR_MNG_NO = "<%=LWS_DLBR_MNG_NO%>";
	var PRGRS_STTS_NM   = "<%=PRGRS_STTS_NM%>";
	var DLBR_SE_NM      = "<%=DLBR_SE_NM%>";
	var DLBR_AGND_NM    = "<%=DLBR_AGND_NM%>";
	
	$(document).ready(function(){
		$(".hideBtn").css("display", "none");
	});
	
	function goReload(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/suitReviewViewPage.do";
		document.frm.submit();
	}
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/goSuitReviewList.do";
		document.frm.submit();
	}
	
	function approve(state){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/suitReviewRequest.do",
			data:{LWS_DLBR_MNG_NO:LWS_DLBR_MNG_NO, PRGRS_STTS_NM:state},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				goReload();
			}
		});
	}
	
	function selectCommiteeList(){
		var cw=900;
		var ch=585;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","setComPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "setComPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/suitCommiteePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_DLBR_MNG_NO", value:LWS_DLBR_MNG_NO}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function saveContInfo(){
		var DLBR_DCS_CN = $("#DLBR_DCS_CN").val();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/reviewContInfoSave.do",
			data:{LWS_DLBR_MNG_NO:LWS_DLBR_MNG_NO, DLBR_DCS_CN:DLBR_DCS_CN},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				goReload();
			}
		});
	}
	
	function saveEndInfo(){
		var DLBR_END_CN = $("#DLBR_END_CN").val();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/reviewEndInfoSave.do",
			data:{LWS_DLBR_MNG_NO:LWS_DLBR_MNG_NO, DLBR_END_CN:DLBR_END_CN, DLBR_SE_NM:DLBR_SE_NM},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				goReload();
			}
		});
	}
	
	function goEditReviewInfo(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/suitReviewWritePage.do";
		document.frm.submit();
	}
	
	function goDelReviewInfo(){
		if(confirm("안건을 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/delReviewInfo.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					goListPage();
				}
			});
		}
	}
	
	function writeOpinionPop(DLBR_CMT_MNG_NO, DLBR_MBCMT_MNG_NO){
		var cw=900;
		var ch=550;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","wOpPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "wOpPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/writeOpinionPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_DLBR_MNG_NO", value:LWS_DLBR_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"DLBR_CMT_MNG_NO", value:DLBR_CMT_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"DLBR_MBCMT_MNG_NO", value:DLBR_MBCMT_MNG_NO}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function saveFile(gbn){
		for (var i = 0; i < fileList.length; i++) {
			var formData = new FormData();
			formData.append("file"+i, fileList[i]);
			formData.append("LWS_MNG_NO", LWS_DLBR_MNG_NO);
			formData.append("INST_MNG_NO", LWS_DLBR_MNG_NO);
			formData.append("TRGT_PST_MNG_NO", LWS_DLBR_MNG_NO);
			formData.append("TRGT_PST_TBL_NM", "TB_LWS_DLBR");
			formData.append("FILE_SE", gbn);
			formData.append("SORT_SEQ", i);
			
			var status = statusList[i];
			var uploadURL = "${pageContext.request.contextPath}/web/suit/fileUpload.do";
			uploadFileFunction(status, uploadURL, formData, i, fileList.length);
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
					goReload();
				}
			}
		});
		status.setAbort(jqXHR);
	}
	
	function showDetail(gbn, num){
		document.getElementById(gbn).style.display='';
		document.getElementById("show"+num).style.display='none';
		document.getElementById("hide"+num).style.display='';
		//$("#show"+num).css
		//$("#show"+num).addClass("active");
	}
	
	function hideDetail(gbn,num){
		document.getElementById(gbn).style.display='none';
		document.getElementById("show"+num).style.display='';
		document.getElementById("hide"+num).style.display='none';
		//$("#show"+num).removeClass("active");
	}
</script>
<style>
	.selFileDiv{cursor:pointer;}
</style>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="LWS_DLBR_MNG_NO" id="LWS_DLBR_MNG_NO" value="<%=LWS_DLBR_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<div class="subCA">
		<div class="subBtnC left">
			<strong class="subTT"><%=reviewInfo.get("DLBR_AGND_NM")==null?"":reviewInfo.get("DLBR_AGND_NM").toString()%></strong>
		</div>
		<div class="subBtnC right" id="test">
<%
		if("작성중".equals(PRGRS_STTS_NM)){
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"approve('심의요청결재중');\">심의위원회 구성요청</a>");
		}
		
		if("심의요청결재중".equals(PRGRS_STTS_NM)){
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"approve('송무팀접수대기');\">심의요청결재</a>");
		}
		
		if("송무팀접수대기".equals(PRGRS_STTS_NM)){
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"approve('송무팀접수');\">접수</a>");
		}
		
		if("송무팀접수".equals(PRGRS_STTS_NM)){
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectCommiteeList();\">심의위원회 구성</a>");
		}
		
		if("심의위원회구성".equals(PRGRS_STTS_NM)){
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"approve('심의개최결재중');\">심의위원회 개최요청</a>");
		}
		
		if("심의개최결재중".equals(PRGRS_STTS_NM)){
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"approve('심의중');\">심의개최결재</a>");
		}
		
		if("심의완료".equals(PRGRS_STTS_NM)){
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"approve('심의완료결재중');\">심의완료 결재요청</a>");
		}
		
		if("심의완료결재중".equals(PRGRS_STTS_NM)){
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"approve('현업부서통보');\">심의완료결재</a>");
		}
		
		if("현업부서통보".equals(PRGRS_STTS_NM)){
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"approve('완료');\">현업부서 통보</a>");
		}
%>
		</div>
		<hr class="margin40">
		<div class="innerB">
			<table class="infoTable" style="width:100%">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>심의번호</th>
					<td><%=DLBR_NO%></td>
					<th>심의구분</th>
					<td><%=reviewInfo.get("DLBR_SE_NM")==null?"":reviewInfo.get("DLBR_SE_NM").toString()%></td>
					<th>의뢰인</th>
					<td id="deptname">
						<%=reviewInfo.get("RQST_DEPT_NM")==null?"":reviewInfo.get("RQST_DEPT_NM").toString()%>
						 <%=reviewInfo.get("RQST_EMP_NM")==null?"":reviewInfo.get("RQST_EMP_NM").toString()%>
					</td>
				</tr>
				<tr>
					<th>심의일자</th>
<%
					if(!PRGRS_STTS_NM.equals("완료")){
%>
					<td colspan="5">
						<%=reviewInfo.get("DLBR_BGNG_YMD")==null?"":reviewInfo.get("DLBR_BGNG_YMD").toString()%>
						~
						<%=reviewInfo.get("DLBR_END_YMD")==null?"":reviewInfo.get("DLBR_END_YMD").toString()%>
					</td>
<%
					}else{
%>
					<td colspan="3">
						<%=reviewInfo.get("DLBR_BGNG_YMD")==null?"":reviewInfo.get("DLBR_BGNG_YMD").toString()%>
						~
						<%=reviewInfo.get("DLBR_END_YMD")==null?"":reviewInfo.get("DLBR_END_YMD").toString()%>
					</td>
					<th>심의결과</th>
					<td><%=endState %></td>
<%
					}
%>
				</tr>
				<tr>
					<th>안건명</th>
					<td id="title" colspan="5">
						<%=reviewInfo.get("DLBR_AGND_NM")==null?"":reviewInfo.get("DLBR_AGND_NM").toString()%>
					</td>
				</tr>
<%
				String getSuitnm = reviewInfo.get("LWS_INCDNT_NM")==null?"":reviewInfo.get("LWS_INCDNT_NM").toString();
				if(getSuitnm != ""){

%>
				<tr>
					<th>소송명</th>
					<td id="suitnm" colspan="3">
<%
				String getsuitnm[] = getSuitnm.split(",");
				if(!getsuitnm.equals("")){
					for(int i=0; i<getsuitnm.length; i++){
%>
					<p><%=getsuitnm[i].toString()%></p>
<%
					}
				}
%>
					</td>
					<th>사건번호</th>
					<td id="casenum">
<%
				String getcasenum[] = reviewInfo.get("INCDNT_NO").toString().split(",");
				if(!getcasenum.equals("")){
					for(int i=0; i<getcasenum.length; i++){
%>
					<p><%=getcasenum[i].toString()%></p>
<%
					}
				}
%>
					</td>
				</tr>
<%
				}
%>
				<tr>
					<th>심의의결 요청사항</th>
					<td colspan="5">
						<%=reviewInfo.get("DLBR_DMND_CN")==null?"":reviewInfo.get("DLBR_DMND_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
<%
				if("의결중".equals(PRGRS_STTS_NM) || "심의완료".equals(PRGRS_STTS_NM) || "심의완료결재중".equals(PRGRS_STTS_NM) || "현업부서통보".equals(PRGRS_STTS_NM) || "완료".equals(PRGRS_STTS_NM)){
%>
				<tr>
					<th>심의·의결 내용</th>
					<td colspan="5">
						<%=reviewInfo.get("DLBR_DCS_CN")==null?"":reviewInfo.get("DLBR_DCS_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
<%
				}

				if("완료".equals(PRGRS_STTS_NM)){
%>
				<tr>
					<th>심의·의결 결과</th>
					<td colspan="5">
						<%=reviewInfo.get("DLBR_DCS_CN")==null?"":reviewInfo.get("DLBR_DCS_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
<%
				}
%>
				<tr>
					<th>심의요청<br/>첨부파일</th>
					<td colspan="5" id="fileList">
<%
					if(fileList.size() > 0){
						for(int f=0; f<fileList.size(); f++){
							HashMap file = (HashMap)fileList.get(f);
							String simgbn = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
							if("FST".equals(simgbn)){
%>
						<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
							<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
						</div>
<%
							}
						}
					}
%>
					</td>
				</tr>
<%
				if("심의위원회구성".equals(PRGRS_STTS_NM) || "심의개최결재중".equals(PRGRS_STTS_NM) || "심의중".equals(PRGRS_STTS_NM) || "의결중".equals(PRGRS_STTS_NM) 
					|| "심의완료".equals(PRGRS_STTS_NM) || "심의완료결재중".equals(PRGRS_STTS_NM) || "현업부서통보".equals(PRGRS_STTS_NM) || "완료".equals(PRGRS_STTS_NM)){
%>
				<tr>
					<th>심의위원회 개최요청<br/>첨부파일</th>
<%
					if(secCnt > 0){
%>
					<td colspan="5">
<%
						for(int f=0; f<fileList.size(); f++){
							HashMap file = (HashMap)fileList.get(f);
							String simgbn = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
							if("SEC".equals(simgbn)){
%>
						<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
							<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
						</div>
<%
							}
						}
%>
					</td>
<%
					}else{
						if("심의위원회구성".equals(PRGRS_STTS_NM) && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1)){
%>
				
					<td colspan="4">
						<div id="fileUpload" class="dragAndDropDiv">
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div id="hkk" class="hkk">
					</td>
					<td style="width:5%">
						<a href="#none" class="innerBtn" onclick="saveFile('SEC');">저장</a>
					</td>
<%
						}
					}
				}
%>
				</tr>
<%
				if("심의완료".equals(PRGRS_STTS_NM) || "심의완료결재중".equals(PRGRS_STTS_NM) || "현업부서통보".equals(PRGRS_STTS_NM) || "완료".equals(PRGRS_STTS_NM)){
%>
				<tr>
					<th style="width:15%">심의완료<br/>첨부파일</th>
<%
					if(thrCnt > 0){
%>
					<td colspan="5">
<%
						for(int f=0; f<fileList.size(); f++){
							HashMap file = (HashMap)fileList.get(f);
							String simgbn = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
							if("THR".equals(simgbn)){
%>
						<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
							<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
						</div>
<%
							}
						}
%>
					</td>
<%
					}else{
						if("심의완료".equals(PRGRS_STTS_NM) && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1)){
%>
				
					<td colspan="4">
						<div id="fileUpload" class="dragAndDropDiv">
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						</div>
						<div id="hkk" class="hkk">
					</td>
					<td style="width:5%">
						<a href="#none" class="innerBtn" onclick="saveFile('THR');">저장</a>
					</td>
<%
						}
					}
				}
%>
				</tr>
			</table>
		</div>
<%
		if("심의중".equals(PRGRS_STTS_NM) && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1)){
%>
		<hr class="margin10">
		<div class="innerB" id="resultState">
			<strong class="subST">심의·의결 내용</strong>
			<table class="infoTable">
				<tr>
					<td colspan="5">
						<textarea id="DLBR_DCS_CN" name="DLBR_DCS_CN" rows="8" cols=""></textarea>
						<a href="#none" class="innerBtn" onclick="saveContInfo();">저장</a>
					</td>
				</tr>
			</table>
		</div>
<%
		}
%>
<%
		
		if("심의완료".equals(PRGRS_STTS_NM) && DLBR_END_CN.equals("") && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1)){
%>
		<hr class="margin10">
		<div class="innerB" id="resultState">
			<strong class="subST">심의·의결 결과</strong>
			<table class="infoTable">
				<tr>
					<td colspan="5">
						<textarea id="DLBR_END_CN" name="DLBR_END_CN" rows="8" cols=""></textarea>
						<a href="#none" class="innerBtn" onclick="saveEndInfo();">저장</a>
					</td>
				</tr>
			</table>
		</div>
<%
		}
%>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<a href="#none" class="sBtn type1" onclick="goListPage();">목록</a>
			</div>
			<div class="subBtnC right">
				<a href="#none" class="sBtn type4" onclick="goEditReviewInfo();">수정</a>
				<a href="#none" class="sBtn type3" onclick="goDelReviewInfo();">삭제</a>
			</div>
		</div>
<%
			if("의결중".equals(PRGRS_STTS_NM) || "심의완료".equals(PRGRS_STTS_NM) || "심의완료결재중".equals(PRGRS_STTS_NM) || "현업부서통보".equals(PRGRS_STTS_NM) || "완료".equals(PRGRS_STTS_NM)){
%>
		<hr class="margin10">
		<div class="innerB" id="resultState">
			<strong class="subST">심의의결</strong>
			<table class="infoTable">
<%
				if("심의완료".equals(PRGRS_STTS_NM) || "심의완료결재중".equals(PRGRS_STTS_NM) || "현업부서통보".equals(PRGRS_STTS_NM) || "완료".equals(PRGRS_STTS_NM)){
%>
				<tr>
					<th>참석</th>
					<td><%=acnt%></td>
					<th>찬성</th>
					<td><%=ycnt%></td>
					<th>반대</th>
					<td><%=ncnt%></td>
					<th>보류</th>
					<td><%=icnt%></td>
				</tr>
<%
				}
%>
			</table>
			<table class="infoTable">
				<tr>
					<td style="background:#f3f6f7;">부서명</td>
					<td style="background:#f3f6f7;">심의위원</td>
					<td style="background:#f3f6f7;">비고</td>
				</tr>
				<%
					for (int i=0; i<commiteeList.size(); i++){
						HashMap commiteeMap = (HashMap) commiteeList.get(i);
						commiteeMap.put("gbnid", commiteeMap.get("DLBR_CMT_MNG_NO"));
						String opinionyn = commiteeMap.get("DLBR_RSLT_NM")==null?"":commiteeMap.get("DLBR_RSLT_NM").toString();
				%>
					<tr>
						<td><%=commiteeMap.get("DLBR_MBCMT_DEPT_NM") %></td>
						<td><%=commiteeMap.get("DLBR_MBCMT_EMP_NM") %></td>
						<td>
<%
						if(!opinionyn.equals("")) {
%>
							<a href="#none" id="show<%=i%>" onclick="showDetail('detail<%=i%>', '<%=i%>')" class="innerBtn">보기</a>
							<a href="#none" id="hide<%=i%>" onclick="hideDetail('detail<%=i%>', '<%=i%>')" class="innerBtn active hideBtn">닫기</a>
<%
						}

						if(opinionyn.equals("") && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1)){
%>
							<a href="#none" id="hide" onclick="writeOpinionPop('<%=commiteeMap.get("DLBR_CMT_MNG_NO") %>','<%=commiteeMap.get("DLBR_MBCMT_MNG_NO") %>')" class="innerBtn">심의의결</a>
<%
						}
%>
						</td>
					</tr>
					<tr style="display:none;" id="detail<%=i%>">
						<td colspan="3">
							<table class="inner" style="margin:10px; width:98%;">
								<colgroup>
									<col style="width:15%;">
									<col style="width:65%;">
									<col style="width:20%;">
								</colgroup>
								<tr>
									<td>채택여부</td>
									<td>내용</td>
									<td>첨부파일</td>
								</tr>
								<tr>
									<td>
										<%
											//String opinionyn = commiteeMap.get("OPINIONYN")==null?"":commiteeMap.get("OPINIONYN").toString();
											if("Y".equals(opinionyn)){
												out.print("찬성");
											}else if("N".equals(opinionyn)){
												out.print("반대");
											}else if("I".equals(opinionyn)){
												out.print("보류");
											}else{
												out.print("미참석");
											}
										%>
									</td>
									<td>
										<%=commiteeMap.get("DLBR_OPNN_CN")==null?"":commiteeMap.get("DLBR_OPNN_CN").toString().replaceAll("\n","<br/>")%>
									</td>
									<td>
										<ul class="fileList">
<%
											String viewFilenm = commiteeMap.get("VIEWFILENM")==null?"":commiteeMap.get("VIEWFILENM").toString();
											if(!viewFilenm.equals("")){
												String view[] = commiteeMap.get("VIEWFILENM").toString().split(",");
												String server[] = commiteeMap.get("SERVERFILENM").toString().split(",");
												String sz[] = commiteeMap.get("VIEW_SZ").toString().split(",");
												for(int f=0; f<view.length; f++){
%>
											<li>
												<a href="#" onclick="downFile('<%=view[f]%>','<%=server[f]%>')" ><%=view[f]%> (<%=sz[f]%>)</a>
											</li>
<%
												}
											}
%>
										</ul>
									</td>
								</tr>
							</table>
						</td>
					</tr>
<%
					}
%>
			</table>
			<hr class="margin40">
		</div>
<%
			}
%>
	</div>
</form>