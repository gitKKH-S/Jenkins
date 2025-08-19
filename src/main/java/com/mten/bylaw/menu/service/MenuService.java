package com.mten.bylaw.menu.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.dao.DataAccessException;


public interface MenuService {
	public JSONArray getNodes(Map mtenMap);
	public JSONArray getWebNodes(Map mtenMap);
	public JSONObject createNode(Map mtenMap);
	public JSONObject deleteMenu(Map mtenMap);
	public JSONObject getUrlInfo(Map mtenMap);
	public JSONObject moveNode(Map mtenMap);
	public JSONObject modSubFolder(Map mtenMap);
}
