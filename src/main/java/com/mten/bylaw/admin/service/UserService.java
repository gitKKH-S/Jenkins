package com.mten.bylaw.admin.service;

import java.util.*;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public interface UserService {
	public JSONObject getMatch(Map map,HttpServletRequest request);
	public JSONObject getGpkiMatch(Map map,HttpServletRequest request);
	
	public JSONObject selectOrg(Map map);
	
	public void setInstallChk(Map map);
	public String getInstallChk(Map map);
}
