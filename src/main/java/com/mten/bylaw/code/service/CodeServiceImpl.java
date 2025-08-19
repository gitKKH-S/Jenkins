package com.mten.bylaw.code.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.mten.bylaw.admin.service.UserServiceImpl;
import com.mten.dao.CommonDao;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("codeService")
public class CodeServiceImpl implements CodeService {
	protected final static Logger logger = Logger.getLogger( CodeServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	//트리메뉴
	public JSONArray getNodes(Map mtenMap) {
		List<HashMap> nodeList = commonDao.selectList("lawcodeSql.getCode",mtenMap);
		for(int i=0; i<nodeList.size(); i++) {
			HashMap result = nodeList.get(i);
			result.put("text", result.get("CD_LCLSF_KORN_NM"));
			result.put("id", result.get("CODEID"));
			result.put("cls", "code");
			result.put("leaf", "true");
			result.put("qtip", result.get("CD_LCLSF_KORN_NM"));
		}
		JSONArray jl = JSONArray.fromObject(nodeList);
		return jl;
	}
	
	public JSONObject getCodeList(Map mtenMap, int start, int limit) {
		List<HashMap> list = commonDao.selectList("lawcodeSql.getCodeList",mtenMap);
		ArrayList nlist = new ArrayList();
		System.out.println("start===>"+start);
		System.out.println("limit===>"+limit);
		
		int total = list.size();
		if(total-limit<0){
			limit=total;
		}
		
		for(int i=start; i<limit;i++){
			HashMap result = list.get(i);
			result.put("ORDSORT", i+1);
			nlist.add(result);
		}
		JSONArray jl = JSONArray.fromObject(nlist);
		JSONObject obj = new JSONObject();
		obj.put("total", list.size());
		obj.put("result", jl);
		return obj;
	}
	
	public List<HashMap> OrderSelect(HashMap col) {
		List<HashMap> clist = commonDao.selectList("lawcodeSql.SelectBox", col);
		return clist;
	}
	
	public JSONObject getCodeCombo(Map mtenMap) {
		List<HashMap> clist = commonDao.selectList("lawcodeSql.getCode",mtenMap);
		for(int i=0; i<clist.size(); i++) {
			HashMap re = (HashMap)clist.get(i);
			re.put("id", i);
			re.put("CD_LCLSF_KORN_NM", re.get("CD_LCLSF_KORN_NM"));
			re.put("CD_LCLSF_ENG_NM", re.get("CD_LCLSF_ENG_NM"));
		}
		System.out.println(clist);
		JSONArray jl = JSONArray.fromObject(clist);
		JSONObject jo = new JSONObject();
		jo.put("result", jl);
		return jo;
	}
	
	public JSONObject getOrd(Map mtenMap) {
		String stat = mtenMap.get("stat")==null?"":mtenMap.get("stat").toString();
		List<HashMap> ordList = commonDao.selectList("lawcodeSql.getOrd",mtenMap);
		if(!stat.equals("") && stat.equals("MOD")){
			for(int i=0;i<ordList.size();i++){
				HashMap lcBean = (HashMap)ordList.get(i);
				int SORT_SEQ = lcBean.get("SORT_SEQ")==null?0:Integer.parseInt(lcBean.get("SORT_SEQ").toString());
				lcBean.put("ordVal", SORT_SEQ);
				lcBean.put("SORT_SEQ", i);
			}
		}else if(!stat.equals("") && stat.equals("CRE")){
			int max = 0;
			for(int i=0;i<ordList.size();i++){
				HashMap lcBean = (HashMap)ordList.get(i);
				int SORT_SEQ = lcBean.get("SORT_SEQ")==null?0:Integer.parseInt(lcBean.get("SORT_SEQ").toString());
				lcBean.put("ordVal", SORT_SEQ);
				lcBean.put("SORT_SEQ", i);
				max = SORT_SEQ;
			}		
			HashMap pp = new HashMap();
			pp.put("ordVal", max+1);
			pp.put("SORT_SEQ", ordList.size());
			ordList.add(pp);
		}
		JSONArray jl = JSONArray.fromObject(ordList);
		JSONObject jo = new JSONObject();
		jo.put("result", jl);
		return jo;
	}
	
	public JSONObject deleteCode(Map mtenMap) {
		int result = commonDao.delete("lawcodeSql.deleteCode",mtenMap);
		JSONObject jo = new JSONObject();
		jo.put("success", "true");
		jo.put("result", result);
		return jo;
	}
	
	public JSONObject createCode(Map mtenMap) {
		mtenMap = this.keyChangeLowerMap(mtenMap);
		if(mtenMap.get("CD_LCLSF_ENG_NM")==null || mtenMap.get("CD_LCLSF_ENG_NM").toString().equals("")) {
			mtenMap.put("CD_LCLSF_ENG_NM",mtenMap.get("CD_LCLSF_ENG_NM2"));
		}
		String SORT_SEQ = mtenMap.get("SORT_SEQ")==null?"":mtenMap.get("SORT_SEQ").toString();
		if(SORT_SEQ.equals("")) {
			mtenMap.put("SORT_SEQ","0");
		}
		commonDao.update("lawcodeSql.updateOrd",mtenMap);
		commonDao.insert("lawcodeSql.createCode",mtenMap);
		JSONObject jo = new JSONObject();
		JSONObject sub = new JSONObject();
		sub.put("CD_LCLSF_ENG_NM", mtenMap.get("CD_LCLSF_ENG_NM"));
		jo.put("data", sub);
		jo.put("success", "true");
		return jo;
	}
	
	public JSONObject updateCode(Map mtenMap) {
		mtenMap = this.keyChangeLowerMap(mtenMap);
		if(mtenMap.get("CD_LCLSF_ENG_NM")==null || mtenMap.get("CD_LCLSF_ENG_NM").toString().equals("")) {
			mtenMap.put("CD_LCLSF_ENG_NM",mtenMap.get("CD_LCLSF_ENG_NM2"));
		}
		int SORT_SEQ = mtenMap.get("SORT_SEQ")==null?0:Integer.parseInt(mtenMap.get("SORT_SEQ").toString().equals("")?"0":mtenMap.get("SORT_SEQ").toString());
		int m_ord = mtenMap.get("m_ord")==null?0:Integer.parseInt(mtenMap.get("m_ord").toString().equals("")?"0":mtenMap.get("m_ord").toString());
		
		mtenMap.put("SORT_SEQ", m_ord);
		
		HashMap oldCodeInfo = commonDao.selectOne("lawcodeSql.getCodeInfo", mtenMap);
		
		String Maxord = commonDao.selectOne("lawcodeSql.getMaxord",mtenMap);
		
		if(SORT_SEQ < m_ord){
			commonDao.update("lawcodeSql.updateOrd2",mtenMap);
		}else{
			if(Integer.parseInt(oldCodeInfo.get("SORT_SEQ").toString()) != m_ord)
				commonDao.update("lawcodeSql.updateOrd",mtenMap);
		}
		
		if(Integer.parseInt(Maxord) == m_ord||SORT_SEQ < m_ord){
			if(Integer.parseInt(Maxord) == m_ord){
				mtenMap.put("SORT_SEQ", m_ord+2);
			}else{
				mtenMap.put("SORT_SEQ", m_ord+1);
			}
		}
		
		commonDao.update("lawcodeSql.updateCode",mtenMap);
		JSONObject jo = new JSONObject();
		JSONObject sub = new JSONObject();
		sub.put("CD_LCLSF_ENG_NM", mtenMap.get("CD_LCLSF_ENG_NM"));
		jo.put("success", "true");
		jo.put("data", sub);
		return jo;
	}
	
	public static HashMap keyChangeLowerMap(Map param) {
		Iterator<String> iteratorKey = param.keySet().iterator(); // 키값 오름차순
		HashMap newMap = new HashMap();
		// //키값 내림차순 정렬
		while (iteratorKey.hasNext()) {
			String key = iteratorKey.next();
			newMap.put(key.toLowerCase(), param.get(key));
		}
		return newMap;

	}
}
