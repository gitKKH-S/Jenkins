<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String userid = (String)session.getAttribute("userid");

	out.println("userid :::: " + userid );
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
 <HEAD>
  <meta charset="EUC-KR">
  <TITLE> New Document </TITLE>
 </HEAD>

 <BODY>
  <form name="form1" method="post" >
	<INPUT TYPE="text" NAME="userid" value="<%=userid%>" >
  </form>
 </BODY>
</HTML>
