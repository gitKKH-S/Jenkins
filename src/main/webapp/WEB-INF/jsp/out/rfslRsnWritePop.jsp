<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String DOC_GBN     = request.getAttribute("DOC_GBN")==null?"":request.getAttribute("DOC_GBN").toString();
	String DOC_PK      = request.getAttribute("DOC_PK")==null?"":request.getAttribute("DOC_PK").toString();
	String LWYR_NM     = request.getAttribute("LWYR_NM")==null?"":request.getAttribute("LWYR_NM").toString();
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	$(document).ready(function(){
		
	});
	
	function saveInfo(sfilenm, vfilenm){
		
		if(confirm("내용을 저장하시겠습니까?")){
			if($("#RFSL_RSN").val() == "") {
				return alert("거절 사유를 입력하세요");
			}
			
			var frm = document.wform;
			$.ajax({
				type:"POST",
				url : "${pageContext.request.contextPath}/out/rfslRsnSave.do",
				data : $('#wform').serializeArray(),
				dataType: "json",
				async: false,
				success : function(result){
					alert("저장되었습니다.");
					opener.location.href="${pageContext.request.contextPath}/out/outMain.do";
					window.close();
				}
			});
		}
	}
	
	function reLoadPop(){
		location.reload(true);
	}
	
	function closePop(){
		opener.location.href="${pageContext.request.contextPath}/out/outMain.do";
		window.close();
	}
</script>
<style>
}
</style>
<strong class="popTT">
	수임 거절 사유 작성
	<a href="#none" class="popClose" onclick="closePop();">닫기</a>
</strong>
<form name="wform" id="wform" method="post">
	<input type="hidden" name="DOC_GBN"      id="DOC_GBN"      value="<%=DOC_GBN%>"/>
	<input type="hidden" name="DOC_PK"       id="DOC_PK"       value="<%=DOC_PK%>"/>
	<input type="hidden" name="WRTR_EMP_NO"  id="WRTR_EMP_NO"  value="<%=WRTR_EMP_NO%>"/>
	<input type="hidden" name="LWYR_NM"      id="LWYR_NM"      value="<%=LWYR_NM%>"/>
	<input type="hidden" name="RCPT_YN"      id="RCPT_YN"      value="N"/>
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write" style="height:100%;">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>거절 사유</th>
					<td>
						<textarea id="RFSL_RSN" name="RFSL_RSN" rows="10" cols=""></textarea>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="saveInfo('', '')" id="savebtn"><i class="fa-solid fa-file-import"></i> 저장</a>
		</div>
	</div>
</form>