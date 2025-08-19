<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	int pageSize = 20;
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script>
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		console.log($("#pagesize").val());
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'ROWNUMBER'},
			{name:'UNCH_DATE_MNG_NO'},
			{name:'UNCH_DATE_NM'},
			{name:'INV_DAY'},
			{name:'INV_DAY_CNT'},
			{name:'INV_SE'},
			{name:'NOTI_INV_DAY_NM'},
			{name:'NOTI_INV_DAY_CNT'},
			{name:'NOTI_YN'},
			{name:'USE_YN'},
			{name:'REL_ARTCL_SE'},
			{name:'REL_ARTCL_TYPE_CD'},
			{name:'UNCH_DATE_CN'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectUnchangeDateList.do"
			}),
			remoteSort:true,
			pagesize:$("#pagesize").val(),
			listeners:{
				load:function(store, records, success) {
					$("#gcnt").text(store.getTotalCount());
					$("#gcnt").number(true);
				}
			},
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'UNCH_DATE_MNG_NO'
			}, myRecordObj),
			pageSize:10
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>불변기일ID</b>", dataIndex:'UNCH_DATE_MNG_NO', hidden:true},
				{header:"<b>no</b>",         width:15,  align:'center', dataIndex:'ROWNUMBER'},
				{header:"<b>종류</b>",       width:100, align:'left',   dataIndex:'UNCH_DATE_NM', sortable:true},
				{header:"<b>설명</b>",       width:100, align:'left',   dataIndex:'UNCH_DATE_CN', sortable:true},
				{header:"<b>기간</b>",       width:20,  align:'center', dataIndex:'INV_DAY'},
				{header:"<b>사용여부</b>",   width:20,  align:'center', dataIndex:'USE_YN',       sortable:true}
			],
		});
		
		var combo = new Ext.form.ComboBox({
			name:'perpage',
			width:40,
			store:new Ext.data.ArrayStore({
				fields:['id'],
				data:[['20'],['50'],['100']]
			}),
			mode:'local',
			value:'20',
			listWidth:40,
			triggerAction:'all',
			displayField:'id',
			valueField:'id',
			editable:false,
			forceSelection:true,
			listeners:{
				select:function(item,newValue){
					bbar.pageSize = parseInt(newValue.get('id'), 10);
					bbar.doLoad(bbar.cursor);
					
					var newPagesize = parseInt(newValue.get('id'), 10);
					$("#pagesize").val(newPagesize);
						gridStore.pagesize = newPagesize;
						gridStore.load({
							params:{
								start:0,
								limit:newPagesize,
								pagesize:newPagesize
							}
						});
				},
				scope:this
			}
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
				beforechange : function(paging, page, eopts) { },
				change : function(thisd, params) { }
			}
		});
		
		var grid = new Ext.grid.GridPanel({
			id:ids,
			renderTo:'gridList',
			store:gridStore,
			autoWidth:true,
			width:'100%',
			height:$('body').height()-320,
			overflowY:'scroll',
			autoScroll:true,
			remoteSort:true,
			cm:cmm,
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows:false,
			viewConfig:{
				forceFit:true,
				enableTextSelection:true,
				emptyText : '<img src="${pageContext.request.contextPath}/resources/images/gallery_no_data.gif">'
			},
			bbar:bbar,
			iconCls:'icon_perlist',
			listeners:{
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					var UNCH_DATE_MNG_NO = histData.data.UNCH_DATE_MNG_NO;
					goView(UNCH_DATE_MNG_NO);
				},
				contextmenu:function(e) {
					e.preventDefault();
				},
				cellcontextmenu:function(grid, idx, cIdx, e) {
					e.preventDefault();
				}
			}
		});
		
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				pagesize : $("#pagesize").val(),
				MENU_MNG_NO : $("#MENU_MNG_NO").val(),
				'${_csrf.parameterName}' : '${_csrf.token}'
			}
		});
		
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val()
			}
		});
		
		$(window).resize(function() {
			gheight = $('body').height()-320;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		});
		
		$("#stxt").keydown(function(key) {
			if (key.keyCode == 13) {
				$('#searchBtn').trigger('click');
			}
		});
		
		$("#searchBtn").click(function(){
			gridStore.load({
				params : {
					start : 0,
					limit : $("#pagesize").val(),
					UNCH_DATE_NM : $("#UNCH_DATE_NM").val(),
					USE_YN : $("#USE_YN option:selected").val(),
					'${_csrf.parameterName}' : '${_csrf.token}'
				}
			});
		});
	});
	
	function unchDateWrite(UNCH_DATE_MNG_NO){
		var cw=790;
		var ch=555;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/unchangeDateWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"UNCH_DATE_MNG_NO", value:UNCH_DATE_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goView(UNCH_DATE_MNG_NO){
		var cw=760;
		var ch=380;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","infoView",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "infoView");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/unchangeDateViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"UNCH_DATE_MNG_NO", value:UNCH_DATE_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goReLoad(){
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/goUnchangeDate.do";
		document.frm.submit();
	}
	
	function goSch(){
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val(),
				UNCH_DATE_NM : $("#UNCH_DATE_NM").val(),
				USE_YN : $("#USE_YN option:selected").val(),
				'${_csrf.parameterName}' : '${_csrf.token}'
			}
		});
	}
	
	function goReset(){
		$('select').find('option:first').attr('selected', 'selected');
		$("#datenm").val("");
		goSch();
	}
</script>
<style>
	input{width:80%}
	#ext-gen12{min-height:100px;}
	.list_navi{
		padding:10px;
		text-align: center;
	}
	.list_navi li{
	    display: inline-block;
	    width: 30px;
	    height: 30px;
	    border-radius: 7px;
	    border:1px solid #ddd;
	    line-height: 28px;
	    text-align: center;
	    cursor:pointer;
	}
	.list_navi li.active{
	    background: #6843E2;
	    color: #fff;
	}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="UNCH_DATE_MNG_NO" id="UNCH_DATE_MNG_NO" value="" />
	<input type="hidden" name="gbn"              id="gbn"              value="" />
	<input type="hidden" name="pageno"           id="pageno"           value=""/>
	<input type="hidden" name="pagesize"         id="pagesize"         value="<%=pageSize%>"/>
	<input type="hidden" name="MENU_MNG_NO"           id="MENU_MNG_NO"           value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="innerB">
			<table class="infoTable" style="width:100%" id="stxt">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>종류</th>
					<td><input type="text" id="UNCH_DATE_NM" name="UNCH_DATE_NM"></td>
					<th>사용여부</th>
					<td>
						<select id="USE_YN" name="USE_YN"  style="width:60%">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
						<a href="#none" class="sBtn type1" id="searchBtn" style="float:right;"><i class="fa-solid fa-magnifying-glass"></i> 검색</a>
					</td>
				</tr>
			</table>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="countT">총 <span id="gcnt">0</span>건</strong>
			</div>
			<div class="subBtnC right">
				<a href="#none" class="sBtn type1" onclick="unchDateWrite('');"><i class="fa-solid fa-file-import"></i> 등록</a>
			</div>
		</div>
		<div class="innerB">
			<div id="gridList"></div>
			<div class='list_naviW'></div>
		</div>
	</div>
</form>