<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script src="${pageContext.request.contextPath}/webjars/jquery/1.12.4/jquery.min.js"></script>
<script>
	$(document).ready(function() {
		//console.log(opener.urlInfo);
		//var url = opener.urlInfo;
		//location.href = url;
		var url = opener.urlInfo;
		
		console.log(url);
		console.log(url.replace("http", "https"));
		if (url.indexOf("http") > -1) {
			url = url.replace("http", "https");
		} else {
			url = "https://law.go.kr"+url;
		}
		document.getElementById("popIf").src = url;
	})
</script>
<iframe id="popIf" src="" width="100%" height="100%" frameborder="0" scrolling="yes"></iframe>