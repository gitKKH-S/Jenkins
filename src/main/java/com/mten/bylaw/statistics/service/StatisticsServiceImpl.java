package com.mten.bylaw.statistics.service;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import com.mten.dao.CommonDao;
import com.mten.dao.SmsDao;
import com.mten.util.AES256Cipher;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("statisticsService")
public class StatisticsServiceImpl implements StatisticsService {
	protected final static Logger logger = Logger.getLogger( StatisticsServiceImpl.class );
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="smsDao")
	private SmsDao smsDao;
	
	public void setMenuLog(HashMap map) {
		commonDao.insert("statisticsSql.setMenuLog",map);
	}
	
	public void setWordLog(Map<String, Object> mtenMap){
		commonDao.insert("statisticsSql.setWordLog",mtenMap);
		
		//검색엔진 검색어 순위 테이블 단어저장 신규생성 테이블 4개 다
		commonDao.insert("statisticsSql.insertImsiPop",mtenMap);
		/*
		commonDao.insert("statisticsSql.insertDayPop",mtenMap);
		commonDao.insert("statisticsSql.insertWeekPop",mtenMap);
		commonDao.insert("statisticsSql.insertMonthPop",mtenMap);
		*/
	}
	
	public JSONArray getSystemLogList(Map<String, Object> mtenMap) {
		List slist = commonDao.selectList("statisticsSql.getSystemLogList", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray getMenuLogList(Map<String, Object> mtenMap) {
		List slist = commonDao.selectList("statisticsSql.getMenuLogList", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray getSystemDeptLogList(Map<String, Object> mtenMap) {
		List slist = commonDao.selectList("statisticsSql.getSystemDeptLogList", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray getWordLogList(Map<String, Object> mtenMap) {
		List slist = commonDao.selectList("statisticsSql.getWordLogList", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray stsRule9(Map<String, Object> mtenMap) {
		List slist = commonDao.selectList("statisticsSql.getDeptBylawList", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public List bylawstatistics1(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatistics1", mtenMap);
		return slist;
	}
	public List bylawstatisticsD1(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatisticsD1", mtenMap);
		return slist;
	}
	public JSONArray bylawstatistics2(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatistics2", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray bylawstatistics3(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatistics3", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray bylawstatistics4(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatistics4", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray bylawstatistics5(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatistics5", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray bylawstatistics6(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatistics6", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray bylawstatistics7(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatistics7", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray bylawstatisticsD5(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatisticsD5", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray bylawstatisticsD6(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatisticsD6", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray bylawstatistics10(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatistics10", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray bylawstatisticsD10(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.bylawstatisticsD10", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	// SUIT
	public JSONArray suitstatistics1(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics1", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics2(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics2", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics3(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics3", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics4(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics4", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics5(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics5", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics6_1(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics6_1", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics6_2(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics6_2", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics6_3(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics6_3", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics7(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics7", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics8(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics8", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics9(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics9", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics10_1(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics10_1", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics10_2(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics10_2", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics11(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics11", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics12(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics12", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics13(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics13", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics14(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics14", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics15(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics15", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray suitstatistics16(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics16", mtenMap);
		List ssList = new ArrayList();
		for(int i=0; i<slist.size(); i++) {
			HashMap map = (HashMap)slist.get(i);
			
			String actno = map.get("H_COL")==null?"":map.get("H_COL").toString();
			String decode = "";
			
			try {
				decode = AES256Cipher.AES_Decode(actno);
			} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
					| NoSuchPaddingException | InvalidAlgorithmParameterException | IllegalBlockSizeException
					| BadPaddingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				decode = "";
			}
			map.put("H_COL", decode);
			
			ssList.add(map);
		}
		
		JSONArray jl = JSONArray.fromObject(ssList);
		return jl;
	}
	public JSONArray suitstatistics17(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.suitstatistics17", mtenMap);
		List ssList = new ArrayList();
		for(int i=0; i<slist.size(); i++) {
			HashMap map = (HashMap)slist.get(i);
			
			String actno = map.get("H_COL")==null?"":map.get("H_COL").toString();
			String decode = "";
			
			try {
				decode = AES256Cipher.AES_Decode(actno);
			} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
					| NoSuchPaddingException | InvalidAlgorithmParameterException | IllegalBlockSizeException
					| BadPaddingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				decode = "";
			}
			map.put("H_COL", decode);
			
			ssList.add(map);
		}
		
		JSONArray jl = JSONArray.fromObject(ssList);
		return jl;
	}
	
	
	
	
	public JSONArray systemstatistics3_1(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.systemstatistics3_1", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray systemstatistics3_2(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.systemstatistics3_2", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray systemstatistics4(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.systemstatistics4", mtenMap);
		List dataList = new ArrayList();
		
		for(int i=0; i<slist.size(); i++) {
			HashMap sMap = (HashMap)slist.get(i);
			String ARSP_NM = sMap.get("ARSP_NM")==null?"":sMap.get("ARSP_NM").toString();
			System.out.println(">> ARSP_NM : " + ARSP_NM);
			if (!ARSP_NM.equals("")) {
				String [] arspNmList = ARSP_NM.split(",");
				HashMap arspMap = new HashMap();
				String SET_ARSP_NM = "";
				for(int s=0; s<arspNmList.length; s++) {
					arspMap.put("ARSP_NM", arspNmList[s]);
					SET_ARSP_NM += commonDao.selectOne("suitSql.getArspNm", arspMap)+",";
				}
				SET_ARSP_NM = StringUtils.removeEnd(SET_ARSP_NM, ",");
				
				sMap.put("ARSP_NM", SET_ARSP_NM);
				
			}
			dataList.add(sMap);
		}
		
		JSONArray jl = JSONArray.fromObject(dataList);
		return jl;
	}
	public JSONArray systemstatistics5(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.systemstatistics5", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	
	
	
	public JSONArray consultstatistics1(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.consultstatistics1", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray consultstatistics2(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.consultstatistics2", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray consultstatistics3(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.consultstatistics3", mtenMap);
		List ssList = new ArrayList();
		for(int i=0; i<slist.size(); i++) {
			HashMap map = (HashMap)slist.get(i);
			
			String actno = map.get("H_COL")==null?"":map.get("H_COL").toString();
			String decode = "";
			
			try {
				decode = AES256Cipher.AES_Decode(actno);
			} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
					| NoSuchPaddingException | InvalidAlgorithmParameterException | IllegalBlockSizeException
					| BadPaddingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				decode = "";
			}
			map.put("H_COL", decode);
			
			ssList.add(map);
		}
		
		JSONArray jl = JSONArray.fromObject(ssList);
		return jl;
	}
	public JSONArray consultstatistics4(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.consultstatistics4", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	public JSONArray consultstatistics5(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.consultstatistics5", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	
	
	public JSONArray agreestatistics1(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.agreestatistics1", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}

	public JSONArray agreestatistics2(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.agreestatistics2", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	public JSONArray agreestatistics3(Map<String, Object> mtenMap){
		List slist = commonDao.selectList("statisticsSql.agreestatistics3", mtenMap);
		JSONArray jl = JSONArray.fromObject(slist);
		return jl;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public JSONObject sendSms(Map<String, Object> mtenMap){
		JSONObject result = new JSONObject();
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		List<Map<String, Object>> sendList = new ArrayList<Map<String, Object>>();
		String docid = "";
		
		if("CONSULT".equals(gbn)){
			docid = mtenMap.get("consultid") == null ? "" : mtenMap.get("consultid").toString();
			sendList = commonDao.selectList("consultSql.selectSmsSendList", mtenMap);
		} else {
			docid = mtenMap.get("caseid") == null ? "" : mtenMap.get("caseid").toString();
			sendList = commonDao.selectList("suitSql.selectSmsEmpList", mtenMap);
		}
		
		mtenMap.put("docid", docid);
		
		try{
			if(sendList.size() > 0){
				for(int i=0; i<sendList.size(); i++){
					HashMap info = (HashMap)sendList.get(i);
					param = new HashMap<String, Object>();
					if("CONSULT".equals(gbn)){
						param.put("bphone", "03180752365");
						param.put("phone", info.get("PHONE").toString());
						param.put("msg", info.get("MSG").toString());
						param.put("subject", "[만족도조사안내]");
					}else{
						String suittype = info.get("SUITTYPE")==null?"민사":info.get("SUITTYPE").toString();
						if("행정".equals(suittype)){
							param.put("bphone", "03180752364");
						}else{
							param.put("bphone", "03180752363");
						}
						param.put("phone", info.get("O_PHONE").toString());
						param.put("msg", info.get("MSG").toString());
						param.put("subject", "[만족도조사안내]");
					}
					
					commonDao.insert("statisticsSql.insertSmsSendLog", mtenMap);
					smsDao.insert("suitSql.sendSms", param);
					Thread.sleep(1000);
				}
				result.put("msg", "발송 완료");
			}else{
				result.put("msg", "수신자 정보 오류");
			}
		}catch(Exception e){
			System.out.println(e.toString());
			result.put("msg", e.toString());
		}
		return result;
	}
}
