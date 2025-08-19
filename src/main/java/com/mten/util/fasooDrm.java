package com.mten.util;


import com.fasoo.adk.packager.*;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.security.KeyStore;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.*;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.SingleClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;

public class fasooDrm {
	public  static String FileTypeStr(int i) {
		String ret = null;
		switch(i) {
			case 20 : ret = "파일을 찾을 수 없습니다."; break;
			case 21 : ret = "파일 사이즈가 0 입니다.";  break;
			case 22 : ret = "파일을 읽을 수 없습니다."; break;
			case 29 : ret = "암호화 파일이 아닙니다.";  break;
			case 26 : ret = "FSD 파일입니다.";          break;
			case 105: ret = "Wrapsody 파일입니다.";     break;
			case 106: ret = "NX 파일입니다.";           break;
			case 101: ret = "MarkAny 파일입니다.";      break;
			case 104: ret = "INCAPS 파일입니다.";       break;
			case 103: ret = "FSN 파일입니다.";          break;
		}
		
		return ret;
	}
	
	public static ResourceBundle bundle   =  ResourceBundle.getBundle("egovframework.property.url");
	public static void main(String[] args) throws IOException {
		boolean iret = false;
		int retVal = 0;
		
		//DRM Config Information
		String strFsdinitPath = bundle.getString("mten.fasoostrFsdinitPath");//"./fsdinit";
		String strCPID = bundle.getString("mten.fasoostrstrCPID");//"0100000000002122";
		String strOrgFilePath = "C:/Users/user/Desktop/1.txt";
		String strFileName = "test.txt";
		String strEncFilePath = "C:/Users/user/Desktop/2.txt";
		
		WorkPackager objWorkPackager = new WorkPackager();
		//암호화 대상 파일이 한글 파일명일 경우 암호화 시도 시 파일을 찾을 수 없다는 에러가 나올경우 아래 해당 옵션을 지정 (utf-8, euckr, ksc5601 등)
		//objWorkPackager.setCharset("eucKR");
		
		//암호화된 문서를 덮어쓰지 않음 - false, 덮어쓰기 - true
		objWorkPackager.setOverWriteFlag(false);
		
		retVal = objWorkPackager.GetFileType(strOrgFilePath);
		
		System.out.println("파일형태는 " + FileTypeStr(retVal) + "["+retVal+"]"+" 입니다.");
		
		//일반 파일의 경우
		if (retVal == 29) {
			iret = objWorkPackager.DoPackaging(
				strFsdinitPath,  //fsdinit 폴더 FullPath 설정
				strCPID,    //고객사 Key(default)
				strOrgFilePath,  //암호화 대상 문서 FullPath + FileName
				strEncFilePath,  //암호화 된 문서 FullPath + FileName
				strFileName,   //파일 명
				"admin",      //작성자 ID
				"관리자",
				"SYSTEM",  
				"BMS",
				"PROGID",
				"",
				""
			);
			
			System.out.println("암호화 결과값 : " + iret);
			System.out.println("암호화 문서 : " + objWorkPackager.getContainerFilePathName());
			System.out.println("오류코드 : " + objWorkPackager.getLastErrorNum());
			System.out.println("오류값 : " + objWorkPackager.getLastErrorStr());
		} else {
			System.out.println("일반 파일이 아닌경우 암호화 불가능 합니다.["+ retVal + "]");
		}
	}
	
	public static void fileDoPackaging(String ofile , String Efile , String path) {
		boolean iret = false;
		int retVal = 0;
		
		//DRM Config Information
		String strFsdinitPath = bundle.getString("mten.fasoostrFsdinitPath");//"./fsdinit";
		String strCPID = bundle.getString("mten.fasoostrstrCPID");//"0100000000002122";
		String strOrgFilePath = path + ofile;
		String strFileName = ofile;
		String strEncFilePath = path + Efile;
		
		WorkPackager objWorkPackager = new WorkPackager();
		//암호화 대상 파일이 한글 파일명일 경우 암호화 시도 시 파일을 찾을 수 없다는 에러가 나올경우 아래 해당 옵션을 지정 (utf-8, euckr, ksc5601 등)
		//objWorkPackager.setCharset("eucKR");
		
		//암호화된 문서를 덮어쓰지 않음 - false, 덮어쓰기 - true
		objWorkPackager.setOverWriteFlag(true);
		
		retVal = objWorkPackager.GetFileType(strOrgFilePath);
		
		System.out.println("파일형태는 " + FileTypeStr(retVal) + "["+retVal+"]"+" 입니다.");
		
		//일반 파일의 경우
		if (retVal == 29) {
			iret = objWorkPackager.DoPackaging(
				strFsdinitPath,  //fsdinit 폴더 FullPath 설정
				strCPID,    //고객사 Key(default)
				strOrgFilePath,  //암호화 대상 문서 FullPath + FileName
				strEncFilePath,  //암호화 된 문서 FullPath + FileName
				strFileName,   //파일 명
				"admin",      //작성자 ID
				"관리자",
				"LSIS",  
				"BMS",
				"PROGID",
				"",
				""
			);
			
			System.out.println("암호화 결과값 : " + iret);
			System.out.println("암호화 문서 : " + objWorkPackager.getContainerFilePathName());
			System.out.println("오류코드 : " + objWorkPackager.getLastErrorNum());
			System.out.println("오류값 : " + objWorkPackager.getLastErrorStr());
		} else {
			System.out.println("일반 파일이 아닌경우 암호화 불가능 합니다.["+ retVal + "]");
		}
	}
	
	public static boolean fileUnPackaging(String Efile , String Dfile , String path) {
		boolean bret = false;
		boolean nret = false;
		boolean iret = false;
		boolean pret = true;
		int retVal = 0;
		
		//DRM Config Information
		String strFsdinitPath = bundle.getString("mten.fasoostrFsdinitPath");//"./fsdinit";
		String strCPID = bundle.getString("mten.fasoostrstrCPID");//"0100000000002122";
		String strEncFilePath = path + Efile;
		String strFileName = Dfile;
		String strDecFilePath = path + Dfile;
		try {
			WorkPackager objWorkPackager = new WorkPackager();
			//objWorkPackager.setCharset("eucKR");
			
			//복호화 된문서가 암호화된 문서를 덮어쓰지 않음 - false, 덮어쓰기 - true
			objWorkPackager.setOverWriteFlag(true);
			
			retVal = objWorkPackager.GetFileType(strEncFilePath);
			
			System.out.println("파일형태는 " + FileTypeStr(retVal) + "["+retVal+"]"+" 입니다.");
			
			//대상 문서가 FSD 암호화 되었을 때만 복호화 실행
			if (retVal == 26) {
				//파일 확장자 체크( IsSupportFile() ) 로직
				iret = objWorkPackager.IsSupportFile(
					strFsdinitPath,
					strCPID,
					strEncFilePath
				);
				System.out.println("지원 확장자 체크  : "+ iret );
				
				//지원 확장자의 경우 복호화 진행
				if (iret == true) {
						// 암호화 된 파일 복호화
						bret = objWorkPackager.DoExtract(
						strFsdinitPath,     //fsdinit 폴더 FullPath 설정
						strCPID,    //고객사 Key(default)
						strEncFilePath,   //복호화 대상 문서 FullPath + FileName
						strDecFilePath  //복호화 된 문서 FullPath + FileName
					);
					
					System.out.println("복호화 결과값 : " + iret);
					System.out.println("복호화 문서 : " + objWorkPackager.getContainerFilePathName());
					System.out.println("오류코드 : " + objWorkPackager.getLastErrorNum());
					System.out.println("오류값 : " + objWorkPackager.getLastErrorStr());
				} else {
					System.out.println("지원 확장자가 아닌경우 복호화 불가능 합니다.["+ iret +"]");
				}
			} else {
				System.out.println("FSN 파일이 아닌경우 복호화 불가능 합니다.["+ retVal + "]");
			}
		} catch (Exception e) {
			System.out.println("DRM 오류");
		}
		
		
		
		String strUrl = bundle.getString("mten.strUrl");//"https://api194.eseoul.go.kr:5443/UPServer/";
		String returnURL = bundle.getString("mten.returnURL");//"115.84.165.44:8080";
		String hostIP = bundle.getString("mten.hostIP");//"115.84.165.44";
		String hostUrl = bundle.getString("mten.hostUrl");//"http://115.84.165.44:8080/PPTEST.jsp";
		String userIP = bundle.getString("mten.userIP");//"127.0.0.1";
		String isPriv = "0";
		
		try {
			// 인증서 로딩 (예: .crt 또는 .cer 파일)
			InputStream certInput = new FileInputStream(bundle.getString("mten.crt"));
			CertificateFactory cf = CertificateFactory.getInstance("X.509");
			X509Certificate caCert = (X509Certificate) cf.generateCertificate(certInput);
			
			// KeyStore에 인증서 추가
			KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
			trustStore.load(null, null); // 빈 keystore
			trustStore.setCertificateEntry("server", caCert);
			
			// TrustManager 초기화
			TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
			tmf.init(trustStore);
			
			// SSLContext에 TrustManager 설정
			SSLContext sslContext = SSLContext.getInstance("TLS");
			sslContext.init(null, tmf.getTrustManagers(), null);
			
			SSLSocketFactory sslSocketFactory = new SSLSocketFactory(sslContext,SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);
			
			SchemeRegistry schemeRegistry = new SchemeRegistry();
			schemeRegistry.register(new Scheme("https",5443,sslSocketFactory));
			
			ClientConnectionManager cm = new SingleClientConnManager(schemeRegistry);
			
			// HTTPS 연결에 사용
			HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.getSocketFactory());
			
			// 테스트 요청
			HttpParams params = new BasicHttpParams();
			DefaultHttpClient client = new DefaultHttpClient(cm);
			
			HttpPost post = new HttpPost(strUrl);
			MultipartEntity entry = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
			
			Map<String,String> easy = new LinkedHashMap<String,String>();
			easy.put("returnURL", returnURL);
			easy.put("hostIP", hostIP);
			easy.put("hostUrl", hostUrl);
			easy.put("userIP", userIP);
			Iterator<String> keys = easy.keySet().iterator();
			while(keys.hasNext()) {
				String key = (String)keys.next();
				StringBody body = new StringBody(easy.get(key) ,"multipart/form-data" ,Charset.forName("UTF-8"));
				entry.addPart(key,(ContentBody)body);
			}
			
			File file = new File(strDecFilePath);
			ContentBody fileBody = new FileBody(file,"multipart/form-data");
			entry.addPart("upload_file1",fileBody);
		
			post.setEntity(entry);
			HttpResponse resp = client.execute(post);
			System.out.println("Response Code: " + resp.getStatusLine().getStatusCode());
			
			HttpEntity responseEntity = resp.getEntity();
			if (responseEntity != null) {
				BufferedReader reader = new BufferedReader(
					new InputStreamReader(responseEntity.getContent(), StandardCharsets.UTF_8)
				);
				
				StringBuilder responseJson = new StringBuilder();
				String line;
				while ((line = reader.readLine()) != null) {
					responseJson.append(line);
				}
				reader.close();
				System.out.println("JSON 응답 결과:");
				System.out.println(responseJson.toString());
				
				String jsondata = responseJson.toString();
				
				JSONObject root = JSONObject.fromObject(jsondata);
				JSONArray privacyArray = root.getJSONArray("privacy");
				
				for (int i = 0; i < privacyArray.size(); i++) {
					JSONObject item = privacyArray.getJSONObject(i);
					isPriv = item.getString("isPriv");
					String privType = item.getString("privType");
					String privContent = item.getString("privContent");
					String checkType = item.getString("checkType");
					
					System.out.println("isPriv: " + isPriv);
					System.out.println("privType: " + privType);
					System.out.println("privContent: " + privContent);
					System.out.println("checkType: " + checkType);
				}
			}
		} catch (Exception e) {
			System.out.println("error:개인정보보호연동 실패"+e);
			pret = false;
		}
		
		if(isPriv.equals("1")) {
			pret = false;
		}
		
		return pret;
	}
}