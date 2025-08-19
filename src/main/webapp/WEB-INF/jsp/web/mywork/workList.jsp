<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	int pageSize = 20;
	String consultwork = "";
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	var progressGrid;
		
	var sgrid;
	Ext.onReady(function(){
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'TASK_GBN'},
			{name:'TASK_SE_NM'},
			{name:'DOC_PK1'},
			{name:'DOC_PK2'},
			{name:'DOC_NM'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/selectMyWorkList.do"
			}),
			remoteSort:true,
			listeners:{
				load:function(store, records, success) {
					$("#gcnt2").text(store.getTotalCount());
					$("#gcnt2").number(true);
				}
			},
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'DOC_PK1'
			}, myRecordObj)
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>구분</b>",     dataIndex:'TASK_GBN', hidden:true},
				{header:"<b>PK1</b>",      dataIndex:'DOC_PK1',  hidden:true},
				{header:"<b>PK2</b>",      dataIndex:'DOC_PK2',  hidden:true},
				{header:"<b>업무구분</b>", width:100, align:'left', dataIndex:'TASK_SE_NM', sortable:true},
				{header:"<b>문서명</b>",   width:300, align:'left', dataIndex:'DOC_NM',     sortable:true}
			]
		});
		
		sgrid = new Ext.grid.GridPanel({
			id:ids,
			renderTo:'gridList',
			store:gridStore,
			autoWidth:true,
			width:'100%',
			height:$('body').height()-200,
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
			iconCls:'icon_perlist',
			listeners:{
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					
					var gbn = histData.get("TASK_GBN");
					var DOC_PK1 = histData.get("DOC_PK1");
					var DOC_PK2 = histData.get("DOC_PK2");
					goDocView(gbn, DOC_PK1, DOC_PK2);
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
				start:0,
				limit:1000
				/* ,
				gbn:'R',
				schGbn:'4'
				 */
			}
		});
		gridStore.load({
			params:{
				start:0,
				limit:1000
				/* ,
				gbn:'R',
				schGbn:'4' */
			}
		});
		
		$(window).resize(function() {
			gheight = 200;
			sgrid.setHeight(gheight);
			sgrid.setWidth($('#type3 .innerB').width());
		});
	});
	
	function goDocView(gbn, DOC_PK1, DOC_PK2) {
		if (gbn == "SUIT") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","workInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "workInfo");
			newForm.attr("action", CONTEXTPATH+"/web/suit/caseViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:DOC_PK1}));
			newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:DOC_PK2}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "CONSULT") {
			// 자문 팝업
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","workInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "workInfo");
			newForm.attr("action", CONTEXTPATH+"/web/consult/consultViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"consultid", value:DOC_PK1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "AGREE") {
			// 자문 팝업
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","workInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "workInfo");
			newForm.attr("action", CONTEXTPATH+"/web/agree/agreeViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:DOC_PK1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "SCONSULT") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","workInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "workInfo");
			newForm.attr("action", CONTEXTPATH+"/web/suit/suitConsultViewPagePop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_RQST_MNG_NO", value:DOC_PK1}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	}
</script>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/seoul/css/search.css">
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div id="type3">
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="countT">나의 할 일 : 총 <span id="gcnt2">0</span>건</strong>
			</div>
		</div>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</div>