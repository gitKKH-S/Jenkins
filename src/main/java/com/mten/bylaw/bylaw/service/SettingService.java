package com.mten.bylaw.bylaw.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.dao.DataAccessException;


public interface SettingService {
	public JSONObject settingIbanlist(Map mtenMap);
	public JSONObject getNextCombo(Map mtenMap);
	public String getProcessListButton(Map mtenMap);
	public JSONObject settingIbanUpdate(Map mtenMap);
	public JSONObject settingIbanUpdate2(Map mtenMap);
}
