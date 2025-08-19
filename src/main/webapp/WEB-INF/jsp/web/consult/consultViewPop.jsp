<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>
<%@page import="java.text.DecimalFormat"%>
<%
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
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String filePath = request.getParameter("filePath")==null?"":request.getParameter("filePath").toString();
	
	/* 자문 요청 내용 */
	//	String consultid   = consult.get("CONSULTID")==null?"":consult.get("CONSULTID").toString();
	//	String title       = consult.get("TITLE")==null?"":consult.get("TITLE").toString();
	//	String statcd      = consult.get("STATCD")==null?"":consult.get("STATCD").toString();
	//	String inoutcon    = consult.get("INOUTCON")==null?"":consult.get("INOUTCON").toString();
	//	String writerempno = consult.get("WRITEREMPNO")==null?"":consult.get("WRITEREMPNO").toString();
	//	String chrgempnm   = consult.get("CHRGEMPNM")==null?"":consult.get("CHRGEMPNM").toString();
	//	String chrgempno   = consult.get("CHRGEMPNO")==null?"":consult.get("CHRGEMPNO").toString();
	//	String outreqdt    = consult.get("OUTREQDT")==null?"":consult.get("OUTREQDT").toString();
	//	String openyn      = consult.get("OPENYN")==null?"":consult.get("OPENYN").toString();
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
	
	//	for(int a=0; a<agreelist.size(); a++) {
	//		HashMap aMap = (HashMap) agreelist.get(a);
	//		String aGbn = aMap.get("GBN")==null?"":aMap.get("GBN").toString();
		
	//		if ( "MAPP".equals(aGbn) ){
	//			teamA = aMap.get("USER_ID")==null?"":aMap.get("USER_ID").toString();
	//		} else if ( "TAPP".equals(aGbn) ){
	//			teamB = aMap.get("USER_ID")==null?"":aMap.get("USER_ID").toString();
	//		}
	//	}
	
	String oldno = consult.get("OLDCONSULTNO")==null?"":consult.get("OLDCONSULTNO").toString();
	
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
%>
<style>
.infoTable.write th {
	background: #d6d9dc;
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
</script>
<form name="detailFrm" id="detailFrm" method="post">
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="consultid"   id="consultid" value="<%=cnstn_mng_no%>"/>
	<input type="hidden" name="inoutcon"   id="inoutcon" value="<%=insd_otsd_task_se%>"/>
</form>
	<div class="subCA">
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="subTT">
					<%=cnstn_ttl%> (<%=cnstn_doc_no%>)
				</strong>
			</div>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC right" id="test">
			<%
				if("완료".equals(prgrs_stts_se_nm)) {
					out.println("<a href=\"#none\" class=\"sBtn type1\" id=\"btnSatisListView\" onclick=\"satisListToggle();\">만족도평가내역  ▼</a>");
				}
			%>
			</div>
		</div>
		<div class="hkkresult">
			<hr class="margin40">
			<strong class="subST">자문상세 내용</strong>
			<div class="innerB" >
				<table class="infoTable write" style="width: 100%">
					<colgroup>
							<col style="width:15%;">
							<col style="width:*;">
							<col style="width:15%;">
							<col style="width:*;">
							<col style="width:15%;">
							<col style="width:*;">
						</colgroup>
						<tr>
							<th>의뢰부서</th>
							<td>
								<%=cnstn_rqst_dept_nm %>
							</td>
							
							<th>의뢰인</th>
							<td>
								<%=cnstn_rqst_emp_nm %>
							</td>
							
							<th>의뢰 등록일</th>
							<td>
								<%=cnstn_rqst_reg_ymd %>
							</td>
						</tr>
						<tr>
							<th>의뢰부서 최종결재자 </th>
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
							<th>의뢰부서 책임자 (팀/과장)</th>
							<td>
								<%=cnstn_rqst_dept_tmldr_nm %>
							</td>
							<th>자문유형</th>
							<td>
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
							</td>
						</tr>
						<tr>
							<th>자문요청일자</th>
							<td>
								<%=cnstn_rqst_ymd %>
							</td>
							
							<th>자문회신<br/>희망일자</th>
							<td>
								<%=cnstn_hope_rply_ymd %>
							</td>
							
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
						</tr>
						<tr>
							<th>자문팀담당자</th>
							<td>
								<%= cnstn_tkcg_emp_nm %>
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
							<th>자문검토담당자</th>
							<td>
								<%
								if(consultLawyerList.size() > 0) {
									for(int i=0; i<consultLawyerList.size(); i++) {
										HashMap lawMap = (HashMap)consultLawyerList.get(i);
								%>
								<div><%=lawMap.get("JDAF_CORP_NM")==null?"":lawMap.get("JDAF_CORP_NM").toString()%> <%=lawMap.get("RVW_TKCG_EMP_NM")==null?"":lawMap.get("RVW_TKCG_EMP_NM").toString()%></div>
								<%
									}
								}
								%>
							</td>
							<th colspan="4"></th>
						</tr>
						<tr>
							<th>외부의뢰사유</th>
							<td colspan="5">
								<%= otsd_rqst_rsn %>
							</td>
						</tr>
						<tr>
							<th>관리자 검색 키워드</th>
							<td colspan="5">
								<%= prvt_srch_kywd_cn %>
							</td>
						</tr>
						<tr>
							<th>진행 상태</th>
							<td colspan="5">
								<%= prgrs_stts_se_nm %>
							</td>
						</tr>
						<tr>
							<th>자문 의뢰 내용</th>
							<td colspan="5">
								<%= cnstn_rqst_cn %>
							</td>
						</tr>
						<tr>
							<th>자문 의뢰 요지 내용</th>
							<td colspan="5">
								<%= cnstn_rqst_subst_cn %>
							</td>
						</tr>
						<tr>
							<th>비고 내용</th>
							<td colspan="5">
								<%= rmrk_cn %>
							</td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td colspan="5">
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
							</td>
						</tr>
				</table>
			</div>
		</div>
		<hr class="margin20">
		
		<hr class="margin40">
<%
		if ((USERNO.equals(cnstn_rqst_emp_no) || USERNO.equals(cnstn_tkcg_emp_no)) && (!prgrs_stts_se_nm.equals("작성중") && !prgrs_stts_se_nm.equals("접수대기") && !prgrs_stts_se_nm.equals("취소요청")&& !prgrs_stts_se_nm.equals("내부결재중")) && "P".equals(ISDEVICE)) {
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
		if(
			((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("K")>-1) && !prgrs_stts_se_nm.equals("완료")) ||
			"완료".equals(prgrs_stts_se_nm)
		){
			for(int i=0; i<opinionlist.size(); i++) {
				HashMap chckMap = (HashMap)opinionlist.get(i);
				
				String ansResult = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
				String ansChckid = chckMap.get("RVW_OPNN_MNG_NO")==null?"":chckMap.get("RVW_OPNN_MNG_NO").toString();
				String ansCont = chckMap.get("RVW_OPNN_CN")==null?"":chckMap.get("RVW_OPNN_CN").toString();
				String ansCont2 = chckMap.get("RMRK_CN")==null?"":chckMap.get("RMRK_CN").toString();
				String rvw_opnn_cmptn_yn = chckMap.get("RVW_OPNN_CMPTN_YN")==null?"":chckMap.get("RVW_OPNN_CMPTN_YN").toString();
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
					<tr>
						<th>자문료</th>
						<td>(예시)400,000</td>
						<th>처리현황</th>
						<td>(예시)지급완료</td>
						<th>지급일자</th>
						<td>(예시)2025-12-31</td>
					</tr>
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
						</td>
					</tr>
				</table>
				<hr class="margin10">
				<div style="text-align:right;">
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
