<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%
	String tabId = request.getParameter("tabId");
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	System.out.println("*************************************");
	System.out.println(se);
	System.out.println("*************************************");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	HashMap suitMap = request.getAttribute("suitMap")==null?new HashMap():(HashMap)request.getAttribute("suitMap");
	HashMap caseMap = request.getAttribute("caseMap")==null?new HashMap():(HashMap)request.getAttribute("caseMap");
	List empList = request.getAttribute("empList")==null?new ArrayList():(ArrayList) request.getAttribute("empList");
	List suitConfFile = request.getAttribute("suitConfFile")==null?new ArrayList():(ArrayList)request.getAttribute("suitConfFile");
	List caseFile = request.getAttribute("caseFile")==null?new ArrayList():(ArrayList)request.getAttribute("caseFile");
	List relList = request.getAttribute("relList")==null?new ArrayList():(ArrayList)request.getAttribute("relList");
	
	String LWS_MNG_NO = suitMap.get("LWS_MNG_NO")==null?"":suitMap.get("LWS_MNG_NO").toString();
	String adminYn = suitMap.get("adminYn")==null?"":suitMap.get("adminYn").toString();
	String SPRVSN_DEPT_NO = suitMap.get("SPRVSN_DEPT_NO")==null?"":suitMap.get("SPRVSN_DEPT_NO").toString();
	String JDGM_UP_TYPE_NM = caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString();
	
	String SEL_INST_MNG_NO = request.getAttribute("SEL_INST_MNG_NO")==null?"":request.getAttribute("SEL_INST_MNG_NO").toString();
	String MENU_MNG_NO     = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	String WRTR_EMP_NM     = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO     = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM     = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO     = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String focus           = request.getAttribute("focus")==null?"":request.getAttribute("focus").toString();
	String writercd        = request.getAttribute("writercd")==null?"":request.getAttribute("writercd").toString();
	String searchForm      = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	int tabcaseid          = ServletRequestUtils.getIntParameter(request, "tabcaseid", 0);
	
	if(tabId == null || "".equals(tabId)){
		tabId = SEL_INST_MNG_NO == "0" ? "report.jsp" : "caseDate.jsp";
	}
%>
<style>
	.sel-highlight{background:#dfe8f6 !important;}
	.non-sel{background:white !important;}
	#tapDiv{padding-bottom:50px;}
	#loading{
		height:100%;left:0px;position:fixed;_position:absolute;top:0px;
		width:100%;filter:alpha(opacity=50);-moz-opacity:0.5;opacity:0.5;
	}
	.loading{background-color:white;z-index:9998;}
	#loading_img{
		position:absolute;top:50%;left:50%;height:35px;
		margin-top:-25px;margin-left:0px;z-index:9999;
	}
	
	#empTable th {padding:5px 10px;}
	#empTable td {padding:5px 10px; text-align:center;}
	.relDiv:hover{
		cursor:pointer;
		text-decoration:underline;
	}
	
	.subBtnW .side{
		margin-top:10px;
	}
</style>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.util.js"></script>
<script src="${resourceUrl}/js/mten.findword.js"></script>
<script type="text/javascript">
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=SEL_INST_MNG_NO%>";
	var focFlg = "<%=focus%>";
	var GRPCD = "<%=GRPCD%>";
	var adminYn = "<%=adminYn%>";
	
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/resources/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	
	var grid1;
	Ext.onReady(function(){
		var myRecordObj = Ext.data.Record.create([
			{name:'INST_MNG_NO'},
			{name:'LWS_MNG_NO'},
			{name:'INST_CD'},
			{name:'INST_NM'},
			{name:'INCDNT_NO'},
			{name:'FLGLW_YMD'},
			{name:'CT_CD'},
			{name:'CT_NM'},
			{name:'JDGM_ADJ_YMD'},
			{name:'JDGM_UP_TYPE_NM'},
			{name:'JDGM_LWR_TYPE_NM'},
			{name:'LWS_EQVL'},
			{name:'JDGM_AMT'},
			{name:'EMPNM'}
		]);
		
		var gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectCaseList.do"
			}),
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'INST_MNG_NO'
			}, myRecordObj),
			listeners:{
				load:function(dataStore, rows, bool){
					var subTitle = "심급정보 (";
					if(rows.length > 0){
						if($("#SEL_INST_MNG_NO").val() == "" || $("#SEL_INST_MNG_NO").val() == "0"){
							subTitle += rows[0].data.INST_NM + ":" + rows[0].data.CT_NM;
							console.log("1");
							var getCaseid = rows[0].data.INST_MNG_NO;
							console.log("2");
							console.log(rows[0]);
							$("#SEL_INST_MNG_NO").val(getCaseid);
							casecdnm = rows[0].data.INST_NM;
							$(".simSpan").html(rows[0].data.INST_NM);
						} else {
							var selcaseid = $("#SEL_INST_MNG_NO").val();
							for(var i=0; i<rows.length; i++){
								if(rows[i].data.INST_MNG_NO == selcaseid){
									subTitle += rows[i].data.INST_NM + ":" + rows[i].data.CT_NM;
									$(".simSpan").html(rows[i].data.INST_NM);
								}
							}
						}
						caseDivOpen(1);
					}else{
						$(".simSpan").html("0심");
						$("#SEL_INST_MNG_NO").val("0");
						subTitle += "등록 된 심급 정보가 없습니다.";
						$("#caseDetail").css("display","none");
						$("#caseEndBtn").css("display", "none");
						caseDivOpen(0);
					}
					$("#LWS_MNG_NO").val(LWS_MNG_NO);
					subTitle += ")";
					$("#caseInfoTitle").append(subTitle);
				}
			}
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"X",                 dataIndex:'INST_MNG_NO', hidden:true},
				{header:"X",                 dataIndex:'LWS_MNG_NO', hidden:true},
				{header:"심급코드",          dataIndex:'INST_CD', hidden:true},
				{header:"<b>심급</b>",       width:120, align:'left', dataIndex:'INST_NM',   sortable:true},
				{header:"<b>법원</b>",       width:150, align:'left', dataIndex:'CT_NM',     sortable:true},
				{header:"<b>사건번호</b>",   width:150, align:'left', dataIndex:'INCDNT_NO', sortable:true},
				{header:"<b>소제기일</b>",   width:100, align:'left', dataIndex:'FLGLW_YMD', sortable:true},
				{header:"<b>판결선고일</b>", width:100, align:'left', dataIndex:'JDGM_ADJ_YMD',   sortable:true},
				{header:"<b>판결분류</b>",   width:100, align:'left', dataIndex:'JDGM_UP_TYPE_NM',   sortable:true},
				{header:"<b>소송가액</b>",   width:100, align:'left', dataIndex:'LWS_EQVL',   sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid1.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var amt = comma(rowData.data.LWS_EQVL);
						return amt;
					}
				},
				{header:"<b>판결금액</b>", width:120, align:'center', dataIndex:'JDGM_AMT', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid1.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var amt = comma(rowData.data.JDGM_AMT);
						return amt;
					}
				},
				{header:"<b>담당자</b>", width:220, align:'center', dataIndex:'EMPNM', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid1.getSelectionModel();
						selModel.selectRow(rowindex);
						var rowData = selModel.getSelected();
						var empnm = "";
						if(rowData.data.EMPNM == ""){
							empnm = "미지정";
						}else{
							empnm = rowData.data.EMPNM;
						}
						
						var caseid = rowData.data.INST_MNG_NO;
						var suitid = "<%=LWS_MNG_NO%>";
						
						var btn = "";
						if(GRPCD.indexOf("C") > -1 || GRPCD.indexOf("Y") > -1){
							btn = "&nbsp;<a href='#none' class='innerBtn' onclick='goSelectEmp("+suitid+","+caseid+")'>담당자 지정</a>";
						}else{
							btn = "";
						}
						return empnm + btn;
					}
				}
			]
		});
		
		grid1 = new Ext.grid.GridPanel({
			id:'hkk4',
			renderTo:'caseGrid',
			store:gridStore,
			width:'100%',
			autoWidth:true,
			autoHeight:true,
			overflowY:'hidden',
			scroll:false,
			remoteSort:true,
			cm:cmm,
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요.'
			},
			stripeRows:false,
			viewConfig:{
				forceFit:true,
				enableTextSelection :true,
				emptyText:'심급 진행내역을 등록하세요.',
				getRowClass:function(record){
					var cls = "";
					
					console.log("FOCUS : " + record.get("INST_MNG_NO") + " / " + INST_MNG_NO);
					
					if(record.get("INST_MNG_NO") == INST_MNG_NO){
						console.log("같다");
						
						cls = "sel-highlight";
					}else{
						cls = "non-sel";
					}
					return cls;
				}
			},
			iconCls:'icon_perlist',
			listeners:{
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					if(iColIdx != 10){
						selModel = grid.getSelectionModel();
						var histData = selModel.getSelected();
						var selectedCaseId = histData.data.INST_MNG_NO;
						var selSuitid = histData.data.LWS_MNG_NO;
						$("#SEL_INST_MNG_NO").val(selectedCaseId);
						goReLoad();
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
				LWS_MNG_NO : LWS_MNG_NO,
				'${_csrf.parameterName}' : '${_csrf.token}'
			}
		});
		
		gridStore.load({
			params:{
				LWS_MNG_NO : LWS_MNG_NO
			}
		});
		
		//try{
			setGrid();
		//}catch(e){console.log("그리드 생성 에러");}
	});
	
	$(window).load(function(){
		$("#loading").hide();
		
		var tabId = "<%=tabId.replace(".jsp", "")%>";
		$("#"+tabId).addClass("active");
		
		if(focFlg == "1"){
			setTimeout( function(){ $('#inFocu').focus();}, 50 );
		} else if(focFlg == "2"){
			setTimeout( function(){ $('#inFocu2').focus();}, 50 );
		}
		$("#inFocu").css("opacity", "0");
	});
	
	function goView(id){
		//심급선택
		var url = id+".jsp"
		if(url == ".jsp"){
			focFlg = "0";
			$("#tabId").val("caseDate.jsp");
		//탭선택
		}else{
			focFlg = "1";
			$("#tabId").val(url);
			$("#tabcaseid").val("");
		}
		$("#focus").val(focFlg);
		goReLoad();
	}
	
	function goReLoad(){
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/suitViewPage.do";
		document.frm.submit();
	}
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/goSuitList.do";
		document.frm.submit();
	}
	
	function goEditSuitMain(){
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/suitWritePage.do";
		document.frm.submit();
	}
	
	function goDelInfo(gbn){
		// gbn
		// suit - 전체 / case - 심급정보 / result - 종결정보
		var delMsg = "";
		delMsg += "소송정보를 삭제하시면 관련 정보도 모두 삭제됩니다.\n";
		delMsg += "삭제 된 정보는 복구되지 않습니다\n";
		delMsg += "정말로 삭제하시겠습니까?";
		
		if(confirm(delMsg)){
			$("#delGbn").val(gbn);
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteSuitInfo.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					goListPage();
				}
			});
		}
	}
	
	function goCaseWrite(gbn){
		$("#gbn").val(gbn);
		
		var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
		var SEL_INST_MNG_NO;
		
		if(gbn == "insert"){
			SEL_INST_MNG_NO = "0";
		}else{
			SEL_INST_MNG_NO = $("#SEL_INST_MNG_NO").val();
		}
		var LWS_MNG_NO = $("#LWS_MNG_NO").val();
		
		var cw=1200;
		var ch=860;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:gbn}));
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:SEL_INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"MENU_MNG_NO", value:MENU_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}

	function goCaseResult(gbn){
		var LWS_MNG_NO = $("#LWS_MNG_NO").val();
		var SEL_INST_MNG_NO = $("#SEL_INST_MNG_NO").val();
		var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
		var cw=1200;
		var ch=650;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","goResult",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "goResult");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseResultWritePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:SEL_INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"gbn", value:gbn}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goSelectEmp(suitid, caseid){
		var cw=650;
		var ch=400;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchEmpPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:suitid}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:caseid}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goFileView() {
		var cw=1300;
		var ch=900;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/fileViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goCourtFileView() {
		var cw=1300;
		var ch=900;
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
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/courtFileViewPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function caseDivOpen(gbn){
		if(gbn == 1){
			//열기
			$("#caseDetail").css("display", "block");
			$("#final").css("display", "block");
			
			$("#closeBtn").css("display", "inline-block");
			$("#openBtn").css("display", "none");
		}else if(gbn == 0){
			// 닫기
			$("#caseDetail").css("display", "none");
			$("#final").css("display", "none");
			
			$("#closeBtn").css("display", "none");
			$("#openBtn").css("display", "inline-block");
		}
	}
	
	function goGianPop(){
		var cw=1300;
		var ch=900;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","gianPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "gianPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/gianMakePop.do");
		newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"INST_MNG_NO", value:INST_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goSchCasePop(){
		var cw=1200;
		var ch=770;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","CaseSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "CaseSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/caseSearchPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"PK", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"schGbn", value:'S'}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goRelDocView(gbn, relpk) {
		if (gbn == "S") {
			var cw=1200;
			var ch=850;
			//스크린의 크기
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			//열 창의 포지션
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "calInfo");
			newForm.attr("action", CONTEXTPATH+"/web/suit/caseViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"LWS_MNG_NO", value:relpk}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "C") {
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
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "calInfo");
			newForm.attr("action", CONTEXTPATH+"/web/consult/consultViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"consultid", value:relpk}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		} else if (gbn == "A") {
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
			var newWindow = window.open("","calInfo",property);
			
			var newForm = $('<form></form>');
			newForm.attr("name", "fileFrm");
			newForm.attr("method", "post");
			newForm.attr("target", "calInfo");
			newForm.attr("action", CONTEXTPATH+"/web/agree/agreeViewPop.do");
			newForm.append($("<input/>", {type:"hidden", name:"CVTN_MNG_NO", value:relpk}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	}
	
	function suitRoleEdit(){
		var LWS_MNG_NO = $("#LWS_MNG_NO").val();
		
		var cw=800;
		var ch=860;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","CaseSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "CaseSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/roleSettingPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"DOC_MNG_NO", value:LWS_MNG_NO}));
		newForm.append($("<input/>", {type:"hidden", name:"DOC_SE", value:"SUIT"}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
</script>
<!-- <form id="frm" name="frm" method="post" action="" enctype="multipart/form-data"> -->
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="searchForm"      id="searchForm"      value="<%=searchForm%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO %>"/>
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=SEL_INST_MNG_NO %>"/>
	<input type="hidden" name="selectedCaseId"  id="selectedCaseId"  value="<%=SEL_INST_MNG_NO %>"/>
	<input type="hidden" name="SEL_INST_MNG_NO" id="SEL_INST_MNG_NO" value="<%=SEL_INST_MNG_NO %>"/>
	<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="delGbn"          id="delGbn"          value=""/>
	<input type="hidden" name="tabId"           id="tabId"           value="<%=tabId %>"/>
	<input type="hidden" name="Grpcd"           id="Grpcd"           value="<%=GRPCD%>"/>
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="focus"           id="focus"           value="" />
	<input type="hidden" name="${_csrf.parameterName}"   value="${_csrf.token}"/>
	<div id="loading" class="loading"><img id="loading_img" alt="loading" src="${resourceUrl}/paramquery-3.3.2/images/loading.gif" /></div>
	
	<div class="subCA">
		<strong class="subTT" id="subTT"></strong>
		<div class="subBtnC right">
		<%if("Y".equals(adminYn)){%>
			<a href="#none" class="sBtn type1" onclick="suitRoleEdit();">권한관리</a>
		<%}%>
		</div>
		<div class="innerB">
			
			<table class="infoTable">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>관리번호</th>
					<td>
						<%= suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString() %>
					</td>
					<th>사건명</th>
					<td colspan="3">
						<%= suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString() %>
					</td>
				</tr>
				<tr>
					<th>소송유형</th>
					<td>
						<%= suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString() %>
						-<%= suitMap.get("LWS_LWR_TYPE_NM")==null?"":suitMap.get("LWS_LWR_TYPE_NM").toString() %>
					</td>
					<th>구분</th>
					<td>
						<%= suitMap.get("LWS_SE_NM")==null?"":suitMap.get("LWS_SE_NM").toString() %>
					</td>
					
					<th>진행상태</th>
					<td>
						<%= suitMap.get("LWS_PRGRS_STTS")==null?"":suitMap.get("LWS_PRGRS_STTS").toString() %>
					</td>
				</tr>
				<tr>
					<th>주관부서</th>
					<td>
						<%= suitMap.get("SPRVSN_DEPT_NM")==null?"":suitMap.get("SPRVSN_DEPT_NM").toString() %>
					</td>
					<th>주관부서 담당자</th>
					<td>
						<%= suitMap.get("SPRVSN_EMP_NM")==null?"":suitMap.get("SPRVSN_EMP_NM").toString() %>
					</td>
					<th>주관부서 팀장</th>
					<td>
						<%= suitMap.get("SPRVSN_TMLDR_NM")==null?"":suitMap.get("SPRVSN_TMLDR_NM").toString() %>
					</td>
				</tr>
				<tr>
					<th>기타주관부서</th>
					<td colspan="5">
						<%= suitMap.get("ETC_SPRVSN_DEPT_NM")==null?"":suitMap.get("ETC_SPRVSN_DEPT_NM").toString() %>
					</td>
				</tr>
				<tr>
					<th>소제기일자</th>
					<td>
						<%= suitMap.get("FLGLW_YMD")==null?"":suitMap.get("FLGLW_YMD").toString() %>
					</td>
					<th>행정청접수일자</th>
					<td>
						<%= suitMap.get("ADMA_RCPT_YMD")==null?"":suitMap.get("ADMA_RCPT_YMD").toString() %>
					</td>
					<th>사건관련토지</th>
					<td>
						<%= suitMap.get("INCDNT_REL_LAND_NM")==null?"":suitMap.get("INCDNT_REL_LAND_NM").toString() %>
					</td>
				</tr>
				<tr>
					<th>
						관련문서
						<%if("Y".equals(adminYn)){%>
						<div>
							<a href="#none" class="innerBtn" onclick="goSchCasePop();" style="float:left; height:20px; line-height:18px;">관련사건 관리</a>
						</div>
						<%}%>
					</th>
					<td colspan="5">
				<%
					if(relList.size() > 0) {
						for(int i=0; i<relList.size(); i++) {
							HashMap relMap = (HashMap)relList.get(i);
							String DOC_SE = relMap.get("DOC_SE")==null?"":relMap.get("DOC_SE").toString();
							String DOC_SE_NM = relMap.get("DOC_SE_NM")==null?"":relMap.get("DOC_SE_NM").toString();
							String REL_DOC_MNG_NO = relMap.get("REL_DOC_MNG_NO")==null?"":relMap.get("REL_DOC_MNG_NO").toString();
				%>
						<div class="relDiv" onclick="goRelDocView('<%=DOC_SE%>', '<%=REL_DOC_MNG_NO%>');">[<%=DOC_SE_NM%>] <%=relMap.get("DOC_NM")==null?"":relMap.get("DOC_NM").toString()%></div>
				<%
						}
					}
				%>
					</td>
				</tr>
				<tr>
					<th>사건개요</th>
					<td colspan="5">
						<%= suitMap.get("INCDNT_OTLN")==null?"":suitMap.get("INCDNT_OTLN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>주요내용</th>
					<td colspan="5">
						<%= suitMap.get("MAIN_CN")==null?"":suitMap.get("MAIN_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>소송입증내용</th>
					<td colspan="5">
						<%= suitMap.get("LWS_CONF_DATA_CN")==null?"":suitMap.get("LWS_CONF_DATA_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="5">
						<%= suitMap.get("RMRK_CN")==null?"":suitMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %>
					</td>
				</tr>
				<tr>
					<th>첨부파일(입증자료)</th>
					<td colspan="5">
				<%
					for(int f=0; f<suitConfFile.size(); f++) {
						HashMap file = (HashMap)suitConfFile.get(f);
				%>
						<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
							<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
						</div>
				<%
					}
				%>
					</td>
				</tr>
			</table>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<a href="#none" class="sBtn type2" onclick="goListPage();">목록</a>
			</div>
			<div class="subBtnC right">
			<%if("Y".equals(adminYn)){%>
				<a href="#none" class="sBtn type2" onclick="goEditSuitMain();">수정</a>
				<a href="#none" class="sBtn type3" onclick="goDelInfo('suit');">삭제</a>
			<%}%>
			</div>
		</div>
		<hr class="margin40">
		<div class="subTTW">
			<div class="subTTC left">
				<strong class="subTT" id="caseInfoTitle"></strong>
				<%if (!SEL_INST_MNG_NO.equals("")) { %>
				<a href="#none" id="openBtn" class="innerBtn" onclick="caseDivOpen(1)">열기</a>
				<a href="#none" id="closeBtn" class="innerBtn" onclick="caseDivOpen(0)">닫기</a>
				<%} %>
			</div>
			<div class="subTTC right">
				<%if (!SEL_INST_MNG_NO.equals("")) { %>
				<a href="#none" class="sBtn type4" onclick="goGianPop();">양식관리</a>
				<a href="#none" class="sBtn type4" onclick="goFileView();">파일뷰어</a>
				<a href="#none" class="sBtn type4" onclick="goCourtFileView();">전자소송파일</a>
				<%} %>
			</div>
		</div>
		<div id="innerCont">
			<hr class="margin10">
			<strong class="countT">진행내역(목록)</strong>
			<hr class="margin10">
			<div class="innerB">
				<div id="caseGrid"></div>
				<div class="subBtnW side">
					<div class="subBtnC left" style="height:40px;">
						<%if("Y".equals(adminYn)){%>
						<a href="#none" class="sBtn type1" id="insertBtn" style="margin-top:3px;" onclick="goCaseWrite('insert')">등록</a>
						<%}%>
					</div>
				</div>
			</div>
<%
	if (!SEL_INST_MNG_NO.equals("")) {
%>
			<div id="caseDetail">
				<input type="text" id="inFocu2" style="opacity:0; display:block;"/>
				<strong class="countT"><span class="simSpan"></span> 상세내용</strong>
				<hr class="margin10">
				<div class="innerB">
					<table class="infoTable">
						<colgroup>
							<col style="width:10%;">
							<col style="width:*;">
							<col style="width:10%;">
							<col style="width:*;">
							<col style="width:10%;">
							<col style="width:*;">
						</colgroup>
						<tr>
							<th>심급</th>
							<td><%=caseMap.get("INST_NM")==null?"":caseMap.get("INST_NM").toString()%></td>
							<th>소제기일</th>
							<td><%=caseMap.get("FLGLW_YMD")==null?"":caseMap.get("FLGLW_YMD").toString()%></td>
							<th>사건번호</th>
							<td><%=caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString()%></td>
						</tr>
						<tr>
							<th>구분</th>
							<td><%=caseMap.get("INCDNT_SE_NM")==null?"":caseMap.get("INCDNT_SE_NM").toString()%></td>
							<th>관할법원</th>
							<td><%=caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString()%></td>
							<th>재판부</th>
							<td><%=caseMap.get("JSDP_NM")==null?"":caseMap.get("JSDP_NM").toString()%></td>
						</tr>
						<tr>
							<th>소송당사자</th>
							<td colspan="5">
								<table class="infoTable" id="empTable">
									<colgroup>
										<col style="width:10%;">
										<col style="width:15%;">
										<col style="width:15%;">
										<col style="width:*;">
									</colgroup>
									<tr>
										<th style="text-align:center;">구분</th>
										<th style="text-align:center;">이름</th>
										<th style="text-align:center;">연락처</th>
										<th style="text-align:center;">주소</th>
										<th style="text-align:center;">비고</th>
									</tr>
							<%
								if(empList.size() > 0) {
									for (int i=0; i<empList.size(); i++) {
										HashMap empMap = (HashMap)empList.get(i);
							%>
									<tr>
										<td><%=empMap.get("LWS_CNCPR_SE_NM")==null?"":empMap.get("LWS_CNCPR_SE_NM").toString()%></td>
										<td><%=empMap.get("LWS_CNCPR_NM")==null?"":empMap.get("LWS_CNCPR_NM").toString()%></td>
										<td><%=empMap.get("LWS_CNCPR_CNPL")==null?"":empMap.get("LWS_CNCPR_CNPL").toString()%></td>
										<td><%=empMap.get("LWS_CNCPR_ADDR")==null?"":empMap.get("LWS_CNCPR_ADDR").toString()%></td>
										<td><%=empMap.get("RMRK_CN")==null?"":empMap.get("RMRK_CN").toString()%></td>
									</tr>
							<%
									}
								} else {
							%>
									<tr>
										<td colspan="5">등록 된 당사자 정보가 없습니다.</td>
									</tr>
							<%
								}
							%>
								</table>
							</td>
						</tr>
						<tr>
							<th>소송가액</th>
							<td>
								<%=caseMap.get("LWS_EQVL")==null?"":caseMap.get("LWS_EQVL").toString()%>
							</td>
							<th>변경소송가액</th>
							<td>
								<%=caseMap.get("CHG_LWS_EQVL")==null?"":caseMap.get("CHG_LWS_EQVL").toString()%>
							</td>
							<th colspan="2"></th>
						</tr>
						<tr>
							<th>검찰청 사건번호</th>
							<td>
								<%=caseMap.get("PPOF_INCDNT_NO")==null?"":caseMap.get("PPOF_INCDNT_NO").toString()%>
							</td>
							<th>공동수행여부</th>
							<td>
								<%=caseMap.get("JNT_FLFMT_YN")==null?"":caseMap.get("JNT_FLFMT_YN").toString()%>
							</td>
							<th colspan="2"></th>
						</tr>
						<tr>
							<th>검찰청 소송수행자</th>
							<td>
								<%=caseMap.get("PPOF_LWS_FLFMT_EMP_NM")==null?"":caseMap.get("PPOF_LWS_FLFMT_EMP_NM").toString()%>
							</td>
							<th>담당검사</th>
							<td>
								<%=caseMap.get("TKCG_PROC_NM")==null?"":caseMap.get("TKCG_PROC_NM").toString()%>
							</td>
							<th colspan="2"></th>
						</tr>
						<tr>
							<th>특이사항</th>
							<td colspan="5">
								<%= caseMap.get("RMRK_CN")==null?"":caseMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %>
							</td>
						</tr>
						<tr>
							<th>판결분류</th>
							<td><%=caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString()%></td>
							<th>신청사건여부</th>
							<td><%=caseMap.get("APLY_INCDNT_YN")==null?"":caseMap.get("APLY_INCDNT_YN").toString()%></td>
							<th colspan="2"></th>
						</tr>
						<tr>
							<th>판결선고일</th>
							<td><%=caseMap.get("JDGM_ADJ_YMD")==null?"":caseMap.get("JDGM_ADJ_YMD").toString()%></td>
							<th>판결송달일</th>
							<td><%=caseMap.get("RLNG_TMTL_YMD")==null?"":caseMap.get("RLNG_TMTL_YMD").toString()%></td>
							<th>판결확정일</th>
							<td><%=caseMap.get("JDGM_CFMTN_YMD")==null?"":caseMap.get("JDGM_CFMTN_YMD").toString()%></td>
						</tr>
						<tr>
							<th>판결금액</th>
							<td><%=caseMap.get("JDGM_AMT")==null?"":caseMap.get("JDGM_AMT").toString()%></td>
							<th>판결금 이자</th>
							<td><%=caseMap.get("JDGM_AMT_INT")==null?"":caseMap.get("JDGM_AMT_INT").toString()%></td>
							<th colspan="2"></th>
						</tr>
					<%
						String APLY_INCDNT_YN = caseMap.get("APLY_INCDNT_YN")==null?"":caseMap.get("APLY_INCDNT_YN").toString();
						if ("N".equals(APLY_INCDNT_YN)) {
					%>
						<tr>
							<th>신청사건불이행사유</th>
							<td colspan="5">
								<%= caseMap.get("APLY_INCDNT_FAU_RSN")==null?"":caseMap.get("APLY_INCDNT_FAU_RSN").toString().replaceAll("\n","<br/>") %>
							</td>
						</tr>
					<%
						}
					%>
						<tr>
							<th>판결내용</th>
							<td colspan="5">
								<%= caseMap.get("JDGM_CN")==null?"":caseMap.get("JDGM_CN").toString().replaceAll("\n","<br/>") %>
							</td>
						</tr>
						<tr>
							<th>소장</th>
							<td colspan="5">
						<%
							for(int f=0; f<caseFile.size(); f++) {
								HashMap file = (HashMap)caseFile.get(f);
								String FILE_SE = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
								if ("CA".equals(FILE_SE)) {
						%>
								<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
									<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
								</div>
						<%
								}
							}
						%>
							</td>
						</tr>
						<tr>
							<th>판결문</th>
							<td colspan="5" id="resultFileList">
							<%
								for(int f=0; f<caseFile.size(); f++) {
									HashMap file = (HashMap)caseFile.get(f);
									String FILE_SE = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
									if ("RE".equals(FILE_SE)) {
							%>
									<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
										<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
									</div>
							<%
									}
								}
							%>
							</td>
						</tr>
						<tr>
							<th>기타</th>
							<td colspan="5" id="resultFileList">
							<%
								for(int f=0; f<caseFile.size(); f++) {
									HashMap file = (HashMap)caseFile.get(f);
									String FILE_SE = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
									if ("ET".equals(FILE_SE)) {
							%>
									<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'>
										<%=file.get("PHYS_FILE_NM").toString()%> (<%=file.get("VIEW_SZ").toString()%>)
									</div>
							<%
									}
								}
							%>
							</td>
						</tr>
					</table>
				</div>
				<div class="subBtnW side">
					<div class="subBtnC left">
					</div>
					<div class="subBtnC right">
						<%if("Y".equals(adminYn)){%>
						<a href="#none" class="sBtn type2" onclick="goCaseWrite('edit');">수정</a>
						<a href="#none" class="sBtn type3" onclick="goDelInfo('case');">삭제</a>
						<%} %>
					</div>
				</div>
			</div>
<%
	}
%>
		<hr class="margin30">
<%
	if (!SEL_INST_MNG_NO.equals("")) {
%>
		<div class="subTabW set8" id="tapMenuDiv">
			<ul>
				<li><a id="relEmp"           href="#none" onclick="goView(this.id)" title="소송 수행자를 등록합니다">소송수행자</a></li>
				<li><a id="chrgLawyer"       href="#none" onclick="goView(this.id)" title="소송 대리인을 등록합니다">소송위임</a></li>
				<li><a id="caseProg"         href="#none" onclick="goView(this.id)" title="소송 진행상황을 조회합니다.">진행상황</a></li>
				<li><a id="caseDate"         href="#none" onclick="goView(this.id)" title="법원기일을 등록하여 관리합니다">기일정보</a></li>
				<li><a id="caseDoc"          href="#none" onclick="goView(this.id)" title="서면,서증,보고자료 파일을 등록합니다">제출/송달서면</a></li>
				<li><a id="caseCost"         href="#none" onclick="goView(this.id)" title="비용을 관리하고 기안합니다">비용정보</a></li>
				<li><a id="caseBond"         href="#none" onclick="goView(this.id)" title="소송건에 대한 채권 정보를 관리합니다.">채권관리</a></li>
				<li><a id="report"           href="#none" onclick="goView(this.id)" title="보고자료 등 문서를 저장합니다">보고서</a></li>
				<li><a id="chkProgress"      href="#none" onclick="goView(this.id)" title="담당자와 변호사의 검토사항을 등록합니다">검토진행</a></li>
				<li><a id="memo"             href="#none" onclick="goView(this.id)" title="소송 관련 메모를 기록합니다.">메모</a></li>
				<li><a id="caseSatisfaction" href="#none" onclick="goView(this.id)" title="만족도를 평가합니다.">만족도조사</a></li>
			</ul>
		</div>
<%
		//tabId = "../"+tabId;
		tabId = "../tab/"+tabId;
%>
		<div id="tapDiv">
			<jsp:include page="<%=tabId %>" flush="false">
				<jsp:param value="<%=LWS_MNG_NO %>"      name="LWS_MNG_NO"/>
				<jsp:param value=""                      name="selCaseId"/>
				<jsp:param value="<%=tabcaseid %>"       name="tabcaseid"/>
				<jsp:param value="<%=writercd %>"        name="writercd"/>
				<jsp:param value="<%=SPRVSN_DEPT_NO%>"   name="SPRVSN_DEPT_NO"/>
				<jsp:param value="MAIN"                  name="MGBN"/>
				<jsp:param value="<%=MENU_MNG_NO %>"     name="MENU_MNG_NO"/>
				<jsp:param value="<%=adminYn %>"         name="adminYn"/>
			</jsp:include>
			<input type="text" id="inFocu"/>
		</div>
		<hr class="margin30">
<%
	}
%>
	</div>
</form>