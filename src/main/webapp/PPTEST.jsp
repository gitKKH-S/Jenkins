<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import = "org.apache.commons.codec.binary.Base64" %>
<%
	String ipAddress=request.getRemoteAddr();
	System.out.println("클라이언트 IP 주소: "+ipAddress);
	ipAddress = "211.187.234.227";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">   
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.js" type="text/javascript"></script>
</head>

<form id = "test" name="test" method="post" enctype="multipart/form-data" action="https://api194.eseoul.go.kr:5443/UPServer/">
	<input type="hidden" name="hostIP" value="115.84.165.44"/>
	<input type="hidden" name="hostUrl" value="http://115.84.165.44:8080/PPTEST.jsp"/>
	<input type="hidden" name="userIP" value="<%=ipAddress%>"/>
	<input id="text1" type="textarea" rows="5" cols="30"  name="content"></textarea><br>
<input id="text2" type="text" name="content2"/><br>
<input id="text3" type="text" name="content3"/><br>
<input id="text4" type="text" name="content4"/><br>
<input type="file" name="file1"/><br>
<input type="submit" name="등록" />
</form>
