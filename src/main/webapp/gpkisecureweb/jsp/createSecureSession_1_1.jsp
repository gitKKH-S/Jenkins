<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.*" %>
<%@ include file="./gpkisecureweb.jsp" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>
<%
	System.out.println("1111");
	String challenge = gpkiresponse.getChallenge();
	System.out.println("11112222");
	String sessionid = gpkirequest.getSession().getId();
	System.out.println("11113333");
	String url = javax.servlet.http.HttpUtils.getRequestURL(request).toString();
	System.out.println("11114444"+url);
	session.setAttribute("currentpage",url);
	System.out.println("111155555");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!--기본css-->
	<link rel="stylesheet" type="text/css" href="../css/common.css">
	<link rel="stylesheet" type="text/css" href="../css/layout.css">
	<link rel="stylesheet" type="text/css" href="../css/sub.css">
    <link rel="stylesheet" type="text/css" href="../css/form_modern.css">
	
	<title>GPKI 사용자용 표준보안API</title>
	<jsp:include page="header.jsp"></jsp:include>
	<script type="text/javascript">
		// 가상 키보드 사용을 위한 보안 세션 초기화
		initSecureSession();
	</script>
</head>
<body>
    <div id="container">
        <div class="loginW">
            <div class="loginC">
                <h1>법률지원통합시스템 GPKI</h1>
                <div class="loginB">
					<form action="./createSecureSession_1_1_response.jsp" method="post" name="popForm">
						<div class="login_ic"><i class="ph-bold ph-user"></i></div>
						<strong>인증서 로그인</strong>
						<input type="hidden" name="param01" />
						<input type="hidden" name="param02" />
						<input type="hidden" name="param03" />
						<input type="hidden" name="ssn" />
						<input disable type="text" name="challenge" value="<%=challenge%>" />
						<input type="hidden" name="sessionid" id="sessionid" value="<%=sessionid%>" />
						<button type="button" name="button" onclick="Login(this,popForm, false);">로그인<span>보안 세션 요청</span></button>
					</form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

