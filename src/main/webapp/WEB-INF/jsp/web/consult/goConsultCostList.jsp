<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.consult.service.ConsultService"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%

	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String writer = request.getAttribute("writer")==null?"":request.getAttribute("writer").toString();
	String writerid = request.getAttribute("writerid")==null?"":request.getAttribute("writerid").toString();
	String deptname = request.getAttribute("deptname")==null?"":request.getAttribute("deptname").toString();
	String deptid = request.getAttribute("deptid")==null?"":request.getAttribute("deptid").toString();
	String Constants = request.getAttribute("Constants")==null?"":request.getAttribute("Constants").toString();
	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
	
	//System.out.println("Constants : " + Constants);
	System.out.println("=====================================>MENU_MNG_NO : " + MENU_MNG_NO);
	
	
	

	String inoutcd = ServletRequestUtils.getStringParameter(request, "inoutcd", "");
    String consultcatcd = Constants;
    //String consultcatcd = Constants.Counsel.TYPE_GNLR;
    String schKey = ServletRequestUtils.getStringParameter(request, "schKey", "");
    String schVal = ServletRequestUtils.getStringParameter(request, "schVal", "");
    String sortcd = ServletRequestUtils.getStringParameter(request, "sortcd", "a.consultid desc");
    String consultstatecd = ServletRequestUtils.getStringParameter(request, "consultstatecd", "완료");
    
    
    /**/
    int pageSize = 20;
	/**/
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
%>

<style>
.sBtn {
    display: inline-block;
    min-width: 0px;
    height: 35px;
    line-height: 35px;
    border-radius: 20px;
    text-align: center;
    font-size: 13px;
    padding: 0 20px;
    margin: 0 1px;
}

.subCA {
    height: 100%;
    padding: 30px;
    overflow-y: auto;
    /* overflow-y: hidden; */
}


</style>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">

	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	var gridStore,grid;
	Ext.onReady(function(){
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name: 'rownum'},
			{name: 'costid'},
            {name: 'title'},
            {name: 'bankname'},
            {name: 'account'},
            {name: 'accountowner'},
            {name: 'cost'},
            {name: 'startdt'},
            {name: 'office'},
            {name: 'consultcnt'},
            {name: 'writer'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"${pageContext.request.contextPath}/web/consult/CostListData.do"
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
				root:'result', totalProperty:'total', idProperty:'costid'
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
	            				
	            			}
	            		});
						
				  },scope: this
			  }
			});
		var cmm = new Ext.grid.ColumnModel({
		
			columns:[
				{header:"<b></b>", width:5 , align:'center', dataIndex:'rownum'},
				{header:"<b>자문ID</b>", width:30 , align:'center', dataIndex:'costid', hidden: true},
				{header:"<b>제목</b>", width:50 , align:'center', dataIndex:'title', sortable: true},
				{header:"<b>법인명</b>", width:20, align:'center', dataIndex:'office', sortable: true},
				{header:"<b>은행</b>", width:10 , align:'center', dataIndex:'bankname', sortable: true},
				{header:"<b>계좌번호</b>", width:20 , align:'center', dataIndex:'account', sortable: true},
				{header:"<b>예금주</b>", width:10, align:'center', dataIndex:'accountowner', sortable: true},
				{header:"<b>자문료</b>", width:20, align:'center', dataIndex:'cost', sortable: true},
				{header:"<b>산정기간</b>", width:20, align:'center', dataIndex:'startdt', sortable: true},
				{header:"<b>자문건수</b>", width:20, align:'center', dataIndex:'consultcnt', sortable: true},
				{header:"<b>작성자</b>", width:20, align:'center', dataIndex:'writer', sortable: true}
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
		grid = new Ext.grid.GridPanel({
			id : ids,
			renderTo : 'gridList',
			store : gridStore,
			autoWidth : true,
			width : '100%',
			height : $('body').height()-210,
			overflowY : 'scroll',
			autoScroll : true,
			remoteSort : true,
			cm : cmm,
			loadMask : {
				msg : '로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows : false,
			viewConfig : {
				forceFit : true,
				enableTextSelection : true,
				emptyText : '조회된 데이터가 없습니다.'
			},
			bbar : bbar,
			iconCls : 'icon_perlist',
			listeners : {
				cellclick : function(grid, iCellEl, iColIdx, iStore, iRowEl,iRowIdx, iEvent) {
					
				},
				rowclick:function(grid, idx, e){
					var selModel= grid.getSelectionModel();
					var histData = selModel.getSelected();
					var costid = histData.get('costid');
					
					gotoview(costid);
				},
				contextmenu : function(e) {
					e.preventDefault();
				},
				cellcontextmenu : function(grid, idx, cIdx, e) {
					e.preventDefault();
				}
			}
		});
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				pagesize : $("#pagesize").val()
			}
		});
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val()
			}
		});
		
		$(window).resize(function() {
			gheight = $('body').height()-210;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		})
	});
	
	/**
	 * 자문의뢰 조회 페이지 이동
	 */
	 function gotoview(costid){
		var frm = document.goList;
		frm.costid.value = costid;
		frm.action = "goConsultCostView.do";
		frm.submit();
	}
	
	//var MENU_MNG_NO = document.getElementById("MENU_MNG_NO").value;	
	function goWritePage() {
		var frm = document.goList;
		frm.action = "${pageContext.request.contextPath}/web/consult/goConsultCostWrite.do";
		frm.submit();
		
	}
	
	
	function goSch(){
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				start : 0,
				limit : <%=pageSize%>,
				pagesize : <%=pageSize%>
			}
		});
		gridStore.load();
	}
	
	function excelDownload(){ 
		document.goList.action = "<%=CONTEXTPATH%>/web/consult/consultExcelDownload.do";
		document.goList.submit();
	}
</script>

<body>
<form name="goList" method="post">
	<input type="hidden" name="pagesize" id="pagesize" value="<%=pageSize%>" />
	<input type="hidden" name="costid" id="costid"/>
	<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>"> 
	
	<div class="subCA">
		<strong class="subTT" id="subTT"></strong>
		<div class="innerB">
			<div class="boardSrchW">
				<input type="text" id="stxt" style='ime-mode:active;' placeholder="검색어를 입력하세요">
				<span id="searchBtn" class="b_SrchBtn" style="cursor:pointer;">검색</span>
			</div>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="countT">총 <span id="gcnt">0</span>건</strong>
			</div>
			<div class="subBtnC right">
				<a href="#none" class="sBtn type2" onclick="excelDownload();">엑셀다운로드</a>
				<a href="#none" class="sBtn type1" onclick="goWritePage()">자문료지급정보 등록</a>
			</div>
		</div>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</form>
</body>