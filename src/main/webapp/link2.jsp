<%@ page language="java"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JAVA SSO test </title>
</head>
<body>
<!--<table width="500" cellpadding="0" border="0" cellspacing="0"  style="BORDER-TOP: solid 2px #BBB;">
<tr>
	<td bgcolor="#f3f3f3" style="BORDER-BOTTOM: solid 1px #eaeaea;">포털 세션 필드명</td>
	<td bgcolor="#f3f3f3" style="BORDER-BOTTOM: solid 1px #eaeaea;">연계 시스템 세션명</td>
</tr>
<tr>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">USERID</td>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">userid</td>
</tr>
<tr>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">USERNAME</td>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">username</td>
</tr>
<tr>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">DEPTNAME</td>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">dname</td>
</tr>
<tr>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">DEPTID</td>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">dcode</td>
</tr>
<tr>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">DEPTFULLNAME</td>
	<td style="BORDER-BOTTOM: solid 1px #eaeaea; PADDING : 0 10px 0 10px">dfullname</td>
</tr>
</table>-->
</br>
<p>
sso_id=<%= session.getAttribute("sso_id") %></br>
sso_nm=<%= session.getAttribute("sso_nm") %></br>
sso_dept_cd=<%= session.getAttribute("sso_dept_cd") %></br>
sso_dept_nm=<%= session.getAttribute("sso_dept_nm") %></br>
sso_dept_full_nm=<%= session.getAttribute("sso_dept_full_nm") %></br>
sso_jbgd_cd=<%= session.getAttribute("sso_jbgd_cd") %></br>
sso_jbgd_nm=<%= session.getAttribute("sso_jbgd_nm") %></br>
</p>
</body>
</html>
