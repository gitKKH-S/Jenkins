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
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
	
	List cdList = request.getAttribute("cdList")==null?new ArrayList():(ArrayList) request.getAttribute("cdList");
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<style>
	#ext-gen12{min-height:100px;}
</style>
<script>
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		$('input:radio[name="schGbn"]:radio[value="Y"]').prop("checked", true);
		$(".subSch").css("display", "none");
		
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
				<%
				if (!setv[0].equals("pagesize") && !setv[0].equals("MENU_MNG_NO")) {
				%>
				$(".downBtn").css("display", "none");
				$(".upBtn").css("display", "");
				$(".subSch").css("display", "");
				<%
				}
				%>
			}
		<%
			}
		}
		%>
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name:'LWYR_MNG_NO'},
			{name:'JDAF_CORP_MNG_NO'},
			{name:'LWYR_NM'},
			{name:'JDAF_CORP_NM'},
			{name:'LGN_LCK_YN'},
			{name:'BRDT'},
			{name:'GNDR_SE'},
			{name:'ACBG_CN'},
			{name:'TEST_INFO'},
			{name:'FRST_YMD'},
			{name:'NOW_YMD'},
			{name:'LST_YMD'},
			{name:'TNR_CNT'},
			{name:'MBL_TELNO'},
			{name:'CRR_MTTR'},
			{name:'LWYR_CTRT_STTS_NM'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"<%=CONTEXTPATH %>/web/suit/selectLawyerList.do"
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
				root:'result', totalProperty:'total', idProperty:'LWYR_MNG_NO'
			}, myRecordObj),
			pageSize:10
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"변호사ID",            dataIndex:'LWYR_MNG_NO',      hidden:true},
				{header:"법무법인ID",          dataIndex:'JDAF_CORP_MNG_NO', hidden:true},
				{header:"<b>이름</b>",            width:5,  align:'center', dataIndex:'LWYR_NM',       sortable:true},
				{header:"<b>소속</b>",            width:10, align:'center', dataIndex:'JDAF_CORP_NM',  sortable:true},
				<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("I") > -1){%>
				{header:"<b>계정잠김여부</b>",    width:5,  align:'center', dataIndex:'LGN_LCK_YN',    sortable:true},
				{header:"<b>출생연도</b>",        width:5,  align:'center', dataIndex:'BRDT',          sortable:true},
				{header:"<b>성별</b>",            width:5,  align:'center', dataIndex:'GNDR_SE',       sortable:true},
				{header:"<b>학력</b>",            width:10, align:'center', dataIndex:'ACBG_CN',       sortable:true},
				<%}%>
				{header:"<b>합격연도(회수)</b>",  width:10, align:'center', dataIndex:'TEST_INFO',     sortable:true},
				{header:"<b>주요경력</b>",        width:10, align:'center', dataIndex:'CRR_MTTR',      sortable:true},
				{header:"<b>최초위촉일</b>",      width:5,  align:'center', dataIndex:'FRST_YMD',      sortable:true},
				{header:"<b>최근위촉일</b>",      width:5,  align:'center', dataIndex:'NOW_YMD',       sortable:true},
				{header:"<b>임기만료일</b>",      width:5,  align:'center', dataIndex:'LST_YMD',       sortable:true},
				{header:"<b>위촉회차</b>",        width:5,  align:'center', dataIndex:'TNR_CNT',       sortable:true},
				{header:"<b>전화번호</b>",        width:5,  align:'center', dataIndex:'MBL_TELNO',     sortable:true}
			],
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
		
		var bbar = new Ext.PagingToolbar({
			pagesize : $("#pagesize").val(),
			autoWidth : true,
			store : gridStore,
			displayInfo : true,
			items : [ '-', 'Per Page: ', combo ],
			displayMsg : '전체 {2}의 결과중 {0} - {1}',
			emptyMsg : "검색된 결과가 없습니다.",
			listeners : {
				beforechange : function(paging, page, eopts) { },
				change : function(thisd, params) { }
			}
		});
		
		var grid = new Ext.grid.GridPanel({
			id:ids,
			renderTo:'gridList',
			store:gridStore,
			autoWidth:true,
			width:'100%',
			autoHeight:true,
			minHeight:150,
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
					var getid = histData.data.LWYR_MNG_NO;
					goView(getid);
				},
				contextmenu:function(e) {
					e.preventDefault();
				},
				cellcontextmenu:function(grid, idx, cIdx, e) {
					e.preventDefault();
				}
			}
		});
		
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				pagesize           : $("#pagesize").val(),
				MENU_MNG_NO        : $("#MENU_MNG_NO").val(),
				LWYR_NM            : $("#LWYR_NM").val(),
				JDAF_CORP_NM       : $("#JDAF_CORP_NM").val(),
				schGbn             : $('input:radio[name="schGbn"]:checked').val(),
				LGN_LCK_YN         : $("#LGN_LCK_YN").val(),
				TNR_CNT            : $("#TNR_CNT").val(),
				TERM_DT            : $("#TERM_DT").val(),
				CRR_MTTR           : $("#CRR_MTTR").val(),
				ARSP_NM            : $("#ARSP_NM").val(),
				SPC_FLD_NM         : $("#SPC_FLD_NM").val(),
				LWYR_INTL_CNSTN_CN : $("#LWYR_INTL_CNSTN_CN").val(),
				LWYR_IPR_CNSTN_CN  : $("#LWYR_IPR_CNSTN_CN").val(),
				ENDTERM            : $("#ENDTERM").val()
			}
		});
		gridStore.load({
			params : {
				start : 0,
				limit : $("#pagesize").val()
			}
		});
		
		$(window).resize(function() {
			gheight = $('body').height()-300;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		});
		
		$(".upBtn").click(function(){
			$(".downBtn").css("display", "");
			$(".upBtn").css("display", "none");
			$(".subSch").css("display", "none");
			goReset();
		});
		
		$(".downBtn").click(function(){
			$(".downBtn").css("display", "none");
			$(".upBtn").css("display", "");
			$(".subSch").css("display", "");
		});
		
		$("#stxt").keydown(function(key) {
			if (key.keyCode == 13) {
				goSch();
			}
		});
		
		$("input:radio[name=schGbn]").click(function(){
			goSch();
		});
		
		$("#searchBtn").click(function(){
			goSch();
		});
	});
	
	function goView(data){
		document.getElementById("LWYR_MNG_NO").value = data;
		document.frm.action="<%=CONTEXTPATH%>/web/suit/lawyerViewPage.do";
		document.frm.submit();
	}
	
	function goWritePage(){
		var obj = gridStore.baseParams;
		var searchForm = "";
		for(var key in obj){
			searchForm = searchForm + "," + (key+"|"+obj[key]);
		}
		$("#searchForm").val(searchForm);
		document.frm.action="<%=CONTEXTPATH%>/web/suit/lawyerWritePage.do";
		document.frm.submit();
	}
	
	function goLawfirmList(){
		document.getElementById("MENU_MNG_NO").value = "10000016";
		document.frm.action="<%=CONTEXTPATH%>/web/suit/goLawfirmList.do";
		document.frm.submit();
	}
	
	function goSch(){
		gridStore.on('beforeload', function(){
			gridStore.baseParams = {
				start : 0,
				limit : <%=pageSize%>,
				pagesize : <%=pageSize%>,
				LWYR_NM            : $("#LWYR_NM").val(),
				JDAF_CORP_NM       : $("#JDAF_CORP_NM").val(),
				schGbn             : $('input:radio[name="schGbn"]:checked').val(),
				LGN_LCK_YN         : $("#LGN_LCK_YN").val(),
				TNR_CNT            : $("#TNR_CNT").val(),
				TERM_DT            : $("#TERM_DT").val(),
				CRR_MTTR           : $("#CRR_MTTR").val(),
				ARSP_NM            : $("#ARSP_NM").val(),
				SPC_FLD_NM         : $("#SPC_FLD_NM").val(),
				LWYR_INTL_CNSTN_CN : $("#LWYR_INTL_CNSTN_CN").val(),
				LWYR_IPR_CNSTN_CN  : $("#LWYR_IPR_CNSTN_CN").val(),
				ENDTERM            : $("#ENDTERM").val()
			}
		});
		gridStore.load();
	}
	
	function goSearchLawfirm(){
		var url = '<%=CONTEXTPATH%>/web/suit/searchLawfirmPop.do';
		var wth = "500";
		var hht = "700";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	
	function goReset(){
		$('select').find('option:first').attr('selected', 'selected');
		$(":text").val("");
		$(":hidden").val("");
	}
	
	function lawyerListDownload() {
		var url = "${pageContext.request.contextPath}/web/suit/lawyerListExcel.do";
		var obj = gridStore.baseParams;
		var inputs = '';
		for(var key in obj) {
			if(key!='pagesize'){
				inputs+='<input type="hidden" name="'+ key +'" value="'+ obj[key] +'" />';
			}
		}
		inputs+='<input type="hidden" name="pagesize" value="10000000" />';
		inputs+='<input type="hidden" name="pageno" value="1" />';
		
		if(gridStore.getSortState()){
			inputs+='<input type="hidden" name="sort" value="'+ gridStore.getSortState().field +'" />';
			inputs+='<input type="hidden" name="dir" value="'+ gridStore.getSortState().direction +'" />';
		}
		
		jQuery('<form action="'+ url +'" method="POST">'+inputs+'</form>').appendTo('.subTT').submit().remove();
	}
</script>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="pageno"       id="pageno"       value=""/>
	<input type="hidden" name=LWYR_MNG_NO    id="LWYR_MNG_NO"  value=""/>
	<input type="hidden" name="pagesize"     id="pagesize"     value="<%=pageSize%>"/>
	<input type="hidden" name="MENU_MNG_NO"  id="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM"  id="WRTR_EMP_NM"  value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"  id="WRTR_EMP_NO"  value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"  id="WRT_DEPT_NO"  value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"  id="WRT_DEPT_NM"  value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="searchForm"   id="searchForm"   value=""/>
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="innerB">
			<table class="infoTable" style="width:100%" id="stxt">
				<colgroup>
					<col style="width:8%;">
					<col style="width:*;">
					<col style="width:8%;">
					<col style="width:*;">
					<col style="width:8%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:8%;">
					<col style="width:*;">
				</colgroup>
				<tr class="subSch">
					<th>계정잠김여부</th>
					<td>
						<select name="LGN_LCK_YN" id="LGN_LCK_YN" style="width:100%">
							<option value="">전체</option>
							<option value="N">N</option>
							<option value="Y">Y</option>
						</select>
					</td>
					<th>위촉회차</th>
					<td>
						<input type="text" id="TNR_CNT" name ="TNR_CNT" style="width:100%">
					</td>
					<th>재임기간</th>
					<td>
						<input type="text" id="TERM_DT" name ="TERM_DT" style="width:100%">
					</td>
					<th>연나이</th>
					<td>
						<input type="text" id="BRDT" name ="BRDT" style="width:100%">
					</td>
					<th>주요경력</th>
					<td>
						<input type="text" id="CRR_MTTR" name ="CRR_MTTR" style="width:100%">
					</td>
				</tr>
				<tr class="subSch">
					<th>전문분야</th>
					<td>
						<select name="ARSP_NM" id="ARSP_NM" style="width:100%">
							<option value="">선택</option>
<%
					for(int i=0; i<cdList.size(); i++) {
						HashMap map = (HashMap) cdList.get(i);
						if ("ARSP_NM".equals(map.get("CD_LCLSF_ENG_NM"))){
							out.println("<option value='"+map.get("CD_MNG_NO").toString()+"'>"+map.get("CD_NM").toString()+"</option>");
						}
					}
%>
						</select>
					</td>
					<th>특별분야</th>
					<td>
						<select name="SPC_FLD_NM" id="SPC_FLD_NM">
							<option value="">선택</option>
<%
					for(int i=0; i<cdList.size(); i++) {
						HashMap map = (HashMap) cdList.get(i);
						if ("SPC_FLD_NM".equals(map.get("CD_LCLSF_ENG_NM"))){
							out.println("<option value='"+map.get("CD_MNG_NO").toString()+"'>"+map.get("CD_NM").toString()+"</option>");
						}
					}
%>
						</select>
					</td>
					<th>국제법률자문</th>
					<td>
						<input type="text" id="LWYR_INTL_CNSTN_CN" name ="LWYR_INTL_CNSTN_CN" style="width:100%">
					</td>
					<th>지적재산권법률자문</th>
					<td>
						<input type="text" id="LWYR_IPR_CNSTN_CN" name ="LWYR_IPR_CNSTN_CN" style="width:100%">
					</td>
					<th>임기만료예정일</th>
					<td>
						<select name="ENDTERM" id="ENDTERM">
							<option value="">전체</option>
							<option value="15">15일 이내</option>
							<option value="30">30일 이내</option>
							<option value="60">60일 이내</option>
							<option value="90">90일 이내</option>
							<option value="120">120일 이내</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>소속</th>
					<td colspan="3">
						<input type="text" id="JDAF_CORP_NM" name ="JDAF_CORP_NM" style="width:100%">
					</td>
					<th>이름</th>
					<td colspan="5">
						<input type="text" id="LWYR_NM" name="LWYR_NM" style="width:80%">
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
				<input type="radio" name="schGbn" id="schGbn1" value="Y"><label>임기중</label>
				<input type="radio" name="schGbn" id="schGbn2" value="N"><label>해촉</label>
				<input type="radio" name="schGbn" id="schGbn3" value="A"><label>해촉(사임)</label>
			</div>
			<div class="subBtnC right">
				<a href="#none" class="sBtn type2" onclick="lawyerListDownload();">리스트저장</a>
				<a href="#none" class="sBtn type2" onclick="goLawfirmList();">법무법인관리</a>
				<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("I") > -1){%>
				<a href="#none" class="sBtn type1" onclick="goWritePage();">등록</a>
				<%}%>
			</div>
		</div>
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</form>