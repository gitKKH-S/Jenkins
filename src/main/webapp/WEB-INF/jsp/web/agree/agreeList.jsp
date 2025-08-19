<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%
	int pageSize = 20;
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String OPENYN = "Y";
	if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("A")>-1) {
		OPENYN = "N";
	}
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
	
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String gbnid = request.getParameter("gbnid")==null?"":request.getParameter("gbnid").toString();
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/mten.static.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/mten.util.js"></script>
<script>
	var gbnid = "<%=gbnid%>";
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	var gMinus = 300;
	
	$(document).ready(function(){
		$(".subSch").css("display", "none");
		
		if (MENU_MNG_NO != "100000594") {
			$("#typecdnm").append($("#subTT").html());
			$("#CVTN_CTRT_TYPE_CD_NM").val($("#subTT").html());
		}
		
		if (gbnid != "") {
			gotoview(gbnid);
		}
		
		$("#sBtn").click(function(){
			var obj = gridStore.baseParams;
			var searchForm = "";
			for(var key in obj){
				searchForm = searchForm + "," + (key+"|"+obj[key]);
			}
			$("#searchForm").val(searchForm);
			
			var frm = document.goList;
			$("#agreeid").val('');
			frm.action = "${pageContext.request.contextPath}/web/agree/agreeWritePage.do";
			frm.submit();
		});
	});
	
	var gridStore;
	Ext.QuickTips.init();
	Ext.onReady(function(){
		$("#start").val(0);
		<%
		for(int i=0; i<sf.length; i++){
			System.out.println("searchForm===>"+sf[i]);
			String setv[] = sf[i].split("\\|");
			if(setv.length == 2){
			System.out.println("setv[0]===>"+setv[0]);
		%>
			if('<%=setv[0]%>' == "INSD_OTSD_TASK_SE" || '<%=setv[0]%>' == "RFLT_YN_RSLT_REG_YN" || '<%=setv[0]%>' == "EMRG_YN"){
				$("input:radio[name='<%=setv[0]%>']:radio[value='" + "<%=setv[1]%>" + "']").prop("checked", true);
			} else {
				$("#<%=setv[0]%>").val('<%=setv[1]%>');
			}
		<%
				if (!setv[0].equals("openyn") && !setv[0].equals("start") && !setv[0].equals("pagesize") && !setv[0].equals("MENU_MNG_NO")) {
		%>
					$(".downBtn").css("display", "none");
					$(".upBtn").css("display", "");
					$(".subSch").css("display", "");
					gMinus = 410;
		<%
				}
			}
		}
		%>
		
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			  {name:'CVTN_MNG_NO'},					//협약관리번호
			, {name:'MENU_MNG_NO'}					//메뉴관리번호
			, {name:'CVTN_DOC_NO'}					//협약문서번호
			, {name:'CVTN_INTL_DOC_NO'}				//협약국제문서번호
			, {name:'PRGRS_STTS_SE_NM'}				//진행상태구분명
			, {name:'RLS_YN'}						//공개여부
			, {name:'INSD_OTSD_TASK_SE'}			//내부외부업무구분
			, {name:'OTSD_RQST_RSN'}				//외부의뢰사유
			, {name:'CVTN_CTRT_TYPE_CD_NM'}			//협약계약유형코드명
			, {name:'CVTN_TTL'}						//협약제목
			, {name:'CVTN_RQST_EMP_NO'}				//협약의뢰직원번호
			, {name:'CVTN_RQST_EMP_NM'}				//협약의뢰직원명
			, {name:'CVTN_RQST_DEPT_NO'}			//협약의뢰부서번호
			, {name:'CVTN_RQST_DEPT_NM'}			//협약의뢰부서명
			, {name:'CVTN_RQST_REG_YMD'}			//협약의뢰등록일자
			, {name:'CVTN_RQST_YMD'}				//협약의뢰일자
			, {name:'CVTN_RQST_CN'}					//협약의뢰내용
			, {name:'CVTN_SRNG_DMND_CN'}			//협약심사요청내용
			, {name:'RMRK_CN'}						//비고내용
			, {name:'CVTN_HOPE_RPLY_YMD'}			//협약희망회신일자
			, {name:'CVTN_RCPT_YMD'}				//협약접수일자
			, {name:'CVTN_TKCG_EMP_NO'}				//협약담당직원번호
			, {name:'CVTN_TKCG_EMP_NM'}				//협약담당직원명
			, {name:'CVTN_RPLY_YMD'}				//협약회신일자
			, {name:'CVTN_CMPTN_YMD'}				//협약완료일자
			, {name:'PRVT_SRCH_KYWD_CN'}			//비공개검색키워드내용
			, {name:'RFLT_YN_RSLT_REG_YN'}			//반영여부결과등록여부
			, {name:'RFLT_YN_RSLT_WRTR_EMP_NO'}		//반영여부결과작성직원번호
			, {name:'RFLT_YN_RSLT_WRTR_EMP_NM'}		//반영여부결과작성직원명
			, {name:'RFLT_YN_RSLT_REG_YMD'}			//반영여부결과등록일자
			, {name:'RFLT_YN_RSLT_TTL'}				//반영여부결과제목
			, {name:'RFLT_YN_RSLT_CN'}				//반영여부결과내용
			, {name:'DEL_YN'}						//삭제여부
			, {name:'WRTR_EMP_NM'}					//작성직원명
			, {name:'WRTR_EMP_NO'}					//작성직원번호
			, {name:'WRT_YMD'}						//작성일자
			, {name:'WRT_DEPT_NM'}					//작성부서명
			, {name:'WRT_DEPT_NO'}					//작성부서번호
			, {name:'MDFCN_EMP_NM'}					//수정직원명
			, {name:'MDFCN_EMP_NO'}					//수정직원번호
			, {name:'MDFCN_YMD'}					//수정일자
			, {name:'MDFCN_DEPT_NM'}				//수정부서명
			, {name:'MDFCN_DEPT_NO'}				//수정부서번호
			, {name:'EXCL_DMND_JDAF_CORP_NM'}		//제외요청법무법인명
			, {name:'JDAF_CORP_NMS'}		//외부변호사정보
			, {name:'MANAGER_DEPT_NM'}		//부서 실국명
		]);
		
		gridStore = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
					url: "${pageContext.request.contextPath}/web/agree/selectAgreeList.do"
			}),
			remoteSort:true,
			reader: new Ext.data.JsonReader({root: 'result', totalProperty: 'total', idProperty: 'CVTN_MNG_NO'},myRecordObj),
			pageSize: 25,
			listeners:{
				load:function(store, records, success) {
					$("#gcnt").text(store.getTotalCount());
					$("#gcnt").number(true);
				}
			}
		});

		var combo = new Ext.form.ComboBox({
			name : 'perpage',
			width: 40,
			store: new Ext.data.ArrayStore({
				fields: ['id'],
				data  : [['20'],['50'],['100']]
			}),
			mode : 'local',
			value: '20',
			listWidth     : 40,
			triggerAction : 'all',
			displayField  : 'id',
			valueField    : 'id',
			editable      : false,
			forceSelection: true,
			listeners:{
				select : function(item,newValue){
					bbar.pageSize = parseInt(newValue.get('id'), 10);
					bbar.doLoad(bbar.cursor);
					
					var newPagesize = parseInt(newValue.get('id'), 10);
					$("#pagesize").val(newPagesize);
					gridStore.pagesize = newPagesize;
					gridStore.load({
						params:{
							start:parseInt($("#start").val()),
							limit : newPagesize,
							pagesize : newPagesize
						}
					});
				},scope: this
			}
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				//new Ext.grid.RowNumberer(),//줄번호 먹이기
				{header:"<b>협약ID</b>",   width:30, align:'center', dataIndex:'CVTN_MNG_NO', hidden: true},
				{header:"<b>관리번호</b>", width:20, align:'center', dataIndex:'CVTN_DOC_NO',          sortable:true},
				{header:"<b>제목</b>",     width:50, align:'left',   dataIndex:'CVTN_TTL',             sortable:true,
					renderer: function(value, metaData, record) {	
						
						var hasPermission = true;
						
						if (record.get('RLS_YN') === 'N') {
							return '<span style="color:#999;">🔒 ' + Ext.util.Format.htmlEncode(value) + '</span>';
						}
						
						return Ext.util.Format.htmlEncode(value);
					}
					
				},
				<%if("100000594".equals(MENU_MNG_NO)) {%>
				{header:"<b>협약유형</b>", width:20, align:'center', dataIndex:'CVTN_CTRT_TYPE_CD_NM', sortable:true},
				<%}%>
// 				{header:"<b>의뢰부서</b>", width:20, align:'center', dataIndex:'CVTN_RQST_DEPT_NM',    sortable:true},
				{header:"<b>의뢰부서</b>", width:20, align:'center', dataIndex:'MANAGER_DEPT_NM',    sortable:true},
				{header:"<b>의뢰인</b>",   width:15, align:'center', dataIndex:'CVTN_RQST_EMP_NM',     sortable:true},
				{header:"<b>의뢰일</b>",   width:15, align:'center', dataIndex:'CVTN_RQST_YMD',        sortable:true},
				{header:"<b>담당자</b>",   width:15, align:'center', dataIndex:'CVTN_TKCG_EMP_NM',     sortable:true,
					renderer: function(value, metaData, record) {
						var display = Ext.util.Format.htmlEncode(value || '');
						var hasPermission = true; // 실제 권한 판단 로직 필요
						var isOutsourced = record.get('INSD_OTSD_TASK_SE') === 'O';
						var reviewerNames = record.get('JDAF_CORP_NMS') || '';
						
						if (hasPermission && isOutsourced && reviewerNames) {
					        // 쉼표 → 줄바꿈. HTML 특수문자 인코딩 후 <br/> 처리
					        var tooltip = Ext.util.Format.htmlEncode(reviewerNames).replace(/,/g, '<br/>');
					        
					        // 자동 너비 적용을 위한 감싸기 div 추가
					        tooltip = '<div style=&quot;white-space: nowrap; max-width: none;&quot;>' + tooltip + '</div>';
					        
					        // + 아이콘에만 툴팁 적용
					        return display + '&nbsp;<span class="rvw-icon" ext:qtip="' + tooltip + '" style="cursor:help; margin-left: 4px;">🔎</span>';
						}
						return display;
					}
				},
				{header:"<b>진행상태</b>", width:15, align:'center', dataIndex:'PRGRS_STTS_SE_NM',     sortable:true},
				{header:"<b>의뢰유형</b>", width:15, align:'center', dataIndex:'INSD_OTSD_TASK_SE',     sortable:true,
					renderer: function(value){
						if (value == 'I') {
							return '내부';
						} else if (value == 'O') {
							return '외부';
						} else {
							return '미정';
						}
					}
				}
			]
		});
		
		var bbar = new Ext.PagingToolbar({
			pagesize : $("#pagesize").val(),
			autoWidth : true,
			store : gridStore,
			displayInfo : true,
			items : [ '-', 'Per Page: ', combo ],
			displayMsg : '전체 {2}의 결과중 {0} - {1}',
			emptyMsg : "검색된 결과가 없습니다.",
			listeners : {
				beforechange : function(paging, page, eopts) {
					$("#start").val(0);
					$("#start").val(page.start);
				},
				change : function(thisd, params) {
					/* params.activePage
					 * params.pages
					 * params.total
					 */
					
					//pages = params.pages;
					//total = params.total;
					//activePage = params.activePage;
				}
			}
		});
		
		var grid = new Ext.grid.GridPanel({
			id : ids,
			renderTo: 'gridList',
			store: gridStore,
			width: '100%',
			autoWidth: true,
			scroll: false,
			remoteSort: true,
			/* height : $('body').height()-315, */
			autoHeight:true,
			cm: cmm,
			loadMask: {
				msg: '로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows: true,
			viewConfig:{
				forceFit:true,
				enableTextSelection:true,
				emptyText:'조회된 데이터가 없습니다.'
			},
			bbar : bbar,
			iconCls: 'icon_perlist',
			listeners: {
				rowcontextmenu:function(grid, idx, e){
					var selModel=grid.getSelectionModel();
					selModel.selectRow(idx);
					var rowData = selModel.getSelected();
					rowData.showAt(e.getXY());
				},
				rowclick:function(grid, idx, e){
					var obj = gridStore.baseParams;
					var searchForm = "";
					for(var key in obj){
						searchForm = searchForm + "," + (key+"|"+obj[key]);
					}
					$("#searchForm").val(searchForm);
					
					console.log($("#searchForm").val());
					
					var selModel= grid.getSelectionModel();
					var histData = selModel.getSelected();
					var agreeid = histData.get('CVTN_MNG_NO');
					gotoview(agreeid);
				},
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent){
					
				},
				contextmenu:function(e){
					e.preventDefault();
				},
				//cellcontextmenu : ( Grid this, Number rowIndex, Number cellIndex, Ext.EventObject e )
				cellcontextmenu:function(grid, idx, cIdx, e){
					e.preventDefault();
				}
			}
		});
		
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				start : parseInt($("#start").val()),
				pagesize : $("#pagesize").val(),
				MENU_MNG_NO : '<%=request.getParameter("MENU_MNG_NO")%>',
				CVTN_RQST_YMD1:$("#CVTN_RQST_YMD1").val(),
				CVTN_RQST_YMD2:$("#CVTN_RQST_YMD2").val(),
				CVTN_RPLY_YMD1:$("#CVTN_RPLY_YMD1").val(),
				CVTN_RPLY_YMD2:$("#CVTN_RPLY_YMD2").val(),
				CVTN_CTRT_TYPE_CD_NM:$("#CVTN_CTRT_TYPE_CD_NM").val(),
				PRVT_SRCH_KYWD_CN:$("#PRVT_SRCH_KYWD_CN").val(),
				CVTN_RQST_DEPT_NM:$("#CVTN_RQST_DEPT_NM").val(),
				CVTN_RQST_EMP_NM:$("#CVTN_RQST_EMP_NM").val(),
				CVTN_TKCG_EMP_NM:$("#CVTN_TKCG_EMP_NM").val(),
				RVW_TKCG_EMP_NM:$("#RVW_TKCG_EMP_NM").val(),
				INSD_OTSD_TASK_SE:$('input:radio[name="INSD_OTSD_TASK_SE"]:checked').val(),
				RFLT_YN_RSLT_REG_YN:$('input:radio[name="RFLT_YN_RSLT_REG_YN"]:checked').val(),
				EMRG_YN:$('input:radio[name="EMRG_YN"]:checked').val(),
				CVTN_DOC_NO:$("#CVTN_DOC_NO").val(),
				CVTN_INTL_DOC_NO:$("#CVTN_INTL_DOC_NO").val(),
				CVTN_TTL:$("#CVTN_TTL").val(),
				PRGRS_STTS_SE_NM:$("#PRGRS_STTS_SE_NM").val(),
				openyn : '<%=OPENYN%>'
			}
			<% 
			if(!(GRPCD.indexOf("P") > -1)){
			%>
			startGraph();
			<%
			}
			%>
		});
		
		gridStore.load({
			params:{
				start : parseInt($("#start").val()),
				limit : $("#pagesize").val()
			}
		});
		
		$(window).resize(function() {
			if($(".subSch").css("display") == "none"){
				gridResize(300);
			}else{
				gridResize(410);
			}
		})
		
		$(".upBtn").click(function(){
			$(".downBtn").css("display", "");
			$(".upBtn").css("display", "none");
			$(".subSch").css("display", "none");
			gridResize(300);
			goReset();
		});
		$(".downBtn").click(function(){
			$(".downBtn").css("display", "none");
			$(".upBtn").css("display", "");
			$(".subSch").css("display", "");
			gridResize(410);
		});
		
		function gridResize(minus){
			gheight = $('body').height()-minus;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		}
	});
	
	function gotoview(agreeid){
		var frm = document.goList;
		$("#CVTN_MNG_NO").val(agreeid);
		frm.action = "agreeView.do";
		frm.submit();
	}
	
	//검색 초기화
	function goReset(){
		$('select').find('option:first').attr('selected', 'selected');
		$(":text").val("");
		$(":hidden").val("");
// 		goSch();
	}
	
	function goSch(){
		$("#start").val(0);
		
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				start : parseInt($("#start").val()),
				pagesize : $("#pagesize").val(),
				MENU_MNG_NO : '<%=request.getParameter("MENU_MNG_NO")%>',
				CVTN_RQST_YMD1:$("#CVTN_RQST_YMD1").val(),
				CVTN_RQST_YMD2:$("#CVTN_RQST_YMD2").val(),
				CVTN_RPLY_YMD1:$("#CVTN_RPLY_YMD1").val(),
				CVTN_RPLY_YMD2:$("#CVTN_RPLY_YMD2").val(),
				CVTN_CTRT_TYPE_CD_NM:$("#CVTN_CTRT_TYPE_CD_NM").val(),
				PRVT_SRCH_KYWD_CN:$("#PRVT_SRCH_KYWD_CN").val(),
				CVTN_RQST_DEPT_NM:$("#CVTN_RQST_DEPT_NM").val(),
				CVTN_RQST_EMP_NM:$("#CVTN_RQST_EMP_NM").val(),
				CVTN_TKCG_EMP_NM:$("#CVTN_TKCG_EMP_NM").val(),
				RVW_TKCG_EMP_NM:$("#RVW_TKCG_EMP_NM").val(),
				INSD_OTSD_TASK_SE:$('input:radio[name="INSD_OTSD_TASK_SE"]:checked').val(),
				RFLT_YN_RSLT_REG_YN:$('input:radio[name="RFLT_YN_RSLT_REG_YN"]:checked').val(),
				EMRG_YN:$('input:radio[name="EMRG_YN"]:checked').val(),
				CVTN_DOC_NO:$("#CVTN_DOC_NO").val(),
				CVTN_INTL_DOC_NO:$("#CVTN_INTL_DOC_NO").val(),
				CVTN_TTL:$("#CVTN_TTL").val(),
				PRGRS_STTS_SE_NM:$("#PRGRS_STTS_SE_NM").val(),
				openyn : '<%=OPENYN%>'
			}
		});
		gridStore.load();
		<% 
		if(!(GRPCD.indexOf("P") > -1)){
		%>
		startGraph();
		<%
		}
		%>
	}
</script>
<body>
	<div class="subCA">
		<strong class="subTT" id="subTT"></strong>
		<form name="goList" id="goList" method="post">
		<input type="hidden" name="searchForm" id="searchForm" value=""/>
		<input type="hidden" name="pageno"/>
		<input type="hidden" name="start" id="start" value=""/>
		<input type="hidden" name="CVTN_MNG_NO"  id="CVTN_MNG_NO"/>
		<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
		<input type="hidden" name="pagesize" id="pagesize" value="<%=pageSize%>"/>
<!-- 		<input type="hidden" name="PRGRS_STTS_SE_NM" id="PRGRS_STTS_SE_NM" value=""/> -->
		<input type="hidden" name="graphHl" id="graphHl" value=""/>
		<div class="innerB">
			<table class="infoTable write" style="width:100%;">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr class="subSch">
					<th>의뢰일</th>
					<td>
						<input type="text" id="CVTN_RQST_YMD1" name="CVTN_RQST_YMD1" style="width:40%;" class="datepick" readonly="readonly"/>
						~
						<input type="text" id="CVTN_RQST_YMD2" name="CVTN_RQST_YMD2" style="width:40%;" class="datepick" readonly="readonly"/>
					</td>
					<th>답변일</th>
					<td>
						<input type="text" id="CVTN_RPLY_YMD1" name="CVTN_RPLY_YMD1" style="width:40%;" class="datepick" readonly="readonly"/>
						~
						<input type="text" id="CVTN_RPLY_YMD2" name="CVTN_RPLY_YMD2" style="width:40%;" class="datepick" readonly="readonly"/>
					</td>
				<%
					if ("100000594".equals(MENU_MNG_NO)) {
				%>
					<th>계약유형</th>
					<td>
						<select name="CVTN_CTRT_TYPE_CD_NM" id="CVTN_CTRT_TYPE_CD_NM" style="width:100%;">
							<option value="">전체</option>
							<option value="민간투자" >민간투자</option>
							<option value="민간위탁" >민간위탁</option>
							<option value="공유재산" >공유재산</option>
							<option value="임대차"   >임대차</option>
						</select>
					</td>
				<%
					} else {
				%>
					<th>계약유형</th>
					<td id="typecdnm">
						<input type="hidden" name="CVTN_CTRT_TYPE_CD_NM" id="CVTN_CTRT_TYPE_CD_NM" value=""/>
					</td>
				<%
					}
				
					if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("A")>-1 || GRPCD.indexOf("N")>-1){
				%>
					<th>협약팀 검색 키워드</th>
					<td>
						<input type="text" name="PRVT_SRCH_KYWD_CN" id="PRVT_SRCH_KYWD_CN" style="width:100%"/>
					</td>
				<%
					} else {
				%>
					<th colspan="2">
						<input type="hidden" name="PRVT_SRCH_KYWD_CN" id="PRVT_SRCH_KYWD_CN" value=""/>
					</th>
				<%
					}
				%>
				</tr>
				<tr class="subSch">
					<th>의뢰부서</th>
					<td>
						<input type="text" name="CVTN_RQST_DEPT_NM" id="CVTN_RQST_DEPT_NM" style="width:100%"/>
					</td>
					<th>의뢰인</th>
					<td>
						<input type="text" name="CVTN_RQST_EMP_NM" id="CVTN_RQST_EMP_NM" style="width:100%"/>
					</td>
					<th>담당자</th>
					<td>
						<input type="text" name="CVTN_TKCG_EMP_NM" id="CVTN_TKCG_EMP_NM" style="width:100%"/>
					</td>
					<th>고문변호사</th>
					<td>
						<input type="text" name="RVW_TKCG_EMP_NM" id="RVW_TKCG_EMP_NM" style="width:100%"/>
					</td>
				</tr>
				<tr class="subSch">
					<th>업무구분</th>
					<td>
						<label><input type="radio" name="INSD_OTSD_TASK_SE" value=""  checked>전체</label>&nbsp;
						<label><input type="radio" name="INSD_OTSD_TASK_SE" value="I">내부</label>&nbsp;
						<label><input type="radio" name="INSD_OTSD_TASK_SE" value="O">외부</label>
					</td>
					<th>반영여부 등록여부</th>
					<td>
						<label><input type="radio" name="RFLT_YN_RSLT_REG_YN" value=""  checked>전체</label>&nbsp;
						<label><input type="radio" name="RFLT_YN_RSLT_REG_YN" value="N" >미등록</label>&nbsp;
						<label><input type="radio" name="RFLT_YN_RSLT_REG_YN" value="Y" >등록</label>
					</td>
					<th>긴급여부</th>
					<td>
						<label><input type="radio" name="EMRG_YN" value="" checked>전체</label>&nbsp;
						<label><input type="radio" name="EMRG_YN" value="N" >일반</label>&nbsp;
						<label><input type="radio" name="EMRG_YN" value="Y" >긴급</label>
					</td>
					<th>진행 상태</th>
					<td>
						<select name="PRGRS_STTS_SE_NM" id="PRGRS_STTS_SE_NM" style="width:100%;">
							<option value="">전체</option>
							<option value="작성중">작성중</option>
							<option value="접수대기">접수대기</option>
							<option value="접수">접수</option>
							<option value="내부검토중">내부검토중</option>
							<option value="외부검토중">외부검토중</option>
							<option value="결재중">결재중</option>
							<option value="답변완료">답변완료</option>
<!-- 							<option value="만족도평가필요">만족도평가필요</option> -->
							<option value="완료">완료</option>
							<option value="철회">철회</option>
							<option value="진행중">진행중</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>관리번호</th>
					<td>
						<input type="text" name="CVTN_DOC_NO" id="CVTN_DOC_NO" style="width:100%"/>
					</td>
					<th>국제관리번호</th>
					<td>
						<input type="text" name="CVTN_INTL_DOC_NO" id="CVTN_INTL_DOC_NO" style="width:100%"/>
					</td>
					<th>협약내용</th>
					<td colspan="3">
						<input type="text" id="CVTN_TTL" name="CVTN_TTL" placeholder="제목, 의뢰내용, 비고 등"  style="width: 90%;">
						<a href="#none" class="upBtn" title="접기" style="display:none"></a>
						<a href="#none" class="downBtn" title="펼치기"></a>
					</td>
				</tr>
			</table>
		</div>
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="goSch();">검색</a>
			<a href="#none" class="sBtn type2" onclick="goReset();">초기화</a>
		</div>
<style>
	*{
	vertical-align:unset;
	}
	body {
/*       font-family: sans-serif; */
/*       padding: 20px; */
/*       background-color: #f8f8f8; */
    }
    .mermaid {
      background-color: #fff;
      padding: 20px;
      border-radius: 10px;
      overflow-x: auto;
      text-align: center;
    }
    .mermaidTooltip {
      display: none;
    }

	/* 노드 박스 스타일 */
	.mermaid rect {
	  fill: #f3f4f6;
	  stroke: none;
	  rx: 8;
	  ry: 8;
	}
	
 	.mermaid .edgePath path { 
 	  stroke: #0073e6 !important;
 	  stroke-width: 2px; 
 	  fill: none; 
 	}
</style>
<script src="${resourceUrl}/js/mermaid@10/mermaid.min.js"></script>
<script>
$(document).ready(function() {
	$(document).on("click","[id^='flowchart-']",function(){
		console.log('111 ::: ' , $(this).attr("title"));
		console.log('222 ::: ' , $(this).get(0).id);
		
		
		var stateCd = $(this).attr("title");
		if (stateCd == '전체') {
			$("#PRGRS_STTS_SE_NM").val('');
		} else if (stateCd == '종료') {
			$("#PRGRS_STTS_SE_NM").val('완료');
		} else {
			$("#PRGRS_STTS_SE_NM").val(stateCd);
		}
		
		var fullId = $(this).get(0).id;
		var prefix = fullId.substring(0, fullId.lastIndexOf('-')); 
		$("#graphHl").val(prefix);
		
		goSch();
	});	
	
 	mermaid.initialize({ startOnLoad: true
 				, theme: "default"  				
 	 			, themeVariables: {myPurple: "#f3f4f6", border1 : "#f3f4f6"}}); // 수동 초기화
 	
});
   
 	function startGraph(){
 		
		$.ajax({
		     url: '${pageContext.request.contextPath}/web/agree/agreeFilter.do',   // 단계 데이터를 제공하는 API 엔드포인트
		     method: 'GET',
		     data : 
					{
						start : parseInt($("#start").val()),
						pagesize : $("#pagesize").val(),
						MENU_MNG_NO : '<%=request.getParameter("MENU_MNG_NO")%>',
						CVTN_RQST_YMD1:$("#CVTN_RQST_YMD1").val(),
						CVTN_RQST_YMD2:$("#CVTN_RQST_YMD2").val(),
						CVTN_RPLY_YMD1:$("#CVTN_RPLY_YMD1").val(),
						CVTN_RPLY_YMD2:$("#CVTN_RPLY_YMD2").val(),
						CVTN_CTRT_TYPE_CD_NM:$("#CVTN_CTRT_TYPE_CD_NM").val(),
						PRVT_SRCH_KYWD_CN:$("#PRVT_SRCH_KYWD_CN").val(),
						CVTN_RQST_DEPT_NM:$("#CVTN_RQST_DEPT_NM").val(),
						CVTN_RQST_EMP_NM:$("#CVTN_RQST_EMP_NM").val(),
						CVTN_TKCG_EMP_NM:$("#CVTN_TKCG_EMP_NM").val(),
						RVW_TKCG_EMP_NM:$("#RVW_TKCG_EMP_NM").val(),
						INSD_OTSD_TASK_SE:$('input:radio[name="INSD_OTSD_TASK_SE"]:checked').val(),
						RFLT_YN_RSLT_REG_YN:$('input:radio[name="RFLT_YN_RSLT_REG_YN"]:checked').val(),
						EMRG_YN:$('input:radio[name="EMRG_YN"]:checked').val(),
						CVTN_DOC_NO:$("#CVTN_DOC_NO").val(),
						CVTN_INTL_DOC_NO:$("#CVTN_INTL_DOC_NO").val(),
						CVTN_TTL:$("#CVTN_TTL").val(),
						PRGRS_STTS_SE_NM:$("#PRGRS_STTS_SE_NM").val(),
						openyn : '<%=OPENYN%>'
						, awesomeVal : {
							  		  A100 : 'fa-solid fa-file-lines'
									, B100 : 'fa-solid fa-file-pen'
									, C100 : 'fa-solid fa-hourglass-half'//fa-solid fa-file-import
									, D100 : 'fa-solid fa-file-circle-check'//fa-solid fa-file-circle-check //fa-solid fa-file-circle-plus
									, E1100 : 'fa-solid fa-user-shield'//fa-solid fa-file-shield //fa-solid fa-user-shield
									, E2100 : 'fa-solid fa-user-clock'//fa-solid fa-arrows-down-to-people //fa-solid fa-user-clock
									, F100 : 'fa-solid fa-user-check'
									, G100 : 'fa-solid fa-list-check'
									, H100 : 'fa-solid fa-circle-check'//fa-solid fa-file-circle-exclamation //fa-solid fa-file-circle-check// fa-solid fa-circle-check
									, I100 : 'fa-solid fa-clipboard-question'//fa-solid fa-file-circle-question //fa-solid fa-clipboard-question
									, J100 : 'fa-solid fa-file-circle-xmark'
						}
			},
		     dataType: 'json',
		     success: function(data) {
		         console.log('단계 데이터:', data);
		         renderGraph(data); // 데이터를 기반으로 그래프 생성
	     	},
		     error: function(xhr, status, error) {
		         console.error('단계 데이터 로드 실패:', error);
	     	}
		});
 	};
 	function renderGraph(stages) {
     	let mermaidCode = 'graph LR\n';

	    // 노드 생성
	    stages.forEach(function(stage) {
	        var id = stage.id;
	        var label = stage.label;
	        var count = stage.count;
	        var labCnt = '<div>' + label + ' - ' + count + '건</div>';
	        var icon = stage.icon ? '<div style=\'font-size: 24px; margin-bottom: 4px;\'><i class=\''+stage.icon+' \' style=\'text-align: center;\'/></div>' : '';
	        var htmlLabel = icon + labCnt;
	
	        // HTML 라벨 처리
	        mermaidCode += '    ' + id + '["<div style=\'text-align:center;\'>' + htmlLabel + '</div>"]\n';
	    });
	    
	    let linkIndex = 0;
	     // 연결선 생성(배치를 위해)
	     stages.forEach(function(stage){
	         stage.next.forEach(function(nextId){
// 	             mermaidCode += '    '+stage.id+' --> '+nextId+'\n';
	             mermaidCode += '    '+stage.id+' --- '+nextId+'\n';
	             mermaidCode += '    linkStyle ' + linkIndex + ' stroke:transparent,fill:none\n';
	             linkIndex++;
	         });
   		});

	    // 클릭 이벤트 바인딩
	    stages.forEach(function(stage) {
	        mermaidCode += '    click ' + stage.id + ' onStageClick "' + stage.label + '"\n';
	    });
		
		// Mermaid 그래프 렌더링
		$('#mermaid-container').html('<div class="mermaid">' + mermaidCode + '</div>');
       	mermaid.run();

       	setTimeout(highlighting, 100);
	}
 	
 	function highlighting(){

 		var prgrsSttsNm = $("#PRGRS_STTS_SE_NM").val();
 		
 		if (prgrsSttsNm == '') {
 			prgrsSttsNm = '전체';
		} else if (prgrsSttsNm == '완료') {
 			prgrsSttsNm = '종료';
		}
 		var $selectedPrgrsStts = $('[title="' + prgrsSttsNm + '"]');
 		var prgrsSttsId = $selectedPrgrsStts.attr('id');
 		
		//$("[id^='flowchart-']").find("rect").css('fill', '#f3f4f6');
		$("[id^='flowchart-']").find("rect").css('stroke', 'none');
		$(".mermaid").find(".edgePath path").css({'stroke': '#0073e6','stroke-width': '2px','stroke-dasharray': '6, 3'});
		// 화살표 머리 색상
		$(".mermaid").find("marker path").css('fill', '#3F5FCE');
		$('#'+prgrsSttsId+' rect').css('stroke', '#1b10dc'); 
	}
	
	function sendSatisMng() {
		var cw=1200;
		var ch=800;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","satisPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "satisPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/consult/sendSatisPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"GBN", value:"AGREE"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
</script>
<style>
.fa-solid{
	color: #41b46f;
}
</style>
		<div id="mermaid-container"></div>
		<hr class="margin20">
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="countT">총 <span id="gcnt">0</span>건</strong>
			</div>
			<div class="subBtnC right">
			<%
				if((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("A")>-1) && "100000595".equals(MENU_MNG_NO)) {
			%>
				<a href="#none" class="sBtn type2" id="sendSatisMng" onclick="sendSatisMng();">만족도조사요청</a>
			<%
				}
			%>
			<%
			if ("100000596".equals(MENU_MNG_NO)) {
			%>
				<a href="#none" id="sBtn" class="sBtn type1">검토 의뢰서 작성</a>
			<%
				}else{
			%>
				<a href="#none" id="sBtn" class="sBtn type1">심사 의뢰서 작성</a>
			<%
				}
			%>
			</div>
		</div>
		</form>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</body>