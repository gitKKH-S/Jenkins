<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="kw.law.bylaw.quickCat.service.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@page import="org.springframework.web.bind.ServletRequestUtils"%>
<%
	QuickCatService service = QuickCatServiceHelper.getQuickCatService(application);

	String job = ServletRequestUtils.getStringParameter(request,"job","");
	String schTxt = ServletRequestUtils.getStringParameter(request,"schTxt","");
	String obookId = ServletRequestUtils.getStringParameter(request,"obookId","");
	String gbn = ServletRequestUtils.getStringParameter(request,"gbn","");
	String quickCatId = ServletRequestUtils.getStringParameter(request,"quickCatId","");
	
	String jsonResult = "";
	System.out.println("====quickCat_proc.jsp=============="+job);
	System.out.println("schTxt : "+schTxt);
	System.out.println("obookId : "+obookId);
	System.out.println("gbn : "+gbn);
	System.out.println("quickCatId : "+quickCatId);

	
	HashMap para = new HashMap();
	para.put("schTxt",schTxt);
	para.put("obookId",obookId);
	para.put("gbn",gbn);
	para.put("quickCatId",quickCatId);
	
	//위원 insert
	if(job.equals("selectLawList")){
		
		jsonResult = service.selectLawList(para);
		
	}else if(job.equals("insertQuickCat")){
		
		jsonResult = service.insertQuickCat(para);
		
	}else if(job.equals("selectQuickCatList")){
		
		jsonResult = service.selectQuickCatList(para);
		
	}else if(job.equals("deleteQuickCat")){
		
		jsonResult = service.deleteQuickCat(para);
		
	}else if(job.equals("selectBoxQuickCat")){
		
		jsonResult = service.selectBoxQuickCat();
		
	}
	
	System.out.println(jsonResult);
 	out.print(jsonResult);
	
%>