<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.mif.serviceSch.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.*" %>
<%@ page import="com.mten.bylaw.mif.serviceSch.MifService" %>
<%
/* 
	Calendar cal = Calendar.getInstance();
	DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	Date makecasedt = null;
	makecasedt = df.parse("2021-02-04");
	System.out.println(makecasedt);
	cal.setTime(makecasedt);
	cal.add(Calendar.DATE, 10);
	System.out.println(df.format(cal.getTime()));
*/
	MifService service = MifServiceHelper.getMifService(application);
	//service.smsSendTest();
	
	//service.setInsaInfo();

	service.deleteSuitFile();
%>
