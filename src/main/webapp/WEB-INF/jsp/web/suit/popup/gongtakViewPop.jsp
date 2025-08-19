<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();	
	String depositid = request.getAttribute("depositid")==null?"":request.getAttribute("depositid").toString();
	String suitid = request.getAttribute("suitid")==null?"":request.getAttribute("suitid").toString();
	String caseid = request.getAttribute("caseid")==null?"":request.getAttribute("caseid").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<style>
	.popW{min-width:537px; height:100%}
	.selFileDiv{cursor:pointer; text-decoration:underline;}
</style>
<script type="text/javascript">
	var depositid = "<%=depositid%>";
	var suitid = "<%=suitid%>";
	var caseid = "<%=caseid%>";
	
	$(document).ready(function(){
		getGongTakInfo();
	});
	
	function getGongTakInfo(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectGongtakInfo.do",
			data:{depositid:depositid, suitid:suitid, caseid:caseid},
			dataType:"json",
			async:false,
			success:setGongTakInfo
		});
	}
	
	function setGongTakInfo(data){
		$.each(data.result, function(key,val){
			console.log(key);
			console.log(val);
			if(val.TYPE == "0"){
				$("#type").append("공탁자");
			}else{
				$("#type").append("피공탁자");
			}
			$("#courtnm").append(val.COURTNM);
			$("#gongtakdt").append(val.GONGTAKDT);
			$("#gongtakamt").append(comma(val.GONGTAKAMT));
			$("#causenm").append(val.CAUSENM);
			$("#recoveryyn").append(val.RECOVERYYN);
			$("#suitnm").append(val.SUITNM+" ("+val.CASENUM+")");
		});
		
		selectFileList();
	}
	
	function selectFileList(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectFileList.do",
			data:{oseq:depositid, tableid:'TB_SU_DEPOSIT'},
			dataType:"json",
			async:false,
			success:setFileList
		});
	}
	
	function setFileList(data){
		var html = "";
		if(data.flist.length > 0){
			$.each(data.flist, function(key, input){
				html += "<div class=\"selFileDiv\" onclick=\"downFile('"+input.SERVERFILENM+"','"+input.VIEWFILENM+"') \">" + input.VIEWFILENM+"</div>";
			});
		}
		
		if(html == ""){
			html+="등록 된 파일이 없습니다.";
		}
		$("#fileList").append(html);
	}
	
	function gongtakEdit(){
		var url = '<%=CONTEXTPATH%>/web/suit/gongtakWritePop.do?depositid='+depositid+'&suitid='+suitid+'&caseid='+caseid;
		var wth = "650";
		var hht = "700";
		var pnm = "editpop";
		popOpen(pnm,url,wth,hht);
		window.close();
	}
	
	function downFile(serverfilenm, viewfilenm){
		var frm = document.frm;
		frm.Serverfile.value = serverfilenm;
		frm.Pcfilename.value = viewfilenm;
		frm.action = "${pageContext.request.contextPath}/Download.do";
		frm.submit();
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
		openWin.opener = opener;
		window.openWin.focus();
	}
	
	function delGongTak(){
		if(confirm("공탁금 정보를 삭제하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/delGongTak.do",
				data:{suitid:suitid, caseid:caseid, depositid:depositid},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					opener.goReLoad();
					window.close();
				}
			});
		}
	}
</script>
<strong class="popTT">
	공탁금 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="depositid" id="depositid" value="<%=depositid%>"/>
	<input type="hidden" name="caseid" id="caseid" value="<%=caseid%>"/>
	<input type="hidden" name="suitid" id="suitid" value="<%=suitid%>"/>
	
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"   id="WRTR_EMP_NM"   value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"   id="WRT_DEPT_NO"   value="<%=WRT_DEPT_NO%>" />
	
	<input type="hidden" name="Serverfile" id="Serverfile" value="" />
	<input type="hidden" name="Pcfilename" id="Pcfilename" value="" />
	<input type="hidden" name="folder" id="folder" value="SUIT" />
	
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>사건명</th>
					<td id="suitnm"></td>
				</tr>
				<tr>
					<th>공탁유형</th>
					<td id="type"></td>
				</tr>
				<tr>
					<th>법원</th>
					<td id="courtnm"></td>
				</tr>
				<tr>
					<th>공탁일자</th>
					<td id="gongtakdt"></td>
				</tr>
				<tr>
					<th>공탁금액</th>
					<td id="gongtakamt"></td>
				</tr>
				<tr>
					<th>공탁사유</th>
					<td id="causenm"></td>
				</tr>
				<tr>
					<th>회수여부</th>
					<td id="recoveryyn"></td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td id="fileList"></td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
<%
		if(!GRPCD.equals("X")){
%>
			<a href="#none" class="sBtn type2" onclick="gongtakEdit();">수정</a>
			<a href="#none" class="sBtn type3" onclick="delGongTak();">삭제</a>
<%
		}
%>
		</div>
	</div>
</form>
