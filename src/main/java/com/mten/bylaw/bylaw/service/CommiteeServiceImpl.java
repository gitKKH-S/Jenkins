package com.mten.bylaw.bylaw.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mten.bylaw.admin.service.UserServiceImpl;
import com.mten.dao.CommonDao;
import com.mten.util.FileUploadUtil;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("commiteeService")
public class CommiteeServiceImpl implements CommiteeService {
	protected final static Logger logger = Logger.getLogger( CommiteeServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public JSONObject insertWewon(Map<String, Object> mtenMap) {
		commonDao.insert("commissionSql.insertWewon", mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", true);
		result.put("data", JSONObject.fromObject(mtenMap));
		return result;
	}
	
	public JSONObject selectWewonList(Map<String, Object> mtenMap){
		List wewonList = commonDao.selectList("commissionSql.selectWewonList", mtenMap);
		JSONObject result = new JSONObject();
		
		result.put("total", wewonList.size());
		result.put("result", JSONArray.fromObject(wewonList));
		
		return result;
	}
	
	public List selectWewonList2(Map<String, Object> mtenMap){
		List result = new ArrayList();
		return result;
	}
	
	public JSONObject selectCommiteeList(Map<String, Object> mtenMap){
		JSONObject result = new JSONObject();
		return result;
	}
	
	public JSONObject delWewon(Map<String, Object> mtenMap){
		commonDao.delete("commissionSql.delWewon", mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", true);
		return result;
	}
	
	public JSONObject updateWewon(Map<String, Object> mtenMap){
		commonDao.selectList("commissionSql.updateWewon", mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", true);
		return result;
	}
	
	
	public HashMap selectCommissionList(Map<String, Object> mtenMap) {
		List clist = commonDao.selectList("commissionSql.selectCommissionList",mtenMap);
		int total = commonDao.selectOne("commissionSql.selectCommissionListTot", mtenMap);
		
		HashMap result = new HashMap();
		result.put("clist", clist);
		result.put("total", total);
		return result;
	}
	
	public HashMap commissionInfo(Map<String, Object> mtenMap) {
		String commissionid = mtenMap.get("commissionid")==null?"":mtenMap.get("commissionid").toString();
		HashMap result = new HashMap();
		
		if(commissionid.length()>0 && !commissionid.equals("")) {
			HashMap commissionInfo = commonDao.selectOne("commissionSql.selectCommissionInfo", mtenMap);
			List ruleList = commonDao.selectList("commissionSql.selectAngun", mtenMap);
			
			//의견리스트
			mtenMap.put("opGbn", "W");
			String openYn = commissionInfo.get("OPENYN")==null?"":commissionInfo.get("OPENYN").toString();
			if(openYn.equals("N")){
				mtenMap.put("userno", mtenMap.get("writerid"));
			}
			List opinionList = commonDao.selectList("commissionSql.selectOpinionList",mtenMap);
			
			mtenMap.remove("userno");
			//간사의견리스트
			mtenMap.put("opGbn","G");
			List gansa_opinionList = commonDao.selectList("commissionSql.selectOpinionList",mtenMap);
			
			//위원장의견리스트
			mtenMap.put("opGbn","C");
			List jang_opinionList = commonDao.selectList("commissionSql.selectOpinionList",mtenMap);
			
			//노조조합장 의견
			mtenMap.put("opGbn","N");
			List Njang_opinionList = commonDao.selectList("commissionSql.selectOpinionList",mtenMap);
			
			mtenMap.put("PST_MNG_NO", commissionid);
			mtenMap.put("bbscd", "summary");
			List fList1 = commonDao.selectList("lawbbsSql.fileList", mtenMap);
			mtenMap.put("bbscd", "etc");
			List fList2 = commonDao.selectList("lawbbsSql.fileList", mtenMap);
			
			mtenMap.put("bbscd", "opinion");
			List fList3 = commonDao.selectList("lawbbsSql.fileList", mtenMap);
			mtenMap.put("bbscd", "resummary");
			List fList4 = commonDao.selectList("lawbbsSql.fileList", mtenMap);
			
			result.put("commissionInfo", commissionInfo);
			result.put("opinionList", opinionList);
			result.put("gansa_opinionList", gansa_opinionList);
			result.put("jang_opinionList", jang_opinionList);
			result.put("Njang_opinionList", Njang_opinionList);
			result.put("ruleList", ruleList);
			result.put("fList1", fList1);
			result.put("fList2", fList2);
			result.put("fList3", fList3);
			result.put("fList4", fList4);
		}
		return result;
	}
	
	public List lawListForCommission(Map<String, Object> mtenMap) {
		return commonDao.selectList("commissionSql.selectLawList",mtenMap);
	}
	
	public void insertCommission(Map<String, Object> mtenMap,Iterator<String> itr ,MultipartHttpServletRequest multipartRequest, String filePath) {
		String commissionid = mtenMap.get("commissionid")==null?"":mtenMap.get("commissionid").toString();
		if (commissionid.length()<1){
			commonDao.insert("commissionSql.insertCommission",mtenMap);
		}else {
			commonDao.update("commissionSql.updateCommission",mtenMap);
			commonDao.delete("commissionSql.deleteAngun",mtenMap);
		}
		
		//안건정보 저장
		String bIds = mtenMap.get("bookids")==null?"":mtenMap.get("bookids").toString();
		if (bIds.length()>0){
			String[] bookIds = bIds.split("@@");
			for (int i=0; i<bookIds.length;i++){
				mtenMap.put("bookid", bookIds[i]);
				commonDao.insert("commissionSql.insertAngun",mtenMap);
			}
		}
		
		//안건요약표 첨부파일 저장
		while (itr.hasNext()) { 
			try {
				String formName = itr.next();
				MultipartFile mpf = multipartRequest.getFile(formName);
				String fname = mpf.getName();
				
				if(mpf.getOriginalFilename()!=null && !mpf.getOriginalFilename().equals("")){
					String originalFilename = mpf.getOriginalFilename();
					String ext = originalFilename.substring(originalFilename.lastIndexOf("."), originalFilename.length());
					String fileid = commonDao.select("commonSql.getSeq");
					String fileFullPath = filePath + "/" + fileid+ext;
					
					mtenMap.put("fileid", fileid);
					mtenMap.put("PST_MNG_NO", mtenMap.get("commissionid"));
					mtenMap.put("pcfilename", originalFilename);
					mtenMap.put("serverfilename", fileid+ext);
					mtenMap.put("fileext", ext);
					
					if(fname.equals("attFile2")) {
						mtenMap.put("filecd", "etc");
					}
					if(fname.equals("attFile")) {
						mtenMap.put("filecd", "summary");
					}
					boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
					if(pchk) {
						commonDao.insert("lawbbsSql.fileInsert",mtenMap);
					}
					
				}
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
			} 
		}
		
		if(mtenMap.get("delfile[]")!=null){
			if(mtenMap.get("delfile[]").getClass().equals(String.class)){
				if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
					mtenMap.put("FILEID", mtenMap.get("delfile[]"));
					commonDao.delete("lawbbsSql.fDelete", mtenMap);
				}
					
			}else{
				ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
				for(int i=0; i<delfile.size(); i++){
					if(delfile.get(i) != null && !delfile.get(i).equals("")){
						mtenMap.put("FILEID", delfile.get(i));
						commonDao.delete("lawbbsSql.fDelete", mtenMap);
					}
				}
			}
		}
	}
	
	public HashMap opinionInfo(Map<String, Object> mtenMap) {
		HashMap resultMap = commonDao.selectOne("commissionSql.selectCommissionInfo", mtenMap);
		List ruleList = commonDao.selectList("commissionSql.selectAngun", mtenMap);
		
		HashMap result = new HashMap();
		String opinionid 	= mtenMap.get("opinionid")==null?"":mtenMap.get("opinionid").toString();
		if(opinionid.length()>0){
			resultMap = commonDao.selectOne("commissionSql.selectOpinionInfo",mtenMap);
			ruleList = commonDao.selectList("commissionSql.selectOpinionYn",mtenMap);
			
			mtenMap.put("PST_MNG_NO", opinionid);
			mtenMap.put("bbscd", "opinion");
			List fList1 = commonDao.selectList("lawbbsSql.fileList", mtenMap);
			
			result.put("fList1", fList1);
		}
		result.put("resultMap", resultMap);
		result.put("ruleList", ruleList);
		return result;
	}
	
	public void insertOpinion(Map<String, Object> mtenMap){
		String opinionId = ""+mtenMap.get("opinionid");
		String bookIds = ""+mtenMap.get("bookids");
		String yORn = ""+mtenMap.get("yorn");
		String OPGBN = ""+mtenMap.get("opgbn");
		mtenMap.remove("yORn");
		String result = "";		
		
		//처음저장
		if (opinionId.length()<1){
			//tb_lm_opinion
			commonDao.insert("commissionSql.insertWewonopinion",mtenMap);
			result = ""+mtenMap.get("opinionid");
		}
		//수정
		else{
			result = opinionId;
			commonDao.update("commissionSql.updateWewonOpinion",mtenMap);
			commonDao.delete("commissionSql.deleteOpinionYn",mtenMap);
		}
		
		//tb_lm_opinionYn
		String[] bookId_Array = bookIds.split("@@");
		String[] yORn_Array = yORn.split("@@");
		for (int i=0; i<bookId_Array.length; i++){
			mtenMap.put("bookid", bookId_Array[i]);
			
			if(OPGBN.equals("W")){
				mtenMap.put("yorn", yORn_Array[i]);
			}
			commonDao.insert("commissionSql.insertOpinionYn",mtenMap);
		}
	}

	public void fileSave(Map<String, Object> mtenMap,Iterator<String> itr ,MultipartHttpServletRequest multipartRequest, String filePath){
		while (itr.hasNext()) { 
			try {
				String formName = itr.next();
				MultipartFile mpf = multipartRequest.getFile(formName);
				String fname = mpf.getName();
				
				if(mpf.getOriginalFilename()!=null && !mpf.getOriginalFilename().equals("")){
					String originalFilename = mpf.getOriginalFilename();
					String ext = originalFilename.substring(originalFilename.lastIndexOf("."), originalFilename.length());
					String fileid = commonDao.select("commonSql.getSeq");
					String fileFullPath = filePath + "/" + fileid+ext;
					
					mtenMap.put("fileid", fileid);
					mtenMap.put("PST_MNG_NO", mtenMap.get("commissionid"));
					mtenMap.put("pcfilename", originalFilename);
					mtenMap.put("serverfilename", fileid+ext);
					mtenMap.put("fileext", ext);
					mtenMap.put("BBSCD", mtenMap.get("filecd"));
					boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
					if(pchk) {
						commonDao.delete("lawbbsSql.fDelete",mtenMap);
						commonDao.insert("lawbbsSql.fileInsert",mtenMap);
					}
					
				}
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
			} 
		}
	}
}
