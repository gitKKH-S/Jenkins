<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="javax.xml.transform.*"%>
<%@ page import="javax.xml.transform.stream.*"%>
<%@ page import="org.springframework.web.bind.ServletRequestUtils"%>
<%@ page import="javax.xml.parsers.*"%>
<%@ page import="javax.xml.xpath.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="javax.xml.transform.dom.DOMSource" %>
<%@ page import="com.mten.bylaw.bylawweb.service.*"%>
<%@ page import="com.mten.util.MakeHan"%>
<style type="text/css">
	.aaa NOBR{
	      font-size: 14pt;
	      font-weight: bold; 
	      color: #487691;
	}
	table{
		border-left:2px solid #60AEE0;
		border-right:2px solid #60AEE0;
		border-bottom:1px solid #60AEE0;
	}

</style>
	<link rel="stylesheet" href="${resourceUrl}/mnview/css/view13pt.css">
	<link rel="stylesheet" href="${resourceUrl}/mnview/css/viewEtc.css">
<script language="JavaScript" type="text/JavaScript">
<!--
	function gostr(id,one,tow){
		if(id == 'A'){
			alert("현재기준입니다!!");
			return;	
		}else if(id =='B'){
			document.chan.Book_id_l.value=tow;
			document.chan.Book_id_c.value=one;
		}
		form = document.chan;
		form.id.value=id;
		
		form.action="./2_compare.do";
		form.submit();
	}
//-->
</script>
<%
	String Book_id_c = ServletRequestUtils.getStringParameter(request,"Book_id_c","");
	String Book_id_l = ServletRequestUtils.getStringParameter(request,"Book_id_l","");
	String Print_yn = ServletRequestUtils.getStringParameter(request,"Print_yn","");
	
	String id = ServletRequestUtils.getStringParameter(request,"id","A");
	String Obookid = ServletRequestUtils.getStringParameter(request,"obookid","");
	
	System.out.println("Book_id_c===>"+Book_id_c);
	System.out.println("Book_id_l===>"+Book_id_l);
	System.out.println("Print_yn===>"+Print_yn);
	System.out.println("id===>"+id);
	System.out.println("Obookid===>"+Obookid);
	
	BylawwebService service = BylawwebServiceHelper.getBylawwebService(application);
	List DanList = request.getAttribute("list")==null?new ArrayList():(List)request.getAttribute("list");
	String Obookid_l="";//왼쪽
	String Obookid_c="";//중앙
	String Booktitle_l="";//왼쪽
	String Booktitle_c="";//중앙
	String XmlData_l="";
	String XmlData_c="";
	for(int k=0;k<DanList.size();k++){
		HashMap bylaw=(HashMap)DanList.get(k);
		String Bookid = bylaw.get("BOOKID")==null?"":bylaw.get("BOOKID").toString();
		if(Bookid.equals(Book_id_l)){
			Obookid_l = bylaw.get("OBOOKID")==null?"":bylaw.get("OBOOKID").toString();
			Booktitle_l = bylaw.get("TITLE")==null?"":bylaw.get("TITLE").toString();
			XmlData_l = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
		}else if(Bookid.equals(Book_id_c)){
			Obookid_c = bylaw.get("OBOOKID")==null?"":bylaw.get("OBOOKID").toString();
			Booktitle_c = bylaw.get("TITLE")==null?"":bylaw.get("TITLE").toString();
			XmlData_c = bylaw.get("XMLDATALINK")==null?"":bylaw.get("XMLDATALINK").toString();
		}
	}
%>
<%!
	public ArrayList relist = new ArrayList();
	public ArrayList getTag(Element tagName){
		NodeList list = tagName.getChildNodes();
		for(int i=0; i<list.getLength(); i++){
			Node node2 = list.item(i);
			String tName = node2.getNodeName();
			if(tName.equals("pyun")||tName.equals("jang")||tName.equals("jeol")||tName.equals("gwan")||tName.equals("jo")){
				HashMap bylaw = new HashMap();
				org.w3c.dom.Element Lset2 = (org.w3c.dom.Element)node2;
				String tag = "";
				if(Lset2.getTagName().equals("pyun")){
					tag = "편";
                }else if(Lset2.getTagName().equals("jang")){
                	tag = "장";
                }else if(Lset2.getTagName().equals("jeol")){
                	tag = "절";
                }else if(Lset2.getTagName().equals("gwan")){
                	tag = "관";
                }else if(Lset2.getTagName().equals("jo")){
                	tag = "조";
                }
				bylaw.put("Contcd",tag);
				bylaw.put("Contents",Lset2.getAttribute("title"));
				bylaw.put("Contno",Lset2.getAttribute("contno"));
				bylaw.put("Contsubno",Lset2.getAttribute("contsubno"));
				boolean as =true;
				if(tName.equals("jo")){
					org.w3c.dom.Element jo = (org.w3c.dom.Element)node2;
					if(!"9999".equals(jo.getAttribute("endcha").toString())){
						as = false;
					}
					TransformerFactory factory1 = TransformerFactory.newInstance();
				    StringWriter sw = new StringWriter();
				    Properties output = new Properties();
					output.setProperty(OutputKeys.ENCODING, "EUC-KR");   
					output.setProperty(OutputKeys.INDENT, "yes");
					try{
						Transformer transformer1 = factory1.newTransformer();
						transformer1.setOutputProperties(output);
						transformer1.transform(new DOMSource(jo), new StreamResult(sw));
						bylaw.put("Contentsweb",sw.toString());
					}catch(TransformerException e){
						String hkk = "1";
					}
				}
				if(as){
					relist.add(bylaw);
				}
				if(Lset2.getChildNodes().getLength()>0 && !tName.equals("jo")){
					getTag(Lset2);
				}
				
			}
		}
		return relist;
	}
%>
<%!
	public ArrayList getScont(String xmldata,String Bookid,String jono,String subjono){
		ArrayList as = new ArrayList();
		try{
			ByteArrayInputStream is = new ByteArrayInputStream(xmldata.getBytes("euc-kr"));
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true); // never forget this!
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(is);//(new StringReader(bylaw.getXmldata()));
			XPathFactory factory2 = XPathFactory.newInstance();
			XPath xpath = factory2.newXPath();
			
			XPathExpression expr2 = xpath.compile("/law/bon//jo[@endcha='9999']");
			Object result2 = expr2.evaluate(doc, XPathConstants.NODESET);
			NodeList nodes = (NodeList)result2;
			org.w3c.dom.Element root = doc.createElement("jo");
			for (int j = 0; j < nodes.getLength(); j++) {
				HashMap bylaw = new HashMap();
				org.w3c.dom.Element Lsetj = (org.w3c.dom.Element)nodes.item(j);
				root=Lsetj;			
				TransformerFactory factory1 = TransformerFactory.newInstance();
			    Properties output = new Properties();
				output.setProperty(OutputKeys.ENCODING, "EUC-KR");   
				output.setProperty(OutputKeys.INDENT, "yes");
				StringWriter sw2 = new StringWriter();
				Transformer transformer1 = factory1.newTransformer();
				transformer1.setOutputProperties(output);
				transformer1.transform(new DOMSource(root), new StreamResult(sw2));
				
				if(!jono.equals("1")){
					if(getTNT(sw2.toString(),Bookid,jono,subjono).equals(true)){
						
						bylaw.put("Contcd","조");
						bylaw.put("Contents",root.getAttribute("title"));
						bylaw.put("Contno",root.getAttribute("contno"));
						bylaw.put("Contsubno",root.getAttribute("contsubno"));
						bylaw.put("Contentsweb",sw2.toString());
						as.add(bylaw);
					}
				}
			}
			//expr2 = xpath.compile("/law//jo//cont/bylaw[@lawid = '"+Bookid+"' and @jono='bon"+jono+"']");
			
		}catch(TransformerException e){
			String hkk = "1";
		}catch(XPathExpressionException e){
			String hkk = "1";
		}catch(UnsupportedEncodingException e){
			String hkk = "1";
		}catch(ParserConfigurationException e){
			String hkk = "1";
		}catch(IOException e){
			String hkk = "1";
		}catch(Exception e){
			String hkk = "1";
		}
		return as;
	}
	public Object getTNT(String bon,String Bookid,String cno,String scno){
		boolean as = false;
		ByteArrayInputStream is = new ByteArrayInputStream(bon.getBytes());
		StringWriter sw2 = new StringWriter();
		HashMap bylaw = new HashMap();
		Object result2 = null;
		try{
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true); // never forget this!
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(is);//(new StringReader(bylaw.getXmldata()));
			XPathFactory factory2 = XPathFactory.newInstance();
			XPath xpath = factory2.newXPath();
			
			XPathExpression expr2 = xpath.compile("/jo//cont/bylaw[@lawid = '"+Bookid+"' and @jono='bon"+cno+"']");
			result2 = expr2.evaluate(doc, XPathConstants.BOOLEAN);
			
		}catch(XPathExpressionException e){
			String hkk = "1";
		}catch(UnsupportedEncodingException e){
			String hkk = "1";
		}catch(ParserConfigurationException e){
			String hkk = "1";
		}catch(IOException e){
			String hkk = "1";
		}catch(Exception e){
			String hkk = "1";
		}
		return result2;
	}
%>
<%
	ByteArrayInputStream is = new ByteArrayInputStream(XmlData_l.getBytes("euc-kr"));
	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	factory.setNamespaceAware(true); // never forget this!
	DocumentBuilder builder = factory.newDocumentBuilder();
	Document doc = builder.parse(is);//(new StringReader(bylaw.getXmldata()));
	XPathFactory factory2 = XPathFactory.newInstance();
	XPath xpath = factory2.newXPath();
	XPathExpression expr = xpath.compile("/law/bon");
	Object result = expr.evaluate(doc, XPathConstants.NODE);
	Node node = (Node) result;
	org.w3c.dom.Element Lset = (org.w3c.dom.Element)node;
		
	String XSLURL = MakeHan.File_url("XSL");
%>
<table width ="100%" style="border-top:2px solid #60AEE0;border-bottom:1px solid #60AEE0;" bgcolor="#D2E4FA">
	<tr>
		<th width="33%" align="center" onMouseOver="this.style.backgroundColor='FFFFFF'" onmouseout="this.style.backgroundColor=''" onclick="gostr('A','<%=Book_id_l %>','<%=Book_id_c %>');">
			<span title='<%=Booktitle_l %>' class="aaa"  style="cursor:hand;">
				<nobr style="text-overflow:ellipsis;overflow:hidden;width=300PX"><%=Booktitle_l %></nobr>
			</span>
		</th>
		<th width="33%" align="center" onMouseOver="this.style.backgroundColor='FFFFFF'" onmouseout="this.style.backgroundColor=''" onclick="gostr('B','<%=Book_id_l %>','<%=Book_id_c %>');">
			<span title='<%=Booktitle_c %>' class="aaa"  style="cursor:hand;">
				<nobr style="text-overflow:ellipsis;overflow:hidden;width=300PX"><%=Booktitle_c %></nobr>
			</span>
		</th>
	</tr>
</table>
<%		
	//xsl 파일 읽어 들이기
	RandomAccessFile file = new RandomAccessFile(new File(XSLURL+"3_compare.xsl"), "rw"); 
    String str="";
    String Xsl="";
    while( (str=file.readLine()) != null){
    	Xsl+=str;
    }
    Xsl=MakeHan.toKorean(Xsl);
    file.close();
%>
<%
	ArrayList cList = getTag(Lset);
	int list_cnt=cList.size();
	String Contents="";
	String Cont_cd="";
	String Cont_no="";
	String Contents_web="";
	String Cont_subno="";
	relist = new ArrayList();
%>

<%
out.println("<table border=\"0\" width=\"100%\">");
for(int k =0; k<list_cnt; k++){
	HashMap la=(HashMap)cList.get(k);
	Contents=la.get("Contents")==null?"":la.get("Contents").toString();	
	Cont_cd=la.get("Contcd")==null?"":la.get("Contcd").toString();
	Cont_no=la.get("Contno")==null?"":la.get("Contno").toString();
	Contents_web=la.get("Contentsweb")==null?"":la.get("Contentsweb").toString();
	Cont_subno=la.get("Contsubno")==null?"":la.get("Contsubno").toString();
	StreamSource xml2 = null;
	StreamSource xsl2 = null;
	TransformerFactory tFactory = TransformerFactory.newInstance(); 
	Transformer transformer = null;
	String xmldata = "";
	if(!Cont_cd.equals("본문")){
	
	out.println("<tr onMouseOver=\"this.style.backgroundColor='e0ffff'\" onmouseout=\"this.style.backgroundColor=''\">");
	out.println("<td width=\"50%\" valign=\"top\">");
	if(Cont_cd.equals("조")){
		if(Cont_subno.equals("0")||Cont_subno.equals("")){
			out.println("<span class=jonumber>제"+Cont_no+Cont_cd+"("+Contents+")</span><br/><span class=jocontent>");
		}else{
			out.println("<span class=jonumber>제"+Cont_no+Cont_cd+"의"+Cont_subno+"("+Contents+")</span><br/><span class=jocontent>");
		}
		xmldata = Contents_web;
		xml2 = new StreamSource(new StringReader(xmldata));
		xsl2 = new StreamSource(new StringReader(Xsl));
		transformer = tFactory.newTransformer(xsl2); 
		transformer.transform(xml2, new StreamResult(out));
	}else{
		if(Cont_subno.equals("0")||Cont_subno.equals("")){
			out.println("<div align=\"center\" class=jang>제"+Cont_no+Cont_cd+" "+Contents+"</div><br/>");
		}else{
			out.println("<div align=\"center\" class=jang>제"+Cont_no+Cont_cd+"의"+Cont_subno+" "+Contents+"</div><br/>");
		}
	}
	
	
	
	out.println("</span></td>");
	out.println("<td width=\"50%\" valign=\"top\">");
		if(!Contents_web.equals("")){
			ArrayList sList = getScont(XmlData_c,Book_id_l,Cont_no,Cont_subno);
			for(int h=0; h<sList.size(); h++){
				HashMap sub = (HashMap)sList.get(h);	
				if(sub.get("Contno")!=null&&!sub.get("Contno").toString().equals("")){
					String joTitle="<span class=jonumber>제"+sub.get("Contno")+"조("+sub.get("Contents")+")</span><br/><span class=jocontent>";
					if(!sub.get("Contsubno").toString().equals("0")&&!sub.get("Contsubno").toString().equals("")){
						joTitle= "<span class=jonumber>제"+sub.get("Contno")+"조의"+sub.get("Contsubno")+"("+sub.get("Contents")+")</span><br/><span class=jocontent>";
					}
					out.println(joTitle);	
					
					xmldata = sub.get("Contentsweb")==null?"":sub.get("Contentsweb").toString();
					xml2 = new StreamSource(new StringReader(xmldata));
					xsl2 = new StreamSource(new StringReader(Xsl));
					tFactory = TransformerFactory.newInstance(); 
					transformer = tFactory.newTransformer(xsl2); 
					transformer.transform(xml2, new StreamResult(out));
				}
			}
		}
		out.println("</span></td>");
		out.println("</tr>");
	}
}
	%>
	<tr>
		<th width="50%" align="center" onMouseOver="this.style.backgroundColor='e0ffff'" onmouseout="this.style.backgroundColor=''" onclick="gostr('A','<%=Book_id_l %>','<%=Book_id_c %>');">
			<span title='' class="aaa"  style="cursor:hand;">
				<nobr style="text-overflow:ellipsis;overflow:hidden;width=300PX"></nobr>
			</span>
		</th>
		<th width="50%" align="center" onMouseOver="this.style.backgroundColor='e0ffff'" onmouseout="this.style.backgroundColor=''" onclick="gostr('B','<%=Book_id_l %>','<%=Book_id_c %>');">
			<span title='' class="aaa"  style="cursor:hand;">
				<nobr style="text-overflow:ellipsis;overflow:hidden;width=300PX"></nobr>
			</span>
		</th>
	</tr>
<%

	out.println("</table>");


%>
<form name="chan" method="post">
	<input type="hidden" name="id">
	<input type="hidden" name="obookid" value="<%=Obookid %>">
	<input type="hidden" name="Book_id_r">
	<input type="hidden" name="Book_id_c">
	<input type="hidden" name="Book_id_l">
</form>
<%
	if(!Print_yn.equals("")){
%>
<script language="javascript">
	window.ieExecWB(7)
	//프린트 출력
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
<%}%>