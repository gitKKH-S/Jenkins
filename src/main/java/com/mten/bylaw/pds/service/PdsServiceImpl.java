package com.mten.bylaw.pds.service;

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

import com.mten.dao.CommonDao;
import com.mten.util.FileUploadUtil;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("pdsService")
public class PdsServiceImpl implements PdsService {
	protected final static Logger logger = Logger.getLogger( PdsServiceImpl.class );
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public JSONObject pdsListData(Map<String, Object> mtenMap) {
		List tlist = commonDao.selectList("lawbbsSql.pdsTopList", mtenMap);
		List plist = commonDao.selectList("lawbbsSql.pdsList", mtenMap);
		tlist.addAll(plist);
		
		int cnt = commonDao.select("lawbbsSql.pdsListCnt", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(tlist);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public List pdsMimgList(Map<String, Object> mtenMap) {
		return commonDao.selectList("lawbbsSql.getPdsMainImgList", mtenMap);
	}
	
	public HashMap getPdsBon(Map<String, Object> mtenMap) {
		HashMap pdsBon = commonDao.select("lawbbsSql.Select", mtenMap);
		List flist = commonDao.selectList("lawbbsSql.TB_FileList", mtenMap);
		
		HashMap result = new HashMap();
		result.put("bon", pdsBon);
		result.put("flist", flist);
		return result;
	}
	
	public void pdsMimgSave(Map<String, Object> mtenMap ,Iterator<String> itr,MultipartHttpServletRequest multipartRequest,String MfilePath) {
		commonDao.insert("lawbbsSql.Insert",mtenMap);
		while (itr.hasNext()) { 
			try {
				String formName = itr.next();
				MultipartFile mpf = multipartRequest.getFile(formName);
				String originalFilename = mpf.getOriginalFilename();
				String ext = originalFilename.substring(originalFilename.lastIndexOf("."), originalFilename.length());
				String fileid = commonDao.select("commonSql.getSeq");
				String fileFullPath = MfilePath + "/" + fileid+ext;
				
				mtenMap.put("FILE_MNG_NO", fileid);
				mtenMap.put("PHYS_FILE_NM", originalFilename);
				mtenMap.put("SRVR_FILE_NM", fileid+ext);
				mtenMap.put("FILE_EXTN_NM", ext);
				mtenMap.put("FILE_SE", "MAIN");
				
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
				if(pchk) {
					commonDao.insert("lawbbsSql.fileInsert", mtenMap);
				}else {
					System.out.println("파일업로드 실패");
				}
				
				
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
			} 
		}
	}
	
	public void setHit(Map<String, Object> mtenMap) {
		commonDao.update("lawbbsSql.setHit",mtenMap);
	}
	
	public void pdsDel(Map<String, Object> mtenMap) {
		commonDao.delete("lawbbsSql.Delete",mtenMap);
		commonDao.delete("lawbbsSql.fDelete",mtenMap);
	}
	
	public JSONObject pdsSave(Map<String, Object> mtenMap){
		String PST_MNG_NO = mtenMap.get("PST_MNG_NO")==null?"":mtenMap.get("PST_MNG_NO").toString();
		if(PST_MNG_NO.equals("")) {
			commonDao.insert("lawbbsSql.Insert",mtenMap);
		}else {
			commonDao.update("lawbbsSql.Update", mtenMap);
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
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public String saveFile(MultipartHttpServletRequest multipartRequest, Map<String, Object> mtenMap){
		String MENU_MNG_NO = mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO").toString();
		Iterator<String> itr = multipartRequest.getFileNames();
		while (itr.hasNext()) { // 받은 파일들을 모두 돌린다.
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			String fileid = commonDao.select("commonSql.getSeq");
			String originalFilename = mpf.getOriginalFilename();
			String ext = originalFilename.substring(originalFilename.lastIndexOf("."), originalFilename.length());
			String fileFullPath = mtenMap.get("filePath") + "/" + fileid+ext;
			
			try {
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
				if(pchk) {
					mtenMap.put("FILE_MNG_NO", fileid);
					mtenMap.put("PHYS_FILE_NM", originalFilename);
					mtenMap.put("SRVR_FILE_NM", fileid+ext);
					mtenMap.put("FILE_EXTN_NM", ext);
					
					if ("100000133".equals(MENU_MNG_NO)) {
						mtenMap.put("FILE_SE", "CON");
					}else {
						mtenMap.put("FILE_SE", "PDS");
					}
					commonDao.insert("lawbbsSql.fileInsert",mtenMap);
				}else {
					System.out.println("파일업로드 실패");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "";
	}
	
	public List<Map<String, Object>> listFileDownload(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("lawbbsSql.listFileDownload", mtenMap);
		return list;
	}
}
