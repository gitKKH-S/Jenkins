<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import = "org.apache.commons.codec.binary.Base64" %>
<%
	String ipAddress=request.getRemoteAddr();
	System.out.println("클라이언트 IP 주소: "+ipAddress);
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
	function goLogin(userid,pw){
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/login/noSSO.do",
			data : {
				userid:userid
			},
		//	processData : true,
		//	contentType:"application/json; charset=UTF-8",
			dataType: "json",
			async: false,
			
			success : function(data) {
				var jdata = data.loginyn;
				if(jdata == 'N'){
					alert(data.msg);	
				}else{
					location.href = "<%=CONTEXTPATH %>/web/index.do";	
				}
			}
		});
	}
</script>
</head>
<body>
<%
	//if("211.114.22.80".equals(ipAddress) || "211.187.234.227".equals(ipAddress)){
%>
<div id="logo" style="padding:20px;text-align:center;">
<img src="<%=CONTEXTPATH %>/jsp/lkms3/images/main/logo.png">
</div>
<div id="selUserLevel">
<ul>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("mten".getBytes()))%>','1111')">전체관리자 (개발자 전용)</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F86168e75e9a9".getBytes()))%>','1111')">권경희 법률지원담당관(과장님권한)</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F75c4cc6da799".getBytes()))%>','1111')">정숙영 주무관(법률고문담당권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F92f7042ee9b1".getBytes()))%>','1111')">김소은 주무관(자문료·인지대·송달료권한)</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F68084933608b".getBytes()))%>','1111')">진영주 송무1팀장(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("D793fb94782fa".getBytes()))%>','1111')">김윤선 법률전문관(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("M61bf4e40d8d6".getBytes()))%>','1111')">기세룡 법률전문관(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F8202b6d64dc6".getBytes()))%>','1111')">박혜란 법률전문관(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F8965d9d5cd3c".getBytes()))%>','1111')">이현정 법률전문관(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("M902712f675ad".getBytes()))%>','1111')">노선덕 법률전문관(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("M91356df1e8ae".getBytes()))%>','1111')">송성현 주무관(소장접수·소송비용권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F936c6a819f1f".getBytes()))%>','1111')">이다현 주무관(일반사용자)</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F89dd2e58f034".getBytes()))%>','1111')">서  려 송무2팀장(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F83b1e7e2d27d".getBytes()))%>','1111')">이보배 법률전문관(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("D854de9dd8c03".getBytes()))%>','1111')">박언지 법률전문관(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F930c2cb8ba5c".getBytes()))%>','1111')">이예진 법률전문관(소송관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("M81850946ba78".getBytes()))%>','1111')">박찬우 주무관(자문접수권한, 협약접수권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("M96621a773ffa".getBytes()))%>','1111')">강상훈 주무관(소송비용회수권한)</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F84032cd79445".getBytes()))%>','1111')">김영란 법률자문팀장(자문관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("D82f0b0559b1c".getBytes()))%>','1111')">박희제 법률전문관(자문관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F88b1ec63c035".getBytes()))%>','1111')">김수산나 법률전문관(자문관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F86d05dd2b62a".getBytes()))%>','1111')">이민주 법률전문관(자문관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F94ea00840f55".getBytes()))%>','1111')">조수연 법률전문관(자문관리권한)</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F7087f7707479".getBytes()))%>','1111')">유혜림 계약법률심사팀장(협약관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F806cb5bcf87a".getBytes()))%>','1111')">김수진 계약전문관(협약관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("F87f220fa0ed4".getBytes()))%>','1111')">김호정 법률전문관(협약관리권한)</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("M90646cd850c7".getBytes()))%>','1111')">진근태 법률전문관(협약관리권한)</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("3".getBytes()))%>','1111')">과장권한</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("4".getBytes()))%>','1111')">소송관리권한</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("5".getBytes()))%>','1111')">소송접수권한</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("6".getBytes()))%>','1111')">소송비용권한</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("7".getBytes()))%>','1111')">소송비용회수권한</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("16".getBytes()))%>','1111')">인지대/송달료권한</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("8".getBytes()))%>','1111')">자문관리권한</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("9".getBytes()))%>','1111')">자문접수권한 </a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("10".getBytes()))%>','1111')">자문팀장권한</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("14".getBytes()))%>','1111')">자문료권한</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("11".getBytes()))%>','1111')">협약관리권한</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("12".getBytes()))%>','1111')">협약접수권한</a></li>
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("13".getBytes()))%>','1111')">협약팀장권한</a></li>
	------------------------------------------------------------------------------------------------------------------------------------------------------
	<li ><a href="javascript:goLogin('<%=new String(Base64.encodeBase64("15".getBytes()))%>','1111')">법률고문담당권한</a></li>
</ul>
</div>
<%
	//}
%>
</body>
</html>
