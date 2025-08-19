<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*"%>
<%@ page import="javax.xml.transform.*"%>
<%@ page import="javax.xml.transform.stream.*"%>
<%@ page import="com.mten.util.*"%>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	String Bookid = param.get("bookid")==null?"":param.get("bookid").toString();
	String Contid = param.get("Contid")==null?"":param.get("Contid").toString();
	String Contno = param.get("Contno")==null?"":param.get("Contno").toString();
	String Contsubno = param.get("Contsubno")==null?"":param.get("Contsubno").toString();
	String allcha = param.get("allcha")==null?"":param.get("allcha").toString();
	String print = param.get("print")==null?"":param.get("print").toString();
	
	HashMap bookInfo = request.getAttribute("bookInfo")==null?new HashMap():(HashMap)request.getAttribute("bookInfo");
	
	String xmldata = bookInfo.get("XMLDATA")==null?"":bookInfo.get("XMLDATA").toString();
	String Revcha = bookInfo.get("REVCHA")==null?"":bookInfo.get("REVCHA").toString();
	
	String xsl_name="printPop.xsl";
	String XSLURL = MakeHan.File_url("XSL");
%>
<title></title>
<link rel="stylesheet" type="text/css" href="<%=CONTEXTPATH%>/jsp/lkms3/css/total.css" />
<style type="text/css">
	body{
		scrollbar-shadow-color:#c9d0d9;
		scrollbar-highlight-color:#FFFFFF;
		scrollbar-face-color:#9ebfeb;
		scrollbar-3dlight-color:#9EBFEB;
		scrollbar-darkshadow-color:#9EBFEB;
		scrollbar-track-color:#FFFFFF;
		scrollbar-arrow-color:#FFFFFF;
		margin:0;
	}
	#pop_container {
		background:#e9edf2 url(<%=CONTEXTPATH%>/jsp/lkms3/images/icon/admin_logo.gif) no-repeat top right;
		padding:10px 0 0 0;
	}

	#pop_container h1 {
		color:#293853;
		font-family:Malgun Gothic, Dotum;
		background:url(<%=CONTEXTPATH%>/jsp/lkms3/images/icon/caption_bullet5.gif) no-repeat 5px top;
		margin:0;
		padding:10px 0;
		padding-left:19px;
		font-size:15px;
	}
	#contents_box {
		background:#fff;
		border:1px solid #9fb0cd;
		margin-left:auto;
		margin-right:auto;
		padding:5px;
		line-height:1.7em;
		color:#777;
	}
</style>
<body>
		<%
			StreamSource xml = new StreamSource(new StringReader(xmldata));
			String xslurl =XSLURL+xsl_name;
			File xsl = new File(xslurl);
			TransformerFactory tFactory = TransformerFactory.newInstance();
			/*
			하나의 스타일시트를 두 번이상 사용하면 Templates 객체를 사용하는 것이 좋다. 
			XSL 스타일시트를 자바 객체로 변환하는 과정을 반복하지 않으므로 더 성능이 좋다. 
			다중 쓰레드 환경에서는 Templates 꼭 사용해야 한다
			*/
			
			Templates template = tFactory.newTemplates(new StreamSource(xsl));
			Transformer transformer = template.newTransformer();

			transformer.setParameter("bookid",Bookid);
			transformer.setParameter("revcha",Revcha);
			transformer.setParameter("contno",Contno);
			transformer.setParameter("contsubno",Contsubno);
			transformer.setParameter("allcha",allcha);
			transformer.setParameter("Contid",Contid);
			transformer.transform(xml, new StreamResult(out));
		%>


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