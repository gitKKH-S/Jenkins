package com.mten.bylaw.bylaw.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.dao.DataAccessException;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartHttpServletRequest;


public interface CommiteeService {
	public JSONObject insertWewon(Map<String, Object> mtenMap);
	public JSONObject selectWewonList(Map<String, Object> mtenMap);
	public List selectWewonList2(Map<String, Object> mtenMap);
	public JSONObject selectCommiteeList(Map<String, Object> mtenMap);
	public JSONObject delWewon(Map<String, Object> mtenMap);
	public JSONObject updateWewon(Map<String, Object> mtenMap);
	
	
	public HashMap selectCommissionList(Map<String, Object> mtenMap);
	public HashMap commissionInfo(Map<String, Object> mtenMap);
	public List lawListForCommission(Map<String, Object> mtenMap);
	
	public void insertCommission(Map<String, Object> mtenMap,Iterator<String> itr ,MultipartHttpServletRequest multipartRequest, String filePath);
	public HashMap opinionInfo(Map<String, Object> mtenMap);
	
	public void insertOpinion(Map<String, Object> mtenMap);
	
	public void fileSave(Map<String, Object> mtenMap,Iterator<String> itr ,MultipartHttpServletRequest multipartRequest, String filePath);
}
