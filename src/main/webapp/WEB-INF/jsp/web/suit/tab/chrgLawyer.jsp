<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String MENU_MNG_NO        = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	String WRTR_EMP_NM        = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO        = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM        = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO        = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	String LWS_MNG_NO = request.getParameter("LWS_MNG_NO")==null?"":request.getParameter("LWS_MNG_NO").toString();
	String SEL_INST_MNG_NO = request.getParameter("SEL_INST_MNG_NO")==null?"":request.getParameter("SEL_INST_MNG_NO").toString();
	if(SEL_INST_MNG_NO.equals("")){
		SEL_INST_MNG_NO = request.getParameter("INST_MNG_NO")==null?"":request.getParameter("INST_MNG_NO").toString();
	}
	String tabId = request.getParameter("tabId");
	String mergeyn = request.getParameter("mergeyn");
	String MGBN = request.getParameter("MGBN");
	String adminYn = request.getParameter("adminYn");
%>
<script>
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var SEL_INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";
	var WRTR_EMP_NO = "<%=WRTR_EMP_NO%>";
	var adminYn = "<%=adminYn%>";
	
	var gridStore;
	var schLawyer;
	$(document).ready(function(){
		schLawyer = function(key){
			var index = gridStore.find('LWYR_MNG_NO', key);
			return index;
		}
	});
	
	function setGrid(){
		var tabRecordObj = Ext.data.Record.create([
			{name:'AGT_MNG_NO'},
			{name:'INST_MNG_NO'},
			{name:'LWS_MNG_NO'},
			{name:'LWYR_MNG_NO'},
			{name:'LWYR_NM'},
			{name:'JDAF_CORP_MNG_NO'},
			{name:'JDAF_CORP_NM'},
			{name:'DLGT_YMD'},
			{name:'DLGT_END_YMD'},
			{name:'ENDYN'},
			{name:'OTST_AMT'},
			{name:'SCS_PAY_AMT'},
			{name:'ACAP_AMT'},
			{name:'APRV_YN'},
			{name:'GIVE_YN'},
			{name:'GIVE_YMD'},
			{name:'RMRK_CN'},
			{name:'PRSL_PSBLTY_YN'},
			{name:'AMT_STAT'},
			{name:'RCPT_YN'},
			{name:'RFSL_RSN'},
			{name:'VIEWFILENM'},
			{name:'SERVERFILENM'}
		]);
		
		gridStore = new Ext.data.Store({
			baseParams : {
				LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO
			},
			proxy: new Ext.data.HttpProxy({
				url: "<%=CONTEXTPATH %>/web/suit/selectChrgLawyerList.do"
			}),
			reader: new Ext.data.JsonReader({
				root: 'result', totalProperty: 'total', idProperty: 'AGT_MNG_NO'
			}, tabRecordObj)
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"AGT_MNG_NO",  dataIndex:'AGT_MNG_NO',   hidden:true},
				{header:"LWS_MNG_NO",  dataIndex:'LWS_MNG_NO',   hidden:true},
				{header:"INST_MNG_NO", dataIndex:'INST_MNG_NO',  hidden:true},
				{header:"LWYR_MNG_NO", dataIndex:'LWYR_MNG_NO',  hidden:true},
				{header:"<b>소속</b>",        width:150, align:'center', dataIndex:'JDAF_CORP_NM', sortable: true},
				{header:"<b>변호사명</b>",    width:80,  align:'center', dataIndex:'LWYR_NM',      sortable: true},
				{header:"<b>위임상태</b>",    width:50,  align:'center', dataIndex:'ENDYN',        sortable: true},
				{header:"<b>진행상태</b>",    width:50,  align:'center', dataIndex:'AMT_STAT',     sortable: true},
				{header:"<b>접수여부</b>",    width:50,  align:'center', dataIndex:'RCPT_YN',      sortable: true},
				{header:"<b>파일</b>",        width:150, align:'left',   dataIndex:'VIEWFILENM',   sortable:true,
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
			<%if(GRPCD.indexOf("X") > -1 || GRPCD.indexOf("Z") > -1) {%>
				,
				{
					header:"<b>비용신청</b>", width:100, align:'center',
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var btn = "";
						var no = rowData.data.LWYR_MNG_NO;
						
						console.log(no);
						console.log(WRTR_EMP_NO);
						console.log(rowData.data.APRV_YN);
						
						if (no == WRTR_EMP_NO && (rowData.data.APRV_YN == "N" || rowData.data.APRV_YN == "R")) {
							btn = "&nbsp;<a href='#none' class='innerBtn' onclick='goChrgCostWrite("+rowData.data.AGT_MNG_NO+","+rowData.data.LWS_MNG_NO+", "+rowData.data.INST_MNG_NO+")'>비용신청</a>";
						}
						return btn;
					}
				}
			<%}%>
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
			cm: cmm,
			selModel: new Ext.grid.RowSelectionModel({singleSelect : false}),
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows: true,
			viewConfig: {
				forceFit: true,
				enableTextSelection : true,
				emptyText:'조회된 데이터가 없습니다.'
			},
			iconCls: 'icon_perlist',
			listeners: {
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					if(iColIdx != 10){
						var selModel = grid.getSelectionModel();
						var histData = selModel.getSelected();
						var AGT_MNG_NO = histData.get("AGT_MNG_NO");
						var LWS_MNG_NO = histData.get("LWS_MNG_NO");
						var INST_MNG_NO = histData.get("INST_MNG_NO");
						goTabView(AGT_MNG_NO, LWS_MNG_NO, INST_MNG_NO);
					}
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
	function goChrgCostWrite(AGT_MNG_NO, LWS_MNG_NO, INST_MNG_NO){
		var cw=1200;
		var ch=435;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","costEdit",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "costEdit");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/chrgLawyerCostPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"AGT_MNG_NO", value:AGT_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goTabView(AGT_MNG_NO, LWS_MNG_NO, INST_MNG_NO){
		var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
		var cw=1200;
		var ch=555;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/chrgLawyerInfoPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"AGT_MNG_NO", value:AGT_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	//등록페이지
	function goTabWrite(AGT_MNG_NO){
		var cw=1000;
		var ch=640;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/chrgLawyerWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"AGT_MNG_NO", value:AGT_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
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
	<input type="hidden" name="selsuit" id="selsuit" value="<%=LWS_MNG_NO%>" />
	<input type="hidden" name="selcase" id="selcase" value="<%=SEL_INST_MNG_NO%>" />
	<div class="subBtnW side" style="margin-top:10px;">
		<div class="subBtnC right">
		<%if("Y".equals(adminYn) && "MAIN".equals(MGBN)) {%>
			<a href="#none" class="sBtn type1" onclick="goTabWrite('');">등록</a>
		<%}%>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
	</div>
</form>
