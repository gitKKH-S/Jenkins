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
						<td><textarea name="banreason" class="textarea_txt ht200px" readonly><%=StringUtil.null2space(banreason)%></textarea></td>
						
					</tr>
				</table>
			</div>
			<!-- 
			<hr class="margin20">
			<input type="button" class="sBtn type1" onclick="editQuestion()" value="수정">
			<input type="button" class="sBtn type2" onclick="deleteQuestion()" value="삭제">
			 -->
		</div>
	</div>
