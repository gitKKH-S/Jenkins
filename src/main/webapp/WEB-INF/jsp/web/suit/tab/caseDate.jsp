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
</style>
<script>
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";
	var mergeyn = "<%=mergeyn%>";
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	function setGrid(){
		$("#loadingCase").hide();
		
		var tabRecordObj = Ext.data.Record.create([
			{name:'DATE_MNG_NO'},
			{name:'INST_MNG_NO'},
			{name:'LWS_MNG_NO'},
			{name:'DATE_TYPE_CD'},
			{name:'DATE_TYPE_NM'},
			{name:'DATE_YMD'},
			{name:'DATE_PLC_NM'},
			{name:'DATE_CN'},
			{name:'DATE_TM'},
			{name:'VIEWTIME'},
			{name:'DATE_RSLT_CN'},
			{name:'DATE_RSLT_MEMO_CN'},
			{name:'RMRK_CN'},
			{name:'NOTI_YN'},
			{name:'NOTI_INV'},
			{name:'HWRT_REG_YN'},
			{name:'SERVERFILENM'},
			{name:'VIEWFILENM'}
		]);
		var gridStore = new Ext.data.Store({
			baseParams : {
				LWS_MNG_NO:LWS_MNG_NO, INST_MNG_NO:INST_MNG_NO, mergeyn:mergeyn
			},
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectDateList.do"
			}),
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'DATE_MNG_NO'
			}, tabRecordObj)
		});
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"DATE_MNG_NO", dataIndex:'DATE_MNG_NO',  hidden:true},
				{header:"LWS_MNG_NO",  dataIndex:'LWS_MNG_NO',   hidden:true},
				{header:"INST_MNG_NO", dataIndex:'INST_MNG_NO',  hidden:true},
				{header:"서버파일명",  dataIndex:'SERVERFILENM', hidden:true},
				{header:"결과",        dataIndex:'DATE_RSLT_CN', hidden:true},
				{header:"<b>종류</b>", width:80, align:'center', dataIndex:'DATE_TYPE_NM', sortable:true},
				{header:"<b>일자</b>", width:70, align:'center', dataIndex:'DATE_YMD', sortable:true},
				{header:"<b>시간</b>", width:60, align:'center', dataIndex:'VIEWTIME', sortable:true},
				{header:"<b>장소</b>", width:170, align:'center', dataIndex:'DATE_PLC_NM', sortable:true},
				{header:"<b>진행요지</b>", width:150, align:'center', dataIndex:'DATE_RSLT_CN', sortable:true},
				{header:"<b>알림</b>", width:50, align:'center', dataIndex:'NOTI_YN', sortable:true},
				{header:"<b>대법원</b>", width:50, align:'center', dataIndex:'HWRT_REG_YN', sortable:true},
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
				beforerender:function(grid){
					
				},
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					var selModel = grid.getSelectionModel();
					var histData = selModel.getSelected();
					var DATE_MNG_NO = histData.get("DATE_MNG_NO");
					var LWS_MNG_NO = histData.get("LWS_MNG_NO");
					var INST_MNG_NO = histData.get("INST_MNG_NO");
					goTabView(DATE_MNG_NO, LWS_MNG_NO, INST_MNG_NO);
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
<script type="text/javascript">
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
	
	function goTabView(DATE_MNG_NO, LWS_MNG_NO, INST_MNG_NO){
		var cw=720;
		var ch=610;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseDateViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"DATE_MNG_NO", value:DATE_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	//등록페이지
	function goTabWrite(gbn){
		var cw=750;
		var ch=767;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseDateWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"DATE_MNG_NO", value:gbn}));
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
						} else {
							alert(result.msg);
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
	<div class="subBtnW side" style="margin-top:10px;">
		<div class="subBtnC right">
		<%if((SPRVSN_DEPT_NO.equals(WRT_DEPT_NO) || "Y".equals(adminYn) || GRPCD.indexOf("X") > -1) && "MAIN".equals(MGBN)){%>
			<a href="#none" class="sBtn type1" onclick="goCaseInfo();">나의사건검색</a>
			<a href="#none" class="sBtn type1" onclick="goTabWrite('');">등록</a>
		<%}%>
		</div>
	</div>
	<div class="innerB">
		<div id="tabGrid"></div>
	</div>
</form>
