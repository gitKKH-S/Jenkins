package com.mten.bylaw.bylaw.controller;


import java.io.IOException;
import java.io.PrintWriter;
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

import com.mten.bylaw.bylaw.service.FoldermnService;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/folder/")
public class FoldermnController {
	@Resource(name="foldermnService")
	private FoldermnService foldermnService;
	
	//트리노드
	@RequestMapping(value="getNodes.do")
	protected void getNodes(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONArray jr = foldermnService.getCatListJson(mtenMap);
		Json4Ajax.commonAjax(jr, response);
	}
	
	//루트폴더추가
	@RequestMapping(value="addRoot.do")
	protected void addRoot(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject result = foldermnService.addRoot(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	//하위폴더추가
	@RequestMapping(value="addChild.do")
	protected void addChild(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject result = foldermnService.addRoot(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	//폴더정렬정보
	@RequestMapping(value="getNodeOrd.do")
	protected void getNodeOrd(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject result = foldermnService.getNodeOrd(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	//폴더삭제
	@RequestMapping(value="deleteFolder.do")
	protected void deleteFolder(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject result = foldermnService.deleteFolder(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	//폴더삭제
	@RequestMapping(value="modFolder.do")
	protected void modFolder(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject result = foldermnService.modFolder(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
}
