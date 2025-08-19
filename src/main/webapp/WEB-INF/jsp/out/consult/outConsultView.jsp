<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%@page import="java.text.DecimalFormat"%>
<%
	
	String WRTR_EMP_NM     = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO     = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM     = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO     = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	ConsultService consultService = ConsultServiceHelper.getConsultService(application);
	//자문 기본 정보
	HashMap consult = request.getAttribute("consultinfo")==null?new HashMap():(HashMap)request.getAttribute("consultinfo");
	//자문의뢰서 첨부파일
	List confileList = request.getAttribute("confileList")==null?new ArrayList():(ArrayList)request.getAttribute("confileList");
	//자문변호사 리스트
	List consultLawyerList = request.getAttribute("consultLawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("consultLawyerList");
	//자문답변
	List opinionlist = request.getAttribute("opinionlist")==null?new ArrayList():(ArrayList)request.getAttribute("opinionlist");
	//자문승인권자목록
	List agreelist = request.getAttribute("agreelist")==null?new ArrayList():(ArrayList)request.getAttribute("agreelist");
	//자문답변 첨부파일
	List opinionFilelist = request.getAttribute("opinionFilelist")==null?new ArrayList():(ArrayList)request.getAttribute("opinionFilelist");
	//관련자문 리스트
	//List relList = consultinfo.get("relList")==null?new ArrayList():(ArrayList)consultinfo.get("relList");
	
	// 만족도 리스트
	List satisList = request.getAttribute("satisList")==null?new ArrayList():(ArrayList)request.getAttribute("satisList");
	
	String RCPT_YN = request.getParameter("RCPT_YN")==null?"":request.getParameter("RCPT_YN").toString();
	
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String filePath = request.getParameter("filePath")==null?"":request.getParameter("filePath").toString();
	String cnstn_mng_no   = consult.get("CNSTN_MNG_NO")==null?"":consult.get("CNSTN_MNG_NO").toString();
	String menu_mng_no   = consult.get("MENU_MNG_NO")==null?"":consult.get("MENU_MNG_NO").toString();
	String cnstn_doc_no   = consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString();
	String prgrs_stts_se_nm   = consult.get("PRGRS_STTS_SE_NM")==null?"":consult.get("PRGRS_STTS_SE_NM").toString();
	String rls_yn   = consult.get("RLS_YN")==null?"":consult.get("RLS_YN").toString();
	String insd_otsd_task_se   = consult.get("INSD_OTSD_TASK_SE")==null?"":consult.get("INSD_OTSD_TASK_SE").toString();
	String otsd_rqst_rsn   = consult.get("OTSD_RQST_RSN")==null?"":consult.get("OTSD_RQST_RSN").toString();
	String cnstn_ttl   = consult.get("CNSTN_TTL")==null?"":consult.get("CNSTN_TTL").toString();
	String cnstn_rqst_emp_no   = consult.get("CNSTN_RQST_EMP_NO")==null?"":consult.get("CNSTN_RQST_EMP_NO").toString();
	String cnstn_rqst_emp_nm   = consult.get("CNSTN_RQST_EMP_NM")==null?"":consult.get("CNSTN_RQST_EMP_NM").toString();
	String cnstn_rqst_dept_no   = consult.get("CNSTN_RQST_DEPT_NO")==null?"":consult.get("CNSTN_RQST_DEPT_NO").toString();
	String cnstn_rqst_dept_nm   = consult.get("CNSTN_RQST_DEPT_NM")==null?"":consult.get("CNSTN_RQST_DEPT_NM").toString();
	String cnstn_rqst_dept_tmldr_emp_no   = consult.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO")==null?"":consult.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO").toString();
	String cnstn_rqst_dept_tmldr_nm   = consult.get("CNSTN_RQST_DEPT_TMLDR_NM")==null?"":consult.get("CNSTN_RQST_DEPT_TMLDR_NM").toString();
	String rqst_dept_last_aprvr_jbps_nm   = consult.get("RQST_DEPT_LAST_APRVR_JBPS_NM")==null?"":consult.get("RQST_DEPT_LAST_APRVR_JBPS_NM").toString();
	String cnstn_rqst_reg_ymd   = consult.get("CNSTN_RQST_REG_YMD")==null?"":consult.get("CNSTN_RQST_REG_YMD").toString();
	String cnstn_rqst_ymd   = consult.get("CNSTN_RQST_YMD")==null?"":consult.get("CNSTN_RQST_YMD").toString();
	String cnstn_rqst_cn   = consult.get("CNSTN_RQST_CN")==null?"":consult.get("CNSTN_RQST_CN").toString().replaceAll("\n","<br/>");
	String cnstn_rqst_subst_cn   = consult.get("CNSTN_RQST_SUBST_CN")==null?"":consult.get("CNSTN_RQST_SUBST_CN").toString().replaceAll("\n","<br/>");
	String rmrk_cn   = consult.get("RMRK_CN")==null?"":consult.get("RMRK_CN").toString().replaceAll("\n","<br/>");
	String cnstn_hope_rply_ymd   = consult.get("CNSTN_HOPE_RPLY_YMD")==null?"":consult.get("CNSTN_HOPE_RPLY_YMD").toString();
	String cnstn_rcpt_ymd   = consult.get("CNSTN_RCPT_YMD")==null?"":consult.get("CNSTN_RCPT_YMD").toString();
	String cnstn_tkcg_emp_no   = consult.get("CNSTN_TKCG_EMP_NO")==null?"":consult.get("CNSTN_TKCG_EMP_NO").toString();
	String cnstn_tkcg_emp_nm   = consult.get("CNSTN_TKCG_EMP_NM")==null?"":consult.get("CNSTN_TKCG_EMP_NM").toString();
	String cnstn_rply_ymd   = consult.get("CNSTN_RPLY_YMD")==null?"":consult.get("CNSTN_RPLY_YMD").toString();
	String cnstn_cmptn_ymd   = consult.get("CNSTN_CMPTN_YMD")==null?"":consult.get("CNSTN_CMPTN_YMD").toString();
	String prvt_srch_kywd_cn   = consult.get("PRVT_SRCH_KYWD_CN")==null?"":consult.get("PRVT_SRCH_KYWD_CN").toString();
	String emrg_yn   = consult.get("EMRG_YN")==null?"":consult.get("EMRG_YN").toString();
	String del_yn   = consult.get("DEL_YN")==null?"":consult.get("DEL_YN").toString();
	String wrtr_emp_nm   = consult.get("WRTR_EMP_NM")==null?"":consult.get("WRTR_EMP_NM").toString();
	String wrtr_emp_no   = consult.get("WRTR_EMP_NO")==null?"":consult.get("WRTR_EMP_NO").toString();
	String wrt_ymd   = consult.get("WRT_YMD")==null?"":consult.get("WRT_YMD").toString();
	String wrt_dept_nm   = consult.get("WRT_DEPT_NM")==null?"":consult.get("WRT_DEPT_NM").toString();
	String wrt_dept_no   = consult.get("WRT_DEPT_NO")==null?"":consult.get("WRT_DEPT_NO").toString();
	String mdfcn_emp_nm   = consult.get("MDFCN_EMP_NM")==null?"":consult.get("MDFCN_EMP_NM").toString();
	String mdfcn_emp_no   = consult.get("MDFCN_EMP_NO")==null?"":consult.get("MDFCN_EMP_NO").toString();
	String mdfcn_ymd   = consult.get("MDFCN_YMD")==null?"":consult.get("MDFCN_YMD").toString();
	String mdfcn_dept_nm   = consult.get("MDFCN_DEPT_NM")==null?"":consult.get("MDFCN_DEPT_NM").toString();
	String mdfcn_dept_no   = consult.get("MDFCN_DEPT_NO")==null?"":consult.get("MDFCN_DEPT_NO").toString();
	String emrg_rsn = consult.get("EMRG_RSN")==null?"":consult.get("EMRG_RSN").toString();
	String cnstn_se_nm = consult.get("CNSTN_SE_NM")==null?"":consult.get("CNSTN_SE_NM").toString();
	String cnstn_ans_rvw_opnn_cn = consult.get("CNSTN_ANS_RVW_OPNN_CN")==null?"":consult.get("CNSTN_ANS_RVW_OPNN_CN").toString();
	
	String cnstn_rqst_dh_emp_no = consult.get("CNSTN_RQST_DH_EMP_NO")==null?"":consult.get("CNSTN_RQST_DH_EMP_NO").toString();
	String cnstn_rqst_dh_nm = consult.get("CNSTN_RQST_DH_NM")==null?"":consult.get("CNSTN_RQST_DH_NM").toString();
	String cnstn_rqst_dh_telno = consult.get("CNSTN_RQST_DH_TELNO")==null?"":consult.get("CNSTN_RQST_DH_TELNO").toString();
	String cnstn_rqst_dept_tmldr_telno = consult.get("CNSTN_RQST_DEPT_TMLDR_TELNO")==null?"":consult.get("CNSTN_RQST_DEPT_TMLDR_TELNO").toString();
	
	String cnstn_intl_doc_no = consult.get("CNSTN_INTL_DOC_NO")==null?"":consult.get("CNSTN_INTL_DOC_NO").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	String JIKGUB_NM = se.get("JIKGUB_NM")==null?"":se.get("JIKGUB_NM").toString();
	String JIKCHK_NM = se.get("JIKCHK_NM")==null?"":se.get("JIKCHK_NM").toString();
	String ISDEVICE = se.get("ISDEVICE")==null?"":se.get("ISDEVICE").toString();
	System.out.println("디바이스 뭐로 나오는가??? ::: " + ISDEVICE);
	ISDEVICE = "P"; // 임시로 고정해둔 값 나중에 공통부분 어떻게 수정되는지에 따라 지우거나 수정해야함.
	String teamA = "";	// 팀장
	String teamB = "";	// 부장
	
	String lawyernm = WRT_DEPT_NM + " " + WRTR_EMP_NM;
	
	String oldno = consult.get("OLDCONSULTNO")==null?"":consult.get("OLDCONSULTNO").toString();
%>
<style>
	.infoTable.write th {
		background: #d6d9dc;
	}
	.innerBtn {float: right;}
	
	.x-grid-empty {padding-top:0px;}
</style>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/plugin/jquery.number.js"></script>
<script type="text/javascript">
	var consultid = "<%=cnstn_mng_no%>";
	var statcd = "<%=prgrs_stts_se_nm%>";
	var inoutcon = "<%=insd_otsd_task_se%>";
	
	// 상세화면 재호출
	function viewReload() {
		var frm = document.detailFrm;
		$("#consultid").val(consultid);
		$("#inoutcon").val('<%=insd_otsd_task_se%>');
		frm.action = "<%=CONTEXTPATH%>/out/outConsultView.do";
		frm.submit();
	}
	
	// 목록 화면 이동
	function consultList() {
		var frm = document.detailFrm;
		$("#consultid").val(consultid);
		$("#inoutcon").val('<%=insd_otsd_task_se%>');
		frm.action = "${pageContext.request.contextPath}/out/outConsultList.do";
		frm.submit();
	}
	
	// 자문 메모 목록 그리드
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/resources/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'CNSTN_MEMO_MNG_NO'},		//자문메모관리번호
			{name:'CNSTN_MNG_NO'},		//자문관리번호
			{name:'CNSTN_DOC_SE_NM'},		//메모제목
			{name:'MEMO_TTL'},		//메모제목
			{name:'MEMO_CN'},		//메모내용
			{name:'DEL_YN'},		//삭제여부
			{name:'WRTR_EMP_NM'},		//작성직원명
			{name:'WRTR_EMP_NO'},		//작성직원번호
			{name:'WRT_YMD'},		//작성일자
			{name:'WRT_DEPT_NM'},		//작성부서명
			{name:'WRT_DEPT_NO'},		//작성부서번호
			{name:'MDFCN_EMP_NM'},		//수정직원명
			{name:'MDFCN_EMP_NO'},		//수정직원번호
			{name:'MDFCN_YMD'},		//수정일자
			{name:'MDFCN_DEPT_NM'},		//수정부서명
			{name:'MDFCN_DEPT_NO'}		//수정부서번호
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/consult/selectMemoList.do"
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
				root:'result', totalProperty:'total', idProperty:'CNSTN_MEMO_MNG_NO'
			}, myRecordObj)
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>자문메모ID</b>",     dataIndex:'CNSTN_MEMO_MNG_NO',       align:'left', hidden:true},
				{header:"<b>자문ID</b>",         dataIndex:'CNSTN_MNG_NO',    align:'left', hidden:true},
				{header:"<b>제목</b>",           dataIndex:'MEMO_TTL',        align:'left'},
				{header:"<b>내용</b>",           dataIndex:'MEMO_CN', align:'left'},
				{header:"<b>작성자</b>",         dataIndex:'WRTR_EMP_NM',       align:'center'},
				{header:"<b>작성자사번</b>",     dataIndex:'WRTR_EMP_NO',     align:'left', hidden:true},
				{header:"<b>작성자부서코드</b>", dataIndex:'WRT_DEPT_NO',       align:'left', hidden:true},
				{header:"<b>작성자부서명</b>",   dataIndex:'WRT_DEPT_NM',     align:'center'},
				{header:"<b>작성일</b>",         dataIndex:'WRT_YMD',      align:'center'}
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
					
					var cnstn_memo_mng_no = histData.get("CNSTN_MEMO_MNG_NO");
					var cnstn_mng_no = histData.get("CNSTN_MNG_NO");
					
					goMemoView(cnstn_memo_mng_no, cnstn_mng_no);
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
				consultid : consultid
				, docGbn : 'CMEMO'
// 				,'${_csrf.parameterName}' : '${_csrf.token}'
			}
		});
		
		gridStore.load({
			params : {
				consultid : consultid
				, docGbn : 'CMEMO'
			}
		});
	});
	
	//자문 메모 등록 팝업 호출
	function memoWrite(memoid) {
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/consultMemoWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"memoid", value:memoid}));
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"filegbn", value:'CMEMO'}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 자문 메모 상세 및 관리 화면 호출
	function goMemoView(memoid, consultid) {
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/consultMemoViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"memoid", value:memoid}));
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:consultid}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 답변 등록 화면 호출
	function consultAnswer(chckid) {
		var outreqdt = "<%=cnstn_rqst_ymd%>";
		
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/consultAnswerWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CNSTN_MNG_NO", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"inoutcon",  value:inoutcon}));
		newForm.append($("<input/>", {type:"hidden", name:"RVW_OPNN_MNG_NO",    value:chckid}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 자문 답변 삭제
	function consultAnswerDelete(getChckid, getConsultLawyerid) {
		var confirmMsg = "답변을 삭제 하시겠습니까?";
		
		if (confirm(confirmMsg)) {
			$.ajax({
				url: "${pageContext.request.contextPath}/web/consult/deleteAnswer.do",
				data: {
					"consultid": $("#consultid").val(),
					"chckid": getChckid,
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
			url : "${pageContext.request.contextPath}/web/consult/answerResultSave.do",
			data : {
				"chckid" : getChckid,
				"ansresult" : 'Y',
				"consultid" : consultid
			},
			dataType: "json",
			async: false,
			success : function(result){
				alert("답변 결과가 변경되었습니다.");
				viewReload();
			}
		});
	}
	
	// 비용 정보 등록 화면 호출
	function consultCstInfoReg(chckid) {
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/consultCstInfoRegPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"inoutcon",  value:inoutcon}));
		newForm.append($("<input/>", {type:"hidden", name:"chckid",    value:chckid}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	$(document).ready(function(){
		var statcd = "<%=prgrs_stts_se_nm%>";
		
		$("#listbtn").click(function(){
			var frm = document.detailFrm;
			frm.action = "${pageContext.request.contextPath}/web/consult/goConsultList.do";
			frm.submit();
		});
		
		$(window).resize(function() {
			
		});
	});
	
	function gotowrite(){
		var frm = document.detailFrm;
		frm.action = "consultWrite.do";
		frm.submit();
	}
	
	function gotoview(){
		var frm = document.detailFrm;
		frm.action = "consultView.do";
		frm.submit();
	}
	
	//자문작성자 변호사 게시판
	function chckBoardPop(id){
		var param = '';
		if(id){
			param  = "?consultid="+ $("#consultid").val()+"&chckid="+id;
		}else{
			param  = "?consultid="+ $("#consultid").val();
		}
		popOpen($("#consultid").val(),"chckBoardWritePop.do"+param,"820","550");
	}
	
	//외부변호사 자문비용 팝업
	function outerConsultantCostPop(lawfirmid, chckid, consultantid){
		var param = "?consultantid="+ consultantid +"&consultid="+$("#consultid").val()+"&chckid="+chckid+"&lawfirmid="+lawfirmid;
		popOpen($("#consultid").val(),"outerConsultantCostPop.do"+param,"720","520");
	}
	
	//자문비용 팝업
	function consultantCostPop(){
		// 자문료 요청 / 지급 정보 확인
		alert("법무법인의 자문료 청구가 완료되지 않았습니다.");
		return;
		var param = "?consultid="+$("#consultid").val();
		popOpen($("#consultid").val(),"consultantCostPop.do"+param,"700","590");
	}
	
	function downFile(Pcfilename,Serverfile,folder){
		form=document.ViewForm;
		form.Pcfilename.value=Pcfilename;
		form.Serverfile.value=Serverfile;
		form.folder.value=folder;
		form.action="${pageContext.request.contextPath}/Download.do";
		form.submit();
	}
	
	function setCostApp(chckid, RVW_TKCG_MNG_NO, writerid, CST_PRGRS_STTS_SE) {
		if ($("#CNSTN_CST_AMT").val() == "") {
			return alert("자문료 금액을 입력하세요");
		}
		if ($("#CST_CLM_YMD").val() == "") {
			return alert("청구일자를 입력하세요");
		}
		if ($("#BACNT_MNG_NO").val() == "") {
			return alert("청구 계좌를 선택하세요");
		}
		
		$("#CNSTN_CST_AMT").val(uncomma($("#CNSTN_CST_AMT").val()));
		
		if (CST_PRGRS_STTS_SE == "X") {
			CST_PRGRS_STTS_SE = "Z";
		}
		
		$.ajax({
			type:"POST",
			url : "${pageContext.request.contextPath}/web/consult/setConsultCost.do",
			data : {
				CNSTN_MNG_NO : consultid,
				CST_PRGRS_STTS_SE : CST_PRGRS_STTS_SE,
				RVW_TKCG_MNG_NO : RVW_TKCG_MNG_NO,
				CNSTN_CST_AMT : $("#CNSTN_CST_AMT").val(),
				CST_CLM_YMD : $("#CST_CLM_YMD").val(),
				BACNT_MNG_NO : $("#BACNT_MNG_NO").val(),
				CNSTN_CST_MNG_NO : $("#CNSTN_CST_MNG_NO").val()
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
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"CONSULT"}));
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
					DOC_GBN:'CONSULT',
					RFSL_RSN:'',
					DOC_PK:$("#consultid").val(),
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
			newForm.append($("<input/>", {type:"hidden", name:"DOC_PK", value:$("#consultid").val()}));
			newForm.append($("<input/>", {type:"hidden", name:"DOC_GBN", value:'CONSULT'}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	}
</script>
<form name="ViewForm" method="post">
	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<form name="detailFrm" id="detailFrm" method="post">
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="consultid"   id="consultid" value="<%=cnstn_mng_no%>"/>
	<input type="hidden" name="inoutcon"   id="inoutcon" value="<%=insd_otsd_task_se%>"/>
	<input type="hidden" name="searchForm" id="searchForm" value="<%=searchForm%>"/>
	
	<div class="subCA">
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="subTT">
					<%=cnstn_ttl%> (<%=cnstn_doc_no%>)
				</strong>
			</div>
		</div>
		<div class="innerS">
			<div class="subContW">
				<div class="form-wrapper">
					<div class="btn-group btns-3">
						<button class="form_btn style1" onclick="consultList();">목록</button>
<%
				if ("X".equals(GRPCD) && !RCPT_YN.equals("A")) {
					if("외부검토중".equals(prgrs_stts_se_nm)) {
						if(opinionlist.size() < consultLawyerList.size()) {
%>
						<button class="form_btn style2" onclick="consultAnswer('');">답변등록</button>
<%
						}
					}
				}
%>
					</div>
					
					<div class="form-group cols-3">
						<div class="formC">
							<label>의뢰부서</label>
							<div class="form_box">
								<p><%=cnstn_rqst_dept_nm%></p>
							</div>
						</div>
						<div class="formC">
							<label>의뢰인</label>
							<div class="form_box">
								<p><%=cnstn_rqst_emp_nm%></p>
							</div>
						</div>
						<div class="formC">
							<label>의뢰 등록일</label>
							<div class="form_box">
								<p><%=cnstn_rqst_reg_ymd%></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-3">
						<div class="formC">
							<label>자문유형</label>
							<div class="form_box">
								<p>
							<%
								if ("O".equals(insd_otsd_task_se)) {
									out.println("외부자문");
								} else if ("I".equals(insd_otsd_task_se)) {
									out.println("내부자문");
								} else {
									out.println("미지정");
								}
								
								if("N".equals(rls_yn)) {
									out.println(" (비공개)");
								} else {
									out.println(" (공개)");
								}
							%>
								</p>
							</div>
						</div>
						<div class="formC">
							<label>긴급여부</label>
							<div class="form_box">
								<p>
							<%
								if ("N".equals(emrg_yn)) {
									out.println("일반");
								} else if ("Y".equals(emrg_yn)) {
									out.println("긴급");
								} else {
									out.println("미지정");
								}
							%>
								</p>
							</div>
						</div>
						<div class="formC">
							<label>긴급사유</label>
							<div class="form_box">
								<p><%=emrg_rsn%></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-3">
						<div class="formC">
							<label>자문요청일자</label>
							<div class="form_box">
								<p><%=cnstn_rqst_ymd%></p>
							</div>
						</div>
						<div class="formC">
							<label>접수완료일자</label>
							<div class="form_box">
								<p><%=cnstn_rcpt_ymd%></p>
							</div>
						</div>
						<div class="formC">
							<label>자문회신일자</label>
							<div class="form_box">
								<p><%=cnstn_rply_ymd%></p>
							</div>
						</div>
					</div>
					
					<div class="form-group cols-1">
						<div class="formC">
							<label>외부의뢰사유</label>
							<div class="form_box">
								<p><%=otsd_rqst_rsn%></p>
							</div>
						</div>
					</div>
					
					<div class="form-group cols-1">
						<div class="formC">
							<label>진행 상태</label>
							<div class="form_box">
								<p><%=prgrs_stts_se_nm%></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>자문 배경</label>
							<div class="form_box">
								<p><%=cnstn_rqst_cn%></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>자문 요지</label>
							<div class="form_box">
								<p><%=cnstn_rqst_subst_cn%></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>첨부파일</label>
							<ul class="fileList">
							<% if(confileList != null & confileList.size()>0){ %>
								<%
								for(int i=0; i<confileList.size();i++){
									HashMap consultFile = (HashMap)confileList.get(i);
								%>
								<li>
									<a href="#" onclick="downFile('<%=consultFile.get("DWNLD_FILE_NM") %>','<%=consultFile.get("SRVR_FILE_NM") %>','CONSULT')"><%=consultFile.get("DWNLD_FILE_NM")%></a>
								</li>
								<% } %>
							<% } %>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<hr class="margin40">
		<strong class="subTT">자문 메모</strong>
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
		System.out.println(opinionlist.size());
		System.out.println(opinionlist.size());
		System.out.println(opinionlist.size());
		System.out.println(opinionlist.size());
		System.out.println(opinionlist.size());
		if(opinionlist.size()>0){
%>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="subTT">자문 답변</strong>
			</div>
		</div>
		<div class="innerS">
			<div class="subContW">
				<div class="form-wrapper">
<%
			for(int i=0; i<opinionlist.size(); i++) {
				HashMap chckMap = (HashMap)opinionlist.get(i);
				
				String ansResult = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
				String ansChckid = chckMap.get("RVW_OPNN_MNG_NO")==null?"":chckMap.get("RVW_OPNN_MNG_NO").toString();
				String ansCont = chckMap.get("RVW_OPNN_CN")==null?"":chckMap.get("RVW_OPNN_CN").toString();
				String ansCont2 = chckMap.get("RMRK_CN")==null?"":chckMap.get("RMRK_CN").toString();
				
				String writerid = chckMap.get("RVW_TKCG_EMP_NO")==null?"":chckMap.get("RVW_TKCG_EMP_NO").toString();
				String RVW_TKCG_MNG_NO = chckMap.get("RVW_TKCG_MNG_NO")==null?"":chckMap.get("RVW_TKCG_MNG_NO").toString();
				String rvw_opnn_cmptn_yn = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
				
				String CST_PRGRS_STTS_SE = chckMap.get("CST_PRGRS_STTS_SE")==null?"R":chckMap.get("CST_PRGRS_STTS_SE").toString();
				String CNSTN_CST_MNG_NO = chckMap.get("CNSTN_CST_MNG_NO")==null?"":chckMap.get("CNSTN_CST_MNG_NO").toString();
%>
					<div class="form-group cols-3">
						<div class="formC">
							<label>자문인</label>
							<div class="form_box">
								<p><%=chckMap.get("RVW_TKCG_EMP_NM")==null?"":chckMap.get("RVW_TKCG_EMP_NM").toString()%></p>
							</div>
						</div>
						<div class="formC">
							<label>답변등록일자</label>
							<div class="form_box">
								<p><%=chckMap.get("RVW_OPNN_REG_YMD")==null?"":chckMap.get("RVW_OPNN_REG_YMD").toString()%></p>
							</div>
						</div>
						<div class="formC">
							<label>답변등록상태</label>
							<div class="form_box">
								<p>
							<%
								if ("N".equals(rvw_opnn_cmptn_yn)) {
									out.println("답변중");
								} else if ("Y".equals(rvw_opnn_cmptn_yn)) {
									out.println("답변완료");
								} else {
									out.println("미확인");
								}
							%>
								</p>
							</div>
						</div>
					</div>
<%
					if ("완료".equals(prgrs_stts_se_nm) && GRPCD.indexOf("X") > -1 && writerid.equals(USERNO)) {
						if ("R".equals(CST_PRGRS_STTS_SE) || "X".equals(CST_PRGRS_STTS_SE)) {
%>
					<div class="form-group cols-3">
						<div class="formC">
							<label>자문료</label>
							<div class="form_box">
								<input type="hidden" name="CNSTN_CST_MNG_NO" id="CNSTN_CST_MNG_NO" value="<%=chckMap.get("CNSTN_CST_MNG_NO")==null?"":chckMap.get("CNSTN_CST_MNG_NO").toString()%>" />
								<input type="text" name="CNSTN_CST_AMT" id="CNSTN_CST_AMT" value="<%=chckMap.get("CNSTN_CST_AMT")==null?"":chckMap.get("CNSTN_CST_AMT").toString()%>" onkeyup="numFormat(this);"/>
							</div>
						</div>
						<div class="formC">
							<label>청구일자</label>
							<div class="form_box">
								<input type="text" class="datepick" id="CST_CLM_YMD" name="CST_CLM_YMD" style="width: 80px;" value="<%=chckMap.get("CST_CLM_YMD")==null?"":chckMap.get("CST_CLM_YMD").toString()%>">
							</div>
						</div>
						<div class="formC">
							<label>계좌정보</label>
							<div class="form_box">
								<input type="hidden" name="BACNT_MNG_NO" id="BACNT_MNG_NO" value="<%=chckMap.get("BACNT_MNG_NO")==null?"":chckMap.get("BACNT_MNG_NO").toString()%>" />
								<input type="text" name="BACNT_INFO" id="BACNT_INFO" value="<%=chckMap.get("BACNT_INFO")==null?"":chckMap.get("BACNT_INFO").toString()%>" readonly="readonly"/>
								<%-- <a href="#none" class="innerBtn" onclick="searchAccount('<%=writerid%>');">조회</a> --%>
								<button class="f_in_btn s1" onclick="searchAccount('<%=writerid%>');">조회</button>
							</div>
						</div>
					</div>
<%
						} else {
%>
					<div class="form-group cols-3">
						<div class="formC">
							<label>자문료</label>
							<div class="form_box">
								<p><%=chckMap.get("CNSTN_CST_AMT")==null?"":chckMap.get("CNSTN_CST_AMT").toString()%></p>
							</div>
						</div>
						<div class="formC">
							<label>청구일자</label>
							<div class="form_box">
								<p><%=chckMap.get("CST_CLM_YMD")==null?"":chckMap.get("CST_CLM_YMD").toString()%></p>
							</div>
						</div>
						<div class="formC">
							<label>계좌정보</label>
							<div class="form_box">
								<p><%=chckMap.get("BACNT_INFO")==null?"":chckMap.get("BACNT_INFO").toString()%></p>
							</div>
						</div>
					</div>
<%
						}
%>
					<div class="form-group cols-3">
						<div class="formC">
							<label>처리현황</label>
							<div class="form_box">
								<p><%=chckMap.get("CST_PRGRS_STTS_NM")==null?"":chckMap.get("CST_PRGRS_STTS_NM").toString()%></p>
							</div>
						</div>
						<div class="formC">
							<label>승인일자</label>
							<div class="form_box">
								<p><%=chckMap.get("CST_APRV_YMD")==null?"":chckMap.get("CST_APRV_YMD").toString()%></p>
							</div>
						</div>
						<div class="formC">
							<label>지급일자</label>
							<div class="form_box">
								<p><%=chckMap.get("CST_GIVE_YMD")==null?"":chckMap.get("CST_GIVE_YMD").toString()%></p>
							</div>
						</div>
					</div>


<%
					}
%>
					<div class="form-group cols-1">
						<div class="formC">
							<label>답변내용</label>
							<div class="form_box">
								<p><%=ansCont.replaceAll("\n","<br/>")%></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>비고내용</label>
							<div class="form_box">
								<p><%=ansCont2.replaceAll("\n","<br/>")%></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>첨부파일</label>
							<div class="form_box">
								<ul>
<%
								if(opinionFilelist.size() > 0 && opinionFilelist != null) {
									for(int f=0; f<opinionFilelist.size(); f++) {
										HashMap chckFile = (HashMap) opinionFilelist.get(f);
										String fileChckid = chckFile.get("CNSTN_MNG_NO")==null?"":chckFile.get("CNSTN_MNG_NO").toString();
										if (ansChckid.equals(fileChckid)) {
%>
									<li>
										<a href="#" onclick="downFile('<%=chckFile.get("DWNLD_FILE_NM") %>','<%=chckFile.get("SRVR_FILE_NM") %>','CONSULT')"><%=chckFile.get("DWNLD_FILE_NM")%></a>
									</li>
<%
										}
									}
								}
%>
								</ul>
							</div>
						</div>
					</div>
					
					<div class="btn-group btns-3">
<%
					if("외부검토중".equals(prgrs_stts_se_nm) && GRPCD.indexOf("X") > -1 && writerid.equals(USERNO)) {
%>
						<button class="form_btn style2" onclick="setAnsResult('<%=ansChckid%>');">답변 완료</button>
						<button class="form_btn style2" onclick="consultAnswer('<%=chckMap.get("RVW_OPNN_MNG_NO") %>');">답변 수정</button>
						<button class="form_btn style2" onclick="consultAnswerDelete('<%=chckMap.get("RVW_OPNN_MNG_NO") %>', '<%=chckMap.get("RVW_TKCG_MNG_NO")%>');">답변 삭제</button>
<%
					} else if ("완료".equals(prgrs_stts_se_nm) && GRPCD.indexOf("X") > -1 && writerid.equals(USERNO) && ("R".equals(CST_PRGRS_STTS_SE) || "X".equals(CST_PRGRS_STTS_SE))) {
%>
						<button class="form_btn style2" onclick="setCostApp('<%=ansChckid%>', '<%=RVW_TKCG_MNG_NO%>', '<%=writerid%>', '<%=CST_PRGRS_STTS_SE%>');">비용신청</button>
<%
					}
%>
					</div>
<%
			}
%>
				</div>
			</div>
		</div>
<%
		}
%>
	</div>
</form>