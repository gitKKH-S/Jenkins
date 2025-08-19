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
				{header:"<b>의뢰부서</b>",     width:10, align:'center',   dataIndex:'MANAGER_DEPT_NM', sortable: true},
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
				{header:"<b>자문구분</b>", width:8, align:'center',   dataIndex:'CNSTN_SE_NM',        sortable: true}
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
		frm.action = "consultOldView.do";
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
		$('select').find('option:first').attr('selected', 'selected');
		$(":text").val("");
		$(":hidden").val("");
	}
	
	function listFileDownload(gbn){
		document.goList.gbn.value = gbn;
		document.goList.action = "<%=CONTEXTPATH%>/web/consult/listFileDownload.do";
		document.goList.submit();
	}
	
	function menual(){
		window.open("${pageContext.request.contextPath}/dataFile/consultManual.pdf", "approval", "scrollbar=yes,width=1200,height=800,resizable=yes");
	}
</script>
<body>
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
					<th colspan="2"></th>
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
					<th colspan="4"></th>
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
		
	});
</script>
<style>
.fa-solid{
	color: #41b46f;
}
</style>
		<hr class="margin20">
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="countT">총 <span id="gcnt">0</span>건</strong>
			</div>
			<div class="subBtnC right"></div>
		</div>
		</form>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</body>