package com.mten.bylaw.admin.service;

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

import com.mten.cmn.SessionListener;
import com.mten.dao.CommonDao;
import com.mten.dao.InsaDao;
import com.mten.email.CreatePwd;
import com.mten.email.MailSend;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Service("userService")
public class UserServiceImpl implements UserService{
	
	protected final static Logger logger = Logger.getLogger( UserServiceImpl.class );
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="insaDao")
	private InsaDao insaDao;
	
	public String getClientIp(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_CLIENT_IP");
		}
		
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		
		return ip;
	}
	
	public JSONObject getMatch(Map map,HttpServletRequest request) {
		JSONObject result = new JSONObject();
		String userid = "";
		String pwd = "";
		try {
			userid = new String(Base64.decodeBase64(map.get("userid")==null?"":map.get("userid").toString()),"utf-8");
			pwd = new String(Base64.decodeBase64(map.get("pw")==null?"":map.get("pw").toString()),"utf-8");
			map.put("userid", userid);
			map.put("pw", pwd);
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			result.put("msg", "사용자정보가 존재 하지 않습니다.");
			result.put("loginyn", "N");
			return result;
		}
		
		HttpSession sessionChk = request.getSession(true);
		SessionListener.getInstance().printloginUsers();
		HashMap user = commonDao.selectOne("userSql.getMatch", map);
		if(user == null) {
			result.put("msg", "사용자정보가 존재 하지 않습니다.");
			result.put("loginyn", "N");
		} else {
			String DEPTCD = user.get("DEPTCD")==null?"":user.get("DEPTCD").toString();
			if ("6113516".equals(DEPTCD)) {
				commonDao.insert("userSql.setUserDate", user);	//접속 로그 저장
				
				String Grpcd = user.get("ISMANAGER")==null?"P":user.get("ISMANAGER").toString();
				user.put("GRPCD", Grpcd);
				
				sessionChk.setAttribute("userInfo",user);
				
				SessionListener.getInstance().setSession(sessionChk, userid);
				
				result.put("loginyn", "Y");
				result.put("msg", "로그인 되었습니다.");
				
				user.put("EMP_NO", user.get("USERID"));
				user.put("IP_ADDR", getClientIp(request));
				user.put("INSTL_YN", "X");
				
				String UID = user.get("USERID")==null?"":user.get("USERID").toString();
				int chk = commonDao.select("userSql.selectTB_LM_INSTALLCHK3", user);
				
				if(chk==0) {
					commonDao.delete("deleteTB_LM_INSTALLCHK1",user);
					commonDao.delete("deleteTB_LM_INSTALLCHK2",user);
					commonDao.insert("userSql.insertTB_LM_INSTALLCHK",user);
					
				} else {
					chk = commonDao.update("userSql.updateTB_LM_INSTALLCHK2", user);
				}
			} else {
				result.put("loginyn", "N");
				result.put("msg", "서비스 준비중입니다");
			}
		}
		return result;
	}
	
	public JSONObject getGpkiMatch(Map map, HttpServletRequest request) {
		JSONObject result = new JSONObject();
		String CRTF_SN = "";
		String CRTF_NM = "";
		
		try {
			CRTF_SN = new String(Base64.decodeBase64(map.get("CRTF_SN")==null?"":map.get("CRTF_SN").toString()),"utf-8");
			CRTF_NM = new String(Base64.decodeBase64(map.get("CRTF_NM")==null?"":map.get("CRTF_NM").toString()),"utf-8");
			map.put("CRTF_SN", CRTF_SN);
			map.put("CRTF_NM", CRTF_NM);
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			result.put("msg", "사용자정보가 존재 하지 않습니다.");
			result.put("loginyn", "N");
			return result;
		}
		
		HttpSession session = request.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		
		if (userInfo == null) {
			// 로그인 절차
			HttpSession sessionChk = request.getSession(true);
			SessionListener.getInstance().printloginUsers();
			
			String userid = commonDao.selectOne("userSql.getEmpNo", map);
			map.put("userid", userid);
			
			HashMap user = commonDao.selectOne("userSql.getMatch", map);
			if(user == null) {
				result.put("msg", "사용자정보가 존재 하지 않습니다.");
				result.put("loginyn", "N");
			} else {
				String DEPTCD = user.get("DEPTCD")==null?"":user.get("DEPTCD").toString();
				commonDao.insert("userSql.setUserDate", user);	//접속 로그 저장
				
				String Grpcd = user.get("ISMANAGER")==null?"P":user.get("ISMANAGER").toString();
				user.put("GRPCD", Grpcd);
				
				sessionChk.setAttribute("userInfo",user);
				
				SessionListener.getInstance().setSession(sessionChk, userid);
				
				result.put("loginyn", "Y");
				result.put("msg", "로그인 되었습니다.");
				
				user.put("EMP_NO", user.get("USERID"));
				user.put("IP_ADDR", getClientIp(request));
				user.put("INSTL_YN", "X");
				
				String UID = user.get("USERID")==null?"":user.get("USERID").toString();
				int chk = commonDao.select("userSql.selectTB_LM_INSTALLCHK3", user);
				
				if(chk==0) {
					commonDao.delete("deleteTB_LM_INSTALLCHK1",user);
					commonDao.delete("deleteTB_LM_INSTALLCHK2",user);
					commonDao.insert("userSql.insertTB_LM_INSTALLCHK", user);
					
				} else {
					chk = commonDao.update("userSql.updateTB_LM_INSTALLCHK2", user);
				}
			}
			
			return result;
		} else {
			// GPKI 인증서 등록 절차
			map.put("EMP_NO", userInfo.get("USERNO")==null?"":userInfo.get("USERNO").toString());
			
			String EMP_PK_NO = commonDao.selectOne("userSql.getEmpNo2", map);
			map.put("EMP_PK_NO", EMP_PK_NO);
			
			int cnt = commonDao.selectOne("userSql.getGpkiSnCnt", map);
			if (cnt > 0) {
				commonDao.update("userSql.updateGPKIInfo", map);
				
				result.put("loginyn", "A");
				result.put("msg", "인증서 정보가 갱신 되었습니다.");
			} else {
				commonDao.insert("userSql.insertGPKIInfo", map);
				
				result.put("loginyn", "A");
				result.put("msg", "인증서 정보가 등록 되었습니다.");
			}
			
			return result;
		}
	}
	
	public JSONObject selectOrg(Map map){
		System.out.println("시작=============>111");
		try{
		List ul = insaDao.selectList("userSql.selectOrg");
		System.out.println("--------------------------");
		System.out.println(ul);
		}catch(Exception e){
			System.out.println(e);
		}
		System.out.println("--------------------------");
		JSONObject result = new JSONObject();
		return result;
	}
	
	
	
	
	

	public void setInstallChk(Map map) {
		commonDao.update("userSql.updateTB_LM_INSTALLCHK1",map);
		commonDao.update("userSql.updateTB_LM_INSTALLCHK2",map);
	}
	
	public String getInstallChk(Map map) {
		String yn = "";
		yn = commonDao.select("userSql.selectTB_LM_INSTALLCHK1_1",map);
		
		if(yn.equals("X") || yn.equals("") || yn == null) {
			yn = commonDao.select("userSql.selectTB_LM_INSTALLCHK2_1",map);
		}
		
		if (yn == null || yn.equals("")) {
			yn = "X";
		}
		return yn;
	}
}
