<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.mten.util.MakeHan"%>
<%@ page import="com.mten.bylaw.law.service.*"%>
<%
	String title = ServletRequestUtils.getStringParameter(request, "title", "");
	title = MakeHan.toKorean2(title);
	LawService lawService = LawServiceHelper.getLawService(application);
	HashMap para = new HashMap();
	para.put("LAWNAME", title);
	List slist = lawService.getLaw3List(para);
	
	int j = slist.size();
	String cols = "";
	if(j==3){
		cols = "33%,33%,33%";
	}if(j==2){
		cols = "50%,50%";
	}
%>
<frameset id="masterFrameset" cols="<%=cols%>">
	<%
		for(int i=0; i<slist.size(); i++){
			HashMap lawBon =(HashMap)slist.get(i);
	%>
	<frame src="lawView.do?LAWID=<%=lawBon.get("LAWID") %>" frameborder="1"/>
	<%
		}
	%>
</frameset>