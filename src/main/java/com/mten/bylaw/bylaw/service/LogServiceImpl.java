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
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("logService")
public class LogServiceImpl implements LogService {
	protected final static Logger logger = Logger.getLogger( LogServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public void setLog(Map<String, Object> logMap) {
		commonDao.insert("logSql.setLog",logMap);
	}
	
	public JSONObject selectLogList(Map<String, Object> mtenMap) {
		JSONObject rs = new JSONObject();
		
		List resList = commonDao.selectList("logSql.selectLogList",mtenMap);
		int total = commonDao.select("logSql.selectLogTotal",mtenMap);
		rs.put("total", total);
		JSONArray jl = JSONArray.fromObject(resList);
		rs.put("result", jl);
		return rs;
	}
}
