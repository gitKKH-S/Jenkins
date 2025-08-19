<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	int suitid = ServletRequestUtils.getIntParameter(request, "suitid", 0);
	int caseid = ServletRequestUtils.getIntParameter(request, "caseid", 0);
	
	String casecd = request.getAttribute("casecd")==null?"":request.getAttribute("casecd").toString();
	String courtnm = request.getAttribute("courtnm")==null?"":request.getAttribute("courtnm").toString();
	String courtid = request.getAttribute("courtid")==null?"":request.getAttribute("courtid").toString();
	String casenum = request.getAttribute("casenum")==null?"":request.getAttribute("casenum").toString();
	String casenm = request.getAttribute("casenm")==null?"":request.getAttribute("casenm").toString();
	String wongo = request.getAttribute("wongo")==null?"":request.getAttribute("wongo").toString();
	String pigo = request.getAttribute("pigo")==null?"":request.getAttribute("pigo").toString();
	String makecasedt = request.getAttribute("makecasedt")==null?"":request.getAttribute("makecasedt").toString();
	String suitamt = request.getAttribute("suitamt")==null?"":request.getAttribute("suitamt").toString();
	String wongoamt = request.getAttribute("wongoamt")==null?"":request.getAttribute("wongoamt").toString();
	String pigoamt = request.getAttribute("pigoamt")==null?"":request.getAttribute("pigoamt").toString();
	String subyn = request.getAttribute("subyn")==null?"":request.getAttribute("subyn").toString();
	String opplawyer = request.getAttribute("opplawyer")==null?"":request.getAttribute("opplawyer").toString();
	String wonsub = request.getAttribute("wonsub")==null?"":request.getAttribute("wonsub").toString();
	String pisub = request.getAttribute("pisub")==null?"":request.getAttribute("pisub").toString();
	String bancasenum = request.getAttribute("bancasenum")==null?"":request.getAttribute("bancasenum").toString();
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	
	String writer = request.getAttribute("writer")==null?"":(String)request.getAttribute("writer");
	String writerid = request.getAttribute("writerid")==null?"":(String)request.getAttribute("writerid");
	String deptname = request.getAttribute("deptname")==null?"":(String)request.getAttribute("deptname");
	String deptid = request.getAttribute("deptid")==null?"":(String)request.getAttribute("deptid");
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<style>
	td div{ width:285px; }
	#delBtn{ margin-top:1px; margin-left:10px; }
	.popW{min-height:834px;}
	.statusbar{width:355px;}
	.filename{width:300px;}
	.abort{width:55px;}
	.filename get{width:300px;}
	.abort get{width:75px;}
	.progressBar{width:175px;}
</style>
<script type="text/javascript">
	var suitid = "<%=suitid%>";
	var caseid = "<%=caseid%>";
	var casenum = "<%=casenum%>";
	var casecd = "<%=casecd%>";
	var subyn = "<%=subyn%>";
	var bancasenum = "<%=bancasenum%>";
	var suitamt = "<%=suitamt%>";
	var wongoamt = "<%=wongoamt%>";
	var pigoamt = "<%=pigoamt%>";
	
	$(document).ready(function(){
		selectCriOption();
		setEditBase();
		if(caseid != "0"){
			selectFileList();
		}
	});
	function selectFileList(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectFileList.do",
			data:{suitid:suitid, oseq:caseid, tableid:'TB_SU_CASE'},
			dataType:"json",
			async:false,
			success:setFileList
		});
		
	}
	
	function setFileList(data){
		if(data.flist.length != "0"){
			$(".dragAndDropDiv").css("width", "50%");
			$(".dragAndDropDiv").css("font-size", "85%");
		}
		var html = "";
		$.each(data.flist, function(key,input){
			console.log(input);
			html += "<div class=\"statusbar odd\">";
			html += "<div class=\"filename\" style=\"width:255px;\">";
			html += input.VIEWFILENM;
			html += "</div>";
			html += "<div class=\"abort\" style=\"float:none; width:73px;\" onclick=\"delFile('"+input.FILEID+"', '"+input.SERVERFILENM+"')\">";
			html += "<input type=\"button\" name=\"delfile\" /> 삭제";
			html += "</div>";
			html += "</div>";
		});
		$(".hkk").append(html);
	}
	
	function delFile(fileid, serverfilenm){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/fileDelete.do",
			data:{fileid:fileid, serverfilenm:serverfilenm},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				location.reload();
			}
		}); 
	}
	
	function setEditBase(){
		if(casenum != '' && casenum != null){
			var str = casenum.split('@');
			for(var i=0; i<str.length; i++){
				$("#casenum"+(i+1)).val(str[i]);
			}
		}
		if(casecd != '' && casecd != null){
			$("#casecd").val("<%=casecd%>").attr("selected", "selected");
		}
		if(subyn != '' && subyn != null){
			$("#subyn").val("<%=subyn%>").attr("selected", "selected");
		}
		if(bancasenum != '' && bancasenum != null){
			$("#bansoDiv").css("display", "");
		}
		if(suitamt != '' && suitamt != null){
			$("#suitamt").val(comma(suitamt));
		}
		if(wongoamt != '' && wongoamt != null){
			$("#wongoamt").val(comma(wongoamt));
		}
		if(pigoamt != '' && pigoamt != null){
			$("#pigoamt").val(comma(pigoamt));
		}
	}
	
	function divDisplay(gbn, divNm){
		var gbnVal = $("#"+gbn).val();
		if(gbnVal == "" || gbnVal == "N"){
			$("#"+divNm).css("display", "none");
		}else{
			$("#"+divNm).css("display", "");
		}
	}
	
	function addRow(name){
		var cnt = $("#"+name+"cnt").val();
		if($("#"+name+cnt).val() == ""){
			return alert("입력 후 추가하세요");
		}
		cnt++;
		
		html = "";
		html += "<div id=\""+name+"div"+cnt+"\"><input type=\"text\" id=\""+name+cnt+"\" name=\""+name+cnt+"\" style=\"margin-top:1px;\">";
		html += "<a href=\"#none\" class=\"innerBtn\" onclick=\"addRow('"+name+"')\">추가</a>";
		html += "<a href=\"#none\" class=\"innerBtn\" onclick=\"goRemove('"+name+"div"+cnt+"')\">삭제</a>";
		html += "</div>";
		
		$("#"+name+"add").append(html);
		$("#"+name+"cnt").val(cnt);
	}
	
	function goRemove(idx){
		console.log(idx);
		$("#"+idx).remove();
	}
	
	function saveInfo(){
		
		var suitGbn = opener.document.getElementsByName("suitgbn").value;
		if(suitGbn != "제소"){
			if($("#casenum2").val() == "" || $("#casenum3").val() == ""){
				$("#casenum").focus();
				return alert("사건번호를 입력하세요");
			}
			var casenum = $("#casenum1").val()+"@"+$("#casenum2").val()+"@"+$("#casenum3").val();
			$("#casenum").val(casenum);
		}
		if($("#casenum2").val() != "" && $("#casenum3").val() != ""){
			var casenum = $("#casenum1").val()+"@"+$("#casenum2").val()+"@"+$("#casenum3").val();
			$("#casenum").val(casenum);
		}
		
		for (i=0; i<100; i++){
			try{
				eval('frm.wongo'+i+'.value')
				if (eval('frm.wongo'+i+'.value').length > 0){
					if(frm.wongo.value.length == 0){
						frm.wongo.value = eval('frm.wongo'+i+'.value');
					}else{
						frm.wongo.value = frm.wongo.value + ','+ eval('frm.wongo'+i+'.value');
					}
				}
			}catch(e){ }
			try{
				eval('frm.wongosub'+i+'.value')
				if (eval('frm.wongosub'+i+'.value').length > 0){
					if(frm.wonsub.value.length == 0){
						frm.wonsub.value = eval('frm.wongosub'+i+'.value');
					}else{
						frm.wonsub.value += ','+ eval('frm.wongosub'+i+'.value');
					}
				}
			}catch(e){ }
			try{
				eval('frm.pigo'+i+'.value')
				if (eval('frm.pigo'+i+'.value').length > 0){
					if(frm.pigo.value.length == 0){
						frm.pigo.value = eval('frm.pigo'+i+'.value');
					}else{
						frm.pigo.value += ','+ eval('frm.pigo'+i+'.value');
					}
				}
			}catch(e){ }
			try{
				eval('frm.pigosub'+i+'.value')
				if (eval('frm.pigosub'+i+'.value').length > 0){
					if(frm.pisub.value.length == 0){
						frm.pisub.value = eval('frm.pigosub'+i+'.value');
					}else{
						frm.pisub.value += ','+ eval('frm.pigosub'+i+'.value');
					}
				}
			}catch(e){ }
		}
		
		if($("#SUBYN").val() == "N"){
			$("#wonsub").val("");
			$("#pisub").val("");
		}
		
		$("#suitamt").val(uncomma($("#suitamt").val()));
		$("#wongoamt").val(uncomma($("#wongoamt").val()));
		$("#pigoamt").val(uncomma($("#pigoamt").val()));
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/caseInfoSave.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				for (var i = 0; i < fileList.length; i++) {
					var formData = new FormData();
					formData.append("file"+i, fileList[i]);
					formData.append("suitid", result.suitid);
					formData.append("caseid", result.caseid);
					formData.append("oseq", result.caseid);
					
					var other_data = $('#frm').serializeArray();
					$.each(other_data,function(key,input){
						if(input.name != 'suitid' && input.name != 'caseid'){
							formData.append(input.name,input.value);
						}
					});
					
					var status = statusList[i];
					var uploadURL = "${pageContext.request.contextPath}/web/suit/fileUpload.do";
					uploadFileFunction(status, uploadURL, formData);
				}
				alert(result.msg);
				window.close();
				opener.goReLoad();
			}
		});
	}
	
	/* 2020-09-08 */
	function uploadFileFunction(status, uploadURL, formData){
		var jqXHR = $.ajax({
			xhr:function() {
				var xhrobj = $.ajaxSettings.xhr();
				if (xhrobj.upload) {
					xhrobj.upload.addEventListener('progress', function(event) {
						var percent = 0;
						var position = event.loaded || event.position;
						var total = event.total;
						if (event.lengthComputable) {
							percent = Math.ceil(position / total * 100);
						}
						var progressBarWidth = percent * status.progressBar.width() / 100;
						status.progressBar.find('div').css({width:progressBarWidth}, 10).html(percent + "% ");
						if(parseInt(percent) >= 100){
							status.abort.hide();
						}
					}, true);
				}
				return xhrobj;
			},
			url:uploadURL,
			type:"POST",
			contentType:false,
			processData:false,
			cache:false,
			data:formData,
			async:true,
			success:function(data){
				
			}
		});
		status.setAbort(jqXHR);
	}
	
	function selectCriOption(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectOptionList.do",
			data: {"type": "CASECD"},
			dataType:"json",
			async:false,
			success:setOptionList
		});
	}
	
	function setOptionList(data){
		var html="";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				html += "<option value='"+val.CODEID+"'>"+val.CODE+"</option>"
			});
		}
		$("#casecd").append(html);
	}
	
	function goSchCasePop(){
		var suitid = $("#suitid").val();
		var caseid = $("#caseid").val();
		var url = '<%=CONTEXTPATH%>/web/suit/caseSearchPop.do?suitid='+suitid+'&caseid='+caseid;
		var wth = "800";
		var hht = "770";
		var pnm = "CaseSearch";
		popOpen(pnm,url,wth,hht);
	}
	
	function goSearchCourt(){
		var url = '<%=CONTEXTPATH%>/web/suit/searchCourtPop.do';
		var wth = "500";
		var hht = "700";
		var pnm = "courtSearch";
		popOpen(pnm,url,wth,hht);
	}
	
	var openWin
	function popOpen(pname,url,wth,hht){
		var cw = wth;
		var ch = hht;
		var sw = screen.availWidth;
		var sh = screen.availHeight;
		var px = (sw-cw)/2;
		var py = (sh-ch)/2;
		var property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=no,status=no,toolbar=no";
		openWin = window.open(url, pname, property);
		window.openWin.focus();
	}
</script>
<strong class="popTT">
	심급 등록
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" enctype="multipart/form-data" method="post" action="">
	<input type="hidden" name="caseid" id="caseid" value="<%=caseid%>"/>
	<input type="hidden" name="suitid" id="suitid" value="<%=suitid%>"/>
	
	<input type="hidden" name="wongocnt" id="wongocnt" value="0"/>
	<input type="hidden" name="pigocnt" id="pigocnt" value="0"/>
	<input type="hidden" name="wongosubcnt" id="wongosubcnt" value="0"/>
	<input type="hidden" name="pigosubcnt" id="pigosubcnt" value="0"/>
	
	<input type="hidden" name="newDeptCnt" id="newDeptCnt" value="1"/>
	
	<input type="hidden" name="wongo" id="wongo" value=""/>
	<input type="hidden" name="pigo" id="pigo" value=""/>
	<input type="hidden" name="wonsub" id="wonsub" value=""/>
	<input type="hidden" name="pisub" id="pisub" value=""/>
	
	<input type="hidden" name="casenum" id="casenum" value=""/>
	
	<input type="hidden" name="writer" id="writer" value="<%=writer%>" />
	<input type="hidden" name="writerid" id="writerid" value="<%=writerid%>" />
	<input type="hidden" name="deptcd" id="deptcd" value="<%=deptid%>" />
	<input type="hidden" name="deptname" id="deptname" value="<%=deptname%>" />
	
	<input type="hidden" name="resultgbn" id="resultgbn" value=""/>
	
	<input type="hidden" name="gbn" id="gbn" value="<%=gbn%>"/>
	
	<input type="hidden" name="filegbn" id="filegbn" value="CASE"/>
	<input type="hidden" name="fileTable" id="fileTable" value="TB_SU_CASE"/>
	
	<div class="popC" style="max-height:780px; height:780px">
		<div class="popA" style="max-height:675px; height:675px;">
			<table class="pop_infoTable write" style="height:100%;">
				<colgroup>
					<col style="width:16%;">
					<col style="width:*;">
					<col style="width:16%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>심급</th>
					<td>
						<select name="casecd" id="casecd" style="width:50%">
							<option value="">선택</option>
						</select>
					</td>
					<th></th>
					<td></td>
				</tr>
				<tr>
					<th>제/피소일</th>
					<td><input type="text" name="makecasedt" id="makecasedt" class="datepick" value="<%= makecasedt %>" style="width:80px;"></td>
					<th>관할 법원</th>
					<td>
						<input type="hidden" name="courtid" id="courtid" value="<%= courtid %>">
						<input type="text" name="courtnm" id="courtnm" value="<%= courtnm %>">
						<a href="#none" onclick="goSearchCourt()" class="innerBtn">검색</a>
					</td>
				</tr>
				<tr>
					<th>사건번호</th>
					<td>
						<select id="casenum1" name="casenum1" style="width:60PX;">
							<option value="2018">2018</option>
							<option value="2019">2019</option>
							<option value="2020">2020</option>
						</select>
						<input type="text" name="casenum2" id="casenum2" style="width:70px" />
						<input type="text" name="casenum3" id="casenum3" style="width:70px"/>
					</td>
					<th>사건명</th>
					<td><input type="text" name="casenm" id="casenm" value="<%= casenm %>"></td>
				</tr>
				<tr>
					<th>원고</th>
					<td id="wongoadd">
<%
						String[] arr1 = wongo.split(",");
						if(!wongo.contains(",")){
%>
						<input type="text" id="wongo0" name="wongo0" value="<%=wongo%>">
						<a href="#none" onclick="addRow('wongo');" class="innerBtn">추가</a>
<%
						}else{
							for(int i=0; i<arr1.length; i++){
%>
						<div id="<%="wongodiv"+i %>">
							<input type="text" id="<%="wongo"+i %>" name="<%="wongo"+i %>" value="<%=arr1[i]%>" style="margin-top:1px;"/>
							<a href="#none" onclick="addRow('wongo');" class="innerBtn">추가</a>
							<a href="#none" class="innerBtn" onclick="goRemove('<%="wongodiv"+i %>')">삭제</a>
						</div>
<%
							}
%>
						<script>
							$("#wongocnt").val("<%=arr1.length%>");
						</script>
<%
						}
%>
					</td>
					<th>피고</th>
					<td id="pigoadd">
<%
						String[] arr2 = pigo.split(",");
						if(!pigo.contains(",")){
%>
						<input type="text" id="pigo0" name="pigo0" value="<%=pigo%>">
						<a href="#none" onclick="addRow('pigo');" class="innerBtn">추가</a>
<%
						}else{
							for(int i=0; i<arr2.length; i++){
%>
						<div id="<%="pigodiv"+i %>">
							<input type="text" id="<%="pigo"+i %>" name="<%="pigo"+i %>" value="<%=arr2[i]%>" style="margin-top:1px;"/>
							<a href="#none" onclick="addRow('pigo');" class="innerBtn">추가</a>
							<a href="#none" class="innerBtn" onclick="goRemove('<%="pigodiv"+i %>')">삭제</a>
						</div>
<%
							}
%>
						<script>
							$("#pigocnt").val("<%=arr2.length%>");
						</script>
<%
						}
%>
					</td>
				</tr>
				<tr>
					<th>상대방대리인</th>
					<td><input type="text" name="opplawyer" id="opplawyer" value="<%=opplawyer%>"></td>
					<th></th>
					<td></td>
				</tr>
				<tr>
					<th>보조참가여부</th>
					<td>
						<select name="subyn" id="subyn" onchange="divDisplay('subyn','subDiv');" style="width:50%">
							<option value="N">N</option>
							<option value="Y">Y</option>
						</select>
					</td>
					<th></th>
					<td></td>
				</tr>
				<tr id="subDiv" style="display:none;">
					<th>원고 보조참가</th>
					<td id="wongosubadd">
<%
						String[] arr3 = wonsub.split(",");
						if(!wonsub.contains(",")){
%>
						<input type="text" id="wongosub0" name="wongosub0" value="<%=wonsub%>">
						<a href="#none" onclick="addRow('wongosub');" class="innerBtn">추가</a>
<%
						}else{
							for(int i=0; i<arr3.length; i++){
%>
						<div id="<%="wongosubdiv"+i %>">
							<input type="text" id="<%="wongosub"+i %>" name="<%="wongosub"+i %>" value="<%=arr3[i]%>" style="margin-top:1px;"/>
							<a href="#none" onclick="addRow('wongosub');" class="innerBtn">추가</a>
							<a href="#none" class="innerBtn" onclick="goRemove('<%="wongosubdiv"+i %>')">삭제</a>
						</div>
<%
							}
%>
						<script>
							$("#wongosubcnt").val("<%=arr3.length%>");
						</script>
<%
						}
%>
					</td>
					<th>피고 보조참가</th>
					<td id="pigosubadd">
<%
						String[] arr4 = pisub.split(",");
						if(!pisub.contains(",")){
%>
						<input type="text" id="pigosub0" name="pigosub0" value="<%=pisub%>">
						<a href="#none" onclick="addTextbox('pigosub');" class="innerBtn">추가</a>
<%
						}else{
							for(int i=0; i<arr4.length; i++){
%>
						<div id="<%="pigosubdiv"+i %>">
							<input type="text" id="<%="pigosub"+i %>" name="<%="pigosub"+i %>" value="<%=arr4[i]%>" style="margin-top:1px;"/>
							<a href="#none" onclick="addRow('pigosub');" class="innerBtn">추가</a>
							<a href="#none" class="innerBtn" onclick="goRemove('<%="pigosubdiv"+i %>')">삭제</a>
						</div>
<%
							}
%>
						<script>
							$("#pigosubcnt").val("<%=arr4.length%>");
						</script>
<%
						}
%>
					</td>
				</tr>
				<tr>
					<th>소송가액</th>
					<td><input type="text" name="suitamt" id="suitamt" value="<%= suitamt%>" onkeyup="numFormat(this);"></td>
					<th></th>
					<td></td>
				</tr>
				<tr>
					<th>원고 소가</th>
					<td><input type="text" name="wongoamt" id="wongoamt" value="<%=wongoamt%>" onkeyup="numFormat(this);"></td>
					<th>피고 소가</th>
					<td><input type="text" name="pigoamt" id="pigoamt" value="<%=pigoamt%>" onkeyup="numFormat(this);"></td>
				</tr>
				<tr>
					<th>관련사건</th>
					<td>
						<a href="#none" class="innerBtn" onclick="goSchCasePop();">관련사건 등록</a>
						<input type="hidden" name="relSuitId" id="relSuitId" value=""/>
						<input type="hidden" name="relCaseId" id="relCaseId" value=""/>
					</td>
					<th>반소여부</th>
					<td>
						<select name="bansoYn" id="bansoYn" onchange="divDisplay('bansoYn', 'bansoDiv');">
							<option value="N">N</option>
							<option value="Y">Y</option>
						</select>
						<span id="bansoDiv" style="display:none;">
							&nbsp;사건번호&nbsp;
							<input type="text" name="bancasenum" id="bancasenum" value="<%=bancasenum%>">
						</span>
					</td>
				</tr>
				<tr>
					<th>소장</th>
					<td colspan="3">
						<div id="fileUpload" class="dragAndDropDiv">
							<input type="file" multiple style="display:none" id="filesel"/>
							<label for="filesel"><strong>업로드 할 파일을 선택 하세요</strong></label>
							<label for="filesel">(드래그 앤 드롭으로 파일 첨부가 가능합니다.)</label>
						</div>
						<div id="fileList">
							<input type="hidden" />
						</div>
						<div id="hkk" class="hkk">
						</div>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" onclick="saveInfo();" class="sBtn type1">등록</a>
		</div>
	</div>
</form>