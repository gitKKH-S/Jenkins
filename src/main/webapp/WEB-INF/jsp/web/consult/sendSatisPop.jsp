<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.mten.cmn.MtenResultMap"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%
	String GBN = request.getAttribute("GBN")==null?"":request.getAttribute("GBN").toString();
	List docList = request.getAttribute("docList")==null?new ArrayList():(ArrayList)request.getAttribute("docList");

%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	
	function reLoadPop(){
		location.reload(true);
	}
	
	function closePop(){
		window.close();
	}
	
	function send() {
		var checkboxes = document.getElementsByName('chkDoc[]');
		var checkedValues = [];
		
		var pkList = [];
		var empPkList = [];
		var empNmList = [];
		
		for (let i = 0; i < checkboxes.length; i++) {
			if (checkboxes[i].checked) {
				pkList.push($("#DOC_PK"+checkboxes[i].value).val());
				empPkList.push($("#EMP_PK_NO"+checkboxes[i].value).val());
				empNmList.push($("#DOC_EMP_NM"+checkboxes[i].value).val());
			}
		}
		
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/sendSatisAlertList.do",
			data:{
				pkList    : pkList,
				empPkList : empPkList,
				empNmList : empNmList,
				GBN       : "<%=GBN%>"
			},
			dataType:"json",
			async:false,
			success:function(result){
				alert("전송되었습니다.");
				reload();
			}
		});
	}
</script>
<style>
	
</style>
<strong class="popTT">
	만족도 응답 요청
	<a href="#none" class="popClose" onclick="closePop();">닫기</a>
</strong>
<form name="wform" id="wform" method="post">
	<input type="hidden" name="GBN" id="GBN" value="<%=GBN%>"/>
	<div class="popC">
		<table class="pop_infoTable write" style="height:100%;">
			<colgroup>
				<col style="width: 3.3%;">
				<col style="width: 9.9%;">
				<col style="width:*;">
				<col style="width: 10%;">
				<col style="width: 11.3%;">
			</colgroup>
			<tr>
				<th></th>
				<th>문서번호</th>
				<th>제목</th>
				<th>의뢰자</th>
				<th>완료일자</th>
			</tr>
		</table>
		<div class="popA">
			<table class="pop_infoTable write" style="height:100%;">
				<colgroup>
					<col style="width:3%;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:10%;">
				</colgroup>
		<%
			if (docList.size() > 0) {
				for(int i=0; i<docList.size(); i++) {
					HashMap map = (HashMap)docList.get(i);
					String DOC_PK = map.get("DOC_PK")==null?"":map.get("DOC_PK").toString();
					String EMP_PK_NO = map.get("EMP_PK_NO")==null?"":map.get("EMP_PK_NO").toString();
					String DOC_EMP_NM = map.get("DOC_EMP_NM")==null?"":map.get("DOC_EMP_NM").toString();
		%>
				<tr>
					<td>
						<input type="hidden" name="DOC_PK<%=i%>"     id="DOC_PK<%=i%>"     value="<%=DOC_PK%>">
						<input type="hidden" name="EMP_PK_NO<%=i%>"  id="EMP_PK_NO<%=i%>"  value="<%=EMP_PK_NO%>">
						<input type="hidden" name="DOC_EMP_NM<%=i%>" id="DOC_EMP_NM<%=i%>" value="<%=DOC_EMP_NM%>">
						<input type="checkbox" name="chkDoc[]" value=""/>
					</td>
					<td><%=map.get("DOC_NO")==null?"":map.get("DOC_NO").toString()%></td>
					<td><%=map.get("DOC_TTL")==null?"":map.get("DOC_TTL").toString()%></td>
					<td><%=map.get("DOC_EMP_NM")==null?"":map.get("DOC_EMP_NM").toString()%></td>
					<td><%=map.get("DOC_END_YMD")==null?"":map.get("DOC_END_YMD").toString()%></td>
				</tr>
		<%
				}
			} else {
		%>
				<tr>
					<td colspan="5">
						대상문서가 없습니다.
					</td>
				</tr>
		<%
			}
		%>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="send()"><i class="fa-solid fa-file-import"></i> 알림발송</a>
		</div>
	</div>
</form>