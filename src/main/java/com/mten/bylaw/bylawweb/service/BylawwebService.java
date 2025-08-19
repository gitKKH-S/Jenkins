package com.mten.bylaw.bylawweb.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public interface BylawwebService {
	public JSONArray getTreeNode(Map mtenMap);
	public JSONArray getDeptNode(Map mtenMap);
	public JSONArray getRecentNode(Map mtenMap);
	public JSONArray getFavNode(Map mtenMap);
	public JSONObject regulationListData(Map<String, Object> mtenMap);
	public HashMap regulationView(Map mtenMap);
	public HashMap regulationNoFormView(Map mtenMap);
	public JSONObject setFav(Map mtenMap);
	
	public HashMap getOldjo(Map mtenMap);
	
	public HashMap BookInfo(Map mtenMap);
	
	public JSONObject historyListSelect(Map mtenMap);
	
	public List getDanList(Map mtenMap);
	
	public HashMap AllZip(Map<String, Object> mtenMap);
	
	public HashMap getBookInfo2(Map<String, Object> mtenMap);
	
	public List joFileList(Map mtenMap);
}
