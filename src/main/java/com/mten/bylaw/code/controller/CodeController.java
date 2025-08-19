package com.mten.bylaw.code.controller;


import java.io.IOException;
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
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.code.service.CodeService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/code/")
public class CodeController extends DefaultController{
	@Resource(name="codeService")
	private CodeService codeService;
	
	@RequestMapping(value="codeMn.do")
	public String codeMn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "codemn/codeMn.adm";
	}
	
	@RequestMapping(value="getNodes.do")
	public void getNodes(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONArray jl = codeService.getNodes(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="getCodeExpList.do")
	public void getCodeExpList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONArray jl = codeService.getNodes(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="getCodeList.do")
	public void getCodeList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		int start = ServletRequestUtils.getIntParameter(req,"start",0);
		int limit = ServletRequestUtils.getIntParameter(req,"limit",0);
		limit+=start;
		
		JSONObject obj = codeService.getCodeList(mtenMap,start,limit);
		Json4Ajax.commonAjax(obj, response);
	}
	
	@RequestMapping(value="getCodeCombo.do")
	public void getCodeCombo(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jl = codeService.getCodeCombo(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="getOrd.do")
	public void getOrd(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jl = codeService.getOrd(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="deleteCode.do")
	public void deleteCode(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jl = codeService.deleteCode(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="createCode.do")
	public void createCode(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jl = codeService.createCode(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="updateCode.do")
	public void updateCode(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jl = codeService.updateCode(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
}
