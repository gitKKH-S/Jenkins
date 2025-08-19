package com.mten.bylaw.gian.service;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.Set;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.w3c.dom.CDATASection;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.mten.bylaw.agree.service.AgreeService;
import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.consult.service.ConsultService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.dao.CommonDao;
import com.mten.util.MakeHan;
import com.mten.util.zipFileDownload;

import webservice.WebLogicWebServiceCall;

@Service("gianService")
public class GianServiceImpl implements GianService{
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="bylawService")
	private BylawService bylawService;
	
	@Resource(name="cousultService")
	private ConsultService consultService;
	
	@Resource(name="agreeService")
	private AgreeService agreeService;

	@Resource(name = "suitService")
	private SuitService suitService;
	
	public String sendserverid = "ADM6110000A8";
	public String receiveserverid = "DOC611000001";
	public String doctype = "send";
	public String maintype = "MOS0003";
	public String subtype = "amiso3";
	
	public String systemid = "goyang_jaass";
	public String authkey = "bb73g5616782q1k6f27454abc3fbed5qb1379c603ek3f7f42cb34e0d07724511";
	public String deptcd = "Z999902";
	public String loginid = "edu005";
	public String deptname = "교육1과";
	public String onsurl = "http://105.10.1.42"; // 온나라 주소
	
	public void makeXml(Map<String, Object> mtenMap) {
		List flist = mtenMap.get("flist")==null?new ArrayList():(ArrayList)mtenMap.get("flist");
		
		try
		{
			String onsPath = mtenMap.get("ONSPATH")==null?"":mtenMap.get("ONSPATH").toString();
			
			String fPath = MakeHan.File_url(mtenMap.get("FPATH").toString());
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			// 루트 엘리먼트
			Document doc = docBuilder.newDocument();
			doc.setXmlStandalone(true);
			Element rootElement = doc.createElement("EXCHANGE");
			doc.appendChild(rootElement);

			Element HEADER = doc.createElement("HEADER");
			rootElement.appendChild(HEADER);
			
			Element COMMON = doc.createElement("COMMON");
			HEADER.appendChild(COMMON);
			
			Element SENDER = doc.createElement("SENDER");
			COMMON.appendChild(SENDER);
			
			Element SSERVERID = doc.createElement("SERVERID");
			SENDER.appendChild(SSERVERID);
			SSERVERID.setTextContent(sendserverid);
			
			Element SUSERID = doc.createElement("USERID");
			SENDER.appendChild(SUSERID);
			SUSERID.setTextContent(loginid);
			
			Element SEMAIL = doc.createElement("EMAIL");
			SENDER.appendChild(SEMAIL);
			SEMAIL.setTextContent("123@234.com");
			
			Element RECEIVER = doc.createElement("RECEIVER");
			COMMON.appendChild(RECEIVER);
			
			Element RSERVERID = doc.createElement("SERVERID");
			RECEIVER.appendChild(RSERVERID);
			RSERVERID.setTextContent(receiveserverid);
			
			Element RUSERID = doc.createElement("USERID");
			RECEIVER.appendChild(RUSERID);
			RUSERID.setTextContent(loginid);
			
			Element REMAIL = doc.createElement("EMAIL");
			RECEIVER.appendChild(REMAIL);
			REMAIL.setTextContent("123@234.com");
			
			Element TITLE = doc.createElement("TITLE");
			COMMON.appendChild(TITLE);
			
			//CDATASection cTITLE = doc.createCDATASection("호출기안테스트 onstest20181126_001");
			String Title = mtenMap.get("TITLE")==null?"호출기안테스트":mtenMap.get("TITLE").toString();
			CDATASection cTITLE = doc.createCDATASection(Title); 
			TITLE.appendChild(cTITLE);
			
			Element CREATED_DATE = doc.createElement("CREATED_DATE");
			COMMON.appendChild(CREATED_DATE);
			CREATED_DATE.setTextContent(mtenMap.get("CREATED_DATE").toString());
			
			Element ATTACHNUM = doc.createElement("ATTACHNUM");
			COMMON.appendChild(ATTACHNUM);
			ATTACHNUM.setTextContent(flist.size()+"");
			
			Element ADMINISTRATIVE_NUM = doc.createElement("ADMINISTRATIVE_NUM");
			COMMON.appendChild(ADMINISTRATIVE_NUM);
			ADMINISTRATIVE_NUM.setTextContent("LAW"+mtenMap.get("GIANID"));
			Element DIRECTION = doc.createElement("DIRECTION");
			HEADER.appendChild(DIRECTION);
			
			Element TO_DOCUMENT_SYSTEM = doc.createElement("TO_DOCUMENT_SYSTEM");
			DIRECTION.appendChild(TO_DOCUMENT_SYSTEM);
			TO_DOCUMENT_SYSTEM.setAttribute("notification", "final");
			
			Element LINES = doc.createElement("LINES");
			TO_DOCUMENT_SYSTEM.appendChild(LINES);
			
			Element LINE = doc.createElement("LINE");
			LINES.appendChild(LINE);
			
			Element LEVEL = doc.createElement("LEVEL");
			LINE.appendChild(LEVEL);
			LEVEL.setTextContent("1");
			
			Element SANCTION = doc.createElement("SANCTION");
			LINE.appendChild(SANCTION);
			SANCTION.setAttribute("result", "미처리");
			SANCTION.setAttribute("type", "기안");
			
			Element PERSON = doc.createElement("PERSON");
			SANCTION.appendChild(PERSON);
			
			Element USERID = doc.createElement("USERID");
			PERSON.appendChild(USERID);
			USERID.setTextContent(loginid);
			
			Element NAME = doc.createElement("NAME");
			PERSON.appendChild(NAME);
			NAME.setTextContent("");//session
			
			Element POSITION = doc.createElement("POSITION");
			PERSON.appendChild(POSITION);
			POSITION.setTextContent("");//session
			
			Element DEPT = doc.createElement("DEPT");
			PERSON.appendChild(DEPT);
			CDATASection cDEPT = doc.createCDATASection(deptname);//session 
			DEPT.appendChild(cDEPT);
			
			Element ORG = doc.createElement("ORG");
			PERSON.appendChild(ORG);
			CDATASection cORG = doc.createCDATASection("서울특별시"); 
			ORG.appendChild(cORG);
			
			Element DATE = doc.createElement("DATE");
			SANCTION.appendChild(DATE);
			DATE.setTextContent(mtenMap.get("CREATED_DATE").toString());
			
			Element MODIFICATION_FLAG = doc.createElement("MODIFICATION_FLAG");
			TO_DOCUMENT_SYSTEM.appendChild(MODIFICATION_FLAG);
			
			Element MODIFIABLE = doc.createElement("MODIFIABLE");
			MODIFICATION_FLAG.appendChild(MODIFIABLE);
			MODIFIABLE.setAttribute("modifyflag", "no");
			
			Element DOC_INFO = doc.createElement("DOC_INFO");
			TO_DOCUMENT_SYSTEM.appendChild(DOC_INFO);
			
			String summary = mtenMap.get("BODY")==null?"문서요지 입니다.":mtenMap.get("BODY").toString();
			Element SUMMARY = doc.createElement("SUMMARY");
			DOC_INFO.appendChild(SUMMARY);
			//CDATASection cSUMMARY = doc.createCDATASection("문서요지 입니다."); 
			CDATASection cSUMMARY = doc.createCDATASection(summary); 
			SUMMARY.appendChild(cSUMMARY);

			
			Element BODY = doc.createElement("BODY");
			BODY.setAttribute("filename", "attach_body_LAW"+mtenMap.get("GIANID")+".txt");
			rootElement.appendChild(BODY);
			
			String bodys = mtenMap.get("BODY")==null?"본문내용 테스트":mtenMap.get("BODY").toString();
			String bodyr[] = bodys.split("\n");
		    BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(onsPath+"attach_body_LAW"+mtenMap.get("GIANID")+".txt",false), "euc-kr"));
            for(int h=0; h<bodyr.length; h++){
            	writer.write(bodyr[h]);writer.write("\n");
            }
		    writer.close();
			
			String Body = mtenMap.get("BODY")==null?"본문내용 테스트":mtenMap.get("BODY").toString();
			CDATASection cBODY = doc.createCDATASection(Body); 
			BODY.appendChild(cBODY);
			
			Element ATTACHMENTS = doc.createElement("ATTACHMENTS");
			rootElement.appendChild(ATTACHMENTS);
			
			if(flist.size()>0){
				for(int i=0; i<flist.size(); i++){
					HashMap finfo = (HashMap)flist.get(i);
					
					Element ATTACHMENT = doc.createElement("ATTACHMENT");
					ATTACHMENTS.appendChild(ATTACHMENT);
					
					zipFileDownload.fileCopy(fPath+finfo.get("SERVERFILE"),onsPath+"attach_attach_"+finfo.get("SERVERFILE"));
					ATTACHMENT.setAttribute("filename", "attach_attach_"+finfo.get("SERVERFILE"));
					ATTACHMENT.setAttribute("desc", String.format("%03d", i+1));
					
					CDATASection cATTACHMENT = doc.createCDATASection(finfo.get("PCFILENAME").toString()); 
					ATTACHMENT.appendChild(cATTACHMENT);
				}
			}

			// XML 파일로 쓰기
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4"); //정렬 스페이스4칸
			transformer.setOutputProperty(OutputKeys.ENCODING, "EUC-KR");
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");	
			
			DOMImplementation domImpl = doc.getImplementation();
			
			transformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "exchange.dtd");
			
			DOMSource source = new DOMSource(doc);
			StreamResult result = null;
			try {
				result = new StreamResult(new FileOutputStream(new File(onsPath+"exchange.xml")));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			
			// 파일로 쓰지 않고 콘솔에 찍어보고 싶을 경우 다음을 사용 (디버깅용)
			// StreamResult result = new StreamResult(System.out);

			transformer.transform(source, result);

			System.out.println("File saved!");
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
		catch (ParserConfigurationException pce)
		{
			pce.printStackTrace();
		}
		catch (TransformerException tfe)
		{
			tfe.printStackTrace();
		}

	}
	
	public JSONObject gianOnsStart(Map<String, Object> mtenMap) {
		System.out.println(mtenMap);
		
		loginid = mtenMap.get("WRTR_EMP_NO").toString();	//운영
		deptcd = mtenMap.get("WRT_DEPT_NO").toString().substring(0, 7);	//운영
		deptname = mtenMap.get("WRT_DEPT_NM").toString(); //운영
		
		System.out.println("gianOnsStart loginid : "  + loginid);
		System.out.println("gianOnsStart deptcd : "   + deptcd);
		System.out.println("gianOnsStart deptname : " + deptname);
		
		SimpleDateFormat format = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat format2 = new SimpleDateFormat ( "yyyyMMddHHmmss");
		Calendar time = Calendar.getInstance();
		String format_time = format.format(time.getTime());
		String format_time2 = format2.format(time.getTime());
		mtenMap.put("CREATED_DATE", format_time);
		
		System.out.println("gianOnsStart 1111111");
		
		String callUrl = "";
		FileWriter writer2 = null;
		try {
			System.out.println("gianOnsStart 222222222");
			
			Random random = new Random();
			int num = 10000 + random.nextInt(90000);
			String onsPath = MakeHan.File_url("ONSPATH")+loginid+sendserverid+receiveserverid+format_time2+num+"/";
			
			System.out.println("gianOnsStart 33333333333333");
			File chk = new File(onsPath);
			if(!chk.isDirectory()) {
				chk.mkdirs();
			}
			
			System.out.println("gianOnsStart 4444444444");
			mtenMap.put("ONSPATH", onsPath);
			//xml파일생성
			this.makeXml(mtenMap);
			
			String docgbn = mtenMap.get("DOCGBN")==null?"":mtenMap.get("DOCGBN").toString();
			String docid = mtenMap.get("DOCID")==null?"":mtenMap.get("DOCID").toString();
			String GIANID = mtenMap.get("GIANID")==null?"":mtenMap.get("GIANID").toString();
			if(docgbn.equals("AGREE")) {
				HashMap param = new HashMap();
				param.put("CVTN_MNG_NO", docid);
				param.put("DRFT_MNG_NO", GIANID);
				agreeService.updateDGSTFN_GIAN(param);
			}
			
			
			System.out.println("gianOnsStart 555555555555555");
			
		    File eof = new File(onsPath+"eof.inf");
		    boolean success = eof.createNewFile();
		    
		    System.out.println("gianOnsStart 6666666666666666");
		   
		    File header = new File(onsPath+"header.inf");
		    
		    BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(onsPath+"header.inf",false), "euc-kr"));
		    //success = header.createNewFile();
		    //writer = new FileWriter(header, false);
		    writer.write("type=send");writer.write("\n");
			writer.write("date="+mtenMap.get("CREATED_DATE"));writer.write("\n");
			writer.write("sender="+sendserverid);writer.write("\n");
			writer.write("receiver="+receiveserverid);writer.write("\n");
			writer.write("sender_userid="+ loginid);writer.write("\n");
			writer.write("receiver_userid="+ loginid);writer.write("\n");
			writer.write("sender_email=");writer.write("\n");
			writer.write("sender_orgname=서울특별시");writer.write("\n");
			writer.write("sender_systemname=법률지원통합시스템");writer.write("\n");
			writer.write("administrative_num="+"LAW"+mtenMap.get("GIANID"));writer.write("\n");
            //writer.flush();
            writer.close();
            System.out.println("gianOnsStart 777777777");
            
	    	//WebLogicWebServiceCall call = new WebLogicWebServiceCall(onsurl);   // 웹서비스 호출 
	    	//String exchangeId = call.exchangeIDCall(loginid, deptcd, systemid, authkey);  // 연계아이디 생성
	    	//String retStr =call.addExchangeFileInfoCall(onsPath, loginid, deptcd, systemid, authkey, exchangeId);  // 연계파일 전달
	    	//callUrl = call.getSSOUrl(loginid, deptcd, exchangeId);  // sso 로그인
		} catch (Exception e) {
		    e.printStackTrace();
		} finally {
            try {
                if(writer2 != null) writer2.close();
            } catch(IOException e) {
                e.printStackTrace();
            }
        }
		JSONObject result = new JSONObject();
		result.put("callUrl", callUrl);
		return result;
	}
	
	public Map gainInsert(Map<String, Object> mtenMap){
		commonDao.insert("gianSql.gianAllInsert",mtenMap);
		return mtenMap;
	}
	
	public Map gainDelete(Map<String, Object> mtenMap){
		commonDao.insert("gianSql.gianAllDelete",mtenMap);
		return mtenMap;
	}
	
	
	public String gianStart(Map<String, Object> mtenMap){
		String BOOKIDS = mtenMap.get("BOOKIDS")==null?"":mtenMap.get("BOOKIDS").toString();
		String STATEHISTORYIDS = mtenMap.get("STATEHISTORYIDS")==null?"":mtenMap.get("STATEHISTORYIDS").toString();
		String KEY = mtenMap.get("KEY")==null?"":mtenMap.get("KEY").toString();
		
		String[] BOOKID = BOOKIDS.split(",");
		String[] STATEHISTORYID = STATEHISTORYIDS.split(",");
		
		String gianid = "";
		String pgianid = "";
		HashMap param = new HashMap();
		for(int i =0 ; i<BOOKID.length;i++){
			param.put("BOOKID", BOOKID[i]);
			param.put("STATEHISTORYID", STATEHISTORYID[i]);
			param.put("STATEID", KEY);
			param.put("UPDT", MakeHan.get_data());
			param.put("ENDDT", MakeHan.get_data());
			commonDao.delete("gianSql.gianAllDelete",param);
			if(i==0){
				param.put("PGIANID", "");
			}
			commonDao.insert("gianSql.gianAllInsert",param);
			gianid = param.get("GIANID").toString();
			System.out.println("gianid===>"+gianid);
			if(i==0){
				System.out.println("PGIANID===>"+gianid);
				param.put("PGIANID", gianid);
				pgianid = gianid;
			}
			System.out.println("gianid===>"+gianid);
			
		}
		
		return pgianid;
	}
	
	public void fcopy(File file, File temp){
		FileInputStream fis = null;
		FileOutputStream fos = null;
		try {
			fis = new FileInputStream(file);
			fos = new FileOutputStream(temp) ;
			byte[] b = new byte[4096];
			int cnt = 0;
			while((cnt=fis.read(b)) != -1){
				fos.write(b, 0, cnt);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			try {
				fis.close();
				fos.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
				
		}
	}
	
	public void copy(File sourceF, File targetF){
		if(sourceF.isFile()){
			fcopy(sourceF, targetF);
		}else{
			File[] target_file = sourceF.listFiles();
			for (File file : target_file) {
				File temp = new File(targetF.getAbsolutePath() + File.separator + file.getName());
				if(file.isDirectory()){
					temp.mkdir();
					fcopy(file, temp);
				} else {
					fcopy(file, temp);
				}
			}
		}
	}
		
    public void delete(String path) {
    	File folder = new File(path);
		try {
			if(folder.isFile()){
				folder.delete();
			}else{
				if(folder.exists()){
				    File[] folder_list = folder.listFiles();
				    for (int i = 0; i < folder_list.length; i++) {
						if(folder_list[i].isFile()) {
							folder_list[i].delete();
						}else {
							delete(folder_list[i].getPath());
						}
						folder_list[i].delete();
				    }
				    folder.delete();
				}
			}
		} catch (Exception e) {
			e.getStackTrace();
		}
    }

	public void gianAllUpdate() throws IOException, SAXException, ParserConfigurationException, XPathExpressionException{
		/*String ONSPATH = MakeHan.File_url("ONSPATH");
		File directory = new File(ONSPATH);
		File[] files = directory.listFiles();
		Arrays.sort(files, new Comparator<File>() {
		    public int compare(File f1, File f2) {
		        return Long.compare(f1.lastModified(), f2.lastModified());
		    }
		});
		long time = System.currentTimeMillis() - (1*60*60*1000);
		for(int i=0; i<files.length; i++){
			File rf = files[i];
			if(time > rf.lastModified()){
				rf.delete();
			}
		}*/
		
		
		String OPATH = MakeHan.File_url("ORECEIVE");
		String GPATH = MakeHan.File_url("GRECEIVE");
		
		File chk = new File(OPATH);
		File chk2[] = chk.listFiles();
		for(int i=0; i<chk2.length; i++){
			File tmp = (File)chk2[i];
			File tmp2 = new File(GPATH+tmp.getName());
			if(tmp.isDirectory()){
				if(!tmp2.exists()){
					tmp2.mkdirs();
				}
			}
			copy(tmp, tmp2);
			delete(tmp.toString());
			
			if(tmp2.isFile()){
				InputSource   is = new InputSource(new FileReader(tmp2.toString()));
				Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
				 // xpath 생성
			    XPath  xpath = XPathFactory.newInstance().newXPath();
			    String expression = "//type/@doc-type";	//결과값
			    String  result = (String) xpath.compile(expression).evaluate(document, XPathConstants.STRING);
			    System.out.println(result);
			    
			    
			    
			    expression = "//administrative_num";	//DB아이디값
			    Node cols = (Node) xpath.compile(expression).evaluate(document, XPathConstants.NODE);
			    String key = cols.getTextContent();
			    key = key.replaceAll("LAW","").trim();
			    
			    HashMap para = new HashMap();
			    para.put("GIANID", key);
			    para.put("GIANSTATE", result);
			    para.put("GIANINFO", tmp2.getName().replace(".xml", ""));
			    para.put("GIANKEY", tmp2.getName());
			    System.out.println(para);
			    if(result.equals("submit") || result.equals("approval") || result.equals("return") || result.equals("retrieval")){
			    	HashMap param = new HashMap();
		    		param.put("GIANID", key);
			    	if(result.equals("submit")){	//상신
			    		param.put("PRGRS_STTS_SE_NM", "내부결재중");
			    	}else if(result.equals("approval")){	//승인
			    		param.put("PRGRS_STTS_SE_NM", "접수대기");
			    	}else if(result.equals("return") || result.equals("retrieval")){	//반려
			    		param.put("PRGRS_STTS_SE_NM", "작성중");
			    	}
		    		agreeService.updateDGSTFN_GIAN_STATE(param);
			    }
			}
		}
		
		
		
		/*HashMap gianstatecd = new HashMap();
		gianstatecd.put("APS_001_1", "결재중");
		gianstatecd.put("APS_002_0", "결재완료");
		gianstatecd.put("APS_002_1", "결재완료");
		gianstatecd.put("APS_003_0", "결재취소");
		gianstatecd.put("APS_004_0", "반려");
		gianstatecd.put("APR_001_1", "접수중");
		gianstatecd.put("APR_002_0", "접수완료");
		gianstatecd.put("APR_002_1", "접수완료");
		gianstatecd.put("APR_004_0", "반송");
		gianstatecd.put("APR_005_0", "반송");
		
		String STATCD = para.get("STATCD")==null?"":para.get("STATCD").toString();
		para.put("STATCD", gianstatecd.get(para.get("STATCD")));
		
		commonDao.update("gianSql.gianAllUpdate",para);
		
		List list = commonDao.selectList("gianSql.gianAllList",para);
		for(int i=0; i<list.size(); i++){
			HashMap gre = (HashMap)list.get(i);
			String nextid = gre.get("NEXTID").toString();
			String preid = gre.get("PREID").toString();
			gre.put("bookIds", gre.get("BOOKID"));
			gre.put("statehistoryids", gre.get("STATEHISTORYID"));
			gre.put("startDts", gre.get("STARTDT"));
			if(!nextid.equals("0")){
				if(STATCD.equals("APS_001_1")){//결재상신
					gre.put("nowstateCd", 9999);
					bylawService.updateStep(gre);
				}else if(STATCD.equals("APS_002_0") || STATCD.equals("APS_002_1") || STATCD.equals("APR_002_0") || STATCD.equals("APR_002_1")){	//결재완료
					gre.put("nowstateCd", nextid);
					bylawService.updateStep(gre);
				}else if(STATCD.equals("APS_003_0") || STATCD.equals("APS_004_0") || STATCD.equals("APR_004_0") || STATCD.equals("APR_005_0")){	//취소 반려
					gre.put("nowstateCd", preid);
					bylawService.updateStep(gre);
				}
			}
			
		}*/
	}
	
	
	public void testGian(String fpath,String fname) {
		try{
			InputSource   is = new InputSource(new FileReader(fpath));
			Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
			 // xpath 생성
		    XPath  xpath = XPathFactory.newInstance().newXPath();
		    String expression = "//doctype";	//결과값
		    Node  cols = (Node) xpath.compile(expression).evaluate(document, XPathConstants.NODE);
		    String result = cols.getTextContent();	//(submit:상신)(approval:완료)(return:반려)(retrieval:회수)
		    expression = "//administrativenum";	//DB아이디값
		    cols = (Node) xpath.compile(expression).evaluate(document, XPathConstants.NODE);
		    String key = cols.getTextContent();
		    key = key.replaceAll("LAW","").trim();
		    
		    HashMap para = new HashMap();
		    para.put("GIANID", key);
		    para.put("GIANSTATE", result);
		    para.put("GIANINFO", fname.replace(".xml", ""));
		    para.put("GIANKEY", fname);
		    commonDao.update("gianSql.gianAllUpdate",para);
		    if(result.equals("submit") || result.equals("approval") || result.equals("return") || result.equals("retrieval")){
			    List list = commonDao.selectList("gianSql.gianAllList",para);
			    for(int k=0; k<list.size(); k++){
			    	HashMap info = (HashMap)list.get(k);
			    	String docgbn = info.get("DOCGBN")==null?"":info.get("DOCGBN").toString();
			    	String docid = info.get("DOCID")==null?"":info.get("DOCID").toString();
			    	String stat = "";
			    	String statc = "";
			    	if(result.equals("submit")){
			    		statc = info.get("NSTATECD")==null?"":info.get("NSTATECD").toString();
			    		stat = info.get("NSTATECD")==null?"":info.get("NSTATECD").toString();
			    	}else if(result.equals("approval")){
			    		stat = info.get("OKSTATECD")==null?"":info.get("OKSTATECD").toString();
			    	}else if(result.equals("return") || result.equals("retrieval")){
			    		stat = info.get("NOSTATECD")==null?"":info.get("NOSTATECD").toString();
			    	}
			    	if(!statc.equals("완료")){
			    		if(docgbn.equals("AGREE")){
				    		
				    		Map param = new HashMap();
				    		param.put("statecd", stat);
				    		param.put("agreeid", docid);
				    		//agreeService.nextStep(param);
				    		
				    	}else if(docgbn.equals("CONSULT")){
				    		
				    		Map param = new HashMap();
				    		param.put("statcd", stat);
				    		param.put("consultid", docid);
				    		//consultService.nextStepconsult(param);
				    		
				    	}else if(docgbn.equals("SUIT")){
				    		Map param = new HashMap();
				    		param.put("state", stat);
				    		param.put("reviewid", docid);
				    		//suitService.reviewStateChange(param);
				    		
				    	}else if(docgbn.equals("BYLAW")){
				    		if(!stat.equals("1800")){
					    		HashMap gre = (HashMap)list.get(k);
								gre.put("bookIds", gre.get("DOCSUBID"));
								gre.put("statehistoryids", gre.get("DOCID"));
								gre.put("startDts", gre.get("UPDT"));
					    		gre.put("nowstateCd", stat);
								//bylawService.updateStep(gre);
				    		}
				    	}
			    	}
			    }
		    }
		}catch(Exception e){
			System.out.println(e);
		}
	}
}