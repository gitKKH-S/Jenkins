<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.mif.serviceSch.*"%>
<%@ page import="java.util.*" %>
<%
	MifService se = MifServiceHelper.getMifService(application);
// 	se.setSuitOldData();
// 	se.setConsultOldData();
// 	se.setAgreeOldData();
	se.setConferenceOldData();

%>
