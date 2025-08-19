package com.mten.bylaw.law.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLEncoder;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.law.service.LawService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.util.BindObject;
import com.mten.util.CommonMakeExcel;
import com.mten.util.Json4Ajax;
import com.mten.util.JsonHelper;
import com.mten.util.MakeHan;
import com.mten.util.StringUtil;
import com.sun.syndication.feed.synd.SyndEntry;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.io.SyndFeedInput;
import com.sun.syndication.io.XmlReader;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/web/lawapi/")
public class LawApiController extends DefaultController{
	
	@Resource(name="lawService")
	private LawService lawService;
	
	@RequestMapping("/{page1}")
	public String goApiPage(@PathVariable String page1 , Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "law/api/"+page1+".frm";
	}
	
	@RequestMapping("/apiData.do")
	public void goApiPage(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String datacd = request.getParameter("datacd")==null?"":request.getParameter("datacd");
		int start = ServletRequestUtils.getIntParameter(request,"start",0);
		int limit = ServletRequestUtils.getIntParameter(request,"limit",0);
		int pageno =0;
		if(start==0){
			pageno = 1;
		}else{
			pageno = start/15 + 1;
		}
		System.out.println(request.getParameterMap());
		JSONArray lList = new JSONArray();
		JSONObject result = new JSONObject();	
		if(datacd.equals("law")){
			String gana = request.getParameter("gana")==null?"":request.getParameter("gana");
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String nw = request.getParameter("nw")==null?"3":request.getParameter("nw");				//현행,연혁 구분 (연혁=1,현행=3)
			String ancYd1 = request.getParameter("ancYd1")==null?"":request.getParameter("ancYd1");	//공포일 시작
			String ancYd2 = request.getParameter("ancYd2")==null?"":request.getParameter("ancYd2");	//공포일 끝
			String ancYd = request.getParameter("ancYd")==null?"":request.getParameter("ancYd");	//공포일범위검색(20090101~20090130)
			String efYd1 = request.getParameter("efYd1")==null?"":request.getParameter("efYd1");	//시행일 시작
			String efYd2 = request.getParameter("efYd2")==null?"":request.getParameter("efYd2");	//시행일 끝
			String efYd = request.getParameter("efYd")==null?"":request.getParameter("efYd");	//시행일 범위검색(20090101~20090130)
			String ancNo1 = request.getParameter("ancNo1")==null?"":request.getParameter("ancNo1");	//공포번호 시작
			String ancNo2 = request.getParameter("ancNo2")==null?"":request.getParameter("ancNo2");	//공포번호 끝
			String ancNo = request.getParameter("ancNo")==null?"":request.getParameter("ancNo");	//공포번호 범위검색
			String nb = request.getParameter("nb")==null?"":request.getParameter("nb");				//공포번호
			String date = request.getParameter("date")==null?"":request.getParameter("date");		//공포일자
			String date1 = request.getParameter("date1")==null?"":request.getParameter("date1");		//공포일자
			String org = request.getParameter("org")==null?"":request.getParameter("org");			//소관부처
			String sort = request.getParameter("sort")==null?"dasc":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("title")) {
				sort="l";
			}else if(sort.equals("promulno")) {
				sort="n";
			}else if(sort.equals("promuldt")) {
				sort="d";
			}else if(sort.equals("startdt")) {
				sort="ef";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			if(pageno2.equals(""))pageno2="1";
			String search_sch = "";
			String gana_sch = "";
			String query_sch = "";	//검색어
			String nw_sch = "";				//현행,연혁 구분 (연혁=1,현행=3)
			String ancYd_sch = "";	//공포일범위검색
			String efYd_sch = "";	//시행일 범위검색
			String ancNo_sch = "";	//공포번호 범위검색
			String nb_sch = "";				//공포번호
			String date_sch = "";		//공포일자
			String org_sch = "";			//소관부처
			String sort_sch="";
			String histGbn="";
			if(nw.equals("3")||nw.equals("")){
				histGbn = "현행";
			}else{
				histGbn = "연혁";
			}
			String Smenu = "";
			if(search.equals("1")){
				Smenu = "제목";
			}else{
				Smenu = "제목내용";		
			}
			if(!search.equals(""))search_sch="&search="+search;
			if(!gana.equals(""))gana_sch="&gana="+gana;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!nw.equals(""))nw_sch="&nw="+nw;
			if(!ancYd.equals("")&&!ancYd.equals("~"))ancYd_sch="&ancYd="+ancYd;
			if(!efYd.equals("")&&!efYd.equals("~"))efYd_sch="&efYd="+efYd;
			if(!ancNo.equals("")&&!ancNo.equals("~"))ancNo_sch="&ancNo="+ancNo;
			if(!nb.equals(""))nb_sch="&nb="+nb;
			if(!date.equals(""))date_sch="&date="+date;
			if(!org.equals(""))org_sch="&org="+org;
			if(!sort.equals(""))sort_sch="&sort="+sort;
			
			String para = query_sch+nw_sch+ancYd_sch+efYd_sch+ancNo_sch+nb_sch+date_sch+org_sch+gana_sch+sort_sch+search_sch+"&page="+pageno;
			System.out.println("para==>"+para);
			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListH(para);
			}catch(Exception e){
				
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("법령명한글").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				dd.put("title", tit);
				dd.put("lawid", data.get("법령ID"));
				dd.put("ord", data.get("번호"));
				dd.put("dlink", data.get("법령상세링크"));
				dd.put("dept", data.get("소관부처명").toString().equals("")?"":data.get("소관부처명"));
				dd.put("revcd", data.get("제개정구분명"));
				dd.put("lawcd", data.get("법령구분명"));
				dd.put("promulno", data.get("공포번호").toString().equals("")?"&nbsp;":"제"+data.get("공포번호")+"호");
				dd.put("promuldt", data.get("공포일자").toString().equals("")?"&nbsp;":data.get("공포일자").toString().substring(0,4)+"-"+data.get("공포일자").toString().substring(4,6)+"-"+data.get("공포일자").toString().substring(6,8));
				dd.put("startdt", data.get("시행일자").toString().equals("")?"&nbsp;":data.get("시행일자").toString().substring(0,4)+"-"+data.get("시행일자").toString().substring(4,6)+"-"+data.get("시행일자").toString().substring(6,8));
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}else if(datacd.equals("bylaw")){
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String nw = request.getParameter("nw")==null?"3":request.getParameter("nw");				//현행,연혁 구분 (연혁=1,현행=3)
			String org = request.getParameter("org")==null?"":request.getParameter("org");			//소관부처
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			if(pageno2.equals(""))pageno2="1";
			
			String sort = request.getParameter("sort")==null?"dasc":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("title")) {
				sort="l";
			}else if(sort.equals("promulno")) {
				sort="n";
			}else if(sort.equals("promuldt")) {
				sort="d";
			}else if(sort.equals("startdt")) {
				sort="ef";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			
			String histGbn="";
			if(nw.equals("3")||nw.equals("")){
				histGbn = "현행";
			}else{
				histGbn = "연혁";
			}
			String Smenu = "";
			if(search.equals("1")){
				Smenu = "제목";
			}else{
				Smenu = "제목내용";		
			}
			
			String search_sch = "";
			String query_sch = "";	//검색어
			String nw_sch = "";				//현행,연혁 구분 (연혁=1,현행=3)
			String org_sch = "";			//소관부처
			String sort_sch="";
			
			if(!search.equals(""))search_sch="&search="+search;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!nw.equals(""))nw_sch="&nw="+nw;
			if(!org.equals(""))org_sch="&org="+org;
			if(!sort.equals(""))sort_sch="&sort="+sort;
			
			String para = query_sch+nw_sch+org_sch+search_sch+sort_sch+"&page="+pageno;
			
			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListBylaw(para);
			}catch(Exception e){
				
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("행정규칙명").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				dd.put("title", tit);
				dd.put("lawid", data.get("행정규칙ID"));
				dd.put("ord", data.get("번호"));
				dd.put("dlink", data.get("행정규칙상세링크"));
				dd.put("dept", data.get("소관부처명").toString().equals("")?"":data.get("소관부처명"));
				dd.put("revcd", data.get("제개정구분명"));
				dd.put("lawcd", data.get("행정규칙종류"));
				dd.put("promulno", data.get("발령번호")==""?"&nbsp;":"제"+data.get("발령번호")+"호");
				dd.put("promuldt", data.get("발령일자")==""?"&nbsp;":data.get("발령일자").toString().substring(0,4)+"-"+data.get("발령일자").toString().substring(4,6)+"-"+data.get("발령일자").toString().substring(6,8));
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}else if(datacd.equals("byul")){
			String gana = request.getParameter("gana")==null?"":request.getParameter("gana");
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String sort = request.getParameter("sort")==null?"ddes":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String org = request.getParameter("org")==null?"":request.getParameter("org");			//소관부처
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			if(pageno2.equals(""))pageno2="1";
			
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("byult")) {
				sort="l";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			
			String search_sch = "";
			String gana_sch = "";
			String query_sch = "";	//검색어
			String sort_sch="";
			String histGbn = "현행";
			String org_sch = "";			//소관부처
			
			String Smenu = "";
			if(search.equals("1")){
				Smenu = "제목";
			}else{
				Smenu = "제목내용";		
			}
			if(!search.equals(""))search_sch="&search="+search;
			if(!gana.equals(""))gana_sch="&gana="+gana;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!sort.equals(""))sort_sch="&sort="+sort;
			if(!org.equals(""))org_sch="&org="+org;
			
			String para = query_sch+gana_sch+sort_sch+org_sch+search_sch+"&page="+pageno;
			System.out.println("para="+para);
			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListLI(para);
			}catch(Exception e){
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("별표명").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				dd.put("byult", tit);
				dd.put("lawt", data.get("관련법령명")==null?"&nbsp;":data.get("관련법령명"));
				dd.put("ord", data.get("번호"));
				dd.put("filen", data.get("별표서식파일링크"));
				dd.put("dlink", data.get("별표법령상세링크"));
				dd.put("byulcd", data.get("별표종류")==""?"&nbsp;":data.get("별표종류"));
				dd.put("dept", data.get("소관부처명").toString().equals("")?"":data.get("소관부처명"));
				dd.put("promulno", data.get("공포번호")==""?"&nbsp;":"제"+data.get("공포번호")+"호");
				dd.put("promuldt", data.get("공포일자")==""?"&nbsp;":data.get("공포일자").toString().substring(0,4)+"-"+data.get("공포일자").toString().substring(4,6)+"-"+data.get("공포일자").toString().substring(6,8));
				dd.put("revcd", data.get("제개정구분명"));
				dd.put("lawcd", data.get("법령종류")==null?"&nbsp;":data.get("법령종류"));
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}else if(datacd.equals("slaw")){
			String gana = request.getParameter("gana")==null?"":request.getParameter("gana");
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String sort = request.getParameter("sort")==null?"ddes":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			String sborg = request.getParameter("sborg")==null?"":request.getParameter("sborg");
			if(pageno2.equals(""))pageno2="1";
			
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("title")) {
				sort="l";
			}else if(sort.equals("promulno")) {
				sort="n";
			}else if(sort.equals("promuldt")) {
				sort="d";
			}else if(sort.equals("startdt")) {
				sort="ef";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			
			String search_sch = "";
			String gana_sch = "";
			String query_sch = "";	//검색어
			String sort_sch="";
			String sborg_sch="";
			String histGbn = "현행";
			
			String Smenu = "";
			if(search.equals("1")){
				Smenu = "제목";
			}else{
				Smenu = "제목내용";		
			}
			if(!search.equals(""))search_sch="&search="+search;
			if(!gana.equals(""))gana_sch="&gana="+gana;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!sort.equals(""))sort_sch="&sort="+sort;
			if(!sborg.equals(""))sborg_sch="&sborg="+sborg;
			
			String para = query_sch+gana_sch+sort_sch+search_sch+sborg_sch+"&page="+pageno;

			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListOR(para);
			}catch(Exception e){
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("자치법규명").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				dd.put("title", tit);
				dd.put("ord", data.get("번호"));
				dd.put("bookcd", data.get("자치법규분야명")==null?"":data.get("자치법규분야명").toString().equals("")?"&nbsp;":data.get("자치법규분야명"));
				dd.put("dlink", data.get("자치법규상세링크"));
				dd.put("startdt", data.get("시행일자")==null?"":data.get("시행일자").toString().equals("")?"&nbsp;":data.get("시행일자").toString().substring(0,4)+"-"+data.get("시행일자").toString().substring(4,6)+"-"+data.get("시행일자").toString().substring(6,8));
				dd.put("dept", data.get("지자체기관명")==null?"":data.get("지자체기관명").toString().equals("")?"&nbsp;":data.get("지자체기관명"));
				dd.put("promulno", data.get("공포번호")==null?"":data.get("공포번호").toString().equals("")?"&nbsp;":"제"+data.get("공포번호")+"호");
				dd.put("promuldt", data.get("공포일자")==null?"":data.get("공포일자").toString().equals("")?"&nbsp;":data.get("공포일자").toString().substring(0,4)+"-"+data.get("공포일자").toString().substring(4,6)+"-"+data.get("공포일자").toString().substring(6,8));
				dd.put("revcd", data.get("제개정구분명")==null?"":data.get("제개정구분명").toString().equals("")?"&nbsp;":data.get("제개정구분명"));
				dd.put("lawcd", data.get("자치법규종류")==null?"":data.get("자치법규종류").toString().equals("")?"&nbsp;":data.get("자치법규종류"));
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}else if(datacd.equals("pan")){
			String gana = request.getParameter("gana")==null?"":request.getParameter("gana");
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String sort = request.getParameter("sort")==null?"ddes":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			if(pageno2.equals(""))pageno2="1";
			
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("title")) {
				sort="l";
			}else if(sort.equals("cname")) {
				sort="n";
			}else if(sort.equals("pandt")) {
				sort="d";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			
			String search_sch = "";
			String gana_sch = "";
			String query_sch = "";	//검색어
			String sort_sch="";
			String histGbn = "현행";
			
			String Smenu = "";
			if(search.equals("1")){
				Smenu = "제목";
			}else{
				Smenu = "제목내용";		
			}
			if(!search.equals(""))search_sch="&search="+search;
			if(!gana.equals(""))gana_sch="&gana="+gana;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!sort.equals(""))sort_sch="&sort="+sort;
			
			String para = query_sch+gana_sch+sort_sch+search_sch+"&page="+pageno;

			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListP(para);
			}catch(Exception e){
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("사건명").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				String pagu = data.get("판결유형").toString();
				dd.put("title", tit);
				dd.put("ord", data.get("번호"));
				dd.put("dlink", data.get("판례상세링크"));
				dd.put("caseno", data.get("사건번호").toString().equals("")?"&nbsp;":data.get("사건번호"));
				dd.put("announ", data.get("선고").toString().equals("")?"&nbsp;":data.get("선고"));
				dd.put("cname", data.get("법원명"));
				dd.put("casecd", data.get("사건종류명").toString().equals("")?"&nbsp;":data.get("사건종류명"));
				dd.put("pancd", StringUtil.null2nbsp(StringUtil.cutstring(pagu, 6)));
				dd.put("pandt", data.get("선고일자").toString().equals("")?"&nbsp;":data.get("선고일자").toString().substring(0,4)+"-"+data.get("선고일자").toString().substring(5,7)+"-"+data.get("선고일자").toString().substring(8,10));
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}else if(datacd.equals("lawex")){
			String gana = request.getParameter("gana")==null?"":request.getParameter("gana");
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String sort = request.getParameter("sort")==null?"ddes":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			if(pageno2.equals(""))pageno2="1";
			
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("title")) {
				sort="l";
			}else if(sort.equals("anno")) {
				sort="n";
			}else if(sort.equals("rdt")) {
				sort="d";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			
			String search_sch = "";
			String gana_sch = "";
			String query_sch = "";	//검색어
			String sort_sch="";
			String histGbn = "현행";
			
			String Smenu = "";
			if(search.equals("1")){
				Smenu = "제목";
			}else{
				Smenu = "제목내용";		
			}
			if(!search.equals(""))search_sch="&search="+search;
			if(!gana.equals(""))gana_sch="&gana="+gana;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!sort.equals(""))sort_sch="&sort="+sort;
			
			String para = query_sch+gana_sch+sort_sch+search_sch+"&page="+pageno;
			System.out.println("para===>"+para);
			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListBH(para);
			}catch(Exception e){
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("안건명").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				dd.put("title", tit);
				dd.put("ord", data.get("번호"));
				dd.put("dlink", data.get("법령해석례상세링크"));
				dd.put("anno", data.get("안건번호").toString().equals("")?"":data.get("안건번호"));
				dd.put("qdept", data.get("질의기관명").toString().equals("")?"":data.get("질의기관명"));
				dd.put("rdept", data.get("회신기관명").toString().equals("")?"":data.get("회신기관명"));
				dd.put("lawcd", data.get("분야명")==null?"":data.get("분야명"));
				dd.put("rdt", data.get("회신일자")==null?"":data.get("회신일자").equals("")?"":data.get("회신일자").toString().substring(0,4)+"-"+data.get("회신일자").toString().substring(5,7)+"-"+data.get("회신일자").toString().substring(8,10));
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}else if(datacd.equals("lawex2")){
			String gana = request.getParameter("gana")==null?"":request.getParameter("gana");
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String sort = request.getParameter("sort")==null?"ddes":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			if(pageno2.equals(""))pageno2="1";
			
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("title")) {
				sort="l";
			}else if(sort.equals("caseno")) {
				sort="n";
			}else if(sort.equals("casedt")) {
				sort="ef";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			
			String search_sch = "";
			String gana_sch = "";
			String query_sch = "";	//검색어
			String sort_sch="";
			String histGbn = "현행";
			
			String Smenu = "";
			if(search.equals("1")){
				Smenu = "제목";
			}else{
				Smenu = "제목내용";		
			}
			if(!search.equals(""))search_sch="&search="+search;
			if(!gana.equals(""))gana_sch="&gana="+gana;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!sort.equals(""))sort_sch="&sort="+sort;
			
			String para = query_sch+gana_sch+sort_sch+search_sch+"&page="+pageno;

			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListHP(para);
			}catch(Exception e){
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("사건명").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				dd.put("title", tit);
				dd.put("ord", data.get("번호"));
				dd.put("dlink", data.get("헌재결정례상세링크"));
				dd.put("caseno", data.get("사건번호").toString().equals("")?"":data.get("사건번호"));
				dd.put("casedt", data.get("종국일자").toString().equals("")?"":data.get("종국일자").toString().substring(0,4)+"-"+data.get("종국일자").toString().substring(5,7)+"-"+data.get("종국일자").toString().substring(8,10));
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}else if(datacd.equals("lawex3")){
			String gana = request.getParameter("gana")==null?"":request.getParameter("gana");
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String sort = request.getParameter("sort")==null?"ddes":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			if(pageno2.equals(""))pageno2="1";
			
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("title")) {
				sort="l";
			}else if(sort.equals("caseno")) {
				sort="n";
			}else if(sort.equals("adt")) {
				sort="d";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			
			String search_sch = "";
			String gana_sch = "";
			String query_sch = "";	//검색어
			String sort_sch="";
			String histGbn = "현행";
			
			String Smenu = "";
			if(search.equals("1")){
				Smenu = "제목";
			}else{
				Smenu = "제목내용";		
			}
			if(!search.equals(""))search_sch="&search="+search;
			if(!gana.equals(""))gana_sch="&gana="+gana;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!sort.equals(""))sort_sch="&sort="+sort;
			
			String para = query_sch+gana_sch+sort_sch+search_sch+"&page="+pageno;

			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListHA(para);
			}catch(Exception e){
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("사건명").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				dd.put("title", tit);
				dd.put("ord", data.get("번호"));
				dd.put("dlink", data.get("행정심판례상세링크"));
				dd.put("caseno", data.get("사건번호")==null?"":data.get("사건번호"));
				dd.put("fdt", data.get("처분일자").toString().equals("")?"":data.get("처분일자").toString().substring(0,4)+"-"+data.get("처분일자").toString().substring(5,7)+"-"+data.get("처분일자").toString().substring(8,10));
				dd.put("adt", data.get("의결일자").toString().equals("")?"":data.get("의결일자").toString().substring(0,4)+"-"+data.get("의결일자").toString().substring(5,7)+"-"+data.get("의결일자").toString().substring(8,10));
				dd.put("fdept", data.get("처분청").toString().equals("")?"":data.get("처분청"));
				dd.put("rdept", data.get("재결청").toString().equals("")?"":data.get("재결청"));
				dd.put("gbn", data.get("재결구분명").toString());
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}else if(datacd.equals("joyak")){
			String gana = request.getParameter("gana")==null?"":request.getParameter("gana");
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String sort = request.getParameter("sort")==null?"ddes":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			if(pageno2.equals(""))pageno2="1";
			
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("title")) {
				sort="l";
			}else if(sort.equals("jno")) {
				sort="n";
			}else if(sort.equals("ndt")) {
				sort="d";
			}else if(sort.equals("sdt")) {
				sort="r";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			
			String search_sch = "";
			String gana_sch = "";
			String query_sch = "";	//검색어
			String sort_sch="";
			String histGbn = "현행";
			
			String Smenu = "";
			if(search.equals("1")){
				Smenu = "제목";
			}else{
				Smenu = "제목내용";		
			}
			if(!search.equals(""))search_sch="&search="+search;
			if(!gana.equals(""))gana_sch="&gana="+gana;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!sort.equals(""))sort_sch="&sort="+sort;
			
			String para = query_sch+gana_sch+sort_sch+search_sch+"&page="+pageno;

			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListJI(para);
			}catch(Exception e){
				System.out.println("데이터 에러");
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("조약명").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				dd.put("title", tit);
				dd.put("ord", data.get("번호"));
				dd.put("dlink", data.get("조약상세링크"));
				dd.put("jno", data.get("조약번호")==null?"":data.get("조약번호"));
				dd.put("gbn", data.get("조약구분명")==null?"":data.get("조약구분명"));
				dd.put("ndt", data.get("발효일자")==null?"":data.get("발효일자").toString().substring(0,4)+"-"+data.get("발효일자").toString().substring(4,6)+"-"+data.get("발효일자").toString().substring(6,8));
				dd.put("sdt", data.get("서명일자")==null?"":data.get("서명일자").equals("")?"":data.get("서명일자").toString().substring(0,4)+"-"+data.get("서명일자").toString().substring(4,6)+"-"+data.get("서명일자").toString().substring(6,8));
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}else if(datacd.equals("word")){
			String gana = request.getParameter("gana")==null?"":request.getParameter("gana");
			String search = request.getParameter("search")==null?"1":request.getParameter("search");	//검색범위(1:자치법규명,2:본문검색)
			String query = request.getParameter("query")==null?"":request.getParameter("query");	//검색어
			String sort = request.getParameter("sort")==null?"ddes":request.getParameter("sort");			//정렬순서(기본 : lasc 자치법규오름차순) ldes:자치법규내림차순,dasc:공포일자 오름차순,ddes:공포일자 내림차순,nasc:공포번호 오름차순,ndes:공포번호 내림차순 
			String pageno2 = request.getParameter("pageno")==null?"1":request.getParameter("pageno");
			if(pageno2.equals(""))pageno2="1";
			
			String dir = request.getParameter("dir")==null?"":request.getParameter("dir");
			if(sort.equals("title")) {
				sort="l";
			}
			if(dir.equals("ASC")) {
				sort=sort+"asc";
			}else if(dir.equals("DESC")) {
				sort=sort+"des";
			}
			
			String search_sch = "";
			String gana_sch = "";
			String query_sch = "";	//검색어
			String sort_sch="";
			if(!search.equals(""))search_sch="&search="+search;
			if(!gana.equals(""))gana_sch="&gana="+gana;
			if(!query.equals(""))query_sch="&query="+URLEncoder.encode(query, "utf-8");
			if(!sort.equals(""))sort_sch="&sort="+sort;
			
			String para = query_sch+gana_sch+sort_sch+search_sch+"&page="+pageno;

			LawBean law = new LawBean();
			try{
				law = GetXmlData.getXmlListWORD(para);
			}catch(Exception e){
			}
			ArrayList lawList = law.getXmlList();
			int total = lawList.size();
			if(total-limit<0){
				limit=total;
			}
			System.out.println("lawList.size()===>"+lawList.size());
			for(int k=0; k<lawList.size(); k++){
				HashMap data = (HashMap)lawList.get(k);
				JSONObject dd = new JSONObject();
				String tit = data.get("법령용어명").toString().replaceAll("<strong>","<strong><font style='color:red'>").replaceAll("</strong>","</strong></font>");
				dd.put("title", tit);
				dd.put("ord", data.get("번호"));
				dd.put("dlink", data.get("법령용어상세검색"));
				lList.add(dd);
			}
			result.put("total", law.getTotal());
			result.put("result", lList);
		}
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("/rssApiData.do")
	public void rssApiData(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String key = mtenMap.get("MENU_SE_NM")==null?"RSS1":mtenMap.get("MENU_SE_NM").toString();
		List<SyndEntry> entries = null;
		JSONObject result=new JSONObject();
		JSONArray jl = new JSONArray();
		try {
			String tempUrl = MakeHan.File_url(key);
			URL feedUrl = new URL(tempUrl);
			SyndFeedInput input = new SyndFeedInput();
			SyndFeed syndFeeds = input.build(new XmlReader(feedUrl));
			
			entries = (List<SyndEntry>)syndFeeds.getEntries();
			
			int i=0;
			for (SyndEntry entry : entries) {
				String tt = entry.getTitle();
				JSONObject result2=new JSONObject();
				result2.put("id", i);
				result2.put("dlink", entry.getLink());
				result2.put("title", entry.getTitle());
				result2.put("winfo", entry.getDescription().getValue());
				result2.put("wdt", MakeHan.getDateParse(entry.getPublishedDate().toString()));
				jl.add(result2);
				i++;
			}
			result.put("total", i);
			result.put("result", jl);
		} catch (Exception ex) {
			ex.printStackTrace();
			System.out.println("ERROR: " + ex.getMessage());
		}
		Json4Ajax.commonAjax(result, response);
	}
}
