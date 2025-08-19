package com.mten.bylaw.bylaw.controller;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.bylaw.service.PopmnService;
import com.mten.bylaw.bylaw.service.ProcService;
import com.mten.bylaw.bylaw.service.SettingService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/popmn/")
public class PopmnController extends DefaultController{
	@Resource(name="popmnService")
	private PopmnService popmnService;
	
	@RequestMapping(value="popmn.do")
	public String popmn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "popmn/popmn.extjs";
	}
	
	@RequestMapping(value="selectPopList.do")
	public void selectPopList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = new JSONObject();
		result = popmnService.selectPopList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="deletePop.do")
	public void deletePop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = new JSONObject();
		result = popmnService.deletePop(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/insertPop.do")
	public void insertPop(Map<String, Object> mtenMap ,HttpServletRequest req, MultipartHttpServletRequest multipartRequest, HttpServletResponse response, ModelMap model) throws Exception{
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = new JSONObject();
		result = popmnService.insertPop(mtenMap,multipartRequest);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/selectView.do")
	public void selectView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception{
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = new JSONObject();
		result = popmnService.selectView(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="todayPopList.do")
	public void todayPopList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = new JSONObject();
		result = popmnService.todayPopList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
}
