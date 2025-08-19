<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String cnt = request.getAttribute("CNT")==null?"":request.getAttribute("CNT").toString();
	String menu = request.getAttribute("menu")==null?"":request.getAttribute("menu").toString();
	String deptno = request.getAttribute("deptno")==null?"":request.getAttribute("deptno").toString();
	String reviewid = request.getAttribute("reviewid")==null?"":request.getAttribute("reviewid").toString();
	System.out.println(cnt + "/" + menu);
%>
<script type="text/javascript">
	var cnt = '<%=cnt%>';
	var menu = '<%=menu%>';
	var deptno = '<%=deptno%>';
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	Ext.QuickTips.init();
	Ext.onReady(function(){
		var Tree = Ext.tree;
		var dLoder = new Ext.tree.TreeLoader({
			dataUrl: '${pageContext.request.contextPath}/web/consult/getDeptList.do'
		});
		
		var treeDD = new Tree.TreePanel({
			id:'treeDD', renderTo:'deptList', useArrows: false, autoScroll: true,
			animate : true, enableDD: false, containerScroll: true, border: true,
			loader : dLoder, height:755,
			root: {
				nodeType: 'async', text:'서울시청', draggable:false, id: '6110000', cls:'dept'
			},
			listeners: {
				click: function(node, e){
					$("#srchTxt2").val("");
					deptno = node.id+"";
					goSelDeptUser(node.id+"", $("#srchTxt2").val());
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
				goSelDeptUser("" , $(this).val());
			}
		});
	});
	
	function getDept(){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/selectDeptList.do",
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
			url:"${pageContext.request.contextPath}/web/consult/selectUserList.do",
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
				html += "<tr class=\"userinfo\">";
				html += "<td>"+val.DEPT_NM+"</td>"; // JIKCHK NM
				html += "<td class=\"selTd\" id=\"usernm\" onclick=\"selectUser('"+val.EMP_NO+"','"+val.EMP_NM+"','"+val.DEPT_NO+"','"+val.DEPT_NM+"','"+val.JBGD_CD+"', '"+val.JBGD_NM+"')\">"+val.EMP_NM+"</td>"; // user nm
				html += "<td>"+val.JBGD_NM+"</td>"; // JIKCHK NM
				html += "</tr>";
			});
		}else{
			html += "<tr class=\"userinfo\"><td colspan=\"3\">검색 결과가 없습니다.</td></tr>";
		}
		$("#emplist").append(html);
	}
	
	function selectUser(userid, usernm, sosokcd, sosoknm, jiknm, teamnm){
		if(menu == 'consult'){
			opener.document.getElementById("empno").value = userid;
			opener.document.getElementById("empnm").value = usernm;
			opener.document.getElementById("deptno").value = sosokcd;
			opener.document.getElementById("deptnm").value = sosoknm;
			alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
			window.close();
		}else if(menu == 'rel'){
			opener.document.getElementById("LWS_FLFMT_EMP_NO").value = userid;
			opener.document.getElementById("LWS_FLFMT_EMP_NM").value = usernm;
			opener.document.getElementById("LWS_FLFMT_DEPT_NO").value = sosokcd;
			opener.document.getElementById("LWS_FLFMT_DEPT_NM").value = sosoknm;
			alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
			window.close();
		}else if(menu == 'criminal'){
			opener.document.getElementById("executeno").value = userid;
			opener.document.getElementById("executenm").value = usernm;
			alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
			window.close();
		}else if(menu == 'comi'){
			opener.document.getElementById("comiInfo"+cnt).childNodes[0].childNodes[0].value = usernm;
			opener.document.getElementById("comiInfo"+cnt).childNodes[0].childNodes[1].value = userid;
			opener.document.getElementById("comiInfo"+cnt).childNodes[1].childNodes[0].value = jiknm;
			opener.document.getElementById("comiInfo"+cnt).childNodes[2].childNodes[0].value = sosoknm;
			opener.document.getElementById("comiInfo"+cnt).childNodes[2].childNodes[1].value = sosokcd;
			alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
			window.close();
		}else if(menu == "bond"){
			opener.document.getElementById("bondempno").value = userid;
			opener.document.getElementById("bondempnm").value = usernm;
			opener.document.getElementById("WRT_DEPT_NO").value = sosokcd;
			opener.document.getElementById("WRT_DEPT_NM").value = sosoknm;
			window.close();
		}else if(menu == 'review'){
			var reviewid = "<%=reviewid%>";
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/reviewUserUpdate.do",
				data: {reviewid:reviewid, userid:userid, usernm:usernm, sosokcd:sosokcd, sosoknm:sosoknm},
				dataType:"json",
				async:false,
				success:function(result){
					alert("선택 한 직원으로 의뢰인이 변경되었습니다.");
					opener.goReload();
					window.close();
				}
			});
		}else if(menu == 'verAd1'){
			opener.document.getElementById("cnstn_rqst_emp_no").value = userid;
			opener.document.getElementById("cnstn_rqst_emp_nm").value = usernm;
			opener.document.getElementById("cnstn_rqst_dept_no").value = sosokcd;
			opener.document.getElementById("cnstn_rqst_dept_nm").value = sosoknm;
			alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
			window.close();
		
		}else if(menu == 'verAd2'){
			opener.document.getElementById("cnstn_tkcg_emp_no").value = userid;
			opener.document.getElementById("cnstn_tkcg_emp_nm").value = usernm;
// 			opener.document.getElementById("deptno").value = sosokcd;
// 			opener.document.getElementById("deptnm").value = sosoknm;
			alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
			window.close();
		
		}else{
			var empno = "empno"+cnt;
			var empnm = "empnm"+cnt;
			var deptno = "deptno"+cnt;
			var deptnm = "deptnm"+cnt;
			opener.document.getElementById(empno).value = userid;
			opener.document.getElementById(empnm).value = usernm;
			opener.document.getElementById(deptno).value = sosokcd;
			opener.document.getElementById(deptnm).value = sosoknm;
			alert(usernm + "("+sosoknm+")" + "이(가) 선택되었습니다.");
			window.close();
		}
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
</style>
<strong class="popTT">
	관련부서 검색
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div class="popC left" style="width:37.5%">
	<div id="deptList"></div>
</div>
<div class="popC right" style="width:55%">
	<div class="popSrchW">
		<input type="text" id="srchTxt2" placeholder="검색 할 직원명을 입력해주세요">
	</div>
	<div class="popA" style="height:962px;">
		<table class="pop_listTable" id="emplist">
			<colgroup>
				<col style="width:*;">
				<col style="width:*;">
				<col style="width:40%;">
			</colgroup>
			<tr>
				<th>팀명</th>
				<th>이름</th>
				<th>직책명</th>
			</tr>
			<tr id="infoTr">
				<td colspan="3">부서명을 선택 해 주세요</td>
			</tr>
		</table>
	</div>
</div>
