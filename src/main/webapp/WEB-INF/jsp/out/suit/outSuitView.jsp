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
	
	String LWS_MNG_NO = suitMap.get("LWS_MNG_NO")==null?"":suitMap.get("LWS_MNG_NO").toString();
	String JDGM_UP_TYPE_NM = caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString();
	
	System.out.println(request);
	
	String SEL_INST_MNG_NO = request.getAttribute("SEL_INST_MNG_NO")==null?"":request.getAttribute("SEL_INST_MNG_NO").toString();
	String MENU_MNG_NO     = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	String WRTR_EMP_NM     = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO     = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM     = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO     = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String focus           = request.getAttribute("focus")==null?"":request.getAttribute("focus").toString();
	String writercd        = request.getAttribute("writercd")==null?"":request.getAttribute("writercd").toString();
	String RCPT_YN         = request.getAttribute("RCPT_YN")==null?"":request.getAttribute("RCPT_YN").toString();
	String searchForm      = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	int tabcaseid          = ServletRequestUtils.getIntParameter(request, "tabcaseid", 0);
	
	String lawyernm = WRT_DEPT_NM + " " + WRTR_EMP_NM;
	
	String userAgent = request.getHeader("user-agent");
	boolean mobile1 = userAgent.matches( ".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
	boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*");
	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RCPT_YN : " + RCPT_YN);
	
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
	.subTabW.set8 ul li {
		width:16.66%;
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
				{header:"심급코드",          dataIndex:'INST_CD',    hidden:true},
				{header:"<b>심급</b>",       width:120, align:'left', dataIndex:'INST_NM',   sortable:true},
				{header:"<b>법원</b>",       width:150, align:'left', dataIndex:'CT_NM',     sortable:true},
				{header:"<b>사건번호</b>",   width:150, align:'left', dataIndex:'INCDNT_NO', sortable:true},
				{header:"<b>소제기일</b>",   width:100, align:'left', dataIndex:'FLGLW_YMD', sortable:true}
			<%if (!mobile1 && !mobile2) {%>
				,
				{header:"<b>판결선고일</b>", width:100, align:'left', dataIndex:'JDGM_ADJ_YMD',   sortable:true},
				{header:"<b>승패소구분</b>", width:100, align:'left', dataIndex:'JDGM_UP_TYPE_NM',  sortable:true},
				{header:"<b>판결분류</b>",   width:100, align:'left', dataIndex:'JDGM_LWR_TYPE_NM',   sortable:true},
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
						return empnm + btn;
					}
				}
			<%}%>
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
					if(record.get("INST_MNG_NO") == INST_MNG_NO){
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
		
		try{
			setGrid();
		}catch(e){
			console.log("그리드 생성 에러");
		}
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
		document.frm.action = "<%=CONTEXTPATH%>/out/lawyerSuitViewPage.do";
		document.frm.submit();
	}
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/out/outSuitList.do";
		document.frm.submit();
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
	
	function setRcpt(yn, docgbn) {
		if(yn == "Y") {
			// 상태값만 변경
			$.ajax({
				type:"POST",
				url : "${pageContext.request.contextPath}/out/rfslRsnSave.do",
				data : {
					RCPT_YN:yn,
					DOC_GBN:'SUIT',
					RFSL_RSN:'',
					DOC_PK:$("#SEL_INST_MNG_NO").val(),
					WRTR_EMP_NO:"<%=WRTR_EMP_NO%>",
					LWYR_NM:"<%=lawyernm%>",
				},
				dataType: "json",
				async: false,
				success : function(result){
					alert("저장되었습니다.");
					goReLoad();
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
			newForm.append($("<input/>", {type:"hidden", name:"DOC_PK", value:$("#SEL_INST_MNG_NO").val()}));
			newForm.append($("<input/>", {type:"hidden", name:"DOC_GBN", value:'SUIT'}));
			newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
			newForm.appendTo("body");
			newForm.submit();
			newForm.remove();
		}
	}
	
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="searchForm"      id="searchForm"      value="<%=searchForm%>"/>
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="<%=LWS_MNG_NO %>"/>
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="<%=SEL_INST_MNG_NO %>"/>
	<input type="hidden" name="selectedCaseId"  id="selectedCaseId"  value="<%=SEL_INST_MNG_NO %>"/>
	<input type="hidden" name="SEL_INST_MNG_NO" id="SEL_INST_MNG_NO" value="<%=SEL_INST_MNG_NO %>"/>
	<input type="hidden" name="PRGRS_STTS_CD"   id="PRGRS_STTS_CD"   value=""/>
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
		<div class="innerS">
			<div class="subContW">
				<div class="form-wrapper">
					<div class="form-group cols-2">
						<div class="formC">
							<label>관리번호</label>
							<div class="form_box">
								<p><%= suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString() %></p>
							</div>
						</div>
						<div class="formC">
							<label>사건명</label>
							<div class="form_box">
								<p><%= suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString() %></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-3">
						<div class="formC">
							<label>진행상태</label>
							<div class="form_box">
								<p><%= suitMap.get("LWS_PRGRS_STTS")==null?"":suitMap.get("LWS_PRGRS_STTS").toString() %></p>
							</div>
						</div>
						<div class="formC">
							<label>구분</label>
							<div class="form_box">
								<p><%= suitMap.get("LWS_SE_NM")==null?"":suitMap.get("LWS_SE_NM").toString() %></p>
							</div>
						</div>
						<div class="formC">
							<label>소송유형</label>
							<div class="form_box">
								<p><%= suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString() %>-<%= suitMap.get("LWS_LWR_TYPE_NM")==null?"":suitMap.get("LWS_LWR_TYPE_NM").toString() %></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-3">
						<div class="formC">
							<label>주관부서</label>
							<div class="form_box">
								<p><%= suitMap.get("LWS_PRGRS_STTS")==null?"":suitMap.get("LWS_PRGRS_STTS").toString() %></p>
							</div>
						</div>
						<div class="formC">
							<label>주관부서 담당자</label>
							<div class="form_box">
								<p><%= suitMap.get("LWS_SE_NM")==null?"":suitMap.get("LWS_SE_NM").toString() %></p>
							</div>
						</div>
						<div class="formC">
							<label>기타주관부서</label>
							<div class="form_box">
								<p><%= suitMap.get("ETC_SPRVSN_DEPT_NM")==null?"":suitMap.get("ETC_SPRVSN_DEPT_NM").toString() %></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-3">
						<div class="formC">
							<label>소제기일자</label>
							<div class="form_box">
								<p><%= suitMap.get("FLGLW_YMD")==null?"":suitMap.get("FLGLW_YMD").toString() %></p>
							</div>
						</div>
						<div class="formC">
							<label>행정청접수일자</label>
							<div class="form_box">
								<p><%= suitMap.get("ADMA_RCPT_YMD")==null?"":suitMap.get("ADMA_RCPT_YMD").toString() %></p>
							</div>
						</div>
						<div class="formC">
							<label>사건관련토지</label>
							<div class="form_box">
								<p><%= suitMap.get("INCDNT_REL_LAND_NM")==null?"":suitMap.get("INCDNT_REL_LAND_NM").toString() %></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>사건개요</label>
							<div class="form_box">
								<p><%= suitMap.get("INCDNT_OTLN")==null?"":suitMap.get("INCDNT_OTLN").toString().replaceAll("\n","<br/>") %></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>주요내용</label>
							<div class="form_box">
								<p><%= suitMap.get("MAIN_CN")==null?"":suitMap.get("MAIN_CN").toString().replaceAll("\n","<br/>") %></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>소송입증내용</label>
							<div class="form_box">
								<p><%= suitMap.get("LWS_CONF_DATA_CN")==null?"":suitMap.get("LWS_CONF_DATA_CN").toString().replaceAll("\n","<br/>") %></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>비고</label>
							<div class="form_box">
								<p><%= suitMap.get("RMRK_CN")==null?"":suitMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %></p>
							</div>
						</div>
					</div>
					<div class="form-group cols-1">
						<div class="formC">
							<label>첨부파일(입증자료)</label>
								<p>
							<%
								for(int f=0; f<suitConfFile.size(); f++) {
									HashMap file = (HashMap)suitConfFile.get(f);
							%>
									<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'><%=file.get("PHYS_FILE_NM").toString()%></div>
							<%
								}
							%>
								</p>
						</div>
					</div>
					<div class="btn-group btns-3">
						<button class="form_btn style1" onclick="goListPage();">목록</button>
						<%if("A".equals(RCPT_YN)) {%>
						<button class="form_btn style2" onclick="setRcpt('Y');">접수</button>
						<button class="form_btn style3" onclick="setRcpt('N');">반려</button>
						<%}%>
					</div>
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
						</div>
					</div>
				</div>
			</div>
<%
	if (!SEL_INST_MNG_NO.equals("")) {
%>
			<div class="innerS">
				<div class="subContW">
					<div class="form-wrapper">
						<div class="form-group cols-3">
							<div class="formC">
								<label>심급</label>
								<div class="form_box">
									<input type="text" id="inFocu2" style="opacity:0; display:block;"/>
									<p><%=caseMap.get("INST_NM")==null?"":caseMap.get("INST_NM").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>소제기일</label>
								<div class="form_box">
									<p><%=caseMap.get("FLGLW_YMD")==null?"":caseMap.get("FLGLW_YMD").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>사건번호</label>
								<div class="form_box">
									<p><%=caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString()%></p>
								</div>
							</div>
						</div>
						<div class="form-group cols-3">
							<div class="formC">
								<label>구분</label>
								<div class="form_box">
									<p><%=caseMap.get("INCDNT_SE_NM")==null?"":caseMap.get("INCDNT_SE_NM").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>관할법원</label>
								<div class="form_box">
									<p><%=caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>재판부</label>
								<div class="form_box">
									<p><%=caseMap.get("JSDP_NM")==null?"":caseMap.get("JSDP_NM").toString()%></p>
								</div>
							</div>
						</div>
						<div class="form-group cols-1">
							<div class="formC">
								<label>소송당사자</label>
								<table class="infoTable" id="empTable" style="font-size:16px;">
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
							</div>
						</div>
						<div class="form-group cols-2">
							<div class="formC">
								<label>소송가액</label>
								<div class="form_box">
									<p><%=caseMap.get("LWS_EQVL")==null?"":caseMap.get("LWS_EQVL").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>변경소송가액</label>
								<div class="form_box">
									<p><%=caseMap.get("CHG_LWS_EQVL")==null?"":caseMap.get("CHG_LWS_EQVL").toString()%></p>
								</div>
							</div>
						</div>
						<div class="form-group cols-2">
							<div class="formC">
								<label>검찰청 사건번호</label>
								<div class="form_box">
									<p><%=caseMap.get("PPOF_INCDNT_NO")==null?"":caseMap.get("PPOF_INCDNT_NO").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>공동수행여부</label>
								<div class="form_box">
									<p><%=caseMap.get("JNT_FLFMT_YN")==null?"":caseMap.get("JNT_FLFMT_YN").toString()%></p>
								</div>
							</div>
						</div>
						<div class="form-group cols-2">
							<div class="formC">
								<label>검찰청 소송수행자</label>
								<div class="form_box">
									<p><%=caseMap.get("PPOF_LWS_FLFMT_EMP_NM")==null?"":caseMap.get("PPOF_LWS_FLFMT_EMP_NM").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>담당검사</label>
								<div class="form_box">
									<p><%=caseMap.get("TKCG_PROC_NM")==null?"":caseMap.get("TKCG_PROC_NM").toString()%></p>
								</div>
							</div>
						</div>
						<div class="form-group cols-1">
							<div class="formC">
								<label>특이사항</label>
								<div class="form_box">
									<p><%= caseMap.get("RMRK_CN")==null?"":caseMap.get("RMRK_CN").toString().replaceAll("\n","<br/>") %></p>
								</div>
							</div>
						</div>
						<div class="form-group cols-2">
							<div class="formC">
								<label>판결분류</label>
								<div class="form_box">
									<p><%=caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>신청사건여부</label>
								<div class="form_box">
									<p><%=caseMap.get("APLY_INCDNT_YN")==null?"":caseMap.get("APLY_INCDNT_YN").toString()%></p>
								</div>
							</div>
						</div>
						<div class="form-group cols-3">
							<div class="formC">
								<label>판결선고일</label>
								<div class="form_box">
									<p><%=caseMap.get("JDGM_ADJ_YMD")==null?"":caseMap.get("JDGM_ADJ_YMD").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>판결송달일</label>
								<div class="form_box">
									<p><%=caseMap.get("RLNG_TMTL_YMD")==null?"":caseMap.get("RLNG_TMTL_YMD").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>판결확정일</label>
								<div class="form_box">
									<p><%=caseMap.get("JDGM_CFMTN_YMD")==null?"":caseMap.get("JDGM_CFMTN_YMD").toString()%></p>
								</div>
							</div>
						</div>
						<div class="form-group cols-2">
							<div class="formC">
								<label>판결금액</label>
								<div class="form_box">
									<p><%=caseMap.get("JDGM_AMT")==null?"":caseMap.get("JDGM_AMT").toString()%></p>
								</div>
							</div>
							<div class="formC">
								<label>판결금 이자</label>
								<div class="form_box">
									<p><%=caseMap.get("JDGM_AMT_INT")==null?"":caseMap.get("JDGM_AMT_INT").toString()%></p>
								</div>
							</div>
						</div>
					<%
						String APLY_INCDNT_YN = caseMap.get("APLY_INCDNT_YN")==null?"":caseMap.get("APLY_INCDNT_YN").toString();
						if ("N".equals(APLY_INCDNT_YN)) {
					%>
						<div class="form-group cols-1">
							<div class="formC">
								<label>신청사건불이행사유</label>
								<div class="form_box">
									<p><%= caseMap.get("APLY_INCDNT_FAU_RSN")==null?"":caseMap.get("APLY_INCDNT_FAU_RSN").toString().replaceAll("\n","<br/>") %></p>
								</div>
							</div>
						</div>
					<%
						}
					%>
						<div class="form-group cols-1">
							<div class="formC">
								<label>판결내용</label>
								<div class="form_box">
									<p><%= caseMap.get("JDGM_CN")==null?"":caseMap.get("JDGM_CN").toString().replaceAll("\n","<br/>") %></p>
								</div>
							</div>
						</div>
						<div class="form-group cols-1">
							<div class="formC">
								<label>소장</label>
							<%
								for(int f=0; f<caseFile.size(); f++) {
									HashMap file = (HashMap)caseFile.get(f);
									String FILE_SE = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
									if ("CA".equals(FILE_SE)) {
							%>
									<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'><%=file.get("PHYS_FILE_NM").toString()%></div>
							<%
									}
								}
							%>
							</div>
						</div>
						<div class="form-group cols-1">
							<div class="formC">
								<label>판결문</label>
							<%
								for(int f=0; f<caseFile.size(); f++) {
									HashMap file = (HashMap)caseFile.get(f);
									String FILE_SE = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
									if ("RE".equals(FILE_SE)) {
							%>
									<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'><%=file.get("PHYS_FILE_NM").toString()%></div>
							<%
									}
								}
							%>
							</div>
						</div>
						<div class="form-group cols-1">
							<div class="formC">
								<label>기타</label>
							<%
								for(int f=0; f<caseFile.size(); f++) {
									HashMap file = (HashMap)caseFile.get(f);
									String FILE_SE = file.get("FILE_SE")==null?"":file.get("FILE_SE").toString();
									if ("ET".equals(FILE_SE)) {
							%>
									<div class="selFileDiv" onclick='downFile("<%=file.get("PHYS_FILE_NM").toString()%>", "<%=file.get("SRVR_FILE_NM").toString()%>", "SUIT")'><%=file.get("PHYS_FILE_NM").toString()%></div>
							<%
									}
								}
							%>
							</div>
						</div>
						<%if(!RCPT_YN.equals("A")) {%>
						<div class="btn-group btns-2">
							<button class="form_btn style2" onclick="goCaseWrite('edit');">수정</button>
							<button class="form_btn style3" onclick="goDelInfo('case');">삭제</button>
						</div>
						<%}%>
					</div>
				</div>
			</div>
<%
}
%>
			<hr class="margin30">
<%
	if (!SEL_INST_MNG_NO.equals("") && !RCPT_YN.equals("A")) {
%>
		<div class="subTabW set8" id="tapMenuDiv">
			<ul>
				<li><a id="relEmp"           href="#none" onclick="goView(this.id)" title="소송 수행자를 등록합니다">소송수행자</a></li>
				<li><a id="chrgLawyer"       href="#none" onclick="goView(this.id)" title="소송 대리인을 등록합니다">소송위임</a></li>
				<li><a id="caseDate"         href="#none" onclick="goView(this.id)" title="법원기일을 등록하여 관리합니다">기일정보</a></li>
				<li><a id="caseDoc"          href="#none" onclick="goView(this.id)" title="서면,서증,보고자료 파일을 등록합니다">제출/송달서면</a></li>
				<li><a id="caseCost"         href="#none" onclick="goView(this.id)" title="비용을 관리하고 기안합니다">비용정보</a></li>
				<li><a id="chkProgress"      href="#none" onclick="goView(this.id)" title="담당자와 변호사의 검토사항을 등록합니다">검토진행</a></li>
			</ul>
		</div>
<%
		//tabId = "../"+tabId;
		tabId = "../../web/suit/tab/"+tabId;
%>
		<div id="tapDiv">
			<jsp:include page="<%=tabId %>" flush="false">
				<jsp:param value="<%=LWS_MNG_NO %>" name="LWS_MNG_NO"/>
				<jsp:param value=""                 name="selCaseId"/>
				<jsp:param value="<%=tabcaseid %>"  name="tabcaseid"/>
				<jsp:param value="<%=writercd %>"   name="writercd"/>
				<jsp:param value="MAIN"             name="MGBN"/>
				<jsp:param value="<%=MENU_MNG_NO %>"     name="MENU_MNG_NO"/>
			</jsp:include>
			<input type="text" id="inFocu"/>
		</div>
		<hr class="margin30">
<%
	}
%>
	</div>
</form>