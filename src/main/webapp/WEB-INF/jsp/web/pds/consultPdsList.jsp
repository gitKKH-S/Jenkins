<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	int pageSize = 20;

	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO");
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">

	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	Ext.onReady(function(){
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'PST_MNG_NO'},
			{name:'ROWNUMBER'},
			{name:'BBS_SE'},
			{name:'UP_PST_MNG_NO'},
			{name:'PST_TTL'},
			{name:'WRTR_EMP_NO'},
			{name:'WRTR_EMP_NM'},
			{name:'WRT_YMD'},
			{name:'PST_INQ_CNT'},
			{name:'FCNT'},
			{name:'RMRK_CN'},
			{name:'PRCS_STTS_SE_NM'},
			{name:'DOC_MNG_NO'} // A.RMRK_CN,A.PRCS_STTS_SE_NM,A.DOC_MNG_NO
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
				{header:"<b>관리번호</b>", width:70, align:'center',dataIndex:'DOC_MNG_NO', sortable: true},
				{header:"<b>등록일</b>", width:70, align:'center', dataIndex:'WRT_YMD', sortable:true},
				{header:"<b>제목</b>", width:200, align:'left',dataIndex:'PST_TTL', sortable: true},
				{header:"<b>등록자</b>", width:70, align:'center', dataIndex:'WRTR_EMP_NM', sortable: true},
				{header:"<b>처리상태</b>", width:50, align:'center', dataIndex:'PRCS_STTS_SE_NM', sortable: true},
				{header:"<b>첨부파일</b>", width:50, align:'center', dataIndex:'FCNT', sortable:true},
// 				{header:"<b>조회수</b>", width:55, align:'center', dataIndex:'PST_INQ_CNT', sortable:true}
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
// 			height : $('body').height()-270,
			autoHeight:true,
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
					var PST_MNG_NO = (histData.get("PST_MNG_NO")+"").replace('T','');
					//alert(PST_MNG_NO)
					goView(PST_MNG_NO);
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
		
		$("#mkexcel").click(function(){
            
            var url = "${pageContext.request.contextPath}/web/pds/pdsListDataMakeExcel.do";
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
			if($("#swriter").is(":checked")){
				swriter = 'Y';
			}
			inputs+='<input type="hidden" name="start" value="'+ 0 +'" />';
			inputs+='<input type="hidden" name="limit" value="10000000" />';
			inputs+='<input type="hidden" name="pagesize" value="10000000" />';
			inputs+='<input type="hidden" name="MENU_MNG_NO" value="'+ MENU_MNG_NO +'" />';
			inputs+='<input type="hidden" name="Schtxt" value="'+ $("#stxt").val() +'" />';
			inputs+='<input type="hidden" name="stitle" value="'+ stitle +'" />';
			inputs+='<input type="hidden" name="scontent" value="'+ scontent +'" />';
			inputs+='<input type="hidden" name="swriter" value="'+ swriter +'" />';
            
            if(gridStore.getSortState()){
            	inputs+='<input type="hidden" name="sort" value="'+ gridStore.getSortState().field +'" />';
            	inputs+='<input type="hidden" name="dir" value="'+ gridStore.getSortState().direction +'" />';
            }
            
            jQuery('<form action="'+ url +'" method="POST">'+inputs+'</form>').appendTo('.subTT').submit().remove();
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
		});
		
		$("#sBtn").click(function(){
			var frm = document.goList;
			frm.action="${pageContext.request.contextPath}/web/pds/pdsWrite.do";
			frm.submit();
		});
		
		$("#stxt").keydown(function(key) {
            if (key.keyCode == 13) {
            	$('#searchBtn').trigger('click');
            }
        });

		$("#searchBtn").click(function(){
			var stitle = 'N';
			var scontent = 'N';
			var swriter = 'N';
			if($("#stitle").is(":checked")){
				stitle = 'Y';
			}
			if($("#scontent").is(":checked")){
				scontent = 'Y';
			}
			if($("#swriter").is(":checked")){
				swriter = 'Y';
			}
			gridStore.load({
				params : {
					start : 0,
					limit : $("#pagesize").val(),
					MENU_MNG_NO : $("#MENU_MNG_NO").val(),
					Schtxt : $("#stxt").val(),
					stitle : stitle,
					scontent : scontent,
					swriter : swriter
				}
			});
		});
		
// 		$("#showgian").click(function(){
// 			gianLayer('PDS','app','12345');
// 		});
		
// 		$("#showgian2").click(function(){
// 			gianStart('PDS','app','12345');
// 		});
// 		$("#showgian3").click(function(){
// 			showGianList('PDS','app','12345','gianTable');
// 		});
	});

	function goView(PST_MNG_NO) {
		var frm = document.goList;
		frm.PST_MNG_NO.value = PST_MNG_NO;
		frm.MENU_MNG_NO.value = MENU_MNG_NO;
		frm.action = "${pageContext.request.contextPath}/web/pds/pdsView.do";
		frm.submit();
	}
	
	function listFileDownload(){
		document.down.action = "<%=CONTEXTPATH%>/web/pds/listFileDownload.do";
		document.down.submit();
	}
</script>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong><strong id="tnotic" style="color:red;float:right;display:none;">* 등록된 계약서는 임시 양식이므로 부서 상황에 맞게 편집하여 사용하시기 바랍니다.</strong>
	<div class="innerB">
		<form id="down" name="down" method="post" action="" enctype="multipart/form-data">
			<input type="hidden" name="fileMenuid" id="fileMenuid" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
		</form>
		<form name="goList" method="post">	
		<input type="hidden" name="pageno"/>
		<input type="hidden" name="PST_MNG_NO"/>
		<input type="hidden" name="BBS_SE" id="BBS_SE" value="PDS"/>
		<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
		<input type="hidden" name="pagesize" id="pagesize" value="<%=pageSize%>"/>
		</form>
		<div class="boardSrchW">
			<div class="bS_left">
				<input type="checkbox" id="stitle" checked="checked"> <label>제목</label>
				<input type="checkbox" id="scontent" checked="checked"> <label>내용</label>
				<input type="checkbox" id="swriter" checked="checked"> <label>작성자</label>
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
<!-- 			<a id="showgian3" class="sBtn type2">결재내역</a> -->
<!-- 			<a id="showgian2" class="sBtn type2">승인테스트</a> -->
<!-- 			<a id="showgian" class="sBtn type2">결재테스트</a> -->
			<a id="mkexcel" class="sBtn type2">대장출력</a>
			<a href="#none" class="sBtn type2" onclick="listFileDownload();">일괄다운로드</a>
			<a id="sBtn" class="sBtn type1">등록</a>
		</div>
	</div>
	<div id="gianTable"></div>
	<div class="innerB">
		<div id="gridList"></div>
	</div>
</div>