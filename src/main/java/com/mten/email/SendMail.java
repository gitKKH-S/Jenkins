package com.mten.email;

import java.util.ArrayList;
import java.util.HashMap;

import com.imoxion.sensrelay.client.ImRelayClient;
import com.imoxion.sensrelay.client.ImRelayClientProc;
import com.mten.dao.CommonDao;

/**
 * 일반 메일 릴레이 전송 예제
 * @author 서울시 통합메일
 *
 */
public class SendMail {

	/**
	 * @param args 첫번째:송신자 이메일 주소, 두번째: 콤마(,)로 구분된 수신자 이메일 주소
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		ImRelayClientProc r = new ImRelayClientProc();
		
		// 반드시 발급 받은 클라이언트 키를 입력(24자리)
		r.setClient_key("67dd17543febd47e82a9d5a7");
		
		// 제목을 입력한다.
		r.setSubject("릴레이 테스트 발송");
		// 송신자 이메일 주소를 입력한다.
		// 입력된 송신자 이메일 주소로 메일이 전송된 결과가 전송되므로 정확한 이메일 주소 입력 필요.
		r.setFrom("legalsupport@seoul.go.kr");
		// 메일 본문에 나올 To 헤더를 입력한다. 실제 메일을 받으면 보이는 수신자 정보
		r.setTo("kyugwan@naver.com");

		// 수신자를 입력한다.
		r.addReceipt("kyugwan@naver.com");
		
		// 메일 본문을 입력한다.
		r.setBody("<html><body>안녕하세요. 릴레이 테스트 입니다</body></html>");

		// 첨부파일을 입력한다. 파일이 여러개 일때는 addAttach 메서드를 여러번 호출한다.
		// 첨부파일의 총량이 10M 이상일 때는 정상적으로 전송이 안될 수 있음.
		// 예) r.addAttach("test.txt","c:\\test.txt"); 파일의 절대 경로에 파일명도 같이 넣어주어야 함
		
		// 메일을 전송한다.
		ImRelayClient rClient = r.doSend();
		
		if(!rClient.getResultStatus().equals("00")){
			// 오류
			System.out.println("Error:"+rClient.getResultMsg());
		}
		// 메일 키와 클라이언트 키를 찍어본다.
		System.out.println(rClient.getKey());
		System.out.println(rClient.getClientKey());
	
	}
	
	public static void sendMail(String title, String cont , ArrayList<String> touser, ArrayList<String> tousernm, ArrayList<HashMap> att, String fpath) {
		// TODO Auto-generated method stub
		
		ImRelayClientProc r = new ImRelayClientProc();
		
		// 반드시 발급 받은 클라이언트 키를 입력(24자리)
		r.setClient_key("67dd17543febd47e82a9d5a7");
		
		// 제목을 입력한다.
		r.setSubject(title);
		// 송신자 이메일 주소를 입력한다.
		// 입력된 송신자 이메일 주소로 메일이 전송된 결과가 전송되므로 정확한 이메일 주소 입력 필요.
		r.setFrom("legalsupport@seoul.go.kr");
		
		String receiver = "";
		String receiverNo = "";
		// 메일 본문에 나올 To 헤더를 입력한다. 실제 메일을 받으면 보이는 수신자 정보
		for(int i=0; i<tousernm.size(); i++) {
			r.setTo(tousernm.get(i));
			
			if (i < tousernm.size()) {
				receiver = receiver+tousernm.get(i)+",";
			} else {
				receiver = receiver+tousernm.get(i);
			}
		}
		
		// 수신자를 입력한다.
		for(int i=0; i<touser.size(); i++) {
			//r.addReceipt(touser.get(i));
			r.addReceiptKey("[RK]"+touser.get(i));
			
			if (i < touser.size()) {
				receiverNo = receiverNo+touser.get(i)+",";
			} else {
				receiverNo = receiverNo+touser.get(i);
			}
		}
		
		// 메일 본문을 입력한다.
		r.setBody(cont);

		// 첨부파일을 입력한다. 파일이 여러개 일때는 addAttach 메서드를 여러번 호출한다.
		// 첨부파일의 총량이 10M 이상일 때는 정상적으로 전송이 안될 수 있음.
		// 예) r.addAttach("test.txt","c:\\test.txt"); 파일의 절대 경로에 파일명도 같이 넣어주어야 함
		
		// 메일을 전송한다.
		ImRelayClient rClient = r.doSend();
		
		if(!rClient.getResultStatus().equals("00")){
			// 오류
			System.out.println("Error:"+rClient.getResultMsg());
		}
		// 메일 키와 클라이언트 키를 찍어본다.
		System.out.println(rClient.getKey());
		System.out.println(rClient.getClientKey());
		
		CommonDao commonDao = new CommonDao();
		HashMap logMap = new HashMap();
		logMap.put("NOTI_RCPTN_EMP_NO", receiverNo);
		logMap.put("NOTI_RCPTN_TELNO",  receiver);
		logMap.put("NOTI_TTL",          title);
		logMap.put("NOTI_CN",           cont);
		logMap.put("NOTI_TRSM_RSLT_CN", rClient.getResultMsg());
		commonDao.insert("commonSql.insertNotiLog", logMap);
		
	}
}
