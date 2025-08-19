<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@	page import="com.mten.util.*"%>
<%
	HashMap mtenMap = request.getAttribute("mtenMap")==null?new HashMap():(HashMap)request.getAttribute("mtenMap");
	HashMap map = request.getAttribute("map")==null?new HashMap():(HashMap)request.getAttribute("map");
	List result = map.get("list")==null?new ArrayList():(List)map.get("list");
	int total = map.get("total")==null?0:Integer.parseInt(map.get("total").toString());
	int pagesize = mtenMap.get("pagesize")==null?10:Integer.parseInt(mtenMap.get("pagesize").toString());
	String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
	
	int cnt = mtenMap.get("cnt")==null?0:Integer.parseInt(mtenMap.get("cnt").toString());
	
	String pageno = mtenMap.get("pageno")==null?"1":mtenMap.get("pageno").toString();
	String schTxt = mtenMap.get("schTxt")==null?"":mtenMap.get("schTxt").toString();
	String gbn = request.getAttribute("gbn")==null?"":request.getAttribute("gbn").toString();
%>
<style>
	#hidden{display:none;}
	th{text-align:center;}
	#suitnm:hover{cursor:pointer; text-decoration:underline;}
</style>
<script src="${resourceUrl}/js/mten.pagenav.js" type="text/javascript"></script>
<script type="text/javascript">
	
	var total = <%=total%>; // 총 건수
	var gbn = "<%=gbn%>";
	var cnt = "<%=cnt%>";
	
	$(document).ready(function(){
		var width =  $(".popA").width();
		$(".paging").css("margin-left", ((width-$(".paging").width())/2));
		
		$("#schTxt").keydown(function(key) {
			if (key.keyCode == 13) {
				$('#searchBtn').trigger('click');
			}
		});
		
		$("#searchBtn").click(function(){
			goReloadList();
		});
	});
	
	function goSelect(LWS_MNG_NO, LWS_INCDNT_NM, INST_NM, INCDNT_NO){
		opener.document.getElementById("MER_LWS_MNG_NO"+cnt).value    = LWS_MNG_NO;
		opener.document.getElementById("MER_LWS_INCDNT_NM"+cnt).value = LWS_INCDNT_NM;
		opener.document.getElementById("MER_INST_NM"+cnt).value       = INST_NM;
		opener.document.getElementById("MER_INCDNT_NO"+cnt).value     = INCDNT_NO;
		alert(LWS_INCDNT_NM + "이(가) 선택되었습니다.");
		window.close();
	}
	
	function goReloadList(){
		var f = document.forms["goList"];
		f.pageno.value = "";
		f.submit();
	}
</script>
<style>
	.active{
		background-color:#009475; color:white;
	}
	.popW{height:619px}
	/* .popA{max-height:400px;} */
	#caseList td{overflow:hidden; text-overflow:ellipsis; white-space:nowrap;}
</style>
<form id="goList" name="goList" method="post" action="">
	
	<input name="LWS_MNG_NO" type="hidden" value="<%=LWS_MNG_NO %>"/>
	<input name="pageno" type="hidden" value="<%=pageno %>"/>
	<strong class="popTT">
		사건 검색
		<a href="#none" class="popClose" onclick="window.close();">닫기</a>
	</strong>
	<div class="popC">
		<div class="popSrchW">
			<input type="radio" name="schGbn" id="schGbn3" value="A"><label>사건번호</label>
			<input type="radio" name="schGbn" id="schGbn4" value="B" checked="checked"><label>사건명</label>
			<input type="text"  name="schTxt" id="schTxt"  value="<%=schTxt%>" placeholder="검색 할 사건명을 입력하세요">
			<a href="#none" id="searchBtn" class="sBtn type1" onclick="javascript:goReloadList();">검색</a>
		</div>
		<div class="popA">
			<table class="pop_listTable" id="caseList" >
				<colgroup>
					<col style="width:15%;">
					<col style="width:*;">
					<col style="width:5%;">
					<col style="width:10%;">
					<col style="width:10%;">
					<col style="width:*;">
				</colgroup>
				<tr>
					<th>사건번호</th>
					<th>사건명</th>
					<th>구분</th>
					<th>심급</th>
					<th>진행상태</th>
					<th>소송상대방</th>
				</tr>
<%
				for(int i=0; i<result.size(); i++){
					HashMap resultMap = (HashMap)result.get(i);
%>
				<tr class="caseinfo">
					<td id="hidden"><%=resultMap.get("LWS_MNG_NO")==null?"":resultMap.get("LWS_MNG_NO").toString()%></td>
					<td id="hidden"><%=resultMap.get("INST_MNG_NO")==null?"":resultMap.get("INST_MNG_NO").toString()%></td>
					<td><%=resultMap.get("INCDNT_NO")==null?"":resultMap.get("INCDNT_NO").toString()%></td>
					<td id="suitnm" 
						onclick="goSelect('<%=resultMap.get("LWS_MNG_NO")%>','<%=resultMap.get("LWS_INCDNT_NM")%>',
						'<%=resultMap.get("INST_NM")%>','<%=resultMap.get("INCDNT_NO")%>');">
						<%=resultMap.get("LWS_INCDNT_NM")==null?"":resultMap.get("LWS_INCDNT_NM").toString()%>
					</td>
					<td><%=resultMap.get("LWS_UP_TYPE_NM")==null?"":resultMap.get("LWS_UP_TYPE_NM").toString()%></td>
					<td><%=resultMap.get("INST_NM")==null?"":resultMap.get("INST_NM").toString()%></td>
					<td><%=resultMap.get("PRGRS_STTS_NM")==null?"진행중":resultMap.get("PRGRS_STTS_NM").toString()%></td>
					<td><%=resultMap.get("LWS_CNCPR_NM")==null?"":resultMap.get("LWS_CNCPR_NM").toString()%></td>
				</tr>
<%
				}
%>
			</table>
		</div>
	</div>
	<div class="paging" style="display:inline-block;">
		<script type="text/javascript">
			document.write( pageNav( "gotoPage", <%=pageno%>, <%=pagesize%>, <%=total%> ) );
		</script>
	</div>
</form>