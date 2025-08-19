package com.mten.bylaw.web.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.ConstantCode;
import com.mten.bylaw.admin.service.UserService;
import com.mten.bylaw.agree.service.AgreeService;
import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.consult.Constants;
import com.mten.bylaw.consult.service.ConsultService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.mif.AlertApi;
//import com.mten.bylaw.mif.AlertApi;
import com.mten.bylaw.pds.service.PdsService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.bylaw.web.service.WebService;
import com.mten.util.DateUtil;
import com.mten.util.Json4Ajax;
import com.mten.util.SMSClientSend;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import tcp.seoul.util.SeedScrtyUtil;

@Controller
@RequestMapping("/web/")
public class MainController extends DefaultController{
	@Resource(name="webService")
	private WebService webService;
	
	@Resource(name="pdsService")
	private PdsService pdsService;
	
	@Resource(name="bylawService")
	private BylawService bylawService;
	
	@Resource(name="agreeService")
	private AgreeService agreeService;
	
	@Resource(name="cousultService")
	private ConsultService consultService;
	
	@Resource(name = "suitService")
	private SuitService suitService;
	
	@Resource(name="userService")
	private UserService userService;
	
	@RequestMapping("/index.do")
	public String index(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		HttpSession session = request.getSession();
		String GRPCD = session.getAttribute("GRPCD")==null?"":session.getAttribute("GRPCD").toString();
		
		HashMap se = (HashMap)session.getAttribute("userInfo");
		String writerGrpcd = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
		String userId = se.get("USERID")==null?"":se.get("USERID").toString();
		mtenMap.put("Grpcd", writerGrpcd);
		
		if ((writerGrpcd.indexOf("Y") > -1)) {
			// 소송, 자문, 협약 진행중 건수
			model.addAttribute("cntY2", suitService.getMainYCnt2());
			
			// 진행중인 사건 목록
			mtenMap.put("TRMN_YN", "N");
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			model.addAttribute("list1", suitService.selectSuitMainList(mtenMap));
			
			// 진행중인 자문/협약 목록
			model.addAttribute("list2", suitService.selectConAgreeMainList(mtenMap));
			
			//공지사항
			mtenMap.put("MENU_MNG_NO", "10004325");
			model.addAttribute("notiPdsList", webService.pdsList(mtenMap));
			
			
			model.addAttribute("cntDate", suitService.getMainCalDataCnt(mtenMap));
			
			// 250619 메인 기일 건수 표기부터 확인하기
			model.addAttribute("cntDetailDate", suitService.getLeftDateMain(mtenMap));
			
		} else if ((writerGrpcd.indexOf("C") > -1)) {
			////// 소송
			// 미도래 기일(불변, 서면, 기일)
//			model.addAttribute("cnt1", suitService.getCnt1());
			// 소송 진행중 건수
			model.addAttribute("cnt2", suitService.getCnt2(userId));
			// 금일 일정 건수
//			model.addAttribute("cnt3", suitService.getCnt3());
			
			// 소송 진행중 목록
			mtenMap.put("TRMN_YN", "N");
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			//model.addAttribute("list1", suitService.selectSuitMainList(mtenMap));
			
			mtenMap.put("grpcd", writerGrpcd);
			model.addAttribute("list1", webService.selectMyWorkListMain(mtenMap));
			
			
			// 소송의뢰 접수요청 목록
			//mtenMap.put("PRGRS_STTS_NM", "접수요청");
			model.addAttribute("list2", suitService.selectSuitMainList(mtenMap));
			
			//공지사항
			mtenMap.put("MENU_MNG_NO", "10004325");
			model.addAttribute("notiPdsList", webService.pdsList(mtenMap));
			model.addAttribute("cntDate", suitService.getMainCalDataCnt(mtenMap));
			
		} else if ((writerGrpcd.indexOf("J") > -1) || (writerGrpcd.indexOf("M") > -1) || (writerGrpcd.indexOf("Q") > -1)) {
			////// 자문
			// 접수대기 건수
			model.addAttribute("cnt1", consultService.getCnt1());
			// 진행중 건수
			model.addAttribute("cnt2", consultService.getCnt2(userId));
			// 나의 할 일 건수
//			model.addAttribute("cnt3", consultService.getCnt1());
			
			// 접수대기 목록
			mtenMap.put("prgrs_stts_se_nm", "접수대기");
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			mtenMap.put("MENU_MNG_NO", "100000131");
//			mtenMap.put("orderby", "order by CNSTN_RCPT_YMD ASC"); // 접수요청 오래된 순으로 보려면 이거 넣어주기 
			model.addAttribute("list1", consultService.selectConsultMainList1(mtenMap));

			// 진행중인 자문 목록
			model.addAttribute("list2", consultService.selectConsultMainList2(mtenMap));
			
			//공지사항
			mtenMap.put("MENU_MNG_NO", "10004325");
			model.addAttribute("notiPdsList", webService.pdsList(mtenMap));
			
			
		} else if ((writerGrpcd.indexOf("A") > -1) || (writerGrpcd.indexOf("N") > -1) || (writerGrpcd.indexOf("R") > -1)) {
			
			////// 협약
			// 접수대기 건수
			model.addAttribute("cntA1", agreeService.getCnt1());
			// 진행중 건수
			model.addAttribute("cntA2", agreeService.getCnt2(userId));
			// 나의 할 일 건수
//			model.addAttribute("cnt3", agreeService.getCnt1());
			
			// 진행중인 협약 목록
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			model.addAttribute("list2", agreeService.selectAgreeMainList2(mtenMap));
//			mtenMap.put("orderby", "order by CNSTN_RCPT_YMD ASC"); // 접수요청 오래된 순으로 보려면 이거 넣어주기 

			// 접수대기 목록
			mtenMap.put("PRGRS_STTS_SE_NM", "접수대기");
			model.addAttribute("list1", agreeService.selectAgreeMainList1(mtenMap));
			
			//공지사항
			mtenMap.put("MENU_MNG_NO", "10004325");
			model.addAttribute("notiPdsList", webService.pdsList(mtenMap));
		
		} else if ((writerGrpcd.indexOf("D") > -1) || (writerGrpcd.indexOf("L") > -1)) { // 소장접수, 소송비용 권한

			// 담당자 미배정 건수
			model.addAttribute("cnt1", suitService.getMainLwsTkcgCnt());
			// 소송비용 지급 요청 건수
			model.addAttribute("cnt2", suitService.getMainLwsCstCnt());
			
			// 메인 담당자 미배정 목록
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			model.addAttribute("list1", suitService.selectMainLwsTkcgList(mtenMap));
//			mtenMap.put("orderby", "order by CNSTN_RCPT_YMD ASC"); // 접수요청 오래된 순으로 보려면 이거 넣어주기 
			// 메인 비용 미지급 목록
			model.addAttribute("list2", suitService.selectMainLwsCstList(mtenMap));
			
			//공지사항
			mtenMap.put("MENU_MNG_NO", "10004325");
			model.addAttribute("notiPdsList", webService.pdsList(mtenMap));
		
		} else if ((writerGrpcd.indexOf("E") > -1)) { // 소송비용회수권한
			////// 소송이랑 동일하게 일단 넣어둠
			// 미도래 기일(불변, 서면, 기일)
//			model.addAttribute("cnt1", suitService.getCnt1());
			// 소송 진행중 건수
			
			List list1 = suitService.selectBondMain1(mtenMap);
			List list2 = suitService.selectBondMain2(mtenMap);
			
			model.addAttribute("cnt1", list1.size());
			model.addAttribute("cnt2", list2.size());
			
			// 회수미완료
			mtenMap.put("TRMN_YN", "N");
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			model.addAttribute("list1", list1);
			
			// 미청구
			model.addAttribute("list2", list2);
			
			//공지사항
			mtenMap.put("MENU_MNG_NO", "10004325");
			model.addAttribute("notiPdsList", webService.pdsList(mtenMap));
		
		} else if ((writerGrpcd.indexOf("F") > -1) || (writerGrpcd.indexOf("B") > -1)) { // 자문료, 인지대 등 권한
			
			// 자문료 지급 요청 건수
			model.addAttribute("cnt1", consultService.getMainConCstCnt());
			// 소송비용 지급 요청 건수
			model.addAttribute("cnt2", suitService.getMainLwsCstCnt());
			
			// 메인 담당자 미배정 목록
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			model.addAttribute("list1", consultService.selectMainConCstList(mtenMap));
//			mtenMap.put("orderby", "order by CNSTN_RCPT_YMD ASC"); // 접수요청 오래된 순으로 보려면 이거 넣어주기 
			// 메인 비용 미지급 목록
			model.addAttribute("list2", suitService.selectMainLwsCstList(mtenMap));
			
			//공지사항
			mtenMap.put("MENU_MNG_NO", "10004325");
			model.addAttribute("notiPdsList", webService.pdsList(mtenMap));
		} else if ((writerGrpcd.indexOf("G") > -1)) { // 과장님 권한

			// 소송, 자문, 협약 진행중 건수
			model.addAttribute("cntY2", suitService.getMainYCnt2());
			
			// 진행중인 사건 목록
			mtenMap.put("TRMN_YN", "N");
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			model.addAttribute("list1", suitService.selectSuitMainList(mtenMap));
			
			// 진행중인 자문/협약 목록
			model.addAttribute("list2", suitService.selectConAgreeMainList(mtenMap));
			
			//공지사항
			mtenMap.put("MENU_MNG_NO", "10004325");
			model.addAttribute("notiPdsList", webService.pdsList(mtenMap));
			model.addAttribute("cntDate", suitService.getMainCalDataCnt(mtenMap));
			
		} else if ((writerGrpcd.indexOf("I") > -1)) { // 법률고문 담당자 권한

			// 만료 예정 고문 건수
			model.addAttribute("cnt1", suitService.selectMainLawfirmEndInfoCnt());
			// 법률 고문수
			model.addAttribute("cnt2", suitService.selectMainLawyerCnt());
			
			// 만료 예정 법률 고문 목록
			mtenMap.put("TRMN_YN", "N");
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			model.addAttribute("list1", suitService.selectMainLawfirmEndInfoList(mtenMap));
		} else if ((writerGrpcd.indexOf("P") > -1)) { // 일반사용자 권한
			
			// 소송 진행/종결 건수
			model.addAttribute("cntM1", suitService.selectMainSuitTrmnYnCnt(userId));
			
			// 자문/협약 진행/종결 건수
			HashMap chkConagrMap = consultService.selectMainConCnt(userId);
			String chkCnt1 = chkConagrMap.get("CNT1")==null?"":chkConagrMap.get("CNT1").toString();
			String chkCnt2 = chkConagrMap.get("CNT2")==null?"":chkConagrMap.get("CNT2").toString();
			if ("".equals(chkCnt1) && "".equals(chkCnt2)) {
				chkConagrMap = agreeService.selectMainAgrCnt(userId);
			}
			model.addAttribute("cntM2", chkConagrMap);
			
			// 소송 진행중 목록
			mtenMap.put("TRMN_YN", "N");
			mtenMap.put("pagesize", "6");
			mtenMap.put("pageno", "1");
			mtenMap.put("userId", userId);
			model.addAttribute("list2", suitService.selectSuitMainList2(mtenMap));
			
			// 자주묻는질문 목록
			mtenMap.put("MENU_MNG_NO", "100158428");
			model.addAttribute("list1", webService.pdsList(mtenMap));
			
			//mtenMap.put("grpcd", writerGrpcd);
			//model.addAttribute("list1", webService.selectMyWorkListMain(mtenMap));
		}
		
		model.addAttribute("cnt4", webService.getTaskCount(mtenMap));
		
		return "index.main";
	}
	

	@RequestMapping(value="/schdule.do")
	public void schdule(Map<String, Object> mtenMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String GRPCD = mtenMap.get("GRPCD")==null?"":mtenMap.get("GRPCD").toString();
		String startdt = "";
		String enddt = "";
		String year2 = mtenMap.get("year")==null?"":mtenMap.get("year").toString();
		
		String gbn = "";
		
		if (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("G") > -1) {
			gbn = "T";
		} else if (GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1 || 
				GRPCD.indexOf("B") > -1 || GRPCD.indexOf("D") > -1 || GRPCD.indexOf("F") > -1) {
			gbn = "S";
		} else if (GRPCD.indexOf("E") > -1) {
			gbn = "E";
		} else if (GRPCD.indexOf("J") > -1 || GRPCD.indexOf("M") > -1) {
			gbn = "C";
		} else if (GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N") > -1) {
			gbn = "A";
		} else if (GRPCD.indexOf("I") > -1) {
			gbn = "Z";
		} else if(GRPCD.indexOf("P") > -1) {
			gbn = "P";
		}
		
		if(year2.equals("")){
			// 오늘 날짜(달) 기준 조회
			Calendar cal = Calendar.getInstance();
			int year = cal.get(Calendar.YEAR);
			int month = cal.get(Calendar.MONTH);
			
			month = month + 1;
			String month2 = "";
			
			if(month < 10){
				month2 = "0"+month;
			}else{
				month2 = ""+month;
			}
			
			startdt = year+"-"+month2+"-"+"01T00:00:00";
			enddt   = year+"-"+month2+"-"+"31T24:59:59";
		} else {
			// 달력 달 선택 기준
			String month2 = mtenMap.get("month")==null?"":mtenMap.get("month").toString();
			if(month2.length() < 2){
				month2 = "0"+month2;
			}
			
			startdt = (mtenMap.get("year")==null?"":mtenMap.get("year").toString())+"-"+month2+"-"+"01T00:00:00";
			enddt   = (mtenMap.get("year")==null?"":mtenMap.get("year").toString())+"-"+month2+"-"+"31T24:59:59";
		}
		
		HashMap codeupMap = new HashMap();
		codeupMap.put("year", mtenMap.get("year")==null?"":mtenMap.get("year"));
		codeupMap.put("month", mtenMap.get("month")==null?"":mtenMap.get("month"));
		codeupMap.put("startdt", startdt);
		codeupMap.put("enddt", enddt);
		codeupMap.put("sc", "Y");
		System.out.println("mainc==>"+codeupMap);
		
		StringBuffer bf = new StringBuffer();
		String strYear = codeupMap.get("year")==null?"":codeupMap.get("year").toString();
		String strMonth = codeupMap.get("month")==null?"":codeupMap.get("month").toString();
		
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH);
		int date = cal.get(Calendar.DATE);
		
		// 선택 한 연/월 있으면 해당 날짜로 다시 세팅
		if(strYear != null && !strYear.equals("")){
			year = Integer.parseInt(strYear);
			month = Integer.parseInt(strMonth)-1;
		}
		
		// 년도/월 셋팅
		cal.set(year, month, 1);
		
		int startDay = cal.getMinimum(java.util.Calendar.DATE);
		int endDay = cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
		int start = cal.get(java.util.Calendar.DAY_OF_WEEK);
		int newLine = 0;
		
		//오늘 날짜 저장.
		Calendar todayCal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		int intToday = Integer.parseInt(sdf.format(todayCal.getTime()));
		
		month = month+1;
		
		int carYBefore = year;
		int carMBefore = month-1;
		if (carMBefore == 0) {
			carYBefore = carYBefore-1;
			carMBefore = 12;
		}
		
		int carYNext = year;
		int carMNext = month+1;
		if (carMNext == 13) {
			carYNext = year+1;
			carMNext = 1;
		}
		
		// 달력 상단
		bf.append("<div class=\"scheC\">");
		bf.append("<div class=\"calendar_header\">");
		bf.append("<button class=\"prev\" onclick=\"schView("+carYBefore+", "+carMBefore+")\"><i class=\"ph-bold ph-caret-left\"></i></button>");
		bf.append("<span class=\"month\">"+year+"."+month+"</span>");
		bf.append("<button class=\"next\" onclick=\"schView("+carYNext+", "+carMNext+")\"><i class=\"ph-bold ph-caret-right\"></i></button>");
		bf.append("</div>");
		// 달력
		bf.append("<div class=\"calendarC\" onclick=\"goCalendar();\">");
		bf.append("<table class=\"calC\" style=\"width:100%\">");
		bf.append("<thead>");
		bf.append("<tr>");
		bf.append("<th>일</th>");
		bf.append("<th>월</th>");
		bf.append("<th>화</th>");
		bf.append("<th>수</th>");
		bf.append("<th>목</th>");
		bf.append("<th>금</th>");
		bf.append("<th>토</th>");
		bf.append("</tr>");
		bf.append("</thead>");
		bf.append("<tbody>");
		bf.append("<tr>");
		bf.append("</div>");
		
		// 송무 일정 가져오기
		HashMap param = new HashMap();
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf2.format(todayCal.getTime());
		String getDay = year+"-"+(month<10?"0"+month:month)+"-"+(startDay<10?"0"+startDay:startDay);
		String getMonth = mtenMap.get("month")==null?"":mtenMap.get("month").toString();
		
		param.put("GRPCD", GRPCD);
		
		if(getMonth.equals("")){
			param.put("start", today);
		}else{
			param.put("start", getDay);
		}
		param.put("start", year+"-"+(month<10?"0"+month:month)+"-01");
		param.put("end", year+"-"+(month<10?"0"+month:month)+"-"+(endDay<10?"0"+endDay:endDay));
		
		param.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
		param.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
		
		List calList = suitService.selectMainCalData(param);
		
		for(int index = 1; index <= endDay; index++) {
			String sUseDate = Integer.toString(year);
			sUseDate += Integer.toString(month).length() == 1 ? "0" + Integer.toString(month) : Integer.toString(month);
			sUseDate += Integer.toString(index).length() == 1 ? "0" + Integer.toString(index) : Integer.toString(index);
			
			int iUseDate = Integer.parseInt(sUseDate);
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
			Date nDate = dateFormat.parse(sUseDate);
			Calendar cal2 = Calendar.getInstance();
			cal2.setTime(nDate);
			
			int dayNum = cal2.get(Calendar.DAY_OF_WEEK);
			
			if (index == 1 && dayNum != 1) {
				for (int k=1; k<dayNum; k++) {
					bf.append("<td></td>");
				}
			}
			
			HashMap calData = new HashMap();
			String ddate = "";
			String css = "";
			
			if(iUseDate == intToday) {
				css = "active";
			}
			
			if(calList.size() > 0){
				for(int i=0; i<calList.size(); i++){
					calData = (HashMap)calList.get(i)==null?new HashMap():(HashMap)calList.get(i);
					ddate = calData.get("DATE_YMD")==null?"":calData.get("DATE_YMD").toString();
					ddate = ddate.replaceAll("-", "");
					
					if (sUseDate.equals(ddate)) {
						css = "inDate";
					}
					
				}
			}
			
			if ("inDate".equals(css)) {
				bf.append("<td><span>"+index+"</span></td>");
			} else {
				bf.append("<td class=\""+css+"\">"+index+"</td>");
			}
			
			switch (dayNum) {
				case 7: 
					bf.append("</tr><tr>");
					break;
			}
		}
		
		bf.append("</tr>");
		bf.append("</tbody>");
		bf.append("</table>");
		bf.append("</div>");
		bf.append("</div>");
		
		// 일정 표시 (오늘 + 7일)
		Calendar todayCal2 = Calendar.getInstance();
		int intToday2 = Integer.parseInt(sdf.format(todayCal2.getTime()));
		
		int startdt2 = intToday;
		int enddt2 = intToday2;
		String get = mtenMap.get("month")==null?"0":mtenMap.get("month").toString();
		if (get == "" || get.isEmpty()) {
			get = "0";
		}
		
		int getMonth2 = Integer.parseInt(get);
		
		Calendar cal2 = Calendar.getInstance();
		int month3 = cal2.get(Calendar.MONTH)+1;
		
		if(year2.equals("") || month3 == getMonth2){
			startdt2 = intToday;
			enddt2 = intToday2;
			
			System.out.println(">>>>>>>>>>>>>>>>>>>>> 1");
		} else {
			String month2 = mtenMap.get("month")==null?"":mtenMap.get("month").toString();
			if(month2.length() < 2){
				month2 = "0"+month2;
			}
			
			startdt2 = Integer.parseInt((mtenMap.get("year")==null?"":mtenMap.get("year").toString())+month2+"01");
			enddt2   = Integer.parseInt((mtenMap.get("year")==null?"":mtenMap.get("year").toString())+month2+"07");
			
			todayCal2.clear();
			todayCal2.set(Integer.parseInt(mtenMap.get("year")==null?"":mtenMap.get("year").toString()), Integer.parseInt(month2)-1, 1);
			System.out.println(">>>>>>>>>>>>>>>>>>>>> 2");
		}
		
		int dtCnt = 0;
		
		int endDtCnt = 7;
		
		Calendar tocal = Calendar.getInstance();
		int toyear = tocal.get(Calendar.YEAR);
		int tomonth = tocal.get(Calendar.MONTH);
		int todate = tocal.get(Calendar.DATE);
		
		String WRTR_EMP_NM = mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString();
		
		for(int d=1; d<=endDtCnt; d++) {
			int wk = todayCal2.get(Calendar.DAY_OF_WEEK);
			int dd = todayCal2.get(Calendar.DATE);
			String wkName = "";
			
			if (wk == 7) {
				todayCal2.add(Calendar.DAY_OF_MONTH, 1);
				wk = todayCal2.get(Calendar.DAY_OF_WEEK);
			}
			
			if (wk == 1) {
				todayCal2.add(Calendar.DAY_OF_MONTH, 1);
				wk = todayCal2.get(Calendar.DAY_OF_WEEK);
			}
			
			dd = todayCal2.get(Calendar.DATE);
			
			switch(wk) {
				case 1: wkName = "일"; break;
				case 2: wkName = "월"; break;
				case 3: wkName = "화"; break;
				case 4: wkName = "수"; break;
				case 5: wkName = "목"; break;
				case 6: wkName = "금"; break;
				case 7: wkName = "토"; break;
			}
			
			param.put("GRPCD", GRPCD);
			param.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
			param.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
			param.put("start", sdf2.format(todayCal2.getTime()));
			param.put("end",   sdf2.format(todayCal2.getTime()));
			List nextcalList = suitService.selectMainCalData(param);
			dtCnt = dtCnt+1;
			
			if (toyear == todayCal2.get(Calendar.YEAR) && tomonth == todayCal2.get(Calendar.MONTH) && todate == todayCal2.get(Calendar.DATE)) {
				bf.append("<div class=\"scheC active\">");
			} else {
				bf.append("<div class=\"scheC\">");
			}
			
			bf.append("<div class=\"scheT\">");
			bf.append("<strong>");
			bf.append((todayCal2.get(Calendar.DATE)));
			bf.append("</strong>");
			bf.append("<span>");
			bf.append(wkName);
			bf.append("</span>");
			bf.append("</div>");
			
			if (nextcalList.size() > 0) {
				int nextcalListCnt = nextcalList.size();
				int forIdx = 2;
				if (nextcalListCnt < 2) {
					forIdx = nextcalListCnt;
				}
				
				bf.append("<div class=\"sche_infoW\">");
				bf.append("<ul>");
				
				for(int i=0; i<=(forIdx-1); i++){
					//for(int i=0; i<nextcalList.size(); i++){
					HashMap map = (HashMap) nextcalList.get(i);
					
					String EMPNM = map.get("EMPNM")==null?"":map.get("EMPNM").toString();
					String GBN = map.get("GBN")==null?"":map.get("GBN").toString();
					
					String sdt = map.get("DATE_YMD")==null?"":map.get("DATE_YMD").toString();
					sdt = sdt.substring(8, 10);
					String dSdt = (dd<10?"0"+dd:dd)+"";
					
					String pk1 = "";
					String pk2 = "";
					String pk3 = "";
					String event = "";
					
					if ("SUIT".equals(GBN)) {
						if("T".equals(gbn) || "P".equals(gbn)) {
							pk1 = map.get("DOCPK1")==null?"":map.get("DOCPK1").toString();
							pk2 = map.get("DOCPK2")==null?"":map.get("DOCPK2").toString();
						} else {
							pk1 = map.get("LWS_MNG_NO")==null?"":map.get("LWS_MNG_NO").toString();
							pk2 = map.get("INST_MNG_NO")==null?"":map.get("INST_MNG_NO").toString();
						}
						
						event = "suitView('"+pk1+"','"+pk2+"')";
					} else if ("CONSULT".equals(GBN)) {
						if("T".equals(gbn) || "P".equals(gbn)) {
							pk1 = map.get("DOCPK1")==null?"":map.get("DOCPK1").toString();
						} else {
							pk1 = map.get("CNSTN_MNG_NO")==null?"":map.get("CNSTN_MNG_NO").toString();
						}
						event = "consultView('"+pk1+"')";
					} else if ("AGREE".equals(GBN)) {
						if("T".equals(gbn) || "P".equals(gbn)) {
							pk1 = map.get("DOCPK1")==null?"":map.get("DOCPK1").toString();
						} else {
							pk1 = map.get("CVTN_MNG_NO")==null?"":map.get("CVTN_MNG_NO").toString();
						}
						event = "agreeView('"+pk1+"')";
					} else if ("I".equals(gbn)) {
						pk1 = map.get("DOCPK1")==null?"":map.get("DOCPK1").toString();
						event = "goLawyerInfo('"+pk1+"')";
					} else if ("E".equals(gbn)) {
						pk1 = map.get("DOCPK1")==null?"":map.get("DOCPK1").toString();
						pk2 = map.get("DOCPK2")==null?"":map.get("DOCPK2").toString();
						pk3 = map.get("DOCPK3")==null?"":map.get("DOCPK3").toString();
						event = "goBondInfo('"+pk1+"', '"+pk2+"', '"+pk3+"')";
					}
					
					if (dSdt.equals(sdt)) {
						if (EMPNM.equals(WRTR_EMP_NM)) {
							bf.append("<li class=\"sel2\" onclick=\""+event+"\">");
						} else {
							bf.append("<li class=\"sel\" onclick=\""+event+"\">");
						}
						
						bf.append(map.get("DATE_TYPE_NM")==null?"":map.get("DATE_TYPE_NM").toString());
						bf.append("</li>");
					}
				}
				
				bf.append("</ul>");
				
				bf.append("</div>");
				bf.append("</div>");
			} else {
				bf.append("<div class=\"sche_infoW\">");
				bf.append("<ul>");
				
				bf.append("<li>일정이 없습니다.</li>");
				
				bf.append("</ul>");
				bf.append("</div>");
				bf.append("</div>");
			}
			
			todayCal2.add(Calendar.DAY_OF_MONTH, 1);
		}
		
		//bf.append("</div>");
		
		PrintWriter out = null;
		response.setContentType("application/html; charset=EUC-KR");
		try {
			out = response.getWriter();
		} catch (IOException e) {
			System.out.println("달력 생성 중 오류 발생");
		}
		
		out.println(bf.toString());
		out.close();
	}
	
	@RequestMapping("/login.do")
	public String login(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("mtenMap===>"+mtenMap);
		
		HttpSession session = request.getSession();
		String userid = session.getAttribute("userid")==null?"":(String)session.getAttribute("userid");
		if(userid == null || userid.equals("")){
			return "login.pop";
		}else{
			
			mtenMap.put("userid", new String(Base64.encodeBase64(userid.getBytes())));
			
			JSONObject result = userService.getMatch(mtenMap,request);
			String loginyn = result.get("loginyn")==null?"":result.get("loginyn").toString();
			if(loginyn.equals("Y")){
				return "redirect:index.do";
			}else{
				return "login.pop";
			}
		}
		
	}
	
	@RequestMapping("/mainC2.do")
	public void mainC2(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String startdt = "";
		String enddt = "";
		if(mtenMap.get("year")==null||mtenMap.get("year").toString().equals("")){
			Calendar cal = Calendar.getInstance();
			int year = cal.get(Calendar.YEAR);
			int month = cal.get(Calendar.MONTH);
			month = month+1;
			String month2 = "";
			if(month<10){
				month2 = "0"+month;
			}else{
				month2 = ""+month;
			}
			startdt = year+month2+"01";
			enddt = year+month2+"31";
		}else{
			String month2 = mtenMap.get("month")+"";
			if(month2.length()<2){
				month2 = "0"+month2;
			}
			startdt = mtenMap.get("year")+month2+"01";
			enddt = mtenMap.get("year")+month2+"31";
		}
		mtenMap.put("startdt", startdt);
		mtenMap.put("enddt", enddt);
		mtenMap.put("sc", "Y");
		System.out.println("mainc==>"+mtenMap);
		
		StringBuffer bf = new StringBuffer();
		String strYear = mtenMap.get("year")==null?"":mtenMap.get("year").toString();
		String strMonth = mtenMap.get("month")==null?"":mtenMap.get("month").toString();
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH);
		int date = cal.get(Calendar.DATE);
		if(strYear != null && !strYear.equals("")){
		  year = Integer.parseInt(strYear);
		  month = Integer.parseInt(strMonth)-1;
		}else{
		}
		
		//년도/월 셋팅
		cal.set(year, month, 1);
		int startDay = cal.getMinimum(java.util.Calendar.DATE);
		int endDay = cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
		int start = cal.get(java.util.Calendar.DAY_OF_WEEK);
		int newLine = 0;
		
		//오늘 날짜 저장.
		Calendar todayCal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		int intToday = Integer.parseInt(sdf.format(todayCal.getTime()));
		month = month+1;
		
		bf.append("<div class='scheduleTitle'>");
		bf.append("<div class='date'>");
		bf.append("<span>"+year+"</span>");
		bf.append("<strong>"+(month<10?"0"+month:month)+"</strong>");
		bf.append("</div>");
		bf.append("<div class='textW'>");
		bf.append("이달의 일정을<br>확인하세요.");
		bf.append("</div>");
		bf.append("<div class='ctrlW'>");
		bf.append("<a href='javascript:return false' class='btnMonth prev' id='prv' value='"+(month-1)+"' value2='"+year+"'>이전 달</a>");
		bf.append("<a href='javascript:return false' class='btnMonth next' id='next' value='"+(month+1)+"' value2='"+year+"'>다음 달</a>");
		bf.append("</div>");
		bf.append("</div>");
		bf.append("<div class='scheduleConW'>");
		bf.append("<div class='calDateW'>");
		bf.append("<ul>");
		
		for(int index = 1; index <= endDay; index++){
			
			String sUseDate = Integer.toString(year); 
            sUseDate += Integer.toString(month).length() == 1 ? "0" + Integer.toString(month) : Integer.toString(month);
            sUseDate += Integer.toString(index).length() == 1 ? "0" + Integer.toString(index) : Integer.toString(index);
            int iUseDate = Integer.parseInt(sUseDate);
            String css = "";
            String css2 = "display: none;";
            if(iUseDate == intToday ) {
            	css = "on";
            	css2 = "";
            }
			bf.append("<li><a href='javascript:return false'>"+(index<10?"0"+index:index)+"</a></li>");
		}
		bf.append("</ul>");
		bf.append("</div>");
		bf.append("<div class='scheduleDetail'>");
		bf.append("<ul>");
		bf.append("<li>");
		bf.append("[선고기일] 2014가합107608");
		bf.append("</li>");
		bf.append("<li>");
		bf.append("[선고기일] 2014가합107608");
		bf.append("</li>");
		bf.append("<li>");
		bf.append("[선고기일] 2014가합107608");
		bf.append("</li>");
		bf.append("<li>");
		bf.append("[선고기일] 2014가합107608");
		bf.append("</li>");
		bf.append("</ul>");
		bf.append("</div>");
		bf.append("</div>");
		
		JSONObject result = new JSONObject();
		result.put("year", year);
		result.put("month", (month<10?"0"+month:month));
		result.put("prv", (month-1));
		result.put("next","<a href='javascript:return false' class='btnMonth next' id='next' value='"+(month+1)+"' value2='"+year+"'><i class=\"fas fa-angle-right\"></i></a>");
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/getPageNavi.do")
	public void getPageNavi(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONObject result = webService.getPageNavi(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/getSubTitle.do")
	public void getSubTitle(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONObject result = webService.getSubTitle(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/search.do")
	public String search(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println(mtenMap);
		model.addAttribute("pQuery_tmp", mtenMap.get("pQuery_tmp"));
		return "sch/search.sch";
	}
	
	@RequestMapping("/{page1}")
	public String lawSearch(@PathVariable String page1 , Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		return "sch/"+page1+".sch";
	}
	
	@RequestMapping("/workMain.do")
	public String workMain(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		model.addAttribute("param", mtenMap);
		return "mywork/workMain.web";
	}
	
	@RequestMapping("/workList.do")
	public String workList(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		model.addAttribute("param", mtenMap);
		return "mywork/workList.frm";
	}
	
	@RequestMapping("/getSts.do")
	public void getSts(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONObject result = webService.getSts(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="goHwp.do")
	public String goHwp(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "common/hwp.dll";
	}
	
	@RequestMapping("goMakeGian.do")
	public void goMakeGian(Map<String, Object> mtenMap, HttpServletRequest req, HttpServletResponse response) throws IOException {
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		String docgbn = mtenMap.get("docgbn")==null?"":mtenMap.get("docgbn").toString();
		String writegbn = mtenMap.get("writegbn")==null?"":mtenMap.get("writegbn").toString();
		
		
		String fnm = "";//webService.getDocFnm(mtenMap);
		String viewnm = "";
		String xml = "";
		String filenm = "";
		
		if(gbn.indexOf("ag")>-1) {
			String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
			String agreeGbn = mtenMap.get("agreeGbn")==null?"":mtenMap.get("agreeGbn").toString();
			
			if("3".equals(writegbn)){
				HashMap param = new HashMap();
				
				param.put("CVTN_MNG_NO", CVTN_MNG_NO);
				param.put("ordgbn", agreeGbn);
				List flist = agreeService.getFileList(param);
				
				for(int i=0; i<flist.size(); i++) {
					HashMap fre = (HashMap)flist.get(i);
					fnm = fre.get("SRVR_FILE_NM")==null?"":fre.get("SRVR_FILE_NM").toString();
				}
			} else {
				fnm = fnm + webService.getDocFnm(mtenMap)+",";
			}
			
			HashMap agreeInfo = agreeService.getAgreeDetail(mtenMap);
			if ("VIEW1".equals(agreeGbn)) {
				xml = xml + "<CVTN_TTL><![CDATA["           + (agreeInfo.get("CVTN_TTL")==null?"":agreeInfo.get("CVTN_TTL").toString())                     + "]]></CVTN_TTL>";
				xml = xml + "<CVTN_RQST_DEPT_NM><![CDATA["  + (agreeInfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeInfo.get("CVTN_RQST_DEPT_NM").toString())   + "]]></CVTN_RQST_DEPT_NM>";
				xml = xml + "<BIZ_OTLN><![CDATA["           + (agreeInfo.get("BIZ_OTLN")==null?"":agreeInfo.get("BIZ_OTLN").toString().replaceAll("\n","\r\n"))                     + "]]></BIZ_OTLN>";
				xml = xml + "<PJTCO_CN><![CDATA["           + (agreeInfo.get("PJTCO_CN")==null?"":agreeInfo.get("PJTCO_CN").toString())                     + "]]></PJTCO_CN>";
				xml = xml + "<BIZ_PRD_NM><![CDATA["         + (agreeInfo.get("BIZ_PRD_NM")==null?"":agreeInfo.get("BIZ_PRD_NM").toString())                 + "]]></BIZ_PRD_NM>";
				xml = xml + "<BSS_STT_CN><![CDATA["         + (agreeInfo.get("BSS_STT_CN")==null?"":agreeInfo.get("BSS_STT_CN").toString().replaceAll("\n","\r\n"))                 + "]]></BSS_STT_CN>";
				xml = xml + "<BFHD_PRCD_IMPLT_CN><![CDATA[" + (agreeInfo.get("BFHD_PRCD_IMPLT_CN")==null?"":agreeInfo.get("BFHD_PRCD_IMPLT_CN").toString().replaceAll("\n","\r\n")) + "]]></BFHD_PRCD_IMPLT_CN>";
				xml = xml + "<MAIN_CTRT_CN><![CDATA["       + (agreeInfo.get("MAIN_CTRT_CN")==null?"":agreeInfo.get("MAIN_CTRT_CN").toString().replaceAll("\n","\r\n"))             + "]]></MAIN_CTRT_CN>";
				xml = xml + "<CVTN_SRNG_DMND_CN><![CDATA["  + (agreeInfo.get("CVTN_SRNG_DMND_CN")==null?"":agreeInfo.get("CVTN_SRNG_DMND_CN").toString().replaceAll("\n","\r\n"))   + "]]></CVTN_SRNG_DMND_CN>";
				xml = xml + "<HCFH_PLAN_CN><![CDATA["       + (agreeInfo.get("HCFH_PLAN_CN")==null?"":agreeInfo.get("HCFH_PLAN_CN").toString().replaceAll("\n","\r\n"))             + "]]></HCFH_PLAN_CN>";
			} else if ("VIEW2".equals(agreeGbn)) {
				xml = xml + "<CVTN_RQST_DEPT_NM><![CDATA["       + (agreeInfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeInfo.get("CVTN_RQST_DEPT_NM").toString())             + "]]></CVTN_RQST_DEPT_NM>";
				xml = xml + "<CVTN_RQST_EMP_NM><![CDATA["        + (agreeInfo.get("CVTN_RQST_EMP_NM")==null?"":agreeInfo.get("CVTN_RQST_EMP_NM").toString())               + "]]></CVTN_RQST_EMP_NM>";
				xml = xml + "<CVTN_RQST_LAST_APRVR_NM><![CDATA[" + (agreeInfo.get("CVTN_RQST_LAST_APRVR_NM")==null?"":agreeInfo.get("CVTN_RQST_LAST_APRVR_NM").toString()) + "]]></CVTN_RQST_LAST_APRVR_NM>";
				xml = xml + "<WRC_TELNO1><![CDATA["              + (agreeInfo.get("WRC_TELNO1")==null?"":agreeInfo.get("WRC_TELNO1").toString())                           + "]]></WRC_TELNO1>";
				xml = xml + "<CVTN_RQST_EMP_NM><![CDATA["        + (agreeInfo.get("CVTN_RQST_EMP_NM")==null?"":agreeInfo.get("CVTN_RQST_EMP_NM").toString())               + "]]></CVTN_RQST_EMP_NM>";
				xml = xml + "<WRC_TELNO2><![CDATA["              + (agreeInfo.get("WRC_TELNO2")==null?"":agreeInfo.get("WRC_TELNO2").toString())                           + "]]></WRC_TELNO2>";
				xml = xml + "<CVTN_CNCLS_PRNMNT_YMD><![CDATA["   + (agreeInfo.get("CVTN_CNCLS_PRNMNT_YMD")==null?"":agreeInfo.get("CVTN_CNCLS_PRNMNT_YMD").toString())     + "]]></CVTN_CNCLS_PRNMNT_YMD>";
				xml = xml + "<CVTN_TTL><![CDATA["                + (agreeInfo.get("CVTN_TTL")==null?"":agreeInfo.get("CVTN_TTL").toString())                               + "]]></CVTN_TTL>";
				xml = xml + "<CVTN_RQST_CN><![CDATA["            + (agreeInfo.get("CVTN_RQST_CN")==null?"":agreeInfo.get("CVTN_RQST_CN").toString())                       + "]]></CVTN_RQST_CN>";
				xml = xml + "<CVTN_SRNG_DMND_CN><![CDATA["       + (agreeInfo.get("CVTN_SRNG_DMND_CN")==null?"":agreeInfo.get("CVTN_SRNG_DMND_CN").toString())             + "]]></CVTN_SRNG_DMND_CN>";
			} else if ("VIEW3".equals(agreeGbn)) {
				xml = xml + "<CVTN_RQST_DEPT_NM><![CDATA["       + (agreeInfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeInfo.get("CVTN_RQST_DEPT_NM").toString())             + "]]></CVTN_RQST_DEPT_NM>";
				xml = xml + "<CVTN_RQST_LAST_APRVR_NM><![CDATA[" + (agreeInfo.get("CVTN_RQST_LAST_APRVR_NM")==null?"":agreeInfo.get("CVTN_RQST_LAST_APRVR_NM").toString()) + "]]></CVTN_RQST_LAST_APRVR_NM>";
				xml = xml + "<WRC_TELNO1><![CDATA["              + (agreeInfo.get("WRC_TELNO1")==null?"":agreeInfo.get("WRC_TELNO1").toString())                           + "]]></WRC_TELNO1>";
				xml = xml + "<CVTN_RQST_EMP_NM><![CDATA["        + (agreeInfo.get("CVTN_RQST_EMP_NM")==null?"":agreeInfo.get("CVTN_RQST_EMP_NM").toString())               + "]]></CVTN_RQST_EMP_NM>";
				xml = xml + "<WRC_TELNO2><![CDATA["              + (agreeInfo.get("WRC_TELNO2")==null?"":agreeInfo.get("WRC_TELNO2").toString())                           + "]]></WRC_TELNO2>";
				xml = xml + "<CVTN_CNCLS_PRNMNT_YMD><![CDATA["   + (agreeInfo.get("CVTN_CNCLS_PRNMNT_YMD")==null?"":agreeInfo.get("CVTN_CNCLS_PRNMNT_YMD").toString())     + "]]></CVTN_CNCLS_PRNMNT_YMD>";
				xml = xml + "<CVTN_TTL><![CDATA["                + (agreeInfo.get("CVTN_TTL")==null?"":agreeInfo.get("CVTN_TTL").toString())                               + "]]></CVTN_TTL>";
				xml = xml + "<CVTN_RQST_CN><![CDATA["            + (agreeInfo.get("CVTN_RQST_CN")==null?"":agreeInfo.get("CVTN_RQST_CN").toString())                       + "]]></CVTN_RQST_CN>";
			}
			xml = xml + "<CVTN_MNG_NO><![CDATA["+CVTN_MNG_NO+"]]></CVTN_MNG_NO>";
			xml = xml + "<docgbn><![CDATA[AGREE]]></docgbn>";
			xml = xml + "<FILE_SE><![CDATA["+agreeGbn+"]]></FILE_SE>";
			
		} else if(gbn.indexOf("co")>-1) {
			
		} else if(gbn.indexOf("SO")>-1) {
			String lwsMngNo = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
			String instMngNo = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
			
			if("3".equals(writegbn)){
				HashMap param = new HashMap();
				
				param.put("LWS_MNG_NO", lwsMngNo);
				param.put("INST_MNG_NO", instMngNo);
				param.put("ordgbn", gbn);
				List flist = suitService.getFileList(param);
				
				for(int i=0; i<flist.size(); i++) {
					HashMap fre = (HashMap)flist.get(i);
					fnm = fre.get("SRVR_FILE_NM")==null?"":fre.get("SRVR_FILE_NM").toString();
				}
			} else {
				fnm = fnm + webService.getDocFnm(mtenMap)+",";
			}
			
			if ("SO1".equals(gbn)) {
				// 소송사무보고(통보)_접수 보고
				HashMap suitMap = suitService.getDocMakeInfo1(mtenMap);
				xml = xml + "<LWS_UP_TYPE_NM><![CDATA["   + (suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString()    ) + "]]></LWS_UP_TYPE_NM>";
				xml = xml + "<DOC_GBN><![CDATA["          + "접수"                                                                                + "]]></DOC_GBN>";
				xml = xml + "<WONGONM><![CDATA["          + (suitMap.get("WONGONM")==null?"":suitMap.get("WONGONM").toString()                  ) + "]]></WONGONM>";
				xml = xml + "<PIGONM><![CDATA["           + (suitMap.get("PIGONM")==null?"":suitMap.get("PIGONM").toString()                    ) + "]]></PIGONM>";
				xml = xml + "<LWS_INCDNT_NM><![CDATA["    + (suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString()      ) + "]]></LWS_INCDNT_NM>";
				xml = xml + "<PPOF_INCDNT_NO><![CDATA["   + (suitMap.get("PPOF_INCDNT_NO")==null?"":suitMap.get("PPOF_INCDNT_NO").toString()    ) + "]]></PPOF_INCDNT_NO>";
				xml = xml + "<CT_NM><![CDATA["            + (suitMap.get("CT_NM")==null?"":suitMap.get("CT_NM").toString()                      ) + "]]></CT_NM>";
				xml = xml + "<INCDNT_NO><![CDATA["        + (suitMap.get("INCDNT_NO")==null?"":suitMap.get("INCDNT_NO").toString()              ) + "]]></INCDNT_NO>";
				xml = xml + "<TKCG_EMP_NM><![CDATA["      + (suitMap.get("TKCG_EMP_NM")==null?"":suitMap.get("TKCG_EMP_NM").toString()          ) + "]]></TKCG_EMP_NM>";
				xml = xml + "<LWS_FLFMT_EMP_NM><![CDATA[" + (suitMap.get("LWS_FLFMT_EMP_NM")==null?"":suitMap.get("LWS_FLFMT_EMP_NM").toString()) + "]]></LWS_FLFMT_EMP_NM>";
				xml = xml + "<LWYR_NM><![CDATA["          + (suitMap.get("LWYR_NM")==null?"":suitMap.get("LWYR_NM").toString()                  ) + "]]></LWYR_NM>";
				xml = xml + "<FLGLW_YMD><![CDATA["        + (suitMap.get("FLGLW_YMD")==null?"":suitMap.get("FLGLW_YMD").toString()              ) + "]]></FLGLW_YMD>";
				xml = xml + "<LWS_SE_NM><![CDATA["        + (suitMap.get("LWS_SE_NM")==null?"":suitMap.get("LWS_SE_NM").toString()              ) + "]]></LWS_SE_NM>";
				xml = xml + "<LWS_EQVL><![CDATA["         + (suitMap.get("LWS_EQVL")==null?"":suitMap.get("LWS_EQVL").toString()                ) + "]]></LWS_EQVL>";
				xml = xml + "<INCDNT_OTLN><![CDATA["      + (suitMap.get("INCDNT_OTLN")==null?"":suitMap.get("INCDNT_OTLN").toString()          ) + "]]></INCDNT_OTLN>";
				xml = xml + "<PROGINFO><![CDATA["         + (suitMap.get("PROGINFO")==null?"":suitMap.get("PROGINFO").toString()                ) + "]]></PROGINFO>";
				xml = xml + "<JDGM_ADJ_YMD><![CDATA["     + (suitMap.get("JDGM_ADJ_YMD")==null?"":suitMap.get("JDGM_ADJ_YMD").toString()        ) + "]]></JDGM_ADJ_YMD>";
				xml = xml + "<JDGM_UP_TYPE_NM><![CDATA["  + (suitMap.get("JDGM_UP_TYPE_NM")==null?"":suitMap.get("JDGM_UP_TYPE_NM").toString()  ) + "]]></JDGM_UP_TYPE_NM>";
				xml = xml + "<RLNG_TMTL_YMD><![CDATA["    + (suitMap.get("RLNG_TMTL_YMD")==null?"":suitMap.get("RLNG_TMTL_YMD").toString()      ) + "]]></RLNG_TMTL_YMD>";
				viewnm = "소송사무보고(통보).hwpx";
			} else if ("SO2".equals(gbn)) {
				// 소송진행상황보고
				HashMap suitMap = suitService.getDocMakeInfo2(mtenMap);
				xml = xml + "<CT_NM><![CDATA["            + (suitMap.get("CT_NM")==null?"":suitMap.get("CT_NM").toString()                      ) + "]]></CT_NM>";
				xml = xml + "<INCDNT_NO><![CDATA["        + (suitMap.get("INCDNT_NO")==null?"":suitMap.get("INCDNT_NO").toString()              ) + "]]></INCDNT_NO>";
				xml = xml + "<PPOF_INCDNT_NO><![CDATA["   + (suitMap.get("PPOF_INCDNT_NO")==null?"":suitMap.get("PPOF_INCDNT_NO").toString()    ) + "]]></PPOF_INCDNT_NO>";
				xml = xml + "<LWS_INCDNT_NM><![CDATA["    + (suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString()      ) + "]]></LWS_INCDNT_NM>";
				xml = xml + "<WONGO><![CDATA["            + (suitMap.get("WONGO")==null?"":suitMap.get("WONGO").toString()                      ) + "]]></WONGO>";
				xml = xml + "<PIGO><![CDATA["             + (suitMap.get("PIGO")==null?"":suitMap.get("PIGO").toString()                        ) + "]]></PIGO>";
				xml = xml + "<TKCG_EMP_NM><![CDATA["      + (suitMap.get("TKCG_EMP_NM")==null?"":suitMap.get("TKCG_EMP_NM").toString()          ) + "]]></TKCG_EMP_NM>";
				xml = xml + "<LWS_SE_NM><![CDATA["        + (suitMap.get("LWS_SE_NM")==null?"":suitMap.get("LWS_SE_NM").toString()              ) + "]]></LWS_SE_NM>";
				xml = xml + "<LWS_FLFMT_EMP_NM><![CDATA[" + (suitMap.get("LWS_FLFMT_EMP_NM")==null?"":suitMap.get("LWS_FLFMT_EMP_NM").toString()) + "]]></LWS_FLFMT_EMP_NM>";
				xml = xml + "<WRC_TELNO><![CDATA["        + (suitMap.get("WRC_TELNO")==null?"":suitMap.get("WRC_TELNO").toString()              ) + "]]></WRC_TELNO>";
				xml = xml + "<TODAY_DATE><![CDATA["       + (suitMap.get("TODAY_DATE")==null?"":suitMap.get("TODAY_DATE").toString()            ) + "]]></TODAY_DATE>";
				xml = xml + "<NEXT_DATE><![CDATA["        + (suitMap.get("NEXT_DATE")==null?"":suitMap.get("NEXT_DATE").toString()              ) + "]]></NEXT_DATE>";
			} else if ("SO3".equals(gbn)) {
				// 응소관련자료제출
				HashMap suitMap = suitService.getDocMakeInfo1(mtenMap);
				xml = xml + "<WONGONM><![CDATA["            + (suitMap.get("WONGONM")==null?"":suitMap.get("WONGONM").toString()                      ) + "]]></WONGONM>";
				xml = xml + "<PIGONM><![CDATA["             + (suitMap.get("PIGONM")==null?"":suitMap.get("PIGONM").toString()                        ) + "]]></PIGONM>";
				xml = xml + "<LWS_INCDNT_NM><![CDATA["      + (suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString()          ) + "]]></LWS_INCDNT_NM>";
				xml = xml + "<SPRVSN_DEPT_NM><![CDATA["     + (suitMap.get("SPRVSN_DEPT_NM")==null?"":suitMap.get("SPRVSN_DEPT_NM").toString()        ) + "]]></SPRVSN_DEPT_NM>";
				xml = xml + "<LWS_NO><![CDATA["             + (suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString()                        ) + "]]></LWS_NO>";
				xml = xml + "<CT_NM><![CDATA["              + (suitMap.get("CT_NM")==null?"":suitMap.get("CT_NM").toString()                          ) + "]]></CT_NM>";
				xml = xml + "<INCDNT_NO><![CDATA["          + (suitMap.get("INCDNT_NO")==null?"":suitMap.get("INCDNT_NO").toString()                  ) + "]]></INCDNT_NO>";
				xml = xml + "<WRC_TELNO><![CDATA["          + (suitMap.get("WRC_TELNO")==null?"":suitMap.get("WRC_TELNO").toString()                  ) + "]]></WRC_TELNO>";
				xml = xml + "<LWS_FLFMT_EMP_NM_2><![CDATA[" + (suitMap.get("LWS_FLFMT_EMP_NM_2")==null?"":suitMap.get("LWS_FLFMT_EMP_NM_2").toString()) + "]]></LWS_FLFMT_EMP_NM_2>";
			} else if ("SO4".equals(gbn)) {
				// 협조요청문
				HashMap suitMap = suitService.getDocMakeInfo3(mtenMap);
				xml = xml + "<LWYR_NM><![CDATA["         + (suitMap.get("LWYR_NM")==null?"":suitMap.get("LWYR_NM").toString()              ) + "]]></LWYR_NM>";
				xml = xml + "<LWS_UP_TYPE_NM><![CDATA["  + (suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString()) + "]]></LWS_UP_TYPE_NM>";
				xml = xml + "<CT_NM><![CDATA["           + (suitMap.get("CT_NM")==null?"":suitMap.get("CT_NM").toString()                  ) + "]]></CT_NM>";
				xml = xml + "<INCDNT_NO><![CDATA["       + (suitMap.get("INCDNT_NO")==null?"":suitMap.get("INCDNT_NO").toString()          ) + "]]></INCDNT_NO>";
				xml = xml + "<LWS_INCDNT_NM><![CDATA["   + (suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString()  ) + "]]></LWS_INCDNT_NM>";
				xml = xml + "<WONGO><![CDATA["           + (suitMap.get("WONGO")==null?"":suitMap.get("WONGO").toString()                  ) + "]]></WONGO>";
				xml = xml + "<PIGO><![CDATA["            + (suitMap.get("PIGO")==null?"":suitMap.get("PIGO").toString()                    ) + "]]></PIGO>";
				xml = xml + "<TKCG_DEPT_NM><![CDATA["    + (suitMap.get("TKCG_DEPT_NM")==null?"":suitMap.get("TKCG_DEPT_NM").toString()    ) + "]]></TKCG_DEPT_NM>";
				xml = xml + "<TKCG_EMP_NM><![CDATA["     + (suitMap.get("TKCG_EMP_NM")==null?"":suitMap.get("TKCG_EMP_NM").toString()      ) + "]]></TKCG_EMP_NM>";
				xml = xml + "<TKCG_WRC_TELNO><![CDATA["  + (suitMap.get("TKCG_WRC_TELNO")==null?"":suitMap.get("TKCG_WRC_TELNO").toString()) + "]]></TKCG_WRC_TELNO>";
				xml = xml + "<TKCG_EML_ADDR><![CDATA["   + (suitMap.get("TKCG_EML_ADDR")==null?"":suitMap.get("TKCG_EML_ADDR").toString()  ) + "]]></TKCG_EML_ADDR>";
				
				List suitList = suitService.getDocMakeInfo3_1(mtenMap);
				if (suitList != null && suitList.size() > 0) {
					for(int i=0; i<suitList.size(); i++) {
						HashMap subMap = (HashMap)suitList.get(i);
						xml = xml + "<LWS_FLFMT_DEPT_NM"+(i+1)+"><![CDATA[" + (subMap.get("LWS_FLFMT_DEPT_NM")==null?"":subMap.get("LWS_FLFMT_DEPT_NM").toString()) + "]]></LWS_FLFMT_DEPT_NM"+(i+1)+">";
						xml = xml + "<LWS_FLFMT_EMP_NM"+(i+1)+"><![CDATA["  + (subMap.get("LWS_FLFMT_EMP_NM")==null?"":subMap.get("LWS_FLFMT_EMP_NM").toString()  ) + "]]></LWS_FLFMT_EMP_NM"+(i+1)+">";
						xml = xml + "<WRC_TELNO"+(i+1)+"><![CDATA["         + (subMap.get("WRC_TELNO")==null?"":subMap.get("WRC_TELNO").toString()                ) + "]]></WRC_TELNO"+(i+1)+">";
						xml = xml + "<EML_ADDR"+(i+1)+"><![CDATA["          + (subMap.get("EML_ADDR")==null?"":subMap.get("EML_ADDR").toString()                  ) + "]]></EML_ADDR"+(i+1)+">";
					}
				}
			} else if ("SO5".equals(gbn)) {
				// 판결문 접수에 따른 지원부서 의견요청
				HashMap suitMap = suitService.getDocMakeInfo1(mtenMap);
				xml = xml + "<WONGONM><![CDATA["          + (suitMap.get("WONGONM")==null?"":suitMap.get("WONGONM").toString()                  ) + "]]></WONGONM>";
				xml = xml + "<PIGONM><![CDATA["           + (suitMap.get("PIGONM")==null?"":suitMap.get("PIGONM").toString()                    ) + "]]></PIGONM>";
				xml = xml + "<LWS_INCDNT_NM><![CDATA["    + (suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString()      ) + "]]></LWS_INCDNT_NM>";
				xml = xml + "<SPRVSN_DEPT_NM><![CDATA["   + (suitMap.get("SPRVSN_DEPT_NM")==null?"":suitMap.get("SPRVSN_DEPT_NM").toString()    ) + "]]></SPRVSN_DEPT_NM>";
				xml = xml + "<LWS_NO><![CDATA["           + (suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString()                    ) + "]]></LWS_NO>";
				xml = xml + "<CT_NM><![CDATA["            + (suitMap.get("CT_NM")==null?"":suitMap.get("CT_NM").toString()                      ) + "]]></CT_NM>";
				xml = xml + "<INCDNT_NO><![CDATA["        + (suitMap.get("INCDNT_NO")==null?"":suitMap.get("INCDNT_NO").toString()              ) + "]]></INCDNT_NO>";
				xml = xml + "<TKCG_EMP_NM><![CDATA["      + (suitMap.get("TKCG_EMP_NM")==null?"":suitMap.get("TKCG_EMP_NM").toString()          ) + "]]></TKCG_EMP_NM>";
				xml = xml + "<LWS_FLFMT_EMP_NM><![CDATA[" + (suitMap.get("LWS_FLFMT_EMP_NM")==null?"":suitMap.get("LWS_FLFMT_EMP_NM").toString()) + "]]></LWS_FLFMT_EMP_NM>";
				xml = xml + "<INCDNT_OTLN><![CDATA["      + (suitMap.get("INCDNT_OTLN")==null?"":suitMap.get("INCDNT_OTLN").toString()          ) + "]]></INCDNT_OTLN>";
			}
			xml = xml + "<LWS_MNG_NO><![CDATA["+lwsMngNo+"]]></LWS_MNG_NO>";
			xml = xml + "<INST_MNG_NO><![CDATA["+instMngNo+"]]></INST_MNG_NO>";
			xml = xml + "<docgbn><![CDATA[SUIT]]></docgbn>";
			xml = xml + "<FILE_SE><![CDATA["+gbn+"]]></FILE_SE>";
		}
		
		filenm = filenm + viewnm + ",";
		
		fnm = StringUtils.removeEnd(fnm, ",");
		filenm = StringUtils.removeEnd(filenm, ",");
		
		mtenMap.put("pdata", xml);
		JSONObject jl = bylawService.setAllDown(mtenMap);
		jl.put("fnm", fnm);
		jl.put("filenm", filenm);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping(value="getDeptNode.do")
	public void getDeptNode(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		String node = mtenMap.get("node")==null?"0":mtenMap.get("node").toString();
		if(node.equals("0")) {
			mtenMap.put("node",  ConstantCode.DEPTROOT);
		}
		JSONArray jr = webService.getDeptNode(mtenMap);
		Json4Ajax.commonAjax(jr, response);
	}
	
	@RequestMapping(value="getUserList.do")
	public void getUserList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONArray jr = webService.getUserList(mtenMap);
		JSONObject result=new JSONObject();
    	result.put("records",jr);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="testMsg.do")
	public void testMsg(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		try {
			AlertApi aa = new AlertApi("98.33.11.55", 15010);
			// 기간계 시스템ID/받는 사람([RK]행정포털연계키)/매크로/보내는 이/내용/빈값
			aa.MakePacket("120", "[RK]M81850946ba78", 1, "legal", "테스트 메신저 알림","");
			System.out.println("??????");
			// 박찬우 주무관에게 전송 (테스트성)
			aa.SendPacket();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="testSmS.do")
	public void testSmS(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
		String receiver = "01059100717";
		String title = "법률지원통합시스템 테스트 제목";
		String msg = "법률지원통합시스템 테스트";
		SMSClientSend.sendSMS(receiver, title, msg);
	}
	
	
	@RequestMapping(value = "selectMyWorkList.do")
	public void selectSuitList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) {
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
		
		mtenMap.put("grpcd", userInfo.get("GRPCD")==null?"":userInfo.get("GRPCD").toString());
		mtenMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
		
		JSONObject jl = webService.selectMyWorkList(mtenMap);
		Json4Ajax.commonAjax(jl, response);
	}
	
	@RequestMapping("/searchAPI.do")
	public void searchAPI(Map<String, Object> mtenMap , HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
		HttpSession session = request.getSession();
		HashMap se = (HashMap)session.getAttribute("userInfo");
		System.out.println(session);
		
		String GRPCD = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
		String USERNO = se.get("USERNO")==null?"":se.get("USERNO").toString();
		String DEPTCD = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
		
		String sAdminYn = "N";	// 소송관리자여부
		String aAdminYn = "N";	// 협약관리자여부
		String cAdminYn = "N";	// 자문관리자여부
		
		if (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("G") > -1) {
			sAdminYn = "Y";
			aAdminYn = "Y";
			cAdminYn = "Y";
		} else if (GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1 || GRPCD.indexOf("E") > -1 || GRPCD.indexOf("D") > -1) {
			sAdminYn = "Y";
			aAdminYn = "N";
			cAdminYn = "N";
		} else if (GRPCD.indexOf("F") > -1) {
			sAdminYn = "N";
			aAdminYn = "Y";
			cAdminYn = "Y";
		} else if (GRPCD.indexOf("J") > -1 || GRPCD.indexOf("M") > -1 || GRPCD.indexOf("Q") > -1) {
			sAdminYn = "N";
			aAdminYn = "N";
			cAdminYn = "Y";
		} else if (GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N") > -1 || GRPCD.indexOf("R") > -1) {
			sAdminYn = "N";
			aAdminYn = "Y";
			cAdminYn = "N";
		}
		
		String strUrl = "http://98.33.0.118:8530";
		strUrl += "/search_post";
		
		// 1) 클라이언트에서 넘어온 모든 파라미터를 가져온다
		Map<String,String[]> incoming = request.getParameterMap();
		
		// 2) proxy용 Map<String,Object> 로 변환
		Map<String,Object> params = new LinkedHashMap<>();
		for (Map.Entry<String,String[]> entry : incoming.entrySet()) {
		    String key   = entry.getKey();
		    String[] vals = entry.getValue();
		    // 배열일 경우 첫 번째 값만 넘기거나, 필요에 따라 String.join(",", vals) 등으로 합치면 됩니다
		    if (vals != null && vals.length > 0) {
		        params.put(key, vals[0]);
		    }
		}
		
		params.put("sAdminYn", sAdminYn);
		params.put("aAdminYn", aAdminYn);
		params.put("cAdminYn", cAdminYn);
		
		params.put("USERNO", USERNO);
		params.put("DEPTCD", DEPTCD);
		
		//Post
		StringBuilder postData = new StringBuilder();
		for(Map.Entry<String,Object> param : params.entrySet()) {
			if(postData.length() != 0) postData.append('&');
			postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
			postData.append('=');
			postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
		}
		byte[] postDataBytes = postData.toString().getBytes("UTF-8");

		try {		
			URL url = new URL(strUrl);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
			con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
			con.setRequestMethod("POST");
	        con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
	        con.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
	        con.setDoOutput(true);
	        con.getOutputStream().write(postDataBytes); // POST 호출

			StringBuilder sb = new StringBuilder();
			if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
				//Stream을 처리해줘야 하는 귀찮음이 있음. 
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {				
					sb.append(line).append("\n");
				}
				br.close();
				System.out.println("" + sb.toString());
				
			} else {
				System.out.println(con.getResponseMessage());
			}
			
			String test = "" + sb.toString();
			
			JSONObject jl = JSONObject.fromObject(test);
			Json4Ajax.commonAjax(jl, response);
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
}
