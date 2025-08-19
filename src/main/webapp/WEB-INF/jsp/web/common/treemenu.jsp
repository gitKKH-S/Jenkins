<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018-12-30
  Time: 오후 5:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	Map<String,String> param = request.getAttribute("param")==null?new HashMap():(Map)request.getAttribute("param");
	String MENU_MNG_NO = param.get("MENU_MNG_NO")==null?"":param.get("MENU_MNG_NO");
	String MENU_SE_NM = param.get("MENU_SE_NM")==null?"":param.get("MENU_SE_NM");
	String smType = param.get("smType")==null?"":param.get("smType");
	System.out.println("MENU_SE_NM===>"+MENU_SE_NM);
	String rTitle = "";
	String cls = "";
	if(MENU_SE_NM.equals("LAW")){
		rTitle = "법률정보";
		cls = "icon_balance";
	}else if(MENU_SE_NM.equals("PAN")){
		rTitle = "소송";
		cls = "icon_justice";
	}else if(MENU_SE_NM.equals("COUNSEL")){
		rTitle = "자문";
		cls = "icon_meeting";
	}else if(MENU_SE_NM.equals("PDS")){
		rTitle = "자료실";
		cls = "icon_binder";
	}else if(MENU_SE_NM.equals("PDS2")){
		rTitle = "게시판";
		cls = "icon_noticeboard";
	}else if(MENU_SE_NM.equals("MAIN")){
		rTitle = "메인화면관리";
	}else if(MENU_SE_NM.equals("BYLAW")){
		rTitle = "현행 자치법규";
		if(smType.equals("recent")){
			rTitle = "최근 제/개정 자치법규";
		}
	}else if(MENU_SE_NM.equals("STS")){
		rTitle = "통계";
		cls = "icon_meeting";
	}else if(MENU_SE_NM.equals("WORK")){
		rTitle = "업무현황";
	}else if(MENU_SE_NM.equals("AGREE")){
		rTitle = "협약";
		cls = "icon_handshake";
	}else if(MENU_SE_NM.equals("CAL")){
		rTitle = "일정관리";
		//cls = "icon_handshake";
	}
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
%>
<link rel="stylesheet" type="text/css" href="${resourceUrl}/css/customtree.css">
<script>
var minus = 50;
<%
if(GRPCD.indexOf("Y")>-1 || GRPCD.indexOf("C")>-1 || GRPCD.indexOf("L")>-1 ||
	GRPCD.indexOf("G")>-1 || GRPCD.indexOf("B")>-1 || GRPCD.indexOf("D")>-1) {
%>
	minus = 420;
<%
}
%>
var menu_se_nm = '<%=MENU_SE_NM%>';
<%
	if(!MENU_SE_NM.equals("BYLAW") && !MENU_SE_NM.equals("WORK") && !MENU_SE_NM.equals("CAL")){ //일반화면 트리목록
%>
	Ext.onReady(function(){
		var Tree = Ext.tree;
		var tLoder = new Ext.tree.TreeLoader({
			dataUrl: '${pageContext.request.contextPath}/bylaw/menu/getWebNodes.do'
		});
		
		treeMM = new Tree.TreePanel({
			id:'treeMM', renderTo:'categoryL', useArrows: false, autoScroll: true,
			animate : true, enableDD: false, containerScroll: true, border: true,
			loader : tLoder, height:($(".categoryW").height()-minus),rootVisible: false,useArrows: true,
			root: {
				nodeType: 'async', text:'<%=rTitle%>', draggable:false, id: '<%=MENU_MNG_NO%>', cls:'<%=cls%>'
			},
			listeners: {
				click: function(node, e){
					if (menu_se_nm != 'AGREE') {
						if(node.attributes.FLDR_SE!='FOLDER'){
							if(node.attributes.URL_INFO_CN != 'N/A' && node.attributes.URL_INFO_CN){
								$("#pagenavi").text(node.attributes.PATH);
								$('#MENU_MNG_NO').val(node.id);
								$('#addParam1').val('');
								$('#addParam2').val('');
								$('#searchForm').val('');
								$('#addParam3').val('');
								var frm = document.pageT;
								frm.target="workPage";
								frm.action="${pageContext.request.contextPath}"+node.attributes.URL_INFO_CN;
								frm.submit();	
							}	
						}
					} else {
						if (node.id != '10000225') {
							if(node.attributes.URL_INFO_CN != 'N/A' && node.attributes.URL_INFO_CN){
								$("#pagenavi").text(node.attributes.PATH);
								$('#MENU_MNG_NO').val(node.id);
								$('#addParam1').val('');
								$('#addParam2').val('');
								$('#searchForm').val('');
								$('#addParam3').val('');
								var frm = document.pageT;
								frm.target="workPage";
								frm.action="${pageContext.request.contextPath}"+node.attributes.URL_INFO_CN;
								frm.submit();	
							}
						}
					}
				},
				render: function (treeMM) {
					var rootText = treeMM.getRootNode().attributes.text;
	                var rootCls = treeMM.getRootNode().attributes.cls;
	                $("#scatit").text(rootText);
	                if(rootText=='소송'){$("#tcls").addClass("ph-gavel");}
	                else if(rootText=='자문'){$("#tcls").addClass("ph-chat-text");}
	                else if(rootText=='협약'){$("#tcls").addClass("ph-pencil-simple-line");}
	                else if(rootText=='법률정보'){$("#tcls").addClass("ph-book-open");}
	                else if(rootText=='통계'){$("#tcls").addClass("ph-chart-line");}
	                else {$("#tcls").addClass("ph-note");}
	            }
			}
		});
	
		treeMM.expandAll();
		Ext.EventManager.onWindowResize(function(w, h){
			console.log("treemenu categoryW Height : " + $(".categoryW").height());
			treeMM.setHeight($(".categoryW").height()-minus);
		});
	});
<%
	}
%>
</script>
<style>
	.x-panel-body{
		border-color : #e7eaed;
		background-color : #e7eaed;
	}
	.x-tree-node-el{
		padding-bottom:3px;
	}
	
	.x-tree-node {
	    border-bottom: 1px solid #e0e0e0;
	}
	.x-tree-node-anchor {
	    text-decoration: none;
	    color: #333;
	}
	.x-tree-node-expanded .x-tree-node-anchor {
	    font-weight: bold;
	}
	.x-tree-selected .x-tree-node-anchor {
	    color: #0073e6;
	    font-weight: bold;
	}
	.x-tree-node-el {
	    padding: 4px;
	    font-size: 15px;
	    border-bottom: 1px solid #ddd;
	}
	.x-tree-node .x-tree-node-icon {
	    background-image: url(folder-icon.png) !important;  /* 직접 경로 설정 필요 */
	    background-repeat: no-repeat;
	    width: 16px;
	    height: 16px;
	}
		
</style>
<%
if(MENU_SE_NM.equals("BYLAW")){
%>
<ul class="categoryIW">
    <li style="width:50%"><a href="#" vo='htree' <%if(!smType.equals("recent")){out.println("class='active'");} %>><i class="far fa-clock"></i><span>현행 자치법규</span></a></li>
    <!--  
    <li><a href="#" vo='dtree'><i class="fas fa-sitemap"></i><span>부서별 자치법규</span></a></li>
	-->
	<li style="width:50%"><a href="#" vo='fav'><i class="fas fa-star"></i><span>즐겨찾는자치법규</span></a></li>
	<!--  
	<li><a href="#" vo='dsch'><i class="fas fa-search"></i><span>상세검색</span></a></li>
	-->
    <li style="width:50%"><a href="#" vo='recent' <%if(smType.equals("recent")){out.println("class='active'");} %>><i class="far fa-clock"></i><span>최근 제·개정</span></a></li>
    <li style="width:50%"><a href="#" vo='ctree'><i class="far fa-trash-alt"></i><span>폐지 자치법규</span></a></li>
</ul>
<%
}
%>
<div class="categoryL" id="categoryL">
	
</div>
