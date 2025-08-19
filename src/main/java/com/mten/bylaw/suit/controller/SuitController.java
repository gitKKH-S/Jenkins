package com.mten.bylaw.suit.controller;


import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.buga.client.Bu04BugaWSDTO;
import com.mten.buga.client.Bu04SimpleBugaETCWSDTO;
import com.mten.buga.client.Bu04UserInfoWSDTO;
import com.mten.buga.client.BugaWS;
import com.mten.buga.client.BugaWebService;
import com.mten.buga.client.StatusCodeWSDTO;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.mif.serviceSch.MifService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.bylaw.web.service.WebService;
import com.mten.util.CommonMakeExcel;
import com.mten.util.Json4Ajax;
import com.mten.util.JsonHelper;
import com.mten.util.MakeHan;
import com.mten.util.zipFileDownload;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/web/suit/")
public class SuitController extends DefaultController {
	
	@Resource(name = "suitService")
	private SuitService suitService;
	
	@Resource(name = "webService")
	private WebService webService;
	
	@Resource(name = "mifService")
	private MifService mifService;
	
	@Value("#{fileinfo['mten.SUIT']}")
	public String filePath;
	
	zipFileDownload zip = new zipFileDownload();
	
	@RequestMapping(value = "fileUpload.do")
	public void fileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filePath", this.filePath);
		
		String fileTable = mtenMap.get("fileTable")==null?"":mtenMap.get("fileTable").toString();
		JSONObject result = new JSONObject();
		if ("COURT".equals(fileTable)) {
			result = suitService.courtFileUpload(mtenMap, multipartRequest);
		} else {
			result = suitService.fileUpload(mtenMap, multipartRequest);
		}
		
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "selectOptionList.do")
	public void selectOptionList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.selectOptionList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "selectLwsLwrTypeCdList.do")
	public void selectLwsLwrTypeCdList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.selectLwsLwrTypeCdList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 소송 메인 호출
	@RequestMapping(value = "goSuitMain.do")
	public String goSuitMain(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("param", mtenMap);
		return "suit/suitMain.web";
	}
	
	// List Frame 호출
	@RequestMapping(value = "goSuitList.do")
	public String goSuitList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap param = new HashMap();
		param.put("type", "list");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		List progList = suitService.getProgList(param);
		model.addAttribute("progList", progList);
		
		return "suit/main/suitList.frm";
	}
	
	@RequestMapping(value = "goSuitConsultList.do")
	public String goSuitConsultList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		return "suit/consult/suitConsultList.frm";
	}
	
	// 소송 목록 데이터 조회
	@RequestMapping(value = "selectSuitList.do")
	public void selectSuitList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String urlInfo = "";
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		
		if (userInfo == null) {
			// 세션이 없어 로그인 페이지로 다이렉트 이동
			urlInfo = "/common/nossion.frm";
		} else {
			req.setAttribute("logMap", mtenMap);
			
			mtenMap.put("grpcd", userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString());
			
			String start = mtenMap.get("start") == null ? "" : mtenMap.get("start").toString();
			String limit = mtenMap.get("limit") == null ? "" : mtenMap.get("limit").toString();
			if (!start.equals("") & !limit.equals("")) {
				int a = Integer.parseInt(start);
				int b = Integer.parseInt(limit);
				int result = 1;
				if (b != 0) {
					result = a / b + 1;
				}
				mtenMap.put("pageno", result);
			}
			
			String sort = mtenMap.get("sort") == null ? "" : mtenMap.get("sort").toString();
			String dir = mtenMap.get("dir") == null ? "" : mtenMap.get("dir").toString();
			String orderby = "";
			if (!sort.equals("") && !dir.equals("")) {
				if (sort.equals("ordsort")) {
					orderby = "";
				} else {
					orderby = "order by " + sort + " " + dir;
				}
				
				mtenMap.put("orderby", orderby);
			}
		}
		JSONObject jl = suitService.selectSuitList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "selectConsultSuitList.do")
	public void selectConsultSuitList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String urlInfo = "";
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		
		if (userInfo == null) {
			// 세션이 없어 로그인 페이지로 다이렉트 이동
			urlInfo = "/common/nossion.frm";
		} else {
			req.setAttribute("logMap", mtenMap);
			
			String start = mtenMap.get("start") == null ? "" : mtenMap.get("start").toString();
			String limit = mtenMap.get("limit") == null ? "" : mtenMap.get("limit").toString();
			if (!start.equals("") & !limit.equals("")) {
				int a = Integer.parseInt(start);
				int b = Integer.parseInt(limit);
				int result = 1;
				if (b != 0) {
					result = a / b + 1;
				}
				mtenMap.put("pageno", result);
			}
			
			String sort = mtenMap.get("sort") == null ? "" : mtenMap.get("sort").toString();
			String dir = mtenMap.get("dir") == null ? "" : mtenMap.get("dir").toString();
			String orderby = "";
			if (!sort.equals("") && !dir.equals("")) {
				if (sort.equals("ordsort")) {
					orderby = "";
				} else {
					orderby = "order by " + sort + " " + dir;
				}
				
				mtenMap.put("orderby", orderby);
			}
		}
		JSONObject jl = suitService.selectConsultSuitList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "suitViewPage.do")
	public String suitViewPage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		String GRPCD = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		String adminYn = "N";
		
		if(GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1 
				|| GRPCD.indexOf("B") > -1 || GRPCD.indexOf("D") > -1 || GRPCD.indexOf("G") > -1) {
			adminYn = "Y";
		}
		model.addAttribute("adminYn", adminYn);
		
		System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		System.out.println("GRPCD : " + GRPCD);
		System.out.println("adminYn : " + adminYn);
		System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		
		String SEL_INST_MNG_NO = mtenMap.get("SEL_INST_MNG_NO")==null?"":mtenMap.get("SEL_INST_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		String WRTR_EMP_NO = mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString();
		
		HashMap suitMap = suitService.getSuitDetail(mtenMap);
		suitMap.put("adminYn", adminYn);
		model.addAttribute("suitMap", suitMap);
		
		if (INST_MNG_NO.equals("")) {
			INST_MNG_NO = suitService.getInstMngNo(mtenMap);
			mtenMap.put("INST_MNG_NO", INST_MNG_NO);
		}
		
		if (!SEL_INST_MNG_NO.equals("")) {
			mtenMap.put("INST_MNG_NO", SEL_INST_MNG_NO);
		}
		
		HashMap taskMap = new HashMap();
		taskMap = new HashMap();
		taskMap.put("EMP_NO", WRTR_EMP_NO);
		taskMap.put("TASK_SE", "S2");
		taskMap.put("DOC_MNG_NO", INST_MNG_NO);
		taskMap.put("PRCS_YN", "Y");
		mifService.setTask(taskMap);
		
		
		HashMap caseMap = suitService.getCaseDetail(mtenMap);
		model.addAttribute("caseMap", caseMap);
		
		List empList = suitService.getEmpInfo(mtenMap);
		model.addAttribute("empList", empList);
		
		HashMap fMap = new HashMap();
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		if (!LWS_MNG_NO.equals("")) {
			fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_MNG");
			fMap.put("FILE_SE", "CONF");
			List suitConfFile = suitService.getFileList(fMap);
			model.addAttribute("suitConfFile", suitConfFile);
		}
		
		String FINST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		if (!FINST_MNG_NO.equals("")) {
			fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_INST");
			List caseFile = suitService.getFileList(fMap);
			model.addAttribute("caseFile", caseFile);
		}
		
		HashMap relMap = new HashMap();
		relMap.put("PK", LWS_MNG_NO);
		HashMap relList = suitService.selectRelCase(relMap);
		
		model.addAttribute("relList", relList.get("list"));
		
		model.addAttribute("SEL_INST_MNG_NO", SEL_INST_MNG_NO);
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("focus", mtenMap.get("focus"));
		return "/suit/main/suitView.frm";
	}
	
	@RequestMapping(value = "caseViewPop.do")
	public String caseViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		
		int roleChk = 0;
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		
		if (Grpcd.indexOf("Y") > -1 || Grpcd.indexOf("C") > -1 || Grpcd.indexOf("L") > -1 || Grpcd.indexOf("G") > -1
				|| Grpcd.indexOf("D") > -1 || Grpcd.indexOf("E") > -1) {
			// 전체관리자 or 소송관리자
			roleChk = 1;
		} else {
			// 그 외 일반사용자
			roleChk = suitService.selectSuitRoleChk(mtenMap);
		}
		// 권한 체크
		
		if (userInfo == null || roleChk == 0) {
			urlInfo = "/common/noRole.err";
		} else if (roleChk > 0) {
			req.setAttribute("logMap", mtenMap);
			
			String SEL_INST_MNG_NO = mtenMap.get("SEL_INST_MNG_NO")==null?"":mtenMap.get("SEL_INST_MNG_NO").toString();
			String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
			String WRTR_EMP_NO = mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString();
			
			HashMap suitMap = suitService.getSuitDetail(mtenMap);
			model.addAttribute("suitMap", suitMap);
			
			
			if (INST_MNG_NO.equals("")) {
				INST_MNG_NO = suitService.getInstMngNo(mtenMap);
				mtenMap.put("INST_MNG_NO", INST_MNG_NO);
			}
			
			if (!SEL_INST_MNG_NO.equals("")) {
				mtenMap.put("INST_MNG_NO", SEL_INST_MNG_NO);
			}
			
			HashMap taskMap = new HashMap();
			taskMap = new HashMap();
			taskMap.put("EMP_NO", WRTR_EMP_NO);
			taskMap.put("TASK_SE", "S2");
			taskMap.put("DOC_MNG_NO", INST_MNG_NO);
			taskMap.put("PRCS_YN", "Y");
			mifService.setTask(taskMap);
			
			HashMap caseMap = suitService.getCaseDetail(mtenMap);
			model.addAttribute("caseMap", caseMap);
			
			List empList = suitService.getEmpInfo(mtenMap);
			model.addAttribute("empList", empList);
			
			HashMap resultMap = suitService.getCaseResultDetail(mtenMap);
			model.addAttribute("resultMap", resultMap);
			
			HashMap fMap = new HashMap();
			String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
			if (!LWS_MNG_NO.equals("")) {
				fMap = new HashMap();
				fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
				fMap.put("TRGT_PST_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
				fMap.put("TRGT_PST_TBL_NM", "TB_LWS_MNG");
				fMap.put("FILE_SE", "CONF");
				List suitConfFile = suitService.getFileList(fMap);
				model.addAttribute("suitConfFile", suitConfFile);
			}
			
			String FINST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
			if (!FINST_MNG_NO.equals("")) {
				fMap = new HashMap();
				fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
				fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
				fMap.put("TRGT_PST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
				fMap.put("TRGT_PST_TBL_NM", "TB_LWS_INST");
				fMap.put("FILE_SE", "INST");
				List caseFile = suitService.getFileList(fMap);
				model.addAttribute("caseFile", caseFile);
				
				fMap = new HashMap();
				fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
				fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
				fMap.put("TRGT_PST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
				fMap.put("TRGT_PST_TBL_NM", "TB_LWS_INST");
				fMap.put("FILE_SE", "RES");
				List caseResultFile = suitService.getFileList(fMap);
				model.addAttribute("caseResultFile", caseResultFile);
			}
			
			model.addAttribute("SEL_INST_MNG_NO", SEL_INST_MNG_NO);
			model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
			model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
			model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
			model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
			model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
			model.addAttribute("focus", mtenMap.get("focus"));
			urlInfo = "/suit/main/caseViewPop.pop";
		}
		return urlInfo;
	}
	
	@RequestMapping(value = "suitConsultViewPage.do")
	public String suitConsultViewPage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		HashMap suitMap = suitService.getSuitConsultDetail(mtenMap);
		model.addAttribute("suitMap", suitMap);
		
		String LWS_MNG_NO = mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString();
		if (!LWS_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_RQST");
			fMap.put("FILE_SE", "CONT");
			List suitContFile = suitService.getFileList(fMap);
			model.addAttribute("suitContFile", suitContFile);
		}
		
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/suit/consult/suitConsultView.frm";
	}
	
	@RequestMapping(value = "suitConsultViewPagePop.do")
	public String suitConsultViewPagePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		HashMap suitMap = suitService.getSuitConsultDetail(mtenMap);
		model.addAttribute("suitMap", suitMap);
		
		String LWS_MNG_NO = mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString();
		if (!LWS_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_RQST");
			fMap.put("FILE_SE", "CONT");
			List suitContFile = suitService.getFileList(fMap);
			model.addAttribute("suitContFile", suitContFile);
		}
		
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/suit/consult/suitConsultViewPop.pop";
	}
	
	@RequestMapping(value = "suitWritePage.do")
	public String suitWritePage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		
		if (!LWS_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", LWS_MNG_NO);
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_MNG");
			fMap.put("FILE_SE", "CONF");
			List suitConfFile = suitService.getFileList(fMap);
			model.addAttribute("suitConfFile", suitConfFile);
		}
		// 코드정보
		HashMap param = new HashMap();
		param.put("type", "suit");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		// 소송 기본정보
		HashMap suitMap = new HashMap();
		if (!LWS_MNG_NO.equals("")) {
			suitMap = suitService.getSuitDetail(mtenMap);
		}
		model.addAttribute("suitMap", suitMap);
		
		List merList = suitService.selectMerCaseInfo(mtenMap);
		model.addAttribute("merList", merList);
		return "/suit/main/suitWrite.frm";
	}
	
	@RequestMapping(value = "suitConsultWritePage.do")
	public String suitConsultWritePage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		String LWS_RQST_MNG_NO = mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString();
		model.addAttribute("LWS_RQST_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO"));
		
		// 코드정보
		HashMap param = new HashMap();
		param.put("type", "suit");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		// 소송 기본정보
		HashMap suitMap = new HashMap();
		if (!LWS_RQST_MNG_NO.equals("")) {
			suitMap = suitService.getSuitConsultDetail(mtenMap);
		}
		model.addAttribute("suitMap", suitMap);
		
		if (!LWS_RQST_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_RQST");
			fMap.put("FILE_SE", "CONT");
			List suitContFile = suitService.getFileList(fMap);
			model.addAttribute("suitContFile", suitContFile);
		}
		return "/suit/consult/suitConsultWrite.frm";
	}
	
	@RequestMapping(value = "insertSuitInfo.do")
	public void insertSuitInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		JSONObject result = suitService.insertSuitInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "insertSuitConsultInfo.do")
	public void insertSuitConsultInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		JSONObject result = suitService.insertSuitConsultInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "caseWritePop.do")
	public String caseWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo");
		
		String MENU_MNG_NO = mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO").toString();
		// 등록/수정 구분
		String gbn = mtenMap.get("gbn").toString();
		HashMap caseMap = suitService.getCaseDetail(mtenMap);
		model.addAttribute("caseMap", caseMap);
		
		HashMap param = new HashMap();
		param.put("type", "case");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		HashMap params = new HashMap();
		params.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
		params.put("gbn", "case");
		HashMap suitMap = suitService.getSuitDetail(params);
		model.addAttribute("suitMap", suitMap);
		
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		List empList = new ArrayList();
		
		if ("insert".equals(gbn)) {
			empList = suitService.getLastEmpInfo(mtenMap);
		} else {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_INST");
			fMap.put("FILE_SE", "INST");
			List caseFile = suitService.getFileList(fMap);
			model.addAttribute("caseFile", caseFile);
			
			empList = suitService.getEmpInfo(mtenMap);
		}
		
		model.addAttribute("empList", empList);
		
		
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		model.addAttribute("menugbn", mtenMap.get("menugbn"));
		return "/suit/main/caseWritePop.pop";
	}
	
	@RequestMapping(value = "searchCourtPop.do")
	public String searchCourtPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		mtenMap.put("type", "court");
		List list = suitService.getCodeList(mtenMap);
		model.put("courtList", list);
		model.put("schTxt", mtenMap.get("schTxt")==null?"":mtenMap.get("schTxt").toString());
		
		return "/suit/popup/searchCourtPop.pop";
	}
	
	@RequestMapping(value = "searchBankPop.do")
	public String searchBankPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		mtenMap.put("type", "bank");
		List list = suitService.getCodeList(mtenMap);
		model.put("bankList", list);
		model.put("schTxt", mtenMap.get("schTxt")==null?"":mtenMap.get("schTxt").toString());
		model.put("idx",    mtenMap.get("idx")==null?"":mtenMap.get("idx").toString());
		
		return "/suit/popup/searchBankPop.pop";
	}
	
	@RequestMapping(value = "insertCaseInfo.do")
	public void insertCaseInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		JSONObject result = suitService.insertCaseInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "caseResultWritePop.do")
	public String caseResultWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo");
		String grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		
		String MENU_MNG_NO = mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO").toString();
		String gbn = mtenMap.get("gbn").toString();
		HashMap resultMap = suitService.getCaseResultDetail(mtenMap);
		model.addAttribute("resultMap", resultMap);
		
		HashMap param = new HashMap();
		param.put("type", "result");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		if (!INST_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_INST");
			fMap.put("FILE_SE", "RES");
			List caseResultFile = suitService.getFileList(fMap);
			model.addAttribute("caseResultFile", caseResultFile);
		}
		
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("gbn", gbn);
		
		return "/suit/main/caseResultWritePop.pop";
	}
	
	@RequestMapping(value = "insertCaseResultInfo.do")
	public void insertCaseResultInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		mtenMap.put("filePath", this.filePath);
		JSONObject result = suitService.insertCaseResultInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "deleteSuitInfo.do")
	public void deleteSuitInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filePath", this.filePath);
		JSONObject result = suitService.deleteSuitInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "deleteSuitConsultInfo.do")
	public void deleteSuitConsultInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filePath", this.filePath);
		JSONObject result = suitService.deleteSuitConsultInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "updateSuitConsultProg.do")
	public void updateSuitConsultProg(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filePath", this.filePath);
		JSONObject result = suitService.updateSuitConsultProg(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "searchEmpPop.do")
	public String searchEmpPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/suit/popup/searchEmpPop.pop";
	}
	
	@RequestMapping(value = "selectEmpUserList.do")
	public void selectEmpList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = suitService.selectEmpUserList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "selectEmpList.do")
	public void selectGetEmpList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = suitService.selectEmpList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 소송 담당자 등록
	@RequestMapping(value = "chgEmpInfoSave.do")
	public void chgEmpInfoSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		JSONObject result = suitService.chgEmpInfoSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "selectCaseList.do")
	public void selectCaseList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = suitService.selectCaseList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "selectDateList.do")
	public void selectDateList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("LWS_MNG_NO", LWS_MNG_NO);
		param.put("INST_MNG_NO", INST_MNG_NO);
		
		JSONObject jl = this.suitService.selectDateList(param);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "caseDateViewPop.do")
	public String caseDateViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("DATE_MNG_NO", mtenMap.get("DATE_MNG_NO"));
		model.addAttribute("LWS_MNG_NO",  mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap map = this.suitService.getDateDetail(mtenMap);
		model.addAttribute("dateinfo", map);
		
		String DATE_MNG_NO = mtenMap.get("DATE_MNG_NO")==null?"":mtenMap.get("DATE_MNG_NO").toString();
		if (!DATE_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("DATE_MNG_NO"));
			List fileList = this.suitService.getDateDocFileList(mtenMap);
			model.addAttribute("fileList", fileList);
		}
		return "/suit/popup/caseDateViewPop.pop";
	}
	
	// 소송 기일 등록 팝업 호출
	@RequestMapping(value = "caseDateWritePop.do")
	public String caseDateWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo");
		String grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		
		model.addAttribute("DATE_MNG_NO", mtenMap.get("DATE_MNG_NO"));
		model.addAttribute("LWS_MNG_NO",  mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap map = this.suitService.getDateDetail(mtenMap);
		model.addAttribute("dateinfo", map);
		
		HashMap param = new HashMap();
		param.put("type", "date");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		return "/suit/popup/caseDateWritePop.pop";
	}
	
	// 소송 기일정보 등록
	@RequestMapping(value = "insertDateInfo.do")
	public void insertDateInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		System.out.println(mtenMap);
		JSONObject result = this.suitService.insertDateInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 소송 기일정보 삭제
	@RequestMapping(value = "deleteCaseDate.do")
	public void delCaseDate(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.deleteCaseDate(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 제출송달서면 목록 조회
	@RequestMapping(value = "selectDocList.do")
	public void selectDocList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("LWS_MNG_NO", LWS_MNG_NO);
		param.put("INST_MNG_NO", INST_MNG_NO);
		
		JSONObject jl = this.suitService.selectDocList(param);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 제출송달서면 등록 팝업화면 호출
	@RequestMapping(value = "caseDocWritePop.do")
	public String caseDocWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		String Grpcd = userInfo.get("GRPCD") == null ? "" : userInfo.get("GRPCD").toString();
		
		model.addAttribute("DOC_MNG_NO", mtenMap.get("DOC_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap docMap = this.suitService.getDocDetail(mtenMap);
		model.addAttribute("docMap", docMap);
		
		List dateList = this.suitService.selectRelDateList(mtenMap);
		model.addAttribute("dateList", dateList);
		
		HashMap param = new HashMap();
		param.put("type", "doc");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		String DOC_MNG_NO = mtenMap.get("DOC_MNG_NO")==null?"":mtenMap.get("DOC_MNG_NO").toString();
		if (!DOC_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("DOC_MNG_NO")==null?"":mtenMap.get("DOC_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_SBMSN_TMTL");
			fMap.put("FILE_SE", "DOC");
			List docFile = suitService.getFileList(fMap);
			model.addAttribute("docFile", docFile);
		}
		return "/suit/popup/caseDocWritePop.pop";
	}
	
	// 제출송달서면 등록
	@RequestMapping(value = "insertDocInfo.do")
	public void insertDocInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertDocInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 제출송달서면 조회 팝업화면 호출
	@RequestMapping(value = "caseDocViewPop.do")
	public String caseDocViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("DOC_MNG_NO", mtenMap.get("DOC_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap docMap = this.suitService.getDocDetail(mtenMap);
		model.addAttribute("docMap", docMap);
		
		HashMap docParam = docMap.get("docInfo")==null?new HashMap():(HashMap)docMap.get("docInfo");
		String DOCDT = docParam.get("DOCDT")==null?"":docParam.get("DOCDT").toString();
		if (!DOCDT.equals("")) {
			mtenMap.put("docdt", DOCDT);
			mtenMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		}
		
		String DOC_MNG_NO = mtenMap.get("DOC_MNG_NO")==null?"":mtenMap.get("DOC_MNG_NO").toString();
		if (!DOC_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("DOC_MNG_NO")==null?"":mtenMap.get("DOC_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_SBMSN_TMTL");
			fMap.put("FILE_SE", "DOC");
			List docFile = suitService.getFileList(fMap);
			model.addAttribute("docFile", docFile);
		}
		return "/suit/popup/caseDocViewPop.pop";
	}
	
	// 제출송달서면 삭제
	@RequestMapping(value = "deleteDocInfo.do")
	public void deleteDocInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.deleteDocInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}

	@RequestMapping(value = "selectRelEmpList.do")
	public void selectRelEmpList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("LWS_MNG_NO", LWS_MNG_NO);
		param.put("INST_MNG_NO", INST_MNG_NO);
		
		JSONObject jl = this.suitService.selectRelEmpList(param);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "relEmpInfoPop.do")
	public String relEmpInfoPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String LWS_FLFMT_MNG_NO = mtenMap.get("LWS_FLFMT_MNG_NO")==null?"":mtenMap.get("LWS_FLFMT_MNG_NO").toString();
		model.addAttribute("LWS_FLFMT_MNG_NO", LWS_FLFMT_MNG_NO);
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap map = this.suitService.getRelEmpDetail(mtenMap);
		HashMap empMap = map.get("empMap")==null?new HashMap():(HashMap)map.get("empMap");
		model.addAttribute("empMap", empMap);
		return "/suit/popup/relEmpInfoPop.pop";
	}
	
	@RequestMapping(value = "relEmpHisPop.do")
	public String relEmpHisPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		return "/suit/popup/relEmpHisPop.pop";
	}
	
	@RequestMapping(value = "relEmpWritePop.do")
	public String relEmpWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String LWS_FLFMT_MNG_NO = mtenMap.get("LWS_FLFMT_MNG_NO")==null?"":mtenMap.get("LWS_FLFMT_MNG_NO").toString();
		model.addAttribute("LWS_FLFMT_MNG_NO", LWS_FLFMT_MNG_NO);
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap map = this.suitService.getRelEmpDetail(mtenMap);
		HashMap empMap = map.get("empMap")==null?new HashMap():(HashMap)map.get("empMap");
		model.addAttribute("empMap", empMap);
		return "/suit/popup/relEmpWritePop.pop";
	}

	@RequestMapping(value = "insertRelEmpInfo.do")
	public void insertRelEmpInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertRelEmpInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "deleteRelEmpInfo.do")
	public void deleteRelEmpInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.deleteRelEmpInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "searchDeptPop.do")
	public String searchDeptPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String menu = mtenMap.get("menu") == null ? "" : mtenMap.get("menu").toString();
		String cnt = mtenMap.get("cnt") == null ? "0" : mtenMap.get("cnt").toString();
		String deptno = mtenMap.get("deptno") == null ? "6110000" : mtenMap.get("deptno").toString();
		String gbn = mtenMap.get("gbn") == null ? "" : mtenMap.get("gbn").toString();
		String reviewid = mtenMap.get("reviewid") == null ? "0" : mtenMap.get("reviewid").toString();
		model.addAttribute("menu", menu);
		model.addAttribute("CNT", cnt);
		model.addAttribute("deptno", deptno);
		model.addAttribute("gbn", gbn);
		model.addAttribute("reviewid", reviewid);
		return "/suit/popup/searchDeptPop.pop";
	}
	
	@RequestMapping(value="getDeptList.do")
	public void getDeptList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONArray jl = this.suitService.getDeptList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "selectDeptList.do")
	public void selectDeptList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.selectDeptList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "selectUserList.do")
	public void selectUserList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.selectUserList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "goLawfirmList.do")
	public String goLawfirmList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		return "/suit/lawfirm/lawfirmList.frm";
	}
	
	@RequestMapping(value = "lawfirmWritePage.do")
	public String lawfirmWritePage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("JDAF_CORP_MNG_NO", mtenMap.get("JDAF_CORP_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap lawfirmMap = this.suitService.getLawfirmDetail(mtenMap);
		model.addAttribute("lawfirmMap", lawfirmMap);
		
		List bankList = suitService.getBankList(mtenMap);
		model.addAttribute("bankList", bankList);
		
		return "/suit/lawfirm/lawfirmWrite.frm";
	}
	
	@RequestMapping(value = "lawfirmViewPage.do")
	public String lawfirmViewPage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String JDAF_CORP_MNG_NO = (String) mtenMap.get("JDAF_CORP_MNG_NO");
		model.addAttribute("JDAF_CORP_MNG_NO", JDAF_CORP_MNG_NO);
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap lawfirmMap = this.suitService.getLawfirmDetail(mtenMap);
		model.addAttribute("lawfirmMap", lawfirmMap);
		
		return "/suit/lawfirm/lawfirmView.frm";
	}
	
	@RequestMapping(value = "selectfLawFirmList.do")
	public void selectfLawFirmList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String start = mtenMap.get("start") == null ? "" : mtenMap.get("start").toString();
		String limit = mtenMap.get("limit") == null ? "" : mtenMap.get("limit").toString();
		
		if (!start.equals("") & !limit.equals("")) {
			int a = Integer.parseInt(start);
			int b = Integer.parseInt(limit);
			int result = 1;
			if (b != 0) {
				result = a / b + 1;
			}
			mtenMap.put("pageno", result);
		}
		
		String sort = mtenMap.get("sort") == null ? "" : mtenMap.get("sort").toString();
		String dir = mtenMap.get("dir") == null ? "" : mtenMap.get("dir").toString();
		String orderby = "";
		if (!sort.equals("") && !dir.equals("")) {
			if (sort.equals("ordsort")) {
				orderby = "";
			} else {
				orderby = "order by " + sort + " " + dir;
			}
			
			mtenMap.put("orderby", orderby);
		}
		
		JSONObject jl = this.suitService.selectfLawFirmList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "insertLawfirmInfo.do")
	public void insertLawfirmInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertLawfirmInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "deleteLawfirmInfo.do")
	public void deleteLawfirmInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.deleteLawfirmInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "golawyerList.do")
	public String golawyerList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap param = new HashMap();
		param.put("type", "lawyer");
		List cdList = suitService.getCodeList(param);
		model.addAttribute("cdList", cdList);
		
		return "/suit/lawfirm/lawyerList.frm";
	}
	
	@RequestMapping(value = "lawyerWritePage.do")
	public String lawyerWritePage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("LWYR_MNG_NO", mtenMap.get("LWYR_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		String LWYR_MNG_NO = mtenMap.get("LWYR_MNG_NO")==null?"":mtenMap.get("LWYR_MNG_NO").toString();
		
		HashMap param = new HashMap();
		param.put("type", "bank");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		param = new HashMap();
		param.put("type", "lawyer");
		List cdList = suitService.getCodeList(param);
		model.addAttribute("cdList", cdList);
		
		if (!LWYR_MNG_NO.equals("")) {
			List bankList = suitService.getBankList(mtenMap);
			model.addAttribute("bankList", bankList);
			
			List agtList = suitService.getAgtList(mtenMap);
			model.addAttribute("agtList", agtList);
			
			HashMap lawyerMap = this.suitService.getLawyerDetail(mtenMap);
			model.addAttribute("lawyerMap", lawyerMap);
			
			mtenMap.put("LWYR_MNG_NO", LWYR_MNG_NO);
			List tnrList = suitService.getTnrList(mtenMap);
			model.addAttribute("tnrList", tnrList);
		}
		
		return "/suit/lawfirm/lawyerWrite.frm";
	}
	
	@RequestMapping(value = "lawyerViewPage.do")
	public String lawyerViewPage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("LWYR_MNG_NO", mtenMap.get("LWYR_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		String LWYR_MNG_NO = mtenMap.get("LWYR_MNG_NO")==null?"":mtenMap.get("LWYR_MNG_NO").toString();
		
		List bankList = suitService.getBankList(mtenMap);
		model.addAttribute("bankList", bankList);
		
		if (!LWYR_MNG_NO.equals("")) {
			HashMap lawyerMap = this.suitService.getLawyerDetail(mtenMap);
			model.addAttribute("lawyerMap", lawyerMap);
			
			List agtList = suitService.getAgtList(mtenMap);
			model.addAttribute("agtList", agtList);
			
			mtenMap.put("LWYR_MNG_NO", LWYR_MNG_NO);
			List tnrList = suitService.getTnrList(mtenMap);
			model.addAttribute("tnrList", tnrList);
		}
		return "/suit/lawfirm/lawyerView.frm";
	}
	
	@RequestMapping(value = "lawyerViewPagePop.do")
	public String lawyerViewPagePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("LWYR_MNG_NO", mtenMap.get("LWYR_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		String LWYR_MNG_NO = mtenMap.get("LWYR_MNG_NO")==null?"":mtenMap.get("LWYR_MNG_NO").toString();
		
		List bankList = suitService.getBankList(mtenMap);
		model.addAttribute("bankList", bankList);
		
		HashMap lawyerMap = this.suitService.getLawyerDetail(mtenMap);
		model.addAttribute("lawyerMap", lawyerMap);
		
		List agtList = suitService.getAgtList(mtenMap);
		model.addAttribute("agtList", agtList);
		
		mtenMap.put("LWYR_MNG_NO", LWYR_MNG_NO);
		List tnrList = suitService.getTnrList(mtenMap);
		model.addAttribute("tnrList", tnrList);
		
		return "/suit/lawfirm/lawyerViewPop.frm";
	}
	
	@RequestMapping(value = "selectLawyerList.do")
	public void selectLawyerList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String start = mtenMap.get("start") == null ? "" : mtenMap.get("start").toString();
		String limit = mtenMap.get("limit") == null ? "" : mtenMap.get("limit").toString();
		
		if (!start.equals("") & !limit.equals("")) {
			int a = Integer.parseInt(start);
			int b = Integer.parseInt(limit);
			int result = 1;
			if (b != 0) {
				result = a / b + 1;
			}
			mtenMap.put("pageno", result);
		}
		
		String sort = mtenMap.get("sort") == null ? "" : mtenMap.get("sort").toString();
		String dir = mtenMap.get("dir") == null ? "" : mtenMap.get("dir").toString();
		String orderby = "";
		if (!sort.equals("") && !dir.equals("")) {
			if (sort.equals("ordsort")) {
				orderby = "";
			} else {
				orderby = "order by " + sort + " " + dir;
			}
			
			mtenMap.put("orderby", orderby);
		}
		
		JSONObject jl = this.suitService.selectLawyerList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "lawyerListExcel.do")
	public void lawyerListExcel(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
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
		mtenMap.put("filePath", this.filePath);
		JSONObject result = suitService.selectLawyerListExcel(mtenMap);
		List datalist = JsonHelper.toList((JSONArray)result.get("result"));
		
		String sTit = "자문";
		
		ArrayList<String> columnList = new ArrayList<String>(); // 데이터컬럼명
		ArrayList<String> columnRList = new ArrayList<String>(); // 화면용컬럼명
		
		columnRList.add("성명\n(출생연도)");
		columnRList.add("성명\n(출생연도)");
		columnRList.add("학력");
		columnRList.add("사시합격\n연도(회수)");
		columnRList.add("주요경력");
		columnRList.add("전문분야");
		columnRList.add("위촉일\n(최초위촉일)");
		
		columnList.add("PHOTO_MNG_PATH_NM");	// +filePath
		columnList.add("LWYR_NM");
		columnList.add("ACBG_CN");
		columnList.add("TEST_INFO");
		columnList.add("CRR_MTTR");
		columnList.add("ARSP_NM");
		columnList.add("EXCELYMD");
		
		suitService.makeLawyerExcel(sTit, columnList, columnRList, datalist, req, response, this.filePath);
	}
	
	@RequestMapping(value = "duchk.do")
	public void duchk(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		JSONObject result = this.suitService.duchk(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "changePassWord.do")
	public void changePassWord(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.changePassWord(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "setViewYn.do")
	public void setViewYn(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.setViewYn(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "insertLawyerInfo.do")
	public void insertLawyerInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertLawyerInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "insertLawyerInfoOut.do")
	public void insertLawyerInfoOut(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertLawyerInfoOut(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "deleteLawyerInfo.do")
	public void deleteLawyerInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.deleteLawyerInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "searchLawfirmPop.do")
	public String searchLawfirmPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		return "/suit/popup/searchLawfirmPop.pop";
	}

	@RequestMapping(value = "searchLawyerPop.do")
	public String searchLawyerPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		return "/suit/popup/searchLawyerPop.pop";
	}
	
	@RequestMapping(value = "selectLawyerPopList.do")
	public void selectLawyerPopList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.selectLawyerPopList(mtenMap);
		model.addAttribute("schText", mtenMap.get("schText"));
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "selectLawfirmPopList.do")
	public void selectLawfirmPopList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.selectLawfirmPopList(mtenMap);
		model.addAttribute("schText", mtenMap.get("schText"));
		Json4Ajax.commonAjax(jl, response);
	}
	
	
	@RequestMapping(value = "caseCostWritePop.do")
	public String caseCostWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("CST_MNG_NO", mtenMap.get("CST_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		List targetList = suitService.getCostTarget(mtenMap);
		model.addAttribute("targetList", targetList);
		
		HashMap costMap = suitService.getCostDetail(mtenMap);
		model.addAttribute("costMap", costMap);
		
		HashMap param = new HashMap();
		param.put("type", "cost");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		String CST_MNG_NO = mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString();
		if (!CST_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_CST");
			fMap.put("FILE_SE", "COST");
			List costFile = suitService.getFileList(fMap);
			model.addAttribute("costFile", costFile);
		}
		return "/suit/popup/caseCostWritePop.pop";
	}
	
	@RequestMapping(value = "caseCostViewPop.do")
	public String caseCostViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("CST_MNG_NO", mtenMap.get("CST_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		List targetList = suitService.getCostTarget(mtenMap);
		model.addAttribute("targetList", targetList);
		
		HashMap costMap = suitService.getCostDetail(mtenMap);
		model.addAttribute("costMap", costMap);
		
		String CST_MNG_NO = mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString();
		if (!CST_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_CST");
			fMap.put("FILE_SE", "COST");
			List costFile = suitService.getFileList(fMap);
			model.addAttribute("costFile", costFile);
		}
		return "/suit/popup/caseCostViewPop.pop";
	}
	
	@RequestMapping(value = "selectCostList.do")
	public void selectCostList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("LWS_MNG_NO", LWS_MNG_NO);
		param.put("INST_MNG_NO", INST_MNG_NO);
		param.put("gbn", mtenMap.get("gbn")==null?"N":mtenMap.get("gbn").toString());
		
		JSONObject jl = this.suitService.selectCostList(param);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "insertCostInfo.do")
	public void insertCostInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		JSONObject result = this.suitService.insertCostInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "deleteCostInfo.do")
	public void deleteCostInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.deleteCostInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "calPop.do")
	public String calPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("gbn", mtenMap.get("gbn"));
		return "/suit/popup/calPop.pop";
	}
	
	@RequestMapping(value = "costCalEditPop.do")
	public String costCalEditPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/suit/popup/costCalEditPop.pop";
	}
	
	@RequestMapping(value = "selectCalList.do")
	public void selectCalList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.selectCalList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "insertCalInfo.do")
	public void insertCalInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.insertCalInfo(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "deleteCalInfo.do")
	public void deleteCalInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.deleteCalInfo(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "chrgLawyerCostPop.do")
	public String chrgLawyerCostPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("AGT_MNG_NO", mtenMap.get("AGT_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap chrgMap = suitService.getChrgLawyerDetail(mtenMap);
		model.addAttribute("chrgMap", chrgMap);
		
		String AGT_MNG_NO = mtenMap.get("AGT_MNG_NO")==null?"":mtenMap.get("AGT_MNG_NO").toString();
		if (!AGT_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("AGT_MNG_NO")==null?"":mtenMap.get("AGT_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_AGT");
			fMap.put("FILE_SE", "COST");
			List chrgFile = suitService.getFileList(fMap);
			model.addAttribute("chrgFile", chrgFile);
		}
		
		return "/suit/popup/chrgLawyerCostPop.pop";
	}
	
	@RequestMapping(value = "chrgLawyerWritePop.do")
	public String chrgLawyerWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("AGT_MNG_NO", mtenMap.get("AGT_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap chrgMap = suitService.getChrgLawyerDetail(mtenMap);
		model.addAttribute("chrgMap", chrgMap);
		
		String AGT_MNG_NO = mtenMap.get("AGT_MNG_NO")==null?"":mtenMap.get("AGT_MNG_NO").toString();
		if (!AGT_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("AGT_MNG_NO")==null?"":mtenMap.get("AGT_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_AGT");
			fMap.put("FILE_SE", "CHRG");
			List chrgFile = suitService.getFileList(fMap);
			model.addAttribute("chrgFile", chrgFile);
		}
		
		return "/suit/popup/chrgLawyerInfoWritePop.pop";
	}

	@RequestMapping(value = "chrgLawyerInfoPop.do")
	public String chrgLawyerInfoPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("AGT_MNG_NO", mtenMap.get("AGT_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap chrgMap = suitService.getChrgLawyerDetail(mtenMap);
		model.addAttribute("chrgMap", chrgMap);
		
		String AGT_MNG_NO = mtenMap.get("AGT_MNG_NO")==null?"":mtenMap.get("AGT_MNG_NO").toString();
		if (!AGT_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("AGT_MNG_NO")==null?"":mtenMap.get("AGT_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_AGT");
			//fMap.put("FILE_SE", "CHRG");
			fMap.put("ordgbn", "CHRG,COST");
			List chrgFile = suitService.getFileList(fMap);
			model.addAttribute("chrgFile", chrgFile);
		}
		
		return "/suit/popup/chrgLawyerInfoPop.pop";
	}
	
	@RequestMapping(value = "selectChrgLawyerList.do")
	public void selectChrgLawyerList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.selectChrgLawyerList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "insertChrgLawyer.do")
	public void insertChrgLawyer(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertChrgLawyer(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "deleteChrgLawyer.do")
	public void deleteChrgLawyer(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.deleteChrgLawyer(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "insertChrgCost.do")
	public void insertChrgCost(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertChrgCost(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "updateChrgLawyerAmt.do")
	public void updateChrgAmtAprv(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.updateChrgLawyerAmt(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "updateChrgLawyerAmtList.do")
	public void updateChrgLawyerAmtList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.updateChrgLawyerAmtList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	
	@RequestMapping(value = "bondViewPage.do")
	public String bondViewPage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("BND_MNG_NO", mtenMap.get("BND_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap bondMap = suitService.getBondDetail(mtenMap);
		model.addAttribute("bondMap", bondMap);
		
		List recList = suitService.selectRecInfoList(mtenMap);
		model.addAttribute("recList", recList);
		
		String BND_MNG_NO = mtenMap.get("BND_MNG_NO")==null?"":mtenMap.get("BND_MNG_NO").toString();
		if (!BND_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("BND_MNG_NO")==null?"":mtenMap.get("BND_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_BND");
			fMap.put("FILE_SE", "BOND");
			List bondFile = suitService.getFileList(fMap);
			model.addAttribute("bondFile", bondFile);
		}
		
		return "/suit/popup/bondView.pop";
	}
	
	@RequestMapping(value = "bondWritePage.do")
	public String bondWritePage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("BND_MNG_NO", mtenMap.get("BND_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap bondMap = suitService.getBondDetail(mtenMap);
		model.addAttribute("bondMap", bondMap);
		
		String BND_MNG_NO = mtenMap.get("BND_MNG_NO")==null?"":mtenMap.get("BND_MNG_NO").toString();
		if (!BND_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("BND_MNG_NO")==null?"":mtenMap.get("BND_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_BND");
			fMap.put("FILE_SE", "BOND");
			List bondFile = suitService.getFileList(fMap);
			model.addAttribute("bondFile", bondFile);
		}
		
		return "/suit/popup/bondWrite.pop";
	}
	
	@RequestMapping(value = "bondRecEditPop.do")
	public String bondRecEditPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("BND_RTRVL_MNG_NO", mtenMap.get("BND_RTRVL_MNG_NO"));
		model.addAttribute("BND_MNG_NO", mtenMap.get("BND_MNG_NO"));
		model.addAttribute("BONDBAL", mtenMap.get("BONDBAL"));
		model.addAttribute("BND_AMT", mtenMap.get("BND_AMT"));
		model.addAttribute("BND_DBT_SE", mtenMap.get("BND_DBT_SE"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap recMap = this.suitService.getBondRecDetail(mtenMap);
		model.put("recMap", recMap);
		
		return "/suit/popup/bondRecEditPop.pop";
	}
	
	@RequestMapping(value = "insertBondInfo.do")
	public void insertBondInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertBondInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}

	@RequestMapping(value = "insertRecInfo.do")
	public void insertRecInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertRecInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "selectBondList.do")
	public void selectBondList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.selectBondList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "deleteRecInfo.do")
	public void deleteRecInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.deleteRecInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}

	@RequestMapping(value = "deleteBondInfo.do")
	public void deleteBondInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.deleteBondInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "reportWritePop.do")
	public String reportWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("RPTP_MNG_NO", mtenMap.get("RPTP_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap reportMap = suitService.getReportDetail(mtenMap);
		model.addAttribute("reportMap", reportMap);
		
		String RPTP_MNG_NO = mtenMap.get("RPTP_MNG_NO")==null?"":mtenMap.get("RPTP_MNG_NO").toString();
		if (!RPTP_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("RPTP_MNG_NO")==null?"":mtenMap.get("RPTP_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_RPTP");
			fMap.put("FILE_SE", "REP");
			List reportFile = suitService.getFileList(fMap);
			model.addAttribute("reportFile", reportFile);
		}
		
		return "/suit/popup/reportWritePop.pop";
	}

	@RequestMapping(value = "reportViewPop.do")
	public String reportViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("RPTP_MNG_NO", mtenMap.get("RPTP_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap reportMap = suitService.getReportDetail(mtenMap);
		model.addAttribute("reportMap", reportMap);
		
		String RPTP_MNG_NO = mtenMap.get("RPTP_MNG_NO")==null?"":mtenMap.get("RPTP_MNG_NO").toString();
		if (!RPTP_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("RPTP_MNG_NO")==null?"":mtenMap.get("RPTP_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_RPTP");
			fMap.put("FILE_SE", "REP");
			List reportFile = suitService.getFileList(fMap);
			model.addAttribute("reportFile", reportFile);
		}
		
		return "/suit/popup/reportViewPop.pop";
	}
	
	@RequestMapping(value = "selectReportList.do")
	public void selectReportList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.selectReportList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "insertReportInfo.do")
	public void insertReportInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertReportInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}

	@RequestMapping(value = "deleteReportInfo.do")
	public void deleteReportInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.deleteReportInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "chkProgressWritePop.do")
	public String chkProgressWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("RVW_MNG_NO", mtenMap.get("RVW_MNG_NO"));
		model.addAttribute("UP_RVW_MNG_NO", mtenMap.get("UP_RVW_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("gbn", mtenMap.get("gbn"));
		
		HashMap chkMap = suitService.getChkInfoDetail(mtenMap);
		model.addAttribute("chkMap", chkMap);
		
		HashMap upChkMap = new HashMap();
		String UP_RVW_MNG_NO = mtenMap.get("UP_RVW_MNG_NO")==null?"":mtenMap.get("UP_RVW_MNG_NO").toString();
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		
		if ("reply".equals(gbn)) {
			HashMap param = new HashMap();
			param.put("RVW_MNG_NO", UP_RVW_MNG_NO);
			param.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
			param.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
			upChkMap = suitService.getChkInfoDetail(mtenMap);
		}
		model.addAttribute("upChkMap", upChkMap);
		
		String RVW_MNG_NO = mtenMap.get("RVW_MNG_NO")==null?"":mtenMap.get("RVW_MNG_NO").toString();
		if (!RVW_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("RVW_MNG_NO")==null?"":mtenMap.get("RVW_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_RVW_PRGRS");
			fMap.put("FILE_SE", "CHK");
			List chkFile = suitService.getFileList(fMap);
			model.addAttribute("chkFile", chkFile);
		}
		
		return "/suit/popup/chkProgressWritePop.pop";
	}
	
	@RequestMapping(value = "chkProgressViewPop.do")
	public String chkProgressViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String WRTR_EMP_NO = mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString();
		
		HashMap taskMap = new HashMap();
		taskMap = new HashMap();
		taskMap.put("EMP_NO", WRTR_EMP_NO);
		taskMap.put("TASK_SE", "S3");
		taskMap.put("DOC_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
		taskMap.put("PRCS_YN", "Y");
		mifService.setTask(taskMap);
		
		model.addAttribute("RVW_MNG_NO", mtenMap.get("RVW_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap chkMap = suitService.getChkInfoDetail(mtenMap);
		model.addAttribute("chkMap", chkMap);
		
		String RVW_MNG_NO = mtenMap.get("RVW_MNG_NO")==null?"":mtenMap.get("RVW_MNG_NO").toString();
		if (!RVW_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("RVW_MNG_NO")==null?"":mtenMap.get("RVW_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_RVW_PRGRS");
			fMap.put("FILE_SE", "CHK");
			List chkFile = suitService.getFileList(fMap);
			model.addAttribute("chkFile", chkFile);
		}
		
		return "/suit/popup/chkProgressViewPop.pop";
	}
	
	@RequestMapping(value = "selectChkList.do")
	public void selectChkList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.selectChkList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "insertChkInfo.do")
	public void insertChkInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo");
		String grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		mtenMap.put("grpcd", grpcd);
		JSONObject result = this.suitService.insertChkInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}

	@RequestMapping(value = "deleteChkInfo.do")
	public void deleteChkInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.deleteChkInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "selectMemoList.do")
	public void selectMemoList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.selectMemoList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "insertMemo.do")
	public void insertMemo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.insertMemo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}

	@RequestMapping(value = "deleteMemo.do")
	public void deleteMemo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.deleteMemo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	
	@RequestMapping(value = "satisMngPage.do")
	public String satisMngPage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		
		String SRVY_SE = "";
		String MENU_MNG_NO = mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO").toString();
		
		//MENU_MNG_NO=100003229 자문
		//MENU_MNG_NO=10000186  소송
		//협약 추후 추가
		if ("100003229".equals(MENU_MNG_NO)) {
			SRVY_SE = "CON";
		} else if ("10000186".equals(MENU_MNG_NO)) {
			SRVY_SE = "SUIT";
		} else if ("100000610".equals(MENU_MNG_NO)) {
			SRVY_SE = "AGR";
		}
		
		HashMap param = new HashMap();
		param.put("SRVY_SE", SRVY_SE);
		List satisMap = this.suitService.getSatisitemList(param);
		model.addAttribute("satisMap", satisMap);
		model.addAttribute("gbn", SRVY_SE);
		return "/suit/sati/caseSatisMng.frm";
	}
	
	@RequestMapping("insertSatisitem.do")
	public void insertSatisitem(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = suitService.insertSatisitem(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "selectSatisfactionList.do")
	public void selectSatisfactionList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.selectSatisfactionList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "caseSatisWritePop.do")
	public String caseSatisWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("DGSTFN_ANS_MNG_NO", mtenMap.get("DGSTFN_ANS_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		// 설문 항목 목록
		List satisList = suitService.getSatisfactionList(mtenMap);
		model.addAttribute("satisList", satisList);
		// 대리인 목록
		List lawyerList = suitService.getLawyerList(mtenMap);
		model.addAttribute("lawyerList", lawyerList);
		// 
		List procSatisList = suitService.getProcSatisList(mtenMap);
		model.addAttribute("procSatisList", procSatisList);
		// 
		List satisItemList = suitService.getSatisitemList2(mtenMap);
		model.addAttribute("satisItemList", satisItemList);
		
		return "/suit/popup/caseSatisWritePop.pop";
	}
	
	@RequestMapping(value="insertSatisfaction.do")
	public void insertSatisfaction(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String jsonStr = req.getParameter( "satisData" );
		org.json.simple.parser.JSONParser parser = new org.json.simple.parser.JSONParser();
		org.json.simple.JSONObject jsonObj;
		try {
			jsonObj = (org.json.simple.JSONObject) parser.parse( jsonStr );
			org.json.simple.JSONArray jsonArr = (org.json.simple.JSONArray) jsonObj.get( "data" );
			int saveRes = suitService.insertSatisfaction(jsonArr);
			
			jsonObj = new org.json.simple.JSONObject();
			jsonObj.put("result", saveRes);
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			
			PrintWriter pw = response.getWriter();
			pw.println(jsonObj);
			pw.close();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			
		}
	}
	
	@RequestMapping(value = "fileViewPop.do")
	public String fileViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("ordgbn", mtenMap.get("ordgbn")==null?"":mtenMap.get("ordgbn").toString());
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("schTxt", mtenMap.get("schTxt"));
		model.addAttribute("filePath", this.filePath);
		
		HashMap fMap = new HashMap();
		fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
		fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
		fMap.put("ordgbn", mtenMap.get("ordgbn")==null?"":mtenMap.get("ordgbn").toString());
		fMap.put("schTxt", mtenMap.get("schTxt")==null?"":mtenMap.get("schTxt").toString());
		List fileList = suitService.getFileList(fMap);
		model.addAttribute("fileList", fileList);
		
		return "/suit/popup/fileViewPop.pop";
	}
	
	@RequestMapping(value = "fileDelete.do")
	public void fileDelete(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filePath", this.filePath);
		JSONObject result = this.suitService.fileDelete(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "courtFileViewPop.do")
	public String courtFileViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		model.addAttribute("filePath", this.filePath);
		return "/suit/popup/courtFileViewPop.pop";
	}
	
	@RequestMapping(value = "courtFileUploadPop.do")
	public String courtFileUploadPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("gbn", mtenMap.get("gbn"));
		
		return "/suit/popup/courtFileUploadPop.pop";
	}
	
	@RequestMapping(value = "selectCourtFileList.do")
	public void selectCourtFileList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.selectCourtFileList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "courtFileUpload.do")
	public void courtFileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filePath", this.filePath);
		JSONObject result = this.suitService.courtFileUpload(mtenMap, multipartRequest);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "courtFileDelete.do")
	public void courtFileDelete(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filePath", this.filePath);
		JSONObject result = this.suitService.courtFileDelete(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "allCourtFileDownload.do")
	public void allCourtFileDownload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		List<Map<String, Object>> fList = this.suitService.getCourtFileList(mtenMap);
		zip.allFileDownload(req, response, fList, this.filePath);
	}
	
	@RequestMapping({"allCourtFileDelete.do"})
	public void allCourtFileDelete(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filePath", this.filePath);
		JSONObject result = this.suitService.allCourtFileDelete(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	
	
	
	@RequestMapping(value = "goUnchangeDate.do")
	public String goUnchangeDate(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		return "/suit/unchdate/unchangeDateList.frm";
	}
	
	// 불변기일관리 목록 조회
	@RequestMapping(value = "selectUnchangeDateList.do")
	public void selectUnchangeDateList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String start = mtenMap.get("start") == null ? "" : mtenMap.get("start").toString();
		String limit = mtenMap.get("limit") == null ? "" : mtenMap.get("limit").toString();
		
		if (!start.equals("") & !limit.equals("")) {
			int a = Integer.parseInt(start);
			int b = Integer.parseInt(limit);
			int result = 1;
			if (b != 0) {
				result = a / b + 1;
			}
			mtenMap.put("pageno", result);
		}
		
		String sort = mtenMap.get("sort") == null ? "" : mtenMap.get("sort").toString();
		String dir = mtenMap.get("dir") == null ? "" : mtenMap.get("dir").toString();
		String orderby = "";
		if (!sort.equals("") && !dir.equals("")) {
			if (sort.equals("ordsort")) {
				orderby = "";
			} else {
				orderby = "order by " + sort + " " + dir;
			}
			
			mtenMap.put("orderby", orderby);
		}
		
		JSONObject jl = this.suitService.selectUnchangeDateList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 불변기일관리 등록 팝업화면 호출
	@RequestMapping(value = "unchangeDateWritePop.do")
	public String unchangeDateWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("UNCH_DATE_MNG_NO", mtenMap.get("UNCH_DATE_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap map = this.suitService.getUnchDateInfo(mtenMap);
		model.addAttribute("map", map);
		
		return "/suit/unchdate/unchangeDateWritePop.pop";
	}
	
	// 불변기일관리 정보 등록
	@RequestMapping(value = "UnchDateInfoSave.do")
	public void UnchDateInfoSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.UnchDateInfoSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 불변기일관리 상세정보 팝업화면 호출
	@RequestMapping(value = "unchangeDateViewPop.do")
	public String unchangeDateViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("UNCH_DATE_MNG_NO", mtenMap.get("UNCH_DATE_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap map = this.suitService.getUnchDateInfo(mtenMap);
		model.addAttribute("map", map);
		
		return "/suit/unchdate/unchangeDateViewPop.pop";
	}
	
	// 불변기일관리 정보 삭제
	@RequestMapping(value = "unchDateDelete.do")
	public void unchDateDelete(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.unchDateDelete(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	

	@RequestMapping("fullcalendarMain.do")
	public String fullcalendarMain(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		String addParam1 = mtenMap.get("addParam1")==null?"":mtenMap.get("addParam1").toString();
		String addParam2 = mtenMap.get("addParam2")==null?"":mtenMap.get("addParam2").toString();
		
		String docGbn = "";
		String dateGbn = "";
		if (addParam1.equals("")) {
			docGbn = mtenMap.get("docGbn")==null?"":mtenMap.get("docGbn").toString();
			dateGbn = mtenMap.get("dateGbn")==null?"":mtenMap.get("dateGbn").toString();
		} else {
			docGbn = addParam1;
			dateGbn = addParam2;
		}
		
		model.addAttribute("docGbn", docGbn);
		model.addAttribute("dateGbn", dateGbn);
		model.addAttribute("param", mtenMap);
		return "/suit/fullcalMain.web";
	}
	
	@RequestMapping(value = "fullcalendar.do")
	public String fullcalendar(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String addParam1 = mtenMap.get("addParam1")==null?"":mtenMap.get("addParam1").toString();
		String addParam2 = mtenMap.get("addParam2")==null?"":mtenMap.get("addParam2").toString();
		
		String docGbn = "";
		String dateGbn = "";
		if (addParam1.equals("")) {
			docGbn = mtenMap.get("docGbn")==null?"":mtenMap.get("docGbn").toString();
			dateGbn = mtenMap.get("dateGbn")==null?"":mtenMap.get("dateGbn").toString();
		} else {
			docGbn = addParam1;
			dateGbn = addParam2;
		}
		
		model.addAttribute("docGbn", docGbn);
		model.addAttribute("dateGbn", dateGbn);
		model.addAttribute("param", mtenMap);
		return "/suit/fullcalendar.frm";
	}
	
	@RequestMapping(value = "selectCalData.do")
	public void selectCalData(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo");
		String grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		mtenMap.put("GRPCD", grpcd);
		
		JSONArray jl = this.suitService.selectCalData(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "caseSearchPop.do")
	public String caseSearchPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String pageno = mtenMap.get("pageno")==null?"":mtenMap.get("pageno").toString();
		mtenMap.put("pagesize", "10");
		
		if(pageno.equals("")) {
			pageno = "1";
		}
		mtenMap.put("pageno", pageno);
		// 관련사건 대상 사건 목록 조회
		HashMap map = this.suitService.selectRelCaseList(mtenMap);
		// 관련사건 목록 조회
		HashMap map2 = this.suitService.selectRelCase(mtenMap);
		
		model.addAttribute("map", map);
		model.addAttribute("map2", map2);
		model.addAttribute("pageno", pageno);
		model.addAttribute("mtenMap", mtenMap);
		model.addAttribute("gbn", mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString());
		model.addAttribute("cnt", mtenMap.get("cnt")==null?"":mtenMap.get("cnt").toString());
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		return "/suit/popup/caseSearchPop.pop";
	}
	
	// 관련문서 등록
	@RequestMapping(value = "saveRelCase.do")
	public void saveRelCase(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject result = this.suitService.saveRelCase(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 관련문서 삭제
	@RequestMapping(value = "deleteRelCase.do")
	public void deleteRelCase(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject result = this.suitService.deleteRelCase(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "mergeCaseSearchPop.do")
	public String mergeCaseSearchPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		
		String pageno = mtenMap.get("pageno")==null?"":mtenMap.get("pageno").toString();
		mtenMap.put("pagesize", "10");
		if(pageno.equals("")) {
			mtenMap.put("pageno", "1");
		}
		HashMap map = this.suitService.selectMerCaseList(mtenMap);
		model.addAttribute("map", map);
		
		model.addAttribute("mtenMap", mtenMap);
		model.addAttribute("gbn", mtenMap.get("gbn"));
		model.addAttribute("cnt", mtenMap.get("cnt")==null?"":mtenMap.get("cnt").toString());
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
		
		return "/suit/popup/mergeCaseSearchPop.pop";
	}
	
	@RequestMapping(value = "lawyerAccInfoPop.do")
	public String lawyerAccInfoPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		//LWYR_MNG_NO
		List bankList = suitService.getBankList(mtenMap);
		model.addAttribute("bankList", bankList);
		
		model.addAttribute("mtenMap", mtenMap);
		model.addAttribute("gbn", mtenMap.get("gbn"));
		return "/suit/popup/lawyerAccInfoPop.pop";
	}
	
	///////////////////////////// 소송심의
	@RequestMapping(value = "goSuitCommittee.do")
	public String goSuitCommittee(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/suit/review/suitCommittee.frm";
	}
	
	@RequestMapping(value = "suitCommiteePop.do")
	public String suitCommiteePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("LWS_DLBR_MNG_NO", mtenMap.get("LWS_DLBR_MNG_NO"));
		model.addAttribute("Menuid", mtenMap.get("Menuid"));
		return "/suit/review/suitCommiteePop.pop";
	}
	
	@RequestMapping(value = "suitComHisPop.do")
	public String suitComHisPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		return "/suit/review/suitComHisPop.pop";
	}
	
	@RequestMapping(value = "writeOpinionPop.do")
	public String writeOpinionPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("LWS_DLBR_MNG_NO", mtenMap.get("LWS_DLBR_MNG_NO"));
		model.addAttribute("DLBR_CMT_MNG_NO", mtenMap.get("DLBR_CMT_MNG_NO"));
		model.addAttribute("DLBR_MBCMT_MNG_NO", mtenMap.get("DLBR_MBCMT_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/suit/review/writeOpinionPop.pop";
	}
	
	@RequestMapping(value = "selectComiUserList.do")
	public void selectComiUserList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.selectComiUserList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "comInfoSave.do")
	public void comInfoSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.comInfoSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "delComiUser.do")
	public void delComiUser(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.delComiUser(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	
	@RequestMapping(value = "goSuitReviewList.do")
	public String goSuitReviewList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/suit/review/suitReviewList.frm";
	}
	
	@RequestMapping(value = "selectReviewList.do")
	public void selectReviewList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		if (userInfo == null) {
			urlInfo = "/common/nossion.frm"; // 세션이 없어 로그인 페이지로 다이렉트 이동
		} else {
			req.setAttribute("logMap", mtenMap);
			
			String start = mtenMap.get("start") == null ? "" : mtenMap.get("start").toString();
			String limit = mtenMap.get("limit") == null ? "" : mtenMap.get("limit").toString();
			if (!start.equals("") & !limit.equals("")) {
				int a = Integer.parseInt(start);
				int b = Integer.parseInt(limit);
				int result = 1;
				if (b != 0) {
					result = a / b + 1;
				}
				mtenMap.put("pageno", result);
			}
			
			String sort = mtenMap.get("sort") == null ? "" : mtenMap.get("sort").toString();
			String dir = mtenMap.get("dir") == null ? "" : mtenMap.get("dir").toString();
			String orderby = "";
			if (!sort.equals("") && !dir.equals("")) {
				if (sort.equals("ordsort")) {
					orderby = "";
				} else {
					orderby = "order by " + sort + " " + dir;
				}
				
				mtenMap.put("orderby", orderby);
			}
		}
		JSONObject jl = this.suitService.selectReviewList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "suitReviewViewPage.do")
	public String suitReviewViewPage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String urlInfo = "";
		String LWS_DLBR_MNG_NO = mtenMap.get("LWS_DLBR_MNG_NO")==null?"":mtenMap.get("LWS_DLBR_MNG_NO").toString();
		
		HashMap reviewInfo = suitService.getSuitReviewDetail(mtenMap);
		model.addAttribute("reviewInfo", reviewInfo);
		
		List commiteeList = suitService.getSuitReviewComiList(mtenMap);
		model.addAttribute("commiteeList", commiteeList);
		
		HashMap opinionCnt = suitService.getReviewOpinionCnt(mtenMap);
		model.addAttribute("opinionCnt", opinionCnt);
		
		HashMap fMap = new HashMap();
		fMap.put("LWS_MNG_NO",      LWS_DLBR_MNG_NO);
		fMap.put("INST_MNG_NO",     LWS_DLBR_MNG_NO);
		fMap.put("TRGT_PST_MNG_NO", LWS_DLBR_MNG_NO);
		fMap.put("TRGT_PST_TBL_NM", "TB_LWS_DLBR");
		fMap.put("FILE_SE", "");
		List fileList = suitService.getFileList(fMap);
		model.addAttribute("fileList", fileList);
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		urlInfo = "/suit/review/suitReviewView.frm";
		
		return urlInfo;
	}
	
	@RequestMapping(value = "suitReviewWritePage.do")
	public String suitReviewWrite(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String LWS_DLBR_MNG_NO = mtenMap.get("LWS_DLBR_MNG_NO")==null?"":mtenMap.get("LWS_DLBR_MNG_NO").toString();
		if(!LWS_DLBR_MNG_NO.equals("")){
			HashMap reviewInfo = suitService.getSuitReviewDetail(mtenMap);
			model.addAttribute("reviewInfo", reviewInfo);
			List commiteeList = suitService.getSuitReviewComiList(mtenMap);
			model.addAttribute("commiteeList", commiteeList);
			HashMap opinionCnt = suitService.getReviewOpinionCnt(mtenMap);
			model.addAttribute("opinionCnt", opinionCnt);
			
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO",      LWS_DLBR_MNG_NO);
			fMap.put("INST_MNG_NO",     LWS_DLBR_MNG_NO);
			fMap.put("TRGT_PST_MNG_NO", LWS_DLBR_MNG_NO);
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_DLBR");
			fMap.put("FILE_SE", "");
			List fileList = suitService.getFileList(fMap);
			model.addAttribute("fileList", fileList);
			
			model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
			model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
			model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
			model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
			model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		}
		model.addAttribute("Menuid", mtenMap.get("Menuid"));
		return "/suit/review/suitReviewWrite.frm";
	}
	
	@RequestMapping(value = "reviewInfoSave.do")
	public void reviewInfoSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.reviewInfoSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "delReviewInfo.do")
	public void delReviewInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.delReviewInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "selectreviewComiList.do")
	public void selectreviewComiList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.selectreviewComiList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "selectEndComList.do")
	public void selectEndComList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = this.suitService.selectEndComList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "reviewComiSave.do")
	public void reviewComiSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.reviewComiSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "suitReviewRequest.do")
	public void suitReviewRequest(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.suitReviewRequest(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "suitOpinionSave.do")
	public void suitOpinionSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.suitOpinionSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "reviewEndInfoSave.do")
	public void reviewEndInfoSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.reviewEndInfoSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "reviewContInfoSave.do")
	public void reviewContInfoSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.reviewContInfoSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "reviewStateChange.do")
	public void reviewStateChange(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.reviewStateChange(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	
	// 대법원 나의사건검색 연계
	@RequestMapping(value = "selectCaseInfo.do")
	public void selectCaseInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.selectCaseInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 사건진행상황 목록 조회
	@RequestMapping(value = "selectProgList.do")
	public void selectProgList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("LWS_MNG_NO", LWS_MNG_NO);
		param.put("INST_MNG_NO", INST_MNG_NO);
		
		JSONObject jl = this.suitService.selectProgList(param);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "gianMakePop.do")
	public String gianMakePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("filePath", this.filePath);
		
		HashMap fMap = new HashMap();
		fMap.put("LWS_MNG_NO",  mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
		fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
		fMap.put("ordgbn", "SO1,SO2,SO3,SO4,SO5");
		fMap.put("schTxt", mtenMap.get("schTxt")==null?"":mtenMap.get("schTxt").toString());
		List fileList = suitService.getFileList(fMap);
		model.addAttribute("fileList", fileList);
		return "/suit/popup/gianMakePop.pop";
	}
	
	@RequestMapping(value = "gianSelFilePop.do")
	public String gianSelFilePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		model.addAttribute("giangbn", mtenMap.get("giangbn"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("filePath", this.filePath);
		
		HashMap fMap = new HashMap();
		fMap.put("LWS_MNG_NO",  mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
		fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
		fMap.put("ordgbn", "SO1,SO2,SO3,SO4,SO5");
		fMap.put("schTxt", mtenMap.get("schTxt")==null?"":mtenMap.get("schTxt").toString());
		List fileList = suitService.getFileList(fMap);
		model.addAttribute("fileList", fileList);
		return "/suit/popup/gianSelFilePop.pop";
	}
	
	@RequestMapping(value = "getSuitTypeInfo.do")
	public void getSuitTypeInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.getSuitTypeInfo(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "getProgListSch.do")
	public void getProgListSch(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.getProgListSch(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "getLeftDate.do")
	public void getLeftDate(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = this.suitService.getLeftDate(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 소송 권한관리 팝업 호출
	@RequestMapping(value = "roleSettingPop.do")
	public String roleSettingPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model){
		model.addAttribute("DOC_MNG_NO",  mtenMap.get("DOC_MNG_NO"));
		model.addAttribute("DOC_SE",      mtenMap.get("DOC_SE"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/suit/popup/roleSettingPop.pop";
	}
	
	@RequestMapping(value = "selectRoleInfo.do")
	public void selectRoleInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject result = this.suitService.selectRoleInfo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "roleInfoSave.do")
	public void roleInfoSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject result = this.suitService.roleInfoSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="bondBugaInsert")
	public void bondBugaInsert(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		HashMap bondMap = suitService.getBondDetail(mtenMap);
		String SYS_ID = bondMap.get("SYS_ID")==null?"":bondMap.get("SYS_ID").toString();
		String TXTN_YMD = bondMap.get("TXTN_YMD")==null?"":bondMap.get("TXTN_YMD").toString();
		String TXTN_YM = TXTN_YMD.substring(0, 6);
		BigDecimal BND_AMT_BIG = bondMap.get("BND_AMT")==null?BigDecimal.ZERO:(BigDecimal) bondMap.get("BND_AMT");
		
		int BND_AMT = BND_AMT_BIG.setScale(0, RoundingMode.HALF_UP).intValue();
		
		BugaWebService service = new BugaWebService();
		BugaWS ws = service.getBugaWSPort();
		Bu04UserInfoWSDTO dto = ws.getUserInfo(SYS_ID);
		
		///**
		// getNewTaxNo 과세번호 생성
		// 설명 : 과세번호를 생성하여 반환한다.
		// @param String sigu_cd   : 시구코드[7]
		// @param String semok_cd  : 세목코드[8]
		// @param String tax_ym    : 과세년월[6]
		// @param String tax_gubun : 과세구분[1]
		// @return String tax_no   : 과세번호[6]
		//*/
		String taxNo = ws.getNewTaxNo(dto.getSiguCd(), "10228901", TXTN_YM, "2");
		
		Bu04BugaWSDTO bugaDto = new Bu04BugaWSDTO();
		bugaDto.setSiguCd(dto.getSiguCd());			// 시구코드
		bugaDto.setSemokCd("10228901");				// 세목코드
		bugaDto.setTaxYm(TXTN_YM);					// 과세년월
		bugaDto.setTaxGubun("2");					// 과세구분 (1/2/3 값만 가능(1:정기, 2:수시, 3:신고))
		bugaDto.setBuseoCd(dto.getBuseoCd());		// 부서코드 (부서코드 7자리 : 기존 11자리중 앞 7자리)
		bugaDto.setTaxNo(taxNo);					// 과세번호 (getNewTexNo(과세번호생성) 로 생성한 값.)
		bugaDto.setSidoCd("11");					// 시도코드 (default 11(서울시))
		bugaDto.setNapId("0000000000000");			// 납세자ID -> 주민/법인번호 13자리 : 사업자번호(10자리)
		bugaDto.setNapNm(bondMap.get("CNCPR_NM")==null?"":bondMap.get("CNCPR_NM").toString());			// 납세자명
		bugaDto.setNapGubun(bondMap.get("TXPR_SE_NO")==null?"":bondMap.get("TXPR_SE_NO").toString());	// 납세자구분
		bugaDto.setSuBuseoCd(dto.getBuseoCd());		// 수납부서코드 (부서코드 7자리 : 기존 11자리중 앞 7자리)
		bugaDto.setTaxYmd(TXTN_YMD);				// 과세일자 (yyyymmdd : 비정상일자 체크 예)20070230 불가)
		bugaDto.setNapgiYmd(bondMap.get("DUDT_YMD")==null?"":bondMap.get("DUDT_YMD").toString());			// 납기일자 (yyyymmdd : 비정상일자 체크 예)20070230 불가)
		bugaDto.setTaxAmt(BND_AMT);					// 과세금액
		bugaDto.setSise(BND_AMT);					// 시세? (병기세목아닌 경우 본세)
		bugaDto.setLastWorkId(SYS_ID);				// 최종작업자ID (작업자인사대체키13자리(필수))
		bugaDto.setSysGubun("LSIS");				// 시스템구분 (* LSIS=법률지원통합시스템)
		bugaDto.setGasanRateGubun("7");
		
		bugaDto.setNapDzipCd(bondMap.get("CNCPR_ZIP")==null?"":bondMap.get("CNCPR_ZIP").toString());
		bugaDto.setNapDzipAddr(bondMap.get("CNCPR_ADDR")==null?"":bondMap.get("CNCPR_ADDR").toString());
		bugaDto.setNapDdtlAddr("");
		bugaDto.setNapDrefAddr("");
		bugaDto.setNapUndYn("N");
		
		System.out.println("?????????????????????????????????????????");
		System.out.println(bugaDto);
		
		StatusCodeWSDTO sDto = ws.insertBugaRegist(bugaDto);
		
		String msg = sDto.getErrorMsg();
		
		System.out.println("bugiInsert result Msg > ");
		System.out.println(msg);
		System.out.println(">>>>>>>>>>>>>> insertBuga after State : " + sDto.getErrorCode());
		System.out.println(">>>>>>>>>>>>>> insertBuga after State : " + sDto.getErrorMsg());
		
		if (msg.equals("")) {
			HashMap updateMap = new HashMap();
			updateMap.put("PRGRS_STTS_SE_NM", "부과");
			updateMap.put("TXTN_NO", taxNo);
			updateMap.put("BND_MNG_NO", bondMap.get("BND_MNG_NO")==null?"":bondMap.get("BND_MNG_NO").toString());
			suitService.updateBondBuga(updateMap);
			
			msg = "부과정보가 세외수입시스템에 등록되었습니다.";
		}
		
		JSONObject jl = new JSONObject();
		jl.put("msg", msg);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="bondBugaUpdate")
	public void bondBugaUpdate(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		HashMap bondMap = suitService.getBondDetail(mtenMap);
		String SYS_ID = bondMap.get("SYS_ID")==null?"":bondMap.get("SYS_ID").toString();
		String TXTN_NO = bondMap.get("TXTN_NO")==null?"":bondMap.get("TXTN_NO").toString();
		String TXTN_YMD = bondMap.get("TXTN_YMD")==null?"":bondMap.get("TXTN_YMD").toString();
		String TXTN_YM = TXTN_YMD.substring(0, 6);
		
		BugaWebService service = new BugaWebService();
		BugaWS ws = service.getBugaWSPort();
		
		///**
		// getSimpleBuga 단순부과정보조회
		// 설명 : 해당 과세번호에 해당되는 부과정보(고지번호 29자리 등), 전용계좌번호 등을 반환한다.
		// @param String buch_gubun : 부과 1 , 체납 2 구분 <BR>
		// @param String sys_gubun : 시스템구분 <BR>
		// @param String sigu_cd : 시구코드
		// @param String semok_cd : 세목코드
		// @param String tax_ym : 과세년월
		// @param String tax_gubun : 과세구분
		// @param String tax_no : 과세번호
		// @return Bu04SimpleBugaETCWSDTO : 부과 <BR>//@exception DAOException
		//*/
		
		System.out.println("TXTN_YM : " + TXTN_YM);
		System.out.println("TXTN_NO : " + TXTN_NO);
		
		Bu04UserInfoWSDTO dto = ws.getUserInfo("A019198095070");
		
		Bu04SimpleBugaETCWSDTO etcWsDto = new Bu04SimpleBugaETCWSDTO();
		etcWsDto = ws.getSimpleBuga("1", "LSIS", dto.getSiguCd(), "10228901", TXTN_YM, "2", TXTN_NO);
		String sttsSeNm = etcWsDto.getEtc14();
		
		
		System.out.println("getSimpleBuga >>");
		System.out.println(etcWsDto.getEtc14());
		System.out.println(etcWsDto.getEtc15());
		System.out.println(etcWsDto.getEtc16());
		if (!sttsSeNm.equals("")) {
			// 고지번호
			String INFRM_NO = etcWsDto.getOcrSiguCd()+etcWsDto.getOcrBuseoCd()+etcWsDto.getGum1()+etcWsDto.getSemokCd()+etcWsDto.getTaxYm()+etcWsDto.getTaxGubun()+etcWsDto.getTaxNo()+etcWsDto.getGum2();
			//getOcrSiguCd()||getOcrBuseoCd()||getGum1() – getSemokCd() – getTaxYm()||getTaxGubun() – getTaxNo()||getGum2()
			
			HashMap updateMap = new HashMap();
			updateMap.put("PRGRS_STTS_SE_NM", etcWsDto.getEtc14());
			updateMap.put("BND_MNG_NO", mtenMap.get("BND_MNG_NO")==null?"":mtenMap.get("BND_MNG_NO").toString());
			updateMap.put("INFRM_NO", INFRM_NO);
			suitService.updateBondBuga(updateMap);
		}
	}	
		
	@RequestMapping(value="callBugaTest")
	public void callBugaTest(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        System.out.println(timestamp);
        
        //method 2 - via Date
        Date date = new Date();
        System.out.println(new Timestamp(date.getTime()));
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String getDate = sdf.format(timestamp);
		
		System.out.println("getDate : " + getDate);
		
		BugaWebService service = new BugaWebService();
		BugaWS ws = service.getBugaWSPort();
		Bu04UserInfoWSDTO dto = ws.getUserInfo("A019198095070");
		
		String taxNo = ws.getNewTaxNo(dto.getSiguCd(), "10228901", getDate, "2");
		
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> call Buga TEST getBuseoCd : " + dto.getBuseoCd());
		// getBuseoCd는 박찬우 주무관이 알려준 부서코드와 상이한 값 출력 됨
		
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> call Buga TEST getSiguCd : " + dto.getSiguCd());
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> call Buga TEST taxNo : " + taxNo);
		
		Bu04BugaWSDTO bugaDto = new Bu04BugaWSDTO();
		bugaDto.setSiguCd(dto.getSiguCd());			// 시구코드
		bugaDto.setSemokCd("10228901");				// 세목코드
		bugaDto.setTaxYm(getDate);					// 과세년월
		bugaDto.setTaxGubun("2");					// 과세구분 (1/2/3 값만 가능(1:정기, 2:수시, 3:신고))
		bugaDto.setBuseoCd(dto.getBuseoCd());		// 부서코드 (부서코드 7자리 : 기존 11자리중 앞 7자리)
		bugaDto.setTaxNo(taxNo);					// 과세번호 (getNewTexNo(과세번호생성) 로 생성한 값.)
		bugaDto.setSidoCd("11");					// 시도코드 (default 11(서울시))
		bugaDto.setNapId("0000000000000");			// 납세자ID -> 주민/법인번호 13자리 : 사업자번호(10자리)
		bugaDto.setNapNm("법률테스트");				// 납세자명
		bugaDto.setNapGubun("10");					// 납세자구분
													// 10=개인, 12=외국인, 13=외국인_번호오류, 19=개인_주민망검증오류,
													// 20=단체(종교단체, 문종, 기타 단체 등), 21=단체_번호오류, 30=법인(회사, 학교법인, 의료법인 등), 31=법인_번호오류,
													// 32=사업자번호, 33=사업자_번호오류, 40=공공기관(국가, 자치단체 등), 41=공공기관_번호오류, 45=공공기관-사업자,
													// 46=공공기관-사업자_번호 오류, 50=외국기관(외국정보 및 주한국제기관 등), 51=외국기관_번호오류, 99=기타
		bugaDto.setSuBuseoCd(dto.getBuseoCd());		// 수납부서코드 (부서코드 7자리 : 기존 11자리중 앞 7자리)
		bugaDto.setTaxYmd("20250617");				// 과세일자 (yyyymmdd : 비정상일자 체크 예)20070230 불가)
		bugaDto.setNapgiYmd("20250617");			// 납기일자 (yyyymmdd : 비정상일자 체크 예)20070230 불가)
		bugaDto.setTaxAmt(1000000);					// 과세금액
		bugaDto.setSise(1000000);					// 시세? (병기세목아닌 경우 본세)
		bugaDto.setLastWorkId("A019198095070");		// 최종작업자ID (작업자인사대체키13자리(필수))
		bugaDto.setSysGubun("LSIS");				// 시스템구분 (* LSIS=법률지원통합시스템)
		bugaDto.setGasanRateGubun("7");
		
		bugaDto.setNapDzipCd("14406");
		bugaDto.setNapDzipAddr("고강로154번길 73-36");
		bugaDto.setNapDdtlAddr("");
		bugaDto.setNapDrefAddr("");
		bugaDto.setNapUndYn("N");
		
		StatusCodeWSDTO sDto = ws.insertBugaRegist(bugaDto);
		System.out.println(">>>>>>>>>>>>>> insertBuga after State : " + sDto.getErrorCode());
		System.out.println(">>>>>>>>>>>>>> insertBuga after State : " + sDto.getErrorMsg());
		
		Bu04SimpleBugaETCWSDTO etcWsDto = new Bu04SimpleBugaETCWSDTO();
		etcWsDto = ws.getSimpleBuga("1", "LSIS", "11", "10228901", getDate, "2", taxNo);
		System.out.println(">>>>> getSimpleBuga info getEtc14");
		System.out.println(etcWsDto.getEtc14());
	}
	
	
	
	
	@RequestMapping(value = "goSuitChrgCost.do")
	public String goSuitChrgCost(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		// List 담아 보내기
		List list = suitService.selectSuitChrgCost(mtenMap);
		model.addAttribute("costList", list);
		
		return "/suit/suitChrgCost.frm";
	}
	
	
	

	@RequestMapping(value = "caseOutCostWritePop.do")
	public String caseOutCostWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("CST_MNG_NO", mtenMap.get("CST_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		String targetNo = suitService.getCostTargetOne(mtenMap);
		model.addAttribute("CST_TRGT_MNG_NO", targetNo);
		
		HashMap costMap = suitService.getCostDetail(mtenMap);
		model.addAttribute("costMap", costMap);
		
		HashMap param = new HashMap();
		param.put("type", "cost");
		List codeList = suitService.getCodeList(param);
		model.addAttribute("codeList", codeList);
		
		String CST_MNG_NO = mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString();
		if (!CST_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_CST");
			fMap.put("FILE_SE", "COST");
			List costFile = suitService.getFileList(fMap);
			model.addAttribute("costFile", costFile);
		}
		return "/suit/popup/caseOutCostWritePop.pop";
	}
	
	@RequestMapping(value = "goSuitCost.do")
	public String goSuitCost(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		// List 담아 보내기
		List list = suitService.selectSuitTotalCost(mtenMap);
		model.addAttribute("costList", list);
		
		return "/suit/suitCost.frm";
	}
	

	@RequestMapping(value = "caseOutCostViewPop.do")
	public String caseOutCostViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("CST_MNG_NO", mtenMap.get("CST_MNG_NO"));
		model.addAttribute("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		model.addAttribute("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		String targetNo = suitService.getCostTargetOne(mtenMap);
		model.addAttribute("CST_TRGT_MNG_NO", targetNo);
		
		HashMap costMap = suitService.getCostDetail(mtenMap);
		model.addAttribute("costMap", costMap);
		
		String CST_MNG_NO = mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString();
		if (!CST_MNG_NO.equals("")) {
			HashMap fMap = new HashMap();
			fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
			fMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_LWS_CST");
			fMap.put("FILE_SE", "COST");
			List costFile = suitService.getFileList(fMap);
			model.addAttribute("costFile", costFile);
		}
		return "/suit/popup/caseOutCostViewPop.pop";
	}
	
	@RequestMapping(value="setOutCostState")
	public void setOutCostState(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject result = this.suitService.setOutCostState(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	

	@RequestMapping(value = "updateCostAmtList.do")
	public void updateCostAmtList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.suitService.updateCostAmtList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
}
