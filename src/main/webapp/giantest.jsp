<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.gian.service.*" %>
<%@ page import="java.util.*" %>
<%
	GianService service = GianServiceHelper.getGianService(application);
	service.testGian("/data/goyang/dataFile/receive/sunnyeMOS0003doc394000001ADM3940000682021082417002563258.xml", "sunnyeMOS0003doc394000001ADM3940000682021082417002563258.xml");
%>
