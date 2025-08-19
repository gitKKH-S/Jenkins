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
	
	List cdList = request.getAttribute("codeList")==null?new ArrayList():(ArrayList) request.getAttribute("codeList");
	List progList = request.getAttribute("progList")==null?new ArrayList():(ArrayList) request.getAttribute("progList");
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
%>
<style>
	p{color:#57b9ba; font-size:15px; font-weight:bold;}
	.x-toolbar-left table {
		width:auto;
	}
</style>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/resources/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	//var gridStore;
	Ext.onReady(function(){
		$('input:radio[name="schGbn"]:radio[value="R"]').prop("checked", true);
		var gMinus = 300;
		<%
		for(int i=0; i<sf.length; i++){
			System.out.println("searchForm===>"+sf[i]);
			String setv[] = sf[i].split("\\|");
			if(setv.length == 2){
			System.out.println("setv[0]===>"+setv[0]);
		%>
				$("#<%=setv[0]%>").val('<%=setv[1]%>');
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
			{name:'LWS_MNG_NO'},
			{name:'INST_MNG_NO'},
			{name:'LWS_NO'},
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
			{name:'LWS_PRGRS_STTS'},
			{name:'OPEN_YN'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectSuitList.do"
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
				select:function(item, newValue){
					console.log("select?");
					console.log(newValue.get('id'));
					
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
				{header:"<b>관리번호</b>",     width:50, align:'center', dataIndex:'LWS_NO',        sortable:true},
				{header:"<b>사건명</b>", width:150, align:'left', dataIndex:'LWS_INCDNT_NM', sortable:true,
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
				{header:"<b>심급</b>",       width:150, align:'center', dataIndex:'INST_NM',        sortable:true},
				{header:"<b>진행상태</b>",   width:50,  align:'center', dataIndex:'LWS_PRGRS_STTS', sortable:true},
				{header:"<b>사건번호</b>",   width:100, align:'center', dataIndex:'INCDNT_NO',      sortable:true},
				
				{header:"<b>소송상대방</b>", width:100, align:'center', dataIndex:'LWS_CNCPR_NM',   sortable:true}
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
					console.log("chg? ");
					console.log(params);
				}
			}
		});
		
		var grid = new Ext.grid.GridPanel({
			id:ids,
			renderTo:'gridList',
			store:gridStore,
			autoWidth:true,
			width:'100%',
			/* height:$('body').height()-gMinus, */
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
					var OPEN_YN = histData.get("OPEN_YN");
					if (OPEN_YN == "Y") {
						goView(suitid, caseid);
					} else {
						return alert("열람권한이 없습니다. 관리자에게 문의하세요.");
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
				pagesize        : $("#pagesize").val(),
				schGbn          : $('input:radio[name="schGbn"]:checked').val(),
				MENU_MNG_NO     : $("#MENU_MNG_NO").val(),
				FLGLW_YMD1      : $("#FLGLW_YMD1").val(),
				FLGLW_YMD2      : $("#FLGLW_YMD2").val(),
				JDGM_ADJ_YMD1   : $("#JDGM_ADJ_YMD1").val(),
				JDGM_ADJ_YMD2   : $("#JDGM_ADJ_YMD2").val(),
				JDGM_CFMTN_YMD1 : $("#JDGM_CFMTN_YMD1").val(),
				JDGM_CFMTN_YMD2 : $("#JDGM_CFMTN_YMD2").val(),
				SPRVSN_DEPT_NM  : $("#SPRVSN_DEPT_NM").val(),
				CT_CD           : $("#CT_CD").val(),
				LWS_CNCPR       : $("#LWS_CNCPR").val(),
				LWS_UP_TYPE_CD  : $("#LWS_UP_TYPE_CD").val(),
				LWS_LWR_TYPE_CD : $("#LWS_LWR_TYPE_CD").val(),
				JDGM_UP_TYPE_CD : $("#JDGM_UP_TYPE_CD").val(),
				PROGRESSCD      : $("#PROGRESSCD").val(),
				INST_CD         : $("#INST_CD").val(),
				LWYR_MNG_NO     : $("#LWYR_MNG_NO").val(),
				LWS_NO          : $("#LWS_NO").val(),
				LWS_INCDNT_NM   : $("#LWS_INCDNT_NM").val(),
				IMPT_LWS_YN     : $("#IMPT_LWS_YN").val(),
				INCDNT_SE_CD    : $("#INCDNT_SE_CD").val(),
				INCDNT_NO       : $("#INCDNT_NO").val()
			}
		});
		
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val()
			}
		});
		
		$(window).resize(function() {
			if($(".subSch").css("display") == "none"){
				gridResize(300);
			}else{
				gridResize(410);
			}
		});
		
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
					schGbn          : $('input:radio[name="schGbn"]:checked').val(),
					FLGLW_YMD1      : $("#FLGLW_YMD1").val(),
					FLGLW_YMD2      : $("#FLGLW_YMD2").val(),
					JDGM_ADJ_YMD1   : $("#JDGM_ADJ_YMD1").val(),
					JDGM_ADJ_YMD2   : $("#JDGM_ADJ_YMD2").val(),
					JDGM_CFMTN_YMD1 : $("#JDGM_CFMTN_YMD1").val(),
					JDGM_CFMTN_YMD2 : $("#JDGM_CFMTN_YMD2").val(),
					SPRVSN_DEPT_NM  : $("#SPRVSN_DEPT_NM").val(),
					CT_CD           : $("#CT_CD").val(),
					LWS_CNCPR       : $("#LWS_CNCPR").val(),
					LWS_UP_TYPE_CD  : $("#LWS_UP_TYPE_CD").val(),
					LWS_LWR_TYPE_CD : $("#LWS_LWR_TYPE_CD").val(),
					JDGM_UP_TYPE_CD : $("#JDGM_UP_TYPE_CD").val(),
					PROGRESSCD      : $("#PROGRESSCD").val(),
					INST_CD         : $("#INST_CD").val(),
					LWYR_MNG_NO     : $("#LWYR_MNG_NO").val(),
					LWS_NO          : $("#LWS_NO").val(),
					LWS_INCDNT_NM   : $("#LWS_INCDNT_NM").val(),
					INCDNT_NO       : $("#INCDNT_NO").val()
				}
			});
		});
		
		function gridResize(minus) {
			gheight = $('body').height()-minus;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		}
	});
	
	function goView(suitid, caseid){
		document.getElementById("LWS_MNG_NO").value = suitid;
		document.getElementById("SEL_INST_MNG_NO").value = caseid;
		document.frm.action="<%=CONTEXTPATH%>/web/suit/suitViewPage.do";
		document.frm.submit();
	}
	
	function goReLoad(){
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/goSuitList.do";
		document.frm.submit();
	}
	
	function goWritePage(){
		var obj = gridStore.baseParams;
		var searchForm = "";
		for(var key in obj){
			searchForm = searchForm + "," + (key+"|"+obj[key]);
		}
		$("#searchForm").val(searchForm);
		document.frm.action="<%=CONTEXTPATH%>/web/suit/suitWritePage.do";
		document.frm.submit();
	}
</script>
<script>
	$(document).ready(function(){  //문서가 로딩될때
		$(".subSch").css("display", "none");
	});
	
	function goReset(){
		$('select').find('option:first').attr('selected', 'selected');
		$(":text").val("");
		$(":hidden").val("");
	}
	
	function excelDownload(){
		document.frm.action = "<%=CONTEXTPATH%>/web/suit/suitExcelDownload.do";
		document.frm.submit();
	}
	
	
	function goMsg() {
		$.ajax({
			type : "POST",
			url : "<%=CONTEXTPATH %>/web/testMsg.do",
			success : function(data) { }
		});
	}
	
	function goSms() {
		$.ajax({
			type : "POST",
			url : "<%=CONTEXTPATH %>/web/testSmS.do",
			success : function(data) { }
		});
	}
	
	function goBugaTest() {
		$.ajax({
			type : "POST",
			url : "<%=CONTEXTPATH %>/web/suit/callBugaTest.do",
			success : function(data) { }
		});
	}
	
	function chgUpTypeCd (uptypecd) {
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectLwsLwrTypeCdList.do",
			data: {type:uptypecd},
			dataType:"json",
			async:false,
			success:setOptionList
		});
	}
	
	function setOptionList(data){
		$("#LWS_LWR_TYPE_CD").children('option').remove();
		var html="";
		
		if(data.result.length > 0){
			html += "<option value=''>선택</option>";
			$.each(data.result, function(index, val){
				if(LWS_LWR_TYPE_CD == val.CD_MNG_NO){
					html += "<option value='"+val.CD_MNG_NO+"' selected>"+val.CD_NM+"</option>";
				}else{
					html += "<option value='"+val.CD_MNG_NO+"'>"+val.CD_NM+"</option>";
				}
			});
		}
		
		$("#LWS_LWR_TYPE_CD").append(html);
	}
	
	function goSearchCourt(){
		var cw=500;
		var ch=700;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","courtSearch",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "courtSearch");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchCourtPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}

	function goSearchLawyer(){
		var cw=500;
		var ch=700;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","lawyerpop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "lawyerpop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchLawyerPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
</script>

<form id="test" name="test" method="post" action="" enctype="multipart/form-data">
</form>

<form name="frm" id=frm method="post" action="">
	<input type="hidden" name="LWS_MNG_NO"      id="LWS_MNG_NO"      value="" />
	<input type="hidden" name="INST_MNG_NO"     id="INST_MNG_NO"     value="" />
	<input type="hidden" name="SEL_INST_MNG_NO" id="SEL_INST_MNG_NO" value="" />
	<input type="hidden" name="pageno"          id="pageno"          value=""/>
	<input type="hidden" name="searchForm"      id="searchForm"      value=""/>
	<input type="hidden" name="pagesize"        id="pagesize"        value="<%=pageSize%>"/>
	<input type="hidden" name="grpcd"           id="grpcd"           value="<%=GRPCD%>"/>
	<input type="hidden" name="MENU_MNG_NO"     id="MENU_MNG_NO"     value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM"     id="WRTR_EMP_NM"     value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"     id="WRTR_EMP_NO"     value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"     id="WRT_DEPT_NO"     value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"     id="WRT_DEPT_NM"     value="<%=WRT_DEPT_NM%>" />
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
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
				<tr class="subSch">
					<th>소제기일</th>
					<td>
						<input type="text" class="datepick" style="width:80px;" id="FLGLW_YMD1" name="FLGLW_YMD1"> ~
						<input type="text" class="datepick" style="width:80px;" id="FLGLW_YMD2" name="FLGLW_YMD2">
					</td>
					<th>판결선고일</th>
					<td>
						<input type="text" class="datepick" style="width:80px;" id="JDGM_ADJ_YMD1" name="JDGM_ADJ_YMD1"> ~
						<input type="text" class="datepick" style="width:80px;" id="JDGM_ADJ_YMD2" name="JDGM_ADJ_YMD2">
					</td>
					<th>판결확정일</th>
					<td>
						<input type="text" class="datepick" style="width:80px;" id="JDGM_CFMTN_YMD1" name="JDGM_CFMTN_YMD1"> ~
						<input type="text" class="datepick" style="width:80px;" id="JDGM_CFMTN_YMD2" name="JDGM_CFMTN_YMD2">
					</td>
				</tr>
				<tr class="subSch">
					<th>주관부서</th>
					<td><input type="text" id="SPRVSN_DEPT_NM" name="SPRVSN_DEPT_NM" style="width:80%" value=""></td>
					<th>관할법원</th>
					<td>
						<input type="hidden" name="CT_CD" id="CT_CD" value="">
						<input type="text"   name="CT_NM" id="CT_NM" value="" onclick="goSearchCourt()" style="width:70%;">
						<a href="#none" onclick="goSearchCourt()" class="innerBtn">검색</a>
					</td>
					<th>소송당사자</th>
					<td><input type="text" id="LWS_CNCPR" name="LWS_CNCPR" style="width:80%" value=""></td>
				</tr>
				<tr class="subSch">
					<th>소송유형</th>
					<td>
						<select name="LWS_UP_TYPE_CD" id="LWS_UP_TYPE_CD" onchange="chgUpTypeCd(this.value);">
							<option value="">선택</option>
<%
						for(int i=0; i<cdList.size(); i++) {
							HashMap map = (HashMap) cdList.get(i);
							if ("LWSTYPECD".equals(map.get("CD_LCLSF_ENG_NM"))){
								out.println("<option value='"+map.get("CD_MNG_NO").toString()+"'>"+map.get("CD_NM").toString()+"</option>");
							}
						}
%>
						</select>
						<select name="LWS_LWR_TYPE_CD" id="LWS_LWR_TYPE_CD">
							<option value="">선택</option>
						</select>
					</td>
					<th>판결분류</th>
					<td>
						<select name="JDGM_UP_TYPE_CD" id="JDGM_UP_TYPE_CD">
							<option value="">선택</option>
						<%
							for(int i=0; i<cdList.size(); i++) {
								HashMap map = (HashMap) cdList.get(i);
								if ("JDGMTGBN".equals(map.get("CD_LCLSF_ENG_NM"))){
									out.println("<option value='"+map.get("CD_MNG_NO").toString()+"'>"+map.get("CD_NM").toString()+"</option>");
								}
							}
						%>
						</select>
					</td>
					<th>진행상태</th>
					<td>
						<select name="PROGRESSCD" id="PROGRESSCD">
							<option value="">선택</option>
						<%
							for(int i=0; i<progList.size(); i++) {
								HashMap map = (HashMap) progList.get(i);
								out.println("<option value='"+map.get("CD_MNG_NO").toString()+"'>"+map.get("CD_NM").toString()+"</option>");
							}
						%>
						</select>
					</td>
				</tr>
				<tr class="subSch">
					<th>최종심급</th>
					<td>
						<select name="INST_CD" id="INST_CD">
							<option value="">선택</option>
						<%
							for(int i=0; i<cdList.size(); i++) {
								HashMap map = (HashMap) cdList.get(i);
								if ("CASECD".equals(map.get("CD_LCLSF_ENG_NM"))){
									out.println("<option value='"+map.get("CD_MNG_NO").toString()+"'>"+map.get("CD_NM").toString()+"</option>");
								}
							}
						%>
						</select>
					</td>
					<th>대리인</th>
					<td>
						<input type="hidden" id="LWYR_MNG_NO" name="LWYR_MNG_NO" value=""/>
						<input type="text" id="LWYR_NM" name="LWYR_NM" value="" readonly="readonly" onclick="goSearchLawyer()" style="width:70%"/>
						<a href="#none" class="innerBtn" id="lawBtn" onclick="goSearchLawyer()">조회</a>
					</td>
					<th>사건구분</th>
					<td>
						<select name="INCDNT_SE_CD" id="INCDNT_SE_CD">
							<option value="">전체</option>
							<option value="A">일반사건</option>
<!-- 							<option value="B">주요소송</option> -->
							<option value="B">중요소송</option>
							<option value="C">특별관리소송</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>관리번호</th>
					<td><input type="text" id="LWS_NO" name="LWS_NO" style="width:80%" value=""></td>
					<th>사건정보</th>
					<td><input type="text" id="LWS_INCDNT_NM" name="LWS_INCDNT_NM" placeholder="최종 심급 기준으로 조회됩니다." style="width:80%" value=""></td>
					<th>사건번호</th>
					<td>
						<input type="text" id="INCDNT_NO" name="INCDNT_NO" placeholder="최종 심급 기준으로 조회됩니다." style="width:80%">
						<a href="#none" class="upBtn" title="접기" style="display:none"></a>
						<a href="#none" class="downBtn" title="펼치기"></a>
					</td>
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
				<input type="radio" name="schGbn" id="schGbn0" value=""><label>전체</label>
				<input type="radio" name="schGbn" id="schGbn1" value="R"><label>진행중</label>
				<input type="radio" name="schGbn" id="schGbn2" value="E"><label>종결</label>
				<input type="radio" name="schGbn" id="schGbn3" value="M"><label>나의사건</label>
				<input type="radio" name="schGbn" id="schGbn4" value="S"><label>민사</label>
				<input type="radio" name="schGbn" id="schGbn5" value="H"><label>행정</label>
			</div>
			<div class="subBtnC right">
			<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1 || GRPCD.indexOf("B") > -1 || GRPCD.indexOf("G") > -1) {%>
				<a href="#none" class="sBtn type1" onclick="goWritePage();">등록</a>
				<a href="#none" class="sBtn type2" onclick="excelDownload();">리스트저장</a>
				<a href="#none" class="sBtn type2" onclick="goSms();">TEST1</a>
			<%}%>
			</div>
		</div>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</form>