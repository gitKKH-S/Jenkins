<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*"%>
<%@ page import="javax.xml.transform.*"%>
<%@ page import="javax.xml.transform.stream.*"%>
<%@ page import="java.util.*" %>
<%
	HashMap bonInfo = request.getAttribute("bonInfo")==null?new HashMap() : (HashMap)request.getAttribute("bonInfo");
	HashMap meta = bonInfo.get("bookInfo")==null?new HashMap():(HashMap)bonInfo.get("bookInfo");
	HashMap param = bonInfo.get("param")==null?new HashMap() : (HashMap)bonInfo.get("param");
	List history = bonInfo.get("history")==null?new ArrayList(): (List)bonInfo.get("history");
	String fav = bonInfo.get("fav")==null?"0":bonInfo.get("fav").toString();
	String vtype = param.get("vtype")==null?"":param.get("vtype").toString();
%>
<title></title>
<link rel="stylesheet" href="${resourceUrl}/mnview/css/view13pt.css">
<link rel="stylesheet" href="${resourceUrl}/mnview/css/viewEtc.css">
<body>
<%=bonInfo.get("bon") %>
<script language="javascript">
	window.ieExecWB(7)
	//프린트 출력

	function ieExecWB( intOLEcmd, intOLEparam ){
		// 웹 브라우저 컨트롤 생성
		var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
		
		// 웹 페이지에 객체 삽입
		document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
		
		// if intOLEparam이 정의되어 있지 않으면 디폴트 값 설정
		if ( ( ! intOLEparam ) || ( intOLEparam < -1 )  || (intOLEparam > 1 ) )
		        intOLEparam = 1;
		
		// ExexWB 메쏘드 실행
		WebBrowser1.ExecWB( intOLEcmd, intOLEparam );
		
		// 객체 해제
		WebBrowser1.outerHTML = "";
		window.close();
	}

//>
</script>
</body>