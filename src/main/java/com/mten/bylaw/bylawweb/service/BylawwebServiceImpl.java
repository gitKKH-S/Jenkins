package com.mten.bylaw.bylawweb.service;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;

import javax.annotation.Resource;
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
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.mten.dao.CommonDao;
import com.mten.util.MakeHan;
import com.mten.util.ZipUtil2;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Service("bylawwebService")
public class BylawwebServiceImpl implements BylawwebService {
	protected final static Logger logger = Logger.getLogger( BylawwebServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;

	public JSONArray getTreeNode(Map mtenMap) {
		List nodeList = commonDao.selectList("bylawwebSql.getTreeNode",mtenMap);
		JSONArray jl = new JSONArray();
		for (int i = 0; i < nodeList.size(); i++) {
			Map tmpBean = (Map) nodeList.get(i);
			int catId = tmpBean.get("CATID")==null?0:Integer.parseInt(tmpBean.get("CATID").toString());
			String title = tmpBean.get("TITLE")==null?"":tmpBean.get("TITLE").toString().replace(":", "").replace("\n", "").replace("\r", "").replace(",", "").replace("\"", "").replace("[", "\\[").replace("]", "\\]").replace("{", "").replace("}", "");
			String catCd = tmpBean.get("CATCD")==null?"":tmpBean.get("CATCD").toString();
			String useYn = tmpBean.get("USEYN")==null?"":tmpBean.get("USEYN").toString();
			int ord = tmpBean.get("ORD")==null?0:Integer.parseInt(tmpBean.get("ORD").toString());
			int bookId = tmpBean.get("BOOKID")==null?0:Integer.parseInt(tmpBean.get("BOOKID").toString());
			String noFormYn = tmpBean.get("NOFORMYN")==null?"":tmpBean.get("NOFORMYN").toString();
			int oBookId = tmpBean.get("OBOOKID")==null?0:Integer.parseInt(tmpBean.get("OBOOKID").toString());
			int revCha = tmpBean.get("REVCHA")==null?0:Integer.parseInt(tmpBean.get("REVCHA").toString());
			String promulDt = tmpBean.get("PROMULDT")==null?"":tmpBean.get("PROMULDT").toString();
			String startDt = tmpBean.get("STARTDT")==null?"":tmpBean.get("STARTDT").toString();
			String endDt = tmpBean.get("ENDDT")==null?"":tmpBean.get("ENDDT").toString();
			String revCd = tmpBean.get("REVCD")==null?"":tmpBean.get("REVCD").toString();
			String bStateCd = tmpBean.get("STATECD")==null?"":tmpBean.get("STATECD").toString();
			String Dept = tmpBean.get("DEPTNAME")==null?"":tmpBean.get("DEPTNAME").toString();
			String Deptcd = tmpBean.get("DEPT")==null?"":tmpBean.get("DEPT").toString();
			String statehistoryid = tmpBean.get("STATEHISTORYID")==null?"":tmpBean.get("STATEHISTORYID").toString();
			String stateid = tmpBean.get("STATEID")==null?"":tmpBean.get("STATEID").toString();
			String cls = "";
			boolean leaf = false;
			String bookcd = tmpBean.get("BOOKCD")==null?"":tmpBean.get("BOOKCD").toString();
			//continue;
			if (catCd.equals("folder") && useYn.equals("Y")) {
				cls = "folder";
			} else if (catCd.equals("doc") && useYn.equals("Y")) {
					cls = "file";
					leaf = true;
			} else if (catCd.equals("folder") && useYn.equals("N")) {
				cls = "nuFolder";
			} else if (catCd.equals("doc") && useYn.equals("Y")) {
				cls = "nuFile";
				leaf = true;
			}
			
			JSONObject tj = new JSONObject();
			tj.put("id", catId);
			tj.put("qtip", title);
			tj.put("title", title);
			
			int strSize = 0;
			strSize = title.length();
			if(strSize>25){
				title = title.substring(0, 24);
				title = title+"...";
			}
			
			tj.put("text", title);
			tj.put("MENU_IMG_NM", cls);
			tj.put("leaf", leaf);
			tj.put("statehistoryid", statehistoryid);
			tj.put("catid", catId);
			tj.put("pcatid", mtenMap.get("node"));
			tj.put("catcd", catCd);
			tj.put("useyn", useYn);
			tj.put("stateid", stateid);
			tj.put("bookid", bookId);
			tj.put("bookid2", bookId+noFormYn);
			tj.put("obookid", oBookId);
			tj.put("noformyn", noFormYn);
			tj.put("revcha", revCha);
			tj.put("revcd", revCd);
			tj.put("promuldt",promulDt);
			tj.put("startdt",startDt);
			tj.put("ord",ord);
			tj.put("dept",Dept);
			tj.put("deptcd",Deptcd);
			tj.put("bookcd",bookcd);
			tj.put("enddt",endDt);
			
			jl.add(tj);
				
			
		}
		
		return jl;
	}
	
	public JSONArray getDeptNode(Map mtenMap) {
		String node = mtenMap.get("node")==null?"":mtenMap.get("node").toString();
		List nodeList = new ArrayList();
		if(node.equals("0")) {
			nodeList = commonDao.selectList("bylawwebSql.getDeptNode",mtenMap);
		}else {
			nodeList = commonDao.selectList("bylawwebSql.getDocNode",mtenMap);
		}
		JSONArray jl = new JSONArray();
		for (int i = 0; i < nodeList.size(); i++) {
			Map tmpBean = (Map) nodeList.get(i);
			String id = tmpBean.get("ID")==null?"":tmpBean.get("ID").toString();
			String title = tmpBean.get("TITLE")==null?"":tmpBean.get("TITLE").toString();
			String cls = tmpBean.get("MENU_IMG_NM")==null?"":tmpBean.get("MENU_IMG_NM").toString();
			String obookid = tmpBean.get("OBOOKID")==null?"":tmpBean.get("OBOOKID").toString();
			String catid = tmpBean.get("CATID")==null?"":tmpBean.get("CATID").toString();
			String statehistoryid = tmpBean.get("STATEHISTORYID")==null?"":tmpBean.get("STATEHISTORYID").toString();
			String noformyn = tmpBean.get("NOFORMYN")==null?"":tmpBean.get("NOFORMYN").toString();
			
			boolean leaf = false;
			if (cls.equals("folder")) {
				leaf = false;
			} else if (cls.equals("file")) {
					leaf = true;
			}
			
			JSONObject tj = new JSONObject();
			tj.put("id", id);
			tj.put("qtip", title);
			tj.put("title", title);
			int strSize = 0;
			strSize = title.length();
			if(strSize>25){
				title = title.substring(0, 24);
				title = title+"...";
			}
			tj.put("text", title);
			tj.put("MENU_IMG_NM", cls);
			tj.put("catcd", cls);
			tj.put("leaf", leaf);
			tj.put("statehistoryid", statehistoryid);
			tj.put("catid", catid);
			tj.put("bookid", id);
			tj.put("obookid", obookid);
			tj.put("noformyn", noformyn);
			
			jl.add(tj);
		}
		return jl;
	}
	
	public JSONArray getRecentNode(Map mtenMap){
		List nodeList = commonDao.selectList("bylawwebSql.getDocNode",mtenMap);
		JSONArray jl = new JSONArray();
		for (int i = 0; i < nodeList.size(); i++) {
			Map tmpBean = (Map) nodeList.get(i);
			String id = tmpBean.get("ID")==null?"":tmpBean.get("ID").toString();
			String title = tmpBean.get("TITLE")==null?"":tmpBean.get("TITLE").toString();
			String cls = tmpBean.get("MENU_IMG_NM")==null?"":tmpBean.get("MENU_IMG_NM").toString();
			String obookid = tmpBean.get("OBOOKID")==null?"":tmpBean.get("OBOOKID").toString();
			String catid = tmpBean.get("CATID")==null?"":tmpBean.get("CATID").toString();
			String statehistoryid = tmpBean.get("STATEHISTORYID")==null?"":tmpBean.get("STATEHISTORYID").toString();
			String noformyn = tmpBean.get("NOFORMYN")==null?"":tmpBean.get("NOFORMYN").toString();
			boolean leaf = true;
			
			JSONObject tj = new JSONObject();
			tj.put("id", id);
			tj.put("qtip", title);
			tj.put("title", title);
			
			int strSize = 0;
			strSize = title.length();
			if(strSize>25){
				title = title.substring(0, 24);
				title = title+"...";
			}
			
			tj.put("text", title);
			tj.put("MENU_IMG_NM", cls);
			tj.put("leaf", leaf);
			tj.put("statehistoryid", statehistoryid);
			tj.put("catid", catid);
			tj.put("bookid", id);
			tj.put("noformyn", noformyn);
			
			jl.add(tj);
				
			
		}
		
		return jl;
	}
	
	public JSONArray getFavNode(Map mtenMap){
		List nodeList = commonDao.selectList("bylawwebSql.getTreeNode",mtenMap);
		JSONArray jl = new JSONArray();
		for (int i = 0; i < nodeList.size(); i++) {
			Map tmpBean = (Map) nodeList.get(i);
			int catId = tmpBean.get("CATID")==null?0:Integer.parseInt(tmpBean.get("CATID").toString());
			String title = tmpBean.get("TITLE")==null?"":tmpBean.get("TITLE").toString().replace(":", "").replace("\n", "").replace("\r", "").replace(",", "").replace("\"", "").replace("[", "\\[").replace("]", "\\]").replace("{", "").replace("}", "");
			String catCd = tmpBean.get("CATCD")==null?"":tmpBean.get("CATCD").toString();
			String useYn = tmpBean.get("USEYN")==null?"":tmpBean.get("USEYN").toString();
			int ord = tmpBean.get("ORD")==null?0:Integer.parseInt(tmpBean.get("ORD").toString());
			int bookId = tmpBean.get("BOOKID")==null?0:Integer.parseInt(tmpBean.get("BOOKID").toString());
			String noFormYn = tmpBean.get("NOFORMYN")==null?"":tmpBean.get("NOFORMYN").toString();
			int oBookId = tmpBean.get("OBOOKID")==null?0:Integer.parseInt(tmpBean.get("OBOOKID").toString());
			int revCha = tmpBean.get("REVCHA")==null?0:Integer.parseInt(tmpBean.get("REVCHA").toString());
			String promulDt = tmpBean.get("PROMULDT")==null?"":tmpBean.get("PROMULDT").toString();
			String startDt = tmpBean.get("STARTDT")==null?"":tmpBean.get("STARTDT").toString();
			String endDt = tmpBean.get("ENDDT")==null?"":tmpBean.get("ENDDT").toString();
			String revCd = tmpBean.get("REVCD")==null?"":tmpBean.get("REVCD").toString();
			String bStateCd = tmpBean.get("STATECD")==null?"":tmpBean.get("STATECD").toString();
			String Dept = tmpBean.get("DEPTNAME")==null?"":tmpBean.get("DEPTNAME").toString();
			String Deptcd = tmpBean.get("DEPT")==null?"":tmpBean.get("DEPT").toString();
			String statehistoryid = tmpBean.get("STATEHISTORYID")==null?"":tmpBean.get("STATEHISTORYID").toString();
			String stateid = tmpBean.get("STATEID")==null?"":tmpBean.get("STATEID").toString();
			String cls = "file";
			boolean leaf = true;
			String bookcd = tmpBean.get("BOOKCD")==null?"":tmpBean.get("BOOKCD").toString();
			
			JSONObject tj = new JSONObject();
			tj.put("id", catId);
			tj.put("qtip", title);
			tj.put("title", title);
			
			int strSize = 0;
			strSize = title.length();
			if(strSize>25){
				title = title.substring(0, 24);
				title = title+"...";
			}
			
			tj.put("text", title);
			tj.put("MENU_IMG_NM", cls);
			tj.put("leaf", leaf);
			tj.put("statehistoryid", statehistoryid);
			tj.put("catid", catId);
			tj.put("pcatid", mtenMap.get("node"));
			tj.put("catcd", catCd);
			tj.put("useyn", useYn);
			tj.put("stateid", stateid);
			tj.put("bookid", bookId);
			tj.put("bookid2", bookId+noFormYn);
			tj.put("obookid", oBookId);
			tj.put("noformyn", noFormYn);
			tj.put("revcha", revCha);
			tj.put("revcd", revCd);
			tj.put("promuldt",promulDt);
			tj.put("startdt",startDt);
			tj.put("ord",ord);
			tj.put("dept",Dept);
			tj.put("deptcd",Deptcd);
			tj.put("bookcd",bookcd);
			tj.put("enddt",endDt);
			
			jl.add(tj);
				
			
		}
		
		return jl;
	}
	
	public JSONObject regulationListData(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("bylawwebSql.getByLawList", mtenMap);
		int cnt = commonDao.select("bylawwebSql.getByLawListCnt", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public HashMap regulationView(Map mtenMap) {
		HashMap bookInfo = commonDao.select("bylawwebSql.getBookInfo", mtenMap);
		mtenMap.put("obookid", bookInfo.get("OBOOKID"));
		mtenMap.put("statecd", bookInfo.get("STATECD"));
		String docPath = commonDao.select("bylawwebSql.getDocpath", mtenMap);
		String allrevcha = "0";
		
		mtenMap.put("revcha", bookInfo.get("REVCHA"));
		mtenMap.put("revcd", "전부개정");
		allrevcha = commonDao.select("bylawSql.GetAllRevCha",mtenMap);
		
		String xmlData = bookInfo.get("XMLDATALINK")==null?"":bookInfo.get("XMLDATALINK").toString();
		
		
		xmlData = MakeHan.setCircleNum(xmlData, "READ");
		xmlData = xmlData.replaceAll("&lt;a5b5 /&gt;", "<a5b5 />").replaceAll("&lt;a5b5", "<a5b5");
		String selectBox = "제"+bookInfo.get("REVCHA")+"차 "+bookInfo.get("REVCD")+" ("+bookInfo.get("PROMULDT")+")";
		
		List history = commonDao.selectList("bylawSql.getHistoryItem", mtenMap);

		mtenMap.put("docgbn", "RULE");
		String fav = commonDao.select("bylawwebSql.getFav", mtenMap);
		
		HashMap result = new HashMap();
		result.put("docPath", docPath);
		result.put("bookInfo", bookInfo);
		result.put("param", mtenMap);
		result.put("history", history);
		result.put("fav", fav);
		String DAN = commonDao.selectOne("bylawwebSql.getDan", mtenMap);
		if(DAN==null) {
			DAN="";
		}
		result.put("DAN", DAN);
		
		HashMap treecnt = commonDao.selectOne("bylawwebSql.chkRuleTree",mtenMap);
		result.put("treecnt", treecnt);
		try {
			String vtype = mtenMap.get("vtype")==null?"":mtenMap.get("vtype").toString();
			String printyn = mtenMap.get("printyn")==null?"":mtenMap.get("printyn").toString();
			if(!vtype.equals("TOTAL")) {
				String xslPath = MakeHan.File_url("XSL");
				String xslName = "appBonUser.xsl";
				String xslUrl = xslPath + xslName;
				File xsl = new File(xslUrl);

				StringWriter stringWriter = new StringWriter();
				StreamSource xml = new StreamSource(new StringReader(xmlData),"utf-8");
				
				TransformerFactory tFactory = TransformerFactory.newInstance();
				Transformer transformer = null;
				transformer = tFactory.newTransformer(new StreamSource(xsl));
			 	transformer.setParameter("bookid",bookInfo.get("BOOKID"));
				transformer.setParameter("revcha",bookInfo.get("REVCHA").toString());
				transformer.setParameter("schtxt",mtenMap.get("Schtxt")==null?"":mtenMap.get("Schtxt"));
				transformer.setParameter("Obookid",bookInfo.get("OBOOKID"));
				transformer.setParameter("Topcont",bookInfo.get("JENMUN")==null?"":bookInfo.get("JENMUN").toString().replaceAll("\n", "<br/>"));
				transformer.setParameter("allcha",allrevcha);
				transformer.setParameter("selectBox",selectBox);
				transformer.setParameter("sysdate",MakeHan.getDate_4());
			 	transformer.transform(xml, new StreamResult(stringWriter));
			 	result.put("bon", stringWriter.toString().replaceAll("&amp;", "&"));
			 	
			 	
			 	xslName = "sub_topUser.xsl";
				xslUrl = xslPath + xslName;
				stringWriter = new StringWriter();
				tFactory = TransformerFactory.newInstance();
				xsl = new File(xslUrl);
				xml = new StreamSource(new StringReader(xmlData));
				transformer = tFactory.newTransformer(new StreamSource(xsl));
			 	transformer.setParameter("bookid",bookInfo.get("OBOOKID"));
				transformer.setParameter("revcha",bookInfo.get("REVCHA").toString());
			 	transformer.transform(xml, new StreamResult(stringWriter));
			 	result.put("rbon", stringWriter.toString());
				
				xslName = "sub_bottom.xsl";
				xslUrl = xslPath + xslName;
				stringWriter = new StringWriter();
				tFactory = TransformerFactory.newInstance();
				xsl = new File(xslUrl);
				xml = new StreamSource(new StringReader(xmlData));
				transformer = tFactory.newTransformer(new StreamSource(xsl));
			 	transformer.setParameter("bookid",bookInfo.get("OBOOKID"));
				transformer.setParameter("revcha",bookInfo.get("REVCHA").toString());
			 	transformer.transform(xml, new StreamResult(stringWriter));
			 	result.put("rbbon", stringWriter.toString());
			}else if(vtype.equals("TOTAL")){
				String xslPath = MakeHan.File_url("XSL");
				String xslName = "together.xsl";
				if(printyn.equals("Y")) {
					xslName = "togetherprint.xsl";
				}
				String xslUrl = xslPath + xslName;
				File xsl = new File(xslUrl);

				StringWriter stringWriter = new StringWriter();
				StreamSource xml = new StreamSource(new StringReader(xmlData),"utf-8");
				
				TransformerFactory tFactory = TransformerFactory.newInstance();
				Transformer transformer = null;
				transformer = tFactory.newTransformer(new StreamSource(xsl));
			 	transformer.setParameter("bookid",bookInfo.get("BOOKID"));
				transformer.setParameter("revcha",bookInfo.get("REVCHA").toString());
				transformer.setParameter("selectBox",selectBox);
			 	transformer.transform(xml, new StreamResult(stringWriter));
			 	result.put("bon", stringWriter.toString());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public HashMap regulationNoFormView(Map mtenMap) {
		HashMap bookInfo = commonDao.select("bylawwebSql.getBookInfo", mtenMap);
		mtenMap.put("BOOKID", bookInfo.get("BOOKID"));
		mtenMap.put("obookid", bookInfo.get("OBOOKID"));
		mtenMap.put("statecd", bookInfo.get("STATECD"));
		String docPath = commonDao.select("bylawwebSql.getDocpath", mtenMap);
		
		String selectBox = "제"+bookInfo.get("REVCHA")+"차 "+bookInfo.get("REVCD")+" ("+bookInfo.get("PROMULDT")+")";
		
		List history = commonDao.selectList("bylawSql.getHistoryItem", mtenMap);

		mtenMap.put("docgbn", "RULE");
		String fav = commonDao.select("bylawwebSql.getFav", mtenMap);
		String DAN = commonDao.selectOne("bylawwebSql.getDan", mtenMap);
		if(DAN==null) {
			DAN="";
		}
		
		List flist = commonDao.selectList("bylawSql.lawfileSelect",mtenMap);
		
		HashMap treecnt = commonDao.selectOne("bylawwebSql.chkRuleTree",mtenMap);
		
		HashMap result = new HashMap();
		result.put("docPath", docPath);
		result.put("bookInfo", bookInfo);
		result.put("param", mtenMap);
		result.put("history", history);
		result.put("fav", fav);
		result.put("DAN", DAN);
		result.put("treecnt", treecnt);
		result.put("flist", flist);
		return result;
	}
	
	public JSONObject setFav(Map mtenMap) {
		JSONObject result = new JSONObject();
		String favcnt = mtenMap.get("favcnt")==null?"0":mtenMap.get("favcnt").toString();
		
		if(favcnt.equals("0")) {
			if(mtenMap.get("obookid[]")!=null){
				if(mtenMap.get("obookid[]").getClass().equals(String.class)){
					if(mtenMap.get("obookid[]") != null && !mtenMap.get("obookid[]").toString().equals("")){
						mtenMap.put("obookid", mtenMap.get("obookid[]"));
						commonDao.insert("insertFav", mtenMap);
						result.put("msg", "즐겨찾기에 등록 되었습니다.");
						result.put("gbn", "I");
					}
						
				}else{
					ArrayList delfile = mtenMap.get("obookid[]")==null?new ArrayList():(ArrayList)mtenMap.get("obookid[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("obookid", delfile.get(i));
							commonDao.insert("insertFav", mtenMap);
							result.put("msg", "즐겨찾기에 등록 되었습니다.");
							result.put("gbn", "I");
						}
					}
				}
			}else {
				commonDao.insert("insertFav", mtenMap);
				result.put("msg", "즐겨찾기에 등록 되었습니다.");
				result.put("gbn", "I");
			}
		}else {
			if(mtenMap.get("obookid[]")!=null){
				if(mtenMap.get("obookid[]").getClass().equals(String.class)){
					if(mtenMap.get("obookid[]") != null && !mtenMap.get("obookid[]").toString().equals("")){
						mtenMap.put("obookid", mtenMap.get("obookid[]"));
						commonDao.delete("deleteFav", mtenMap);
						result.put("msg", "즐겨찾기가 삭제 되었습니다.");
						result.put("gbn", "D");
					}
						
				}else{
					ArrayList delfile = mtenMap.get("obookid[]")==null?new ArrayList():(ArrayList)mtenMap.get("obookid[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("obookid", delfile.get(i));
							commonDao.delete("deleteFav", mtenMap);
							result.put("msg", "즐겨찾기가 삭제 되었습니다.");
							result.put("gbn", "D");
						}
					}
				}
			}else {
				commonDao.delete("deleteFav", mtenMap);
				result.put("msg", "즐겨찾기가 삭제 되었습니다.");
				result.put("gbn", "D");
			}
		}
		return result;
	}
	
	public HashMap getOldjo(Map mtenMap) {
		HashMap result = new HashMap();
		
		String Bookid = mtenMap.get("Bookid")==null?"":mtenMap.get("Bookid").toString();
		String Bcontid = mtenMap.get("bcontid")==null?"":mtenMap.get("bcontid").toString();
		String Contno = mtenMap.get("Contno")==null?"":mtenMap.get("Contno").toString();
		String Contsubno = mtenMap.get("Contsubno")==null?"":mtenMap.get("Contsubno").toString();
		HashMap bylaw = commonDao.selectOne("bylawSql.selectBon",Bookid);
		result.put("docInfo", bylaw);
		
		String XMLOLDNEWREVISION = bylaw.get("XMLOLDNEWREVISION")==null?"":bylaw.get("XMLOLDNEWREVISION").toString();
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true); // never forget this!
			DocumentBuilder builder = factory.newDocumentBuilder();
			org.w3c.dom.Document doc = builder.parse(new InputSource(new java.io.StringReader(XMLOLDNEWREVISION)));// (new
															// StringReader(bylaw.getXmldata()));
			org.w3c.dom.Element root = doc.createElement("law");
			org.w3c.dom.Element his = doc.createElement("history");
			root.appendChild(his);
			boolean first = true;
			root = this.getOldjo(bylaw, Bcontid, doc, root, Contno,	Contsubno, his, first);

			TransformerFactory factory1 = TransformerFactory.newInstance();
			StringWriter sw = new StringWriter();
			Properties output = new Properties();
			output.setProperty(OutputKeys.ENCODING, "EUC-KR");
			output.setProperty(OutputKeys.INDENT, "yes");
			Transformer transformer = factory1.newTransformer();
			transformer.setOutputProperties(output);
			transformer.transform(new DOMSource(root), new StreamResult(sw));
			
			result.put("xmldata", sw.toString());
		} catch (Exception e) {
			System.out.println("%%%%%%%%%" + e);
		}	
		return result;
	}
	
	public org.w3c.dom.Element getOldjo(HashMap bylaw, String bcontid,Document doc, org.w3c.dom.Element root, String Contno,String Contsubno, org.w3c.dom.Element his, boolean first) {
		try{
	        String linkGbn = "";
	        if(first){
	        	linkGbn = "law/bon//jo[@bcontid='"+ bcontid +"']";
	        }else{
	        	linkGbn = "law/bon//jo[@contid='"+ bcontid +"']";
	        }
	        System.out.println("linkGbn = "+linkGbn);
	        XPathFactory factory2 = XPathFactory.newInstance();
	        XPath xpath = factory2.newXPath();
	        XPathExpression expr = xpath.compile(linkGbn);
	        Object result = expr.evaluate(doc, XPathConstants.NODE);
	        org.w3c.dom.Element set = null;
	        if(result == null){
	        	if(bcontid.equals("0")) return root;
	        	linkGbn = "law/bon//jo[(@contid='"+ bcontid +"' and @startcha='0')]";
	        	factory2 = XPathFactory.newInstance();
	 	        xpath = factory2.newXPath();
	 	        expr = xpath.compile(linkGbn);
	 	        result = expr.evaluate(doc, XPathConstants.NODE);
	 	        Node node = (Node) result;
		        set =(org.w3c.dom.Element)node;
		        root.appendChild(set);	//조연혁 추가
		        
		        //history데이터 가져오기
		        org.w3c.dom.Node tempNode = this.getHistoryXml(bylaw,set.getAttribute("startcha"),doc);
	            his.appendChild(tempNode);	//history 추가
	            
	        	return root;
	        }else{		        
	        	Node node = (Node) result;
		        set =(org.w3c.dom.Element)node;
		        root.appendChild(set);	//조연혁 추가
		        
		        //history데이터 가져오기
		        org.w3c.dom.Node tempNode = this.getHistoryXml(bylaw,set.getAttribute("startcha"),doc);
	            his.appendChild(tempNode);	//history 추가
		        
		        getOldjo(bylaw,set.getAttribute("bcontid"),doc,root,Contno,Contsubno,his,false);
		        return root;
	        }
		}catch(Exception e){ 
			System.out.println("여기니%%%%%"+e);
		}
		return root;
	}
	
	public Node getHistoryXml(HashMap bylaw, String startcha, Document doc) {
		String XMLDATA = bylaw.get("XMLDATA")==null?"":bylaw.get("XMLDATA").toString();
		org.w3c.dom.Node tempNode = null;
		try{
	        String linkGbn = "";
	        
	        //history데이터 가져오기
			DocumentBuilderFactory factory3 = DocumentBuilderFactory.newInstance();
	        factory3.setNamespaceAware(true); // never forget this!
	        DocumentBuilder builder2 = factory3.newDocumentBuilder();
	        org.w3c.dom.Document doc1 = builder2.parse(new InputSource(new StringReader(XMLDATA)));
	        XPathFactory factory2 = XPathFactory.newInstance();
	        XPath xpath = factory2.newXPath();
	        System.out.println("/law/history/hisitem[@revcha='"+startcha+"']");
	        XPathExpression expr = xpath.compile("/law/history/hisitem[@revcha='"+startcha+"']");
	        Object result = expr.evaluate(doc1, XPathConstants.NODE);	
		    Node node2 = (Node)result;
		    StringWriter sw = new StringWriter();
		    TransformerFactory factory1 = TransformerFactory.newInstance();
		    Transformer transformer = factory1.newTransformer();
			transformer.transform(new DOMSource(node2), new StreamResult(sw));
		    org.w3c.dom.Element secondRoot = builder2.parse(new org.xml.sax.InputSource(new StringReader(sw.toString()))).getDocumentElement();
	        tempNode = doc.importNode(secondRoot,true); //true if you want a deep copy
	    	return tempNode;
	     
		}catch(Exception e){ 
			System.out.println("연혁 부문 에러"+e);
		}
		return tempNode;
	}

	public HashMap BookInfo(Map mtenMap) {
		return commonDao.selectOne("bylawSql.selectBon",mtenMap);
	}
	
	public JSONObject historyListSelect(Map mtenMap) {
		JSONObject result = new JSONObject();
		List hlist = commonDao.selectList("bylawSql.getHistory", mtenMap);
		JSONArray jhjson = JSONArray.fromObject(hlist);
		result.put("history", jhjson);
		return result;
	}
	
	public List getDanList(Map mtenMap) {
		List l4 = commonDao.selectList("bylawwebSql.getDanList", mtenMap);
		return l4;
	}
	
	public HashMap AllZip(Map<String, Object> mtenMap){
		HashMap rst = new HashMap();
		String STATEHISTORYID = mtenMap.get("STATEHISTORYID")==null?"":mtenMap.get("STATEHISTORYID").toString();
		String fName = STATEHISTORYID+".zip";
		String sName = "";
		try {
			String path =  MakeHan.File_url("LAW");
			HashMap by = commonDao.selectOne("bylawwebSql.getXMLDATASTATEHISTORY",mtenMap);
			String XMLDATA = by.get("XMLDATA")==null?"":by.get("XMLDATA").toString();
			sName = by.get("TITLE")+".zip";
			
			StringWriter sw = new StringWriter();
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true); // never forget this!
			org.w3c.dom.Document doc = null;
		
			ByteArrayInputStream is = new ByteArrayInputStream(XMLDATA.getBytes("euc-kr"));
			DocumentBuilder builder = factory.newDocumentBuilder();
			doc = builder.parse(is);// (new StringReader(bylaw.getXmldata()));
			String linkGbn = "//byul[@endcha='9999' and @curstate!='delete' and @curstate!='deletemark']";
			System.out.println("linkGbn" + linkGbn);
			XPathFactory factory2 = XPathFactory.newInstance();
			XPath xpath = factory2.newXPath();
			XPathExpression expr = xpath.compile(linkGbn);

			Object result = expr.evaluate(doc, XPathConstants.NODESET);
			NodeList node = (NodeList) result;
			String rootPath = path+STATEHISTORYID+"/";
			
			folddelete(rootPath);
			
			File io = new File(rootPath);
			io.mkdir();
			
			for(int i=0; i<node.getLength(); i++){
				org.w3c.dom.Element byul = (org.w3c.dom.Element) node.item(i);
				String pname = byul.getAttribute("showtitle").replaceAll("<", "").replaceAll(">", "");
				String sname = byul.getAttribute("serverfilename");
				String type = sname.substring(sname.lastIndexOf("."),sname.length());
				System.out.println("pname===>"+pname);
				System.out.println("pname===>"+pname);
				System.out.println("pname===>"+pname);
				System.out.println("pname===>"+pname);
				System.out.println("pname===>"+pname);
				System.out.println("pname===>"+MakeHan.toKorean(pname));
				System.out.println("pname===>"+MakeHan.toKorean_notic(pname));
				System.out.println("pname===>"+MakeHan.toKorean2(pname));
				System.out.println("pname===>"+MakeHan.toDecoding(pname));
				System.out.println("pname===>"+MakeHan.toDecoding2(pname));
				fileCopy(path+sname,path+STATEHISTORYID+"/"+pname+type);
			}
			
			//zip(path+statehistoryid+"/", path+fName);
			//zip2(path+statehistoryid+"/", path+fName);
			zip3(path+STATEHISTORYID+"/", path+fName);
			folddelete(rootPath);
		} catch (Exception e) {
			System.out.println("%%%%%%%%" + e);
		}
		rst.put("fName", fName);
		rst.put("sName", sName);
		return rst;
	}
	void folddelete(String path){
		File io = new File(path);
		if(io.isDirectory()){
			File[] deleteFolderList = io.listFiles();
  			for (int i = 0; i < deleteFolderList.length; i++) { 
  				deleteFolderList[i].delete();  
  			} 
  			io.delete(); 
		}
	}
	void fileCopy(String fileName1, String fileName2) {
		byte b[] = new byte[64];
		FileInputStream fis = null;
		FileOutputStream fos = null;
		try {
			fis = new FileInputStream(fileName1);
			fos = new FileOutputStream(fileName2);
			int i = 0;
			while ((i = fis.read(b)) != -1) {
				fos.write(b, 0, i);
			}
			fos.flush();
			System.out.println("\n>> COPY COMPLETE");
		} catch (FileNotFoundException fnfe) {
			System.out.println(">> 파일을 찾을수 없습니다. \n└> 프로그램을 종료합니다.");
//            System.exit(0);
		} catch (IOException ioe) {
		} finally {
			try {
				if (fis != null)
					fis.close();
				if (fos != null)
					fos.close();
			} catch (Exception e) {
			}
		}
	}
	
	public void zip3(String sourcePath, String output) throws Exception {
		ZipUtil2.setZip(sourcePath, output);
	}
	
	public HashMap getBookInfo2(Map<String, Object> mtenMap) {
		HashMap result = commonDao.selectOne("bylawwebSql.getBookInfo2",mtenMap);
		return result;
	}
	
	public List joFileList(Map mtenMap) {
		List result = commonDao.selectList("bylawwebSql.joFileList",mtenMap);
		return result;
	}
}


