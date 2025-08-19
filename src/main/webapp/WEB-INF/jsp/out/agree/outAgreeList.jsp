<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%
	int pageSize = 20;
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String OPENYN = "Y";
	if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("A")>-1) {
		OPENYN = "N";
	}
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String lawyernm = WRT_DEPT_NM + " " + WRTR_EMP_NM;
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
	
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String gbnid = request.getParameter("gbnid")==null?"":request.getParameter("gbnid").toString();
	
	String userAgent = request.getHeader("user-agent");
	boolean mobile1 = userAgent.matches( ".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
	boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*");
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/mten.static.js"></script>
<script type="text/javascript" src="${resourceUrl}/js/mten.util.js"></script>
<style>
	.x-grid-panel .x-panel-body {
		min-height:300px;
	}
</style>
<script>
	var gbnid = "<%=gbnid%>";
	var MENU_MNG_NO = "<%=MENU_MNG_NO%>";
	var gMinus = 300;
	
	$(document).ready(function(){
		$(".subSch").css("display", "none");
		
		if (MENU_MNG_NO != "100000594") {
			$("#typecdnm").append($("#subTT").html());
			$("#CVTN_CTRT_TYPE_CD_NM").val($("#subTT").html());
		}
		
		if (gbnid != "") {
			gotoview(gbnid);
		}
		
		$("#sBtn").click(function(){
			var obj = gridStore.baseParams;
			var searchForm = "";
			for(var key in obj){
				searchForm = searchForm + "," + (key+"|"+obj[key]);
			}
			$("#searchForm").val(searchForm);
			
			var frm = document.goList;
			$("#agreeid").val('');
			frm.action = "${pageContext.request.contextPath}/web/agree/agreeWritePage.do";
			frm.submit();
		});
	});
	
	var gridStore;
	Ext.QuickTips.init();
	Ext.onReady(function(){
		$("#start").val(0);
		<%
		for(int i=0; i<sf.length; i++){
			System.out.println("searchForm===>"+sf[i]);
			String setv[] = sf[i].split("\\|");
			if(setv.length == 2){
			System.out.println("setv[0]===>"+setv[0]);
		%>
			if('<%=setv[0]%>' == "INSD_OTSD_TASK_SE" || '<%=setv[0]%>' == "RFLT_YN_RSLT_REG_YN" || '<%=setv[0]%>' == "EMRG_YN"){
				$("input:radio[name='<%=setv[0]%>']:radio[value='" + "<%=setv[1]%>" + "']").prop("checked", true);
			} else {
				$("#<%=setv[0]%>").val('<%=setv[1]%>');
			}
		<%
				if (!setv[0].equals("pagesize") && !setv[0].equals("MENU_MNG_NO")) {
		%>
					$(".downBtn").css("display", "none");
					$(".upBtn").css("display", "");
					$(".subSch").css("display", "");
					gMinus = 410;
		<%
				}
			}
		}
		%>
		
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
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
			{name : 'RCPT_YN'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
					url: "${pageContext.request.contextPath}/out/selectOutAgreeList.do"
			}),
			remoteSort:true,
			reader: new Ext.data.JsonReader({root: 'result', totalProperty: 'total', idProperty: 'CVTN_MNG_NO'},myRecordObj),
			pageSize: 25,
			listeners:{
				load:function(store, records, success) {
					$("#gcnt").text(store.getTotalCount());
					$("#gcnt").number(true);
				}
			}
		});

		var combo = new Ext.form.ComboBox({
			name : 'perpage',
			width: 40,
			store: new Ext.data.ArrayStore({
				fields: ['id'],
				data  : [['20'],['50'],['100']]
			}),
			mode : 'local',
			value: '20',
			listWidth     : 40,
			triggerAction : 'all',
			displayField  : 'id',
			valueField    : 'id',
			editable      : false,
			forceSelection: true,
			listeners:{
				select : function(item,newValue){
					bbar.pageSize = parseInt(newValue.get('id'), 10);
					bbar.doLoad(bbar.cursor);
					
					var newPagesize = parseInt(newValue.get('id'), 10);
					$("#pagesize").val(newPagesize);
					gridStore.pagesize = newPagesize;
					gridStore.load({
						params:{
							start:parseInt($("#start").val()),
							limit : newPagesize,
							pagesize : newPagesize
						}
					});
				},scope: this
			}
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
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
						var selModel=grid.getSelectionModel();
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
		
		var bbar = new Ext.PagingToolbar({
			pagesize : $("#pagesize").val(),
			autoWidth : true,
			store : gridStore,
			displayInfo : true,
			items : [ '-', 'Per Page: ', combo ],
			displayMsg : '전체 {2}의 결과중 {0} - {1}',
			emptyMsg : "검색된 결과가 없습니다.",
			listeners : {
				beforechange : function(paging, page, eopts) {
					$("#start").val(0);
					$("#start").val(page.start);
				},
				change : function(thisd, params) {
					/* params.activePage
					 * params.pages
					 * params.total
					 */
					
					//pages = params.pages;
					//total = params.total;
					//activePage = params.activePage;
				}
			}
		});
		
		var grid = new Ext.grid.GridPanel({
			id : ids,
			renderTo: 'gridList',
			store: gridStore,
			width: '100%',
			autoWidth: true,
			scroll: false,
			remoteSort: true,
			/* height : $('body').height()-315, */
			autoHeight:true,
			cm: cmm,
			loadMask: {
				msg: '로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows: true,
			viewConfig:{
				forceFit:true,
				enableTextSelection:true,
				emptyText:'조회된 데이터가 없습니다.'
			},
			bbar : bbar,
			iconCls: 'icon_perlist',
			listeners: {
				rowcontextmenu:function(grid, idx, e){
					var selModel=grid.getSelectionModel();
					selModel.selectRow(idx);
					var rowData = selModel.getSelected();
					rowData.showAt(e.getXY());
				},
				rowclick:function(grid, idx, e){
					var obj = gridStore.baseParams;
					var searchForm = "";
					for(var key in obj){
						searchForm = searchForm + "," + (key+"|"+obj[key]);
					}
					$("#searchForm").val(searchForm);
					
					var selModel= grid.getSelectionModel();
					var histData = selModel.getSelected();
					var CVTN_MNG_NO = histData.get('CVTN_MNG_NO');
					gotoview(CVTN_MNG_NO);
				},
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent){
					
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
				start : parseInt($("#start").val()),
				pagesize : $("#pagesize").val(),
				MENU_MNG_NO : '<%=request.getParameter("MENU_MNG_NO")%>',
				CVTN_RQST_YMD1:$("#CVTN_RQST_YMD1").val(),
				CVTN_RQST_YMD2:$("#CVTN_RQST_YMD2").val(),
				CVTN_RPLY_YMD1:$("#CVTN_RPLY_YMD1").val(),
				CVTN_RPLY_YMD2:$("#CVTN_RPLY_YMD2").val(),
				CVTN_CTRT_TYPE_CD_NM:$("#CVTN_CTRT_TYPE_CD_NM").val(),
				PRVT_SRCH_KYWD_CN:$("#PRVT_SRCH_KYWD_CN").val(),
				CVTN_RQST_DEPT_NM:$("#CVTN_RQST_DEPT_NM").val(),
				CVTN_RQST_EMP_NM:$("#CVTN_RQST_EMP_NM").val(),
				CVTN_TKCG_EMP_NM:$("#CVTN_TKCG_EMP_NM").val(),
				RVW_TKCG_EMP_NM:$("#RVW_TKCG_EMP_NM").val(),
				INSD_OTSD_TASK_SE:$('input:radio[name="INSD_OTSD_TASK_SE"]:checked').val(),
				RFLT_YN_RSLT_REG_YN:$('input:radio[name="RFLT_YN_RSLT_REG_YN"]:checked').val(),
				EMRG_YN:$('input:radio[name="EMRG_YN"]:checked').val(),
				CVTN_DOC_NO:$("#CVTN_DOC_NO").val(),
				CVTN_INTL_DOC_NO:$("#CVTN_INTL_DOC_NO").val(),
				CVTN_TTL:$("#CVTN_TTL").val(),
				openyn : '<%=OPENYN%>'
			}
		});
		
		gridStore.load({
			params:{
				start : parseInt($("#start").val()),
				limit : $("#pagesize").val()
			}
		});
		
		$(window).resize(function() {
			if($(".subSch").css("display") == "none"){
				gridResize(300);
			}else{
				gridResize(410);
			}
		})
		
		$(".upBtn").click(function(){
			$(".downBtn").css("display", "");
			$(".upBtn").css("display", "none");
			$(".subSch").css("display", "none");
			gridResize(300);
			goReset();
		});
		$(".downBtn").click(function(){
			$(".downBtn").css("display", "none");
			$(".upBtn").css("display", "");
			$(".subSch").css("display", "");
			gridResize(410);
		});
		
		function gridResize(minus){
			gheight = $('body').height()-minus;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		}
	});
	
	function gotoview(CVTN_MNG_NO){
		document.getElementById("CVTN_MNG_NO").value = CVTN_MNG_NO;
		document.goList.action="<%=CONTEXTPATH%>/out/outAgreeView.do";
		document.goList.submit();
	}
	
	//검색 초기화
	function goReset(){
		$('select').find('option:first').attr('selected', 'selected');
		$(":text").val("");
		$(":hidden").val("");
		goSch();
	}
	
	function goSch(){
		$("#start").val(0);
		
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				start : parseInt($("#start").val()),
				pagesize : $("#pagesize").val(),
				MENU_MNG_NO : '<%=request.getParameter("MENU_MNG_NO")%>',
				CVTN_RQST_YMD1:$("#CVTN_RQST_YMD1").val(),
				CVTN_RQST_YMD2:$("#CVTN_RQST_YMD2").val(),
				CVTN_RPLY_YMD1:$("#CVTN_RPLY_YMD1").val(),
				CVTN_RPLY_YMD2:$("#CVTN_RPLY_YMD2").val(),
				CVTN_CTRT_TYPE_CD_NM:$("#CVTN_CTRT_TYPE_CD_NM").val(),
				PRVT_SRCH_KYWD_CN:$("#PRVT_SRCH_KYWD_CN").val(),
				CVTN_RQST_DEPT_NM:$("#CVTN_RQST_DEPT_NM").val(),
				CVTN_RQST_EMP_NM:$("#CVTN_RQST_EMP_NM").val(),
				CVTN_TKCG_EMP_NM:$("#CVTN_TKCG_EMP_NM").val(),
				RVW_TKCG_EMP_NM:$("#RVW_TKCG_EMP_NM").val(),
				INSD_OTSD_TASK_SE:$('input:radio[name="INSD_OTSD_TASK_SE"]:checked').val(),
				RFLT_YN_RSLT_REG_YN:$('input:radio[name="RFLT_YN_RSLT_REG_YN"]:checked').val(),
				EMRG_YN:$('input:radio[name="EMRG_YN"]:checked').val(),
				CVTN_DOC_NO:$("#CVTN_DOC_NO").val(),
				CVTN_INTL_DOC_NO:$("#CVTN_INTL_DOC_NO").val(),
				CVTN_TTL:$("#CVTN_TTL").val(),
				openyn : '<%=OPENYN%>'
			}
		});
		gridStore.load();
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
					location.href="${pageContext.request.contextPath}/out/outAgreeList.do";
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
</script>
<body>
	
	<div class="subCA">
		<strong class="subTT" id="subTT">협약</strong>
		<form name="goList" id="goList" method="post">
		<input type="hidden" name="searchForm" id="searchForm" value=""/>
		<input type="hidden" name="pageno"/>
		<input type="hidden" name="start" id="start" value=""/>
		<input type="hidden" name="CVTN_MNG_NO"  id="CVTN_MNG_NO"/>
		<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
		<input type="hidden" name="pagesize" id="pagesize" value="<%=pageSize%>"/>
		
		<div class="innerB">
			<table class="infoTable write" style="width:100%;">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr class="subSch">
					<th>의뢰일</th>
					<td>
						<input type="text" id="CVTN_RQST_YMD1" name="CVTN_RQST_YMD1" style="width:40%;" class="datepick" readonly="readonly"/>
						~
						<input type="text" id="CVTN_RQST_YMD2" name="CVTN_RQST_YMD2" style="width:40%;" class="datepick" readonly="readonly"/>
					</td>
					<th>답변일</th>
					<td>
						<input type="text" id="CVTN_RPLY_YMD1" name="CVTN_RPLY_YMD1" style="width:40%;" class="datepick" readonly="readonly"/>
						~
						<input type="text" id="CVTN_RPLY_YMD2" name="CVTN_RPLY_YMD2" style="width:40%;" class="datepick" readonly="readonly"/>
					</td>
					<th>긴급여부</th>
					<td>
						<label><input type="radio" name="EMRG_YN" value="" checked>전체</label>&nbsp;
						<label><input type="radio" name="EMRG_YN" value="N">일반</label>&nbsp;
						<label><input type="radio" name="EMRG_YN" value="Y" >긴급</label>
					</td>
				</tr>
				<tr class="subSch">
					<th>의뢰부서</th>
					<td>
						<input type="text" name="CVTN_RQST_DEPT_NM" id="CVTN_RQST_DEPT_NM" style="width:100%"/>
					</td>
					<th>의뢰인</th>
					<td>
						<input type="text" name="CVTN_RQST_EMP_NM" id="CVTN_RQST_EMP_NM" style="width:100%"/>
					</td>
					<th>담당자</th>
					<td>
						<input type="text" name="CVTN_TKCG_EMP_NM" id="CVTN_TKCG_EMP_NM" style="width:100%"/>
					</td>
				</tr>
				<tr>
					<th>관리번호</th>
					<td>
						<input type="text" name="CVTN_DOC_NO" id="CVTN_DOC_NO" style="width:100%"/>
					</td>
					<th>국제관리번호</th>
					<td>
						<input type="text" name="CVTN_INTL_DOC_NO" id="CVTN_INTL_DOC_NO" style="width:100%"/>
					</td>
					<th>협약내용</th>
					<td>
						<input type="text" id="CVTN_TTL" name="CVTN_TTL" placeholder="제목, 의뢰내용, 비고 등"  style="width: 90%;">
						<a href="#none" class="upBtn" title="접기" style="display:none"></a>
						<a href="#none" class="downBtn" title="펼치기"></a>
					</td>
				</tr>
			</table>
		</div>
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="goSch();">검색</a>
			<a href="#none" class="sBtn type2" onclick="goReset();">초기화</a>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="countT">총 <span id="gcnt">0</span>건</strong>
			</div>
			<div class="subBtnC right">
			</div>
		</div>
		</form>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</body>