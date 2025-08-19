package com.mten.bylaw.law.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.law.service.LawService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.util.BindObject;
import com.mten.util.CommonMakeExcel;
import com.mten.util.Json4Ajax;
import com.mten.util.JsonHelper;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/web/law/")
public class LawController extends DefaultController{
	
	@Resource(name="lawService")
	private LawService lawService;
	
	@RequestMapping(value="goLawMain.do")
	public String goLawMain(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "law/lawMain.web";
	}
	
	@RequestMapping(value="koreaLawList.do")
	public String koreaLawList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "law/koreaLawList.frm";
	}
	
	@RequestMapping(value="koreaLawListData.do")
	public void koreaLawListData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
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
		
		JSONObject result = lawService.koreaLawListData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="lawViewPage.do")
	public String lawViewPage(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap result = lawService.getLawBon(mtenMap);
		model.addAttribute("param", mtenMap);
		model.addAttribute("bonInfo", result);
		return "law/lawViewPage.frm";
	}
	
	@RequestMapping(value="lawViewPagePop.do")
	public String lawViewPagePop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println(mtenMap);
		HashMap result = lawService.getLawBon(mtenMap);
		model.addAttribute("param", mtenMap);
		model.addAttribute("bonInfo", result);
		return "law/lawViewPagePop.frm";
	}
	
	@RequestMapping(value="koreaByLawList.do")
	public String koreaByLawList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "law/koreaByLawList.frm";
	}
	
	@RequestMapping(value="koreaByLawListData.do")
	public void koreaByLawListData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
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
		
		JSONObject result = lawService.koreaByLawListData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="bylawViewPage.do")
	public String bylawViewPage(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap result = lawService.getByLawBon(mtenMap);
		model.addAttribute("param", mtenMap);
		model.addAttribute("bonInfo", result);
		return "law/bylawViewPage.frm";
	}
	
	@RequestMapping(value="bylawViewPagePop.do")
	public String bylawViewPagePop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap result = lawService.getByLawBon(mtenMap);
		model.addAttribute("param", mtenMap);
		model.addAttribute("bonInfo", result);
		return "law/bylawViewPagePop.frm";
	}
	
	@RequestMapping(value="etcList.do")
	public String etcList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "law/etcList.frm";
	}
	
	@RequestMapping(value="etcListData.do")
	public void etcListData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = lawService.etcListData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="favList.do")
	public String favList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "law/favList.frm";
	}
	
	@RequestMapping(value="favListData.do")
	public void favListData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = lawService.favListData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="getData.do")
	public void getData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
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
		
		JSONObject result = lawService.getData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="getMenuData.do")
	public void getMenuData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = lawService.getMenuData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="getDataMN.do")
	public void getDataMN(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String datacd = mtenMap.get("datacd")==null?"":mtenMap.get("datacd").toString();
		if(datacd.equals("I")) {
			lawService.insertMapping(mtenMap);
		}else if(datacd.equals("U")) {
			lawService.updateMapping(mtenMap);
		}else if(datacd.equals("D")) {
			lawService.deleteMapping(mtenMap);
		}
	}
	
	@RequestMapping(value="createHwp.do")
	public String createHwp(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String TYPE = mtenMap.get("TYPE")==null?"":mtenMap.get("TYPE").toString();
		HashMap result = new HashMap();
		String urlInfo = "";
		if(TYPE.equals("LAW")) {
			result = lawService.getLawBon(mtenMap);
			urlInfo = "law/lawPrint.dll";
		}else if(TYPE.equals("BYLAW")) {
			result = lawService.getByLawBon(mtenMap);
			urlInfo = "law/bylawPrint.dll";
		}
		model.addAttribute("param", mtenMap);
		model.addAttribute("bonInfo", result);
		return urlInfo;
	}
	
	@RequestMapping(value="multipleView.do")
	public String multipleView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "law/multipleView.frm";
	}
	
	@RequestMapping(value="bonPop.do")
	public void bonPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println("mtenMap===>"+mtenMap);
		String GBN = mtenMap.get("GBN")==null?"":mtenMap.get("GBN").toString();
		String durl = "";
		HashMap result = new HashMap();
		if(GBN.equals("LAW")){
			result = lawService.getLawBon(mtenMap);
			model.addAttribute("bonInfo", result);
		}else if(GBN.equals("BYLAW")){
			mtenMap.put("BYLAWID", mtenMap.get("LAWID"));
			result = lawService.getByLawBon(mtenMap);
			model.addAttribute("bonInfo", result);
		}
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println(result.get("bon"));
			writer.close();
		}
		catch (IOException ioe) {
		}
	}
	
	@RequestMapping(value="schlawList.do")
	public ModelAndView schlawList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject jr = lawService.schlawList(mtenMap,req);
		return addResponseData(jr);	
	}
	
	@RequestMapping(value="3_popup.do")
	public String popup3(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		return "law/3_popup.frm";
	}
	
	@RequestMapping(value="lawView.do")
	public String lawView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap result = lawService.getLawBon(mtenMap);
		model.addAttribute("param", mtenMap);
		model.addAttribute("bonInfo", result);
		return "law/lawView.frm";
	}
	
	@RequestMapping(value="koreaLawListDataMakeExcel.do")
	public void koreaLawListDataMakeExcel(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println(mtenMap);
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
		
		JSONObject result = lawService.koreaLawListData(mtenMap);
		
		List datalist = JsonHelper.toList((JSONArray)result.get("result"));
		
		String sTit = "대한민국 현행 법령";
		ArrayList<String> columnList = new ArrayList<String>();	//데이터컬럼명
		ArrayList<String> columnRList = new ArrayList<String>();	//화면용컬럼명
		columnRList.add("법령명");
		columnRList.add("제/개정구분");
		columnRList.add("관련부처");
		columnRList.add("법령구분");
		columnRList.add("공포번호");
		columnRList.add("공포일");
		columnRList.add("시행일");
		
		columnList.add("LAWNAME");
		columnList.add("REVCD");
		columnList.add("DEPT");
		columnList.add("LAWGBN");
		columnList.add("PROMULNO");
		columnList.add("PROMULDT");
		columnList.add("STARTDT");
		CommonMakeExcel.makeExcel(sTit, columnList, columnRList, datalist, req, response);
	}
	
	@RequestMapping(value="koreaByLawListDataMakeExcel.do")
	public void koreaByLawListDataMakeExcel(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
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
		
		JSONObject result = lawService.koreaByLawListData(mtenMap);
		
		List datalist = JsonHelper.toList((JSONArray)result.get("result"));
		
		String sTit = "타기관 행정 규칙";
		ArrayList<String> columnList = new ArrayList<String>();	//데이터컬럼명
		ArrayList<String> columnRList = new ArrayList<String>();	//화면용컬럼명
		columnRList.add("행정규칙명");
		columnRList.add("행정규칙종류");
		columnRList.add("발령일자");
		columnRList.add("발령번호");
		columnRList.add("소관부처명");
		columnRList.add("제개정구분명");
		columnRList.add("시행일자");
		
		columnList.add("BYLAWNAME");
		columnList.add("BYLAWCD");
		columnList.add("APPOINTDT");
		columnList.add("APPOINTNO");
		columnList.add("BYLAWDEPT");
		columnList.add("REVCD");
		columnList.add("STARTDT");
		CommonMakeExcel.makeExcel(sTit, columnList, columnRList, datalist, req, response);
	}
	
	@RequestMapping(value="etcListDataMakeExcel.do")
	public void etcListDataMakeExcel(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = lawService.etcListData(mtenMap);
		List datalist = JsonHelper.toList((JSONArray)result.get("result"));
		
		String sTit = "고양시청 관련 법령";
		ArrayList<String> columnList = new ArrayList<String>();	//데이터컬럼명
		ArrayList<String> columnRList = new ArrayList<String>();	//화면용컬럼명
		columnRList.add("법령명");
		columnRList.add("제/개정구분");
		columnRList.add("관련부처");
		columnRList.add("법령구분");
		columnRList.add("공포일");
		
		columnList.add("LAWNAME");
		columnList.add("REVCD");
		columnList.add("DEPT");
		columnList.add("LAWGBN");
		columnList.add("PROMULDT");
		CommonMakeExcel.makeExcel(sTit, columnList, columnRList, datalist, req, response);
	}
	
	@RequestMapping(value="favListDataMakeExcel.do")
	public void favListDataMakeExcel(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = lawService.favListData(mtenMap);
		List datalist = JsonHelper.toList((JSONArray)result.get("result"));
		
		String sTit = "즐겨찾는 법률정보";
		ArrayList<String> columnList = new ArrayList<String>();	//데이터컬럼명
		ArrayList<String> columnRList = new ArrayList<String>();	//화면용컬럼명
		columnRList.add("법령명");
		columnRList.add("제/개정구분");
		columnRList.add("관련부처");
		columnRList.add("법령구분");
		columnRList.add("공포일");
		
		columnList.add("LAWNAME");
		columnList.add("REVCD");
		columnList.add("DEPT");
		columnList.add("LAWGBN");
		columnList.add("PROMULDT");
		CommonMakeExcel.makeExcel(sTit, columnList, columnRList, datalist, req, response);
	}
}
