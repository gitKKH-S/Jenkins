package com.mten.bylaw.bylaw.controller;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URLDecoder;
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

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.bylaw.service.DocService;
import com.mten.bylaw.bylaw.service.ProcService;
import com.mten.bylaw.bylaw.service.SettingService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.web.service.WebService;
import com.mten.util.FileUploadUtil;
import com.mten.util.Json4Ajax;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/docmn/")
public class DocController extends DefaultController{
	@Resource(name="webService")
	private WebService webService;
	
	@Resource(name="docService")
	private DocService docService;
	
	@Resource(name="bylawService")
	private BylawService bylawService;
	
	@Value("#{fileinfo['mten.DOCTYPE']}") 
	public String DOCTYPE;
	
	@RequestMapping(value="docMn.do")
	public String docMn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "docmn/docMn.extjs";
	}
	
	@RequestMapping(value="getMenuNode.do")
	public void getMenuNode(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		List mlist = webService.getTopMenu(req);
		for(int i=0; i<mlist.size(); i++) {
			HashMap re = (HashMap)mlist.get(i);
			re.put("text", re.get("MENU_TTL"));
			re.put("id", re.get("MENU_MNG_NO"));
			re.put("leaf", true);
		}
		JSONArray jr = JSONArray.fromObject(mlist);
		Json4Ajax.commonAjax(jr, response);
	}
	
	@RequestMapping(value="getMenuDocList.do")
	public void getMenuDocList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject mlist = docService.getMenuDocList(mtenMap);
		Json4Ajax.commonAjax(mlist, response);
	}
	
	@RequestMapping("insertDoctype.do")
	public void insertDoctype(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest ,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("insertDoctype.do");
		Iterator<String> itr = multipartRequest.getFileNames();
		String sfName = "";
		while (itr.hasNext()) { 
			String formName = itr.next();
			System.out.println(formName);
			MultipartFile mpf = multipartRequest.getFile(formName);
			String originalFilename = mpf.getOriginalFilename();
			String keyid = bylawService.getKey();
			sfName = keyid +"."+ originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
			String fileFullPath = DOCTYPE + "/" + sfName;
			System.out.println("fileFullPath1===>"+fileFullPath);
			
			boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
			
			if(pchk) {
				mtenMap.put("PHYS_FILE_NM", originalFilename);
				mtenMap.put("FILE_MNG_NO", keyid);
				mtenMap.put("SRVR_FILE_NM", sfName);
				
				docService.insertDoctype(mtenMap);
			}
		}
		
		
		JSONObject mlist = new JSONObject();
		mlist.put("success", "true");
		mlist.put("sfName", sfName);
		Json4Ajax.commonAjax(mlist, response);
	}
	
	@RequestMapping(value="deleteDoctype.do")
	public void deleteDoctype(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject mlist = docService.deleteDoctype(mtenMap);
		Json4Ajax.commonAjax(mlist, response);
	}
	
}
