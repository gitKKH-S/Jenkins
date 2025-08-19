<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
	String deptsenginname = request.getAttribute("deptsenginname")==null?"":request.getAttribute("deptsenginname").toString();
	String consultstatecd = request.getAttribute("consultstatecd")==null?"":request.getAttribute("consultstatecd").toString();
	String dept = request.getAttribute("dept")==null?"":request.getAttribute("dept").toString();
	String jilmunsabun = request.getAttribute("jilmunsabun")==null?"":request.getAttribute("jilmunsabun").toString();
	String jilmunname = request.getAttribute("jilmunname")==null?"":request.getAttribute("jilmunname").toString();
	String gradedetail = request.getAttribute("gradedetail")==null?"":request.getAttribute("gradedetail").toString();
	String phone = request.getAttribute("phone")==null?"":request.getAttribute("phone").toString();
	String hopedt = request.getAttribute("hopedt")==null?"":request.getAttribute("hopedt").toString();
	String email = request.getAttribute("email")==null?"":request.getAttribute("email").toString();
	String balsindt = request.getAttribute("balsindt")==null?"":request.getAttribute("balsindt").toString();String suitnm = request.getAttribute("suitnm")==null?"":request.getAttribute("suitnm").toString();
	String title = request.getAttribute("title")==null?"":request.getAttribute("title").toString();
	String sasilkoreo = request.getAttribute("sasilkoreo")==null?"":request.getAttribute("sasilkoreo").toString();
	String yoji = request.getAttribute("yoji")==null?"":request.getAttribute("yoji").toString();
	String deptview = request.getAttribute("deptview")==null?"":request.getAttribute("deptview").toString();
	String bubname = request.getAttribute("bubname")==null?"":request.getAttribute("bubname").toString();
	String inoutcd = request.getAttribute("inoutcd")==null?"":request.getAttribute("inoutcd").toString();
	
	String consultcatcd = request.getAttribute("consultcatcd")==null?"":request.getAttribute("consultcatcd").toString();
	String Grpcd = request.getAttribute("Grpcd")==null?"":request.getAttribute("Grpcd").toString();
	
	String writer = request.getAttribute("writer")==null?"":(String)request.getAttribute("writer");
	String writerid = request.getAttribute("writerid")==null?"":(String)request.getAttribute("writerid");
	String deptname = request.getAttribute("deptname")==null?"":(String)request.getAttribute("deptname");
	String deptid = request.getAttribute("deptid")==null?"":(String)request.getAttribute("deptid");
	String MENU_MNG_NO   = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();
	
	//의견서

	//int suitid = ServletRequestUtils.getIntParameter(request, "suitid", 0);
	String selectedConsultansId = request.getAttribute("selectedConsultansId")==null?"":request.getAttribute("selectedConsultansId").toString();
	
	String consultansid    = request.getAttribute("consultansid")==null?"":(String)request.getAttribute("consultansid");
	String refconsultid    = request.getAttribute("refconsultid")==null?"":(String)request.getAttribute("refconsultid");
	
	//System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>consultansid:"+consultansid + ">>>>>>>>>>>>>>>>refconsultid:"+refconsultid);
	
	//fList
	List<Map<String, Object>> list = (List)request.getAttribute("fList");
	
	//System.out.println("list:"+list.size());
	
	
	

%>
<style>
.infoTable.write th {
	background: #d6d9dc;
}

</style>
<script type="text/javascript">
$(document).ready(function(){
	$('.wrap').on('keyup', 'textarea', function (e) {
		$(this).css('height', 'auto');
		$(this).height(this.scrollHeight);
	});
	$('.wrap').find('textarea').keyup();
});


/**
 * 자문의뢰신청서 페이지 이동
 */
function go2Write() {
    var frm = document.detailFrm;
    frm.action = "<%=CONTEXTPATH%>/web/consult/consultWritePage.do";
    frm.submit();
}



	
</script>



<!-- 의견서 -->
<script type="text/javascript">
	var consultid = <%=consultid%>;
	
	Ext.BLANK_IMAGE_URL = "<%=CONTEXTPATH %>/resources/extjs/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		wwidth = $(".subTTW").width();
		var myRecordObj = Ext.data.Record.create([
			{name:'CONSULTANSID'},
			{name:'CONSULTID'},
			{name:'REFCONSULTID'},
			{name:'TITLE'},
			{name:'SASILYOJI'},
			{name:'BUBVIEW'},
			{name:'BUBMUSENGINSABUN'},
			{name:'BUBMUSENGINNAME'},
			{name:'EMAILSUSINDT'},
			{name:'HOISINDT'},
			{name:'BUBLAWYERID'},
			{name:'BIZ_KEY'},
			{name:'APRV_STATUS'},
			{name:'DOC_ID'},
			{name:'BANREASON'},
			{name:'OPENYN'},
			{name:'WRITERID'},
			{name:'WRITER'},
			{name:'DEPTID'},
			{name:'DEPTNAME'},
			{name:'DEPT'}
		]);
		
		var gridStore = new Ext.data.Store({
			baseParams : {
				consultid : consultid
			},
			proxy:new Ext.data.HttpProxy({ //url 수정 
				url:"<%=CONTEXTPATH %>/web/consult/selectConsultansList.do" 
			}),
			reader:new Ext.data.JsonReader({
				root:'result', totalProperty:'total', idProperty:'consultansid'
			}, myRecordObj)
		
		});
		
		var cmm = new Ext.grid.ColumnModel({ 
			columns:[
				{header:"<b>CONSULTANSID</b>", width:0, align:'center', dataIndex:'CONSULTANSID', hidden:true},
				{header:"<b>CONSULTID</b>", width:90, align:'center',dataIndex:'CONSULTID', hidden:true},
				{header:"<b>REFCONSULTID</b>", width:90, align:'center',dataIndex:'REFCONSULTID', hidden:true},
				{header:"<b></b>", width:20, align:'center', dataIndex:'ROWNUMBER'},
				{header:"<b>자문명</b>", width:200, align:'center',dataIndex:'TITLE', sortable:true},
				{header:"<b>회신일</b>", width:90, align:'center', dataIndex:'HOISINDT', sortable:true},
				{header:"<b>담당자</b>", width:90, align:'center', dataIndex:'BUBMUSENGINNAME', sortable:true}
			
			]
		});
		
		var grid = new Ext.grid.GridPanel({
			id:'hkk4',
			renderTo:'consultansGrid',
			store:gridStore,
			width:'100%',
			autoWidth:true,
			autoHeight:true,
			overflowY:'scroll',
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
				emptyText:'자문의견서를 등록하세요.'
			},
			iconCls:'icon_perlist',
			listeners:{
				cellclick: function(grid, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
					if(iColIdx != 9){
						var selModel = grid.getSelectionModel();
						var histData = selModel.getSelected();
						var consultansId = histData.data.CONSULTANSID;
						//var consultId = histData.data.CONSULTID;
						console.log("======>consultansId:"+consultansId);
						goConsultansViewPage(consultansId);
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
				consultid: consultid
			}
		});
		
		gridStore.load();
		
		try{
			setGrid();
		}catch(e){}
	});
</script>
<script type="text/javascript">

	
	function goConsultansViewPage(consultansId) {
		//console.log("consultansid:"+encodeURI(consultansId));
		var url = '<%=CONTEXTPATH%>/web/consult/consultansViewPage.do?consultansid='+consultansId;
		var wth = "980";
		var hht = "830";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	

	

	
	
	

	
	function suitRoleEdit(){
		var suitid = $("#suitid").val();
		var url = '<%=CONTEXTPATH%>/web/suit/roleSettingPop.do?suitid='+suitid;
		var wth = "800";
		var hht = "500";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	
	

	
	
	
	function goListPage(){
		history.back();
	}
	
	
	function goEdit(){
		document.frm.action="<%=CONTEXTPATH%>/web/consult/consultWritePage.do";
		document.frm.submit();
	}
	
	function goConsultansWritePage(consultid) {
		
		document.getElementById("consultid").value = consultid;
		console.log("consultid:"+consultid)
		document.frm.action = "${pageContext.request.contextPath}/web/consult/consultansWritePage.do";
		document.frm.submit();
		
	}
	
	function banReasonViewPop() {
		var consultid = $("#consultid").val();
		var url = '<%=CONTEXTPATH%>/web/consult/banReasonViewPop.do?consultid='+consultid;
		var wth = "800";
		var hht = "400";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	
	function banReasonWritePop() {
		var consultid = $("#consultid").val();
		var url = '<%=CONTEXTPATH%>/web/consult/banReasonWritePop.do?consultid='+consultid;
		var wth = "800";
		var hht = "400";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	
	

	function consultStatechg() {
		var confirm_test = confirm("재승인요청");
		if(confirm_test == true){
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/consultStatechg.do",
			//data:$('#goList').serializeArray(), 
			data:{"consultid":document.getElementById("consultid").value, "consultstatecd":"등록"},
			dataType:"json",
			async:false,
			success:function(result){
				if(result.data.msg == 'ok'){
					alert(obj.value+"저장이 완료되었습니다.");
					//alert("저장이 완료되었습니다.");
					location.href = "<%=CONTEXTPATH%>/web/consult/goConsultList.do";
					//goListPage();
				}
			}
		});
		
	} else if (confirm_test == false) {
		return;
	}	
}
	
	
	
	function consultRoleEdit(){
		var consultid = $("#consultid").val();
		var url = '<%=CONTEXTPATH%>/web/consult/roleSettingPop.do?consultid='+consultid;
		var wth = "800";
		var hht = "900";
		var pnm = "newEdit";
		popOpen(pnm,url,wth,hht);
	}
	
	
	/**
	* 만족도 조사 
	* 
	*/


	function goResearch(consultid){
		var frm = document.detailFrm;
		var consultid = $("#consultid").val();
		var url = '<%=CONTEXTPATH%>/web/consult/researchPop.do?consultid'+consultid;
		var wth = "1200";
		var hht = "500";
		var pnm = "research";
		popOpen(pnm,url,wth,hht); 


	}
	
	
	function showEmplSearchPop(){
		var url = '<%=CONTEXTPATH%>/web/consult/chargerSearchPop.do?menu='+'consultview';
		var wth = "1200";
		var hht = "500";
		var pnm = "chargerSerach";
		popOpen(pnm,url,wth,hht);    
	}
	
	
	//첨부파일다운로드
	//	function downFile(serverfilenm, viewfilenm){ 
	function downFile(){ 

		frm.action = "${pageContext.request.contextPath}/Download.do";
		frm.submit();
	}


	
</script> 
 
 
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="MENU_MNG_NO" id="MENU_MNG_NO" value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="consultid"   id="consultid"   value="<%=consultid%>"/>
	<input type="hidden" name="writer"   id="writer"   value="<%=writer%>" />
	<input type="hidden" name="writerid" id="writerid" value="<%=writerid%>" />
	<input type="hidden" name="deptnm"   id="deptnm"   value="<%=deptname%>" />
	<input type="hidden" name="deptcd"   id="deptcd"   value="<%=deptid%>" />
	<input type="hidden" name="consultcatcd"   id="consultcatcd"   value="<%=consultcatcd%>" />
	
	<input type="hidden" name="Pcfilename" id="Pcfilename" value="" />
	<input type="hidden" name="Serverfile" id="Serverfile" value="" />
	<input type="hidden" name="folder" id="folder" value="CONSULT" />
	
	<input type="hidden" name="Grpcd" id="Grpcd" value="<%=Grpcd%>"/>


	
 	
<div class="subCA">
<div class="subBtnW side">
<div class="subBtnC left">
	<strong class="subTT">일반자문의뢰신청서보기(<span id="Inoutcd"><%=inoutcd%></span>)</strong>
	</div>
	<div class="subBtnC right" id="test">

	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	 				 
	</div>
</div>	
	<div class="innerB" style="height: 55px;">
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width: 10%;">
				<col style="width: *;">
				<col style="width: 10%;">
				<col style="width: *;">
			</colgroup>
			<tr>
				<th>승인자 지정</th>
				<td id="deptsenginname"><%= deptsenginname %></td>
				<th>승인여부</th>
				<td id="consultstatecd"><%= consultstatecd %></td>
			</tr>
		</table>
	</div>
	<hr class="margin40">
	<strong class="subST">법률자문 의뢰 신청서</strong>
	<div class="innerB" >
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width: 10%;">
				<col style="width: 10%;">
				<col style="width: *;">
				<col style="width: 10%;">
				<col style="width: *;">
			</colgroup>
			<tr>
				<th rowspan="4">의뢰자</th>
				<th>소속</th>
				<td id="dept"><%= dept %></td>
				<th>사번</th>
				<td id="jilmunsabun"><%= jilmunsabun %></td>
			</tr>
			<tr>
				<th>성명</th>
				<td id="jilmunname"><%= jilmunname %></td>
				<th>직위</th>
				<td id="gradedetail"><%= gradedetail %></td>
			</tr>
			<tr>
				<th>연락처</th>
				<td id="phone"><%= phone %></td>
				<th>희망회신일자</th>
				
				<td id="hopedt"><%= hopedt %></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td id="email"><%= email %></td>
				<th>등록일자</th>
				<td id="balsindt"><%= balsindt %></td>
			</tr>
		</table>
		<table class="infoTable write" style="width: 100%">
			<colgroup>
				<col style="width: 10%;">
				<col style="width: *;">
			</colgroup>
			<tr>
				<th>자문명</th>
				<td id="title" ><%= title %></td>
			</tr>
			<tr>
				<th>사실관계</th>
				<td id="sasilkoreo" class="wrap"><textarea name="sasilkoreo" id="sasilkoreo" style="background:#fff; color: #666; min-height: 0px; overflow: hidden;" readonly><%= sasilkoreo %></textarea></td>
			</tr>
			<tr>
				<th>질의요지</th>
				<td id="yoji" class="wrap"> <textarea name="yoji" id="yoji" style="background:#fff; color: #666; min-height: 0px; overflow: hidden;" readonly><%= yoji %></textarea></td>
			</tr>
			<tr>
				<th>부서의견</th>
				<td id="deptview" class="wrap"><textarea name="deptview" id="deptview" style="background:#fff; color: #666; min-height: 0px; overflow: hidden;" readonly><%= deptview %></textarea></td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td>
				
				<% for(int i=0; i<list.size(); i++){
					String pcfilename = list.get(i).get("PCFILENAME").toString();
					String serverfile = list.get(i).get("SERVERFILENAME").toString();
				%>
				<div class="downfile" onclick="downFile()"><%= list.get(i).get("PCFILENAME").toString()%></div>
				<%}%>
				
				</td> <!-- 수정 -->

			</tr>
			<tr>
				<th>담당자</th>
				<td ><input type="text" id="bubname" name="bubname" value="<%= bubname %>">	
				</td>
			</tr>
		</table>
	</div>
	
	<!-- 의견서  -->
		<hr class="margin40">
		<div class="subTTW">
			<div class="subTTC left">
				<strong class="subTT" id="caseInfoTitle">자문의견서</strong>
				
			</div>
		</div>
		<div id="innerCont">
			<hr class="margin10">
			<strong class="countT">목록</strong>
			<hr class="margin10">
			<div class="innerB">
				<div id="consultansGrid"></div>
	
			</div>
			
		
	
 </div>
</div>

</form>
