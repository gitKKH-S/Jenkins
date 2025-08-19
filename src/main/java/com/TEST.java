package com;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.Comparator;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.mten.util.MakeHan;

public class TEST {
	public static void main(String args[]){
		File directory = new File("D:\\새 폴더\\dataFile\\bbs\\");
		File[] files = directory.listFiles();
		Arrays.sort(files, new Comparator<File>() {
		    public int compare(File f1, File f2) {
		        return Long.compare(f1.lastModified(), f2.lastModified());
		    }
		});
		long time = System.currentTimeMillis() - (1*60*60*1000);
		System.out.println(time);
		
		for(int i=0; i<files.length; i++){
			File rf = files[i];
			if(time > rf.lastModified()){
				System.out.println(rf.getName()+"////"+rf.lastModified());
				rf.delete();
			}
		}
		
	}
	public static void fcopy(File file, File temp){
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
	public static void copy(File sourceF, File targetF){
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
		
    public static void delete(String path) {
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
	public static void main2(String args[]) throws IOException, SAXException, ParserConfigurationException, XPathExpressionException{
		String OPATH = "C:/Users/mten/Desktop/exreceivetemp/";
		String GPATH = "C:/Users/mten/Desktop/test/";
		
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
			    String expression = "//doctype";
			    Node  cols = (Node) xpath.compile(expression).evaluate(document, XPathConstants.NODE);
			    String result = cols.getTextContent();	//(submit:상신)(approval:완료)(return:반려)
			    
			    expression = "//administrativenum";
			    cols = (Node) xpath.compile(expression).evaluate(document, XPathConstants.NODE);
			    
			    String key = cols.getTextContent();
			    
			    System.out.println(result + "///////" + key);
			}
		}
	}
	
	
	public static void mainon(String args[]) throws Exception{
		/*OnsLegacyInfo onsLegacyInfo = new OnsLegacyInfo();
		
		String lawKey = "LAW-1234";
		String sendTemp = PropertiesReader.getString("sendTemp") + lawKey + File.separator;		//실제 inf, xml 이 생성될 위치 이며 첨부파일이 있는경우 해당 폴더에 위치해 있어야 함
		
		//斫?정보
		String[] commonData = new String[9];
		commonData[0] = lawKey;		//행정정보 유일키
		commonData[1] = "test";				//제목
		commonData[2] = "IQIS";						//행정정보ID
		commonData[3] = "QMC";						//업무ID
		commonData[4] = "003";						//양식번호
		commonData[5] = "2018-04-17 16:20:20";		//문서생성일자(yyyy-MM-dd HH:mm:ss)
		commonData[6] = "국방기술품질원장";              //발신명의
		commonData[7] = "dopt1";                    //문서관리카드종류(내부:dopt1, 대내외시행:dopt2)
		commonData[8] = "2NNNNNNNN";                //공개여부코드(공개:1NNNNNNNN, 비공개:2NNNNNNNN, 부분공개:3NNNNNNNN)
		
		
		//기안자 ID		
		String userId = "sunnye";
		
		//수신처정보 
		//대내 {"RECEIPT", "yes|no", "수신기관명", "수신기관코드", "참조부서명", "참조부서코드"}
		//대외{"EXRECEIPT", "yes|no", "수신기관명", "수신기관코드", "참조부서명", "참조부서코드", "기관종류", "기관종류타입", "수신시스템종류", "수신시스템종류타입", "수신망종류", "수신망종류타입"}
		String[][] receiverData ={
				{"RECEIPT", "no", "홍보협력실", "980P075", "", ""},
				{"EXTERNAL", "yes", "국방정보본부장", "1290455", "해외정보종합분석과장", "980C502", "공공기관", "PUB", "온-나라시스템", "O", "기관디렉토리", "DRT02"}
		};
		String[][] receiverData = null;
		
		
		//서식 필드
		String[][] fieldData = {
				{"내용", "test"}
		};
		//String[][] fieldData = null;
		
		
		//첨부파일  {파일명, 파일표시명, 순서}
		//String[][] attachData = {{"a7b8f5c6a6ac45be84a9bfb2cc8b7eec.pdf", "(석문전기)국방품질경영체제 시정조치결과서.pdf", "1"}};
		//String[][] attachData = {{"test.txt", "txt파일.txt", "1"}};
		String[][] attachData = {
				{"test.txt", "txt파일.txt", "1"},
				{"test.hwp", "hwp파일.hwp", "2"}
		};
		String[][] attachData = null;
		
		
		String[] exchangeInfo = onsLegacyInfo.sendLaw(sendTemp, commonData, userId, receiverData, fieldData, attachData);
		
		String del = ""+(char)18+"";
		String UserID = exchangeInfo[0];     //사용자 사번
		String UserPWD = "";         // 패스워드 공백
		String UserDept = ""; //부서코드
		
		String exChangeId = exchangeInfo[3];
		System.out.println(exChangeId);
		String enc = sutil.Encrypt.com_Encode("SSO" + del + UserID + del + UserPWD + del +  UserDept + del);
		String enExId = sutil.Encrypt.com_Encode( del + exChangeId + del );
		String url = "http://8.1.4.126/bms/com/SSO.do?L1="+enc+"&DOC_TYPE=EX&EX_ID="+enExId;*/
	}
}
