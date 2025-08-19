package com.mten.bylaw.web.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Service;
import org.apache.log4j.Logger;

import com.mten.bylaw.admin.service.UserService;
import com.mten.cmn.SessionListener;
import com.mten.dao.CommonDao;
import com.mten.dao.SmsDao;
import com.mten.email.CreatePwd;
import com.mten.email.MailSend;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Service("webService")
public class WebServiceImpl implements WebService{
	
	protected final static Logger logger = Logger.getLogger( WebServiceImpl.class );
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="smsDao")
	private SmsDao smsDao;
	
	public List getTopMenu(HttpServletRequest request) {
		HttpSession session =  request.getSession();
		HashMap h = (HashMap)session.getAttribute("userInfo");
		String Grpcd = h.get("GRPCD")==null?"":h.get("GRPCD").toString();
		
		HashMap para = new HashMap();
		para.put("ID", "0");
		
		
		if(Grpcd.indexOf("Y")>-1 || Grpcd.indexOf("C")>-1 || Grpcd.indexOf("L")>-1||
				Grpcd.indexOf("J")>-1 || Grpcd.indexOf("M")>-1 || Grpcd.indexOf("A")>-1 ||
				Grpcd.indexOf("N")>-1 || Grpcd.indexOf("B")>-1 || Grpcd.indexOf("D")>-1 ||
				Grpcd.indexOf("E")>-1 || Grpcd.indexOf("F")>-1 || Grpcd.indexOf("G")>-1 ||
				Grpcd.indexOf("I")>-1 || Grpcd.indexOf("Q")>-1 || Grpcd.indexOf("R")>-1
					) {
			para.put("ROLETYPE", "Y");
		}else {
			para.put("ROLETYPE", "N");
		}
		List mlist = commonDao.selectList("commonSql.getWebMenu", para);
		return mlist;
	}

	public JSONObject getPageNavi(Map<String, Object> mtenMap) {
		HashMap result = commonDao.select("commonSql.getPageNavi", mtenMap);
		return JSONObject.fromObject(result);
	}
	
	public JSONObject getSubTitle(Map<String, Object> mtenMap) {
		HashMap result = commonDao.select("commonSql.getSubTitle", mtenMap);
		return JSONObject.fromObject(result);
	}
	
	public int getRoleChk(Map<String, Object> mtenMap) {
		return commonDao.select("commonSql.getRoleChk", mtenMap);
	}
	
	public List byRecent(Map<String, Object> mtenMap) {
		List mlist = commonDao.selectList("bylawwebSql.getByLawList", mtenMap);
		return mlist;
	}
	
	public List pdsList(Map<String, Object> mtenMap) {
		List plist = commonDao.selectList("lawbbsSql.pdsList", mtenMap);
		return plist;
	}
	
	public List schRank(Map<String, Object> mtenMap) {
		List plist = commonDao.selectList("commonSql.schRank", mtenMap);
		return plist;
	}
	
	public JSONObject getSts(Map<String, Object> mtenMap) {
		//HashMap result = commonDao.select("commonSql.getSts1", mtenMap);
		//mtenMap.putAll(result);
		HashMap result = commonDao.select("commonSql.getSts2", mtenMap);
		mtenMap.putAll(result);
		result = commonDao.select("commonSql.getSts3", mtenMap);
		mtenMap.putAll(result);
		//result = commonDao.select("commonSql.getSts4", mtenMap);
		//mtenMap.putAll(result);
		return JSONObject.fromObject(mtenMap);
	}
	
	public String getDocFnm(Map<String, Object> mtenMap) {
		return commonDao.selectOne("commonSql.getDocFnm", mtenMap);
	}
	
	public JSONArray getDeptNode(Map<String, Object> mtenMap) {
		List dlist = commonDao.selectList("commonSql.getDeptNode",mtenMap);
		return JSONArray.fromObject(dlist);
	}
	
	public JSONArray getUserList(Map<String, Object> mtenMap) {
		List dlist = commonDao.selectList("commonSql.getUserList",mtenMap);
		return JSONArray.fromObject(dlist);
	}
	
	public void testSmS(Map<String, Object> mtenMap){
		//smsDao.insert("commonSql.setSMS",mtenMap);
	}
	

	public List getApproveList(HttpServletRequest request) {
		HttpSession session =  request.getSession();
		HashMap h = (HashMap)session.getAttribute("userInfo");
		
		List mlist = commonDao.selectList("approveSql.getApproveList", h);
		return mlist;
	}
	
	public int getTaskCount(Map<String, Object> mtenMap) {
		mtenMap.put("EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
		return commonDao.select("commonSql.getTotalTaskCnt", mtenMap);
	}
	
	public List selectMyWorkListMain(Map<String, Object> mtenMap) {
		String Grpcd = mtenMap.get("grpcd") == null ? "" : mtenMap.get("grpcd").toString();
		
		List list = new ArrayList();
		int cnt = 0;
		
		if (Grpcd.indexOf("C") > -1) {
			mtenMap.put("grpcd", "C");
			list = commonDao.selectList("commonSql.suitWorkList", mtenMap);
		} if (Grpcd.indexOf("J") > -1) {
			mtenMap.put("grpcd", "J");
			list = commonDao.selectList("commonSql.consultWorkList", mtenMap);
		} if (Grpcd.indexOf("A") > -1) {
			mtenMap.put("grpcd", "A");
			list = commonDao.selectList("commonSql.agreeWorkList", mtenMap);
		} if (Grpcd.indexOf("L") > -1) {
			mtenMap.put("grpcd", "L");
			list = commonDao.selectList("commonSql.sConsultWorkList", mtenMap);
		} else {
			// 그 외 일반사용자
			mtenMap.put("grpcd", "P");
			list = commonDao.selectList("commonSql.sConsultWorkList", mtenMap);
		}
		return list;
	}
	
	public JSONObject selectMyWorkList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String Grpcd = mtenMap.get("grpcd") == null ? "" : mtenMap.get("grpcd").toString();
		
		List list = new ArrayList();
		int cnt = 0;
		
		if (Grpcd.indexOf("C") > -1) {
			mtenMap.put("grpcd", "C");
			list = commonDao.selectList("commonSql.suitWorkList", mtenMap);
			cnt = commonDao.select("commonSql.suitWorkListCnt", mtenMap);
		} if (Grpcd.indexOf("J") > -1) {
			mtenMap.put("grpcd", "J");
			list = commonDao.selectList("commonSql.consultWorkList", mtenMap);
			cnt = commonDao.select("commonSql.consultWorkListCnt", mtenMap);
		} if (Grpcd.indexOf("A") > -1) {
			mtenMap.put("grpcd", "A");
			list = commonDao.selectList("commonSql.agreeWorkList", mtenMap);
			cnt = commonDao.select("commonSql.agreeWorkListCnt", mtenMap);
		} if (Grpcd.indexOf("L") > -1) {
			mtenMap.put("grpcd", "L");
			list = commonDao.selectList("commonSql.sConsultWorkList", mtenMap);
			cnt = commonDao.select("commonSql.sConsultWorkListCnt", mtenMap);
		} else {
			// 그 외 일반사용자
			mtenMap.put("grpcd", "P");
			list = commonDao.selectList("commonSql.pWorkList", mtenMap);
			cnt = commonDao.select("commonSql.pWorkListCnt", mtenMap);
		}
		
		JSONArray jr = JSONArray.fromObject(list);
		
		result.put("result", jr);
		result.put("total", cnt);
		return result;
	}
}
