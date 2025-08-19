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
import com.mten.bylaw.bylaw.service.LogService;
import com.mten.bylaw.bylaw.service.ProcService;
import com.mten.bylaw.bylaw.service.SettingService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/log/")
public class LogController extends DefaultController{
	@Resource(name="logService")
	private LogService logService;
	
	@RequestMapping(value="logMn.do")
	public String docMn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "log/logMn.adm";
	}
	
	@RequestMapping(value="selectLogList.do")
	public void selectPopList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = new JSONObject();
		result = logService.selectLogList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
}
