package com.mten.bylaw.bylaw.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.mten.bylaw.admin.service.UserServiceImpl;
import com.mten.dao.CommonDao;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("foldermnService")
public class FoldermnServiceImpl implements FoldermnService {
	protected final static Logger logger = Logger.getLogger( FoldermnServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	//트리메뉴
	public JSONArray getCatListJson(Map mtenMap) {
		mtenMap.put("key1", "연혁");
		mtenMap.put("key2", "폐지");
		List nodeList = commonDao.selectList("folderSql.getCatList_ext",mtenMap);
		JSONArray jl = new JSONArray();
		for (int i = 0; i < nodeList.size(); i++) {
			Map tmpBean = (Map) nodeList.get(i);
			int catId = tmpBean.get("CATID")==null?0:Integer.parseInt(tmpBean.get("CATID").toString());
			String title = tmpBean.get("TITLE")==null?"":tmpBean.get("TITLE").toString().replace(":", "").replace("\n", "").replace("\r", "").replace(",", "").replace("\"", "").replace("[", "\\[").replace("]", "\\]").replace("{", "").replace("}", "");
			String catCd = tmpBean.get("CATCD")==null?"":tmpBean.get("CATCD").toString();
			String useYn = tmpBean.get("USEYN")==null?"":tmpBean.get("USEYN").toString();
			int ord = tmpBean.get("ORD")==null?0:Integer.parseInt(tmpBean.get("ORD").toString());
			int bookId = tmpBean.get("BOOKID")==null?0:Integer.parseInt(tmpBean.get("BOOKID").toString());
			String noFormYn = tmpBean.get("NOFORMYN")==null?"":tmpBean.get("NOFORMYN").toString();
			int oBookId = tmpBean.get("OBOOKID")==null?0:Integer.parseInt(tmpBean.get("OBOOKID").toString());
			int revCha = tmpBean.get("REVCHA")==null?0:Integer.parseInt(tmpBean.get("REVCHA").toString());
			String promulDt = tmpBean.get("PROMULDT")==null?"":tmpBean.get("PROMULDT").toString();
			String startDt = tmpBean.get("STARTDT")==null?"":tmpBean.get("STARTDT").toString();
			String endDt = tmpBean.get("ENDDT")==null?"":tmpBean.get("ENDDT").toString();
			String revCd = tmpBean.get("REVCD")==null?"":tmpBean.get("REVCD").toString();
			String bStateCd = tmpBean.get("STATECD")==null?"":tmpBean.get("STATECD").toString();
			String fStateCd = tmpBean.get("FSTATECD")==null?"":tmpBean.get("FSTATECD").toString();
			String Dept = tmpBean.get("DEPTNAME")==null?"":tmpBean.get("DEPTNAME").toString();
			String Deptcd = tmpBean.get("DEPT")==null?"":tmpBean.get("DEPT").toString();
			String statehistoryid = tmpBean.get("STATEHISTORYID")==null?"":tmpBean.get("STATEHISTORYID").toString();
			String stateid = tmpBean.get("STATEID")==null?"":tmpBean.get("STATEID").toString();
			String cls = "";
			boolean leaf = false;
			String bookcd = tmpBean.get("BOOKCD")==null?"":tmpBean.get("BOOKCD").toString();
			String updatecha = tmpBean.get("UPDATECHA")==null?"0":tmpBean.get("UPDATECHA").toString();
			//continue;
			if (catCd.equals("folder") && useYn.equals("Y")) {
				cls = "folder";
			} else if (catCd.equals("doc") && useYn.equals("Y")) {
				if(!(bStateCd.equals("현행")||fStateCd.equals("폐지"))){
					cls = "fileIng";
				}else{
					cls = "file";
				}
				leaf = true;
			} else if (catCd.equals("folder") && useYn.equals("N")) {
				cls = "nuFolder";
			} else if (catCd.equals("doc") && useYn.equals("Y")) {
				cls = "nuFile";
				leaf = true;
			}
			
			JSONObject tj = new JSONObject();
			tj.put("id", catId);
			tj.put("qtip", title);
			tj.put("title", title);
			
			int strSize = 0;
			strSize = title.length();
			if(strSize>25){
				title = title.substring(0, 24);
				title = title+"...";
			}
			
			tj.put("text", title);
			tj.put("MENU_IMG_NM", cls);
			tj.put("leaf", leaf);
			tj.put("statehistoryid", statehistoryid);
			tj.put("catId", catId);
			tj.put("pCatId", mtenMap.get("node"));
			tj.put("catCd", catCd);
			tj.put("useYn", useYn);
			tj.put("stateid", stateid);
			tj.put("bookId", bookId);
			tj.put("bookId2", bookId+noFormYn);
			tj.put("oBookId", oBookId);
			tj.put("noFormYn", noFormYn);
			tj.put("revCha", revCha);
			tj.put("revCd", revCd);
			tj.put("promulDt",promulDt);
			tj.put("startDt",startDt);
			tj.put("ord",ord);
			tj.put("fStateCd",fStateCd);
			tj.put("Dept",Dept);
			tj.put("Deptcd",Deptcd);
			tj.put("bookcd",bookcd);
			tj.put("updatecha",updatecha);
			tj.put("endDt",endDt);
			
			jl.add(tj);
				
			
		}
		
		return jl;
	}
	
	//하위노드 추가
	public JSONObject addRoot(Map mtenMap) {
		JSONObject result = new JSONObject();
		
		mtenMap.put("ord", commonDao.selectOne("folderSql.getCurNodeSize",mtenMap));
		
		commonDao.insert("folderSql.addChild", mtenMap);
		if(mtenMap.get("catid")!=null){
			result.put("success", true);
			result.put("catid", mtenMap.get("catid"));
		}else {
			result.put("success", false);
		}
		return result;
	}
	
	//폴더삭제
	public JSONObject deleteFolder(Map mtenMap) {
		JSONObject result = new JSONObject();
		
		int nodesize = commonDao.selectOne("folderSql.getNodeSize",mtenMap);
		if(nodesize > 1) {
			result.put("success", false);
		}else {
			commonDao.delete("folderSql.deleteFolder", mtenMap);
			commonDao.update("folderSql.reorderMinus", mtenMap);
			result.put("success", true);
		}
		return result;
	}
	
	//노드정렬순서
	public JSONObject getNodeOrd(Map mtenMap) {
		JSONObject result = new JSONObject();
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		int ordSize = commonDao.selectOne("folderSql.getCurNodeSize",mtenMap);
		if(gbn.equals("new")) {
			ordSize = ordSize+1;
		}
		JSONArray ord = new JSONArray();
		for(int i=0; i< ordSize; i++) {
			JSONObject rs = new JSONObject();
			rs.put("ord", i);
			ord.add(rs);
		}
		result.put("result", ord);
		return result;
	}
	
	public JSONObject modFolder(Map mtenMap) {
		int oldord = mtenMap.get("oldord")==null?0:Integer.parseInt(mtenMap.get("oldord").toString());
		int ord = mtenMap.get("ord")==null?0:Integer.parseInt(mtenMap.get("ord").toString());
		int resultcnt = 0;
		JSONObject result = new JSONObject();
		if((oldord-ord)>0) {
			resultcnt = commonDao.update("folderSql.reorderAbove",mtenMap);
			resultcnt = commonDao.update("folderSql.modFolder",mtenMap);
		}else if((oldord-ord)<0) {
			resultcnt = commonDao.update("folderSql.reorderBelow",mtenMap);
			resultcnt = commonDao.update("folderSql.modFolder",mtenMap);
		}else if(oldord==ord) {
			resultcnt = commonDao.update("folderSql.modFolder",mtenMap);
		}
		if(resultcnt == 0) {
			result.put("success", false);
		}else {
			result.put("success", true);
			result.put("resultcnt", resultcnt);
		}
		return result;
	}
	
	public JSONObject addChild(Map mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.update("folderSql.reorderAbove",mtenMap);
		commonDao.insert("folderSql.addChild", mtenMap);
		if(mtenMap.get("catid")!=null){
			result.put("success", true);
			result.put("catid", mtenMap.get("catid"));
		}else {
			result.put("success", false);
		}
		return result;
	}
}
