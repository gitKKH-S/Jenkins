package com.mten.bylaw.user.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.mten.bylaw.ConstantCode;
import com.mten.dao.CommonDao;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("userService2")
public class UserServiceImpl implements UserService {
	protected final static Logger logger = Logger.getLogger( UserServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public JSONArray getNodes(Map mtenMap) {
		String node = mtenMap.get("node")==null?"":mtenMap.get("node").toString();
		List nodeList = new ArrayList();
		if(node.equals("ROLE")) {
			nodeList = commonDao.selectList("userSql.getNodes",mtenMap);
		}else {
			nodeList = commonDao.selectList("userSql.getUser",mtenMap);
		}
		
		for(int i=0; i<nodeList.size(); i++) {
			HashMap result = (HashMap)nodeList.get(i);
			result.put("leaf", false);
		}
		JSONArray jl = new JSONArray();
		jl = JSONArray.fromObject(nodeList);
		return jl;
	}
	
	public JSONObject createRole(Map mtenMap) {
		commonDao.insert("userSql.createRole", mtenMap);
		JSONObject jo = JSONObject.fromObject(mtenMap);
		return jo;
	}
	
	public JSONObject deleteRole(Map mtenMap) {
		int ucnt = commonDao.select("userSql.getUserNum", mtenMap);
		JSONObject jb = new JSONObject();
		if(ucnt == 0) {
			commonDao.delete("userSql.deleteRole",mtenMap);
			jb.put("result", "Y");
			jb.put("msg", "권한삭제를 완료 하였습니다.");
		}else {
			jb.put("result", "N");
			jb.put("msg", "권한을 부여받은 직원이 있어 권한 삭제를 할 수 없습니다.");
		}
		
		return jb;
	}
	
	public JSONObject userList(Map mtenMap) {
		List ulist = commonDao.selectList("userSql.getUserList", mtenMap);
		for(int i=0; i<ulist.size(); i++) {
			HashMap result = (HashMap)ulist.get(i);
			result.put("EMP_NM", result.get("EMP_NM"));
			result.put("EMP_NO", result.get("EMP_NO"));
			result.put("teamname", result.get("DEPT_NM"));
			result.put("DEPT_NM", result.get("DEPT_NM"));
			result.put("DEPT_NO", result.get("DEPT_NO"));
			result.put("phone", result.get("WRC_TELNO"));
		}
    	JSONArray jl = JSONArray.fromObject(ulist);
    	JSONObject result=new JSONObject();
    	result.put("records",jl);
    	return result;
	}
	
	public String getCode(String MNGR_AUTHRT_NM) {
		String MNGR_AUTHRT_CD = "";
		if(MNGR_AUTHRT_NM.equals("Y")) {
			MNGR_AUTHRT_CD = "10000580"; // 0
		}else if(MNGR_AUTHRT_NM.equals("H")) {
			MNGR_AUTHRT_CD = "10039558";
		}else if(MNGR_AUTHRT_NM.equals("J")) {
			MNGR_AUTHRT_CD = "100006865"; // 3
		}else if(MNGR_AUTHRT_NM.equals("C")) {
			MNGR_AUTHRT_CD = "100006864"; // 1
		}else if(MNGR_AUTHRT_NM.equals("A")) {
			MNGR_AUTHRT_CD = "100000223"; // 5
		}else if(MNGR_AUTHRT_NM.equals("K")) {
			MNGR_AUTHRT_CD = "10118756";
		}else if(MNGR_AUTHRT_NM.equals("L")) {
			MNGR_AUTHRT_CD = "100000224"; // 2
		}else if(MNGR_AUTHRT_NM.equals("M")) {
			MNGR_AUTHRT_CD = "100000225"; // 4
		}else if(MNGR_AUTHRT_NM.equals("N")) {
			MNGR_AUTHRT_CD = "100000226"; // 6
		}else if(MNGR_AUTHRT_NM.equals("B")) {
			MNGR_AUTHRT_CD = "100000227"; // 7
		}else if(MNGR_AUTHRT_NM.equals("D")) {
			MNGR_AUTHRT_CD = "100000228"; // 8
		}else if(MNGR_AUTHRT_NM.equals("E")) {
			MNGR_AUTHRT_CD = "100000229"; // 9
		}else if(MNGR_AUTHRT_NM.equals("F")) {
			MNGR_AUTHRT_CD = "100000230"; // 10
		}else if(MNGR_AUTHRT_NM.equals("G")) {
			MNGR_AUTHRT_CD = "100000231"; // 11
		}else if(MNGR_AUTHRT_NM.equals("I")) {
			MNGR_AUTHRT_CD = "100000232"; // 12
		}else if(MNGR_AUTHRT_NM.equals("Q")) {
			MNGR_AUTHRT_CD = "100000233"; // 13
		}else if(MNGR_AUTHRT_NM.equals("R")) {
			MNGR_AUTHRT_CD = "100000234"; // 14
		}
		return MNGR_AUTHRT_CD;
	}
	
	public JSONObject createUser(Map mtenMap) {
		int chk = commonDao.select("userSql.isUserExist", mtenMap);
		String MNGR_AUTHRT_NM = mtenMap.get("MNGR_AUTHRT_NM")==null?"":mtenMap.get("MNGR_AUTHRT_NM").toString();
		
		String MNGR_AUTHRT_CD = this.getCode(MNGR_AUTHRT_NM);
		
		mtenMap.put("MNGR_AUTHRT_CD", MNGR_AUTHRT_CD);
		JSONObject jb = new JSONObject();
		if(chk == 0) {
			commonDao.insert("userSql.createUser",mtenMap);
			jb.put("result", "Y");
			jb.put("msg", "담당자에게 권한 설정을 완료 하였습니다.");
			jb.put("MNGR_MNG_NO", mtenMap.get("MNGR_MNG_NO"));
			jb.put("MNGR_AUTHRT_CD", MNGR_AUTHRT_CD);
		}else {
			jb.put("result", "N");
			jb.put("msg", "이미 같은 권한이 부여된 사용자 입니다.");
		}
    	
    	return jb;
	}
	
	public JSONObject moveNode(Map mtenMap) {
		JSONObject jb = new JSONObject();
		int chk = commonDao.select("userSql.isUserExist", mtenMap);
		if(chk == 0) {
			commonDao.insert("userSql.moveNode",mtenMap);
			jb.put("result", "Y");
			jb.put("msg", "담당자에게 권한 설정을 완료 하였습니다.");
		}else {
			jb.put("result", "N");
			jb.put("msg", "이미 같은 권한이 부여된 사용자 입니다.");
		}
		return jb;
	}
	
	public JSONObject updateUser(Map mtenMap) {
		String MNGR_AUTHRT_NM = mtenMap.get("MNGR_AUTHRT_NM")==null?"":mtenMap.get("MNGR_AUTHRT_NM").toString();
		
		String MNGR_AUTHRT_CD = this.getCode(MNGR_AUTHRT_NM);
		
		mtenMap.put("MNGR_AUTHRT_CD", MNGR_AUTHRT_CD);
		JSONObject jb = new JSONObject();
		int chk = commonDao.select("userSql.isUserExist", mtenMap);
		if(chk == 0) {
			commonDao.update("userSql.updateUser",mtenMap);
			jb.put("result", "Y");
			jb.put("msg", "사용자 정보를 변경 하였습니다.");
			jb.put("MNGR_MNG_NO", mtenMap.get("MNGR_MNG_NO"));
			jb.put("MNGR_AUTHRT_CD", MNGR_AUTHRT_CD);
		}else {
			jb.put("result", "N");
			jb.put("msg", "사용자 정보 변경을 실패 하였습니다ㅣ");
		}
		return jb;
	}
	
	public JSONObject deleteUser(Map mtenMap) {
		JSONObject jb = new JSONObject();
		int chk = commonDao.delete("userSql.deleteUser", mtenMap);
		if(chk >= 1) {
			jb.put("result", "Y");
			jb.put("msg", "사용자 정보를 삭제 하였습니다.");
		}else {
			jb.put("result", "N");
			jb.put("msg", "사용자 정보 삭제를 실패 하였습니다ㅣ");
		}
		return jb;
	}
	
	public JSONObject getDeptName(Map mtenMap) {
		mtenMap.put("root", ConstantCode.DEPTROOT);
		List clist = commonDao.selectList("userSql.setDeptList",mtenMap);
		JSONArray jl = new JSONArray();
		JSONObject result = new JSONObject();
		for(int i=0; i<clist.size(); i++){
			HashMap re = (HashMap)clist.get(i);
			JSONObject obj = new JSONObject();
			obj.put("DEPT_NM",re.get("DEPT_NM")==null?"":re.get("DEPT_NM"));
			obj.put("DEPT_NO",re.get("DEPT_NO")==null?"":re.get("DEPT_NO"));
			jl.add(obj);
		}
		result.put("result",jl);
		return result;
	}
}
