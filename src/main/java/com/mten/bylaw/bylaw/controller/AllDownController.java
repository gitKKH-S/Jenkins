package com.mten.bylaw.bylaw.controller;


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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/cdmake/")
public class AllDownController extends DefaultController{
	@Resource(name="bylawService")
	private BylawService bylawService;
	
	@RequestMapping(value="mtree.do")
	public String lawMn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "cdmake/mtree.extjs";
	}
	
	@RequestMapping(value="getCdnodes.do")
	public void getCdnodes(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONArray jl = bylawService.getAllDownJson(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="setAllDown.do")
	public void setAllDown(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jl = bylawService.setAllDown(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
}
