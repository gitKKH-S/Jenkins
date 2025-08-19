package com.mten.bylaw.menu.service;

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

@Service("menuService")
public class MenuServiceImpl implements MenuService {
	protected final static Logger logger = Logger.getLogger( MenuServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	//트리메뉴
	public JSONArray getNodes(Map mtenMap) {
		List<HashMap> nodeList = commonDao.selectList("menuSql.getMenu",mtenMap);
		for(int i=0; i<nodeList.size(); i++) {
			HashMap result = nodeList.get(i);
			String FLDR_SE = result.get("FLDR_SE")==null?"":result.get("FLDR_SE").toString();
			String USE_YN = result.get("USE_YN")==null?"":result.get("USE_YN").toString();
			if(USE_YN.equals("N")) {
				FLDR_SE = "menuLeafDis";
			}else {
				FLDR_SE = FLDR_SE.toLowerCase();
			}
			boolean leaf = false;
			if(FLDR_SE.equals("doc")){
				leaf = true;
			}
			result.put("text", result.get("MENU_TTL"));
			result.put("id", result.get("MENU_MNG_NO"));
			result.put("cls", FLDR_SE);
			result.put("leaf", leaf);
			result.put("qtip", result.get("MENU_TTL"));
		}
		JSONArray jl = JSONArray.fromObject(nodeList);
		return jl;
	}
	
	public JSONArray getWebNodes(Map mtenMap) {
		List<HashMap> nodeList = commonDao.selectList("menuSql.getMenu",mtenMap);
		for(int i=0; i<nodeList.size(); i++) {
			HashMap result = nodeList.get(i);
			String FLDR_SE = result.get("FLDR_SE")==null?"":result.get("FLDR_SE").toString();
			String USE_YN = result.get("USE_YN")==null?"":result.get("USE_YN").toString();
			if(USE_YN.equals("N")) {
				FLDR_SE = "menuLeafDis";
			}else {
				FLDR_SE = FLDR_SE.toLowerCase();
			}
			boolean leaf = false;
			if(FLDR_SE.equals("doc")){
				leaf = true;
			}
			result.put("text", result.get("MENU_TTL"));
			result.put("id", result.get("MENU_MNG_NO"));
			result.put("leaf", leaf);
			result.put("qtip", result.get("MENU_TTL"));
		}
		JSONArray jl = JSONArray.fromObject(nodeList);
		return jl;
	}
	
	public JSONObject createNode(Map mtenMap) {
		commonDao.insert("menuSql.createMenu", mtenMap);
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		data.put("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		result.put("success", true);
		result.put("data", data);
		return result;
	}
	
	public JSONObject deleteMenu(Map mtenMap) {
		JSONObject result = new JSONObject();
		int mcnt = commonDao.select("menuSql.getMenuSize", mtenMap);
		if(mcnt==0) {
			commonDao.delete("menuSql.deleteMenu",mtenMap);
			result.put("result", "OK");
			result.put("msgT", "결과");
			result.put("msg", "정삭적으로 삭제 되었습니다.");
		}else {
			result.put("result", "NO");
			result.put("msgT", "에러");
			result.put("msg", "하위메뉴나 폴더가 있는경우<br/>삭제가 불가능합니다.");
		}
		return result;
	}
	
	public JSONObject getUrlInfo(Map mtenMap) {
		JSONObject result = new JSONObject();
		List ulist = commonDao.selectList("menuSql.getUrlList");
		JSONArray jl = JSONArray.fromObject(ulist);
		result.put("result", ulist);
		return result;
	}
	
	public JSONObject moveNode(Map mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.update("menuSql.updateNodeAll",mtenMap);
		result.put("cnt", commonDao.update("menuSql.updateNode",mtenMap));
		return result;
	}
	
	public JSONObject modSubFolder(Map mtenMap) {
		int resNum = commonDao.update("menuSql.modSubFolder",mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", "true");
		result.put("data", resNum);
		return result;
	}
}
