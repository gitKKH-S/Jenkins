<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mten.bylaw.statistics.service.*"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.util.*"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-excel"); 
response.setHeader("Content-Disposition", "attachment; filename=excelFile.xls"); 
response.setHeader("Content-Disposition", "JSP Generated Data"); 
	
	Calendar cal = Calendar.getInstance();
	cal.add(cal.YEAR,-1);
	System.out.println();
	String txtStartDate = request.getParameter("txtStartDate")==null?"":request.getParameter("txtStartDate");
	String txtEndDate = request.getParameter("txtEndDate")==null?MakeHan.get_data():request.getParameter("txtEndDate");
	
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

		<table width="100%" style="border:1px solid #ececf1;">
			<tr style="border:1px solid #ececf1; ">
				<th style="border:1px solid #ececf1;">소송유형</th>
				<th style="border:1px solid #ececf1;">소송구분</th>
				<th style="border:1px solid #ececf1;">진행상태</th>
				<th style="border:1px solid #ececf1;">사건번호</th>
				<th style="border:1px solid #ececf1;">사건명</th>
				<th style="border:1px solid #ececf1;">사건개요</th>
				<th style="border:1px solid #ececf1;">쟁점사항</th>
				<th style="border:1px solid #ececf1;">원고</th>
				<th style="border:1px solid #ececf1;">원고대리인</th>
				<th style="border:1px solid #ececf1;">원고 보조참가</th>
				<th style="border:1px solid #ececf1;">피고</th>
				<th style="border:1px solid #ececf1;">피고대리인</th>
				<th style="border:1px solid #ececf1;">소송가액</th>
				<th style="border:1px solid #ececf1;">원고소가</th>
				<th style="border:1px solid #ececf1;">피고소가</th>
				<th style="border:1px solid #ececf1;">관할법원</th>
				<th style="border:1px solid #ececf1;">재판부</th>
				<th style="border:1px solid #ececf1;">재판 결과</th>
				<th style="border:1px solid #ececf1;">판결분류</th>
				<th style="border:1px solid #ececf1;">판결내용</th>
				<th style="border:1px solid #ececf1;">판결금액</th>
				<th style="border:1px solid #ececf1;">제ㆍ피소일</th>
				<th style="border:1px solid #ececf1;">선고일</th>
				<th style="border:1px solid #ececf1;">판결확정일</th>
				<th style="border:1px solid #ececf1;">병합여부</th>
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
						<th style="border:1px solid #ececf1;" rowspan="<%=rowspan%>"><%=result.get("SUITTYPE")==null?"":result.get("SUITTYPE")  %></th>
						<th style="border:1px solid #ececf1;" rowspan="<%=rowspan%>"><%=result.get("SUITGBN")==null?"":result.get("SUITGBN")  %></th>
						<%
							}
						%>
						<th style="border:1px solid #ececf1;"><%=result.get("PROGRESS")==null?"":result.get("PROGRESS")  %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("CASENUM")==null?"":result.get("CASENUM")  %></th>
						<%
							if(rowfg){
						%>
						<th style="border:1px solid #ececf1;" rowspan="<%=rowspan%>"><%=result.get("SUITNM")==null?"":result.get("SUITNM")%></th>
						<th style="border:1px solid #ececf1;" rowspan="<%=rowspan%>"><%=result.get("SUITCONT")==null?"":result.get("SUITCONT") %></th>
						<th style="border:1px solid #ececf1;" rowspan="<%=rowspan%>"><%=result.get("ISSUECONT")==null?"":result.get("ISSUECONT") %></th>
						<%
							}
						%>
						<th style="border:1px solid #ececf1;"><%=result.get("WONGO")==null?"":result.get("WONGO") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("WONGOLAWYER")==null?"":result.get("WONGOLAWYER") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("WONSUB")==null?"":result.get("WONSUB") %> </th>
						<th style="border:1px solid #ececf1;"><%=result.get("PIGO")==null?"":result.get("PIGO") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("PIGOLAWYER")==null?"":result.get("PIGOLAWYER") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("SUITAMT")==null?"":result.get("SUITAMT") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("WONGOAMT")==null?"":result.get("WONGOAMT") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("PIGOAMT")==null?"":result.get("PIGOAMT") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("COURTNM")==null?"":result.get("COURTNM") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("CASEJUDGE")==null?"":result.get("CASEJUDGE") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("CASERESULT")==null?"":result.get("CASERESULT") %> </th>
						<th style="border:1px solid #ececf1;"><%=result.get("JDGMTGBN")==null?"":result.get("JDGMTGBN") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("JDGMTCONT")==null?"":result.get("JDGMTCONT") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("JDGMTAMT")==null?"":result.get("JDGMTAMT") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("MAKECASEDT")==null?"":result.get("MAKECASEDT") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("JDGMTDT")==null?"":result.get("JDGMTDT") %></th>
						<th style="border:1px solid #ececf1;"><%=result.get("FINALDT")==null?"":result.get("FINALDT") %></th>
						<%
							if(rowfg){
						%>
						<th style="border:1px solid #ececf1;" rowspan="<%=rowspan%>"><%=result.get("MERGEYN")==null?"":result.get("MERGEYN") %></th>
						<%
							}
						%>
					</tr>
			<%
				}
			%>
		</table>
