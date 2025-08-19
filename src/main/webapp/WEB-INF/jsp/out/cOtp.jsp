<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>   
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">   
<title>::::::::::::: 서울시청 고문변호사 법무지원 시스템 :::::::::::::</title>
<style type="text/css">
	.topW {display:none;}
</style>
<script>
	var createYn = "N";
	function goLogin(){
		if($("#userid").val() == "" || $("#pw").val() == ""){
			return alert("아이디와 비밀번호를 입력하세요.");
		}else{
			var asst = "N";
			if($('input[name="asst_yn"]').is(':checked')) {
				asst = "Y";
			}
			
			if (createYn != "Y") {
				$.ajax({
					type:"POST",
					url : "${pageContext.request.contextPath}/out/cOtp2.do",
					data : {
						LGN_ID : $("#userid").val(),
						ASST_YN : asst,
						LGN_PSWD : $("#pw").val()
					},
					dataType: "json",
					async: false,
					success : function(result){
						console.log(result);
						if(result.openyn=='Y'){
							alert("생성 된 QR코드를 사진으로 입력하시기 바랍니다.");
							
							$("#optImg").append("<li style=\"margin-top:20px\">google otp(아이폰 Authenticator) 어플을 다운로드 받은 후,<br/>아래 QR코드를 사진으로 입력하세요<br/>QR코드 등록 후, 로그인 페이지로 돌아가기 버튼을 클릭하세요</li>");
							$("#optImg").append("<li style=\"margin-top:20px\">"+result.OTP_NO+"</li>");
							$("#optImg").append("<li><img src='"+result.url+"'/></li>");
							
							createYn = "Y";
						}else{
							alert(result.msg);
							createYn = "N";
						}
					}
				});
			} else {
				return alert("이미 생성 된 QR코드가 있습니다. 해당 QR코드를 등록하거나 화면을 새로고침 하세요.");
			}
		}
	}
	
	function goLoginPage(){
		location.href = '${pageContext.request.contextPath}/out/login.do';
	}
</script>
<style>
	.loginb { width:100%; height:100%; background:url('${resourceUrl}/seoul/images/login_bg.jpg')no-repeat 0 0; background-position:center; }
	.loginwrap { position:relative; top:30%; width:390px; margin:0 auto; }
	.loginwrap .login { margin-top:40px; }
	.loginwrap input.id { width:310px; height:40px; border:1px solid #888; color:#999; padding-left:10px; }
	.loginwrap input.pw { width:378px; height:40px; margin-top:10px; padding-left:10px; border:1px solid #888; color:#999; }
	.loginwrap button.loginbt { width:378px; height:40px;background:#0066b3; margin-top:20px; color:#fff; }
	.searchlogo { width:440px; height:34px; margin:0 auto; text-align:center; }
</style>
</head>
<body style="width:100%; height:100%;">
	<div class="loginb">
		<div class="loginwrap">
			<h1 class="searchlogo"><a href="javascript:goMain()"><img src="${resourceUrl}/seoul/images/logo.png" alt="고문변호사자문지원시스템" /></a></h1>
			<div class="login">
				<ul id="optImg">
					<li>
						<input type="text" name="userid" id="userid" class="id" placeholder="아이디" value="">
						<input type="checkbox" name="asst_yn" value="Y" /> 보조여부
					</li>
					<li><input type="password" name="pw" id="pw" class="pw" placeholder="비밀번호" value="" onkeypress="if(event.keyCode==13) javascript:goLogin();"></li>
					<li><button class="loginbt" onclick="goLogin()" >OTP 계정 생성</button></li>
					<li><button class="loginbt" onclick="goLoginPage()" style="background:gray;">로그인 페이지로 돌아가기</button></li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>