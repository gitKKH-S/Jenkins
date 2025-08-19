package com.mten.bylaw.statistics.service;

import java.util.*;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public interface StatisticsService {
	public void setMenuLog(HashMap map);
	public void setWordLog(Map<String, Object> mtenMap);
	public JSONArray getSystemLogList(Map<String, Object> mtenMap);
	public JSONArray getMenuLogList(Map<String, Object> mtenMap);
	public JSONArray getSystemDeptLogList(Map<String, Object> mtenMap);
	public JSONArray getWordLogList(Map<String, Object> mtenMap);
	public JSONArray stsRule9(Map<String, Object> mtenMap);
	
	public List bylawstatistics1(Map<String, Object> mtenMap);
	public List bylawstatisticsD1(Map<String, Object> mtenMap);
	public JSONArray bylawstatistics2(Map<String, Object> mtenMap);
	public JSONArray bylawstatistics3(Map<String, Object> mtenMap);
	public JSONArray bylawstatistics4(Map<String, Object> mtenMap);
	public JSONArray bylawstatistics5(Map<String, Object> mtenMap);
	public JSONArray bylawstatistics6(Map<String, Object> mtenMap);
	public JSONArray bylawstatistics7(Map<String, Object> mtenMap);
	public JSONArray bylawstatisticsD5(Map<String, Object> mtenMap);
	public JSONArray bylawstatisticsD6(Map<String, Object> mtenMap);
	public JSONArray bylawstatistics10(Map<String, Object> mtenMap);
	public JSONArray bylawstatisticsD10(Map<String, Object> mtenMap);
	
	public JSONArray suitstatistics1(Map<String, Object> mtenMap);
	public JSONArray suitstatistics2(Map<String, Object> mtenMap);
	public JSONArray suitstatistics3(Map<String, Object> mtenMap);
	public JSONArray suitstatistics4(Map<String, Object> mtenMap);
	public JSONArray suitstatistics5(Map<String, Object> mtenMap);
	public JSONArray suitstatistics6_1(Map<String, Object> mtenMap);
	public JSONArray suitstatistics6_2(Map<String, Object> mtenMap);
	public JSONArray suitstatistics6_3(Map<String, Object> mtenMap);
	public JSONArray suitstatistics7(Map<String, Object> mtenMap);
	public JSONArray suitstatistics8(Map<String, Object> mtenMap);
	public JSONArray suitstatistics9(Map<String, Object> mtenMap);
	public JSONArray suitstatistics10_1(Map<String, Object> mtenMap);
	public JSONArray suitstatistics10_2(Map<String, Object> mtenMap);
	public JSONArray suitstatistics11(Map<String, Object> mtenMap);
	public JSONArray suitstatistics12(Map<String, Object> mtenMap);
	public JSONArray suitstatistics13(Map<String, Object> mtenMap);
	public JSONArray suitstatistics14(Map<String, Object> mtenMap);
	public JSONArray suitstatistics15(Map<String, Object> mtenMap);
	public JSONArray suitstatistics16(Map<String, Object> mtenMap);
	public JSONArray suitstatistics17(Map<String, Object> mtenMap);
	
	
	public JSONArray systemstatistics3_1(Map<String, Object> mtenMap);
	public JSONArray systemstatistics3_2(Map<String, Object> mtenMap);
	public JSONArray systemstatistics4(Map<String, Object> mtenMap);
	public JSONArray systemstatistics5(Map<String, Object> mtenMap);
	
	
	public JSONArray consultstatistics1(Map<String, Object> mtenMap);
	public JSONArray consultstatistics2(Map<String, Object> mtenMap);
	public JSONArray consultstatistics3(Map<String, Object> mtenMap);
	public JSONArray consultstatistics4(Map<String, Object> mtenMap);
	public JSONArray consultstatistics5(Map<String, Object> mtenMap);
	
	public JSONArray agreestatistics1(Map<String, Object> mtenMap);
	public JSONArray agreestatistics2(Map<String, Object> mtenMap);
	public JSONArray agreestatistics3(Map<String, Object> mtenMap);
	
	
	
	public JSONObject sendSms(Map<String, Object> mtenMap);
	
}
