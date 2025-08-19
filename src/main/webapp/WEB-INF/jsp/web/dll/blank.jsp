<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.util.*" %>

<%
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	if(gbn.equals("xml")){
		out.println(request.getAttribute("body").toString());
	}else{
		out.println(request.getAttribute("body").toString());	
	}
	
%>