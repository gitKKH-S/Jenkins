<%@ page contentType="text/json; charset=utf-8" pageEncoding="utf-8"%><%@ page autoFlush="true"%><%@ page import="java.io.BufferedReader"%><%@ page import="java.io.InputStreamReader"%><%@ page import="java.io.OutputStreamWriter"%><%@ page import="java.net.HttpURLConnection"%><%@ page import="java.net.*"%><%@ page import="java.util.*"%><%@ page import="java.util.regex.*"%>
<%
	//String strUrl = "http://222.112.20.242:8530/itrinity";
	String strUrl = "http://localhost:8530";
	strUrl += "/search_post";
	
	
	// 1) 클라이언트에서 넘어온 모든 파라미터를 가져온다
	Map<String,String[]> incoming = request.getParameterMap();
	
	// 2) proxy용 Map<String,Object> 로 변환
	Map<String,Object> params = new LinkedHashMap<>();
	for (Map.Entry<String,String[]> entry : incoming.entrySet()) {
	    String key   = entry.getKey();
	    String[] vals = entry.getValue();
	    // 배열일 경우 첫 번째 값만 넘기거나, 필요에 따라 String.join(",", vals) 등으로 합치면 됩니다
	    if (vals != null && vals.length > 0) {
	        params.put(key, vals[0]);
	    }
	}

	
	//Post
	StringBuilder postData = new StringBuilder();
	for(Map.Entry<String,Object> param : params.entrySet()) {
		if(postData.length() != 0) postData.append('&');
		postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
		postData.append('=');
		postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
	}
	byte[] postDataBytes = postData.toString().getBytes("UTF-8");

	try {		
		URL url = new URL(strUrl);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
		con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
		con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        con.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
        con.setDoOutput(true);
        con.getOutputStream().write(postDataBytes); // POST 호출

		StringBuilder sb = new StringBuilder();
		if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
			//Stream을 처리해줘야 하는 귀찮음이 있음. 
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
			String line;
			while ((line = br.readLine()) != null) {				
				sb.append(line).append("\n");
			}
			br.close();
			out.println("" + sb.toString());			
			
		} else {
			System.out.println(con.getResponseMessage());
		}

	} catch (Exception e) {
		out.println(e.toString());
	}
%>