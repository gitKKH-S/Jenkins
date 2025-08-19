<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%@page import="java.text.DecimalFormat"%>
<%
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
	
	List relList = request.getAttribute("relList")==null?new ArrayList():(ArrayList)request.getAttribute("relList");
	
	// 만족도 리스트
	List satisList = request.getAttribute("satisList")==null?new ArrayList():(ArrayList)request.getAttribute("satisList");
	
	// 자문답변 검토의견 첨부파일
	List reviewCommentFileList = request.getAttribute("reviewCommentFileList")==null?new ArrayList():(ArrayList)request.getAttribute("reviewCommentFileList");
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String filePath = request.getParameter("filePath")==null?"":request.getParameter("filePath").toString();
	
	/* 자문 요청 내용 */
// 	String consultid   = consult.get("CONSULTID")==null?"":consult.get("CONSULTID").toString();
// 	String title       = consult.get("TITLE")==null?"":consult.get("TITLE").toString();
// 	String statcd      = consult.get("STATCD")==null?"":consult.get("STATCD").toString();
// 	String inoutcon    = consult.get("INOUTCON")==null?"":consult.get("INOUTCON").toString();
// 	String writerempno = consult.get("WRITEREMPNO")==null?"":consult.get("WRITEREMPNO").toString();
// 	String chrgempnm   = consult.get("CHRGEMPNM")==null?"":consult.get("CHRGEMPNM").toString();
// 	String chrgempno   = consult.get("CHRGEMPNO")==null?"":consult.get("CHRGEMPNO").toString();
// 	String outreqdt    = consult.get("OUTREQDT")==null?"":consult.get("OUTREQDT").toString();
// 	String openyn      = consult.get("OPENYN")==null?"":consult.get("OPENYN").toString();
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
	String excl_dmnd_jdaf_corp_nm   = consult.get("EXCL_DMND_JDAF_CORP_NM")==null?"":consult.get("EXCL_DMND_JDAF_CORP_NM").toString();
	String emrg_rsn = consult.get("EMRG_RSN")==null?"":consult.get("EMRG_RSN").toString();
	String cnstn_se_nm = consult.get("CNSTN_SE_NM")==null?"":consult.get("CNSTN_SE_NM").toString();
	String cnstn_ans_rvw_opnn_cn = consult.get("CNSTN_ANS_RVW_OPNN_CN")==null?"":consult.get("CNSTN_ANS_RVW_OPNN_CN").toString();

	String cnstn_rqst_dh_emp_no = consult.get("CNSTN_RQST_DH_EMP_NO")==null?"":consult.get("CNSTN_RQST_DH_EMP_NO").toString();
	String cnstn_rqst_dh_nm = consult.get("CNSTN_RQST_DH_NM")==null?"":consult.get("CNSTN_RQST_DH_NM").toString();
	String cnstn_rqst_dh_telno = consult.get("CNSTN_RQST_DH_TELNO")==null?"":consult.get("CNSTN_RQST_DH_TELNO").toString();
	String cnstn_rqst_dept_tmldr_telno = consult.get("CNSTN_RQST_DEPT_TMLDR_TELNO")==null?"":consult.get("CNSTN_RQST_DEPT_TMLDR_TELNO").toString();
	
	String cnstn_intl_doc_no = consult.get("CNSTN_INTL_DOC_NO")==null?"":consult.get("CNSTN_INTL_DOC_NO").toString();
	
	
	
	String DGSTFN_RSPNS_YN = consult.get("DGSTFN_RSPNS_YN")==null?"":consult.get("DGSTFN_RSPNS_YN").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	String JIKGUB_NM = se.get("JIKGUB_NM")==null?"":se.get("JIKGUB_NM").toString();
	String JIKCHK_NM = se.get("JIKCHK_NM")==null?"":se.get("JIKCHK_NM").toString();
// 	String ISDEVICE = se.get("ISDEVICE")==null?"":se.get("ISDEVICE").toString();
	
	String oldno = consult.get("OLDCONSULTNO")==null?"":consult.get("OLDCONSULTNO").toString();
	
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
%>
<style>
	.infoTable.write th {
		background: #d6d9dc;
	}
	.innerBtn {float: right;}
	
	.x-grid-empty {padding-top:0px;}
	
	.relDiv:hover{
		cursor:pointer;
		text-decoration:underline;
	}
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
	var menu_mng_no = "<%=MENU_MNG_NO%>";
	
	// 수정 화면 이동
	function consultEdit() {
		var frm = document.detailFrm;
		$("#MENU_MNG_NO").val('<%=MENU_MNG_NO%>');
		$("#consultid").val(consultid);
		$("#inoutcon").val('<%=insd_otsd_task_se%>');
		frm.action = "consultWritePage.do";
		frm.submit();
	}
	
	// 상세화면 재호출
	function viewReload() {
		var frm = document.detailFrm;
		$("#MENU_MNG_NO").val('<%=MENU_MNG_NO%>');
		$("#consultid").val(consultid);
		$("#inoutcon").val('<%=insd_otsd_task_se%>');
		frm.action = "consultView.do";
		frm.submit();
	}
	
	// 목록 화면 이동
	function consultList() {
		var frm = document.detailFrm;
		$("#MENU_MNG_NO").val('<%=MENU_MNG_NO%>');
		$("#consultid").val(consultid);
		$("#inoutcon").val('<%=insd_otsd_task_se%>');
		frm.action = "${pageContext.request.contextPath}/web/consult/goConsultList.do";
		frm.submit();
	}
	
	// 자문 삭제
	function consultDelete() {
		//consultDelete.do
		if(confirm("자문 정보를 모두 삭제하시겠습니까?")) {
			
			$("#MENU_MNG_NO").val('<%=MENU_MNG_NO%>');
			$("#consultid").val(consultid);
			$("#inoutcon").val('<%=insd_otsd_task_se%>');
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/consult/consultDelete.do",
				data:$('#detailFrm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					alert("자문이 삭제되었습니다.");
					consultList();
				}
			});
		}
	}
	
	// 자문 진행상태 변경(버튼)
	function consultStateChange(getState) {
		var msg = '진행하시겠습니까?';
		if (getState == '접수대기') {
			msg = '접수를 요청 하시겠습니까?';
		} else if (getState == '접수') {
			msg = '접수 처리 하시겠습니까?';
// 		} else if (getState == '답변중') {
// 			msg = '다음 진행으로 넘어가시겠습니까?';
		} else if (getState == '팀장결재중') {
			msg = '팀장 결재 요청하시겠습니까??';
		} else if (getState == '과장결재중') {
			msg = '과장 결재 요청하시겠습니까??';
		}
		
		if(confirm(msg)){
			
			if (getState == '접수') {
				if (!inoutcon) {
					alert('자문 유형 저장 후 다시 시도하세요.');
					return false;
				}
			}
			
<%-- 			console.log(("<%=cnstn_tkcg_emp_no%>" != '')); --%>
// 			return false;
			if (getState == "외부검토중"){
				if("<%=cnstn_tkcg_emp_no%>" != '') {
					if (getState == "외부검토중" && "<%=consultLawyerList.size()%>" == 0) {
						return alert("자문위원지정을 수행 후 다시 시도하세요");
					} 
				}else {
					return alert("자문팀 담당자 지정이 필요합니다");
				}
			} 
			
			
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/consult/updateConsultState.do",
				data:{
					consultid : consultid,
					statcd : getState
				},
				dataType:"json",
				async:false,
				success:function(result){
					var msg = result.data.msg;
					if(msg != "") {
						alert(msg);
					} else {
						alert("처리가 완료되었습니다.");
						viewReload();
					}
					
				}
			});
		}
	}
	
	// 자문 진행상태 변경(콤보박스)
	function setAdmChgState(sta) {
		$.ajax({
			type:"POST",
// 			url:"${pageContext.request.contextPath}/web/consult/updateConsultState.do",
			url:"${pageContext.request.contextPath}/web/consult/updateConsultState2.do",
			data:{
				consultid : consultid,
				statcd : sta,
				adm:'Y'
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("처리가 완료되었습니다.");
				viewReload();
			}
		});
	}
	
	// 자문 공개여부 변경(콤보박스)
	function setAdmChgOpenyn(yn) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/updateConsultOpenyn.do",
			data:{
				consultid : consultid,
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
	
	// 자문 담당자 선택 팝업 호출
	function selectConsultEmp() {
		var cw=900;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/selectConsultEmpPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:"edit"}));
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:menu_mng_no}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 자문검토담당자 선택 팝업 호출
	function selectConsultRvwTkcg() {
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/selectConsultRvwPicPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"inoutcon",  value:inoutcon}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
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
		newForm.append($("<input/>", {type:"hidden", name:"CNSTN_MEMO_MNG_NO", value:memoid}));
		newForm.append($("<input/>", {type:"hidden", name:"CNSTN_MNG_NO", value:consultid}));
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
		newForm.append($("<input/>", {type:"hidden", name:"CNSTN_MEMO_MNG_NO", value:memoid}));
		newForm.append($("<input/>", {type:"hidden", name:"CNSTN_MNG_NO", value:consultid}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 답변 등록 화면 호출
	function consultAnswer(chckid) {
<%-- 		var inoutcon = "<%=inoutcon%>"; --%>
		var outreqdt = "<%=cnstn_rqst_ymd%>";
		
// 		if (inoutcon == "O" && outreqdt == "" && statcd == "답변중") { // 외부의뢰일을 따로 수동 등록해야하는건지?
// 			return alert("외부 의뢰일 등록 후 답변을 등록하세요");
// 		}
		
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
					"CNSTN_MNG_NO": consultid,
					"TRGT_PST_MNG_NO": getChckid,
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
			url : "${pageContext.request.contextPath}/web/consult/answerResultSave.do",
			data : {
				"chckid" : getChckid,
				"ansresult" : 'Y',
				"consultid" : consultid,
				inoutcon:inoutcon,
				prgrs_stts : statcd
				
			},
// 			beforeSend : function(xhr){
// 				xhr.setRequestHeader(header,token);	
// 			},
			dataType: "json",
			async: false,
			success : function(result){
				if (inoutcon == "I") {
					alert("팀장결재 요청이 되었습니다.");
				} else {
					alert("답변 결과가 변경되었습니다.");
				}
				viewReload();
			}
		});
	}
	
	// 반려 선택 및 반려 내용 메모테이블에 등록하는 팝업 호출
	function rejectWrite(memoid, stateCd) {
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/consultRejectWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"memoid", value:memoid}));
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"docGbn", value:'REJECT'}));
		newForm.append($("<input/>", {type:"hidden", name:"stateCd", value:stateCd}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	
	// 자문 답변 반려 내용 상세 및 관리 화면 호출
	function goRejectView(memoid, consultid) {
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/consultRejectViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"memoid", value:memoid}));
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:consultid}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 비용 정보 등록 화면 호출
	function consultCstInfoReg(chckid) {
<%-- 		var inoutcon = "<%=inoutcon%>"; --%>
		
// 		if (inoutcon == "O" && outreqdt == "" && statcd == "답변중") { // 외부의뢰일을 따로 수동 등록해야하는건지?
// 			return alert("외부 의뢰일 등록 후 답변을 등록하세요");
// 		}
		
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
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	$(document).ready(function(){
	
		var statcd = "<%=prgrs_stts_se_nm%>";
		
// 		$("#chgState").val(statcd).attr("selected", "selected");// psy
		
		$("#listbtn").click(function(){
			var frm = document.detailFrm;
			frm.action = "${pageContext.request.contextPath}/web/consult/goConsultList.do";
			frm.submit();
		});
		/* 
		var inHei = window.innerHeight;
		$(".hkkresult").css("height", inHei-380);
		$(".hkkresult").css("overflow-y", "auto");
		 */
		$(window).resize(function() {
			/* 
			var inHei = window.innerHeight;
			$(".hkkresult").css("height", inHei-240);
			$(".hkkresult").css("overflow-y", "auto");
			 */
		});

		// 자문 유형 변경 저장 버튼 클릭
	    $('#consultTypeSaveBtn').click(function() {
	        const selected = $('#consultTypeSelect').val();
	        const id = consultid;
			
	        if(confirm("자문 유형을 저장 하시겠습니까?")) {
		        if (!selected) {
		        	alert('자문유형을 선택해주세요.(상관없음 제외)');
		            return;
		        }
				
				$.ajax({
					type:"POST",
					url:"${pageContext.request.contextPath}/web/consult/updateInsdOtsdTaskSe.do",
					data:{
						consultid : id
						,insd_otsd_task_se : selected
					},
					dataType:"json",
					async:false,
					success:function(result){
						alert("처리가 완료되었습니다.");
						viewReload();
					}
				});
	        }
	    });
		
	});
	
	function hwpDownload() {
		var frm = document.detailFrm;
		frm.action = "${pageContext.request.contextPath}/web/consult/consultViewMakeHwp.do";
		frm.submit();
	}
	
	//첨부파일 전체 다운로드
	function downloadAllFiles() {
		var frm = document.detailFrm;
		frm.whereFrom.value = "consult";
		frm.gbn.value = gbn;
		frm.action = "${pageContext.request.contextPath}/web/consult/downloadAllFiles.do";
		frm.submit();
	}
	
	function downFile(Pcfilename,Serverfile,folder){
		form=document.ViewForm;
		form.Pcfilename.value=Pcfilename;
		form.Serverfile.value=Serverfile;
		form.folder.value=folder;
		
		form.action="${pageContext.request.contextPath}/Download.do";
		form.submit();
	}
	function downFileYDrm(Pcfilename,Serverfile,folder){
		form=document.ViewForm;
		form.Pcfilename.value=Pcfilename;
		form.Serverfile.value=Serverfile;
		form.folder.value=folder;
		form.DRMYN.value='Y';
		
		form.action="${pageContext.request.contextPath}/Download.do";
		form.submit();
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/caseSatisWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:gbn}));
		newForm.append($("<input/>", {type:"hidden", name:"TRGT_PST_MNG_NO", value:"<%=cnstn_mng_no%>"}));
		newForm.append($("<input/>", {type:"hidden", name:"CNSTN_MNG_NO", value:"<%=cnstn_mng_no%>"}));
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:"<%=cnstn_mng_no%>"}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
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
	
	function setCostInfo(costid, RVW_TKCG_EMP_NO) {
		
		$.ajax({
			type:"POST",
			url : "${pageContext.request.contextPath}/web/consult/setCostInfo.do",
			data : {
				CNSTN_CST_MNG_NO : costid,
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
	
	// 답변에 대한 검토 의견 등록 화면 호출
	function consultReviewComment(checkVal) {
		
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/consultReviewCommentWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"CNSTN_MNG_NO", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"inoutcon",  value:inoutcon}));
		newForm.append($("<input/>", {type:"hidden", name:"checkVal",    value:checkVal}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	// 자문 답변  검토 의견 삭제
	function consultReviewCommentDelete() {
		var confirmMsg = "자문 답변 검토 의견 정보를 삭제 하시겠습니까?";
		
		if (confirm(confirmMsg)) {
			$.ajax({
				url: "${pageContext.request.contextPath}/web/consult/consultReviewCommentDelete.do",
				data: {
					"CNSTN_MNG_NO": consultid,
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
		newForm.append($("<input/>", {type:"hidden", name:"PK", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"schGbn", value:'C'}));
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
	
	// 의뢰자 변경 팝업 호출
	function cnstn_rqst_chang(cnstn_rqst_emp_no) {
		
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/consultRqstChangWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"consultid", value:consultid}));
		newForm.append($("<input/>", {type:"hidden", name:"inoutcon",  value:inoutcon}));
		newForm.append($("<input/>", {type:"hidden", name:"cnstn_rqst_emp_no",    value:cnstn_rqst_emp_no}));
// 		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	
	function sendSatisAlert() {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/sendSatisAlert.do",
			data:{
				CNSTN_MNG_NO : consultid,
				CNSTN_RQST_EMP_NO : "<%=cnstn_rqst_emp_no%>",
				CNSTN_RQST_EMP_NM : "<%=cnstn_rqst_emp_nm%>"
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
				url:"${pageContext.request.contextPath}/web/consult/updateKeyword.do",
				data:{
					CNSTN_MNG_NO : consultid,
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
<style>
	/* The Modal (background) */
	.modal {
		display: none; /* Hidden by default */
		position: fixed; /* Stay in place */
		z-index: 1; /* Sit on top */
		left: 0;
		top: 0;
		width: 100%; /* Full width */
		height: 100%; /* Full height */
		overflow: auto; /* Enable scroll if needed */
		background-color: rgb(0,0,0); /* Fallback color */
		background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
	}
	
	/* Modal Content/Box */
	.modal-content {
		background-color: #fefefe;
		margin: 10% auto; /* 15% from the top and centered */
		padding: 20px;
		border: 1px solid #888;
		width: 45%; /* Could be more or less, depending on screen size */
	}
</style>
<form name="ViewForm" method="post">
	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
	<input type="hidden" name="DRMYN"/>
</form>
<form name="detailFrm" id="detailFrm" method="post">
<%-- 	<input type="hidden" name="searchForm" id="searchForm" value="<%=searchForm%>"/> --%>
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="consultid"   id="consultid" value="<%=cnstn_mng_no%>"/>
	<input type="hidden" name="inoutcon"   id="inoutcon" value="<%=insd_otsd_task_se%>"/>
	<input type="hidden" name="searchForm" id="searchForm" value="<%=searchForm%>"/>
<!-- 	<input type="hidden" id="whereFrom" name="whereFrom" /> -->
<!-- 	<input type="hidden" id="gbn" name="gbn" /> -->
	<div class="subCA">
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="subTT">
				<%=cnstn_ttl%> (<%=cnstn_doc_no%>)<%if("국제".equals(cnstn_se_nm) && !"".equals(cnstn_intl_doc_no)){%>(<%=cnstn_intl_doc_no%>)<%} %>
					
				</strong>
			</div>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC right" id="test">
<%
			if("작성중".equals(prgrs_stts_se_nm)) {
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('접수대기');\">접수요청</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultEdit();\">수정</a>");
				} else if(cnstn_rqst_emp_no.equals(USERNO)){// 의뢰자
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('접수대기');\">접수요청</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultEdit();\">수정</a>");
				}
			} else if("접수대기".equals(prgrs_stts_se_nm)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('접수');\">접수</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultEdit();\">수정</a>");
				} else if(GRPCD.indexOf("Q")>-1){ // 자문팀장 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('접수');\">접수</a>");
// 						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultEdit();\">수정</a>"); // 수정이 가능해야할지??
				} else if(cnstn_rqst_emp_no.equals(USERNO)){// 의뢰자
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('작성중');\">접수취소</a>");
				}
			} else if("취소요청".equals(prgrs_stts_se_nm)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
// 						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('자문취소');\">접수취소승인</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('작성중');\">접수취소승인</a>");
				} else if(GRPCD.indexOf("Q")>-1){ // 자문팀장 권한
// 						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('자문취소');\">접수취소승인</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('작성중');\">접수취소승인</a>");
				} else if(GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1){ // 자문팀 권한(접수? 권한?)
// 						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('자문취소');\">접수취소승인</a>"); 자문팀도 취소승인하는 권한이 있어야 할지
				}
			} else if("철회".equals(prgrs_stts_se_nm)){ // 자문 취소상태인거는 어떻게 해야할지 철회로 해야할지
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한

				}
			} else if("접수".equals(prgrs_stts_se_nm)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectConsultEmp();\">자문팀담당자지정</a>");
					if("O".equals(insd_otsd_task_se)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectConsultRvwTkcg();\">자문답변자지정</a>");
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('외부검토중');\">자문답변자지정완료</a>");
					}
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('취소요청');\">접수취소요청</a>");
				} else if(GRPCD.indexOf("Q")>-1){ // 자문팀장 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectConsultEmp();\">자문팀담당자지정</a>");
					if("O".equals(insd_otsd_task_se)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"selectConsultRvwTkcg();\">자문답변자지정</a>");
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('외부검토중');\">자문답변자지정완료</a>");
					}
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('취소요청');\">접수취소요청</a>");
				} else if(cnstn_rqst_emp_no.equals(USERNO)){// 의뢰자
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('취소요청');\">접수취소요청</a>");
				}
			} else if("내부검토중".equals(prgrs_stts_se_nm)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					if(opinionlist.size() < consultLawyerList.size()) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultAnswer('');\">답변등록</a>");
					}
				} else if(cnstn_tkcg_emp_no.equals(USERNO)){ // 자문 담당자
// 						if("I".equals(insd_otsd_task_se)){
// 							}else{
// 								out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('팀장결재중');\">팀장결재요청</a>");
// 						}
					if(opinionlist.size() < consultLawyerList.size()) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultAnswer('');\">답변등록</a>");
					}
				}
			} else if("외부검토중".equals(prgrs_stts_se_nm)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					if(opinionlist.size() < consultLawyerList.size()) {
//	 						if(opinionlist.size() < 1) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultAnswer('');\">답변등록</a>");
					}
				} else if(GRPCD.indexOf("Q")>-1){ // 자문팀장 권한
					
				} else if(GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1){ // 자문팀 권한(접수? 권한?)

				} else if(cnstn_tkcg_emp_no.equals(USERNO)){ // 자문 담당자

				}
			} else if("답변완료".equals(prgrs_stts_se_nm)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					if("O".equals(insd_otsd_task_se)){
						if("".equals(cnstn_ans_rvw_opnn_cn)){
							out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultReviewComment('');\">답변 검토 의견 등록</a>");
						} else{
							out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('팀장결재중');\">팀장결재요청</a>");
						}
					}
					if(opinionlist.size() < consultLawyerList.size()) {
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultAnswer('');\">답변등록</a>");
					}
				} else if(cnstn_tkcg_emp_no.equals(USERNO)){ // 자문 담당자
					if("O".equals(insd_otsd_task_se)){
						if("".equals(cnstn_ans_rvw_opnn_cn)){
							out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultReviewComment('');\">답변 검토 의견 등록</a>");
						} else{
							out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('팀장결재중');\">팀장결재요청</a>");
						}
					}

				}
			} else if("팀장결재중".equals(prgrs_stts_se_nm)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('과장결재중');\">승인</a>");
//	 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"rejectWrite('0','답변중');\">반려</a>");
					if("O".equals(insd_otsd_task_se)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('외부검토중');\">반려</a>");
					} else{
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('내부검토중');\">반려</a>");
						
					}
				} else if(GRPCD.indexOf("Q")>-1){ // 자문팀장 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('과장결재중');\">승인</a>");
//	 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"rejectWrite('0','답변중');\">반려</a>");
					if("O".equals(insd_otsd_task_se)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('외부검토중');\">반려</a>");
					} else{
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('내부검토중');\">반려</a>");
						
					}
				}
			} else if("과장결재중".equals(prgrs_stts_se_nm)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('만족도평가필요');\">승인</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('완료');\">승인</a>");
//	 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"rejectWrite('0','답변중');\">반려</a>");
					if("O".equals(insd_otsd_task_se)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('외부검토중');\">반려</a>");
					} else{
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('내부검토중');\">반려</a>");
						
					}
				} else if(GRPCD.indexOf("G")>-1){ // 과장 권한
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('만족도평가필요');\">승인</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('완료');\">승인</a>");
//	 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"rejectWrite('0','답변중');\">반려</a>");
					if("O".equals(insd_otsd_task_se)){
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('외부검토중');\">반려</a>");
					} else{
						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultStateChange('내부검토중');\">반려</a>");
						
					}
				}
			} else if("만족도평가필요".equals(prgrs_stts_se_nm)){
				if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"satisfactionPop('N');\">만족도평가</a>");
				} else if(cnstn_rqst_emp_no.equals(USERNO)){// 의뢰자
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"satisfactionPop('N');\">만족도평가</a>");
				} else if(cnstn_rqst_dept_no.equals(DEPTCD)){// 의뢰부서
// 						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"satisfactionPop('N');\">만족도평가</a>") // 부서에서 할 수 있게 해야하나?
				}
			} else if("완료".equals(prgrs_stts_se_nm)){
					if(GRPCD.indexOf("Y")>-1){ // 관리자 권한
// 						out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultRole();\">열람권한관리</a>"); //의뢰자 정보 수정기능으로 바꿈
						
						if ("N".equals(DGSTFN_RSPNS_YN) && "O".equals(insd_otsd_task_se)) {
							out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"sendSatisAlert();\">만족도평가요청</a>");
						}
						
					}
					out.println("<a href=\"#none\" class=\"sBtn type1\" id=\"btnSatisListView\" onclick=\"satisListToggle();\">만족도평가내역  ▼</a>");
// 					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultDelete();\">삭제</a>"); // 삭제 어디어디 존재해야하나
			}
			if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1){ // 관리자 권한
				out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"goSchCasePop();\">관련문서 관리</a>");
				if(!"작성중".equals(prgrs_stts_se_nm) && !"접수대기".equals(prgrs_stts_se_nm)){
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"cnstn_rqst_chang('"+cnstn_rqst_emp_no+"');\">의뢰자 변경</a>");
					out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultDelete();\">삭제</a>");
				}
			}
			out.println("<a href=\"#none\" class=\"sBtn type1\" onclick=\"consultList();\">목록</a>");
%>
			</div>
		</div>
		<div class="hkkresult">
			<hr class="margin40">
			<strong class="subST">자문 의뢰</strong>
<%
	if((GRPCD.indexOf("Y")>-1)){
%>
			<div class="subBtnC right" style='font-size:13px;'>
				진행상태 변경	:
				<select id="chgState" style="background:#f1f4f7;line-height:40px; margin-right: 15px;" onchange="setAdmChgState(this.value);">
					<option value="작성중"         <%if("작성중".equals(prgrs_stts_se_nm))         out.println("selected");%>>작성중</option>
					<option value="접수대기"       <%if("접수대기".equals(prgrs_stts_se_nm))       out.println("selected");%>>접수대기</option>
					<option value="취소요청"       <%if("취소요청".equals(prgrs_stts_se_nm))       out.println("selected");%>>취소요청</option>
					<option value="자문취소"       <%if("자문취소".equals(prgrs_stts_se_nm))       out.println("selected");%>>자문취소</option>
					<option value="접수"           <%if("접수".equals(prgrs_stts_se_nm))           out.println("selected");%>>접수</option>
					<option value="내부검토중"         <%if("내부검토중".equals(prgrs_stts_se_nm))         out.println("selected");%>>내부검토중</option>
				<%
				if("O".equals(insd_otsd_task_se)){
				%>
					<option value="외부검토중"         <%if("외부검토중".equals(prgrs_stts_se_nm))         out.println("selected");%>>외부검토중</option>
					<option value="답변완료"       <%if("답변완료".equals(prgrs_stts_se_nm))       out.println("selected");%>>답변완료</option>
				<%
				}
				%>
					<option value="팀장결재중"   <%if("팀장결재중".equals(prgrs_stts_se_nm))   out.println("selected");%>>팀장결재중</option>
					<option value="과장결재중"   <%if("과장결재중".equals(prgrs_stts_se_nm))   out.println("selected");%>>과장결재중</option>
<%-- 					<option value="만족도평가필요" <%if("만족도평가필요".equals(prgrs_stts_se_nm)) out.println("selected");%>>만족도평가필요</option> --%>
					<option value="완료"           <%if("완료".equals(prgrs_stts_se_nm))           out.println("selected");%>>완료</option>
				</select>
				
				공개/비공개 설정	: 
				<select id="openyn" style="background:#f1f4f7;line-height:40px;" onchange="setAdmChgOpenyn(this.value);">
					<option value="Y" <%if("Y".equals(rls_yn) || rls_yn.equals("")) out.println("selected");%>>부서공개</option>
					<option value="N" <%if("N".equals(rls_yn)) out.println("selected");%>>비공개</option>
				</select>
			</div>
<%
	}
%>
			<div class="innerB" >
				<table class="infoTable write" style="width: 100%">
					<colgroup>
						<col style="width:13%;">
						<col style="width:20%;">
						<col style="width:10%;">
						<col style="width:23%;">
						<col style="width:10%;">
						<col style="width:24%;">
					</colgroup>
					<tr>
						<th>의뢰부서</th>
						<td>
							<%=cnstn_rqst_dept_nm %>
						</td>
						
						<th>의뢰자</th>
						<td>
							<%=cnstn_rqst_emp_nm %>
						</td>
						
						<th>의뢰 등록일</th>
						<td>
							<%=cnstn_rqst_reg_ymd %>
						</td>
					</tr>
					<tr>
						<th>의뢰부서 최종 검토자 </th>
						<td>
						<%
							if ("과장".equals(rqst_dept_last_aprvr_jbps_nm)) {
								out.println("과장");
							} else if ("팀장".equals(rqst_dept_last_aprvr_jbps_nm)) {
								out.println("팀장");
							} else {
								out.println("미지정");
							}
						%>
						</td>
						<th>부서장</th>
						<td>
							<%=cnstn_rqst_dh_nm %>
						</td>
						<th>부서장 직위명</th>
						<td>
							<%=cnstn_rqst_dh_telno %>
						</td>
					</tr>
					<tr>
						<th>담당팀장</th>
						<td>
							<%=cnstn_rqst_dept_tmldr_nm %>
						</td>
						<th>담당팀장 행정번호</th>
						<td>
							<%=cnstn_rqst_dept_tmldr_telno %>
						</td>
						<th>담당팀장 직위명</th>
						<td>
							<%=cnstn_rqst_dept_tmldr_telno %>
						</td>
					</tr>
					<tr>
						<th>자문유형</th>
						<td>
							<%
							boolean isEmpty = (insd_otsd_task_se == null || insd_otsd_task_se.trim().isEmpty());
							 
							if (isEmpty && "접수대기".equals(prgrs_stts_se_nm) && (GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1)) { 
							%>
								<select id="consultTypeSelect">
								    <option value="">상관없음</option>
								    <option value="I">내부자문</option>
								    <option value="O">외부자문</option>
								</select>
								<a href="#none" class="innerBtn" id="consultTypeSaveBtn" style="float: none;">저장</a>
								
							<% } else {
	
								if ("O".equals(insd_otsd_task_se)) {
									out.println("외부자문");
								} else if ("I".equals(insd_otsd_task_se)) {
									out.println("내부자문");
								} else {
									out.println("상관없음");
								}
								
							}
							%>
						</td>
						<th>외부자문사유</th>
						<td>
							<%= otsd_rqst_rsn %>
						</td>
						<th>공개여부</th>
						<td>
							<%
								if("N".equals(rls_yn)) {
									out.println(" 비공개");
								} else {
									out.println(" 부서공개");
								}
							 %>
						</td>
					</tr>
					<tr>

						<th>긴급여부</th>
						<td>
						<%
							if ("N".equals(emrg_yn)) {
								out.println("일반");
							} else if ("Y".equals(emrg_yn)) {
								out.println("긴급");
							} else {
								out.println("미지정");
							}
						%>
						</td>
						<th>긴급사유</th>
						<td>
							<%=emrg_rsn%>
						</td>
						<th>진행 상태</th>
						<td>
							<%= prgrs_stts_se_nm %>

						</td>
					</tr>		
					<%
					if((GRPCD.indexOf("Y")>-1||GRPCD.indexOf("G")>-1||GRPCD.indexOf("Q")>-1||GRPCD.indexOf("J")>-1||GRPCD.indexOf("M")>-1)){
					%>	
					<tr>
						<th>접수요청일자</th>
						<td>
							<%=cnstn_rqst_ymd %>
						</td>
						<th>접수완료일자</th>
						<td>
							<%= cnstn_rcpt_ymd %>
						</td>
						
						<th>자문회신일자</th>
						<td>
							<%= cnstn_rply_ymd %>
						</td>
					</tr>
					<tr>
						<th>자문팀담당자</th>
						<td>
							<%= cnstn_tkcg_emp_nm %>
							<%
							String chrg = cnstn_tkcg_emp_nm;
							if("I".equals(insd_otsd_task_se)){
								if(prgrs_stts_se_nm.equals("접수") && (GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1)) { // 내부일때는 접수상태에서만 자문팀 담당자 변경할 수 있게 해두신 이유 여줘보기
							%>
								<a href="#none" class="innerBtn" style="height:20px;line-height:20px;" onclick="selectConsultEmp();">담당자변경</a>
							<%
								}
							} else {
								if(!prgrs_stts_se_nm.equals("완료") && !chrg.equals("") && (GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("Q")>-1)) {
	// 							if("접수대기".equals(prgrs_stts_se_nm)) {
									if(!"".equals(cnstn_tkcg_emp_no)) {
							%>
										<a href="#none" class="innerBtn" style="height:20px;line-height:20px;" onclick="selectConsultEmp();">담당자변경</a>
							<%
									}
								}
							}
// 							}
							%>
						</td>
						<th>담당고문변호사</th>
						<td>
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
						<th>
						</th>
						<td>
						</td>
					</tr>
					<tr>
						<th>자문 구분</th>
						<td>
							<%= cnstn_se_nm %>
						</td>
						<th>관리자 검색 키워드</th>
						<td>
							<div id="viewDiv">
								<%= prvt_srch_kywd_cn %>
								<a href="#none" class="innerBtn" onclick="goEditKeyword('edit');">수정</a>
							</div>
							<div id="editDiv" style="display:none;">
								<input type="text" id="PRVT_SRCH_KYWD_CN" name="PRVT_SRCH_KYWD_CN" value="<%=prvt_srch_kywd_cn%>">
								<a href="#none" class="innerBtn" onclick="goEditKeyword('save');">저장</a>
							</div>
						</td>
						<th></th>
						<td></td>
					</tr>
					<!--나중에 외부일때만 보이게s -->
					<%
					}
					%>
					<%
					if((GRPCD.indexOf("Y")>-1||GRPCD.indexOf("G")>-1||GRPCD.indexOf("Q")>-1||GRPCD.indexOf("J")>-1||GRPCD.indexOf("M")>-1|| USERNO.equals(cnstn_rqst_emp_no))){
					%>	
					<tr>
						<th >기피 변호사 및 기피사유</th>
						<td colspan="5">
							<%=excl_dmnd_jdaf_corp_nm%>
						</td>
					</tr>
					<%
					}
					%>
					<!--나중에 외부일때만 보이게e -->
					<tr>
						<th>자문 배경</th>
						<td colspan="5">
							<%= cnstn_rqst_cn %>
						</td>
					</tr>
					<tr>
						<th>자문 요지</th>
						<td colspan="5">
							<%= cnstn_rqst_subst_cn %>
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
					
					<%
					if((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("G")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1)){
					%>
					<tr>
						<th>비고</th>
						<td colspan="5">
							<%= rmrk_cn %>
						</td>
					</tr>
				    <%
				    }
				    %>					
					<tr>
						<th>첨부파일</th>
						<td colspan="5">
							<ul class="fileList">
							<% if(confileList != null & confileList.size()>0){ %>
<%-- 								<% if ( confileList.size() > 1 ) { %> --%>
<!-- 								<li style="padding-bottom: 10px;"> -->
<!-- 									<a href="#" onclick="downloadAllFiles('makezip1')"><span style="color: blue; font-weight: bold;">첨부파일 전체 다운로드</span></a> -->
<!-- 								</li> -->
<%-- 								<% } %> --%>
								<%
								for(int i=0; i<confileList.size();i++){
									HashMap consultFile = (HashMap)confileList.get(i);
								%>
								<li>
									<a href="#" onclick="downFile('<%=consultFile.get("DWNLD_FILE_NM") %>','<%=consultFile.get("SRVR_FILE_NM") %>','CONSULT')">
										<%=consultFile.get("DWNLD_FILE_NM")%> (<%=consultFile.get("VIEW_SZ").toString()%>)
									</a>
								</li>
								<% } %>
							<% } %>
							</ul>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div id="consultGianTable"></div>
		<hr class="margin40">
<%
		//if ((USERNO.equals(writerempno) || USERNO.equals(chrgempno)) && ("접수".equals(statcd) || "답변중".equals(statcd) || "팀장승인대기".equals(statcd)) && "P".equals(ISDEVICE)) {
		if ((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("G")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1 || USERNO.equals(cnstn_rqst_emp_no) || USERNO.equals(cnstn_tkcg_emp_no)) && (!prgrs_stts_se_nm.equals("작성중") && !prgrs_stts_se_nm.equals("접수대기") && !prgrs_stts_se_nm.equals("취소요청"))) {
%>
		<strong class="subTT">자문 메모</strong>
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
				<strong class="subTT">자문 답변</strong>
			</div>
		</div>
		<div class="innerB">
<%
		if(((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("G")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1) && !"완료".equals(prgrs_stts_se_nm)) || "완료".equals(prgrs_stts_se_nm)){
			for(int i=0; i<opinionlist.size(); i++) {
				HashMap chckMap = (HashMap)opinionlist.get(i);
				
				String ansResult = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
				String ansChckid = chckMap.get("RVW_OPNN_MNG_NO")==null?"":chckMap.get("RVW_OPNN_MNG_NO").toString();
				String ansCont = chckMap.get("RVW_OPNN_CN")==null?"":chckMap.get("RVW_OPNN_CN").toString();
				String ansCont2 = chckMap.get("RMRK_CN")==null?"":chckMap.get("RMRK_CN").toString();
				String rvw_opnn_cmptn_yn = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
				
				String CST_PRGRS_STTS_SE = chckMap.get("CST_PRGRS_STTS_SE")==null?"R":chckMap.get("CST_PRGRS_STTS_SE").toString();
				String CNSTN_CST_MNG_NO = chckMap.get("CNSTN_CST_MNG_NO")==null?"":chckMap.get("CNSTN_CST_MNG_NO").toString();
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
			if ("완료".equals(prgrs_stts_se_nm) && !CNSTN_CST_MNG_NO.equals("")) {
			%>
					<tr>
						<th>자문료</th>
						<td>
							<%=chckMap.get("CNSTN_CST_AMT")==null?"":chckMap.get("CNSTN_CST_AMT").toString()%>
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
							<select name="CST_PRGRS_STTS_SE_<%=CNSTN_CST_MNG_NO%>" id="CST_PRGRS_STTS_SE_<%=CNSTN_CST_MNG_NO%>">
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
							<input type="text" class="datepick" id="CST_APRV_YMD_<%=CNSTN_CST_MNG_NO%>" name="CST_APRV_YMD_<%=CNSTN_CST_MNG_NO%>" style="width: 80px;" value="<%=chckMap.get("CST_APRV_YMD")==null?"":chckMap.get("CST_APRV_YMD").toString()%>">
						</td>
						<th>지급일자</th>
						<td>
							<input type="text" class="datepick" id="CST_GIVE_YMD_<%=CNSTN_CST_MNG_NO%>" name="CST_GIVE_YMD_<%=CNSTN_CST_MNG_NO%>" style="width: 80px;" value="<%=chckMap.get("CST_GIVE_YMD")==null?"":chckMap.get("CST_GIVE_YMD").toString()%>">
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
				if("O".equals(insd_otsd_task_se)){				
			%>
					<tr>
						<td colspan="6">법무법인이 자문료 청구정보를 등록하지 않았습니다.</td>
					</tr>
			<%
				}
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
									<a href="#none" onclick="downFileYDrm('<%=chckFile.get("DWNLD_FILE_NM") %>','<%=chckFile.get("SRVR_FILE_NM") %>','CONSULT')">
										<%=chckFile.get("DWNLD_FILE_NM")%> (<%=chckFile.get("VIEW_SZ").toString()%>)
									</a>
									<%
									if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("G")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1){
									%>
									<a href="#none" class="innerBtn" style="height:20px;line-height:20px;float: none;" onclick="downFile('<%=chckFile.get("DWNLD_FILE_NM") %>','<%=chckFile.get("SRVR_FILE_NM") %>','CONSULT')">평문다운로드</a>
									<%
									}
									%>
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
				if(("외부검토중".equals(prgrs_stts_se_nm) || "내부검토중".equals(prgrs_stts_se_nm) || "답변완료".equals(prgrs_stts_se_nm)) && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("J") > -1 || GRPCD.indexOf("M")>-1)) {
					
					if(!"Y".equals(rvw_opnn_cmptn_yn)){
						if("I".equals(insd_otsd_task_se)){
%>
							<a href="#none" class="sBtn type1" onclick="setAnsResult('<%=ansChckid%>');">팀장결재요청</a>
<%
						}else if("O".equals(insd_otsd_task_se)){
							if(!"Y".equals(rvw_opnn_cmptn_yn)){
%>
							<a href="#none" class="sBtn type1" onclick="setAnsResult('<%=ansChckid%>');">답변 완료</a>
<%
							}
						}
					}
%>					
					<a href="#none" class="sBtn type1" onclick="consultAnswer('<%=chckMap.get("RVW_OPNN_MNG_NO") %>');">답변 수정</a>
					<a href="#none" class="sBtn type1" onClick="consultAnswerDelete('<%=chckMap.get("RVW_OPNN_MNG_NO") %>', '<%=chckMap.get("RVW_TKCG_MNG_NO")%>')">답변 삭제</a>
<%
				} else if ("완료".equals(prgrs_stts_se_nm) && (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("J") > -1 || GRPCD.indexOf("K")>-1) && !CNSTN_CST_MNG_NO.equals("") && !CST_PRGRS_STTS_SE.equals("E")) {
%>
					<a href="#none" class="sBtn type1" onclick="setCostInfo('<%=CNSTN_CST_MNG_NO%>', '<%=RVW_TKCG_EMP_NO%>');">비용정보 저장</a>
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
					<th>의뢰하신 자문 의뢰를 처리중입니다.<br/><br/>자문이 완료 된 후 답변을 확인하세요.</th>
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
		if((!"작성중".equals(prgrs_stts_se_nm) && !"접수대기".equals(prgrs_stts_se_nm) && !"접수".equals(prgrs_stts_se_nm) && !"외부검토중".equals(prgrs_stts_se_nm)) && (GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("G")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1)){
%>
		<hr class="margin10">
		<div class="innerB" id="resultState">
			<strong class="subST">검토 의견</strong>
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
<!-- 					<td colspan="5"> -->
<!-- 						<textarea id="DLBR_DCS_CN" name="DLBR_DCS_CN" rows="8" cols=""></textarea> -->
<!-- 						<a href="#none" class="innerBtn" onclick="saveContInfo();">저장</a> -->
<!-- 					</td> -->
					<td colspan="5">
						<%= cnstn_ans_rvw_opnn_cn %>
					</td>
				</tr>
				<tr>
					<th>검토 의견 - 첨부파일</th>
					<td colspan="5">
						<ul class="fileList">
						<% if(reviewCommentFileList != null & reviewCommentFileList.size()>0){ %>
<%-- 								<% if ( confileList.size() > 1 ) { %> --%>
<!-- 								<li style="padding-bottom: 10px;"> -->
<!-- 									<a href="#" onclick="downloadAllFiles('makezip1')"><span style="color: blue; font-weight: bold;">첨부파일 전체 다운로드</span></a> -->
<!-- 								</li> -->
<%-- 								<% } %> --%>
							<%
							for(int i=0; i<reviewCommentFileList.size();i++){
								HashMap reviewCommentFile = (HashMap)reviewCommentFileList.get(i);
							%>
							<li>
								<a href="#none" onclick="downFileYDrm('<%=reviewCommentFile.get("DWNLD_FILE_NM") %>','<%=reviewCommentFile.get("SRVR_FILE_NM") %>','CONSULT')">
									<%=reviewCommentFile.get("DWNLD_FILE_NM")%> (<%=reviewCommentFile.get("VIEW_SZ").toString()%>)
								</a>
								<%
								if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("G")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1){
								%>
								<a href="#none" class="innerBtn" style="height:20px;line-height:20px;float: none;" onclick="downFile('<%=reviewCommentFile.get("DWNLD_FILE_NM") %>','<%=reviewCommentFile.get("SRVR_FILE_NM") %>','CONSULT')">평문다운로드</a>
								<%
								}
								%>
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
			if(!"".equals(cnstn_ans_rvw_opnn_cn) && (USERNO.equals(cnstn_tkcg_emp_no) || (GRPCD.indexOf("Y") > -1)) && "답변완료".equals(prgrs_stts_se_nm) ){
%>
				<a href="#none" class="sBtn type1" onclick="consultReviewComment('rcModi');">수정</a>
				<a href="#none" class="sBtn type1" onClick="consultReviewCommentDelete()">삭제</a>
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
		if ((USERNO.equals(cnstn_rqst_emp_no) || USERNO.equals(cnstn_tkcg_emp_no))&& (prgrs_stts_se_nm.equals("내부검토중") || prgrs_stts_se_nm.equals("외부검토중") || prgrs_stts_se_nm.equals("답변완료") || prgrs_stts_se_nm.equals("팀장결재중") || prgrs_stts_se_nm.equals("과장결재중") || prgrs_stts_se_nm.equals("완료"))) {
%>
		<!-- 
		<strong class="subTT">자문 답변 반려 내용</strong>
		<hr class="margin10">
		<div class="innerB">
			<div id="consultProgGrid2"></div>
			<div class="subBtnW side">
			</div>
		</div>
		 -->
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
						<th style="text-align: center;">구분</th>
						<th style="text-align: center;">평가 유형</th>
						<th style="text-align: center;">평가 결과</th>
						<th style="text-align: center;">평가 점수</th>
						<th style="text-align: center;">법무법인</th>
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
</form>