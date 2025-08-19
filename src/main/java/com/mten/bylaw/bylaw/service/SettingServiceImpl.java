package com.mten.bylaw.bylaw.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.mten.bylaw.admin.service.UserServiceImpl;
import com.mten.dao.CommonDao;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("settingService")
public class SettingServiceImpl implements SettingService {
	protected final static Logger logger = Logger.getLogger( SettingServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public JSONObject settingIbanlist(Map mtenMap) {
		JSONObject result = new JSONObject();
		List sl = commonDao.selectList("settingSql.getIbanList", mtenMap);
		JSONArray jl = JSONArray.fromObject(sl);
		result.put("result", jl);
		return result;
	}
	
	public JSONObject getNextCombo(Map mtenMap) {
		JSONObject result = new JSONObject();
		List sl = commonDao.selectList("settingSql.getNextCombo", mtenMap);
		JSONArray jl = JSONArray.fromObject(sl);
		result.put("result", jl);
		return result;
	}
	
	public String getProcessListButton(Map mtenMap) {
		String key = mtenMap.get("key")==null?"":mtenMap.get("key").toString();
		String html="<div class=\"orderViewW\"><ul class=\"orderView\">";
		List blist = commonDao.selectList("settingSql.getProcessListButton", mtenMap);
		for(int i=0; i<blist.size(); i++){
			HashMap re = (HashMap)blist.get(i);
			String ilcls = "";
			if(i==blist.size()-1){
				//ilcls = "end";
			}
			if(key.equals(re.get("STATEID").toString())){
				ilcls = "on";
			}
			//html = html + "<img src='../../../images/progress/"+re.get("STATEID")+".png' /><img src='../../../images/progress/next.gif'/>";
			html = html + "<li class=\""+ilcls+"\" onclick=\"reStore('"+re.get("STATEID")+"')\" style=\"cursor:pointer\">"+re.get("STATECD")+"</li>";
		}
		html = html + "</ul></div>";
		return html;
	}
	
	public JSONObject settingIbanUpdate(Map mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.update("settingSql.settingIbanUpdate",mtenMap);
		result.put("success", true);
		return result;
	}
	
	public JSONObject settingIbanUpdate2(Map mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.update("settingSql.settingIbanUpdate2",mtenMap);
		result.put("success", true);
		return result;
	}
}
