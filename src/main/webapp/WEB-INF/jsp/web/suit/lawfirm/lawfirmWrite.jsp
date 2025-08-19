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
	String lawfirmgbn = lawfirmMap.get("CORP_SE")==null?"":lawfirmMap.get("CORP_SE").toString();
	
	String CORP_NOZ_YN = lawfirmMap.get("CORP_NOZ_YN")==null?"":lawfirmMap.get("CORP_NOZ_YN").toString();
%>
<script type="text/javascript">
	$(document).ready(function(){  //문서가 로딩될때
		// 전화번호 - 삽입
		$(".telInput").on("keyup", function(){
			$(this).val($(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-"));
		});
	});
	
	function goSave(){
		if(confirm("등록 하시겠습니까?")){
			
			if($("#JDAF_CORP_NM").val() == ""){
				return alert("법인명을 입력하세요");
			}
			
			if($("#CORP_NOZ").checked) {
				$("#CORP_NOZ_YN").val("Y");
			} else {
				$("#CORP_NOZ_YN").val("N");
			}
			
			$.ajax({
				type:"POST",
				url:"${pageContext.request.contextPath}/web/suit/insertLawfirmInfo.do",
				data:$('#frm').serializeArray(),
				dataType:"json",
				async:false,
				success:function(result){
					alert(result.msg);
					goListPage();
				}
			});
		}
	}
	
	function goListPage(){
		document.frm.action="<%=CONTEXTPATH%>/web/suit/goLawfirmList.do";
		document.frm.submit();
	}
	
	
	
</script>
<style>
	input{width:50%}
</style>
<form name="frm" id="frm" method="post" action="">
	<input type="hidden" name="JDAF_CORP_MNG_NO" id="JDAF_CORP_MNG_NO" value="<%=JDAF_CORP_MNG_NO%>"/>
	<input type="hidden" name="MENU_MNG_NO"      id="MENU_MNG_NO"      value="<%=MENU_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM"      id="WRTR_EMP_NM"      value="<%=WRTR_EMP_NM%>" />
	<input type="hidden" name="WRTR_EMP_NO"      id="WRTR_EMP_NO"      value="<%=WRTR_EMP_NO%>" />
	<input type="hidden" name="WRT_DEPT_NO"      id="WRT_DEPT_NO"      value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="WRT_DEPT_NM"      id="WRT_DEPT_NM"      value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="CORP_NOZ_YN"      id="CORP_NOZ_YN"      value="<%=CORP_NOZ_YN%>" />
	<input type="hidden" name="searchForm"       id="searchForm"       value="<%=searchForm%>"/>
	<div class="subCA">
		<strong class="subTT">법무법인 등록</strong>
		<div class="innerB">
			<table class="infoTable write">
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
						<input type="text" id="JDAF_CORP_NM" name="JDAF_CORP_NM" value="<%=lawfirmMap.get("JDAF_CORP_NM")==null?"":lawfirmMap.get("JDAF_CORP_NM").toString()%>">
					</td>
					<th>공증인가 법무법인 해당여부</th>
					<td>
						<input type="checkbox" name="CORP_NOZ" id="CORP_NOZ" <%if("Y".equals(CORP_NOZ_YN)) out.println("checked");%>>
					</td>
				</tr>
				<tr>
					<th>우편번호</th>
					<td>
						<input type="text" id="ZIP" name="ZIP" value="<%=lawfirmMap.get("ZIP")==null?"":lawfirmMap.get("ZIP").toString()%>">
					</td>
					<th>사무실 주소</th>
					<td colspan="3">
						<input type="text" id="OFC_ADDR" name="OFC_ADDR" value="<%=lawfirmMap.get("OFC_ADDR")==null?"":lawfirmMap.get("OFC_ADDR").toString()%>">
					</td>
				</tr>
				<tr>
					<th>사무실 전화번호</th>
					<td>
						<input type="text" class="telInput" id="OFC_TELNO" name="OFC_TELNO" value="<%=lawfirmMap.get("OFC_TELNO")==null?"":lawfirmMap.get("OFC_TELNO").toString()%>">
					</td>
					<th>사무실 팩스번호</th>
					<td>
						<input type="text" class="telInput" id="OFC_FXNO" name="OFC_FXNO" value="<%=lawfirmMap.get("OFC_FXNO")==null?"":lawfirmMap.get("OFC_FXNO").toString()%>">
					</td>
					<th colspan="2"></th>
				</tr>
				<tr>
					<th>국제법률자문</th>
					<td colspan="5">
						<input type="text" name="CORP_INTL_CNSTN_CN" id="CORP_INTL_CNSTN_CN" value="<%=lawfirmMap.get("CORP_INTL_CNSTN_CN")==null?"":lawfirmMap.get("CORP_INTL_CNSTN_CN").toString()%>">
					</td>
				</tr>
				<tr>
					<th>지적재산권법률자문</th>
					<td colspan="5">
						<input type="text" name="CORP_IPR_CNSTN_CN" id="CORP_IPR_CNSTN_CN" value="<%=lawfirmMap.get("CORP_IPR_CNSTN_CN")==null?"":lawfirmMap.get("CORP_IPR_CNSTN_CN").toString()%>">
					</td>
				</tr>
				<tr>
					<th>대표변호사명</th>
					<td>
						<input type="text" id="RPRS_LWYR_NM" name="RPRS_LWYR_NM" value="<%=lawfirmMap.get("RPRS_LWYR_NM")==null?"":lawfirmMap.get("RPRS_LWYR_NM").toString()%>">
					</td>
					<th>대표변호사 전화번호</th>
					<td>
						<input type="text" class="telInput" id="RPRS_LWYR_TELNO" name="RPRS_LWYR_TELNO" value="<%=lawfirmMap.get("RPRS_LWYR_TELNO")==null?"":lawfirmMap.get("RPRS_LWYR_TELNO").toString()%>">
					</td>
					<th>대표변호사 이메일주소</th>
					<td>
						<input type="text" id="RPRS_LWYR_EML_ADDR" name="RPRS_LWYR_EML_ADDR" value="<%=lawfirmMap.get("RPRS_LWYR_EML_ADDR")==null?"":lawfirmMap.get("RPRS_LWYR_EML_ADDR").toString()%>">
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="5">
						<textarea rows="5" cols="200" name="RMRK_CN" id="RMRK_CN">
							<%=lawfirmMap.get("RMRK_CN")==null?"":lawfirmMap.get("RMRK_CN").toString()%>
						</textarea>
					</td>
				</tr>
			</table>
		</div>
		<div class="subBtnW side">
			<div class="subBtnC right">
				<a href="#none" class="sBtn type1" onclick="goSave();">등록</a>
				<a href="#none" class="sBtn type2" onclick="goListPage();">목록</a>
			</div>
		</div>
	</div>
</form>
