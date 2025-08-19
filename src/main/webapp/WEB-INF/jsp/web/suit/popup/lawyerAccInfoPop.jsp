<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%
	List list = request.getAttribute("bankList")==null?new ArrayList():(ArrayList)request.getAttribute("bankList");
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
%>
<style>
	.display-none{ /*감추기*/
		display:none;
	}
</style>

<script type="text/javascript">
	var gbn = "<%=gbn%>";
	$(document).ready(function(){
		
	});
	
	function goSelect(BACNT_MNG_NO, BANK_NM, DPSTR_NM, ACTNO){
		if (gbn == "CONSULT") {
			var ACCCNT = BANK_NM + " " + DPSTR_NM + " " + ACTNO;
			opener.document.getElementById("BACNT_MNG_NO").value = BACNT_MNG_NO;
			opener.document.getElementById("BACNT_INFO").value = ACCCNT;
		} else if (gbn == "SUIT") {
			opener.document.getElementById("BACNT_MNG_NO").value = BACNT_MNG_NO;
			opener.document.getElementById("BANK_NM").value = BANK_NM;
			opener.document.getElementById("DPSTR_NM").value = DPSTR_NM;
			opener.document.getElementById("ACTNO").value = ACTNO;
		} else if (gbn == "AGREE") {
			var ACCCNT = BANK_NM + " " + DPSTR_NM + " " + ACTNO;
			opener.document.getElementById("BACNT_MNG_NO").value = BACNT_MNG_NO;
			opener.document.getElementById("BACNT_INFO").value = ACCCNT;
		}
		alert("계좌정보가 선택 되었습니다.");
		window.close();
	}
</script>
<style>
	table th{text-align:center;}
	.sel:hover{cursor:pointer; text-decoration:underline;}
	.popW{min-width:570px;}
</style>

<input type="hidden" id="cnt" value="0"/>

<form name="frm" id="frm" method="post">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<input type="hidden" name="gbn" id="gbn" value="<%=gbn%>">
</form>

<strong class="popTT">
	계좌정보 검색
	<a href="#none" class="popClose" onclick="window.close();">닫기</a>
</strong>
<div class="popC">
	<table class="pop_listTable">
		<colgroup>
			<col style="width:15%;">
			<col style="width:15%;">
			<col style="width:*;">
		</colgroup>
		<tr>
			<th id="gbnTitle">은행명</th>
			<th id="gbnTitle">예금주명</th>
			<th id="gbnTitle">계좌번호</th>
		</tr>
	</table>
	
	<div class="popA" style="max-height:500px;">
		<table class="pop_listTable" id="courtList">
			<colgroup>
				<col style="width:15%;">
			<col style="width:15%;">
			<col style="width:*;">
			</colgroup>
			<%
		if(list.size() > 0) {
			for(int i=0; i<list.size(); i++) {
				HashMap map = (HashMap) list.get(i);
				String banknm = map.get("BANK_NM")==null?"":map.get("BANK_NM").toString();
				String dpstrnm = map.get("DPSTR_NM")==null?"":map.get("DPSTR_NM").toString();
				String actno = map.get("ACTNO")==null?"":map.get("BANK_NM").toString();
		%>
		<tr onclick="goSelect('<%=map.get("BACNT_MNG_NO").toString()%>', '<%=banknm%>', '<%=dpstrnm%>', '<%=actno%>')">
			<td class="sel"><%=banknm%></td>
			<td class="sel"><%=dpstrnm%></td>
			<td class="sel"><%=actno%></td>
		</tr>
		<%
			}
		} else {
		%>
		<tr>
			<td colspan="3">등록 된 계좌정보가 없습니다.</td>
		</tr>
		<%
		}
		%>
		</table>
	</div>
</div>