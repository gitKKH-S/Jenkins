<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.uportal.UPSA.common.Util.*"%>
<%@ page import="com.uportal.UPSA.sso.client.*"%>
<%
String exceptionMessage = request.getParameter("msg");

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />
<style type="text/css">
.lang_selec_top
	{font-size:9pt;font-family:"Tahoma,MS PGothic,Dotum"}
	
.notice{FONT-SIZE: 9pt;COLOR: #000000; FONT-FAMILY: Tahoma,MS PGothic,Dotum; TEXT-DECORATION: none;}
.notice A:link {FONT-SIZE: 9pt;COLOR: #000000; FONT-FAMILY: Tahoma,MS PGothic,Dotum; TEXT-DECORATION: none;}
.notice A:visited {FONT-SIZE: 9pt;COLOR: #000000; FONT-FAMILY: Tahoma,MS PGothic,Dotum; TEXT-DECORATION: none;}
.notice A:active {FONT-SIZE: 9pt;COLOR: #000000; FONT-FAMILY: Tahoma,MS PGothic,Dotum; TEXT-DECORATION: none;}
.notice A:hover {FONT-SIZE: 9pt;COLOR: #f26522; FONT-FAMILY: Tahoma,MS PGothic,Dotum; TEXT-DECORATION: none;}

.login_input{background-color:#FFFFFF;border:1px solid #c9c9c9;font-size:9pt;FONT-FAMILY: Dotum,Tahoma; color:#000; width:150px;height:21px;padding : 2px;vertical-align:middle;}

.tx_black_s{font-size:11px; COLOR: #000; FONT-FAMILY: Dotum,Tahoma;}

</style>
<title>ERROR</title>

</head>
<body style="background-repeat:repeat-x; background-position: center" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0">
	<tr valign="middle">
	  <td valign="middle"><table border="0" style="height:250" align="center" cellpadding="10" cellspacing="0">
        <tr>
           <td bgcolor="#FFFFFF" width="700" align="center" style="position:fixed;background-image:url(./err_pro2.gif);background-repeat:no-repeat;border:2px solid #e1e1e1">
			<div style="padding-left:150px;padding-top:50px;text-align:left">
				<font color=red><%=exceptionMessage%></font>
			</div>
		  </td>
        </tr>
        
        </table>
	  </td>
	</tr>
</table>
</body>
</html>
