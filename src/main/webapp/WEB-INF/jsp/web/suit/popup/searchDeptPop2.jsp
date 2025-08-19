<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	String menu = request.getAttribute("menu")==null?"":request.getAttribute("menu").toString();
%>
<script type="text/javascript">
	
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
			loader : dLoder, height:620,
			root: {
				nodeType: 'async', text:'고양시', draggable:false, id: '39400000000', cls:'dept'
			},
			listeners: {
				click: function(node, e){
					// node.id로 해당 부서 직원 select
					if(node.id != "39400000000"){
						////// 채무 담당부서 직원단위 선택으로 변경
						if("<%=menu%>" == "bond" && node.attributes.GBN == "user"){
							//var getId = node.id;
							goSelect(node.id, node.text);
						}else{
							goSelect(node.id, node.text);
						}
					}
				}
			}
		});
		treeDD.getRootNode().expand();
		
		$(window).resize(function() {
			
		});
	});
	
	function goSelect(deptno, deptnm){
		
		var menu = "<%=menu%>";
		if(menu == "bond"){
			opener.document.getElementById("bonddeptno").value = deptno;
			opener.document.getElementById("bonddeptnm").value = deptnm;
			
			alert(deptnm + "이(가) 선택되었습니다.");
			window.close();
		}else{
			opener.document.getElementById("deptno").value = deptno;
			opener.document.getElementById("deptnm").value = deptnm;
			
			alert(deptnm + "이(가) 선택되었습니다.");
			window.close();
			
			
			if(menu == "criminal"){
				opener.document.getElementById("deptno").value = deptno;
				opener.document.getElementById("deptnm").value = deptnm;
				
				alert(deptnm + "이(가) 선택되었습니다.");
				window.close();
			}else{
				var i = $("#cnt").val();
				i++;
				$("#cnt").val(i);
				var html = "";
				html += "<tr id=\"tr"+i+"\"><td>"+deptnm+"<input type=\"hidden\" id=\"deptInfo"+i+"\" value=\""+deptnm+"\"/><input type=\"hidden\" id=\"deptcode"+i+"\" value=\""+deptno+"\"/></td>";
				html += "<td><a href=\"#\" class=\"innerBtn center\" onclick=\"goRemove("+i+")\">삭제</a></tr>";
				
				$("#deptSelList").append(html);
			}
		}
	}
</script>
<style>
	.popW{width:500; min-width:500px; height:100%}
	table th{text-align:center;}
	#schTxt{width:100%;}
</style>

<input type="hidden" id="cnt" value="0"/>
<strong class="popTT" style="width:500px;">
	부서 검색
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div class="popC" style="width:497; height:648px;">
	<div id="deptList"></div>
</div>