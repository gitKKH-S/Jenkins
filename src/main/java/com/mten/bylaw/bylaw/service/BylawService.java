package com.mten.bylaw.bylaw.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public interface BylawService {
	public String getKey();
	//본문select
	public HashMap selectBon(String Bookid);
	
	//담당부서 셀렉트박스 생성
	public String setDeptList(Map<String, Object> mtenMap);
	public String setDeptNameList(Map<String, Object> mtenMap);
	
	//메타데이트
	public HashMap selectMETA(String Bookid);
	
	//문서정보
	public JSONObject getDocInfoView(Map<String, Object> mtenMap,HttpServletRequest req);
	
	//문서본문
	public JSONObject getDocBon(Map<String, Object> mtenMap,HttpServletRequest req);
	
	//Obookid 가져오기
	public String getObookid(String bookid);
	
	public HashMap getFileName(Map mtenMap);
	
	public List getFileNameList(Map mtenMap);
	
	//문서본문
	public JSONObject schList(Map<String, Object> mtenMap,HttpServletRequest req);
	
	//제정
	public Map setXmlBon(Map<String, Object> mtenMap);
	public String dllReqSelect(Map<String, Object> mtenMap);
	public String getSelectXml(Map<String, Object> mtenMap);
	public void setLawXMLDataUpdate(Map<String, Object> mtenMap);
	public JSONArray getUserList(Map<String, Object> mtenMap);
	public Map setUpdatelog(Map<String, Object> mtenMap);
	public void setXmlschBonSetting();
	public void setXmlSchBon(String bookid);
	
	//전체다운로드
	public JSONArray getAllDownJson(Map mtenMap);
	public JSONObject setAllDown(Map<String, Object> mtenMap);
	
	public List makeExcel(Map mtenMap);
	
	
	//비정형문서
	public Map noFormInsert(Map<String, Object> mtenMap);
	public Map noFormView(Map<String, Object> mtenMap);
	
	public List getAttList(HashMap para);
	public List getSIMlist(String Bookid);
	
	//개정
	public Map DocRevision(Map<String, Object> mtenMap);
	public Map allDocRevision(Map<String, Object> mtenMap);
	//프로세스리스트
	public JSONObject progressList(Map<String, Object> mtenMap);
	
	//프로세스 규정명 변경
	public JSONObject changeTitle(Map<String, Object> mtenMap);
	
	public JSONObject updateStep(Map<String, Object> mtenMap);
	
	public JSONObject deleteProc(Map<String, Object> mtenMap);
	
	public JSONObject setRevreason(Map<String, Object> mtenMap);
	
	public JSONObject setJenmun(Map<String, Object> mtenMap);
	
	public JSONObject setMemo(Map<String, Object> mtenMap);
	
	public JSONObject getMemo(Map<String, Object> mtenMap);
	
	public JSONObject get3danList(int start, int limit, String query);
	
	public JSONObject getSchResult(int start, int limit, String query);
	
	public JSONObject getSchResult2(String query, String oBookIds);
	
	public int insertData2(String dan1, String dan2);
	public int insertData(String dan1, String dan2, String dan3);
	public int insertData3(String dan1, String dan2, String dan3, String dan4);
	public int del3danSet(String selected);
	
	public HashMap getFileInfoDLL(Map<String, Object> mtenMap);
	public boolean ServerFileBeing(Map<String, Object> mtenMap);
	public void DllImgUpload(Map<String, Object> mtenMap);
	public void DllImgDelete(Map<String, Object> mtenMap);
	public int delAttFile(Map<String, Object> mtenMap);
	
	public JSONObject promuldtInsert(Map<String, Object> mtenMap);
	public JSONObject deleteCansel(Map<String, Object> mtenMap);
	
	//첨부파일 등록(TB_LM_RULEFILE)
	public String setLawfileInsert(ArrayList fileInsert);
	
	public Map noFormUp(Map<String, Object> mtenMap);
	
	public JSONObject makeLink(Map<String, Object> mtenMap);
	
	public JSONObject ruleDeptData(Map<String, Object> mtenMap);
	
	public JSONObject ruleDeptInsert(Map<String, Object> mtenMap);
	
	public JSONObject LawAllData(Map<String, Object> mtenMap);
	
	public JSONObject saveRuleTree(Map<String, Object> mtenMap);
	
	public JSONArray getRuleTree(Map<String, Object> mtenMap);
	
	public JSONObject delRuleTree(Map<String, Object> mtenMap);
	
	public JSONObject updateRuleTree(Map<String, Object> mtenMap);
	
	public JSONObject chkCatruleList(Map<String, Object> mtenMap);
	
	public JSONArray getDept(Map<String, Object> mtenMap);
	
	public JSONObject getCatruleInsert(Map<String, Object> mtenMap);
	
	public JSONObject getCatruleList(Map<String, Object> mtenMap);
	
	public JSONObject getCatruleDelete(Map<String, Object> mtenMap);
	
	public List etcLinkSelect2(HashMap para);
	
	public List selectDocList();
	
	public JSONArray getJoMunList(Map<String, Object> mtenMap);
	
	public JSONObject ectLinkInsert(Map<String, Object> mtenMap);
	
	public String ContfileUpload(MultipartHttpServletRequest multipartRequest , Map<String, Object> mtenMap);
	
	public JSONArray selectContFile(Map<String, Object> mtenMap);
	
	public JSONObject moveNode(Map<String, Object> mtenMap);
	
	public JSONObject docInfoUpdate(Map<String, Object> mtenMap);
}
