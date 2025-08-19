package com.mten.bylaw.out.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mten.bylaw.agree.service.AgreeService;
import com.mten.bylaw.consult.service.ConsultService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONObject;


@Controller
@RequestMapping("/out/")
public class OutController extends DefaultController{
	
	@Resource(name = "suitService")
	private SuitService suitService;
	
	@Resource(name="cousultService")
	private ConsultService consultService;
	
	@Resource(name="agreeService")
	private AgreeService agreeService;
	
	@Value("#{fileinfo['mten.CONSULT']}")
	public String filePath;
	
	@RequestMapping("/login.do")
	public String index(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		return "login.out";
	}
	
	@RequestMapping("/cOtp.do")
	public String cOtp(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		return "cOtp.out";
	}
	
	@RequestMapping("/resetAcct.do")
	public String resetAcct(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		return "resetAcct.out";
	}

	@RequestMapping(value = "/loginChk.do")
	public void loginChk(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response)  {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = this.suitService.lawyerLoginChk(mtenMap, req);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "/cOtp2.do")
	public void cOtp2(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response)  {
		req.setAttribute("logMap", mtenMap);
		JSONObject result = this.suitService.cOtp2(mtenMap, req);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "/resetLwyrAcct.do")
	public void resetLwyrAcct(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response)  {
		req.setAttribute("logMap", mtenMap);
		JSONObject result = this.suitService.resetLwyrAcct(mtenMap, req);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/outMain.do")
	public String outMain(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		mtenMap.put("gbn", "out");
		
		HttpSession session = request.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		String lgnId = userInfo.get("LGN_ID")==null?"":userInfo.get("LGN_ID").toString();
		mtenMap.put("LGN_ID", lgnId);
		mtenMap.put("GRPCD", userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString());
		
		String pwchg = suitService.getPwChg(mtenMap);
		System.out.println(mtenMap);
		
		HashMap sCnt = suitService.getOutSuitCnt(mtenMap);
		//String consultCnt = consultService.getOutConsultCnt(mtenMap);
		HashMap cCnt = consultService.getOutConsultCnt(mtenMap);
		//String agreeCnt = suitservice.getOutSuitCnt(mtenMap);
		HashMap aCnt = agreeService.getOutAgreeCnt(mtenMap);
		
		model.addAttribute("sCnt", sCnt);
		model.addAttribute("cCnt", cCnt);
		model.addAttribute("aCnt", aCnt);
		
		model.addAttribute("pwchg", pwchg);
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "outMain.out";
	}
	
	@RequestMapping("/outSuitList.do")
	public String outSuitList(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/suit/outSuitList.out";
	}
	
	@RequestMapping("/outConsultList.do")
	public String outConsultList(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/consult/outConsultList.out";
	}
	
	@RequestMapping("/outAgreeList.do")
	public String outAgreeList(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		return "/agree/outAgreeList.out";
	}
	
	@RequestMapping("/outLawyerInfo.do")
	public String outLawyerInfo(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		request.setAttribute("logMap", mtenMap);
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		mtenMap.put("LWYR_MNG_NO", mtenMap.get("WRTR_EMP_NO").toString());
		model.addAttribute("map", mtenMap);
		HashMap lawyerMap = this.suitService.getLawyerDetail(mtenMap);
		model.addAttribute("lawyerMap", lawyerMap);
		return "/suit/outLawyerInfoEdit.out";
	}
	
	// 소송일반
	@RequestMapping(value = "/selectOutSuitList.do")
	public void selectOutSuitList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model)  {
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		if (userInfo == null) {
			urlInfo = "/web/common/nossion.out"; // 세션이 없어 로그인 페이지로 다이렉트 이동
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
		JSONObject jl = this.suitService.selectOutSuitList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 자문
	@RequestMapping(value = "/selectOutConsultList.do")
	public void selectOutConsultList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model)  {
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		if (userInfo == null) {
			urlInfo = "/web/common/nossion.out"; // 세션이 없어 로그인 페이지로 다이렉트 이동
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
		JSONObject jl = this.consultService.selectOutConsultList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "/selectOutAgreeList.do")
	public void selectOutAgreeList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model)  {
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		if (userInfo == null) {
			urlInfo = "/web/common/nossion.out"; // 세션이 없어 로그인 페이지로 다이렉트 이동
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
		JSONObject jl = this.agreeService.selectOutAgreeList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "/lawyerSuitViewPage.do")
	public String lawyerSuitViewPage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model)  {
		req.setAttribute("logMap", mtenMap);
		
		String SEL_INST_MNG_NO = mtenMap.get("SEL_INST_MNG_NO")==null?"":mtenMap.get("SEL_INST_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		
		HashMap suitMap = suitService.getSuitDetail(mtenMap);
		model.addAttribute("suitMap", suitMap);
		
		if (INST_MNG_NO.equals("")) {
			INST_MNG_NO = suitService.getInstMngNo(mtenMap);
			mtenMap.put("INST_MNG_NO", INST_MNG_NO);
		}
		
		if (!SEL_INST_MNG_NO.equals("")) {
			mtenMap.put("INST_MNG_NO", SEL_INST_MNG_NO);
		} else {
			SEL_INST_MNG_NO = INST_MNG_NO;
		}
		
		HashMap caseMap = suitService.getCaseDetail(mtenMap);
		model.addAttribute("caseMap", caseMap);
		
		List empList = suitService.getEmpInfo(mtenMap);
		model.addAttribute("empList", empList);
		
		HashMap resultMap = suitService.getCaseResultDetail(mtenMap);
		model.addAttribute("resultMap", resultMap);
		
		HashMap fMap = new HashMap();
		fMap.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
		fMap.put("TRGT_PST_MNG_NO", mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
		fMap.put("TRGT_PST_TBL_NM", "TB_LWS_MNG");
		fMap.put("FILE_SE", "CONF");
		List suitConfFile = suitService.getFileList(fMap);
		model.addAttribute("suitConfFile", suitConfFile);
		
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
		
		String RCPT_YN = suitService.getOutRcptYn(mtenMap);
		
		model.addAttribute("SEL_INST_MNG_NO", SEL_INST_MNG_NO);
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("RCPT_YN", RCPT_YN);
		model.addAttribute("focus", mtenMap.get("focus"));
		return "/suit/outSuitView.out";
	}
	
	// view ConsultView
	@RequestMapping(value="outConsultView.do")
	public String outConsultView(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model)  {
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		if(userInfo==null) {
			urlInfo = "/common/nossion.frm";	//세션이 없어 로그인 페이지로 다이렉트 이동
		} else {
			req.setAttribute("logMap", mtenMap);
			
			// 자문 상세정보 조회
			HashMap map = consultService.getConsultInfo(mtenMap);
			model.addAttribute("consultinfo", map);
			
			// 자문 요청 파일 목록 조회
			mtenMap.put("filegbn", "CONSULT");
			List confileList = consultService.getFileList2(mtenMap);
			model.addAttribute("confileList", confileList);
			
			// 자문 외부위원 목록 조회
			List consultLawyerList = consultService.selectConsultLawyerList(mtenMap);
			model.addAttribute("consultLawyerList", consultLawyerList);
			
			// 자문 답변 내용 조회 
			List opinionlist = consultService.selectAnswerBoard(mtenMap);
			model.addAttribute("opinionlist", opinionlist);
			
			// 자문 승인자 조회
			List agreelist = consultService.selectAgreeEmp();
			model.addAttribute("agreelist", agreelist); // 어떻게 사용 되는 것인지..
			
			// 자문 회신 파일 목록 조회 (추후 추가)
			HashMap fMap = new HashMap();
			fMap.put("consultid", mtenMap.get("consultid"));
			fMap.put("filegbn", "ANSWER");
			List opinionFilelist = consultService.getAnswerFileList(fMap);
			model.addAttribute("opinionFilelist", opinionFilelist);
			
			String RCPT_YN = consultService.getOutRcptYn(mtenMap);
			
			model.addAttribute("writer",        mtenMap.get("writer"));
			model.addAttribute("writerid",      mtenMap.get("writerid"));
			model.addAttribute("deptname",      mtenMap.get("sdeptname"));
			model.addAttribute("deptid",        mtenMap.get("sdeptid"));
			model.addAttribute("MENU_MNG_NO",   mtenMap.get("MENU_MNG_NO"));
			model.addAttribute("RCPT_YN",       RCPT_YN);
			model.addAttribute("Menuid",   filePath);
			System.out.println("여기까지는 문제 없나??11");
			
			mtenMap.put("CNSTN_MNG_NO", mtenMap.get("consultid"));
			List satisList = consultService.getProcSatisList(mtenMap);
			int satisListCnt = satisList.size();
			if ( satisListCnt > 0 ) {
				satisList = consultService.getSatisfactionList(mtenMap);
			}
			model.addAttribute("satisList", satisList);
			urlInfo = "/consult/outConsultView.out";
		}
		return urlInfo;
	}
	
	@RequestMapping(value = "outAgreeView.do")
	public String outAgreeView(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model)  {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		HashMap agreeMap = agreeService.getAgreeDetail(mtenMap);
		model.addAttribute("agreeMap", agreeMap);
		
		HashMap fMap = new HashMap();
		fMap.put("CVTN_MNG_NO",     mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		fMap.put("TRGT_PST_TBL_NM", "TB_CVTN_MNG");
		fMap.put("FILE_SE", "RQST");
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
		
		model.addAttribute("MENU_TTL", agreeService.getCvtnCtrtTypeNm(mtenMap));
		
		String RCPT_YN = agreeService.getOutRcptYn(mtenMap);
		model.addAttribute("RCPT_YN", RCPT_YN);
		
		return "agree/agreeView2.out";
	}
	
	@RequestMapping(value = "rfslRsnPop.do")
	public String rfslRsnPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model)  {
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("DOC_PK",      mtenMap.get("DOC_PK"));
		model.addAttribute("DOC_GBN",     mtenMap.get("DOC_GBN"));
		model.addAttribute("LWYR_NM",     mtenMap.get("LWYR_NM"));
		return "rfslRsnWritePop.pop";
	}
	
	@RequestMapping(value = "rfslRsnSave.do")
	public void rfslRsnSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		JSONObject result = new JSONObject();
		String DOC_GBN = mtenMap.get("DOC_GBN")==null?"":mtenMap.get("DOC_GBN").toString();
		if ("SUIT".equals(DOC_GBN)) {
			result = suitService.rfslRsnSave(mtenMap);
		} else if ("CONSULT".equals(DOC_GBN)) {
			result = consultService.rfslRsnSave(mtenMap);
		} else if ("AGREE".equals(DOC_GBN)) {
			result = agreeService.rfslRsnSave(mtenMap);
		}
		
		Json4Ajax.commonAjax(result, response);
	}
}
