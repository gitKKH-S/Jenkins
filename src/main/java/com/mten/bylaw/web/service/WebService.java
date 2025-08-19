package com.mten.bylaw.web.service;

import java.util.*;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public interface WebService {
	public List getTopMenu(HttpServletRequest request);
	
	public JSONObject getPageNavi(Map<String, Object> mtenMap);
	public JSONObject getSubTitle(Map<String, Object> mtenMap);
	public int getRoleChk(Map<String, Object> mtenMap);
	public List byRecent(Map<String, Object> mtenMap);
	public List pdsList(Map<String, Object> mtenMap);
	public List schRank(Map<String, Object> mtenMap);
	public JSONObject getSts(Map<String, Object> mtenMap);
	public String getDocFnm(Map<String, Object> mtenMap); 
	public void testSmS(Map<String, Object> mtenMap);
	public JSONArray getDeptNode(Map<String, Object> mtenMap);
	public JSONArray getUserList(Map<String, Object> mtenMap);
	
	public List getApproveList(HttpServletRequest request);
	
	public int getTaskCount(Map<String, Object> mtenMap);

	public List selectMyWorkListMain(Map<String, Object> mtenMap);
	public JSONObject selectMyWorkList(Map<String, Object> mtenMap);
}
