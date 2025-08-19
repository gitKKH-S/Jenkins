package com.mten.bylaw.user.controller;


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
import com.mten.bylaw.menu.service.MenuService;
import com.mten.bylaw.user.service.UserService;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/user/")
public class UserController extends DefaultController{
	@Resource(name="userService2")
	private UserService userService;
	
	@RequestMapping(value="userMn.do")
	public String userMn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "usermn/userMn.adm";
	}
	
	@RequestMapping(value="getNodes.do")
	public void getNodes(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONArray jr = userService.getNodes(mtenMap);
		Json4Ajax.commonAjax(jr, response);
	}
	
	@RequestMapping(value="createRole.do")
	public void createRole(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("CD_LCLSF_ENG_NM", "ROLE");
		mtenMap.put("CD_LCLSF_KORN_NM", "권한구분");
		mtenMap.put("USE_YN", "Y");
		JSONObject jo = userService.createRole(mtenMap);
		jo.put("success", true);
		Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="deleteRole.do")
	public void deleteRole(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = userService.deleteRole(mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", true);
		result.put("data", jo);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="userList.do")
	public void userList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = userService.userList(mtenMap);
		Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="createUser.do")
	public void createUser(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = userService.createUser(mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", true);
		result.put("data", jo);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="moveNode.do")
	public void moveNode(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = userService.moveNode(mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", true);
		result.put("data", jo);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="updateUser.do")
	public void updateUser(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = userService.updateUser(mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", true);
		result.put("data", jo);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="deleteUser.do")
	public void deleteUser(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = userService.deleteUser(mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", true);
		result.put("data", jo);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="getDeptName.do")
	public void getDeptName(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject jo = userService.getDeptName(mtenMap);
		Json4Ajax.commonAjax(jo, response);
	}
}
