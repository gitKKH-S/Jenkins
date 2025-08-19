package com.mten.bylaw.code.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.dao.DataAccessException;


public interface CodeService {
	public JSONArray getNodes(Map mtenMap);
	public JSONObject getCodeList(Map mtenMap, int start, int limit);
	public List<HashMap> OrderSelect(HashMap col);
	public JSONObject getCodeCombo(Map mtenMap);
	public JSONObject getOrd(Map mtenMap);
	public JSONObject deleteCode(Map mtenMap);
	public JSONObject createCode(Map mtenMap);
	public JSONObject updateCode(Map mtenMap);
}
