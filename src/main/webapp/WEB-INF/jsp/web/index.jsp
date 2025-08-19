<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	System.out.println(se);
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String cnt1 = request.getAttribute("cnt1")==null?"0":request.getAttribute("cnt1").toString();
	String cnt2 = request.getAttribute("cnt2")==null?"0":request.getAttribute("cnt2").toString();
	String cntDate = request.getAttribute("cntDate")==null?"0":request.getAttribute("cntDate").toString();
	HashMap cntDetailDate = request.getAttribute("cntDetailDate")==null?new HashMap():(HashMap)request.getAttribute("cntDetailDate");
	
	HashMap cntM1 = null;
	HashMap cntM2 = null;
	String cntM_0 = "0";
	String cntM_1 = "0";
	String cntM_2 = "0";
	String cntM_3 = "0";
	String cntM_4 = "";
	String cntM_5 = "0";
	
	String dateDetail1 = "";
	String dateDetail2 = "";
	String dateDetail3 = "";
	dateDetail1 = cntDetailDate.get("UNCH_DATE_CNT")==null?"0":cntDetailDate.get("UNCH_DATE_CNT").toString();
	dateDetail2 = cntDetailDate.get("DATE_CNT")==null?"0":cntDetailDate.get("DATE_CNT").toString();
	dateDetail3 = cntDetailDate.get("DOC_CNT")==null?"0":cntDetailDate.get("DOC_CNT").toString();
	
	if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("G") > -1){
		cntM1 = request.getAttribute("cntY2")==null?new HashMap():(HashMap)request.getAttribute("cntY2");
		cntM_0 = cntM1.get("TOTAL_CNT")==null?"0":cntM1.get("TOTAL_CNT").toString();
		cntM_1 = cntM1.get("LWS_TKCG_CNT")==null?"0":cntM1.get("LWS_TKCG_CNT").toString();
		cntM_2 = cntM1.get("CNSTN_CNT")==null?"0":cntM1.get("CNSTN_CNT").toString();
		cntM_3 = cntM1.get("CVTN_CNT")==null?"0":cntM1.get("CVTN_CNT").toString();
		
	} else if(GRPCD.indexOf("P") > -1){
		cntM1 = request.getAttribute("cntM1")==null?new HashMap():(HashMap)request.getAttribute("cntM1");
		cntM_0 = cntM1.get("CNT1")==null?"0":cntM1.get("CNT1").toString();
		cntM_1 = cntM1.get("CNT2")==null?"0":cntM1.get("CNT2").toString();
		
		cntM2 = request.getAttribute("cntM2")==null?new HashMap():(HashMap)request.getAttribute("cntM2");
		cntM_2 = cntM2.get("CNT1")==null?"0":cntM2.get("CNT1").toString();
		cntM_3 = cntM2.get("CNT2")==null?"0":cntM2.get("CNT2").toString();
		cntM_4 = cntM2.get("GBN")==null?"0":cntM2.get("GBN").toString();
	} else if(GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N") > -1 || GRPCD.indexOf("R") > -1){
		cntM1 = request.getAttribute("cntA1")==null?new HashMap():(HashMap)request.getAttribute("cntA1");
		cntM_0 = cntM1.get("ACNT1")==null?"0":cntM1.get("ACNT1").toString(); // 필수
		cntM_1 = cntM1.get("ACNT2")==null?"0":cntM1.get("ACNT2").toString(); // 기타계약
		cntM_2 = cntM1.get("ACNT3")==null?"0":cntM1.get("ACNT3").toString(); // 시의회
		
		cntM2 = request.getAttribute("cntA2")==null?new HashMap():(HashMap)request.getAttribute("cntA2");
		cntM_3 = cntM2.get("ACNT1")==null?"0":cntM2.get("ACNT1").toString();
		cntM_4 = cntM2.get("ACNT2")==null?"0":cntM2.get("ACNT2").toString();
		cntM_5 = cntM2.get("ACNT3")==null?"0":cntM2.get("ACNT3").toString();
	} else{
	}
		
	String cnt3 = request.getAttribute("cnt3")==null?"0":request.getAttribute("cnt3").toString();
	String cnt4 = request.getAttribute("cnt4")==null?"0":request.getAttribute("cnt4").toString();
	
	System.out.println("1");
	List notiPdsList = request.getAttribute("notiPdsList")==null?new ArrayList():(ArrayList)request.getAttribute("notiPdsList");
	System.out.println("2");
	List list1 = request.getAttribute("list1")==null?new ArrayList():(ArrayList)request.getAttribute("list1");
	System.out.println("3");
	List list2 = request.getAttribute("list2")==null?new ArrayList():(ArrayList)request.getAttribute("list2");
	System.out.println("4");
	
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
%>
<style>
	#contentW{height:320px;}
	.topSrchC dl dd:HOVER {cursor:pointer;}
	.filename{text-decoration:underline;}
	
	.sel { cursor:pointer; }
	.sel2 { cursor:pointer; text-decoration:underline; font-weight:bold;}
</style>
<script src="${resourceUrl}/js/mten.static.js"></script>
<link rel="stylesheet" href="${resourceUrl}/jBox-master/dist/jBox.all.css">
<script src="${resourceUrl}/jBox-master/dist/jBox.all.js"></script>
<script>
	$(document).ready(function(){
		$.ajax({
			type : "POST",
			url : "<%=CONTEXTPATH%>/bylaw/popmn/todayPopList.do",
			datatype: "json",
			error: function(){
				
			},
			success:function(data){
				var result = JSON.parse(data);
				var obj = result.result;
				for(i=0; i<obj.length; i++){
					var cont = obj[i].POPUP_CN;
					if (obj[i].PHYS_FILE_NM != "" && obj[i].PHYS_FILE_NM != "undefined" && obj[i].PHYS_FILE_NM != null) {
						cont += "\r<br/>\r<br/><li class='filename' onclick='downpage(\""+obj[i].PHYS_FILE_NM+"\", \""+obj[i].SRVR_FILE_NM+"\")' style='cursor:pointer;'>"+obj[i].PHYS_FILE_NM+"</li>";
					}
					var mo = new jBox('Modal', {
						attach: '#Modal-'+obj[i].POPUP_MNG_NO,
						offset: {
							x: 100*(i),
							y: 100*(i)
						},
						width: obj[i].POPUP_WDTH_SZ,
						height: obj[i].POPUP_VRTC_SZ,
						blockScroll: false,
						animation: 'zoomIn',
						draggable: 'title',
						closeButton: true,
						content: cont,
						title: obj[i].POPUP_TTL,
						overlay: false,
						reposition: false,
						repositionOnOpen: false
					});
					mo.open();
				}
			}
		});
		
		<%
		if(GRPCD.indexOf("B") == -1 && GRPCD.indexOf("D") == -1 && GRPCD.indexOf("E") == -1 && 
			GRPCD.indexOf("F") == -1) {
		%>
		schView('','');
		<%
		}
		%>
	});
	
	function schView(year, month){
		$.ajax({
			type : "POST",
			url : "<%=CONTEXTPATH %>/web/schdule.do",
			data : {
				year : year,
				month : month,
				GRPCD : "<%=GRPCD%>"
			},
			success : function(data) {
				$(".scheduleW").html(data);
			}
		});
	}
	
	function suitCView(LWS_RQST_MNG_NO) {
		var cw=1200;
		var ch=850;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","suitCpop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "suitCpop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/suitConsultViewPagePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_RQST_MNG_NO", value:LWS_RQST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function suitView(LWS_MNG_NO, INST_MNG_NO) {
		var cw=1200;
		var ch=850;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","suitpop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "suitpop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function pdsView(PST_MNG_NO) {
		var cw=900;
		var ch=575;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","pdspop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "pdspop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/pds/pdsViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"PST_MNG_NO", value:PST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goToMenu() {
		$("#10000181").trigger("click");
	}
	
	function consultView(CNSTN_MNG_NO) {
		var cw=900;
		var ch=575;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","consultpop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "consultpop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/consultViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:CNSTN_MNG_NO}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function agreeView(CVTN_MNG_NO, MENU_MNG_NO) {
		var cw=900;
		var ch=575;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","agreepop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "agreepop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/agreeViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:CVTN_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function conAgreeView(SEQ, MENU_NO, GBN){
		if(GBN != 'CON'){
			 agreeView(SEQ, MENU_NO);
		} else {
			consultView(SEQ)
		}
	}
	
	function goBondView(LWS_MNG_NO, INST_MNG_NO, BND_MNG_NO){
		var cw=900;
		var ch=850;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoView",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoView");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/bondViewPage.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"BND_MNG_NO", value:BND_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:''}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goLawyerInfo(LWYR_MNG_NO) {
		var cw=1200;
		var ch=600;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","lawyerInfo",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "lawyerInfo");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/lawyerViewPagePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWYR_MNG_NO",        value:LWYR_MNG_NO}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goBondInfo(BND_MNG_NO, INST_MNG_NO, LWS_MNG_NO) {
		var cw=900;
		var ch=850;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoView",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoView");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/bondViewPage.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"BND_MNG_NO", value:BND_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:''}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function taskViewPop(TASK_GBN, DOC_PK1, DOC_PK2) {
		if (TASK_GBN == "SUIT") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","workInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "workInfo");
			newForm.attr("action", CONTEXTPATH+"/web/suit/caseViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:DOC_PK1}));
			newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:DOC_PK2}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (TASK_GBN == "CONSULT") {
			// 자문 팝업
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","workInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "workInfo");
			newForm.attr("action", CONTEXTPATH+"/web/consult/consultViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"consultid", value:DOC_PK1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (TASK_GBN == "AGREE") {
			// 자문 팝업
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","workInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "workInfo");
			newForm.attr("action", CONTEXTPATH+"/web/agree/agreeViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:DOC_PK1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (TASK_GBN == "SCONSULT") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","workInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "workInfo");
			newForm.attr("action", CONTEXTPATH+"/web/suit/suitConsultViewPagePop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_RQST_MNG_NO", value:DOC_PK1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	}
	
	function goGpkiChk() {
		var cw=1200;
		var ch=850;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","workInfo",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "workInfo");
		newForm.attr("action", CONTEXTPATH+"/gpkisecureweb/jsp/createSecureSession_1_1.jsp");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"create"}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
</script>

<form name="ViewForm" method="post">
	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<form name="mfm" method="post">
	<input type="hidden" name="MENU_MNG_NO" />
	<input type="hidden" name="MENU_SE_NM" />
	<input type="hidden" name="smType" />
	<input type="hidden" name="" />
</form>

<style>
	.cnt_link{
		cursor: pointer;
/* 		text-decoration: underline; */
/* 		text-decoration-thickness: 2px;	 */
	}
</style>
<div class="innerW">
	<div class="countW">
<%
	if(GRPCD.indexOf("Y") > -1) {
%>
		<div class="countC type1">
			<div class="countC_inner">
				<span class="tCnt"><%=cntDate%></span>
				<strong>미도래(불변 <%=dateDetail1%> / 서면 <%=dateDetail2%> / 기일<%=dateDetail3%>)</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<span class="tCnt"><%=cntM_0%></span>
				<strong>진행중(소송 <%=cntM_1%> / 자문 <span class="cnt_link" vo="10000002" vo1="COUNSEL" vo2="100000131" vo3="/web/consult/goConsultMain.do" vo8="진행중"><%=cntM_2%></span> / 협약 <span class="cnt_link" vo="10000225" vo1="AGREE" vo2="10000225" vo3="/web/agree/goAgreeMain.do" vo8="진행중"><%=cntM_3%></span>)</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	//} else if(GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1) {
	} else if(GRPCD.indexOf("C") > -1) {
%>
		<div class="countC type1">
			<div class="countC_inner">
				<span class="tCnt"><%=cntDate%></span>
				<strong>미도래(불변 <%=dateDetail1%> / 서면 <%=dateDetail2%> / 기일<%=dateDetail3%>)</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt2%></span>
				<strong>진행중</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	} else if(GRPCD.indexOf("J") > -1 || GRPCD.indexOf("M") > -1 || GRPCD.indexOf("Q") > -1) {
%>
		<div class="countC type1">
			<div class="countC_inner">
				<span class="tCnt"><span class="cnt_link" style="cursor: pointer;" vo="10000002" vo1="COUNSEL" vo2="100000131" vo3="/web/consult/goConsultMain.do" vo8="접수대기"><%=cnt1%></span></span>
				<strong>접수대기</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<span class="tCnt"><span class="cnt_link" style="cursor: pointer;" vo="10000002" vo1="COUNSEL" vo2="100000131" vo3="/web/consult/goConsultMain.do" vo8="진행중"><%=cnt2%></span></span>
				<strong>진행중</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	} else if(GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N") > -1 || GRPCD.indexOf("R") > -1) {
%>
		<div class="countC type1">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt1%></span>
				<strong>접수대기(필수 <span class="cnt_link" vo="10000225" vo1="AGREE" vo2="10000225" vo3="/web/agree/goAgreeMain.do" vo8="접수대기"><%=cntM_0%></span> 
				/ 기타 <span class="cnt_link" vo="10000225" vo1="AGREE" vo2="100000595" vo3="/web/agree/goAgreeMain.do" vo8="접수대기"><%=cntM_1%></span>
				 / 시의회 <span class="cnt_link" vo="10000225" vo1="AGREE" vo2="100000596" vo3="/web/agree/goAgreeMain.do" vo8="접수대기"><%=cntM_2%></span>)
			 	</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt2%></span>
				<strong>진행중(필수 <span class="cnt_link" vo="10000225" vo1="AGREE" vo2="10000225" vo3="/web/agree/goAgreeMain.do" vo8="진행중"><%=cntM_3%></span> 
				/ 기타 <span class="cnt_link" vo="10000225" vo1="AGREE" vo2="100000595" vo3="/web/agree/goAgreeMain.do" vo8="진행중"><%=cntM_4%></span>
				 / 시의회 <span class="cnt_link" vo="10000225" vo1="AGREE" vo2="100000596" vo3="/web/agree/goAgreeMain.do" vo8="진행중"><%=cntM_5%></span>)</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	} else if(GRPCD.indexOf("L") > -1 || GRPCD.indexOf("D") > -1) {
%>
		<!-- 소송접수 담당, 소송 대리인 수임료 담당 -->
		<div class="countC type1">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt1%></span>
				<strong>담당자 미배정</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt2%></span>
				<strong>소송비용 지급 요청</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	} else if(GRPCD.indexOf("E") > -1) {
%>
		<div class="countC type1">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt1%></span>
				<strong>소송비용 회수미완료</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt2%></span>
				<strong>소송비용 미청구</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	} else if(GRPCD.indexOf("F") > -1 || GRPCD.indexOf("B") > -1) {
%>
		<div class="countC type1">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt1%></span>
				<strong>자문료 지급 요청</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt2%></span>
				<strong>소송비용 지급 요청</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	} else if(GRPCD.indexOf("G") > -1) {
%>
		<div class="countC type1">
			<div class="countC_inner">
				<span class="tCnt"><%=cntDate%></span>
				<strong>미도래(불변 <%=dateDetail1%> / 서면 <%=dateDetail2%> / 기일<%=dateDetail3%>)</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<span class="tCnt"><%=cntM_0%></span>
				<strong>진행중(소송 <%=cntM_1%> / 자문 <span class="cnt_link" vo="10000002" vo1="COUNSEL" vo2="100000131" vo3="/web/consult/goConsultMain.do" vo8="진행중"><%=cntM_2%></span> / 협약 <span class="cnt_link" vo="10000225" vo1="AGREE" vo2="10000225" vo3="/web/agree/goAgreeMain.do" vo8="진행중"><%=cntM_3%></span>)</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	} else if(GRPCD.indexOf("I") > -1) {
%>
		<div class="countC type1">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt1%></span>
				<strong>만료예정</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt2%></span>
				<strong>법률 고문수</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	} else if(GRPCD.indexOf("P") > -1) {
%>
		<div class="countC type1">
			<div class="countC_inner">
				<strong>소송</strong>
				<span class="tCnt"><%=cntM_0%>/<%=cntM_1%></span>
				<strong>진행중/종결</strong>
			</div>
		</div>
		<div class="countC type2">
			<div class="countC_inner">
				<%-- <strong><%=cntM_4%></strong> --%>
				<strong>자문·협약</strong>
				<span class="tCnt"><%=cntM_2%>/<%=cntM_3%></span>
				<strong>진행중/종료</strong>
			</div>
		</div>
		<div class="countC type3">
			<div class="countC_inner">
				<span class="tCnt"><%=cnt4%></span>
				<strong>나의 할 일</strong>
			</div>
		</div>
<%
	}
%>
	</div>
</div>
<div class="innerW">
	<div class="quick_linkW">
<%
	if(GRPCD.indexOf("Y") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="B"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">중요소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="C"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">특별관리소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000001" vo1="PAN" vo2="10000009" vo3="/web/suit/goSuitMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">법률고문현황 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	} else if(GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="B"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">중요소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="C"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">특별관리소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000001" vo1="PAN" vo2="10000009" vo3="/web/suit/goSuitMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">법률고문현황 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	} else if(GRPCD.indexOf("J") > -1 || GRPCD.indexOf("M") > -1 || GRPCD.indexOf("Q") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000013" vo1="STS" vo2="10000146" vo3="/web/statistics/goStsMain.do" vo4="O"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">외부자문대장 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000002" vo1="COUNSEL" vo2="100000395" vo3="/web/consult/goConsultMain.do"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">구두자문현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000002" vo1="COUNSEL" vo2="100003227" vo3="/web/consult/goConsultMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">법률고문현황 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	} else if(GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N") > -1 || GRPCD.indexOf("R") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000225" vo1="AGREE" vo2="10000225" vo3="/web/agree/goAgreeMain.do"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">필수심사 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000225" vo1="AGREE" vo2="100000595" vo3="/web/agree/goAgreeMain.do"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">기타계약 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000225" vo1="AGREE" vo2="100000596" vo3="/web/agree/goAgreeMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">시의회 사전동의 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	} else if(GRPCD.indexOf("B") > -1 || GRPCD.indexOf("D") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="B"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">중요소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000013" vo1="STS" vo2="10000135" vo3="/web/statistics/goStsMain.do"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">담당별 사건수 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000001" vo1="PAN" vo2="10000009" vo3="/web/suit/goSuitMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">법률고문현황 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	} else if(GRPCD.indexOf("E") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="B"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">중요소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="C"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">특별관리소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000001" vo1="PAN" vo2="10000009" vo3="/web/suit/goSuitMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">법률고문현황 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	} else if(GRPCD.indexOf("F") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000013" vo1="STS" vo2="10000146" vo3="/web/statistics/goStsMain.do" vo4="O"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">외부자문대장 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000013" vo1="STS" vo2="10000146" vo3="/web/statistics/goStsMain.do" vo5="국제"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">국제자문대장 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000002" vo1="COUNSEL" vo2="100003227" vo3="/web/consult/goConsultMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">법률고문현황 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	} else if(GRPCD.indexOf("G") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="B"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">중요소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="C"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">특별관리소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000001" vo1="PAN" vo2="10000009" vo3="/web/suit/goSuitMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">법률고문현황 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	} else if(GRPCD.indexOf("I") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="B"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">중요소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000001" vo1="PAN" vo2="10000008" vo3="/web/suit/goSuitMain.do" vo6="" vo7="C"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">특별관리소송현황 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000001" vo1="PAN" vo2="10000009" vo3="/web/suit/goSuitMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">법률고문현황 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	} else if(GRPCD.indexOf("P") > -1) {
%>
		<div class="ql type1" vo="" vo1="" vo2="" vo3=""><span><i class="ph-bold ph-question"></i>        </span><a href="#none">이용방법 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type2" vo="10000002" vo1="COUNSEL" vo2="100000131" vo3="/web/consult/goConsultMain.do"><span><i class="ph-bold ph-git-pull-request"></i></span><a href="#none">법률자문 의뢰 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type3" vo="10000225" vo1="AGREE" vo2="10000225" vo3="/web/agree/goAgreeMain.do"><span><i class="ph-bold ph-archive"></i>         </span><a href="#none">필수심사 <i class="ph-bold ph-caret-right"></i></a></div>
		<div class="ql type4" vo="10000225" vo1="AGREE" vo2="100000596" vo3="/web/agree/goAgreeMain.do"><span><i class="ph-bold ph-question"></i>        </span><a href="#none">시의회 사전동의 <i class="ph-bold ph-caret-right"></i></a></div>
<%
	}
%>
	</div>
</div>
<style>
	.notice{width:100%; height:50px; overflow:hidden; background-color:#fff;}
	.rolling{position:relative; width:100%; height:auto;}
	.rolling li{width:100%; height:50px; line-height:50px; font-size:16px;}
	.rolling_stop{display:block; width:100px; height:20px; background-color:#000; color:#fff; text-align:center;}
	.rolling_start{display:block; width:100px; height:20px; background-color:#000; color:#0f0; text-align:center;}
</style>
<div class="innerW">
	<div class="noticeW">
		<div class="notice-text">
			<h2 style="width:130px;">공지사항</h2>
			<div class="notice">
				<ul class="rolling">
				<%
					if (notiPdsList.size() > 0) {
						for(int i=0; i<notiPdsList.size(); i++) {
							HashMap pdsMap = (HashMap) notiPdsList.get(i);
							String PST_MNG_NO = pdsMap.get("PST_MNG_NO")==null?"":pdsMap.get("PST_MNG_NO").toString();
				%>
					<li>
						<a href="#" class="sel" onclick="pdsView('<%=PST_MNG_NO%>');"><%=pdsMap.get("PST_TTL")==null?"":pdsMap.get("PST_TTL").toString()%></a>
					</li>
				<%
						}
					} else {
				%>
					<li><a href="#">등록 된 공지사항이 없습니다.</a></li>
				<%
					}
				%>
				</ul>
			</div>
		</div>
		<button type="button" onclick="goToMenu();"><i class="ph-bold ph-plus"></i></button>
		<div class="" vo="" vo1="" vo2="" vo3="" style="position: relative; display: block; font-weight: 600; color: #fff; font-size: 18px; padding: 0px 40px 0px 0px;">
			<a href="#none" onclick="goGpkiChk();">인증서등록 <i class="ph-bold ph-caret-right"></i></a>
		</div>
	</div>
</div>
<script>
	$(document).ready(function(){
		var height =  $(".notice").height();
		var num = $(".rolling li").length;
		var max = height * num;
		var move = 0;
		function noticeRolling(){
			move += height;
			$(".rolling").animate({"top":-move},600,function(){
				if( move >= max ){
					$(this).css("top",0);
					move = 0;
				};
			});
		};
		
		noticeRollingOff = setInterval(noticeRolling,3000);
		$(".rolling").append($(".rolling li").first().clone());
	});
</script>
<div class="innerW">
	<div class="m_boardW">
<%
	if(GRPCD.indexOf("Y") > -1) {
%>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-clock-clockwise"></i> <span>진행중인 사건 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
		%>
				<li class="sel" onclick="suitView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">
					<p><%=map.get("LWS_INCDNT_NM")==null?"":map.get("LWS_INCDNT_NM").toString()%></p>
					<span><%=map.get("FLGLW_YMD")==null?"":map.get("FLGLW_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>진행중인 사건이 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>진행중인 자문/협약 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list2.size(); i++) {
					HashMap map = (HashMap) list2.get(i);
					String SEQ1 = map.get("SEQ1")==null?"":map.get("SEQ1").toString();
					String MENU_NO = map.get("MENU_NO")==null?"":map.get("MENU_NO").toString();
					String GBN = map.get("GBN")==null?"":map.get("GBN").toString();
		%>
				<li class="sel" onclick="conAgreeView('<%=SEQ1%>', '<%=MENU_NO%>', '<%=GBN%>');">
				<%
				if(!"CON".equals(GBN)){
				%>
					<p>(협약-<%=map.get("VAL1")==null?"":map.get("VAL1").toString()%>)<%=map.get("TTL")==null?"":map.get("TTL").toString()%></p>
					
				<%
				}else{
				%>
					<p>(자문)<%=map.get("TTL")==null?"":map.get("TTL").toString()%></p>
				<%
				}
				%>
					<span><%=map.get("RCPT_YMD")==null?"":map.get("RCPT_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>자료가  없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
<%
	} else if(GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1) { // 송무팀(팀장님포함) 
%>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>진행중인 사건 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
		%>
				<li class="sel" onclick="suitView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">
					<p><%=map.get("LWS_INCDNT_NM")==null?"":map.get("LWS_INCDNT_NM").toString()%></p>
					<span><%=map.get("FLGLW_YMD")==null?"":map.get("FLGLW_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>진행중인 사건이 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>나의 할 일</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String LWS_MNG_NO = map.get("DOC_PK1")==null?"":map.get("DOC_PK1").toString();
					String INST_MNG_NO = map.get("DOC_PK2")==null?"":map.get("DOC_PK2").toString();
		%>
				<li class="sel" onclick="suitView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">
					<p>[<%=map.get("TASK_SE_NM")==null?"":map.get("TASK_SE_NM").toString()%>]<%=map.get("DOC_NM")==null?"":map.get("DOC_NM").toString()%></p>
				</li>
		<%
				}
			} else {
		%>
				<li><p>진행중인 업무가 없습니다.</p></li>
		<%
			}
		%>
			</ul>
		</div> 

<%
	} else if(GRPCD.indexOf("J") > -1 || GRPCD.indexOf("M") > -1 || GRPCD.indexOf("Q") > -1) { // 자문팀(팀장님포함)
%>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-clock-clockwise"></i> <span>접수대기 자문 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String CNSTN_MNG_NO = map.get("CNSTN_MNG_NO")==null?"":map.get("CNSTN_MNG_NO").toString();
		%>
				<li class="sel" onclick="consultView('<%=CNSTN_MNG_NO%>');">
					<p><%=map.get("CNSTN_TTL")==null?"":map.get("CNSTN_TTL").toString()%></p>
					<span><%=map.get("CNSTN_RQST_YMD")==null?"":map.get("CNSTN_RQST_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>등록된 접수대기 자료가  없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>진행중인 자문 목록</span></h2>
			<ul>
		<%
			if (list2.size() > 0) {
				for(int i=0; i<list2.size(); i++) {
					HashMap map = (HashMap) list2.get(i);
					String CNSTN_MNG_NO = map.get("CNSTN_MNG_NO")==null?"":map.get("CNSTN_MNG_NO").toString();
		%>
				<li class="sel" onclick="consultView('<%=CNSTN_MNG_NO%>');">
					<p><%=map.get("CNSTN_TTL")==null?"":map.get("CNSTN_TTL").toString()%></p>
					<span><%=map.get("CNSTN_RCPT_YMD")==null?"":map.get("CNSTN_RCPT_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>진행중인 자문이 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
<%
	} else if(GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N") > -1 || GRPCD.indexOf("R") > -1) { // 협약팀(팀장님포함)
%>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-clock-clockwise"></i> <span>접수대기 협약 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String CVTN_MNG_NO = map.get("CVTN_MNG_NO")==null?"":map.get("CVTN_MNG_NO").toString();
					String MENU_MNG_NO = map.get("MENU_MNG_NO")==null?"":map.get("MENU_MNG_NO").toString();
					String CVTN_CTRT_TYPE_CD_NM = map.get("CVTN_CTRT_TYPE_CD_NM")==null?"":map.get("CVTN_CTRT_TYPE_CD_NM").toString();
		%>
				<li class="sel" onclick="agreeView('<%=CVTN_MNG_NO%>', '<%=MENU_MNG_NO%>');">
					<p>(<%=map.get("CVTN_CTRT_TYPE_CD_NM")==null?"":map.get("CVTN_CTRT_TYPE_CD_NM").toString()%>)<%=map.get("CVTN_TTL")==null?"":map.get("CVTN_TTL").toString()%></p>
					<span><%=map.get("CVTN_RQST_YMD")==null?"":map.get("CVTN_RQST_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>등록된 접수대기 자료가  없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>진행중인 협약목록</span></h2>
			<ul>
		<%
			if (list2.size() > 0) {
				for(int i=0; i<list2.size(); i++) {
					HashMap map = (HashMap) list2.get(i);
					String CVTN_MNG_NO = map.get("CVTN_MNG_NO")==null?"":map.get("CVTN_MNG_NO").toString();
					String MENU_MNG_NO = map.get("MENU_MNG_NO")==null?"":map.get("MENU_MNG_NO").toString();
					String CVTN_CTRT_TYPE_CD_NM = map.get("CVTN_CTRT_TYPE_CD_NM")==null?"":map.get("CVTN_CTRT_TYPE_CD_NM").toString();
		%>
				<li class="sel" onclick="agreeView('<%=CVTN_MNG_NO%>', '<%=MENU_MNG_NO%>');">
					<p>(<%=map.get("CVTN_CTRT_TYPE_CD_NM")==null?"":map.get("CVTN_CTRT_TYPE_CD_NM").toString()%>)<%=map.get("CVTN_TTL")==null?"":map.get("CVTN_TTL").toString()%></p>
					<span><%=map.get("CVTN_RCPT_YMD")==null?"":map.get("CVTN_RCPT_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>진행중인 검토 의뢰가 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
<%
	} else if(GRPCD.indexOf("B") > -1 || GRPCD.indexOf("D") > -1) { // 송무1팀 주무관님(소장접수, 소송비용 지급 업무)
%>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-clock-clockwise"></i> <span>담당자 미배정 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
		%>
				<li class="sel" onclick="suitView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">
					<p>(<%=map.get("CD_NM")==null?"":map.get("CD_NM").toString()%>)<%=map.get("LWS_INCDNT_NM")==null?"":map.get("LWS_INCDNT_NM").toString()%></p>
					<span><%=map.get("REG_YMD")==null?"":map.get("REG_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>등록된 자료가 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>진행중인 소송비용 지급 요청 목록</span></h2>
			<ul>
		<%
			if (list2.size() > 0) {
				for(int i=0; i<list2.size(); i++) {
					HashMap map = (HashMap) list2.get(i);
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
					String CVTN_CTRT_TYPE_CD_NM = map.get("CVTN_CTRT_TYPE_CD_NM")==null?"":map.get("CVTN_CTRT_TYPE_CD_NM").toString();
		%>
				<li class="sel" onclick="suitView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">
					<p>(<%=map.get("CD_NM")==null?"":map.get("CD_NM").toString()%> - <%=map.get("CST_PRCS_SE_KR")==null?"":map.get("CST_PRCS_SE_KR").toString()%>)<%=map.get("LWS_INCDNT_NM")==null?"":map.get("LWS_INCDNT_NM").toString()%></p>
					<span><%=map.get("CST_PRCS_YMD")==null?"":map.get("CST_PRCS_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>등록된 자료가 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
<%
	} else if(GRPCD.indexOf("E") > -1) { // 소송비용회수담당
%>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-clock-clockwise"></i> <span>소송비용 회수미완료 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
					String BND_MNG_NO = map.get("BND_MNG_NO")==null?"":map.get("BND_MNG_NO").toString();
		%>
				<li class="sel" onclick="goBondView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>', <%=BND_MNG_NO%>)">
					<p><%=map.get("DOC_NM")==null?"":map.get("DOC_NM").toString()%></p>
					<span><%=map.get("DUDT_YMD")==null?"":map.get("DUDT_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>미회수 된 소송비용이 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>소송비용 미청구 목록</span></h2>
			<ul>
		<%
			if (list2.size() > 0) {
				for(int i=0; i<list2.size(); i++) {
					HashMap map = (HashMap) list2.get(i);
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
		%>
				<li class="sel" onclick="suitView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>')">
					<p><%=map.get("DOC_NM")==null?"":map.get("DOC_NM").toString()%></p>
					<span><%=map.get("DUDT_YMD")==null?"":map.get("DUDT_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>미청구 된 소송비용이 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div> 
<%
	} else if(GRPCD.indexOf("F") > -1) { // 자문료, 인지대 등 담당
%>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-clock-clockwise"></i> <span>진행중인 자문료 지급 요청 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String CNSTN_MNG_NO = map.get("CNSTN_MNG_NO")==null?"":map.get("CNSTN_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
		%>
				<li class="sel" onclick="consultView('<%=CNSTN_MNG_NO%>');">
					<p>(<%=map.get("CST_PRGRS_STTS_SE")==null?"":map.get("CST_PRGRS_STTS_SE").toString()%> - <%=map.get("RVW_TKCG_EMP_NM")==null?"":map.get("RVW_TKCG_EMP_NM").toString()%>)<%=map.get("CNSTN_TTL")==null?"":map.get("CNSTN_TTL").toString()%></p>
					<span><%=map.get("CST_CLM_YMD")==null?"":map.get("CST_CLM_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>등록된 자료가 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>진행중인 소송비용 지급 요청 목록</span></h2>
			<ul>
		<%
			if (list2.size() > 0) {
				for(int i=0; i<list2.size(); i++) {
					HashMap map = (HashMap) list2.get(i);
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
					String CVTN_CTRT_TYPE_CD_NM = map.get("CVTN_CTRT_TYPE_CD_NM")==null?"":map.get("CVTN_CTRT_TYPE_CD_NM").toString();
		%>
				<li class="sel" onclick="suitView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">
					<p>(<%=map.get("CD_NM")==null?"":map.get("CD_NM").toString()%> - <%=map.get("CST_PRCS_SE_KR")==null?"":map.get("CST_PRCS_SE_KR").toString()%>)<%=map.get("LWS_INCDNT_NM")==null?"":map.get("LWS_INCDNT_NM").toString()%></p>
					<span><%=map.get("CST_PRCS_YMD")==null?"":map.get("CST_PRCS_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>등록된 자료가 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
<%
	} else if(GRPCD.indexOf("G") > -1) { // 과장님
%>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-clock-clockwise"></i> <span>진행중인 사건 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
		%>
				<li class="sel" onclick="suitView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">
					<p><%=map.get("LWS_INCDNT_NM")==null?"":map.get("LWS_INCDNT_NM").toString()%></p>
					<span><%=map.get("FLGLW_YMD")==null?"":map.get("FLGLW_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>진행중인 사건이 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>진행중인 자문/협약 목록</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list2.size(); i++) {
					HashMap map = (HashMap) list2.get(i);
					String SEQ1 = map.get("SEQ1")==null?"":map.get("SEQ1").toString();
					String MENU_NO = map.get("MENU_NO")==null?"":map.get("MENU_NO").toString();
					String GBN = map.get("GBN")==null?"":map.get("GBN").toString();
		%>
				<li class="sel" onclick="conAgreeView('<%=SEQ1%>', '<%=MENU_NO%>', '<%=GBN%>');">
				<%
				if(!"CON".equals(GBN)){
				%>
					<p>(협약-<%=map.get("VAL1")==null?"":map.get("VAL1").toString()%>)<%=map.get("TTL")==null?"":map.get("TTL").toString()%></p>
					
				<%
				}else{
				%>
					<p>(자문)<%=map.get("TTL")==null?"":map.get("TTL").toString()%></p>
				<%
				}
				%>
					<span><%=map.get("RCPT_YMD")==null?"":map.get("RCPT_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>자료가  없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
<%
	} else if(GRPCD.indexOf("I") > -1) { // 법률고문 담당자
%>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-clock-clockwise"></i> <span>임기 만료 예정 법률 고문</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap map = (HashMap) list1.get(i);
					String LWYR_MNG_NO = map.get("LWYR_MNG_NO")==null?"":map.get("LWYR_MNG_NO").toString();
		%>
				<li class="sel" onclick="goLawyerInfo('<%=LWYR_MNG_NO%>');">
					<p><%=map.get("JDAF_CORP_NM")==null?"":map.get("JDAF_CORP_NM").toString()%> - <%=map.get("LWYR_NM")==null?"":map.get("LWYR_NM").toString()%></p>
					<span><%=map.get("ENTRST_END_YMD")==null?"":map.get("ENTRST_END_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>자료가 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>나의 할 일</span></h2>
			<ul>
		<%
			if (list2.size() > 0) {
				for(int i=0; i<list2.size(); i++) {
					HashMap map = (HashMap) list2.get(i);
					String SEQ1 = map.get("SEQ1")==null?"":map.get("SEQ1").toString();
					String MENU_NO = map.get("MENU_NO")==null?"":map.get("MENU_NO").toString();
					String GBN = map.get("GBN")==null?"":map.get("GBN").toString();
		%>
				<li class="sel" onclick="conAgreeView('<%=SEQ1%>', '<%=MENU_NO%>', '<%=GBN%>');">
				<%
				if(!"CON".equals(GBN)){
				%>
					<p>(협약-<%=map.get("VAL1")==null?"":map.get("VAL1").toString()%>)<%=map.get("TTL")==null?"":map.get("TTL").toString()%></p>
					
				<%
				}else{
				%>
					<p>(자문)<%=map.get("TTL")==null?"":map.get("TTL").toString()%></p>
				<%
				}
				%>
					<span><%=map.get("RCPT_YMD")==null?"":map.get("RCPT_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>자료가  없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>

<%
	} else if(GRPCD.indexOf("P") > -1) { // 일반사용자
%>

		<div class="m_boardC">
			<!-- <h2><i class="ph-bold ph-clock-clockwise"></i> <span>나의 업무 목록</span></h2> -->
			<h2><i class="ph-bold ph-clock-clockwise"></i> <span>자주 묻는 질문</span></h2>
			<ul>
		<%
			if (list1.size() > 0) {
				for(int i=0; i<list1.size(); i++) {
					HashMap pdsMap = (HashMap) list1.get(i);
					String PST_MNG_NO = pdsMap.get("PST_MNG_NO")==null?"":pdsMap.get("PST_MNG_NO").toString();
		%>
				<li class="sel" onclick="pdsView('<%=PST_MNG_NO%>');">
					<p><%=pdsMap.get("PST_TTL")==null?"":pdsMap.get("PST_TTL").toString()%></p>
				</li>
		<%
				}
			} else {
		%>
				<li><p>등록된 자주 묻는 질문이 없습니다.</p></li>
		<%
			}
		%>
			</ul>
		</div>
		<div class="m_boardC">
			<h2><i class="ph-bold ph-list-bullets"></i> <span>진행중인 사건 목록</span></h2>
			<ul>
		<%
			if (list2.size() > 0) {
				for(int i=0; i<list2.size(); i++) {
					HashMap map = (HashMap) list2.get(i);
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
		%>
				<li class="sel" onclick="suitView('<%=LWS_MNG_NO%>', '<%=INST_MNG_NO%>');">
					<p><%=map.get("LWS_INCDNT_NM")==null?"":map.get("LWS_INCDNT_NM").toString()%></p>
					<span><%=map.get("RQST_RCPT_YMD")==null?"":map.get("RQST_RCPT_YMD").toString()%></span>
				</li>
		<%
				}
			} else {
		%>
				<li><p>진행중인 사건이 없습니다.</p><span>-</span></li>
		<%
			}
		%>
			</ul>
		</div>

<%
	}
%>
	</div>
</div>
<div class="innerW">
	<div class="scheduleW">
		
	</div>
</div>