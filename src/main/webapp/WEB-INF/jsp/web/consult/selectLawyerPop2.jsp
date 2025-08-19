<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	List lawyerList = request.getAttribute("lawyerList")==null?new ArrayList():(ArrayList)request.getAttribute("lawyerList");
%>
<script language="javascript" src="${resourceUrl}/js/mten.pagenav.js"></script>
<script type="text/javascript">
function jubsu(LAWFIRMID,OFFICE,BANKNAME,ACCOUNT,ACCOUNTOWNER){
	$("#lawfirmid",opener.document).val(LAWFIRMID); 
	$("#office",opener.document).val(OFFICE);
	$("#bankname",opener.document).val(BANKNAME);
	$("#account",opener.document).val(ACCOUNT);
	$("#accountowner",opener.document).val(ACCOUNTOWNER);
	window.close();
}
</script>
<style>
	#srchTxt1{width:90%; height:30px; line-height:0px; margin-top:3px;}
	#srchTxt2{width:90%; height:30px; line-height:0px; margin-top:3px;}
	.popW{height:100%}
	#hidden{display:none;}
	.selTd{cursor:pointer;}
</style>
<strong class="popTT">
	법무법인 지정
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div style="height:74%">
	<div class="popC">
		<div class="popA" style="max-height:900px;">
			<div class="tableW">
				<table class="infoTable pop" style="border-top:2px solid #000;">
					<colgroup>
						<col style="width:10%;">
						<col style="width:20%;">
						<col style="width:20%;">	
						<col style="width:20%;">
						<col style="width:30%;">			
					</colgroup>	
					<tr style="background:#f3f6f7;text-align:center;color:#000;">
						<th style="background:#f3f6f7;text-align:center;color:#000;">번호</th>
						<th style="background:#f3f6f7;text-align:center;color:#000;">법무법인명</th>
						<th style="background:#f3f6f7;text-align:center;color:#000;">은행명</th>
						<th style="background:#f3f6f7;text-align:center;color:#000;">계좌번호</th>
						<th style="background:#f3f6f7;text-align:center;color:#000;">예금주</th>
					</tr>	
					<%
						if(lawyerList != null & lawyerList.size()>0){
							for(int i=0;i<lawyerList.size();i++){
								HashMap lawyer = (HashMap)lawyerList.get(i);
					%>
								<tr style="cursor:pointer;" onclick="jubsu('<%=lawyer.get("LAWFIRMID")%>','<%=lawyer.get("OFFICE")%>','<%=lawyer.get("BANKNAME")%>','<%=lawyer.get("ACCOUNT")%>','<%=lawyer.get("ACCOUNTOWNER")%>')">
									<td style="text-align:center;"><%=i+1 %></td>	
									<td style="text-align:center;"><%=lawyer.get("OFFICE")==null?"&nbsp":lawyer.get("OFFICE") %></td>
									<td style="text-align:center;"><%=lawyer.get("BANKNAME")==null?"&nbsp":lawyer.get("BANKNAME") %></td>
									<td style="text-align:center;"><%=lawyer.get("ACCOUNT")==null?"&nbsp":lawyer.get("ACCOUNT") %></td>
									<td style="text-align:center;"><%=lawyer.get("ACCOUNTOWNER")==null?"&nbsp":lawyer.get("ACCOUNTOWNER") %></td>	
								</tr>
					<%
							}
						}
					
					%>
				</table>
			</div>
		</div>
	</div>
</div>
