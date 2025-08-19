<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.mten.bylaw.bylawweb.service.*"%>
<%@ page import="com.mten.util.MakeHan"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="javax.xml.transform.*"%>
<%@ page import="javax.xml.transform.stream.*"%>

<title></title>
<script language="javascript">
<!--
		window.focus();
		function move(){
		form=document.select_move;
		//alert(form.revision_sel.value);
		location.href="../../law_Popup.jsp?Book_id="+form.revision_sel.value;
	}
//--> 
</script>
<link rel="stylesheet" href="${resourceUrl}/mnview/css/view13pt.css">
<link rel="stylesheet" href="${resourceUrl}/mnview/css/viewEtc.css">
<link href="${resourceUrl}/mnview/css/viewPrt.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
* {
	font-family:  "돋움", "굴림";
	color: #333;
	margin:0px;
	padding:0px;
	font-size:12px;
}
-->
</style>

<%
	String Book_id_r = request.getParameter("Book_id_r")==null?"":request.getParameter("Book_id_r");
	String Book_id_c = request.getParameter("Book_id_c")==null?"":request.getParameter("Book_id_c");
	String Book_id_l = request.getParameter("Book_id_l")==null?"":request.getParameter("Book_id_l");
	String Book_id_l2 = request.getParameter("Book_id_l2")==null?"":request.getParameter("Book_id_l2");
	String Bookid = request.getParameter("Bookid")==null?"":request.getParameter("Bookid");
	String Bookid1="";
	String Bookid2="";
	String Bookid3="";
	int Gbn =0;
	if(!Book_id_l.equals("")&&!Book_id_c.equals("")&&!Book_id_r.equals("")&&!Book_id_l2.equals("")){
		Bookid1=Book_id_l;
		Bookid2=Book_id_c;
		Bookid3=Book_id_l2;
		Gbn=4;
	}else if(Book_id_l.equals("")&&!Book_id_c.equals("")&&!Book_id_r.equals("")){
		Bookid1=Book_id_c;
		Bookid2=Book_id_r;
		Gbn=2;
	}else if(!Book_id_l.equals("")&&Book_id_c.equals("")&&!Book_id_r.equals("")){
		Bookid1=Book_id_l;
		Bookid2=Book_id_r;
		Gbn=2;
	}else if(!Book_id_l.equals("")&&!Book_id_c.equals("")&&Book_id_r.equals("")){
		Bookid1=Book_id_l;
		Bookid2=Book_id_c;
		Gbn=2;
	}else if(!Book_id_l.equals("")&&!Book_id_c.equals("")&&!Book_id_r.equals("")){
		Bookid1=Book_id_l;
		Bookid2=Book_id_c;
		Gbn=3;
	}
	String XSLURL = MakeHan.File_url("XSL");
	System.out.println("Gbn"+Gbn);
%>		
	<%	
		HashMap param = new HashMap();
		BylawwebService service = BylawwebServiceHelper.getBylawwebService(application);
		String xslurl ="";
		xslurl =XSLURL+"2_right.xsl";
		File xsl = new File(xslurl);
		if(!Bookid.equals("")){		
			try{
	//			xml 파일 정보 가져 오기
	//			Bylaw_bean 데이터 불러온다.
				param.put("bookid", Bookid);
				HashMap bylaw = service.BookInfo(param);	//문서정보
				String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();	
				StreamSource xml = new StreamSource(new StringReader(xmldata));	
			
				TransformerFactory tFactory = TransformerFactory.newInstance(); 
				Transformer transformer = tFactory.newTransformer(new StreamSource(xsl)); 
				transformer.transform(xml, new StreamResult(out)); 	
			}catch(Exception e){
				out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
			}
			
		}else if(Gbn==2){
		%>
			<table border="1" width="100%" height="420">
				<tr>
					<td width="50%" valign="top">
					<%	
						try{
							param.put("bookid", Bookid2);
							HashMap bylaw = service.BookInfo(param);	//문서정보
							String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
							StreamSource xml = new StreamSource(new StringReader(xmldata));		
						
							TransformerFactory tFactory2 = TransformerFactory.newInstance(); 
							Transformer transformer2 = tFactory2.newTransformer(new StreamSource(xsl)); 
							transformer2.transform(xml, new StreamResult(out)); 
						}catch(Exception e){
							out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
						}
					%>
					</td>
					<td width="50%" valign="top">
					<%	
						try{
							param.put("bookid", Bookid1);
							HashMap bylaw = service.BookInfo(param);	//문서정보
							String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
							StreamSource xml = new StreamSource(new StringReader(xmldata));	
							TransformerFactory tFactory3 = TransformerFactory.newInstance(); 
							Transformer transformer3 = tFactory3.newTransformer(new StreamSource(xsl)); 
							transformer3.transform(xml, new StreamResult(out)); 
						}catch(Exception e){
							out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
						}
					%>					
					</td>
				</tr>
			</table>
		<%}else if(Gbn==3){ %>
			<table border="1" width="100%" height="420">
				<tr>
					<td width="33%" valign="top">
					<%	
						try{
							param.put("bookid", Book_id_r);
							HashMap bylaw = service.BookInfo(param);	//문서정보
							String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
							StreamSource xml = new StreamSource(new StringReader(xmldata));	
							TransformerFactory tFactory2 = TransformerFactory.newInstance(); 
							Transformer transformer2 = tFactory2.newTransformer(new StreamSource(xsl)); 
							transformer2.transform(xml, new StreamResult(out)); 
						}catch(Exception e){
							out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
						}
					%>
					</td>
					<td width="33%" valign="top">
					<%	
						try{
							param.put("bookid", Book_id_c);
							HashMap bylaw = service.BookInfo(param);	//문서정보
							String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
							StreamSource xml = new StreamSource(new StringReader(xmldata));	
							TransformerFactory tFactory2 = TransformerFactory.newInstance(); 
							Transformer transformer2 = tFactory2.newTransformer(new StreamSource(xsl)); 
							transformer2.transform(xml, new StreamResult(out)); 
						}catch(Exception e){
							out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
						}
					%>					
					</td>
					<td width="33%" valign="top">
					<%	
						try{
							param.put("bookid", Book_id_l);
							HashMap bylaw = service.BookInfo(param);	//문서정보
							String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
							StreamSource xml = new StreamSource(new StringReader(xmldata));	
							TransformerFactory tFactory2 = TransformerFactory.newInstance(); 
							Transformer transformer2 = tFactory2.newTransformer(new StreamSource(xsl)); 
							transformer2.transform(xml, new StreamResult(out)); 
						}catch(Exception e){
							out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
						}
					%>					
					</td>
				</tr>
			</table>
		<%}else if(Gbn==4){ %>	
			<table border="1" width="100%" height="420">
				<tr>
					<td width="25%" valign="top">
					<%	
						try{
							param.put("bookid", Book_id_r);
							HashMap bylaw = service.BookInfo(param);	//문서정보
							String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
							StreamSource xml = new StreamSource(new StringReader(xmldata));	
							TransformerFactory tFactory2 = TransformerFactory.newInstance(); 
							Transformer transformer2 = tFactory2.newTransformer(new StreamSource(xsl)); 
							transformer2.transform(xml, new StreamResult(out)); 
						}catch(Exception e){
							out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
						}
					%>
					</td>
					<td width="25%" valign="top">
					<%	
						try{
							param.put("bookid", Book_id_c);
							HashMap bylaw = service.BookInfo(param);	//문서정보
							String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
							StreamSource xml = new StreamSource(new StringReader(xmldata));	
							TransformerFactory tFactory2 = TransformerFactory.newInstance(); 
							Transformer transformer2 = tFactory2.newTransformer(new StreamSource(xsl)); 
							transformer2.transform(xml, new StreamResult(out)); 
						}catch(Exception e){
							out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
						}
					%>					
					</td>
					<td width="25%" valign="top">
					<%	
						try{
							param.put("bookid", Book_id_l);
							HashMap bylaw = service.BookInfo(param);	//문서정보
							String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
							StreamSource xml = new StreamSource(new StringReader(xmldata));	
							TransformerFactory tFactory2 = TransformerFactory.newInstance(); 
							Transformer transformer2 = tFactory2.newTransformer(new StreamSource(xsl)); 
							transformer2.transform(xml, new StreamResult(out)); 
						}catch(Exception e){
							out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
						}
					%>					
					</td>
					<td width="25%" valign="top">
					<%	
						try{
							param.put("bookid", Book_id_l2);
							HashMap bylaw = service.BookInfo(param);	//문서정보
							String xmldata = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
							StreamSource xml = new StreamSource(new StringReader(xmldata));	
							TransformerFactory tFactory2 = TransformerFactory.newInstance(); 
							Transformer transformer2 = tFactory2.newTransformer(new StreamSource(xsl)); 
							transformer2.transform(xml, new StreamResult(out)); 
						}catch(Exception e){
							out.println("잠시뒤에 다시 이용해 주시기 바랍니다.");
						}
					%>					
					</td>
				</tr>
			</table>
		<%} %>
<script language="javascript">
	window.ieExecWB(7)
<!--
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


