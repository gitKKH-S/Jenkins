package com.mten.bylaw.law.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.*;

import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.*;
import org.jdom.xpath.XPath;
import org.xml.sax.InputSource;


public class GetXmlData {
	private static String OC = "kyugwan";	//기업코드asj1030,/anci
	private static String target = "law";	//타겟
	private static String display = "15";	//검색결과 갯수
	private static String Server = "http://10.175.79.142/DRF/lawSearch.do?";
	private static Class calss =  GetXmlData.class;
	
	public static void main(String [] args){
		String as= "http://10.175.79.142/DRF/lawSearch.do?OC=miso21&target=law&display=10";
		URL url = null;
		URLConnection connection = null;  
		InputStream is = null; 
		InputStreamReader isr = null;
		BufferedReader br = null;
		String strXML = new String(); //xml내용 저장하기 위한 변수
		try {
			url = new URL(as); //URL 세팅
			
			InputStreamReader isra = new InputStreamReader(url.openStream());
			BufferedReader brs = new BufferedReader(isra);
			while(brs.readLine()!=null){
				System.out.println(brs.readLine());
			}
			
			
			connection = url.openConnection(); //접속
			is = connection.getInputStream(); //inputStream 이용
			isr = new InputStreamReader(is,"utf-8"); 
			br = new BufferedReader(isr);
			String buf = null;
	 
			while (true) { //무한반복
				buf = br.readLine(); //화면에 있는 내용을 \n단위로 읽어온다
				if (buf == null) { //null일 경우 화면이 끝난 경우이므로
					break; //반복문 끝
				} else {
					strXML += buf + "\n"; //strXML에 화면에 출력된 내용을 기억시킨다.
				}
			}
		} catch (MalformedURLException mue) {
	 
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} 
//			HashMap para = getDept();   
//			Set key = para.keySet();
//			for(Iterator iterator = key.iterator(); iterator.hasNext();){
//				String keyName =(String) iterator.next();
//				String ValueName =(String)para.get(keyName);
//				System.out.println(keyName+":::"+ValueName);
//			}
		target = "law";
		//System.out.println(getXmlListH(""));
	}
	
	public static LawBean Common(Document doc , String code){
		Element Root = doc.getRootElement();
		List law = Root.getChildren();
		
		ArrayList lawList = new ArrayList();
		HashMap lawMap = new HashMap();
		LawBean lawBean = new LawBean();
		
		Iterator i = law.iterator();
		while(i.hasNext()){
			Element row = (Element)i.next();
			System.out.println(row);
			if(row.getName().equals("키워드")){	
				lawBean.setKeword(row.getValue());
			}else if(row.getName().equals("totalCnt")){
				lawBean.setTotal(row.getValue());
			}else if(row.getName().equals("page")){
				lawBean.setPage(row.getValue());
			}else if(row.getName().equals(code)){
				List rowha = row.getChildren();
				lawMap = new HashMap();
				lawMap.put("번호",row.getAttributeValue("id"));
				Iterator is = rowha.iterator();
				while(is.hasNext()){
					Element rowV = (Element)is.next();
					lawMap.put(rowV.getName(),rowV.getValue());
				}
				
				lawList.add(lawMap);
			}
		}
		lawBean.setXmlList(lawList);
		return lawBean;
	}
	
	//판례 검색 리스트
	public static LawBean getXmlListP(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=prec&display=" + display + Para;
		System.out.println("Url"+Url);
		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Common(doc,"prec");
	}
	
//	법령해석례 리스트
	public static LawBean getXmlListBH(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=expc&display=" + display + Para;
		System.out.println("Url"+Url);
		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Common(doc,"expc");
	}
	
//	행정심판례
	public static LawBean getXmlListHA(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=decc&display=" + display + Para;
		System.out.println("Url"+Url);
		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Common(doc,"decc");
	}

//	법령용어
	public static LawBean getXmlListWORD(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=lstrm&display=" + display + Para;
		System.out.println("Url"+Url);
		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Common(doc,"lstrm");
	}
	
//	조약
	public static LawBean getXmlListJI(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=trty&display=" + display + Para;
		System.out.println("Url"+Url);
		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Common(doc,"Trty");
	}
	
//	자치법규
	public static LawBean getXmlListOR(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=ordin&display=" + display + Para;
		System.out.println("Url"+Url);
		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Common(doc,"law");
	}
	
//	행정규칙
	public static LawBean getXmlListBylaw(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=admrul&display=" + display + Para;
		System.out.println("Url"+Url);
		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Common(doc,"admrul");
	}
	
//	법령별표검색
	public static LawBean getXmlListLI(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=licbyl&display=" + display + Para;
		System.out.println("Url"+Url);
		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Common(doc,"licbyl");
	}
	
//	헌재결정례
	public static LawBean getXmlListHP(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=detc&display=" + display + Para;
		System.out.println("Url"+Url);
		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Common(doc,"Detc");
	}
	
	//법령검색리스트
	public static LawBean getXmlListH(String Para) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&type=xml&target=" + target + "&display=" + display + Para;

		String strXML = getUrlXml(Url);

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
//		DocumentBuilder _docBuilder;
//		Document document = null;
//		try {
//			_docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
//			 document = _docBuilder.parse(new InputSource(new java.io.StringReader(strXML))); 
//		} catch (Exception e) {
//			e.printStackTrace();
//		}

		
//		Node Root = document.getFirstChild();
//		NodeList law = Root.getChildNodes();
//		ArrayList lawList = new ArrayList();
//		HashMap lawMap = new HashMap();
//		LawBean lawBean = new LawBean();
		
//		for ( int i = 0; i < law.getLength(); i++ ) {  //노드 길이 만큼
//			Element row = (Element)law.item( i ); //node row에 item들을 가져온다.
//			if(row.getNodeName().equals("키워드")){	
//				lawBean.setKeword(row.getTextContent());
//			}else if(row.getNodeName().equals("totalCnt")){
//				lawBean.setTotal(row.getTextContent());
//			}else if(row.getNodeName().equals("page")){
//				lawBean.setPage(row.getTextContent());
//			}else if(row.getNodeName().equals("law")){
//				NodeList rowha = row.getChildNodes();
//				lawMap = new HashMap();
//				lawMap.put("번호",row.getAttribute("id"));
//				for( int j = 0; j < rowha.getLength(); j++){
//					Node rowV = rowha.item( j );
//					lawMap.put(rowV.getNodeName(),rowV.getTextContent());
//				}
//				lawList.add(lawMap);
//			}
//		}
		return Common(doc,"law");
	}
	
	
	
	public static String getDept(String key){
		String linkGbn = "/코드테이블/소관부처테이블/소관부처/이름";
		String Op="";
		try{
			SAXBuilder builder = new SAXBuilder();
			Document doc = builder.build(new File(calss.getResource("").getPath()+"sDpt.xml"));
	
			XPath servletPath = XPath.newInstance(linkGbn);
			List servlets = servletPath.selectNodes(doc);
			
			Iterator i = servlets.iterator();
			while(i.hasNext()){
				Element servlet = (Element)i.next();
				if(key.equals(servlet.getAttributeValue("코드"))){
					Op = Op + "<option value=\""+servlet.getAttributeValue("코드")+"\" selected>"+servlet.getValue() +"</option>";
				}else{
					Op = Op + "<option value=\""+servlet.getAttributeValue("코드")+"\">"+servlet.getValue() +"</option>";
				}
			}
		}catch (Exception e){
			System.out.println("소관부처 데이터 로딩 실패"+e);
		}
		
		//jdom을 사용하지 않을때
//		Document doc = null;
//		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance(); 
//		DocumentBuilder builder;
//		//System.out.println(this.getClass().getResource("").getPath());
//		
//		try {
//			builder = factory.newDocumentBuilder();
//			doc = builder.parse();
//			
//			XPathFactory factory2 = XPathFactory.newInstance();
//	        XPath xpath = factory2.newXPath();
//	        XPathExpression expr = xpath.compile(linkGbn);
//	        Object result = expr.evaluate(doc, XPathConstants.NODESET);
//	        NodeList nodes = (NodeList) result;
//			
//			for( int j = 0; j < nodes.getLength(); j++){
//				Element reDept = (Element)nodes.item(j);
//				Text contents = (Text) reDept.getFirstChild();
//				System.out.println("!!!!!!!"+contents.getNodeValue());
//				if(key.equals(reDept.getAttribute("코드"))){
//					Op = Op + "<option value=\""+reDept.getAttribute("코드")+"\" selected>"+reDept.getTextContent() +"</option>";
//				}else{
//					Op = Op + "<option value=\""+reDept.getAttribute("코드")+"\">"+reDept.getTextContent() +"</option>";
//				}
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//			System.out.println("에러:::"+e);
//		}
		return Op;
	}
	
	public static String getUrlXml(String Url) {
		URL url = null;
		URLConnection connection = null;  
		InputStream is = null; 
		InputStreamReader isr = null;
		BufferedReader br = null;
		String strXML = new String(); //xml내용 저장하기 위한 변수
		try {
			url = new URL(Url); //URL 세팅
			connection = url.openConnection(); //접속
			is = connection.getInputStream(); //inputStream 이용
			isr = new InputStreamReader(is,"utf-8"); 
			br = new BufferedReader(isr);
			String buf = null;
	 
			while (true) { //무한반복
				buf = br.readLine(); //화면에 있는 내용을 \n단위로 읽어온다
				if (buf == null) { //null일 경우 화면이 끝난 경우이므로
					break; //반복문 끝
				} else {
					strXML += buf + "\n"; //strXML에 화면에 출력된 내용을 기억시킨다.
				}
			}
		} catch (MalformedURLException mue) {
	 
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} 
		return strXML;
	}
	
	public static String toKorean( String st ) {
	    if (st == null) return null;
	    try {
	      st = new String( st.getBytes("8859_1"), "euc-kr" );
	    } catch ( java.io.UnsupportedEncodingException e ) {
	      System.out.println( "GetXmlData toKorean 에러" );
	    }
	    return st;
	  }
}
