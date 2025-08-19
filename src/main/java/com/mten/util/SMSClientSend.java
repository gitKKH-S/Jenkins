package com.mten.util;

import java.util.HashMap;
import java.util.ResourceBundle;

import javax.annotation.Resource;

import com.mten.dao.CommonDao;

import tcp.seoul.sms.SMSClient;
import tcp.seoul.sms.SMSClientVO;
import tcp.seoul.util.SeedScrtyUtil;

public class SMSClientSend {
	public static ResourceBundle bundle = ResourceBundle.getBundle("egovframework.property.url"); 
	public static void sendSMS(String receiver, String title, String msg) {
		try {
			SMSClientVO smsClientVO = new SMSClientVO();
			System.out.println("###### Client 시작 ######");
			smsClientVO.setApikey(bundle.getString("mten.Apikey"));
			
			smsClientVO.setKindtype(bundle.getString("mten.Kindtype")); // 001:전송 , 002:결과조회 , 003:예약취소
			smsClientVO.setMsgtype(bundle.getString("mten.Msgtype"));
			smsClientVO.setSender(bundle.getString("mten.Sender"));
			
			receiver = SeedScrtyUtil.encryptText(receiver);
			//smsClientVO.setReceiver(receiver);	// 운영전환 시 주석 해제
			smsClientVO.setReceiver("01059100717");	// 개발 테스트
			smsClientVO.setSubject(title);
			smsClientVO.setMsg(msg);
			
			SMSClient smsClient = new SMSClient();
			SMSClientVO resultVo;
			
			resultVo  =  smsClient.doSend(smsClientVO);
			
			CommonDao commonDao = new CommonDao();
			HashMap logMap = new HashMap();
			logMap.put("NOTI_RCPTN_EMP_NO", receiver);
			logMap.put("NOTI_RCPTN_TELNO",  receiver);
			logMap.put("NOTI_TTL",          title);
			logMap.put("NOTI_CN",           msg);
			logMap.put("NOTI_TRSM_RSLT_CN", resultVo.getResultMent());
			commonDao.insert("commonSql.insertNotiLog", logMap);
			
			//SMSClientVO 형식으로 리턴
			//인터페이스 정의서 확인
			System.out.println("결과값 code : " + resultVo.getResultCode());
			System.out.println("결과값 ment : " + resultVo.getResultMent());
			System.out.println("결과값 postid : " + resultVo.getPostid());
			System.out.println("###### Client 종료 ######");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
