<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String consultid = request.getAttribute("consultid")==null?"":(String)request.getAttribute("consultid");
	String chggbn = request.getAttribute("chggbn")==null?"":(String)request.getAttribute("chggbn");	//chrgempInfo,writerInfo
%>
<script type="text/javascript">
	var consultid = "<%=consultid%>";
	var chggbn = "<%=chggbn%>";
	
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
			loader : dLoder, height:755,
			root: {
				nodeType: 'async', text:'고양시', draggable:false, id: '39400000000', cls:'dept'
			},
			listeners: {
				click: function(node, e){
					// node.id로 해당 부서 직원 select
					if(node.id != "39400000000"){
						//var getId = node.id;
						getUserList(node.id, node.text);
					}
				}
				/* ,
				dblclick : function(node, e){
					console.log(node);
					if(node.childNodes.length > 0){
						for(var i=0; i<node.childNodes.length; i++){
							setSelInfo(node.childNodes[i].id, node.childNodes[i].text, 'D');
						}
					}else{
						setSelInfo(node.id, node.text, 'D');
					}
				} */
			}
		});
		treeDD.getRootNode().expand();
		
		$(window).resize(function() {
			
		});
	});
	
	
	$(document).ready(function(){
		$("#loading").hide();
		
		$("#srchTxt2").keyup(function(){
			var k = $(this).val();
			$("#emplist > tbody > .userinfo").hide();
			var temp = $("#emplist > tbody > .userinfo > #usernm:nth-child(3n+1):contains('" + k + "')");
			$(temp).parent().show();
		});
	});
	
	function setSelInfo(id, name, gbn){
		var ucnt = $("#ucnt").val();
		if(ucnt==0){
			var html = "<tr id=\"usel"+ucnt+"\">";
			html += "<td>"+name;
			html += "<input type=\"hidden\" id=\"seluser"+ucnt+"\" value=\""+id+"\">";
			html += "</td>";
			html += "<td>";
			html += "<a href=\"#none\" class=\"innerBtn\" onclick=\"selDel('"+ucnt+"','U')\">삭제</a>";
			html += "</td></tr>";
			$("#selList").append(html);
			ucnt++;	
		}else{
			alert('직원선택은 한명만 가능합니다. 선택된 직원을 삭제해주시기 바랍니다.');
		}	
		$("#ucnt").val(ucnt);
	}
	
	function selDel(cnt, gbn){
		$("#usel"+cnt).remove();
		$("#ucnt").val(0);
	}
	
	function goSave(){
		var ucnt = $("#ucnt").val();
		var selUser = "";
		
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
		
		$("#chkUser").val(selUser);
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/chgUserSetting.do",
			data:$('#frm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.data.msg);
				opener.gotoview();
				window.close();
			}
		});
	}
	

	function getUserList(id, name){
		$("#infoTr").remove();
		$(".userinfo").remove();
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/selectUserList.do",
			data: {"sosokcd":id},
			dataType:"json",
			async:false,
			success:function(result){
				var html = "";
				if(result.result.length > 0){
					$.each(result.result, function(index, val){
						html += "<tr class=\"userinfo\" onclick=\"setSelInfo('"+val.USER_ID+"','"+val.USER_NM+"','P')\">";
						html += "<td class=\"selTd\" id=\"usernm\">"+val.USER_NM+"</td>"; // user nm
						html += "<td>"+val.CALL_CD+"</td>";
						html += "<td>"+val.SOSOK_NM+"</td>";
						html += "</tr>";
					});
				}else{
					html += "<tr class=\"userinfo\"><td colspan=\"3\">검색 결과가 없습니다.</td></tr>";
				}
				$("#emplist").append(html);
			}
		});
	}
</script>
<style>
	#srchTxt1{width:90%; height:30px; line-height:0px; margin-top:3px;}
	#srchTxt2{width:90%; height:30px; line-height:0px; margin-top:3px;}
	.popW{height:100%}
	#hidden{display:none;}
	/* 
	.selTd{cursor:pointer;}
	.selTd:hover{color:blue;}
	 */
	
	.userinfo{cursor:pointer;}
	.userinfo:hover{background:#BDBDBD;}
	
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
	table { border-collapse: collapse; border-spacing: 0; table-layout: fixed; word-break: break-all; width:100% }
</style>
<form name="frm" id=frm method="post" action="">
	<input type="hidden" name="consultid"   id="consultid"   value="<%=consultid%>" />
	<input type="hidden" name="chggbn"   id="chggbn"   value="<%=chggbn%>" />
	
	<input type="hidden" name="chkUser" id="chkUser" value="" />
	
	<input type="hidden" name="ucnt" id="ucnt" value="0"/>
</form>
<strong class="popTT">
	담당자 변경
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div>
	<div id="loading" class="loading"><img id="loading_img" alt="loading" src="${resourceUrl}/paramquery-3.3.2/images/loading.gif" /></div>
	<div class="popC left" style="width:40%">
		<div id="deptList"></div>
	</div>
	<div class="popC right" style="width:60%">
		<div class="popSrchW">
			<input type="text" id="srchTxt2" placeholder="검색 할 직원명을 입력해주세요">
		</div>
		<div class="popA" style="height:310px;">
			<table class="pop_listTable" id="emplist">
				<colgroup>
					<!-- <col style="width:14%;"> -->
					<col style="width:30%;">
					<col style="width:*;">
					<col style="width:30%;">
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
		<strong class="popSTT" style="margin-left:10px;">선택 된 부서/직원</strong><p> ※ 변경내용은 저장 버튼을 눌러야 반영됩니다.</p>
		<div class="popA" style="height:310px;">
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
	<hr class="margin40">
	<div class="subBtnW center">
		<a href="#none" class="sBtn type1" onclick="goSave();">저장</a>
	</div>
</div>