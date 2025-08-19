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
	String MGBN = request.getParameter("MGBN");
	String adminYn = request.getParameter("adminYn");
	
	String SPRVSN_DEPT_NO = request.getParameter("SPRVSN_DEPT_NO");
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";
	
	function goTabWrite(RPTP_MNG_NO){
		var cw=700;
		var ch=680;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/reportWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"RPTP_MNG_NO", value:RPTP_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goTabView(RPTP_MNG_NO){
		var cw=700;
		var ch=705;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/reportViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"RPTP_MNG_NO", value:RPTP_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
</script>
<script>
	function setGrid(){
		var tabRecordObj = Ext.data.Record.create([
			{name:'RPTP_MNG_NO'},
			{name:'INST_MNG_NO'},
			{name:'LWS_MNG_NO'},
			{name:'RPTP_TTL'},
			{name:'RPTP_CN'},
			{name:'WRTR_EMP_NM'},
			{name:'WRT_YMD'},
			
			{name:'SERVERFILENM'},
			{name:'VIEWFILENM'}
		]);
		var gridStore = new Ext.data.Store({
			baseParams : {
				LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO
			},
			proxy: new Ext.data.HttpProxy({
				url: "<%=CONTEXTPATH %>/web/suit/selectReportList.do"
			}),
			reader: new Ext.data.JsonReader({
				root: 'result', totalProperty: 'total', idProperty: 'RPTP_MNG_NO'
			}, tabRecordObj)
		});
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"RPTP_MNG_NO", dataIndex:'RPTP_MNG_NO',  hidden:true},
				{header:"INST_MNG_NO", dataIndex:'INST_MNG_NO',  hidden:true},
				{header:"LWS_MNG_NO",  dataIndex:'LWS_MNG_NO',   hidden:true},
				{header:"서버파일명",  dataIndex:'SERVERFILENM', hidden:true}, 
				
				{header:"<b>제목</b>",     width:120, align:'center', dataIndex:'RPTP_TTL',    sortable: true},
				{header:"<b>내용</b>",     width:150, align:'center', dataIndex:'RPTP_CN',     sortable: true},
				{header:"<b>작성일</b>",   width:60,  align:'center', dataIndex:'WRT_YMD',     sortable: true},
				{header:"<b>작성자</b>",   width:60,  align:'center', dataIndex:'WRTR_EMP_NM', sortable: true},
				{header:"<b>첨부파일</b>", width:180, align:'left',   dataIndex:'VIEWFILENM',  sortable: true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel = grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						
						var html = "";
						if(rowData.get("SERVERFILENM") != null && rowData.get("SERVERFILENM") != ""){
							var viewfile = rowData.get("VIEWFILENM").split(",");
							var serverfile = rowData.get("SERVERFILENM").split(",");
							var filetype = "";
							html+="<ul>";
							for(var j=0; j<viewfile.length; j++){
								html+="<li><a href='#none' onclick='downFile(\""+viewfile[j]+"\",\""+serverfile[j]+"\", \"SUIT\")' title=\""+viewfile[j]+"\">"+viewfile[j]+"</a></li>";
							}
							html+="</ul>";
						}
						return html;
						
					}
				}
			]
		});
		
		var grid = new Ext.grid.GridPanel({
			id : 'hkk4',
			renderTo: 'tabGrid',
			store: gridStore,
			autoWidth: true,
			width: '100%',
			autoHeight: true,
			overflowY: 'hidden',
			scroll: false,
			remoteSort: true,
			selModel: new Ext.grid.RowSelectionModel({singleSelect : false}),
			cm: cmm,
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows: true,
			viewConfig: {
				forceFit: true,
				enableTextSelection : true
			},
			iconCls: 'icon_perlist',
			listeners: {
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					var RPTP_MNG_NO = histData.get("RPTP_MNG_NO");
					goTabView(RPTP_MNG_NO);
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
				LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO
			}
		});
		
		gridStore.load();
	}
</script>
<form name="tabFrm" id="tabFrm" method="post" action="" onsubmit="return false;">
	<input type="hidden" name="selsuit" id="selsuit" value="<%=LWS_MNG_NO%>" />
	<input type="hidden" name="selcase" id="selcase" value="<%=SEL_INST_MNG_NO%>" />
</form>
	
	<div class="subBtnW side" style="margin-top:10px;">
		<div class="subBtnC right">
		<%if((SPRVSN_DEPT_NO.equals(WRT_DEPT_NO) || "Y".equals(adminYn) || GRPCD.indexOf("X") > -1) && "MAIN".equals(MGBN)){%>
			<a href="#none" class="sBtn type1" onclick="goTabWrite();">등록</a>
		<%}%>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
	</div>
