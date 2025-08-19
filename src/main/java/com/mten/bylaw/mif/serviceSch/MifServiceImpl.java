package com.mten.bylaw.mif.serviceSch;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.springframework.stereotype.Service;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.json.simple.parser.JSONParser;

import com.mten.dao.CommonDao;
import com.mten.dao.InsaDao;
import com.mten.dao.OldDao;
import com.mten.dao.SmsDao;
import com.mten.email.SendMail;
import com.mten.util.MakeHan;
import com.mten.util.SMSClientSend;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Service("mifService")
public class MifServiceImpl implements MifService {

	protected final static Logger logger = Logger.getLogger(MifServiceImpl.class);

	@Resource(name = "commonDao")
	private CommonDao commonDao;

	@Resource(name="insaDao")
	private InsaDao insaDao;
	
	@Resource(name="smsDao")
	private SmsDao smsDao;
	
	//@Resource(name="oldDao")
	//private OldDao oldDao;
	
	ResourceBundle bundle 		= 	ResourceBundle.getBundle("egovframework.property.url"); 
	public String LAWURL 		= 	bundle.getString("mten.LAWURL")==null?"":(String)bundle.getString("mten.LAWURL");

	private String OC = "kyugwan"; // 기업코드
	private String target = "law"; // 타겟
	private String display = "100"; // 검색결과 갯수
	private String Server = LAWURL+"DRF/lawSearch.do?";
	private String mServer = LAWURL;
	private String sUrl = LAWURL;

	private String outServer = "http://10.50.64.16:9500/mif/law.do";
	private String outServer2 = "http://10.50.64.16:9500/mif/lawBon.do";
	private String outServer2_1 = "http://10.50.64.16:9500/mif/bylawBon.do";
	private String outServer3 = "http://10.50.64.16:9500/dataFile/klaw/";
	private String outServer3_1 = "http://10.50.64.16:9500/dataFile/blaw/";
	private String outServerLawImg = "http://10.50.64.16:9500/mif/getLawImg.do";
	private String outServerByLawImg = "http://10.50.64.16:9500/mif/getByLawImg.do";
	private String getfilename = "http://10.50.64.16:9500/mif/getFileName.do";

	private boolean ifBon = false;
	
	public void blog(HashMap logparam) {
		//commonDao.insert("commonSql.schlogInsert", logparam);
	}

	public String getUrlXml(String Url) {
		URL url = null;
		URLConnection connection = null;
		String strXML = new String(); // xml내용 저장하기 위한 변수
		try {
			url = new URL(Url); // URL 세팅
			connection = url.openConnection(); // 접속
			BufferedReader rd = new BufferedReader(new InputStreamReader(connection.getInputStream(), "utf-8"));
			StringBuffer sb = new StringBuffer();
			int BUFFER_SIZE = 1024;
			char[] buffer = new char[BUFFER_SIZE]; // or some other size,
			int charsRead = 0;
			while ((charsRead = rd.read(buffer, 0, BUFFER_SIZE)) != -1) {
				sb.append(buffer, 0, charsRead);
			}
			strXML = sb.toString().replaceAll("<개정문>[\\s\\S]*?</개정문>", "").replaceAll("<제개정이유>[\\s\\S]*?</제개정이유>", "")
					.replaceAll("<별표내용[\\s\\S]*?</별표내용>", "");
			System.out.println(
					"=====================================================================================================");
			System.out.println(
					"=====================================================================================================");
			System.out.println(
					"=====================================================================================================");
			System.out.println(strXML);
			System.out.println(
					"=====================================================================================================");
			System.out.println(
					"=====================================================================================================");
			System.out.println(
					"=====================================================================================================");
			System.out.println(
					"=====================================================================================================");
			rd.close();

		} catch (MalformedURLException mue) {
			System.out.println(mue);
		} catch (IOException ioe) {
			System.out.println(ioe);
			ioe.printStackTrace();
		}
		return strXML;
	}

	public String getUrlXml_in(String sUrl, String Url, String sLawId) {
		URL url = null;
		URLConnection connection = null;
		InputStream is = null;
		InputStreamReader isr = null;
		BufferedReader br = null;
		String strXML = new String(); // xml내용 저장하기 위한 변수
		try {
			url = new URL(sUrl); // URL 세팅
			connection = url.openConnection(); // 접속
			((HttpURLConnection) connection).setRequestMethod("POST");

			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setUseCaches(false);

			OutputStreamWriter wr = new OutputStreamWriter(connection.getOutputStream());
			Url = URLEncoder.encode("path") + "=" + URLEncoder.encode(Url) + "&" + URLEncoder.encode("sLawId") + "="
					+ URLEncoder.encode(sLawId);
			wr.write(Url);
			wr.flush();

			is = connection.getInputStream(); // inputStream 이용
			isr = new InputStreamReader(is,"utf-8");
			br = new BufferedReader(isr);
			String buf = null;

			while (true) { // 무한반복
				buf = br.readLine(); // 화면에 있는 내용을 \n단위로 읽어온다
				if (buf == null) { // null일 경우 화면이 끝난 경우이므로
					break; // 반복문 끝
				} else {
					strXML += buf + "\n"; // strXML에 화면에 출력된 내용을 기억시킨다.
				}
			}
			wr.close();
			is.close();
			isr.close();
			br.close();
		} catch (MalformedURLException mue) {

		} catch (IOException ioe) {
			ioe.printStackTrace();
		}
		return strXML;
	}

	public ArrayList ReadXml(int pageno) {
		String Url = Server;
		Url = Url + "OC=" + OC + "&target=" + target + "&display=" + display + "&nw=3&page=" + pageno;
		System.out.println("2" + Url);
		String strXML = "";
		if(ifBon) {
			strXML = getUrlXml_in(outServer, Url, "");
		}else {
			strXML = getUrlXml(Url);
		}

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		}

		Element Root = doc.getRootElement();
		List law = Root.getChildren();

		ArrayList lawList = new ArrayList();
		Iterator i = law.iterator();
		while (i.hasNext()) {
			Element row = (Element) i.next();
			if (row.getName().equals("law")) {
				HashMap lawMap = new HashMap();
				List rowha = row.getChildren();
				Iterator is = rowha.iterator();
				while (is.hasNext()) {

					Element rowV = (Element) is.next();
					lawMap.put(rowV.getName(), rowV.getValue());
				}
				lawList.add(lawMap);
				System.out.println(lawMap.get("법령명한글"));
			}
		}
		return lawList;
	}

	// 법령 리스트
	public ArrayList ReadXml1() {
		String Url = Server;
		Url = Url + "OC=" + OC + "&target=" + target + "&display=" + display + "&nw=3";
		System.out.println(Url);
		String strXML = "";
		if(ifBon) {
			strXML = getUrlXml_in(outServer, Url, "");
		}else {
			strXML = getUrlXml(Url);
		}

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		}

		Element Root = doc.getRootElement();
		List law = Root.getChildren();
		Iterator i = law.iterator();
		int cnt = 0;
		while (i.hasNext()) {
			Element row = (Element) i.next();
			if (row.getName().equals("totalCnt")) {
				cnt = Integer.parseInt(row.getValue());
			}
		}

		int page = 1;
		if (cnt % 100 == 0) {
			page = cnt / 100;
		} else {
			page = cnt / 100 + 1;
		}
		ArrayList lawMlist = new ArrayList();
		for (int j = 1; j <= page; j++) { // test를 위해 페이지 조정 "j<=page"
			lawMlist.add(ReadXml(j));
		}
		return lawMlist;
	}
	
	//행정규칙리스트
	public ArrayList ReadXml2(){
		String Url = Server;
		Url = Url + "OC=" + OC + "&target=admrul&display=" + display;
		System.out.println(Url);
		
		String strXML = "";
		if(ifBon) {
			strXML = getUrlXml_in(outServer, Url, "");
		}else {
			strXML = getUrlXml(Url);
		}
		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		Element Root = doc.getRootElement();
		List law = Root.getChildren();
		Iterator i = law.iterator();
		int cnt = 0;
		while(i.hasNext()){
			Element row = (Element)i.next();
			if(row.getName().equals("totalCnt")){
				cnt = Integer.parseInt(row.getValue());
			}
		}
		
		int page = 1;
		if(cnt%100==0){
			page = cnt/100;
		}else{
			page = cnt/100+1;
		}
		ArrayList lawMlist = new ArrayList();
		for(int j=1; j<=page; j++){    //test를 위해 페이지 조정 "j<=page"
			lawMlist.add(ReadXml3(j));
		}
		return lawMlist;
	}
	
	public ArrayList ReadXml3(int pageno){
		String Url = Server;
		Url = Url + "OC=" + OC + "&target=admrul&display=" + display + "&page="+pageno;
		System.out.println("2"+Url);
		String strXML = "";
		if(ifBon) {
			strXML = getUrlXml_in(outServer, Url, "");
		}else {
			strXML = getUrlXml(Url);
		}

		SAXBuilder builder = new SAXBuilder();
		Document doc = null;
		try {
			doc = builder.build(new java.io.StringReader(strXML));
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		Element Root = doc.getRootElement();
		List law = Root.getChildren();
		
		ArrayList lawList = new ArrayList();
		Iterator i = law.iterator();
		while(i.hasNext()){
			Element row = (Element)i.next();
			if(row.getName().equals("admrul")){
				HashMap lawMap = new HashMap();
				List rowha = row.getChildren();
				Iterator is = rowha.iterator();
				while(is.hasNext()){
					
					Element rowV = (Element)is.next();
					lawMap.put(rowV.getName(),rowV.getValue());
				}
				lawList.add(lawMap);
				System.out.println(lawMap.get("행정규칙명"));
			}
		}
		return lawList;
	}
	
	public int setInsertLaw() {
		HashMap logparam = new HashMap();
		logparam.put("LOG_CN", "법령배치 시작");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);

		int cnt = 0;

		ArrayList lawList = ReadXml1();
		for (int i = 0; i < lawList.size(); i++) {
			ArrayList lawSList = (ArrayList) lawList.get(i);
			for (int j = 0; j < lawSList.size(); j++) {
				try {
					HashMap lawMap = (HashMap) lawSList.get(j);
					Lawif lawif = new Lawif();

					String sLawId = lawMap.get("법령일련번호").toString();
					lawif.setLawsid(lawMap.get("법령일련번호") == null ? "" : lawMap.get("법령일련번호").toString());
					lawif.setStatecd(lawMap.get("현행연혁코드") == null ? "" : lawMap.get("현행연혁코드").toString());
					lawif.setLawname(lawMap.get("법령명한글") == null ? "" : lawMap.get("법령명한글").toString());
					lawif.setLawid(lawMap.get("법령ID") == null ? "" : lawMap.get("법령ID").toString());
					lawif.setPromuldt(lawMap.get("공포일자") == null ? "" : lawMap.get("공포일자").toString());
					lawif.setPromulno(lawMap.get("공포번호") == null ? "" : lawMap.get("공포번호").toString());
					lawif.setRevcd(lawMap.get("제개정구분명") == null ? "" : lawMap.get("제개정구분명").toString());
					lawif.setDeptcode(lawMap.get("소관부처코드") == null ? "" : lawMap.get("소관부처코드").toString());
					lawif.setDept(lawMap.get("소관부처명") == null ? "" : lawMap.get("소관부처명").toString());
					lawif.setLawgbn(lawMap.get("법령구분명") == null ? "" : lawMap.get("법령구분명").toString());
					lawif.setStartdt(lawMap.get("시행일자") == null ? "" : lawMap.get("시행일자").toString());
					lawif.setOtherlawyn(lawMap.get("자법타법여부") == null ? "" : lawMap.get("자법타법여부").toString());
					lawif.setLawurl(lawMap.get("법령상세링크") == null ? "" : lawMap.get("법령상세링크").toString());
					lawif.setLawbon(lawMap.get("법령ID") == null ? "" : lawMap.get("법령ID").toString());

					String url = lawMap.get("법령상세링크") == null ? "" : lawMap.get("법령상세링크").toString();
					if(ifBon) {
						if (url.equals("")) {
							lawif.setLawbon("");
						} else {
							String XMLDATA = getUrlXml_in(outServer2, sUrl + url.replaceAll("HTML", "XML"), sLawId);
							XMLDATA = XMLDATA.trim();
							lawif.setLawbon(XMLDATA);
	
							// 별표확인
							DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
							factory.setNamespaceAware(true); // never forget this!
							org.w3c.dom.Document doc = null;
							Object result = null;
							try {
								ByteArrayInputStream is = new ByteArrayInputStream(XMLDATA.getBytes("utf-8"));
								DocumentBuilder builder = factory.newDocumentBuilder();
								doc = builder.parse(is);// (new StringReader(bylaw.getXmldata()));
								String linkGbn = "/법령/별표/별표단위";
								XPathFactory factory2 = XPathFactory.newInstance();
								XPath xpath = factory2.newXPath();
								XPathExpression expr = xpath.compile(linkGbn);
								result = expr.evaluate(doc, XPathConstants.NODESET);
							} catch (Exception e) {
								logparam.put("LOG_CN", "본문데이터 추출 실패 ===>" + lawif.getLawname() + ":" + e);
								logparam.put("LOG_RSLT_NM", "실패");
								this.blog(logparam);
								System.out.println("%%%%%%%%" + e);
							}
	
							NodeList node = (NodeList) result;
							String fPath = MakeHan.File_url("KLAW") + sLawId;
							if (node.getLength() > 0) {
								File io = new File(fPath);
								if (!io.isDirectory()) {
									io.mkdirs();
								}
							}
							
							String tablePattern = "<img id=\"(.*?)\">[\\s\\S]*?</img>";
							Pattern tpattern = Pattern.compile(tablePattern);
							Matcher tmatch = tpattern.matcher(XMLDATA);
							while (tmatch.find()) {
								File io = new File(fPath);
								if (!io.isDirectory()) {
									io.mkdirs();
								}
								if(tmatch.groupCount()>=1){
									String id = tmatch.group(1);
									String imgName = FileUrlDownload.getImgName(outServerLawImg+"?id="+id+"&lawid="+sLawId);
									
									FileUrlDownload.ImgfileUrlReadAndDownloadIN(outServer3+sLawId+"/"+imgName, imgName,fPath);
								}
							}
							
							for (int hk = 0; hk < node.getLength(); hk++) {
								org.w3c.dom.Element it = (org.w3c.dom.Element) node.item(hk);
								String byulKey = it.getAttribute("별표키");
	
								System.out.println(byulKey);
								String fgbn = "";
								NodeList nodes = node.item(hk).getChildNodes();
								for (int hk2 = 0; hk2 < nodes.getLength(); hk2++) {
									Node its = nodes.item(hk2);
									String nodeTitle = its.getNodeName();
									String fUrl = "";
	
									if (nodeTitle.equals("별표번호")) {
										lawif.setNum(its.getTextContent());
									} else if (nodeTitle.equals("별표가지번호")) {
										lawif.setSubnum(its.getTextContent());
									} else if (nodeTitle.equals("별표구분")) {
										lawif.setByulgbn(its.getTextContent());
										if (lawif.getByulgbn().equals("별도")) {
											fgbn = "A";
										} else if (lawif.getByulgbn().equals("별지")) {
											fgbn = "B";
										} else if (lawif.getByulgbn().equals("별표")) {
											fgbn = "C";
										} else if (lawif.getByulgbn().equals("부록")) {
											fgbn = "D";
										} else if (lawif.getByulgbn().equals("서식")) {
											fgbn = "E";
										} else if (lawif.getByulgbn().equals("별첨")) {
											fgbn = "F";
										} else if (lawif.getByulgbn().equals("부속서")) {
											fgbn = "G";
										} else if (lawif.getByulgbn().equals("붙임")) {
											fgbn = "H";
										} else if (lawif.getByulgbn().equals("서식")) {
											fgbn = "I";
										} else if (lawif.getByulgbn().equals("양식")) {
											fgbn = "J";
										}
									} else if (nodeTitle.equals("별표제목")) {
										lawif.setByultitle(its.getTextContent());
									}
	
									if (nodeTitle.equals("별표서식파일링크")) {
										fUrl = its.getTextContent();
										try {
											String ext = this.getUrlXml_in(getfilename,fUrl,"").trim();
											ext = ext.substring(ext.lastIndexOf("."),ext.length());
											
											FileBean fb = FileUrlDownload.setUrlFileSave(outServer3 + "/" + sLawId + "/" + fgbn + byulKey + ext, fPath,fgbn + byulKey + ext);
											lawif.setByulkey(fgbn + byulKey);
											lawif.setFilecontent(fb.getFbuf());
											lawif.setSfilenm(fgbn + byulKey + ext);
										} catch (Exception e) {
											System.out.println(e + "별표파일이 없네.");
										}
									}
								}
								commonDao.insert("lawifSql.setInsertLawFile", lawif);
								// LawifDao.setInsertLawFile(lawif);
							}
						}
					}
					commonDao.insert("lawifSql.setInsertLaw", lawif);
				} catch (Exception e) {
					System.out.println(e);
				}
				cnt++;
			}
		}
		logparam.put("LOG_CN", "법령배치 종료");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		return cnt;
	}

	public void updateLaw() {
		HashMap logparam = new HashMap();
		logparam.put("LOG_CN", "법령배치 시작");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		// DB에서 ID, 일련번호 가져오기
		List oldlawList = commonDao.selectList("lawifSql.getSelectId");

		// 법령센터 데이터
		ArrayList preNewList = ReadXml1();
		ArrayList newlawList = new ArrayList();
		Iterator iter = preNewList.iterator();
		while (iter.hasNext()) {
			ArrayList arr = (ArrayList) iter.next();
			for (int t = 0; t < arr.size(); t++) {
				newlawList.add(arr.get(t));
			}
		}

		// 비교해서 쿼리
		try {
			ArrayList oldIdForRemove = new ArrayList();
			ArrayList newIdForRemove = new ArrayList();

			// 변화없는 법령들을 목록에서 지우기.
			for (int i = 0; i < oldlawList.size(); i++) {
				HashMap oldDa = (HashMap) oldlawList.get(i);

				for (int k = 0; k < newlawList.size(); k++) {
					HashMap webDa = (HashMap) newlawList.get(k);

					if (Integer.parseInt(oldDa.get("LAWID").toString()) == Integer.parseInt(webDa.get("법령ID").toString())) {
						if (Integer.parseInt(oldDa.get("LAWSID").toString()) == Integer.parseInt(webDa.get("법령일련번호").toString())) {
							oldIdForRemove.add(oldDa);
							newIdForRemove.add(webDa);
							break;
						}
					}
				}
			}
			System.out.println("oldIdForRemove==>" + oldIdForRemove.size());
			System.out.println("newIdForRemove==>" + newIdForRemove.size());

			System.out.println("P:oldlawList==>" + oldlawList.size());
			System.out.println("P:newlawList==>" + newlawList.size());
			// 업데이트된 법령 들을 목록에서 지우기
			oldlawList.removeAll(oldIdForRemove);
			newlawList.removeAll(newIdForRemove);
			System.out.println("E:oldlawList==>" + oldlawList.size());
			System.out.println("E:newlawList==>" + newlawList.size());

			oldIdForRemove = new ArrayList();
			newIdForRemove = new ArrayList();
			System.out.println("oldIdForRemove==>" + oldIdForRemove.size());
			System.out.println("newIdForRemove==>" + newIdForRemove.size());

			// 개정된 법령은 삭제한후 다시 저장
			for (int i = 0; i < oldlawList.size(); i++) {
				HashMap oldDa = (HashMap) oldlawList.get(i);
				String deleteLaw = "";
				for (int k = 0; k < newlawList.size(); k++) {
					HashMap webDa = (HashMap) newlawList.get(k);

					if (Integer.parseInt(oldDa.get("LAWID").toString()) == Integer.parseInt(webDa.get("법령ID").toString())) {
						if (Integer.parseInt(oldDa.get("LAWSID").toString()) != Integer.parseInt(webDa.get("법령일련번호").toString())) {
							// 업데이트
							commonDao.delete("lawifSql.setDelete", oldDa);
							commonDao.delete("lawifSql.setDelete2", oldDa);
							
							oldIdForRemove.add(oldDa);
							System.out.println("삭제법령=>" + oldDa.get("LAWNAME"));
							deleteLaw = deleteLaw + "\n"+ oldDa.get("LAWNAME");
							// newIdForRemove.add(webDa);
							break;
						}
					}
				}
				
				logparam.put("LOG_CN", "법령삭제\n"+deleteLaw);
				logparam.put("LOG_RSLT_NM", "삭제성공");
				this.blog(logparam);
			}
			System.out.println("oldIdForRemove==>" + oldIdForRemove.size());
			System.out.println("newIdForRemove==>" + newIdForRemove.size());
			// 업데이트된 법령 들을 목록에서 지우기
			System.out.println("P:oldlawList==>" + oldlawList.size());
			System.out.println("P:newlawList==>" + newlawList.size());
			oldlawList.removeAll(oldIdForRemove);
			newlawList.removeAll(newIdForRemove);
			System.out.println("E:oldlawList==>" + oldlawList.size());
			System.out.println("E:newlawList==>" + newlawList.size());

			System.out.println("oldIdForRemove==>" + oldIdForRemove.size());
			System.out.println("newIdForRemove==>" + newIdForRemove.size());

			for (int q = 0; q < oldlawList.size(); q++) {
				HashMap oldDa = (HashMap) oldlawList.get(q);
				// 삭제
				commonDao.delete("lawifSql.setDelete", oldDa);
				commonDao.delete("lawifSql.setDelete2", oldDa);
				System.out.println("삭제법령=>" + oldDa.get("LAWNAME"));
			}
		} catch (Exception e) {
			logparam.put("LOG_CN", "법령삭제");
			logparam.put("LOG_RSLT_NM", "실패");
			this.blog(logparam);
		}
		
		String insertLaw = "";
		for (int k = 0; k < newlawList.size(); k++) {
			try {
				HashMap lawMap = (HashMap) newlawList.get(k);
				Lawif lawif = new Lawif();
				System.out.println("신규법령==>" + lawMap.get("법령명한글"));
				insertLaw = insertLaw + "\n" + lawMap.get("법령명한글");
				String sLawId = lawMap.get("법령일련번호").toString();
				lawif.setLawsid(lawMap.get("법령일련번호") == null ? "" : lawMap.get("법령일련번호").toString());
				lawif.setPlawsid(lawMap.get("법령일련번호") == null ? "" : lawMap.get("법령일련번호").toString());
				lawif.setStatecd(lawMap.get("현행연혁코드") == null ? "" : lawMap.get("현행연혁코드").toString());
				lawif.setLawname(lawMap.get("법령명한글") == null ? "" : lawMap.get("법령명한글").toString());
				lawif.setLawid(lawMap.get("법령ID") == null ? "" : lawMap.get("법령ID").toString());
				lawif.setPromuldt(lawMap.get("공포일자") == null ? "" : lawMap.get("공포일자").toString());
				lawif.setPromulno(lawMap.get("공포번호") == null ? "" : lawMap.get("공포번호").toString());
				lawif.setRevcd(lawMap.get("제개정구분명") == null ? "" : lawMap.get("제개정구분명").toString());
				lawif.setDeptcode(lawMap.get("소관부처코드") == null ? "" : lawMap.get("소관부처코드").toString());
				lawif.setDept(lawMap.get("소관부처명") == null ? "" : lawMap.get("소관부처명").toString());
				lawif.setLawgbn(lawMap.get("법령구분명") == null ? "" : lawMap.get("법령구분명").toString());
				lawif.setStartdt(lawMap.get("시행일자") == null ? "" : lawMap.get("시행일자").toString());
				lawif.setOtherlawyn(lawMap.get("자법타법여부") == null ? "" : lawMap.get("자법타법여부").toString());
				lawif.setLawurl(lawMap.get("법령상세링크") == null ? "" : lawMap.get("법령상세링크").toString());
				lawif.setLawbon(lawMap.get("법령ID") == null ? "" : lawMap.get("법령ID").toString());

				String url = lawMap.get("법령상세링크") == null ? "" : lawMap.get("법령상세링크").toString();
				if(ifBon) {
					if (url.equals("")) {
						lawif.setLawbon("");
					} else {
						String XMLDATA = getUrlXml_in(outServer2, sUrl + url.replaceAll("HTML", "XML"), sLawId);
						XMLDATA = XMLDATA.trim();
						lawif.setLawbon(XMLDATA);
	
						// 별표확인
						DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
						factory.setNamespaceAware(true); // never forget this!
						org.w3c.dom.Document doc = null;
						Object result = null;
						try {
							ByteArrayInputStream is = new ByteArrayInputStream(XMLDATA.getBytes("utf-8"));
							DocumentBuilder builder = factory.newDocumentBuilder();
							doc = builder.parse(is);// (new StringReader(bylaw.getXmldata()));
							String linkGbn = "/법령/별표/별표단위";
							XPathFactory factory2 = XPathFactory.newInstance();
							XPath xpath = factory2.newXPath();
							XPathExpression expr = xpath.compile(linkGbn);
							result = expr.evaluate(doc, XPathConstants.NODESET);
						} catch (Exception e) {
							logparam.put("LOG_CN", "본문데이터 추출 실패 ===>" + lawif.getLawname() + ":" + e);
							logparam.put("LOG_RSLT_NM", "실패");
							this.blog(logparam);
							System.out.println("%%%%%%%%" + e);
						}
						NodeList node = (NodeList) result;
						String fPath = MakeHan.File_url("KLAW") + sLawId;
						
						if (node.getLength() > 0) {
							File io = new File(fPath);
							if (!io.isDirectory()) {
								io.mkdirs();
							}
						}
						
						String tablePattern = "<img id=\"(.*?)\">[\\s\\S]*?</img>";
						Pattern tpattern = Pattern.compile(tablePattern);
						Matcher tmatch = tpattern.matcher(XMLDATA);
						while (tmatch.find()) {
							File io = new File(fPath);
							if (!io.isDirectory()) {
								io.mkdirs();
							}
							if(tmatch.groupCount()>=1){
								String id = tmatch.group(1);
								String imgName = FileUrlDownload.getImgName(outServerLawImg+"?id="+id+"&lawid="+sLawId);
								
								FileUrlDownload.ImgfileUrlReadAndDownloadIN(outServer3+sLawId+"/"+imgName, imgName,fPath);
							}
						}
						
						for (int hk = 0; hk < node.getLength(); hk++) {
							org.w3c.dom.Element it = (org.w3c.dom.Element) node.item(hk);
							String byulKey = it.getAttribute("별표키");
	
							System.out.println(byulKey);
							String fgbn = "";
							NodeList nodes = node.item(hk).getChildNodes();
							for (int hk2 = 0; hk2 < nodes.getLength(); hk2++) {
								Node its = nodes.item(hk2);
								String nodeTitle = its.getNodeName();
								String fUrl = "";
	
								if (nodeTitle.equals("별표번호")) {
									lawif.setNum(its.getTextContent());
								} else if (nodeTitle.equals("별표가지번호")) {
									lawif.setSubnum(its.getTextContent());
								} else if (nodeTitle.equals("별표구분")) {
									lawif.setByulgbn(its.getTextContent());
									if (lawif.getByulgbn().equals("별도")) {
										fgbn = "A";
									} else if (lawif.getByulgbn().equals("별지")) {
										fgbn = "B";
									} else if (lawif.getByulgbn().equals("별표")) {
										fgbn = "C";
									} else if (lawif.getByulgbn().equals("부록")) {
										fgbn = "D";
									} else if (lawif.getByulgbn().equals("서식")) {
										fgbn = "E";
									} else if (lawif.getByulgbn().equals("별첨")) {
										fgbn = "F";
									} else if (lawif.getByulgbn().equals("부속서")) {
										fgbn = "G";
									} else if (lawif.getByulgbn().equals("붙임")) {
										fgbn = "H";
									} else if (lawif.getByulgbn().equals("서식")) {
										fgbn = "I";
									} else if (lawif.getByulgbn().equals("양식")) {
										fgbn = "J";
									}
								} else if (nodeTitle.equals("별표제목")) {
									lawif.setByultitle(its.getTextContent());
								}
	
								if (nodeTitle.equals("별표서식파일링크")) {
									fUrl = its.getTextContent();
									try {
										String ext = this.getUrlXml_in(getfilename,fUrl,"").trim();
										ext = ext.substring(ext.lastIndexOf("."),ext.length());
										
										FileBean fb = FileUrlDownload.setUrlFileSave(outServer3 + "/" + sLawId + "/" + fgbn + byulKey + ext, fPath,fgbn + byulKey + ext);
										lawif.setByulkey(fgbn + byulKey);
										lawif.setFilecontent(fb.getFbuf());
										lawif.setSfilenm(fgbn + byulKey + ext);
									} catch (Exception e) {
										System.out.println(e + "별표파일이 없네.");
									}
								}
							}
							commonDao.insert("lawifSql.setInsertLawFile", lawif);
						}
					}
				}
				insertLaw = insertLaw + "(성공)";
				commonDao.insert("lawifSql.setInsertLaw", lawif);
			} catch (Exception e) {
				System.out.println(e);
				logparam.put("LOG_CN", "법령저장");
				logparam.put("LOG_RSLT_NM", "실패");
				this.blog(logparam);
				
				insertLaw = insertLaw + "(실패)";
			}
		}
		logparam.put("LOG_CN", "법령저장\n"+insertLaw);
		logparam.put("LOG_RSLT_NM", "저장내용");
		this.blog(logparam);
		
		logparam.put("LOG_CN", "법령배치 종료");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		
		System.out.println("@@@@@ @@@ @@@ 업데이트가 종료되었습니다.@@@ @@@ @@@@@");

	}
	
	public int setInsertByLaw() {
		HashMap logparam = new HashMap();
		logparam.put("LOG_CN", "행정규칙배치 시작");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);

		int cnt = 0;

		ArrayList lawList = ReadXml2();
		for (int i = 0; i < lawList.size(); i++) {
			ArrayList lawSList = (ArrayList) lawList.get(i);
			for (int j = 0; j < lawSList.size(); j++) {
				try {
					HashMap lawMap = (HashMap) lawSList.get(j);
					Lawif lawif = new Lawif();

					String sByLawId = lawMap.get("행정규칙ID").toString();
					lawif.setBylawno(lawMap.get("행정규칙일련번호")==null?"":lawMap.get("행정규칙일련번호").toString());
					lawif.setBylawname(lawMap.get("행정규칙명")==null?"":lawMap.get("행정규칙명").toString());
					lawif.setBylawcd(lawMap.get("행정규칙종류")==null?"":lawMap.get("행정규칙종류").toString());
					lawif.setAppointdt(lawMap.get("발령일자")==null?"":lawMap.get("발령일자").toString());
					lawif.setAppointno(lawMap.get("발령번호")==null?"":lawMap.get("발령번호").toString());
					lawif.setBylawdept(lawMap.get("소관부처명")==null?"":lawMap.get("소관부처명").toString());
					lawif.setStatecd(lawMap.get("현행연혁구분")==null?"":lawMap.get("현행연혁구분").toString());
					lawif.setRevcdcode(lawMap.get("제개정구분코드")==null?"":lawMap.get("제개정구분코드").toString());
					lawif.setRevcd(lawMap.get("제개정구분명")==null?"":lawMap.get("제개정구분명").toString());
					lawif.setBylawid(lawMap.get("행정규칙ID")==null?"":lawMap.get("행정규칙ID").toString());
					lawif.setPbylawid(lawMap.get("행정규칙ID")==null?"":lawMap.get("행정규칙ID").toString());
					lawif.setBylawurl(lawMap.get("행정규칙상세링크")==null?"":lawMap.get("행정규칙상세링크").toString());
					lawif.setStartdt(lawMap.get("시행일자")==null?"":lawMap.get("시행일자").toString());
					lawif.setNewdt(lawMap.get("생성일자")==null?"":lawMap.get("생성일자").toString());
					lawif.setRevcha("0");
					String url = lawMap.get("행정규칙상세링크")==null?"":lawMap.get("행정규칙상세링크").toString();
					if(ifBon) {
						if (url.equals("")) {
							lawif.setBylawbon("");
						} else {
							String XMLDATA = getUrlXml_in(outServer2_1, sUrl + url.replaceAll("HTML", "XML"), sByLawId);
							
							XMLDATA = XMLDATA.trim();
							lawif.setBylawbon(XMLDATA);
	
							// 별표확인
							DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
							factory.setNamespaceAware(true); // never forget this!
							org.w3c.dom.Document doc = null;
							Object result = null;
							try {
								ByteArrayInputStream is = new ByteArrayInputStream(XMLDATA.getBytes("utf-8"));
								DocumentBuilder builder = factory.newDocumentBuilder();
								doc = builder.parse(is);// (new StringReader(bylaw.getXmldata()));
								String linkGbn = "/AdmRulService/별표/별표단위|/AdmRulService/첨부파일";
								XPathFactory factory2 = XPathFactory.newInstance();
								XPath xpath = factory2.newXPath();
								XPathExpression expr = xpath.compile(linkGbn);
								result = expr.evaluate(doc, XPathConstants.NODESET);
							} catch (Exception e) {
								logparam.put("LOG_CN", "본문데이터 추출 실패 ===>" + lawif.getBylawname() + ":" + e);
								logparam.put("LOG_RSLT_NM", "실패");
								this.blog(logparam);
								System.out.println("%%%%%%%%" + e);
							}
	
							NodeList node = (NodeList) result;
							String fPath = MakeHan.File_url("BLAW") + sByLawId;
							if (node.getLength() > 0) {
								File io = new File(fPath);
								if (!io.isDirectory()) {
									io.mkdirs();
								}
							}
							
							String tablePattern = "<img id=\"(.*?)\">[\\s\\S]*?</img>";
							Pattern tpattern = Pattern.compile(tablePattern);
							Matcher tmatch = tpattern.matcher(XMLDATA);
							while (tmatch.find()) {
								File io = new File(fPath);
								if (!io.isDirectory()) {
									io.mkdirs();
								}
								if(tmatch.groupCount()>=1){
									String id = tmatch.group(1);
									String imgName = FileUrlDownload.getImgName(outServerByLawImg+"?id="+id+"&sByLawId="+sByLawId);
									
									FileUrlDownload.ImgfileUrlReadAndDownloadIN(outServer3_1+sByLawId+"/"+imgName, imgName,fPath);
								}
							}
							
							for (int hk = 0; hk < node.getLength(); hk++) {
								org.w3c.dom.Element it = (org.w3c.dom.Element) node.item(hk);
								if(it.getNodeName().equals("별표단위")){
									String byulKey = it.getAttribute("별표키");
		
									System.out.println(byulKey);
									String fgbn = "";
									NodeList nodes = node.item(hk).getChildNodes();
									for (int hk2 = 0; hk2 < nodes.getLength(); hk2++) {
										Node its = nodes.item(hk2);
										String nodeTitle = its.getNodeName();
										String fUrl = "";
		
										if (nodeTitle.equals("별표번호")) {
											lawif.setNum(its.getTextContent());
										} else if (nodeTitle.equals("별표가지번호")) {
											lawif.setSubnum(its.getTextContent());
										} else if (nodeTitle.equals("별표구분")) {
											lawif.setByulgbn(its.getTextContent());
											if (lawif.getByulgbn().equals("별도")) {
												fgbn = "A";
											} else if (lawif.getByulgbn().equals("별지")) {
												fgbn = "B";
											} else if (lawif.getByulgbn().equals("별표")) {
												fgbn = "C";
											} else if (lawif.getByulgbn().equals("부록")) {
												fgbn = "D";
											} else if (lawif.getByulgbn().equals("서식")) {
												fgbn = "E";
											} else if (lawif.getByulgbn().equals("별첨")) {
												fgbn = "F";
											} else if (lawif.getByulgbn().equals("부속서")) {
												fgbn = "G";
											} else if (lawif.getByulgbn().equals("붙임")) {
												fgbn = "H";
											} else if (lawif.getByulgbn().equals("서식")) {
												fgbn = "I";
											} else if (lawif.getByulgbn().equals("양식")) {
												fgbn = "J";
											}
										} else if (nodeTitle.equals("별표제목")) {
											lawif.setByultitle(its.getTextContent());
										}
		
										if (nodeTitle.equals("별표서식파일링크")) {
											fUrl = its.getTextContent().trim();
											String fnms[] = fUrl.split("flSeq=");
											try {
												
												String ext = this.getUrlXml_in(getfilename,fUrl,"").trim();
												ext = ext.substring(ext.lastIndexOf("."),ext.length());
												
												FileBean fb = FileUrlDownload.setUrlFileSave(outServer3_1 + "/" + sByLawId + "/" + fgbn + byulKey + ext, fPath,fgbn + byulKey + ext);
												lawif.setByulkey(fgbn + byulKey);
												lawif.setFilecontent(fb.getFbuf());
												lawif.setSfilenm(fgbn + byulKey + ext);
											} catch (Exception e) {
												System.out.println(e + "별표파일이 없네.");
											}
										}
									}
									commonDao.insert("lawifSql.setInsertByLawFile", lawif);
								}else if(it.getNodeName().equals("첨부파일")){
									NodeList nodes = node.item(hk).getChildNodes();
									lawif.setByulgbn(it.getNodeName());
									String fnm = "";
									for(int hk2=0; hk2<nodes.getLength(); hk2++){
										Node its = nodes.item(hk2);
										String nodeTitle = its.getNodeName();
										String fUrl = "";
										
										if(nodeTitle.equals("첨부파일명")){
											lawif.setByultitle(its.getTextContent().trim());
											fnm = its.getTextContent().trim();
										}
										
										if(nodeTitle.equals("첨부파일링크")){
											String ext = fnm.substring(fnm.lastIndexOf("."),fnm.length());
											fUrl = its.getTextContent().trim();
											String fnms[] = fUrl.split("flSeq=");
											try{
												FileBean fb = FileUrlDownload.setUrlFileSave(outServer3_1 + "/" + sByLawId + "/" + fnms[1]+ext, fPath,fnms[1]+ext);
												lawif.setSfilenm(fnms[1]+ext);
												lawif.setFilecontent(fb.getFbuf());
											}catch(Exception e){
												System.out.println(e+"별표파일이 없네.");
											}
										}
									}
									commonDao.insert("lawifSql.setInsertByLawFile", lawif);
								}
							}
						}
					}
					commonDao.insert("lawifSql.setInsertByLaw", lawif);
				} catch (Exception e) {
					System.out.println(e);
				}
				cnt++;
			}
		}
		logparam.put("LOG_CN", "행정규칙배치 종료");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		return cnt;
	}
	
	public void updateByLaw() {
		HashMap logparam = new HashMap();
		logparam.put("LOG_CN", "행정규칙배치 시작");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		// DB에서 ID, 일련번호 가져오기
		List oldlawList = commonDao.selectList("lawifSql.getSelectId2");

		// 법령센터 데이터
		ArrayList preNewList = ReadXml2();
		ArrayList newlawList = new ArrayList();
		Iterator iter = preNewList.iterator();
		while (iter.hasNext()) {
			ArrayList arr = (ArrayList) iter.next();
			for (int t = 0; t < arr.size(); t++) {
				newlawList.add(arr.get(t));
			}
		}

		// 비교해서 쿼리
		try {
			ArrayList oldIdForRemove = new ArrayList();
			ArrayList newIdForRemove = new ArrayList();

			// 변화없는 법령들을 목록에서 지우기.
			for (int i = 0; i < oldlawList.size(); i++) {
				HashMap oldDa = (HashMap) oldlawList.get(i);

				for (int k = 0; k < newlawList.size(); k++) {
					HashMap webDa = (HashMap) newlawList.get(k);
			
					if (oldDa.get("BYLAWID").toString().equals(webDa.get("행정규칙ID").toString())) {
						if (oldDa.get("BYLAWNO").toString().equals(webDa.get("행정규칙일련번호").toString())) {
							oldIdForRemove.add(oldDa);
							newIdForRemove.add(webDa);
							break;
						}
					}
				}
			}
			System.out.println("oldIdForRemove==>" + oldIdForRemove.size());
			System.out.println("newIdForRemove==>" + newIdForRemove.size());

			System.out.println("P:oldlawList==>" + oldlawList.size());
			System.out.println("P:newlawList==>" + newlawList.size());
			// 업데이트된 법령 들을 목록에서 지우기
			oldlawList.removeAll(oldIdForRemove);
			newlawList.removeAll(newIdForRemove);
			System.out.println("E:oldlawList==>" + oldlawList.size());
			System.out.println("E:newlawList==>" + newlawList.size());

			oldIdForRemove = new ArrayList();
			newIdForRemove = new ArrayList();
			System.out.println("oldIdForRemove==>" + oldIdForRemove.size());
			System.out.println("newIdForRemove==>" + newIdForRemove.size());

			// 개정된 법령은 삭제한후 다시 저장
			for (int i = 0; i < oldlawList.size(); i++) {
				HashMap oldDa = (HashMap) oldlawList.get(i);
				String deleteLaw = "";
				for (int k = 0; k < newlawList.size(); k++) {
					HashMap webDa = (HashMap) newlawList.get(k);

					if (oldDa.get("BYLAWID").toString().equals(webDa.get("행정규칙ID").toString())) {
						if (!oldDa.get("BYLAWNO").toString().equals(webDa.get("행정규칙일련번호").toString())) {
							// 업데이트
							commonDao.delete("lawifSql.setBylawDelete", oldDa);
							commonDao.delete("lawifSql.setBylawDelete2", oldDa);
							
							oldIdForRemove.add(oldDa);
							System.out.println("삭제행정규칙=>" + oldDa.get("BYLAWNAME"));
							deleteLaw = deleteLaw + "\n"+ oldDa.get("BYLAWNAME");
							// newIdForRemove.add(webDa);
							break;
						}
					}
				}
				
				logparam.put("LOG_CN", "행정규칙삭제\n"+deleteLaw);
				logparam.put("LOG_RSLT_NM", "삭제성공");
				this.blog(logparam);
			}
			System.out.println("oldIdForRemove==>" + oldIdForRemove.size());
			System.out.println("newIdForRemove==>" + newIdForRemove.size());
			// 업데이트된 법령 들을 목록에서 지우기
			System.out.println("P:oldlawList==>" + oldlawList.size());
			System.out.println("P:newlawList==>" + newlawList.size());
			oldlawList.removeAll(oldIdForRemove);
			newlawList.removeAll(newIdForRemove);
			System.out.println("E:oldlawList==>" + oldlawList.size());
			System.out.println("E:newlawList==>" + newlawList.size());

			System.out.println("oldIdForRemove==>" + oldIdForRemove.size());
			System.out.println("newIdForRemove==>" + newIdForRemove.size());

			for (int q = 0; q < oldlawList.size(); q++) {
				HashMap oldDa = (HashMap) oldlawList.get(q);
				// 삭제
				commonDao.delete("lawifSql.setBylawDelete", oldDa);
				commonDao.delete("lawifSql.setBylawDelete2", oldDa);
				System.out.println("삭제행정규칙=>" + oldDa.get("BYLAWNAME"));
			}
		} catch (Exception e) {
			logparam.put("LOG_CN", "행정규칙삭제");
			logparam.put("LOG_RSLT_NM", "실패");
			this.blog(logparam);
		}
		
		String insertLaw = "";
		for (int k = 0; k < newlawList.size(); k++) {
			try {
				HashMap lawMap = (HashMap) newlawList.get(k);
				Lawif lawif = new Lawif();
				System.out.println("신규행정규칙==>" + lawMap.get("행정규칙명"));
				insertLaw = insertLaw + "\n" + lawMap.get("행정규칙명");
				String sByLawId = lawMap.get("행정규칙ID").toString();
				lawif.setBylawno(lawMap.get("행정규칙일련번호")==null?"":lawMap.get("행정규칙일련번호").toString());
				lawif.setBylawname(lawMap.get("행정규칙명")==null?"":lawMap.get("행정규칙명").toString());
				lawif.setBylawcd(lawMap.get("행정규칙종류")==null?"":lawMap.get("행정규칙종류").toString());
				lawif.setAppointdt(lawMap.get("발령일자")==null?"":lawMap.get("발령일자").toString());
				lawif.setAppointno(lawMap.get("발령번호")==null?"":lawMap.get("발령번호").toString());
				lawif.setBylawdept(lawMap.get("소관부처명")==null?"":lawMap.get("소관부처명").toString());
				lawif.setStatecd(lawMap.get("현행연혁구분")==null?"":lawMap.get("현행연혁구분").toString());
				lawif.setRevcdcode(lawMap.get("제개정구분코드")==null?"":lawMap.get("제개정구분코드").toString());
				lawif.setRevcd(lawMap.get("제개정구분명")==null?"":lawMap.get("제개정구분명").toString());
				lawif.setBylawid(lawMap.get("행정규칙ID")==null?"":lawMap.get("행정규칙ID").toString());
				lawif.setPbylawid(lawMap.get("행정규칙ID")==null?"":lawMap.get("행정규칙ID").toString());
				lawif.setBylawurl(lawMap.get("행정규칙상세링크")==null?"":lawMap.get("행정규칙상세링크").toString());
				lawif.setStartdt(lawMap.get("시행일자")==null?"":lawMap.get("시행일자").toString());
				lawif.setNewdt(lawMap.get("생성일자")==null?"":lawMap.get("생성일자").toString());
				lawif.setRevcha("0");
				String url = lawMap.get("행정규칙상세링크")==null?"":lawMap.get("행정규칙상세링크").toString();
				if(ifBon) {
					if (url.equals("")) {
						lawif.setBylawbon("");
					} else {
						String XMLDATA = getUrlXml_in(outServer2_1, sUrl + url.replaceAll("HTML", "XML"), sByLawId);
						XMLDATA = XMLDATA.trim();
						lawif.setBylawbon(XMLDATA);
	
						// 별표확인
						DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
						factory.setNamespaceAware(true); // never forget this!
						org.w3c.dom.Document doc = null;
						Object result = null;
						try {
							ByteArrayInputStream is = new ByteArrayInputStream(XMLDATA.getBytes("utf-8"));
							DocumentBuilder builder = factory.newDocumentBuilder();
							doc = builder.parse(is);// (new StringReader(bylaw.getXmldata()));
							String linkGbn = "/AdmRulService/별표/별표단위|/AdmRulService/첨부파일";
							XPathFactory factory2 = XPathFactory.newInstance();
							XPath xpath = factory2.newXPath();
							XPathExpression expr = xpath.compile(linkGbn);
							result = expr.evaluate(doc, XPathConstants.NODESET);
						} catch (Exception e) {
							logparam.put("LOG_CN", "본문데이터 추출 실패 ===>" + lawif.getBylawname() + ":" + e);
							logparam.put("LOG_RSLT_NM", "실패");
							this.blog(logparam);
							System.out.println("%%%%%%%%" + e);
						}
						NodeList node = (NodeList) result;
						String fPath = MakeHan.File_url("BLAW") + sByLawId;
						
						if (node.getLength() > 0) {
							File io = new File(fPath);
							if (!io.isDirectory()) {
								io.mkdirs();
							}
						}
						
						String tablePattern = "<img id=\"(.*?)\">[\\s\\S]*?</img>";
						Pattern tpattern = Pattern.compile(tablePattern);
						Matcher tmatch = tpattern.matcher(XMLDATA);
						while (tmatch.find()) {
							File io = new File(fPath);
							if (!io.isDirectory()) {
								io.mkdirs();
							}
							if(tmatch.groupCount()>=1){
								String id = tmatch.group(1);
								String imgName = FileUrlDownload.getImgName(outServerByLawImg+"?id="+id+"&sByLawId="+sByLawId);
								
								FileUrlDownload.ImgfileUrlReadAndDownloadIN(outServer3_1+sByLawId+"/"+imgName, imgName,fPath);
							}
						}
						
						for (int hk = 0; hk < node.getLength(); hk++) {
							org.w3c.dom.Element it = (org.w3c.dom.Element) node.item(hk);
							if(it.getNodeName().equals("별표단위")){
								String byulKey = it.getAttribute("별표키");
		
								System.out.println(byulKey);
								String fgbn = "";
								NodeList nodes = node.item(hk).getChildNodes();
								for (int hk2 = 0; hk2 < nodes.getLength(); hk2++) {
									Node its = nodes.item(hk2);
									String nodeTitle = its.getNodeName();
									String fUrl = "";
		
									if (nodeTitle.equals("별표번호")) {
										lawif.setNum(its.getTextContent());
									} else if (nodeTitle.equals("별표가지번호")) {
										lawif.setSubnum(its.getTextContent());
									} else if (nodeTitle.equals("별표구분")) {
										lawif.setByulgbn(its.getTextContent());
										if (lawif.getByulgbn().equals("별도")) {
											fgbn = "A";
										} else if (lawif.getByulgbn().equals("별지")) {
											fgbn = "B";
										} else if (lawif.getByulgbn().equals("별표")) {
											fgbn = "C";
										} else if (lawif.getByulgbn().equals("부록")) {
											fgbn = "D";
										} else if (lawif.getByulgbn().equals("서식")) {
											fgbn = "E";
										} else if (lawif.getByulgbn().equals("별첨")) {
											fgbn = "F";
										} else if (lawif.getByulgbn().equals("부속서")) {
											fgbn = "G";
										} else if (lawif.getByulgbn().equals("붙임")) {
											fgbn = "H";
										} else if (lawif.getByulgbn().equals("서식")) {
											fgbn = "I";
										} else if (lawif.getByulgbn().equals("양식")) {
											fgbn = "J";
										}
									} else if (nodeTitle.equals("별표제목")) {
										lawif.setByultitle(its.getTextContent());
									}
		
									if (nodeTitle.equals("별표서식파일링크")) {
										fUrl = its.getTextContent();
										try {
											String ext = this.getUrlXml_in(getfilename,fUrl,"").trim();
											ext = ext.substring(ext.lastIndexOf("."),ext.length());
											
											FileBean fb = FileUrlDownload.setUrlFileSave(outServer3_1 + "/" + sByLawId + "/" + fgbn + byulKey + ext, fPath,fgbn + byulKey + ext);
											lawif.setByulkey(fgbn + byulKey);
											lawif.setFilecontent(fb.getFbuf());
											lawif.setSfilenm(fgbn + byulKey + ext);
										} catch (Exception e) {
											System.out.println(e + "별표파일이 없네.");
										}
									}
								}
								commonDao.insert("lawifSql.setInsertByLawFile", lawif);
							}else if(it.getNodeName().equals("첨부파일")){
								NodeList nodes = node.item(hk).getChildNodes();
								lawif.setByulgbn(it.getNodeName());
								String fnm = "";
								for(int hk2=0; hk2<nodes.getLength(); hk2++){
									Node its = nodes.item(hk2);
									String nodeTitle = its.getNodeName();
									String fUrl = "";
									
									if(nodeTitle.equals("첨부파일명")){
										lawif.setByultitle(its.getTextContent().trim());
										fnm = its.getTextContent().trim();
									}
									
									if(nodeTitle.equals("첨부파일링크")){
										String ext = fnm.substring(fnm.lastIndexOf("."),fnm.length());
										fUrl = its.getTextContent().trim();
										String fnms[] = fUrl.split("flSeq=");
										try{
											FileBean fb = FileUrlDownload.setUrlFileSave(outServer3_1 + "/" + sByLawId + "/" + fnms[1]+ext, fPath,fnms[1]+ext);
											lawif.setSfilenm(fnms[1]+ext);
											lawif.setFilecontent(fb.getFbuf());
										}catch(Exception e){
											System.out.println(e+"별표파일이 없네.");
										}
									}
								}
								commonDao.insert("lawifSql.setInsertByLawFile", lawif);
							}
						}
					}
				}
				insertLaw = insertLaw + "(성공)";
				commonDao.insert("lawifSql.setInsertByLaw", lawif);
			} catch (Exception e) {
				System.out.println(e);
				logparam.put("LOG_CN", "행정규칙저장");
				logparam.put("LOG_RSLT_NM", "실패");
				this.blog(logparam);
				
				insertLaw = insertLaw + "(실패)";
			}
		}
		logparam.put("LOG_CN", "행정규칙저장\n"+insertLaw);
		logparam.put("LOG_RSLT_NM", "저장내용");
		this.blog(logparam);
		
		logparam.put("LOG_CN", "행정규칙배치 종료");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		
		System.out.println("@@@@@ @@@ @@@ 업데이트가 종료되었습니다.@@@ @@@ @@@@@");

	}
	
	public String outFile(String url, String sLawId) {
		String XMLDATA = getUrlXml(url.replaceAll("HTML", "XML"));
		
		// 별표확인
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true); // never forget this!
		org.w3c.dom.Document doc = null;
		Object result = null;
		try {
			ByteArrayInputStream is = new ByteArrayInputStream(XMLDATA.getBytes("utf-8"));
			DocumentBuilder builder = factory.newDocumentBuilder();
			doc = builder.parse(is);// (new StringReader(bylaw.getXmldata()));
			String linkGbn = "/법령/별표/별표단위";
			XPathFactory factory2 = XPathFactory.newInstance();
			XPath xpath = factory2.newXPath();
			XPathExpression expr = xpath.compile(linkGbn);
			result = expr.evaluate(doc, XPathConstants.NODESET);
		} catch (Exception e) {
			System.out.println("%%%%%%%%" + e);
		}
		NodeList node = (NodeList) result;
		String fPath = "";
		try {
			fPath = MakeHan.File_url("KLAW") + sLawId;
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		if (node.getLength() > 0) {
			File io = new File(fPath);
			if (!io.isDirectory()) {
				io.mkdirs();
			}
		}
		
		String tablePattern = "<img id=\"(.*?)\">[\\s\\S]*?</img>";
		Pattern tpattern = Pattern.compile(tablePattern);
		Matcher tmatch = tpattern.matcher(XMLDATA);
		while (tmatch.find()) {
			File io = new File(fPath);
			if (!io.isDirectory()) {
				io.mkdirs();
			}
			if(tmatch.groupCount()>=1){
				String id = tmatch.group(1);
				System.out.println(id);
				
				FileBean fb = FileUrlDownload.setUrlImgFileSave("http://10.175.79.142/flDownload.do?flSeq="+id, fPath,id);
			}
		}
		
		for (int hk = 0; hk < node.getLength(); hk++) {
			org.w3c.dom.Element it = (org.w3c.dom.Element) node.item(hk);
			String byulKey = it.getAttribute("별표키");
			NodeList nodes = node.item(hk).getChildNodes();
			String fgbn = "";
			for (int hk2 = 0; hk2 < nodes.getLength(); hk2++) {
				Node its = nodes.item(hk2);
				String nodeTitle = its.getNodeName();
				String fUrl = "";
				Lawif lawif = new Lawif();
				if (nodeTitle.equals("별표구분")) {
					lawif.setByulgbn(its.getTextContent());
					if (lawif.getByulgbn().equals("별도")) {
						fgbn = "A";
					} else if (lawif.getByulgbn().equals("별지")) {
						fgbn = "B";
					} else if (lawif.getByulgbn().equals("별표")) {
						fgbn = "C";
					} else if (lawif.getByulgbn().equals("부록")) {
						fgbn = "D";
					} else if (lawif.getByulgbn().equals("서식")) {
						fgbn = "E";
					} else if (lawif.getByulgbn().equals("별첨")) {
						fgbn = "F";
					} else if (lawif.getByulgbn().equals("부속서")) {
						fgbn = "G";
					} else if (lawif.getByulgbn().equals("붙임")) {
						fgbn = "H";
					} else if (lawif.getByulgbn().equals("서식")) {
						fgbn = "I";
					} else if (lawif.getByulgbn().equals("양식")) {
						fgbn = "J";
					}
				}
				if (nodeTitle.equals("별표서식파일링크")) {
					fUrl = its.getTextContent();
					try {
						String ext = this.getUrlXml_in(getfilename,fUrl,"").trim();
						ext = ext.substring(ext.lastIndexOf("."),ext.length());
						
						FileBean fb = FileUrlDownload.setUrlFileSave(mServer + fUrl, fPath, fgbn + byulKey + ext);
					} catch (Exception e) {
						System.out.println(e + "별표파일이 없네.");
					}
				}
			}
		}
		return XMLDATA;
	}
	
	public String outFile2(String url, String sByLawId) {
		String XMLDATA = getUrlXml(url.replaceAll("HTML", "XML"));
		
		// 별표확인
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true); // never forget this!
		org.w3c.dom.Document doc = null;
		Object result = null;
		try {
			ByteArrayInputStream is = new ByteArrayInputStream(XMLDATA.getBytes("utf-8"));
			DocumentBuilder builder = factory.newDocumentBuilder();
			doc = builder.parse(is);// (new StringReader(bylaw.getXmldata()));
			String linkGbn = "/AdmRulService/별표/별표단위|/AdmRulService/첨부파일";
			XPathFactory factory2 = XPathFactory.newInstance();
			XPath xpath = factory2.newXPath();
			XPathExpression expr = xpath.compile(linkGbn);
			result = expr.evaluate(doc, XPathConstants.NODESET);
		} catch (Exception e) {
			System.out.println("%%%%%%%%" + e);
		}
		NodeList node = (NodeList) result;
		String fPath = "";
		try {
			fPath = MakeHan.File_url("BLAW") + sByLawId;
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		if (node.getLength() > 0) {
			File io = new File(fPath);
			if (!io.isDirectory()) {
				io.mkdirs();
			}
		}
		
		String tablePattern = "<img id=\"(.*?)\">[\\s\\S]*?</img>";
		Pattern tpattern = Pattern.compile(tablePattern);
		Matcher tmatch = tpattern.matcher(XMLDATA);
		while (tmatch.find()) {
			File io = new File(fPath);
			if (!io.isDirectory()) {
				io.mkdirs();
			}
			if(tmatch.groupCount()>=1){
				String id = tmatch.group(1);
				System.out.println(id);
				
				FileBean fb = FileUrlDownload.setUrlImgFileSave("http://10.175.79.142/flDownload.do?flSeq="+id, fPath,id);
			}
		}
		
		for (int hk = 0; hk < node.getLength(); hk++) {
			org.w3c.dom.Element it = (org.w3c.dom.Element) node.item(hk);
			if(it.getNodeName().equals("별표단위")){
				String byulKey = it.getAttribute("별표키");
				NodeList nodes = node.item(hk).getChildNodes();
				String fgbn = "";
				for (int hk2 = 0; hk2 < nodes.getLength(); hk2++) {
					Node its = nodes.item(hk2);
					String nodeTitle = its.getNodeName();
					String fUrl = "";
					Lawif lawif = new Lawif();
					if (nodeTitle.equals("별표구분")) {
						lawif.setByulgbn(its.getTextContent());
						if (lawif.getByulgbn().equals("별도")) {
							fgbn = "A";
						} else if (lawif.getByulgbn().equals("별지")) {
							fgbn = "B";
						} else if (lawif.getByulgbn().equals("별표")) {
							fgbn = "C";
						} else if (lawif.getByulgbn().equals("부록")) {
							fgbn = "D";
						} else if (lawif.getByulgbn().equals("서식")) {
							fgbn = "E";
						} else if (lawif.getByulgbn().equals("별첨")) {
							fgbn = "F";
						} else if (lawif.getByulgbn().equals("부속서")) {
							fgbn = "G";
						} else if (lawif.getByulgbn().equals("붙임")) {
							fgbn = "H";
						} else if (lawif.getByulgbn().equals("서식")) {
							fgbn = "I";
						} else if (lawif.getByulgbn().equals("양식")) {
							fgbn = "J";
						}
					}
					if (nodeTitle.equals("별표서식파일링크")) {
						fUrl = its.getTextContent();
						try {
							String ext = this.getUrlXml_in(getfilename,fUrl,"").trim();
							ext = ext.substring(ext.lastIndexOf("."),ext.length());
							FileBean fb = FileUrlDownload.setUrlFileSave(mServer + fUrl, fPath, fgbn + byulKey + ext);
						} catch (Exception e) {
							System.out.println(e + "별표파일이 없네.");
						}
					}
				}
			}else if(it.getNodeName().equals("첨부파일")){
				NodeList nodes = node.item(hk).getChildNodes();
				String fnm = "";
				for(int hk2=0; hk2<nodes.getLength(); hk2++){
					Node its = nodes.item(hk2);
					String nodeTitle = its.getNodeName();
					String fUrl = "";
					
					if(nodeTitle.equals("첨부파일명")){
						fnm = its.getTextContent().trim();
					}
					
					if(nodeTitle.equals("첨부파일링크")){
						String ext = fnm.substring(fnm.lastIndexOf("."),fnm.length());
						fUrl = its.getTextContent().trim();
						String fnms[] = fUrl.split("flSeq=");
						try{
							if(fUrl.indexOf("http")==-1) {
								fUrl = mServer+fUrl;
							}
							FileBean fb = FileUrlDownload.setUrlFileSave(fUrl, fPath,fnms[1]+ext);
						}catch(Exception e){
							System.out.println(e+"별표파일이 없네.");
						}
					}
				}
			}
		}
		return XMLDATA;
	}
	
	public void getXmlTest(String url , String sLawId ,String gbn) {
		if(gbn.equals("LAW")) {
			System.out.println(getUrlXml_in(outServer2, sUrl + url.replaceAll("HTML", "XML"), sLawId));
		}else {
			System.out.println(getUrlXml_in(outServer2_1, sUrl + url.replaceAll("HTML", "XML"), sLawId));
		}
	}
	
	public void noticeSms(String getDate) {
		HashMap logparam = new HashMap();
		logparam.put("LOG_CN", "문자발송배치 시작");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("start", getDate);
		param.put("end", getDate);
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectSendUserList", param);
		
		try{
			if(list.size() > 0){
				for(int i=0; i<list.size(); i++){
					HashMap info = (HashMap)list.get(i);
					param = new HashMap<String, Object>();
					
					String title = "[법률지원통합시스템] 기일 도래 안내";
					String mobileNo = info.get("MBL_TELNO")==null?"":info.get("MBL_TELNO").toString();
					String msg = "아래 사건의 기일이 도래하였습니다.\r\n"
							+ "관리번호: "+info.get("LWS_NO")==null?"":info.get("LWS_NO").toString()+"\r\n"
							+ "사건번호: "+info.get("INCDNT_NO")==null?"":info.get("INCDNT_NO").toString()+"\r\n"
							+ "기일정보: "+info.get("DATE_TYPE_NM")==null?"":info.get("DATE_TYPE_NM").toString()+"";
					
					SMSClientSend.sendSMS(mobileNo, title, msg);
					
					Thread.sleep(1000);
				}
			}
		}catch(Exception e){
			System.out.println(e.toString());
		}

		logparam.put("LOG_CN", "문자발송배치 종료");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
	}
	
	public void noticeLawyerInfo(String getDate) {
		HashMap logparam = new HashMap();
		logparam.put("LOG_CN", "법인 임기만료 메일 발송배치 시작");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("date", getDate);
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectSendLawfirmEndInfo", param);
		
		try{
			if(list.size() > 0){
				ArrayList<String> sendUserList = new ArrayList();
				ArrayList<String> sendUserNmList = new ArrayList();
				String cont = "서울시 법률고문 임기만료 예정자 안내<br/><br/>";
				for(int i=0; i<list.size(); i++){
					// 만료일이 7일 남은 변호사 목록 전송
					HashMap info = (HashMap)list.get(i);
					param = new HashMap<String, Object>();
					sendUserList.add(param.get("EMP_PK_NO")==null?"":param.get("EMP_PK_NO").toString());
					sendUserNmList.add(param.get("EMP_NM")==null?"":param.get("EMP_NM").toString());
					
					cont = cont + 
							(param.get("LWYR_NM")==null?"":param.get("LWYR_NM").toString()) +
							(param.get("ENTRST_END_YMD")==null?"":param.get("ENTRST_END_YMD").toString()) +
							"<br/>";
				}
				
				SendMail mail = new SendMail();
				mail.sendMail("[법률지원통합시스템] 서울시 법률고문 임기만료 예정자 안내", cont, sendUserList, sendUserNmList, null, "");
			}
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		logparam.put("LOG_CN", "법인 임기만료 메일 발송배치 종료");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
	}
	
	public void noticeMail(String getDate) {
		HashMap logparam = new HashMap();
		logparam.put("LOG_CN", "부서정보배치 시작");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("start", getDate);
		param.put("end", getDate);
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectSendUserList", param);
		
		
		logparam.put("LOG_CN", "부서정보배치 종료");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
	}
	
	public void setInsaInfo() {
		HashMap logparam = new HashMap();
		logparam.put("LOG_CN", "인사정보 배치 시작");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
		
		List ol = insaDao.selectList("userSql.selectOrg");
		List ul = insaDao.selectList("userSql.selectUser");
		
		commonDao.delete("deleteTB_COM_ORGCHT");
		for(int i=0; i<ol.size(); i++){
			HashMap result = (HashMap)ol.get(i);
			commonDao.insert("userSql.insertTB_COM_ORGCHT",result);
		}
		commonDao.delete("deleteTB_COM_HRIS");
		for(int i=0; i<ul.size(); i++){
			HashMap result = (HashMap)ul.get(i);
			commonDao.insert("userSql.insertTB_COM_HRIS",result);
		}
		logparam.put("LOG_CN", "인사정보 배치 종료");
		logparam.put("LOG_RSLT_NM", "성공");
		this.blog(logparam);
	}
	
	public void setTask(HashMap taskMap) {
		String PRCS_YN = taskMap.get("PRCS_YN")==null?"":taskMap.get("PRCS_YN").toString();
		
		if("Y".equals(PRCS_YN)) {
			// 업무 처리 완료
			commonDao.update("commonSql.updateTask", taskMap);
		} else {
			// 업무 신규
			commonDao.insert("commonSql.insertTask", taskMap);
		}
	}
	
	public void updateSuitDate() {
		HashMap logparam = new HashMap();
		logparam.put("logtext", "나의사건검색 데이터 연계 시작");
		logparam.put("logresult", "성공");
		this.blog(logparam);
		
		String RELAY2 = bundle.getString("mten.RELAY2")==null?"":(String)bundle.getString("mten.RELAY2");
		
		JSONObject result = new JSONObject();
		List baseInfoList = commonDao.selectList("suitSql.selectCaseInfoBaseAll");
		
		System.out.println("caseBaseCnt ===========> " + baseInfoList.size());
		System.out.println("caseBaseCnt ===========> " + baseInfoList.size());
		System.out.println("caseBaseCnt ===========> " + baseInfoList.size());
		
		int inCnt = 0;
		int upCnt = 0;
		int errCnt = 0;
		
		for (int d=0; d<baseInfoList.size(); d++) {
			HashMap map = (HashMap) baseInfoList.get(d);
			String casenum = map.get("INCDNT_NO")==null?"":map.get("INCDNT_NO").toString();
			
			if (casenum.indexOf("@") > -1) {
				String[] casenum2 = casenum.split("@");
				String casenum_1 = casenum2[0]==null?"":casenum2[0];
				String casenum_2 = casenum2[1]==null?"":casenum2[1];
				String casenum_3 = casenum2[2]==null?"":casenum2[2];
				
				/*
				 * s1 : 관할법원
				 * s2 : 사건번호 1
				 * s3 : 사건번호 2
				 * s4 : 사건번호 3
				 * s5 : 상대방이름
				 * http://10.250.3.34:9500/caseinfo/index.jsp
				 */
				 
				URL url = null;
				URLConnection connection = null;
				InputStream is = null;
				InputStreamReader isr = null;
				BufferedReader br = null;
				
				String dateInfo = new String();
				try {
					url = new URL(RELAY2+"/index.jsp"); // URL 세팅
					connection = url.openConnection(); // 접속
					((HttpURLConnection) connection).setRequestMethod("POST");
					
					connection.setDoOutput(true);
					connection.setDoInput(true);
					connection.setUseCaches(false);
					
					OutputStreamWriter wr = new OutputStreamWriter(connection.getOutputStream());
					
					String param = URLEncoder.encode("s1") + "=" + URLEncoder.encode(map.get("CT_NM").toString(), "utf-8")
					+ "&" + URLEncoder.encode("s2") + "=" + URLEncoder.encode(casenum_1,"utf-8")
					+ "&" + URLEncoder.encode("s3") + "=" + URLEncoder.encode(casenum_2,"utf-8")
					+ "&" + URLEncoder.encode("s4") + "=" + URLEncoder.encode(casenum_3,"utf-8")
					+ "&" + URLEncoder.encode("s5") + "=" + URLEncoder.encode(map.get("LWS_CNCPR_NM").toString(),"utf-8");
					
					wr.write(param);
					wr.flush();
					
					is = connection.getInputStream(); // inputStream 이용
					isr = new InputStreamReader(is,"utf-8");
					br = new BufferedReader(isr);
					String buf = null;
					
					while (true) { // 무한반복
						buf = br.readLine(); // 화면에 있는 내용을 \n단위로 읽어온다
						
						if (buf == null) { // null일 경우 화면이 끝난 경우이므로
							break; // 반복문 끝
						} else {
							//System.out.println(buf);
							dateInfo += buf;
						}
					}
					
					JSONParser parser = new JSONParser();
					result.put("result", dateInfo);
					
					wr.close();
					is.close();
					isr.close();
					br.close();
				} catch (MalformedURLException mue) {
					//System.out.println(mue);
					
					logparam.put("logtext", "나의사건검색 연계 오류 MalformedURLException");
					logparam.put("logresult", "오류실패");
					this.blog(logparam);
					
				} catch (IOException ioe) {
					//System.out.println(ioe);
					
					logparam.put("logtext", "나의사건검색 연계 오류 IOException");
					logparam.put("logresult", "오류실패");
					this.blog(logparam);
					
					//ioe.printStackTrace();
				}
				
				JSONObject getOb = (JSONObject) result.get("result");
				
				String getMsg = "";
				if (getOb != null && getOb.size() > 0) {
					getMsg = getOb.get("msg")==null?"":getOb.get("msg").toString();
					System.out.println(getMsg);
				}
				
				if("사건이 존재하지 않습니다.".equals(getMsg) || dateInfo.indexOf("NO") > -1) {
					result.put("msg", "no");
					errCnt = errCnt+1;
				} else {
					JSONArray arr = (JSONArray) getOb.get("data");
					
					String LWS_MNG_NO = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
					String INST_MNG_NO = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
					
					String baseDatedt = map.get("SDT")==null?"":map.get("SDT").toString();
					String baseDocdt = map.get("DOCDT")==null?"":map.get("DOCDT").toString();
					
					for (int i=0; i<arr.size(); i++) {
						try {
							HashMap param = new HashMap();
							JSONObject dateInfoMap = (JSONObject) arr.get(i);
							
							String scont = dateInfoMap.get("scont")==null?"":dateInfoMap.get("scont").toString();
							scont = scont.trim();
							
							String sresult = dateInfoMap.get("sresult")==null?"":dateInfoMap.get("sresult").toString();
							sresult = sresult.trim();
							
							String sdt = dateInfoMap.get("sdate")==null?"":dateInfoMap.get("sdate").toString();
							sdt = sdt.replace(" ", "").replace(".", "-");
							
							String gbn = dateInfoMap.get("sgbn")==null?"":dateInfoMap.get("sgbn").toString();
							
							String matchcont = sdt+scont;
							
							if ("기일".equals(gbn)) {
								// 기일정보 insert
								String[] scontArr = scont.split("\\(");
								String sdatenm = scontArr[0];
								sdatenm = sdatenm.replace(" ", "");
								
								String [] reformData1 = scontArr[1].split("\\)");
								String [] testString = reformData1[0].split(" ");
								String place = "";
								String time = "";
								for(int zz=0; zz<testString.length; zz++) {
									String zzText = testString[zz].replaceAll(" ", "");
									if (!zzText.equals(sdatenm) ) {
										if (zzText.indexOf(":") > -1) {
											time = zzText.replaceAll(":", "").replaceAll(" ", "");
										} else {
											place += zzText + " ";
										}
									}
								}
								
								param.put("LWS_MNG_NO", LWS_MNG_NO);
								param.put("INST_MNG_NO", INST_MNG_NO);
								param.put("DATE_INSP_CN", matchcont);
								
								if (sdatenm.indexOf("준비") > -1) {
									sdatenm = "준비";
								} else if (sdatenm.indexOf("조정") > -1) {
									sdatenm = "조정";
								} else if (sdatenm.indexOf("변론") > -1) {
									sdatenm = "변론";
								} else if (sdatenm.indexOf("선고") > -1) {
									sdatenm = "선고";
								} else {
									sdatenm = sdatenm.substring(0, 2);
								}
								
								param.put("DATE_TYPE_NM", sdatenm);
								param.put("DATE_PLC_NM", place);
								param.put("DATE_TM", time);
								param.put("DATE_YMD", sdt);
								param.put("DATE_CN", scont);
								param.put("DATE_RSLT_CN", sresult);
								
								HashMap getDateInfo = commonDao.selectOne("suitSql.getMatchedDate", param);
								
								if(getDateInfo == null) {
									// INSERT 처리
									System.out.println("%%%%%%%%%%%%%%%% INSERT DATE %%%%%%%%%%%%%%%%");
									commonDao.insert("suitSql.insertCaseInfoDateData", param);
									inCnt = inCnt+1;
								} else {
									String DATE_MNG_NO = getDateInfo.get("DATE_MNG_NO")==null?"":getDateInfo.get("DATE_MNG_NO").toString();
									String DATE_RSLT_CN = getDateInfo.get("DATE_RSLT_CN")==null?"":getDateInfo.get("DATE_RSLT_CN").toString();
									if(DATE_MNG_NO != null && DATE_MNG_NO != "" && !sresult.equals(DATE_RSLT_CN)) {
										System.out.println("%%%%%%%%%%%%%%%% UPDATE DATE %%%%%%%%%%%%%%%%");
										// UPDATE 처리
										param.put("DATE_MNG_NO", DATE_MNG_NO);
										commonDao.update("suitSql.updateCaseInfoDateData", param);
										upCnt = upCnt+1;
									}
								}
							} else {
								// 문서정보 insert
								param.put("LWS_MNG_NO", LWS_MNG_NO);
								param.put("INST_MNG_NO", INST_MNG_NO);
								param.put("DOC_INSP_CN", matchcont);
								param.put("DOC_YMD", sdt);
								param.put("DOC_CN", scont);
								param.put("DOC_RSLT_CN", sresult);
								
								HashMap getDocInfo = commonDao.selectOne("suitSql.getMatchedDoc", param);
								
								if(getDocInfo == null) {
									// INSERT 처리
									System.out.println("%%%%%%%%%%%%%%%% INSERT DOC %%%%%%%%%%%%%%%%");
									commonDao.insert("suitSql.insertCaseInfoDocData", param);
									inCnt = inCnt+1;
								} else {
									String DOC_MNG_NO = getDocInfo.get("DOC_MNG_NO")==null?"":getDocInfo.get("DOC_MNG_NO").toString();
									String DOC_RSLT_CN = getDocInfo.get("DOC_RSLT_CN")==null?"":getDocInfo.get("DOC_RSLT_CN").toString();
									if(DOC_MNG_NO != null && DOC_MNG_NO != "" && !sresult.equals(DOC_RSLT_CN)) {
										System.out.println("%%%%%%%%%%%%%%%% UPDATE DOC %%%%%%%%%%%%%%%%");
										// UPDATE 처리
										param.put("DOC_MNG_NO", DOC_MNG_NO);
										commonDao.update("suitSql.updateCaseInfoDocData", param);
										upCnt = upCnt+1;
									}
								}
							}
						} catch (NullPointerException e) {
							logparam.put("logtext", "나의사건검색 등록 오류 Exception " + e);
							logparam.put("logresult", "오류실패");
							this.blog(logparam);
						}
					}
				}
			}
		}
		
		logparam.put("logtext", "나의사건검색 데이터 연계 종료\n신규 : " + inCnt + "건\n업데이트 : " + upCnt + "건\n사건조회불가 : "+errCnt);
		logparam.put("logresult", "성공");
		this.blog(logparam);
	}
	
	
	public void setSuitOldData() {
		//List suitMst = commonDao.selectList("oldDataSql.getSuitInfo");
		//for (int s=0; s<suitMst.size(); s++) {
		//	HashMap suitMap = (HashMap)suitMst.get(s);
		//	commonDao.insert("oldDataSql.insertSuitInfo", suitMap);
		//}
		//
		//List case1Mst = commonDao.selectList("oldDataSql.getCaseInfo1");
		//for (int c=0; c<case1Mst.size(); c++) {
		//	HashMap caseMap = (HashMap)case1Mst.get(c);
		//	commonDao.insert("oldDataSql.insertCaseInfo1", caseMap);
		//}
		//
		//List case2Mst = commonDao.selectList("oldDataSql.getCaseInfo2");
		//for (int c=0; c<case2Mst.size(); c++) {
		//	HashMap caseMap = (HashMap)case2Mst.get(c);
		//	commonDao.insert("oldDataSql.insertCaseInfo2", caseMap);
		//}
		//
		//List cncprMst = commonDao.selectList("oldDataSql.getCncprInfo");
		//for (int c=0; c<cncprMst.size(); c++) {
		//	HashMap cncprMap = (HashMap)cncprMst.get(c);
		//	commonDao.insert("oldDataSql.insertCncprInfo", cncprMap);
		//}
		//
		//List agtMst = commonDao.selectList("oldDataSql.getAgtInfo");
		//for (int c=0; c<agtMst.size(); c++) {
		//	HashMap agtMap = (HashMap)agtMst.get(c);
		//	commonDao.insert("oldDataSql.insertAgtInfo", agtMap);
		//}
		
		//List flfmtMst1 = commonDao.selectList("oldDataSql.getFlfmtInfo1");
		//for (int c=0; c<flfmtMst1.size(); c++) {
		//	HashMap flfmtMap = (HashMap)flfmtMst1.get(c);
		//	commonDao.insert("oldDataSql.insertFlfmtInfo1", flfmtMap);
		//}
		//
		//List flfmtMst2 = commonDao.selectList("oldDataSql.getFlfmtInfo2");
		//for (int c=0; c<flfmtMst2.size(); c++) {
		//	HashMap flfmtMap = (HashMap)flfmtMst2.get(c);
		//	commonDao.insert("oldDataSql.insertFlfmtInfo2", flfmtMap);
		//}
		
		//List dateMst = commonDao.selectList("oldDataSql.getDateInfo");
		//for (int c=0; c<dateMst.size(); c++) {
		//	HashMap dateMap = (HashMap)dateMst.get(c);
		//	commonDao.insert("oldDataSql.insertDateInfo", dateMap);
		//}
		//
		//List costMst = commonDao.selectList("oldDataSql.getCostInfo");
		//for (int c=0; c<costMst.size(); c++) {
		//	HashMap costMap = (HashMap)costMst.get(c);
		//	commonDao.insert("oldDataSql.insertCostInfo", costMap);
		//}
		//
		//List bndMst = commonDao.selectList("oldDataSql.getBndInfo");
		//for (int c=0; c<bndMst.size(); c++) {
		//	HashMap bndMap = (HashMap)bndMst.get(c);
		//	commonDao.insert("oldDataSql.insertBndInfo", bndMap);
		//}
		//
		//List bndRtrvlMst = commonDao.selectList("oldDataSql.getBndRtrvlInfo");
		//for (int c=0; c<bndRtrvlMst.size(); c++) {
		//	HashMap bndMap = (HashMap)bndRtrvlMst.get(c);
		//	commonDao.insert("oldDataSql.insertBndRtrvlInfo", bndMap);
		//}
		
		System.out.println(":::::::::::::: 소송데이터 이관 끝 ::::::::::::::");
	}
	
	public void setConsultOldData() {
		System.out.println(":::::::::::::: 자문데이터 이관 시작 ::::::::::::::");
		LocalDateTime startTime = LocalDateTime.now();
		System.out.println("이관 시작 시간 : " + startTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		
		List consultMst1 = commonDao.selectList("oldDataSql.getConsultInfo1"); // 기본 의뢰 테이블에서 자문 정보 가져오기
		for (int s=0; s<consultMst1.size(); s++) {
			HashMap consultMap = (HashMap)consultMst1.get(s);
			commonDao.insert("oldDataSql.insertConsultInfo1", consultMap);
			String CNSTN_TKCG_EMP_NO = consultMap.get("CNSTN_TKCG_EMP_NO")==null?"":consultMap.get("CNSTN_TKCG_EMP_NO").toString();
			if (!"".equals(CNSTN_TKCG_EMP_NO)) {
				String rvwPicSeq = commonDao.select("commonSql.getSeq");
				String rvwOpnnSeq = commonDao.select("commonSql.getSeq");
				consultMap.put("RVW_TKCG_MNG_NO", rvwPicSeq);
				consultMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
				commonDao.insert("oldDataSql.insertConsultRvwPic1", consultMap);
				commonDao.insert("oldDataSql.insertConsultRvwOpnn1", consultMap);
				
				List consultFile2 = commonDao.selectList("oldDataSql.getConsultFile2", consultMap);
				for (int c=0; c<consultFile2.size(); c++) {
					HashMap consultFileMap = (HashMap)consultFile2.get(c);
					consultFileMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
					commonDao.insert("oldDataSql.insertConsultFile2", consultFileMap);
				}
			}
			//메모 넣기위해서 조회
//			HashMap memoMap = commonDao.select("oldDataSql.getConsultMemo1", consultMap);
			List consultMemo1 = commonDao.selectList("oldDataSql.getConsultMemo1", consultMap);
			for (int m=0; m<consultMemo1.size(); m++) {
				HashMap consultMemoMap = (HashMap)consultMemo1.get(m);
				commonDao.insert("oldDataSql.insertConsultMemo1", consultMemoMap);
				List consultMemoFile1 = commonDao.selectList("oldDataSql.getConsultMemoFile1", consultMemoMap);
//				HashMap memoFileMap = commonDao.select("oldDataSql.getConsultMemoFile1", memoMap);
				for (int f=0; f<consultMemoFile1.size(); f++) {
					HashMap consultMemoFileMap = (HashMap)consultMemoFile1.get(f);
					commonDao.insert("oldDataSql.insertConsultMemoFile1", consultMemoFileMap);
				}
			
			}
		}
		
		List consultMst2 = commonDao.selectList("oldDataSql.getConsultInfo2"); // 기본 의뢰 테이블에서 자문 정보 가져오기
		for (int s=0; s<consultMst2.size(); s++) {
			HashMap consultMap = (HashMap)consultMst2.get(s);
			commonDao.insert("oldDataSql.insertConsultInfo1", consultMap);
			String CNSTN_TKCG_EMP_NO = consultMap.get("CNSTN_TKCG_EMP_NO")==null?"":consultMap.get("CNSTN_TKCG_EMP_NO").toString();
			if (!"".equals(CNSTN_TKCG_EMP_NO)) {
				String rvwPicSeq = commonDao.select("commonSql.getSeq");
				String rvwOpnnSeq = commonDao.select("commonSql.getSeq");
				consultMap.put("RVW_TKCG_MNG_NO", rvwPicSeq);
				consultMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
				commonDao.insert("oldDataSql.insertConsultRvwPic1", consultMap);
				commonDao.insert("oldDataSql.insertConsultRvwOpnn1", consultMap);
			}
			//메모 넣기위해서 조회
//			HashMap memoMap = commonDao.select("oldDataSql.getConsultMemo1", consultMap);
//			commonDao.insert("oldDataSql.insertMemo1", memoMap);
//			HashMap memoFileMap = commonDao.select("oldDataSql.getConsultMemoFile1", memoMap);
//			commonDao.insert("oldDataSql.insertMemoFile1", memoFileMap);
			//메모 넣기위해서 조회
//			HashMap memoMap = commonDao.select("oldDataSql.getConsultMemo1", consultMap);
			List consultMemo1 = commonDao.selectList("oldDataSql.getConsultMemo1", consultMap);
			for (int m=0; m<consultMemo1.size(); m++) {
				HashMap consultMemoMap = (HashMap)consultMemo1.get(m);
				commonDao.insert("oldDataSql.insertConsultMemo1", consultMemoMap);
				List consultMemoFile1 = commonDao.selectList("oldDataSql.getConsultMemoFile1", consultMemoMap);
//				HashMap memoFileMap = commonDao.select("oldDataSql.getConsultMemoFile1", memoMap);
				for (int f=0; f<consultMemoFile1.size(); f++) {
					HashMap consultMemoFileMap = (HashMap)consultMemoFile1.get(f);
					commonDao.insert("oldDataSql.insertConsultMemoFile1", consultMemoFileMap);
				}
			
			}
		}
		
//		List consultMst3 = commonDao.selectList("oldDataSql.getConsultInfo3"); // 기본 의뢰 테이블에서 자문 정보 가져오기
//		for (int s=0; s<consultMst3.size(); s++) {
//			HashMap consultMap = (HashMap)consultMst3.get(s);
//			commonDao.insert("oldDataSql.insertConsultInfo1", consultMap);
//			String CNSTN_TKCG_EMP_NO = consultMap.get("CNSTN_TKCG_EMP_NO")==null?"":consultMap.get("CNSTN_TKCG_EMP_NO").toString();
//			if (!"".equals(CNSTN_TKCG_EMP_NO)) {
//				String rvwPicSeq = commonDao.select("commonSql.getSeq");
//				String rvwOpnnSeq = commonDao.select("commonSql.getSeq");
//				consultMap.put("RVW_TKCG_MNG_NO", rvwPicSeq);
//				consultMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
//				commonDao.insert("oldDataSql.insertConsultRvwPic1", consultMap);
//				commonDao.insert("oldDataSql.insertConsultRvwOpnn1", consultMap);
//			}
//			//메모 넣기위해서 조회
////			HashMap memoMap = commonDao.select("oldDataSql.getConsultMemo1", consultMap);
////			commonDao.insert("oldDataSql.insertMemo1", memoMap);
////			HashMap memoFileMap = commonDao.select("oldDataSql.getConsultMemoFile1", memoMap);
////			commonDao.insert("oldDataSql.insertMemoFile1", memoFileMap);
//			//메모 넣기위해서 조회
////			HashMap memoMap = commonDao.select("oldDataSql.getConsultMemo1", consultMap);
//			List consultMemo1 = commonDao.selectList("oldDataSql.getConsultMemo1", consultMap);
//			for (int m=0; m<consultMemo1.size(); m++) {
//				HashMap consultMemoMap = (HashMap)consultMemo1.get(m);
//				commonDao.insert("oldDataSql.insertConsultMemo1", consultMemoMap);
//				List consultMemoFile1 = commonDao.selectList("oldDataSql.getConsultMemoFile1", consultMemoMap);
////				HashMap memoFileMap = commonDao.select("oldDataSql.getConsultMemoFile1", memoMap);
//				for (int f=0; f<consultMemoFile1.size(); f++) {
//					HashMap consultMemoFileMap = (HashMap)consultMemoFile1.get(f);
//					commonDao.insert("oldDataSql.insertConsultMemoFile1", consultMemoFileMap);
//				}
//			
//			}
//		}
		
		List consultFile1 = commonDao.selectList("oldDataSql.getConsultFile1");
		for (int s=0; s<consultFile1.size(); s++) {
			HashMap consultFileMap = (HashMap)consultFile1.get(s);
			commonDao.insert("oldDataSql.insertConsultFile1", consultFileMap);
		}
//		List consultFile2 = commonDao.selectList("oldDataSql.getConsultFile2");
//		for (int s=0; s<consultFile2.size(); s++) {
//			HashMap consultFileMap = (HashMap)consultFile2.get(s);
//			commonDao.insert("oldDataSql.insertConsultFile1", consultFileMap);
//		}
		List consultFile3 = commonDao.selectList("oldDataSql.getConsultFile3");
		for (int s=0; s<consultFile3.size(); s++) {
			HashMap consultFileMap = (HashMap)consultFile3.get(s);
			commonDao.insert("oldDataSql.insertConsultFile1", consultFileMap);
		}
//		List consultFile4 = commonDao.selectList("oldDataSql.getConsultFile4");
//		for (int s=0; s<consultFile4.size(); s++) {
//			HashMap consultFileMap = (HashMap)consultFile4.get(s);
//			commonDao.insert("oldDataSql.insertConsultFile1", consultFileMap);
//		}
		
		LocalDateTime endTime = LocalDateTime.now();
		System.out.println("이관 시작 시간 : " + startTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		System.out.println("이관 종료 시간 : " + endTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		
		System.out.println(":::::::::::::: 자문데이터 이관 끝 ::::::::::::::");
	}
	
	public void setAgreeOldData() {
		
		System.out.println(":::::::::::::: 협약 데이터 이관 시작 ::::::::::::::");
		LocalDateTime startTime = LocalDateTime.now();
		System.out.println("이관 시작 시간 : " + startTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		
		List agreeMst1 = commonDao.selectList("oldDataSql.getAgreeInfo1"); // 기본 의뢰 테이블에서 협약 정보 가져오기
		for (int s=0; s<agreeMst1.size(); s++) {
			HashMap agreeMap = (HashMap)agreeMst1.get(s);
			commonDao.insert("oldDataSql.insertAgreeInfo1", agreeMap);
			String CVTN_TKCG_EMP_NO = agreeMap.get("CVTN_TKCG_EMP_NO")==null?"":agreeMap.get("CVTN_TKCG_EMP_NO").toString();
			if (!"".equals(CVTN_TKCG_EMP_NO)) {
				String rvwPicSeq = commonDao.select("commonSql.getSeq");
				String rvwOpnnSeq = commonDao.select("commonSql.getSeq");
				agreeMap.put("RVW_TKCG_MNG_NO", rvwPicSeq);
				agreeMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
				commonDao.insert("oldDataSql.insertAgreeRvwPic1", agreeMap);
				commonDao.insert("oldDataSql.insertAgreeRvwOpnn1", agreeMap);
				
				List agreeFileList1 = commonDao.selectList("oldDataSql.getAgreeFile2", agreeMap);
				for (int a=0; a<agreeFileList1.size(); a++) {
					HashMap agreeFileMap = (HashMap)agreeFileList1.get(a);
					agreeFileMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
					commonDao.insert("oldDataSql.insertAgreeFile1", agreeFileMap);
				}
			}
			//메모 넣기위해서 조회
//			HashMap memoMap = commonDao.select("oldDataSql.getConsultMemo1", consultMap);
			List agreeMemo1 = commonDao.selectList("oldDataSql.getAgreeMemo1", agreeMap);
			for (int m=0; m<agreeMemo1.size(); m++) {
				HashMap agreeMemoMap = (HashMap)agreeMemo1.get(m);
				commonDao.insert("oldDataSql.insertAgreeMemo1", agreeMemoMap);
				List agreeMemoFile1 = commonDao.selectList("oldDataSql.getAgreeMemoFile1", agreeMemoMap);
//				HashMap memoFileMap = commonDao.select("oldDataSql.getConsultMemoFile1", memoMap);
				for (int f=0; f<agreeMemoFile1.size(); f++) {
					HashMap agreeMemoFileMap = (HashMap)agreeMemoFile1.get(f);
					agreeMemoFileMap.put("CVTN_MNG_NO_1", agreeMemoMap.get("CVTN_MNG_NO"));
					agreeMemoFileMap.put("TRGT_PST_MNG_NO_1", agreeMemoMap.get("CVTN_MEMO_MNG_NO"));
					commonDao.insert("oldDataSql.insertAgreeMemoFile1", agreeMemoFileMap);
				}
			
			}
		}
		
		List agreeMst2 = commonDao.selectList("oldDataSql.getAgreeInfo2"); // 기타계약
		for (int s=0; s<agreeMst2.size(); s++) {
			HashMap agreeMap = (HashMap)agreeMst2.get(s);
			commonDao.insert("oldDataSql.insertAgreeInfo1", agreeMap);
			String CVTN_TKCG_EMP_NO = agreeMap.get("CVTN_TKCG_EMP_NO")==null?"":agreeMap.get("CVTN_TKCG_EMP_NO").toString();
			if (!"".equals(CVTN_TKCG_EMP_NO)) {
				if (!"1500".equals(agreeMap.get("REQUEST_STATUS_CD"))) {
					String rvwPicSeq = commonDao.select("commonSql.getSeq");
					String rvwOpnnSeq = commonDao.select("commonSql.getSeq");
					agreeMap.put("RVW_TKCG_MNG_NO", rvwPicSeq);
					agreeMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
					commonDao.insert("oldDataSql.insertAgreeRvwPic1", agreeMap);
					commonDao.insert("oldDataSql.insertAgreeRvwOpnn1", agreeMap);
					
					List agreeFileList1 = commonDao.selectList("oldDataSql.getAgreeFile4", agreeMap);
					for (int a=0; a<agreeFileList1.size(); a++) {
						HashMap agreeFileMap = (HashMap)agreeFileList1.get(a);
						agreeFileMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
						commonDao.insert("oldDataSql.insertAgreeFile1", agreeFileMap);
					}
				}
			}
			
			//메모 넣기위해서 조회
//			HashMap memoMap = commonDao.select("oldDataSql.getConsultMemo1", consultMap);
			List agreeMemo1 = commonDao.selectList("oldDataSql.getAgreeMemo1", agreeMap);
			for (int m=0; m<agreeMemo1.size(); m++) {
				HashMap agreeMemoMap = (HashMap)agreeMemo1.get(m);
				commonDao.insert("oldDataSql.insertAgreeMemo1", agreeMemoMap);
				List agreeMemoFile1 = commonDao.selectList("oldDataSql.getAgreeMemoFile1", agreeMemoMap);
//				HashMap memoFileMap = commonDao.select("oldDataSql.getConsultMemoFile1", memoMap);
				for (int f=0; f<agreeMemoFile1.size(); f++) {
					HashMap agreeMemoFileMap = (HashMap)agreeMemoFile1.get(f);
					agreeMemoFileMap.put("CVTN_MNG_NO_1", agreeMemoMap.get("CVTN_MNG_NO"));
					agreeMemoFileMap.put("TRGT_PST_MNG_NO_1", agreeMemoMap.get("CVTN_MEMO_MNG_NO"));
					commonDao.insert("oldDataSql.insertAgreeMemoFile1", agreeMemoFileMap);
				}
			
			}
		}
		
		List agreeMst3 = commonDao.selectList("oldDataSql.getAgreeInfo3"); // 시의회
		for (int s=0; s<agreeMst3.size(); s++) {
			HashMap agreeMap = (HashMap)agreeMst3.get(s);
			commonDao.insert("oldDataSql.insertAgreeInfo1", agreeMap);
			String CVTN_TKCG_EMP_NO = agreeMap.get("CVTN_TKCG_EMP_NO")==null?"":agreeMap.get("CVTN_TKCG_EMP_NO").toString();
			if (!"".equals(CVTN_TKCG_EMP_NO)) {
				String rvwPicSeq = commonDao.select("commonSql.getSeq");
				String rvwOpnnSeq = commonDao.select("commonSql.getSeq");
				agreeMap.put("RVW_TKCG_MNG_NO", rvwPicSeq);
				agreeMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
				commonDao.insert("oldDataSql.insertAgreeRvwPic1", agreeMap);
				commonDao.insert("oldDataSql.insertAgreeRvwOpnn1", agreeMap);
				
				List agreeFileList1 = commonDao.selectList("oldDataSql.getAgreeFile6", agreeMap);
				for (int a=0; a<agreeFileList1.size(); a++) {
					HashMap agreeFileMap = (HashMap)agreeFileList1.get(a);
					agreeFileMap.put("RVW_OPNN_MNG_NO", rvwOpnnSeq);
					commonDao.insert("oldDataSql.insertAgreeFile1", agreeFileMap);
				}
			}
			
			//메모 넣기위해서 조회
//			HashMap memoMap = commonDao.select("oldDataSql.getConsultMemo1", consultMap);
			List agreeMemo1 = commonDao.selectList("oldDataSql.getAgreeMemo1", agreeMap);
			for (int m=0; m<agreeMemo1.size(); m++) {
				HashMap agreeMemoMap = (HashMap)agreeMemo1.get(m);
				commonDao.insert("oldDataSql.insertAgreeMemo1", agreeMemoMap);
				List agreeMemoFile1 = commonDao.selectList("oldDataSql.getAgreeMemoFile1", agreeMemoMap);
//				HashMap memoFileMap = commonDao.select("oldDataSql.getConsultMemoFile1", memoMap);
				for (int f=0; f<agreeMemoFile1.size(); f++) {
					HashMap agreeMemoFileMap = (HashMap)agreeMemoFile1.get(f);
					agreeMemoFileMap.put("CVTN_MNG_NO_1", agreeMemoMap.get("CVTN_MNG_NO"));
					agreeMemoFileMap.put("TRGT_PST_MNG_NO_1", agreeMemoMap.get("CVTN_MEMO_MNG_NO"));
					commonDao.insert("oldDataSql.insertAgreeMemoFile1", agreeMemoFileMap);
				}
			
			}
			
		}
		
		List agreeFile1 = commonDao.selectList("oldDataSql.getAgreeFile1");
		for (int s=0; s<agreeFile1.size(); s++) {
			HashMap agreeFileMap = (HashMap)agreeFile1.get(s);
			commonDao.insert("oldDataSql.insertAgreeFile2", agreeFileMap);
		}
		
		List agreeFile2 = commonDao.selectList("oldDataSql.getAgreeFile3");
		for (int s=0; s<agreeFile2.size(); s++) {
			HashMap agreeFileMap = (HashMap)agreeFile2.get(s);
			commonDao.insert("oldDataSql.insertAgreeFile2", agreeFileMap);
		}
		
		List agreeFile3 = commonDao.selectList("oldDataSql.getAgreeFile5");
		for (int s=0; s<agreeFile3.size(); s++) {
			HashMap agreeFileMap = (HashMap)agreeFile3.get(s);
			commonDao.insert("oldDataSql.insertAgreeFile2", agreeFileMap);
		}
		
		List agreeFile4 = commonDao.selectList("oldDataSql.getAgreeFile7");
		for (int s=0; s<agreeFile4.size(); s++) {
			HashMap agreeFileMap = (HashMap)agreeFile4.get(s);
			commonDao.insert("oldDataSql.insertAgreeFile2", agreeFileMap);
		}
		
		LocalDateTime endTime = LocalDateTime.now();
		System.out.println("이관 시작 시간 : " + startTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		System.out.println("이관 종료 시간 : " + endTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		
		System.out.println(":::::::::::::: 협약 데이터 이관 끝 ::::::::::::::");
	}
	
	// 자문 회의 데이터 
	public void setConferenceOldData() {
		System.out.println(":::::::::::::: 자문 회의 데이터 이관 시작 ::::::::::::::");
		LocalDateTime startTime = LocalDateTime.now();
		System.out.println("이관 시작 시간 : " + startTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		
		List conferenceMst1 = commonDao.selectList("oldDataSql.getConferenceInfo1"); // 기본 회의 테이블에서 구두자문 제외한 정보 가져오기
		for (int s=0; s<conferenceMst1.size(); s++) {
			HashMap conferenceMap = (HashMap)conferenceMst1.get(s);
			commonDao.insert("oldDataSql.insertConferenceInfo1", conferenceMap);
			List conferenceFileList1 = commonDao.selectList("oldDataSql.getConferenceFile1", conferenceMap);
			for (int a=0; a<conferenceFileList1.size(); a++) {
				HashMap conferenceFileMap = (HashMap)conferenceFileList1.get(a);
				commonDao.insert("oldDataSql.insertConferenceFile1", conferenceFileMap);
			}
		}
		
		LocalDateTime endTime = LocalDateTime.now();
		System.out.println("이관 시작 시간 : " + startTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		System.out.println("이관 종료 시간 : " + endTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
		
		System.out.println(":::::::::::::: 자문 회의 데이터 이관 끝 ::::::::::::::");
		
	}
}
