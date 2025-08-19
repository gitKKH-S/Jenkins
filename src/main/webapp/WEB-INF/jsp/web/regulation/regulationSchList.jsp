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
	var gridStore;
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
			height : $('body').height()-340,
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
			gheight = $('body').height()-340;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		})
	});

	function sch(){
		var statecd = $("input[name='statecd']:checked").val();
		var scTxt = $("#scTxt").val();
		var bookcd = [];
		$("input[name='bookcd']:checked").each(function(){
			bookcd.push($(this).val());
		});
		var gbn = $("input[name='gbn']:checked").val();
		
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				pagesize : $("#pagesize").val(),
				MENU_MNG_NO : $("#MENU_MNG_NO").val()
			}
		});
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val(),
				mtype : statecd,
				Schtxt : scTxt,
				gbn:gbn,
				deptsch : $("#dept").val(),
				startdt : $("#mkCaseDt1").val(),
				enddt : $("#mkCaseDt2").val()
			}
		});
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
		<table class="infoTable write" style="width:100%">
			<colgroup>
				<col style="width:10%;">
				<col style="width:*;">
				<col style="width:10%;">
				<col style="width:*;">
			</colgroup>
			<tr>
				<th>검색어</th>
				<td>
					<input type="text" id="scTxt" name="scTxt">
				</td>
				<th>검색구분</th>
				<td>
					<input type="radio" name="gbn" value="T" checked>제목 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="gbn" value="TC" >제목+내용 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="gbn" value="C" >내용
				</td>
			</tr>
			<tr>
				<th>제/개정일</th>
				<td>
					<input type="text" class="datepick" style="width:80px;" id="mkCaseDt1" name="mkCaseDt1"> ~
					<input type="text" class="datepick" style="width:80px;" id="mkCaseDt2" name="mkCaseDt2">
				</td>
				<th>연혁구분</th>
				<td>
					<input type="radio" name="statecd" value="htree" checked>현행 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="statecd" value="ctree" >폐지
				</td>
			</tr>
			<tr>
				<th>규정구분</th>
				<td>
					<input type="checkbox" name="bookcd" value="정관" checked>정관
					<input type="checkbox" name="bookcd" value="규정" checked>규정
					<input type="checkbox" name="bookcd" value="시행세칙" checked>시행세칙
					<input type="checkbox" name="bookcd" value="요령" checked>요령
					<input type="checkbox" name="bookcd" value="매뉴얼" checked>매뉴얼
					<input type="checkbox" name="bookcd" value="지침" checked>지침
				</td>
				<th>소관부서</th>
				<td><input type="text" id="dept" name="dept"></td>
			</tr>
		</table>
		</form>
	</div>
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="countT">총 <span id="gcnt">0</span>건</strong>
		</div>
		<div class="subBtnC right">
			<a href="#" onclick="sch()" class="sBtn type1">검색</a>
		</div>
	</div>
	<div class="innerB">
		<div id="gridList"></div>
	</div>
</div>