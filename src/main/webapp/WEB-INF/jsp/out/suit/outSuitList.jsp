<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	int pageSize = 20;
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	String lawyernm = WRT_DEPT_NM + " " + WRTR_EMP_NM;
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
%>
<style>
	p{color:#57b9ba; font-size:15px; font-weight:bold;}
	.x-grid-panel .x-panel-body {
		min-height:300px;
	}
</style>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	var GRPCD="<%=GRPCD%>";
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/resources/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	Ext.onReady(function(){
		
		<%
		for(int i=0; i<sf.length; i++){
			System.out.println("searchForm===>"+sf[i]);
			String setv[] = sf[i].split("\\|");
			if(setv.length==2){
		%>
			if('<%=setv[0]%>' == "schGbn"){
				$("input:radio[name=schGbn]:radio[value='" + "<%=setv[1]%>" + "']").prop("checked", true);
			}else{
				$("#<%=setv[0]%>").val('<%=setv[1]%>');
			}
		<%
			}
		}
		%>
		
		var ids = "hkk4";
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
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/out/selectOutSuitList.do"
			}),
			remoteSort:true,
			pagesize:$("#pagesize").val(),
			listeners:{
				load:function(store, records, success) {
					$("#gcnt").text(store.getTotalCount());
					$("#gcnt").number(true);
				}
			},
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'LWS_MNG_NO'
			}, myRecordObj)
		});
		
		var combo = new Ext.form.ComboBox({
			name:'perpage',
			width:40,
			store:new Ext.data.ArrayStore({
				fields:['id'],
				data:[['20'],['50'],['100']]
			}),
			mode:'local',
			value:'20',
			listWidth:40,
			triggerAction:'all',
			displayField:'id',
			valueField:'id',
			editable:false,
			forceSelection:true,
			listeners:{
				select:function(item,newValue){
					bbar.pageSize = parseInt(newValue.get('id'), 10);
					bbar.doLoad(bbar.cursor);
					
					var newPagesize = parseInt(newValue.get('id'), 10);
					$("#pagesize").val(newPagesize);
					gridStore.pagesize = newPagesize;
					gridStore.load({
						params:{
							start:0,
							limit:newPagesize,
							pagesize:newPagesize
						}
					});
				},
				scope:this
			}
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>소송아이디</b>",   dataIndex:'LWS_MNG_NO',  hidden:true},
				{header:"<b>사건아이디</b>",   dataIndex:'INST_MNG_NO', hidden:true},
				{header:"<b>중요소송여부</b>", dataIndex:'IMPT_LWS_YN', hidden:true},
				{header:"<b>사건명</b>",       align:'left', dataIndex:'LWS_INCDNT_NM', sortable:true,
					renderer: function(value, cell, record, rowindex, columnindex, store) {
						var selModel=grid.getSelectionModel();
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
				{header:"<b>소송상대방</b>",   align:'center', dataIndex:'LWS_CNCPR_NM', sortable:true},
				{header:"<b>심급</b>",         align:'center', dataIndex:'INST_NM',      sortable:true},
				{header:"<b>사건번호</b>",     align:'center', dataIndex:'INCDNT_NO',    sortable:true},
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
		
		var bbar = new Ext.PagingToolbar({
			pagesize:$("#pagesize").val(),
			autoWidth:true,
			store:gridStore,
			displayInfo:true,
			items:['-', 'Per Page: ', combo],
			displayMsg:'전체 {2}의 결과중 {0} - {1}',
			emptyMsg:"검색 된 결과가 없습니다.",
			listeners:{
				beforechange:function(paging, page, eopts) {},
				change:function(thisd, params) {
					
				}
			}
		});
		
		var grid = new Ext.grid.GridPanel({
			id:ids,
			renderTo:'gridList',
			store:gridStore,
			autoWidth:true,
			width:'100%',
			autoHeight:true,
			overflowY:'scroll',
			autoScroll:true, 
			remoteSort:true,
			cm:cmm,
			loadMask:{
				msg:'로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows:false,
			viewConfig:{
				forceFit:true,
				enableTextSelection:true,
				emptyText:'조회된 데이터가 없습니다.'
			},
			bbar:bbar,
			iconCls:'icon_perlist',
			listeners:{
				cellclick:function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					if(iColIdx != 7) {
						var obj = gridStore.baseParams;
						var searchForm = "";
						for(var key in obj){
							searchForm = searchForm + "," + (key+"|"+obj[key]);
						}
						$("#searchForm").val(searchForm);
						
						var selModel = grid.getSelectionModel();
						var histData = selModel.getSelected();
						var suitid = histData.get("LWS_MNG_NO");
						var caseid = histData.get("INST_MNG_NO");
						goView(suitid, caseid);
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
		
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				pagesize : $("#pagesize").val(),
				MENU_MNG_NO : $("#MENU_MNG_NO").val(),
				suitnm  : $("#suitnm").val(),
				caseNo  : $("#caseNo").val()
			}
		});
		
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val()
			}
		});
		
		$(window).resize(function() {
			gheight = $('body').height()-350;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		});
		
		$("#stxt").keydown(function(key) {
			if (key.keyCode == 13) {
				$('#searchBtn').trigger('click');
			}
		});
		
		$("input:radio[name=schGbn]").click(function(){
			$('#searchBtn').trigger('click');
		});
		
		$("#searchBtn").click(function(){
			gridStore.load({
				params : {
					start : 0,
					limit : $("#pagesize").val(),
					suitnm  : $("#suitnm").val(),
					caseNo  : $("#caseNo").val()
				}
			});
		});
	});
	
	function goView(suitid, caseid){
		document.getElementById("LWS_MNG_NO").value = suitid;
		document.getElementById("INST_MNG_NO").value = caseid;
		document.frm.action="<%=CONTEXTPATH%>/out/lawyerSuitViewPage.do";
		document.frm.submit();
	}
	
	function goReLoad(){
		document.frm.action = "<%=CONTEXTPATH%>/out/outSuitList.do";
		document.frm.submit();
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
					location.href="${pageContext.request.contextPath}/out/outSuitList.do";
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
<script>
	$(document).ready(function(){  //문서가 로딩될때
		
	});
	
	function goReset(){
		
	}
</script>

<form id="test" name="test" method="post" action="" enctype="multipart/form-data">
</form>

<form name="frm" id=frm method="post" action="">
	<input type="hidden" name="LWS_MNG_NO"  id="LWS_MNG_NO"  value="0" />
	<input type="hidden" name="INST_MNG_NO" id="INST_MNG_NO" value="0" />
	<input type="hidden" name="pageno"      id="pageno"      value=""/>
	<input type="hidden" name="searchForm"  id="searchForm"  value=""/>
	<input type="hidden" name="pagesize"    id="pagesize"    value="<%=pageSize%>"/>
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM" id="WRTR_EMP_NM" value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO" id="WRT_DEPT_NO" value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<div class="subCA">
		<strong id="subTT" class="subTT">소송관리</strong>
		<div class="subBtnC right" id="test">
			
		</div>
		<div class="innerB">
			<table class="infoTable write" style="width:100%" id="stxt">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>사건명/사건개요</th>
					<td colspan="3"><input type="text" id="suitNm" name="suitNm" placeholder="최종 심급 기준으로 조회됩니다." style="width:80%" value=""></td>
					<th>사건번호</th>
					<td><input type="text" id="caseNo" name="caseNo" placeholder="최종 심급 기준으로 조회됩니다." style="width:80%"></td>
				</tr>
			</table>
		</div>
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" id="searchBtn">검색</a>
			<a href="#none" class="sBtn type2" onclick="goReset();">초기화</a>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC left">
				<strong class="countT">총 <span id="gcnt">0</span>건</strong>
			</div>
			<div class="subBtnC right">
			</div>
		</div>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</form>