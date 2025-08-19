<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%
	String WRTR_EMP_NM     = request.getAttribute("WRTR_EMP_NM")==null?"":request.getAttribute("WRTR_EMP_NM").toString();
	String WRTR_EMP_NO     = request.getAttribute("WRTR_EMP_NO")==null?"":request.getAttribute("WRTR_EMP_NO").toString();
	String WRT_DEPT_NM     = request.getAttribute("WRT_DEPT_NM")==null?"":request.getAttribute("WRT_DEPT_NM").toString();
	String WRT_DEPT_NO     = request.getAttribute("WRT_DEPT_NO")==null?"":request.getAttribute("WRT_DEPT_NO").toString();
	
	HashMap mtenMap = request.getAttribute("mtenMap")==null?new HashMap():(HashMap)request.getAttribute("mtenMap");
	HashMap map = request.getAttribute("map")==null?new HashMap():(HashMap)request.getAttribute("map");
	HashMap map2 = request.getAttribute("map2")==null?new HashMap():(HashMap)request.getAttribute("map2");
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
	String cnt = request.getAttribute("cnt")==null?"":request.getAttribute("cnt").toString();
	
	List result  = map.get("list")==null?new ArrayList():(List)map.get("list");
	List relList = map2.get("list")==null?new ArrayList():(List)map2.get("list");
	int total = map.get("total")==null?0:Integer.parseInt(map.get("total").toString());
	int pagesize = mtenMap.get("pagesize")==null?15:Integer.parseInt(mtenMap.get("pagesize").toString());
	//int pageno = mtenMap.get("pageno")==null?1:Integer.parseInt(mtenMap.get("pageno").toString());
	
	String pageno = mtenMap.get("pageno")==null?"":mtenMap.get("pageno").toString();
	String PK = mtenMap.get("PK")==null?"":mtenMap.get("PK").toString();
	String schGbn = mtenMap.get("schGbn")==null?"":mtenMap.get("schGbn").toString();
	String schTxt = mtenMap.get("schTxt")==null?"":mtenMap.get("schTxt").toString();
%>
<style>
	.pop_listTable{width:100%}
	.popA{height:245px; overflow-y:scroll;}
	#hidden{display:none;}
	th{text-align:center;}
	#schTxt{width:55%;}
	#searchBtn{height:30px; line-height:30px; margin:3px 0px 0px 0px;}
	.paging{margin-top:15px;}
</style>
<script src="${resourceUrl}/js/mten.pagenav.js" type="text/javascript"></script>
<script type="text/javascript">
	
	var total = <%=total%>; // 총 건수
	var gbn = "<%=gbn%>";
	var cnt = "<%=cnt%>";
	
	var PK = '<%=PK%>';
	var pageno = '<%=pageno%>';
	var schGbn = '<%=schGbn%>';
	var relcaseid = new Array();
	var relgbn = new Array();
	var relidx = 0;
	$(document).ready(function(){
		var width =  $(".popA").width();
		
		
		console.log("pageno : "+pageno);
		
		$("#pageno").val(pageno);
		$('input:radio[name="schGbn"]:radio[value="'+schGbn+'"]').prop("checked", true);
		
		$(".paging").css("margin-left", ((width-$(".paging").width())/2));
		
		$("#schTxt").keydown(function(key) {
			if (key.keyCode == 13) {
				if ($("#schTxt").val().length < 2) {
					return alert("검색어는 2자 이상 입력해야 합니다.");
				} else {
					$('#searchBtn').trigger('click');
				}
			}
		});
		
		$("#searchBtn").click(function(){
			if ($("#schTxt").val().length < 2) {
				return alert("검색어는 2자 이상 입력해야 합니다.");
			} else {
				goReloadList();
			}
		});
	});
	
	function goSelect(relpk, gbn){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/saveRelCase.do",
			data:{MAIN_DOC_MNG_NO:PK, REL_DOC_MNG_NO:relpk, DOC_SE:gbn},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				goReloadList();
			}
		});
	}
	
	function deleteRelCase(relpk){
		$.ajax({
			type:"POST",
			url:"${pageContext.request.contextPath}/web/suit/deleteRelCase.do",
			data:{MAIN_DOC_MNG_NO:PK, REL_DOC_MNG_NO:relpk},
			dataType:"json",
			async:false,
			success:function(result){
				alert(result.msg);
				goReloadList();
			}
		});
	}
	
	function goReloadList(){
		var f = document.forms["goList"];
		f.pageno.value = "";
		f.submit();
	}
	
	// 페이지 클릭해도 controller에는 pageno가 무조건 1로 넘어감, 확인 필요
</script>
<form id="goList" name="goList" method="post" action="<%=CONTEXTPATH%>/web/suit/caseSearchPop.do">
	<input name="pageno" id="pageno" type="hidden" value="<%=pageno%>"/>
	<input name="PK"     id="PK"     type="hidden" value="<%=PK%>"/>
	
	<strong class="popTT">
		문서 검색 <span style="font-size:12px; color:#57b9ba"></span>
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC" style="height:720px;">
		<div class="popSrchW">
			<input type="radio" name="schGbn" id="schGbn3" value="S" <%if(schGbn.equals("") || "S".equals(schGbn)) out.println("checked");%>><label>소송</label>
			<input type="radio" name="schGbn" id="schGbn4" value="C" <%if("C".equals(schGbn)) out.println("checked");%>><label>자문</label>
			<input type="radio" name="schGbn" id="schGbn5" value="A" <%if("A".equals(schGbn)) out.println("checked");%>><label>협약</label>
			<input type="text" id="schTxt" name="schTxt" value="<%=schTxt%>" placeholder="검색어를 입력하세요">
			<a href="#none" id="searchBtn" class="sBtn type1" onclick="javascript:goReloadList();">검색</a>
		</div>
		<div class="popA">
			<table class="pop_listTable" id="caseList">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
				</colgroup>
				<tr>
					<th>구분</th>
					<th>문서명</th>
					<th>선택</th>
				</tr>
<%
				for(int i=0; i<result.size(); i++){
					HashMap resultMap = (HashMap)result.get(i);
					String getgbn = resultMap.get("GBN")==null?"":resultMap.get("GBN").toString();
					String viewGbn = "";
					if("S".equals(getgbn)) {
						viewGbn = "소송";
					} else if("C".equals(getgbn)) {
						viewGbn = "자문";
					} else if("A".equals(getgbn)) {
						viewGbn = "협약";
					}
%>
				<tr>
					<td><%=viewGbn%></td>
					<td><%=resultMap.get("DOC_NM")%></td>
					<td>
						<a href="#none" class="innerBtn" onclick="goSelect('<%=resultMap.get("DOC_PK")%>','<%=resultMap.get("GBN")%>','');">선택</a>
					</td>
				</tr>
<%
				}
%>
			</table>
		</div>
		<div class="paging" style="display:inline-block; margin-left:30%;">
			<script type="text/javascript">
				document.write( pageNav( "gotoPage", <%=pageno%>, <%=pagesize%>, <%=total%> ) );
			</script>
		</div>
		<hr class="margin10">
		<strong class="popSTT">관련 사건</strong>
		<div class="popA">
			<table class="pop_listTable" id="caseSelList">
				<colgroup>
					<col style="width:12%;">
					<col style="width:*;">
					<col style="width:12%;">
				</colgroup>
				<tr>
					<th>구분</th>
					<th>문서명</th>
					<th></th>
				</tr>
<%
				for(int i=0; i<relList.size(); i++){
					HashMap resultMap = (HashMap)relList.get(i);
%>
					<tr>
						<td><%=resultMap.get("DOC_SE_NM")%></td>
						<td><%=resultMap.get("DOC_NM")%></td>
						<td>
							<a href="#none" class="innerBtn" onclick="deleteRelCase('<%=resultMap.get("REL_DOC_MNG_NO")%>');">삭제</a>
						</td>
					</tr>
<%
				}
%>
			</table>
		</div>
	</div>
</form>