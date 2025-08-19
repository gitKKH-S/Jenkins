<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	var miHeight = 220;
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	Ext.onReady(function(){
		var xg = Ext.grid;
		var myRecordObj = Ext.data.Record.create([
			{name: 'ord'},
            {name: 'title'},
            {name: 'dlink'},
            {name: 'caseno'},
            {name: 'announ'},
            {name: 'cname'},
            {name: 'casecd'},
            {name: 'pancd'},
            {name: 'pandt'}
		]);
		var dsCode = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				type: 'rest',
				url: '${pageContext.request.contextPath}/web/lawapi/apiData.do'
			}),
			listeners: {
		        load: function(store, records, success) {
		        	$("#gcnt").text(store.getTotalCount());
		        	$("#gcnt").number(true);
		        }
			},
			remoteSort: true,
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
						{header:"<b>번호</b>",  width:15, style: 'text-align:center', dataIndex:'ord'},
						{header:"<b>사건명</b>",  style: 'text-align:center', dataIndex:'title', sortable: true},
						{header:"<b>사건번호</b>",  width:40, align:'center', dataIndex:'caseno'},
						{header:"<b>선고</b>",  width:40, align:'center', dataIndex:'announ'},
						{header:"<b>법원명</b>",  width:40, align:'center', dataIndex:'cname', sortable: true},
						{header:"<b>사건종류명</b>",  width:40, align:'center', dataIndex:'casecd'},
						{header:"<b>판결유형</b>",  width:40, align:'center', dataIndex:'pancd'},
						{header:"<b>선고일자</b>",  width:40, align:'center', dataIndex:'pandt', sortable: true}
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
			},
			bbar:new Ext.PagingToolbar({
				align: 'right',
				autoWidth: true,width:'100%',
				pageSize:15, store: dsCode,
				displayInfo:true, displayMsg:'전체 {2}의 결과중 {0} - {1}',
				emptyMsg:"검색된 결과가 없습니다."
			})
		});
		dsCode.on('beforeload', function(){
			dsCode.baseParams = {
				datacd : 'pan',
				start:0, limit:15
			}
		});
		dsCode.load();
		
		//alert(gridCodeMan.getStore().getCount());
		
		function sch(){
			dsCode.on('beforeload', function(){
				dsCode.baseParams = {
					datacd : 'pan',
					query : $("#stxt").val(),
					search : $("#search").val(),
					start:0, limit:15
				}
			});
			dsCode.load();
		}
		$("#searchBtn").click(function() {
			sch();
		});
		$('#stxt').keypress(function(e){
		    if(e.which == 13){
		    	sch();
		    }
		});
		
		$(window).resize(function() {
			gheight = $('body').height()-miHeight;
			gridCodeMan.setHeight(gheight);
			gridCodeMan.setWidth($('.innerB').width());
		})
	});
	var urlInfo;
	function goView2(url){
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
		pop_f = window.open("popView.do",'klaw',property);
	}
</script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<div class="boardSrchW">
			<div class="bS_left">
				<select id="search">
					<option value="1">제목</option>
					<option value="2">본문</option>
				</select>
			</div>
			<input type="text" id="stxt" style='ime-mode:active;' placeholder="검색어를 입력하세요">
			<span id="searchBtn" class="b_SrchBtn" style="cursor:pointer;">검색</span>
		</div>
	</div>
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="countT">총 <span id="gcnt">0</span>건</strong>
		</div>
	</div>
	<div class="innerB">
		<div id="gridList"></div>
	</div>
</div>