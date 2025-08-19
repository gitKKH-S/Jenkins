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
%>
<script>
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";
	var gridStore;
	
	function setGrid(){
		//var offset = $("#tabGrid").offset();
		//console.log(offset);
		//$("html").animate({scrollTop:offset.top}, 400);
		
		var tabRecordObj = Ext.data.Record.create([
			{name:'BND_MNG_NO'},
			{name:'INST_MNG_NO'},
			{name:'LWS_MNG_NO'},
			{name:'PRGRS_STTS_SE_CD'},
			{name:'PRGRS_STTS_SE_NM'},
			{name:'BND_DBT_SE'},
			{name:'BND_DBT_SE_NM'},
			{name:'CNCPR_NM'},
			{name:'CNCPR_ADDR'},
			{name:'CNCPR_TELNO'},
			{name:'BND_SE_CD'},
			{name:'BND_PBLCN_YMD'},
			{name:'JDGM_CFMTN_YMD'},
			{name:'LWS_INCDNT_NM'},
			{name:'BND_INCDNT_NO'},
			{name:'BND_AMT'},
			{name:'RMRK_CN'},
			{name:'GIVE_RTRVL_AMT'},
			{name:'BND_BLNC'},
			{name:'VIEWFILENM'},
			{name:'SERVERFILENM'},
		]);
		
		gridStore = new Ext.data.Store({
			baseParams : {
				LWS_MNG_NO : LWS_MNG_NO,
				INST_MNG_NO : INST_MNG_NO
			},
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectBondList.do"
			}),
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'BND_MNG_NO'
			}, tabRecordObj)
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"채권ID", dataIndex:'BND_MNG_NO', hidden:true},
				{header:"<b>채권금액</b>", width:70, align:'center', dataIndex:'BND_AMT', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var amt = comma(rowData.data.BND_AMT);
						return amt;
					}
				},
				{header:"<b>당사자</b>", width:70, align:'center', dataIndex:'CNCPR_NM', sortable:true},
				{header:"<b>총 회수금</b>", width:70, align:'center', dataIndex:'GIVE_RTRVL_AMT', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var reamt = comma(rowData.data.GIVE_RTRVL_AMT);
						return reamt;
					}
				},
				{header:"<b>채권잔액</b>", width:100, align:'center', dataIndex:'BND_BLNC', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var bondbal = comma(rowData.data.BND_BLNC);
						return bondbal;
					}
				},
				{header:"<b>파일</b>", width:170, align:'center', dataIndex:'VIEWFILENM', sortable:true,
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
					var BND_MNG_NO = histData.get("BND_MNG_NO");
					goBondView(BND_MNG_NO);
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
				LWS_MNG_NO : LWS_MNG_NO,
				INST_MNG_NO : INST_MNG_NO
			}
		});
		
		gridStore.load({
			params:{
				LWS_MNG_NO : LWS_MNG_NO,
				INST_MNG_NO : INST_MNG_NO
			}
		});
		
		gridStore.load();
	}
	
	function goBondView(BND_MNG_NO){
		var cw=900;
		var ch=850;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/bondViewPage.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"BND_MNG_NO", value:BND_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goWritePage(BND_MNG_NO){
		var cw=900;
		var ch=700;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/bondWritePage.do");
		newForm.append($("<input/>", {type:"hidden", name:"BND_MNG_NO", value:BND_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
</script>
<form name="tabFrm" id="tabFrm" method="post" action="" onsubmit="return false;">
	<input type="hidden" name="selsuit" id="selsuit" value="<%=LWS_MNG_NO%>" />
	<input type="hidden" name="selcase" id="selcase" value="<%=SEL_INST_MNG_NO%>" />
	<div class="subBtnW side" style="margin-top:10px;">
		<div class="subBtnC right">
			<%if(("Y".equals(adminYn) || GRPCD.indexOf("E") > -1) && "MAIN".equals(MGBN)){%>
			<a href="#none" class="sBtn type1" onclick="goWritePage();">등록</a>
			<%}%>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
	</div>
</form>
