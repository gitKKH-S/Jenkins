<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	List list = request.getAttribute("bankList")==null?new ArrayList():(ArrayList)request.getAttribute("bankList");
	String schTxt = request.getAttribute("schTxt")==null?"":request.getAttribute("schTxt").toString();
	String idx = request.getAttribute("idx")==null?"":request.getAttribute("idx").toString();
%>
<style>
	.display-none{ /*감추기*/
		display:none;
	}
</style>

<script type="text/javascript">
	var idx = "<%=idx%>";
	$(document).ready(function(){
		$("#schTxt2").keydown(function(key){
			if (key.keyCode == 13) {
				document.frm.schTxt.value = $("#schTxt2").val();
				document.frm.action="<%=CONTEXTPATH%>/web/suit/searchBankPop.do";
				document.frm.submit();
			}
		});
	});
	
	function goSelect(couno, counm){
		opener.document.getElementById("BANK_SE_NO"+idx).value = couno;
		opener.document.getElementById("BANK_NM"+idx).value = counm;
		alert(counm + "이 선택 되었습니다.");
		window.close();
	}
</script>
<style>
	.popW{width:483px; min-width:483px;}
	table th{text-align:center;}
	.sel:hover{cursor:pointer; text-decoration:underline;}
	
</style>

<input type="hidden" id="cnt" value="0"/>

<form name="frm" id="frm" method="post">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="schTxt" id="schTxt" value="<%=schTxt%>">
	<input type="hidden" name="idx" id="idx" value="<%=idx%>">
</form>

<strong class="popTT" style="width:483px;">
	은행 검색
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div class="popC" style="width:483px; height:645px;">
	<div class="popSrchW">
		<input type="text" id="schTxt2" name="schTxt2" value="<%=schTxt%>" placeholder="검색할 이름을 입력 해 주세요" style="width:100%">
	</div>
	
	<table class="pop_listTable">
		<colgroup>
			<col style="width:*;">
		</colgroup>
		<tr>
			<th id="gbnTitle">은행명</th>
		</tr>
	</table>
	
	<div class="popA" style="max-height:500px;">
		<table class="pop_listTable" id="courtList">
			<colgroup>
				<col style="width:*;">
			</colgroup>
			<%
		if(list.size() > 0) {
			for(int i=0; i<list.size(); i++) {
				HashMap map = (HashMap) list.get(i);
		%>
		<tr>
			<td class="sel" onclick="goSelect('<%=map.get("CD_MNG_NO").toString()%>', '<%=map.get("CD_NM").toString()%>')">
				<%=map.get("CD_NM").toString()%>
			</td>
		</tr>
		<%
			}
		} else {
		%>
		<tr>
			<td>조회 된 은행정보가 없습니다.</td>
		</tr>
		<%
		}
		%>
		</table>
	</div>
</div>