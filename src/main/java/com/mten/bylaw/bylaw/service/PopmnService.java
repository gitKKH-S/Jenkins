package com.mten.bylaw.bylaw.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.dao.DataAccessException;
import org.springframework.web.multipart.MultipartHttpServletRequest;


public interface PopmnService {
	public JSONObject selectPopList(Map<String, Object> mtenMap);
	public JSONObject deletePop(Map<String, Object> mtenMap);
	public JSONObject insertPop(Map<String, Object> mtenMap,MultipartHttpServletRequest multipartRequest) throws IllegalStateException, IOException;
	public JSONObject selectView(Map<String, Object> mtenMap);
	public JSONObject todayPopList(Map<String, Object> mtenMap);
}
