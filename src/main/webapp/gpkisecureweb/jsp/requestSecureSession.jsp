<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.*" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>
<%@ include file="./gpkisecureweb.jsp" %>
<%
	String challenge = gpkiresponse.getChallenge();
	String sessionid = request.getParameter("rnd");
	if (sessionid != null) sessionid.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","").replaceAll("\r|\n|&nbsp;","");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
	<title>GPKI 사용자용 표준보안API</title>
	<jsp:include page="header.jsp"></jsp:include>
</head>

<body>
	<form name="secureSession" action="./responseSecureSession.jsp" method="post">
		<input type="text" name="challenge" width="300px" value="<%=challenge%>" disabled/><br/>
		<input type="hidden" name="sessionid" value="<%=sessionid%>"/>
	</form>
	<script type="text/javascript">
		function bar(arg){};
		function EnvelopedDataII(form)
		{
			GPKIClientJS.Init();

			GPKIClientJS.SetProperty(2, ServerCert);
			GPKIClientJS.SetProperty(3, 3);
			GPKIClientJS.SetProperty(4, 4);

			//0:system default, 1:KSC5601,MS949,EUC-KR, 2: UTF8
			GPKIClientJS.setServerEncoding(2); // 서버 인코딩 지정 
			GPKIClientJS.setClientEncoding(2); // 클라이언트 인코딩 지정
			
			var strData;
			var nResult;
			var strReturnData;
			var strSendData; 
			strData = GPKISubmit(form);
	
			var sessionID = "";
			if( form.sessionid.value != null)
				sessionID = form.sessionid.value;

			if( GPKIClientJS.SetSessionID(sessionID) != 0) {
				return;
			}

			var sSiteID = SiteID+sessionID;
			
			GPKIClientJS.EnvelopData(sSiteID, strData, function(result){
				nResult = result.code;
				strReturnData = result.message;
				
				if( nResult == 0 ) {
					//alert("EnvelopData success");
					document.gpkiForm.encryptedData.value = strReturnData;
					document.gpkiForm.method = form.method;
					document.gpkiForm.action = form.action;
					document.gpkiForm.submit();	
				} else {
					if( nResult != 106)
						alert(strReturnData);
				}
				
			});
		}
		EnvelopedDataII(secureSession);
	</script>
</html>
