package com.mten.bylaw.bylaw.controller;


import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.util.Json4Ajax;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/dan/")
public class DanController extends DefaultController{
	@Resource(name="bylawService")
	private BylawService bylawService;
	
	@RequestMapping(value="set3danView.do")
	public String set3danView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "3danmn/set3danView.extjs";
	}
	
	@RequestMapping(value="list3danView.do")
	public String list3danView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "3danmn/list3danView.extjs";
	}
	
	@RequestMapping(value="Column_proc.do")
	public void Column_proc(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = new JSONObject();
		String job = mtenMap.get("job")==null?"":mtenMap.get("job").toString();
		if(job.equals("1dan")){
			int start =	mtenMap.get("start")==null?0:Integer.parseInt(mtenMap.get("start").toString());
			int limit =	mtenMap.get("limit")==null?0:Integer.parseInt(mtenMap.get("limit").toString());
			limit+=start;
			String query  =	mtenMap.get("query")==null?"":mtenMap.get("query").toString();
			
			result = bylawService.getSchResult(start, limit, query);
			
			Json4Ajax.commonAjax(result, response);
			
		}else if(job.equals("2dan") ||job.equals("3dan") ||job.equals("4dan")){
			String oBookIds  =	mtenMap.get("oBookIds")==null?"":mtenMap.get("oBookIds").toString();
			String query  =	mtenMap.get("query")==null?"":mtenMap.get("query").toString();

			result = bylawService.getSchResult2(query, oBookIds);
		}else if(job.equals("listSch")){
			int start =	mtenMap.get("start")==null?0:Integer.parseInt(mtenMap.get("start").toString());
			int limit =	mtenMap.get("limit")==null?0:Integer.parseInt(mtenMap.get("limit").toString());
			limit += start;
			String query  =	mtenMap.get("query")==null?"":mtenMap.get("query").toString();
			
			result = bylawService.get3danList(start, limit, query);
		}else if(job.equals("getOrd")){
			int ordNum =	mtenMap.get("ordNum")==null?0:Integer.parseInt(mtenMap.get("ordNum").toString());
			JSONArray jl = new JSONArray();
			for(int i =1; i<=ordNum;i++){
				JSONObject rss = new JSONObject();
				rss.put("ord", i);
				jl.add(rss);
			}
			result.put("result", jl);
		}else if(job.equals("getOrd2")){
			int ordNum =	mtenMap.get("ordNum")==null?0:Integer.parseInt(mtenMap.get("ordNum").toString());
			JSONArray jl = new JSONArray();
			for(int i =1; i<=ordNum;i++){
				JSONObject rss = new JSONObject();
				rss.put("ord", i);
				jl.add(rss);
			}
			result.put("result", jl);
		}else if(job.equals("insertData2")){
			String dan1 = mtenMap.get("dan1")==null?"":mtenMap.get("dan1").toString();
			String dan2 = mtenMap.get("dan2")==null?"":mtenMap.get("dan2").toString();
			int resNum=0;
			resNum = bylawService.insertData2(dan1.replaceAll("&#47;","/"),dan2.replaceAll("&#47;","/"));
			result.put("chk", resNum);
		}else if(job.equals("insertData3")){
			String dan1 = mtenMap.get("dan1")==null?"":mtenMap.get("dan1").toString();
			String dan2 = mtenMap.get("dan2")==null?"":mtenMap.get("dan2").toString();
			String dan3 = mtenMap.get("dan3")==null?"":mtenMap.get("dan3").toString();
			int resNum=0;
			resNum = bylawService.insertData(dan1.replaceAll("&#47;","/"),dan2.replaceAll("&#47;","/"),dan3.replaceAll("&#47;","/"));
			result.put("chk", resNum);
		}else if(job.equals("insertData")){
			String dan1 = mtenMap.get("dan1")==null?"":mtenMap.get("dan1").toString();
			String dan2 = mtenMap.get("dan2")==null?"":mtenMap.get("dan2").toString();
			String dan3 = mtenMap.get("dan3")==null?"":mtenMap.get("dan3").toString();
			String dan4 = mtenMap.get("dan4")==null?"":mtenMap.get("dan4").toString();
			int resNum=0;
			resNum = bylawService.insertData3(dan1.replaceAll("&#47;","/"),dan2.replaceAll("&#47;","/"),dan3.replaceAll("&#47;","/"),dan4.replaceAll("&#47;","/"));
			result.put("chk", resNum);
		}else if(job.equals("del3danSet")){
			int resNum=0;
			String selected = mtenMap.get("selected")==null?"":mtenMap.get("selected").toString();
			resNum = bylawService.del3danSet(selected.replaceAll("&#47;","/"));
			result.put("chk", resNum);
		}
		Json4Ajax.commonAjax(result, response);
	}
}
