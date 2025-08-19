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
	String adminYn = request.getParameter("adminYn");

	String SPRVSN_DEPT_NO = request.getParameter("SPRVSN_DEPT_NO");
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script>
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";
	var mergeyn = "<%=mergeyn%>";
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	function setGrid(){
		
		var tabRecordObj = Ext.data.Record.create([
			{name:'DOC_MNG_NO'},
			{name:'DATE_MNG_NO'},
			{name:'INST_MNG_NO'},
			{name:'LWS_MNG_NO'},
			{name:'DOC_SE'},
			{name:'DOC_SE_NM'},
			{name:'DOC_YMD'},
			{name:'DOC_CN'},
			{name:'DOC_TYPE_CD'},
			{name:'DOC_TYPE_NM'},
			{name:'HWRT_REG_YN'},
			{name:'VIEWFILENM'},
			{name:'SERVERFILENM'}
		]);
		
		var gridStore = new Ext.data.Store({
			baseParams : {
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO,
				mergeyn:mergeyn
			},
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectDocList.do"
			}),
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'DOC_MNG_NO'
			}, tabRecordObj)
		});
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"DOC_MNG_NO",  dataIndex:'DOC_MNG_NO',   hidden:true},
				{header:"LWS_MNG_NO",  dataIndex:'LWS_MNG_NO',   hidden:true},
				{header:"INST_MNG_NO", dataIndex:'INST_MNG_NO',  hidden:true},
				{header:"DOC_SE_NM",   dataIndex:'DOC_SE_NM',    hidden:true},
				{header:"서버파일명",  dataIndex:'SERVERFILENM', hidden:true},
				{header:"<b>구분</b>",        width:15,  align:'center', dataIndex:'DOC_SE_NM',   sortable:true},
				{header:"<b>문서종류</b>",    width:20,  align:'center', dataIndex:'DOC_TYPE_NM', sortable:true},
				{header:"<b>제출/송달일</b>", width:20,  align:'center', dataIndex:'DOC_YMD',     sortable:true},
				{header:"<b>문서내용</b>",    width:100, align:'left',   dataIndex:'DOC_CN',      sortable:true},
				{header:"<b>파일</b>",        width:50,  align:'left',   dataIndex:'VIEWFILENM',  sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel = grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var html = "";
						if(rowData.get("SERVERFILENM") != null && rowData.get("SERVERFILENM") != ""){
							var viewfile = rowData.get("VIEWFILENM").split(",");
							var serverfile = rowData.get("SERVERFILENM").split(",");
							html+="<ul>";
							for(var j=0; j<viewfile.length; j++){
								html+="<li><a href='#none' onclick='downFile(\""+viewfile[j]+"\",\""+serverfile[j]+"\", \"SUIT\")' title=\""+viewfile[j]+"\">"+viewfile[j]+"</a></li>";
							}
							html+="</ul>";
						}
						return html;
						
					}
				}
				//,{header:"<b>결정문여부</b>", width:60, align:'center', dataIndex:'DECISIONYN', sortable:true}
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
				emptyText:'조회된 데이터가 없습니다.'
			},
			iconCls:'icon_perlist',
			listeners:{
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					var DOC_MNG_NO = histData.get("DOC_MNG_NO");
					var LWS_MNG_NO = histData.get("LWS_MNG_NO");
					var INST_MNG_NO = histData.get("INST_MNG_NO");
					goTabView(DOC_MNG_NO, LWS_MNG_NO, INST_MNG_NO);
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
				INST_MNG_NO:INST_MNG_NO,
				mergeyn:mergeyn
			}
		});
		
		gridStore.load();
	}
</script>

<script type="text/javascript">
	function goTabView(DOC_MNG_NO, LWS_MNG_NO, INST_MNG_NO){
		var cw=900;
		var ch=510;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseDocViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"DOC_MNG_NO", value:DOC_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	//등록페이지
	function goTabWrite(DOC_MNG_NO){
		var cw=1100;
		var ch=907;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseDocWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"DOC_MNG_NO", value:DOC_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
</script>
<form name="tabFrm" id="tabFrm" method="post" action="">
	<div class="subBtnW side" style="margin-top:10px;">
		<div class="subBtnC right">
		<%if((SPRVSN_DEPT_NO.equals(WRT_DEPT_NO) || "Y".equals(adminYn) || GRPCD.indexOf("X") > -1) && "MAIN".equals(MGBN)){%>
			<a href="#none" class="sBtn type1" onclick="goTabWrite('');">등록</a>
		<%}%>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
	</div>
</form>