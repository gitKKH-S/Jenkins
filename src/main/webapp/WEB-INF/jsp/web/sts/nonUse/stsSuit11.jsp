<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.statistics.service.*"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.util.*"%>
<%
	Calendar cal = Calendar.getInstance();
	cal.add(cal.YEAR,-1);
	System.out.println();

	String txtStartDate = request.getParameter("txtStartDate")==null?"":request.getParameter("txtStartDate");
	String txtEndDate = request.getParameter("txtEndDate")==null?MakeHan.get_data():request.getParameter("txtEndDate");
	System.out.println("txtStartDate >>>>>>> " + txtStartDate);
	System.out.println("txtEndDate >>>>>>> " + txtEndDate);
	if(txtStartDate.equals("")){
		txtStartDate = cal.get(cal.YEAR)+"-"+(cal.get(cal.MONTH)+1)+"-"+cal.get(cal.DATE);
	}
	if(txtEndDate.equals("")){
		txtEndDate = MakeHan.get_data();
	}
	
	StatisticsService service = StatisticsServiceHelper.getStatisticsService(application);
	HashMap para = new HashMap();
	para.put("txtStartDate", txtStartDate);
	para.put("txtEndDate", txtEndDate);
	List list = service.getSuitMainList(para);
	List list2 = service.getSuitMainList2(para);
	
	
	HashMap rowinfo = new HashMap();
	for(int i=0; i<list2.size(); i++){
		HashMap result = (HashMap)list2.get(i);
		rowinfo.put("R"+result.get("SUITID"), result.get("CNT"));
	}
%>
<%-- 
<link rel="stylesheet" href="${resourceUrl}/paramquery-3.3.2/lib/jquery-ui.css" /><!-- 1.11.4 -->
<script src="${resourceUrl}/paramquery-3.3.2/lib/jquery.min.js"></script>    <!-- 1.8.3 -->
<script src="${resourceUrl}/paramquery-3.3.2/lib/jquery-ui.min.js"></script><!-- 1.11.4 -->
<!--ParamQuery Grid css files-->
<link rel="stylesheet" href="${resourceUrl}/paramquery-3.3.2/pqgrid.min.css" />    
<!--add pqgrid.ui.css for jQueryUI theme support-->
<link rel="stylesheet" href="${resourceUrl}/paramquery-3.3.2/pqgrid.ui.min.css" />
<!--ParamQuery Grid js files-->
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/pqgrid.min.js" ></script>   
<!--Include Touch Punch file to provide support for touch devices (optional)-->
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/touch-punch/touch-punch.min.js" ></script>   
<!--Include jsZip file to support xlsx and zip export (optional)-->
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/jsZip-2.5.0/jszip.min.js" ></script> 
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/localize/pq-localize-ko.js" ></script>
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/FileSaver.js-master/FileSaver.min.js" ></script>

<link rel="stylesheet" href="${resourceUrl}/paramquery-3.3.2/pqSelect/pqselect.min.css" />
<script type="text/javascript" src="${resourceUrl}/paramquery-3.3.2/pqSelect/pqselect.min.js" ></script>   

<link id="calendar_month" href="${resourceUrl}/css/calendar_month.css" rel="stylesheet" />
<link id="calendar_year" href="${resourceUrl}/css/calendar_year.css" rel="stylesheet" />
<script src="${resourceUrl}/js/mten.statistics.js"></script>
 --%>
<script type="text/javascript">
	function setSchDate(){
		document.frm.action="${pageContext.request.contextPath}/web/statistics/stsSuit11.do?txtStartDate="+$("#txtStartDate").val()+"&txtEndDate="+$("#txtEndDate").val();
		document.frm.submit();
	}
	
	function dateMask(info, val){
		if(event.keyCode == 13){
			setSchDate();
		}
		
		var obj = "";
		val = val.replace(/-/gi, "");
		if(val.length == 8){
			obj = val.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
			$("#"+info.id).val(obj);
		}else if(val.length == 6){
			obj = val.replace(/(\d{4})(\d{2})/, '$1-$2');
			$("#"+info.id).val(obj);
		}
		
	}
	
</script>
<style>
	/* th{border:1px solid #ececf1;}
	td{border:1px solid #ececf1;}
	table{border:1px solid #ececf1; width:1000%;} */
</style>
<form id="frm" name="frm" method="post" action="">
</form>
<div class="subCA">
	<strong id="subTT" class="subTT"></strong>
	<div class="innerB">
		<table class="infoTable write" style="width:100%">
			<colgroup>
				<col style="width:10%;">
				<col style="width:10%;">
				<col style="width:10%;">
				<col style="width:*;">
				<col style="width:*;">
			</colgroup>
			<tr>
				<th>검색구분</th>
				<td>
				<!-- 
					<input type="radio" name="searchGbn" class="searchGbn" value="d" checked="checked" /><label>  일별  </label>
			        <input type="radio" name="searchGbn" class="searchGbn" value="m" /><label>  월별  </label>
			        <input type="radio" name="searchGbn" class="searchGbn" value="y" /><label>  년도별    </label>
			         -->
				</td>
				<td>
					<input type="text" id="txtStartDate" maxlength="12" style="width:150px" value="<%=txtStartDate %>" onkeyup="dateMask(this, this.value);"/>
			        ~
			        <input type="text" id="txtEndDate" maxlength="12" style="width:150px" value="<%=txtEndDate %>" onkeyup="dateMask(this, this.value);"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="subBtnW center">
		<a href="#none" id="btnSubmit" onclick="setSchDate();" class="sBtn type1">검색</a>
		<a href="${pageContext.request.contextPath}/stsSuit12.jsp?txtStartDate=<%=txtStartDate %>&txtEndDate=<%=txtEndDate %>" class="sBtn type1">엑셀 다운로드</a>
	</div>
	<div class="innerB" style="height:80%; overflow:scroll;">
		<table class="infoTable" style="width:1000%; table-layout:auto;">
			<tr>
				<th>소송유형</th>
				<th>소송구분</th>
				<th>진행상태</th>
				<th>사건번호</th>
				<th>사건명</th>
				<th>사건개요</th>
				<th>쟁점사항</th>
				<th>원고</th>
				<th>원고대리인</th>
				<th>원고 보조참가</th>
				<th>피고</th>
				<th>피고대리인</th>
				<th>소송가액</th>
				<th>원고소가</th>
				<th>피고소가</th>
				<th>관할법원</th>
				<th>재판부</th>
				<th>재판 결과</th>
				<th>판결분류</th>
				<th>판결내용</th>
				<th>판결금액</th>
				<th>제ㆍ피소일</th>
				<th>선고일</th>
				<th>판결확정일</th>
				<th>병합여부</th>
			</tr>
			<%
				String pSUITID = "";
				System.out.println(rowinfo);
				System.out.println(rowinfo.get("R"+10257));
				for(int i=0; i<list.size(); i++){
					HashMap result = (HashMap)list.get(i);
					String SUITID = result.get("SUITID").toString();
					String rowspan = rowinfo.get("R"+SUITID)==null?"1":rowinfo.get("R"+SUITID).toString();
					boolean rowfg = false;
					if(rowspan.equals("1")){
						rowfg = true;
					}else{
						if(SUITID.equals(pSUITID)){
							rowfg = false;
						}else{
							rowfg = true;
						}
					}
					pSUITID = SUITID;
			%>	
					<tr>
						<%
							if(rowfg){
						%>
						<td rowspan="<%=rowspan%>"><%=result.get("SUITTYPE")==null?"":result.get("SUITTYPE")  %></td>
						<td rowspan="<%=rowspan%>"><%=result.get("SUITGBN")==null?"":result.get("SUITGBN")  %></td>
						<%
							}
						%>
						<td><%=result.get("PROGRESS")==null?"":result.get("PROGRESS")  %></td>
						<td><%=result.get("CASENUM")==null?"":result.get("CASENUM")  %></td>
						<%
							if(rowfg){
						%>
						<td rowspan="<%=rowspan%>"><%=result.get("SUITNM")==null?"":result.get("SUITNM")%></td>
						<td rowspan="<%=rowspan%>"><%=result.get("SUITCONT")==null?"":result.get("SUITCONT") %></td>
						<td rowspan="<%=rowspan%>"><%=result.get("ISSUECONT")==null?"":result.get("ISSUECONT") %></td>
						<%
							}
						%>
						<td><%=result.get("WONGO")==null?"":result.get("WONGO") %></td>
						<td><%=result.get("WONGOLAWYER")==null?"":result.get("WONGOLAWYER") %></td>
						<td><%=result.get("WONSUB")==null?"":result.get("WONSUB") %> </td>
						<td><%=result.get("PIGO")==null?"":result.get("PIGO") %></td>
						<td><%=result.get("PIGOLAWYER")==null?"":result.get("PIGOLAWYER") %></td>
						<td><%=result.get("SUITAMT")==null?"":result.get("SUITAMT") %></td>
						<td><%=result.get("WONGOAMT")==null?"":result.get("WONGOAMT") %></td>
						<td><%=result.get("PIGOAMT")==null?"":result.get("PIGOAMT") %></td>
						<td><%=result.get("COURTNM")==null?"":result.get("COURTNM") %></td>
						<td><%=result.get("CASEJUDGE")==null?"":result.get("CASEJUDGE") %></td>
						<td><%=result.get("CASERESULT")==null?"":result.get("CASERESULT") %> </td>
						<td><%=result.get("JDGMTGBN")==null?"":result.get("JDGMTGBN") %></td>
						<td><%=result.get("JDGMTCONT")==null?"":result.get("JDGMTCONT") %></td>
						<td><%=result.get("JDGMTAMT")==null?"":result.get("JDGMTAMT") %></td>
						<td><%=result.get("MAKECASEDT")==null?"":result.get("MAKECASEDT") %></td>
						<td><%=result.get("JDGMTDT")==null?"":result.get("JDGMTDT") %></td>
						<td><%=result.get("FINALDT")==null?"":result.get("FINALDT") %></td>
						<%
							if(rowfg){
						%>
						<td rowspan="<%=rowspan%>"><%=result.get("MERGEYN")==null?"":result.get("MERGEYN") %></td>
						<%
							}
						%>
					</tr>
			<%
				}
			%>
		</table>
	</div>
</div>
