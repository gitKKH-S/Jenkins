<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	int pageSize = 20;
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
%>
<style>
	p{color:#57b9ba; font-size:15px; font-weight:bold;}
</style>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/resources/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	Ext.onReady(function(){
		
		<%
		for(int i=0; i<sf.length; i++){
			System.out.println("searchForm===>"+sf[i]);
			String setv[] = sf[i].split("\\|");
			if(setv.length==2){
		%>
			if('<%=setv[0]%>' == "schGbn"){
				$("input:radio[name=schGbn]:radio[value='" + "<%=setv[1]%>" + "']").prop("checked", true);
			}else{
				$("#<%=setv[0]%>").val('<%=setv[1]%>');
			}
		<%
			}
		}
		%>
		
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'LWS_RQST_MNG_NO'},
			{name:'IMPT_LWS_YN'},
			{name:'LWS_INCDNT_NM'},
			{name:'PRGRS_STTS_NM'},
			{name:'LWS_RLT_NM'},
			{name:'LWS_RQST_EMP_NM'},
			{name:'LWS_RQST_YMD'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectConsultSuitList.do"
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
				root:'result', totalProperty:'total', idProperty:'LWS_RQST_MNG_NO'
			}, myRecordObj)
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
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>의뢰PK</b>",       dataIndex:'LWS_RQST_MNG_NO',  hidden:true},
				{header:"<b>중요소송여부</b>", dataIndex:'IMPT_LWS_YN',      hidden:true},
				{header:"<b>사건명</b>",     width:150, align:'left',   dataIndex:'LWS_INCDNT_NM',   sortable:true},
				{header:"<b>진행상태</b>",   width:100, align:'center', dataIndex:'PRGRS_STTS_NM',   sortable:true},
				{header:"<b>소송상대방</b>", width:100, align:'center', dataIndex:'LWS_RLT_NM',      sortable:true},
				{header:"<b>의뢰직원</b>",   width:150, align:'center', dataIndex:'LWS_RQST_EMP_NM', sortable:true},
				{header:"<b>의뢰일</b>",     width:100, align:'center', dataIndex:'LWS_RQST_YMD',    sortable:true}
			]
		});
		
		var bbar = new Ext.PagingToolbar({
			pagesize:$("#pagesize").val(),
			autoWidth:true,
			store:gridStore,
			displayInfo:true,
			items:['-', 'Per Page: ', combo],
			displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색 된 결과가 없습니다.",
			listeners:{
				beforechange:function(paging, page, eopts) {},
				change:function(thisd, params) {
					
				}
			}
		});
		
		var grid = new Ext.grid.GridPanel({
			id:ids,
			renderTo:'gridList',
			store:gridStore,
			autoWidth:true,
			width:'100%',
			height:$('body').height()-300,
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
				emptyText:'조회된 데이터가 없습니다.'
			},
			bbar:bbar,
			iconCls:'icon_perlist',
			listeners:{
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var obj = gridStore.baseParams;
					var searchForm = "";
					for(var key in obj){
						searchForm = searchForm + "," + (key+"|"+obj[key]);
					}
					$("#searchForm").val(searchForm);
					
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					var LWS_RQST_MNG_NO = histData.get("LWS_RQST_MNG_NO");
					goView(LWS_RQST_MNG_NO);
				},
				contextmenu:function(e){
					e.preventDefault();
				},
				cellcontextmenu:function(grid, idx, cIdx, e){
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
		
		$(window).resize(function() {
			gheight = $('body').height()-300;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		});
		
		$("#stxt").keydown(function(key) {
			if (key.keyCode == 13) {
				$('#searchBtn').trigger('click');
			}
		});
		
		$("input:radio[name=schGbn]").click(function(){
			$('#searchBtn').trigger('click');
		});
		
		$("#searchBtn").click(function(){
			gridStore.load({
				params : {
					start : 0,
					limit : $("#pagesize").val()
				}
			});
		});
	});
	
	function goView(LWS_RQST_MNG_NO){
		document.getElementById("LWS_RQST_MNG_NO").value = LWS_RQST_MNG_NO;
		document.frm.action="<%=CONTEXTPATH%>/web/suit/suitConsultViewPage.do";
		document.frm.submit();
	}
	
	function goReLoad(){
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/goSuitConsultList.do";
		document.frm.submit();
	}
	
	function goWritePage(){
		var obj = gridStore.baseParams;
		var searchForm = "";
		for(var key in obj){
			searchForm = searchForm + "," + (key+"|"+obj[key]);
		}
		$("#searchForm").val(searchForm);
		document.frm.action="<%=CONTEXTPATH%>/web/suit/suitConsultWritePage.do";
		document.frm.submit();
	}
</script>
<script>
	$(document).ready(function(){  //문서가 로딩될때
		$('input:radio[name="schGbn"]:radio[value="0"]').prop("checked", true);
	});
	
	function goReset(){
		
	}
</script>

<form id="test" name="test" method="post" action="" enctype="multipart/form-data">
</form>

<form name="frm" id=frm method="post" action="">
	<input type="hidden" name="LWS_RQST_MNG_NO"  id="LWS_RQST_MNG_NO"  value="0" />
	<input type="hidden" name="pageno"      id="pageno"      value=""/>
	<input type="hidden" name="searchForm"  id="searchForm"  value=""/>
	<input type="hidden" name="pagesize"    id="pagesize"    value="<%=pageSize%>"/>
	<input type="hidden" name="MENU_MNG_NO"      id="MENU_MNG_NO"      value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM"      id="WRTR_EMP_NM"      value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"    id="WRTR_EMP_NO"    value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"      id="WRT_DEPT_NO"      value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"    id="WRT_DEPT_NM"    value="<%=WRT_DEPT_NM%>" />
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="subBtnC right" id="test">
			
		</div>
		<div class="innerB">
			<table class="infoTable write" style="width:100%" id="stxt">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>사건명/사건개요</th>
					<td colspan="3"><input type="text" id="suitNm" name="suitNm" style="width:80%" value=""></td>
					<th>소송상대방</th>
					<td><input type="text" id="caseNo" name="caseNo" style="width:80%"></td>
				</tr>
			</table>
		</div>
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" id="searchBtn">검색</a>
			<a href="#none" class="sBtn type2" onclick="goReset();">초기화</a>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="countT">총 <span id="gcnt">0</span>건</strong>
				<!-- 
				<input type="radio" name="schGbn" id="schGbn0" value="0"><label>전체</label>
				<input type="radio" name="schGbn" id="schGbn1" value="1"><label>진행중</label>
				<input type="radio" name="schGbn" id="schGbn2" value="2"><label>종결</label>
				<input type="radio" name="schGbn" id="schGbn3" value="3"><label>내사건</label>
				 -->
			</div>
			<div class="subBtnC right">
				<a href="#none" class="sBtn type1" onclick="goWritePage();">등록</a>
			</div>
		</div>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</form>