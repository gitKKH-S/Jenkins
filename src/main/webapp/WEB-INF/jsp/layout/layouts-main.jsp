<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018-12-30
  Time: 오후 5:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!doctype html>
<html lang="ko">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
	<title><%=SYSTITLE %></title>
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/${DMI}/css/main.css">
	<tiles:insertAttribute name="meta"/>
	<link rel="icon" type="image/ico" href="${resourceUrl}/mten.ico"/>
</head>
<style>
	.logoW{cursor:pointer;}
</style>

<body>
<div id="container">
	<tiles:insertAttribute name="topmenu"/>
	<div class="mainW">
		<tiles:insertAttribute name="content"/>
	</div>
	<tiles:insertAttribute name="footer"/>
</div>
</body>
</html>