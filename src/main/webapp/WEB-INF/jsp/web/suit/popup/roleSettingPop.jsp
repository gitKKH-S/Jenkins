<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String DOC_MNG_NO  = request.getAttribute("DOC_MNG_NO")==null?"":(String)request.getAttribute("DOC_MNG_NO");
	String DOC_SE      = request.getAttribute("DOC_SE")==null?"":(String)request.getAttribute("DOC_SE");
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":(String)request.getAttribute("WRTR_EMP_NM");
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":(String)request.getAttribute("WRTR_EMP_NO");
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":(String)request.getAttribute("WRT_DEPT_NM");
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":(String)request.getAttribute("WRT_DEPT_NO");
%>
<script type="text/javascript">
	var DOC_MNG_NO = "<%=DOC_MNG_NO%>";
	var DOC_SE     = "<%=DOC_SE%>";
	var deptno     = '<%=WRT_DEPT_NO%>';
	var deptnm     = "";
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		var Tree = Ext.tree;
		var dLoder = new Ext.tree.TreeLoader({
			dataUrl: '${pageContext.request.contextPath}/web/suit/getDeptList.do'
		});
		
		var treeDD = new Tree.TreePanel({
			id:'treeDD', renderTo:'deptList', useArrows: false, autoScroll: true,
			animate : true, enableDD: false, containerScroll: true, border: true,
			loader : dLoder, height:650,
			root: {
				nodeType: 'async', text:'서울시청', draggable:false, id: '6110000', cls:'dept'
			},
			listeners: {
				click: function(node, e){
					$("#srchTxt2").val("");
					
					if (node.id != "6110000") {
						deptno = node.id+"";
						deptnm = node.text;
						goSelDeptUser(node.id+"", $("#srchTxt2").val());
					} else {
						deptnm = "";
						deptno = "";
					}
				}
			}
		});
		treeDD.getRootNode().expand();
		
		$(window).resize(function() {
			
		});
	});
	
	$(document).ready(function(){
		$("#srchTxt2").keydown(function(key) {
			if (key.keyCode == 13) {
				goSelDeptUser(deptno , $(this).val());
			}
		});
		
		getRoleInfo();
	});
	
	function goSelDeptUser(DEPT_NO, schtxt2){
		$("#infoTr").remove();
		$(".userinfo").remove();
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectUserList.do",
			data: {"DEPT_NO":DEPT_NO, "schtxt2":schtxt2},
			dataType:"json",
			async:false,
			success:selectUserCallBack
		});
	}
	
	function selectUserCallBack(data){
		var html = "";
		if(data.result.length > 0){
			if (deptnm != "") {
				html += "<tr class=\"userinfo\" onclick=\"setSelInfo('"+deptno+"','"+deptnm+"','D')\">";
				html += "<td class=\"selTd\" colspan=\"3\" id=\"usernm\">"+deptnm+" 전체 </td>"; // user nm
				html += "</tr>";
			}
			
			$.each(data.result, function(index, val){
				html += "<tr class=\"userinfo\">";
				html += "<td>"+val.DEPT_NM+"</td>";
				html += "<td>"+val.JBGD_NM+"</td>";
				html += "<td class=\"selTd\" id=\"usernm\" onclick=\"setSelInfo('"+val.EMP_NO+"','"+val.EMP_NM+"','P')\">"+val.EMP_NM+"</td>"; // user nm
				html += "</tr>";
			});
			
			if (data.result.length > 19) {
				$("#headTable").css("width", "96.7%");
			} else {
				$("#headTable").css("width", "100%");
			}
		} else {
			$("#headTable").css("width", "100%");
			html += "<tr class=\"userinfo\"><td colspan=\"3\">검색 결과가 없습니다.</td></tr>";
		}
		$("#emplist").append(html);
	}
	
	function getRoleInfo(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectRoleInfo.do",
			data: {"DOC_MNG_NO":DOC_MNG_NO, "DOC_SE":DOC_SE},
			dataType:"json",
			async:false,
			success:function(result){
				$.each(result.result, function(index, val){
					if (val.ROLEGBN == "D") {
						setSelInfo(val.AUTHRT_DEPT_NO, val.NAME, val.AUTHRT_SE);
					} else {
						setSelInfo(val.AUTHRT_EMP_NO, val.NAME, val.AUTHRT_SE);
					}
				});
			}
		});
	}
	
	function setSelInfo(id, name, gbn){
		var dcnt = $("#dcnt").val();
		var ucnt = $("#ucnt").val();
		if (name != "undefined") {
			if (gbn == "DW") {
				var html = "<tr id=\"dselDW\">";
				html += "<td>"+name;
				html += "<input type=\"hidden\" id=\"seldeptDW\" value=\""+id+"\">";
				html += "</td>";
				html += "<td>";
				html += "주관부서";
				html += "</td></tr>";
				$("#selList").append(html);
			} else if(gbn == "D"){
				var html = "<tr id=\"dsel"+dcnt+"\">";
				html += "<td>"+name;
				html += "<input type=\"hidden\" id=\"seldept"+dcnt+"\" value=\""+id+"\">";
				html += "</td>";
				html += "<td>";
				html += "<a href=\"#none\" class=\"innerBtn\" onclick=\"selDel('"+dcnt+"','D')\">삭제</a>";
				html += "</td></tr>";
				$("#selList").append(html);
				dcnt++;
			} else {
				var html = "<tr id=\"usel"+ucnt+"\">";
				html += "<td>"+name;
				html += "<input type=\"hidden\" id=\"seluser"+ucnt+"\" value=\""+id+"\">";
				html += "</td>";
				html += "<td>";
				html += "<a href=\"#none\" class=\"innerBtn\" onclick=\"selDel('"+ucnt+"','U')\">삭제</a>";
				html += "</td></tr>";
				$("#selList").append(html);
				ucnt++;
			}
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
	.userinfo{cursor:pointer;}
	.userinfo:hover{background:#BDBDBD;}
	#notiMsg {
		margin-bottom: 10px;
		font-weight: bold;
		font-size: 12px;
	}
</style>
<form name="frm" id=frm method="post" action="">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="WRTR_EMP_NM" id="WRTR_EMP_NM" value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO" id="WRTR_EMP_NO" value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO" id="WRT_DEPT_NO" value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM" id="WRT_DEPT_NM" value="<%=WRT_DEPT_NM%>" />
	
	<input type="hidden" name="DOC_MNG_NO"  id="DOC_MNG_NO"  value="<%=DOC_MNG_NO%>" />
	<input type="hidden" name="DOC_SE"      id="DOC_SE"      value="<%=DOC_SE%>" />
	<input type="hidden" name="chkUser"     id="chkUser"     value="" />
	<input type="hidden" name="chkDept"     id="chkDept"     value="" />
	<input type="hidden" name="dcnt"        id="dcnt"        value="0"/>
	<input type="hidden" name="ucnt"        id="ucnt"        value="0"/>
</form>
<strong class="popTT">
	열람권한관리
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div class="popC left" style="width:40%">
	<div id="notiMsg">
		서울시청 선택 후 직원 검색 시 전체부서 대상으로 검색됩니다.
	</div>
	<div id="deptList"></div>
</div>

<div class="popC right" style="width:50%">
	<div class="popSrchW">
		<input type="text" id="srchTxt2" placeholder="검색 할 직원명을 입력해주세요.">
	</div>
	<table class="pop_listTable" id="headTable" style="width:100%">
		<colgroup>
			<col style="width:*;">
			<col style="width:30%;">
			<col style="width:30%;">
		</colgroup>
		<tr>
			<th>부서</th>
			<th>직급</th>
			<th>이름</th>
		</tr>
	</table>
		
	<div class="popA" style="height:570px; max-height:900px;">
		<div class="popA" style="height:250px;">
			<table class="pop_listTable" id="emplist">
				<colgroup>
					<col style="width:*;">
					<col style="width:*;">
					<col style="width:40%;">
				</colgroup>
				<tr id="infoTr">
					<td colspan="3">부서명을 선택 해 주세요</td>
				</tr>
			</table>
		</div>
		
		<hr class="margin20">
		<strong class="popSTT" style="margin-left:10px;">선택 된 부서/직원</strong><p> ※ 변경내용은 저장 버튼을 눌러야 반영됩니다.</p>
		<div class="popA" style="height:245px;">
			<table class="pop_listTable" id="selList">
				<colgroup>
					<col style="width:*;">
					<col style="width:20%;">
				</colgroup>
				<tr>
					<th>부서명/직원명</th>
					<th></th>
				</tr>
			</table>
		</div>
	</div>
</div>

<hr class="margin40">
<div class="subBtnW center">
	<a href="#none" class="sBtn type1" onclick="goSave();"><i class="fa-regular fa-floppy-disk"></i> 저장</a>
</div>