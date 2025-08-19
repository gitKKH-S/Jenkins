<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	var miHeight = 220;
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	Ext.onReady(function(){
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'LAWID'},
			{name:'ROWNUMBER'},
			{name:'LAWNAME'},
			{name:'PROMULDT'},
			{name:'PROMULNO'},
			{name:'REVCD'},
			{name:'DEPTCODE'},
			{name:'DEPT'},
			{name:'LAWGBN'},
			{name:'GBN'},
			{name:'STARTDT'},
			{name:'URLINFO'}
		]);
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"${pageContext.request.contextPath}/web/law/etcListData.do"
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
				root:'result', totalProperty:'total', idProperty:'BYLAWID'
			}, myRecordObj)
		});

		var cmm = new Ext.grid.ColumnModel({
			columns:[
				new Ext.grid.RowNumberer(),
				{header:"<b>법령명</b>", width:250, align:'left',dataIndex:'LAWNAME', sortable: true},
				{header:"<b>제/개정구분</b>", width:50, align:'center', dataIndex:'REVCD', sortable: true},
				{header:"<b>관련부처</b>", width:70, align:'center', dataIndex:'DEPT', sortable:true},
				{header:"<b>법령구분</b>", width:70, align:'center', dataIndex:'LAWGBN', sortable:true},
				{header:"<b>공포일</b>", width:55, align:'center', dataIndex:'PROMULDT', sortable:true}
			]
		});
		
		var grid = new Ext.grid.GridPanel({
			id : ids,
			renderTo : 'gridList',
			store : gridStore,
			autoWidth : true,
			width : '100%',
			height : $('body').height()-miHeight,
			overflowY : 'hidden',
			remoteSort : true,
			scroll: false,
			iconCls : 'icon_perlist',
			stripeRows : true,
			loadMask : {
				msg : '로딩중입니다. 잠시만 기다려주세요...'
			},
			viewConfig : {
				forceFit : true,
				enableTextSelection : true,
				emptyText : '조회된 데이터가 없습니다.'
			},
			cm : cmm,
			listeners : {
				rowcontextmenu: function(grid, idx, e) {
					var selModel = grid.getSelectionModel();
					selModel.selectRow(idx);
					var rowData = selModel.getSelected();
					rowData.showAt(e.getXY());
				},
				rowclick: function(grid, idx, e) {
					var selModel= grid.getSelectionModel();
					var histData = selModel.getSelected();
					/* if(histData.get("GBN")=='LAW'){
						goView(histData.get("LAWID"));
					}else{
						goView2(histData.get("LAWID"));	
					} */
					goView3(histData.get("URL_INFO_CN"));
				},
				cellcontextmenu: function(grid, idx, cIdx, e) {
					e.preventDefault();
				},
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					
					
				},
				contextmenu: function(e) {
					e.preventDefault();
				}
			}
		});
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				MENU_MNG_NO : <%=request.getParameter("MENU_MNG_NO")%>
			}
		});
		gridStore.load({
			params : {
				
			}
		});
		
		
		$("#mkexcel").click(function(){
            
            var url = "${pageContext.request.contextPath}/web/law/etcListDataMakeExcel.do";
			var obj = gridStore.baseParams;
            var inputs = '';
            for(var key in obj) {
            	//inputs+='<input type="hidden" name="'+ key +'" value="'+ obj[key] +'" />'; 
            }
            
            var stitle = 'N';
			var scontent = 'N';
			var sdept = 'N';
			if($("#stitle").is(":checked")){
				stitle = 'Y';
			}
			if($("#sdept").is(":checked")){
				sdept = 'Y';
			}
			inputs+='<input type="hidden" name="start" value="'+ 0 +'" />';
			inputs+='<input type="hidden" name="limit" value="10000000" />';
			inputs+='<input type="hidden" name="pagesize" value="10000000" />';
			inputs+='<input type="hidden" name="MENU_MNG_NO" value="'+ $("#MENU_MNG_NO").val() +'" />';
			inputs+='<input type="hidden" name="Schtxt" value="'+ $("#stxt").val() +'" />';
			inputs+='<input type="hidden" name="stitle" value="'+ stitle +'" />';
			inputs+='<input type="hidden" name="sdept" value="'+ sdept +'" />';
            
            if(gridStore.getSortState()){
            	inputs+='<input type="hidden" name="sort" value="'+ gridStore.getSortState().field +'" />';
            	inputs+='<input type="hidden" name="dir" value="'+ gridStore.getSortState().direction +'" />';
            }
            
            jQuery('<form action="'+ url +'" method="POST">'+inputs+'</form>').appendTo('.subTT').submit().remove();
		});
		
		$(window).resize(function() {
			gheight = $('body').height()-miHeight;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		})
		
		$("#stxt").keydown(function(key) {
            if (key.keyCode == 13) {
            	$('#searchBtn').trigger('click');
            }
        });

		$("#searchBtn").click(function(){
			var stitle = 'N';
			var scontent = 'N';
			var sdept = 'N';
			if($("#stitle").is(":checked")){
				stitle = 'Y';
			}
			if($("#sdept").is(":checked")){
				sdept = 'Y';
			}
			gridStore.load({
				params : {
					start : 0,
					limit : $("#pagesize").val(),
					MENU_MNG_NO : $("#MENU_MNG_NO").val(),
					Schtxt : $("#stxt").val(),
					stitle : stitle,
					sdept : sdept
				}
			});
		});
	});

	function goView(LAWID) {
		var frm = document.goList;
		frm.LAWID.value = LAWID;
		frm.action = "${pageContext.request.contextPath}/web/law/lawViewPage.do";
		frm.submit();
	}
	function goView2(BYLAWID) {
		var frm = document.goList;
		frm.BYLAWID.value = BYLAWID;
		frm.action = "${pageContext.request.contextPath}/web/law/bylawViewPage.do";
		frm.submit();
	}
	
	var urlInfo;
	function goView3(url){
		urlInfo = url
		//새창의 크기
		 cw=562;
		 ch=420;
		  //스크린의 크기
		 sw=screen.availWidth;
		 sh=screen.availHeight;
		 //열 창의 포지션
		 px=(sw-cw)/2;
		 py=(sh-ch)/2;
		 //창을 여는부분
		property="left="+px+",top="+py+",width=1300,height=900,scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var pop_f;
		pop_f = window.open("../lawapi/popView.do",'klaw',property);
	}
</script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<form name="goList" method="post">	
		<input type="hidden" name="BYLAWID"/>
		<input type="hidden" name="LAWID"/>
		</form>
		<div class="boardSrchW">
			<div class="bS_left">
				<input type="checkbox" id="stitle" checked="checked"> <label>법률명</label>
				<input type="checkbox" id="sdept" checked="checked"> <label>관련부처</label>
			</div>
			<input type="text" style='ime-mode:active;' id="stxt" placeholder="검색어를 입력하세요">
			<span id="searchBtn" class="b_SrchBtn" style="cursor:pointer;">검색</span>
		</div>
	</div>
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="countT">총 <span id="gcnt">0</span>건</strong>
		</div>
		<div class="subBtnC right">
			<a id="mkexcel" class="sBtn type2">대장출력</a>
		</div>
	</div>
	<div class="innerB">
		<div id="gridList"></div>
	</div>
</div>