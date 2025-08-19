<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*"%>
<%@ page import="javax.xml.transform.*"%>
<%@ page import="javax.xml.transform.stream.*"%>
<%@ page import="com.mten.util.*"%>
<%
	HashMap param = request.getAttribute("param")==null?new HashMap():(HashMap)request.getAttribute("param");
	String Bookid = param.get("Bookid")==null?"":param.get("Bookid").toString();
	String Bcontid = param.get("bcontid")==null?"":param.get("bcontid").toString();
	String Contno = param.get("Contno")==null?"":param.get("Contno").toString();
	String Contsubno = param.get("Contsubno")==null?"":param.get("Contsubno").toString();
	String allcha = param.get("allcha")==null?"":param.get("allcha").toString();
	String print = param.get("print")==null?"":param.get("print").toString();
	
	HashMap oldjo = request.getAttribute("oldjo")==null?new HashMap():(HashMap)request.getAttribute("oldjo");
	HashMap bookInfo = oldjo.get("docInfo")==null?new HashMap():(HashMap)oldjo.get("docInfo");
	String xmldata = oldjo.get("xmldata")==null?"":oldjo.get("xmldata").toString();
	xmldata = xmldata.replaceAll("&amp;lt;span style=\"color: red; text-decoration: underline;\"&amp;gt;"," <span class=\"mten\">")
			.replaceAll("&amp;lt;span style=\"text-decoration:underline; color:red;\"&amp;gt;"," <span class=\"mten\">").replaceAll("&amp;lt;/span&amp;gt;","</span>").replaceAll("&amp;","&");
	xmldata = xmldata.replaceAll("&amp;lt;", "&lt;").replaceAll("&amp;gt;", "&gt;");
	xmldata = xmldata.replaceAll("&lt;span style=\"color: red; text-decoration: underline;\"&gt;"," <span class=\"mten\">").replaceAll("&lt;span style=\"text-decoration:underline; color:red;\"&gt;"," <span class=\"mten\">").replaceAll("&lt;/span&gt;","</span>");
	
	String xsl_name="oldnewjo.xsl";
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
		background:#e9edf2 url(<%=CONTEXTPATH%>/jsp/lkms3/images/icon/logo2.png) no-repeat top right;
		padding:10px 0 0 0;
	}

	#pop_container h1 {
		color:#293853;
		font-family:Malgun Gothic, Dotum;
		background:url(<%=CONTEXTPATH%>/jsp/lkms3/images/icon/caption_bullet52.gif) no-repeat 5px top;
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
<SCRIPT LANGUAGE="JavaScript">
function wid(a,b){
	var xwt;
	if(b==''){
		if(a==0){
			xwt='100%';
		}else{
			xwt='392';
		}
	}else{
		if(b==1){
			xwt='100%';
		}else{
			xwt='392';
		}
	}
	var oStyleSheet=document.styleSheets[0];
	   oStyleSheet.cssText='.xslk{width:380px;border=1px solid #CCC;}'+
		   						'.jotitle {font-size:13pt; font-weight:bold; color:#1956a1;}'+
		   						'.mten { text-decoration:underline; color:red;}'+
		   						'.jonumber {font-size:13pt; font-weight:bold; color:#1956a1;}'+
		   						'.jocontent {font-size:13pt; TEXT-ALIGN:justify;line-height:30px}'+
		   						'.jocontent2 {font-size:9pt; TEXT-ALIGN:justify;line-height:30px}'+
		   						'.ds {width:'+xwt+';}'+
		   						'.yunhyuk {font-size:10pt; font-family: "돋움"; color:"#007099"}';
}
function printJo(Bookid,Contno,Contsubno,allcha,bcontid){
	cw=502;
	 ch=320;
	  //스크린의 크기
	 sw=screen.availWidth;
	 sh=screen.availHeight;
	 //열 창의 포지션
	 px=(sw-cw)/2;
	 py=(sh-ch)/2;
	 //창을 여는부분		
	property="left="+px+",top="+py+",width=502,height=320,scrollbars=yes,resizable=no,status=no,toolbar=no";
	form=document.revi;
	window.open("joPop.do?Bookid=<%=Bookid%>&Contno=<%=Contno%>&Contsubno=<%=Contsubno%>&allcha=<%=allcha%>&bcontid=<%=Bcontid%>&print=P", Bookid, property);
}

</script>
<body>
<%if(!print.equals("P")){ %>
<div id="pop_container">
   	<h1>
   		조문연혁<span style="font-size:12px; color:#5674a7;"> (전부개정 이후 변경된 조문만 조회됩니다.)</span>
		&nbsp;<a  href="javascript:printJo();">인쇄하기</a>
	</h1>
	<div id="contents_box">
<table height="80%" style="border-bottom:1px solid #CCC" width="800" cellspacing="0" cellpadding="0">
	<tr>
<%} %>
		<%
			StreamSource xml = new StreamSource(new StringReader(xmldata));
		
		
			//String xsl_url = MakeHan.File_url("XSL");
			String xslurl =XSLURL+xsl_name;
			File xsl = new File(xslurl);
			TransformerFactory tFactory = TransformerFactory.newInstance();
//			Transformer transformer = tFactory.newTransformer(new StreamSource(xsl)); 


			/*
			하나의 스타일시트를 두 번이상 사용하면 Templates 객체를 사용하는 것이 좋다. 
			XSL 스타일시트를 자바 객체로 변환하는 과정을 반복하지 않으므로 더 성능이 좋다. 
			다중 쓰레드 환경에서는 Templates 꼭 사용해야 한다
			*/
			
			Templates template =
				tFactory.newTemplates(new StreamSource(xsl));
			Transformer transformer = template.newTransformer();
			

			transformer.setParameter("bookid",Bookid);
			transformer.setParameter("revcha",bookInfo.get("REVCHA"));
			transformer.setParameter("Contno",Contno);
			transformer.setParameter("Contsubno",Contsubno);
			transformer.setParameter("allcha",allcha);
			transformer.transform(xml, new StreamResult(out));
			
			//StringWriter stringWriter = new StringWriter();
			//transformer.transform(xml, new StreamResult(stringWriter));
			//String result = stringWriter.toString();
			//System.out.println(result);
			
			
			
		%>
<%if(!print.equals("P")){ %>
	</tr>
</table>
</div>
</div>
<%} %>
<%if(print.equals("P")){ %>
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
<%} %>
</body>