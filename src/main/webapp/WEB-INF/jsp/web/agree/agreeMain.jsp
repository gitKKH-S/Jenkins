<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	String url = "agreeList.jsp";
%>

<script type="text/javascript" src="<%=CONTEXTPATH %>/resources/jquery/js/jquery-1.8.3.js"></script>
<script type="text/javascript" src="<%=CONTEXTPATH %>/resources/jquery/js/jquery.number.js"></script>

<iframe id="frame" name="frame" src="<%=CONTEXTPATH%>/web/agree/goAgreeList.do" width="100%" height="100%" frameborder="0" scrolling="yes"></iframe>
