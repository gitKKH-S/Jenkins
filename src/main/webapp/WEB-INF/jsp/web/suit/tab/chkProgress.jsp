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
	String MGBN = request.getParameter("MGBN");
	String adminYn = request.getParameter("adminYn");
	
	String SPRVSN_DEPT_NO = request.getParameter("SPRVSN_DEPT_NO");
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<style type="text/css">

</style>
<script type="text/javascript">
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";

	function goTabView(RVW_MNG_NO){
		var cw=700;
		var ch=605;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/chkProgressViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"RVW_MNG_NO", value:RVW_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	//등록페이지
	function goTabWrite(RVW_MNG_NO, UP_RVW_MNG_NO, gbn){
		var cw=700;
		var ch=605;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/chkProgressWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"RVW_MNG_NO", value:RVW_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"UP_RVW_MNG_NO", value:UP_RVW_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:gbn}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function setGrid(){
		var tabRecordObj = Ext.data.Record.create([
			{name:'RVW_MNG_NO'},
			{name:'INST_MNG_NO'},
			{name:'LWS_MNG_NO'},
			{name:'UP_RVW_MNG_NO'},
			{name:'ANS_SEQ'},
			{name:'RVW_DMND_TTL'},
			{name:'RVW_DMND_CN'},
			{name:'WRTR_EMP_NM'},
			{name:'WRT_YMD'},
			{name:'SERVERFILENM'},
			{name:'VIEWFILENM'}
		]);
		
		var gridStore = new Ext.data.Store({
			baseParams : {
				LWS_MNG_NO:LWS_MNG_NO,
				INST_MNG_NO:INST_MNG_NO
			},
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectChkList.do"
			}),
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'RVW_MNG_NO'
			}, tabRecordObj)
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				new Ext.grid.RowNumberer(),		//줄번호 먹이기
				{header:"RVW_MNG_NOID", dataIndex:'RVW_MNG_NO',   hidden:true},
				{header:"INST_MNG_NO",  dataIndex:'INST_MNG_NO',  hidden:true},
				{header:"LWS_MNG_NO",   dataIndex:'LWS_MNG_NO',   hidden:true},
				{header:"서버파일명",   dataIndex:'SERVERFILENM', hidden:true},
				{header:"<b>제목</b>", width:500, align:'left', dataIndex:'RVW_DMND_TTL', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel = grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var RVW_DMND_TTL = rowData.get("RVW_DMND_TTL");
						var ANS_SEQ = rowData.get("ANS_SEQ");
						
						var img = "";
						if(ANS_SEQ > 0){
							var term = "";
							for(var t=0; t<ANS_SEQ; t++){
								term += "&nbsp;&nbsp;";
							}
							img = term+"<img src=\"${pageContext.request.contextPath}/resources/images/icon_reply.png\" alt=\"답글\" />&nbsp;";
						}
						return img+RVW_DMND_TTL;
					}
				},
				{header:"<b>파일</b>", width:230, align:'left', dataIndex:'VIEWFILENM', sortable:true,
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
								html+="<li><a href='#none' onclick='downFile(\""+viewfile[j]+"\",\""+serverfile[j]+"\",\"SUIT\")' title=\""+viewfile[j]+"\">"+viewfile[j]+"</a></li>";
							}
							html+="</ul>";
						}
						return html;
					}
				},
				{header:"<b>작성자</b>", width:120, align:'center', dataIndex:'WRTR_EMP_NM', sortable:true},
				{header:"<b>작성일</b>", width:120, align:'center', dataIndex:'WRT_YMD',     sortable:true}
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
					var RVW_MNG_NO = histData.get("RVW_MNG_NO");
					goTabView(RVW_MNG_NO);
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
	<div class="subBtnW side" style="margin-top:10px;">
		<div class="subBtnC right">
		<%if((SPRVSN_DEPT_NO.equals(WRT_DEPT_NO) || "Y".equals(adminYn) || GRPCD.indexOf("X") > -1) && "MAIN".equals(MGBN)){%>
			<a href="#none" class="sBtn type1" onclick="goTabWrite('', '', 'insert');">등록</a>
		<%}%>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
	</div>
</form>