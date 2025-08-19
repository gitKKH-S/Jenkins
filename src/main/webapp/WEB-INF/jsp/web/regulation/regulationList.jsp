<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	int pageSize = 20;
	String mtype = request.getParameter("mtype")==null?"htree":request.getParameter("mtype");
	String gbnid = request.getParameter("gbnid")==null?"":request.getParameter("gbnid");
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	Ext.onReady(function(){
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name: 'ORDSORT', sortType: 'asInt'},
			{name: 'ROWNUMBER'},
			{name: 'BOOKID'},
            {name: 'OBOOKID'},
            {name: 'CATID'},
            {name: 'BOOKCODE'},
            {name: 'BOOKCD'},
            {name: 'TITLE'},
            {name: 'REVCD'},
            {name: 'REVCHA'},
            {name: 'STATECD'},
            {name: 'PROMULDT'},
            {name: 'STARTDT'},
            {name: 'DEPTNAME'},
            {name: 'NOFORMYN'},
            {name: 'STATEHISTORYID'}
		]);
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"${pageContext.request.contextPath}/web/regulation/regulationListData.do"
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
				root:'result', totalProperty:'total', idProperty:'BOOKID'
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
	            				pagesize : newPagesize,
	            				mtype : '<%=mtype%>',
	            				gbnid : '<%=gbnid%>'
	            			}
	            		});
						
				  },scope: this
			  }
			});
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>NO</b>", width:20, align:'center', dataIndex:'ROWNUMBER'},
				{header: '<b>규정명</b>', width: 50, style: 'text-align: center', dataIndex: 'TITLE', sortable: true},
				{header: '<b>제·개정</b>', width: 15, align: 'center', dataIndex: 'REVCD', sortable: true},
				{header: '<b>공포일</b>', width: 15, align: 'center', dataIndex: 'PROMULDT', sortable: true},
				{header: '<b>시행일</b>', width: 15, align: 'center', dataIndex: 'STARTDT', sortable: true},
				{header: '<b>담당부서</b>', width: 20, align: 'center', dataIndex: 'DEPTNAME', sortable: true},
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
			height : $('body').height()-210,
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
					goRegulationView(histData.get("BOOKID"),histData.get("NOFORMYN"))
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
		
		var stitle = 'N';
		var scontent = 'N';
		var swriter = 'N';
		if($("#stitle").is(":checked")){
			stitle = 'Y';
		}
		if($("#scontent").is(":checked")){
			scontent = 'Y';
		}
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
					pagesize : $("#pagesize").val(),
					MENU_MNG_NO : $("#MENU_MNG_NO").val(),
				mtype : '<%=mtype%>',
				gbnid : '<%=gbnid%>',
				Schtxt : $("#stxt").val(),
				stitle : stitle,
				scontent : scontent
			}
		});
		
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val(),
				mtype : '<%=mtype%>',
				gbnid : '<%=gbnid%>'
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
			gheight = $('body').height()-210;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		})
		
		$("#stxt").keydown(function(key) {
            if (key.keyCode == 13) {
            	//$('#searchBtn').trigger('click');
            	sch();
            }
        });
		
		$("#searchBtn").click(function(){
			sch();
		});
		
		$("#mkexcel").click(function(){
            
            var url = "${pageContext.request.contextPath}/web/regulation/regulationListDataMakeExcel.do";
			var obj = gridStore.baseParams;
            var inputs = '';
            for(var key in obj) {
            	//inputs+='<input type="hidden" name="'+ key +'" value="'+ obj[key] +'" />'; 
            }
            
            var stitle = 'N';
			var scontent = 'N';
			var swriter = 'N';
			if($("#stitle").is(":checked")){
				stitle = 'Y';
			}
			if($("#scontent").is(":checked")){
				scontent = 'Y';
			}
			inputs+='<input type="hidden" name="start" value="'+ 0 +'" />';
			inputs+='<input type="hidden" name="limit" value="10000000" />';
			inputs+='<input type="hidden" name="pagesize" value="10000000" />';
			inputs+='<input type="hidden" name="MENU_MNG_NO" value="'+ $("#MENU_MNG_NO").val() +'" />';
			inputs+='<input type="hidden" name="Schtxt" value="'+ $("#stxt").val() +'" />';
			inputs+='<input type="hidden" name="stitle" value="'+ stitle +'" />';
			inputs+='<input type="hidden" name="scontent" value="'+ scontent +'" />';
			inputs+='<input type="hidden" name="mtype" value="<%=mtype%>" />';
			inputs+='<input type="hidden" name="gbnid" value="<%=gbnid%>" />';
            
            if(gridStore.getSortState()){
            	inputs+='<input type="hidden" name="sort" value="'+ gridStore.getSortState().field +'" />';
            	inputs+='<input type="hidden" name="dir" value="'+ gridStore.getSortState().direction +'" />';
            }
            
            jQuery('<form action="'+ url +'" method="POST">'+inputs+'</form>').appendTo('.subTT').submit().remove();
		});
	});
	
	function goView(LAWID) {
		var frm = document.goList;
		frm.LAWID.value = LAWID;
		frm.action = "${pageContext.request.contextPath}/web/law/lawViewPage.do";
		frm.submit();
	}
	
	function sch(){
		var stitle = 'N';
		var scontent = 'N';
		var swriter = 'N';
		if($("#stitle").is(":checked")){
			stitle = 'Y';
		}
		if($("#scontent").is(":checked")){
			scontent = 'Y';
		}
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				start : 0,
				limit : $("#pagesize").val(),
				pagesize : $("#pagesize").val(),
				mtype : '<%=mtype%>',
				gbnid : '<%=gbnid%>',
				Schtxt : $("#stxt").val(),
				stitle : stitle,
				scontent : scontent
			}
		});
		gridStore.load();
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
		</form>
		<div class="boardSrchW">
			<div class="bS_left">
				<input type="checkbox" id="stitle" checked="checked"> <label>규정명</label>
				<input type="checkbox" id="scontent" checked="checked"> <label>본문내용</label>
			</div>
			<input type="text" id="stxt" placeholder="검색어를 입력하세요">
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