package com.mten.bylaw.menu.controller;


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
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/menu/")
public class MenuController extends DefaultController{
	@Resource(name="menuService")
	private MenuService menuService;
	
	@RequestMapping(value="menuMn.do")
	public String codeMn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "menumn/menuMn.adm";
	}
	
	@RequestMapping(value="getNodes.do")
	public void getNodes(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("menuparid", mtenMap.get("node"));
		JSONArray jl = menuService.getNodes(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="createRootMenu.do")
	public void createRootMenu(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("URL_INFO_CN", mtenMap.get("URL_INFO_CN").toString().replaceAll("&#47;", "/"));
		JSONObject result = menuService.createNode(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="deleteMenu.do")
	public void deleteMenu(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = menuService.deleteMenu(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="getUrlInfo.do")
	public void getUrlInfo(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = menuService.getUrlInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="moveNode.do")
	public void moveNode(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = menuService.moveNode(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="getWebNodes.do")
	public void getWebNodes(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("UP_MENU_MNG_NO", mtenMap.get("node"));
		mtenMap.put("webyn", "Y");
		
		HttpSession session =  req.getSession();
		HashMap h = (HashMap)session.getAttribute("userInfo");
		String Grpcd = h.get("GRPCD")==null?"":h.get("GRPCD").toString();
		if(Grpcd.indexOf("Y")>-1 || Grpcd.indexOf("C")>-1 || Grpcd.indexOf("L")>-1||
			Grpcd.indexOf("J")>-1 || Grpcd.indexOf("M")>-1 || Grpcd.indexOf("A")>-1 ||
			Grpcd.indexOf("N")>-1 || Grpcd.indexOf("B")>-1 || Grpcd.indexOf("D")>-1 ||
			Grpcd.indexOf("E")>-1 || Grpcd.indexOf("F")>-1 || Grpcd.indexOf("G")>-1 ||
			Grpcd.indexOf("I")>-1 || Grpcd.indexOf("Q")>-1 || Grpcd.indexOf("R")>-1
				) {
			mtenMap.put("RLS_SCP_NM", "Y");
		}else {
			mtenMap.put("RLS_SCP_NM", "N");
		}
		JSONArray jl = menuService.getWebNodes(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="modSubFolder.do")
	public void modSubFolder(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = menuService.modSubFolder(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="updateMenu.do")
	public void updateMenu(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = menuService.modSubFolder(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
}
