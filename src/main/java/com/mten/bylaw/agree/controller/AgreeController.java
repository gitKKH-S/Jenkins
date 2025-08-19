package com.mten.bylaw.agree.controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.GZIPOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.agree.service.AgreeService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.law.service.LawService;
import com.mten.bylaw.mif.serviceSch.MifService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.bylaw.web.service.WebService;
import com.mten.util.BindObject;
import com.mten.util.CommonMakeExcel;
import com.mten.util.Json4Ajax;
import com.mten.util.JsonHelper;
import com.mten.util.zipFileDownload;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/web/agree/")
public class AgreeController extends DefaultController{
	@Value("#{fileinfo['mten.AGREE']}") 
	public String filePath; 
	
	@Resource(name="agreeService")
	private AgreeService agreeService;
	
	@Resource(name="webService")
	private WebService webService;

	@Resource(name = "suitService")
	private SuitService suitService;

	@Resource(name = "mifService")
	private MifService mifService;
	
	@RequestMapping(value = "fileUpload.do")
	public void fileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		mtenMap.put("filePath", this.filePath);
		String fileTable = mtenMap.get("fileTable")==null?"":mtenMap.get("fileTable").toString();
		JSONObject result = new JSONObject();
		result = agreeService.fileUpload(mtenMap, multipartRequest);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "goAgreeMain.do")
	public String goAgreeMain(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("param", mtenMap);
		return "agree/agreeMain.web";
	}
	
	@RequestMapping(value = "goAgreeList.do")
	public String goAgreeList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String gbnid = mtenMap.get("gbnid")==null?"":mtenMap.get("gbnid").toString();
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("gbnid", gbnid);
		
		System.out.println("**************************************");
		System.out.println("**************************************");
		System.out.println(mtenMap.get("MENU_MNG_NO"));
		// 협약 최초 접근, 필수심사대상 폴더 클릭 100000594
		// 기타 -> 100000595
		// 시의회 -> 100000596
		System.out.println("**************************************");
		System.out.println("**************************************");
		
		return "agree/agreeList.frm";
	}
	
	@RequestMapping(value = "selectAgreeList.do")
	public void selectAgreeList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
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
		
		JSONObject jl = agreeService.selectAgreeList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "agreeWritePage.do")
	public String agreeWritePage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap fMap = new HashMap();
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		
		String MENU_TTL = agreeService.getCvtnCtrtTypeNm(mtenMap);
		model.addAttribute("MENU_TTL", agreeService.getCvtnCtrtTypeNm(mtenMap));
		
		HashMap agreeMap = new HashMap();
		if(!CVTN_MNG_NO.equals("")) {
			agreeMap = agreeService.getAgreeDetail(mtenMap);
			
			String filese = "";
			if (MENU_TTL.indexOf("의회") > -1) {
				filese = "VIEW3";
			} else if (MENU_TTL.indexOf("기타계약") > -1) {
				filese = "VIEW2";
			} else {
				// 필수심사
				filese = "VIEW1";
			}
			
			fMap = new HashMap();
			fMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_MNG");
			//fMap.put("FILE_SE", "RQST");
			fMap.put("ordgbn", "RQST"+","+filese);
			List agreeRqstFile = agreeService.getFileList(fMap);
			model.addAttribute("agreeRqstFile", agreeRqstFile);
		} else {
			model.addAttribute("getCvtnCtrtTypeNm", agreeService.getCvtnCtrtTypeNm(mtenMap));
		}
		model.addAttribute("agreeMap", agreeMap);
		
		String url = "";
		if (MENU_TTL.indexOf("의회") > -1) {
			url = "agree/agreeWrite3.frm";
		} else if (MENU_TTL.indexOf("기타계약") > -1) {
			url = "agree/agreeWrite2.frm";
		} else {
			// 필수심사
			url = "agree/agreeWrite1.frm";
		}
		
		return url;
	}
	
	@RequestMapping(value = "agreeView.do")
	public String agreeView(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap agreeMap = agreeService.getAgreeDetail(mtenMap);
		model.addAttribute("agreeMap", agreeMap);
		
		String MENU_TTL = agreeService.getCvtnCtrtTypeNm(mtenMap);
		model.addAttribute("MENU_TTL", agreeService.getCvtnCtrtTypeNm(mtenMap));
		
		String filese = "";
		if (MENU_TTL.indexOf("의회") > -1) {
			filese = "VIEW3";
		} else if (MENU_TTL.indexOf("기타계약") > -1) {
			filese = "VIEW2";
		} else {
			// 필수심사
			filese = "VIEW1";
		}
		
		HashMap taskMap = new HashMap();
		taskMap = new HashMap();
		taskMap.put("EMP_NO", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
		taskMap.put("TASK_SE", "A3");
		taskMap.put("DOC_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		taskMap.put("PRCS_YN", "Y");
		mifService.setTask(taskMap);
		
		taskMap.put("TASK_SE", "A4");
		mifService.setTask(taskMap);
		
		taskMap.put("TASK_SE", "A6");
		mifService.setTask(taskMap);
		
		HashMap fMap = new HashMap();
		fMap.put("CVTN_MNG_NO",     mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_MNG");
		//fMap.put("FILE_SE", "RQST");
		fMap.put("ordgbn", "RQST"+","+filese);
		List agreeRqstFile = agreeService.getFileList(fMap);
		model.addAttribute("agreeRqstFile", agreeRqstFile);
		
		// 자문 외부위원 목록 조회
		List consultLawyerList = agreeService.selectAgreeLawyerList(mtenMap);
		model.addAttribute("consultLawyerList", consultLawyerList);
		
		// 자문 답변 내용 조회 
		List opinionlist = agreeService.selectAnswerBoard(mtenMap);
		model.addAttribute("opinionlist", opinionlist);
		
		// 자문 회신 파일 목록 조회
		fMap = new HashMap();
		fMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_RVW_OPNN");
		fMap.put("FILE_SE", "OPNN");
		List opinionFilelist = agreeService.getFileList(fMap);
		model.addAttribute("opinionFilelist", opinionFilelist);
		
		model.addAttribute("writer",   mtenMap.get("writer"));
		model.addAttribute("writerid", mtenMap.get("writerid"));
		model.addAttribute("deptname", mtenMap.get("sdeptname"));
		model.addAttribute("deptid",   mtenMap.get("sdeptid"));
		model.addAttribute("MENU_MNG_NO",   mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("Menuid",   filePath);
		
		System.out.println("여기까지는 문제 없나??11");
		
		mtenMap.put("CNSTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		List satisList = agreeService.getProcSatisList(mtenMap);
		int satisListCnt = satisList.size();
		if ( satisListCnt > 0 ) {
			satisList = agreeService.getSatisfactionList(mtenMap);
		}
		model.addAttribute("satisList", satisList);
		
		fMap = new HashMap();
		fMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_MNG");
		fMap.put("FILE_SE", "RES");
		List agreeResultFile = agreeService.getFileList(fMap);
		model.addAttribute("agreeResultFile", agreeResultFile);
		
		// 협약 답변 검토 의견 파일 목록 조회
		HashMap rCMap = new HashMap();
		rCMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO"));
		rCMap.put("FILE_SE", "ANSWERCOMMENT");
		List reviewCommentFileList = agreeService.getFileList(rCMap);
		model.addAttribute("reviewCommentFileList", reviewCommentFileList);
		
		HashMap relMap = new HashMap();
		relMap.put("PK", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		HashMap relList = suitService.selectRelCase(relMap);
		
		model.addAttribute("relList", relList.get("list")==null?new ArrayList():(ArrayList)relList.get("list"));
		
		String url = "";
		if (MENU_TTL.indexOf("의회") > -1) {
			url = "agree/agreeView3.frm";
		} else if (MENU_TTL.indexOf("기타계약") > -1) {
			url = "agree/agreeView2.frm";
		} else {
			// 필수심사
			url = "agree/agreeView1.frm";
		}
		
		return url;
	}
	
	@RequestMapping(value = "agreeViewPop.do")
	public String agreeViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		String url = "";
		int roleChk = 0;
		
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		
		if (Grpcd.indexOf("Y") > -1 || Grpcd.indexOf("G") > -1 || Grpcd.indexOf("A") > -1 || 
				Grpcd.indexOf("N") > -1 || Grpcd.indexOf("R") > -1 || Grpcd.indexOf("F") > -1) {
			// 전체관리자 or 협약관리자
			roleChk = 1;
		} else {
			// 그 외 일반사용자
			roleChk = agreeService.getAgreeRole(mtenMap);
		}
		
		if (roleChk > 0) {
			model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
			model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
			model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
			model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
			model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
			
			HashMap agreeMap = agreeService.getAgreeDetail(mtenMap);
			model.addAttribute("agreeMap", agreeMap);
			
			mtenMap.put("MENU_MNG_NO", agreeMap.get("MENU_MNG_NO")==null?"":agreeMap.get("MENU_MNG_NO").toString());
			
			String MENU_TTL = agreeService.getCvtnCtrtTypeNm(mtenMap);
			model.addAttribute("MENU_TTL", agreeService.getCvtnCtrtTypeNm(mtenMap));
			
			String filese = "";
			if (MENU_TTL.indexOf("의회") > -1) {
				filese = "VIEW3";
			} else if (MENU_TTL.indexOf("기타계약") > -1) {
				filese = "VIEW2";
			} else {
				// 필수심사
				filese = "VIEW1";
			}
			
			HashMap taskMap = new HashMap();
			taskMap = new HashMap();
			taskMap.put("EMP_NO", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
			taskMap.put("TASK_SE", "A3");
			taskMap.put("DOC_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			taskMap.put("PRCS_YN", "Y");
			mifService.setTask(taskMap);
			
			taskMap.put("TASK_SE", "A4");
			mifService.setTask(taskMap);
			
			taskMap.put("TASK_SE", "A6");
			mifService.setTask(taskMap);
			
			HashMap fMap = new HashMap();
			fMap.put("CVTN_MNG_NO",     mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_MNG");
			//fMap.put("FILE_SE", "RQST");
			fMap.put("ordgbn", "RQST"+","+filese);
			List agreeRqstFile = agreeService.getFileList(fMap);
			model.addAttribute("agreeRqstFile", agreeRqstFile);
			
			// 자문 외부위원 목록 조회
			List consultLawyerList = agreeService.selectAgreeLawyerList(mtenMap);
			model.addAttribute("consultLawyerList", consultLawyerList);
			
			// 자문 답변 내용 조회 
			List opinionlist = agreeService.selectAnswerBoard(mtenMap);
			model.addAttribute("opinionlist", opinionlist);
			
			// 자문 회신 파일 목록 조회
			fMap = new HashMap();
			fMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_RVW_OPNN");
			fMap.put("FILE_SE", "OPNN");
			List opinionFilelist = agreeService.getFileList(fMap);
			model.addAttribute("opinionFilelist", opinionFilelist);
			
			model.addAttribute("writer",   mtenMap.get("writer"));
			model.addAttribute("writerid", mtenMap.get("writerid"));
			model.addAttribute("deptname", mtenMap.get("sdeptname"));
			model.addAttribute("deptid",   mtenMap.get("sdeptid"));
			model.addAttribute("MENU_MNG_NO",   mtenMap.get("MENU_MNG_NO"));
			model.addAttribute("Menuid",   filePath);
			
			System.out.println("여기까지는 문제 없나??11");
			
			mtenMap.put("CNSTN_MNG_NO", mtenMap.get("consultid"));
			List satisList = agreeService.getProcSatisList(mtenMap);
			int satisListCnt = satisList.size();
			if ( satisListCnt > 0 ) {
				satisList = agreeService.getSatisfactionList(mtenMap);
			}
			model.addAttribute("satisList", satisList);
			
			fMap = new HashMap();
			fMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_MNG");
			fMap.put("FILE_SE", "RES");
			List agreeResultFile = agreeService.getFileList(fMap);
			model.addAttribute("agreeResultFile", agreeResultFile);
			
			mtenMap.put("MENU_MNG_NO", agreeMap.get("MENU_MNG_NO")==null?"":agreeMap.get("MENU_MNG_NO").toString());
			
			if (MENU_TTL.indexOf("의회") > -1) {
				url = "agree/agreeViewPop3.frm";
			} else if (MENU_TTL.indexOf("기타계약") > -1) {
				url = "agree/agreeViewPop2.frm";
			} else {
				// 필수심사
				url = "agree/agreeViewPop1.frm";
			}
		} else {
			url = "/common/noRole.err";
		}
		
		return url;
	}
	
	@RequestMapping(value = "agreeSave.do")
	public void agreeSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.agreeSave(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="updateAgreeState.do")
	public ModelAndView updateAgreeState(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.updateAgreeState(mtenMap);
		return addResponseData(result);
	}
	@RequestMapping(value="updateAgreeState2.do")
	public ModelAndView updateAgreeState2(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.updateAgreeState2(mtenMap);
		return addResponseData(result);
	}
	
	@RequestMapping(value="updateAgreeOpenyn.do")
	public ModelAndView updateAgreeOpenyn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.updateAgreeOpenyn(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="updateAgreeInout.do")
	public ModelAndView updateAgreeInout(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.updateAgreeInout(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="agreeDelete.do")
	public ModelAndView agreeDelete(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.agreeDelete(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="selectAgreeEmp.do")
	public String selectAgreeEmp(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		System.out.println("팝업에서 mtenMap 뭐로 오나  :::::  " + mtenMap.toString());
		List empList = this.agreeService.selectAgreeEmp(mtenMap);
		model.addAttribute("empList",     empList);
		model.addAttribute("gbn",         mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString());
		model.addAttribute("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO"));
		model.addAttribute("writer",      mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid",    mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname",    mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",      mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO")==null?"":mtenMap.get("MENU_MNG_NO"));
		
		return "agree/selectAgreeEmpPop.pop";
	}
	
	@RequestMapping(value="setChrgEmpState.do") 
	public void setChrgEmpState(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		JSONObject jl = this.agreeService.setChrgEmpState(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="selectAgreeRvwPicPop.do")
	public String selectAgreeRvwPicPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String pageno = mtenMap.get("pageno")==null?"":mtenMap.get("pageno").toString();
		//mtenMap.put("pagesize", "10");
		if(pageno.equals("")) {
			mtenMap.put("pageno", "1");
		}
		
		String pagesize = "9999";
		String schOrd = mtenMap.get("schOrd")==null?"":mtenMap.get("schOrd").toString();
		if (!schOrd.equals("")) {
			pagesize = schOrd;
		}
		
		mtenMap.put("pagesize", pagesize);
		
		List agreeLawyerList = agreeService.selectAgreeLawyerList(mtenMap);
		List lawyerList = agreeService.selectLawyerList2(mtenMap);
		int tot = agreeService.selectLawyerTotal(mtenMap);
		
		model.put("agreeLawyerList", agreeLawyerList);
		model.put("lawyerList", lawyerList);
		model.put("tot", tot);
		model.put("office", mtenMap.get("office")==null?"":mtenMap.get("office").toString());
		
		model.addAttribute("schOrd", mtenMap.get("schOrd")==null?"":mtenMap.get("schOrd").toString());
		model.addAttribute("writer", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO"));
		model.addAttribute("INSD_OTSD_TASK_SE", mtenMap.get("INSD_OTSD_TASK_SE"));
		model.addAttribute("lawyerid", mtenMap.get("lawyerid")==null?"":mtenMap.get("lawyerid").toString());
		model.addAttribute("lawyernm", mtenMap.get("lawyernm")==null?"":mtenMap.get("lawyernm").toString());
		
		return "agree/selectAgreeRvwPicPop.pop";
	}
	
	@RequestMapping(value="agreeLawInfoSave.do")
	public ModelAndView agreeLawInfoSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.agreeLawInfoSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="deleteAgreeLawyer.do") 
	public void deleteAgreeLawyer(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = agreeService.deleteAgreeLawyer2(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="agreeAnswerWritePop.do")
	public String agreeAnswerWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String RVW_OPNN_MNG_NO = mtenMap.get("RVW_OPNN_MNG_NO")==null?"":mtenMap.get("RVW_OPNN_MNG_NO").toString();
		
		// 자문 답변 수정 화면 호출 시
		if(!RVW_OPNN_MNG_NO.equals("") && RVW_OPNN_MNG_NO.length() > 0) {
			// 자문 답변 내용 조회
			HashMap answer = agreeService.selectAgreeAnswerView(mtenMap);
			model.put("answer", answer);
			
			// 자문 답변 첨부파일 목록 조회
			HashMap fMap = new HashMap();
			fMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", mtenMap.get("RVW_OPNN_MNG_NO")==null?"":mtenMap.get("RVW_OPNN_MNG_NO").toString());
			fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_RVW_OPNN");
			fMap.put("FILE_SE", "OPNN");
			List agreeOpnnFile = agreeService.getFileList(fMap);
			model.addAttribute("filelist", agreeOpnnFile);
		}
		
		// 자문 위원 목록 조회
		List agreeLawyerList = agreeService.selectAgreeLawyerList(mtenMap);
		model.put("agreeLawyerList", agreeLawyerList);
		
		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
		
		model.addAttribute("CVTN_MNG_NO",       mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		model.addAttribute("INSD_OTSD_TASK_SE", mtenMap.get("INSD_OTSD_TASK_SE")==null?"":mtenMap.get("INSD_OTSD_TASK_SE").toString());
		model.addAttribute("RVW_OPNN_MNG_NO",   mtenMap.get("RVW_OPNN_MNG_NO")==null?"":mtenMap.get("RVW_OPNN_MNG_NO").toString());
		model.addAttribute("CVTN_CTRT_TYPE_CD_NM",   mtenMap.get("CVTN_CTRT_TYPE_CD_NM")==null?"":mtenMap.get("CVTN_CTRT_TYPE_CD_NM").toString());
		return "agree/agreeAnswerWritePop.pop";
	}
	
	@RequestMapping(value="answerSave.do")
	public ModelAndView answerSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		mtenMap.put("Grpcd",Grpcd);
		
		JSONObject result = agreeService.answerSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="deleteAnswer.do")
	public void deleteAnswer(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.deleteAnswer(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="answerResultSave.do")
	public ModelAndView answerResultSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.answerResultSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value = "selectMemoList.do")
	public void selectProgList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = agreeService.selectMemoList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="agreeMemoWritePop.do")
	public String agreeMemoWritePop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String CVTN_MEMO_MNG_NO = mtenMap.get("CVTN_MEMO_MNG_NO")==null?"":mtenMap.get("CVTN_MEMO_MNG_NO").toString();
		// 자문 진행상태 수정 화면 호출 시
		if(!CVTN_MEMO_MNG_NO.equals("0") && CVTN_MEMO_MNG_NO.length() > 0) {
			// 내용 조회
			HashMap memo = agreeService.selectAgreeMemoView(mtenMap);
			model.put("memo", memo);
			
			HashMap fMap = new HashMap();
			fMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
			fMap.put("TRGT_PST_MNG_NO", CVTN_MEMO_MNG_NO);
			fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_MEMO");
			fMap.put("FILE_SE", "");
			List memoFile = agreeService.getFileList(fMap);
			model.addAttribute("filelist", memoFile);
		}
		
		model.addAttribute("CVTN_MEMO_MNG_NO", mtenMap.get("CVTN_MEMO_MNG_NO"));
		model.addAttribute("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO"));
		
		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
		return "agree/agreeMemoWritePop.pop";
	}
	
	// 자문 메모 등록
	@RequestMapping(value="saveMemoInfo.do")
	public ModelAndView saveMemoInfo(Map<String, Object> mtenMap, HttpServletRequest request, HttpServletResponse response) {
		request.setAttribute("logMap", mtenMap);
		
		HttpSession session = request.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		mtenMap.put("Grpcd",Grpcd);
		
		JSONObject result = agreeService.saveMemoInfo(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 자문 메모 상세 및 관리 팝업 호출
	@RequestMapping(value = "agreeMemoViewPop.do")
	public String agreeMemoViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String CVTN_MEMO_MNG_NO = mtenMap.get("CVTN_MEMO_MNG_NO")==null?"":mtenMap.get("CVTN_MEMO_MNG_NO").toString();
		model.addAttribute("CVTN_MEMO_MNG_NO", CVTN_MEMO_MNG_NO);
		model.addAttribute("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO"));
		
		model.addAttribute("writer", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid", mtenMap.get("WRT_DEPT_NO"));
		

		HashMap taskMap = new HashMap();
		taskMap = new HashMap();
		taskMap.put("EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
		taskMap.put("TASK_SE", "A5");
		taskMap.put("DOC_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		taskMap.put("PRCS_YN", "Y");
		mifService.setTask(taskMap);
		
		// 내용 조회
		HashMap memo = agreeService.selectAgreeMemoView(mtenMap);
		model.put("memo", memo);
		
		// 첨부파일 목록 조회
		HashMap fMap = new HashMap();
		fMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_MNG_NO", CVTN_MEMO_MNG_NO);
		fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_MEMO");
		fMap.put("FILE_SE", "");
		List memoFile = agreeService.getFileList(fMap);
		model.addAttribute("filelist", memoFile);
		return "agree/agreeMemoViewPop.pop";
	}
	
	// 자문 메모 삭제 (반려도 같이 쓸듯)
	@RequestMapping(value="deleteMemo.do")
	public void deleteMemo(Map<String, Object> mtenMap, HttpServletRequest request, HttpServletResponse response) {
		request.setAttribute("logMap", mtenMap);
		JSONObject result = agreeService.deleteMemo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="satisfactionMng.do")
	public String satisfactionMng(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		
		return "agree/satisfactionMng.frm";
	}
	
	@RequestMapping(value = "caseSatisWritePop.do")
	public String caseSatisWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("DGSTFN_ANS_MNG_NO", mtenMap.get("DGSTFN_ANS_MNG_NO"));
		model.addAttribute("TRGT_PST_MNG_NO", mtenMap.get("TRGT_PST_MNG_NO"));
		model.addAttribute("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		// 설문 항목 목록
		List satisList = agreeService.getSatisfactionList(mtenMap);
		model.addAttribute("satisList", satisList);
		// 대리인 목록
		List lawyerList = agreeService.getLawyerList2(mtenMap);
		model.addAttribute("lawyerList", lawyerList);
		// 
		List procSatisList = agreeService.getProcSatisList(mtenMap);
		model.addAttribute("procSatisList", procSatisList);
		// 
		List satisItemList = agreeService.getSatisitemList2(mtenMap);
		model.addAttribute("satisItemList", satisItemList);
		
		return "agree/agreeSatisWritePop.pop";
	}
	

	@RequestMapping(value="agreeResultWritePop.do")
	public String agreeResultWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		HashMap result = agreeService.getAgreeDetail(mtenMap);
		model.put("result", result);
		
		HashMap fMap = new HashMap();
		fMap.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_MNG");
		fMap.put("FILE_SE", "RES");
		List agreeResultFile = agreeService.getFileList(fMap);
		model.addAttribute("agreeResultFile", agreeResultFile);
		
		return "agree/agreeResultWritePop.pop";
	}
	
	@RequestMapping(value="agreeResultSave.do")
	public ModelAndView agreeResultSave(Map<String, Object> mtenMap, HttpServletRequest request, HttpServletResponse response) {
		request.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.agreeResultSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	

	@RequestMapping(value="setAgreeCost.do")
	public ModelAndView setAgreeCost(Map<String, Object> mtenMap, HttpServletRequest request, HttpServletResponse response) {
		request.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.setAgreeCost(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="setCostInfo.do")
	public ModelAndView setCostInfo(Map<String, Object> mtenMap, HttpServletRequest request, HttpServletResponse response) {
		request.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.setCostInfo(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value = "agreeFilter.do")
	public void agreeFilter(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model){
		
		System.out.println("mtenMap값 뭐로 나오는가? " + mtenMap.toString());
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		String userId = userInfo.get("USERID")==null?"":userInfo.get("USERID").toString();
		String userDeptCd = userInfo.get("DEPTCD")==null?"":userInfo.get("DEPTCD").toString();
		
		mtenMap.put("userDeptCd", userDeptCd);
		
		int totalCnt = agreeService.selectStateTotalCnt(mtenMap);
		List stateCnt = agreeService.selectStateCnt(mtenMap);
		System.out.println("stateCnt값 뭐로 나오는가? " + stateCnt.toString());
		
		HashMap statusCountMap = new HashMap<>();
		if (stateCnt != null && !stateCnt.isEmpty()) {
			for (int i = 0; i < stateCnt.size(); i++) {
				HashMap row = (HashMap) stateCnt.get(i);
				String status = row.get("PRGRS_STTS_SE_NM")==null?"":row.get("PRGRS_STTS_SE_NM").toString();
				String count = row.get("CNT")==null?"0":row.get("CNT").toString();
				statusCountMap.put(status, count);
			}
			
//		} else {
//		    System.out.println("stateCnt가 null이거나 비어 있음");
		}
		
		JSONArray jl = new JSONArray();
		
		JSONArray next = new JSONArray();
		JSONObject jo = new JSONObject();
		jo.put("id", "A100");
		jo.put("label", "전체");
//		jo.put("count", 5);
		jo.put("count", totalCnt);
		next.add("B100");
		jo.put("next", next);
//		jo.put("icon", "admin_bt1.gif");
//		jo.put("icon", awesomeVal.get("H100"));
		jo.put("icon", mtenMap.get("awesomeVal[A100]"));
		jl.add(jo);
		
		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "B100");
		jo.put("label", "작성중");
//		jo.put("count", 5);
		jo.put("count", statusCountMap.getOrDefault("작성중", 0));
		next.add("C100");
		jo.put("next", next);
//		jo.put("icon", awesomeVal.get("I100"));
		jo.put("icon", mtenMap.get("awesomeVal[B100]"));
		jl.add(jo);

		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "C100");
		jo.put("label", "접수대기");
//		jo.put("count", 5);
		jo.put("count", statusCountMap.getOrDefault("접수대기", 0));
		next.add("D100");
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[C100]"));
		jl.add(jo);
		
		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "D100");
		jo.put("label", "접수");
		jo.put("count", statusCountMap.getOrDefault("접수", 0));
		next.add("E1100");
//		next.add("E2100");
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[D100]"));
		jl.add(jo);
		
		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "E1100");
		jo.put("label", "내부검토중");
		jo.put("count", statusCountMap.getOrDefault("내부검토중", 0));
//		next.add("C100");
//		next.add("G100");
		next.add("E2100");
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[E1100]"));
		jl.add(jo);
		
		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "E2100");
		jo.put("label", "외부검토중");
		jo.put("count", statusCountMap.getOrDefault("외부검토중", 0));
		next.add("F100");
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[E2100]"));
		jl.add(jo);
		
		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "F100");
		jo.put("label", "답변완료");
		jo.put("count", statusCountMap.getOrDefault("답변완료", 0));
		next.add("G100");
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[F100]"));
		jl.add(jo);
		
		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "G100");
		jo.put("label", "결재중");
		jo.put("count", statusCountMap.getOrDefault("결재중", 0));
		next.add("H100");
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[G100]"));
		jl.add(jo);
		
		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "H100");
		jo.put("label", "완료");
		jo.put("count", statusCountMap.getOrDefault("완료", 0));
		next.add("I100");
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[H100]"));
		jl.add(jo);
		
		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "I100");
		jo.put("label", "만족도평가필요");
		jo.put("count", statusCountMap.getOrDefault("만족도평가필요", 0));
//		next.add("H100");
		next.add("J100");
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[I100]"));
		jl.add(jo);
		
		next = new JSONArray();
		jo = new JSONObject();
		jo.put("id", "J100");
		jo.put("label", "철회");
		jo.put("count", statusCountMap.getOrDefault("철회", 0));
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[J100]"));
		jl.add(jo);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 협약 답변  검토 의견 등록 팝업 호출
	@RequestMapping(value="agreeReviewCommentWritePop.do")
	public String agreeReviewCommentWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String checkVal = mtenMap.get("checkVal")==null?"":mtenMap.get("checkVal").toString();
		
		// 협약 답변 검토 의견 수정 화면 호출 시
		if(!checkVal.equals("") && checkVal.length() > 0) {
			// 협약 답변 검토 의견 내용 조회
			HashMap reviewComment = agreeService.selectAgreeReviewComment(mtenMap);
			model.put("reviewComment", reviewComment);
			
			// 협약 답변 검토 의견 첨부파일 목록 조회
			mtenMap.put("FILE_SE", "ANSWERCOMMENT");
			List rcfilelist = agreeService.getFileList(mtenMap);
			model.put("rcfilelist", rcfilelist);
		}
		
		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("CVTN_MNG_NO",   mtenMap.get("CVTN_MNG_NO"));
		model.addAttribute("checkVal",   checkVal);
//		model.addAttribute("Menuid",   mtenMap.get("Menuid"));
		return "agree/agreeReviewCommentWritePop.pop";
	}
	
	// 협약 답변  검토 의견 저장
	@RequestMapping(value="saveReviewComment.do")
	public ModelAndView saveReviewComment(Map<String, Object> mtenMap, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		mtenMap.put("Grpcd",Grpcd);
		
		JSONObject result = agreeService.saveReviewComment(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 자문 답변  검토 의견 삭제 
	@RequestMapping(value="agreeReviewCommentDelete.do")
	public void agreeReviewCommentDelete(Map<String, Object> mtenMap, HttpServletRequest request, HttpServletResponse response){
		JSONObject result = agreeService.deleteReviewComment(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	

	@RequestMapping(value = "goAgreeChrgCost.do")
	public String goAgreeChrgCost(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		// List 담아 보내기
		List list = agreeService.selectAgreeChrgCost(mtenMap);
		model.addAttribute("costList", list);
		
		return "/agree/agreeChrgCost.frm";
	}
	
	@RequestMapping(value = "updateChrgLawyerAmt.do")
	public void updateChrgLawyerAmt(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.agreeService.updateChrgLawyerAmt(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "updateChrgLawyerAmtList.do")
	public void updateChrgLawyerAmtList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filepath", this.filePath);
		JSONObject result = this.agreeService.updateChrgLawyerAmtList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 협약 의뢰자 변경 팝업 호출
	@RequestMapping(value="agreeRqstChangWritePop.do")
	public String agreeRqstChangWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		String CVTN_RQST_EMP_NO = mtenMap.get("CVTN_RQST_EMP_NO")==null?"":mtenMap.get("CVTN_RQST_EMP_NO").toString();
		List empList = agreeService.selectRqstChangEmpList(mtenMap);
		model.addAttribute("empList",   empList);
		model.addAttribute("CVTN_MNG_NO",   CVTN_MNG_NO);
		model.addAttribute("CVTN_RQST_EMP_NO",   CVTN_RQST_EMP_NO);
		model.addAttribute("srchTxt",     mtenMap.get("srchTxt")==null?"":mtenMap.get("srchTxt").toString());
		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
//		model.addAttribute("Menuid",   mtenMap.get("Menuid"));
		return "agree/agreeRqstChangWritePop.pop";
	}
	
	// 협약 의뢰자 변경
	@RequestMapping(value="agreeRqstChang.do") 
	public void setRqstEmp(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		JSONObject jl = agreeService.agreeRqstChang(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	
	
	
	
	
	@RequestMapping(value="insertSatisfaction.do")
	public void insertSatisfaction(HttpServletRequest req, HttpServletResponse response) {
	    response.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json; charset=UTF-8");

	    try {
	        // JSON 바디 직접 읽기
	        StringBuilder sb = new StringBuilder();
	        BufferedReader reader = req.getReader();
	        String line;
	        while ((line = reader.readLine()) != null) {
	            sb.append(line);
	        }

	        String jsonStr = sb.toString();
	        System.out.println("수신된 JSON: " + jsonStr);

	        org.json.simple.parser.JSONParser parser = new org.json.simple.parser.JSONParser();
	        org.json.simple.JSONObject jsonObj = (org.json.simple.JSONObject) parser.parse(jsonStr);
	        org.json.simple.JSONArray jsonArr = (org.json.simple.JSONArray) jsonObj.get("data");

	        int saveRes = agreeService.insertSatisfaction(jsonArr);

	        org.json.simple.JSONObject result = new org.json.simple.JSONObject();
	        result.put("result", saveRes);

	        PrintWriter pw = response.getWriter();
	        pw.println(result.toJSONString());
	        pw.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	        try {
	            response.getWriter().println("{\"result\":-1}");
	        } catch (IOException ioEx) {
	            ioEx.printStackTrace();
	        }
	    }
	}
	
	
	
	@RequestMapping(value="sendSatisAlert.do")
	public ModelAndView sendSatisAlert(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.sendSatisAlert(mtenMap);
		return addResponseData(result);
	}
	
	
	
	@RequestMapping(value="updateKeyword.do")
	public ModelAndView updateKeyword(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = agreeService.updateKeyword(mtenMap);
		return addResponseData(result);
	}
}
