package com.mten.bylaw.statistics.controller;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Hashtable;
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

import com.mten.bylaw.statistics.service.StatisticsService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Controller
@RequestMapping("/web/statistics/")
public class StatisticsController {
	
	@Resource(name="statisticsService")
	private StatisticsService statisticsService;
	
	@Resource(name = "suitService")
	private SuitService suitService;
	
	@RequestMapping(value="goStsMain.do")
	public String goPdsMain(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "sts/goStsMain.web";
	}
	
	@RequestMapping("/{page1}")
	public String lawSearch(@PathVariable String page1 , Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		if (page1.indexOf("Suit") > -1) {
			HashMap param = new HashMap();
			param.put("type", "suit");
			List codeList = suitService.getCodeList(param);
			model.addAttribute("codeList", codeList);
		}
		model.addAttribute("param", mtenMap);
		
		return "sts/"+page1+".frm";
	}
	
	@RequestMapping(value="setMenuLog.do")
	public void setMenuLog(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model){
		HttpSession session = req.getSession();
		HashMap h = (HashMap)session.getAttribute("userInfo");
		h.put("MENU_MNG_NO", mtenMap.get("MENU_MNG_NO"));
		statisticsService.setMenuLog(h);
		h.remove("MENU_MNG_NO");
	}
	
	@RequestMapping(value="setWordLog.do")
	public void setWordLog(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model){
		statisticsService.setWordLog(mtenMap);
	}
	
	@RequestMapping("/getSystemLogList.do")
	public void getSystemLogList(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.getSystemLogList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/getMenuLogList.do")
	public void getMenuLogList(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.getMenuLogList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/getSystemDeptLogList.do")
	public void getSystemDeptLogList(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.getSystemDeptLogList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/getWordLogList.do")
	public void getWordLogList(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.getWordLogList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/stsRuleData9.do")
	public void stsRule9(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONArray result = statisticsService.stsRule9(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/getBylaw1.do")
	public void getBylaw1(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
			List slist = statisticsService.bylawstatistics1(mtenMap);
			List slist2 = statisticsService.bylawstatisticsD1(mtenMap);
			
			JSONObject result = new JSONObject();
			JSONArray jl = new JSONArray();
			JSONArray jl2 = new JSONArray();
			JSONObject jre2 = new JSONObject();
			for(int i=0; i<slist.size(); i++){
				HashMap re = (HashMap)slist.get(i);
				JSONObject jre = new JSONObject();
				Set key = re.keySet();
				boolean st = true;
				for (Iterator iterator = key.iterator(); iterator.hasNext();) {
					 Object keyName = iterator.next();
					 Object valueName = re.get(keyName);
					jre.put(keyName, valueName);
					if(keyName.toString().equals("STATEID")){
						if(jre.get("STATEID").toString().equals("5000")||jre.get("STATEID").toString().equals("6000")||jre.get("STATEID").toString().equals("7000")){
							st = false;
						}
					}
				}
				if(st){
					jl.add(jre);
				}else{
					if(jre.get("STATEID").toString().equals("5000")){
						jre2.put("CNT1", jre.get("CNT"));
					}
					if(jre.get("STATEID").toString().equals("6000")){
						jre2.put("CNT2", jre.get("CNT"));
					}
					if(jre.get("STATEID").toString().equals("7000")){
						jre2.put("CNT3", jre.get("CNT"));
					}
				}
			}
			jl2.add(jre2);
			result.put("data1", jl2);
			result.put("data2", slist);
			
			result.put("data3", slist2); 
			Json4Ajax.commonAjax(result, response);	
	} 
	
	@RequestMapping("/getBylaw2.do")
	public void getBylaw2(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		
		JSONArray slist = statisticsService.bylawstatistics2(mtenMap);
		JSONObject result = new JSONObject();
		result.put("data", slist);
		Json4Ajax.commonAjax(result, response);	
	} 
	
	@RequestMapping("/getBylaw3.do")
	public void getBylaw3(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String year = mtenMap.get("year")==null?"":mtenMap.get("year").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray slist = statisticsService.bylawstatistics3(mtenMap);
			
		if(!year.equals("")){
			slist = statisticsService.bylawstatistics2(mtenMap);
		}
			
		JSONObject result = new JSONObject();
		result.put("data", slist);
			
		Json4Ajax.commonAjax(result, response);	
	} 
	
	@RequestMapping("/getBylaw4.do")
	public void getBylaw4(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String obookid = mtenMap.get("obookid")==null?"":mtenMap.get("obookid").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray slist = statisticsService.bylawstatistics4(mtenMap);
			
		if(!obookid.equals("")){
			slist = statisticsService.bylawstatistics2(mtenMap);
		}
			
		JSONObject result = new JSONObject();
		result.put("data", slist);

		Json4Ajax.commonAjax(result, response);	
	} 
	
	@RequestMapping("/getBylaw5.do")
	public void getBylaw5(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String year = mtenMap.get("year")==null?"":mtenMap.get("year").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		System.out.println("mtenMap===>"+mtenMap);
		JSONArray slist = statisticsService.bylawstatistics5(mtenMap);
			
		if(!year.equals("")){
			slist = statisticsService.bylawstatisticsD5(mtenMap);
		}
			
		JSONObject result = new JSONObject();
		result.put("data", slist);
		
		Json4Ajax.commonAjax(result, response);	
	} 
	
	@RequestMapping("/getBylaw6.do")
	public void getBylaw6(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dept = mtenMap.get("dept")==null?"":mtenMap.get("dept").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray slist = statisticsService.bylawstatistics6(mtenMap);
			
		if(!dept.equals("")){
			slist = statisticsService.bylawstatisticsD6(mtenMap);
		}
			
		JSONObject result = new JSONObject();
		result.put("data", slist);
			
		Json4Ajax.commonAjax(result, response);	
	} 
	
	@RequestMapping("/getBylaw7.do")
	public void getBylaw7(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONArray slist = statisticsService.bylawstatistics7(mtenMap);
		JSONObject result = new JSONObject();
		result.put("data", slist);
		Json4Ajax.commonAjax(result, response);
	} 
	

	@RequestMapping("/getBylaw10.do")
	public void getBylaw10(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String deptname = mtenMap.get("deptname")==null?"":mtenMap.get("deptname").toString();
		JSONArray slist = statisticsService.bylawstatistics10(mtenMap);
			
		if(!deptname.equals("")){
			slist = statisticsService.bylawstatisticsD10(mtenMap);
		}
		JSONObject result = new JSONObject();
		result.put("data", slist);
		Json4Ajax.commonAjax(result, response);	
	} 
	
	///////////////// 소송 통계
	@RequestMapping("/getSuit1.do")
	public void getSuit1(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 소송 승·패소 현황
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics1(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit2.do")
	public void getSuit2(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 수행중 소송사건 유형별
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics2(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit3.do")
	public void getSuit3(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 패소 현황
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics3(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit4.do")
	public void getSuit4(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 판결금 현황
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics4(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit5.do")
	public void getSuit5(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 진행 중 중요소송 현황
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics5(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit6.do")
	public void getSuit6(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 중요소송 지정사건 현황(총괄)
		JSONObject result = new JSONObject();
		List list1 = statisticsService.suitstatistics6_1(mtenMap);
		List list2 = statisticsService.suitstatistics6_2(mtenMap);
		List list3 = statisticsService.suitstatistics6_3(mtenMap);
		result.put("data1", list1);
		result.put("data2", list2);
		result.put("data3", list3);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit7.do")
	public void getSuit7(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 중요소송 종결사건
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics7(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit8.do")
	public void getSuit8(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 소송심의회 위원현황
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics8(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit9.do")
	public void getSuit9(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 소송비용 회수현황
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics9(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit10.do")
	public void getSuit10(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 중요소송 지정사건 현황(총괄)
		JSONObject result = new JSONObject();
		List list1 = statisticsService.suitstatistics10_1(mtenMap);
		List list2 = statisticsService.suitstatistics10_2(mtenMap);
		result.put("data1", list1);
		result.put("data2", list2);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit11.do")
	public void getSuit11(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 진행중사건목록
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics11(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit12.do")
	public void getSuit12(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 법률고문 수임 현황
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics12(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit13.do")
	public void getSuit13(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 담당별사건수
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics13(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit14.do")
	public void getSuit14(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 부서별사건수
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics14(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit15.do")
	public void getSuit15(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 소송대장
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics15(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit16.do")
	public void getSuit16(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 소송위임비용 E-호조
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics16(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSuit17.do")
	public void getSuit17(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 소송비용(인지,송달 등) E-호조
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.suitstatistics17(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	
	
	
	
	
	
	
	@RequestMapping("/getSystem3.do")
	public void getSystem3(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 법률고문 수행실적, 법률고문 재임기간
		JSONObject result = new JSONObject();
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		List list1 = statisticsService.systemstatistics3_1(mtenMap);
		List list2 = statisticsService.systemstatistics3_2(mtenMap);
		result.put("data1", list1);
		result.put("data2", list2);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSystem4.do")
	public void getSystem4(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 법률고문 현황
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.systemstatistics4(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getSystem5.do")
	public void getSystem5(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) {
		// 법률고문 소송수행 및 법률자문 현황
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.systemstatistics5(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	
	
	
	@RequestMapping(value="sendSms.do")
	public void sendSms(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model){
		JSONObject result = statisticsService.sendSms(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/getConsult1.do")
	public void getConsult1(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.consultstatistics1(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getConsult2.do")
	public void getConsult2(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.consultstatistics2(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getConsult3.do")
	public void getConsult3(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.consultstatistics3(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getConsult4.do")
	public void getConsult4(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.consultstatistics4(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/getConsult5.do")
	public void getConsult5(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONArray result = statisticsService.consultstatistics5(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/stsAgree1.do")
	public void stsAgree1(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.agreestatistics1(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/stsAgree2.do")
	public void stsAgree2(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.agreestatistics2(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	@RequestMapping("/stsAgree3.do")
	public void stsAgree3(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String searchGbn = mtenMap.get("searchGbn")==null?"d":mtenMap.get("searchGbn").toString();
		String dateFormat = "YYYY-MM-DD"; //쿼리에 사용되는 날짜 형식을 지정
		if("m".equals(searchGbn)){
			dateFormat = "YYYY-MM";
		}else if("y".equals(searchGbn)){
			dateFormat = "YYYY";
		}	
		mtenMap.put("dateFormat", dateFormat);
		JSONArray result = statisticsService.agreestatistics3(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
}
