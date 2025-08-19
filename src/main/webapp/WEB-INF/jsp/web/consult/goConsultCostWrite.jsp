<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.mten.bylaw.consult.Constants" %>
<%@ page import="com.mten.bylaw.consult.service.*"%>

<%
	HashMap cInfo = request.getAttribute("cInfo")==null?new HashMap():(HashMap)request.getAttribute("cInfo");
	HashMap costInfo = cInfo.get("costInfo")==null?new HashMap():(HashMap)cInfo.get("costInfo");
	//자문의뢰서 첨부파일
	List fconsultlist = cInfo.get("fconsultlist")==null?new ArrayList():(ArrayList)cInfo.get("fconsultlist");
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
    System.out.println(se);
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
	String OPHONE = se.get("INPHONE")==null?"":se.get("INPHONE").toString();
	String USERNAME = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
	String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
	String DEPTNAME = se.get("DEPTNAME")==null?"":se.get("DEPTNAME").toString();
	String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
	
	String writer = USERNAME;
	String deptnm = DEPTNAME;
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
	});
	$(document).ready(function(){
		$("#cost").number(true);
		$("#savebtn").click(function(){
			if(confirm("등록 하시겠습니까?")){
				var frm = document.wform;
				$.ajax({
	                type:"POST",
	                url : "${pageContext.request.contextPath}/web/consult/consultCostSave.do",
	                data : $('#wform').serializeArray(),
	                dataType: "json",
	                async: false,
	                success : function(result){
	                    if(result.data.msg =='ok'){
	                    	for (var i = 0; i < fileList.length; i++) 
	    		            {
	    		            	var formData = new FormData();
	    		            	formData.append('file'+i, fileList[i]);
	    		            	formData.append('gbnid',result.data.costid);
	    		            	
	    		            	var other_data = $('#wform').serializeArray();
	                            $.each(other_data,function(key,input){
	                            	if(input.name != 'costid'){
	                            		formData.append(input.name,input.value);
	                            	}
	                            });
	    		            	var status = statusList[i];
	    		            	
	    		            	var uploadURL = "${pageContext.request.contextPath}/web/consult/fileUploadconsult.do"; //Upload URL
	    			            var extraData ={}; //Extra Data.
	    			            var jqXHR=$.ajax({
	    			                    xhr: function() {
	    			                    var xhrobj = $.ajaxSettings.xhr();
	    			                    if (xhrobj.upload) {
	    			                            xhrobj.upload.addEventListener('progress', function(event) {
	    			                                var percent = 0;
	    			                                var position = event.loaded || event.position;
	    			                                var total = event.total;
	    			                                if (event.lengthComputable) {
	    			                                    percent = Math.ceil(position / total * 100);
	    			                                }
	    			                                status.setProgress(percent);
	    			                            }, false);
	    			                        }
	    			                    return xhrobj;
	    			                },
	    			                url: uploadURL,
	    			                type: "POST",
	    			                contentType:false,
	    			                processData: false,
	    			                cache: false,
	    			                data: formData,
	    			                async: false,
	    			                success: function(data){
	    			                	status.setProgress(100);
	    			                    //$("#status1").append("File upload Done<br>");           
	    			                }
	    			            }); 
	    			            status.setAbort(jqXHR);
	    		            }
	                    	alert("저장되었습니다.");
	                		frm.costid.value = result.data.costid;
	                		frm.action = "${pageContext.request.contextPath}/web/consult/goConsultCostView.do";
	                		frm.submit();
	                    }else{
	                        alert(result.data.msg);
	                    }
	                }
	            })
			}
		});
		
		$("#listbtn").click(function(){
			var frm = document.wform;
			frm.action = "${pageContext.request.contextPath}/web/consult/goConsultCostList.do";
			frm.submit();
		});
	});
	
	//자문변호사 선택
	function selectLawyerPop(){
		cw = 1000;
		ch = 830;
		sw = screen.availWidth;
		sh = screen.availHeight;
		px = (sw-cw)/2;
		py = (sh-ch)/2;
		
		var property = "left="+px+", top="+py+", width="+cw+"px, height="+ch+"px, ";
	    property += "scrollbars=auto, resizable=no, status=no, toolbar=no, location=no";

	    window.open("${pageContext.request.contextPath}/web/consult/selectLawyerPop2.do","",property); 
	}
	function consultSch(){
		if($("#startdt").val()==''||$("#startdt").val()==''||$("#startdt").val()==''){
			alert("지급대상 법무법인,자문료 산정기간을 선택하셔야 검색이 가능합니다.");
			return;
		}
		gridStore.on('beforeload', function() {
			gridStore.baseParams = {
				startdt : $("#startdt").val(),
				enddt : $("#enddt").val(),
				lawfirmid : $("#lawfirmid").val()
			}
		});
		gridStore.load();
	}
</script>


<div class="subCA">
	<div class="subBtnW side">
		<div class="subBtnC left">
			<strong class="subTT">자문료지급정보</strong>
		</div>
		<div class="subBtnC right" id="test">
		 	<a href="#none" class="sBtn type1" id="savebtn">저장</a>
			<a href="#none"class="sBtn type2" id="listbtn">목록</a>
		</div>
	</div>	
	<div class="innerB" >
		<form name="wform" id="wform" method="post" action="${pageContext.request.contextPath}/web/consult/consultCostSave.do">
		<input type="hidden" name="costid" id="costid" value="<%=costInfo.get("costid")==null?"":costInfo.get("costid")%>"/>
		<input type="hidden" name="MENU_MNG_NO"  value="<%=MENU_MNG_NO%>"> 
		<input type="hidden" name="filegbn"  value="consultcost">
		<input type="hidden" name="consultcnt" id="consultcnt"  value="0">
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
					<input type="text" id="title" name="title" value="<%=costInfo.get("title")==null?"":costInfo.get("title")%>" style="width: 100%;"/>
				</td>
				
				<th>작성자</th>
				<td>
					<input type="text" value="<%=writer %>" style="width: 100%;" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<th>법인선택</th>
				<td>
					<input type="text" id="office" name="office" value="<%=costInfo.get("office")==null?"":costInfo.get("office")%>" style="width: 70%;"/>
					<a href="javascript:selectLawyerPop();" style="height:30px;line-height:30px;min-width:0px;" class="sBtn type1" id="savebtn">조회</a>
					<input type="hidden" id="lawfirmid" name="lawfirmid" value="<%=costInfo.get("lawfirmid")==null?"":costInfo.get("lawfirmid")%>"/>
				</td>
				<th>자문료산정기간</th>
				<td>
					<input type="text" id="startdt" name="startdt" value="<%=costInfo.get("startdt")==null?"":costInfo.get("startdt")%>" class="datepick" style="width: 30%;"/> ~
					<input type="text" id="enddt" name="enddt" value="<%=costInfo.get("enddt")==null?"":costInfo.get("enddt")%>" class="datepick" style="width: 30%;"/>
					<a href="javascript:consultSch()" style="height:30px;line-height:30px;min-width:0px;padding:0 5px;" class="sBtn type1" id="savebtn">조회</a>
				</td>
				<th>자문료</th>
				<td>
					<input type="text" id="cost" name="cost" style="width:100%;" value="<%=costInfo.get("cost")==null?"":costInfo.get("cost")%>"/>
				</td>
			</tr>
			<tr>
				<th>은행</th>
				<td>
					<input type="text" id="bankname" name="bankname" style="width:100%;" value="<%=costInfo.get("bankname")==null?"":costInfo.get("bankname")%>"/>
				</td>
				<th>계좌번호</th>
				<td>
					<input type="text" id="account" name="account" style="width:100%;" value="<%=costInfo.get("account")==null?"":costInfo.get("account")%>"/>
				</td>
				
				<th>예금주</th>
				<td>
					<input type="text" id="accountowner" name="accountowner" style="width:100%;" value="<%=costInfo.get("accountowner")==null?"":costInfo.get("accountowner")%>"/>
				</td>
			</tr>
			<tr>
				<th>파일첨부</th>
				<td colspan="5">
					<div id="fileUpload" class="dragAndDropDiv" <%if(fconsultlist.size()>0){ %>style="width:50%"<%} %>>
						<input type="file" multiple style="display:none" id="filesel"/>
						<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
						<label for="filesel">(드래그 앤 드롭으로 파일 첨부가 가능합니다.)</label>
					</div>
					<div id="fileList">
						<input type="hidden" />
					</div>
					<div id="hkk" class="hkk"></div>
					<div class="hkk2" style="width:49%;">
						<%
							for(int i=0; i<fconsultlist.size(); i++){
								HashMap result = (HashMap)fconsultlist.get(i);
						%>
						<div class="statusbar odd">
							<div class="filename" style='width:80%'><%=result.get("VIEWFILENM") %></div><div class="abort"><input type="checkbox" name="delfile[]" value="<%=result.get("FILEID") %>"/>　삭제</div>
						</div>
						<%
							}
						%>
					</div>
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
