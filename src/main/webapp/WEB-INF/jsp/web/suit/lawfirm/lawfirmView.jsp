<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String JDAF_CORP_MNG_NO = request.getAttribute("JDAF_CORP_MNG_NO")==null?"":(String)request.getAttribute("JDAF_CORP_MNG_NO");
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	String MENU_MNG_NO = request.getAttribute("MENU_MNG_NO")==null?"":request.getAttribute("MENU_MNG_NO").toString();

	String searchForm = request.getParameter("searchForm")==null?"":request.getParameter("searchForm").toString();
	
	HashMap lawfirmMap = request.getAttribute("lawfirmMap")==null?new HashMap():(HashMap)request.getAttribute("lawfirmMap");
	
	HashMap se = (HashMap)session.getAttribute("userInfo");
	String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();	
%>
<script type="text/javascript">
	var JDAF_CORP_MNG_NO = "<%=JDAF_CORP_MNG_NO%>";
	
	function goUpdate(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/lawfirmWritePage.do";
		document.frm.submit();
	}
	
	function goDel(){
		if(confirm("법무법인을 삭제하면 소속 변호사가 함께 삭제됩니다.\n삭제 하시겠습니까?")){
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/deleteLawfirmInfo.do",
				data:{JDAF_CORP_MNG_NO:JDAF_CORP_MNG_NO},
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					goListPage();
				}
			});
		}
	}
	
	$(document).ready(function(){
		
	});
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/goLawfirmList.do";
		document.frm.submit();
	}
</script>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="JDAF_CORP_MNG_NO" id="JDAF_CORP_MNG_NO" value="<%=JDAF_CORP_MNG_NO%>"/>
	<input type="hidden" name="MENU_MNG_NO"      id="MENU_MNG_NO"      value="<%=request.getParameter("MENU_MNG_NO")%>"/>
	<input type="hidden" name="WRTR_EMP_NM"      id="WRTR_EMP_NM"      value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"      id="WRTR_EMP_NO"      value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"      id="WRT_DEPT_NO"      value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"      id="WRT_DEPT_NM"      value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="searchForm"       id="searchForm"       value="<%=searchForm%>"/>
	<div class="subCA">
		<strong id="subTT" class="subTT"></strong>
		<div class="innerB">
			<table class="infoTable" style="width:100%">
				<colgroup>
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>법무법인명</th>
					<td colspan="3">
						<%=lawfirmMap.get("JDAF_CORP_NM")==null?"":lawfirmMap.get("JDAF_CORP_NM").toString()%>
					</td>
					<th>공증인가 법무법인 해당여부</th>
					<td>
						<%=lawfirmMap.get("CORP_NOZ_YN")==null?"":lawfirmMap.get("CORP_NOZ_YN").toString()%>
					</td>
				</tr>
				<tr>
					<th>우편번호</th>
					<td>
						<%=lawfirmMap.get("ZIP")==null?"":lawfirmMap.get("ZIP").toString()%>
					</td>
					<th>사무실 주소</th>
					<td colspan="3">
						<%=lawfirmMap.get("OFC_ADDR")==null?"":lawfirmMap.get("OFC_ADDR").toString()%>
					</td>
				</tr>
				<tr>
					<th>사무실 전화번호</th>
					<td>
						<%=lawfirmMap.get("OFC_TELNO")==null?"":lawfirmMap.get("OFC_TELNO").toString()%>
					</td>
					<th>사무실 팩스번호</th>
					<td>
						<%=lawfirmMap.get("OFC_FXNO")==null?"":lawfirmMap.get("OFC_FXNO").toString()%>
					</td>
					<th colspan="2"></th>
				</tr>
				<tr>
					<th>국제법률자문</th>
					<td colspan="5">
						<%=lawfirmMap.get("CORP_INTL_CNSTN_CN")==null?"":lawfirmMap.get("CORP_INTL_CNSTN_CN").toString()%>
					</td>
				</tr>
				<tr>
					<th>지적재산권법률자문</th>
					<td colspan="5">
						<%=lawfirmMap.get("CORP_IPR_CNSTN_CN")==null?"":lawfirmMap.get("CORP_IPR_CNSTN_CN").toString()%>
					</td>
				</tr>
				<tr>
					<th>대표변호사명</th>
					<td>
						<%=lawfirmMap.get("RPRS_LWYR_NM")==null?"":lawfirmMap.get("RPRS_LWYR_NM").toString()%>
					</td>
					<th>대표변호사 전화번호</th>
					<td>
						<%=lawfirmMap.get("RPRS_LWYR_TELNO")==null?"":lawfirmMap.get("RPRS_LWYR_TELNO").toString()%>
					</td>
					<th>대표변호사 이메일주소</th>
					<td>
						<%=lawfirmMap.get("RPRS_LWYR_EML_ADDR")==null?"":lawfirmMap.get("RPRS_LWYR_EML_ADDR").toString()%>
					</td>
				</tr>
				
				<tr>
					<th>비고</th>
					<td colspan="3"><%=lawfirmMap.get("RMRK_CN")==null?"":lawfirmMap.get("RMRK_CN").toString().replaceAll("\n","<br/>")%></td>
				</tr>
			</table>
		</div>
		<div class="subBtnW center">
		<%if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("I") > -1){%>
			<a href="#none" class="sBtn type1" onclick="goUpdate();">수정</a>
			<a href="#none" class="sBtn type3" onclick="goDel();">삭제</a>
		<%}%>
			<a href="#none" class="sBtn type2" onclick="goListPage();">목록</a>
		</div>
	</div>
</form>