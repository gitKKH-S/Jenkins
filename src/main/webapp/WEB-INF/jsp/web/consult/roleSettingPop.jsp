<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String suitid = request.getAttribute("suitid")==null?"":(String)request.getAttribute("suitid");
	String writer = request.getAttribute("writer")==null?"":(String)request.getAttribute("writer");
	String writerid = request.getAttribute("writerid")==null?"":(String)request.getAttribute("writerid");
	String deptname = request.getAttribute("deptname")==null?"":(String)request.getAttribute("deptname");
	String deptid = request.getAttribute("deptid")==null?"":(String)request.getAttribute("deptid");
%>
<script type="text/javascript">
	var suitid = "<%=suitid%>";
	$(document).ready(function(){
		$("#loading").hide();
		getDept();
		
		$("#srchTxt1").keyup(function(){
			var k = $(this).val();
			$("#deptlist > tbody > .deptinfo").hide();
			var temp = $("#deptlist > tbody > .deptinfo > #deptnm:nth-child(1n+1):contains('" + k + "')");
			$(temp).parent().show();
		});
		
		$("#srchTxt2").keyup(function(){
			var k = $(this).val();
			$("#emplist > tbody > .userinfo").hide();
			var temp = $("#emplist > tbody > .userinfo > #usernm:nth-child(3n+2):contains('" + k + "')");
			$(temp).parent().show();
		});
	});
	
	function getRoleInfo(suitid){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectRoleInfo.do",
			data: {"docid":suitid},
			dataType:"json",
			async:true,
			success:function(result){
				$.each(result.result, function(index, val){
					if(val.ROLEGBN == "D"){
						setSelInfo(val.ROLEDEPTID, val.NAME, val.ROLEGBN);
					}else{
						setSelInfo(val.ROLEWRITERID, val.NAME, val.ROLEGBN);
					}
				});
			},
			beforeSend:function(){
				$("#loading").show();
			},
			complete:function(){
				$("#loading").hide();
			}
		});
	}
	
	function getDept(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectDeptList.do",
			dataType:"json",
			async:false,
			success:selectDeptCallBack
		});
	}
	
	function selectDeptCallBack(data){
		var html = "";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				html += "<tr class=\"deptinfo\">";
				html += "<td class=\"selTd\" id=\"deptnm\" onclick=\"goSelDeptUser('"+val.SOSOK_CD+"')\">"+val.CODE_NAME_KR+"</td>";
				html += "<td><a href=\"#none\" class=\"innerBtn\" onclick=\"setSelInfo('"+val.SOSOK_CD+"','"+val.CODE_NAME_KR+"','D')\">선택</a></td>";
				html += "</tr>";
			});
		}else{
			html += "<tr class=\"deptinfo\"><td colspan=\"3\">검색 결과가 없습니다.</td></tr>";
		}
		$("#deptlist").append(html);
		
		$("#loading").hide();
		
		getRoleInfo(suitid);
	}
	
	function goSelDeptUser(sosokcd){
		$("#infoTr").remove();
		$(".userinfo").remove();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectUserList.do",
			data: {"sosokcd":sosokcd},
			dataType:"json",
			async:false,
			success:selectUserCallBack
		});
	}
	
	function selectUserCallBack(data){
		var html = "";
		if(data.result.length > 0){
			$.each(data.result, function(index, val){
				html += "<tr class=\"userinfo\">";
				html += "<td>"+val.USER_NM+"</td>";
				html += "<td>"+val.JIKCHK_NM+"</td>";
				html += "<td><a href=\"#none\" class=\"innerBtn\" onclick=\"setSelInfo('"+val.USER_ID+"','"+val.USER_NM+"','P')\">선택</a></td>";
				html += "</tr>";
			});
		}else{
			html += "<tr class=\"userinfo\"><td colspan=\"3\">검색 결과가 없습니다.</td></tr>";
		}
		$("#emplist").append(html);
	}
	
	function setSelInfo(id, name, gbn){
		var dcnt = $("#dcnt").val();
		var ucnt = $("#ucnt").val();
		if(gbn == "D"){
			var html = "<tr id=\"dsel"+dcnt+"\">";
			html += "<td>"+name;
			html += "<input type=\"hidden\" id=\"seldept"+dcnt+"\" value=\""+id+"\">";
			html += "<a href=\"#none\" class=\"innerBtn\" onclick=\"selDel('"+dcnt+"','D')\">삭제</a>";
			html += "</td></tr>";
			$("#selList").append(html);
			dcnt++;
		}else{
			var html = "<tr id=\"usel"+ucnt+"\">";
			html += "<td>"+name;
			html += "<input type=\"hidden\" id=\"seluser"+ucnt+"\" value=\""+id+"\">";
			html += "<a href=\"#none\" class=\"innerBtn\" onclick=\"selDel('"+ucnt+"','U')\">삭제</a>";
			html += "</td></tr>";
			$("#selList").append(html);
			ucnt++;
		}
		$("#dcnt").val(dcnt);
		$("#ucnt").val(ucnt);
	}
	
	function selDel(cnt, gbn){
		if(gbn == "D"){
			$("#dsel"+cnt).remove();
		}else{
			$("#usel"+cnt).remove();
		}
	}
	
	function goSave(){
		var dcnt = $("#dcnt").val();
		var ucnt = $("#ucnt").val();
		var selDept = "";
		var selUser = "";
		
		for(var i=0; i<dcnt; i++){
			if(i == (dcnt-1)){
				if($("#seldept"+i).val() != undefined){
					selDept += $("#seldept"+i).val();
				}
			}else{
				if($("#seldept"+i).val() != undefined){
					selDept += $("#seldept"+i).val()+",";
				}
			}
		}
		
		for(var i=0; i<ucnt; i++){
			if(i == (ucnt-1)){
				if($("#seluser"+i).val() != undefined){
					selUser += $("#seluser"+i).val();
				}
			}else{
				if($("#seluser"+i).val() != undefined){
					selUser += $("#seluser"+i).val()+",";
				}
			}
		}
		
		$("#chkDept").val(selDept);
		$("#chkUser").val(selUser);
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/roleInfoSave.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				window.close();
			}
		});
	}
</script>
<style>
	#srchTxt1{width:90%; height:30px; line-height:0px; margin-top:3px;}
	#srchTxt2{width:90%; height:30px; line-height:0px; margin-top:3px;}
	.popW{height:100%}
	#hidden{display:none;}
	.selTd{cursor:pointer;}
	.selTd:hover{color:blue;}
	
	#loading{
		height:100%;
		left:0px;
		position:fixed;
		_position:absolute;
		top:0px;
		width:100%;
		filter:alpha(opacity=50);
		-moz-opacity:0.5;
		opacity:0.5;
	}
	
	.loading{
		background-color:white;
		z-index:9998;
	}
	
	#loading_img{
		position:absolute;
		top:50%;
		left:50%;
		height:35px;
		margin-top:-25px;
		margin-left:0px;
		z-index:9999;
	}
</style>
<form name="frm" id=frm method="post" action="">
	<input type="hidden" name="suitid"   id="suitid"   value="<%=suitid%>" />
	<input type="hidden" name="writer"   id="writer"   value="<%=writer%>" />
	<input type="hidden" name="writerid" id="writerid" value="<%=writerid%>" />
	<input type="hidden" name="deptcd"   id="deptcd"   value="<%=deptid%>" />
	<input type="hidden" name="deptname" id="deptname" value="<%=deptname%>" />
	
	<input type="hidden" name="chkUser" id="chkUser" value="" />
	<input type="hidden" name="chkDept" id="chkDept" value="" />
	
	<input type="hidden" name="dcnt" id="dcnt" value="0"/>
	<input type="hidden" name="ucnt" id="ucnt" value="0"/>
</form>
<strong class="popTT">
	소송 권한 관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div>
	<div id="loading" class="loading"><img id="loading_img" alt="loading" src="${resourceUrl}/paramquery-3.3.2/images/loading.gif" /></div>
	<div class="popC left">
		<div class="popSrchW">
			<input type="text" id="srchTxt1" placeholder="검색 할 부서명을 입력해주세요">
		</div>
		<div class="popA" style="max-height:670px;">
			<table class="pop_listTable" id="deptlist">
				<colgroup>
					<col style="width:*;">
					<col style="width:20%;">
				</colgroup>
				<tr>
					<th>부서명</th>
					<th>선택</th>
				</tr>
			</table>
		</div>
	</div>
	<div class="popC right">
		<div class="popSrchW">
			<input type="text" id="srchTxt2" placeholder="검색 할 직원명을 입력해주세요">
		</div>
		<div class="popA" style="height:310px;">
			<table class="pop_listTable" id="emplist">
				<colgroup>
					<!-- <col style="width:14%;"> -->
					<col style="width:40%;">
					<col style="width:*;">
					<col style="width:20%;">
				</colgroup>
				<tr>
					<!-- <th>순번</th> -->
					<th>이름</th>
					<th>직책명</th>
					<th>선택</th>
				</tr>
				<tr id="infoTr">
					<td colspan="3">부서명을 선택 해 주세요</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<strong class="popSTT" style="margin-left:10px;">선택 된 부서/직원</strong>
		<div class="popA" style="height:310px;">
			<table class="pop_listTable" id="selList">
				<colgroup>
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>부서명/직원명</th>
				</tr>
			</table>
		</div>
	</div>
	<hr class="margin40">
	<div class="subBtnW center">
		<a href="#none" class="sBtn type1" onclick="goSave();">저장</a>
	</div>
</div>