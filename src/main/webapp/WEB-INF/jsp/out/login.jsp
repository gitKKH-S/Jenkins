<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> -->
<!DOCTYPE html>
<!-- maxpostsize -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">   
<title>::::::::::::: 서울시청 고문변호사 법무지원 시스템 :::::::::::::</title>
<style type="text/css">
	.topW {display:none;}
</style>

<script>
	function goLogin(){
		//if ($("#userid").val() == "" || $("#pw").val() == "" || $("#otp").val() == ""){
		if ($("#userid").val() == "" || $("#pw").val() == ""){
			return alert("아이디와 비밀번호,otp 정보를 입력하세요.");
		} else {
			
			var asst = "N";
			if($('input[name="asst_yn"]').is(':checked')) {
				asst = "Y";
			}
			
			$.ajax({
				type:"POST",
				url : "${pageContext.request.contextPath}/out/loginChk.do",
				data : {
					LGN_ID : $("#userid").val(),
					ASST_YN : asst,
					LGN_PSWD : $("#pw").val(),
					otp : $("#otp").val()
				},
				dataType: "json",
				async: false,
				success : function(result){
					console.log(result);
					if(result.openyn=='Y'){
						//if(result.pwchg == "N"){
						//	alert("비밀번호가 초기 비밀번호입니다.\n변호사 정보 변경 화면에서 비밀번호를 변경하세요");
						//}
						//
						location.href = '${pageContext.request.contextPath}/out/outMain.do';
					}else{
						alert(result.msg);
					}
					
				}
			});
		}
	}
	
</script>
<style>
	.loginb { width:100%; height:100%; background:url('${resourceUrl}/seoul/images/login_bg.jpg')no-repeat 0 0; background-position:center; }
	.loginwrap { position:relative; top:30%; width:390px; margin:0 auto; }
	.loginwrap .login { margin-top:40px; }
	/*
	.loginwrap input.id { width:310px; height:40px; border:1px solid #888; color:#999; padding-left:10px; }
	.loginwrap input.pw { width:378px; height:40px; margin-top:10px; padding-left:10px; border:1px solid #888; color:#999; }
	*/
	
	.loginwrap input.id { width:100%; border:1px solid #888; color:#999; padding-left:10px; }
	.loginwrap input.pw { width:100%; margin-top:10px; padding-left:10px; border:1px solid #888; color:#999; }
	
	.loginwrap button.loginbt { width:100%; height:40px;background:#0066b3; margin-top:20px; color:#fff; }
	.searchlogo { width:100%; height:55px; margin:0 auto; text-align:center; background: #0066b3; }
	a {fons-size:2.5vw;}
</style>
</head>
<body style="width:100%; height:100%;">
	<div class="loginb">
		<div class="loginwrap">
			<h1 class="searchlogo"><a href="javascript:goMain()"><img style="width:100%;" src="${resourceUrl}/seoul/images/outlogo.png" alt="고문변호사자문지원시스템" /></a></h1>
			<div class="login">
				<ul>
					<li>
						<input type="text" name="userid" id="userid" class="id" placeholder="아이디" value="" onkeypress="if(event.keyCode==13) javascript:goLogin();">
						<input type="checkbox" name="asst_yn" value="Y" /> 보조여부
					</li>
					<li><input type="password" name="pw" id="pw" class="pw" placeholder="비밀번호"  value=""  onkeypress="if(event.keyCode==13) javascript:goLogin();"></li>
					<li><input type="password" name="otp" id="otp" class="pw" placeholder="google otp"        onkeypress="if(event.keyCode==13) javascript:goLogin();"></li>
					<li><button class="loginbt" onclick="goLogin()" >로그인</button></li>
					<li><a href="cOtp.do">▶ OTP 계정생성</a></li>
					<li><a href="resetAcct.do">▶ 비밀번호초기화</a></li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>