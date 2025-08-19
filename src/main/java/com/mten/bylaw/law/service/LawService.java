package com.mten.bylaw.law.service;

import java.util.*;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;


public interface LawService {
	public JSONObject koreaLawListData(Map<String, Object> mtenMap);
	public HashMap getLawBon(Map<String, Object> mtenMap);
	
	public JSONObject koreaByLawListData(Map<String, Object> mtenMap);
	public HashMap getByLawBon(Map<String, Object> mtenMap);
	
	public JSONObject getData(Map<String, Object> mtenMap);
	public JSONObject getMenuData(Map<String, Object> mtenMap);
	
	public void insertMapping(Map<String, Object> mtenMap);
	public void deleteMapping(Map<String, Object> mtenMap);
	public void updateMapping(Map<String, Object> mtenMap);
	
	public JSONObject etcListData(Map<String, Object> mtenMap);
	public JSONObject favListData(Map<String, Object> mtenMap);
	public JSONObject schlawList(Map<String, Object> mtenMap,HttpServletRequest req);
	public List getLaw3List(HashMap mtenMap);
}
