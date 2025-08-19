<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%
	HashMap cInfo = request.getAttribute("cInfo")==null?new HashMap():(HashMap)request.getAttribute("cInfo");
	HashMap costInfo = cInfo.get("costInfo")==null?new HashMap():(HashMap)cInfo.get("costInfo");
	//자문의뢰서 첨부파일
	List fconsultlist = cInfo.get("fconsultlist")==null?new ArrayList():(ArrayList)cInfo.get("fconsultlist");
	
	String MENU_MNG_NO = request.getParameter("MENU_MNG_NO")==null?"":request.getParameter("MENU_MNG_NO").toString();
%>
<script type="text/javascript" src="${resourceUrl}/seoul/js/jquery.number.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	var gridStore,grid;
	Ext.onReady(function(){
		var ids = "hkk4";
		var myRecordObj = Ext.data.Record.create([
			{name: 'CONSULTID'},
	        {name: 'TITLE'},
	        {name: 'CONSULTNO'},
	        {name: 'CSTTYPECD'},
	        {name: 'INPUTTYPE'},
	        {name: 'OPENYN'},
	        {name: 'STATCD'},
	        {name: 'WRITER'},
	        {name: 'WRITEDT'},
	        {name: 'CHRGEMPNO'},
	        {name: 'CHRGEMPNM'},
	        {name: 'CHRGREGDT'},
	        {name: 'SENDDT'},
	        {name: 'WRITERDEPTCD'},
	        {name: 'WRITERDEPTNM'},
	        {name: 'INOUTHAN'},
	        {name: 'OPINIONCNT'},
	        {name: 'FULLDEPTCD'},
	        {name: 'OFFICE'},
	        {name: 'WRITEREMPNO'}
		]);
		
		gridStore = new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"${pageContext.request.contextPath}/web/consult/consultCostListData.do"
			}),
			remoteSort:true,
			pagesize : $("#pagesize").val(),
			listeners:{
				load:function(store, records, success) {
					$("#consultcnt").val(store.getTotalCount());
				}
			},
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'CONSULTID'
			}, myRecordObj)
		});
		
		var cmm = new Ext.grid.ColumnModel({
		
			columns:[
				{header:"<b>자문ID</b>", width:30 , align:'center', dataIndex:'CONSULTID', hidden: true},
				{header:"<b>관리번호</b>", width:20 , align:'center', dataIndex:'CONSULTNO', sortable: true},
				{header:"<b>자문구분</b>", width:15 , align:'center', dataIndex:'CSTTYPECD', sortable: true},
				{header:"<b>자문유형</b>", width:15 , align:'center', dataIndex:'INOUTHAN', sortable: true},
				{header:"<b>제목</b>", width:50, align:'center', dataIndex:'TITLE', sortable: true},
				{header:"<b>의뢰부서</b>", width:20, align:'center', dataIndex:'WRITERDEPTNM', sortable: true},
				{header:"<b>의뢰인</b>", width:20, align:'center', dataIndex:'WRITER', sortable: true},
				{header:"<b>법무법인</b>", width:20, align:'center', dataIndex:'OFFICE', sortable: true},
				{header:"<b>담당자</b>", width:20, align:'center', dataIndex:'CHRGEMPNM', sortable: true},
				{header:"<b>접수일자</b>", width:20, align:'center', dataIndex:'CHRGREGDT', sortable: true},
				{header:"<b>회신일자</b>", width:20, align:'center', dataIndex:'SENDDT', sortable: true},
				{header:"<b>진행상태</b>", width:25, align:'center', dataIndex:'STATCD', sortable: true},	
				{header:"<b>검토의견</b>", width:10, align:'center', dataIndex:'OPINIONCNT', sortable: true}	
			]
		
		});
		
		grid = new Ext.grid.GridPanel({
			id : ids,
			renderTo : 'gridList',
			store : gridStore,
			autoWidth : true,
			width : '100%',
			height : 350,
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
			iconCls : 'icon_perlist',
			listeners : {
				cellclick : function(grid, iCellEl, iColIdx, iStore, iRowEl,iRowIdx, iEvent) {
					
				},
				rowclick:function(grid, idx, e){
					
				},
				contextmenu : function(e) {
					e.preventDefault();
				},
				cellcontextmenu : function(grid, idx, cIdx, e) {
					e.preventDefault();
				}
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
		
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				startdt : '<%=costInfo.get("startdt")==null?"":costInfo.get("startdt")%>',
				enddt : '<%=costInfo.get("enddt")==null?"":costInfo.get("enddt")%>',
				lawfirmid : '<%=costInfo.get("lawfirmid")==null?"":costInfo.get("lawfirmid")%>'
			}
		});
		gridStore.load();
	});
	$(document).ready(function(){
		$("#cost").number(true);
		$("#listbtn").click(function(){
			var frm = document.wform;
			frm.action = "${pageContext.request.contextPath}/web/consult/goConsultCostList.do";
			frm.submit();
		});
		
		$("#deletebtn").click(function(){
			var frm = document.wform;
			frm.action = "${pageContext.request.contextPath}/web/consult/deleteConsultCost.do";
			frm.submit();
		});
		
		$("#editbtn").click(function(){
			var frm = document.wform;
			frm.action = "${pageContext.request.contextPath}/web/consult/goConsultCostWrite.do";
			frm.submit();
		});
	});
	
</script>


<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">자문료지급정보</strong>
		</div>
		<div class="subBtnC right" id="test">
			<a href="#none"class="sBtn type1" id="editbtn">수정</a>
		 	<a href="#none" class="sBtn type1" id="deletebtn">삭제</a>
			<a href="#none"class="sBtn type2" id="listbtn">목록</a>
		</div>
	</div>	
	<div class="innerB" >
		<form name="wform" id="wform" method="post">
		<input type="hidden" name="costid" id="costid" value="<%=costInfo.get("costid")==null?"":costInfo.get("costid")%>"/>
		<input type="hidden" name="filegbn"  value="consult">
		<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>"> 
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width:10%;">
				<col style="width:23%;">
				<col style="width:10%;">
				<col style="width:23%;">
				<col style="width:10%;">
				<col style="width:24%;">
			</colgroup>
			<tr>
				<th>제목</th>
				<td colspan="3">
					<%=costInfo.get("title")==null?"":costInfo.get("title")%>
				</td>
				
				<th>작성자</th>
				<td>
					<%=costInfo.get("writer")==null?"":costInfo.get("writer")%>
				</td>
			</tr>
			<tr>
				<th>법인</th>
				<td>
					<%=costInfo.get("office")==null?"":costInfo.get("office")%>(<%=costInfo.get("consultcnt")==null?"0":costInfo.get("consultcnt")%>건)
				</td>
				<th>자문료산정기간</th>
				<td>
					<%=costInfo.get("startdt")==null?"":costInfo.get("startdt")%> ~ <%=costInfo.get("enddt")==null?"":costInfo.get("enddt")%>
				</td>
				<th>자문료</th>
				<td>
					<span id="cost"><%=costInfo.get("cost")==null?"":costInfo.get("cost")%></span>
				</td>
			</tr>
			<tr>
				<th>은행</th>
				<td>
					<%=costInfo.get("bankname")==null?"":costInfo.get("bankname")%>
				</td>
				<th>계좌번호</th>
				<td>
					<%=costInfo.get("account")==null?"":costInfo.get("account")%>
				</td>
				
				<th>예금주</th>
				<td>
					<%=costInfo.get("accountowner")==null?"":costInfo.get("accountowner")%>
				</td>
			</tr>
			<tr>
				<th>파일첨부</th>
				<td colspan="5">
					<%
						for(int i=0; i<fconsultlist.size(); i++){
							HashMap result = (HashMap)fconsultlist.get(i);
					%>
						<div class="filename" style='width:80%'><%=result.get("VIEWFILENM") %></div>
					<%
						}
					%>
				</td>
			</tr>
		</table>
		</form>
		<hr class="margin20">
		<div class="innerB">
			<div id="gridList"></div>
		</div>
	</div>
</div>
