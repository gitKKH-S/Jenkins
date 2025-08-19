<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	int pageSize = 20;
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<style>
	#ext-gen12{min-height:100px;}
</style>
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
			{name:'ROWNUMBER'},
			{name:'JDAF_CORP_MNG_NO'},
			{name:'JDAF_CORP_NM'},
			{name:'CORP_SE'},
			{name:'OFC_ADDR'},
			{name:'ZIP'},
			{name:'OFC_TELNO'},
			{name:'OFC_FXNO'},
			{name:'RPRS_LWYR_NM'},
			{name:'RPRS_LWYR_TELNO'},
			{name:'RPRS_LWYR_EML_ADDR'},
			{name:'RMRK_CN'},
			{name:'LWYR_CNT'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectfLawFirmList.do"
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
				root:'result', totalProperty:'total', idProperty:'JDAF_CORP_MNG_NO'
			}, myRecordObj),
			pageSize:10
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>법무법인ID</b>",   dataIndex:'JDAF_CORP_MNG_NO', hidden:true},
				{header:"<b>no</b>",           width:15, align:'center', dataIndex:'ROWNUMBER'},
				{header:"<b>법무법인</b>",     width:90, align:'center', dataIndex:'JDAF_CORP_NM',   sortable:true},
				{header:"<b>전화번호</b>",     width:40, align:'center', dataIndex:'OFC_TELNO',      sortable:true},
				{header:"<b>소속변호사수</b>", width:30, align:'center', dataIndex:'LWYR_CNT',       sortable:true}
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
					var obj = gridStore.baseParams;
					var searchForm = "";
					for(var key in obj){
						searchForm = searchForm + "," + (key+"|"+obj[key]);
					}
					$("#searchForm").val(searchForm);
					
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					var getData = histData.data.JDAF_CORP_MNG_NO;
					
					goView(getData);
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
				MENU_MNG_NO : $("#MENU_MNG_NO").val(),
				
				JDAF_CORP_NM : $("#JDAF_CORP_NM").val()
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
					JDAF_CORP_NM : $("#JDAF_CORP_NM").val()
				}
			});
		});
	});
	
	function goView(data){
		document.getElementById("JDAF_CORP_MNG_NO").value = data;
		document.frm.action="<%=CONTEXTPATH%>/web/suit/lawfirmViewPage.do";
		document.frm.submit();
	}
	
	function goWritePage(){
		var obj = gridStore.baseParams;
		var searchForm = "";
		for(var key in obj){
			searchForm = searchForm + "," + (key+"|"+obj[key]);
		}
		$("#searchForm").val(searchForm);
		document.frm.action="<%=CONTEXTPATH%>/web/suit/lawfirmWritePage.do";
		document.frm.submit();
	}
	
	function goLawyerList(){
		document.getElementById("MENU_MNG_NO").value = "10000009";
		document.frm.action="<%=CONTEXTPATH%>/web/suit/golawyerList.do";
		document.frm.submit();
	}
	
	function goSch(){
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				start : 0,
				limit : <%=pageSize%>,
				pagesize : <%=pageSize%>,
				JDAF_CORP_NM : $("#JDAF_CORP_NM").val()
			}
		});
		gridStore.load();
	}
	
	function goReset(){
		$("#JDAF_CORP_NM").val("");
	}
</script>
<style>
	input{width:80%}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="pageno"           id="pageno"           value=""/>
	<input type="hidden" name="JDAF_CORP_MNG_NO" id="JDAF_CORP_MNG_NO" value=""/>
	<input type="hidden" name="pagesize"         id="pagesize"         value="<%=pageSize%>"/>
	<input type="hidden" name="MENU_MNG_NO"           id="MENU_MNG_NO"           value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM"           id="WRTR_EMP_NM"           value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"         id="WRTR_EMP_NO"         value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"           id="WRT_DEPT_NO"           value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"         id="WRT_DEPT_NM"         value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="searchForm"       id="searchForm"       value=""/>
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="innerB">
			<table class="infoTable" style="width:100%" id="stxt">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>법무법인명</th>
					<td><input type="text" id="JDAF_CORP_NM" name="JDAF_CORP_NM"></td>
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
				<a href="#none" class="sBtn type2" onclick="goLawyerList();">변호사관리</a>
				<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("I") > -1){%>
				<a href="#none" class="sBtn type1" onclick="goWritePage();">등록</a>
				<%}%>
			</div>
		</div>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</form>