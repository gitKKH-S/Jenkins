<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@	page import="java.util.*"%>
<%
	String searchForm  = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	String RCPT_YN = request.getParameter("RCPT_YN")==null?"":request.getParameter("RCPT_YN").toString();
	
	String lawyernm = WRT_DEPT_NM + " " + WRTR_EMP_NM;
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	String JIKGUB_NM = se.get("JIKGUB_NM")==null?"":se.get("JIKGUB_NM").toString();
	String JIKCHK_NM = se.get("JIKCHK_NM")==null?"":se.get("JIKCHK_NM").toString();
	
	HashMap agreeMap = request.getAttribute("agreeMap")==null?new HashMap():(HashMap)request.getAttribute("agreeMap");
	List agreeFileList = request.getAttribute("agreeRqstFile")==null?new ArrayList():(ArrayList)request.getAttribute("agreeRqstFile");
	List opinionlist = request.getAttribute("opinionlist")==null?new ArrayList():(ArrayList)request.getAttribute("opinionlist");
	List opinionFilelist = request.getAttribute("opinionFilelist")==null?new ArrayList():(ArrayList)request.getAttribute("opinionFilelist");
	List satisList = request.getAttribute("satisList")==null?new ArrayList():(ArrayList)request.getAttribute("satisList");
	List agreeResultFile = request.getAttribute("agreeResultFile")==null?new ArrayList():(ArrayList)request.getAttribute("agreeResultFile");
	
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
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/plugin/jquery.number.js"></script>
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
		var frm = document.detailFrm;
		$("#CVTN_MNG_NO").val(CVTN_MNG_NO);
		frm.action = "<%=CONTEXTPATH%>/out/outAgreeView.do";
		frm.submit();
	}
	
	function agreeList() {
		document.detailFrm.action = "<%=CONTEXTPATH%>/out/outAgreeList.do";
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
	
	
	function setCostApp(chckid, RVW_TKCG_MNG_NO, writerid, CST_PRGRS_STTS_SE) {
		if ($("#CVTN_CST_AMT").val() == "") {
			return alert("자문료 금액을 입력하세요");
		}
		if ($("#CST_CLM_YMD").val() == "") {
			return alert("청구일자를 입력하세요");
		}
		if ($("#BACNT_MNG_NO").val() == "") {
			return alert("청구 계좌를 선택하세요");
		}
		
		$("#CVTN_CST_AMT").val(uncomma($("#CVTN_CST_AMT").val()));
		
		if (CST_PRGRS_STTS_SE == "X") {
			CST_PRGRS_STTS_SE = "Z";
		}
		
		$.ajax({
			type:"POST",
			url : "${pageContext.request.contextPath}/web/agree/setAgreeCost.do",
			data : {
				CVTN_MNG_NO : CVTN_MNG_NO,
				CST_PRGRS_STTS_SE : CST_PRGRS_STTS_SE,
				RVW_TKCG_MNG_NO : RVW_TKCG_MNG_NO,
				CVTN_CST_AMT : $("#CVTN_CST_AMT").val(),
				CST_CLM_YMD : $("#CST_CLM_YMD").val(),
				BACNT_MNG_NO : $("#BACNT_MNG_NO").val(),
				CVTN_CST_MNG_NO : $("#CVTN_CST_MNG_NO").val()
			},
			dataType: "json",
			async: false,
			success : function(result){
				alert("자문료 정보가 저장되었습니다.");
				viewReload();
			}
		});
	}
	
	function searchAccount(LWYR_MNG_NO) {
		var cw=600;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/lawyerAccInfoPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"AGREE"}));
		newForm.append($("<input/>", {type:"hidden", name:"LWYR_MNG_NO", value:LWYR_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	
	function setRcpt(yn, docgbn) {
		if(yn == "Y") {
			// 상태값만 변경
			$.ajax({
				type:"POST",
				url : "${pageContext.request.contextPath}/out/rfslRsnSave.do",
				data : {
					RCPT_YN:yn,
					DOC_GBN:'AGREE',
					RFSL_RSN:'',
					DOC_PK:$("#CVTN_MNG_NO").val(),
					WRTR_EMP_NO:"<%=WRTR_EMP_NO%>",
					LWYR_NM:"<%=lawyernm%>",
				},
				dataType: "json",
				async: false,
				success : function(result){
					alert("저장되었습니다.");
					viewReload();
				}
			});
		} else {
			// 반려처리+반려사유 팝업 호출 및 담당자 알림 발송
			var cw=800;
			var ch=500;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","newEdit",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "newEdit");
			newForm.attr("action", "<%=CONTEXTPATH%>/out/rfslRsnPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWYR_NM", value:"<%=lawyernm%>"}));
			newForm.append($("<input/>", {type:"hidden", name:"WRTR_EMP_NO", value:"<%=WRTR_EMP_NO%>"}));
			newForm.append($("<input/>", {type:"hidden", name:"DOC_PK", value:$("#CVTN_MNG_NO").val()}));
			newForm.append($("<input/>", {type:"hidden", name:"DOC_GBN", value:'AGREE'}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
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
		if ("X".equals(GRPCD) && !RCPT_YN.equals("A")) {
			if("외부검토중".equals(PRGRS_STTS_SE_NM)) {
				out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"AgreeAnswer('');\">답변등록</a>");
			}
		}
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"agreeList();\"><i class=\"fa-solid fa-list\"></i> 목록</a>");
%>
		</div>
	</div>
	<div class="hkkresult">
		<hr class="margin40">
		<strong class="subST">기타계약 협약심사 내용</strong>
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
						(<%=CVTN_RQST_LAST_ATRZ_JBPS_SE%>)<%=CVTN_RQST_LAST_APRVR_NM%>
					</td>
					<th>구분</th>
					<td>
						<%=CVTN_SE%>
					</td>
					<th colspan="2"></th>
				</tr>
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
			%>
						<%=INSD_OTSD_TASK_NM%>
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
				if ("O".equals(INSD_OTSD_TASK_SE) && (GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1)) {
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
			<%
				}
			%>
				
				<tr>
					<th>협약건명</th>
					<td colspan="5">
						<%=agreeMap.get("CVTN_TTL")==null?"":agreeMap.get("CVTN_TTL").toString()%>
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
			</table>
		</div>
	</div>
	<div id="agreeGianTable"></div>
	
	<hr class="margin40">
	
	<strong class="subTT">협약 메모</strong>
	<hr class="margin10">
	<div class="innerB">
		<div id="consultProgGrid"></div>
		<div class="subBtnW side">
			<div class="subBtnC left" style="height:40px;">
			<%if(!RCPT_YN.equals("A")) {%>
				<a href="#none" class="sBtn type1" id="insertBtn" style="margin-top:3px;" onclick="memoWrite('0')">등록</a>
			<%}%>
			</div>
		</div>
	</div>
<%
		if(opinionlist.size()>0){
%>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="subTT">협약 답변</strong>
			</div>
		</div>
		<div class="innerB">
<%
			for(int i=0; i<opinionlist.size(); i++) {
				HashMap chckMap = (HashMap)opinionlist.get(i);
				
				String ansResult = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
				String ansChckid = chckMap.get("RVW_OPNN_MNG_NO")==null?"":chckMap.get("RVW_OPNN_MNG_NO").toString();
				String ansCont = chckMap.get("RVW_OPNN_CN")==null?"":chckMap.get("RVW_OPNN_CN").toString();
				String ansCont2 = chckMap.get("RMRK_CN")==null?"":chckMap.get("RMRK_CN").toString();
				String rvw_opnn_cmptn_yn = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
				String writerid = chckMap.get("RVW_TKCG_EMP_NO")==null?"":chckMap.get("RVW_TKCG_EMP_NO").toString();
				String RVW_TKCG_MNG_NO = chckMap.get("RVW_TKCG_MNG_NO")==null?"":chckMap.get("RVW_TKCG_MNG_NO").toString();
				String CST_PRGRS_STTS_SE = chckMap.get("CST_PRGRS_STTS_SE")==null?"R":chckMap.get("CST_PRGRS_STTS_SE").toString();
				String CVTN_CST_MNG_NO = chckMap.get("CVTN_CST_MNG_NO")==null?"":chckMap.get("CVTN_CST_MNG_NO").toString();
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
					if ("완료".equals(PRGRS_STTS_SE_NM) && GRPCD.indexOf("X") > -1 && writerid.equals(USERNO)) {
						if ("R".equals(CST_PRGRS_STTS_SE) || "X".equals(CST_PRGRS_STTS_SE)) {
%>
					<tr>
						<th>자문료</th>
						<td>
							<input type="hidden" name="CVTN_CST_MNG_NO" id="CVTN_CST_MNG_NO" value="<%=chckMap.get("CVTN_CST_MNG_NO")==null?"":chckMap.get("CVTN_CST_MNG_NO").toString()%>" />
							<input type="text" name="CVTN_CST_AMT" id="CVTN_CST_AMT" value="<%=chckMap.get("CVTN_CST_AMT")==null?"":chckMap.get("CVTN_CST_AMT").toString()%>" onkeyup="numFormat(this);"/>
						</td>
						<th>청구일자</th>
						<td>
							<input type="text" class="datepick" id="CST_CLM_YMD" name="CST_CLM_YMD" style="width: 80px;" value="<%=chckMap.get("CST_CLM_YMD")==null?"":chckMap.get("CST_CLM_YMD").toString()%>">
						</td>
						<th>계좌정보</th>
						<td>
							<input type="hidden" name="BACNT_MNG_NO" id="BACNT_MNG_NO" value="<%=chckMap.get("BACNT_MNG_NO")==null?"":chckMap.get("BACNT_MNG_NO").toString()%>" />
							<input type="text" name="BACNT_INFO" id="BACNT_INFO" value="<%=chckMap.get("BACNT_INFO")==null?"":chckMap.get("BACNT_INFO").toString()%>" readonly="readonly"/>
							<a href="#none" class="innerBtn" onclick="searchAccount('<%=writerid%>');">조회</a>
						</td>
					</tr>
					<%
						} else {
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
						}
					%>
					<tr>
						<th>처리현황</th>
						<td><%=chckMap.get("CST_PRGRS_STTS_NM")==null?"":chckMap.get("CST_PRGRS_STTS_NM").toString()%></td>
						<th>승인일자</th>
						<td><%=chckMap.get("CST_APRV_YMD")==null?"":chckMap.get("CST_APRV_YMD").toString()%></td>
						<th>지급일자</th>
						<td><%=chckMap.get("CST_GIVE_YMD")==null?"":chckMap.get("CST_GIVE_YMD").toString()%></td>
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
										String fileChckid = chckFile.get("CVTN_MNG_NO")==null?"":chckFile.get("CVTN_MNG_NO").toString();
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
				if(("내부검토중".equals(PRGRS_STTS_SE_NM) || "외부검토중".equals(PRGRS_STTS_SE_NM)) && GRPCD.indexOf("X") > -1 && writerid.equals(USERNO)) {
%>
					<a href="#none" class="sBtn type1" onclick="setAnsResult('<%=ansChckid%>');">답변 완료</a>
					<a href="#none" class="sBtn type1" onclick="AgreeAnswer('<%=chckMap.get("RVW_OPNN_MNG_NO") %>');">답변 수정</a>
					<a href="#none" class="sBtn type1" onClick="agreeAnswerDelete('<%=chckMap.get("RVW_OPNN_MNG_NO") %>', '<%=chckMap.get("RVW_TKCG_MNG_NO")%>')">답변 삭제</a>
<%
				} else if ("완료".equals(PRGRS_STTS_SE_NM) && GRPCD.indexOf("X") > -1 && writerid.equals(USERNO) && ("R".equals(CST_PRGRS_STTS_SE) || "X".equals(CST_PRGRS_STTS_SE))) {
%>
					<a href="#none" class="sBtn type1" onclick="setCostApp('<%=ansChckid%>', '<%=RVW_TKCG_MNG_NO%>', '<%=writerid%>', '<%=CST_PRGRS_STTS_SE%>');">비용신청</a>
<%
				}
%>
				</div>
				<hr class="margin20">
<%
			}
%>
<%
		}
%>
		</div>
	</div>
</div>