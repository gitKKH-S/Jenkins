<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="com.mten.bylaw.consult.StringUtil"%> 
<% 
	String banreason = request.getAttribute("banreason")==null?"":request.getAttribute("banreason").toString();
	String consultid = request.getAttribute("consultid")==null?"":request.getAttribute("consultid").toString();
	String consultansid = request.getAttribute("consultansid")==null?"":request.getAttribute("consultansid").toString();
	String paramType = request.getAttribute("paramType")==null?"":request.getAttribute("paramType").toString();
	
	//System.out.println("반려사유:"+banreason);
%>
<script>

function goSaveInfo(){
	if(document.detailFrm.banreason.value==''){
		alert("반려사유를 입력하시기 바랍니다.");
		return;
	}
	if(confirm(" 등록 하시겠습니까?")){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/consult/banReasonUpdate.do",
			data:$('#detailFrm').serializeArray(),
			dataType:"json",
			async:false,
			success:function(result){
				if(result.data.msg == 'ok'){
					alert("정상 처리 되었습니다.");
					opener.pagereload();
					window.close();
				}
			}
		});
	}
}
</script>

<form name="detailFrm" id="detailFrm" method="post" action="">
<input type="hidden" name="consultid" id="consultid" value="<%=consultid%>"/>
<input type="hidden" name="consultansid" id="consultansid" value="<%=consultansid%>"/>
<input type="hidden" name="paramType" id="paramType" value="<%=paramType%>"/>

<strong class="popTT">
	자문반려
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
	<div class="popW">
		<div class="popC">
			<div class="popA">
				<table class="pop_infoTable write">
					<colgroup>
						<col style="width:70%;">
						<col style="width:10%;">
						<col style="width:10%;">
						<col style="width:*;">
					</colgroup>
					<tr>
						<th>반려사유</<th>

					</tr>
				</table>
			
				<table class="pop_infoTable write">
					<colgroup>
	
						<col style="width:*;">
					</colgroup>
					<tr>
						<td><textarea name="banreason" class="textarea_txt ht200px"/><%=StringUtil.null2space(banreason)%></textarea></td>
					</tr>
				</table>
			</div>
	
			<hr class="margin20">
			<div class="subBtnC right" style="height:50px;">
				<input type="button" class="sBtn type1" onclick="goSaveInfo()" value="저장">
				<input type="button" class="sBtn type2" onclick="window.close();" value="취소">
			</div>
		</div>
	</div>
</form>