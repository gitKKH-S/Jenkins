<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String suitid = request.getParameter("suitid")==null?"":request.getParameter("suitid").toString();
	String selectedCaseId = request.getParameter("selectedCaseId")==null?"":request.getParameter("selectedCaseId").toString();
	String tabId = request.getParameter("tabId");
%>
<script>
	var suitid = "<%=suitid%>";
	var caseid = "<%=selectedCaseId%>";
	var gridStore;
	
	function setGrid(){
		//var offset = $("#tabGrid").offset();
		//console.log(offset);
		//$("html").animate({scrollTop:offset.top}, 400);
		
		var tabRecordObj = Ext.data.Record.create([
			{name:'BONDID'},
			{name:'BONDAMT'},
			{name:'DEBTOR'},
			{name:'RECOVEAMT'},
			{name:'RECOVEDT'},
			{name:'BONDBAL'}
		]);
		gridStore = new Ext.data.Store({
			baseParams : {
				suitid : suitid,
				caseid : caseid,
				gbn : "debt"
			},
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectTabBondList.do"
			}),
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'bondid'
			}, tabRecordObj)
		});
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"채무ID", dataIndex:'BONDID', hidden:true},
				{header:"<b>채무금액</b>", width:70, align:'center', dataIndex:'BONDAMT', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var amt = comma(rowData.data.BONDAMT);
						return amt;
					}
				},
				{header:"<b>채권자</b>", width:70, align:'center', dataIndex:'DEBTOR', sortable:true},
				{header:"<b>총 지급금</b>", width:70, align:'center', dataIndex:'RECOVEAMT', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var reamt = comma(rowData.data.RECOVEAMT);
						return reamt;
					}
				},
				{header:"<b>마지막 지급일</b>", width:100, align:'center', dataIndex:'RECOVEDT', sortable:true},
				{header:"<b>채무잔액</b>", width:100, align:'center', dataIndex:'BONDBAL', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var bondbal = comma(rowData.data.BONDBAL);
						return bondbal;
					}
				}
			]
		});
	
		var grid = new Ext.grid.GridPanel({
			id:'hkk4',
			renderTo:'tabGrid',
			store:gridStore,
			autoWidth:true,
			width:'100%',
			autoHeight:true,
			overflowY:'hidden',
			scroll:false,
			remoteSort:true,
			selModel:new Ext.grid.RowSelectionModel({singleSelect : false}),
			cm:cmm,
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요'
			},
			stripeRows:true,
			viewConfig:{
				forceFit:true,
				enableTextSelection:true,
				emptyText:'조회된 데이터가 없습니다.'
			},
			iconCls:'icon_perlist',
			listeners:{
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					var bondid = histData.get("BONDID");
					goBondView(bondid);
				},
				contextmenu:function(e){
					e.preventDefault();
				},
				cellcontextmenu:function(grid, idx, cIdx, e){
					e.preventDefault();
				}
			}
		});
		
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				suitid : suitid,
				caseid : caseid,
				gbn : "debt"
			}
		});
		
		gridStore.load({
			params:{
				suitid:suitid,
				caseid:caseid,
				gbn : "debt"
			}
		});
		
		gridStore.load();
	}
	
	function goBondView(bondid){
		var url = '<%=CONTEXTPATH%>/web/suit/bondDetailPop.do?bondid='+bondid+'&gbn=debt';
		var wth = "900";
		var hht = "850";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	
	var openWin
	function popOpen(pname,url,wth,hht){
		var cw = wth;
		var ch = hht;
		var sw = screen.availWidth;
		var sh = screen.availHeight;
		var px = (sw-cw)/2;
		var py = (sh-ch)/2;
		var property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=no,status=no,toolbar=no";
		openWin = window.open(url, pname, property);
		window.openWin.focus();
	}
	
	function goWritePage(){
		$("#getSuitnm").val($("#suitnm").text());
		var bondid = $("#bondid").val();
		var url = '<%=CONTEXTPATH%>/web/suit/bondWritePage.do?bondid=0&suitid='+suitid+'&caseid='+caseid+'&gbn=debt';
		var wth = "900";
		var hht = "809";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	
	function getRelcase(){
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				suitid : suitid,
				caseid : caseid,
				gbn : "rel"
			}
		});
		gridStore.load();
	}
</script>
<form name="tabFrm" id="tabFrm" method="post" action="" onsubmit="return false;">
	<input type="hidden" id="bondid" name="bondid" value=""/>
	<input type="hidden" id="Menuid" name="Menuid" value=""/>
	
	<input type="hidden" id="getSuitnm" name="getSuitnm" value=""/>
	
	
	<div class="subBtnW side">
		<div class="subBtnC right">
<%
			if(!GRPCD.equals("X")){
%>
			<a href="#none" class="sBtn type1" onclick="goWritePage();">등록</a>
<%
			}
%>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
		<!-- <input type="text" id="test"/> -->
	</div>
</form>
