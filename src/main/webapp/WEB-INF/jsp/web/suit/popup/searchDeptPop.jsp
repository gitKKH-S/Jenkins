<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String cnt = request.getAttribute("CNT")==null?"":request.getAttribute("CNT").toString();
	String menu = request.getAttribute("menu")==null?"":request.getAttribute("menu").toString();
	String deptno = request.getAttribute("deptno")==null?"":request.getAttribute("deptno").toString();
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	String reviewid = request.getAttribute("reviewid")==null?"":request.getAttribute("reviewid").toString();
	System.out.println(cnt + "/" + menu);
%>
<style>
	th {text-align:center;}
</style>
<script type="text/javascript">
	var cnt = '<%=cnt%>';
	var menu = '<%=menu%>';
	var gbn = '<%=gbn%>';
	var deptno = '<%=deptno%>';
	
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		if (deptno != "" && deptno != '6110000') {
			goSelDeptUser(deptno, $("#srchTxt2").val());
		}
		
		var Tree = Ext.tree;
		var dLoder = new Ext.tree.TreeLoader({
			dataUrl: '${pageContext.request.contextPath}/web/suit/getDeptList.do'
		});
		
		var treeDD = new Tree.TreePanel({
			id:'treeDD', renderTo:'deptList', useArrows: false, autoScroll: true,
			animate : true, enableDD: false, containerScroll: true, border: true,
			loader : dLoder, height:775,
			root: {
				nodeType: 'async', text:'서울시청', draggable:false, id: '6110000', cls:'dept'
			},
			listeners: {
				click: function(node, e){
					$("#srchTxt2").val("");
					
					if (node.id != "6110000") {
						deptno = node.id+"";
						goSelDeptUser(node.id+"", $("#srchTxt2").val());
					} else {
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
	});
	
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
				html += "<td class=\"selTd\" id=\"deptnm\" onclick=\"goSelDeptUser('"+val.DEPT_NO+"', '"+$("#srchTxt2").val()+"')\">"+val.DEPT_NM+"</td>";
				html += "</tr>";
			});
		}else{
			html += "<tr><td>검색 결과가 없습니다.</td></tr>";
		}
		
		$("#deptlist").append(html);
	}
	
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
			$.each(data.result, function(index, val){
				html += "<tr class=\"userinfo\" onclick=\"selectUser('"+val.EMP_NO+"','"+val.EMP_NM+"','"+val.DEPT_NO+"','"+val.DEPT_NM+"','"+val.JBGD_CD+"', '"+val.JBGD_NM+"')\">";
				html += "<td>"+val.DEPT_NM+"</td>"; // JIKCHK NM
				html += "<td class=\"selTd\" id=\"usernm\">"+val.EMP_NM+"</td>"; // user nm
				html += "<td>"+val.JBGD_NM+"</td>"; // JIKCHK NM
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
	
	function selectUser(userid, usernm, sosokcd, sosoknm, jiknm, teamnm){
		if(menu == 'rel'){
			opener.document.getElementById("LWS_FLFMT_EMP_NO").value = userid;
			opener.document.getElementById("LWS_FLFMT_EMP_NM").value = usernm;
			opener.document.getElementById("LWS_FLFMT_DEPT_NO").value = sosokcd;
			opener.document.getElementById("LWS_FLFMT_DEPT_NM").value = sosoknm;
		} else if(menu == 'suit'){
			if (gbn == "A") {
				opener.document.getElementById("SPRVSN_EMP_NO").value = userid;
				opener.document.getElementById("SPRVSN_EMP_NM").value = usernm;
				opener.document.getElementById("SPRVSN_DEPT_NO").value = sosokcd;
				opener.document.getElementById("SPRVSN_DEPT_NM").value = sosoknm;
			} else {
				opener.document.getElementById("SPRVSN_TMLDR_NO").value = userid;
				opener.document.getElementById("SPRVSN_TMLDR_NM").value = usernm;
			}
		} else if(menu == 'comi'){
			opener.document.getElementById("usernm"+cnt).value = usernm;
			opener.document.getElementById("userid"+cnt).value = userid;
			opener.document.getElementById("jiknm"+cnt).value = jiknm;
			opener.document.getElementById("sosoknm"+cnt).value = sosoknm;
			opener.document.getElementById("sosokcd"+cnt).value = sosokcd;
			
			
			//opener.document.getElementById("comiInfo"+cnt).childNodes[0].childNodes[0].value = usernm;
			//opener.document.getElementById("comiInfo"+cnt).childNodes[0].childNodes[1].value = userid;
			//opener.document.getElementById("comiInfo"+cnt).childNodes[1].childNodes[0].value = jiknm;
			//opener.document.getElementById("comiInfo"+cnt).childNodes[2].childNodes[0].value = sosoknm;
			//opener.document.getElementById("comiInfo"+cnt).childNodes[2].childNodes[1].value = sosokcd;
			alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
			window.close();
		}
		alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
		window.close();
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
<strong class="popTT">
	관련부서 검색
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div class="popC left" style="width:40%">
	<div id="notiMsg">
		서울시청 선택 후 직원 검색 시 전체부서 대상으로 검색됩니다.
	</div>
	<div id="deptList"></div>
</div>
<div class="popC right" style="width:53%">
	<div class="popSrchW">
		<input type="text" id="srchTxt2" placeholder="검색 할 직원명을 입력해주세요.">
	</div>
	<table class="pop_listTable" id="headTable" style="width:100%">
		<colgroup>
			<col style="width:40%;">
			<col style="width:*;">
			<col style="width:40%;">
		</colgroup>
		<tr>
			<th>부서명</th>
			<th>이름</th>
			<th>직책명</th>
		</tr>
	</table>
		
	<div class="popA" style="height:695px; max-height:900px;">
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
</div>
