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

@Service("popmnService")
public class PopmnServiceImpl implements PopmnService {
	protected final static Logger logger = Logger.getLogger( PopmnServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public JSONObject selectPopList(Map<String, Object> mtenMap) {
		int start =	mtenMap.get("start")==null?0:Integer.parseInt(mtenMap.get("start").toString());
		int limit =	mtenMap.get("limit")==null?0:Integer.parseInt(mtenMap.get("limit").toString());
		limit+=start;
		
		JSONObject rs = new JSONObject();
		
		List resList = commonDao.selectList("popSql.selectPopList",mtenMap);
		if(resList.size()-limit<0){
			limit=resList.size();
		}
		rs.put("total", resList.size());
		JSONArray jl = new JSONArray();
		for(int i=start;i<limit;i++){
			jl.add(JSONObject.fromObject(resList.get(i)));
		}
		rs.put("result", jl);
		return rs;
	}
	
	public JSONObject deletePop(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		commonDao.selectList("popSql.deletePop",mtenMap);
		rs.put("success", true);
		return rs;
	}
	
	public JSONObject selectView(Map<String, Object> mtenMap) {
		return JSONObject.fromObject(commonDao.selectOne("popSql.selectPop",mtenMap));
	}
	
	public JSONObject insertPop(Map<String, Object> mtenMap,MultipartHttpServletRequest multipartRequest) throws IllegalStateException, IOException {
		Iterator<String> itr = multipartRequest.getFileNames();
		String sfName = "";
		String POPUP_MNG_NO = mtenMap.get("POPUP_MNG_NO")==null?"":mtenMap.get("POPUP_MNG_NO").toString();
		if(POPUP_MNG_NO.equals("")) {
			commonDao.insert("popSql.insertPop",mtenMap);
		}else {
			commonDao.update("popSql.updatePop",mtenMap);
		}
		
		while (itr.hasNext()) { 
			String formName = itr.next();
			MultipartFile mpf = multipartRequest.getFile(formName);
			String originalFilename = mpf.getOriginalFilename();
			if(!originalFilename.equals("")) {
				String keyid = commonDao.select("commonSql.getSeq");
	
				sfName = keyid +"."+ originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
				
				String fileFullPath = MakeHan.File_url("PDS") + "/" + sfName;
				System.out.println("fileFullPath1===>"+fileFullPath);
				
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
				
				if(pchk) {
					mtenMap.put("PST_MNG_NO", mtenMap.get("POPUP_MNG_NO"));
					mtenMap.put("FILE_MNG_NO", keyid);
					mtenMap.put("PHYS_FILE_NM", originalFilename);
					mtenMap.put("SRVR_FILE_NM", sfName);
					mtenMap.put("FILE_EXTN_NM", originalFilename.substring(originalFilename.lastIndexOf(".") + 1));
					mtenMap.put("FILE_SE", "POP");
					
					//mpf.transferTo(new File(fileFullPath));
					FileUploadUtil.saveFile(mpf, fileFullPath);
					commonDao.delete("lawbbsSql.fDelete",mtenMap);
					commonDao.insert("lawbbsSql.fileInsert",mtenMap);
				}
			}
		}
		
		
		JSONObject rs = new JSONObject();
		rs.put("success", true);
		return rs;
	}
	
	public JSONObject todayPopList(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		List resList = commonDao.selectList("popSql.todayPopList",mtenMap);
		
		JSONArray jl = new JSONArray();
		for(int i=0;i<resList.size();i++){
			HashMap result = (HashMap)resList.get(i);
			result.put("POPUP_CN", result.get("POPUP_CN")==null?"":result.get("POPUP_CN").toString().replace("\n", "<br/>"));
			jl.add(JSONObject.fromObject(result));
		}
		
		rs.put("result", jl);
		return rs;
	}
}
