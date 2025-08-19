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

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.bylaw.service.CommiteeService;
import com.mten.bylaw.bylaw.service.FoldermnService;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/commitee/")
public class CommiteeController {
	@Value("#{fileinfo['mten.BBS']}") 
	public String filePath; 
	
	@Resource(name="commiteeService")
	private CommiteeService commiteeService;
	
	@RequestMapping(value="commiteeMn.do")
	public String commiteeMn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "commitee/commiteeMn.adm";
	}
	
	@RequestMapping(value="selectWewonList.do")
	public void selectWewonList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = commiteeService.selectWewonList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="delWewon.do")
	public void delWewon(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = commiteeService.delWewon(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="insertWewon.do")
	public void insertWewon(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = commiteeService.insertWewon(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="updateWewon.do")
	public void updateWewon(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = commiteeService.updateWewon(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	
	@RequestMapping(value="commission.do")
	public String commission(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "commitee/commission.adm";
	}
	
	@RequestMapping(value="commissionList.do")
	public String commissionList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		if(mtenMap.get("pageno")==null) {
			mtenMap.put("pageno",1);
		}
		mtenMap.put("pageSize",15);
		HashMap result = commiteeService.selectCommissionList(mtenMap);
		model.addAttribute("info", result);
		model.addAttribute("param", mtenMap);
		return "commitee/commissionList.extjs";
	}
	
	@RequestMapping(value="commissionWrite.do")
	public String commissionWrite(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap result = commiteeService.commissionInfo(mtenMap);
		model.addAttribute("info", result);
		model.addAttribute("param", mtenMap);
		return "commitee/commissionWrite.extjs";
	}
	
	@RequestMapping(value="commissionView.do")
	public String commissionView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap result = commiteeService.commissionInfo(mtenMap);
		model.addAttribute("info", result);
		model.addAttribute("param", mtenMap);
		return "commitee/commissionView.extjs";
	}
	
	@RequestMapping(value="lawListForCommission.do")
	public String lawListForCommission(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		List lawlist = commiteeService.lawListForCommission(mtenMap);
		model.addAttribute("info", lawlist);
		model.addAttribute("param", mtenMap);
		return "commitee/lawListForCommission.extjs";
	}
	
	@RequestMapping(value="insertCommission.do")
	public String insertCommission(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest, HttpServletResponse response, ModelMap model) throws Exception {
		Iterator<String> itr = multipartRequest.getFileNames();
		System.out.println(mtenMap);
		commiteeService.insertCommission(mtenMap, itr, multipartRequest, filePath);
		
	    return "redirect:/bylaw/commitee/commissionView.do?commissionid="+mtenMap.get("commissionid");
	}
	
	@RequestMapping(value="opinionView.do")
	public String opinionView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap result = commiteeService.opinionInfo(mtenMap);
		model.addAttribute("info", result);
		model.addAttribute("param", mtenMap);
		return "commitee/opinionView.extjs";
	}
	
	@RequestMapping(value="opinionWrite.do")
	public String opinionWrite(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap result = commiteeService.opinionInfo(mtenMap);
		model.addAttribute("info", result);
		model.addAttribute("param", mtenMap);
		return "commitee/opinionWrite.extjs";
	}
	
	@RequestMapping(value="insertOpinion.do")
	public String insertOpinion(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println(mtenMap);
		commiteeService.insertOpinion(mtenMap);
		return "commitee/proc.extjs";
	}
	
	@RequestMapping(value="fileUploadForm.do")
	public String fileUploadForm(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "commitee/fileUploadForm.extjs";
	}
	
	@RequestMapping(value="fileSave.do")
	public String fileSave(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest, HttpServletResponse response, ModelMap model) throws Exception {
		Iterator<String> itr = multipartRequest.getFileNames();
		System.out.println(mtenMap);
		commiteeService.fileSave(mtenMap, itr, multipartRequest, filePath);
		return "commitee/proc.extjs";
	}
}
