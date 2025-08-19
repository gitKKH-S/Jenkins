package com.mten.bylaw.bylaw.service;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.nio.channels.FileChannel;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.CDATASection;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.mten.dao.CommonDao;
import com.mten.util.FileUploadUtil;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Service("bylawService")
public class BylawServiceImpl implements BylawService {
	protected final static Logger logger = Logger.getLogger( BylawServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public String getKey() {
		return commonDao.select("commonSql.getSeq");
	}
	
	public ArrayList setDBDeptList(Map<String, Object> mtenMap) {
		return (ArrayList)commonDao.selectList("userSql.setDeptList", mtenMap);
	}
	
	public HashMap selectBon(String Bookid) {
		return (HashMap)commonDao.selectOne("bylawSql.selectBon",Bookid);
	}
	
	public String setDeptList(Map<String, Object> mtenMap) {
		ArrayList deptList = this.setDBDeptList(mtenMap);
		String dept = mtenMap.get("dept")==null?"":mtenMap.get("dept").toString();
		StringBuffer select= new StringBuffer();
		select.append("<option value=\"\">---담당 부서 선택---</option>");
		for(int k=0;k<deptList.size();k++){
			HashMap result = (HashMap)deptList.get(k);
      		String deptcd = result.get("DEPT")==null?"":result.get("DEPT").toString();
      		String deptname = result.get("DEPTNAME")==null?"":result.get("DEPTNAME").toString();
      		String deptname2 = result.get("DEPTNAME")==null?"":result.get("DEPTNAME").toString();
      		int level = result.get("LVL")==null?0:Integer.parseInt(result.get("LVL").toString());
      		String nbsp = "";
      		if(deptname2.length()>10)deptname2 = deptname2.substring(0,10)+"....";
      		if(level != 0){
      			if(level > 1){
      				int nLvlCnt = level;
      				for(int h=1;h<nLvlCnt;h++){
          				nbsp += "　";
      				}
      			}
      			if(deptcd.equals(dept)){
    				select.append("<option value=\""+deptcd+"/"+deptname+"\" selected title=\""+deptname+"\">"+nbsp+deptname2+"</option>");
          		}else{
    				select.append("<option value=\""+deptcd+"/"+deptname+"\" title=\""+deptname+"\">"+nbsp+deptname2+"</option>");
          		}
      		}
      	}
		return select.toString();
	}
	
	public String setDeptNameList(Map<String, Object> mtenMap) {
		ArrayList deptList = this.setDBDeptList(mtenMap);
		String dept = mtenMap.get("dept")==null?"":mtenMap.get("dept").toString();
		StringBuffer select= new StringBuffer();
		select.append("<option value=\"\">---담당 부서 선택---</option>");
		for(int k=0;k<deptList.size();k++){
			HashMap result = (HashMap)deptList.get(k);
      		String deptcd = result.get("DEPT")==null?"":result.get("DEPT").toString();
      		String deptname = result.get("DEPTNAME")==null?"":result.get("DEPTNAME").toString();
      		String deptname2 = result.get("DEPTNAME")==null?"":result.get("DEPTNAME").toString();
      		int level = result.get("LVL")==null?0:Integer.parseInt(result.get("LVL").toString());
      		String nbsp = "";
      		if(deptname2.length()>10)deptname2 = deptname2.substring(0,10)+"....";
      		if(level != 0){
      			if(level > 1){
      				int nLvlCnt = level;
      				for(int h=1;h<nLvlCnt;h++){
          				nbsp += "　";
      				}
      			}
      			if(deptcd.equals(dept)){
    				select.append("<option value=\""+deptname+"/"+deptname+"\" selected title=\""+deptname+"\">"+nbsp+deptname2+"</option>");
          		}else{
    				select.append("<option value=\""+deptname+"/"+deptname+"\" title=\""+deptname+"\">"+nbsp+deptname2+"</option>");
          		}
      		}
      	}
		return select.toString();
	}
	
	public HashMap selectMETA(String Bookid) {
		return (HashMap)commonDao.selectOne("bylawSql.selectMETA",Bookid);
	}
	
	public JSONObject getDocInfoView(Map<String, Object> mtenMap,HttpServletRequest req) {
		JSONObject result = new JSONObject();
		JSONObject dinfo = new JSONObject();
		JSONArray ulist = new JSONArray();
		JSONObject uinfo = new JSONObject();
		
		List<HashMap> resultList = commonDao.selectList("bylawSql.getSelectDocInfo",mtenMap);
		int total = resultList.size();
		int start = mtenMap.get("start")==null?0:Integer.parseInt(mtenMap.get("start").toString());
		int limit = mtenMap.get("limit")==null?0:Integer.parseInt(mtenMap.get("limit").toString());
		String bookid = mtenMap.get("bookid")==null?"":mtenMap.get("bookid").toString();
		
		if(resultList.size()!=0) {
			HashMap bylaw = resultList.get(0);
			dinfo.put("Bookid", bylaw.get("BOOKID"));
	   		dinfo.put("Title", bylaw.get("TITLE"));
	   		dinfo.put("Bookcode", bylaw.get("Bookcode"));
	   		dinfo.put("Bookcd", bylaw.get("BOOKCD"));
	   		dinfo.put("Booksubcd", bylaw.get("BOOKSUBCD"));
	   		dinfo.put("Revcd", bylaw.get("REVCD"));
	   		dinfo.put("Revcha", bylaw.get("REVCHA"));
	   		dinfo.put("Promuldt", bylaw.get("PROMULDT"));
	   		dinfo.put("Startdt", bylaw.get("STARTDT"));
	   		dinfo.put("Deptname", bylaw.get("DEPTNAME"));
	   		dinfo.put("Username", bylaw.get("USERNAME"));
	   		dinfo.put("Deptcd", bylaw.get("DEPTCD"));
	   		dinfo.put("revreason", bylaw.get("REVREASON"));
	   		dinfo.put("mainpith", bylaw.get("MAINPITH"));
			result.put("dinfo", dinfo);
			
			if(total-limit<0){
				limit=total;
			}
			
			for(int i=start; i<limit;i++){
				bylaw = resultList.get(i);
				JSONObject linfo = new JSONObject();
				linfo.put("updateid", bylaw.get("UPDATEID"));
				linfo.put("bookid", bylaw.get("BOOKID"));
				linfo.put("updatecha", bylaw.get("UPDATECHA"));
				linfo.put("updatereason", bylaw.get("UPDATEREASON"));
				linfo.put("updateupdt", bylaw.get("UPDATEUPDT"));
				linfo.put("writer", bylaw.get("WRITER"));
				linfo.put("writerid", bylaw.get("WRITERID"));
				ulist.add(linfo);
			}
			uinfo.put("total", resultList.size());
			uinfo.put("result", ulist);
			result.put("uinfo", uinfo);
		}
		
		List<HashMap> pList = commonDao.selectList("bylawSql.selectProgInfo",mtenMap);
		StringBuffer jsonResult = new StringBuffer("");
		jsonResult.append("<div class='list'>");
		jsonResult.append("<ul class='list_02'>");
		if(mtenMap.get("noform").toString().equals("N")){
			for(int i=0;i<pList.size();i++){
				HashMap bylaw = pList.get(i);
				jsonResult.append("<li  class='list_03' style='cursor:pointer' "
						+ " onMouseOver='this.className=\"list_03_1\"' onMouseOut='this.className=\"list_03\"' "
						+ "onclick='viewProg("+bylaw.get("STATEHISTORYID")+","+"\""+bylaw.get("STATECD")+"\""+")'><span>");
				jsonResult.append(bylaw.get("STATECD"));
				jsonResult.append("</span></li>");
				if(i!=pList.size()-1){
					jsonResult.append("<li class='list_03'>"
							+ "<p><img src='"+req.getContextPath()+"/resources/images/common/tree/moveDown.gif' style='cursor:default'/></p>"
							+ "</li>");
				}
			}
		}else{
			jsonResult.append("<li>비정형문서는 지원하지 않습니다.</li>");
		}
		jsonResult.append("</ul>");
		jsonResult.append("</div>");
		result.put("pinfo", jsonResult.toString());
		
		
		List lList1 = commonDao.selectList("bylawSql.getSelectLinkInfo1",bookid);
		JSONArray link1 = JSONArray.fromObject(lList1);
		List lList2 = commonDao.selectList("bylawSql.getSelectLinkInfo2",bookid);
		JSONArray link2 = JSONArray.fromObject(lList2);
		
		result.put("link1", link1);
		result.put("link2", link2);
		
		return result;
	}
	
	public JSONObject getDocBon(Map<String, Object> mtenMap,HttpServletRequest req) {
		JSONObject result = new JSONObject();
		
		String Bookid = mtenMap.get("Bookid")==null?"":mtenMap.get("Bookid").toString(); 
		String Obookid = mtenMap.get("Obookid")==null?"":mtenMap.get("Obookid").toString();
		String Pstate = mtenMap.get("Pstate")==null?"":mtenMap.get("Pstate").toString();
		String schtxt = mtenMap.get("schtxt")==null?"":mtenMap.get("schtxt").toString();
		String deptname = mtenMap.get("deptname")==null?"":mtenMap.get("deptname").toString();
		String Revcha = mtenMap.get("Revcha")==null?"0":mtenMap.get("Revcha").toString();
		String statehistoryid = mtenMap.get("statehistoryid")==null?"":mtenMap.get("statehistoryid").toString();
		String type = mtenMap.get("type")==null?"":mtenMap.get("type").toString();
		
		HashMap bylaw = new HashMap();
		if(statehistoryid.equals("")){
			bylaw = commonDao.selectOne("bylawSql.selectBon",Bookid);	
		}else{
			bylaw = commonDao.selectOne("bylawSql.selectProgBon",statehistoryid);
		}
		
		//첨부파일 담을 객체
		HashMap<String,String> fbean = new HashMap();
		String XSLURL = "";
		try {
			XSLURL = MakeHan.File_url("XSL");
		} catch (IOException e) {
			logger.error("프로퍼티에 xsl 경로가 없습니다.");
		}
		
		String XMLDATA = MakeHan.setCircleNum(bylaw.get("XMLDATA").toString(), "READ");
		String XMLOLDNEWREVISION = MakeHan.setCircleNum(bylaw.get("XMLOLDNEWREVISION").toString(), "READ");
		String XMLDATALINK = MakeHan.setCircleNum(bylaw.get("XMLDATALINK").toString(), "READ");
		String REVCD = bylaw.get("REVCD")==null?"":bylaw.get("REVCD").toString();
		
		String selectBox = this.getHistoryItem(Bookid, "A");
		
		//전문
		String xslurl ="appBon.xsl";
		
		HashMap para = new HashMap();
    	para.put("obookid", bylaw.get("OBOOKID"));
    	para.put("revcha", bylaw.get("REVCHA"));
    	para.put("revcd", "전부개정");
    	int allrevcha = Integer.parseInt((String) commonDao.selectOne("bylawSql.GetAllRevCha", para).toString());
        
    	String BONXMLDATA = XMLDATALINK.replaceAll("&lt;a5b5 /&gt;", "<a5b5 />").replaceAll("&lt;a5b5", "<a5b5");
    	StreamSource xml = new StreamSource(new StringReader(BONXMLDATA),"utf-8");
		File xsl = new File(XSLURL+xslurl);
		StringWriter stringWriter = new StringWriter();
		
		Date now = new Date ();
		SimpleDateFormat sdf4 = new SimpleDateFormat ( "yyyyMMdd",new Locale("en","US") );
		sdf4.setTimeZone ( TimeZone.getTimeZone ( "Asia/Seoul" ) );
		String sysdate =  sdf4.format ( now );
		
		TransformerFactory tFactory = TransformerFactory.newInstance();
		Transformer transformer = null;
		try{
			transformer = tFactory.newTransformer(new StreamSource(xsl));
			transformer.setParameter("bookid",bylaw.get("BOOKID"));
			transformer.setParameter("revcha",bylaw.get("REVCHA").toString());
			transformer.setParameter("schtxt",schtxt);
			transformer.setParameter("deptname",deptname);
			transformer.setParameter("Topcont",bylaw.get("JENMUN")==null?"":bylaw.get("JENMUN").toString().replace("\\n", "<br/>"));
			transformer.setParameter("Mainpith",bylaw.get("MAINPITH")==null?"":bylaw.get("MAINPITH"));	
			transformer.setParameter("allcha",Integer.toString(allrevcha));
			transformer.setParameter("selectBox",selectBox);
			transformer.setParameter("statehistoryid",statehistoryid);
			transformer.setParameter("sysdate",sysdate);
			transformer.transform(xml, new StreamResult(stringWriter));
			
			result.put("bon", stringWriter.toString());
		}catch (Exception e){
			System.out.println("비정형문서는 xml데이터 관리대상이 아니다."+e);
		}
		
		
		//신구조문
		xslurl ="oldnew.xsl";
		xml = new StreamSource(new StringReader(XMLOLDNEWREVISION.replaceAll("&amp;lt;span style=\"color: red; text-decoration: underline;\"&amp;gt;"," <span class=\"mten\">")
																.replaceAll("&amp;lt;span style=\"text-decoration:underline; color:red;\"&amp;gt;"," <span class=\"mten\">")
																.replaceAll("&amp;lt;/span&amp;gt;","</span>").replaceAll("&amp;","&").replaceAll("A&HCI","A&amp;HCI")
																.replaceAll("Teaching & Learning","Teaching &amp; Learning")
																.replaceAll("Teaching & ","Teaching &amp; ")
															));
		xsl = new File(XSLURL+xslurl);
		stringWriter = new StringWriter();
		String BON = "<div align=\"center\" width=\"100%\" class=\"title\">"+bylaw.get("TITLE")+"</div>";
		if(XMLOLDNEWREVISION.equals("")||XMLOLDNEWREVISION==null||REVCD.equals("제정")||REVCD.equals("전부개정")||REVCD.equals("폐지")){
			BON = BON + "<br/><br/><span class=\"mten\" style=\"padding-left:10px\">현행 문서가 제정문,전부개정문 일경우 신구조문대비표가 생성되지 않습니다.</span>";
		}else{
			HashMap oldnewTitle = new HashMap();
			if(!Bookid.equals("")){//문서정보>입안프로세스 의 신구조문대비표는 title이 없음!!
				HashMap paras = new HashMap();
				paras.put("bookid", Bookid);
				oldnewTitle = (HashMap)commonDao.selectOne("bylawSql.GetOldNew", paras);
		        
				if(oldnewTitle==null){
					BON = BON + "<br/><br/><span class=\"mten\" style=\"padding-left:10px\">비교할자료가 존재하지 않아 신구조문대비표가 생성되지 않습니다.</span>";
				}else{
					BON = BON + "<table class='singuTable' width='100%' border='0'>";
					BON = BON + "<tr><td style='text-align:center; padding:5px; line-height:1.4em;' class='bold'><strong>"+oldnewTitle.get("OLDTITLE").toString().replaceAll("JE","제").replaceAll("CHA","차")+"</strong></td>";
					BON = BON + "<td width='50%' style='text-align:center; padding:5px; line-height:1.4em;' class='bold'><strong>"+oldnewTitle.get("NEWTITLE").toString().replaceAll("JE","제").replaceAll("CHA","차")+"</strong></td></tr>";
					BON = BON + "</table>";		
					xml = new StreamSource(new StringReader(XMLOLDNEWREVISION.replaceAll("&amp;lt;span style=\"color: red; text-decoration: underline;\"&amp;gt;"," <span class=\"mten\">")
																.replaceAll("&amp;lt;span style=\"text-decoration:underline; color:red;\"&amp;gt;"," <span class=\"mten\">")
																.replaceAll("&amp;lt;/span&amp;gt;","</span>")
																.replaceAll("&amp;","&").replaceAll("A&HCI","A&amp;HCI")
																.replaceAll("Teaching & Learning","Teaching &amp; Learning").replaceAll("Teaching & ","Teaching &amp; ")
																));					
													}	
			}else{
				xml = new StreamSource(new StringReader(XMLOLDNEWREVISION.replaceAll("&amp;lt;span style=\"color: red; text-decoration: underline;\"&amp;gt;"," <span class=\"mten\">")
																.replaceAll("&amp;lt;span style=\"text-decoration:underline; color:red;\"&amp;gt;"," <span class=\"mten\">")
																.replaceAll("&amp;lt;/span&amp;gt;","</span>")
																.replaceAll("&amp;","&")
																.replaceAll("A&HCI","A&amp;HCI")
																.replaceAll("Teaching & Learning","Teaching &amp; Learning").replaceAll("Teaching & ","Teaching &amp; ")
																));
			}
			try{
				transformer = tFactory.newTransformer(new StreamSource(xsl));
				transformer.setParameter("bookid",bylaw.get("BOOKID"));
				transformer.setParameter("revcha",bylaw.get("REVCHA").toString());
				transformer.setParameter("schtxt",schtxt);
				transformer.setParameter("deptname",deptname);
				transformer.setParameter("Topcont",bylaw.get("JENMUN")==null?"":bylaw.get("JENMUN").toString().replace("\\n", "<br/>"));	
				transformer.setParameter("Mainpith",bylaw.get("MAINPITH")==null?"":bylaw.get("MAINPITH"));	
				transformer.setParameter("allcha",Integer.toString(allrevcha));
				transformer.setParameter("selectBox",selectBox);
				transformer.setParameter("statehistoryid",statehistoryid);
				transformer.transform(xml, new StreamResult(stringWriter));
			}catch (Exception e){
				System.out.println("비정형문서는 xml데이터 관리대상이 아니다."+e);
			}
		}
		result.put("oldnew", BON+stringWriter.toString());
		
		//과거조문동시보기
		BON = "";
		xslurl ="together.xsl";
		if(XMLOLDNEWREVISION.equals("")||XMLOLDNEWREVISION==null||REVCD.equals("제정")||REVCD.equals("전부개정")||REVCD.equals("폐지")){
			BON = "<br/><br/><span class=\"mten\" style=\"padding-left:10px\">현행 문서가 제정문,전부개정문 일경우 과거조문동시보기가 생성되지 않습니다.</span>";
		}else{
			BONXMLDATA = XMLOLDNEWREVISION;

			BONXMLDATA = BONXMLDATA.replaceAll("&amp;lt;span style=\"color: red; text-decoration: underline;\"&amp;gt;"," <span class=\"mten\">")
					.replaceAll("&amp;lt;span style=\"text-decoration:underline; color:red;\"&amp;gt;"," <span class=\"mten\">").replaceAll("&amp;lt;/span&amp;gt;","</span>").replaceAll("&amp;","&").replaceAll("A&HCI","A&amp;HCI").replaceAll("Teaching & Learning","Teaching &amp; Learning").replaceAll("Teaching & ","Teaching &amp; ");
			BONXMLDATA = BONXMLDATA.replaceAll("&amp;lt;", "&lt;").replaceAll("&amp;gt;", "&gt;");
			BONXMLDATA = BONXMLDATA.replaceAll("&lt;span style=\"color: red; text-decoration: underline;\"&gt;"," <span class=\"mten\">").replaceAll("&lt;span style=\"text-decoration:underline; color:red;\"&gt;"," <span class=\"mten\">").replaceAll("&lt;/span&gt;","</span>");
			xml = new StreamSource(new StringReader(BONXMLDATA));
		}
		xsl = new File(XSLURL+xslurl);
		stringWriter = new StringWriter();
		try{
			transformer = tFactory.newTransformer(new StreamSource(xsl));
			transformer.setParameter("bookid",bylaw.get("BOOKID"));
			transformer.setParameter("revcha",bylaw.get("REVCHA").toString());
			transformer.setParameter("schtxt",schtxt);
			transformer.setParameter("deptname",deptname);
			transformer.setParameter("Topcont",bylaw.get("JENMUN")==null?"":bylaw.get("JENMUN").toString().replace("\\n", "<br/>"));	
			transformer.setParameter("Mainpith",bylaw.get("MAINPITH")==null?"":bylaw.get("MAINPITH"));	
			transformer.setParameter("allcha",Integer.toString(allrevcha));
			transformer.setParameter("selectBox",selectBox);
			transformer.setParameter("statehistoryid",statehistoryid);
			transformer.transform(xml, new StreamResult(stringWriter));
		}catch (Exception e){
			System.out.println("비정형문서는 xml데이터 관리대상이 아니다."+e);
		}
		result.put("together", BON+stringWriter.toString());
		
		BON = "";
		xslurl ="sub_top.xsl";
		
		BONXMLDATA="";
		StringWriter sw = new StringWriter();
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true); // never forget this!
		org.w3c.dom.Document doc = null;
		Object results = null;
		System.out.println("^^^^^^^^^^^^^^^^^^^^^^^");
		try {
			ByteArrayInputStream is = new ByteArrayInputStream(XMLDATALINK.getBytes("euc-kr"));
			DocumentBuilder builder = factory.newDocumentBuilder();
			doc = builder.parse(is);// (new StringReader(bylaw.getXmldata()));
			
			HashMap memopara = new HashMap();
			memopara.put("bookid", Bookid);
			memopara.put("userid", mtenMap.get("writerid"));
			memopara.put("gbn", "J");
			List mList = commonDao.selectList("bylawSql.getMemoList", memopara);;
			for(int i=0; i<mList.size(); i++){
				HashMap by = (HashMap)mList.get(i);
				
				String linkGbn = "//jo[@contid='" + by.get("CONTID") + "']";
				System.out.println("linkGbn" + linkGbn);
				
				XPathFactory factory2 = XPathFactory.newInstance();
				XPath xpath = factory2.newXPath();
				XPathExpression expr = xpath.compile(linkGbn);

				results = expr.evaluate(doc, XPathConstants.NODE);
				Node node = (Node) results;

				org.w3c.dom.Element set2 = (org.w3c.dom.Element) node;

				set2.setAttribute("memoyn","Y");
			}
			
		} catch (Exception e) {
			System.out.println("%%%%%%%%" + e);
		}
		
		TransformerFactory factory1 = TransformerFactory.newInstance();
		Properties output = new Properties();
		output.setProperty(OutputKeys.ENCODING, "EUC-KR");
		output.setProperty(OutputKeys.INDENT, "yes");
		try {
			transformer = factory1.newTransformer();
			transformer.setOutputProperties(output);
			transformer.transform(new DOMSource(doc), new StreamResult(sw));
		} catch (Exception e) {
			System.out.println(e);
		}
		BONXMLDATA = sw.toString();
		BONXMLDATA = BONXMLDATA.replaceAll("&lt;a5b5 /&gt;", "<a5b5 />").replaceAll("&lt;a5b5", "<a5b5");

		xml = new StreamSource(new StringReader(BONXMLDATA));
		xsl = new File(XSLURL+xslurl);
		stringWriter = new StringWriter();
		try{
			transformer = tFactory.newTransformer(new StreamSource(xsl));
			transformer.setParameter("bookid",bylaw.get("BOOKID"));
			transformer.setParameter("revcha",bylaw.get("REVCHA").toString());
			transformer.setParameter("schtxt",schtxt);
			transformer.setParameter("deptname",deptname);
			transformer.setParameter("Topcont",bylaw.get("JENMUN")==null?"":bylaw.get("JENMUN").toString().replace("\\n", "<br/>"));	
			transformer.setParameter("Mainpith",bylaw.get("MAINPITH")==null?"":bylaw.get("MAINPITH"));	
			transformer.setParameter("allcha",Integer.toString(allrevcha));
			transformer.setParameter("selectBox",selectBox);
			transformer.setParameter("statehistoryid",statehistoryid);
			transformer.transform(xml, new StreamResult(stringWriter));
		}catch (Exception e){
			System.out.println("비정형문서는 xml데이터 관리대상이 아니다."+e);
		}
		result.put("jolist", BON+stringWriter.toString());
		
		BON = "";
		xslurl ="sub_bottom.xsl";
		BONXMLDATA = XMLDATALINK.replaceAll("&lt;a5b5 /&gt;", "<a5b5 />").replaceAll("&lt;a5b5", "<a5b5");
		
		xml = new StreamSource(new StringReader(BONXMLDATA));
		xsl = new File(XSLURL+xslurl);
		stringWriter = new StringWriter();
		try{
			transformer = tFactory.newTransformer(new StreamSource(xsl));
			transformer.setParameter("bookid",bylaw.get("BOOKID"));
			transformer.setParameter("revcha",bylaw.get("REVCHA").toString());
			transformer.setParameter("schtxt",schtxt);
			transformer.setParameter("deptname",deptname);
			transformer.setParameter("Topcont",bylaw.get("JENMUN")==null?"":bylaw.get("JENMUN").toString().replace("\\n", "<br/>"));	
			transformer.setParameter("Mainpith",bylaw.get("MAINPITH")==null?"":bylaw.get("MAINPITH"));	
			transformer.setParameter("allcha",Integer.toString(allrevcha));
			transformer.setParameter("selectBox",selectBox);
			transformer.setParameter("statehistoryid",statehistoryid);
			transformer.transform(xml, new StreamResult(stringWriter));
		}catch (Exception e){
			System.out.println("비정형문서는 xml데이터 관리대상이 아니다."+e);
		}
		result.put("flist", BON+stringWriter.toString());
		
		List hlist = commonDao.selectList("bylawSql.getHistory", Bookid);
		JSONArray jhjson = JSONArray.fromObject(hlist);
		result.put("history", jhjson);
		
		if(type.equals("sub")) {
			List fList = commonDao.selectList("bylawSql.selectFilelist",mtenMap);
			JSONArray fj = JSONArray.fromObject(fList);
			result.put("finfo", fj);
		}
		return result;
	}
	
	public String setMemoChk(String xml,HashMap para){
		
		StringWriter sw = new StringWriter();
		/*DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true); // never forget this!
		org.w3c.dom.Document doc = null;
		Object result = null;
		System.out.println("^^^^^^^^^^^^^^^^^^^^^^^");
		try {
			ByteArrayInputStream is = new ByteArrayInputStream(xml.getBytes("euc-kr"));
			DocumentBuilder builder = factory.newDocumentBuilder();
			doc = builder.parse(is);// (new StringReader(bylaw.getXmldata()));
			
			ArrayList mList = (ArrayList)commonDao.selectList("bylawSql.getMemoList",para);
			for(int i=0; i<mList.size(); i++){
				Bylaw by = (Bylaw)mList.get(i);
				
				String linkGbn = "//jo[@contid='" + by.getContid() + "']";
				System.out.println("linkGbn" + linkGbn);
				
				XPathFactory factory2 = XPathFactory.newInstance();
				XPath xpath = factory2.newXPath();
				XPathExpression expr = xpath.compile(linkGbn);

				result = expr.evaluate(doc, XPathConstants.NODE);
				Node node = (Node) result;

				org.w3c.dom.Element set2 = (org.w3c.dom.Element) node;

				set2.setAttribute("memoyn","Y");
			}
			
		} catch (Exception e) {
			System.out.println("%%%%%%%%" + e);
		}
		

		
		TransformerFactory factory1 = TransformerFactory.newInstance();
		Properties output = new Properties();
		output.setProperty(OutputKeys.ENCODING, "EUC-KR");
		output.setProperty(OutputKeys.INDENT, "yes");
		try {
			Transformer transformer = factory1.newTransformer();
			transformer.setOutputProperties(output);
			transformer.transform(new DOMSource(doc), new StreamResult(sw));
		} catch (Exception e) {
			System.out.println(e);
		}
		//System.out.println("sw.toString()" + sw.toString());
*/
		
		
		return sw.toString();
	}

	public String getHistoryItem(String Bookid,String gbn){
		List<HashMap> list = commonDao.selectList("bylawSql.getHistoryItem",Bookid);
		StringBuffer as = new StringBuffer();
		as.append("<select name='sel' onchange=move1('','','')>");
		for(int i=0; i<list.size(); i++){
			HashMap by = list.get(i);
			String REVCD = by.get("REVCD")==null?"":by.get("REVCD").toString();
			String PROMULDT = by.get("PROMULDT")==null?"":by.get("PROMULDT").toString();
			String BOOKID = by.get("BOOKID")==null?"":by.get("BOOKID").toString();
			String NOFORMYN = by.get("NOFORMYN")==null?"":by.get("NOFORMYN").toString();
			String REVCHA = by.get("REVCHA")==null?"":by.get("REVCHA").toString();
			String OTHERLAW = by.get("OTHERLAW")==null?"":by.get("OTHERLAW").toString();
			boolean gs = true;
			if(!gbn.equals("A")&&PROMULDT.equals("7777-12-31")){
				gs = false;
			}
			if(gs){
				String title = "";
				
				if(REVCD.equals("제정")){
					title = title + REVCD;
				}else{
					title = title + REVCHA +"차"+REVCD;
				}
				if(PROMULDT!=null && !PROMULDT.equals("7777-12-31")){
					title = title + "/"+PROMULDT;
				}
				if(OTHERLAW!=null && !OTHERLAW.equals("")){
					title = title + "("+OTHERLAW+")";
				}
				
				
				if(Bookid.equals(BOOKID)){
					as.append("<option value='"+BOOKID+NOFORMYN+"' selected='selected'");
				}else{
					as.append("<option value='"+BOOKID+NOFORMYN+"'");
				}
				as.append("title='"+title+"'");
				as.append(">");
				as.append(title);
				as.append("</option>");
			}
		}
		as.append("</select>");
		return as.toString();
	}
	
	//Obookid 가져오기
	public String getObookid(String bookid){
		return commonDao.selectOne("bylawSql.getObookid",bookid);
	}
	
	public HashMap getFileName(Map mtenMap) {
		return (HashMap)commonDao.selectOne("bylawSql.getFileName", mtenMap);
	}
	
	public List getFileNameList(Map mtenMap) {
		return commonDao.selectList("bylawSql.getFileName", mtenMap);
	}
	
	public JSONObject schList(Map<String, Object> mtenMap,HttpServletRequest req) {
		JSONObject result = new JSONObject();
		
		List list = commonDao.selectList("bylawSql.getSchResult",mtenMap);
		JSONArray slist = JSONArray.fromObject(list);
		result.put("slist", slist);
		
		return result;
	}
	
	public String replace_html( String str , int number ){
		if(str==null) return "";
		str=str.replaceAll("<TABLE.*?>[\\s\\S]*?</TABLE>", "테이블자리위치"+number);
		str=str.replaceAll("<!--.*[\\s\\S]*?-->", "");
		str=str.replaceAll("<!.*>", "");
		str=str.replaceAll("<META.*", "");
		str=str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", ""); //정규식 html 제거
		str=str.replaceAll("&nbsp;"," "); //띄어쓰기
		str=str.replaceAll("&quot;","\""); //띄어쓰기
		return str;
	}
	
	public String replace_html( String str ){
		if(str==null) return "";
		
		String tablePattern = "<TABLE.*?>[\\s\\S]*?</TABLE>";
		Pattern tpattern = Pattern.compile(tablePattern);
	
		Matcher tmatch = tpattern.matcher(str);
		HashMap tb = new HashMap();
		int number =1;
		while (tmatch.find()) {
			str=str.replace(tmatch.group(), "테이블자리위치"+number);
			number++;
		}
		str=str.replaceAll("<!--.*[\\s\\S]*?-->", "");
		str=str.replaceAll("<!.*>", "");
		str=str.replaceAll("<META.*", "");
		str=str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", ""); //정규식 html 제거
		str=str.replaceAll("&nbsp;"," "); //띄어쓰기
		str=str.replaceAll("&quot;","\""); //띄어쓰기
		return str;
	}
	
	public HashMap getTable(String bontext) {
		//테이블 처리를 위한 사전 작업
		String tablePattern = "<TABLE.*?>[\\s\\S]*?</TABLE>";
		Pattern tpattern = Pattern.compile(tablePattern);
	
		Matcher tmatch = tpattern.matcher(bontext);
		HashMap tb = new HashMap();
		int number =1;
		while (tmatch.find()) {
			String joTxt = tmatch.group();
			String tableTxt = "<table><![CDATA["+tmatch.group(0)+"]]></table>";
			joTxt = this.replace_html(joTxt,number);
			tb.put("테이블자리위치"+number, tableTxt);
			number++;
		}
		System.out.println("number==>"+number);
		return tb;
	}
	
	// xml 데이터 생성시(링크생성)
	public org.w3c.dom.Element getBookHistoryXml(org.w3c.dom.Document doc,String oBookid) {
		org.w3c.dom.Element history = doc.createElement("history");

		List list = commonDao.selectList("bylawSql.getBookHistoryXML", oBookid);
		Iterator iter = list.iterator();
		while (iter.hasNext()) {
			HashMap data = (HashMap)iter.next();
			org.w3c.dom.Element set = doc.createElement("hisitem");
			history.appendChild(set);
			String nBookid = data.get("BOOKID") == null ? "" : data.get("BOOKID").toString();
			set.setAttribute("bookid", nBookid);
			set.setAttribute("noformyn", data.get("NOFORMYN") == null ? "" : data.get("NOFORMYN").toString());
			set.setAttribute("revcd", data.get("REVCD") == null ? "" : data.get("REVCD").toString());
			set.setAttribute("promuldt", data.get("PROMULDT") == null ? "" : data.get("PROMULDT").toString());
			set.setAttribute("deptname", data.get("DEPTNAME") == null ? "" : data.get("DEPTNAME").toString());
			set.setAttribute("obookid", data.get("OBOOKID") == null ? "" : data.get("OBOOKID").toString());
			set.setAttribute("bookcd", data.get("BOOKCD") == null ? "" : data.get("BOOKCD").toString());
			set.setAttribute("promulno", data.get("PROMULNO") == null ? "" : data.get("PROMULNO").toString());
			set.setAttribute("revcha", data.get("REVCHA") == null ? "" : data.get("REVCHA").toString());
			set.setAttribute("startdt", data.get("STARTDT") == null ? "" : data.get("STARTDT").toString());
			set.setAttribute("enddt", data.get("ENDDT") == null ? "" : data.get("ENDDT").toString());
			set.setAttribute("bookcode", data.get("BOOKCODE") == null ? "" : data.get("BOOKCODE").toString());
			String st = data.get("STATECD") == null ? "" : data.get("STATECD").toString();
			set.setAttribute("statecd", st);
			set.setAttribute("title", data.get("TITLE") == null ? "" : data.get("TITLE").toString());
			set.setAttribute("otherlaw", data.get("OTHERLAW") == null ? "" : data.get("OTHERLAW").toString());
		}
		return history;
	}
		
	// 본문목록,부칙목록,별표목록
	public org.w3c.dom.Element bbbElement(String tagName, org.w3c.dom.Document doc, String contid) {
		org.w3c.dom.Element val = doc.createElement(tagName);
		val.setAttribute("contid", contid);
		val.setAttribute("bcontid", "0");
		val.setAttribute("startcha", "0");
		val.setAttribute("endcha", "9999");
		return val;
	}
	
	// 편장절관조
	public org.w3c.dom.Element createElement(String tagName,org.w3c.dom.Document doc, HashMap para) {
		org.w3c.dom.Element val = doc.createElement(tagName);
		val.setAttribute("contno", (String) para.get("contno"));
		val.setAttribute("contsubno", (String) para.get("contsubno"));
		val.setAttribute("title", (String) para.get("title"));
		val.setAttribute("contid", (String) para.get("contid"));
		val.setAttribute("bcontid", "0");
		val.setAttribute("startcha", (String) para.get("startcha"));
		val.setAttribute("endcha", "9999");
		val.setAttribute("createstate", "new");
		val.setAttribute("curstate", "new");
		return val;
	}
	
	public boolean isContains(String str1,String str2){
		if(str1.indexOf(str2)!=-1) return true;
		else return false;
	}
	
	public Map setXmlBon(Map<String, Object> mtenMap) {
		String bontext = mtenMap.get("bonhtml")==null?"":mtenMap.get("bonhtml").toString();
		mtenMap.put("XMLSCHTXT", mtenMap.get("bontxt"));
		
		if(bontext.equals("")) {
			mtenMap.put("msg", "본문생성 실패!! 데이터추출 실패!");
		}else {
			HashMap tableH =  this.getTable(bontext);
			bontext = this.replace_html(bontext).replaceAll("&lt;", "<").replaceAll("&gt;", ">");
			
			boolean bStart = false; // 변환시작되면 true
			boolean bu = false; // 부칙 변환 시작되면 true
			int nOrd = 0;
			int nContid = 0;
			int nPcontid = 0;
			int nIdx = 0;
			int[] nArrContId = new int[6]; // 0=nBodyid,nBuchickid저장 나머지는 편장절관조의
											// contid를 저장하귀위한 숫자형 배열
			int[] nArrOrd = { 0, 0, 0, 0, 0, 0, 0 }; // ord를 저장하기 위한 숫자형 배열
			
			String sContType = " 편장절관조"; //
			String sContno = "";
			String sBContno = ""; // 내용의 바로이전 조번호 저장 (내용에 조번호를 붙여주기 위해서)
			String sLine = "";
			String sLineSum = "";
			String sTitle = "";
			String sSub = "";
			String sSubno = "";
			String sContentsJo = "";
			String sContcd = "";

			String sPattern1 = "^제[\\d]{1,}[편장절관조]";
			String sPattern2 = "^부칙";

			Pattern pattern = Pattern.compile(sPattern1);
			Pattern pattern2 = Pattern.compile(sPattern2);

			String _nBodyid = "0";
			String _nBuchikid = "0";
			String _nByeolid = "0";
			
			String bontxt2[] = bontext.split("\\n");
			
			_nBodyid = commonDao.select("commonSql.getSeq");
			_nBuchikid = commonDao.select("commonSql.getSeq");
			_nByeolid = commonDao.select("commonSql.getSeq");
			
				//TB_LM_RULECAT
				HashMap rulecat = new HashMap();
				rulecat.put("pcatid", mtenMap.get("PCATID"));
				rulecat.put("ord", mtenMap.get("ORD"));
				rulecat.put("title", mtenMap.get("TITLE"));
				rulecat.put("useyn", "Y");
				commonDao.insert("bylawSql.addDoc",rulecat);
				mtenMap.put("CATID", rulecat.get("catid"));
				System.out.println(mtenMap);
				commonDao.insert("bylawSql.lawbookInsert",mtenMap);
				String bookid = mtenMap.get("BOOKID")==null?"":mtenMap.get("BOOKID").toString();
			try {	
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				DocumentBuilder builder = factory.newDocumentBuilder();
				org.w3c.dom.Document doc = builder.newDocument();
				org.w3c.dom.Element law = doc.createElement("law");
				org.w3c.dom.Element preBon = null;
				org.w3c.dom.Element preJo = null;
				org.w3c.dom.Element sbon = null;
				doc.appendChild(law);
				
				org.w3c.dom.Element history = this.getBookHistoryXml(doc, bookid);
				law.appendChild(history);
				
				// 루트 속성
				law.setAttribute("title", mtenMap.get("TITLE").toString());
				law.setAttribute("revcha", mtenMap.get("REVCHA").toString());
				org.w3c.dom.Element bon = this.bbbElement("bon", doc, _nBodyid); // 본문
				law.appendChild(bon); // 본문 태그

				org.w3c.dom.Element byullist = null; // 별표리스트

				nArrContId[0] = Integer.parseInt(_nBodyid);

				Matcher matcher1 = null;
				Matcher matcher2 = null;
				
				for (int k = 0; k < bontxt2.length; k++) {
					if(bontxt2[k].length()==0){
						continue;
					}
					String sWord = "";
					sWord = bontxt2[k];
					sLine = sWord;
					matcher1 = pattern.matcher(sLine.replaceAll(" ", ""));
					matcher2 = pattern2.matcher(sLine.replaceAll(" ", ""));
					if (matcher1.find() || matcher2.find()) {
						String sValue = "";
						try {// 미스 매치시 오류 발생하므로 빈값을 던져 준다.
							sValue = matcher1.group(); // 제1장
						} catch (Exception e) {
							sValue = "";
						}

						bStart = true;
						nContid = 0;
						if (sValue.length() <= 0) {
							sValue = matcher2.group();
						}

						sContcd = sValue.substring(sValue.length() - 1, sValue
								.length());

						nIdx = sContType.indexOf(sContcd);
						if (nIdx < 0) {
							nIdx = 0;
						}
						sContentsJo = sLine;
						// 내용저장
						// ===================================================================================
						if (sLineSum.replaceAll(" ", "").trim().length() > 0) {
							for (int i = 5; i >= 0; i--) {
								if (nArrContId[i] > 0) {
									nPcontid = nArrContId[i];
									nOrd = 1;
									break;
								}
							}

							String sTagedText = "<lawsub>"+ this.makeTag4Text(sLineSum, 0)+"</lawsub>";
							//sTagedText = sTagedText.replaceAll("테이블자리위치", tableH.get(sContno)==null?"":tableH.get(sContno).toString());
							String tablePattern = "테이블자리위치\\d";
							Pattern tpattern = Pattern.compile(tablePattern);
							Matcher tmatch = tpattern.matcher(sTagedText);
							while (tmatch.find()) {
								sTagedText = sTagedText.replace(tmatch.group(), tableH.get(tmatch.group())==null?"":tableH.get(tmatch.group()).toString());
							}
							org.w3c.dom.Element secondRoot = builder.parse(new org.xml.sax.InputSource(new StringReader(sTagedText))).getDocumentElement();
							org.w3c.dom.Node tempNode = doc.importNode(secondRoot,true); // true if you want a deep copy
							preJo.appendChild(tempNode);

							sLineSum = "";
						}
						
						// 제1조(목적) 이 세칙은....
						// svalue="제1조" sTitle = "목적"
						if (sContcd.equals("편") || sContcd.equals("장")	|| sContcd.equals("절") || sContcd.equals("관") || sContcd.equals("조")) {
							// 조일 경우 () 있음
							if (sLine.indexOf("(") > 0 || sContcd.equals("조")) {
								if (sLine.indexOf("(") > 0) {
									sContentsJo = sLine.substring(0, sLine.indexOf(")") + 1);
									sContno = this.selectInt(sValue).trim();
									sSub = sLine.substring(0, sLine.indexOf("("));
								}
								sTitle = this.JoTitle(sLine);
							} else {
								// 편장절관 일경우 () 없음
								if (this.isContains(sLine.trim(), "장의")) {
									sTitle = sLine.substring(sLine.indexOf(sContcd) + 3).trim();
								} else {
									sTitle = sLine.substring(sLine.indexOf(sContcd) + 1).trim(); // sLine// 제1장// 총칙
								}
								sContno = this.selectInt(sValue);
							}
							// 부속번호가 있을경우
							if (this.isContains(sSub.replaceAll(" ", "").trim(),"조의")) {
								sSubno = this.Josubno(sSub);
							} else {
								sSubno = "0";
							}
							String tagName = "";
							if (sContcd.equals("편")) {
								tagName = "pyun";
							} else if (sContcd.equals("장")) {
								tagName = "jang";
							} else if (sContcd.equals("절")) {
								tagName = "jeol";
							} else if (sContcd.equals("관")) {
								tagName = "gwan";
							} else if (sContcd.equals("조")) {
								tagName = "jo";
							} else if (sContcd.equals("부칙")) {
								tagName = "buchick";
							}

							HashMap para = new HashMap();
							para.put("contno", sContno);
							para.put("contsubno", sSubno);
							para.put("title", sTitle);
							para.put("startdt", mtenMap.get("STARTDT").toString());
							para.put("enddt", "9998-12-31");
							para.put("startcha", mtenMap.get("REVCHA").toString());
							para.put("contid", commonDao.select("commonSql.getSeq"));
							sSubno = "";
							sSub = "";
							sbon = this.createElement(tagName, doc, para);
							
							if (sContcd.equals("편")) {
								law.getLastChild().appendChild(sbon);
							} else if (sContcd.equals("장") || sContcd.equals("절") || sContcd.equals("관") || sContcd.equals("조")) {
								if (bon.getLastChild() == null || bon.getLastChild().getNodeName().equals(tagName)) {
									law.getLastChild().appendChild(sbon);
								} else {
									if (preBon != null && preBon.getNodeName().equals(tagName)) {
										bon.getLastChild().appendChild(sbon);
									} else {
										if(preBon == null){
											bon.appendChild(sbon);
										}else{
											preBon.appendChild(sbon);
										}
									}
								}
							} else if (sContcd.equals("부칙")) {
								law.getLastChild().appendChild(sbon);
							}
							if (!sContcd.equals("조")) {
								preBon = sbon;
							} else {
								preJo = sbon;
							}
						}
						
						if (sValue.replaceAll(" ", "").equals("부칙")) {
							if (!bu) {
								bon = bbbElement("buchicklist", doc, _nBuchikid); // 부칙
								law.appendChild(bon); // 본문 태그
							}
							nIdx = 4; // 부칙다음에는 편이 안나오므로 부칙은 4로 조정
							sTitle = sLine;
							sContcd = "부칙";
							for (int i = 0; i < 6; i++) {
								nArrContId[i] = 0;
								nArrOrd[i] = 0;
							}
							nArrContId[0] = Integer.parseInt(_nBuchikid); // 부칙아이디;

							HashMap para = new HashMap();
							para.put("contno", "0");
							para.put("contsubno", "0");
							para.put("title", sTitle);
							para.put("startdt", mtenMap.get("STARTDT").toString());
							para.put("enddt", "9998-12-31");
							para.put("startcha", mtenMap.get("REVCHA").toString());
							para.put("contid", commonDao.select("commonSql.getSeq"));

							sbon = this.createElement("buchick", doc, para);
							bon.appendChild(sbon);
							preBon = sbon;
							preJo = sbon;
							bu = true;

						}
						// 부모 contid 와 자기자신의 순서를 구하고
						// 자기자신레벨의 contid 와 ord값을 정한다.

						// 상위 contid 구하기" (편1) (장2) (절3) (관4) (조5)"
						// 현재 conttype 보다 상위인 contid 가 pcontid 가 된다.
						nPcontid = 0;
						for (int i = nIdx - 1; i >= 0; i--) {
							if (nArrContId[i] != 0) {
								nPcontid = nArrContId[i];
								break;
							}
						}
						// ord 는 자기 conttype 의 ord
						nOrd = nArrOrd[nIdx];

						// pcontid 와 ord를 구했으므로 자기와 동급의 contid = 0으로 하고 자기하위의 ord=0
						// 도 0으로 한다.
						// 예를 들면 현재읽은 sLine (관4) 이면 관이하인 (관4)(조5)의 contid =0 으로 하고
						// (조5)의 순서도 0으로 초기화한다.
						for (int i = nIdx; i <= 5; i++) {
							nArrContId[i] = 0; // 자기포함 하위 구조의 contid =0
							nArrOrd[i + 1] = 0; // 자기하위의 구조의 순서를 =0 ,자기순서는 누적해야함
						}
						//                    
						// 편장절관조부칙인경우 타이틀을 저장한다.
						// String sTagedJo = bylawDao.makeTag4JoByul(sContcd,
						// sContno, sSubno, sTitle, revcha,
						// bylaw.getStartdt(), "9999", bylaw.getEnddt(),"");

						// 새로운 contid를 구해서 배열에 넣어주고 자기와 동급인 contcd의 ord는 +1을 한다.
						// nContid =
						// lawcontInsert(Integer.toString(nPcontid),"",Bookid,sContcd,sContno,sSubno,sTitle,bylaw.getPromuldt(),bylaw.getStartdt(),
						// bylaw.getEnddt(),bylaw.getUpdt(),Integer.toString(nOrd),"0","9999","N",sTitle,sTagedJo,"");

						nArrContId[nIdx] = nContid;
						nArrOrd[nIdx]++;
						//
						//                    
						//
						if (sContcd.equals("조")) { // 제1조(목적) 이하의 내용을 sLineSum 에
													// 누적저장한다.
							sLineSum = sLine.substring(sLine.indexOf(")") + 1)
									+ "\n";
							sBContno = sContno; // 내용에 조의 contno를 넣어주기 위해
						}
					}else {
						if (bStart) {
							sLineSum += sLine + "\n";
						}
					}
				}
				//부칙이 없을경우
				if (!bu) {
					bon = bbbElement("buchicklist", doc, _nBuchikid); // 부칙
					law.appendChild(bon); // 본문 태그
					bu = true;
				}
				
				// 부칙이하 마지막에 읽은 파일 내용처리
				if (sLineSum.length() > 1) {
					for (int i = 5; i >= 0; i--) {
						if (nArrContId[i] > 0) {
							nPcontid = nArrContId[i];
							nOrd = nArrOrd[i];
							break;
						}
					}

					String sTagedText = "<lawsub>" + this.makeTag4Text(sLineSum, 0) + "</lawsub>";
					org.w3c.dom.Element secondRoot = builder.parse(new org.xml.sax.InputSource(new StringReader(sTagedText))).getDocumentElement();
					org.w3c.dom.Node tempNode = doc.importNode(secondRoot, true); 
					preJo.appendChild(tempNode);

					// law_cont 저장
					sLineSum = "";
				}
				
				bon = bbbElement("byullist", doc, _nByeolid); // 별표
				law.appendChild(bon);
				TransformerFactory factory1 = TransformerFactory.newInstance();
				StringWriter sw = new StringWriter();
				Properties output = new Properties();
				output.setProperty(OutputKeys.ENCODING, "EUC-KR");
				output.setProperty(OutputKeys.INDENT, "yes");
				Transformer transformer = factory1.newTransformer();
				transformer.setOutputProperties(output);
				transformer.transform(new DOMSource(doc), new StreamResult(sw));
				String XMLDATA = sw.getBuffer().toString().replaceAll("<lawsub>","").replaceAll("</lawsub>", "");
				mtenMap.put("XMLDATA", XMLDATA);
				mtenMap.put("XMLDATALINK", linkAndXml(XMLDATA,mtenMap));
				
				commonDao.insert("bylawSql.getTB_LM_STATEHISTORYInsert", mtenMap);
			}catch(Exception e) {
				System.out.println(e);
				mtenMap.put("msg", "본문생성 실패!! 데이터추출 실패!");
			}
		}
		return mtenMap;
	}
	
	public String selectInt(String strTemp){
		String strRet = "";
        String strPattenr = "\\D";
        strRet = strTemp.replaceAll(strPattenr, "");
        
        return strRet;
    }
    // 제1조(제목) 중에서 제목만 셀렉트해서 리턴
    public String selectDanNum(String sLine){
        String sTitle = "";

        int nLength = sLine.length()-1;
        sTitle = sLine.substring(sLine.indexOf("(") + 1, nLength).trim();
        return sTitle;

    }
    // 제1조(제목) 중에서 제목만 셀렉트해서 리턴
    public String JoTitle(String sLine){
        String sTitle = "";
        int nLength = sLine.indexOf(")");
        if(nLength>0){
        	sTitle = sLine.substring(sLine.indexOf("(")+1, nLength).trim();
        	
    		sTitle = sTitle.replaceAll("&quot;","\"");
        }
        return sTitle;
    }
    
    // 조의 부속번호만 셀렉트해서 리턴
    public String Josubno(String sSub){
        String sSubno = "";
        sSubno = this.selectInt(sSub.substring(sSub.indexOf("의") + 1));
        try{
            if (Integer.parseInt(sSubno) < 0){
                sSubno = "0";
            }
        }catch (Exception e){
            sSubno = "0";
        }
        return sSubno;
    }
    
	// 내용에 내용 항호목단 태그 붙이기
    public String makeTag4Text(String Contents, int contid){
    	String sContents = Contents;
        if(sContents == null){
        	return "";
        }
        
        String sHang = " ①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳㉑㉒㉓㉔㉕㉖㉗㉘㉙㉚㉛㉜㉝㉞㉟㊱㊲㊳㊴㊵㊶㊷㊸㊹㊺㊻㊼㊽㊾㊿"; // 항번호를 얻기위해 사용
        String[] sArrHo ={ "", "가.", "나.", "다.", "라.", "마.", "바.", "사.", "아.", "자.", "차.", "카.", "타.", "파.", "하.", "거.", "너.", "더.", "러.", "머." }; //목번호를 얻기위해 사용

        String[] sArrStaticTag =  { "</hang>", "</ho>", "</mok>", "</dan>" };
        String sContType = "항호목단";
        String[] sArrTag = new String[4];

        int[] nArrTag = { 0, 0, 0, 0 };

        String sContcd = "";
        String sLine = "";
        String sLineSum = "";
        String sNumber = "";
        String sValue = "";
        String sPatternHang = "^[①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳㉑㉒㉓㉔㉕㉖㉗㉘㉙㉚㉛㉜㉝㉞㉟㊱㊲㊳㊴㊵㊶㊷㊸㊹㊺㊻㊼㊽㊾㊿]";
        String sPatternHo = "^[\\d의]{1,}\\.";
        String sPatternMok = "^[가나다라마바사아자차카타파하거너더러]\\.";
        String sPatternDan = "^\\d{1,}\\)";

        int nIdx = 0;

        String[] sConvert = sContents.replaceAll("\r", "").split("\n");
        String sResult = "";
        try{
        	Element root = new Element("sub");
        	XMLOutputter serializer = new XMLOutputter();
        	
        	String[] sConvert2 = sContents.replaceAll("\r", "").split("\n");
        	String bon = "";
        	for(int s=0; s<sConvert2.length; s++){
        		sConvert2[s] = sConvert2[s].trim();
        		if(sConvert2[s].length()>0){
        			bon = bon + sConvert2[s] + "\n";
        		}
        	}
        	sConvert2 = bon.replaceAll("\r", "").split("\n");
        	for(int s=0; s<sConvert2.length; s++){
        		String sTxt = "";
        		sTxt = sConvert2[s];
        		if(sConvert2[s].length()>0){
        			
        			boolean aaas = false;
        			String tableT = "";
        			for(int ss=s+1; ss<sConvert2.length; ss++){
                		String sTxt2 = "";
                		sTxt2 = sConvert2[ss];
                		System.out.println("sTxt2:==>"+sTxt2+":::"+sConvert2[ss].length());
                		if(sConvert2[ss].length()>0){
                			if(sTxt2.contains("테이블자리위치")){
                				aaas = true;
                				tableT = sTxt2;
                				break;
                			}else{
                				break;
                			}
                		}
                	}
	        		sLine = sTxt.trim();
	        			        		
	        		if(aaas){
	        			sLine = sLine + "  "+tableT;
	        			tableT = "";
	        		}
	        		
	        		Pattern patternHang = Pattern.compile( sPatternHang );
	        		Pattern patternHo = Pattern.compile( sPatternHo );
	        		Pattern patternMok = Pattern.compile( sPatternMok );
	        		Pattern patternDan = Pattern.compile( sPatternDan );
	        		Matcher matchPatternHang = patternHang.matcher(sLine);
	    			Matcher matchPatternHo = patternHo.matcher(sLine);
	    			Matcher matchPatternMok = patternMok.matcher(sLine);
	    			Matcher matchPatternDan = patternDan.matcher(sLine);
	    			System.out.println("Contents:::::"+sTxt);
	    			boolean maHang = matchPatternHang.find();
					boolean maHo = matchPatternHo.find();
					boolean maMok = matchPatternMok.find();
					boolean maDan = matchPatternDan.find();
	    			if(maHang){ 
	    				sContcd = "hang";
	    				sValue = matchPatternHang.group();
	    				sNumber = Integer.toString(sHang.indexOf(sValue));
	    			}else if(maHo){
	    				sContcd = "ho";
	    				sValue = matchPatternHo.group();
	    				sNumber = sValue.substring(0,sValue.indexOf("."));
	    			}else if(maMok){
	    				sContcd = "mok";
	    				sValue = matchPatternMok.group();
	    				for (int i = 0; i < sArrHo.length; i++){
	                          if (sArrHo[i].equals(sValue)){
	                              sNumber = Integer.toString(i);//sValue.substring(0,1);
	                              break;
	                          }
	                      }
	    			}else if(maDan){
	    				sContcd = "dan";
	                  sValue = matchPatternDan.group();
	                  sNumber = this.selectDanNum(sValue);
	    			}
	    			Element cont = new Element("cont");
	    			if(maHang||maHo||maMok||maDan){
	    				if (sLine.length() > 1){
							Element Hang = new Element("hang");
							Element Ho = new Element("ho");
							Element Mok = new Element("mok");
							Element Dan = new Element("dan");
	    					if(maHang){
	    						//항태그
	    						Hang.setName(sContcd);
	        					Hang.setAttribute("contno",sNumber);
	    						
	    						Hang.addContent(cont);
	        					cont.setText(sLine);
	        					root.addContent(Hang);	//항상 루트 밑에 존재한다.
	    					}else if(maHo){
	    						//호태그
	    						Ho.setName(sContcd);
	        					Ho.setAttribute("contno",sNumber);
	    						Ho.addContent(cont);
	        					cont.setText(sLine);
	        					if(root.getChildren("hang").size()==0){
	        						root.addContent(Ho);	//루트밑에 바로 호가 올때
	        					}else{
	        						List children = root.getChildren();
	        						((Element) children.get(root.getContentSize()-1)).addContent(Ho);	//항밑에 호가 올때
	        					}
	    					}else if(maMok){
	    						//목태그
	    						Mok.setName(sContcd);
	        					Mok.setAttribute("contno",sNumber);
	    						Mok.addContent(cont);
	        					cont.setText(sLine);
	        					List children = root.getChildren();
	        					if(root.getChildren("hang").size()==0&&root.getChildren("ho").size()==0){
	        						root.addContent(Mok);	//루트밑에 목이 올때
	        					}else if(root.getChildren("hang").size()>0&&root.getChildren("ho").size()==0){
	        						if(((Element) children.get(root.getContentSize()-1)).getChildren("ho").size()==0){
	        							((Element) children.get(root.getContentSize()-1)).addContent(Mok);	//항밑에 목이올때
	        						}else{
	        							List children2 = ((Element) children.get(root.getContentSize()-1)).getChildren("ho");
	        							((Element) children2.get(children2.size()-1)).addContent(Mok);	//항,호 밑에 목이 올때
	        						}
	        					}else if(root.getChildren("ho").size()>0){
	        						if(((Element) children.get(root.getContentSize()-1)).getChildren("ho").size()==0){
	        							((Element) root.getChildren().get(root.getContentSize()-1)).addContent(Mok);	//루트/호밑에 목이 올때.
	        						}else{	
	        							List children2 = ((Element) children.get(root.getContentSize()-1)).getChildren("ho");
	        							((Element) children2.get(children2.size()-1)).addContent(Mok);	//항,호 밑에 목이 올때
	        						}
	        					}
	    					}else if(maDan){
	    						Dan.setName(sContcd);
	        					Dan.setAttribute("contno",sNumber);
	    						Dan.addContent(cont);
	        					cont.setText(sLine);
	        					List children = root.getChildren();
	        					if(root.getChildren("hang").size()==0&&root.getChildren("ho").size()==0&&root.getChildren("mok").size()==0){
	        						root.addContent(Dan);	//루트밑에 단이 올때
	        					}else if(root.getChildren("hang").size()>0&&root.getChildren("ho").size()==0&&root.getChildren("mok").size()==0){
	        						if(((Element) children.get(root.getContentSize()-1)).getChildren("ho").size()==0&&((Element) children.get(root.getContentSize()-1)).getChildren("mok").size()==0){
	        							((Element) root.getChildren("hang").get(root.getChildren("hang").size()-1)).addContent(Dan);	//루트/항밑에 단이 올때
	        						}else{
	        							List children2 = ((Element) children.get(root.getContentSize()-1)).getChildren("ho");
	        							List children3 = ((Element) children.get(root.getContentSize()-1)).getChildren("mok");
	        							if(children2.size()!=0){
	        								List children4 = ((Element) children2.get(children2.size()-1)).getChildren("mok");
	        								if(children4.size()==0){
	        									((Element) children2.get(children2.size()-1)).addContent(Dan);	//루트/항/호 밑에 단이 올때
	        								}else{
	        									((Element) children4.get(children4.size()-1)).addContent(Dan);	//루트/항/호/목 밑에 단이 올때
	        								}
	        							}else{
	        								((Element) children3.get(children3.size()-1)).addContent(Dan);	//루트/항/목 밑에 단이 올때
	        							}
	        							
	        						}
	        					}else if(root.getChildren("ho").size()>0&&root.getChildren("hang").size()==0&&root.getChildren("mok").size()==0){
	        						List children2 = root.getChildren("ho");
	        						List children4 = ((Element) children2.get(children2.size()-1)).getChildren("mok");
	        						if(children2.size()!=0){
	        							if(children4.size()==0){
	        								((Element) root.getChildren("ho").get(root.getChildren("ho").size()-1)).addContent(Dan);	//루트/호밑에 단이 올때
	    								}else{
	    									((Element) children4.get(children4.size()-1)).addContent(Dan);	//루트/호/목 밑에 단이 올때
	    								}
	    							}
	        					}else if(root.getChildren("hang").size()==0&&root.getChildren("ho").size()==0&&root.getChildren("mok").size()>0){
	        						((Element) root.getChildren("mok").get(root.getChildren("mok").size()-1)).addContent(Dan);	//루트/목밑에 단이 올때
	        					}
	    					}
	    					sLine="";
	                        sLineSum = "";
	                    }
	        		    
	    			}else{
	    				//본문만 있을경우 항을 필수로 붙인다.
						Element Hang = new Element("hang");
						//항태그
						sContcd="hang";
						Hang.setName(sContcd);
    					Hang.setAttribute("contno","1");
    					
	    				if (sLine.length() > 1){
	    					if(sLine.indexOf("테이블자리위치")!=0){
	    						root.addContent(Hang);
			    				Hang.addContent(cont);
								cont.setText(sLine);
	    					}else{
	    						cont.setText(sLine);
	    					}
	    					sLine="";
		                    sLineSum = "";
	    				}
	    			}
	    			Format fm = serializer.getFormat();
	//        		// encoding 형태를 한글로 변경한다.
	//        		fm.setEncoding("euc-kr");
	//        		// 부모 자식 태그를 구별하기 위한 탭 범위를 정한다.
	    		    fm.setIndent(" ");
	//        		    // 태그 끼리 줄바꿈을 지정한다.
	    		    fm.setLineSeparator("\r\n");
	//        		    // 설정한 XML파일의 포맷을 set 한다.
	    		    serializer.setFormat(fm);
	    			sLineSum += sLine;
        		}
        	}
        	if (sLineSum.length() > 1){
        		Element cont = new Element("cont");
        		cont.setText(sLineSum);
        		//본문만 있을경우 항을 필수로 붙인다.
				Element Hang = new Element("hang");
				//항태그
				sContcd = "hang";
				Hang.setName(sContcd);
				Hang.setAttribute("contno","1");
        		root.addContent(Hang);
				Hang.addContent(cont);
                sLineSum = "";
            }
        	sResult = serializer.outputString(root);
		  }catch (Exception e){
			  sResult = "<hang contno=\"1\"><cont>" + sContents + "</cont></hang>";
		  }
		  System.out.println("sResult:::::::::::"+sResult);
		  sResult = sResult.replaceAll("<sub>","")
		  					.replaceAll("</sub>","")
		  					.replaceAll("&nbsp;","")
		  					.replaceAll("@@@", "<a5b5/>")
		  					.replaceAll("&lt;bylaw","<bylaw").replaceAll("jono=\"bon1\"&gt;","jono=\"bon1\">").replaceAll("&lt;/bylaw&gt;","</bylaw>")
		  					.replaceAll("&lt;law","<law").replaceAll("jono=\"xf00010000\"&gt;","jono=\"xf00010000\">").replaceAll("&lt;/law&gt;","</law>")
		  					.replaceAll("/&gt;","/>").replaceAll("/&amp;gt;","/>").replaceAll("&lt;img","<img").replaceAll("@@","<");//.replaceAll("\\**",">");
		  System.out.println("sLineSum:::::::::::"+sResult);
		  return sResult;
    }
    
    public String dllReqSelect(Map<String, Object> mtenMap){
		List qList = commonDao.selectList("bylawSql.dllReqSelect",mtenMap);
		DllReqXml2 xml = new DllReqXml2();
		String xmlData = "";
		try {
			Document document = (Document)xml.iBATISForMake(qList);
			XMLOutputter outputter = new XMLOutputter();
			Format format = Format.getPrettyFormat();
			format.setEncoding("UTF-8");
			outputter.setFormat(format);

			xmlData = outputter.outputString(document);
			  

		} catch (Exception e) {
			e.printStackTrace();
			xmlData = qList.get(0).toString();
		}
		return xmlData;
	}
    
    public String getSelectXml(Map<String, Object> mtenMap) {
    	HashMap result = commonDao.select("bylawSql.getSelectXml",mtenMap);
    	String lawgbn = mtenMap.get("lawgbn")==null?"LAW":mtenMap.get("lawgbn").toString();
    	String XML = "";
    	if(lawgbn.equals("LAW")) {
    		XML = result.get("XMLDATA")==null?"":result.get("XMLDATA").toString();
    	}else if(lawgbn.equals("GLAW")) {
    		XML = result.get("XMLOLDNEWREVISION")==null?"":result.get("XMLOLDNEWREVISION").toString();
    	}
    	return XML;
    }
    
    public void setLawXMLDataUpdate(Map<String, Object> mtenMap) {
    	String allrevyn = mtenMap.get("allrevyn")==null?"":mtenMap.get("allrevyn").toString();
    	String xmldata = mtenMap.get("xmldata")==null?"":mtenMap.get("xmldata").toString();
    	
    	try {
			ByteArrayInputStream is = new ByteArrayInputStream(xmldata.getBytes("utf-8"));
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true); // never forget this!
			DocumentBuilder builder = factory.newDocumentBuilder();
			org.w3c.dom.Document doc = builder.parse(is);// (new
															// StringReader(bylaw.getXmldata()));
			org.w3c.dom.Element secondRoot = builder.parse(new org.xml.sax.InputSource(new StringReader(xmldata))).getDocumentElement();

			String linkGbn = "law/history/hisitem[@revcha='"+ secondRoot.getAttribute("revcha") + "']";
			XPathFactory factory2 = XPathFactory.newInstance();
			XPath xpath = factory2.newXPath();
			XPathExpression expr = xpath.compile(linkGbn);
			Object result = expr.evaluate(doc, XPathConstants.NODE);

			Node node = (Node) result;
			org.w3c.dom.Element set = (org.w3c.dom.Element) node;
			NamedNodeMap nnmap = node.getAttributes();

			mtenMap.put("revcha", secondRoot.getAttribute("revcha"));
			mtenMap.put("REVCHA", secondRoot.getAttribute("revcha"));
			mtenMap.put("title", secondRoot.getAttribute("title"));
			mtenMap.put("BOOKID", mtenMap.get("bookid"));
			
			// XML데이터 저장
			mtenMap.put("xmldatalink", linkAndXml(xmldata.replaceAll("<a5b5 />", "&lt;a5b5 /&gt;").replaceAll("<image", "&lt;image").replaceAll("baseline\" />","baseline\" /&gt;"),mtenMap));
			if(allrevyn.equals("Y")){	//연혁데이터수정
				commonDao.update("bylawSql.getAllLawXMLDataUpdate", mtenMap);
			}else{
				mtenMap.put("XMLDATA", mtenMap.get("xmldata"));
				mtenMap.put("XMLDATALINK", mtenMap.get("xmldatalink"));
				mtenMap.put("XMLOLDNEWREVISION", mtenMap.get("xmloldnewrevision"));
				mtenMap.put("STATEHISTORYID", mtenMap.get("statehistoryid"));
				commonDao.update("bylawSql.getLawXMLDataUpdate", mtenMap);
				//검색을 위한 텍스트 집어 넣기
				String bookid = mtenMap.get("bookid")==null?"":mtenMap.get("bookid").toString();
				this.setXmlSchBon(bookid);
				
				HashMap re = commonDao.select("bylawSql.selectDocByul",mtenMap.get("statehistoryid").toString());
				this.byulListInosert(re);
			}
			
		} catch (Throwable t) {
			System.out.println(t);
		}
		
	}
    
    public JSONArray getUserList(Map<String, Object> mtenMap) {
    	List ulist = commonDao.selectList("userSql.getUserList", mtenMap);
    	JSONArray jl = JSONArray.fromObject(ulist);
    	return jl;
    }
    
    public Map setUpdatelog(Map<String, Object> mtenMap) {
    	 	commonDao.insert("bylawSql.setUpdatelog", mtenMap);
    	 return mtenMap;
    }
    
    public void deleteLinkInfo1(String bookid){
    	commonDao.delete("bylawSql.deleteLinkInfo1", bookid);
	}
    
    public org.w3c.dom.Node getEl(org.w3c.dom.Node reJo){
		if(reJo != null){
			if(reJo.getParentNode().getNodeName().equals("jo")){
				reJo = reJo.getParentNode();
			}else{
				reJo = getEl(reJo.getParentNode());
			}
		}
		return reJo;
	}
    
    private String GetLink(String bookid ,String law,String sTitle,String Jo){
    	System.out.println("링크작업파아"+law+Jo+sTitle);
    	if(law!=null){
	    	if(law.equals("외국환거래법")){
	    		law="외국환거래법(신)";
	    	}
	    	if(law.equals("거래법")){
	    		law="증권거래법";
	    	}
	    	if(law.equals("공공기관운영법")){
	    		law="공공기관의운영에관한법률";
	    	}
    	}
        String sCmd = "";
        String sLaw = law.replaceAll(" ","");
        System.out.println("==>"+law.replaceAll(" ", ""));
        System.out.println("==>"+sTitle.replaceAll(" ", ""));
        System.out.println("==>"+sTitle);
        if(!law.replaceAll(" ", "").equals(sTitle.replaceAll(" ", "")) && !(sTitle.equals("정관")||sTitle.equals("조례")||sTitle.equals("법")||sTitle.equals("영"))){
        	if(Jo.equals("1")){
        		return "";
        	}
        }
        String sLawKind = "bylaw";
        String sLawid = "";
        String sResult = "";
        HashMap para = new HashMap();
        para.put("statecd", "현행");
        para.put("slaw", sLaw);
        Object getdata = commonDao.select("bylawSql.GetLink1", para);
        
        sLawid = getdata==null?"":getdata.toString();
        if (sLawid.equals("")){
            sLawKind = "law";
            getdata = commonDao.select("bylawSql.GetLink2", sLaw);
            sLawid = getdata==null?"":getdata.toString();
        }
        System.out.println("sLaw==>"+sLaw);
        System.out.println("sLawid==>"+sLawid);
        if (sLawid.equals("")){
            return "";
        }
        String sJo = "";
        Element root = new Element(sLawKind);
        if (sLawKind.equals("bylaw")){
            sJo = "bon" + Jo;
            root.setAttribute("lawid", sLawid);
            root.setAttribute("jono", sJo);
            root.setText(sTitle);
            HashMap spara = new HashMap();
            spara.put("bookid", bookid);
            spara.put("relationbookid", sLawid);
            this.saveLinkinfo(spara);
        }else if (sLawKind.equals("law")){
        	if(Jo.length()==1){
        		sJo = "000"+Jo+"00";	//법제처럽령
        		//sJo = "000"+Jo+"0000";	//mten법령
        	}else if(Jo.length()==2){
        		sJo = "00"+Jo+"00";	//법제처럽령
        		//sJo = "00"+Jo+"0000";	//mten법령
        	}else if(Jo.length()==3){
        		sJo = "0"+Jo+"00";	//법제처럽령
        		//sJo = "0"+Jo+"0000";	//mten법령
        	}
        	root.setAttribute("lawid", sLawid);
            root.setAttribute("jono", sJo);
            root.setText(sTitle);
        }
        XMLOutputter serializer = new XMLOutputter();
        sResult = serializer.outputString(root);
        System.out.println("sResult"+sResult);
        return sResult;
    }
    
    private String GetLink(String bookid,String law,String sTitle,String Jo,String Jobu){
    	System.out.println("링크작업파아2"+law+"/"+Jo+"/"+sTitle+"/"+Jobu);
        String sCmd = "";
        String sLaw = law.replaceAll(" ","");
        String sLawKind = "bylaw";
        String sLawid = "";
        String sResult = "";
        Object getdata = commonDao.select("bylawSql.GetLink1", sLaw);
        
        sLawid = getdata==null?"":getdata.toString();
        if (sLawid.equals("")){
            sLawKind = "law";
            getdata = commonDao.select("bylawSql.GetLink2", sLaw);
            sLawid = getdata==null?"":getdata.toString();
        }
        if (sLawid.equals("")){
            return "";
        }
        String sJo = "";
        Element root = new Element(sLawKind);
        if (sLawKind.equals("bylaw")){
            sJo = "bon" + Jo;
            if(!Jobu.equals("")){
            	sJo = "bon" + Jo + "bu" + Jobu;
            }
            root.setAttribute("lawid", sLawid);
            root.setAttribute("jono", sJo);
            root.setText(sTitle);
            HashMap spara = new HashMap();
            spara.put("bookid", bookid);
            spara.put("relationbookid", sLawid);
            this.saveLinkinfo(spara);
        }else if (sLawKind.equals("law")){
        	if(Jo.length()==1){
        		if(Jobu.length()==1){
        			sJo = "000"+Jo+"0"+Jobu;	//법제처
        			//sJo = "000"+Jo+"0"+Jobu+"00";//mten
        		}else{
        			sJo = "000"+Jo+""+Jobu;		//법제처
        			//sJo = "000"+Jo+""+Jobu+"00";//mten
        		}
        	}else if(Jo.length()==2){
        		if(Jobu.length()==1){
        			sJo = "00"+Jo+"0"+Jobu;		//법제처
        			//sJo = "00"+Jo+"0"+Jobu+"00";//mten
        		}else{
        			sJo = "00"+Jo+""+Jobu;		//법제처
        			//sJo = "00"+Jo+""+Jobu+"00";//mten
        		}
        	}else if(Jo.length()==3){
        		if(Jobu.length()==1){
        			sJo = "0"+Jo+"0"+Jobu;		//법제처
        			//sJo = "0"+Jo+"0"+Jobu+"00";//mten
        		}else{
        			sJo = "0"+Jo+""+Jobu;		//법제처
        			//sJo = "0"+Jo+""+Jobu+"00";	//엠텐
        		}
        	}
            root.setAttribute("lawid", sLawid);
            root.setAttribute("jono", sJo);
            root.setText(sTitle);
        }
        XMLOutputter serializer = new XMLOutputter();
        sResult = serializer.outputString(root);
        System.out.println("sResult"+sResult);
        return sResult;
    }
    
    public void saveLinkinfo(HashMap para){
    	commonDao.insert("bylawSql.saveLinkinfo",para);
    }
    
    private String GetStrBetWeen(String str, String s1,String s2)
    {
        String sResult = "";
        int n1 = str.indexOf(s1,0);
        int n2 = str.indexOf(s2,n1+1);
        if (n1>0 && n2>0)
        {
            sResult = str.substring(n1+1,n2);
        }
        return sResult;
    }
    
    private String GetBetweenString(String s, int start, int end){
    	System.out.println(start+s+end);
    	String result = "";
    	try{
    		result = (s.substring(start+1,end));
    	}catch(Exception e){
    		System.out.println("링크생성 에러"+e);
    		result = s;
    	}
	    return result;
	}
    
    private int FindLawkind(String Law, String[][] lawkind){
        int nIdx = -1;
        System.out.println("lawkind.length"+lawkind.length);
        for (int i = 0; i < lawkind.length; i++){
            if (lawkind[i][0].equals(Law)){
                nIdx = i;
                break;
            }
        }
        return nIdx;
    }
    
    public String linkAndXml(String Xmldata,Map mtenMap) {
    	System.out.println("METH==>linkAndXml");
		String Msg="";
		String sLine = "";
		Xmldata = Xmldata.replaceAll("<a5b5", "&lt;a5b5").replaceAll("<a5b5/>", "&lt;a5b5/&gt;");
		Xmldata = Xmldata.replaceAll("<image", "&lt;image");
		Xmldata = Xmldata.replaceAll("“", "\"").replaceAll("”", "\"");
		String bookid = mtenMap.get("BOOKID")==null?"":mtenMap.get("BOOKID").toString();
		String revcha = mtenMap.get("REVCHA")==null?"":mtenMap.get("REVCHA").toString();
		this.deleteLinkInfo1(bookid);
		//연혁포함 문서 링크 생성
		//String linkGbn = "//cont";
		//현행 문서 링크 생성  //jo[@startcha='1' or @endcha>='1']//cont   //jo[@startcha <= '1' and @endcha>='1']//cont
		String linkGbn = "//jo[@startcha <= '"+revcha+"' and @endcha>='"+revcha+"']//cont[local-name(child::*)!='table']";
		String linkGbn2 = "//jo[@startcha <= '"+revcha+"' and @endcha>='"+revcha+"']";
		System.out.println("linkGbn"+linkGbn);
		
		//참조규정/법령
		List lawList = commonDao.selectList("bylawSql.etcLinkSelect3",bookid);
		HashMap contTable = new HashMap();
		for(int i=0; i<lawList.size(); i++) {
			HashMap result = (HashMap)lawList.get(i);
			contTable.put(result.get("CONTID").toString(), result.get("CNT"));
		}
		try{
			ByteArrayInputStream is = new ByteArrayInputStream(Xmldata.getBytes("euc-kr"));
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	        factory.setNamespaceAware(true); // never forget this!
	        DocumentBuilder builder = factory.newDocumentBuilder();
	        org.w3c.dom.Document doc = builder.parse(is);//(new StringReader(bylaw.getXmldata()));
	        //new StringReader(bylaw.getXmldata());
	        XPathFactory factory2 = XPathFactory.newInstance();
	        XPath xpath = factory2.newXPath();
	        
	        XPathExpression expr2 = xpath.compile(linkGbn2);
	        Object result2 = expr2.evaluate(doc, XPathConstants.NODESET);
	        NodeList nodes2 = (NodeList) result2;
	        for (int j = 0; j < nodes2.getLength(); j++) {
	        	//연계된 판례가 있는지 체크
	        	String contid = ((org.w3c.dom.Element)nodes2.item(j)).getAttribute("contid");
	        	if(contTable.get(contid)!=null) {
	        		((org.w3c.dom.Element)nodes2.item(j)).setAttribute("fchk", "Y");
	        	}else {
	        		((org.w3c.dom.Element)nodes2.item(j)).setAttribute("fchk", "N");
	        	}
	        	
	        	/*ArrayList lawListS = new ArrayList();
	        	for(int hk=0; hk<lawList.size(); hk++){
	        		HashMap lawre = (HashMap)lawList.get(hk);
	        		String pcontid = lawre.get("CONTID").toString();
	        		if(contid.equals(pcontid)){
	        			lawListS.add(lawre);
	        		}
	        	}
	        	
	        	if(lawListS.size()>0){
	        		org.w3c.dom.Element bylaws = doc.createElement("bylawList");
	        		for(int p=0; p<lawListS.size(); p++){
	        			org.w3c.dom.Element sspan = doc.createElement("bylaw");
	        			HashMap pre = (HashMap)lawListS.get(p);
	        			sspan.setAttribute("pkey", pre.get("BOOKID").toString());
	        			sspan.setTextContent(pre.get("TITLE").toString());
	        			bylaws.appendChild(sspan);
	        		}
	        		nodes2.item(j).appendChild(bylaws);
	        	}*/
	        }
	        
	        
	        
	        
	        XPathExpression expr = xpath.compile(linkGbn);
	        Object result = expr.evaluate(doc, XPathConstants.NODESET);
	        
	        NodeList nodes = (NodeList) result;
	        String s ="";
	        
	        String [][] lawKind =    { { "시행규칙", "" }  //{ "시행규정", "" }
						            , { "규칙", "" }    //, { "시행세칙", "" }
						            , { "지침", "" }    //, { "시행지침", "" }
						            , { "요령", "" }
						            , { "윤리규정행동세칙", "윤리규정행동세칙&#91;한국지역난방공사 임직원 행동강령&#93;" }
						            , { "세칙", "" }
						            , { "규정", "" }
						            , { "정관", "한국지역난방공사정관" }
						            , { "영", "" }
						            , { "시행령", "" }
						            , { "강령", "" }
						            , { "법률", "" }
						            , { "법", "" }
						            , { "예금", "" }
						            , { "기준", "" }
						            , { "매뉴얼", "" }
						            , { "업무절차", "" }
						            , { "조례", "" }
						        };
	        String sNewBody = "";
	        String sConts = "";

	        String sPattern = "^제[\\d]{1,}조의[\\d]{1,}|^제[\\d]{1,}조";
	        String topLaw = mtenMap.get("TITLE")==null?"":mtenMap.get("TITLE").toString();;	//해당 문서의 규정에 대한 정의 
	        String sBeforeLaw = ""; // 바로이전 법령저장

	        String topLawBon = "";
	        String topLawReplace = "";
	        HashMap topReplace = new HashMap();
	        
	        String topLink = "";
	        String Obookid = "";
	        String contid = "";
	        boolean topLawOne = false;
	        for (int j = 0; j < nodes.getLength(); j++) {
	        	s =nodes.item(j).getTextContent();
	        	
	        	boolean tableYn = false;
	        	String tablePattern = "(<TABLE.*?>[\\s\\S]*?</TABLE>)";
	    		Pattern tpattern = Pattern.compile(tablePattern);
	    	
	    		Matcher tmatch = tpattern.matcher(s);
	    		ArrayList tableTxt = new ArrayList();
	    		while (tmatch.find()) {
	    			tableTxt.add(tmatch.group(1));
	    			tableYn = true;
	    		}
	    		if(tableYn){
	    			s = s.replaceAll("<TABLE.*?>[\\s\\S]*?</TABLE>", "");
	    		}
	        	
        		org.w3c.dom.Element reJo = (org.w3c.dom.Element)this.getEl(nodes.item(j));
	        	String mJoNo = reJo.getAttribute("contno");
	        	String sJoNo = reJo.getAttribute("contsubno");
	        	String Jono = "";
	        	System.out.println("JoNo : "+mJoNo);
	        	System.out.println("sJoNo : "+sJoNo);
	        	System.out.println("Bookid : "+bookid);
        		
	        	Jono = "bon" + mJoNo;
				if(!sJoNo.equals("") && !sJoNo.equals("0")){
					Jono = Jono + "bu" + sJoNo;
				}
	            
				System.out.println("Jono : "+Jono);
//				String JoCnt = "";
//				if(!reJo.getParentNode().getNodeName().equals("buchick")){	//부칙에 포함되는 조는 참조조문 검색에서 제외한다.
//	        		HashMap pJo = new HashMap();
//	        		pJo.put("Bookid", bylaw.getBookid());
//	        		pJo.put("Jono", Jono);
//	        		JoCnt = (String)getSqlMapClientTemplate().queryForObject("bylawSql.chkJo",pJo);
//	        		reJo.setAttribute("jocnt", JoCnt==""?"0":JoCnt);
//	        		reJo.getParentNode().replaceChild(reJo,getEl(nodes.item(j)));
//	        		System.out.println("JoCnt : "+reJo.getParentNode());
//	        	}
//        		
//				
//				System.out.println("JoCnt : "+JoCnt);
//        		
        		
	        	sConts = s;
	        	Obookid = "";
	        	System.out.println("%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@s3333333"+Obookid);
	        	int nLawLocation=0;

	        	//상단 규정및 법 정의
	        	
        		if(sConts.indexOf("「")>0){
        			System.out.println("%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@s3333333");
        			String sPatternlaw = "\".*규정\"|\".*조례\"|\".*법\"|\".*법률\"|“.*법”|“.*규정”|“.*조례”";
        			Pattern patternlaw = Pattern.compile( sPatternlaw );
        			Matcher matcherlaw = patternlaw.matcher(sConts);
        			if(matcherlaw.find()){	
        				topLawBon = sConts.substring(sConts.indexOf("「")+1,sConts.indexOf("」"));
        				String[] lawgijun = matcherlaw.group().split("\\s");
        				System.out.println("lawgijun[lawgijun.length-1]===>"+lawgijun.length);
        				for(int v=0; v<lawgijun.length; v++) {
        					System.out.println(lawgijun[v]);
        					
        					patternlaw = Pattern.compile( sPatternlaw );
        					matcherlaw = patternlaw.matcher(lawgijun[v]);
        					if(matcherlaw.find()) {
        						String sin = matcherlaw.group();
        						System.out.println("sin==>"+sin);
        						topLawReplace = sin.replaceAll("\"", "").replaceAll("“", "").replaceAll("”", ""); 
        						break;
        					}
        				}
        				System.out.println("lawgijun[lawgijun.length-1]===>"+lawgijun[lawgijun.length-1]);
        				//String as = lawgijun[lawgijun.length-1];
        				//topLawReplace = as.replaceAll("\"", ""); 
        				System.out.println("2222222%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@s3333333"+topLawBon+topLawReplace);
        				topReplace.put(topLawReplace,topLawBon);
        				String dumy = topReplace.get(topLawReplace)==null?"":topReplace.get(topLawReplace).toString();
        				topLink = GetLink(bookid,dumy, topLawReplace, "1");
        				
        				if(MakeHan.isContains(sConts, "(이하")) {
        					System.out.println("한번에 들어올때");
        					String sPatternlawsub = "^.*규정」\\(이하|^.*법률」\\(이하|^.*법」\\(이하|^.*조례」\\(이하";
        					System.out.println("111");
                			Pattern patternlawsub = Pattern.compile( sPatternlawsub );
                			System.out.println("222");
                			Matcher matcherlawsub = patternlawsub.matcher(sConts);
                			System.out.println("333");
                			if(matcherlawsub.find()){	
                				System.out.println("matcherlaw.group()matcherlaw.group()matcherlaw.group()"+matcherlawsub.group());
                				String[] lawgijunsub = matcherlawsub.group().split("\\s");
                				String as = lawgijunsub[lawgijunsub.length-1];
                				System.out.println("matcherlaw.group()matcherlaw.group()matcherlaw.group()"+topLawBon);

                				String sPatternlaw1 = "\".*규정\"|“규정”|\".*법률\"|\".*법\"|“.*규정”|“.*법”|“법”|\".*조례\"";
                				Pattern patternlaw1 = Pattern.compile( sPatternlaw1 );
                				Matcher matcherlaw1 = patternlaw1.matcher(sConts);
                				System.out.println(sConts);
                				if(matcherlaw1.find()){
                					System.out.println("start.");
                					String[] lawgijun1 = matcherlaw1.group().split("\\s");
                					String as1 = lawgijun1[lawgijun1.length-1];
                					System.out.println("as1==>"+as1);
                					topLawReplace = as1.replaceAll("\"", "").replaceAll("“", "").replaceAll("”", ""); 
                					System.out.println("topLawReplace==>"+topLawReplace);
                					topReplace.put(topLawReplace,topLawBon);
                					System.out.println("topLawReplace==>"+topLawReplace);
                    				String dumy2 = topReplace.get(topLawReplace)==null?"":topReplace.get(topLawReplace).toString();
                    				System.out.println("dumy==>"+dumy2);
                    				topLink = GetLink(bookid,dumy2, topLawReplace, "1");
                    				System.out.println("topLink==>"+topLink);
                				}
                			}
        				}
        			}
        		}else if(MakeHan.isContains(sConts, "금융실명거래 및 비밀보장에 관한 법률")||MakeHan.isContains(sConts, "공공기관의 운영에 관한 법률")
        				||MakeHan.isContains(sConts, "부패방지및국민권익위원회의설치와운영에관한법률")
        				||MakeHan.isContains(sConts, "공공기관의정보공개에관한법률")
        				||MakeHan.isContains(sConts, "측량·수로조사 및 지적에 관한 법률")){	//기타 법처리
        			sConts = sConts.replaceAll("금융실명거래 및 비밀보장에 관한 법률", "「금융실명거래 및 비밀보장에 관한 법률」");
        			sConts = sConts.replaceAll("공공기관의 운영에 관한 법률", "「공공기관의 운영에 관한 법률」");
        			sConts = sConts.replaceAll("부패방지및국민권익위원회의설치와운영에관한법률", "「부패방지및국민권익위원회의설치와운영에관한법률」");
        			sConts = sConts.replaceAll("공공기관의정보공개에관한법률", "「공공기관의정보공개에관한법률」");
        			sConts = sConts.replaceAll("측량·수로조사 및 지적에 관한 법률", "「측량·수로조사 및 지적에 관한 법률」");
        			String sPatternlaw = "\".*규정\"|\".*법률\"|\".*법\"";
        			Pattern patternlaw = Pattern.compile( sPatternlaw );
        			Matcher matcherlaw = patternlaw.matcher(sConts);
        			if(matcherlaw.find()){	
        				topLawBon = sConts.substring(sConts.indexOf("「")+1,sConts.indexOf("」"));
        				System.out.println("DDDDDDDDDDDDDDDDDD"+topLawBon);
        				String[] lawgijun = matcherlaw.group().split("\\s");
        				String as = lawgijun[lawgijun.length-1];
        				topLawReplace = as.replaceAll("\"", ""); 
        				System.out.println("topLawReplace"+topLawReplace);
        				topLink = GetLink(bookid,topLawBon, topLawReplace, "1");
        			}
        		}else if(sConts.indexOf("「")<0 && MakeHan.isContains(sConts, "(이하")){
        			System.out.println("%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@s1");
        			String sPatternlaw = "^.*규정\\(이하|^.*법률\\(이하|^.*법\\(이하|^.*조례\\(이하";
        			Pattern patternlaw = Pattern.compile( sPatternlaw );
        			Matcher matcherlaw = patternlaw.matcher(sConts);
        			if(matcherlaw.find()){	
        				System.out.println("matcherlaw.group()matcherlaw.group()matcherlaw.group()"+matcherlaw.group());
        				String[] lawgijun = matcherlaw.group().split("\\s");
        				String as = lawgijun[lawgijun.length-1];
        				topLawBon = as.substring(0,as.indexOf("(이하"));
        				System.out.println("matcherlaw.group()matcherlaw.group()matcherlaw.group()"+topLawBon);

        				String sPatternlaw1 = "\".*규정\"|“규정”|\".*법률\"|\".*법\"|“.*규정”|“.*법”|“법”|\".*조례\"";
        				Pattern patternlaw1 = Pattern.compile( sPatternlaw1 );
        				Matcher matcherlaw1 = patternlaw1.matcher(sConts);
        				System.out.println(sConts);
        				if(matcherlaw1.find()){
        					System.out.println("start.");
        					String[] lawgijun1 = matcherlaw1.group().split("\\s");
        					String as1 = lawgijun1[lawgijun1.length-1];
        					System.out.println("as1==>"+as1);
        					topLawReplace = as1.replaceAll("\"", "").replaceAll("“", "").replaceAll("”", ""); 
        					System.out.println("topLawReplace==>"+topLawReplace);
        					topReplace.put(topLawReplace,topLawBon);
        					System.out.println("topLawReplace==>"+topLawReplace);
            				String dumy = topReplace.get(topLawReplace)==null?"":topReplace.get(topLawReplace).toString();
            				System.out.println("dumy==>"+dumy);
            				topLink = GetLink(bookid,dumy, topLawReplace, "1");
            				System.out.println("topLink==>"+topLink);
        				}
        			}
        		}
	        	
	        	sConts = sConts.replaceAll("<cont>", "<cont> ");
	        	String[] split = sConts.split("\\s");
	        	String sLinkedCont = "";
	        	String sLink = "";    // 링크내용
	        	String sTitle = "";   // 링크가될 법령텍스트 저장
	        	String sGathter = "";
	        	String backWord = "";	//이전 단어 기억
	        	String backWordLink = "";	//이전 단어 링크 기억
	        	String sLink2 = "";
	        	String sTitle2 = "";
	        	boolean joJak = false; //이전 작업이 조작업이였는지 기억
	        	boolean bGathering=false;
	        	
	        	int nGateringCnt = 0;
	        	ArrayList split2 = new ArrayList();
	        	int hkk=0;
	        	for (int k=0; k<split.length; k++){
	        		if(split[k].length()!=0) {
	        			split2.add(hkk, split[k]);
	        			hkk++;
	        		}
	        		System.out.println("WORD==>"+split[k]);
	        	}
	        	String plusWord = "";
	        	for (int k=0; k<split2.size(); k++){
	        		
	        		String sWord = "";
	        		sWord = split2.get(k).toString();
	        		if(!plusWord.equals("")) {
	        			sWord = plusWord+sWord;
	        			plusWord = "";
	        		}
	        		String sTWord = "";
	        		String sLaw = "";
	        		sTWord = sWord;
	        		sLink = sWord;
	        		sTitle = sWord.replaceAll("<cont>","").replaceAll("\"","").replaceAll("\\d.","");
	        		sLink = "";
	        		sLink2 = "";

	        		//한번에 꺽쇄가 같이 올때 에러 발생 처리가 필요하다.
        			String sPatternlaw = "^「.*」";
        			Pattern patternlaw = Pattern.compile( sPatternlaw );
        			Matcher matcherlaw = patternlaw.matcher(sTitle);
        			if(matcherlaw.find()){	
        				sLink = GetLink(bookid,sTitle.substring(sTitle.indexOf("「")+1,sTitle.indexOf("」")), sTitle.substring(sTitle.indexOf("「")+1,sTitle.indexOf("」")), "1");
        				System.out.println("sTitlesTWord.substring(sTitle.indexOf("+sTitle.substring(sTitle.indexOf("「")+1,sTitle.indexOf("」")));
        				if (!sWord.equals("") && !sLink.equals("")){
        					sTWord = sTWord.replaceAll(sTitle.substring(sTitle.indexOf("「")+1,sTitle.indexOf("」")), sLink);
        				}
        				backWordLink = sLink;
        				sBeforeLaw = sTitle.substring(sTitle.indexOf("「")+1,sTitle.indexOf("」"));
        				sLinkedCont += sTWord + " ";
        				sNewBody += sTWord + " ";
        				backWord = sWord;
        				System.out.println("sLinkedCont^"+sLinkedCont);
        				
        				System.out.println(sLinkedCont.indexOf("「"));
        				System.out.println(sLinkedCont.lastIndexOf("「"));
        				if(sTWord.indexOf("「")!=sTWord.lastIndexOf("「")) {
        					plusWord = sLinkedCont.substring(sLinkedCont.lastIndexOf("「"));
        					
        					sLinkedCont = sLinkedCont.replace(plusWord, "");
        					System.out.println("plusWord=>"+plusWord);
        					System.out.println("sLinkedCont=>"+sLinkedCont);
        				}
        				
        				
        				String ssPattern = "제[\\d]{1,}조의[\\d]{1,}|제[\\d]{1,}조";
						Pattern spattern = Pattern.compile( ssPattern );
		        		Matcher smatcher = spattern.matcher(sTWord);
		        		System.out.println("sTWord1===>"+sTWord);
						if (smatcher.find()){	//조번호일경우 처리
							System.out.println("1조번호가 붙어있을경우 처리");
							
							String sPatternbu = "제[\\d]{1,}조의[\\d]{1,}";
        					Pattern patternbu = Pattern.compile( sPatternbu );
        					Matcher matcherbu = patternbu.matcher(smatcher.group());
        					if(matcherbu.find()){	//부속번호가 있을경우 처리
        						System.out.println("1부속번호 있는 경우");
        						System.out.println("1smatcher.group()==>"+smatcher.group());
        						System.out.println("1smatcher.group()==>"+smatcher.group().indexOf("조의"));
        						String strPattenr = "\\D";
        						String sNo = smatcher.group().substring(1,smatcher.group().indexOf("조의")).replaceAll(strPattenr, ""); 
        						System.out.println("sNO==>"+sNo);
        						sTitle2 = smatcher.group();
        						System.out.println("sTitle2==>"+sTitle2);
        						sLink2 = GetLink(bookid,sBeforeLaw, sTitle2, sNo, smatcher.group().substring(smatcher.group().indexOf("조의")+2,smatcher.group().length()));
        					}else{		//부속번호가 없을경우 처리
        						System.out.println("1부속번호 없을 경우");
        						String strPattenr = "\\D";
        						String sNo = smatcher.group().replaceAll(strPattenr, "");
        						
        						sTitle2 = smatcher.group();
        						sLink2 = GetLink(bookid,sBeforeLaw, sTitle2, sNo);
        					}
        					System.out.println("1sTWord2===>"+sTWord);
        					System.out.println(sTitle2);
        					System.out.println(sLink2);
        					sTWord = sLinkedCont.replaceAll(sTitle2, sLink2);
        					System.out.println("1sTWord3===>"+sTWord);
        					System.out.println(sTWord);
        					System.out.println("sLinkedCont===>"+sLinkedCont);
        					sLinkedCont = sTWord;
		        		}
        				
        				
        				
        				continue;
        			}
	        		// 조일경우
	        		Pattern pattern = Pattern.compile( sPattern );
	        		Matcher matcher = pattern.matcher(sWord);
	        		if (matcher.find()){	//조번호일경우 처리
	        			System.out.println("backWordLinkbackWordLinkbackWordLinkbackWordLinkbackWordLink222"+backWordLink);
	        			System.out.println("backWordLinkbackWordLinkbackWordLinkbackWordLinkbackWordLink222"+backWord);
	        			if(MakeHan.isContains(backWord, "규정")||MakeHan.isContains(backWord, "정관")||MakeHan.isContains(backWord, "법")||MakeHan.isContains(backWord, "법률")||
	        					MakeHan.isContains(backWord, "규칙")||MakeHan.isContains(backWord, "세칙")||MakeHan.isContains(backWord, "시행령")||MakeHan.isContains(backWord, "요령")||
	        					backWord.equals("한다)")||MakeHan.isContains(backWord, "지침")||MakeHan.isContains(backWord, "조례")||
	        					backWord.equals("영")||joJak){	//조번호 앞에 있어야 할 단어들..MakeHan.isContains(backWord, "한다.")||
	        				System.out.println("backWordLinkbackWordLinkbackWordLinkbackWordLinkbackWordLink"+backWordLink+"%%%"+joJak);
	        				if(joJak){
	        					System.out.println("backWordLinkbackWordLinkbackWordLinkbackWordLinkbackWordLink111111"+backWordLink);
	        					String sPatternbu = "^제[\\d]{1,}조의[\\d]{1,}";
	        					Pattern patternbu = Pattern.compile( sPatternbu );
	        					Matcher matcherbu = patternbu.matcher(sWord);
	        					if(matcherbu.find()){	//부속번호가 있을경우 처리
	        				
	        						String strPattenr = "\\D";
	        						String sNo = matcher.group().substring(0,sWord.indexOf("조의")).replaceAll(strPattenr, ""); 
	        						sTitle = matcher.group();
	        						sLink = GetLink(bookid,sBeforeLaw, sTitle, sNo, matcher.group().substring(sWord.indexOf("조의")+2,matcher.group().length()));
	        					}else{		//부속번호가 없을경우 처리
	        						String strPattenr = "\\D";
	        						String sNo = matcher.group().replaceAll(strPattenr, "");
	        						
	        						sTitle = matcher.group();
	        						if(sBeforeLaw.equals("규정")) {
	        							sBeforeLaw = topReplace.get(sBeforeLaw)==null?"":topReplace.get(sBeforeLaw).toString();
	        						}
	        						sLink = GetLink(bookid,sBeforeLaw, sTitle, sNo);
	        					
	        					}
	        				}else{
	        					System.out.println("backWordLinkbackWordLinkbackWordLinkbackWordLinkbackWordLink777777"+backWordLink+"^^^"+sBeforeLaw);
	        					if(!MakeHan.isContains(backWord, "규정등")&&!MakeHan.isContains(backWord, "결제업무규정")&& MakeHan.isContains(backWordLink, "lawid")){
	        						String sPatternbu = "^제[\\d]{1,}조의[\\d]{1,}";
	        						Pattern patternbu = Pattern.compile( sPatternbu );
	        						Matcher matcherbu = patternbu.matcher(sWord);
	        						if(matcherbu.find()){	//부속번호가 있을경우 처리
	        							System.out.println("chk1");
	        							String strPattenr = "\\D";
	        							String sNo = matcher.group().substring(0,sWord.indexOf("조의")).replaceAll(strPattenr, ""); 
	        							sTitle = matcher.group();
	        							if(sBeforeLaw.equals("규정")) {
	        								sBeforeLaw = topReplace.get(sBeforeLaw)==null?"":topReplace.get(sBeforeLaw).toString();
	        							}
	        							sLink = GetLink(bookid,sBeforeLaw, sTitle, sNo, matcher.group().substring(sWord.indexOf("조의")+2,matcher.group().length()));
	        						}else{		//부속번호가 없을경우 처리
	        							System.out.println("chk2");
	        							String strPattenr = "\\D";
	        							String sNo = matcher.group().replaceAll(strPattenr, "");
	        							
	        							sTitle = matcher.group();
	        							
	        							if(sBeforeLaw.equals("규정")) {
	        								sBeforeLaw = topReplace.get(sBeforeLaw)==null?"":topReplace.get(sBeforeLaw).toString();
	        							}
	        							sLink = GetLink(bookid,sBeforeLaw, sTitle, sNo);
	        						
	        						}
	        						System.out.println("chk3");
	        					}
	        					System.out.println("chk4");
	        				}
	        				joJak = true;
	        				
	        			}
	        		}else{ // 조번호가 아닐경우 처리
	        			if(!MakeHan.isContains(sWord, "및")){	//조번호 앞에 규정이외에 단어가 있을경우
	        				joJak = false;
	        				if(sWord.equals("한다)")){	//조번호 앞에 규정이외에 단어가 있을경우
	        					joJak = true;
	        					System.out.println("여기입니다.........1111");
	        				}
	        			}
	        			boolean G = true;
        				if (MakeHan.isContains(sWord, "「") || bGathering){ // "「" 나오면 다음에 "」"가 나올때까지(오류로 안나올겨우는 6번이후에는 무시) sGathter 에 sWord저장
        					nGateringCnt++;
        					bGathering = true;
        					sGathter += " " + sWord;
        					if(MakeHan.isContains(sGathter, "」")){
        						bGathering = false;
        						nGateringCnt = 0;
        					}
        					System.out.printf("황규관 로그 2013. 11. 21.====>(%s)\n",sGathter);
        					System.out.printf("황규관 로그 2013. 11. 21.====>(%s)\n",nGateringCnt);
        					System.out.printf("황규관 로그 2013. 11. 21.====>(%s)\n",( MakeHan.isContains(sGathter, "「") && MakeHan.isContains(sGathter, "」") ) || nGateringCnt > 20);
        					if ( ( MakeHan.isContains(sGathter, "「") && MakeHan.isContains(sGathter, "」") ) || nGateringCnt > 20){
        						sTWord = sGathter.substring(1);
        						sLink = sTWord;
        						
        						sTitle = sTWord.replaceAll("<cont>","").replaceAll("\"","");//.replaceAll("\\d.","");
        						sTitle = GetStrBetWeen(sGathter, "「", "」"); // 법명을 찾아서
								if (!sTitle.equals("")){
								     sLink = GetLink(bookid,sTitle, sTitle, "1"); // 링크를 생성
								     
								     sBeforeLaw = sTitle;
								     System.out.println("sWord==>"+sWord);
								     System.out.println("sLink==>"+sLink);
								    if (!sWord.equals("") && !sLink.equals("")){
								    	sTWord = sTWord.replaceAll(sTitle, sLink);
								    	
								    	System.out.println("====>"+sTWord);
								    	if (MakeHan.isContains(sTWord, "이하") && topReplace.size() == 0) {
											String sPatternlawH = "\".*규정\"|\".*조례\"|\".*법\"|\".*법률\"|“.*법”|“.*규정”|“.*조례”";
											Pattern patternlaw1 = Pattern.compile(sPatternlawH);
											Matcher matcherlaw1 = patternlaw1.matcher(sConts);
											String sin = matcherlaw1.group();
											topLawReplace = sin.replaceAll("\"", "").replaceAll("“", "").replaceAll("”", "");
											topReplace.put(topLawReplace, sTitle);
								        }
								    	
								    	String ssPattern = "제[\\d]{1,}조의[\\d]{1,}|제[\\d]{1,}조";
		        						Pattern spattern = Pattern.compile( ssPattern );
		        		        		Matcher smatcher = spattern.matcher(sTWord);
		        		        		System.out.println("sTWord1===>"+sTWord);
										if (smatcher.find()){	//조번호일경우 처리
											System.out.println("조번호가 붙어있을경우 처리");
											
											String sPatternbu = "제[\\d]{1,}조의[\\d]{1,}";
				        					Pattern patternbu = Pattern.compile( sPatternbu );
				        					Matcher matcherbu = patternbu.matcher(smatcher.group());
				        					if(matcherbu.find()){	//부속번호가 있을경우 처리
				        						System.out.println("부속번호 있는 경우");
				        						System.out.println("smatcher.group()==>"+smatcher.group());
				        						System.out.println("smatcher.group()==>"+smatcher.group().indexOf("조의"));
				        						String strPattenr = "\\D";
				        						String sNo = smatcher.group().substring(1,smatcher.group().indexOf("조의")).replaceAll(strPattenr, ""); 
				        						System.out.println("sNO==>"+sNo);
				        						sTitle2 = smatcher.group();
				        						System.out.println("sTitle2==>"+sTitle2);
				        						sLink2 = GetLink(bookid,sBeforeLaw, sTitle2, sNo, smatcher.group().substring(smatcher.group().indexOf("조의")+2,smatcher.group().length()));
				        					}else{		//부속번호가 없을경우 처리
				        						System.out.println("부속번호 없을 경우");
				        						String strPattenr = "\\D";
				        						String sNo = smatcher.group().replaceAll(strPattenr, "");
				        						
				        						sTitle2 = smatcher.group();
				        						sLink2 = GetLink(bookid,sBeforeLaw, sTitle2, sNo);
				        					}
				        					System.out.println("sTWord2===>"+sTWord);
				        					System.out.println(sTitle2);
				        					System.out.println(sLink2);
				        					sTWord = sTWord.replaceAll(sTitle2, sLink2);
				        					System.out.println("sTWord3===>"+sTWord);
				        					System.out.println(sTWord);
		        		        		}
										G = false;
									}
								}
                                 sTWord = sGathter;
                                 sGathter = "";
        					}else{
        						continue;
        					}
        					System.out.println("topReplace==>"+topReplace);
        				}
	        			END:
	        				for (int i = 0; i < lawKind.length; i++){  // 법령유형찾기
	        					//for문을 빠져나가기 위한 filter
	        					if(!G) break END;
	        					if (sTWord.length()==0) break END;
	        					if(!(MakeHan.isContains(sTWord, "법")||MakeHan.isContains(sTWord, "규정")||MakeHan.isContains(sTWord, "예금")||MakeHan.isContains(sTWord, "법률")||MakeHan.isContains(sTWord, "강령")
	        							||MakeHan.isContains(sTWord, "시행령")||MakeHan.isContains(sTWord, "영")||MakeHan.isContains(sTWord, "세칙")||MakeHan.isContains(sTWord, "요령")||MakeHan.isContains(sTWord, "지침")
	        							||MakeHan.isContains(sTWord, "규칙")||MakeHan.isContains(sTWord, "시행규칙")||MakeHan.isContains(sTWord, "정관")||MakeHan.isContains(sTWord, "기준")||MakeHan.isContains(sTWord, "매뉴얼")||MakeHan.isContains(sTWord, "업무절차")||MakeHan.isContains(sTWord, "조례"))){
	        						break END;
	        					}
	        					if(!(MakeHan.isContains(sTWord, "법")||MakeHan.isContains(sTWord, "규정")||MakeHan.isContains(sTWord, "예금")||MakeHan.isContains(sTWord, "법률")||MakeHan.isContains(sTWord, "강령")
	        							||MakeHan.isContains(sTWord, "시행령")||MakeHan.isContains(sTWord, "영")||MakeHan.isContains(sTWord, "세칙")||MakeHan.isContains(sTWord, "요령")||MakeHan.isContains(sTWord, "지침")
	        							||MakeHan.isContains(sTWord, "규칙")||MakeHan.isContains(sTWord, "시행규칙"))){
	        						if (sTWord.equals("<hang")||sTWord.equals("<ho")||sTWord.equals("<mok")||sTWord.equals("<dan")) break END;
	        						if (sTWord.equals("</hang>")||sTWord.equals("</ho>")||sTWord.equals("</mok>")||sTWord.equals("</dan>")) break END;
	        						if (MakeHan.isContains(sTWord, "contno="))break END;
	        						if (sTWord.equals("<cont>"))break END;
	        					}
	        					if (sTWord.equals("영문으로는")||sTWord.equals("규정할")) break END;
	        					if (sTWord.length() < lawKind[i][0].length()) continue;
	        					
	        					if (MakeHan.isContains(sTWord, "법인")||MakeHan.isContains(sTWord, "법정")||MakeHan.isContains(sTWord, "법상")||MakeHan.isContains(sTWord, "법률자문")||
	        							MakeHan.isContains(sTWord, "방법")||MakeHan.isContains(sTWord, "법조계")||MakeHan.isContains(sTWord, "법규")||MakeHan.isContains(sTWord, "법원")||
	        							MakeHan.isContains(sTWord, "법률검토")||MakeHan.isContains(sTWord, "법률고문")||MakeHan.isContains(sTWord, "법적")||MakeHan.isContains(sTWord, "영수증")||
	        							MakeHan.isContains(sTWord, "법무")||MakeHan.isContains(sTWord, "영향")||MakeHan.isContains(sTWord, "영상")
	        							){//||MakeHan.isContains(sTWord, "영업")
	        						if(!MakeHan.isContains(sTWord, "법인세법"))continue;
	        						
	        					}
	        					
	        					if(backWord.equals("다른")||backWord.equals("기타")||MakeHan.isContains(backWord, "관련"))continue;
	        					if (sTWord.equals("규정에")||sTWord.equals("규정된")||MakeHan.isContains(sTWord, "규정하")||//MakeHan.isContains(sTWord, "규정을")||
	        							MakeHan.isContains(sTWord, "규정등")||MakeHan.isContains(sTWord, "규정문서")||MakeHan.isContains(sTWord, "규정서식")||MakeHan.isContains(sTWord, "규정담당")||
	        							sTWord.equals("규정함을")||sTWord.equals("규정한")||sTWord.equals("규정되지")||sTWord.equals("규정·지침·지시")||sTWord.equals("규정·지침·지시")||sTWord.equals("요령은")||sTWord.equals("요령에")||
	        							sTWord.equals("규정은")||sTWord.equals("규정의")||MakeHan.isContains(sTWord, "규정집")||sTWord.equals("규정에서")||sTWord.equals("규정으로")||
	        							sTWord.equals("규정과")||sTWord.equals("규정,")||sTWord.equals("규정이나")||sTWord.equals("요령으로")||sTWord.equals("규정상·제도상·행정상")||sTWord.equals("규정도")||sTWord.equals("규정되어")||
	        							MakeHan.isContains(sTWord, "규정관리")||MakeHan.isContains(sTWord, "규정입안")||MakeHan.isContains(sTWord, "규정안")||sTWord.equals("규정에도")||
	        							sTWord.equals("규정이")||MakeHan.isContains(sTWord, "규정함")||MakeHan.isContains(sTWord, "규정한다.")||MakeHan.isContains(sTWord, "법률상")||MakeHan.isContains(sTWord, "법령상")||MakeHan.isContains(sTWord, "법령을")||
	        							MakeHan.isContains(sTWord, "법률전문가")||MakeHan.isContains(sTWord, "법리적")||MakeHan.isContains(sTWord, "법령에")||MakeHan.isContains(sTWord, "법제업무")
	        					) continue;  
	        					if(sTWord.indexOf("기준")==0)continue;
	        					//	if(sTWord.indexOf("규칙")<0||sTWord.indexOf("지침")<0||
	        					//     		sTWord.indexOf("요령")<0||sTWord.indexOf("세칙")<0||sTWord.indexOf("규정")<0||
	        					//     		sTWord.indexOf("정관")<0||sTWord.indexOf("영")<0||sTWord.indexOf("시행령")<0||
	        					//     		sTWord.indexOf("강령")<0||sTWord.indexOf("법")<0||
	        					//     		sTWord.indexOf("예금")<0)continue;
	        					System.out.println("sTWord2"+sTWord+"/"+lawKind[i][0]+"/"+sTWord.indexOf(lawKind[i][0]));                   	 
	        					int nLoc = sTWord.indexOf(lawKind[i][0]);
	        					nLawLocation = nLoc;
	        					while (nLoc > -1){
	        						if (sTWord.length() == 1) { nLoc = -1; break; }
	        						if (bGathering)
	        						{
	        							if (sTWord.indexOf("」")>0) { nLoc = -1; break; }//sTWord.substring(nLawLocation + lawKind[i][0].length(), 1).equals("」")
	        						}
	        						nLawLocation = nLoc;
	        						nLoc = sTWord.indexOf(lawKind[i][0], nLoc + 1);
	        					}
	        					
	        					System.out.println("sTWord1===>"+sTWord);
	        					if (nLawLocation > -1 && sTWord.substring(nLawLocation, nLawLocation+lawKind[i][0].length()).equals(lawKind[i][0]))
	        					{
	        						System.out.println("nLawLocation==>"+nLawLocation);
	        						System.out.println("sTWord2===>"+sTWord);
		        					System.out.println("hkk1==>"+sTWord.substring(nLawLocation, nLawLocation+lawKind[i][0].length()));
		        					System.out.println("sTWord3===>"+sTWord);
		        					System.out.println("hkk2==>"+lawKind[i][0]);
	        						if (bGathering) // "「""」"표시가 붙은 법령일경우
	        						{
	        							sTitle = GetBetweenString(sTWord, sTWord.indexOf("「", 0), sTWord.indexOf("」", 0)).replaceAll("<cont>","").replaceAll("\"","").replaceAll("\\d.","");
	        							
	        							if (sTWord.indexOf("」")<0)//!sTWord.substring(nLawLocation + lawKind[i][0].length(), 1).equals("」")
	        							{
	        								break;
	        							}
	        						}
	        						else
	        						{
	        							System.out.println("sTWord4===>"+sTWord);
	        							if(MakeHan.isContains(sTWord, "(법")||MakeHan.isContains(sTWord, ",법")){
	        								sTitle = sTWord.substring(nLawLocation, nLawLocation + lawKind[i][0].length()).replaceAll("<cont>","").replaceAll("\"","").replaceAll("\\d.","");
	        							}else{
	        								System.out.println("hkk3==>"+nLawLocation);
	        								System.out.println("hkk4==>"+sTWord);
	        								if(sTWord.indexOf("“규정")>-1) {
	        									System.out.println("1");
	        									sTitle = sTWord.substring(nLawLocation, nLawLocation + lawKind[i][0].length()).replaceAll("<cont>","").replaceAll("\"","").replaceAll("\\d.","");
	        								}else if(sTWord.indexOf("“법")>-1) {
	        									System.out.println("3");
	        									sTitle = sTWord.substring(nLawLocation, nLawLocation + lawKind[i][0].length()).replaceAll("<cont>","").replaceAll("“","").replaceAll("\\d.","");
	        								}else {
	        									System.out.println("2");
	        									sTitle = sTWord.substring(0, nLawLocation + lawKind[i][0].length()).replaceAll("<cont>","").replaceAll("\"","").replaceAll("\\d.","");
	        								}
	        								
	        								System.out.println("hkk5==>"+sTitle);
	        							}
	        							
	        						}
	        						
	        						bGathering = false;
	        						nGateringCnt = 0;
	        						
	        						if(backWord.equals("관한")&&sTitle.equals("규정"))continue;
	        						if(Obookid.equals("10018539")&&sTitle.equals("규정"))continue;	//규정등의 입안관리기준에서 규정을 링크시키지 않는다.
	        						
	        						System.out.println("topLawReplace==>"+topLawReplace);
	        						System.out.println("topLawBon==>"+topLawBon);
	        						System.out.println("topLink==>"+topLink);
	        						System.out.println("topReplace==>"+topReplace);
	        						System.out.println("sTitle==>"+sTitle);
	        						System.out.println("sTitle==>"+topReplace.get(sTitle));
	        						if(topReplace.get(sTitle)!=null && (sTitle.indexOf("법")>-1||sTitle.indexOf("조례")>-1)){	//최상단에서 정한 규정,법과 동일한것
	        							String dumy = topReplace.get(sTitle)==null?"":topReplace.get(sTitle).toString();
	        							sLink = GetLink(bookid,dumy, sTitle, "1");
	        							System.out.println("sLink===>"+sLink);
	        							lawKind[i][1] = dumy;
	        							sBeforeLaw = dumy;
	        							break;
	        						}else{
	        							System.out.println("여기까지 오나?");
		        						System.out.println("여기까지 오나?"+lawKind[i][0]);
		        						System.out.println("여기까지 오나?"+sTitle);
		        						System.out.println("여기까지 오나?"+backWordLink);
		        						System.out.println("여기까지 오나?"+sBeforeLaw);
		        						
	        							if(sTitle.equals("시행령") || sTitle.indexOf("시행령")>-1 || sTitle.equals("시행규칙") || sTitle.equals("영")){
	        								System.out.println("hkk5==>법시행령 시작!!");
	        								if(sTitle.equals("법시행령")) {
	        									//sLaw = lawKind[FindLawkind("법", lawKind)][1]+sTitle.replace("법", "");
	        									sLaw = topReplace.get("법")+sTitle.replace("법", "");
	        								}else {
	        									sLaw = lawKind[FindLawkind("법", lawKind)][1]+sTitle;
	        								}
	        								
	        								if(sTitle.equals("영")) {
	        									//sLaw = lawKind[FindLawkind("법", lawKind)][1]+sTitle.replace("법", "");
	        									System.out.println("영일때");
	        									System.out.println(topReplace);
	        									
	        									System.out.println(sBeforeLaw);
	        									if(topReplace.get("영")==null) {
	        										sLaw = topReplace.get("법")+"시행령";
	        										sBeforeLaw = sLaw;
	        										topReplace.put(sTitle, sLaw);
	        										System.out.println(topReplace);
	        									}else {
	        										sLaw = topReplace.get("영")==null?"":topReplace.get("영").toString();
	        									}
	        									System.out.println(sLaw);
	        								}
	        								
	        								System.out.println("hkk5==>"+sLaw);
	        								
	        								sLink = GetLink(bookid,sLaw, sTitle, "1");
	        								sBeforeLaw = sLaw;
	        								if(sTitle.equals("시행령") || sTitle.equals("영")){
	        									lawKind[7][1]=sLaw;
	        									lawKind[8][1]=sLaw;
	        								}
	        								break;
	        							}else{
	        								if(sTitle.equals("규정")){
	        									String dumy = topReplace.get(sTitle)==null?"":topReplace.get(sTitle).toString();
	        									System.out.println("dumy===>"+dumy+":::"+sTitle);
	        									sLink = GetLink(bookid,dumy, sTitle, "1");
	        								}else{
	        									sLink = GetLink(bookid,sTitle, sTitle, "1");
	        								}
	        								
	        							}
	        							//        	 	}
	        						}
	        						if (MakeHan.isContains(sLink, "lawid"))
	        						{
	        							if(!sTitle.equals("관공서의 공휴일에 관한 규정")){	//법이 규정으로 정해지는 경우를 막는다.
	        								lawKind[i][1] = sTitle;
	        								if(i==FindLawkind("법", lawKind)||i==FindLawkind("법률", lawKind)){
	        									lawKind[FindLawkind("법률", lawKind)][1] = sTitle;
	        									lawKind[FindLawkind("법", lawKind)][1] = sTitle;
	        								}
	        							}
	        							sBeforeLaw = sTitle;
	        							break;
	        						}
	        						sTitle = sTitle.replaceAll("이하", "").replaceAll("\"", "").replaceAll("이라", "").replaceAll("<cont>","").replaceAll("\"","").replaceAll("\\d.","");
	        						
	        						if (sTitle.equals(lawKind[i][0]))
	        						{
	        							if (lawKind[i][1].equals(""))
	        							{
	        								if (sTitle.equals("시행령") || sTitle.equals("시행규칙"))
	        								{
	        									sLaw = lawKind[FindLawkind("법", lawKind)][1]+sTitle;
	        									lawKind[i][1] = sLaw;
	        									if (sTitle.equals("시행령")){
	        										sLaw = lawKind[FindLawkind("영", lawKind)][1];
	        									}
	        								}
	        							}
	        							else
	        							{
	        								sLaw = lawKind[i][1];
	        							}
	        							
	        							if(Obookid.equals("10018539")&&sTitle.equals("규정"))continue;	//규정등의 입안관리기준에서 규정을 링크시키지 않는다.
	        							
	        							if(!sTitle.equals("규정")) {
	        								sLink = GetLink(bookid,sLaw, sTitle, "1");
	        							}
	        							if (MakeHan.isContains(sLink, "lawid"))
	        							{
	        								sBeforeLaw = sLaw;
	        								break;
	        							}
	        						}
	        						
	        						sTitle = sTWord.replaceAll("<cont>","").replaceAll("\"","").replaceAll("\\d.","");
	        						
	        						if (sTWord.equals("동" + lawKind[i][0]))
	        						{
	        							sLink = GetLink(bookid,sBeforeLaw, sTitle, "1");
	        							lawKind[i][1] = sBeforeLaw;
	        							break;
	        						}
	        					}
	        					
	        				}
	        			
	        		}
	        		System.out.println("sTWord===>"+sTWord);
	        		System.out.println("sWord===>"+sWord);
	        		System.out.println("sLink===>"+sLink);
	        		System.out.println("sLink2===>"+sLink2);
	        		if (!sWord.equals("") && !sLink.equals("")){
	        			sTWord = sTWord.replaceAll(sTitle, sLink);
	        		}
	        		System.out.println("sTWord2===>"+sTWord);
	        		if (!sWord.equals("") && !sLink2.equals("")){
	        			sTWord = sTWord.replaceAll(sTitle2, sLink2);
	        		}
	        		System.out.println("sTWord3===>"+sTWord);
	        		backWordLink = sLink;
	        		backWord = sWord.replaceAll("<cont>","").replaceAll("\"","").replaceAll("\\d.","");
	        		System.out.println("sLinkedCont==>"+sLinkedCont);
	        		sLinkedCont += sTWord + " ";
	        		System.out.println("sLinkedCont2==>"+sLinkedCont);
	        		sNewBody += sTWord + " ";
	        	} 
	        	System.out.println("여기입니다.........");
	        	System.out.println("sLinkedCont : "+sLinkedCont);
	        	
	        	org.w3c.dom.Element ss = (org.w3c.dom.Element)nodes.item(j);
	        	String tag = ss.getAttribute("tag")==null?"":ss.getAttribute("tag");
	        	String showtag = ss.getAttribute("showtag")==null?"":ss.getAttribute("showtag");
	        	
	        	org.w3c.dom.Element set = doc.createElement("cont");
	        	if(!tag.equals("")){
	        		set.setAttribute("tag", tag);
	        	}
	        	if(!showtag.equals("")){
	        		set.setAttribute("showtag", showtag);
	        	}
	        	set.setTextContent(sLinkedCont);

	        	if(tableYn){
	        		for(int kk=0; kk<tableTxt.size(); kk++){
		        		CDATASection cdataNode = doc.createCDATASection(tableTxt.get(kk).toString());
		        		org.w3c.dom.Element table = doc.createElement("table");
		        		table.appendChild(cdataNode);
		        		set.appendChild(table);
	        		}
	    		}
	        	nodes.item(j).getParentNode().replaceChild(set, nodes.item(j));
	        } 
	        
	        TransformerFactory factory1 = TransformerFactory.newInstance();
			StringWriter sw = new StringWriter();
			Properties output = new Properties();
			output.setProperty(OutputKeys.ENCODING, "EUC-KR");   
			output.setProperty(OutputKeys.INDENT, "yes");
			Transformer transformer = factory1.newTransformer();
			transformer.setOutputProperties(output);
			transformer.transform(new DOMSource(doc), new StreamResult(sw));
	        Msg = sw.toString().replaceAll("&lt;a5b5/&gt;", "<a5b5 />")
	        				.replaceAll("&lt;law", "<law").replaceAll("&lt;bylaw", "<bylaw")
	        				.replaceAll("\"&gt;", "\">").replaceAll("&lt;/law&gt;", "</law>")
	        				.replaceAll("&lt;/bylaw&gt;", "</bylaw>").replaceAll("&lt;image", "<image")
	        				.replaceAll("baseline\" /&gt;", "baseline\" />").replaceAll("/&gt;", "/>"); 
			}catch(Exception e){
				System.out.println("%%%%%%%%%에러발생경보에러발생경보에러발생경보에러발생경보에러발생경보"+e);
				Msg = Xmldata;
			}
			
			return Msg;
		}
   
    public void setXmlschBonSetting() {
    	List xl = commonDao.selectList("bylawSql.setXmlschBonSetting");
    	for(int i=0; i<xl.size(); i++) {
    		HashMap result = (HashMap)xl.get(i);
    		String bookid = result.get("BOOKID")==null?"":result.get("BOOKID").toString();
    		this.setXmlSchBon(bookid);
    	}
    }
    
	public void setXmlSchBon(String bookid) {
		HashMap result = commonDao.select("bylawSql.getSelectBons", bookid);
		this.setXmlSchBon(result);
		//this.byulListInosert(result); //임시 일괄 데이터 구축시에만 풀고 데이터 구축
	}
	
	public String setXmlSchBon(HashMap param) {
		String XMLDATA = param.get("XMLDATA")==null?"":param.get("XMLDATA").toString();
		String revcha = param.get("REVCHA")==null?"":param.get("REVCHA").toString();
		
		String linkGbn = "//jo[@startcha <= '"+revcha+"' and @endcha>='"+revcha+"']//cont";
		String s = "";
		int kk = 0;
		if(XMLDATA != null){
			try {
				ByteArrayInputStream is = new ByteArrayInputStream(XMLDATA.getBytes("euc-kr"));
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				factory.setNamespaceAware(true); // never forget this!
				DocumentBuilder builder = factory.newDocumentBuilder();
				org.w3c.dom.Document doc = builder.parse(is);//(new StringReader(bylaw.getXmldata()));
				XPathFactory factory2 = XPathFactory.newInstance();
				XPath xpath = factory2.newXPath();
				XPathExpression expr = xpath.compile(linkGbn);
				Object result = expr.evaluate(doc, XPathConstants.NODESET);
				NodeList nodes = (NodeList) result;
				
				for(int j=0; j<nodes.getLength(); j++){
					s = s + nodes.item(j).getTextContent();
				}
			} catch (Exception e) {
				System.out.println("%%%%%%%%" + e);
			}
			param.put("s", s);
			kk = kk + commonDao.update("bylawSql.setXmlSchBon",param);
		}

		String re = kk + "건 업데이트 완료";
		System.out.println(re);
		return re;
	}
	
	public JSONArray getAllDownJson(Map mtenMap) {
		List al = commonDao.selectList("bylawSql.getAllDownJson", mtenMap);
		for(int i=0; i<al.size(); i++) {
			HashMap result = (HashMap)al.get(i);
			String catcd = result.get("catcd")==null?"":result.get("catcd").toString();
			if(catcd.equals("folder")) {
				result.put("leaf", false);
			}else {
				result.put("leaf", true);
			}
		}
		JSONArray jl = new JSONArray();
		jl = JSONArray.fromObject(al);
		return jl;
	}
	
	public JSONObject setAllDown(Map<String, Object> mtenMap) {
		commonDao.insert("bylawSql.setAllDown",mtenMap);
		JSONObject jo = new JSONObject();
		jo.put("id", mtenMap.get("did"));
		return jo;
	}
	
	public List makeExcel(Map mtenMap) {
		List list = commonDao.selectList("bylawSql.makeExcel", mtenMap);
		return list;
	}
	
	public Map noFormInsert(Map<String, Object> mtenMap) {
		String state = mtenMap.get("state")==null?"":mtenMap.get("state").toString();
		String pstate = mtenMap.get("pstate")==null?"":mtenMap.get("pstate").toString();
		if(state.equals("noForm")) {
			if(!pstate.equals("U")){
				mtenMap.put("STATECD", "5000");
				mtenMap.put("useyn", "Y");
				mtenMap.put("delyn", "N");
			}
			
			String mord = "";
			if(pstate.equals("I")) {	//제정
				mord = commonDao.select("bylawSql.getMaxOrd",mtenMap);
				mtenMap.put("ord", mord);
			}else if(pstate.equals("OLDADD")) {	//연혁 등록
				mtenMap.put("STATECD", "7000");
			}else if(pstate.equals("U")){	//문서정보 수정
				
			}else if(pstate.equals("RE")){	//개정등록
				mtenMap.put("STATECD", "7000");
				commonDao.update("updateStep", mtenMap);
				mtenMap.put("STATECD", "5000");
			}else if(pstate.equals("P")){	//폐지
				mtenMap.put("STATECD", "7000");
				commonDao.update("updateStep", mtenMap);
				mtenMap.put("STATECD", "6000");
			}
			
			if(pstate.equals("I") || pstate.equals("OLDADD") || pstate.equals("RE") || pstate.equals("P")) {	//제정
				//tb_lm_rulecat insert
				commonDao.insert("bylawSql.addDoc",mtenMap);
				//tb_lm_rulehistory insert
				mtenMap = this.keyChangeUpperMap(mtenMap);
				commonDao.insert("bylawSql.lawbookInsert",mtenMap);
				commonDao.insert("bylawSql.getTB_LM_STATEHISTORYInsert", mtenMap);
				commonDao.insert("bylawSql.lawfileInsert", mtenMap);
				
			}else if(pstate.equals("U")){	//문서정보 수정
				mtenMap = this.keyChangeUpperMap(mtenMap);
				commonDao.update("bylawSql.lawBookUpdate",mtenMap);
				commonDao.update("bylawSql.lawCatTitle",mtenMap);
				if(mtenMap.get("FILEID")!=null && !mtenMap.get("FILEID").toString().equals("")) {
					String fileid = commonDao.selectOne("bylawSql.getFileid", mtenMap);
					//기존파일삭제
					commonDao.delete("bylawSql.delFile",fileid);
					commonDao.insert("bylawSql.lawfileInsert", mtenMap);
				}
			}
		}
		
		
		return mtenMap;
	}
	
	public static HashMap keyChangeUpperMap(Map param) {
		Iterator<String> iteratorKey = param.keySet().iterator(); // 키값 오름차순
		HashMap newMap = new HashMap();
		// //키값 내림차순 정렬
		while (iteratorKey.hasNext()) {
			String key = iteratorKey.next();
			if(!(key.equals("writerid")||key.equals("writer")||key.equals("deptid")||key.equals("deptname")||key.equals("grpcd"))) {
				newMap.put(key.toUpperCase(), param.get(key));
			}
		}
		return newMap;

	}
	
	public Map noFormView(Map<String, Object> mtenMap) {
		String Bookid = mtenMap.get("BOOKID")==null?"":mtenMap.get("BOOKID").toString();
		HashMap resultMap = new HashMap();
		List flist = commonDao.selectList("bylawSql.lawfileSelect", mtenMap);
		String ftext = "";
		
		if(flist.size()==0){
			ftext = "전문,개정문,신구조문이 등록되지 않았습니다.";
		}else{
			for(int i=0; i<flist.size(); i++){
				HashMap fMap = (HashMap)flist.get(i);
				String Pcfilename = fMap.get("PCFILENAME")==null?"":fMap.get("PCFILENAME").toString();
				String Serverfile = fMap.get("SERVERFILE")==null?"":fMap.get("SERVERFILE").toString();
				String filetype = fMap.get("FILETYPE")==null?"":fMap.get("FILETYPE").toString();
				String filecd = fMap.get("FILECD")==null?"":fMap.get("FILECD").toString();
				String fn = "javascript:downpage('"+Pcfilename+"','"+Serverfile+"','ATTACH');";
				String img = "";
				if(filetype.equals("txt")){
					img = "txt2.gif";
				}else if(filetype.equals("hwp")){
					img = "han_down.gif";
				}else if(filetype.equals("pdf")){
					img = "pdf.gif";
				}else if(filetype.equals("doc")||filetype.equals("docx")){
					img = "doc.gif";
				}else if(filetype.equals("xls")||filetype.equals("xlsx")){
					img = "xls.gif";
				}else if(filetype.equals("ppt")||filetype.equals("pptx")){
					img = "ppt.gif";
				}else if(filetype.equals("gif")){
					img = "img.gif";
				}
				
				ftext = ftext + "["+filecd+"]&nbsp;"; 
						
				ftext = ftext + "<span onclick=\""+fn+"\" style='cursor:pointer'>";
				ftext = ftext + Pcfilename;
				ftext = ftext + "</span>";
				ftext = ftext + "<span onclick=\""+fn+"\" style='cursor:pointer'>";
				ftext = ftext + "<img src=\"../../resources/images/file/"+img+"\" align=\"absmiddle\" alt=\""+Pcfilename+"\">";
				ftext = ftext + "</span>";
				ftext = ftext + "<span onclick=\"javascript:fileView('"+Serverfile+"');\" style='cursor:pointer'>";
				ftext = ftext + "<img src=\"../../resources/images/file/han_view.gif\" align=\"absmiddle\" alt=\""+Pcfilename+"\"><br/>";
				ftext = ftext + "</span>";
				
				if(filecd.equals("전문")) {
					resultMap.put("fileName", Serverfile);
				}
			}
		}
		
		resultMap.put("flist", ftext);
		List hlist = commonDao.selectList("bylawSql.getHistory", Bookid);
		JSONArray jhjson = JSONArray.fromObject(hlist);
		resultMap.put("history", jhjson);
		
		return resultMap;
	}
	
	public List getAttList(HashMap para) {
		List alist = commonDao.selectList("bylawSql.getAttList", para);
		return alist;
	}
	
	public List getSIMlist(String Bookid) {
		List alist = commonDao.selectList("bylawSql.getSIMlist", Bookid);
		return alist;
	}
	
	public Map DocRevision(Map<String, Object> mtenMap) {
		HashMap rulecat = new HashMap();
		rulecat.put("pcatid", mtenMap.get("PCATID"));
		rulecat.put("ord", mtenMap.get("ORD"));
		rulecat.put("title", mtenMap.get("TITLE"));
		rulecat.put("useyn", "Y");
		commonDao.insert("bylawSql.addDoc",rulecat);
		mtenMap.put("CATID", rulecat.get("catid"));
		System.out.println(mtenMap);
		String bookid = mtenMap.get("BOOKID")==null?"":mtenMap.get("BOOKID").toString();
		commonDao.insert("bylawSql.lawbookInsert",mtenMap);
		String obookid = mtenMap.get("OBOOKID")==null?"":mtenMap.get("OBOOKID").toString();
		
		HashMap XMLDATA = commonDao.select("bylawSql.getSelectXMLDATA", mtenMap);
		String xml[] = {XMLDATA.get("XMLDATA")==null?"":XMLDATA.get("XMLDATA").toString(),XMLDATA.get("XMLOLDNEWREVISION")==null?"":XMLDATA.get("XMLOLDNEWREVISION").toString()};
		for(int i=0; i<xml.length; i++){
			if(!xml[i].equals("")) {
				try {
					DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
					DocumentBuilder builder = factory.newDocumentBuilder();
					org.w3c.dom.Document doc = builder.newDocument();
					ByteArrayInputStream is = new ByteArrayInputStream(xml[i].getBytes("euc-kr"));
					
					doc = builder.parse(is);
					String linkGbn = "law/history";
					XPathFactory factory2 = XPathFactory.newInstance();
					XPath xpath = factory2.newXPath();
					XPathExpression expr = xpath.compile(linkGbn);
					Object result = expr.evaluate(doc, XPathConstants.NODE);
					Node node = (Node) result;
					org.w3c.dom.Element set = (org.w3c.dom.Element) node;
					org.w3c.dom.Element root = (org.w3c.dom.Element) set.getParentNode();
					
					org.w3c.dom.Element history = this.getBookHistoryXml(doc, obookid);
					root.replaceChild(history, set);
					expr = xpath.compile("/law");
					result = expr.evaluate(doc, XPathConstants.NODE);
					node = (Node) result;
					set = (org.w3c.dom.Element) node;
					
					set.setAttribute("title", mtenMap.get("TITLE")==null?"":mtenMap.get("TITLE").toString());
					set.setAttribute("revcha", mtenMap.get("REVCHA")==null?"":mtenMap.get("REVCHA").toString());
					
					StringWriter sw = new StringWriter();
					TransformerFactory factory1 = TransformerFactory.newInstance();
					Properties output = new Properties();
					output.setProperty(OutputKeys.ENCODING, "EUC-KR");
					output.setProperty(OutputKeys.INDENT, "yes");
					Transformer transformer = factory1.newTransformer();
					transformer.setOutputProperties(output);
					transformer.transform(new DOMSource(doc), new StreamResult(sw));
					
					if(i==0){
						mtenMap.put("XMLDATA", sw.toString());
						String XMLDATATMP = sw.toString().replaceAll("<a5b5 />", "&lt;a5b5 /&gt;").replaceAll("<image", "&lt;image").replaceAll("baseline\" />","baseline\" /&gt;");
						mtenMap.put("XMLDATALINK", linkAndXml(XMLDATATMP,mtenMap));
					}else{
						mtenMap.put("XMLOLDNEWREVISION", sw.toString());
					}
				}catch(Exception e) {
					System.out.println(e);
				}
			}
		}
		commonDao.insert("bylawSql.getTB_LM_STATEHISTORYInsert", mtenMap);
		return mtenMap;
	}
	
	public Map allDocRevision(Map<String, Object> mtenMap) {
		String Oldbookid = mtenMap.get("BOOKID")==null?"":mtenMap.get("BOOKID").toString();
		String bontext = mtenMap.get("bonhtml")==null?"":mtenMap.get("bonhtml").toString();
		mtenMap.put("XMLSCHTXT", mtenMap.get("bontxt"));
		if(bontext.equals("")) {
			mtenMap.put("msg", "본문생성 실패!! 데이터추출 실패!");
		}else {
			HashMap tableH =  this.getTable(bontext);
			bontext = this.replace_html(bontext).replaceAll("&lt;", "<").replaceAll("&gt;", ">");
			
			boolean bStart = false; // 변환시작되면 true
			boolean bu = false; // 부칙 변환 시작되면 true
			int nOrd = 0;
			int nContid = 0;
			int nPcontid = 0;
			int nIdx = 0;
			int[] nArrContId = new int[6]; // 0=nBodyid,nBuchickid저장 나머지는 편장절관조의
											// contid를 저장하귀위한 숫자형 배열
			int[] nArrOrd = { 0, 0, 0, 0, 0, 0, 0 }; // ord를 저장하기 위한 숫자형 배열
			
			String sContType = " 편장절관조"; //
			String sContno = "";
			String sBContno = ""; // 내용의 바로이전 조번호 저장 (내용에 조번호를 붙여주기 위해서)
			String sLine = "";
			String sLineSum = "";
			String sTitle = "";
			String sSub = "";
			String sSubno = "";
			String sContentsJo = "";
			String sContcd = "";

			String sPattern1 = "^제[\\d]{1,}[편장절관조]";
			String sPattern2 = "^부칙";

			Pattern pattern = Pattern.compile(sPattern1);
			Pattern pattern2 = Pattern.compile(sPattern2);

			String _nBodyid = "0";
			String _nBuchikid = "0";
			String _nByeolid = "0";
			
			String bontxt2[] = bontext.split("\\n");
			
			_nBodyid = commonDao.select("commonSql.getSeq");
			_nBuchikid = commonDao.select("commonSql.getSeq");
			_nByeolid = commonDao.select("commonSql.getSeq");
			
				//TB_LM_RULECAT
				HashMap rulecat = new HashMap();
				rulecat.put("pcatid", mtenMap.get("PCATID"));
				rulecat.put("ord", mtenMap.get("ORD"));
				rulecat.put("title", mtenMap.get("TITLE"));
				rulecat.put("useyn", "Y");
				commonDao.insert("bylawSql.addDoc",rulecat);
				mtenMap.put("CATID", rulecat.get("catid"));
				System.out.println(mtenMap);
				commonDao.insert("bylawSql.lawbookInsert",mtenMap);
				String bookid = mtenMap.get("BOOKID")==null?"":mtenMap.get("BOOKID").toString();
				String obookid = mtenMap.get("OBOOKID")==null?"":mtenMap.get("OBOOKID").toString();
			try {	
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				DocumentBuilder builder = factory.newDocumentBuilder();
				org.w3c.dom.Document doc = builder.newDocument();
				org.w3c.dom.Element law = doc.createElement("law");
				org.w3c.dom.Element preBon = null;
				org.w3c.dom.Element preJo = null;
				org.w3c.dom.Element sbon = null;
				doc.appendChild(law);
				
				org.w3c.dom.Element history = this.getBookHistoryXml(doc, obookid);
				law.appendChild(history);
				
				// 루트 속성
				law.setAttribute("title", mtenMap.get("TITLE").toString());
				law.setAttribute("revcha", mtenMap.get("REVCHA").toString());
				org.w3c.dom.Element bon = this.bbbElement("bon", doc, _nBodyid); // 본문
				law.appendChild(bon); // 본문 태그

				org.w3c.dom.Element byullist = null; // 별표리스트

				nArrContId[0] = Integer.parseInt(_nBodyid);

				Matcher matcher1 = null;
				Matcher matcher2 = null;
				
				for (int k = 0; k < bontxt2.length; k++) {
					if(bontxt2[k].length()==0){
						continue;
					}
					String sWord = "";
					sWord = bontxt2[k];
					sLine = sWord;
					matcher1 = pattern.matcher(sLine.replaceAll(" ", ""));
					matcher2 = pattern2.matcher(sLine.replaceAll(" ", ""));
					if (matcher1.find() || matcher2.find()) {
						String sValue = "";
						try {// 미스 매치시 오류 발생하므로 빈값을 던져 준다.
							sValue = matcher1.group(); // 제1장
						} catch (Exception e) {
							sValue = "";
						}

						bStart = true;
						nContid = 0;
						if (sValue.length() <= 0) {
							sValue = matcher2.group();
						}

						sContcd = sValue.substring(sValue.length() - 1, sValue
								.length());

						nIdx = sContType.indexOf(sContcd);
						if (nIdx < 0) {
							nIdx = 0;
						}
						sContentsJo = sLine;
						// 내용저장
						// ===================================================================================
						if (sLineSum.replaceAll(" ", "").trim().length() > 0) {
							for (int i = 5; i >= 0; i--) {
								if (nArrContId[i] > 0) {
									nPcontid = nArrContId[i];
									nOrd = 1;
									break;
								}
							}

							String sTagedText = "<lawsub>"+ this.makeTag4Text(sLineSum, 0)+"</lawsub>";
							//sTagedText = sTagedText.replaceAll("테이블자리위치", tableH.get(sContno)==null?"":tableH.get(sContno).toString());
							String tablePattern = "테이블자리위치\\d";
							Pattern tpattern = Pattern.compile(tablePattern);
							Matcher tmatch = tpattern.matcher(sTagedText);
							while (tmatch.find()) {
								sTagedText = sTagedText.replace(tmatch.group(), tableH.get(tmatch.group())==null?"":tableH.get(tmatch.group()).toString());
							}
							org.w3c.dom.Element secondRoot = builder.parse(new org.xml.sax.InputSource(new StringReader(sTagedText))).getDocumentElement();
							org.w3c.dom.Node tempNode = doc.importNode(secondRoot,true); // true if you want a deep copy
							preJo.appendChild(tempNode);

							sLineSum = "";
						}
						
						// 제1조(목적) 이 세칙은....
						// svalue="제1조" sTitle = "목적"
						if (sContcd.equals("편") || sContcd.equals("장")	|| sContcd.equals("절") || sContcd.equals("관") || sContcd.equals("조")) {
							// 조일 경우 () 있음
							if (sLine.indexOf("(") > 0 || sContcd.equals("조")) {
								if (sLine.indexOf("(") > 0) {
									sContentsJo = sLine.substring(0, sLine.indexOf(")") + 1);
									sContno = this.selectInt(sValue).trim();
									sSub = sLine.substring(0, sLine.indexOf("("));
								}
								sTitle = this.JoTitle(sLine);
							} else {
								// 편장절관 일경우 () 없음
								if (this.isContains(sLine.trim(), "장의")) {
									sTitle = sLine.substring(sLine.indexOf(sContcd) + 3).trim();
								} else {
									sTitle = sLine.substring(sLine.indexOf(sContcd) + 1).trim(); // sLine// 제1장// 총칙
								}
								sContno = this.selectInt(sValue);
							}
							// 부속번호가 있을경우
							if (this.isContains(sSub.replaceAll(" ", "").trim(),"조의")) {
								sSubno = this.Josubno(sSub);
							} else {
								sSubno = "0";
							}
							String tagName = "";
							if (sContcd.equals("편")) {
								tagName = "pyun";
							} else if (sContcd.equals("장")) {
								tagName = "jang";
							} else if (sContcd.equals("절")) {
								tagName = "jeol";
							} else if (sContcd.equals("관")) {
								tagName = "gwan";
							} else if (sContcd.equals("조")) {
								tagName = "jo";
							} else if (sContcd.equals("부칙")) {
								tagName = "buchick";
							}

							HashMap para = new HashMap();
							para.put("contno", sContno);
							para.put("contsubno", sSubno);
							para.put("title", sTitle);
							para.put("startdt", mtenMap.get("STARTDT").toString());
							para.put("enddt", "9998-12-31");
							para.put("startcha", mtenMap.get("REVCHA").toString());
							para.put("contid", commonDao.select("commonSql.getSeq"));
							sbon = this.createElement(tagName, doc, para);
							
							if (sContcd.equals("편")) {
								law.getLastChild().appendChild(sbon);
							} else if (sContcd.equals("장") || sContcd.equals("절") || sContcd.equals("관") || sContcd.equals("조")) {
								if (bon.getLastChild() == null || bon.getLastChild().getNodeName().equals(tagName)) {
									law.getLastChild().appendChild(sbon);
								} else {
									if (preBon != null && preBon.getNodeName().equals(tagName)) {
										bon.getLastChild().appendChild(sbon);
									} else {
										if(preBon == null){
											bon.appendChild(sbon);
										}else{
											preBon.appendChild(sbon);
										}
									}
								}
							} else if (sContcd.equals("부칙")) {
								law.getLastChild().appendChild(sbon);
							}
							if (!sContcd.equals("조")) {
								preBon = sbon;
							} else {
								preJo = sbon;
							}
						}
						
						if (sValue.replaceAll(" ", "").equals("부칙")) {
							if (!bu) {
								bon = bbbElement("buchicklist", doc, _nBuchikid); // 부칙
								law.appendChild(bon); // 본문 태그
							}
							nIdx = 4; // 부칙다음에는 편이 안나오므로 부칙은 4로 조정
							sTitle = sLine;
							sContcd = "부칙";
							for (int i = 0; i < 6; i++) {
								nArrContId[i] = 0;
								nArrOrd[i] = 0;
							}
							nArrContId[0] = Integer.parseInt(_nBuchikid); // 부칙아이디;

							HashMap para = new HashMap();
							para.put("contno", "0");
							para.put("contsubno", "0");
							para.put("title", sTitle);
							para.put("startdt", mtenMap.get("STARTDT").toString());
							para.put("enddt", "9998-12-31");
							para.put("startcha", mtenMap.get("REVCHA").toString());
							para.put("contid", commonDao.select("commonSql.getSeq"));

							sbon = this.createElement("buchick", doc, para);
							bon.appendChild(sbon);
							preBon = sbon;
							preJo = sbon;
							bu = true;

						}
						// 부모 contid 와 자기자신의 순서를 구하고
						// 자기자신레벨의 contid 와 ord값을 정한다.

						// 상위 contid 구하기" (편1) (장2) (절3) (관4) (조5)"
						// 현재 conttype 보다 상위인 contid 가 pcontid 가 된다.
						nPcontid = 0;
						for (int i = nIdx - 1; i >= 0; i--) {
							if (nArrContId[i] != 0) {
								nPcontid = nArrContId[i];
								break;
							}
						}
						// ord 는 자기 conttype 의 ord
						nOrd = nArrOrd[nIdx];

						// pcontid 와 ord를 구했으므로 자기와 동급의 contid = 0으로 하고 자기하위의 ord=0
						// 도 0으로 한다.
						// 예를 들면 현재읽은 sLine (관4) 이면 관이하인 (관4)(조5)의 contid =0 으로 하고
						// (조5)의 순서도 0으로 초기화한다.
						for (int i = nIdx; i <= 5; i++) {
							nArrContId[i] = 0; // 자기포함 하위 구조의 contid =0
							nArrOrd[i + 1] = 0; // 자기하위의 구조의 순서를 =0 ,자기순서는 누적해야함
						}
						//                    
						// 편장절관조부칙인경우 타이틀을 저장한다.
						// String sTagedJo = bylawDao.makeTag4JoByul(sContcd,
						// sContno, sSubno, sTitle, revcha,
						// bylaw.getStartdt(), "9999", bylaw.getEnddt(),"");

						// 새로운 contid를 구해서 배열에 넣어주고 자기와 동급인 contcd의 ord는 +1을 한다.
						// nContid =
						// lawcontInsert(Integer.toString(nPcontid),"",Bookid,sContcd,sContno,sSubno,sTitle,bylaw.getPromuldt(),bylaw.getStartdt(),
						// bylaw.getEnddt(),bylaw.getUpdt(),Integer.toString(nOrd),"0","9999","N",sTitle,sTagedJo,"");

						nArrContId[nIdx] = nContid;
						nArrOrd[nIdx]++;
						//
						//                    
						//
						if (sContcd.equals("조")) { // 제1조(목적) 이하의 내용을 sLineSum 에
													// 누적저장한다.
							sLineSum = sLine.substring(sLine.indexOf(")") + 1)
									+ "\n";
							sBContno = sContno; // 내용에 조의 contno를 넣어주기 위해
						}
					}else {
						if (bStart) {
							sLineSum += sLine + "\n";
						}
					}
				}
				//부칙이 없을경우
				if (!bu) {
					bon = bbbElement("buchicklist", doc, _nBuchikid); // 부칙
					law.appendChild(bon); // 본문 태그
					bu = true;
				}
				
				// 부칙이하 마지막에 읽은 파일 내용처리
				if (sLineSum.length() > 1) {
					for (int i = 5; i >= 0; i--) {
						if (nArrContId[i] > 0) {
							nPcontid = nArrContId[i];
							nOrd = nArrOrd[i];
							break;
						}
					}

					String sTagedText = "<lawsub>" + this.makeTag4Text(sLineSum, 0) + "</lawsub>";
					org.w3c.dom.Element secondRoot = builder.parse(new org.xml.sax.InputSource(new StringReader(sTagedText))).getDocumentElement();
					org.w3c.dom.Node tempNode = doc.importNode(secondRoot, true); 
					preJo.appendChild(tempNode);

					// law_cont 저장
					sLineSum = "";
				}
				
				bon = bbbElement("byullist", doc, _nByeolid); // 별표
				law.appendChild(bon);
				TransformerFactory factory1 = TransformerFactory.newInstance();
				StringWriter sw = new StringWriter();
				Properties output = new Properties();
				output.setProperty(OutputKeys.ENCODING, "EUC-KR");
				output.setProperty(OutputKeys.INDENT, "yes");
				Transformer transformer = factory1.newTransformer();
				transformer.setOutputProperties(output);
				transformer.transform(new DOMSource(doc), new StreamResult(sw));
				String XMLDATA = sw.getBuffer().toString().replaceAll("<lawsub>","").replaceAll("</lawsub>", "");
				mtenMap.put("XMLDATA", XMLDATA);
				mtenMap.put("XMLDATALINK", linkAndXml(XMLDATA,mtenMap));
				
				commonDao.insert("bylawSql.getTB_LM_STATEHISTORYInsert", mtenMap);
				
				
				// 이전문서 데이터 처리
				System.out.println("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
				HashMap backBon = this.selectBon(Oldbookid);
				String bnoformyn = backBon.get("NOFORMYN")==null?"":backBon.get("NOFORMYN").toString();
				String bobookid = backBon.get("OBOOKID")==null?"":backBon.get("OBOOKID").toString();
				if (bnoformyn.equals("N")) {
					String[] BXMLDATA = { backBon.get("XMLDATA").toString(),backBon.get("XMLDATALINK").toString() };
					
					for (int k = 0; k < BXMLDATA.length; k++) {
						System.out.println("◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀");
						System.out.println("◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀");
						System.out.println("◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀");
						System.out.println(BXMLDATA[k]);
						System.out.println("◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀");
						System.out.println("◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀");
						System.out.println("◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀◁◀");
						ByteArrayInputStream is = new ByteArrayInputStream(BXMLDATA[k].getBytes("utf-8"));
						doc = builder.parse(is);// (new
												// StringReader(bylaw.getXmldata()));
						String linkGbn = "law/history";
						XPathFactory factory2 = XPathFactory.newInstance();
						XPath xpath = factory2.newXPath();
						XPathExpression expr = xpath.compile(linkGbn);
						Object result = expr.evaluate(doc, XPathConstants.NODE);
						Node node = (Node) result;

						org.w3c.dom.Element set = (org.w3c.dom.Element) node;
						org.w3c.dom.Element root = (org.w3c.dom.Element) set
								.getParentNode();
						// root.removeChild(set);
						history = getBookHistoryXml(doc, bobookid);
						root.replaceChild(history, set);

						factory1 = TransformerFactory.newInstance();
						sw = new StringWriter();
						output = new Properties();
						output.setProperty(OutputKeys.ENCODING, "EUC-KR");
						output.setProperty(OutputKeys.INDENT, "yes");
						transformer = factory1.newTransformer();
						transformer.setOutputProperties(output);
						transformer.transform(new DOMSource(doc), new StreamResult(
								sw));

						if (k == 0) {
							backBon.put("XMLDATA", sw.toString());
						} else {
							backBon.put("XMLDATALINK", sw.toString());
						}
					}
				}
				// XML데이터 저장
				commonDao.update("getLawXMLDataUpdate", backBon);
			}catch(Exception e) {
				System.out.println(e);
				mtenMap.put("msg", "본문생성 실패!! 데이터추출 실패!");
			}
		}
		
		
		return mtenMap;
	}
	
	//프로세스리스트
	public JSONObject progressList(Map<String, Object> mtenMap) {
		List plist = commonDao.selectList("getProgList", mtenMap);
		JSONArray jl = JSONArray.fromObject(plist);
		JSONObject jo = new JSONObject();
		jo.put("total", plist.size());
		jo.put("result", jl);
		return jo;
	}
	
	public JSONObject changeTitle(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		commonDao.update("lawCatTitle",mtenMap);
		commonDao.update("updateHistoryTitle",mtenMap);
		String obookid = mtenMap.get("OBOOKID")==null?"":mtenMap.get("OBOOKID").toString();
		HashMap XMLDATA = commonDao.selectOne("getSelectXMLDATA", mtenMap);
		String xml[] = {XMLDATA.get("XMLDATA")==null?"":XMLDATA.get("XMLDATA").toString(),XMLDATA.get("XMLOLDNEWREVISION")==null?"":XMLDATA.get("XMLOLDNEWREVISION").toString()};
		for(int i=0; i<xml.length; i++){
			if(!xml[i].equals("")) {
				try {
					DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
					DocumentBuilder builder = factory.newDocumentBuilder();
					org.w3c.dom.Document doc = builder.newDocument();
					ByteArrayInputStream is = new ByteArrayInputStream(xml[i].getBytes("euc-kr"));
					
					doc = builder.parse(is);
					String linkGbn = "law/history";
					XPathFactory factory2 = XPathFactory.newInstance();
					XPath xpath = factory2.newXPath();
					XPathExpression expr = xpath.compile(linkGbn);
					Object result = expr.evaluate(doc, XPathConstants.NODE);
					Node node = (Node) result;
					
					org.w3c.dom.Element set = (org.w3c.dom.Element) node;
					org.w3c.dom.Element root = (org.w3c.dom.Element) set.getParentNode();
					
					org.w3c.dom.Element history = this.getBookHistoryXml(doc, obookid);
					root.replaceChild(history, set);
					
					expr = xpath.compile("/law");
					result = expr.evaluate(doc, XPathConstants.NODE);
					node = (Node) result;
					set = (org.w3c.dom.Element) node;
					
					set.setAttribute("title", mtenMap.get("TITLE")==null?"":mtenMap.get("TITLE").toString());
					set.setAttribute("revcha", mtenMap.get("REVCHA")==null?"":mtenMap.get("REVCHA").toString());
					
					StringWriter sw = new StringWriter();
					TransformerFactory factory1 = TransformerFactory.newInstance();
					Properties output = new Properties();
					output.setProperty(OutputKeys.ENCODING, "EUC-KR");
					output.setProperty(OutputKeys.INDENT, "yes");
					Transformer transformer = factory1.newTransformer();
					transformer.setOutputProperties(output);
					transformer.transform(new DOMSource(doc), new StreamResult(sw));
					
					if(i==0){
						mtenMap.put("XMLDATA", sw.toString());
						String XMLDATATMP = sw.toString().replaceAll("<a5b5 />", "&lt;a5b5 /&gt;").replaceAll("<image", "&lt;image").replaceAll("baseline\" />","baseline\" /&gt;");
						mtenMap.put("XMLDATALINK", linkAndXml(XMLDATATMP,mtenMap));
					}else{
						mtenMap.put("XMLOLDNEWREVISION", sw.toString());
					}
				}catch(Exception e) {
					System.out.println(e);
					rs.put("success", false);
				}
			}
		}
		commonDao.update("getLawXMLDataUpdate", mtenMap);
		rs.put("success", true);
		return rs;
	}
	
	public static String dateAddFormat(int field, int amount, String date,
			String dateFormat) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
			String formatDate = sdf.format(dateAdd(field, amount, date,
					dateFormat));
			return formatDate;
		} catch (Exception e) {
			return null;
		}
	}
	
	/* 날짜가 String형일 경우에는 SimpleDateFormat 클래스를 이용해서 Date형으로 변환한다. */
	public static Date dateAdd(int field, int amount, String date,
			String inputDateFormat) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat(inputDateFormat);
			Date result = sdf.parse(date);
			result = dateAdd(field, amount, result);
			return result;
		} catch (Exception e) {
			return null;
		}
	}
	
	/* 실제로 날짜 연산을 수행하는 메소드 */
	public static Date dateAdd(int field, int amount, Date date) {
		Calendar cal = Calendar.getInstance(); /* 날짜 연산을 위해 Calendar 객체를 생성한다. */
		cal.setTime(date); /* Date형으로 넘어온 날짜를 Calendar 객체를 이용하여 현재 시간으로 설정한다 */
		cal.add(field, amount); /* Calendar 객체의 add 메소드를 이용하여 날짜 연산을 수행한다. */
		return cal.getTime(); /* Date형으로 연산된 날짜를 반환한다. */
	}
	
	public void fileCopy(String f1, String f2){
		//스트림, 채널 선언  
		FileInputStream inputStream = null;  
		FileOutputStream outputStream = null;  
		FileChannel fcin = null;  
		FileChannel fcout = null;  
		try {
			//복사 대상이 되는 파일 생성   
			File sourceFile = new File(MakeHan.File_url("ATTACH")+"/"+ f1 );
			//스트림 생성   
			inputStream = new FileInputStream(sourceFile); 
			
			System.out.println("========f2 : "+f2);
			outputStream = new FileOutputStream(MakeHan.File_url("ATTACH")+"/"+f2);   
			//채널 생성   
			fcin = inputStream.getChannel();   
			fcout = outputStream.getChannel();      
			//채널을 통한 스트림 전송   
			long size = fcin.size();   
			fcin.transferTo(0, size, fcout);  
		} catch (Exception e) {  
			e.printStackTrace();  
		} finally {   
			//자원 해제  
			try{    
				fcout.close();   
			}catch(IOException ioe){}   
			try{    
				fcin.close();   
			}catch(IOException ioe){}   
			try{    
				outputStream.close();   
			}catch(IOException ioe){}   
			try{    
				inputStream.close();   
			}catch(IOException ioe){}  
		} 
	}
	
	public JSONObject updateStep(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		System.out.println("==============>"+mtenMap);
		String bookIds = mtenMap.get("bookIds")==null?"":mtenMap.get("bookIds").toString();
		String statehistoryids = mtenMap.get("statehistoryids")==null?"":mtenMap.get("statehistoryids").toString();
		String startDts = mtenMap.get("startDts")==null?"":mtenMap.get("startDts").toString();
		String nowstatecd = mtenMap.get("nowstateCd")==null?"":mtenMap.get("nowstateCd").toString();
		String titles = mtenMap.get("titles")==null?"":mtenMap.get("titles").toString();
		
		String[] arrBookId = bookIds.split(",");
		String[] arrstatehistoryids = statehistoryids.split(",");
		String[] arrstartDts = startDts.split(",");
		String[] title = titles.split(",");
		if(arrBookId.length<1) {
			rs.put("success", false);
			return rs;
		}
		
		if(arrBookId.length>0) {
			for(int i =0 ; i<arrBookId.length;i++){
				HashMap para = new HashMap();
				para.put("bookid", arrBookId[i]);
				para.put("statecd", nowstatecd);
				para.put("stateid", nowstatecd);
				para.put("statehistoryid", arrstatehistoryids[i]);
				para.put("writerid", mtenMap.get("writerid"));
				
				//현재 현행문서를 연혁으로 수정하고 enddt를 수정해준다.
				String conV = commonDao.selectOne("bylawSql.getStateCd", nowstatecd);
				if(conV.equals("현행")||conV.equals("폐지")){
					para.put("enddt", dateAddFormat(Calendar.DATE, -1, arrstartDts[i],"yyyy-MM-dd"));
					commonDao.update("bylawSql.updateStep1", para);
				}
				commonDao.update("bylawSql.updateStep2", para);
				commonDao.insert("bylawSql.nextStep_Copy",para);
				String statehistoryid = para.get("newstatehistoryid").toString();
				
				//첨부파일처리
				List flist = commonDao.selectList("bylawSql.getServerFilename", para);
				for(int j=0; j<flist.size(); j++){
					HashMap Fileinfo = (HashMap)flist.get(j);
					System.out.println(Fileinfo);
					if(Fileinfo != null){
						String Fileid = commonDao.select("commonSql.getSeq");
						String serverfilename = Fileid+"."+Fileinfo.get("FILETYPE");//getFiletype();
						para.put("fileid", Fileid);
						para.put("statehistoryid", statehistoryid);
						para.put("filecd", Fileinfo.get("FILECD"));//getFilecd());
						para.put("pcfilename", Fileinfo.get("PCFILENAME"));//getPcfilename());
						para.put("filetype", Fileinfo.get("FILETYPE"));//getFiletype());
						para.put("serverfile", serverfilename);
						para.put("updt", MakeHan.get_data());
						para.put("bontxt", "");//getBontxt());
						para.put("ord", Fileinfo.get("ORD"));//getOrd());
						commonDao.insert("bylawSql.setServerFilename",para);
						
						System.out.println("fileid"+Fileid+",serverfilename:"+Fileinfo.get("FILETYPE"));
						
						fileCopy(Fileinfo.get("SERVERFILE").toString(),serverfilename);//getServerfile(),serverfilename);
					}
				}
				
				//공포전에 검색을 위한 파일 데이터와 본문데이터를 추출한다.
				if(conV.equals("현행")||conV.equals("폐지")){
					this.setXmlSchBon(arrBookId[i]);	//본문 텍스트 추출
					HashMap re = commonDao.select("bylawSql.selectDocByul",statehistoryid);
					this.byulListInosert(re);
					
					String bookcd = re.get("BOOKCD")==null?"":re.get("BOOKCD").toString();
					if(!("조례".equals(bookcd) || "규칙".equals(bookcd) || bookcd.equals(""))){
						HashMap bpara = new HashMap();
						bpara.put("BBSCD", "PDS");
						bpara.put("title", "[알림] "+title[i]+"이 공포 되었습니다.");
						bpara.put("contents", "<b>"+title[i] + "이 공포되었습니다. 다음 링크를 클릭해 확인 내용을 확인 하시기 바랍니다.</b><br/><br/><a href='"+mtenMap.get("uInfo")+"/web/regulation/regulationViewPop.do?bookid="+arrBookId[i]+"&noformyn=N'  target='_blank' style='color:blue;'><u>"+title[i]+" 확인하기</u></a>");
						bpara.put("writerid", mtenMap.get("writerid"));
						bpara.put("writer", mtenMap.get("writer"));
						bpara.put("sdeptid", mtenMap.get("sdeptid"));
						bpara.put("sdeptname", mtenMap.get("sdeptname"));
						bpara.put("MENU_MNG_NO", "10004325");
						commonDao.insert("lawbbsSql.Insert",bpara);
					}
				}
			}
		}
		
		rs.put("success", true);
		
		return rs;
	}
	
	public void byulListInosert(HashMap re){
		String bookid = re.get("BOOKID")==null?"":re.get("BOOKID").toString();
		String Xmldata = re.get("XMLDATA")==null?"":re.get("XMLDATA").toString();
		String STATECD = re.get("STATECD")==null?"":re.get("STATECD").toString();
		try{
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			org.w3c.dom.Document doc = builder.newDocument();
			ByteArrayInputStream is = new ByteArrayInputStream(Xmldata.getBytes("euc-kr"));
			doc = builder.parse(is);
			String linkGbn = "//byul[@endcha='9999' and @curstate!='delete' and @curstate!='deletemark']";
			XPathFactory factory2 = XPathFactory.newInstance();
			XPath xpath = factory2.newXPath();
			XPathExpression expr = xpath.compile(linkGbn);
			Object result = expr.evaluate(doc, XPathConstants.NODESET);
			NodeList blist = (NodeList)result;
			System.out.println("blist.getLength()===>"+blist.getLength());
			if(blist.getLength()>0){
				commonDao.delete("searchByulDelete",bookid);
				for(int j=0; j<blist.getLength(); j++){
					org.w3c.dom.Element bb = (org.w3c.dom.Element)blist.item(j);
					if(bb.getAttribute("fileid")!=null && !bb.getAttribute("fileid").equals("")){
						re.put("FILEID",bb.getAttribute("fileid"));
						re.put("SERVERFILE",bb.getAttribute("serverfilename"));
						re.put("PCFILENAME",bb.getAttribute("pcfilename"));
						re.put("FILECD",bb.getAttribute("byulcd"));
						re.put("STATECD",STATECD);
						commonDao.insert("bylawSql.searchByulInsert",re);
					}
					
				}
			}
		}catch(Exception e){
			System.out.println(e);
		}
	}
	
	public JSONObject deleteProc(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		commonDao.delete("bylawSql.delLawCat",mtenMap);			//TB_LM_RULECAT
		commonDao.delete("bylawSql.delAllDoclawFile",mtenMap);	//TB_LM_RULEFILE
		commonDao.delete("bylawSql.delLawBook",mtenMap);		//TB_LM_RULEHISTORY
		commonDao.delete("bylawSql.delXmlData",mtenMap);		//TB_LM_STATEHISTORY
		commonDao.delete("bylawSql.delAllDoclawTB_LM_RULELINKINFO",mtenMap);	//TB_LM_RULELINKINFO
		commonDao.delete("bylawSql.delAllDoclawTB_LM_RULEOPINION",mtenMap);		//TB_LM_RULELINKINFO
		commonDao.delete("bylawSql.delAllDoclawTB_LM_RULESEARCHFILE",mtenMap);	//TB_LM_RULELINKINFO
		rs.put("success", true);
		return rs;
	}
	
	public JSONObject setRevreason(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		commonDao.update("bylawSql.setRevreason",mtenMap);
		rs.put("success", true);
		return rs;
	}
	
	public JSONObject setJenmun(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		commonDao.update("bylawSql.setJenmun",mtenMap);
		rs.put("success", true);
		return rs;
	}
	
	public JSONObject setMemo(Map<String, Object> mtenMap) {
		String memoid = mtenMap.get("memoid")==null?"":mtenMap.get("memoid").toString();
		JSONObject rs = new JSONObject();
		if(memoid.equals("")) {
			commonDao.insert("bylawSql.setMemo",mtenMap);
		}else {
			commonDao.update("bylawSql.setMemoU",mtenMap);
		}
		rs.put("success", true);
		return rs;
	}
	
	public JSONObject getMemo(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		HashMap result = commonDao.select("bylawSql.getMemo",mtenMap);
		if(result!=null) {
			rs = JSONObject.fromObject(result);
		}
		return rs;
	}
	
	public JSONObject getMemoList(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		commonDao.update("bylawSql.getMemoList",mtenMap);
		rs.put("success", true);
		return rs;
	}
	
	public JSONObject get3danList(int start, int limit, String query) {
		JSONObject rs = new JSONObject();
		String statecd = "현행";
		HashMap params = new HashMap();
		params.put("query", query);
		params.put("statecd", statecd);
		List resList = commonDao.selectList("3danSql.get3danList",params);
		List fstList = commonDao.selectList("3danSql.get3danSetSize",params);  
		int total = fstList.size();
		if(total-limit<0){
			limit = total;
		}
		rs.put("total", total);
		int fstOBookId=-1;
		JSONArray jl = new JSONArray();
		for(int i=start;i<limit;i++){
			JSONObject rss = new JSONObject();
			int danNum=-1;
			String dan1="";
			String dan2="";
			String dan3="";
			String dan4="";
			fstOBookId = ((HashMap)fstList.get(i)).get("FSTOBOOKID")==null?-1:Integer.parseInt(((HashMap)fstList.get(i)).get("FSTOBOOKID").toString());
			
			for(int j=0;j<resList.size();j++){
				HashMap l3Bean = (HashMap) resList.get(j);
				
				int FSTOBOOKID = Integer.parseInt(l3Bean.get("FSTOBOOKID").toString()); 
				int DAN = Integer.parseInt(l3Bean.get("DAN").toString()); 
				
				if(fstOBookId != FSTOBOOKID)
					continue;
				
				if(DAN==1){
					dan1=l3Bean.get("TITLE").toString();
				}else if(DAN==2 && danNum==-1){
					dan2+=l3Bean.get("TITLE").toString();
					danNum=2;
				}else if(DAN==2 && danNum==2){
					dan2+=", "+l3Bean.get("TITLE").toString();
				}else if(DAN==3 && danNum==2){
					dan3+=l3Bean.get("TITLE").toString();
					danNum=3;
				}else if(DAN==3 && danNum==3){
					dan3+=", "+l3Bean.get("TITLE").toString();
				}else if(DAN==4 && danNum==3){
					dan4+=l3Bean.get("TITLE").toString();
					danNum=4;
				}else if(DAN==4 && danNum==4){
					dan4+=", "+l3Bean.get("TITLE").toString();
				}
			}
			rss.put("id", i+1);
			rss.put("fstOBookId", fstOBookId);
			rss.put("dan1", dan1);
			rss.put("dan2", dan2);
			rss.put("dan3", dan3);
			rss.put("dan4", dan4);
			
			jl.add(rss);
			
			dan1="";
			dan2="";
			dan3="";
			danNum=-1;
		}
		rs.put("result", jl);
		return rs;
	}
	
	public JSONObject getSchResult(int start, int limit, String query) {
		JSONObject rs = new JSONObject();
		String statecd = "현행";
		HashMap params = new HashMap();
		params.put("schText", query);
		params.put("statecd", statecd);
		
		List resList = commonDao.selectList("3danSql.getSearchResult",params);
		if(resList.size()-limit<0){
			limit=resList.size();
		}
		rs.put("total", resList.size());
		JSONArray jl = new JSONArray();
		for(int i=start;i<limit;i++){
			JSONObject rss = new JSONObject();
			HashMap l3Bean = (HashMap)resList.get(i);
			int DAN = Integer.parseInt(l3Bean.get("DAN").toString()); 
			if(DAN==1||DAN==2||DAN==3){
				rss.put("is3dan", "Y");
			}else{
				rss.put("is3dan", "N");
			}
			rss.put("id", i+1);
			rss.put("bookId", l3Bean.get("BOOKID"));
			rss.put("oBookId", l3Bean.get("OBOOKID"));
			rss.put("title", l3Bean.get("TITLE"));
			jl.add(rss);
		}
		rs.put("result", jl);
		return rs;
	}
	
	public JSONObject getSchResult2(String query, String oBookIds) {
		JSONObject rs = new JSONObject();
		String[] arrOBookId= oBookIds.split(",");
		HashMap params = new HashMap();
		params.put("schText", query);
		params.put("statecd", "현행");
		
		ArrayList obookids = new ArrayList();
		for(int i=0; i<arrOBookId.length;i++){
			obookids.add(arrOBookId[i]);
		}
		params.put("obookids", obookids);
		
		List resList = commonDao.selectList("3danSql.getSearch23",params);
		
		JSONArray jl = new JSONArray();
		for(int i =0; i<resList.size();i++){
			JSONObject rss = new JSONObject();
			HashMap l3Bean = (HashMap)resList.get(i);
			
			rss.put("bookId", l3Bean.get("BOOKID"));
			rss.put("oBookId", l3Bean.get("OBOOKID"));
			rss.put("title", l3Bean.get("TITLE"));
			
			jl.add(rss);
		}
		rs.put("result", jl);
		return rs;
	}
	
	public int insertData2(String dan1, String dan2) {
		int count=0;
		HashMap beanDan1 = new HashMap();
		ArrayList arrDan2= new ArrayList();
		HashMap tmbBean = new HashMap();
		String[] strArrDan1 = dan1.split(",");
		int fstOBookId=Integer.parseInt(strArrDan1[1]);
		int oBookId=0;
		int dan=0;
		int ord=0;
		//1단 내규 빈 설정
		beanDan1.put("obookid",fstOBookId);
		beanDan1.put("fstobookid",fstOBookId);
		beanDan1.put("ord",ord);
		beanDan1.put("dan",1);
		//2단 내규 빈 설정
		String[] strArrDan2 = dan2.split("/");
		for(int i=0;i<strArrDan2.length;i++){
			String[] tmpStrArr = strArrDan2[i].split(",");
			HashMap tmpBean = new HashMap();
			tmpBean.put("fstobookid",fstOBookId);
			tmpBean.put("obookid",Integer.parseInt(tmpStrArr[0]));
			tmpBean.put("ord",Integer.parseInt(tmpStrArr[1]));
			tmpBean.put("dan",2);
			arrDan2.add(tmpBean);
		}
		
		System.out.println("Data insert process Start");
		commonDao.insert("3danSql.insertData",beanDan1);
		count++;
		for(int i=0;i<arrDan2.size();i++){
			HashMap l3Bean = (HashMap)arrDan2.get(i);
			commonDao.insert("3danSql.insertData",l3Bean);
			count++;
		}
		System.out.println("Data insert process Success");
		return count;
	}
	
	public int insertData(String dan1, String dan2, String dan3) {
		int count=0;
		HashMap beanDan1 = new HashMap();
		ArrayList arrDan2= new ArrayList();
		ArrayList arrDan3= new ArrayList();
		HashMap tmbBean = new HashMap();
		String[] strArrDan1 = dan1.split(",");
		int fstOBookId=Integer.parseInt(strArrDan1[1]);
		int oBookId=0;
		int dan=0;
		int ord=0;
		//1단 내규 빈 설정
		beanDan1.put("obookid",fstOBookId);
		beanDan1.put("fstobookid",fstOBookId);
		beanDan1.put("ord",ord);
		beanDan1.put("dan",1);
		//2단 내규 빈 설정
		System.out.println(dan2);
		String[] strArrDan2 = dan2.split("/");
		for(int i=0;i<strArrDan2.length;i++){
			String[] tmpStrArr = strArrDan2[i].split(",");
			System.out.println("tmpStrArr: "+tmpStrArr);
			HashMap tmpBean = new HashMap();

			tmpBean.put("fstobookid",fstOBookId);
			tmpBean.put("obookid",Integer.parseInt(tmpStrArr[0]));
			tmpBean.put("ord",Integer.parseInt(tmpStrArr[1]));
			tmpBean.put("dan",2);
			arrDan2.add(tmpBean);
		}
		//3단 내규 빈 설정
		System.out.println(dan3);
		String[] strArrDan3 = dan3.split("/");
		for(int i=0;i<strArrDan3.length;i++){
			String[] tmpStrArr = strArrDan3[i].split(",");
			HashMap tmpBean = new HashMap();
			tmpBean.put("fstobookid",fstOBookId);
			tmpBean.put("obookid",Integer.parseInt(tmpStrArr[0]));
			tmpBean.put("ord",Integer.parseInt(tmpStrArr[1]));
			tmpBean.put("dan",3);
			arrDan3.add(tmpBean);
		}
		
		System.out.println("Data insert process Start");
		commonDao.insert("3danSql.insertData",beanDan1);
		count++;
		for(int i=0;i<arrDan2.size();i++){
			HashMap l3Bean = (HashMap)arrDan2.get(i);
			commonDao.insert("3danSql.insertData",l3Bean);
			count++;
		}
		for(int i=0;i<arrDan3.size();i++){
			HashMap l3Bean = (HashMap)arrDan3.get(i);
			commonDao.insert("3danSql.insertData",l3Bean);
			count++;
		}
		return count;
	}
	
	public int insertData3(String dan1, String dan2, String dan3, String dan4) {
		int count=0;
		HashMap beanDan1 = new HashMap();
		ArrayList arrDan2= new ArrayList();
		ArrayList arrDan3= new ArrayList();
		ArrayList arrDan4= new ArrayList();
		HashMap tmbBean = new HashMap();
		String[] strArrDan1 = dan1.split(",");
		int fstOBookId=Integer.parseInt(strArrDan1[1]);
		int oBookId=0;
		int dan=0;
		int ord=0;
		//1단 내규 빈 설정
		beanDan1.put("obookid",fstOBookId);
		beanDan1.put("fstobookid",fstOBookId);
		beanDan1.put("ord",ord);
		beanDan1.put("dan",1);
		//2단 내규 빈 설정
		System.out.println(dan2);
		String[] strArrDan2 = dan2.split("/");
		for(int i=0;i<strArrDan2.length;i++){
			String[] tmpStrArr = strArrDan2[i].split(",");
			System.out.println("tmpStrArr: "+tmpStrArr);
			HashMap tmpBean = new HashMap();

			tmpBean.put("fstobookid",fstOBookId);
			tmpBean.put("obookid",Integer.parseInt(tmpStrArr[0]));
			tmpBean.put("ord",Integer.parseInt(tmpStrArr[1]));
			tmpBean.put("dan",2);
			arrDan2.add(tmpBean);
		}
		//3단 내규 빈 설정
		System.out.println(dan3);
		String[] strArrDan3 = dan3.split("/");
		for(int i=0;i<strArrDan3.length;i++){
			String[] tmpStrArr = strArrDan3[i].split(",");
			HashMap tmpBean = new HashMap();
			tmpBean.put("fstobookid",fstOBookId);
			tmpBean.put("obookid",Integer.parseInt(tmpStrArr[0]));
			tmpBean.put("ord",Integer.parseInt(tmpStrArr[1]));
			tmpBean.put("dan",3);
			arrDan3.add(tmpBean);
		}
		
		//4단 내규 빈 설정
		System.out.println(dan4);
		String[] strArrDan4 = dan4.split("/");
		for(int i=0;i<strArrDan4.length;i++){
			String[] tmpStrArr = strArrDan4[i].split(",");
			HashMap tmpBean = new HashMap();
			tmpBean.put("fstobookid",fstOBookId);
			tmpBean.put("obookid",Integer.parseInt(tmpStrArr[0]));
			tmpBean.put("ord",Integer.parseInt(tmpStrArr[1]));
			tmpBean.put("dan",4);
			arrDan4.add(tmpBean);
		}
				
		System.out.println("Data insert process Start");
		commonDao.insert("3danSql.insertData",beanDan1);
		count++;
		for(int i=0;i<arrDan2.size();i++){
			HashMap l3Bean = (HashMap)arrDan2.get(i);
			commonDao.insert("3danSql.insertData",l3Bean);
			count++;
		}
		for(int i=0;i<arrDan3.size();i++){
			HashMap l3Bean = (HashMap)arrDan3.get(i);
			commonDao.insert("3danSql.insertData",l3Bean);
			count++;
		}
		for(int i=0;i<arrDan4.size();i++){
			HashMap l3Bean = (HashMap)arrDan4.get(i);
			commonDao.insert("3danSql.insertData",l3Bean);
			count++;
		}
		return count;
	}
	
	public int del3danSet(String selected) {
		String[] fstOBookIds = selected.split("/");
		ArrayList fstobookids = new ArrayList();
		
		for(int i=0; i<fstOBookIds.length;i++){
			fstobookids.add(fstOBookIds[i]);
		}
		HashMap param = new HashMap();
		param.put("fstobookids", fstobookids);
		int resNum = commonDao.delete("3danSql.del3danSet",param);
		return resNum;
	}
	
	public HashMap getFileInfoDLL(Map<String, Object> mtenMap) {
		return (HashMap)commonDao.selectOne("bylawSql.getFileInfoDLL",mtenMap);
	}
	
	public boolean ServerFileBeing(Map<String, Object> mtenMap) {
		String serverfilename = (String)commonDao.selectOne("bylawSql.ServerFileBeing",mtenMap);
		File f = null;
		try {
			f = new File(MakeHan.File_url("ATTACH")+"/"+serverfilename);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return f.isFile();
	}
	
	public void DllImgUpload(Map<String, Object> mtenMap) {
		String work = mtenMap.get("work")==null?"":mtenMap.get("work").toString();
		String Filecd = mtenMap.get("Filecd")==null?"":mtenMap.get("Filecd").toString();
		
		Map UPP = this.keyChangeUpperMap(mtenMap);
		
		if (work.equals("INSERT")) {// 파일 업로드
			HashMap by = commonDao.selectOne("bylawSql.getFileInfoCom",mtenMap);
			if(by==null){
				commonDao.insert("bylawSql.lawfileInsert",UPP);
				if(Filecd.equals("REA")){
					commonDao.update("bylawSql.setMAINPITH",mtenMap);
				}
			}else{
				commonDao.delete("bylawSql.delLawFileDLL",mtenMap);
				commonDao.insert("bylawSql.lawfileInsert",UPP);
				if(Filecd.equals("REA")){
					commonDao.update("bylawSql.setMAINPITH",mtenMap);
				}
			}
		} else if (work.equals("UPDATE")) { // 파일 수정
			commonDao.delete("bylawSql.delLawFileDLL",mtenMap);
			commonDao.insert("bylawSql.lawfileInsert",UPP);
		}
	}
	
	public void DllImgDelete(Map<String, Object> mtenMap) {
		commonDao.delete("bylawSql.delLawFile",mtenMap);
	}
	
	public int delAttFile(Map<String, Object> mtenMap) {
		System.out.println("mtenMap===>"+mtenMap);
		mtenMap.put("fileid", mtenMap.get("fileId"));
		HashMap by = commonDao.selectOne("bylawSql.getFileInfoCom",mtenMap);
		int reNum = 0;
		if(by!=null) {
			mtenMap.put("FILEID", mtenMap.get("fileId"));
			reNum = commonDao.delete("bylawSql.delFile",mtenMap);
			if(reNum!=0) {
				try {
					File file = new File(MakeHan.File_url("LAW")+by.get("SERVERFILE"));
					if (file.exists())
			        	file.delete();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return reNum;
	}
	
	public JSONObject promuldtInsert(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		List data = commonDao.selectList("bylawSql.promuldtInsertInfo", mtenMap);
		for(int i=0; i<data.size(); i++) {
			HashMap result = (HashMap)data.get(i);
			result.put("XMLDATA", this.ReplaceDt(result.get("XMLDATA")==null?"":result.get("XMLDATA").toString(),mtenMap));
			result.put("XMLOLDNEWREVISION", this.ReplaceDt(result.get("XMLOLDNEWREVISION")==null?"":result.get("XMLOLDNEWREVISION").toString(),mtenMap));
			result.put("XMLDATALINK", this.ReplaceDt(result.get("XMLDATALINK")==null?"":result.get("XMLDATALINK").toString(),mtenMap));
			commonDao.update("bylawSql.promuldtInsert2",result);
		}
		commonDao.update("bylawSql.promuldtInsert", mtenMap);
		rs.put("success", true);
		return rs;
	}
	
	public String ReplaceDt(String dt,Map<String, Object> mtenMap){
		dt = dt.replaceAll("제0000-000호", mtenMap.get("promulno").toString());
		dt = dt.replaceAll("7777-12-31", mtenMap.get("promuldt").toString()).replaceAll("6666-12-31", mtenMap.get("startdt").toString()).replaceAll("5555-12-31", mtenMap.get("enddt").toString());
		dt = dt.replaceAll("7777.12.31", mtenMap.get("promuldt").toString().replaceAll("-", ".")).replaceAll("6666.12.31", mtenMap.get("startdt").toString().replaceAll("-", ".")).replaceAll("5555.12.31", mtenMap.get("enddt").toString().replaceAll("-", "."));
		return dt;
	}
	
	public JSONObject deleteCansel(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		String GBN = mtenMap.get("GBN")==null?"":mtenMap.get("GBN").toString();
		String REVCHA = mtenMap.get("REVCHA")==null?"":mtenMap.get("REVCHA").toString();
		if(GBN.equals("SEL") || GBN.equals("CLOSESEL")) {	//개정 취소,폐지 취소
			mtenMap.put("gbn", "ONE");
			List dl = commonDao.selectList("bylawSql.deleteCansel", mtenMap);
			for (int i = 0; i < dl.size(); i++) {
				HashMap bylaw = (HashMap) dl.get(i);
				String drevcha = bylaw.get("REVCHA")==null?"":bylaw.get("REVCHA").toString();
				if (REVCHA.equals(drevcha)) { // 현행삭제
					bylaw.put("gbn", "ONE");
					commonDao.delete("bylawSql.delLawCat",bylaw);			//TB_LM_RULECAT
					commonDao.delete("bylawSql.delAllDoclawFile",bylaw);	//TB_LM_RULEFILE
					commonDao.delete("bylawSql.delXmlData",bylaw);		//TB_LM_STATEHISTORY
					commonDao.delete("bylawSql.delAllDoclawTB_LM_RULELINKINFO",bylaw);	//TB_LM_RULELINKINFO
					commonDao.delete("bylawSql.delAllDoclawTB_LM_RULEOPINION",bylaw);		//TB_LM_RULEOPINION
					commonDao.delete("bylawSql.delAllDoclawTB_LM_RULESEARCHFILE",bylaw);	//TB_LM_RULESEARCHFILE
					commonDao.delete("bylawSql.delAllDoclawTB_LM_RULEMEMO",bylaw);	//TB_LM_RULEMEMO
					commonDao.delete("bylawSql.delAllDoclawBook",bylaw);	//TB_LM_RULEHISTORY
				} else {
					commonDao.update("bylawSql.updateLawBook",bylaw);
					rs.put("BOOKID", bylaw.get("BOOKID"));
				}
			}
		}else {	//삭제
			mtenMap.put("gbn", "ALL");
			commonDao.delete("bylawSql.delLawCat",mtenMap);			//TB_LM_RULECAT
			commonDao.delete("bylawSql.delAllDoclawFile",mtenMap);	//TB_LM_RULEFILE
			commonDao.delete("bylawSql.delXmlData",mtenMap);		//TB_LM_STATEHISTORY
			commonDao.delete("bylawSql.delAllDoclawTB_LM_RULELINKINFO",mtenMap);	//TB_LM_RULELINKINFO
			commonDao.delete("bylawSql.delAllDoclawTB_LM_RULEOPINION",mtenMap);		//TB_LM_RULEOPINION
			commonDao.delete("bylawSql.delAllDoclawTB_LM_RULESEARCHFILE",mtenMap);	//TB_LM_RULESEARCHFILE
			commonDao.delete("bylawSql.delAllDoclawTB_LM_RULEMEMO",mtenMap);	//TB_LM_RULEMEMO
			commonDao.delete("bylawSql.delAllDoclawTB_LM_RULEDEPT",mtenMap);	//TB_LM_RULEDEPT
			commonDao.delete("bylawSql.delAllDoclawTB_LM_FAV",mtenMap);	//TB_LM_FAV
			commonDao.delete("bylawSql.delAllDoclawBook",mtenMap);	//TB_LM_RULEHISTORY
		}
		
		
		return rs;
	}
	
	// 첨부파일 등록(TB_LM_RULEFILE)
	public String setLawfileInsert(ArrayList fileInsert) {
		String reSult = "파일이 등록되었습니다.";
		try {
			int cnt = fileInsert.size();
			HashMap data = new HashMap();
			for (int i = 0; i < cnt; i++) {
				data = (HashMap) fileInsert.get(i);
				commonDao.insert("bylawSql.lawfileInsert",data);
				
				/*if (!(bylaw.getFiletype().toLowerCase().equals("")
						|| bylaw.getFiletype().toLowerCase().equals("jpg")
						|| bylaw.getFiletype().toLowerCase().equals("hwp")
						|| bylaw.getFiletype().toLowerCase().equals("pdf")
						|| bylaw.getFiletype().toLowerCase().equals("doc")
						|| bylaw.getFiletype().toLowerCase().equals("docx")
						|| bylaw.getFiletype().toLowerCase().equals("txt")
						|| bylaw.getFiletype().toLowerCase().equals("xls")
						|| bylaw.getFiletype().toLowerCase().equals("ppt")
						|| bylaw.getFiletype().toLowerCase().equals("xlsx")
						|| bylaw.getFiletype().toLowerCase().equals("pptx") || bylaw
						.getFiletype().toLowerCase().equals("xdw"))) {
					reSult = "<script language=javascript> alert(\"*."
							+ bylaw.getFiletype()
							+ "는 업로드할수 없는 파일 형식입니다.!!\"); history.go(-1); </script>";
					for (int k = i; k >= 0; k--) {
						FileUploadUtil Futil = new FileUploadUtil();
						Futil.deleteFile(data.get("tempDir").toString()
								+ data.get("serverfile").toString()); // 업로드
																		// 실패로
																		// 인한 파일
																		// 삭제
					}
					break;
				}*/
			}

		} catch (Throwable t) {
			System.out.println(t);
			reSult = "파일업로드 실패 잠시후 이용바랍니다.";
		}
		return reSult;
	}
	
	public Map noFormUp(Map<String, Object> mtenMap) {
		try {
			commonDao.update("bylawSql.lawBookUpdate",mtenMap);
			commonDao.update("bylawSql.lawCatTitle",mtenMap);
			String bookid = mtenMap.get("BOOKID")==null?"":mtenMap.get("BOOKID").toString();
			HashMap result = commonDao.select("bylawSql.getSelectBons", bookid);
			
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true); // never forget this!
			DocumentBuilder builder = factory.newDocumentBuilder();
			org.w3c.dom.Document doc = builder.newDocument();
			String XMLDATA[] = { result.get("XMLDATA").toString(),result.get("XMLDATALINK").toString() };
			for (int i = 0; i < XMLDATA.length; i++) {
				ByteArrayInputStream is = new ByteArrayInputStream(XMLDATA[i].getBytes("euc-kr"));
				doc = builder.parse(is);// (new
										// StringReader(bylaw.getXmldata()));
				String linkGbn = "law/history/hisitem[@revcha='"+ mtenMap.get("REVCHA") + "']";
				XPathFactory factory2 = XPathFactory.newInstance();
				XPath xpath = factory2.newXPath();
				XPathExpression expr = xpath.compile(linkGbn);
				Object resultX = expr.evaluate(doc, XPathConstants.NODE);
				Node node = (Node) resultX;
				org.w3c.dom.Element set = (org.w3c.dom.Element) node;
				((org.w3c.dom.Element) set.getParentNode().getParentNode()).setAttribute("title", mtenMap.get("TITLE").toString());
	
				set.setAttribute("title", mtenMap.get("TITLE").toString());
				set.setAttribute("promuldt", mtenMap.get("PROMULDT")==null?"":mtenMap.get("PROMULDT").toString());
				set.setAttribute("otherlaw", mtenMap.get("OTHERLAW")==null?"":mtenMap.get("OTHERLAW").toString());
				set.setAttribute("revcd", mtenMap.get("REVCD")==null?"":mtenMap.get("REVCD").toString());
				
				set.setAttribute("startdt", mtenMap.get("STARTDT")==null?"":mtenMap.get("STARTDT").toString());
				
				TransformerFactory factory1 = TransformerFactory.newInstance();
				StringWriter sw = new StringWriter();
				Properties output = new Properties();
				output.setProperty(OutputKeys.ENCODING, "EUC-KR");
				output.setProperty(OutputKeys.INDENT, "yes");
				Transformer transformer = factory1.newTransformer();
				transformer.setOutputProperties(output);
				transformer.transform(new DOMSource(doc), new StreamResult(sw));
				
				if (i == 0) {
					result.put("XMLDATA", sw.toString());
				} else {
					result.put("XMLDATALINK", sw.toString());
				}
			}
			// XML데이터 저장
			commonDao.update("bylawSql.setUpdateDocinfo",result);
		} catch (Throwable t) {
			System.out.println("=============rollback=====================");
		}
		return mtenMap;
	}
	
	public JSONObject makeLink(Map<String, Object> mtenMap) {
		JSONObject re = new JSONObject();
		String BOOKID = mtenMap.get("BOOKID")==null?"":mtenMap.get("BOOKID").toString();
		String GBN = mtenMap.get("GBN")==null?"":mtenMap.get("GBN").toString();
		
		if(GBN.equals("DOC")) {
			HashMap data = this.selectBon(BOOKID);
			data.put("STATEHISTORYID", data.get("statehistoryid"));
			String XMLDATA = data.get("XMLDATA")==null?"":data.get("XMLDATA").toString();
			data.put("XMLDATALINK", linkAndXml(XMLDATA,data));
			
			commonDao.update("bylawSql.getLawXMLDataUpdate", data);
		}else if(GBN.equals("ALLDOC")) {
			List dl = commonDao.selectList("bylawSql.linkDocList",mtenMap);
			int cnt = dl.size();
			for (int i = 0; i < cnt; i++) {
				try {
					HashMap bylaw = (HashMap) dl.get(i);
					String XMLDATA = bylaw.get("XMLDATA")==null?"":bylaw.get("XMLDATA").toString();
					bylaw.put("XMLDATALINK", linkAndXml(XMLDATA,bylaw));
					
					commonDao.update("bylawSql.getLawXMLDataUpdate", bylaw);
				} catch (Throwable t) {
					System.out.println(t);
				}
			}
		}else if(GBN.equals("TOTALDOC")) {
			List dl = commonDao.selectList("bylawSql.linkDocList");
			int cnt = dl.size();
			for (int i = 0; i < cnt; i++) {
				try {
					HashMap bylaw = (HashMap) dl.get(i);
					String XMLDATA = bylaw.get("XMLDATA")==null?"":bylaw.get("XMLDATA").toString();
					bylaw.put("XMLDATALINK", linkAndXml(XMLDATA,bylaw));
					
					commonDao.update("bylawSql.getLawXMLDataUpdate", bylaw);
				} catch (Throwable t) {
					System.out.println(t);
				}
			}
		}
		
		re.put("success", true);
		return re;
	}
	
	public JSONObject ruleDeptData(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		JSONArray jl = new JSONArray();
		List<HashMap> resultList = commonDao.selectList("bylawSql.selectRuleDeptList",mtenMap);
		result.put("total", resultList.size());
		result.put("result", jl.fromObject(resultList));
		
		return result;
	}
	
	public JSONObject ruleDeptInsert(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String deptCds = mtenMap.get("DEPTCDS")==null?"":mtenMap.get("DEPTCDS").toString();
		String[] tmp = deptCds.split("@@");
		commonDao.delete("bylawSql.deleteRuleDept", mtenMap);
		for(int i=0; i<tmp.length; i++){
			mtenMap.put("DEPTCD", tmp[i]);
			commonDao.insert("bylawSql.insertRuleDept",mtenMap);
		}
		result.put("success", true);
		return result;
	}
	
	public JSONObject LawAllData(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		int start = mtenMap.get("start")==null?0:Integer.parseInt(mtenMap.get("start").toString());
		int limit = mtenMap.get("limit")==null?30:Integer.parseInt(mtenMap.get("limit").toString());
		
		String sort = mtenMap.get("sort")==null?"":mtenMap.get("sort").toString();
		String dir = mtenMap.get("dir")==null?"":mtenMap.get("dir").toString();
		String lawgbn = mtenMap.get("lawgbn")==null?"law":mtenMap.get("lawgbn").toString();
		
		String orderby = sort+ " " +dir;  
		if(sort.equals("")||dir.equals("")){
			orderby = "";
		}
		mtenMap.put("orderby", orderby);
		
		List list = new ArrayList();
		if(lawgbn.equals("law")){
			list = commonDao.selectList("bylawSql.lawList", mtenMap);
		}else if(lawgbn.equals("bylaw")){
			list = commonDao.selectList("bylawSql.bylawList", mtenMap);
		}else if(lawgbn.equals("rule")){
			list = commonDao.selectList("bylawSql.ruleList", mtenMap);
		}
		int total = list.size();
		if(total-limit<0){
			limit=total;
		}
		
		JSONArray obl = new JSONArray();
		for(int i=start; i<limit;i++){
			HashMap re = (HashMap)list.get(i);
			JSONObject ob = new JSONObject();
			if(lawgbn.equals("law")){
				ob.put("lawsid", re.get("LAWID"));
				ob.put("lawid", re.get("LAWID"));
				ob.put("lawname", re.get("LAWNAME"));
				ob.put("lawgbn", re.get("LAWGBN"));
				ob.put("promuldt", re.get("PROMULDT"));
				ob.put("revcd", re.get("REVCD"));
				ob.put("plawsid", re.get("PLAWSID"));
				obl.add(ob);	
			}else if(lawgbn.equals("bylaw")){
				ob.put("lawsid", re.get("BYLAWID"));
				ob.put("lawid", re.get("BYLAWNO"));
				ob.put("lawname", re.get("BYLAWNAME"));
				ob.put("lawgbn", re.get("BYLAWCD"));
				ob.put("promuldt", re.get("STARTDT"));
				ob.put("revcd", re.get("BYLAWCD"));
				ob.put("plawsid", re.get("PBYLAWID"));
				obl.add(ob);
			}else{
				ob.put("lawsid", re.get("OBOOKID"));
				ob.put("lawid", re.get("BOOKCODE"));
				ob.put("lawname", re.get("TITLE"));
				ob.put("lawgbn", re.get("BOOKCD"));
				ob.put("promuldt", re.get("PROMULDT"));
				ob.put("revcd", re.get("REVCD"));
				ob.put("plawsid", re.get("BOOKID"));
				obl.add(ob);
			}
		}
		result.put("total", list.size());
		result.put("result", obl);
		return result;
	}
	
	public JSONObject saveRuleTree(Map<String, Object> mtenMap) {
		commonDao.insert("bylawSql.saveRuleTree",mtenMap);
		
		JSONObject obj = new JSONObject();
		obj.put("success", true);
		return obj;
	}
	
	public JSONArray getRuleTree(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("bylawSql.getRuleTree",mtenMap);
		JSONArray jsonArr = new JSONArray();
		for(int i=0; i<list.size(); i++){
			HashMap re = (HashMap)list.get(i);
			JSONObject obj = new JSONObject();
			
			obj.put("id", re.get("TREEID"));
			obj.put("title", re.get("TITLE"));
			obj.put("text", re.get("TITLE"));
			obj.put("docid", re.get("DOCID"));
			obj.put("docgbn", re.get("DOCGBN"));
			obj.put("linkgbn", re.get("LINKGBN"));
			obj.put("mdocid", re.get("MDOCID"));
			obj.put("MENU_IMG_NM", "file");
			obj.put("leaf", false);
			jsonArr.add(obj);
		}
		
		return jsonArr;
	}
	
	public JSONObject delRuleTree(Map<String, Object> mtenMap) {
		int chk = commonDao.selectOne("bylawSql.chkRuleTree", mtenMap);
		JSONObject obj = new JSONObject();
		if(chk==0){
			commonDao.delete("bylawSql.delRuleTree",mtenMap);
			obj.put("success", true);
		}else{
			obj.put("faire", true);
		}
		
		return obj;
	}
	
	public JSONObject updateRuleTree(Map<String, Object> mtenMap){
		
		HashMap nodeInfo = commonDao.selectOne("bylawSql.moveNode", mtenMap);
		if(nodeInfo!=null){
			commonDao.update("bylawSql.updateRuleTreeOrd",nodeInfo);
			mtenMap.put("ord", nodeInfo.get("ORD"));
		}else{
			mtenMap.put("ord", "");
		}
		
		commonDao.update("bylawSql.updateRuleTree",mtenMap);
		
		JSONObject obj = new JSONObject();
		obj.put("success", true);
		return obj;
	}
	
	public JSONObject chkCatruleList(Map<String, Object> mtenMap) {
		int chk = commonDao.selectOne("bylawSql.chkCatruleList",mtenMap);
		JSONObject jo = new JSONObject();
		jo.put("data", chk);
		return jo;
	}
	
	public JSONArray getDept(Map<String, Object> mtenMap) {
		List dl = commonDao.selectList("userSql.setDeptList", mtenMap);
		JSONArray jl = new JSONArray();
		for(int i=0; i<dl.size(); i++) {
			HashMap result = (HashMap)dl.get(i);
			JSONObject obj = new JSONObject();
			obj.put("id", result.get("DEPT"));
			obj.put("title", result.get("DEPTNAME"));
			obj.put("text", result.get("DEPTNAME"));
			obj.put("MENU_IMG_NM", "file");
			obj.put("leaf", true);
			jl.add(obj);
		}
		return jl;
	}
	
	public JSONObject getCatruleInsert(Map<String, Object> mtenMap) {
		int chk = commonDao.selectOne("bylawSql.chkCatruleList", mtenMap);
		
		String id = "";
		if(chk==0){
			commonDao.insert("bylawSql.getCatruleInsert",mtenMap);
			id = mtenMap.get("catruleid")==null?"0":mtenMap.get("catruleid").toString();
		}else{
			id="0";
		}
		
		JSONObject result = new JSONObject();
		result.put("data", id);
		return result;
	}
	
	public JSONObject getCatruleList(Map<String, Object> mtenMap) {
		List cl = commonDao.selectList("bylawSql.getCatruleList", mtenMap);
		JSONArray jl = JSONArray.fromObject(cl);
		JSONObject result = new JSONObject();
		result.put("data", jl);
		return result;
	}
	
	public JSONObject getCatruleDelete(Map<String, Object> mtenMap) {
		int chk = commonDao.delete("bylawSql.getCatruleDelete", mtenMap);
		JSONObject result = new JSONObject();
		result.put("data", chk);
		return result;
	}
	
	public List etcLinkSelect2(HashMap para) {
		return commonDao.selectList("bylawSql.etcLinkSelect2",para);
	}
	
	public List selectDocList() {
		return commonDao.selectList("bylawSql.selectDocList");
	}
	
	public JSONArray getJoMunList(Map<String, Object> mtenMap) {
		String docgbn = mtenMap.get("docgbn")==null?"":mtenMap.get("docgbn").toString();
		JSONArray jl = new JSONArray();
		if(docgbn.equals("RULE")){
			HashMap bookInfo = commonDao.selectOne("bylawSql.selectBon", mtenMap);
			String xmldata = bookInfo.get("XMLDATA").toString();
			try {
				ByteArrayInputStream is = new ByteArrayInputStream(xmldata.getBytes("utf-8"));
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				factory.setNamespaceAware(true); // never forget this!
				DocumentBuilder builder = factory.newDocumentBuilder();
				org.w3c.dom.Document doc = builder.parse(is);// (new// StringReader(bylaw.getXmldata()));
				XPathFactory factory2 = XPathFactory.newInstance();
				XPath xpath = factory2.newXPath();
				
				XPathExpression expr = xpath.compile("/law/bon//jo[@endcha='9999']");
				Object result = expr.evaluate(doc, XPathConstants.NODESET);
				NodeList node = (NodeList) result;
				for (int j = 0; j < node.getLength(); j++) {
					JSONObject jre = new JSONObject();
					jre.put("no", j);
					jre.put("contid", ((org.w3c.dom.Element) node.item(j)).getAttribute("contid"));
					jre.put("jono", ((org.w3c.dom.Element) node.item(j)).getAttribute("contno"));
					jre.put("subjono", ((org.w3c.dom.Element) node.item(j)).getAttribute("contsubno"));
					jre.put("title", ((org.w3c.dom.Element) node.item(j)).getAttribute("title"));
					jl.add(jre);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(docgbn.equals("LAW")){
			/*LawBon lawBon =  lawDao.getLawBon(para.getBookid());
			try {
				ByteArrayInputStream is = new ByteArrayInputStream(lawBon.getLawbon().getBytes("UTF-8"));
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				factory.setNamespaceAware(true); // never forget this!
				DocumentBuilder builder = factory.newDocumentBuilder();
				org.w3c.dom.Document doc = builder.parse(is);// (new// StringReader(bylaw.getXmldata()));
				XPathFactory factory2 = XPathFactory.newInstance();
				XPath xpath = factory2.newXPath();
				
				XPathExpression expr = xpath.compile("//조문단위");
				Object result = expr.evaluate(doc, XPathConstants.NODESET);
				NodeList node = (NodeList) result;
				for (int j = 0; j < node.getLength(); j++) {
					Node Mnode = node.item(j);
					
					NodeList snode = node.item(j).getChildNodes();
					boolean jtype = false;
					for(int i=0; i<snode.getLength(); i++){
						Node stype1 = snode.item(i);
						System.out.println("stype1.getNodeValue(1)==>"+stype1);
						if(stype1.getNodeName().equals("조문여부")){
							System.out.println("stype1.getNodeValue(2)==>"+stype1.getNodeValue());
							System.out.println("stype1.getNodeValue(3)==>"+((org.w3c.dom.Element) snode.item(i)).getTextContent());
							
							if(((org.w3c.dom.Element) snode.item(i)).getTextContent().equals("조문")){
								jtype = true;
							}
						}
					}
					if(jtype){
						JSONObject jre = new JSONObject();
						jre.put("no", j);
						for(int i=0; i<snode.getLength(); i++){
							Node stype1 = snode.item(i);
							if(stype1.getNodeName().equals("조문제목")){
								jre.put("title", ((org.w3c.dom.Element) snode.item(i)).getTextContent());
							}
							if(stype1.getNodeName().equals("조문번호")){
								jre.put("jono", ((org.w3c.dom.Element) snode.item(i)).getTextContent());
							}
							if(stype1.getNodeName().equals("조문가지번호")){
								jre.put("subjono", ((org.w3c.dom.Element) snode.item(i)).getTextContent());
							}
							
						}
						jre.put("contid", ((org.w3c.dom.Element) node.item(j)).getAttribute("조문키"));
						System.out.println(jre);
						if(jre.get("subjono")==null){
							jre.put("subjono", "0");
						}
						jl.add(jre);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			*/
		}else if(docgbn.equals("BYLAW")){
			//LawBon lawBon =  lawDao.getByLawBon(para.getBookid());
		}
		
		return jl;
	}
	
	public JSONObject ectLinkInsert(Map<String, Object> mtenMap) {
		commonDao.insert("bylawSql.ectLinkInsert", mtenMap);
		JSONObject result = new JSONObject();
		result.put("data", "");
		return result;
	}
	
	public String ContfileUpload(MultipartHttpServletRequest multipartRequest , Map<String, Object> mtenMap) {
		Iterator<String> itr = multipartRequest.getFileNames();
		while (itr.hasNext()) { // 받은 파일들을 모두 돌린다.
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			String fileid = commonDao.select("commonSql.getSeq");
			String originalFilename = mpf.getOriginalFilename();
			String ext = originalFilename.substring(originalFilename.lastIndexOf("."), originalFilename.length());
			String fileFullPath = "";
			try {
				fileFullPath = MakeHan.File_url("LAW") + "/" + fileid+ext;
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			try {
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
				if(pchk) {
					mtenMap.put("FILEID", fileid);
					mtenMap.put("PCFILENAME", originalFilename);
					mtenMap.put("SERVERFILE", fileid+ext);
					mtenMap.put("FILETYPE", ext);
					mtenMap.put("FILECD", "CONT");
					
					commonDao.insert("bylawSql.lawfileInsert",mtenMap);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "";
	}
	
	public JSONArray selectContFile(Map<String, Object> mtenMap) {
		JSONArray jl = new JSONArray();
		List cl = commonDao.selectList("bylawSql.selectContFile", mtenMap);
		jl = JSONArray.fromObject(cl);
		return jl;
	}
	
	public JSONObject moveNode(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		/*job: job,
		catId: catId,
		pCatId: pCatId,
		catIds: catIds,
		ord: ord,
		useYn: useYn	*/
				
		String job = mtenMap.get("job")==null?"":mtenMap.get("job").toString();
		if(job.equals("moveAppend")) {
			commonDao.update("bylawSql.updateAppandNode",mtenMap);
		}else{
			commonDao.update("bylawSql.updateReorderNode1",mtenMap);
			commonDao.update("bylawSql.updateReorderNode2",mtenMap);
		}
				
		result.put("success", true);
		return result;
	}
	
	public JSONObject docInfoUpdate(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.update("bylawSql.docInfoUpdate",mtenMap);
				
		result.put("success", true);
		return result;
	}
}


