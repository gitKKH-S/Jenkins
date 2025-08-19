<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String UNCH_DATE_MNG_NO = request.getAttribute("UNCH_DATE_MNG_NO")==null?"":request.getAttribute("UNCH_DATE_MNG_NO").toString();
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap map = request.getAttribute("map")==null?new HashMap():(HashMap)request.getAttribute("map");
%>
<script type="text/javascript">
	var UNCH_DATE_MNG_NO = "<%=UNCH_DATE_MNG_NO%>";
	$(document).ready(function(){
		
	});
	
	function editUnchDate(){
		opener.unchDateWrite(UNCH_DATE_MNG_NO);
		window.close();
	}
	
	function delUnchDate(){
		if(confirm("등록 된 기일정보를 정보를 삭제 하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/unchDateDelete.do",
				data:{UNCH_DATE_MNG_NO:UNCH_DATE_MNG_NO},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					opener.goReLoad();
					window.close();
				}
			});
		}
	}
</script>
<strong class="popTT">
	불변 기일 정보 <label id="gbn"></label>
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="UNCH_DATE_MNG_NO" id="UNCH_DATE_MNG_NO" value="<%=UNCH_DATE_MNG_NO%>" />
	<input type="hidden" name="WRTR_EMP_NM"           id="WRTR_EMP_NM"           value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"         id="WRTR_EMP_NO"         value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"           id="WRT_DEPT_NO"           value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"         id="WRT_DEPT_NM"         value="<%=WRT_DEPT_NM%>" />
	
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write" style="width:100%;">
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:15%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>불변기일명</th>
					<td colspan="3">
						<%=map.get("UNCH_DATE_NM")==null?"":map.get("UNCH_DATE_NM").toString()%>
					</td>
				</tr>
				<tr>
					<th>구분</th>
					<td>
					<%
						String relcodegbn = map.get("REL_ARTCL_SE")==null?"":map.get("REL_ARTCL_SE").toString();
						if ("DATE".equals(relcodegbn)) {
							out.println("기일");
						} else {
							out.println("서면");
						}
					%>
					</td>
					<th>종류</th>
					<td>
						<%=map.get("REL_ARTCL_TYPE_NM")==null?"":map.get("REL_ARTCL_TYPE_NM").toString()%>
					</td>
				</tr>
				<tr>
					<th>기간</th>
					<td>
						<%=map.get("INV_DAY")==null?"":map.get("INV_DAY").toString()%>
					</td>
					<th>사용여부</th>
					<td>
						<%=map.get("USE_YN")==null?"":map.get("USE_YN").toString()%>
					</td>
				</tr>
				<tr>
					<th>설명</th>
					<td colspan="3">
						<%=map.get("UNCH_DATE_CN")==null?"":map.get("UNCH_DATE_CN").toString().replaceAll("\n","<br/>")%>
					</td>
				</tr>
				
				<tr>
					<th>알림여부</th>
					<td>
						<%=map.get("NOTI_YN")==null?"":map.get("NOTI_YN").toString()%>
					</td>
					<th>알림간격</th>
					<td>
						<%
					String [] term = (map.get("NOTI_INV")==null?"":map.get("NOTI_INV").toString()).split(",");
					String termText = "";
					if(term[0] != ""){
						for(int i=0; i<term.length; i++){
							if("0".equals(term[i])){
								termText += "당일";
							}else{
								termText += term[i] + "일전";
							}
							if(i+1 != term.length){
								termText += ", ";
							}
						}
					}else{
						termText = "알림없음";
					}
				%>
					<%=termText%>
					</td>
				</tr>
				
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="editUnchDate();">수정</a>
			<a href="#none" class="sBtn type3" onclick="delUnchDate();">삭제</a>
		</div>
	</div>
</form>