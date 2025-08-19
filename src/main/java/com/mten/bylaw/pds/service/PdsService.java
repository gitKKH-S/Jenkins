package com.mten.bylaw.pds.service;

import java.util.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import net.sf.json.JSONObject;


public interface PdsService {
	public JSONObject pdsListData(Map<String, Object> mtenMap);
	public HashMap getPdsBon(Map<String, Object> mtenMap);
	public void pdsMimgSave(Map<String, Object> mtenMap ,Iterator<String> itr,MultipartHttpServletRequest multipartRequest,String MfilePath);
	public List pdsMimgList(Map<String, Object> mtenMap);
	public void setHit(Map<String, Object> mtenMap);
	public void pdsDel(Map<String, Object> mtenMap);
	public JSONObject pdsSave(Map<String, Object> mtenMap);
	public String saveFile(MultipartHttpServletRequest multipartRequest , Map<String, Object> mtenMap);
	public List<Map<String, Object>> listFileDownload(Map<String, Object> mtenMap);
}
