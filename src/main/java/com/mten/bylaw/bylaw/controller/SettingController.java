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
import com.mten.bylaw.bylaw.service.ProcService;
import com.mten.bylaw.bylaw.service.SettingService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/setting/")
public class SettingController extends DefaultController{
	@Resource(name="procService")
	private ProcService procService;
	
	@Resource(name="settingService")
	private SettingService settingService;
	@RequestMapping(value="getProcessListButton2.do")
	public void getProcessListButton2(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String html = procService.getProcessListButton(mtenMap);
		
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println(html);
			writer.close();
		}
		catch (IOException ioe) {
		}
	}
	
	@RequestMapping(value="getButtonList.do")
	public void getButtonList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = procService.getButtonList(mtenMap);
		Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="settingMn.do")
	public String lawMn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "settingmn/settingMn.adm";
	}
	
	@RequestMapping(value="settingIbanlist.do")
	public void settingIbanlist(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = settingService.settingIbanlist(mtenMap);
		Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="getNextCombo.do")
	public void getNextCombo(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = settingService.getNextCombo(mtenMap);
		Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="getProcessListButton.do")
	public void getProcessListButton(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String html = settingService.getProcessListButton(mtenMap);
		Json4Ajax.response(html, response);
	}
	
	@RequestMapping(value="settingIbanUpdate.do")
	public void settingIbanUpdate3(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = settingService.settingIbanUpdate(mtenMap);
		Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="settingIbanUpdate2.do")
	public void settingIbanUpdate2(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = settingService.settingIbanUpdate2(mtenMap);
		Json4Ajax.commonAjax(jo, response);
	}
}
