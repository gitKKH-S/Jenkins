package com.mten.bylaw.bylaw.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.dao.DataAccessException;


public interface FoldermnService {
	public JSONArray getCatListJson(Map mtenMap);
	public JSONObject addRoot(Map mtenMap);
	public JSONObject deleteFolder(Map mtenMap);
	public JSONObject getNodeOrd(Map mtenMap);
	public JSONObject modFolder(Map mtenMap);
	public JSONObject addChild(Map mtenMap);
}
