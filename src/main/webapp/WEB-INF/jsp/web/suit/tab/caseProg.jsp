<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String LWS_MNG_NO = request.getParameter("LWS_MNG_NO")==null?"":request.getParameter("LWS_MNG_NO").toString();
	String SEL_INST_MNG_NO = request.getParameter("SEL_INST_MNG_NO")==null?"":request.getParameter("SEL_INST_MNG_NO").toString();
	if(SEL_INST_MNG_NO.equals("")){
		SEL_INST_MNG_NO = request.getParameter("INST_MNG_NO")==null?"":request.getParameter("INST_MNG_NO").toString();
	}
	String tabId = request.getParameter("tabId");
	String mergeyn = request.getParameter("mergeyn");
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO");
	String MGBN = request.getParameter("MGBN");
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<style>
	#loadingCase{
		height:100%;left:0px;position:fixed;_position:absolute;top:0px;
		width:100%;filter:alpha(opacity=50);-moz-opacity:0.5;opacity:0.5;
	}
	.loading{background-color:white;z-index:9998;}
	#loadingCase_img{
		position:absolute;top:50%;left:50%;height:35px;
		margin-top:-25px;margin-left:0px;z-index:9999;
	}
	#notiLoading{
		margin-top: 13%; margin-left: 43%; font-size: 1vw; color: red; font-weight: bold; background-color: white;
	}
	.modal {
		top:0px;
		position: fixed;
		z-index:1;
		width:100%;
		height:100%;
		background-color: rgb(0,0,0);
		background-color: rgb(0,0,0,0.4);
	}
	
	.modal .modal_popup {
		position:absolute;
		top:40%;
		left:25%;
		padding:20px;
		border:1px solid #888;
		width: 50%;
		border-radius: 15px;
		background-color: #ffffff;
	}
	
	h3 {
		text-align: center;
		font-size:25px;
	}
	
	.modal .modal_popup p {
		padding:15px 0px 0px 0px;
		font-size:15px;
	}
	
	.modal .modal_popup .close_btn {
		display: block;
		padding: 10px 20px;
		background-color: rgb(116,0,0);
		border: none;
		border-radius: 5px;
		color:#fff;
		cursor: pointer;
		transition:box-shadow 0.2s;
	}
</style>
<script>
	var LWS_MNG_NO  = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO  = "<%=SEL_INST_MNG_NO%>";
	var MENU_MNG_NO  = "<%=MENU_MNG_NO%>";
	
	var gridStore;
	
	function setGrid(){
		$("#loadingCase").hide();
		$(".modal").hide();
		
		var tabRecordObj = Ext.data.Record.create([
			{name:'DOCGBN'},
			{name:'SEQ'},
			{name:'LWS_MNG_NO'},
			{name:'INST_MNG_NO'},
			{name:'PROGDT'},
			{name:'CONT'},
			{name:'HANDYN'},
			{name:'RESULT'}
		]);
		
		gridStore = new Ext.data.Store({
			baseParams : {
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO
			},
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectProgList.do"
			}),
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'SEQ'
			}, tabRecordObj)
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"DOCGBN",      dataIndex:'DOCGBN',        hidden:true},
				{header:"SEQ",         dataIndex:'SEQ',           hidden:true},
				{header:"LWS_MNG_NO",  dataIndex:'LWS_MNG_NO',    hidden:true},
				{header:"INST_MNG_NO", dataIndex:'INST_MNG_NO',   hidden:true},
				{header:"<b>구분</b>", width:15,  align:'center', dataIndex:'HANDYN', sortable:true},
				{header:"<b>일자</b>", width:15,  align:'center', dataIndex:'PROGDT', sortable:true},
				{header:"<b>내용</b>", width:70,  align:'left',   dataIndex:'CONT',   sortable:false},
				{header:"<b>결과</b>", width:15,  align:'left',   dataIndex:'RESULT', sortable:false}
			]
		});
		
		var grid = new Ext.grid.GridPanel({
			id:'hkk4',
			renderTo:'tabGrid',
			store:gridStore,
			autoWidth:true,
			width:'100%',
			autoHeight:true,
			overflowY:'hidden',
			scroll:false,
			remoteSort:true,
			cm:cmm,
			selModel:new Ext.grid.RowSelectionModel({singleSelect : false}),
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요'
			},
			stripeRows:true,
			viewConfig:{
				forceFit:true,
				enableTextSelection:true,
				emptyText : '<img src="${pageContext.request.contextPath}/resources/images/gallery_no_data.gif">'
			},
			iconCls:'icon_perlist',
			listeners:{
				beforerender:function(grid){
					
				},
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					
					var docgbn = histData.get("DOCGBN");
					var seq    = histData.get("SEQ");
					var LWS_MNG_NO = histData.get("LWS_MNG_NO");
					var INST_MNG_NO = histData.get("INST_MNG_NO");
					
					goTabView(docgbn, seq, LWS_MNG_NO, INST_MNG_NO);
				},
				contextmenu:function(e){
					e.preventDefault();
				},
				cellcontextmenu:function(grid, idx, cIdx, e){
					e.preventDefault();
				}
			}
		});
		
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO
			}
		});
		
		gridStore.load();
	}
</script>
<script type="text/javascript">
	function goTabView(gbn, seq, LWS_MNG_NO, INST_MNG_NO){
		var cw=700;
		var ch=603;
		var url = "";
		var colnm = "";
		
		if (gbn == "DATE") {
			cw = 720;
			ch = 610;
			url = "<%=CONTEXTPATH%>/web/suit/caseDateViewPop.do";
			colnm = "DATE_MNG_NO";
		} else {
			cw = 900;
			ch = 510;
			url = "<%=CONTEXTPATH%>/web/suit/caseDocViewPop.do";
			colnm = "DOC_MNG_NO";
		}
		
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
		newForm.attr("action", url);
		newForm.append($("<input/>", {type:"hidden", name:colnm,    value:seq}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goCaseInfo() {
		if(confirm("대법원에서 데이터를 받아오는데에 시간이 2~3분 소요되며,\n수신 중 시스템 사용이 불가능합니다.\n대법원에서 데이터를 받아오시겠습니까?")) {
			$("#loadingCase").show();
			
			setTimeout(function(){
				$.ajax({
					type:"POST",
					url:"${pageContext.request.contextPath}/web/suit/selectCaseInfo.do",
					data:{LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO},
					
					dataType:"json",
					async:false,
					success:function(result){
						if(result.msg == "no") {
							alert("대법원에서 사건정보가 조회되지 않았습니다.\n시스템에 등록 된 사건정보를 확인하세요.");
						}
						goReLoad();
					},
					error:function(request, status, error){
						alert("저장에 실패하였습니다. 관리자에게 문의바랍니다.");
						$("#loadingCase").hide();
					}
				});
			}, 3000);
		}
	}
</script>
<form name="tabFrm" id="tabFrm" method="post" action="" onsubmit="return false;">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="selsuit" id="selsuit" value="<%=LWS_MNG_NO%>" />
	<input type="hidden" name="selcase" id="selcase" value="<%=SEL_INST_MNG_NO%>" />
	<div id="loadingCase" class="loading">
		<img id="loadingCase_img" alt="loading" src="${resourceUrl}/paramquery-3.3.2/images/loading.gif" />
		<div id="notiLoading">
			사건정보를 가져오는 중입니다.<br/>
			시간이 오래 소요될 수 있습니다.<br/>
			화면 조작을 멈추고 기다려주세요<br/>
			※ 화면을 새로고침 하면 대법원과의 통신이 끊깁니다.
		</div>
	</div>
	<div class="subBtnW side">
		<div class="subBtnC right">
			<a href="#none" class="sBtn type1" onclick="goCaseInfo();">나의사건검색</a>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
	</div>
</form>