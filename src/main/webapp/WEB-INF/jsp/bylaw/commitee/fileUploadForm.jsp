<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	String commissionid = param.get("commissionid")==null?"":param.get("commissionid").toString();
	String filecd = param.get("filecd")==null?"":param.get("filecd").toString();
%>
<script>
	function save(){
		var frm = document.frm;
		frm.action="fileSave.do";
		frm.submit();
	}
</script>

<form name="frm" method="post" enctype="multipart/form-data">
 	<input type="hidden" name="commissionid" value="<%=commissionid%>"/>
 	<input type="hidden" name="filecd" value="<%=filecd%>"/>
 	<input type="hidden" name="job" value="fileUpload"/>
	<div style="width:95%; text-align:center; padding:15px 10px;">
		<input type="file" name="attFile" style="width:300px;"/>
		<img src="${resourceUrl}/images/commitee/button_register.png" width="57" height="20" alt="등록" style="cursor:pointer;margin-top:-2px;" onclick="save();">
	</div>
</form>	