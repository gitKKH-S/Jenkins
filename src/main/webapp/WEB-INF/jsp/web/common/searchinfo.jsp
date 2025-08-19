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
	String stxt = request.getParameter("stxt")==null?"":request.getParameter("stxt");

	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
%>
<script>
	$(document).ready(function(){
		$("#allDown").click(function(){
			var cw=630;
			var ch=650;
			var sw=screen.availWidth;
			var sh=screen.availHeight;
			var px=(sw-cw)/2;
			var py=(sh-ch)/2;
			var property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=no,resizable=no,status=no,toolbar=no,location=no";
			var openWin = window.open("${pageContext.request.contextPath}/bylaw/cdmake/mtree.do", "allDown", property);
			openWin.focus();
		});
		
		$("#schBtn").click(function(){
			var frm = document.sform;
			frm.stxt.value = $("#txSimpleSearch1").val();
			frm.submit();
		});
		
	});
</script>
<form name="sform" action="${pageContext.request.contextPath}/web/search.do" method="post">
<input type="hidden" name="stxt">
</form>
		<div class="topW">
			<h2>고양시 법무행정통합지원시스템</h2>
			<div class="srchW">
				<div class="srchC">
					<!-- <input type="text" placeholder="검색어를 입력하세요"> -->
					<input type="text" placeholder="검색어를 입력하세요" id="txSimpleSearch1" name="pQuery_tmp" value="<%=stxt%>">
					<a href="#" id="schBtn" class="srchBtn">검색</a>
				</div>
				<div class="topBtnW">
					<a href="#" id="allDown" class="topBtn download">규정일괄다운로드</a>
					<a href="${pageContext.request.contextPath}/resources/edit/mtenViewer.exe" class="topBtn download">뷰어다운로드</a>
					<%
						if(GRPCD.indexOf("Y")>-1||GRPCD.indexOf("J")>-1||GRPCD.indexOf("C")>-1){
					%>
					<a href="${pageContext.request.contextPath}/bylaw/adm/mainLayout2.do" class="topBtn admin">관리자</a>
					<%
						}
					%>
				</div>
			</div>
		</div>