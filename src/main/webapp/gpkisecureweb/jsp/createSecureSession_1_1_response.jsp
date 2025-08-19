<%@ page import="com.gpki.gpkiapi.exception.GpkiApiException"%>
<%@ page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.gpki.gpkiapi.cert.*" %>
<%@ page import="com.gpki.gpkiapi.cms.*" %>
<%@ page import="com.gpki.gpkiapi.util.*" %>
<%@ page import="com.dsjdf.jdf.Logger" %>
<%@ page import="java.net.URLDecoder" %>

<%@ page import = "org.apache.commons.codec.binary.Base64" %>

<%@ include file="./gpkisecureweb.jsp"%>
<%
	X509Certificate cert      = null; 
	byte[]  signData          = null;
	byte[]  privatekey_random = null;
	String  signType          = null;
	String  subDN             = null;
	String  queryString       = "";
	boolean checkPrivateNum   = false;
	
	java.math.BigInteger b = new java.math.BigInteger("-1".getBytes()); 

	int message_type =  gpkirequest.getRequestMessageType();

	if( message_type == gpkirequest.ENCRYPTED_SIGNDATA || message_type == gpkirequest.LOGIN_ENVELOP_SIGN_DATA ||
		message_type == gpkirequest.ENVELOP_SIGNDATA || message_type == gpkirequest.SIGNED_DATA){

		cert              = gpkirequest.getSignerCert(); 
		subDN             = cert.getSubjectDN();
		b                 = cert.getSerialNumber();
		signData          = gpkirequest.getSignedData();
		privatekey_random = gpkirequest.getSignerRValue();
		signType          = gpkirequest.getSignType();
	}

	queryString = gpkirequest.getQueryString();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>GPKI 사용자용 표준보안API</title>
	<script type="text/javascript" src="../client/jquery-1.7.1.min.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/style.css" />
</head>
<body>
	<div class="wrap">
		<div class="header">
			<h1><a href="../index.html"><strong>GPKI 사용자용 표준보안API</strong></a></h1>
		</div>
		<div class="content">
			<div class="course course1">
				<div class="title">
					<h2><span class="subject">서버에서 암호 메시지 처리 결과</span></h2>
				</div>
				<div class="list_01">
					<ul>
						<li><span class="subject">- <%
							if(message_type == gpkirequest.ENCRYPTED_DATA){
								out.println("클라이언트에서 암호화 메시지 만들어 서버에서 복호화 하기");
							} else if ((message_type == gpkirequest.ENCRYPTED_SIGNDATA) || (message_type == gpkirequest.ENVELOP_SIGNDATA)) {
								out.println("전자서명 메시지 암호화 하기");
							} else if (message_type == gpkirequest.ENVELOP_DATA){
								out.println("서버 인증서 인증 후 보안세션 만들기");
							} else if (message_type == gpkirequest.SIGNED_DATA){
								out.println("전자서명 메시지 생성하기");
							} else if (message_type == gpkirequest.LOGIN_ENVELOP_SIGN_DATA){
								out.println("사용자와 서버 인증서 인증 후 보안세션 만들기");
							} else {
								out.println("서버에서 암호화 메시지 만들어 클라이언트에서 복호화 하기");
							}
						%></span><span class="sub"><br /></span>
						</li>
						<p>&nbsp;</p>
						<li><strong>[ 전달 파라미터 ] </strong></li>
						<li class="list_02">
						<%
							Enumeration params = gpkirequest.getParameterNames(); 
							while (params.hasMoreElements()) {
								String paramName = (String)params.nextElement(); 
								String paramValue = gpkirequest.getParameter(paramName);
								System.out.println("???? 1");
								if(paramName.trim().equalsIgnoreCase("ssn") && (null != paramValue) && (!"".equals(paramValue)) && privatekey_random != null) {
										System.out.println("???? 2");
									try {
										System.out.println("???? 3");
										cert.verifyVID(paramValue,privatekey_random);
										checkPrivateNum = true;
									} catch (GpkiApiException ex) {
										System.out.println("???? 3");
										// 개인 식별 번호가 다른경우 예외처리
										com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
										StringBuffer sb = new StringBuffer(1500);
										sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
										sb.append("?errmsg=");
										sb.append(URLEncoder.encode("ssn parameter is different in certificate ! check ssn number","UTF-8"));
										response.sendRedirect(sb.toString());
									}
								}
								//out.println(paramName+"="+((paramName.equals("challenge"))?paramValue:URLDecoder.decode(paramValue,"UTF-8"))+"<br>");
							}%>
						</li>
						<%
						String wonSn = b.toString();
						String encodeSn = new String(Base64.encodeBase64(wonSn.getBytes()));
						String encodeNm = new String(Base64.encodeBase64(subDN.getBytes()));
						%>
						<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.js" type="text/javascript"></script>
						<script>
							console.log("? 1");
							function goLogin(){
								console.log("? 4");
								$.ajax({
									type : "POST",
									url : "${pageContext.request.contextPath}/login/gpkiLogin.do",
									data : {
										CRTF_SN:"<%=encodeSn%>",
										CRTF_NM:"<%=encodeNm%>"
									},
									dataType: "json",
									async: false,
									success : function(data) {
										var jdata = data.loginyn;
										if(jdata == 'N'){
											alert(data.msg);
										} else if (jdata == "Y"){
											location.href = "<%=CONTEXTPATH %>/web/index.do";
										} else if (jdata == "A") {
											alert(data.msg);
											window.close();
										}
									}
								});
							}
							console.log("? 2");
							goLogin();
							console.log("? 3");
						</script>
						<li class="list_02">message_type = <%=message_type %></li>
							<% if (signType != null) {%>
								<li><strong> [ 사용자 인증서 고유 정보  ]</strong></li>
								<li class="list_02">인증서 시리얼 넘버: <%= b%></li>
								<li class="list_02">인증서 명칭 : <%= subDN%></li>
								<li class="list_02">인증서 식별번호 확인 : <%=checkPrivateNum?"확인 완료":"확인되지 않음" %></li>
								<li class="list_02">signType = <%=signType %></li>
								<%}
							%>
						</li>
						<li><br></li>
					</ul>
					<div align="center"><a href="../index.html"><img src="../image/button/btn_home.gif" /></a><%if(message_type!=0);%><a href="../logout.html"><img src="../image/button/btn_logout.gif" /></a></div>
				</div>
			</div>
		<div class="sp"></div>
	</div>
</body>
</html>
