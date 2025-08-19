<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	HashMap empMap = request.getAttribute("empMap")==null?new HashMap():(HashMap)request.getAttribute("empMap");

	String LWS_FLFMT_MNG_NO = request.getAttribute("LWS_FLFMT_MNG_NO")==null?"":request.getAttribute("LWS_FLFMT_MNG_NO").toString();
	String LWS_MNG_NO = request.getAttribute("LWS_MNG_NO")==null?"":request.getAttribute("LWS_MNG_NO").toString();
	String INST_MNG_NO = request.getAttribute("INST_MNG_NO")==null?"":request.getAttribute("INST_MNG_NO").toString();
	
	String FLFMT_YN = empMap.get("FLFMT_YN")==null?"":empMap.get("FLFMT_YN").toString();
	
	String WRTR_EMP_NM = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
%>
<script src="${resourceUrl}/js/mten.fileupload.js" type="text/javascript"></script>
<link rel="stylesheet" href="${resourceUrl}/css/fileupload.css" type="text/css" charset="euc-kr"/>
<script type="text/javascript">
	
	var LWS_FLFMT_MNG_NO = "<%=LWS_FLFMT_MNG_NO%>";
	var LWS_MNG_NO = "<%=LWS_MNG_NO%>";
	var INST_MNG_NO = "<%=INST_MNG_NO%>";
	
	$(document).ready(function(){
		
	});
	
	function searchDept(idx){
		var cw=900;
		var ch=900;
		//스크린의 크기
		var sw=screen.availWidth;
		var sh=screen.availHeight;
		//열 창의 포지션
		var px=(sw-cw)/2;
		var py=(sh-ch)/2;
		property="left="+px+",top="+py+",width="+cw+",height="+ch+",scrollbars=yes,resizable=yes,status=no,toolbar=no";
		var newWindow = window.open("","relViewPop",property);
		
		var newForm = $('<form></form>');
		newForm.attr("name", "fileFrm");
		newForm.attr("method", "post");
		newForm.attr("target", "relViewPop");
		newForm.attr("action", "<%=CONTEXTPATH%>/web/suit/searchDeptPop.do");
		newForm.append($("<input/>", {type:"hidden", name:"menu", value:"rel"}));
		newForm.append($("<input/>", {type:"hidden", name:"deptno", value:"<%=empMap.get("LWS_FLFMT_DEPT_NO")==null?"6110000":empMap.get("LWS_FLFMT_DEPT_NO").toString()%>"}));
		newForm.append($("<input/>", {type:"hidden", name:"${_csrf.parameterName}", value:"${_csrf.token}"}));
		newForm.appendTo("body");
		newForm.submit();
		newForm.remove();
	}
	
	function goInfoSave(){
		var useyn = $("#useyn").val();
		if(useyn == "Y"){
			$("#enddt").val("");
		}
		
		$.ajax({
			url: "<%=CONTEXTPATH%>/web/suit/insertRelEmpInfo.do",
			data: $("#frm").serialize(),
			dataType: "json",
			async: false,
			type:"POST",
			error: function(){
				alert("처리중 오류가 발생하였습니다.")
			},
			success: function(result){
				alert(result.msg);
				opener.document.getElementById("focus").value = "1";
				opener.goReLoad();
				window.close();
			}
		});
		
	}
</script>
<style>
	.datepick{width:40%;}
</style>
<strong class="popTT">
	소송수행자 등록
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<form id="frm" name="frm" method="post" action="">
	<input type="hidden" name="LWS_FLFMT_MNG_NO" id="LWS_FLFMT_MNG_NO" value="<%=LWS_FLFMT_MNG_NO%>" />
	<input type="hidden" name="LWS_MNG_NO"       id="LWS_MNG_NO"       value="<%=LWS_MNG_NO%>"/>
	<input type="hidden" name="INST_MNG_NO"      id="INST_MNG_NO"      value="<%=INST_MNG_NO%>"/>
	<input type="hidden" name="WRTR_EMP_NM"           id="WRTR_EMP_NM"           value="<%=WRTR_EMP_NM%>"/>
	<input type="hidden" name="WRTR_EMP_NO"         id="WRTR_EMP_NO"         value="<%=WRTR_EMP_NO%>"/>
	<input type="hidden" name="WRT_DEPT_NM"         id="WRT_DEPT_NM"         value="<%=WRT_DEPT_NM%>" />
	<input type="hidden" name="WRT_DEPT_NO"           id="WRT_DEPT_NO"           value="<%=WRT_DEPT_NO%>" />
	<input type="hidden" name="gbn"              id="gbn"              value="pop"/>
	<div class="popC">
		<div class="popA">
			<table class="pop_infoTable write" style="width:100%">
				<colgroup>
					<col style="width:20%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>수행부서</th>
					<td>
						<input type="hidden" id="LWS_FLFMT_DEPT_NO" name="LWS_FLFMT_DEPT_NO" value="<%=empMap.get("LWS_FLFMT_DEPT_NO")==null?"":empMap.get("LWS_FLFMT_DEPT_NO").toString()%>"/>
						<input type="text" id="LWS_FLFMT_DEPT_NM" name="LWS_FLFMT_DEPT_NM" value="<%=empMap.get("LWS_FLFMT_DEPT_NM")==null?"":empMap.get("LWS_FLFMT_DEPT_NM").toString()%>" readonly="readonly" onclick="searchDept()" style="width:70%"/>
						<a href="#none" class="innerBtn" id="searchBtn" onclick="searchDept()">조회</a>
					</td>
				</tr>
				<tr>
					<th>소송수행자</th>
					<td>
						<input type="hidden" id="LWS_FLFMT_EMP_NO" name="LWS_FLFMT_EMP_NO" value="<%=empMap.get("LWS_FLFMT_EMP_NO")==null?"":empMap.get("LWS_FLFMT_EMP_NO").toString()%>"/>
						<input type="text" id="LWS_FLFMT_EMP_NM" name="LWS_FLFMT_EMP_NM" value="<%=empMap.get("LWS_FLFMT_EMP_NM")==null?"":empMap.get("LWS_FLFMT_EMP_NM").toString()%>" readonly="readonly" onclick="searchDept()"/>
					</td>
				</tr>
				<tr>
					<th>사용여부</th>
					<td>
						<select id="FLFMT_YN" name="FLFMT_YN" style="float:left">
							<option value="Y" <%if(FLFMT_YN.equals("") || "Y".equals(FLFMT_YN)) out.println("selected"); %>>Y</option>
							<option value="N" <%if("N".equals(FLFMT_YN)) out.println("selected"); %>>N</option>
						</select>
						<p style="color:#57b9ba; float:left; margin:5px;"> ※ 종료시 "N" 선택</p>
					</td>
				</tr>
				<tr>
					<th>수행기간</th>
					<td>
						<input type="text" id="FLFMT_BGNG" name="FLFMT_BGNG" value="<%=empMap.get("FLFMT_BGNG")==null?"":empMap.get("FLFMT_BGNG").toString()%>" class="datepick"/> ~ 
						<input type="text" id="FLFMT_END"  name="FLFMT_END" value="<%=empMap.get("FLFMT_END")==null?"":empMap.get("FLFMT_END").toString()%>" class="datepick"/>
					</td>
				</tr>
				<tr>
					<th>비고</th>
					<td>
						<textarea rows="5" cols="200" name="RMRK_CN" id="RMRK_CN"><%=empMap.get("RMRK_CN")==null?"":empMap.get("RMRK_CN").toString()%></textarea>
					</td>
				</tr>
			</table>
		</div>
		<hr class="margin20">
		<div class="subBtnW center">
			<a href="#none" class="sBtn type1" onclick="goInfoSave();">저장</a>
		</div>
	</div>
</form>