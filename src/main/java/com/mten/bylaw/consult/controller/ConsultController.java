package com.mten.bylaw.consult.controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.GZIPOutputStream;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.agree.service.AgreeService;
import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.consult.Constants;
import com.mten.bylaw.consult.service.ConsultService;

import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.mif.serviceSch.MifService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.util.CommonMakeExcel;
import com.mten.util.Json4Ajax;
import com.mten.util.JsonHelper;
import com.mten.util.zipFileDownload;
import com.mten.bylaw.web.service.WebService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;	

@Controller
@RequestMapping("/web/consult/")
public class ConsultController extends DefaultController{
	
	@Resource(name="cousultService")
	private ConsultService consultService;
	
	@Resource(name="webService")
	private WebService webService;
	
	@Resource(name="bylawService")
	private BylawService bylawService;

	@Resource(name = "suitService")
	private SuitService suitService;
	
	@Resource(name = "agreeService")
	private AgreeService agreeService;

	@Resource(name = "mifService")
	private MifService mifService;
	
	@Value("#{fileinfo['mten.CONSULT']}")
	public String filePath;
	
	@Value("#{fileinfo['mten.TEMP']}")
	public String tempPath;
	
	zipFileDownload zip = new zipFileDownload();
	
	// 자문 메인 호출
	@RequestMapping(value="goConsultMain.do")
	public String goConsultMain(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("param", mtenMap);
		return "consult/consultMain.web";
	}
	// 자문 메인 호출 END
	
	
	// List Frame 호출
	@RequestMapping(value="goConsultList.do")  //자문의뢰리스트
	public String goConsultList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("Constants", Constants.Counsel.TYPE_GNLR);
		return "consult/consultList.frm";
	}
	
	@RequestMapping(value="goOldConsultList.do")  //자문의뢰리스트
	public String goOldConsultList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("Constants", Constants.Counsel.TYPE_GNLR);
		return "consult/consultOldList.frm";
	}
	
	@RequestMapping(value="researchPop.do")//만족도조사 화면
	public String researchPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("consultid", mtenMap.get("consultid"));
		return "/consult/research.pop";
	}
	
	// 이전 부터 있던 파일 일괄 다운로드 기능 메서드 인데 활용 가능 여부 판단 위해 남겨놓기 
	@RequestMapping(value = "listFileDownload.do")
	public void listFileDownload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest, HttpServletRequest req, HttpServletResponse response) {
		List<Map<String, Object>> fList = consultService.listFileDownload(mtenMap);
		zip.listFileDownload(req, response, fList, filePath, "일괄다운로드", tempPath);
	}
	
	// 자문 목록 데이터
	@RequestMapping(value="consultListData.do")
	public void consultListData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		mtenMap.put("grpcd", userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString());
		
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
		JSONObject result = consultService.consultListData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="consultListExcel.do")
	public void consultListExcel(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		mtenMap.put("grpcd", userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString());
		
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
		
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		
		JSONObject result = consultService.consultListData(mtenMap);
		List datalist = JsonHelper.toList((JSONArray)result.get("result"));
		
		String sTit = "자문";
		
		ArrayList<String> columnList = new ArrayList<String>(); // 데이터컬럼명
		ArrayList<String> columnRList = new ArrayList<String>(); // 화면용컬럼명
		
		columnRList.add("관리번호");
		columnRList.add("접수일");
		columnRList.add("제목");
		columnRList.add("의뢰부서");
		columnRList.add("의뢰자");
		columnRList.add("담당변호사");
		columnRList.add("처리상태");
		columnRList.add("자문유형");
		columnRList.add("자문구분");
		
		columnList.add("CNSTN_DOC_NO");
		columnList.add("CNSTN_RCPT_YMD");
		columnList.add("CNSTN_TTL");
		columnList.add("MANAGER_DEPT_NM");
		columnList.add("CNSTN_RQST_EMP_NM");
		if ("none".equals(gbn)) {
			// 마스킹 없음
			columnList.add("JDAF_CORP_NMS");
		} else {
			// 마스킹 처리
			columnList.add("JDAF_CORP_EMP_NMS2");
		}
		columnList.add("PRGRS_STTS_SE_NM");
		columnList.add("INOUTHAN");
		columnList.add("CNSTN_SE_NM");
		
		CommonMakeExcel.makeExcel(sTit, columnList, columnRList, datalist, req, response);
	}
	
	// 자문 상세 화면 이동
	@RequestMapping(value="consultView.do")
	public String consultView(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		if(userInfo==null) {
			urlInfo = "/common/nossion.frm";	//세션이 없어 로그인 페이지로 다이렉트 이동
		}else {
			String WRTR_EMP_NO = mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString();
			String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
			mtenMap.put("docid", mtenMap.get("consultid"));
			mtenMap.put("rolegbn", "CONSULT");
			
			int roleCnt = 1;//webService.getRoleChk(mtenMap);//권한 테이블에서 권한 확인
			if(Grpcd.indexOf("Y")>-1 || Grpcd.indexOf("J")>-1 || roleCnt>0) {
				// 자문 상세정보 조회
				HashMap map = consultService.getConsultInfo(mtenMap);
				model.addAttribute("consultinfo", map);
				
				HashMap taskMap = new HashMap();
				taskMap = new HashMap();
				taskMap.put("EMP_NO", WRTR_EMP_NO);
				taskMap.put("TASK_SE", "C3");
				taskMap.put("DOC_MNG_NO", mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString());
				taskMap.put("PRCS_YN", "Y");
				mifService.setTask(taskMap);
				
				taskMap.put("TASK_SE", "C4");
				mifService.setTask(taskMap);
				
				taskMap.put("TASK_SE", "C6");
				mifService.setTask(taskMap);
				
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
				fMap.put("chckid", mtenMap.get("consultid"));
				fMap.put("filegbn", "ANSWER");
				List opinionFilelist = consultService.getAnswerFileList(fMap);
				model.addAttribute("opinionFilelist", opinionFilelist);
				
				model.addAttribute("writer",   mtenMap.get("writer"));
				model.addAttribute("writerid", mtenMap.get("writerid"));
				model.addAttribute("deptname", mtenMap.get("sdeptname"));
				model.addAttribute("deptid",   mtenMap.get("sdeptid"));
				model.addAttribute("MENU_MNG_NO",   mtenMap.get("MENU_MNG_NO"));
				model.addAttribute("Menuid",   filePath);
				
				mtenMap.put("CNSTN_MNG_NO", mtenMap.get("consultid"));
				List satisList = consultService.getProcSatisList(mtenMap);
				int satisListCnt = satisList.size();
				if ( satisListCnt > 0 ) {
					satisList = consultService.getSatisfactionList(mtenMap);
				}
				model.addAttribute("satisList", satisList);
				
				// 자문 답변 검토 의견 파일 목록 조회
				HashMap rCMap = new HashMap();
				rCMap.put("chckid", mtenMap.get("consultid"));
				rCMap.put("filegbn", "ANSWERCOMMENT");
				List reviewCommentFileList = consultService.getAnswerFileList(rCMap);
				model.addAttribute("reviewCommentFileList", reviewCommentFileList);
				
				HashMap relMap = new HashMap();
				relMap.put("PK", mtenMap.get("consultid"));
				HashMap relList = suitService.selectRelCase(relMap);
				
				model.addAttribute("relList", relList.get("list"));
				
				urlInfo = "/consult/consultView.frm";
			}else {
				urlInfo = "/common/norole.frm";	//접근 권한이 없다는 메세지 페이지로 이동
			}
		}
		return urlInfo;
	}
	
	@RequestMapping(value="consultOldView.do")
	public String consultOldView(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		if(userInfo==null) {
			urlInfo = "/common/nossion.frm";	//세션이 없어 로그인 페이지로 다이렉트 이동
		}else {
			String WRTR_EMP_NO = mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString();
			String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
			mtenMap.put("docid", mtenMap.get("consultid"));
			mtenMap.put("rolegbn", "CONSULT");
			
			int roleCnt = 1;//webService.getRoleChk(mtenMap);//권한 테이블에서 권한 확인
			if(Grpcd.indexOf("Y")>-1 || Grpcd.indexOf("J")>-1 || roleCnt>0) {
				// 자문 상세정보 조회
				HashMap map = consultService.getConsultInfo(mtenMap);
				model.addAttribute("consultinfo", map);
				
				HashMap taskMap = new HashMap();
				taskMap = new HashMap();
				taskMap.put("EMP_NO", WRTR_EMP_NO);
				taskMap.put("TASK_SE", "C3");
				taskMap.put("DOC_MNG_NO", mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString());
				taskMap.put("PRCS_YN", "Y");
				mifService.setTask(taskMap);
				
				taskMap.put("TASK_SE", "C4");
				mifService.setTask(taskMap);
				
				taskMap.put("TASK_SE", "C6");
				mifService.setTask(taskMap);
				
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
				
				model.addAttribute("writer",   mtenMap.get("writer"));
				model.addAttribute("writerid", mtenMap.get("writerid"));
				model.addAttribute("deptname", mtenMap.get("sdeptname"));
				model.addAttribute("deptid",   mtenMap.get("sdeptid"));
				model.addAttribute("MENU_MNG_NO",   mtenMap.get("MENU_MNG_NO"));
				model.addAttribute("Menuid",   filePath);
				
				mtenMap.put("CNSTN_MNG_NO", mtenMap.get("consultid"));
				List satisList = consultService.getProcSatisList(mtenMap);
				int satisListCnt = satisList.size();
				if ( satisListCnt > 0 ) {
					satisList = consultService.getSatisfactionList(mtenMap);
				}
				model.addAttribute("satisList", satisList);
				
				// 자문 답변 검토 의견 파일 목록 조회
				HashMap rCMap = new HashMap();
				rCMap.put("chckid", mtenMap.get("consultid"));
				rCMap.put("filegbn", "ANSWERCOMMENT");
				List reviewCommentFileList = consultService.getAnswerFileList(rCMap);
				model.addAttribute("reviewCommentFileList", reviewCommentFileList);
				
				HashMap relMap = new HashMap();
				relMap.put("PK", mtenMap.get("consultid"));
				HashMap relList = suitService.selectRelCase(relMap);
				
				model.addAttribute("relList", relList.get("list"));
				
				urlInfo = "/consult/consultOldView.frm";
			}else {
				urlInfo = "/common/norole.frm";	//접근 권한이 없다는 메세지 페이지로 이동
			}
		}
		return urlInfo;
	}
	
	@RequestMapping(value="consultWritePage.do")
	public String consultWritePage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		if(userInfo==null) {
			urlInfo = "/common/nossion.frm";	//세션이 없어 로그인 페이지로 다이렉트 이동
		}else {
			String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
			mtenMap.put("docid", mtenMap.get("consultid"));
			mtenMap.put("rolegbn", "CONSULT");
			int roleCnt = 1;//webService.getRoleChk(mtenMap);//권한 테이블에서 권한 확인
			if(Grpcd.indexOf("Y")>-1 || Grpcd.indexOf("J")>-1 || roleCnt>0) {
				if(mtenMap.get("consultid")!=null && !mtenMap.get("consultid").equals("")) {
					String consultid = mtenMap.get("consultid").toString();
					// 자문 의뢰 기본 정보
					HashMap map = consultService.getConsultInfo(mtenMap);
					model.addAttribute("consultinfo", map);
					
					// 자문의뢰 파일 조회
					mtenMap.put("filegbn", "CONSULT");
					List fileList = consultService.getFileList2(mtenMap);
					model.addAttribute("fileList", fileList);

					
					
					model.addAttribute("consultid", consultid);
					model.addAttribute("writer", mtenMap.get("writer"));
					model.addAttribute("writerid", mtenMap.get("writerid"));
					model.addAttribute("deptname", mtenMap.get("sdeptname"));
					model.addAttribute("deptid", mtenMap.get("sdeptid"));
					model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
				}else {
					
					System.out.println("????123123???? : " + mtenMap.toString());
					// 부서장 정보조회
					HashMap map2 = consultService.getDeptHeadInfo(mtenMap);
					model.addAttribute("deptHeadinfo", map2);
				}
				urlInfo = "/consult/consultWrite.frm";
			}else {
				urlInfo = "/common/norole.frm";	//접근 권한이 없다는 메세지 페이지로 이동
			}
		}
		return urlInfo;
	}
	

	// 자문 의뢰 기본 정보 저장
	@RequestMapping(value="consultSave.do")
	public ModelAndView consultSave(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.consultSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 자문 의뢰 기본 파일 저장
	@RequestMapping(value = "fileUploadconsult.do") // ajax에서 호출하는 부분
	@ResponseBody
	public void upload(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest, HttpServletRequest req, HttpServletResponse response) { // Multipart로
		req.setAttribute("logMap", mtenMap);
		
		System.out.println("mtenMap==>"+mtenMap);
		System.out.println("mten==>"+multipartRequest.getParameter("DOCTITLE"));
		System.out.println("filePath==>"+filePath);
		mtenMap.put("filePath", filePath);
		
		JSONObject jr = consultService.saveFile(multipartRequest, mtenMap);
		
		Json4Ajax.commonAjax(jr, response);
	}
	
	// 자문 의뢰 진행상태 변경
	@RequestMapping(value="updateConsultState.do")
	public ModelAndView updateConsultState(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.updateConsultState(mtenMap);
		return addResponseData(result);
	}
	// 자문 의뢰 진행상태 변경
	@RequestMapping(value="updateConsultState2.do")
	public ModelAndView updateConsultState2(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.updateConsultState2(mtenMap);
		return addResponseData(result);
	}
	
	 // 자문 의뢰 공개 여부 변경
	@RequestMapping(value="updateConsultOpenyn.do")
	public ModelAndView updateConsultOpenyn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.updateConsultOpenyn(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 자문 정보 삭제
	@RequestMapping(value="consultDelete.do")
	public ModelAndView consultDelete(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.consultDelete(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 자문 담당자 관리 팝업 호출
	@RequestMapping(value="selectConsultEmpPop.do")
	public String selectChrgEmpPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		
		List empList = consultService.selectChrgEmpList(mtenMap);
		model.addAttribute("empList", empList);
		model.addAttribute("gbn", mtenMap.get("gbn"));
		model.addAttribute("consultid", mtenMap.get("consultid"));
		model.addAttribute("writer", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		return "/consult/selectConsultEmpPop.pop";
	}

	// 자문 담당자 관리 팝업 호출
	@RequestMapping(value="selectRqstDeptManagerPop.do")
	public String selectRqstDeptManagerPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		
		List managerList = consultService.selectRqstDeptManagerList(mtenMap);
		model.addAttribute("managerList", managerList);
		model.addAttribute("gbn",         mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString());
		model.addAttribute("srchTxt",     mtenMap.get("srchTxt")==null?"":mtenMap.get("srchTxt").toString());
		model.addAttribute("consultid",   mtenMap.get("consultid"));
		model.addAttribute("writer",      mtenMap.get("writer"));
		model.addAttribute("writerid",    mtenMap.get("writerid"));
		model.addAttribute("deptname",    mtenMap.get("sdeptname"));
		model.addAttribute("deptid",      mtenMap.get("sdeptid"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		
		return "/consult/selectRqstDeptManagerPop.pop";
	}
	
	// 자문 담당자 변경(상태 변경 필요한지 모르겠음. 상태 변경까지)
	@RequestMapping(value="setChrgEmpState.do") 
	public void setChrgEmpState(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		JSONObject jl = consultService.setChrgEmpState(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	//  자문검토담당자 지정 팝업 호출
	@RequestMapping(value="selectConsultRvwPicPop.do")
	public String selectConsultRvwPicPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String pageno = mtenMap.get("pageno")==null?"":mtenMap.get("pageno").toString();
//		mtenMap.put("pagesize", "10");
		if(pageno.equals("")) {
			mtenMap.put("pageno", "1");
		}
		
		String pagesize = "9999";
		String schOrd = mtenMap.get("schOrd")==null?"":mtenMap.get("schOrd").toString();
		if (!schOrd.equals("")) {
			pagesize = schOrd;
		}
		
		mtenMap.put("pagesize", pagesize);
		
		
		List consultLawyerList = consultService.selectConsultLawyerList(mtenMap);
		List lawyerList = consultService.selectLawyerList2(mtenMap);
		int tot = consultService.selectLawyerTotal(mtenMap);
		
		model.put("consultLawyerList", consultLawyerList);
		model.put("lawyerList", lawyerList);
		model.put("tot", tot);
		model.put("office", mtenMap.get("office")==null?"":mtenMap.get("office").toString());
		
		model.addAttribute("schOrd", mtenMap.get("schOrd")==null?"":mtenMap.get("schOrd").toString());
		model.addAttribute("writer", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid", mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("lawyerid", mtenMap.get("lawyerid")==null?"":mtenMap.get("lawyerid").toString());
		model.addAttribute("lawyernm", mtenMap.get("lawyernm")==null?"":mtenMap.get("lawyernm").toString());
		
		return "/consult/selectConsultRvwPicPop.pop";
	}
	
	// 외부 자문 검토자 저장
	@RequestMapping(value="consultLawInfoSave.do")
	public ModelAndView consultLawInfoSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.consultLawInfoSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 외부 자문 검토자 삭제
	@RequestMapping(value="deleteConsultLawyer.do") 
	public void deleteConsultLawyer(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject jl = consultService.deleteConsultLawyer2(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 자문 메모 목록 조회
	@RequestMapping(value = "selectMemoList.do")
	public void selectProgList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = consultService.selectMemoList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 자문 메모 등록 팝업 호출
	@RequestMapping(value="consultMemoWritePop.do")
	public String consultMemoWritePop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String CNSTN_MEMO_MNG_NO = mtenMap.get("CNSTN_MEMO_MNG_NO")==null?"":mtenMap.get("CNSTN_MEMO_MNG_NO").toString();
		String CNSTN_MNG_NO = mtenMap.get("CNSTN_MNG_NO")==null?"":mtenMap.get("CNSTN_MNG_NO").toString();
		
		// 자문 진행상태 수정 화면 호출 시
		if(!CNSTN_MEMO_MNG_NO.equals("0") && CNSTN_MEMO_MNG_NO.length() > 0) {
			// 내용 조회
			HashMap memo = consultService.selectConsultMemoView(mtenMap);
			model.put("memo", memo);
			
			// 첨부파일 목록 조회
			HashMap fileMap = new HashMap();
			fileMap.put("CNSTN_MNG_NO", CNSTN_MNG_NO);
			fileMap.put("TRGT_PST_MNG_NO", CNSTN_MEMO_MNG_NO);
			fileMap.put("filegbn", "CMEMO");
			List confileList = consultService.getAnswerFileList(fileMap);
			model.put("filelist", confileList);
		}
		
		model.addAttribute("CNSTN_MEMO_MNG_NO", mtenMap.get("CNSTN_MEMO_MNG_NO"));
		model.addAttribute("CNSTN_MNG_NO", mtenMap.get("CNSTN_MNG_NO"));
		
		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
//		model.addAttribute("Menuid",   mtenMap.get("Menuid"));
		return "consult/consultMemoWritePop.pop";
	}
	
	// 자문 메모 등록
	@RequestMapping(value="saveMemoInfo.do")
	public ModelAndView saveMemoInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response ){
		req.setAttribute("logMap", mtenMap);
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		mtenMap.put("Grpcd",Grpcd);
		
		JSONObject result = consultService.saveMemoInfo(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 자문 메모 상세 및 관리 팝업 호출
	@RequestMapping(value = "consultMemoViewPop.do")
	public String consultMemoViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		model.addAttribute("CNSTN_MEMO_MNG_NO", mtenMap.get("CNSTN_MEMO_MNG_NO"));
		model.addAttribute("CNSTN_MNG_NO", mtenMap.get("CNSTN_MNG_NO"));
		
		model.addAttribute("writer", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid", mtenMap.get("WRT_DEPT_NO"));
		//model.addAttribute("menuid", mtenMap.get("menuid"));
		
		HashMap taskMap = new HashMap();
		taskMap = new HashMap();
		taskMap.put("EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
		taskMap.put("TASK_SE", "C5");
		taskMap.put("DOC_MNG_NO", mtenMap.get("CNSTN_MNG_NO")==null?"": mtenMap.get("CNSTN_MNG_NO").toString());
		taskMap.put("PRCS_YN", "Y");
		mifService.setTask(taskMap);
		
		// 내용 조회
		HashMap memo = consultService.selectConsultMemoView(mtenMap);
		model.put("memo", memo);
		
		// 첨부파일 목록 조회
		HashMap fileMap = new HashMap();
		fileMap.put("CNSTN_MNG_NO", mtenMap.get("CNSTN_MNG_NO")==null?"":mtenMap.get("CNSTN_MNG_NO").toString());
		fileMap.put("TRGT_PST_MNG_NO", mtenMap.get("CNSTN_MEMO_MNG_NO")==null?"":mtenMap.get("CNSTN_MEMO_MNG_NO").toString());
		fileMap.put("filegbn", "CMEMO");
		List confileList = consultService.getAnswerFileList(fileMap);
		model.put("filelist", confileList);
		
//		consultService.updateProgHit(mtenMap);
		
		return "consult/consultMemoViewPop.pop";
	}
	
	// 자문 메모 삭제 (반려도 같이 쓸듯)
	@RequestMapping(value="deleteMemo.do")
	public void deleteMemo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.deleteMemo(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 자문 답변 등록 팝업 호출
	@RequestMapping(value="consultAnswerWritePop.do")
	public String consultAnswerWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
//		String chckid = mtenMap.get("chckid")==null?"":mtenMap.get("chckid").toString();
//		String consultid = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String RVW_OPNN_MNG_NO = mtenMap.get("RVW_OPNN_MNG_NO")==null?"":mtenMap.get("RVW_OPNN_MNG_NO").toString();
		String CNSTN_MNG_NO = mtenMap.get("CNSTN_MNG_NO")==null?"":mtenMap.get("CNSTN_MNG_NO").toString();
		String inoutcon = mtenMap.get("inoutcon")==null?"":mtenMap.get("inoutcon").toString();
		
		// 자문 답변 수정 화면 호출 시
		if(!RVW_OPNN_MNG_NO.equals("") && RVW_OPNN_MNG_NO.length() > 0) {
			// 자문 답변 내용 조회
			HashMap answer = consultService.selectConsultAnswerView(mtenMap);
			model.put("answer", answer);
			
//			// 자문 답변 첨부파일 목록 조회
//			mtenMap.put("filegbn", "ANSWER");
			HashMap fileMap = new HashMap();
			fileMap.put("CNSTN_MNG_NO", CNSTN_MNG_NO);
			fileMap.put("TRGT_PST_MNG_NO", RVW_OPNN_MNG_NO);
			fileMap.put("filegbn", "ANSWER");
			List confileList = consultService.getAnswerFileList(fileMap);
			model.put("filelist", confileList);
		}
		
		// 자문 위원 목록 조회
		List consultLawyerList = consultService.selectConsultLawyerList(mtenMap);
		model.put("consultLawyerList", consultLawyerList);
		
		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
//		model.addAttribute("Menuid",   mtenMap.get("Menuid"));
//		model.addAttribute("inoutcon",   inoutcon);
		return "consult/consultAnswerWritePop.pop";
	}
	
	// 자문 답변 등록
	@RequestMapping(value="answerSave.do")
	public ModelAndView answerSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		mtenMap.put("Grpcd",Grpcd);
		
		JSONObject result = consultService.answerSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 자문 답변 삭제
	@RequestMapping(value="deleteAnswer.do")
	public void deleteAnswer(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.deleteAnswer(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 자문 답변결과 수정
	@RequestMapping(value="answerResultSave.do")
	public ModelAndView answerResultSave(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.answerResultSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 자문 답변 반려 등록 팝업 호출
	@RequestMapping(value="consultRejectWritePop.do")
	public String consultRejectWritePop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String memoid = mtenMap.get("memoid")==null?"":mtenMap.get("memoid").toString();
		
		// 자문 진행상태 수정 화면 호출 시
		if(!memoid.equals("0") && memoid.length() > 0) {
			// 내용 조회
			HashMap memo = consultService.selectConsultMemoView(mtenMap);
			model.put("memo", memo);
			
			// 첨부파일 목록 조회
			HashMap fileMap = new HashMap();
			fileMap.put("memoid", memoid);
			fileMap.put("filegbn", "CREJECT");
			List confileList = consultService.getAnswerFileList(fileMap);
			model.put("filelist", confileList);
		}
		
		model.addAttribute("memoid", mtenMap.get("memoid"));
		model.addAttribute("consultid", mtenMap.get("consultid"));
		model.addAttribute("stateCd", mtenMap.get("stateCd"));
		
		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
//		model.addAttribute("Menuid",   mtenMap.get("Menuid"));
		return "consult/consultRejectWritePop.pop";
	}
	
	// 자문 답변 반려 상세 및 관리 팝업 호출
	@RequestMapping(value = "consultRejectViewPop.do")
	public String consultRejectViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		
		model.addAttribute("memoid", mtenMap.get("memoid"));
		model.addAttribute("consultid", mtenMap.get("consultid"));
		
		model.addAttribute("writer", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid", mtenMap.get("WRT_DEPT_NO"));
//		model.addAttribute("menuid", mtenMap.get("menuid"));
		
		// 내용 조회
		HashMap memo = consultService.selectConsultMemoView(mtenMap);
		model.put("memo", memo);
		
		// 첨부파일 목록 조회
		HashMap fileMap = new HashMap();
		fileMap.put("memoid", mtenMap.get("memoid")==null?"":mtenMap.get("memoid").toString());
		fileMap.put("filegbn", "CREJECT");
		List confileList = consultService.getAnswerFileList(fileMap);
		model.put("filelist", confileList);
		
//		consultService.updateProgHit(mtenMap);
		
		return "consult/consultRejectViewPop.pop";
	}
	
	@RequestMapping(value="setConsultRvwPic.do") 
	public void setConsultRvwPic(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		JSONObject jl = consultService.setConsultRvwPic(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
//	// 자문 비용 등록 팝업 호출
//	@RequestMapping(value="consultCstInfoRegPop.do")
//	public String consultCstInfoRegPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
//		String chckid = mtenMap.get("chckid")==null?"":mtenMap.get("chckid").toString();
//		
//		// 자문 비용 정보 수정 화면 호출 시
//		if(!chckid.equals("") && chckid.length() > 0) {
//			// 자문 비용 정보 내용 조회
//			HashMap answer = consultService.selectConsultCstInfoView(mtenMap);
//			model.put("answer", answer);
//			
//			// 자문 비용 정보 첨부파일 목록 조회
//			mtenMap.put("filegbn", "COST");
//			List confileList = consultService.getAnswerFileList(mtenMap);
//			model.put("filelist", confileList);
//		}
//		
//		// 자문 위원 목록 조회
//		List consultLawyerList = consultService.selectConsultLawyerList(mtenMap);
//		model.put("consultLawyerList", consultLawyerList);
//		
//		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
//		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
//		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
//		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
////		model.addAttribute("Menuid",   mtenMap.get("Menuid"));
//		return "consult/consultCstInfoRegPop.pop";
//	}
	
	@RequestMapping(value = "caseSatisWritePop.do")
	public String caseSatisWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("DGSTFN_ANS_MNG_NO", mtenMap.get("DGSTFN_ANS_MNG_NO"));
		model.addAttribute("TRGT_PST_MNG_NO", mtenMap.get("TRGT_PST_MNG_NO"));
		model.addAttribute("CNSTN_MNG_NO", mtenMap.get("CNSTN_MNG_NO"));
		
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		// 설문 항목 목록
		List satisList = consultService.getSatisfactionList(mtenMap);
		model.addAttribute("satisList", satisList);
		// 대리인 목록
		List lawyerList = consultService.getLawyerList2(mtenMap);
		model.addAttribute("lawyerList", lawyerList);
		// 
		List procSatisList = consultService.getProcSatisList(mtenMap);
		model.addAttribute("procSatisList", procSatisList);
		// 
		List satisItemList = consultService.getSatisitemList2(mtenMap);
		model.addAttribute("satisItemList", satisItemList);
		
		return "/consult/consultSatisWritePop.pop";
	}
	
	@RequestMapping(value="setConsultCost.do")
	public ModelAndView setConsultCost(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.setConsultCost(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	@RequestMapping(value="setCostInfo.do")
	public ModelAndView setCostInfo(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.setCostInfo(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	

	@RequestMapping(value = "consultFilter.do")
	public void consultFilter(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model){
		
		System.out.println("mtenMap값 뭐로 나오는가? " + mtenMap.toString());
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		String userId = userInfo.get("USERID")==null?"":userInfo.get("USERID").toString();
		String userDeptCd = userInfo.get("DEPTCD")==null?"":userInfo.get("DEPTCD").toString();
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		
		mtenMap.put("userDeptCd", userDeptCd);
		
		int totalCnt = consultService.selectStateTotalCnt(mtenMap);
		List stateCnt = consultService.selectStateCnt(mtenMap);
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
		if(Grpcd.indexOf("Y")>-1) {
			next.add("B100");
		}else {
			next.add("C100");
		}
		jo.put("next", next);
//		jo.put("icon", "admin_bt1.gif");
//		jo.put("icon", awesomeVal.get("H100"));
		jo.put("icon", mtenMap.get("awesomeVal[A100]"));
		jl.add(jo);
		
		if(Grpcd.indexOf("Y")>-1) {
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
		}
		
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
//		next.add("I100");
		next.add("J100");
		jo.put("next", next);
		jo.put("icon", mtenMap.get("awesomeVal[H100]"));
		jl.add(jo);
		
//		next = new JSONArray();
//		jo = new JSONObject();
//		jo.put("id", "I100");
//		jo.put("label", "만족도평가필요");
//		jo.put("count", statusCountMap.getOrDefault("만족도평가필요", 0));
////		next.add("H100");
//		next.add("J100");
//		jo.put("next", next);
//		jo.put("icon", mtenMap.get("awesomeVal[I100]"));
//		jl.add(jo);
		
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
	
	
	
	// 구두자문 목록 이동 
	@RequestMapping(value="goVerbalAdviceList.do")  //자문의뢰리스트
	public String goVerbalAdviceList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		model.addAttribute("Constants", Constants.Counsel.TYPE_GNLR);
		return "consult/verbalAdviceList.frm";
	}
	
	// 구두자문 목록 데이터
	@RequestMapping(value="verbalAdviceListData.do")
	public void verbalAdviceListData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
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
		JSONObject result = consultService.verbalAdviceListData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 구두 자문 등록 화면 이동
	@RequestMapping(value="verbalAdviceWritePage.do")
	public String verbalAdviceWritePage(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		if(userInfo==null) {
			urlInfo = "/common/nossion.frm";	//세션이 없어 로그인 페이지로 다이렉트 이동
		}else {
			String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
			mtenMap.put("docid", mtenMap.get("consultid"));
			mtenMap.put("rolegbn", "CONSULT");
			int roleCnt = 1;//webService.getRoleChk(mtenMap);//권한 테이블에서 권한 확인
			if(Grpcd.indexOf("Y")>-1 || Grpcd.indexOf("J")>-1 || roleCnt>0) {
				if(mtenMap.get("consultid")!=null && !mtenMap.get("consultid").equals("")) {
					String consultid = mtenMap.get("consultid").toString();
					// 자문 의뢰 기본 정보
					HashMap map = consultService.getConsultInfo(mtenMap);
					model.addAttribute("consultinfo", map);
					
					// 자문의뢰 파일 조회
					mtenMap.put("filegbn", "CONSULT");
					List fileList = consultService.getFileList2(mtenMap);
					model.addAttribute("fileList", fileList);
					
					model.addAttribute("consultid", consultid);
					model.addAttribute("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
				}
				urlInfo = "/consult/verbalAdviceWrite.frm";
			}else {
				urlInfo = "/common/norole.frm";	//접근 권한이 없다는 메세지 페이지로 이동
			}
		}
		return urlInfo;
	}
	
	// 구두자문 기본 정보 저장
	@RequestMapping(value="verbalAdviceSave.do")
	public ModelAndView verbalAdviceSave(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.verbalAdviceSave(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 구두 자문 상세 화면 이동
	@RequestMapping(value="verbalAdviceView.do")
	public String verbalAdviceView(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		if(userInfo==null) {
			urlInfo = "/common/nossion.frm";	//세션이 없어 로그인 페이지로 다이렉트 이동
		}else {
			String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
			mtenMap.put("docid", mtenMap.get("consultid"));
			mtenMap.put("rolegbn", "CONSULT");
			int roleCnt = 1;//webService.getRoleChk(mtenMap);//권한 테이블에서 권한 확인
			if(Grpcd.indexOf("Y")>-1 || Grpcd.indexOf("J")>-1 || roleCnt>0) {
				// 구두 자문 상세정보 조회
				HashMap map = consultService.getConsultInfo(mtenMap);
				model.addAttribute("consultinfo", map);
				
				// 자문 요청 파일 목록 조회
				mtenMap.put("filegbn", "CONSULT");
				List confileList = consultService.getFileList2(mtenMap);
				model.addAttribute("confileList", confileList);
				
				model.addAttribute("writer",   mtenMap.get("writer"));
				model.addAttribute("writerid", mtenMap.get("writerid"));
				model.addAttribute("deptname", mtenMap.get("sdeptname"));
				model.addAttribute("deptid",   mtenMap.get("sdeptid"));
				model.addAttribute("MENU_MNG_NO",   mtenMap.get("MENU_MNG_NO"));
				urlInfo = "/consult/verbalAdviceView.frm";
			}else {
				urlInfo = "/common/norole.frm";	//접근 권한이 없다는 메세지 페이지로 이동
			}
		}
		return urlInfo;
	}
	
	// 구두 자문 정보 삭제
	@RequestMapping(value="verbalAdviceDelete.do")
	public ModelAndView verbalAdviceDelete(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.verbalAdviceDelete(mtenMap);
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 구두 자문 직원 선택 팝업 호출
	@RequestMapping(value = "searchDeptPop.do")
	public String searchDeptPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String menu = mtenMap.get("menu") == null ? "" : mtenMap.get("menu").toString();
		String cnt = mtenMap.get("cnt") == null ? "0" : mtenMap.get("cnt").toString();
		String deptno = mtenMap.get("deptno") == null ? "6110000" : mtenMap.get("deptno").toString();
		String reviewid = mtenMap.get("reviewid") == null ? "0" : mtenMap.get("reviewid").toString();
		model.addAttribute("menu", menu);
		model.addAttribute("CNT", cnt);
		model.addAttribute("deptno", deptno);
		model.addAttribute("reviewid", reviewid);
		return "/consult/searchDeptPop.pop";
	}
	
	// 구두 자문 직원 선택 팝업 부서 목록
	@RequestMapping(value="getDeptList.do")
	public void getDeptList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONArray jl = consultService.getDeptList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 구두 자문 직원 선택 팝업 직원 목록
	@RequestMapping(value = "selectUserList.do")
	public void selectUserList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = consultService.selectUserList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value = "selectDeptList.do")
	public void selectDeptList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		JSONObject jl = consultService.selectDeptList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	// 자문 내/외부 유형 변경
	@RequestMapping(value="updateInsdOtsdTaskSe.do")
	public ModelAndView updateInsdOtsdTaskSe(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.updateInsdOtsdTaskSe(mtenMap);
		return addResponseData(result);
	}
	
	//업무현황 
	@RequestMapping(value = "consultViewPop.do")
	public String consultViewPop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		req.setAttribute("logMap", mtenMap);
		
		String urlInfo = "";
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap) session.getAttribute("userInfo");
		String url = "";
		int roleChk = 0;
		
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		
		if (Grpcd.indexOf("Y") > -1 || Grpcd.indexOf("G") > -1 || Grpcd.indexOf("J") > -1 || 
				Grpcd.indexOf("M") > -1 || Grpcd.indexOf("Q") > -1 || Grpcd.indexOf("F") > -1) {
			// 전체관리자 or 자문관리자
			roleChk = 1;
		} else {
			// 그 외 일반사용자
			roleChk = consultService.getConsultRole(mtenMap);
		}
		
		if(userInfo==null || roleChk == 0) {
			urlInfo = "/common/nossion.frm";	//세션이 없어 로그인 페이지로 다이렉트 이동
		} else {
			String WRTR_EMP_NO = mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString();
			//String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
			mtenMap.put("docid", mtenMap.get("consultid"));
			mtenMap.put("rolegbn", "CONSULT");
			int roleCnt = 1;//webService.getRoleChk(mtenMap);//권한 테이블에서 권한 확인
			if(Grpcd.indexOf("Y")>-1 || Grpcd.indexOf("J")>-1 || roleCnt>0) {
				
				HashMap map = consultService.getConsultInfo(mtenMap);
				model.addAttribute("consultinfo", map);
				
				HashMap taskMap = new HashMap();
				taskMap = new HashMap();
				taskMap.put("EMP_NO", WRTR_EMP_NO);
				taskMap.put("TASK_SE", "C3");
				taskMap.put("DOC_MNG_NO", mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString());
				taskMap.put("PRCS_YN", "Y");
				mifService.setTask(taskMap);
				
				taskMap.put("TASK_SE", "C4");
				mifService.setTask(taskMap);
				
				taskMap.put("TASK_SE", "C6");
				mifService.setTask(taskMap);
				
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
				fMap.put("chckid", mtenMap.get("consultid"));
				fMap.put("filegbn", "ANSWER");
				List opinionFilelist = consultService.getAnswerFileList(fMap);
				model.addAttribute("opinionFilelist", opinionFilelist);
				
				model.addAttribute("writer",   mtenMap.get("writer"));
				model.addAttribute("writerid", mtenMap.get("writerid"));
				model.addAttribute("deptname", mtenMap.get("sdeptname"));
				model.addAttribute("deptid",   mtenMap.get("sdeptid"));
				model.addAttribute("MENU_MNG_NO",   mtenMap.get("MENU_MNG_NO"));
				model.addAttribute("Menuid",   filePath);
				System.out.println("여기까지는 문제 없나??11");
				
				mtenMap.put("CNSTN_MNG_NO", mtenMap.get("consultid"));
				List satisList = consultService.getProcSatisList(mtenMap);
				int satisListCnt = satisList.size();
				if ( satisListCnt > 0 ) {
					satisList = consultService.getSatisfactionList(mtenMap);
				}
				model.addAttribute("satisList", satisList);
				
				urlInfo = "/consult/consultViewPop.frm";
			}else {
				urlInfo = "/common/norole.frm";	//접근 권한이 없다는 메세지 페이지로 이동
			}
		}
		return urlInfo;
	}
	
	// 자문 답변  검토 의견 등록 팝업 호출
	@RequestMapping(value="consultReviewCommentWritePop.do")
	public String consultReviewCommentWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String checkVal = mtenMap.get("checkVal")==null?"":mtenMap.get("checkVal").toString();
		
		// 자문 답변 검토 의견 수정 화면 호출 시
		if(!checkVal.equals("") && checkVal.length() > 0) {
			// 자문 답변 검토 의견 내용 조회
			HashMap reviewComment = consultService.selectConsultReviewComment(mtenMap);
			model.put("reviewComment", reviewComment);
			
			// 자문 답변 검토 의견 첨부파일 목록 조회
			mtenMap.put("filegbn", "ANSWERCOMMENT");
			List confileList = consultService.getAnswerFileList(mtenMap);
			model.put("rcfilelist", confileList);
		}
		
		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
		model.addAttribute("CNSTN_MNG_NO",   mtenMap.get("CNSTN_MNG_NO"));
		model.addAttribute("checkVal",   checkVal);
		model.addAttribute("inoutcon",   mtenMap.get("inoutcon"));
//		model.addAttribute("Menuid",   mtenMap.get("Menuid"));
		return "consult/consultReviewCommentWritePop.pop";
	}
	
	// 자문 답변  검토 의견 저장
	@RequestMapping(value="saveReviewComment.do")
	public ModelAndView saveReviewComment(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		HttpSession session = req.getSession();
		HashMap userInfo = (HashMap)session.getAttribute("userInfo"); 
		String Grpcd = userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString();
		mtenMap.put("Grpcd",Grpcd);
		
		JSONObject result = consultService.saveReviewComment(mtenMap);
		
//		String inoutcon = mtenMap.get("inoutcon")==null?"":mtenMap.get("inoutcon").toString();
//		if ("I".equals(inoutcon)) {
//			
//		}
		
		result.put("msg", "ok");
		return addResponseData(result);
	}
	
	// 자문 답변  검토 의견 삭제 
	@RequestMapping(value="consultReviewCommentDelete.do")
	public void consultReviewCommentDelete(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.deleteReviewComment(mtenMap);
		Json4Ajax.commonAjax(result, response);
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

	        int saveRes = consultService.insertSatisfaction(jsonArr);

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

	@RequestMapping(value = "goConsultChrgCost.do")
	public String goConsultChrgCost(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		model.addAttribute("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO"));
		
		// List 담아 보내기
		List list = consultService.selectConsultChrgCost(mtenMap);
		model.addAttribute("costList", list);
		
		return "/consult/consultChrgCost.frm";
	}
	
	@RequestMapping(value = "updateChrgLawyerAmt.do")
	public void updateChrgLawyerAmt(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filepath", filePath);
		JSONObject result = consultService.updateChrgLawyerAmt(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value = "updateChrgLawyerAmtList.do")
	public void updateChrgLawyerAmtList(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		mtenMap.put("filepath", filePath);
		JSONObject result = consultService.updateChrgLawyerAmtList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	// 자문 의뢰자 변경 팝업 호출
	@RequestMapping(value="consultRqstChangWritePop.do")
	public String consultRqstChangWritePop(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String consultid = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String cnstn_rqst_emp_no = mtenMap.get("cnstn_rqst_emp_no")==null?"":mtenMap.get("cnstn_rqst_emp_no").toString();
		List empList = consultService.selectRqstChangEmpList(mtenMap);
		model.addAttribute("empList",   empList);
		model.addAttribute("consultid",   consultid);
		model.addAttribute("cnstn_rqst_emp_no",   cnstn_rqst_emp_no);
		model.addAttribute("srchTxt",     mtenMap.get("srchTxt")==null?"":mtenMap.get("srchTxt").toString());
		model.addAttribute("writer",   mtenMap.get("WRTR_EMP_NM"));
		model.addAttribute("writerid", mtenMap.get("WRTR_EMP_NO"));
		model.addAttribute("deptname", mtenMap.get("WRT_DEPT_NM"));
		model.addAttribute("deptid",   mtenMap.get("WRT_DEPT_NO"));
//		model.addAttribute("Menuid",   mtenMap.get("Menuid"));
		return "consult/consultRqstChangWritePop.pop";
	}
	
	// 자문 의뢰자 변경
	@RequestMapping(value="consultRqstChang.do") 
	public void setRqstEmp(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) {
		JSONObject jl = consultService.consultRqstChang(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="sendSatisAlert.do")
	public ModelAndView sendSatisAlert(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.sendSatisAlert(mtenMap);
		return addResponseData(result);
	}
	
	@RequestMapping(value="sendSatisPop.do")//만족도조사 화면
	public String sendSatisPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		List docList = new ArrayList();
		
		String gbn = mtenMap.get("GBN")==null?"":mtenMap.get("GBN").toString();
		if ("CONSULT".equals(gbn)) {
			docList = consultService.getSatisSendConsultList();
		} else if ("AGREE".equals(gbn)) {
			docList = agreeService.getSatisSendAgreeList();
		}
		
		model.addAttribute("docList", docList);
		model.addAttribute("GBN", mtenMap.get("GBN"));
		return "/consult/sendSatisPop.pop";
	}
	
	

	@RequestMapping(value="sendSatisAlertList.do")
	public ModelAndView sendSatisAlertList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.sendSatisAlert(mtenMap);
		return addResponseData(result);
	}
	

	@RequestMapping(value="updateKeyword.do")
	public ModelAndView updateKeyword(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		req.setAttribute("logMap", mtenMap);
		
		JSONObject result = consultService.updateKeyword(mtenMap);
		return addResponseData(result);
	}
	
}

