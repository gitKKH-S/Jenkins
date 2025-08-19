<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String MENU_SE_NM = request.getParameter("MENU_SE_NM")==null?"RSS1":request.getParameter("MENU_SE_NM");
	if(MENU_SE_NM.equals(""))MENU_SE_NM="RSS1";
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	var miHeight = 200;
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	Ext.onReady(function(){
		var MENU_SE_NM = "<%=MENU_SE_NM%>";
		var tt = '제안자';
		if(MENU_SE_NM=='RSS3'){
			tt = '설명';
		}
		var xg = Ext.grid;
		var myRecordObj = Ext.data.Record.create([
			{name: 'id'},
            {name: 'title'},
            {name: 'dlink'},
            {name: 'dlink2'},
            {name: 'winfo'},
            {name: 'wdt'}
		]);
		var dsCode = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				type: 'rest',
				url: '${pageContext.request.contextPath}/web/lawapi/rssApiData.do'
			}),
			listeners: {
		        load: function(store, records, success) {
		        	$("#gcnt").text(store.getTotalCount());
		        	$("#gcnt").number(true);
		        }
			},
			//remoteSort: true,
			//sortInfo: { field: 'title', direction: 'DESC' },

			sorters: [
			          {
			              property : 'title',
			              direction: 'DESC'
			          }
			      ]
			,
			reader: new Ext.data.JsonReader({
				root: 'result',  totalProperty: 'total', idProperty: 'id'
			},
			myRecordObj
			)
		});
		var cmm = new xg.ColumnModel({
				columns:[
						new Ext.grid.RowNumberer({width: 30}),		//줄번호 먹이기
						{header:"<b>발의 의안</b>",  style: 'text-align:center', dataIndex:'title', sortable: true},
						{header:"<b>"+tt+"</b>",  width:30, align:'center', dataIndex:'winfo', sortable: true},
						{header:"<b>제안일자</b>",  width:40, align:'center', dataIndex:'wdt', sortable: true}
					]
				});
		gridCodeMan = new xg.GridPanel({
			id : "hkk4",
			renderTo:'gridList',
			store:dsCode,
			autoWidth: true,
			overflowY: 'hidden',
			scroll:false,
			remoteSort: true,
			height: $('body').height()-miHeight,
			cm:cmm,
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows:true,
			viewConfig:{
				forceFit:true,
				enableTextSelection : true
			},
	        iconCls: 'icon-grid',
			listeners: {
				rowcontextmenu:function(grid, idx, e){
					var selModel=grid.getSelectionModel();
					selModel.selectRow(idx);
					var rowData = selModel.getSelected();
					rowContext.showAt(e.getXY());
				},
				rowclick:function(grid, idx, e){
					var selModel=grid.getSelectionModel();
					selModel.selectRow(idx);
					var rowData = selModel.getSelected();
					goView2(rowData.get("dlink"));
				},
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					
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
		dsCode.on('beforeload', function(){
			dsCode.baseParams = {
				datacd : 'slaw',
				MENU_SE_NM : MENU_SE_NM,
				start:0, limit:15
			}
		});
		dsCode.load();
		
		//alert(gridCodeMan.getStore().getCount());
		
		$(window).resize(function() {
			gheight = $('body').height()-miHeight;
			gridCodeMan.setHeight(gheight);
			gridCodeMan.setWidth($('.innerB').width());
		})
	});
	function goView2(url){
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
		property="left="+px+",top="+py+",width=1300,height=700,scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var pop_f;
		pop_f = window.open(url,'klaw',property);
	}
</script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="countT">총 <span id="gcnt">0</span>건</strong>
		</div>
	</div>
	<div class="innerB">
		<div id="gridList"></div>
	</div>
</div>