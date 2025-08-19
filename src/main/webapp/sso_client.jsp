<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.uportal.UPSA.common.Util.*"%>
<%@ page import="com.uportal.UPSA.sso.client.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>SSO Client</title>
</head>
<body>
<%
response.setHeader("P3P","CP='CAO PSA CONi OTR OUR DEM ONL'");   /* 통합검색 결과 URL 연계 관련 추가(frame 사용 관련) 20180802 */
String str = request.getParameter("SSO");
String SSO_PARAM = "";
String PARAMS = "";
String URL_PARAM = ""; /* 통합검색 결과 URL 연계 관련 추가 20180802 */

if(str.equals("")){
	%>
	<script>
	location.href="sso_error.jsp?msg=잘못된 접근입니다.";
	</script>
<%
	return;
}
try{
	SSOClient sso = new SSOClient();
	sso.setGpkiHome("/home/legal/legalb/gpkisecureqweb/WEB-INF/conf","sso_client.properties");

	String url = sso.getURL();

	if(sso.parseSSOMessage(str)){
		// SSO 파싱이 제대로 되면
		String fields = sso.getFields();

		ArrayList arr_field =  ImStringUtil.stringTokenize(fields,"[.]");
		for(int i=0;i<arr_field.size();i++){
			String sItem = (String)arr_field.get(i);
		
			ArrayList arr_item =  ImStringUtil.stringTokenize(sItem,"[$]");
			if(arr_item.size() > 1){
				String name = (String)arr_item.get(0);
				String value = (String)arr_item.get(1);

				if(name.equals("SSO_PARAM")){
					SSO_PARAM = value;
				}else if(name.equals("PARAMS")){
					PARAMS = value;
				}/* 통합검색 결과 URL 연계 관련 추가 20180802 */
				else if(name.equals("URL_PARAM")){
					URL_PARAM = value;
					URL_PARAM = URL_PARAM.relpaceAll("||","&");
				}
				
				session.setAttribute(name,value);
			}
		}

		session.setAttribute("MappingCode",sso.getMappingCode());

		if(!SSO_PARAM.equals("")){
			url = SSO_PARAM;
		}
	
		/* 통합검색 결과 URL 연계 관련 추가 20180802 */
		if(!URL_PARAM.equals("")){
			url = URL_PARAM;
		}

		if(!PARAMS.equals("")){
			int n = url.indexOf("?");
			if(n < 0){
				url += "?" + PARAMS;
			}else{
				url += "&" + PARAMS;
			}
		}

		session.setMaxInactiveInterval( 1 * 60 * 60 );	// 1시간 동안 세션을 유지한다.
	%>
				<script>
				location.href="<%= url%>";
				</script>
				<%
	}else{
					%>
				<script>
				location.href="sso_error.jsp?msg=<%= sso.getError() %>";
				</script>
				<%

	}	
}catch(Exception ex){
	%>
				<script>
				location.href="sso_error.jsp?msg=<%= ex.getMessage() %>";
				</script>
	<%
}


%>
</body>
</html>
