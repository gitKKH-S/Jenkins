package com.mten.bylaw.approve.service;

import java.io.IOException;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import net.sf.json.JSONObject;


public interface ApproveService {
	public JSONObject approveSave(Map<String, Object> mtenMap);
	public JSONObject approveLineSend(Map<String, Object> mtenMap);
	public JSONObject setGianForm(Map<String, Object> mtenMap);
	public JSONObject chgState(Map<String, Object> mtenMap, HttpServletRequest request);
	public JSONObject showGianList(Map<String, Object> mtenMap);
}
