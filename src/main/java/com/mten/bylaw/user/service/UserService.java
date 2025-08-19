package com.mten.bylaw.user.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.dao.DataAccessException;


public interface UserService {
	public JSONArray getNodes(Map mtenMap);
	public JSONObject createRole(Map mtenMap);
	public JSONObject deleteRole(Map mtenMap);
	public JSONObject userList(Map mtenMap);
	public JSONObject createUser(Map mtenMap);
	public JSONObject moveNode(Map mtenMap);
	public JSONObject updateUser(Map mtenMap);
	public JSONObject deleteUser(Map mtenMap);
	public JSONObject getDeptName(Map mtenMap);
}

