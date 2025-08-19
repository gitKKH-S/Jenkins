package com.mten.bylaw.bylaw.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public interface DocService {
	public JSONObject getMenuDocList(Map<String, Object> mtenMap);
	public void insertDoctype(Map<String, Object> mtenMap);
	public JSONObject deleteDoctype(Map<String, Object> mtenMap);
}
