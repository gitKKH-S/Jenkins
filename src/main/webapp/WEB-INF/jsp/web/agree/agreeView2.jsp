<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@	page import="java.util.*"%>
<%
	String searchForm  = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	HashMap agreeMap = request.getAttribute("agreeMap")==null?new HashMap():(HashMap)request.getAttribute("agreeMap");
	List agreeFileList = request.getAttribute("agreeRqstFile")==null?new ArrayList():(ArrayList)request.getAttribute("agreeRqstFile");
	List consultLawyerList = request.getAttribute("consultLawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("consultLawyerList");
	List opinionlist = request.getAttribute("opinionlist")==null?new ArrayList():(ArrayList)request.getAttribute("opinionlist");
	List opinionFilelist = request.getAttribute("opinionFilelist")==null?new ArrayList():(ArrayList)request.getAttribute("opinionFilelist");
	List satisList = request.getAttribute("satisList")==null?new ArrayList():(ArrayList)request.getAttribute("satisList");
	List agreeResultFile = request.getAttribute("agreeResultFile")==null?new ArrayList():(ArrayList)request.getAttribute("agreeResultFile");
	List reviewCommentFileList = request.getAttribute("reviewCommentFileList")==null?new ArrayList():(ArrayList)request.getAttribute("reviewCommentFileList");
	List relList = request.getAttribute("relList")==null?new ArrayList():(ArrayList)request.getAttribute("relList");
	String CVTN_MNG_NO = agreeMap.get("CVTN_MNG_NO")==null?"":agreeMap.get("CVTN_MNG_NO").toString();
	
	String CVTN_RQST_LAST_ATRZ_JBPS_SE = agreeMap.get("CVTN_RQST_LAST_ATRZ_JBPS_SE")==null?"":agreeMap.get("CVTN_RQST_LAST_ATRZ_JBPS_SE").toString();	// 최종결재자구분
	String CVTN_RQST_LAST_APRVR_NO = agreeMap.get("CVTN_RQST_LAST_APRVR_NO")==null?"":agreeMap.get("CVTN_RQST_LAST_APRVR_NO").toString();				// 최종결재자사번
	String CVTN_RQST_LAST_APRVR_NM = agreeMap.get("CVTN_RQST_LAST_APRVR_NM")==null?"":agreeMap.get("CVTN_RQST_LAST_APRVR_NM").toString();				// 최종결재자이름
	String INSD_OTSD_TASK_SE = agreeMap.get("INSD_OTSD_TASK_SE")==null?"":agreeMap.get("INSD_OTSD_TASK_SE").toString();									// 내외부구분
	String CVTN_CTRT_TYPE_CD_NM = agreeMap.get("CVTN_CTRT_TYPE_CD_NM")==null?"":agreeMap.get("CVTN_CTRT_TYPE_CD_NM").toString();						// 협약유형
	String RLS_YN = agreeMap.get("RLS_YN")==null?"":agreeMap.get("RLS_YN").toString();																	// 공개여부
	String OTSD_RQST_RSN = agreeMap.get("OTSD_RQST_RSN")==null?"":agreeMap.get("OTSD_RQST_RSN").toString();												// 외부의뢰사유
	String EMRG_YN = agreeMap.get("EMRG_YN")==null?"":agreeMap.get("EMRG_YN").toString();																// 긴급여부
	String CVTN_SE = agreeMap.get("CVTN_SE")==null?"":agreeMap.get("CVTN_SE").toString();																// 협약구분(일반/국제)
	String PRGRS_STTS_SE_NM = agreeMap.get("PRGRS_STTS_SE_NM")==null?"":agreeMap.get("PRGRS_STTS_SE_NM").toString();									// 진행상태
	
	String AGRE_YN = agreeMap.get("AGRE_YN")==null?"":agreeMap.get("AGRE_YN").toString();																// 시의회동의여부
	String RFLT_YN_RSLT_REG_YN = agreeMap.get("RFLT_YN_RSLT_REG_YN")==null?"N":agreeMap.get("RFLT_YN_RSLT_REG_YN").toString();							// 반영여부결과등록여부
	
	String CVTN_RQST_EMP_NM  = agreeMap.get("CVTN_RQST_EMP_NM")==null?"":agreeMap.get("CVTN_RQST_EMP_NM").toString();
	String CVTN_RQST_EMP_NO  = agreeMap.get("CVTN_RQST_EMP_NO")==null?"":agreeMap.get("CVTN_RQST_EMP_NO").toString();
	String CVTN_RQST_DEPT_NM = agreeMap.get("CVTN_RQST_DEPT_NM")==null?"":agreeMap.get("CVTN_RQST_DEPT_NM").toString();
	String CVTN_RQST_DEPT_NO = agreeMap.get("CVTN_RQST_DEPT_NO")==null?"":agreeMap.get("CVTN_RQST_DEPT_NO").toString();
	String CVTN_RQST_REG_YMD = agreeMap.get("CVTN_RQST_REG_YMD")==null?"":agreeMap.get("CVTN_RQST_REG_YMD").toString();
	
	String DGSTFN_RSPNS_YN = agreeMap.get("DGSTFN_RSPNS_YN")==null?"":agreeMap.get("DGSTFN_RSPNS_YN").toString();

	String CVTN_ANS_RVW_OPNN_CN = agreeMap.get("CVTN_ANS_RVW_OPNN_CN")==null?"":agreeMap.get("CVTN_ANS_RVW_OPNN_CN").toString();
	String CVTN_TKCG_EMP_NO = agreeMap.get("CVTN_TKCG_EMP_NO")==null?"":agreeMap.get("CVTN_TKCG_EMP_NO").toString();
	
	String CVTN_RQST_YMD  = agreeMap.get("CVTN_RQST_YMD")==null?"":agreeMap.get("CVTN_RQST_YMD").toString();
	String CVTN_RCPT_YMD  = agreeMap.get("CVTN_RCPT_YMD")==null?"":agreeMap.get("CVTN_RCPT_YMD").toString();
	String CVTN_RPLY_YMD  = agreeMap.get("CVTN_RPLY_YMD")==null?"":agreeMap.get("CVTN_RPLY_YMD").toString();
	String CVTN_TKCG_EMP_NM  = agreeMap.get("CVTN_TKCG_EMP_NM")==null?"":agreeMap.get("CVTN_TKCG_EMP_NM").toString();

	String CVTN_RQST_DH_EMP_NO = agreeMap.get("CVTN_RQST_DH_EMP_NO")==null?"":agreeMap.get("CVTN_RQST_DH_EMP_NO").toString();
	String CVTN_RQST_DH_NM = agreeMap.get("CVTN_RQST_DH_NM")==null?"":agreeMap.get("CVTN_RQST_DH_NM").toString();
	String CVTN_RQST_DH_JBPS_NM = agreeMap.get("CVTN_RQST_DH_JBPS_NM")==null?"":agreeMap.get("CVTN_RQST_DH_JBPS_NM").toString();
	String CVTN_RQST_DEPT_TMLDR_JBPS_NM = agreeMap.get("CVTN_RQST_DEPT_TMLDR_JBPS_NM")==null?"":agreeMap.get("CVTN_RQST_DEPT_TMLDR_JBPS_NM").toString();
	
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/plugin/jquery.number.js"></script>
<style>
	.relDiv:hover{
		cursor:pointer;
		text-decoration:underline;
	}
</style>
<script>
	var INSD_OTSD_TASK_SE = "<%=INSD_OTSD_TASK_SE%>";
	var CVTN_MNG_NO = "<%=CVTN_MNG_NO%>";
	var CVTN_CTRT_TYPE_CD_NM = "<%=CVTN_CTRT_TYPE_CD_NM%>";
	
	$(document).ready(function(){
		
	});
	
	function agreeEdit() {
		document.detailFrm.action = "<%=CONTEXTPATH%>/web/agree/agreeWritePage.do";
		document.detailFrm.submit();
	}
	
	function viewReload() {
		document.detailFrm.action = "<%=CONTEXTPATH%>/web/agree/agreeView.do";
		document.detailFrm.submit();
	}
	
	function agreeList() {
		document.detailFrm.action = "<%=CONTEXTPATH%>/web/agree/goAgreeList.do";
		document.detailFrm.submit();
	}
	
	function agreeDelete() {
		if(confirm("협약 정보를 삭제하면 복구할 수 없습니다.\n협약 정보를 삭제하시겠습니까?")) {
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/agree/agreeDelete.do",
				data:{
					CVTN_MNG_NO : CVTN_MNG_NO
				},
				dataType:"json",
				async:false,
				success:function(result){
					alert("처리가 완료되었습니다.");
					agreeList();
				}
			});
		}
	}
	
	function agreeStateChange(sta) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/agree/updateAgreeState.do",
			data:{
				CVTN_MNG_NO : CVTN_MNG_NO,
				PRGRS_STTS_SE_NM : sta
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("처리가 완료되었습니다.");
				viewReload();
			}
		});
	}
	
	function setAdmChgOpenyn(yn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/agree/updateAgreeOpenyn.do",
			data:{
				CVTN_MNG_NO : CVTN_MNG_NO,
				openyn : yn
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("처리가 완료되었습니다.");
				viewReload();
			}
		});
	}
	
	function setInoutChg(gbn) {
		if (gbn == "edit") {
			// 변경항목 활성화
			$("#inoutView").css("display", "none");
			$("#inoutEdit").css("display", "");
		} else {
			// 변경내용 저장
			if (confirm("변경하시겠습니까?")) {
				var inout = $('input[name="INSD_OTSD_TASK_SE"]:checked').val();
				$.ajax({
					type:"POST",
					url:"${pageContext.request.contextPath}/web/agree/updateAgreeInout.do",
					data:{
						CVTN_MNG_NO : CVTN_MNG_NO,
						inout : inout
					},
					dataType:"json",
					async:false,
					success:function(result){
						alert("처리가 완료되었습니다.");
						viewReload();
					}
				});
			} else {
				viewReload();
			}
		}
	}
	
	function selectAgreeEmp() {
		var cw=800;
		var ch=400;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/selectAgreeEmp.do");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"edit"}));
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:CVTN_MNG_NO}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function selectAgreeRvwTkcg() {
		var cw=1200;
		var ch=830;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/selectAgreeRvwPicPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO",        value:CVTN_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INSD_OTSD_TASK_SE",  value:INSD_OTSD_TASK_SE}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function AgreeAnswer(RVW_OPNN_MNG_NO) {
		var cw=1000;
		var ch=590;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/agreeAnswerWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:CVTN_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INSD_OTSD_TASK_SE",  value:INSD_OTSD_TASK_SE}));
		newForm.append($("<input/>", {type:"hidden", name:"RVW_OPNN_MNG_NO",    value:RVW_OPNN_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_CTRT_TYPE_CD_NM",    value:CVTN_CTRT_TYPE_CD_NM}));
//		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function agreeAnswerDelete(getChckid, getConsultLawyerid) {
		var confirmMsg = "답변을 삭제 하시겠습니까?";
		if (confirm(confirmMsg)) {
			$.ajax({
				url: "${pageContext.request.contextPath}/web/agree/deleteAnswer.do",
				data: {
					"CVTN_MNG_NO": $("#CVTN_MNG_NO").val(),
					"RVW_OPNN_MNG_NO": getChckid,
					"CONSULTLAWYERID" : getConsultLawyerid
				},
				dataType: "json",
				method: "post",
				error: function(jqXHR, textStatus, errorThrown) {
					console.log("ERROR - \n" + errorThrown);
					alert("처리 중 오류가 발생하였습니다.");
				},
				success: function(result) {
					alert("정상 처리 되었습니다.");
					viewReload();
				}
			});
		}
	}
	
	// 자문 답변완료 처리시 검토의견완료여부 컬럼 Y값으로 얻데이트
	function setAnsResult(getChckid) {
		$.ajax({
			type:"POST",
			url : "${pageContext.request.contextPath}/web/agree/answerResultSave.do",
			data : {
				"RVW_OPNN_MNG_NO" : getChckid,
				"ansresult" : 'Y',
				"CVTN_MNG_NO" : CVTN_MNG_NO,
				INSD_OTSD_TASK_SE:INSD_OTSD_TASK_SE
			},
			dataType: "json",
			async: false,
			success : function(result){
				alert("답변 결과가 변경되었습니다.");
				viewReload();
			}
		});
	}
	
	
	
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/resources/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'CVTN_MEMO_MNG_NO'},	//자문메모관리번호
			{name:'CVTN_MNG_NO'},		//자문관리번호
			{name:'MEMO_TTL'},			//메모제목
			{name:'MEMO_CN'},			//메모내용
			{name:'DEL_YN'},			//삭제여부
			{name:'WRTR_EMP_NM'},		//작성직원명
			{name:'WRTR_EMP_NO'},		//작성직원번호
			{name:'WRT_YMD'},			//작성일자
			{name:'WRT_DEPT_NM'},		//작성부서명
			{name:'WRT_DEPT_NO'}		//작성부서번호
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/agree/selectMemoList.do"
			}),
			remoteSort:true,
			pagesize:$("#pagesize").val(),
			listeners:{
				load:function(store, records, success) {
					$("#gcnt").text(store.getTotalCount());
					$("#gcnt").number(true);
				}
			},
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'CVTN_MEMO_MNG_NO'
			}, myRecordObj)
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>자문메모ID</b>",     dataIndex:'CVTN_MEMO_MNG_NO', align:'left', hidden:true},
				{header:"<b>자문ID</b>",         dataIndex:'CVTN_MNG_NO',      align:'left', hidden:true},
				{header:"<b>제목</b>",           dataIndex:'MEMO_TTL',         align:'left'},
				{header:"<b>내용</b>",           dataIndex:'MEMO_CN',          align:'left'},
				{header:"<b>작성자</b>",         dataIndex:'WRTR_EMP_NM',      align:'center'},
				{header:"<b>작성자사번</b>",     dataIndex:'WRTR_EMP_NO',      align:'left', hidden:true},
				{header:"<b>작성자부서코드</b>", dataIndex:'WRT_DEPT_NO',      align:'left', hidden:true},
				{header:"<b>작성자부서명</b>",   dataIndex:'WRT_DEPT_NM',      align:'center'},
				{header:"<b>작성일</b>",         dataIndex:'WRT_YMD',          align:'center'}
			]
		});
		
		var grid = new Ext.grid.GridPanel({
			id:ids,
			renderTo:'consultProgGrid',
			store:gridStore,
			width:'100%',
			height:200,
			autoWidth:true,
			//autoHeight:true,
			overflowY:'scroll',
			autoScroll:true, 
			remoteSort:true,
			cm:cmm,
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows:false,
			viewConfig:{
				forceFit:true,
				enableTextSelection:true,
				emptyText : '<img src="${pageContext.request.contextPath}/resources/images/gallery_no_data.gif">'
			},
			iconCls:'icon_perlist',
			listeners:{
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var obj = gridStore.baseParams;
					
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					
					var CVTN_MEMO_MNG_NO = histData.get("CVTN_MEMO_MNG_NO");
					var CVTN_MNG_NO = histData.get("CVTN_MNG_NO");
					
					goMemoView(CVTN_MEMO_MNG_NO, CVTN_MNG_NO);
				},
				contextmenu:function(e){
					e.preventDefault();
				},
				cellcontextmenu:function(grid, idx, cIdx, e){
					e.preventDefault();
				}
			}
		});
		
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				CVTN_MNG_NO : CVTN_MNG_NO
			}
		});
		
		gridStore.load({
			params : {
				CVTN_MNG_NO : CVTN_MNG_NO
			}
		});
	});
	
	//자문 메모 등록 팝업 호출
	function memoWrite(CVTN_MEMO_MNG_NO) {
		var cw=800;
		var ch=600;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/agreeMemoWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MEMO_MNG_NO", value:CVTN_MEMO_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:CVTN_MNG_NO}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 자문 메모 상세 및 관리 화면 호출
	function goMemoView(CVTN_MEMO_MNG_NO) {
		var cw=800;
		var ch=660;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/agreeMemoViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MEMO_MNG_NO", value:CVTN_MEMO_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:CVTN_MNG_NO}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function satisfactionPop(gbn) {
		var cw=1200;
		var ch=860;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","satiEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "satiEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/caseSatisWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:gbn}));
		newForm.append($("<input/>", {type:"hidden", name:"TRGT_PST_MNG_NO", value:"<%=CVTN_MNG_NO%>"}));
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:"<%=CVTN_MNG_NO%>"}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	//만족도평가내역 보기/숨기기
	var slToggle = 0;
	function satisListToggle() {
		if (slToggle == 0) {
			slToggle = 1;
			$("#satisList").css("display", "block");
			$( "#btnSatisListView" ).text( "만족도평가내역  ▲" );
		} else {
			slToggle = 0;
			$("#satisList").css("display", "none");
			$( "#btnSatisListView" ).text( "만족도평가내역  ▼" );
		}
	}
	
	function agreeResult() {
		var cw=900;
		var ch=560;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","satiEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "satiEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/agreeResultWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:"<%=CVTN_MNG_NO%>"}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	

	function setCostInfo(costid, RVW_TKCG_EMP_NO) {
		$.ajax({
			type:"POST",
			url : "${pageContext.request.contextPath}/web/agree/setCostInfo.do",
			data : {
				CVTN_CST_MNG_NO : costid,
				RVW_TKCG_EMP_NO : RVW_TKCG_EMP_NO,
				CST_PRGRS_STTS_SE : $("#CST_PRGRS_STTS_SE_"+costid).val(),
				CST_APRV_YMD : $("#CST_APRV_YMD_"+costid).val(),
				CST_GIVE_YMD : $("#CST_GIVE_YMD_"+costid).val()
			},
			dataType: "json",
			async: false,
			success : function(result){
				alert("자문료 정보가 저장되었습니다.");
				viewReload();
			}
		});
	}
	
	//협약 답변 검토 의견 등록 팝업 호출
	function agreeReviewComment(checkVal) {
		
		var cw=800;
		var ch=600;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/agreeReviewCommentWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:CVTN_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"checkVal",    value:checkVal}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 협약 답변  검토 의견 삭제
	function agreeReviewCommentDelete() {
		var confirmMsg = "협약 답변 검토 의견 정보를 삭제 하시겠습니까?";
		
		if (confirm(confirmMsg)) {
			$.ajax({
				url: "${pageContext.request.contextPath}/web/agree/agreeReviewCommentDelete.do",
				data: {
					"CVTN_MNG_NO": CVTN_MNG_NO,
					"FILE_SE_NM" : "ANSWERCOMMENT"
				},
				dataType: "json",
				method: "post",
				error: function(jqXHR, textStatus, errorThrown) {
					console.log("ERROR - \n" + errorThrown);
					alert("처리 중 오류가 발생하였습니다.");
				},
				success: function(result) {
					alert("정상 처리 되었습니다.");
					viewReload();
				}
			});
		}
	}
	
	function makeDoc(writegbn) {
		var urlInfo = '';
		var path = '';
		if(writegbn == '1'){
			urlInfo = "SaveContentDoc.do";
			path = 'doctype';
		}else{
			urlInfo = "UpdateContentDoc.do";
			path = 'agree';
		}
		
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/web/goMakeGian.do",
			data : {
				CVTN_MNG_NO:CVTN_MNG_NO,
				docgbn:'AGREE',
				gbn:'agree',
				agreeGbn:'VIEW2',
				DOC_SE:'VIEW2',
				writegbn:writegbn
			},
			datatype: "json",
			error: function(){},
			success:function(data){
				data = Ext.util.JSON.decode(data);
				
				var fileid = data.fnm.split(",");
				
				var obj = new HashMap();
				obj.put("write",      writegbn);
				obj.put("file",       URLINFO + "/dataFile/"+path+"/"+fileid[0]);
				obj.put("gianurl",    "/dll/SaveContentDoc.do");
				obj.put("saveurl",    URLINFO + "/dll/"+urlInfo);
				obj.put("AutoReport", data.id);
				chkSetUp(makeDocXML(obj));
				
				Ext.MessageBox.show({
					title : "알림",
					msg : "<span id=\"msgTxt\">문서를 서버에 저장한 후 확인 버튼을 클릭하세요.<br/>※ 미리 누르면 문서가 저장되지 않습니다.</span>",
					icon : Ext.MessageBox.WARNING,
					buttons:Ext.MessageBox.OK,
					width:410,
					fn:function(btn){
						if(btn == "ok"){
							viewReload();
						}
					}
				});
			}
		});
	}

	function goSchCasePop(){
		var cw=1200;
		var ch=770;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","CaseSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "CaseSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseSearchPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"PK", value:CVTN_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"schGbn", value:'A'}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goRelDocView(gbn, relpk) {
		if (gbn == "S") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "calInfo");
			newForm.attr("action", CONTEXTPATH+"/web/suit/caseViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:relpk}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "C") {
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
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "calInfo");
			newForm.attr("action", CONTEXTPATH+"/web/consult/consultViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"consultid", value:relpk}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "A") {
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
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "calInfo");
			newForm.attr("action", CONTEXTPATH+"/web/agree/agreeViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:relpk}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	}
	
	function agreeStateChange2(sta) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/agree/updateAgreeState2.do",
			data:{
				CVTN_MNG_NO : CVTN_MNG_NO,
				PRGRS_STTS_SE_NM : sta
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("처리가 완료되었습니다.");
				viewReload();
			}
		});
	}
	
	// 의뢰자 변경 팝업 호출
	function cvtn_rqst_chang(cvtn_rqst_emp_no) {
		
		var cw=1000;
		var ch=590;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","rqstChang",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "rqstChang");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/agree/agreeRqstChangWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:CVTN_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INSD_OTSD_TASK_SE",  value:INSD_OTSD_TASK_SE}));
		newForm.append($("<input/>", {type:"hidden", name:"CVTN_RQST_EMP_NO",    value:cvtn_rqst_emp_no}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function sendSatisAlert() {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/agree/sendSatisAlert.do",
			data:{
				CVTN_MNG_NO : CVTN_MNG_NO,
				CVTN_RQST_EMP_NO : "<%=CVTN_RQST_EMP_NO%>",
				CVTN_RQST_EMP_NM : "<%=CVTN_RQST_EMP_NM%>"
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("요청이 전송되었습니다.");
				viewReload();
			}
		});
	}
	

	function goEditKeyword(gbn) {
		if (gbn == "edit") {
			$("#viewDiv").hide();
			$("#editDiv").show();
		} else {
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/agree/updateKeyword.do",
				data:{
					CVTN_MNG_NO : CVTN_MNG_NO,
					PRVT_SRCH_KYWD_CN : $("#PRVT_SRCH_KYWD_CN").val()
				},
				dataType:"json",
				async:false,
				success:function(result){
					alert("검색 키워드가 변경되었습니다.");
					viewReload();
					//$("#viewDiv").show();
					//$("#editDiv").hide();
				}
			});
			
		}
	}
</script>

<form name="detailFrm" id="detailFrm" method="post">
	<input type="hidden" name="searchForm"        id="searchForm"        value="<%=searchForm%>"/>
	<input type="hidden" name="WRTR_EMP_NO"       id="WRTR_EMP_NO"       value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"       id="WRTR_EMP_NM"       value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"       id="WRT_DEPT_NO"       value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"       id="WRT_DEPT_NM"       value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="MENU_MNG_NO"       id="MENU_MNG_NO"       value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="CVTN_MNG_NO"       id="CVTN_MNG_NO"       value="<%=CVTN_MNG_NO%>"/>
	<input type="hidden" name="INSD_OTSD_TASK_SE" id="INSD_OTSD_TASK_SE" value="<%=INSD_OTSD_TASK_SE%>"/>
</form>
<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">
		<%
			String docNo = agreeMap.get("CVTN_DOC_NO")==null?"":agreeMap.get("CVTN_DOC_NO").toString();
			if("국제".equals(CVTN_SE) && !docNo.equals("")) {
				docNo = docNo + "("+(agreeMap.get("CVTN_INTL_DOC_NO")==null?"":agreeMap.get("CVTN_INTL_DOC_NO").toString())+")";
			}
		%>
				(<%=docNo%>)&nbsp;
				<%=agreeMap.get("CVTN_TTL")==null?"":agreeMap.get("CVTN_TTL").toString()%>
			</strong>
		</div>
	</div>
	<div class="subBtnW side">
		<div class="subBtnC right" id="test">
<%
// 				out.println("<a href=\"#none\" class=\"sBtn type1\" id='gianView' onclick=\"showGianList('AGREE', 'app', '"+CVTN_MNG_NO+"', 'agreeGianTable');\">결재내역  ▼</a>");
// 				out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"gianStart('AGREE', 'app', '"+CVTN_MNG_NO+"');\">결재</a>");
			
			if("작성중".equals(PRGRS_STTS_SE_NM)) {
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"makeDoc('1');\">의뢰서 생성</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('접수대기');\">접수요청</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeEdit();\">수정</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeDelete();\">삭제</a>");
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 자문팀 권한(접수? 권한?)
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"makeDoc('1');\">의뢰서 생성</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('접수대기');\">접수요청</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeEdit();\">수정</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeDelete();\">삭제</a>");
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			} else if("접수대기".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('접수');\">접수</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeEdit();\">수정</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('작성중');\">접수취소</a>");
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('접수');\">접수</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeEdit();\">수정</a>");
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 자문팀 권한(접수? 권한?)
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('접수');\">접수</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeEdit();\">수정</a>");
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('작성중');\">접수취소</a>");
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('작성중');\">접수취소</a>");
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			} else if("취소요청".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('철회');\">접수취소승인</a>");
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('철회');\">접수취소승인</a>");
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 자문팀 권한(접수? 권한?)
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('철회');\">접수취소승인</a>");
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('철회');\">접수취소승인</a>");
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			} else if("철회".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
				}
			} else if("접수".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectAgreeEmp();\">협약팀담당자지정</a>");
					if("O".equals(INSD_OTSD_TASK_SE)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectAgreeRvwTkcg();\">자문답변자지정</a>");
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('외부검토중');\">자문답변자지정완료</a>");
					}
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('취소요청');\">접수취소요청</a>");
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectAgreeEmp();\">협약팀담당자지정</a>");
					if("O".equals(INSD_OTSD_TASK_SE)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectAgreeRvwTkcg();\">자문답변자지정</a>");
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('외부검토중');\">자문답변자지정완료</a>");
					}
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 협약팀 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectAgreeEmp();\">협약팀담당자지정</a>");
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('취소요청');\">접수취소요청</a>");
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('취소요청');\">접수취소요청</a>");
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			} else if("내부검토중".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					if(opinionlist.size() < consultLawyerList.size()) {
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"AgreeAnswer('');\">답변등록</a>");
					}
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 협약팀 권한(접수? 권한?)
					if(opinionlist.size() < consultLawyerList.size()) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"AgreeAnswer('');\">답변등록</a>");
					}
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
					if(opinionlist.size() < consultLawyerList.size()) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"AgreeAnswer('');\">답변등록</a>");
					}
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			} else if("외부검토중".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					if(opinionlist.size() < consultLawyerList.size()) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"AgreeAnswer('');\">답변등록</a>");
					}
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 자문팀 권한(접수? 권한?)
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			} else if("답변완료".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					if("".equals(CVTN_ANS_RVW_OPNN_CN)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeReviewComment('');\">답변 검토 의견 등록</a>");
					}
					if("O".equals(INSD_OTSD_TASK_SE)){
						if("".equals(CVTN_ANS_RVW_OPNN_CN)){
							out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultReviewComment('');\">답변 검토 의견 등록</a>");
						} else{
							out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('팀장결재중');\">팀장결재요청</a>");
						}
					}
					if(opinionlist.size() < consultLawyerList.size()) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultAnswer('');\">답변등록</a>");
					}
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 자문팀 권한(접수? 권한?)
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
					if("".equals(CVTN_ANS_RVW_OPNN_CN)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeReviewComment('');\">답변 검토 의견 등록</a>");
					}
					if("O".equals(INSD_OTSD_TASK_SE)){
						if("".equals(CVTN_ANS_RVW_OPNN_CN)){
							out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultReviewComment('');\">답변 검토 의견 등록</a>");
						} else{
							out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('팀장결재중');\">팀장결재요청</a>");
						}
					}
					if(opinionlist.size() < consultLawyerList.size()) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultAnswer('');\">답변등록</a>");
					}
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"gianLayer('AGREE', 'app', '"+CVTN_MNG_NO+"');\">결재요청</a>");
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
				
			} else if("팀장결재중".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('과장결재중');\">승인</a>");
					if("O".equals(INSD_OTSD_TASK_SE)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('외부검토중');\">반려</a>");
					} else{
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('내부검토중');\">반려</a>");
					}
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('과장결재중');\">승인</a>");
					if("O".equals(INSD_OTSD_TASK_SE)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('외부검토중');\">반려</a>");
					} else{
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('내부검토중');\">반려</a>");
					}
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 자문팀 권한(접수? 권한?)
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			} else if("과장결재중".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('만족도평가필요');\">승인</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('완료');\">승인</a>");
					if("O".equals(INSD_OTSD_TASK_SE)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('외부검토중');\">반려</a>");
					} else{
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('내부검토중');\">반려</a>");
					}
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('만족도평가필요');\">승인</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('완료');\">승인</a>");
					if("O".equals(INSD_OTSD_TASK_SE)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('외부검토중');\">반려</a>");
					} else{
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeStateChange('내부검토중');\">반려</a>");
					}
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 협약팀 권한(접수? 권한?)
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			} else if("만족도평가필요".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"satisfactionPop('N');\">만족도평가</a>");
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 협약팀 권한(접수? 권한?)
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"satisfactionPop('N');\">만족도평가</a>");
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			} else if("완료".equals(PRGRS_STTS_SE_NM)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					if("Y".equals(AGRE_YN) && "N".equals(RFLT_YN_RSLT_REG_YN)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeResult();\">반영여부결과등록</a>");
					} else if("Y".equals(AGRE_YN) && "Y".equals(RFLT_YN_RSLT_REG_YN)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeResult();\">반영여부결과수정</a>");
					}
					
					if ("N".equals(DGSTFN_RSPNS_YN) && "O".equals(INSD_OTSD_TASK_SE)) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"sendSatisAlert();\">만족도평가요청</a>");
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"satisfactionPop('N');\">만족도평가</a>");
					}
					
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeDelete();\">삭제</a>");
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
					if ("N".equals(DGSTFN_RSPNS_YN) && "O".equals(INSD_OTSD_TASK_SE)) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"sendSatisAlert();\">만족도평가요청</a>");
					}
				} else if(GRPCD.indexOf("R")>-1){ // 협약팀장 권한
					if ("N".equals(DGSTFN_RSPNS_YN) && "O".equals(INSD_OTSD_TASK_SE)) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"sendSatisAlert();\">만족도평가요청</a>");
					}
				} else if(GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){ // 자문팀 권한(접수? 권한?)
					if ("N".equals(DGSTFN_RSPNS_YN) && "O".equals(INSD_OTSD_TASK_SE)) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"sendSatisAlert();\">만족도평가요청</a>");
					}
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeDelete();\">삭제</a>");
				} else if(CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 협약팀 담당자
					if ("N".equals(DGSTFN_RSPNS_YN) && "O".equals(INSD_OTSD_TASK_SE)) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"sendSatisAlert();\">만족도평가요청</a>");
					}
				} else if(CVTN_RQST_LAST_APRVR_NO.equals(WRTR_EMP_NO)){// 의뢰부서 결재 권한 팀장
				} else if(CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)){// 의뢰자
					if("Y".equals(AGRE_YN) && "N".equals(RFLT_YN_RSLT_REG_YN)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeResult();\">반영여부결과등록</a>");
					} else if("Y".equals(AGRE_YN) && "Y".equals(RFLT_YN_RSLT_REG_YN)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeResult();\">반영여부결과수정</a>");
					}
					if ("N".equals(DGSTFN_RSPNS_YN) && "O".equals(INSD_OTSD_TASK_SE)) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"satisfactionPop('N');\">만족도평가</a>");
					}
				} else if(CVTN_RQST_DEPT_NO.equals(WRT_DEPT_NO)){// 의뢰부서
				}
			}
			if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("R")>-1 || CVTN_TKCG_EMP_NO.equals(WRTR_EMP_NO)){ // 관리자 권한, 팀장권한
				out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"goSchCasePop();\">관련문서 관리</a>");
				if(!"작성중".equals(PRGRS_STTS_SE_NM) && !"접수대기".equals(PRGRS_STTS_SE_NM)){
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"cvtn_rqst_chang('"+CVTN_RQST_EMP_NO+"');\">의뢰자 변경</a>");
				}
			}
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeList();\"><i class=\"fa-solid fa-list\"></i> 목록</a>");
%>
		</div>
	</div>
	<div class="hkkresult">
		<hr class="margin40">
		<strong class="subST">기타계약 협약심사 내용</strong>
<%
	if((GRPCD.indexOf("Y")>-1)){
%>
		<div class="subBtnC right" style='font-size:13px;'>
			진행상태 변경	:
			<select id="chgState" style="background:#f1f4f7;line-height:40px; margin-right: 15px;" onchange="agreeStateChange2(this.value);">
				<option value="작성중"         <%if("작성중".equals(PRGRS_STTS_SE_NM))         out.println("selected");%>>작성중</option>
				<option value="내부결재중"     <%if("내부결재중".equals(PRGRS_STTS_SE_NM))     out.println("selected");%>>내부결재중</option>
				<option value="접수대기"       <%if("접수대기".equals(PRGRS_STTS_SE_NM))       out.println("selected");%>>접수대기</option>
				<option value="취소요청"       <%if("취소요청".equals(PRGRS_STTS_SE_NM))       out.println("selected");%>>취소요청</option>
				<option value="자문취소"       <%if("자문취소".equals(PRGRS_STTS_SE_NM))       out.println("selected");%>>자문취소</option>
				<option value="접수"           <%if("접수".equals(PRGRS_STTS_SE_NM))           out.println("selected");%>>접수</option>
				<option value="내부검토중"         <%if("내부검토중".equals(PRGRS_STTS_SE_NM))         out.println("selected");%>>내부검토중</option>
		<%
		if("O".equals(INSD_OTSD_TASK_SE)){
		%>
				<option value="외부검토중"         <%if("외부검토중".equals(PRGRS_STTS_SE_NM))         out.println("selected");%>>외부검토중</option>
				<option value="답변완료"       <%if("답변완료".equals(PRGRS_STTS_SE_NM))       out.println("selected");%>>답변완료</option>
		<%
		}
		%>
				<option value="팀장결재중"   <%if("팀장결재중".equals(PRGRS_STTS_SE_NM))   out.println("selected");%>>팀장결재중</option>
				<option value="과장결재중"   <%if("과장결재중".equals(PRGRS_STTS_SE_NM))   out.println("selected");%>>과장결재중</option>
				<option value="만족도평가필요" <%if("만족도평가필요".equals(PRGRS_STTS_SE_NM)) out.println("selected");%>>만족도평가필요</option>
				<option value="완료"           <%if("완료".equals(PRGRS_STTS_SE_NM))           out.println("selected");%>>완료</option>
			</select>
			
			공개/비공개 설정	: 
			<select id="openyn" style="background:#f1f4f7;line-height:40px;" onchange="setAdmChgOpenyn(this.value);">
				<option value="Y" <%if("Y".equals(RLS_YN) || RLS_YN.equals("")) out.println("selected");%>>공개</option>
				<option value="N" <%if("N".equals(RLS_YN)) out.println("selected");%>>비공개</option>
			</select>
		</div>
<%
	}
%>
		<div class="innerB" >
			<table class="infoTable write" style="width: 100%">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>의뢰자</th>
					<td>
						<%=CVTN_RQST_EMP_NM%>
					</td>
					<th>의뢰부서</th>
					<td>
						<%=CVTN_RQST_DEPT_NM%>
					</td>
					<th>의뢰등록일</th>
					<td>
						<%=CVTN_RQST_REG_YMD%>
					</td>
				</tr>
				<tr>
					<th>의뢰부서 최종결재자</th>
					<td>
						<%=CVTN_RQST_LAST_ATRZ_JBPS_SE%>
					</td>
					<th>의뢰부서 과장</th>
					<td>
						<%=CVTN_RQST_DH_NM %>
					</td>
					<th>과장 직위명</th>
					<td>
						<%=CVTN_RQST_DH_JBPS_NM %>
					</td>
				</tr>
				<tr>
					<th>구분</th>
					<td>
						<%=CVTN_SE%>
					</td>
					<th>의뢰부서 팀장</th>
					<td>
						<%=CVTN_RQST_LAST_APRVR_NM %>
					</td>
					<th>팀장 직위명</th>
					<td>
						<%=CVTN_RQST_DEPT_TMLDR_JBPS_NM %>
					</td>
				</tr>
			<%
			if((GRPCD.indexOf("Y")>-1||GRPCD.indexOf("G")>-1||GRPCD.indexOf("R")>-1||GRPCD.indexOf("A")>-1||GRPCD.indexOf("N")>-1)){
			%>	
				<tr>
					<th>접수요청일자</th>
					<td>
						<%=CVTN_RQST_YMD %>
					</td>
					<th>접수완료일자</th>
					<td>
						<%= CVTN_RCPT_YMD %>
					</td>
					
					<th>답변회신일자</th>
					<td>
						<%= CVTN_RPLY_YMD %>
					</td>
				</tr>
				<tr>
					<th>협약팀담당자</th>
					<td>
						<%= CVTN_TKCG_EMP_NM %>
						<%
						String chrg = CVTN_TKCG_EMP_NM;
						if("I".equals(INSD_OTSD_TASK_SE)){
							if(PRGRS_STTS_SE_NM.equals("접수") && (GRPCD.indexOf("Y")>-1 ||GRPCD.indexOf("R")>-1||GRPCD.indexOf("A")>-1||GRPCD.indexOf("N")>-1)) { // 내부일때는 접수상태에서만 자문팀 담당자 변경할 수 있게 해두신 이유 여줘보기
						%>
							<a href="#none" class="innerBtn" style="height:20px;line-height:20px;" onclick="selectAgreeEmp();">담당자변경</a>
						<%
							}
						} else {
							if(!PRGRS_STTS_SE_NM.equals("완료") && !chrg.equals("") && (GRPCD.indexOf("Y")>-1 ||GRPCD.indexOf("R")>-1||GRPCD.indexOf("A")>-1||GRPCD.indexOf("N")>-1)) {
								if(!"".equals(CVTN_TKCG_EMP_NO)) {
						%>
									<a href="#none" class="innerBtn" style="height:20px;line-height:20px;" onclick="selectAgreeEmp();">담당자변경</a>
						<%
								}
							}
						}
						%>
					</td>
					<th>
					</th>
					<td>
					</td>
					<th>
					</th>
					<td>
					</td>
				</tr>
				<!--나중에 외부일때만 보이게s -->
			<%
			}
			%>
				<tr>
					<th>공개여부</th>
					<td>
			<%
					if ("Y".equals(RLS_YN)) {
						out.println("공개");
					} else {
						out.println("비공개");
					}
			%>
					</td>
					<th>긴급여부</th>
					<td>
			<%
						if("N".equals(EMRG_YN)) {
							out.println("일반");
						} else if ("Y".equals(EMRG_YN)) {
							out.println("긴급");
						}
			%>
					</td>
					<th>내/외부 업무</th>
					<td>
			<%
					String INSD_OTSD_TASK_NM = "미정";
					if ("I".equals(INSD_OTSD_TASK_SE)) {
						INSD_OTSD_TASK_NM = "내부";
					} else if ("O".equals(INSD_OTSD_TASK_SE)) {
						INSD_OTSD_TASK_NM = "외부";
					}
					
					if ("접수".equals(PRGRS_STTS_SE_NM)) {
			%>
						<div id="inoutView">
							<%=INSD_OTSD_TASK_NM%>
							<a href="#none" class="innerBtn" style="height:20px; line-height:20px;" onclick="setInoutChg('edit');">변경</a>
						</div>
						<div id="inoutEdit" style="display:none;">
							<label><input type="radio" name="INSD_OTSD_TASK_SE" id="INSD_OTSD_TASK_SE" value="I" <%if(INSD_OTSD_TASK_SE.equals("I"))out.println("checked");%>>내부</label>&nbsp;
							<label><input type="radio" name="INSD_OTSD_TASK_SE" id="INSD_OTSD_TASK_SE" value="O" <%if(INSD_OTSD_TASK_SE.equals("O"))out.println("checked");%>>외부</label>
							<a href="#none" class="innerBtn" style="height:20px; line-height:20px;" onclick="setInoutChg('save');">저장</a>
						</div>
			<%
					} else {
			%>
						<%=INSD_OTSD_TASK_NM%>
			<%
					}
			%>
					</td>
				</tr>
			<%
					if ("Y".equals(EMRG_YN)) {
			%>
				<tr>
					<th>긴급의뢰사유</th>
					<td colspan="5">
						<%=agreeMap.get("EMRG_RQST_RSN")==null?"":agreeMap.get("EMRG_RQST_RSN").toString()%>
					</td>
			<%
						}
			%>
				</tr>
			<%
				if ("O".equals(INSD_OTSD_TASK_SE) && (CVTN_RQST_EMP_NO.equals(WRTR_EMP_NO)||(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1))) {
			%>
				<tr>
					<th>외부 의뢰 사유</th>
					<td>
						<%=OTSD_RQST_RSN%>
					</td>
					<th>제외 요청 법무법인명</th>
					<td colspan="3">
						<%=agreeMap.get("EXCL_DMND_JDAF_CORP_NM")==null?"":agreeMap.get("EXCL_DMND_JDAF_CORP_NM").toString()%>
					</td>
				</tr>
				<tr>
					<th>외부 변호사</th>
					<td colspan="5">
						<%
						if(consultLawyerList.size() > 0) {
							for(int i=0; i<consultLawyerList.size(); i++) {
								HashMap lawMap = (HashMap)consultLawyerList.get(i);
								
								String RCPT_YN = lawMap.get("RCPT_YN")==null?"":lawMap.get("RCPT_YN").toString();
						%>
						<div <%if("N".equals(RCPT_YN)){%>style="text-decoration:line-through;"<%} %>>
							<%=lawMap.get("JDAF_CORP_NM")==null?"":lawMap.get("JDAF_CORP_NM").toString()%> <%=lawMap.get("RVW_TKCG_EMP_NM")==null?"":lawMap.get("RVW_TKCG_EMP_NM").toString()%>
							<%
							if("N".equals(RCPT_YN)){
							%>
							(거절 사유 : <%=lawMap.get("RFSL_RSN")==null?"":lawMap.get("RFSL_RSN").toString().replaceAll("\n","<br/>") %>)
							<%
							}
							%>
						</div>
						<%
							}
						}
						%>
					</td>
				</tr>
			<%
				}
			%>
			<%
				if((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1)){
					String keyworkd = agreeMap.get("PRVT_SRCH_KYWD_CN")==null?"":agreeMap.get("PRVT_SRCH_KYWD_CN").toString();
			%>
				<tr>
					<th>관리자 검색 키워드</th>
					<td colspan="5">
						<div id="viewDiv">
							<%= keyworkd %>
							<a href="#none" class="innerBtn" onclick="goEditKeyword('edit');">수정</a>
						</div>
						<div id="editDiv" style="display:none;">
							<input type="text" id="PRVT_SRCH_KYWD_CN" name="PRVT_SRCH_KYWD_CN" value="<%=keyworkd%>">
							<a href="#none" class="innerBtn" onclick="goEditKeyword('save');">저장</a>
						</div>
					</td>
				</tr>
			<%
				}
			%>
				<tr>
					<th>협약건명</th>
					<td colspan="3">
						<%=agreeMap.get("CVTN_TTL")==null?"":agreeMap.get("CVTN_TTL").toString()%>
					</td>
					<th>협약체결예정일</th>
					<td>
						<%=agreeMap.get("CVTN_CNCLS_PRNMNT_YMD")==null?"":agreeMap.get("CVTN_CNCLS_PRNMNT_YMD").toString()%>
					</td>
				</tr>
				<tr>
					<th>의뢰 배경</th>
					<td colspan="5">
						<%=agreeMap.get("CVTN_RQST_CN")==null?"":agreeMap.get("CVTN_RQST_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>주요 심사요청사항</th>
					<td colspan="5">
						<%=agreeMap.get("CVTN_SRNG_DMND_CN")==null?"":agreeMap.get("CVTN_SRNG_DMND_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>비고 내용</th>
					<td colspan="5">
						<%=agreeMap.get("RMRK_CN")==null?"":agreeMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<%
				if(relList.size() > 0) {
				%>
				<tr>
					<th>관련문서</th>
					<td colspan="5">
				<%
					for(int i=0; i<relList.size(); i++) {
						HashMap relMap = (HashMap)relList.get(i);
						String DOC_SE = relMap.get("DOC_SE")==null?"":relMap.get("DOC_SE").toString();
						String DOC_SE_NM = relMap.get("DOC_SE_NM")==null?"":relMap.get("DOC_SE_NM").toString();
						String REL_DOC_MNG_NO = relMap.get("REL_DOC_MNG_NO")==null?"":relMap.get("REL_DOC_MNG_NO").toString();
				%>
						<div class="relDiv" onclick="goRelDocView('<%=DOC_SE%>', '<%=REL_DOC_MNG_NO%>');">[<%=DOC_SE_NM%>] <%=relMap.get("DOC_NM")==null?"":relMap.get("DOC_NM").toString()%></div>
				<%
					}
				%>
					</td>
				</tr>
				<%
				}
				%>
				<tr>
					<th>첨부파일</th>
					<td colspan="5">
				<%
					for(int f=0; f<agreeFileList.size(); f++) {
						HashMap file = (HashMap)agreeFileList.get(f);
				%>
						<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "AGREE")'><%=file.get("PHYS_FILE_NM").toString()%></div>
				<%
					}
				%>
					</td>
				</tr>
			</table>
		<%
			if("Y".equals(RFLT_YN_RSLT_REG_YN)) {
		%>
			<hr class="margin10">
			<table class="infoTable write" style="width: 100%">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>반영여부결과 등록자</th>
					<td>
						<%=agreeMap.get("RFLT_YN_RSLT_WRTR_EMP_NM")==null?"":agreeMap.get("RFLT_YN_RSLT_WRTR_EMP_NM").toString()%>
					</td>
					<th>반영여부결과 등록일</th>
					<td>
						<%=agreeMap.get("RFLT_YN_RSLT_REG_YMD")==null?"":agreeMap.get("RFLT_YN_RSLT_REG_YMD").toString()%>
					</td>
					<th colspan="2"></th>
				</tr>
				<tr>
					<th>반영여부 결과명</th>
					<td colspan="5">
						<%=agreeMap.get("RFLT_YN_RSLT_TTL")==null?"":agreeMap.get("RFLT_YN_RSLT_TTL").toString()%>
					</td>
				</tr>
				<tr>
					<th>반영여부 내용</th>
					<td colspan="5">
						<%=agreeMap.get("RFLT_YN_RSLT_CN")==null?"":agreeMap.get("RFLT_YN_RSLT_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td colspan="5">
				<%
					for(int f=0; f<agreeResultFile.size(); f++) {
						HashMap file = (HashMap)agreeResultFile.get(f);
				%>
						<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "AGREE")'><%=file.get("PHYS_FILE_NM").toString()%></div>
				<%
					}
				%>
					</td>
				</tr>
		<%
			}
		%>
			</table>
		</div>
	</div>
	<div id="agreeGianTable"></div>
	
	<hr class="margin40">
<%
	if ((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("G")>-1 || GRPCD.indexOf("R")>-1 || GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1 || WRTR_EMP_NO.equals(CVTN_RQST_EMP_NO) || WRTR_EMP_NO.equals(CVTN_TKCG_EMP_NO)) && (!PRGRS_STTS_SE_NM.equals("작성중") && !PRGRS_STTS_SE_NM.equals("접수대기") && !PRGRS_STTS_SE_NM.equals("취소요청"))) {
%>
	<strong class="subTT">협약 메모</strong>
	<hr class="margin10">
	<div class="innerB">
		<div id="consultProgGrid"></div>
		<div class="subBtnW side">
			<div class="subBtnC left" style="height:40px;">
				<a href="#none" class="sBtn type1" id="insertBtn" style="margin-top:3px;" onclick="memoWrite('0')">등록</a>
			</div>
		</div>
	</div>
<%
	}
		if(opinionlist.size()>0){
%>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="subTT">협약 답변</strong>
			</div>
		</div>
		<div class="innerB">
<%
		if(((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1) && !PRGRS_STTS_SE_NM.equals("완료")) || "완료".equals(PRGRS_STTS_SE_NM)){
			for(int i=0; i<opinionlist.size(); i++) {
				HashMap chckMap = (HashMap)opinionlist.get(i);
				
				String ansResult = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
				String ansChckid = chckMap.get("RVW_OPNN_MNG_NO")==null?"":chckMap.get("RVW_OPNN_MNG_NO").toString();
				String ansCont = chckMap.get("RVW_OPNN_CN")==null?"":chckMap.get("RVW_OPNN_CN").toString();
				String ansCont2 = chckMap.get("RMRK_CN")==null?"":chckMap.get("RMRK_CN").toString();
				String rvw_opnn_cmptn_yn = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
				
				String CST_PRGRS_STTS_SE = chckMap.get("CST_PRGRS_STTS_SE")==null?"R":chckMap.get("CST_PRGRS_STTS_SE").toString();
				String CVTN_CST_MNG_NO = chckMap.get("CVTN_CST_MNG_NO")==null?"":chckMap.get("CVTN_CST_MNG_NO").toString();
				String RVW_TKCG_EMP_NO = chckMap.get("RVW_TKCG_EMP_NO")==null?"":chckMap.get("RVW_TKCG_EMP_NO").toString();
%>
				<table class="infoTable write" style="width:100%">
					<colgroup>
						<col style="width:10%;">
						<col style="width:20%;">
						<col style="width:10%;">
						<col style="width:20%;">
						<col style="width:10%;">
						<col style="width:20%;">
					</colgroup>
					<tr>
						<th>자문인</th>
						<td><%=chckMap.get("RVW_TKCG_EMP_NM")==null?"":chckMap.get("RVW_TKCG_EMP_NM").toString()%></td>
						<th>답변등록일자</th>
						<td><%=chckMap.get("RVW_OPNN_REG_YMD")==null?"":chckMap.get("RVW_OPNN_REG_YMD").toString()%></td>
						<th>답변등록상태</th>
						<td>
						<%
							if ("N".equals(rvw_opnn_cmptn_yn)) {
								out.println("답변중");
							} else if ("Y".equals(rvw_opnn_cmptn_yn)) {
								out.println("답변완료");
							} else {
								out.println("미확인");
							}
						%>
						</td>
					</tr>
			<%
			if ("완료".equals(PRGRS_STTS_SE_NM) && !CVTN_CST_MNG_NO.equals("")) {
			%>
					<tr>
						<th>자문료</th>
						<td>
							<%=chckMap.get("CVTN_CST_AMT")==null?"":chckMap.get("CVTN_CST_AMT").toString()%>
						</td>
						<th>청구일자</th>
						<td>
							<%=chckMap.get("CST_CLM_YMD")==null?"":chckMap.get("CST_CLM_YMD").toString()%>
						</td>
						<th>계좌정보</th>
						<td>
							<%=chckMap.get("BACNT_INFO")==null?"":chckMap.get("BACNT_INFO").toString()%>
						</td>
					</tr>
			<%
				if(!CST_PRGRS_STTS_SE.equals("E")) {
			%>
					<tr>
						<th>비용진행상태</th>
						<td>
							<select name="CST_PRGRS_STTS_SE_<%=CVTN_CST_MNG_NO%>" id="CST_PRGRS_STTS_SE_<%=CVTN_CST_MNG_NO%>">
								<option value="R" <%if("R".equals(CST_PRGRS_STTS_SE)) out.println("selected");%>>검토중</option>
								<option value="X" <%if("X".equals(CST_PRGRS_STTS_SE)) out.println("selected");%>>보완요청</option>
								<option value="Z" <%if("Z".equals(CST_PRGRS_STTS_SE)) out.println("selected");%>>보완완료</option>
								<option value="A" <%if("A".equals(CST_PRGRS_STTS_SE)) out.println("selected");%>>비용승인</option>
								<option value="C" <%if("C".equals(CST_PRGRS_STTS_SE)) out.println("selected");%>>비용지급</option>
								<option value="E" <%if("E".equals(CST_PRGRS_STTS_SE)) out.println("selected");%>>완료</option>
							</select>
						</td>
						<th>승인일자</th>
						<td>
							<input type="text" class="datepick" id="CST_APRV_YMD_<%=CVTN_CST_MNG_NO%>" name="CST_APRV_YMD_<%=CVTN_CST_MNG_NO%>" style="width: 80px;" value="<%=chckMap.get("CST_APRV_YMD")==null?"":chckMap.get("CST_APRV_YMD").toString()%>">
						</td>
						<th>지급일자</th>
						<td>
							<input type="text" class="datepick" id="CST_GIVE_YMD_<%=CVTN_CST_MNG_NO%>" name="CST_GIVE_YMD_<%=CVTN_CST_MNG_NO%>" style="width: 80px;" value="<%=chckMap.get("CST_GIVE_YMD")==null?"":chckMap.get("CST_GIVE_YMD").toString()%>">
						</td>
					</tr>
			<%
				} else {
			%>
					<tr>
						<th>비용진행상태</th>
						<td>
							<%=chckMap.get("CST_PRGRS_STTS_NM")==null?"":chckMap.get("CST_PRGRS_STTS_NM").toString()%>
						</td>
						<th>승인일자</th>
						<td>
							<%=chckMap.get("CST_APRV_YMD")==null?"":chckMap.get("CST_APRV_YMD").toString()%>
						</td>
						<th>지급일자</th>
						<td>
							<%=chckMap.get("CST_GIVE_YMD")==null?"":chckMap.get("CST_GIVE_YMD").toString()%>
						</td>
					</tr>
			<%
				}
			} else {
			%>
					<tr>
						<td colspan="6">법무법인이 자문료 청구정보를 등록하지 않았습니다.</td>
					</tr>
			<%
			}
			%>
					<tr>
						<th>답변내용</th>
						<td colspan="5"><%=ansCont.replaceAll("\n","<br/>")%></td>
					</tr>
					<tr>
						<th>비고내용</th>
						<td colspan="5"><%=ansCont2.replaceAll("\n","<br/>")%></td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td colspan="5">
							<ul>
<%
								if(opinionFilelist.size() > 0 && opinionFilelist != null) {
									for(int f=0; f<opinionFilelist.size(); f++) {
										HashMap chckFile = (HashMap) opinionFilelist.get(f);
										String fileChckid = chckFile.get("TRGT_PST_MNG_NO")==null?"":chckFile.get("TRGT_PST_MNG_NO").toString();
										if (ansChckid.equals(fileChckid)) {
%>
								<li>
									<a href="#" onclick="downFile('<%=chckFile.get("DWNLD_FILE_NM") %>','<%=chckFile.get("SRVR_FILE_NM") %>','AGREE')"><%=chckFile.get("DWNLD_FILE_NM")%></a>
								</li>
<%
										}
									}
								}
%>
							</ul>
						</td>
					</tr>
				</table>
				<hr class="margin10">
				<div style="text-align:right;">
<%
				if(("내부검토중".equals(PRGRS_STTS_SE_NM) || "외부검토중".equals(PRGRS_STTS_SE_NM)) && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N")>-1)) {
					if(!"Y".equals(rvw_opnn_cmptn_yn)){
						if("I".equals(INSD_OTSD_TASK_SE)){
%>
							<a href="#none" class="sBtn type1" onclick="setAnsResult('<%=ansChckid%>');">팀장결재요청</a>
<%
						}else if("O".equals(INSD_OTSD_TASK_SE)){
%>
							<a href="#none" class="sBtn type1" onclick="setAnsResult('<%=ansChckid%>');">답변 완료</a>
<%
						}
					}
%>
					<a href="#none" class="sBtn type1" onclick="AgreeAnswer('<%=chckMap.get("RVW_OPNN_MNG_NO") %>');">답변 수정</a>
					<a href="#none" class="sBtn type1" onClick="agreeAnswerDelete('<%=chckMap.get("RVW_OPNN_MNG_NO") %>', '<%=chckMap.get("RVW_TKCG_MNG_NO")%>')">답변 삭제</a>
<%
				} else if ("완료".equals(PRGRS_STTS_SE_NM) && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N")>-1) && !CVTN_CST_MNG_NO.equals("") && !CST_PRGRS_STTS_SE.equals("E")) {
%>
					<a href="#none" class="sBtn type1" onclick="setCostInfo('<%=CVTN_CST_MNG_NO%>', '<%=RVW_TKCG_EMP_NO%>');">비용정보 저장</a>
<%
				}
%>
				</div>
				<hr class="margin20">
<%
			}
		} else {
%>
			<table class="infoTable write" style="width:100%">
				<colgroup>
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>의뢰하신 협약 의뢰를 처리중입니다.<br/><br/>완료 된 후 답변을 확인하세요.</th>
				</tr>
			</table>
<%
		}
%>
		</div>
<%
		}
%>


<%
		if((!"작성중".equals(PRGRS_STTS_SE_NM) && !"접수대기".equals(PRGRS_STTS_SE_NM) && !"접수".equals(PRGRS_STTS_SE_NM) && !"외부검토중".equals(PRGRS_STTS_SE_NM)) && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("G")>-1 || GRPCD.indexOf("R")>-1 || GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N") > -1)){
%>
		<hr class="margin10">
		<div class="innerB" id="resultState">
			<strong class="subST">협약 답변 검토 의견</strong>
			<table class="infoTable write">
				<colgroup>
					<col style="width:10%;">
					<col style="width:20%;">
					<col style="width:10%;">
					<col style="width:20%;">
					<col style="width:10%;">
					<col style="width:20%;">
				</colgroup>
				<tr>
					<th>검토 의견</th>
					<td colspan="5">
						<%= CVTN_ANS_RVW_OPNN_CN %>
					</td>
				</tr>
				<tr>
					<th>검토 의견 - 첨부파일</th>
					<td colspan="5">
						<ul class="fileList">
						<% if(reviewCommentFileList != null & reviewCommentFileList.size()>0){ 
							
							for(int i=0; i<reviewCommentFileList.size();i++){
								HashMap reviewCommentFile = (HashMap)reviewCommentFileList.get(i);
						%>
							<li>
								<a href="#" onclick="downFile('<%=reviewCommentFile.get("DWNLD_FILE_NM") %>','<%=reviewCommentFile.get("SRVR_FILE_NM") %>','CONSULT')">
									<%=reviewCommentFile.get("DWNLD_FILE_NM")%> (<%=reviewCommentFile.get("VIEW_SZ").toString()%>)
								</a>
							</li>
							<% } %>
						<% } %>
						</ul>
					</td>
				</tr>
			</table>
			<hr class="margin10">
			<div style="text-align:right;">
<%
			if(!"".equals(CVTN_ANS_RVW_OPNN_CN)){
%>
				<a href="#none" class="sBtn type1" onclick="agreeReviewComment('rcModi');">수정</a>
				<a href="#none" class="sBtn type1" onClick="agreeReviewCommentDelete()">삭제</a>
<%
			}
%>
			</div>
		</div>
<%
		}
%>

		<hr class="margin40">
		
		<%
		if (satisList.size() > 0) {
		%>
		<div id="satisList" style="display:none;">
			<div class="subBtnW side">
				<div class="subBtnC left">
					<strong class="subTT">만족도평가정보</strong>
				</div>
			</div>
			<div class="innerB" >
				<table class="infoTable">
					<colgroup>
						<col style="width: 10%;">
						<col style="width: 40%;">
						<col style="width: 10%;">
						<col style="width: 15%;">
					</colgroup>
					<tr>
						<th>구분</th>
						<th>평가 유형</th>
						<th>평가 결과</th>
						<th>평가 점수</th>
						<th>법무법인</th>
					</tr>
					<%
						for ( int i=0; i<satisList.size(); i++ ) {
							HashMap satisInfo = (HashMap) satisList.get(i);
							if ( satisInfo.get( "DGSTFN_ANS_MNG_NO" ) == null ) {
								continue;
							}
							
							String ansCont = "";
							String DGSTFN_ANS_SCR = satisInfo.get("DGSTFN_ANS_SCR")==null?"":satisInfo.get("DGSTFN_ANS_SCR").toString();
							
// 							switch(DGSTFN_ANS_SCR) {
// 								case "5":
// 									ansCont = satisInfo.get("FST_ANS_ARTCL_NM")==null?"":satisInfo.get("FST_ANS_ARTCL_NM").toString();
// 									break;
// 								case "4":
// 									ansCont = satisInfo.get("SEC_ANS_ARTCL_NM")==null?"":satisInfo.get("SEC_ANS_ARTCL_NM").toString();
// 									break;
// 								case "3":
// 									ansCont = satisInfo.get("THR_ANS_ARTCL_NM")==null?"":satisInfo.get("THR_ANS_ARTCL_NM").toString();
// 									break;
// 								case "2":
// 									ansCont = satisInfo.get("FOUR_ANS_ARTCL_NM")==null?"":satisInfo.get("FOUR_ANS_ARTCL_NM").toString();
// 									break;
// 								case "1":
// 									ansCont = satisInfo.get("FIFTH_ANS_ARTCL_NM")==null?"":satisInfo.get("FIFTH_ANS_ARTCL_NM").toString();
// 									break;
// 							}
							if ("5".equals(DGSTFN_ANS_SCR)) {
								ansCont = satisInfo.get("FST_ANS_ARTCL_NM") == null ? "" : satisInfo.get("FST_ANS_ARTCL_NM").toString();
							} else if ("4".equals(DGSTFN_ANS_SCR)) {
								ansCont = satisInfo.get("SEC_ANS_ARTCL_NM") == null ? "" : satisInfo.get("SEC_ANS_ARTCL_NM").toString();
							} else if ("3".equals(DGSTFN_ANS_SCR)) {
								ansCont = satisInfo.get("THR_ANS_ARTCL_NM") == null ? "" : satisInfo.get("THR_ANS_ARTCL_NM").toString();
							} else if ("2".equals(DGSTFN_ANS_SCR)) {
								ansCont = satisInfo.get("FOUR_ANS_ARTCL_NM") == null ? "" : satisInfo.get("FOUR_ANS_ARTCL_NM").toString();
							} else if ("1".equals(DGSTFN_ANS_SCR)) {
								ansCont = satisInfo.get("FIFTH_ANS_ARTCL_NM") == null ? "" : satisInfo.get("FIFTH_ANS_ARTCL_NM").toString();
							}
					%>
					<tr>
						<td style="text-align: center;"><%=satisInfo.get("DGSTFN_SRVY_TRGT_SE")==null?"":("L".equals(String.valueOf(satisInfo.get("DGSTFN_SRVY_TRGT_SE")))?"자문팀":"의뢰부서")%></td>
						<td style="text-align: left;"><%=satisInfo.get("DGSTFN_SRVY_CN")==null?"":(satisInfo.get("DGSTFN_EVL_TYPE_NM")+":"+satisInfo.get("DGSTFN_SRVY_CN"))%></td>
						<td style="text-align: left;"><%=ansCont%></td>
						<td style="text-align: center;"><%=satisInfo.get("DGSTFN_ANS_SCR2")==null?"0":satisInfo.get("DGSTFN_ANS_SCR2").toString()+"점"%></td>
						<td style="text-align: left;"><%=satisInfo.get("TRGT_NM")==null?"":satisInfo.get("TRGT_NM").toString()%></td>
					</tr>
					<%
						}
					%>
				</table>
			</div>
		</div>
		<%
		}
		%>
	</div>
