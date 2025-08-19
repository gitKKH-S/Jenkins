<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script>
$(document).ready(function(){
    
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
							<div class="card-title">계정생성</div>
							<div class="form-group">
								<label class="form-label">이름</label>
								<input type="text" id="usernm" class="form-control" placeholder="Enter name">
							</div>
							<div class="form-group">
								<label class="form-label">이메일</label>
								<input type="email" id="email" class="form-control" placeholder="Enter email">
							</div>
							<div class="form-footer">
								<button type="submit" id="saveBtn" class="btn btn-primary btn-block">계정생성</button>
							</div>
						</div>
					</form>
					<div class="text-center text-muted">
						Already have account? <a href="${pageContext.request.contextPath}/login/login.do">Sign in</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>