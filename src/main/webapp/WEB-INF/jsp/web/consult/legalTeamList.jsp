<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	int pageSize = 20;
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	Ext.onReady(function(){
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'PST_MNG_NO'},
			{name:'ROWNUMBER'},
			{name:'BBSCD'},
			{name:'TOPBBSID'},
			{name:'TITLE'},
			{name:'WRITERID'},
			{name:'WRITER'},
			{name:'UPDT'},
			{name:'HIT'},
			{name:'FCNT'}
		]);
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"${pageContext.request.contextPath}/web/pds/pdsListData.do"
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
				root:'result', totalProperty:'total', idProperty:'PST_MNG_NO'
			}, myRecordObj)
		});
		var combo = new Ext.form.ComboBox({
			  name : 'perpage',
			  width: 40,
			  store: new Ext.data.ArrayStore({
			    fields: ['id'],
			    data  : [
			      ['20'],
			      ['50'],
			      ['100']
			    ]
			  }),
			  mode : 'local',
			  value: '20',
			 
			  listWidth     : 40,
			  triggerAction : 'all',
			  displayField  : 'id',
			  valueField    : 'id',
			  editable      : false,
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
	            				start : 0,
	            				limit : newPagesize,
	            				pagesize : newPagesize
	            			}
	            		});
						
				  },scope: this
			  }
			});
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>NO</b>", width:20, align:'center', dataIndex:'ROWNUMBER'},
				{header:"<b>제목</b>", width:250, align:'left',dataIndex:'TITLE', sortable: true},
				{header:"<b>등록자</b>", width:50, align:'center', dataIndex:'WRITER', sortable: true},
				{header:"<b>등록일</b>", width:70, align:'center', dataIndex:'UPDT', sortable:true},
				{header:"<b>첨부파일</b>", width:70, align:'center', dataIndex:'FCNT', sortable:true},
				{header:"<b>조회수</b>", width:55, align:'center', dataIndex:'HIT', sortable:true}
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
					//		            alert(paging.pages);
					//	            alert(page.start);
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
			id : ids,
			renderTo : 'gridList',
			store : gridStore,
			autoWidth : true,
			width : '100%',
			height : $('body').height()-270,
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
			bbar : bbar,
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
					goView(histData.get("LAWID"));
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
				pagesize : $("#pagesize").val(),
				MENU_MNG_NO : $("#MENU_MNG_NO").val()
			}
		});
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val()
			}
		});
		
		function renderDate(value) {
			if (value == '' || value == undefined) {
				return '';
			}
			else {
				y = value.substr(0,4);
				m = value.substr(4,2);
				d = value.substr(6,2);
				//console.log(y+"-"+m+"-"+d);
				getDate = new Date(y+"-"+m+"-"+d);
			}
			return Ext.util.Format.date(getDate, 'Y-m-d');
		}
		
		$(window).resize(function() {
			gheight = $('body').height()-270;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		})
	});

	function goView(LAWID) {
		var frm = document.goList;
		frm.LAWID.value = LAWID;
		frm.action = "${pageContext.request.contextPath}/web/law/lawViewPage.do";
		frm.submit();
	}
</script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<form name="goList" method="post">	
		<input type="hidden" name="pageno"/>
		<input type="hidden" name="PST_MNG_NO"/>
		<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
		<input type="hidden" name="pagesize" id="pagesize" value="<%=pageSize%>"/>
		<div class="boardSrchW">
			<div class="bS_left">
				<input type="checkbox" checked="checked"> <label>제목</label>
				<input type="checkbox"> <label>내용</label>
				<input type="checkbox"> <label>작성자</label>
			</div>
			<input type="text" placeholder="검색어를 입력하세요">
			<a href="" class="b_SrchBtn">검색</a>
		</div>
		</form>
	</div>
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="countT">총 <span id="gcnt">0</span>건</strong>
		</div>
		<div class="subBtnC right">
			<!-- 
			<a href="" class="sBtn type2">대장출력</a>
			<a href="" class="sBtn type2">일괄다운로드</a>
			 -->
			<a href="<%=CONTEXTPATH%>/web/consult/consultWritePage.do" class="sBtn type1">등록</a>
		</div>
	</div>
	<div class="innerB">
		<div id="gridList"></div>
	</div>
</div>