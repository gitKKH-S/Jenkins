<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.consult.service.ConsultService"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%

	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String writer = request.getAttribute("writer")==null?"":request.getAttribute("writer").toString();
	String writerid = request.getAttribute("writerid")==null?"":request.getAttribute("writerid").toString();
	String deptname = request.getAttribute("deptname")==null?"":request.getAttribute("deptname").toString();
	String deptid = request.getAttribute("deptid")==null?"":request.getAttribute("deptid").toString();
	String Constants = request.getAttribute("Constants")==null?"":request.getAttribute("Constants").toString();
	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
	
	//System.out.println("Constants : " + Constants);
	System.out.println("=====================================>MENU_MNG_NO : " + MENU_MNG_NO);
	
	String inoutcd = ServletRequestUtils.getStringParameter(request, "inoutcd", "");
	System.out.println("=====================================>inoutcd : " + inoutcd);
	String consultcatcd = Constants;
	//String consultcatcd = Constants.Counsel.TYPE_GNLR;
	String schKey = ServletRequestUtils.getStringParameter(request, "schKey", "");
	String schVal = ServletRequestUtils.getStringParameter(request, "schVal", "");
	String sortcd = ServletRequestUtils.getStringParameter(request, "sortcd", "a.consultid desc");
	String consultstatecd = ServletRequestUtils.getStringParameter(request, "consultstatecd", "완료");
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
	
	/**/
	int pageSize = 20;
	/**/
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String OPENYN = "Y";
	if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1) {
		OPENYN = "N";
	}
%>

<style>
	.sBtn {
/* 		display: inline-block; */
/* 		min-width: 0px; */
/* 		height: 35px; */
/* 		line-height: 35px; */
/* 		border-radius: 20px; */
/* 		text-align: center; */
/* 		font-size: 13px; */
/* 		padding: 0 20px; */
/* 		margin: 0 1px; */
	}
	
	.subCA {
/* 		height: 100%; */
/* 		padding: 10 30; */
/* 		overflow-y: auto; */
		/* overflow-y: hidden; */
	}
	
	table:not(.x-toolbar-right) {
 /*   	width: 100%;                     콘텐츠 기반 auto의 반대 */
/*     table-layout: fixed;           /* unset 해제 후 고정 레이아웃 */ */
/*     box-sizing: border-box;        /* revert 대신 명시적 border-box */ */
/*     -webkit-box-sizing: border-box; */
	}
	
</style>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$(".subSch").css("display", "none");
		$('#myModal').hide();
		$('#myModal2').hide();
		$("#sBtn").click(function(){
// 			if(confirm("자문의뢰서를 작성하시겠습니까?")){
				var obj = gridStore.baseParams;
				var searchForm = "";
				for(var key in obj){
					searchForm = searchForm + "," + (key+"|"+obj[key]);
				}
				$("#searchForm").val(searchForm);
				
				var frm = document.goList;
				frm.action = "${pageContext.request.contextPath}/web/consult/consultWritePage.do";
				frm.submit();
// 			}
		});
		
	});
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	var gridStore,grid;
	Ext.onReady(function(){
		var searchYn = "N";
		var gridMinu = 310;
		$("#start").val(0);
		
		<%
		for(int i=0; i<sf.length; i++){
			System.out.println("searchForm===>"+sf[i]);
			String setv[] = sf[i].split("\\|");
			if(setv.length == 2){
		%>
				if ('<%=setv[0]%>' == "start"){
					$("#<%=setv[0]%>").val(parseInt('<%=setv[1]%>'));
				}else{
					$("#<%=setv[0]%>").val('<%=setv[1]%>');
				}
				<%
				if (!setv[0].equals("openyn") && !setv[0].equals("start") && !setv[0].equals("pagesize") && !setv[0].equals("MENU_MNG_NO")) {
				%>
					gridMinu = 410;
					$(".downBtn").css("display", "none");
					$(".upBtn").css("display", "");
					$(".subSch").css("display", "");
				<%
				}
				%>
		<%
			}
		}
		%>
		
		
		if(searchYn == "Y"){
			gridMinu = 410;
			$(".downBtn").css("display", "none");
			$(".upBtn").css("display", "");
			$(".subSch").css("display", "");
			//gridResize(380);
		}
		
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
// 			{name : 'ROWNO'}, // 순번 넣을 수 있는거 테스트해봤다가 일단 지워둠
			{name : 'CNSTN_MNG_NO'},
			{name : 'MENU_MNG_NO'},
			{name : 'PRGRS_STTS_SE_NM'},
			{name : 'CNSTN_TTL'},
			{name : 'CNSTN_RQST_DEPT_NO'},
			{name : 'CNSTN_RQST_DEPT_NM'},
			{name : 'CNSTN_RQST_EMP_NO'},
			{name : 'CNSTN_RQST_EMP_NM'},
// 			{name : 'CSTTYPECD'},
// 			{name : 'CSTTYPENM'},
			{name : 'CNSTN_HOPE_RPLY_YMD'},
			{name : 'OPENYN'},
// 			{name : 'CSTSUMRY'},
			{name : 'CNSTN_TKCG_EMP_NO'},
			{name : 'CNSTN_TKCG_EMP_NM'},
			{name : 'INSD_OTSD_TASK_SE'}, // 코드로 받아오게 되면 정해진 용어로 변환해줘야할수도 있음
			{name : 'CNSTN_RPLY_YMD'},
			{name : 'CNSTN_RQST_YMD'},
			{name : 'CNSTN_DOC_NO'},
// 			{name : 'HIT'},
			{name : 'WRT_YMD'}, // 어떤 정보, 무엇을 위한 컬럼인지 여쭤보기
			{name : 'RVW_TKCG_EMP_NM'}
			,{name : 'JDAF_CORP_NMS'}
			,{name : 'INOUTHAN'}
			,{name : 'CNSTN_RCPT_YMD'}
			,{name : 'RLS_YN'}
			,{name : 'CNSTN_SE_NM'}
			,{name : 'MANAGER_DEPT_NM'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"${pageContext.request.contextPath}/web/consult/consultListData.do"
			}),
			remoteSort:true,
			pagesize : $("#pagesize").val(),
			listeners:{
				load:function(store, records, success) {
					$("#gcnt").text(store.getTotalCount());
					$("#gcnt").number(true);
				}
			},
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'CNSTN_MNG_NO'
			}, myRecordObj)
		});
		
		var combo = new Ext.form.ComboBox({
			name : 'perpage',
			width: 40,
			store: new Ext.data.ArrayStore({
				fields: ['id'],
				data : [
					['20'],
					['50'],
					['100']
				]
			}),
			mode : 'local',
			value: '20',
			listWidth : 40,
			triggerAction : 'all',
			displayField : 'id',
			valueField : 'id',
			editable : false,
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
							pagesize : newPagesize,
						}
					});
				},scope: this
			}
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>자문ID</b>", dataIndex:'CNSTN_MNG_NO', hidden: true},
				{header:"<b>관리번호</b>",     width:8,  align:'center', dataIndex:'CNSTN_DOC_NO',    sortable: true},
				{header:"<b>접수일</b>",     width:8,  align:'center', dataIndex:'CNSTN_RCPT_YMD',    sortable: true},
				{header:"<b>제목</b>", width:20, align:'left',   dataIndex:'CNSTN_TTL',        sortable: true,
					renderer: function(value, metaData, record) {	
						
						var hasPermission = true;
						
						if (record.get('RLS_YN') === 'N') {
							return '<span style="color:#999;">🔒 ' + Ext.util.Format.htmlEncode(value) + '</span>';
						}
						
						return Ext.util.Format.htmlEncode(value);
					}
				},
// 				{header:"<b>의뢰부서</b>",     width:10, align:'center',   dataIndex:'CNSTN_RQST_DEPT_NM', sortable: true},
				{header:"<b>의뢰부서</b>",     width:20, align:'center',   dataIndex:'MANAGER_DEPT_NM', sortable: true},
				{header:"<b>의뢰자</b>",       width:10,  align:'center', dataIndex:'CNSTN_RQST_EMP_NM',  sortable: true},
				{header:"<b>담당변호사</b>",       width:10, align:'center', dataIndex:'CNSTN_TKCG_EMP_NM',    sortable: true,
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
				{header:"<b>처리상태</b>",     width:8,  align:'center', dataIndex:'PRGRS_STTS_SE_NM',       sortable: true},
				{header:"<b>자문유형</b>", width:8, align:'center',   dataIndex:'INOUTHAN',        sortable: true},
				{header:"<b>자문구분</b>", width:8, align:'center',   dataIndex:'CNSTN_SE_NM',        sortable: true},
// 				{header:"<b>요청일자</b>",     width:10, align:'center', dataIndex:'CNSTN_RQST_YMD',        sortable: true},
// 				{header:"<b>희망회신일자</b>",     width:10, align:'center', dataIndex:'CNSTN_HOPE_RPLY_YMD',        sortable: true}
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
		
		grid = new Ext.grid.GridPanel({
			id : ids,
			renderTo : 'gridList',
			store : gridStore,
			autoWidth : true,
			width : '100%',
// 			height : $('body').height()-gridMinu,
			autoHeight:true,
			overflowY : 'scroll',
			autoScroll : true,
			remoteSort : true,
			cm : cmm,
			loadMask : {
				msg : '로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows : false,
			viewConfig : {
				forceFit : true,
				enableTextSelection : true,
				emptyText : '조회된 데이터가 없습니다.'
			},
			bbar : bbar,
			iconCls : 'icon_perlist',
			listeners : {
				cellclick : function(grid, iCellEl, iColIdx, iStore, iRowEl,iRowIdx, iEvent) {
					
				},
				rowclick:function(grid, idx, e){
					
					var obj = gridStore.baseParams;
					var searchForm = "";
					for(var key in obj){
						searchForm = searchForm + "," + (key+"|"+obj[key]);
					}
					$("#searchForm").val(searchForm);
					
					var selModel= grid.getSelectionModel();
					var histData = selModel.getSelected();
					var consultid = histData.get('CNSTN_MNG_NO');
// 					var openyn = histData.get('OPENYN');
// 					var writerempno = histData.get('WRITEREMPNO');
// 					var writerdeptcd = histData.get('WRITERDEPTCD');
// 					var fulldeptcd = histData.get('FULLDEPTCD');
					
					gotoview(consultid);
				},
				contextmenu : function(e) {
					e.preventDefault();
				},
				cellcontextmenu : function(grid, idx, cIdx, e) {
					e.preventDefault();
				}
			}
		});
		
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				start : parseInt($("#start").val()),
				pagesize : $("#pagesize").val(),
// 				consultcatcd : $("#consultcatcd").val(),
// 				schGbn : $('input[name="schGbn"]:checked').val(),
				MENU_MNG_NO : '<%=MENU_MNG_NO%>',
				openyn : '<%=OPENYN%>',
				
				schreqdt1 : $("#schreqdt1").val(),
				schreqdt2 : $("#schreqdt2").val(),
				sch_insd_otsd_task_se : $("#sch_insd_otsd_task_se").val(),
				srch_kywd_cn : $("#srch_kywd_cn").val(),
				sch_rqst_dept_nm : $("#sch_rqst_dept_nm").val(),
				sch_rqst_emp_nm : $("#sch_rqst_emp_nm").val(),
				sch_tkcg_emp_nm : $("#sch_tkcg_emp_nm").val(),
				cnstn_ttl : $("#cnstn_ttl").val()
				, cnstn_doc_no : $("#cnstn_doc_no").val()
				, schreqdt3 : $("#schreqdt3").val()
				, schreqdt4 : $("#schreqdt4").val()
				, sch_answer : $("#sch_answer").val()
// 				, sch_conGbn : $("#sch_conGbn").val()
				, prgrs_stts_se_nm : $("#prgrs_stts_se_nm").val()
				, all_cn : $("#all_cn").val()
				
			}
			<% 
			if(!(GRPCD.indexOf("P") > -1)){
			%>
			test1();
			<%
			}
			%>
			
		});
		
		gridStore.load({
			params : {
				start : parseInt($("#start").val()),
				limit : $("#pagesize").val()
			}
		});
		
		$(window).resize(function() {
			if($(".subSch").css("display") == "none"){
				gridResize(310);
			}else{
				gridResize(410);
			}
		})
		
		$(".upBtn").click(function(){
			$(".downBtn").css("display", "");
			$(".upBtn").css("display", "none");
			$(".subSch").css("display", "none");
			gridResize(310);
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
	
	/**
	 * 자문의뢰 조회 페이지 이동
	 */
	function gotoview(consultid){
		var frm = document.goList;
		frm.consultid.value = consultid;
		frm.action = "consultView.do";
		frm.submit();
	}
	
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	
	function goSch(){
		$("#start").val(0);
		
// 		gridStore.on('beforeload', function(){
// 			gridStore.baseParams = {
		gridStore.load({
			params : {
				start : parseInt($("#start").val()),
				limit : <%=pageSize%>,
				pagesize : <%=pageSize%>,
				MENU_MNG_NO : '<%=MENU_MNG_NO%>',
				schreqdt1 : $("#schreqdt1").val(),
				schreqdt2 : $("#schreqdt2").val(),
// 				schbasis : $("#schbasis").val(),
				sch_insd_otsd_task_se : $("#sch_insd_otsd_task_se").val(),
				srch_kywd_cn : $("#srch_kywd_cn").val(),
				sch_rqst_dept_nm : $("#sch_rqst_dept_nm").val(),
				sch_rqst_emp_nm : $("#sch_rqst_emp_nm").val(),
				sch_tkcg_emp_nm : $("#sch_tkcg_emp_nm").val(),
				cnstn_ttl : $("#cnstn_ttl").val(),
// 				schGbn : $('input[name="schGbn"]:checked').val(),
				MENU_MNG_NO : '<%=MENU_MNG_NO%>',
				openyn : '<%=OPENYN%>'
				, cnstn_doc_no : $("#cnstn_doc_no").val()
				, schreqdt3 : $("#schreqdt3").val()
				, schreqdt4 : $("#schreqdt4").val()
				, sch_answer : $("#sch_answer").val()
// 				, sch_conGbn : $("#sch_conGbn").val()
				, prgrs_stts_se_nm : $("#prgrs_stts_se_nm").val()
				, all_cn : $("#all_cn").val()
			}
		});
// 		gridStore.load();
		<% 
		if(!(GRPCD.indexOf("P") > -1)){
		%>
		test1();
		<%
		}
		%>
	}
	
	function goReset(){
// 		$('select').find('option:first').attr('selected', 'selected');
// 		$("#schreqdt1").val("");
// 		$("#schreqdt2").val("");
// // 		$("#sch_insd_otsd_task_se").val("");
// 		$("#srch_kywd_cn").val("");
// 		$("#sch_rqst_dept_nm").val("");
// 		$("#sch_rqst_emp_nm").val("");
// 		$("#sch_tkcg_emp_nm").val("");
// 		$("#cnstn_ttl").val("");
		
// 		$("#cnstn_doc_no").val("");
// 		$("#schreqdt3").val("");
// 		$("#schreqdt4").val("");
// 		$("#sch_answer").val("");
// // 		$("#sch_conGbn").val("");
// // 		$("#prgrs_stts_se_nm").val("");
// 		$("#all_cn").val("");
		$('select').find('option:first').attr('selected', 'selected');
		$(":text").val("");
		$(":hidden").val("");
		
// 		goSch();
	}
	
	function listFileDownload(gbn){
		document.goList.gbn.value = gbn;
		document.goList.action = "<%=CONTEXTPATH%>/web/consult/listFileDownload.do";
		document.goList.submit();
	}
	
	function menual(){
		window.open("${pageContext.request.contextPath}/dataFile/consultManual.pdf", "approval", "scrollbar=yes,width=1200,height=800,resizable=yes");
	}
	
	function modalCall() {
		$('#myModal').show();
	}
	
	function makeExcel(gbn) {
		$('#myModal').hide();
		$("#myModal2").show();
		
		var url = "${pageContext.request.contextPath}/web/consult/consultListExcel.do";
		var obj = gridStore.baseParams;
		var inputs = '';
		for(var key in obj) {
			if(key!='pagesize'){
				inputs+='<input type="hidden" name="'+ key +'" value="'+ obj[key] +'" />';
			}
		}
		inputs+='<input type="hidden" name="pagesize" value="10000000" />';
		inputs+='<input type="hidden" name="pageno" value="1" />';
		inputs+='<input type="hidden" name="gbn" value="'+gbn+'" />';
		
		if(gridStore.getSortState()){
			inputs+='<input type="hidden" name="sort" value="'+ gridStore.getSortState().field +'" />';
			inputs+='<input type="hidden" name="dir" value="'+ gridStore.getSortState().direction +'" />';
		}
		
		jQuery('<form action="'+ url +'" method="POST">'+inputs+'</form>').appendTo('.subTT').submit().remove();
		
		setTimeout(function(){
			$("#myModal2").hide();
		}, 10000);
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
		height:23%;
	}
</style>
<body>
	<div id="myModal" class="modal">
		<!-- Modal content -->
		<div class="modal-content">
			<p style="text-align: center;"><span style="font-size: 14pt;"><b><span style="font-size: 24pt;">목록 엑셀 다운로드</span></b></span></p>
			<p style="text-align: center; line-height: 1.5;"><br /></p>
			<p style="text-align: left; line-height: 1.5;"><span style="font-size: 14pt;">다운로드 받을 방식을 선택하세요.</span></p>
			<p style="text-align: center; line-height: 1.5;"><br /></p>
			<p><br /></p>
			<div style="cursor:pointer; background-color:#DDDDDD; text-align: center; padding-bottom: 10px; padding-top: 10px; width:45%; float:left;" onClick="makeExcel('none');">
				<span class="pop_bt" style="font-size: 13pt;" >
					일반 다운로드
				</span>
			</div>
			<div style="cursor:pointer; background-color:#DDDDDD; text-align: center; padding-bottom: 10px; padding-top: 10px; width:45%; float:right;" onClick="makeExcel('mask');">
				<span class="pop_bt" style="font-size: 13pt;" >
					마스킹 다운로드
				</span>
			</div>
		</div>
	</div>
	
	<div id="myModal2" class="modal">
		<div class="modal-content">
			<p style="text-align: left; height:100%; margin-top:12%; text-align:center;"><span style="font-size: 14pt;">문서를 생성중입니다.<br/>잠시만 기다려주세요</span></p>
		</div>
	</div>
	
	<div class="subCA">
		<strong class="subTT" id="subTT"></strong>
		<form name="goList" method="post">
		<input type="hidden" name="pagesize" id="pagesize" value="<%=pageSize%>" />
		<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>"> 
		<input type="hidden" name="consultid" id="consultid"/>
		<input type="hidden" name="schradio" id="schradio"/>
		<input type="hidden" name="start" id="start" value=""/>
		<input type="hidden" name="searchForm" id="searchForm" value=""/>
		<input type="hidden" name="graphHl" id="graphHl" value=""/>
		<div class="innerB">
			<table class="infoTable write" style="width:100%">
				<colgroup>
					<col style="width:10%;">
					<col style="width:23%;">
					<col style="width:10%;">
					<col style="width:23%;">
					<col style="width:10%;">
					<col style="width:24%;">
				</colgroup>
				<tr class="subSch">
					<th>접수일</th>
					<td>
						<input type="text" id="schreqdt1" name="schreqdt1" style="width:40%;" class="datepick" readonly="readonly"/>
						~
						<input type="text" id="schreqdt2" name="schreqdt2" style="width:40%;" class="datepick" readonly="readonly"/>
					</td>
					<th>자문유형</th>
					<td>
						<select name="sch_insd_otsd_task_se" id="sch_insd_otsd_task_se" style="width:100%;">
							<option value="">전체</option>
							<option value="I">내부검토</option>
							<option value="O">외부자문</option>
						</select>
					</td>
					<%
					if((GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("Q")>-1 || GRPCD.indexOf("J")>-1 || GRPCD.indexOf("M")>-1)){
					%>
					<th>자문팀 검색 키워드</th>
					<td>
						<input type="text" name="srch_kywd_cn" id="srch_kywd_cn" style="width:100%"/>
					</td>
					<%
					}
					%>
				</tr>
				<tr class="subSch">
					<th>의뢰부서</th>
					<td>
						<input type="text" name="sch_rqst_dept_nm" id="sch_rqst_dept_nm" style="width:100%"/>
					</td>
					<th>의뢰자</th>
					<td>
						<input type="text" name="sch_rqst_emp_nm" id="sch_rqst_emp_nm" style="width:100%"/>
					</td>
					<th>담당자</th>
					<td>
						<input type="text" name="sch_tkcg_emp_nm" id="sch_tkcg_emp_nm" style="width:100%"/>
					</td>
				</tr>
				<tr class="subSch">
					<th>관리번호</th>
					<td>
						<input type="text" name="cnstn_doc_no" id="cnstn_doc_no" style="width:100%"/>
					</td>
					<th>답변일</th>
					<td>
						<input type="text" id="schreqdt3" name="schreqdt3" style="width:40%;" class="datepick" readonly="readonly"/>
						~
						<input type="text" id="schreqdt4" name="schreqdt4" style="width:40%;" class="datepick" readonly="readonly"/>
					</td>
					<th>담당 고문변호사</th>
					<td>
						<input type="text" name="sch_answer" id="sch_answer" style="width:100%"/>
					</td>
				</tr>
				<tr class="subSch">
					<th>자문 구분</th>
					<td>
						<select name="sch_cnstn_se_nm" id="sch_cnstn_se_nm" style="width:100%;">
							<option value="">전체</option>
							<option value="일반">일반</option>
							<option value="국제">국제</option>
						</select>
					</td>
					<th>진행 상태</th>
					<td>
						<select name="prgrs_stts_se_nm" id="prgrs_stts_se_nm" style="width:100%;">
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
					<th></th>
					<td>
					</td>
				</tr>
				<tr>
					<th>자문명</th>
					<td colspan="5">
						<input type="text" id="cnstn_ttl" name="cnstn_ttl" style="width: 90%;">
						<a href="#none" class="upBtn" title="접기" style="display:none"></a>
						<a href="#none" class="downBtn" title="펼치기"></a>
					</td>
				</tr>
				<tr class="subSch">
					<th>내용</th>
					<td colspan="5">
						<input type="text" id="all_cn" name="all_cn" style="width: 100%;">
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
var resourceUrl = '${resourceUrl}';
$(document).ready(function() {
	$(document).on("click","[id^='flowchart-']",function(){
		console.log('111 ::: ' , $(this).attr("title"));
		console.log('222 ::: ' , $(this).get(0).id);
		
		
		var stateCd = $(this).attr("title");
		if (stateCd == '전체') {
			$("#prgrs_stts_se_nm").val('');
		} else if (stateCd == '종료') {
			$("#prgrs_stts_se_nm").val('완료');
		} else {
			$("#prgrs_stts_se_nm").val(stateCd);
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
   
 	function test1(){
 		
		$.ajax({
		     url: '${pageContext.request.contextPath}/web/consult/consultFilter.do',   // 단계 데이터를 제공하는 API 엔드포인트
		     method: 'GET',
		     data : 
// 		    	 $('#goList').serializeArray(),
					{
						start : parseInt($("#start").val()),
						limit : <%=pageSize%>,
						pagesize : <%=pageSize%>,
						MENU_MNG_NO : '<%=MENU_MNG_NO%>',
						schreqdt1 : $("#schreqdt1").val(),
						schreqdt2 : $("#schreqdt2").val(),
	//	 				schbasis : $("#schbasis").val(),
						sch_insd_otsd_task_se : $("#sch_insd_otsd_task_se").val(),
						srch_kywd_cn : $("#srch_kywd_cn").val(),
						sch_rqst_dept_nm : $("#sch_rqst_dept_nm").val(),
						sch_rqst_emp_nm : $("#sch_rqst_emp_nm").val(),
						sch_tkcg_emp_nm : $("#sch_tkcg_emp_nm").val(),
						cnstn_ttl : $("#cnstn_ttl").val(),
// 						schGbn : $('input[name="schGbn"]:checked').val(),
						MENU_MNG_NO : '<%=MENU_MNG_NO%>',
						openyn : '<%=OPENYN%>'
						, cnstn_doc_no : $("#cnstn_doc_no").val()
						, schreqdt3 : $("#schreqdt3").val()
						, schreqdt4 : $("#schreqdt4").val()
						, sch_answer : $("#sch_answer").val()
// 						, sch_conGbn : $("#sch_conGbn").val()
						, prgrs_stts_se_nm : $("#prgrs_stts_se_nm").val()
						, all_cn : $("#all_cn").val()
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
//	             mermaidCode += '    '+stage.id+' --> '+nextId+'\n';
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
	
	    setTimeout(highlighting, 100); // 강조 표시

	}
 	
 	function highlighting(){

 		var prgrsSttsNm = $("#prgrs_stts_se_nm").val();
 		
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
		newForm.append($("<input/>", {type:"hidden", name:"GBN", value:"CONSULT"}));
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
				if(GRPCD.indexOf("J")>-1 || GRPCD.indexOf("Y")>-1){
			%>
				<a href="#none" class="sBtn type2" id="sendSatisMng" onclick="sendSatisMng();">만족도조사요청</a>
				<a href="#none" class="sBtn type1" onclick="modalCall();">엑셀다운로드</a>
			<%
				}
			%>
				<a href="#none" id="sBtn" class="sBtn type1">자문의뢰서작성</a>
			</div>
		</div>
		</form>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</body>