package com.mten.bylaw.approve.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.GZIPOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.agree.service.AgreeService;
import com.mten.bylaw.approve.service.ApproveService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.law.service.LawService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.bylaw.web.service.WebService;
import com.mten.util.BindObject;
import com.mten.util.CommonMakeExcel;
import com.mten.util.Json4Ajax;
import com.mten.util.JsonHelper;
import com.mten.util.zipFileDownload;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/web/approve/")
public class ApproveController extends DefaultController{
	@Resource(name="approveService")
	private ApproveService approveService;

	@Resource(name="webService")
	private WebService webService;
	
	@RequestMapping(value="approveSave.do")
	public ModelAndView approveSave(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model){
		JSONObject result = approveService.approveSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="approveLineSend.do")
	public ModelAndView approveLineSend(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model){
		JSONObject result = approveService.approveLineSend(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="setGianForm.do")
	public ModelAndView setGianForm(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model){
		JSONObject result = approveService.setGianForm(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="chgState.do")
	public ModelAndView chgState(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model){
		JSONObject result = approveService.chgState(mtenMap, req);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="showGianList.do")
	public ModelAndView showGianList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model){
		JSONObject result = approveService.showGianList(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
}
