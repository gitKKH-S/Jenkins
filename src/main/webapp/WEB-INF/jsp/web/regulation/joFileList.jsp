<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*"%>
<%@ page import="javax.xml.transform.*"%>
<%@ page import="javax.xml.transform.stream.*"%>
<%@ page import="com.mten.util.*"%>
<%
	List jfl = request.getAttribute("fl")==null?new ArrayList():(ArrayList)request.getAttribute("fl");
%>
<title></title>
<link rel="stylesheet" type="text/css" href="<%=CONTEXTPATH%>/jsp/lkms3/css/total.css" />
<style type="text/css">
	body{
		scrollbar-shadow-color:#c9d0d9;
		scrollbar-highlight-color:#FFFFFF;
		scrollbar-face-color:#9ebfeb;
		scrollbar-3dlight-color:#9EBFEB;
		scrollbar-darkshadow-color:#9EBFEB;
		scrollbar-track-color:#FFFFFF;
		scrollbar-arrow-color:#FFFFFF;
		margin:0;
	}
	#pop_container {
		background:#e9edf2 url(<%=CONTEXTPATH%>/jsp/lkms3/images/icon/logo2.png) no-repeat top right;
		padding:10px 0 0 0;
		height : 105%;
	}

	#pop_container h1 {
		color:#293853;
		font-family:Malgun Gothic, Dotum;
		background:url(<%=CONTEXTPATH%>/jsp/lkms3/images/icon/caption_bullet52.gif) no-repeat 5px top;
		margin:0;
		padding:10px 0;
		padding-left:19px;
		font-size:15px;
	}
	#contents_box {
		background:#fff;
		border:1px solid #9fb0cd;
		margin-left:auto;
		margin-right:auto;
		padding:5px;
		line-height:1.7em;
		color:#777;
		height :85%;
		margin:10px;
	}
</style>
<script>
function downpage(Pcfilename,Serverfile){
	form=document.ViewForm;
	form.Pcfilename.value=Pcfilename;
	form.Serverfile.value=Serverfile;
	form.folder.value='ATTACH';
	form.action="${pageContext.request.contextPath}/Download.do";
	form.submit();
}
</script>
<form name="ViewForm" method="post">
  	<input type="hidden" name="Serverfile"/>
	<input type="hidden" name="Pcfilename"/>
	<input type="hidden" name="folder"/>
</form>
<SCRIPT LANGUAGE="JavaScript">


</script>
<div id="pop_container">
   	<h1>
   		관련 첨부문서
	</h1>
	<div id="contents_box">
		<ul>
			<%
			for(int i=0; i<jfl.size(); i++){
				HashMap result = (HashMap)jfl.get(i);
			%>
			<li style="cursor:pointer;" onclick="downpage('<%=result.get("PCFILENAME") %>','<%=result.get("SERVERFILE") %>')"> -<span style="color:red;">[<%=result.get("PDFFILE") %>]</span> <%=result.get("PCFILENAME") %></li>
			<%
			}
			%>
		</ul>
	</div>
</div>
