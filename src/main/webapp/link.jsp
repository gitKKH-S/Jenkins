<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import = "org.apache.commons.codec.binary.Base64" %>
<%
	String ipAddress=request.getRemoteAddr();
	System.out.println("클라이언트 IP 주소: "+ipAddress);
	String sso_id = session.getAttribute("sso_id")==null?"":session.getAttribute("sso_id").toString();
	sso_id = new String(Base64.encodeBase64(sso_id.getBytes()));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<style type="text/css">
* {
	font-family:  "돋움", "굴림";
	color: #333;
	margin:0px;
	padding:0px;
}
#logo {
	margin: 0 0 10px 0;
	border-bottom:#CCC 1px solid;
}
UL LI {
	font-size:14px;
	list-style-type:none;
}
LI {
	margin:5px 0 3px 25px;
}
A {
	text-decoration:none;
	color:#06C;
}
A:hover {
	text-decoration:underline;
	color:#339;
}
</style>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">   
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.js" type="text/javascript"></script>
<script>
	function goLogin(){
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/login/noSSO.do",
			data : {
				userid:'<%=sso_id%>'
			},
			dataType: "json",
			async: false,
			
			success : function(data) {
				var jdata = data.loginyn;
				if(jdata == 'N'){
					location.href="sso_error2.jsp";
				}else{
					location.href = "<%=CONTEXTPATH %>/web/index.do";
				}
			}
		});
	}
	goLogin();
</script>
</head>
<body>
</body>
</html>
