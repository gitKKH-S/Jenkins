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
	
	<script type="text/javascript" src="${resourceUrl}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${resourceUrl}/extjs/ext-all.js"></script>
	<script type="text/javascript" src="${resourceUrl}/extjs/src/locale/ext-lang-ko.js"></script>
	<link rel="stylesheet" type="text/css" href="${resourceUrl}/extjs/resources/css/ext-all.css" />
	
    <script>
	Ext.BLANK_IMAGE_URL = "${resourceUrl}/extjs/resources/images/default/s.gif";
	</script>
</head>

<body>
	<tiles:insertAttribute name="content"/>
</body>
</html>