<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();

	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String pwchg = request.getAttribute("pwchg")==null?"":request.getAttribute("pwchg").toString();
	
	String lawyernm = WRT_DEPT_NM + " " + WRTR_EMP_NM;
	
	HashMap sCnt = request.getAttribute("sCnt")==null?new HashMap():(HashMap)request.getAttribute("sCnt");
	HashMap cCnt = request.getAttribute("cCnt")==null?new HashMap():(HashMap)request.getAttribute("cCnt");
	HashMap aCnt = request.getAttribute("aCnt")==null?new HashMap():(HashMap)request.getAttribute("aCnt");
	
	String userAgent = request.getHeader("user-agent");
	boolean mobile1 = userAgent.matches( ".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
	boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*");
%>
<!doctype html>
<html lang="ko">
<head>
	<style>
		.x-grid-empty {
			padding-top: 20px;
			
		}
		
		/* The Modal (background) */
		.modal {
			display: none; /* Hidden by default */
			position: fixed; /* Stay in place */
			z-index: 1; /* Sit on top */
			left: 0;
			top: 0;
			width: 100%; /* Full width */
			height: 100%; /* Full height */
			overflow: auto; /* Enable scroll if needed */
			background-color: rgb(0,0,0); /* Fallback color */
			background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
		}
		/* Modal Content/Box */
		.modal-content {
			background-color: #fefefe;
			margin: 10% auto; /* 15% from the top and centered */
			padding: 20px;
			border: 1px solid #888;
			width: 45%; /* Could be more or less, depending on screen size */
		}
		
		.x-grid3-row td, .x-grid3-summary-row td {
			font:normal 12px/13px arial,tahoma,helvetica,sans-serif;
		}
		.innerBtn {
			height:100%;
			line-height:100%;
		}
	</style>
	<script>
		var pwchg = "<%=pwchg%>";
		var GRPCD = "<%=GRPCD%>";
		$(function(){
			if (pwchg == "N") {
				// 비밀번호 변경 모달창
				$('#myModal').show();
			}
		});
		
		var gridHei = 173;
		
		Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/extjs/resources/images/default/s.gif";
		Ext.QuickTips.init();
		Ext.onReady(function(){
			var myRecordObj = Ext.data.Record.create([
				{name:'LWS_MNG_NO'},
				{name:'INST_MNG_NO'},
				{name:'LWS_SE'},
				{name:'LWS_UP_TYPE_CD'},
				{name:'LWS_UP_TYPE_NM'},
				{name:'LWS_LWR_TYPE_CD'},
				{name:'LWS_LWR_TYPE_NM'},
				{name:'LWS_INCDNT_NM'},
				{name:'IMPT_LWS_YN'},
				{name:'INST_CD'},
				{name:'INST_NM'},
				{name:'INCDNT_NO'},
				{name:'LWS_CNCPR_NM'},
				{name:'RCPT_YN'}
			]);
			
			var gridStore = new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url: "${pageContext.request.contextPath}/out/selectOutSuitList.do"
				}),
				reader: new Ext.data.JsonReader({root: 'result', totalProperty: 'total', idProperty: 'LWS_MNG_NO'}, myRecordObj)
			});
			
			var cmm = new Ext.grid.ColumnModel({
				columns:[
					new Ext.grid.RowNumberer(),		//줄번호 먹이기
					{header:"<b>소송아이디</b>",   dataIndex:'LWS_MNG_NO',  hidden:true},
					{header:"<b>사건아이디</b>",   dataIndex:'INST_MNG_NO', hidden:true},
					{header:"<b>중요소송여부</b>", dataIndex:'IMPT_LWS_YN', hidden:true},
					{header:"<b>사건명</b>", width:150, align:'left', dataIndex:'LWS_INCDNT_NM', sortable:true,
						renderer: function(value, cell, record, rowindex, columnindex, store) {
							var selModel=gridCodeMan.getSelectionModel();
							selModel.selectRow(rowindex);
							var rowData = selModel.getSelected();
							var reyn = rowData.data.IMPT_LWS_YN;
							var suitnm = rowData.data.LWS_INCDNT_NM;
							if(reyn == "Y"){
								return "<span style=\"color:red;\">[중요소송]</span>" + suitnm;
							}else{
								return suitnm;
							}
						}
					},
					<%if (!mobile1 && !mobile2) {%>
					{header:"<b>소송상대방</b>", width:100, align:'center', dataIndex:'LWS_CNCPR_NM', sortable:true},
					<%}%>
					{header:"<b>심급</b>",       width:150, align:'center', dataIndex:'INST_NM',      sortable:true},
					{header:"<b>사건번호</b>",   width:100, align:'center', dataIndex:'INCDNT_NO',    sortable:true},
					{
						header:"<b>접수여부</b>",   width:100, align:'center', dataIndex:'RCPT_YN',    sortable:true,
						renderer: function(value, cell, record, rowindex, columnindex, store) {
							var selModel=gridCodeMan.getSelectionModel();
							selModel.selectRow(rowindex);
							var rowData = selModel.getSelected();
							var data = "";
							if(rowData.data.RCPT_YN == "A"){
								data = "";
							}else{
								data = rowData.data.RCPT_YN;
							}
							var INST_MNG_NO = rowData.data.INST_MNG_NO;
							var LWS_MNG_NO = rowData.data.LWS_MNG_NO;
							
							var btn = "";
							if(rowData.data.RCPT_YN == "A" && GRPCD == "X"){
								btn = "<a href='#none' class='innerBtn' onclick='setRcpt(\""+INST_MNG_NO+"\", \"Y\", \"SUIT\")'>접수</a>";
								btn = btn + "<a href='#none' class='innerBtn' onclick='setRcpt(\""+INST_MNG_NO+"\", \"N\", \"SUIT\")'>거절</a>";
							}else{
								btn = "";
							}
							return data + btn;
						}
					}
				]
			});
			
			gridCodeMan = new Ext.grid.GridPanel({
				renderTo: 'suit',
				store: gridStore,
				autoWidth: true,
				width: '100%',
				height:gridHei,
				overflowY: 'hidden',
				scroll: false,
				remoteSort: true,
				cm: cmm,
				loadMask:{
					msg:'로딩중입니다. 잠시만 기다려주세요...'
				},
				stripeRows: false,
				viewConfig:{
					forceFit:true,
					enableTextSelection:true,
					emptyText:'조회된 데이터가 없습니다.'
				},
				iconCls: 'icon_perlist',
				listeners: {
					cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
						if(iColIdx != 8) {
							var selModel = grid.getSelectionModel();
							var histData = selModel.getSelected();
							var LWS_MNG_NO = histData.get("LWS_MNG_NO");
							var INST_MNG_NO = histData.get("INST_MNG_NO");
							var RCPT_YN = histData.get("RCPT_YN");
							
							goView(LWS_MNG_NO, INST_MNG_NO);
						}
					},
					contextmenu:function(e){
						e.preventDefault();
					},
					//cellcontextmenu : ( Grid this, Number rowIndex, Number cellIndex, Ext.EventObject e )
					cellcontextmenu:function(grid, idx, cIdx, e){
						e.preventDefault();
					}
				}
			});
			
			gridStore.on('beforeload', function(){
				gridStore.baseParams = {
					start : 0,
					limit : 25,
					pageSize : 25
				}
			});
			
			gridStore.load();
			
			var myRecordObj1 = Ext.data.Record.create([
				{name : 'CNSTN_MNG_NO'},
				{name : 'MENU_MNG_NO'},
				{name : 'PRGRS_STTS_SE_NM'},
				{name : 'CNSTN_TTL'},
				{name : 'CNSTN_RQST_DEPT_NO'},
				{name : 'CNSTN_RQST_DEPT_NM'},
				{name : 'CNSTN_RQST_EMP_NO'},
				{name : 'CNSTN_RQST_EMP_NM'},
				{name : 'CNSTN_HOPE_RPLY_YMD'},
				{name : 'OPENYN'},
				{name : 'CNSTN_TKCG_EMP_NO'},
				{name : 'CNSTN_TKCG_EMP_NM'},
				{name : 'INSD_OTSD_TASK_SE'},
				{name : 'CNSTN_RPLY_YMD'},
				{name : 'CNSTN_RQST_YMD'},
				{name : 'CNSTN_DOC_NO'},
				{name : 'WRT_YMD'},
				{name : 'RVW_TKCG_EMP_NM'},
				{name : 'JDAF_CORP_NMS'},
				{name : 'CNSTN_RCPT_YMD'},
				{name:'RCPT_YN'}
			]);
			
			var gridStore1 = new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url: "${pageContext.request.contextPath}/out/selectOutConsultList.do"
				}),
				reader: new Ext.data.JsonReader({root: 'result', totalProperty: 'total', idProperty: 'CNSTN_MNG_NO'}, myRecordObj1),
				pageSize: 25
			});
			
			var cmm1 = new Ext.grid.ColumnModel({
				columns:[
					new Ext.grid.RowNumberer(),//줄번호 먹이기
					{header:"<b>자문ID</b>", dataIndex:'CNSTN_MNG_NO', hidden: true},
					{header:"<b>관리번호</b>",     align:'center', dataIndex:'CNSTN_DOC_NO',        sortable:true},
					{header:"<b>자문요청제목</b>", align:'left',   dataIndex:'CNSTN_TTL',           sortable:true},
					<%if (!mobile1 && !mobile2) {%>
					{header:"<b>진행상태</b>",     align:'center', dataIndex:'PRGRS_STTS_SE_NM',    sortable:true},
					{header:"<b>요청부서</b>",     align:'center', dataIndex:'CNSTN_RQST_DEPT_NM',  sortable:true},
					{header:"<b>요청자</b>",       align:'center', dataIndex:'CNSTN_RQST_EMP_NM',   sortable:true},
					{header:"<b>검토자</b>",       align:'center', dataIndex:'RVW_TKCG_EMP_NM',     sortable:true},
					<%}%>
					{header:"<b>요청일자</b>",     align:'center', dataIndex:'CNSTN_RQST_YMD',      sortable:true},
					<%if (!mobile1 && !mobile2) {%>
					{header:"<b>희망회신일자</b>", align:'center', dataIndex:'CNSTN_HOPE_RPLY_YMD', sortable:true},
					<%}%>
					{
						header:"<b>접수여부</b>",   align:'center', dataIndex:'RCPT_YN',    sortable:true,
						renderer: function(value, cell, record, rowindex, columnindex, store) {
							var selModel=grid1.getSelectionModel();
							selModel.selectRow(rowindex);
							var rowData = selModel.getSelected();
							var data = "";
							if(rowData.data.RCPT_YN == "A"){
								data = "";
							}else{
								data = rowData.data.RCPT_YN;
							}
							var CNSTN_MNG_NO = rowData.data.CNSTN_MNG_NO;
							
							var btn = "";
							if(rowData.data.RCPT_YN == "A" && GRPCD == "X"){
								btn = "<a href='#none' class='innerBtn' onclick='setRcpt(\""+CNSTN_MNG_NO+"\", \"Y\", \"CONSULT\")'>접수</a>";
								btn = btn + "<a href='#none' class='innerBtn' onclick='setRcpt(\""+CNSTN_MNG_NO+"\", \"N\", \"CONSULT\")'>거절</a>";
							}else{
								btn = "";
							}
							return data + btn;
						}
					}
				]
			});
			
			var grid1 = new Ext.grid.GridPanel({
				renderTo: 'consult',
				store:gridStore1,
				width: '100%',
				autoWidth: true,
				overflowY: 'hidden',
				scroll:false,
				remoteSort: true,
				height:gridHei,
				cm:cmm1,
				loadMask:{
					msg:'로딩중입니다. 잠시만 기다려주세요...'
				},
				stripeRows:true,
				viewConfig:{
					forceFit:true,
					enableTextSelection:true,
					emptyText:'조회된 데이터가 없습니다.'
				},
				iconCls: 'icon_perlist',
				listeners: {
					rowcontextmenu:function(grid, idx, e){
						var selModel=grid.getSelectionModel();
						selModel.selectRow(idx);
						var rowData = selModel.getSelected();
						rowData.showAt(e.getXY());
					},
					rowclick:function(grid, idx, e){
						
					},
					cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent){
						if (iColIdx != 10) {
							var selModel= grid.getSelectionModel();
							var histData = selModel.getSelected();
							var CNSTN_MNG_NO = histData.get('CNSTN_MNG_NO');
							
							goConsultView(CNSTN_MNG_NO);
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
			
			gridStore1.on('beforeload', function(){
				gridStore1.baseParams = {
					start : 0,
					limit : 25,
					pagesize : 25
				}
			});
			
			gridStore1.load({
				params:{
					start : 0,
					limit : 25
				}
			});
			
			
			
			
			var myRecordObj2 = Ext.data.Record.create([
				{name : 'CVTN_MNG_NO'},
				{name : 'MENU_MNG_NO'},
				{name : 'PRGRS_STTS_SE_NM'},
				{name : 'CVTN_TTL'},
				{name : 'CVTN_RQST_EMP_NO'},
				{name : 'CVTN_RQST_EMP_NM'},
				{name : 'CVTN_RQST_DEPT_NO'},
				{name : 'CVTN_RQST_DEPT_NM'},
				{name : 'CVTN_TKCG_EMP_NO'},
				{name : 'CVTN_TKCG_EMP_NM'},
				{name : 'CVTN_CTRT_TYPE_CD_NM'},
				{name : 'CVTN_RQST_REG_YMD'},
				{name : 'CVTN_RQST_YMD'},
				{name : 'CVTN_DOC_NO'},
				{name : 'WRT_YMD'},
				{name : 'RVW_TKCG_EMP_NM'},
				{name : 'MDFCN_YMD'},
				{name : 'CVTN_RCPT_YMD'},
				{name:'RCPT_YN'}
			]);
			
			var gridStore2 = new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url: "${pageContext.request.contextPath}/out/selectOutAgreeList.do"
				}),
				reader: new Ext.data.JsonReader({root: 'result', totalProperty: 'total', idProperty: 'CVTN_MNG_NO'}, myRecordObj2),
				pageSize: 25
			});
			
			var cmm2 = new Ext.grid.ColumnModel({
				columns:[
					new Ext.grid.RowNumberer(),//줄번호 먹이기
					{header:"<b>협약ID</b>",       dataIndex:'CVTN_MNG_NO', hidden: true},
					{header:"<b>관리번호</b>",     align:'center', dataIndex:'CVTN_DOC_NO',        sortable:true},
					{header:"<b>자문요청제목</b>", align:'left',   dataIndex:'CVTN_TTL',           sortable:true},
					<%if (!mobile1 && !mobile2) {%>
					{header:"<b>진행상태</b>",     align:'center', dataIndex:'PRGRS_STTS_SE_NM',   sortable:true},
					{header:"<b>요청부서</b>",     align:'center', dataIndex:'CVTN_RQST_DEPT_NM',  sortable:true},
					{header:"<b>요청자</b>",       align:'center', dataIndex:'CVTN_RQST_EMP_NM',   sortable:true},
					{header:"<b>검토자</b>",       align:'center', dataIndex:'CVTN_TKCG_EMP_NM',   sortable:true},
					<%}%>
					{header:"<b>요청일자</b>",     align:'center', dataIndex:'CVTN_RQST_YMD',      sortable:true},
					<%if (!mobile1 && !mobile2) {%>
					{header:"<b>접수일자</b>",     align:'center', dataIndex:'CVTN_RCPT_YMD',      sortable:true},
					<%}%>
					{
						header:"<b>접수여부</b>",  align:'center', dataIndex:'RCPT_YN',    sortable:true,
						renderer: function(value, cell, record, rowindex, columnindex, store) {
							var selModel=grid2.getSelectionModel();
							selModel.selectRow(rowindex);
							var rowData = selModel.getSelected();
							var data = "";
							if(rowData.data.RCPT_YN == "A"){
								data = "";
							}else{
								data = rowData.data.RCPT_YN;
							}
							var CVTN_MNG_NO = rowData.data.CVTN_MNG_NO;
							
							var btn = "";
							if((rowData.data.RCPT_YN == "A" || rowData.data.RCPT_YN == "") && GRPCD == "X"){
								btn = "<a href='#none' class='innerBtn' onclick='setRcpt(\""+CVTN_MNG_NO+"\", \"Y\", \"AGREE\")'>접수</a>";
								btn = btn + "<a href='#none' class='innerBtn' onclick='setRcpt(\""+CVTN_MNG_NO+"\", \"N\", \"AGREE\")'>거절</a>";
							}else{
								btn = "";
							}
							return data + btn;
						}
					}
				]
			});
			
			var grid2 = new Ext.grid.GridPanel({
				renderTo: 'agree',
				store:gridStore2,
				width: '100%',
				autoWidth: true,
				overflowY: 'hidden',
				scroll:false,
				remoteSort: true,
				height:gridHei,
				cm:cmm2,
				loadMask:{
					msg:'로딩중입니다. 잠시만 기다려주세요...'
				},
				stripeRows:true,
				viewConfig:{
					forceFit:true,
					enableTextSelection:true,
					emptyText:'조회된 데이터가 없습니다.'
				},
				
				iconCls: 'icon_perlist',
				listeners: {
					rowcontextmenu:function(grid, idx, e){
						var selModel=grid.getSelectionModel();
						selModel.selectRow(idx);
						var rowData = selModel.getSelected();
						rowData.showAt(e.getXY());
					},
					rowclick:function(grid, idx, e){
						
					},
					cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent){
						if (iColIdx != 10) {
							var selModel= grid.getSelectionModel();
							var histData = selModel.getSelected();
							var CVTN_MNG_NO = histData.get('CVTN_MNG_NO');
							
							goAgreeView(CVTN_MNG_NO);
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
			
			gridStore2.on('beforeload', function(){
				gridStore2.baseParams = {
					start : 0,
					limit : 25,
					pagesize : 25
				}
			});
			
			gridStore2.load({
				params:{
					start : 0,
					limit : 25
				}
			});
		});
		
		function goView(LWS_MNG_NO, INST_MNG_NO){
			document.getElementById("LWS_MNG_NO").value = LWS_MNG_NO;
			document.getElementById("INST_MNG_NO").value = INST_MNG_NO;
			document.suitFrm.action="<%=CONTEXTPATH%>/out/lawyerSuitViewPage.do";
			document.suitFrm.submit();
		}
		
		function goConsultView(CNSTN_MNG_NO){
			document.getElementById("consultid").value = CNSTN_MNG_NO;
			document.conFrm.action="<%=CONTEXTPATH%>/out/outConsultView.do";
			document.conFrm.submit();
		}
		
		function goAgreeView(CVTN_MNG_NO) {
			document.getElementById("CVTN_MNG_NO").value = CVTN_MNG_NO;
			document.agrFrm.action="<%=CONTEXTPATH%>/out/outAgreeView.do";
			document.agrFrm.submit();
		}
		
		function setRcpt(pk, yn, docgbn) {
			if(yn == "Y") {
				// 상태값만 변경
				$.ajax({
					type:"POST",
					url : "${pageContext.request.contextPath}/out/rfslRsnSave.do",
					data : {
						RCPT_YN:yn,
						DOC_GBN:docgbn,
						RFSL_RSN:'',
						DOC_PK:pk,
						WRTR_EMP_NO:"<%=WRTR_EMP_NO%>",
						LWYR_NM:"<%=lawyernm%>",
					},
					dataType: "json",
					async: false,
					success : function(result){
						alert("저장되었습니다.");
						location.href="${pageContext.request.contextPath}/out/outMain.do";
					}
				});
			} else {
				// 반려처리+반려사유 팝업 호출 및 담당자 알림 발송
				var cw=800;
				var ch=500;
				//스크린의 크기
				var sw=screen.availWidth;
				var sh=screen.availHeight;
				//열 창의 포지션
				var px=(sw-cw)/2;
				var py=(sh-ch)/2;
				property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
				var newWindow = window.open("","newEdit",property);
				
				var newForm = $('<form></form>');
				newForm.attr("name", "fileFrm");
				newForm.attr("method", "post");
				newForm.attr("target", "newEdit");
				newForm.attr("action", "<%=CONTEXTPATH%>/out/rfslRsnPop.do");
				newForm.append($("<input/>", {type:"hidden", name:"LWYR_NM", value:"<%=lawyernm%>"}));
				newForm.append($("<input/>", {type:"hidden", name:"WRTR_EMP_NO", value:"<%=WRTR_EMP_NO%>"}));
				newForm.append($("<input/>", {type:"hidden", name:"DOC_PK", value:pk}));
				newForm.append($("<input/>", {type:"hidden", name:"DOC_GBN", value:docgbn}));
				newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
				newForm.appendTo("body");
				newForm.submit();
				newForm.remove();
			}
		}
		
		function chgPw() {
			var pw1 = $("#newPw1").val();
			var pw2 = $("#newPw2").val();
			if (pw1 == "seoul123!!!") {
				return alert("초기 비밀번호와 동일합니다. 다른 비밀번호를 사용하세요.");
			}
			
			if (pw1 != pw2) {
				return alert("입력 한 비밀번호가 다릅니다. 입력 한 비밀번호를 다시 확인하세요");
			}
			
			var newPw = $("#newPw1").val();
			var num = newPw.search(/[0-9]/g);
			var eng = newPw.search(/[a-z]/ig);
			var spe = newPw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
			
			if(newPw.search(/\s/) != -1){
				return alert("비밀번호는 공백을 포함할 수 없습니다.");
			}else if( (num < 0 && eng < 0) || (eng < 0 && spe < 0) || (spe < 0 && num < 0) ){
				return alert("영문, 숫자, 특수문자 중 2가지 이상을 혼합하여 입력하세요.");
			}else {
				$.ajax({
					type:"POST",
					url:"<%=CONTEXTPATH %>/web/suit/changePassWord.do",
					data:{LWYR_MNG_NO:"<%=WRTR_EMP_NO%>", LGN_PSWD:pw1, GRPCD:"<%=GRPCD%>"},
					dataType:'json',
					success:function(data) {
						alert("비밀번호 변경이 완료되었습니다.");
						$("#myModal").hide();
					}
				});
			}
		}
	</script>
</head>
<body>

<div id="myModal" class="modal">
	<!-- Modal content -->
	<div class="modal-content">
		<p style="text-align: center;"><span style="font-size: 14pt;"><b><span style="font-size: 24pt;">초기 비밀번호 변경</span></b></span></p>
		<p style="text-align: center; line-height: 1.5;"><br /></p>
		<p style="text-align: left; line-height: 1.5;">
			<span style="font-size: 14pt;">변경 비밀번호 : <input type="password" style="width:70%; border-bottom: 1px solid lightgray;" name="newPw1" id="newPw1" value=""/></span>
		</p>
		<p style="text-align: left; line-height: 1.5;">
			<span style="font-size: 14pt;">비밀번호 확인 : <input type="password" style="width:70%; border-bottom: 1px solid lightgray;" name="newPw2" id="newPw2" value=""/></span>
		</p>
		<p style="text-align: center; line-height: 1.5;"><br /></p>
		<p><br /></p>
		<div style="cursor:pointer;background-color:#DDDDDD;text-align: center;padding-bottom: 10px;padding-top: 10px;" onClick="chgPw();">
			<span class="pop_bt" style="font-size: 13pt;" >
				변경하기
			</span>
		</div>
	</div>
</div>

<form name="suitFrm" id=suitFrm method="post" action="">
	<input type="hidden" name="LWS_MNG_NO" id="LWS_MNG_NO"   value="0" />
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="0" />
</form>
<form name="conFrm" id=conFrm method="post" action="">
	<input type="hidden" name="consultid" id="consultid" value="0" />
</form>
<form name="agrFrm" id=agrFrm method="post" action="">
	<input type="hidden" name="CVTN_MNG_NO" id="CVTN_MNG_NO" value="0" />
</form>
<div id="wrap">
	<div id="ncontent">
		<div class="outmainvisual">
			<div class="mcInfo2">
				<h2>외부 변호사 접속화면</h2>
				<p>
					외부 변호사분들의 법무 업무처리 공간 입니다.<br>
					서울시청 법률지원통합시스템에오신 것을 환영합니다.
				</p>
			</div>
		</div>
		<div class="contactInfoW">
			<strong>담당자 정보</strong>
			<dl>
				<dt>소송</dt>
				<dd>☎ 02-0000-0000</dd>
			</dl>
			<dl>
				<dt>자문</dt>
				<dd>☎ 02-0000-0000</dd>
			</dl>
			<dl>
				<dt>협약</dt>
				<dd>☎ 02-0000-0000</dd>
			</dl>
		</div>
		<div class="mRightW2">
			<div class="mQuickW">
				<div class="board">
					<div class="tagW type1">
						<i class="ph-fill ph-scales"></i>
						<strong>소송</strong>
					</div>
					<ul id="ch">
						<li style="text-decoration: none;"><div id="s0"><%=sCnt.get("PROGCNT")==null?"0":sCnt.get("PROGCNT").toString()%>건</div><li>
						<li><div id="fl">진행중</div><div id="fr"><div id="s1"><%=sCnt.get("PROGCNT")==null?"0":sCnt.get("PROGCNT").toString()%>건</div></div></li>
						<li><div id="fl">종결</div><div id="fr"><div id="s2"><%=sCnt.get("ENDCNT")==null?"0":sCnt.get("ENDCNT").toString()%>건</div></div></li>
						<li><div id="fl">전체</div><div id="fr"><div id="s3"><%=sCnt.get("TOTALCNT")==null?"0":sCnt.get("TOTALCNT").toString()%>건</div></div></li>
					</ul>
				</div>
				
			</div>
			<div class="mQuickW">
				<div class="board">
					<div class="tagW type2">
						<i class="ph-fill ph-chat-teardrop-dots"></i>
						<strong>자문</strong>
					</div>
					<ul id="ch">
						<li style="text-decoration: none;"><div id="c0"><%=cCnt.get("PROGCNT")==null?"0":cCnt.get("PROGCNT").toString()%>건</div><li>
						<li><div id="fl">진행</div><div id="fr"><div id="c1"><%=cCnt.get("PROGCNT")==null?"0":cCnt.get("PROGCNT").toString()%>건</div></div></li>
						<li><div id="fl">완료</div><div id="fr"><div id="c2"><%=cCnt.get("ENDCNT")==null?"0":cCnt.get("ENDCNT").toString()%>건</div></div></li>
						<li><div id="fl">전체</div><div id="fr"><div id="c3"><%=cCnt.get("TOTALCNT")==null?"0":cCnt.get("TOTALCNT").toString()%>건</div></div></li>
					</ul>
				</div>
				
			</div>
			<div class="mQuickW">
				<div class="board">
					<div class="tagW type3">
						<i class="ph-fill ph-handshake"></i>
						<strong>협약</strong>
					</div>
					<ul id="ch">
						<li style="text-decoration: none;"><div id="a0"><%=aCnt.get("PROGCNT")==null?"0":aCnt.get("PROGCNT").toString()%>건</div><li>
						<li><div id="fl">진행</div><div id="fr"><div id="a1"><%=aCnt.get("PROGCNT")==null?"0":aCnt.get("PROGCNT").toString()%>건</div></div></li>
						<li><div id="fl">완료</div><div id="fr"><div id="a2"><%=aCnt.get("ENDCNT")==null?"0":aCnt.get("ENDCNT").toString()%>건</div></div></li>
						<li><div id="fl">전체</div><div id="fr"><div id="a3"><%=aCnt.get("TOTALCNT")==null?"0":aCnt.get("TOTALCNT").toString()%>건</div></div></li>
					</ul>
				</div>
			</div>
		</div>
		<div id="suit"    class="mQW con1" style="height:173px; margin-bottom:10px;"></div>
		<div id="consult" class="mQW con1" style="height:173px; margin-bottom:10px;"></div>
		<div id="agree"   class="mQW con1" style="height:173px;"></div>
	</div>
</div>
</body>
</html>