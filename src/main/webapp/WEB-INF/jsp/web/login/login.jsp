<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script>
$(document).ready(function(){
	$('#loginBtn').click(function() {
		if($("#email").val() == ''){
			alert("이메일주소를 입력하시기 바랍니다.");
		}else{
			$.ajax({
                type:"POST",
                url : "${pageContext.request.contextPath}/login/loginChk.do",
                data : {
                	email : $("#email").val()
                },
                dataType: "json",
                async: false,
                success : function(result){
                	if(result.data.openyn=='Y'){
                		location.href = '${pageContext.request.contextPath}/web/index.do';		
                	}else{
                		alert(result.data.msg);
                	}
                	
                }
            })	
		}
	});
});
</script>
<div class="page">
	<div class="page-single">
		<div class="container">
			<div class="row">
				<div class="col col-login mx-auto">
					<div class="text-center mb-6">
						<img src="${resourceUrl}/tabler-master/dist/demo/brand/tabler.svg" class="h-6" alt="">
					</div>
					<form class="card" action="" method="post">
						<div class="card-body p-6">
							<div class="card-title">Login to your account</div>
							<div class="form-group">
								<label class="form-label">Email address</label>
								<input type="email" class="form-control" id="email" aria-describedby="emailHelp" placeholder="Enter email">
							</div>
							<div class="form-footer">
								<button type="submit" id="loginBtn" class="btn btn-primary btn-block">로그인</button>
							</div>
						</div>
						<div class="text-center text-muted">
							Don't have account yet? <a href="${pageContext.request.contextPath}/login/register.do">Sign up</a>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>