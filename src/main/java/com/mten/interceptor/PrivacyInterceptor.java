package com.mten.interceptor;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.bylaw.service.LogService;
import com.mten.bylaw.bylaw.service.ProcService;
import com.mten.bylaw.pds.service.PdsService;
import com.mten.bylaw.web.service.WebService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.security.KeyStore;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.StringJoiner;

import javax.annotation.Resource;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class PrivacyInterceptor extends HandlerInterceptorAdapter {
	public static ResourceBundle bundle 		= 	ResourceBundle.getBundle("egovframework.property.url"); 
	
	public String getParameterString(HttpServletRequest request, String delimiter) {
        Map<String, String[]> paramMap = request.getParameterMap();
        StringJoiner joiner = new StringJoiner(delimiter);

        for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {
            String key = entry.getKey();
            String[] values = entry.getValue();

            for (String value : values) {
                joiner.add(value);
            }
        }

        return joiner.toString();
    }
	
	@Override
	public boolean preHandle(HttpServletRequest request,HttpServletResponse response, Object handler) throws Exception {
		String strUrl = bundle.getString("mten.strUrl");//"https://api194.eseoul.go.kr:5443/UPServer/";
    	String returnURL = bundle.getString("mten.returnURL");//"115.84.165.44:8080";
    	String hostIP = bundle.getString("mten.hostIP");//"115.84.165.44";
    	String hostUrl = bundle.getString("mten.hostUrl");//"http://115.84.165.44:8080/PPTEST.jsp";
    	String userIP = bundle.getString("mten.userIP");//"127.0.0.1";
    	
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

        // HTTPS 연결에 사용
        HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.getSocketFactory());

        // 테스트 요청
        HttpParams params = new BasicHttpParams();
    	DefaultHttpClient client = new DefaultHttpClient(params);
    	String isPriv = "0";
		if (!(request instanceof MultipartHttpServletRequest)) {
			String result = this.getParameterString(request, ",");
			System.out.println("result==>"+result);
	    	
	    	String content = result;
	    	
	    	HttpPost post = new HttpPost(strUrl);
	    	MultipartEntity entry = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
	    	
	    	Map<String,String> easy = new LinkedHashMap<String,String>();
	    	easy.put("returnURL", returnURL);
	    	easy.put("hostIP", hostIP);
	    	easy.put("hostUrl", hostUrl);
	    	easy.put("userIP", userIP);
	    	easy.put("content", content);
	    	Iterator<String> keys = easy.keySet().iterator();
	    	while(keys.hasNext()) {
	    		String key = (String)keys.next();
	    		StringBody body = new StringBody(easy.get(key) ,"multipart/form-data" ,Charset.forName("UTF-8"));
	    		entry.addPart(key,(ContentBody)body);
	    	}
	    	post.setEntity(entry);
	    	HttpResponse resp = client.execute(post);
	    	System.out.println("Response Code: " + resp.getStatusLine().getStatusCode());
	    	System.out.println("Response Code: " + resp.toString());
	    	
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
	        
	        if (resp.getStatusLine().getStatusCode() == 302) {
	            String location = resp.getFirstHeader("Location").getValue();
	            System.out.println("리디렉션 주소: " + location);
	            location = strUrl+"/?hostIP="+hostIP+"&hostUrl="+hostUrl+"&userIP="+userIP+"&content="+content+"&content2=&content3=&content4=";
	            // 새로 리디렉션된 URL로 GET 요청 보내기
	            HttpGet redirectRequest = new HttpGet(location);
	            HttpResponse redirectedResp = client.execute(redirectRequest);
	            int redirectedCode = redirectedResp.getStatusLine().getStatusCode();
	            System.out.println("리디렉션 응답 코드: " + redirectedCode);

	            if (redirectedCode == 200) {
	                BufferedReader reader = new BufferedReader(
	                    new InputStreamReader(redirectedResp.getEntity().getContent(), StandardCharsets.UTF_8)
	                );
	                StringBuilder json = new StringBuilder();
	                String line;
	                while ((line = reader.readLine()) != null) {
	                    json.append(line);
	                }
	                reader.close();

	                System.out.println("리디렉션 후 응답(JSON):");
	                System.out.println(json.toString());
	                
	                String jsondata = json.toString();
	                
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
	        }
			
	        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
	        
	        if(isPriv.equals("1")) {
	        	if (isAjax) {
	        		response.setStatus(HttpServletResponse.SC_FORBIDDEN);
	                response.setContentType("application/json");
	                response.setCharacterEncoding("UTF-8");
	                response.getWriter().write("{\"errorCode\":\"PRIVACY_DETECTED\", \"message\":\"개인정보가 검출 되었습니다. 데이터 확인후 다시 저장 바랍니다.\"}");
	            } else {
	                response.sendRedirect(request.getContextPath() + "/common/noPrivacyPage.do");
	            }
				return false;
	        }else {
	        	return super.preHandle(request, response, handler);
	        }
		}else {
	        return true;
		}
		
	}
	
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		
    }
}
