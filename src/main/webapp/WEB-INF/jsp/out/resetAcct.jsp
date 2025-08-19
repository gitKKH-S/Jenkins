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
	function goLogin(){
		if($("#userid").val() == "" || $("#usernm").val() == "" || $("#mblno").val() == ""){
			return alert("정보를 빠짐없이 입력하세요.");
		}else{
			var asst = "N";
			if($('input[name="asst_yn"]').is(':checked')) {
				asst = "Y";
			}
			
			$.ajax({
				type:"POST",
				url : "${pageContext.request.contextPath}/out/resetLwyrAcct.do",
				data : {
					LGN_ID : $("#userid").val(),
					ASST_YN : asst,
					usernm : $("#usernm").val(),
					mblno : $("#mblno").val()
				},
				dataType: "json",
				async: false,
				success : function(result){
					alert(result.msg);
					if(result.suc=='Y'){
						goLoginPage();
					}
				}
			});
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
	.loginwrap input.nm { width:378px; height:40px; margin-top:10px; padding-left:10px; border:1px solid #888; color:#999; }
	.loginwrap input.mblno { width:378px; height:40px; margin-top:10px; padding-left:10px; border:1px solid #888; color:#999; }
	.loginwrap button.loginbt { width:378px; height:40px;background:#0066b3; margin-top:20px; color:#fff; }
	.searchlogo { width:440px; height:34px; margin:0 auto; text-align:center; }
</style>
</head>
<body style="width:100%; height:100%;">
	<div class="loginb">
		<div class="loginwrap">
			<h1 class="searchlogo"><a href="javascript:goMain()"><img src="${resourceUrl}/seoul/images/logo.png" alt="고문변호사자문지원시스템" /></a></h1>
			<div class="login">
				<ul id="reset">
					<li>
						<input type="text" name="usernm" id="usernm" class="nm" placeholder="변호사명" value="" />
					</li>
					<li>
						<input type="text" name="mblno" id="mblno" class="mblno" placeholder="휴대전화번호(- 제외)" value="" />
					</li>
					<li>
						<input type="text" name="userid" id="userid" class="id" placeholder="아이디" value="">
						<input type="checkbox" name="asst_yn" value="Y" /> 보조여부
					</li>
					<li><button class="loginbt" onclick="goLogin()" >비밀번호 초기화</button></li>
					<li><button class="loginbt" onclick="goLoginPage()" style="background:gray;">로그인 페이지로 돌아가기</button></li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>