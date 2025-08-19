package com.mten.bylaw.pds.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.law.service.LawService;
import com.mten.bylaw.pds.service.PdsService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.util.BindObject;
import com.mten.util.CommonMakeExcel;
import com.mten.util.Json4Ajax;
import com.mten.util.JsonHelper;
import com.mten.util.zipFileDownload;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/web/pds/")
public class PdsController extends DefaultController{
	@Value("#{fileinfo['mten.PDS']}") 
	public String filePath; 
	
	@Value("#{fileinfo['mten.MAIN']}") 
	public String MfilePath; 
	
	@Value("#{fileinfo['mten.TEMP']}")
	public String tempPath;
	
	@Value("#{fileinfo['mten.CONSULT']}") 
	public String filePath2; 

	zipFileDownload zip = new zipFileDownload();
	
	@Resource(name="pdsService")
	private PdsService pdsService;
	
	@RequestMapping(value="goPdsMain.do")
	public String goPdsMain(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "pds/pdsMain.web";
	}
	
	@RequestMapping(value="pdsList.do")
	public String pdsList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String MENU_MNG_NO = mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO").toString();
		String url = "";
		if ("100000133".equals(MENU_MNG_NO)) {
			url = "pds/consultPdsList.frm";
		}else {
			url = "pds/pdsList.frm";
		}
		
		return url;
	}
	
	@RequestMapping(value="pdsWrite.do")
	public String pdsWrite(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String PST_MNG_NO = mtenMap.get("PST_MNG_NO")==null?"":mtenMap.get("PST_MNG_NO").toString();
		if(!PST_MNG_NO.equals("")) {
			HashMap pdsBon = pdsService.getPdsBon(mtenMap);
			model.addAttribute("pdsBon", pdsBon);
		}
		
		String MENU_MNG_NO = mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO").toString();
		String url = "";
		if ("100000133".equals(MENU_MNG_NO)) {
			url = "pds/consultPdsWrite.frm";
		}else {
			url = "pds/pdsWrite.frm";
		}
		return url;
	}
	
	@RequestMapping(value="pdsView.do")
	public String pdsView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		req.setAttribute("logMap", mtenMap);
		
		pdsService.setHit(mtenMap);
		HashMap pdsBon = pdsService.getPdsBon(mtenMap);
		model.addAttribute("pdsBon", pdsBon);
		
		String MENU_MNG_NO = mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO").toString();
		System.out.println("12312313 : " + MENU_MNG_NO);
		String url = "";
		if ("100000133".equals(MENU_MNG_NO)) {
			url = "pds/consultPdsView.frm";
		}else {
			url = "pds/pdsView.frm";
		}
		return url;
	}
	
	@RequestMapping(value="pdsViewPop.do")
	public String pdsViewPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		req.setAttribute("logMap", mtenMap);
		
		pdsService.setHit(mtenMap);
		HashMap pdsBon = pdsService.getPdsBon(mtenMap);
		model.addAttribute("pdsBon", pdsBon);
		return "pds/pdsViewPop.frm";
	}
	
	@RequestMapping(value="pdsDel.do")
	public String pdsDel(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		req.setAttribute("logMap", mtenMap);
		
		pdsService.pdsDel(mtenMap);
		return "redirect:/web/pds/pdsList.do?MENU_MNG_NO="+mtenMap.get("MENU_MNG_NO");
	}
	
	@RequestMapping(value="pdsDelajax.do")
	public ModelAndView pdsDelajax(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		pdsService.pdsDel(mtenMap);
		JSONObject result = new JSONObject();
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="pdsMimgList.do")
	public String pdsMimgList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("mlist", pdsService.pdsMimgList(mtenMap));
		return "pds/pdsMimgList.frm";
	}

	@RequestMapping(value="pdsMimgWrite.do")
	public String pdsMimgWrite(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "pds/pdsMimgWrite.frm";
	}
	
	@RequestMapping(value="pdsMimgSave.do")
	public String pdsMimgSave(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest, HttpServletResponse response, ModelMap model) throws Exception {
		Iterator<String> itr = multipartRequest.getFileNames();
		System.out.println(mtenMap);
		pdsService.pdsMimgSave(mtenMap, itr, multipartRequest, MfilePath);
	    return "redirect:/web/pds/pdsMimgList.do?MENU_MNG_NO="+mtenMap.get("MENU_MNG_NO");
	}
	
	@RequestMapping(value="pdsSave.do")
	public ModelAndView pdsSave(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setAttribute("logMap", mtenMap);
		
		JSONObject result = pdsService.pdsSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value = "fileUpload.do") // ajax에서 호출하는 부분
	@ResponseBody
	public String upload(Map<String, Object> mtenMap ,HttpServletRequest request, MultipartHttpServletRequest multipartRequest) { // Multipart로
		request.setAttribute("logMap", mtenMap);
		
		System.out.println("mtenMap==>"+mtenMap);
		System.out.println("mten==>"+multipartRequest.getParameter("DOCTITLE"));
		System.out.println("filePath==>"+filePath);
		
		String MENU_MNG_NO = mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO").toString();
		if ("100000133".equals(MENU_MNG_NO)) {
			mtenMap.put("filePath", filePath2);
		}else {
			mtenMap.put("filePath", filePath);
		}
		
		pdsService.saveFile(multipartRequest, mtenMap);
		
		return "success";
	}
	
	@RequestMapping(value="pdsListData.do")
	public void pdsListData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		req.setAttribute("logMap", mtenMap);
		
		String start = mtenMap.get("start")==null?"":mtenMap.get("start").toString();
		String limit = mtenMap.get("limit")==null?"":mtenMap.get("limit").toString();
		
		if(!start.equals("") & !limit.equals("")){
			int a = Integer.parseInt(start);
			int b = Integer.parseInt(limit);
			int result = 1;
			if(b != 0){
				result = a/b+1;
			}
			mtenMap.put("pageno", result);
		}
		
		String sort = mtenMap.get("sort")==null?"":mtenMap.get("sort").toString();
		String dir = mtenMap.get("dir")==null?"":mtenMap.get("dir").toString();
		String orderby = "";
		if(!sort.equals("") && !dir.equals("")){
			if(sort.equals("ordsort")){
				orderby = "";
			}else{
				orderby = "order by "+sort+" "+dir;	
			}
			
			mtenMap.put("orderby", orderby);
		}
		
		JSONObject result = pdsService.pdsListData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="pdsListDataMakeExcel.do")
	public void pdsListDataMakeExcel(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		req.setAttribute("logMap", mtenMap);
		
		String start = mtenMap.get("start")==null?"":mtenMap.get("start").toString();
		String limit = mtenMap.get("limit")==null?"":mtenMap.get("limit").toString();
		
		if(!start.equals("") & !limit.equals("")){
			int a = Integer.parseInt(start);
			int b = Integer.parseInt(limit);
			int result = 1;
			if(b != 0){
				result = a/b+1;
			}
			mtenMap.put("pageno", result);
		}
		
		String sort = mtenMap.get("sort")==null?"":mtenMap.get("sort").toString();
		String dir = mtenMap.get("dir")==null?"":mtenMap.get("dir").toString();
		String orderby = "";
		if(!sort.equals("") && !dir.equals("")){
			if(sort.equals("ordsort")){
				orderby = "";
			}else{
				orderby = "order by "+sort+" "+dir;	
			}
			
			mtenMap.put("orderby", orderby);
		}
		
		JSONObject result = pdsService.pdsListData(mtenMap);
		
		List datalist = JsonHelper.toList((JSONArray)result.get("result"));
		
		String MENU_MNG_NO = mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO").toString();
		
		String sTit = "리스트대장출력";
		if(datalist.size()>0) {
			sTit = ((HashMap)datalist.get(0)).get("MENU_TTL").toString();
		}
		ArrayList<String> columnList = new ArrayList<String>();	//데이터컬럼명
		ArrayList<String> columnRList = new ArrayList<String>();	//화면용컬럼명
		if ("100000133".equals(MENU_MNG_NO)) {
			columnRList.add("제목");
			columnRList.add("등록자");
			columnRList.add("등록일");
			columnRList.add("처리상태");
			columnRList.add("첨부파일");
			
			columnList.add("PST_TTL");
			columnList.add("WRTR_EMP_NM");
			columnList.add("WRT_YMD");
			columnList.add("PRCS_STTS_SE_NM");
			columnList.add("FCNT");
		}else {
			columnRList.add("제목");
			columnRList.add("등록자");
			columnRList.add("등록일");
			columnRList.add("첨부파일");
			columnRList.add("조회수");
			
			columnList.add("TITLE");
			columnList.add("WRITER");
			columnList.add("UPDT");
			columnList.add("FCNT");
			columnList.add("HIT");
		}

		CommonMakeExcel.makeExcel(sTit, columnList, columnRList, datalist, req, response);
	}
	
	@RequestMapping(value = "listFileDownload.do")
	public void listFileDownload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest,
			HttpServletRequest req, HttpServletResponse response) throws Exception {
		req.setAttribute("logMap", mtenMap);
		String MENU_MNG_NO = mtenMap.get("fileMenuid")==null?"":mtenMap.get("fileMenuid").toString();
		List<Map<String, Object>> fList = pdsService.listFileDownload(mtenMap);
		if ("100000133".equals(MENU_MNG_NO)) {
			zip.listFileDownload(req, response, fList, this.filePath2, "일괄다운로드", this.tempPath);
		}else {
			zip.listFileDownload(req, response, fList, this.filePath, "일괄다운로드", this.tempPath);
		}
	}
}
