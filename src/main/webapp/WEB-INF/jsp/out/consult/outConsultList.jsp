<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.consult.service.ConsultService"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<%@ page import="com.mten.bylaw.consult.DateUtil"%>
<%

	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();

	
	String writer = request.getAttribute("writer")==null?"":request.getAttribute("writer").toString();
	String writerid = request.getAttribute("writerid")==null?"":request.getAttribute("writerid").toString();
	String deptname = request.getAttribute("deptname")==null?"":request.getAttribute("deptname").toString();
	String deptid = request.getAttribute("deptid")==null?"":request.getAttribute("deptid").toString();
	String Constants = request.getAttribute("Constants")==null?"":request.getAttribute("Constants").toString();
	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
	
	//System.out.println("Constants : " + Constants);
	System.out.println("=====================================>MENU_MNG_NO : " + MENU_MNG_NO);
	
	String inoutcd = ServletRequestUtils.getStringParameter(request, "inoutcd", "");
	System.out.println("=====================================>inoutcd : " + inoutcd);
	String consultcatcd = Constants;
	//String consultcatcd = Constants.Counsel.TYPE_GNLR;
	String schKey = ServletRequestUtils.getStringParameter(request, "schKey", "");
	String schVal = ServletRequestUtils.getStringParameter(request, "schVal", "");
	String sortcd = ServletRequestUtils.getStringParameter(request, "sortcd", "a.consultid desc");
	String consultstatecd = ServletRequestUtils.getStringParameter(request, "consultstatecd", "완료");
	
	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	String sf[] = searchForm.split(",");
	
	/**/
	int pageSize = 20;
	/**/
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	
	String OPENYN = "Y";
	if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("J")>-1) {
		OPENYN = "N";
	}
	
	String lawyernm = WRT_DEPT_NM + " " + WRTR_EMP_NM;
	
	String userAgent = request.getHeader("user-agent");
	boolean mobile1 = userAgent.matches( ".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
	boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*");
%>

<style>
	.sBtn {
		display: inline-block;
		min-width: 0px;
		height: 35px;
		line-height: 35px;
		border-radius: 20px;
		text-align: center;
		font-size: 13px;
		padding: 0 20px;
		margin: 0 1px;
	}
	.x-grid-panel .x-panel-body {
		min-height:300px;
	}
</style>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$(".subSch").css("display", "none");
	});
	
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	var gridStore,grid;
	Ext.onReady(function(){
		var searchYn = "N";
		var gridMinu = 310;
		$("#start").val(0);
		
		<%
		for(int i=0; i<sf.length; i++){
			System.out.println("searchForm===>"+sf[i]);
			String setv[] = sf[i].split("\\|");
			if(setv.length == 2){
		%>
				if ('<%=setv[0]%>' == "start"){
					$("#<%=setv[0]%>").val(parseInt('<%=setv[1]%>'));
				}else{
					$("#<%=setv[0]%>").val('<%=setv[1]%>');
				}
				searchYn ="Y";
		<%
			}
		}
		%>
		
		
		if(searchYn == "Y"){
			gridMinu = 410;
			$(".downBtn").css("display", "none");
			$(".upBtn").css("display", "");
			$(".subSch").css("display", "");
			//gridResize(380);
		}
		
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
// 			{name: 'CNSTN_MNG_NO'},
// 			{name: 'CNSTN_TTL'},
// 			{name: 'CNSTN_DOC_NO'},
// // 			{name: 'CSTTYPECD'},
// // 			{name: 'INPUTTYPE'},
// 			{name: 'OPENYN'},
// 			{name: 'PRGRS_STTS_SE_NM'},
// 			{name: 'CNSTN_RQST_EMP_NM'},
// 			{name: 'CNSTN_RQST_YMD'},
// 			{name: 'CNSTN_TKCG_EMP_NO'},
// 			{name: 'CNSTN_TKCG_EMP_NM'},
// 			{name: 'CNSTN_RCPT_YMD'},//CHRGREGDT
// 			{name: 'CNSTN_RPLY_YMD'},
// 			{name: 'CNSTN_RQST_DEPT_NO'},
// 			{name: 'CNSTN_RQST_DEPT_NM'},
// 			{name: 'INOUTHAN'},
// // 			{name: 'OPINIONCNT'}, // 자문 검토의견 개수?
// // 			{name: 'FULLDEPTCD'},
// 			{name: 'JDAF_CORP_NMS'}, // 법무법인명
// 			{name: 'CNSTN_RQST_EMP_NO'} 
			{name : 'CNSTN_MNG_NO'},
			{name : 'MENU_MNG_NO'},
			{name : 'PRGRS_STTS_SE_NM'},
			{name : 'CNSTN_TTL'},
			{name : 'CNSTN_RQST_DEPT_NO'},
			{name : 'CNSTN_RQST_DEPT_NM'},
			{name : 'CNSTN_RQST_EMP_NO'},
			{name : 'CNSTN_RQST_EMP_NM'},
// 			{name : 'CSTTYPECD'},
// 			{name : 'CSTTYPENM'},
			{name : 'CNSTN_HOPE_RPLY_YMD'},
			{name : 'OPENYN'},
// 			{name : 'CSTSUMRY'},
			{name : 'CNSTN_TKCG_EMP_NO'},
			{name : 'CNSTN_TKCG_EMP_NM'},
			{name : 'INSD_OTSD_TASK_SE'}, // 코드로 받아오게 되면 정해진 용어로 변환해줘야할수도 있음
			{name : 'CNSTN_RPLY_YMD'},
			{name : 'CNSTN_RQST_YMD'},
			{name : 'CNSTN_DOC_NO'},
// 			{name : 'HIT'},
			{name : 'WRT_YMD'}, // 어떤 정보, 무엇을 위한 컬럼인지 여쭤보기
			{name : 'RVW_TKCG_EMP_NM'}
			,{name : 'JDAF_CORP_NMS'}
			,{name : 'CNSTN_RCPT_YMD'}
			,{name : 'RCPT_YN'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"${pageContext.request.contextPath}/out/selectOutConsultList.do"
			}),
			remoteSort:true,
			pagesize : $("#pagesize").val(),
			listeners:{
				load:function(store, records, success) {
					$("#gcnt").text(store.getTotalCount());
					$("#gcnt").number(true);
				}
			},
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'CNSTN_MNG_NO'
			}, myRecordObj)
		});
		
		var combo = new Ext.form.ComboBox({
			name : 'perpage',
			width: 40,
			store: new Ext.data.ArrayStore({
				fields: ['id'],
				data : [
					['20'],
					['50'],
					['100']
				]
			}),
			mode : 'local',
			value: '20',
			listWidth : 40,
			triggerAction : 'all',
			displayField : 'id',
			valueField : 'id',
			editable : false,
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
							pagesize : newPagesize,
						}
					});
				},scope: this
			}
		});
		
		var cmm = new Ext.grid.ColumnModel({
			columns:[
				{header:"<b>자문ID</b>",       dataIndex:'CNSTN_MNG_NO', hidden: true},
// 				{header:"<b>주제분류</b>",     width:10, align:'center', dataIndex:'CSTTYPENM',    sortable: true},
				{header:"<b>관리번호</b>",     align:'center', dataIndex:'CNSTN_DOC_NO',    sortable: true},
				{header:"<b>자문요청제목</b>", align:'left',   dataIndex:'CNSTN_TTL',        sortable: true},
				<%if (!mobile1 && !mobile2) {%>
				{header:"<b>진행상태</b>",     align:'center', dataIndex:'PRGRS_STTS_SE_NM',       sortable: true},
				{header:"<b>요청부서</b>",     align:'center',   dataIndex:'CNSTN_RQST_DEPT_NM', sortable: true},
				{header:"<b>요청자</b>",       align:'center', dataIndex:'CNSTN_RQST_EMP_NM',  sortable: true},
				{header:"<b>검토자</b>",       align:'center', dataIndex:'RVW_TKCG_EMP_NM',    sortable: true},
				<%}%>
// 				{header:"<b>조회수</b>",       width:5,  align:'center', dataIndex:'HIT',          sortable: true},
				{header:"<b>요청일자</b>",     align:'center', dataIndex:'CNSTN_RQST_YMD',        sortable: true},
				<%if (!mobile1 && !mobile2) {%>
				{header:"<b>희망회신일자</b>", align:'center', dataIndex:'CNSTN_HOPE_RPLY_YMD',        sortable: true},
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
		
		grid = new Ext.grid.GridPanel({
			id : ids,
			renderTo : 'gridList',
			store : gridStore,
			autoWidth : true,
			width : '100%',
			autoHeight:true,
			overflowY : 'scroll',
			autoScroll : true,
			remoteSort : true,
			cm : cmm,
			loadMask : {
				msg : '로딩중입니다. 잠시만 기다려주세요...'
			},
			stripeRows : false,
			viewConfig : {
				forceFit : true,
				enableTextSelection : true,
				emptyText : '조회된 데이터가 없습니다.'
			},
			bbar : bbar,
			iconCls : 'icon_perlist',
			listeners : {
				cellclick : function(grid, iCellEl, iColIdx, iStore, iRowEl,iRowIdx, iEvent) {
					
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
					var CNSTN_MNG_NO = histData.get('CNSTN_MNG_NO');
					
					gotoview(CNSTN_MNG_NO);
				},
				contextmenu : function(e) {
					e.preventDefault();
				},
				cellcontextmenu : function(grid, idx, cIdx, e) {
					e.preventDefault();
				}
			}
		});
		
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				start : parseInt($("#start").val()),
				pagesize : $("#pagesize").val(),
				consultcatcd : $("#consultcatcd").val(),
				
				schreqdt1 : $("#schreqdt1").val(),
				schreqdt2 : $("#schreqdt2").val(),
// 				schbasis : $("#schbasis").val(),
				sch_insd_otsd_task_se : $("#sch_insd_otsd_task_se").val(),
				srch_kywd_cn : $("#srch_kywd_cn").val(),
				sch_rqst_dept_nm : $("#sch_rqst_dept_nm").val(),
				sch_rqst_emp_nm : $("#sch_rqst_emp_nm").val(),
				sch_tkcg_emp_nm : $("#sch_tkcg_emp_nm").val(),
				cnstn_ttl : $("#cnstn_ttl").val(),
				schGbn : $('input[name="schGbn"]:checked').val(),
				MENU_MNG_NO : '<%=MENU_MNG_NO%>',
				openyn : '<%=OPENYN%>'
			}
		});
		
		gridStore.load({
			params : {
				start : parseInt($("#start").val()),
				limit : $("#pagesize").val()
			}
		});
		
		function renderDate(value) {
			if (value == '' || value == undefined) {
				return '';
			}else {
				value = $.trim(value);
				if(value.length==10){
					getDate = new Date(value);
				}else{
					y = value.substr(0,4);
					m = value.substr(4,2);
					d = value.substr(6,2);
					console.log(y+"-"+m+"-"+d);
					getDate = new Date(y+"-"+m+"-"+d);
				}
			}
			return Ext.util.Format.date(getDate, 'Y-m-d');
		}
		
		$(window).resize(function() {
			if($(".subSch").css("display") == "none"){
				gridResize(310);
			}else{
				gridResize(410);
			}
		})
		
		$(".upBtn").click(function(){
			$(".downBtn").css("display", "");
			$(".upBtn").css("display", "none");
			$(".subSch").css("display", "none");
			gridResize(310);
			goReset();
		});
		
		$(".downBtn").click(function(){
			$(".downBtn").css("display", "none");
			$(".upBtn").css("display", "");
			$(".subSch").css("display", "");
			gridResize(410);
			goReset();
		});
		
		function gridResize(minus){
			gheight = $('body').height()-minus;
			grid.setHeight(gheight);
			grid.setWidth($('.innerB').width());
		}
	});
	
	/**
	 * 자문의뢰 조회 페이지 이동
	 */
	function gotoview(CNSTN_MNG_NO){
		document.getElementById("consultid").value = CNSTN_MNG_NO;
		document.goList.action="<%=CONTEXTPATH%>/out/outConsultView.do";
		document.goList.submit();
		
	}
	
	function goSch(){
		$("#start").val(0);
		gridStore.load({
			params : {
				start : parseInt($("#start").val()),
				limit : <%=pageSize%>,
				pagesize : <%=pageSize%>,
				MENU_MNG_NO : '<%=MENU_MNG_NO%>',
				schreqdt1 : $("#schreqdt1").val(),
				schreqdt2 : $("#schreqdt2").val(),
				sch_insd_otsd_task_se : $("#sch_insd_otsd_task_se").val(),
				srch_kywd_cn : $("#srch_kywd_cn").val(),
				sch_rqst_dept_nm : $("#sch_rqst_dept_nm").val(),
				sch_rqst_emp_nm : $("#sch_rqst_emp_nm").val(),
				sch_tkcg_emp_nm : $("#sch_tkcg_emp_nm").val(),
				cnstn_ttl : $("#cnstn_ttl").val(),
				schGbn : $('input[name="schGbn"]:checked').val(),
				MENU_MNG_NO : '<%=MENU_MNG_NO%>',
				openyn : '<%=OPENYN%>'
			}
		});
	}
	
	function goReset(){
		$('select').find('option:first').attr('selected', 'selected');
		$("#sch_insd_otsd_task_se").val("");
		$("#schreqdt1").val("");
		$("#schreqdt2").val("");
		$("#srch_kywd_cn").val("");
		$("#sch_rqst_dept_nm").val("");
		$("#sch_rqst_emp_nm").val("");
		$("#sch_tkcg_emp_nm").val("");
		$("#cnstn_ttl").val("");
		
		goSch();
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
					location.href="${pageContext.request.contextPath}/out/outConsultList.do";
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
	
	<form name="goList" method="post">
		<input type="hidden" name="pagesize" id="pagesize" value="<%=pageSize%>" />
		<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>"> 
		<input type="hidden" name="consultid" id="consultid"/>
		<input type="hidden" name="schradio" id="schradio"/>
		<input type="hidden" name="start" id="start" value=""/>
		<input type="hidden" name="searchForm" id="searchForm" value=""/>
		<div class="subCA">
			<strong class="subTT" id="subTT">법률자문</strong>
			<div class="innerB">
				<table class="infoTable write">
					<colgroup>
						<col style="width:10%;">
						<col style="width:23%;">
						<col style="width:10%;">
						<col style="width:23%;">
						<col style="width:10%;">
						<col style="width:24%;">
					</colgroup>
					<tr class="subSch">
						<th>접수일자</th>
						<td>
							<input type="text" id="schreqdt1" name="schreqdt1" style="width:40%;" class="datepick" readonly="readonly"/>
							~
							<input type="text" id="schreqdt2" name="schreqdt2" style="width:40%;" class="datepick" readonly="readonly"/>
						</td>
						<th>자문유형</th>
						<td>
							<select name="sch_insd_otsd_task_se" id="sch_insd_otsd_task_se" style="width:100%;">
								<option value="">전체</option>
								<option value="I">내부검토</option>
								<option value="O">외부자문</option>
							</select>
						</td>
						<th>자문팀 검색 키워드</th>
						<td>
							<input type="text" name="srch_kywd_cn" id="srch_kywd_cn" style="width:100%"/>
						</td>
					</tr>
					<tr class="subSch">
						<th>의뢰부서</th>
						<td>
							<input type="text" name="sch_rqst_dept_nm" id="sch_rqst_dept_nm" style="width:100%"/>
						</td>
						<th>의뢰인</th>
						<td>
							<input type="text" name="sch_rqst_emp_nm" id="sch_rqst_emp_nm" style="width:100%"/>
						</td>
						<th>담당자</th>
						<td>
							<input type="text" name="sch_tkcg_emp_nm" id="sch_tkcg_emp_nm" style="width:100%"/>
						</td>
					</tr>
					<tr>
						<th>자문명</th>
						<td colspan="5">
							<input type="text" id="cnstn_ttl" name="cnstn_ttl" style="width: 90%;">
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
			<div class="innerB">
				<div id="gridList"></div>
			</div>
		</div>
	</form>
</body>