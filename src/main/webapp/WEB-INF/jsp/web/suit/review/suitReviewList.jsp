<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	int pageSize = 20;
	String Menuid = request.getParameter("Menuid")==null?"":request.getParameter("Menuid");
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script>
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		
		<%
		for(int i=0; i<sf.length; i++){
			System.out.println("searchForm===>"+sf[i]);
			String setv[] = sf[i].split("\\|");
			if(setv.length==2){
		%>
			$("#<%=setv[0]%>").val('<%=setv[1]%>');
		<%
			}
		}
		%>
		
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'DLBR_SE_NM'},
			{name:'LWS_DLBR_MNG_NO'},
			{name:'DLBR_AGND_NM'},
			{name:'PRGRS_STTS_NM'},
			{name:'RQST_EMP_NM'},
			{name:'RQST_DEPT_NM'},
			{name:'DLBR_BGNG_YMD'},
			{name:'DLBR_END_YMD'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectReviewList.do"
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
				root:'result', totalProperty:'total', idProperty:'LWS_DLBR_MNG_NO'
			}, myRecordObj),
			pageSize:10
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"심의ID", dataIndex:'LWS_DLBR_MNG_NO', hidden:true},
				{header:"<b>심의구분</b>",     width:30, align:'center', dataIndex:'DLBR_SE_NM',     sortable:true},
				{header:"<b>심의제목</b>",     width:90, align:'center', dataIndex:'DLBR_AGND_NM',   sortable:true},
				{header:"<b>진행상태</b>",     width:30, align:'center', dataIndex:'PRGRS_STTS_NM',  sortable:true},
				{header:"<b>의뢰부서</b>",     width:30, align:'center', dataIndex:'RQST_DEPT_NM',   sortable:true},
				{header:"<b>심의시작일자</b>", width:30, align:'center', dataIndex:'DLBR_BGNG_YMD',  sortable:true}
			],
		});
		
		var combo = new Ext.form.ComboBox({
			name:'perpage',
			width:40,
			store:new Ext.data.ArrayStore({
				fields:['id'],
				data:[['20'],['50'],['100']]
			}),
			mode:'local',
			value:'20',
			listWidth:40,
			triggerAction:'all',
			displayField:'id',
			valueField:'id',
			editable:false,
			forceSelection:true,
			listeners:{
				select:function(item,newValue){
					bbar.pageSize = parseInt(newValue.get('id'), 10);
					bbar.doLoad(bbar.cursor);
					
					var newPagesize = parseInt(newValue.get('id'), 10);
					$("#pagesize").val(newPagesize);
						gridStore.pagesize = newPagesize;
						gridStore.load({
							params:{
								start:0,
								limit:newPagesize,
								pagesize:newPagesize
							}
						});
				},
				scope:this
			}
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
				},
				change : function(thisd, params) {
				}
			}
		});
		
		var grid = new Ext.grid.GridPanel({
			id:ids,
			renderTo:'gridList',
			store:gridStore,
			autoWidth:true,
			width:'100%',
			height:$('body').height()-300,
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
				emptyText:'조회된 데이터가 없습니다.'
			},
			bbar:bbar,
			iconCls:'icon_perlist',
			listeners:{
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					var LWS_DLBR_MNG_NO = histData.get("LWS_DLBR_MNG_NO");
					goView(LWS_DLBR_MNG_NO);
				},
				contextmenu:function(e) {
					e.preventDefault();
				},
				cellcontextmenu:function(grid, idx, cIdx, e) {
					e.preventDefault();
				}
			}
		});
		
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				pagesize : $("#pagesize").val(),
				casenum : $("#casenum").val(),
				deptnm : $("#deptnm").val(),
				suitcont : $("#suitcont").val()
			}
		});
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val()
			}
		});
		
		$(window).resize(function() {
			gheight = $('body').height()-300;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		});
		
		$("#stxt").keydown(function(key) {
			if (key.keyCode == 13) {
				$('#searchBtn').trigger('click');
			}
		});
		
		$("#searchBtn").click(function(){
			gridStore.load({
				params : {
					start : 0,
					limit : $("#pagesize").val(),
					casenum : $("#casenum").val(),
					deptnm : $("#deptnm").val(),
					suitcont : $("#suitcont").val()
				}
			});
		});
	});
	
	function goWritePage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/suitReviewWritePage.do";
		document.frm.submit();
	}
	
	function goView(LWS_DLBR_MNG_NO){
		document.getElementById("LWS_DLBR_MNG_NO").value = LWS_DLBR_MNG_NO;
		document.frm.action="<%=CONTEXTPATH%>/web/suit/suitReviewViewPage.do";
		document.frm.submit();
	}
	
	function goReset(){
		$("#casenum").val("");
		$("#dept").val("");
		$("#suitcont").val("");
	}
	
	function searchDept(idx){
		var url = '<%=CONTEXTPATH%>/web/suit/searchDeptPop2.do';
		var wth = "400";
		var hht = "720";
		var pnm = "deptPop";
		popOpen(pnm,url,wth,hht);
	}
</script>
<style>
	input{width:80%}
	#ext-gen12{min-height:100px;}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="pageno" id="pageno" value=""/>
	<input type="hidden" name="LWS_DLBR_MNG_NO" id="LWS_DLBR_MNG_NO" value="0"/>
	<input type="hidden" name="pagesize" id="pagesize" value="<%=pageSize%>"/>
	<input type="hidden" name="Menuid" id="Menuid" value="<%=Menuid%>"/>
	<input type="hidden" name="searchForm" id="searchForm" value=""/>
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="innerB">
			<table class="infoTable" style="width:100%" id="stxt">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>사건번호</th>
					<td><input type="text" id="casenum" name="casenum"></td>
					<th>신청부서</th>
					<td>
						<input type="text" id="deptnm" name="deptnm" />
					</td>
					<th>심의요청내용</th>
					<td><input type="text" id="suitcont" name="suitcont"></td>
				</tr>
			</table>
		</div>
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" id="searchBtn">검색</a>
			<a href="#none" class="sBtn type2" onclick="goReset();">초기화</a>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="countT">총 <span id="gcnt">0</span>건</strong>
			</div>
			<div class="subBtnC right">
				<a href="#none" class="sBtn type1" onclick="goWritePage();">등록</a>
			</div>
		</div>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</form>