package com.mten.bylaw.law.service;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.springframework.stereotype.Service;
import com.mten.dao.CommonDao;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("lawService")
public class LawServiceImpl implements LawService {
	protected final static Logger logger = Logger.getLogger( LawServiceImpl.class );
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public JSONObject koreaLawListData(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("lawifSql.getLawList", mtenMap);
		int cnt = commonDao.select("lawifSql.getLawListCnt", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public List getLaw3List(HashMap mtenMap) {
		String title = mtenMap.get("LAWNAME")==null?"":mtenMap.get("LAWNAME").toString();
		String title_trim = title.replaceAll(" ", "");
		String mkTitle = "";
		if(title.length()>3){
			if( title_trim.substring(title_trim.length()-3,title_trim.length()).equals("시행령")){
				mkTitle=title_trim.substring(0,title_trim.length());
			}else if( title_trim.substring(title_trim.length()-4,title_trim.length()).equals("시행규칙") ||  title_trim.substring(title_trim.length()-4,title_trim.length()).equals("시행지침")){
				mkTitle=title_trim.substring(0,title_trim.length()-4);
			}else{
				mkTitle=title_trim;
			}
		}
		List dl = commonDao.selectList("lawifSql.getLaw3List",mkTitle);
		return dl;
	}
	
	public HashMap getLawBon(Map<String, Object> mtenMap) {
		HashMap result = new HashMap();
		HashMap lawBon = commonDao.select("lawifSql.getLawBon", mtenMap);
		try {
			/*String title = lawBon.get("LAWNAME")==null?"":lawBon.get("LAWNAME").toString();
			String title_trim = title.replaceAll(" ", "");
			String mkTitle = "";
			if(title.length()>3){
				if( title_trim.substring(title_trim.length()-3,title_trim.length()).equals("시행령")){
					mkTitle=title_trim.substring(0,title_trim.length());
				}else if( title_trim.substring(title_trim.length()-4,title_trim.length()).equals("시행규칙") ||  title_trim.substring(title_trim.length()-4,title_trim.length()).equals("시행지침")){
					mkTitle=title_trim.substring(0,title_trim.length()-4);
				}else{
					mkTitle=title_trim;
				}
			}
			List dl = commonDao.selectList("lawifSql.getLaw3List",mkTitle);
			result.put("DANCHK", dl.size());*/
			result.put("param", lawBon);
			
			/*mtenMap.put("docgbn", "LAW");
			mtenMap.put("obookid", mtenMap.get("LAWID"));
			String fav = commonDao.select("bylawwebSql.getFav", mtenMap);
			result.put("fav", fav);
			
			String xslPath = MakeHan.File_url("XSL");
			String xslName = "lawView.xsl";
			String xslUrl = xslPath + xslName;
			String xmlData = lawBon.get("LAWBON")==null?"":lawBon.get("LAWBON").toString();
			xmlData = xmlData.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("\\<\\%\\(\\.\\*\\?\\)\\%\\>", "");
			StringWriter stringWriter = new StringWriter();
			
			TransformerFactory tFactory = TransformerFactory.newInstance();
			File xsl = new File(xslUrl);
			StreamSource xml = new StreamSource(new StringReader(xmlData));
			Templates template = tFactory.newTemplates(new StreamSource(xsl));
		 	Transformer transformer = template.newTransformer();
		 	transformer.transform(xml, new StreamResult(stringWriter));
		 	result.put("bon", stringWriter.toString());
		 	
		 	xslName = "lawRView.xsl";
			xslUrl = xslPath + xslName;
			stringWriter = new StringWriter();
			tFactory = TransformerFactory.newInstance();
			xsl = new File(xslUrl);
			xml = new StreamSource(new StringReader(xmlData));
			template = tFactory.newTemplates(new StreamSource(xsl));
		 	transformer = template.newTransformer();
		 	transformer.transform(xml, new StreamResult(stringWriter));
		 	result.put("rbon", stringWriter.toString());
			
			xslName = "lawRBView.xsl";
			xslUrl = xslPath + xslName;
			stringWriter = new StringWriter();
			tFactory = TransformerFactory.newInstance();
			xsl = new File(xslUrl);
			xml = new StreamSource(new StringReader(xmlData));
			template = tFactory.newTemplates(new StreamSource(xsl));
		 	transformer = template.newTransformer();
		 	transformer.transform(xml, new StreamResult(stringWriter));
		 	result.put("rbbon", stringWriter.toString());*/
		} catch (Exception e) {
			System.out.println("본문파싱에러");
		}
		
		
		return result;
	}
	
	public JSONObject koreaByLawListData(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("lawifSql.getByLawList", mtenMap);
		int cnt = commonDao.select("lawifSql.getByLawListCnt", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getByLawBon(Map<String, Object> mtenMap) {
		HashMap result = new HashMap();
		HashMap lawBon = commonDao.select("lawifSql.getByLawBon", mtenMap);
		
		TransformerFactory tFactory = TransformerFactory.newInstance();
		try {
			result.put("param", lawBon);
			
			mtenMap.put("docgbn", "BYLAW");
			mtenMap.put("obookid", mtenMap.get("BYLAWID"));
			String fav = commonDao.select("bylawwebSql.getFav", mtenMap);
			result.put("fav", fav);
			
			String xslPath = MakeHan.File_url("XSL");
			String xslName = "lawView.xsl";
			String xslUrl = xslPath + xslName;
			String xmlData = lawBon.get("BYLAWBON")==null?"":lawBon.get("BYLAWBON").toString();
			xmlData = xmlData.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("\\<\\%\\(\\.\\*\\?\\)\\%\\>", "");
			String bylawbon = "";
			SAXBuilder parser = new SAXBuilder();
		 	Document doc = parser.build(new java.io.StringReader(xmlData));
		 	Element root = doc.getRootElement();
		 	Element de = root.getChild("행정규칙기본정보");
		 	Element t1 = de.getChild("행정규칙명");
		 	Element t2 = de.getChild("발령일자");
		 	Element t3 = de.getChild("행정규칙종류");
		 	Element t4 = de.getChild("소관부처명");
		 	Element t5 = de.getChild("발령번호");
		 	Element t6 = de.getChild("제개정구분명");
		 	bylawbon = bylawbon + "<div style='font-size:20px;font-weight:bold;text-align:center;height:25px;margin-top:5px;'>"+t1.getText()+"</div>";
		 	bylawbon = bylawbon + "<br/>";
		 	bylawbon = bylawbon + "<div style='font-size:15px;text-align:right;height:25px;'>";
		 	bylawbon = bylawbon + "[시행"+t2.getText().substring(0, 4)+"."+t2.getText().substring(4, 6)+"."+t2.getText().substring(6, 8)+".]";
		 	bylawbon = bylawbon + "["+t4.getText()+t3.getText()+" "+t5.getText()+", "+t2.getText().substring(0, 4)+"."+t2.getText().substring(4, 6)+"."+t2.getText().substring(6, 8)+". ,"+t6.getText()+"]";
		 	bylawbon = bylawbon + "</div>";
		 	
		 	List jo = root.getChildren("조문내용");
		 	if(jo.size()==0){
		 		Element jo2 = root.getChild("조문");
		 		jo = jo2.getChildren("조문내용");
		 	}
		 	bylawbon = bylawbon + "<br/>";
		 	bylawbon = bylawbon + "<br/>";
		 	for(int i=0; i<jo.size(); i++){
		 		Element sjo = (Element)jo.get(i);
		 		String jBon = sjo.getText();
		 		
		 		String sPattern1 = "^제.*?[편장절관조]";
		 		
		 		String bon[] = jBon.split("\n");
		 		System.out.println("bon===>"+bon.length);
		 		
		 		for(int j=0; j<bon.length; j++){
		 			System.out.println("j==>"+j+"///////"+bon[j].length());
		 			String cont = bon[j];
		 			if(cont.length()!=0){
		 				Pattern pattern = Pattern.compile(sPattern1);
				 		Matcher matcher1 = null;
				 		matcher1 = pattern.matcher(cont.replaceAll(" ", ""));
				 		String align = "left";
				 		if (matcher1.find()) {
							String sValue = "";
							try {// 미스 매치시 오류 발생하므로 빈값을 던져 준다.
								sValue = matcher1.group(); // 제1장
								System.out.println(sValue);
							} catch (NullPointerException e) {
								sValue = "";
							}
							if (cont.indexOf("(") > 0) {
								String jt = cont.substring(0,cont.indexOf(")") + 1);
								
								jt = "<span style='font-size: 15px;color:#06C;font-weight:bold;'><a style='color:#06C;' name='#"+jt+"'>"+jt+"</a></span>";
								cont = cont.substring(cont.indexOf(")") + 1);
								cont = jt + cont;
								
							}else{
								if(sValue.indexOf("조")>-1){
									cont = cont.replaceAll(sValue, "<span style='font-size: 15px;color:#06C;font-weight:bold;'>"+sValue+"</span>");
								}else{
									System.out.println(cont);
									cont = "<span style='font-size:18px;font-weight:bold;'><a name='"+cont+"'>"+cont+"</a></span>";
									align = "center";
								}
								
							}
				 		}
				 		bylawbon = bylawbon + "<pre style='white-space:pre-wrap;text-align:"+align+";padding-left:15px;font-size:15px;'>"+cont+"</pre>";
		 			}
		 		}
		 		
		 		
		 	}
		 	Element bu = root.getChild("부칙");
		 	List bul = bu.getChildren("부칙내용");
		 	for(int i=0; i<bul.size(); i++){
		 		Element bjo = (Element)bul.get(i);
		 		String jBon = bjo.getText();
		 		
		 		String bup = "^부칙.\\<.*\\>";
		 		Pattern pattern = Pattern.compile(bup);
		 		Matcher matcher1 = null;
		 		matcher1 = pattern.matcher(jBon);
		 		if (matcher1.find()) {
		 			System.out.println(matcher1.group());
		 			jBon = jBon.replace(matcher1.group(), "<b style='font-weight:bold;color:#06f;'>"+matcher1.group()+"</b>");
		 		}
		 		
		 		bylawbon = bylawbon + "<br/><pre style='white-space:pre-wrap;text-align:left;padding-left:15px;font-size:15px;'>"+jBon+"</pre>";
		 	}
			
		 	result.put("bon", bylawbon);
			
			
		 	bylawbon = "";
		 	tFactory = TransformerFactory.newInstance();
		 	parser = new SAXBuilder();
		 	doc = parser.build(new java.io.StringReader(xmlData));
		 	root = doc.getRootElement();
		 	jo = root.getChildren("조문내용");
		 	if(jo.size()==0){
		 		Element jo2 = root.getChild("조문");
		 		jo = jo2.getChildren("조문내용");
		 	}
		 	for(int i=0; i<jo.size(); i++){
		 		Element sjo = (Element)jo.get(i);
		 		String jBon = sjo.getText();
		 		
		 		String sPattern1 = "^제.*?[편장절관조]";
		 		Pattern pattern = Pattern.compile(sPattern1);
		 		Matcher matcher1 = null;
		 		matcher1 = pattern.matcher(jBon.replaceAll(" ", ""));
		 		String align = "left";
		 		if (matcher1.find()) {
					String sValue = "";
					try {// 미스 매치시 오류 발생하므로 빈값을 던져 준다.
						sValue = matcher1.group(); // 제1장
						System.out.println(sValue);
					} catch (NullPointerException e) {
						sValue = "";
					}
					if (jBon.indexOf("(") > 0) {
						String jt = jBon.substring(0,jBon.indexOf(")") + 1);
						jBon = "<span style='font-size: 15px;color:#06C;font-weight:bold;'><a style='color:#06C;' href='#"+jt+"'>"+jt+"</a></span>";
					}else{
						if(sValue.indexOf("조")>-1){
							jBon = jBon.replaceAll(sValue, "<span style='font-size: 15px;color:#06C;font-weight:bold;'>"+sValue+"</span>");
						}else{
							jBon = "<span style='font-size:15px;font-weight:bold;'><a href='#"+jBon+"'>"+jBon+"</a></span>";
							align = "left";
						}
						
					}
		 		}
		 		bylawbon = bylawbon + "<div style='text-align:"+align+";padding:2px'>"+jBon.replaceAll("\\n", "<br/>")+"</div>";
		 	}
		 	bu = root.getChild("부칙");
		 	bul = bu.getChildren("부칙내용");
		 	for(int i=0; i<bul.size(); i++){
		 		Element bjo = (Element)bul.get(i);
		 		String jBon = bjo.getText();
		 		bylawbon = bylawbon + "<div style='text-align:left;padding:5px'>"+jBon.substring(0,jBon.replaceAll("\\n", "<br/>").indexOf("<br/>") + 1)+"</div>";
		 	}
		 	result.put("rbon", bylawbon);
		 	
		 	bylawbon = "";
		 	tFactory = TransformerFactory.newInstance();
			parser = new SAXBuilder();
		 	doc = parser.build(new java.io.StringReader(xmlData));
		 	root = doc.getRootElement();
		 	Element bb = root.getChild("별표");
		 	if(bb != null){
			 	jo = bb.getChildren("별표단위");
			 	for(int i=0; i<jo.size(); i++){
			 		Element sjo = (Element)jo.get(i);
			 		List byuls = sjo.getChildren();
			 		String tit = "";
					String bcd = "";
					String bkey = sjo.getAttributeValue("별표키");
					String fN = "";
			 		for(int k=0; k<byuls.size(); k++){
			 			Element byul = (Element)byuls.get(k);
			 			if(byul.getName().equals("별표번호")){
			 				String cc = byul.getText();
			 				for(int h=0; h<cc.length(); h++){
			 					if(!cc.substring(h,h+1).equals("0")){
			 						cc = cc.substring(h,h+1);
			 						break;
			 					}
			 				}
			 				tit = "[" +tit + cc;
			 			}
			 			if(byul.getName().equals("별표가지번호")){
			 				if(!byul.getText().equals("00"))
			 				tit = tit +" - "+ byul.getText();
			 			}
			 			if(byul.getName().equals("별표구분")){
			 				tit = tit + byul.getText()+"] ";
							bcd = byul.getText();
			 			}
			 			if(byul.getName().equals("별표제목")){
			 				tit = tit + byul.getText();
			 			}
			 			if(byul.getName().equals("별표서식파일링크")){
							String fName = byul.getText().trim();
							String fnms[] = fName.split("flSeq=");
							fN = fnms[1];
						}
			 		}
			 		bylawbon = bylawbon + "<div style='text-align:left;padding:2px;cursor:pointer;' onclick='goDownLoad(\""+fN+"\",\""+bcd+"\")'>"+tit+"</div>";
			 	}
		 	}	
		 	
			////////////////202002 신규추가
		 	Element bb2 = root.getChild("첨부파일");
		 	if(bb2 != null){
		 		bylawbon = bylawbon + "<div style='text-align:left;padding:2px;'>[첨부파일]</div>";
			 	jo = bb2.getChildren();
			 	String tit = "";
			 	for(int i=0; i<jo.size(); i++){
			 		Element sjo = (Element)jo.get(i);
					if(sjo.getName().equals(("첨부파일명"))){
						tit = sjo.getText();
					}
					if(sjo.getName().equals(("첨부파일링크"))){
						String fName = sjo.getText().trim();
						String fnms[] = fName.split("flSeq=");
						String fN = fnms[1];
						if(tit.indexOf("hwp")>-1||tit.indexOf("HWP")>-1){
							bylawbon = bylawbon + "<div style='text-align:left;padding:2px;cursor:pointer;' onclick='goDownLoad(\""+fN+"\",\""+"aa"+"\")'>"+tit+"</div>";
						}else{
							String ext = tit.substring(tit.indexOf("."));
							ext= ext.trim();
							System.out.println("ext===>"+ext);
							bylawbon = bylawbon + "<div style='text-align:left;padding:2px;cursor:pointer;' onclick='goDownLoad2(\""+fN+ext+"\",\""+(tit.trim())+"\")'>"+tit+"</div>";
						}
					}
			 	}
		 	}	
		 	result.put("rbbon", bylawbon);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return result;
	}
	
	public JSONObject getData(Map<String, Object> mtenMap) {
		String lawgbn = mtenMap.get("lawgbn")==null?"":mtenMap.get("lawgbn").toString();
		List llist = new ArrayList();
		int cnt = 0;
		if(lawgbn.equals("LAW")) {
			llist = commonDao.selectList("lawifSql.getLawList", mtenMap);
			cnt = commonDao.select("lawifSql.getLawListCnt", mtenMap);
		}else {
			llist = commonDao.selectList("lawifSql.getByLawList", mtenMap);
			for(int i=0; i<llist.size(); i++) {
				HashMap lre = (HashMap)llist.get(i);
				lre.put("LAWSID", lre.get("BYLAWNO"));
				lre.put("LAWID", lre.get("BYLAWID"));
				lre.put("LAWNAME", lre.get("BYLAWNAME"));
				lre.put("PROMULDT", lre.get("STARTDT"));
				lre.put("REVCD", lre.get("REVCD"));
				lre.put("PLAWSID", lre.get("PBYLAWID"));
			}
			cnt = commonDao.select("lawifSql.getByLawListCnt", mtenMap);
		}
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", cnt);
		result.put("result", jr);
		
		return result;
	}
	
	public JSONObject getMenuData(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("lawifSql.getWebLawList", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", llist.size());
		result.put("result", jr);
		
		return result;
	}
	
	public void insertMapping(Map<String, Object> mtenMap) {
		mtenMap.put("mappingid", commonDao.select("commonSql.getSeq"));
		commonDao.selectList("lawifSql.insertMapping", mtenMap);
	}
	
	public void deleteMapping(Map<String, Object> mtenMap) {
		commonDao.selectList("lawifSql.deleteMapping", mtenMap);
	}
	
	public void updateMapping(Map<String, Object> mtenMap) {
		commonDao.selectList("lawifSql.updateMapping", mtenMap);
	}
	
	public JSONObject etcListData(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("lawifSql.getWebLawList", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", llist.size());
		result.put("result", jr);
		
		return result;
	}
	
	public JSONObject favListData(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("lawifSql.getfavLawList", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", llist.size());
		result.put("result", jr);
		
		return result;
	}
	
	public JSONObject schlawList(Map<String, Object> mtenMap,HttpServletRequest req) {
		JSONObject result = new JSONObject();
		
		List list = commonDao.selectList("lawifSql.schlawList",mtenMap);
		JSONArray slist = JSONArray.fromObject(list);
		result.put("slist", slist);
		
		return result;
	}
}
