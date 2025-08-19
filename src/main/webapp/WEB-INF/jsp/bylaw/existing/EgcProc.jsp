<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="java.util.*"%>
<%
	String pstate = ServletRequestUtils.getStringParameter(request,"PSTATE", "");					//등록,수정,개정여부
	String bonTxt = request.getAttribute("bonTxt")==null?"":request.getAttribute("bonTxt").toString();
	HashMap docInfo = request.getAttribute("docInfo")==null?new HashMap():(HashMap)request.getAttribute("docInfo");
	String STATECD = docInfo.get("STATECD")==null?"":docInfo.get("STATECD").toString();
	String BOOKCD = docInfo.get("BOOKCD")==null?"":docInfo.get("BOOKCD").toString();
	
	if(STATECD.equals("1000")||STATECD.equals("1100")||STATECD.equals("1200")){
		STATECD = "BANGCHIMAN";
	}else if(STATECD.equals("1300")){
		STATECD = "IBBUBYEGOAN";
	}else if(STATECD.equals("1400")||STATECD.equals("1500")||STATECD.equals("1600")){
		STATECD = "LASTAN";
	}else if(STATECD.equals("1700")){
		STATECD = "LASTAN";
	}else if(STATECD.equals("1800") || STATECD.equals("1900")){
		STATECD = "DOSAJUNBOGO";
	}else if(STATECD.equals("4000")){
		if("의회훈령,예규".indexOf(BOOKCD)>-1) {
			STATECD = "HUNBALREONGMUN";
		}else {
			STATECD = "GONGPOMUN";
		}
	}
	out.println(bonTxt);
%>
<script src="${resourceUrl}/js/mten.static.js"></script>
<script src="${resourceUrl}/js/mten.makeXml.js"></script>
<script src="${resourceUrl}/js/mten.setup.js"></script>
<script>
<%
if(!pstate.equals("U")){
%>
var obj = new HashMap();
obj.put("exeform","lawxml");
obj.put("bookid","<%=docInfo.get("BOOKID")==null?"":docInfo.get("BOOKID")%>");
obj.put("statehistoryid","<%=docInfo.get("STATEHISTORYID")==null?"":docInfo.get("STATEHISTORYID")%>");
obj.put("revmode","3");
obj.put("filecd","<%=STATECD%>");
obj.put("sabun","<%=ServletRequestUtils.getStringParameter(request,"writerid", "")%>");
obj.put("before_statehistoryid","<%=docInfo.get("BEFORE_STATEHISTORYID")==null?"0":docInfo.get("BEFORE_STATEHISTORYID")%>");
chkSetUp(makeXML(obj));
<%
}
%>

<%
if(pstate.equals("I") || pstate.equals("RE") || pstate.equals("P") || pstate.equals("U")){
%>
parent.msghidden();
parent.msgbox2('<%=docInfo.get("BOOKID")%>','<%=docInfo.get("NOFORMYN")%>','<%=docInfo.get("STATEHISTORYID")%>');
parent.treload();
parent.close();
<%
}
%>
</script>