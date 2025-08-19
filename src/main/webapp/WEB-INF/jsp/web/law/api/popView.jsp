<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.min.js"></script>
<script>
	$(document).ready(function() {
		var url = opener.urlInfo;
		console.log(url);
		//location.href = "http://www.law.go.kr"+url;
		document.getElementById("popIf").src = "https://www.law.go.kr"+url;
	})
</script>
<iframe id="popIf" src="" width="100%" height="100%" frameborder="0" scrolling="yes"></iframe>