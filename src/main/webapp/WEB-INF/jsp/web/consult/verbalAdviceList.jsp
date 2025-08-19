<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.consult.service.ConsultService"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%

	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String Constants = request.getAttribute("Constants")==null?"":request.getAttribute("Constants").toString();
	
	//System.out.println("Constants : " + Constants);
	System.out.println("=====================================>MENU_MNG_NO : " + MENU_MNG_NO);
	
	String consultcatcd = Constants;
	//String consultcatcd = Constants.Counsel.TYPE_GNLR;
	
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
/* 		padding: 30px; */
/* 		overflow-y: auto; */
		/* overflow-y: hidden; */
	}
</style>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$(".subSch").css("display", "none");
		
		$("#sBtn").click(function(){
// 			if(confirm("구두자문을 등록하시겠습니까?")){
				var obj = gridStore.baseParams;
				var searchForm = "";
				for(var key in obj){
					searchForm = searchForm + "," + (key+"|"+obj[key]);
				}
				$("#searchForm").val(searchForm);
				
				var frm = document.goList;
				frm.action = "${pageContext.request.contextPath}/web/consult/verbalAdviceWritePage.do";
				frm.submit();
// 			}
		});
		
		$(".searchInput").on('keypress', function(e){
			if (e.which === 13) {
				$('#searchBtn').click();
			}
		})
		
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
				searchYn ="Y";
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
			{name : 'CNSTN_MNG_NO'}
			,{name : 'MENU_MNG_NO'}
			,{name : 'CNSTN_CMPTN_YMD'}
			,{name : 'DSCSN_TYPE_NM'}
			,{name : 'CNSTN_TTL'}
			,{name : 'CNSTN_RQST_DEPT_NO'}
			,{name : 'CNSTN_RQST_DEPT_NM'}
			,{name : 'CNSTN_RQST_EMP_NO'}
			,{name : 'CNSTN_RQST_EMP_NM'}
			,{name : 'CNSTN_TKCG_EMP_NO'}
			,{name : 'CNSTN_TKCG_EMP_NM'}
			,{name : 'WRT_YMD'} 

			,{name : 'PRGRS_STTS_SE_NM'}
			,{name : 'CNSTN_HOPE_RPLY_YMD'}
			,{name : 'OPENYN'}
			,{name : 'INSD_OTSD_TASK_SE'} // 코드로 받아오게 되면 정해진 용어로 변환해줘야할수도 있음
			,{name : 'CNSTN_RPLY_YMD'}
			,{name : 'CNSTN_RQST_YMD'}
			,{name : 'CNSTN_DOC_NO'}
			,{name : 'RVW_TKCG_EMP_NM'}
			,{name : 'JDAF_CORP_NMS'}
			,{name : 'CNSTN_RCPT_YMD'}
			
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"${pageContext.request.contextPath}/web/consult/verbalAdviceListData.do"
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
				{header:"<b>상담일자</b>",     width:10, align:'center', dataIndex:'CNSTN_CMPTN_YMD',        sortable: true},
				{header:"<b>상담유형</b>",     width:10, align:'center', dataIndex:'DSCSN_TYPE_NM',    sortable: true},
				{header:"<b>제목(안건)</b>",     width:20,  align:'left', dataIndex:'CNSTN_TTL',    sortable: true},
				{header:"<b>의뢰부서</b>",     width:10, align:'center',   dataIndex:'CNSTN_RQST_DEPT_NM', sortable: true},
				{header:"<b>의뢰자</b>",     width:8,  align:'center', dataIndex:'CNSTN_RQST_EMP_NM',       sortable: true},
				{header:"<b>담당자</b>",       width:10, align:'center', dataIndex:'CNSTN_TKCG_EMP_NM',    sortable: true},
				{header:"<b>비고</b>",     width:10, align:'center', dataIndex:'RMRK_CN',        sortable: true}
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
				consultcatcd : $("#consultcatcd").val(),
				
				schreqdt1 : $("#schreqdt1").val(),
				schreqdt2 : $("#schreqdt2").val(),
				dscsn_type_nm : $("#dscsn_type_nm").val(),
				srch_kywd_cn : $("#srch_kywd_cn").val(),
				sch_rqst_dept_nm : $("#sch_rqst_dept_nm").val(),
				sch_rqst_emp_nm : $("#sch_rqst_emp_nm").val(),
				sch_tkcg_emp_nm : $("#sch_tkcg_emp_nm").val(),
				cnstn_ttl : $("#cnstn_ttl").val(),
				MENU_MNG_NO : '<%=MENU_MNG_NO%>',
				openyn : '<%=OPENYN%>'
			}
		});
		
		gridStore.load({
			params : {
				start : parseInt($("#start").val()),
				limit : $("#pagesize").val()
			}
		});
		
		function renderDate(value) {
			if (value == '' || value == undefined) {
				return '';
			}else {
				value = $.trim(value);
				if(value.length==10){
					getDate = new Date(value);
				}else{
					y = value.substr(0,4);
					m = value.substr(4,2);
					d = value.substr(6,2);
					console.log(y+"-"+m+"-"+d);
					getDate = new Date(y+"-"+m+"-"+d);
				}
			}
			return Ext.util.Format.date(getDate, 'Y-m-d');
		}
		
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
// 			goReset();
		});
		
		$(".downBtn").click(function(){
			$(".downBtn").css("display", "none");
			$(".upBtn").css("display", "");
			$(".subSch").css("display", "");
			gridResize(410);
// 			goReset();
		});
		
		function gridResize(minus){
			gheight = $('body').height()-minus;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		}
		
		$("#makexcel").click(function(){
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
			
			if(gridStore.getSortState()){
				inputs+='<input type="hidden" name="sort" value="'+ gridStore.getSortState().field +'" />';
				inputs+='<input type="hidden" name="dir" value="'+ gridStore.getSortState().direction +'" />';
			}
			
			jQuery('<form action="'+ url +'" method="POST">'+inputs+'</form>').appendTo('.subTT').submit().remove();
		});
		
		$("#makezip1,#makezip2").click(function(){
			var url = "${pageContext.request.contextPath}/web/consult/consultListmakezip.do";
			var obj = gridStore.baseParams;
			var inputs = '';
			for(var key in obj) {
				if(key!='pagesize'){
					inputs+='<input type="hidden" name="'+ key +'" value="'+ obj[key] +'" />';
				}
			}
			inputs+='<input type="hidden" name="pagesize" value="10000000" />';
			inputs+='<input type="hidden" name="pageno" value="1" />';
			inputs+='<input type="hidden" name="gbn" value="'+this.id+'" />';
			
			if(gridStore.getSortState()){
				inputs+='<input type="hidden" name="sort" value="'+ gridStore.getSortState().field +'" />';
				inputs+='<input type="hidden" name="dir" value="'+ gridStore.getSortState().direction +'" />';
			}
			
			jQuery('<form action="'+ url +'" method="POST">'+inputs+'</form>').appendTo('.subTT').submit().remove();
		});
	});
	
	/**
	 * 자문의뢰 조회 페이지 이동
	 */
	function gotoview(consultid){
		var frm = document.goList;
		frm.consultid.value = consultid;
		frm.action = "verbalAdviceView.do";
		frm.submit();
	}
	
	/**
	 * 기간 탭 선택 처리
	 */
	function selectedOnAction(data) {
		document.getElementById("consultstatecd").value = data;
		//console.log(">>>>>"+data);
		var frm = document.goList;
		//frm.consultstatecd.value = type; 
		frm.action = "${pageContext.request.contextPath}/web/consult/goConsultList.do";
		frm.submit();
	}
	
	//var Menuid = document.getElementById("Menuid").value;	
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	function goWritePage() {
		var chkyn = $("#modalChkYn").is(":checked");
		
		if(!chkyn){
			alert("검토 여부를 체크하세요.");
			return false;
		}
		
		$('#myModal2').hide();
		
		
		var obj = gridStore.baseParams;
		var searchForm = "";
		for(var key in obj){
			searchForm = searchForm + "," + (key+"|"+obj[key]);
		}
		$("#searchForm").val(searchForm);
		
		
		var frm = document.goList;
		frm.action = "${pageContext.request.contextPath}/web/consult/consultWritePage.do";
		frm.submit();
	}
	
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
				dscsn_type_nm : $("#dscsn_type_nm").val(),
				srch_kywd_cn : $("#srch_kywd_cn").val(),
				sch_rqst_dept_nm : $("#sch_rqst_dept_nm").val(),
				sch_rqst_emp_nm : $("#sch_rqst_emp_nm").val(),
				sch_tkcg_emp_nm : $("#sch_tkcg_emp_nm").val(),
				cnstn_ttl : $("#cnstn_ttl").val(),
				MENU_MNG_NO : '<%=MENU_MNG_NO%>',
				openyn : '<%=OPENYN%>'
				
			}
		});
// 		gridStore.load();
	}
	
	function goReset(){
		$('select').find('option:first').attr('selected', 'selected');
		$("#dscsn_type_nm").val("");
		$("#schreqdt1").val("");
		$("#schreqdt2").val("");
		$("#srch_kywd_cn").val("");
		$("#sch_rqst_dept_nm").val("");
		$("#sch_rqst_emp_nm").val("");
		$("#sch_tkcg_emp_nm").val("");
		$("#cnstn_ttl").val("");
		
		goSch();
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
<body>
	
	<form name="goList" method="post">
		<input type="hidden" name="pagesize" id="pagesize" value="<%=pageSize%>" />
		<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>"> 
		<input type="hidden" name="consultid" id="consultid"/>
		<input type="hidden" name="schradio" id="schradio"/>
		<input type="hidden" name="start" id="start" value=""/>
		<input type="hidden" name="searchForm" id="searchForm" value=""/>
		
		<div class="subCA">
			<strong class="subTT" id="subTT"></strong>
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
						<th>자문일자</th>
						<td>
							<input type="text" id="schreqdt1" name="schreqdt1" style="width:40%;" class="datepick" readonly="readonly"/>
							~
							<input type="text" id="schreqdt2" name="schreqdt2" style="width:40%;" class="datepick" readonly="readonly"/>
						</td>
<!-- 						<th>자문구분</th> -->
<!-- 						<td> -->
<!-- 							<select name="schcsttypecd" id="schcsttypecd" style="width:100%;"> -->
<!-- 								<option value="">전체</option> -->
<!-- 							</select> -->
<!-- 						</td> -->
						<th>상담유형</th>
						<td>
							<select name="dscsn_type_nm" id="dscsn_type_nm" style="width:100%;">
								<option value="">전체</option>
								<option value="유선">유선</option>
								<option value="방문">방문</option>
								<option value="메일">메일</option>
								<option value="메신저">메신저</option>
							</select>
						</td>
						<th>담당자</th>
						<td>
							<input type="text" name="sch_tkcg_emp_nm" id="sch_tkcg_emp_nm" style="width:100%" class="searchInput"/>
						</td>
					</tr>
					<tr class="subSch">
						<th>의뢰부서</th>
						<td>
							<input type="text" name="sch_rqst_dept_nm" id="sch_rqst_dept_nm" style="width:100%" class="searchInput"/>
						</td>
						<th>의뢰인</th>
						<td>
							<input type="text" name="sch_rqst_emp_nm" id="sch_rqst_emp_nm" style="width:100%" class="searchInput"/>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th>제목(안건)</th>
						<td colspan="5">
							<input type="text" id="cnstn_ttl" name="cnstn_ttl" style="width: 90%;" class="searchInput">
							<a href="#none" class="upBtn" title="접기" style="display:none"></a>
							<a href="#none" class="downBtn" title="펼치기"></a>
						</td>
					</tr>
					
				</table>
			</div>
			<div class="subBtnW center">
				<a href="#none" class="sBtn type1" onclick="goSch();" id="searchBtn">검색</a>
				<a href="#none" class="sBtn type2" onclick="goReset();">초기화</a>
			</div>
			<div class="subBtnW side">
				<div class="subBtnC left">
					<strong class="countT">총 <span id="gcnt">0</span>건</strong>
				</div>
				<div class="subBtnC right">
	<%
					//if(!Menuid.equals("10118690")){
	%>
					<a href="#none" id="sBtn" class="sBtn type1">구두자문 등록</a>
	<%
					//}
					if(GRPCD.indexOf("J")>-1 || GRPCD.indexOf("Y")>-1){
	%>
<!-- 						<a href="#" class="sBtn type1" id="makezip1">의뢰서다운로드</a> -->
<!-- 						<a href="#" class="sBtn type1" id="makezip2">의견서다운로드</a> -->
<!-- 						<a href="#none" class="sBtn type2" id="makexcel">엑셀다운로드</a> -->
	<%
					}
	%>
<!-- 					<a href="#none" class="sBtn type6" onclick="menual();">자문 매뉴얼</a> -->
				</div>
			</div>
			<div class="innerB">
				<div id="gridList"></div>
			</div>
		</div>
	</form>
</body>