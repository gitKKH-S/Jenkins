<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String suitid = request.getParameter("suitid")==null?"":request.getParameter("suitid").toString();
	String selectedCaseId = request.getParameter("selectedCaseId")==null?"":request.getParameter("selectedCaseId").toString();
	String tabId = request.getParameter("tabId");
	String mergeyn = request.getParameter("mergeyn");
%>
<script>
	var suitid = "<%=suitid%>";
	var caseid = "<%=selectedCaseId%>";
	var mergeyn = "<%=mergeyn%>";
	var gridStore;
	function setGrid(){
		var tabRecordObj = Ext.data.Record.create([
			{name:'DEPOSITID'},
			{name:'CASEID'},
			{name:'SUITID'},
			{name:'TYPE'},
			{name:'COURTCD'},
			{name:'COURTNM'},
			{name:'GONGTAKDT'},
			{name:'GONGTAKAMT'},
			{name:'CAUSENM'},
			{name:'CAUSECD'},
			{name:'RECOVERYYN'},
			{name:'VIEWFILENM'},
			{name:'SERVERFILENM'}
		]);
		gridStore = new Ext.data.Store({
			baseParams : {
				suitid:suitid,
				caseid:caseid,
				mergeyn:mergeyn,
				gbn:""
			},
			proxy: new Ext.data.HttpProxy({
				url: "<%=CONTEXTPATH %>/web/suit/selectGongtakList.do"
			}),
			reader: new Ext.data.JsonReader({
				root: 'result', totalProperty: 'total', idProperty: 'depositid'
			}, tabRecordObj)
		});
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"공탁ID",   dataIndex:'DEPOSITID', hidden:true},
				{header:"소송ID",   dataIndex:'SUITID',    hidden:true},
				{header:"심급ID",   dataIndex:'CASEID',    hidden:true},
				{header:"법원코드", dataIndex:'COURTCD',   hidden:true},
				{header:"사유코드", dataIndex:'CAUSECD',   hidden:true},
				{header:"<b>공탁유형</b>", width:50, align:'center',dataIndex:'TYPE', sortable: true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var type = rowData.data.TYPE;
						var typetxt = "";
						
						if(type == "0"){
							typetxt = "공탁자";
						}else{
							typetxt = "피공탁자";
						}
						
						return typetxt;
					}
				},
				{header:"<b>법원</b>", width:100, align:'center', dataIndex:'COURTNM', sortable: true},
				{header:"<b>공탁일</b>",  width:80, align:'center', dataIndex:'GONGTAKDT', sortable: true},
				{header:"<b>공탁금액</b>", width:100, align:'center', dataIndex:'GONGTAKAMT', sortable: true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var amt = comma(rowData.data.GONGTAKAMT);
						return amt;
					}
				},
				{header:"<b>공탁사유</b>", width:100, align:'center', dataIndex:'CAUSENM', sortable: true},
				{header:"<b>회수여부</b>",  width:50, align:'center', dataIndex:'RECOVERYYN', sortable: true},
				{header:"<b>파일</b>", width:100, align:'left', dataIndex:'VIEWFILENM', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel = grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var html = "";
						if(rowData.get("SERVERFILENM") != null && rowData.get("SERVERFILENM") != ""){
							var viewfile = rowData.get("VIEWFILENM").split(",");
							var serverfile = rowData.get("SERVERFILENM").split(",");
							html+="<ul>";
							for(var j=0; j<viewfile.length; j++){
								html+="<li><a href='#none' onclick='downFile(\""+viewfile[j]+"\",\""+serverfile[j]+"\")' title=\""+viewfile[j]+"\">"+viewfile[j]+"</a></li>";
							}
							html+="</ul>";
						}
						return html;
						
					}
				}
			]
		});
		var grid = new Ext.grid.GridPanel({
			id : 'hkk4',
			renderTo: 'tabGrid',
			store: gridStore,
			autoWidth: true,
			width: '100%',
			autoHeight: true,
			overflowY: 'hidden',
			scroll: false,
			remoteSort: true,
			selModel: new Ext.grid.RowSelectionModel({singleSelect : false}),
			cm: cmm,
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows: true,
			viewConfig: {
				forceFit: true,
				enableTextSelection : true,
				emptyText:'조회된 데이터가 없습니다.'
			},
			iconCls: 'icon_perlist',
			listeners: {
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					var depositid = histData.get("DEPOSITID");
					var getcaseid = histData.get("CASEID");
					var getsuitid = histData.get("SUITID");
					goTabView(depositid, getcaseid, getsuitid);
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
				suitid:suitid,
				caseid:caseid,
				mergeyn:mergeyn,
				gbn:""
			}
		});
		
		gridStore.load({
			params:{
				suitid:suitid,
				caseid:caseid,
				mergeyn:mergeyn,
				gbn:""
			}
		});
		
		gridStore.load();
	}
	
	//등록페이지
	function goTabWrite(){
		$("#getSuitnm").val($("#suitnm").text());
		var url = '<%=CONTEXTPATH%>/web/suit/gongtakWritePop.do?depositid=0&suitid='+suitid+'&caseid='+caseid;
		var wth = "650";
		var hht = "700";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	
	function goTabView(depositid, getcaseid, getsuitid){
		var param = "";
		if(caseid != getcaseid){
			if(suitid != getsuitid){
				param = '?depositid='+depositid+'&suitid='+getsuitid+'&caseid='+getcaseid;
			}else{
				param = '?depositid='+depositid+'&suitid='+suitid+'&caseid='+getcaseid;
			}
		}else{
			param = '?depositid='+depositid+'&suitid='+suitid+'&caseid='+caseid;
		}
		
		var url = '<%=CONTEXTPATH%>/web/suit/gongtakViewPop.do' + param;
		var wth = "550";
		var hht = "560";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	
	var openWin
	function popOpen(pname,url,wth,hht){
		var cw=wth;
		var ch=hht;
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		var property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=no,status=no,toolbar=no";
		openWin = window.open(url, pname, property);
		window.openWin.focus();
	}
	
	function getRelcase(){
		if(mergeyn == "Y"){
			return alert("병합사건은 관련사건 정보를 함께 불러올 수 없습니다.");
		}else{
			gridStore.on('beforeload', function(){
				gridStore.baseParams = {
					suitid : suitid,
					caseid : caseid,
					gbn : "rel"
				}
			});
			gridStore.load();
		}
	}
	
	function downFile(viewfilenm, serverfilenm){
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("action", "${pageContext.request.contextPath}/Download.do");
		newForm.append($("<input/>", {type:"hidden", name:"Serverfile", value:serverfilenm}));
		newForm.append($("<input/>", {type:"hidden", name:"Pcfilename", value:viewfilenm}));
		newForm.append($("<input/>", {type:"hidden", name:"folder", value:"SUIT"}));
		newForm.appendTo("body");
		newForm.submit();
	}
</script>
<form name="tabFrm" id="tabFrm" method="post" action="" onsubmit="return false;">
	<div class="subBtnW side">
		<div class="subBtnC right">
			<a href="#none" class="sBtn type2" onclick="getRelcase();">관련사건데이터</a>
<%
			if(!GRPCD.equals("L")){
%>
			<a href="#none" class="sBtn type1" onclick="goTabWrite();">등록</a>
<%
			}
%>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
	</div>
</form>
