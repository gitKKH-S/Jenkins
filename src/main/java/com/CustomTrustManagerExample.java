package com;

import javax.net.ssl.*;

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

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.net.HttpURLConnection;

public class CustomTrustManagerExample {
    public static void main(String[] args) throws Exception {
        // 인증서 로딩 (예: .crt 또는 .cer 파일)
        InputStream certInput = new FileInputStream("E:\\hkkdev\\kcousult\\src\\main\\java\\com\\eseoul.crt");
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
    	
    	String strUrl = "https://api194.eseoul.go.kr:5443/UPServer";
    	String returnURL = "115.84.165.44:8080";
    	String hostIP = "115.84.165.44";
    	String hostUrl = "http://115.84.165.44:8080/PPTEST.jsp";
    	String userIP = "127.0.0.1";
    	String content = "010-9869-5867,7909231017511,6602131024216,0198695867,212-81-67414,11208646701018,18207169521";
    	
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
            }
        }
    }
}

