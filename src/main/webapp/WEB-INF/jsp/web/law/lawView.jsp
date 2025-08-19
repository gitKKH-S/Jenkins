<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%
	HashMap bonInfo = request.getAttribute("bonInfo")==null?new HashMap() : (HashMap)request.getAttribute("bonInfo");
%>
<link rel="stylesheet" href="${resourceUrl}/css/bonTop.css">
		<div class="lawbon" id="regulCont">
			<%=bonInfo.get("bon") %>
		</div>