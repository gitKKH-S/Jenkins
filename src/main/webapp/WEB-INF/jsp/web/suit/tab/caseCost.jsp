<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String suitid = request.getParameter("suitid")==null?"":request.getParameter("suitid").toString();
	String selectedCaseId = request.getParameter("selectedCaseId")==null?"":request.getParameter("selectedCaseId").toString();
	String tabId = request.getParameter("tabId");
	String mergeyn = request.getParameter("mergeyn");
	String MGBN = request.getParameter("MGBN");
	String adminYn = request.getParameter("adminYn");
%>
<script>
	var suitid = "<%=suitid%>";
	var caseid = "<%=selectedCaseId%>";
	var mergeyn = "<%=mergeyn%>";
	//var gridStore;
	
	function setGrid(){
		console.log(suitid);
		var tabRecordObj = Ext.data.Record.create([
			{name:'CST_MNG_NO'},
			{name:'INST_MNG_NO'},
			{name:'LWS_MNG_NO'},
			{name:'CST_PRCS_SE'},
			{name:'CST_PRCS_NM'},
			{name:'CST_SE_CD'},
			{name:'CST_SE_NM'},
			{name:'CST_PRCS_YMD'},
			{name:'PRCS_AMT'},
			{name:'CST_TRGT_MNG_NO'},
			{name:'CST_TRGT_MNG_NM'},
			{name:'CST_PRCS_CMPTN_YN'},
			{name:'RMRK_CN'},
			{name:'VIEWFILENM'},
			{name:'SERVERFILENM'}
		]);
		
		gridStore = new Ext.data.Store({
			baseParams : {
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO
			},
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectCostList.do"
			}),
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'CST_MNG_NO'
			}, tabRecordObj)
		});
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"CST_MNG_NO", dataIndex:'CST_MNG_NO', hidden:true},
				{header:"LWS_MNG_NO", dataIndex:'LWS_MNG_NO', hidden:true},
				{header:"INST_MNG_NO", dataIndex:'INST_MNG_NO', hidden:true},
				{header:"<b>처리구분</b>", width:70, align:'center', dataIndex:'CST_PRCS_NM', sortable:true},
				{header:"<b>예산구분</b>", width:100, align:'center', dataIndex:'CST_SE_NM', sortable:true},
				{header:"<b>금액</b>", width:100, align:'right', dataIndex:'PRCS_AMT', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var amt = comma(rowData.data.PRCS_AMT);
						return amt;
					}
				},
				{header:"<b>지급대상</b>",  width:100, align:'center', dataIndex:'CST_TRGT_MNG_NM', sortable:true},
				{header:"<b>처리일자</b>", width:90, align:'center', dataIndex:'CST_PRCS_YMD', sortable:true},
				{header:"<b>완료여부</b>", width:70, align:'center', dataIndex:'CST_PRCS_CMPTN_YN', sortable:true},
				{header:"<b>파일</b>", width:100, align:'left', dataIndex:'VIEWFILENM', sortable:true,
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
			selModel:new Ext.grid.RowSelectionModel({singleSelect : false}),
			cm:cmm,
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
					var CST_MNG_NO = histData.get("CST_MNG_NO");
					var LWS_MNG_NO = histData.get("LWS_MNG_NO");
					var INST_MNG_NO = histData.get("INST_MNG_NO");
					goTabView(CST_MNG_NO, LWS_MNG_NO, INST_MNG_NO);
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
		
		gridStore.load({
			params:{
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO
			}
		});
		
		gridStore.load();
	}
	
	//등록페이지
	function goTabWrite(CST_MNG_NO){
		var cw=700;
		var ch=640;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","costWrite",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "costWrite");
		<%if(GRPCD.indexOf("X") > -1 || GRPCD.indexOf("Z") > -1) {%>
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseOutCostWritePop.do");
		<%} else {%>
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseCostWritePop.do");
		<%}%>
		newForm.append($("<input/>", {type:"hidden", name:"CST_MNG_NO", value:CST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goTabView(CST_MNG_NO, LWS_MNG_NO, INST_MNG_NO){
		var cw=700;
		var ch=610;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","costView",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "costView");
		
		<%if(GRPCD.indexOf("X") > -1 || GRPCD.indexOf("Z") > -1) {%>
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseOutCostViewPop.do");
		<%} else {%>
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseCostViewPop.do");
		<%}%>
		
		newForm.append($("<input/>", {type:"hidden", name:"CST_MNG_NO", value:CST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function editCal(){
		var cw=1000;
		var ch=600;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","calEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "calEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/costCalEditPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function downFile(viewfilenm, serverfilenm){
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("action", "${pageContext.request.contextPath}/Download.do");
		newForm.append($("<input/>", {type:"hidden", name:"Serverfile", value:serverfilenm}));
		newForm.append($("<input/>", {type:"hidden", name:"Pcfilename", value:viewfilenm}));
		newForm.append($("<input/>", {type:"hidden", name:"folder", value:"SUIT"}));
		newForm.appendTo("body");
		newForm.submit();
	}
</script>
<form name="tabFrm" id="tabFrm" method="post" action="" onsubmit="return false;">
	<input type="hidden" id="getSuitnm" name="getSuitnm" value=""/>
	
	<div class="subBtnW side" style="margin-top:10px;">
		<div class="subBtnC right">
			<a href="#none" class="sBtn type1" onclick="goTabWrite();">등록</a>
		<%if("Y".equals(adminYn) && "MAIN".equals(MGBN)){%>
			<a href="#none" class="sBtn type2" onclick="editCal();">공식 수정</a>
		<%}%>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
	</div>
</form>
