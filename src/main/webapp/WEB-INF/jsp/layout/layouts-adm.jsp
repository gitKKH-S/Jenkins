<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html lang="ko">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
	<meta http-eqiv="Content-Type" content="text/html"; charset="UTF-8">
	<meta name="robots" content="noindex, nofollow">
	<title><%=SYSTITLE %></title>
	<script src="${resourceUrl}/js/mten.static.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.js" type="text/javascript"></script>
	<script src="${resourceUrl}/js/CryptoJSv3.1.2/crypto-js.min.js"></script>
	<script src="${resourceUrl}/js/mten.session.js" type="text/javascript"></script>
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/ext-all-debug.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/src/locale/ext-lang-ko.js"></script>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/css/ext-all.css" />
	
    <script>
	Ext.BLANK_IMAGE_URL = "${pageContext.request.contextPath}/webjars/extjs/3.4.1.1/resources/images/default/s.gif";
	</script>
    <script src="${resourceUrl}/appjs/common/topMenu.js" type="text/javascript"></script>
    <link href="${resourceUrl}/css/bylaw/topMenu.css" rel="stylesheet" type="text/css">
	<style type="text/css">
		body {
			scrollbar-shadow-color: #FFFFFF;
			scrollbar-highlight-color: #FFFFFF;
			scrollbar-face-color: #9EBFEB;
			scrollbar-3dlight-color:  #9EBFEB;
			scrollbar-darkshadow-color:  #9EBFEB;
			scrollbar-track-color: #FFFFFF;
			scrollbar-arrow-color: #FFFFFF;
		}
	</style>
</head>

<body class="admin_css">
	<div id="message" style="position:absolute;left:0;top:500;visibility:visible;z-index:2"></div>
	<div id="topMenuHolder">
		<%@include file="/WEB-INF/jsp/bylaw/commonjs/adminTop.jsp"%>
		<div id="topMenu"></div>
	</div>
	<div>
	<tiles:insertAttribute name="content"/>
	</div>
</body>
</html>