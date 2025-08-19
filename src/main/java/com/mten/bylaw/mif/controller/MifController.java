package com.mten.bylaw.mif.controller;

import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.admin.service.UserService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.mif.AlertApi;
import com.mten.bylaw.mif.serviceSch.FileUrlDownload;
import com.mten.bylaw.mif.serviceSch.MifService;
import com.mten.util.Json4Ajax;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Controller
@RequestMapping("/mif/")
public class MifController extends DefaultController{
	@Resource(name="mifService")
	private MifService mifService;
	
	@RequestMapping(value="law.do")
	public void getLaw(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		try {
			String path = mtenMap.get("path")==null?"":mtenMap.get("path").toString();
			String XMLDATA = mifService.getUrlXml(path);
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			System.out.println("--------------------------------------------------------");
			System.out.println(XMLDATA);
			System.out.println("--------------------------------------------------------");
			writer.println(XMLDATA);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="lawBon.do")
	public void lawBon(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		try {
			String path = mtenMap.get("path")==null?"":mtenMap.get("path").toString();
			String sLawId = mtenMap.get("sLawId")==null?"":mtenMap.get("sLawId").toString();
			String XMLDATA = mifService.outFile(path,sLawId);
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			System.out.println("--------------------------------------------------------");
			System.out.println(XMLDATA);
			System.out.println("--------------------------------------------------------");
			writer.println(XMLDATA);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="bylawBon.do")
	public void bylawBon(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		try {
			String path = mtenMap.get("path")==null?"":mtenMap.get("path").toString();
			String sLawId = mtenMap.get("sLawId")==null?"":mtenMap.get("sLawId").toString();
			String XMLDATA = mifService.outFile2(path,sLawId);
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			System.out.println("--------------------------------------------------------");
			System.out.println(XMLDATA);
			System.out.println("--------------------------------------------------------");
			writer.println(XMLDATA);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="getLawImg.do")
	public void getLawImg(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		try {
			String id = mtenMap.get("id")==null?"":mtenMap.get("id").toString();
			String lawid = mtenMap.get("lawid")==null?"":mtenMap.get("lawid").toString();
			
			HashMap result = FileUrlDownload.ImgfileUrlReadAndDownload(MakeHan.File_url("LAWURL")+"flDownload.do?flSeq="+id, id,MakeHan.File_url("KLAW") + lawid);
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println(result.get("filenm"));
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="getByLawImg.do")
	public void getByLawImg(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		try {
			String id = mtenMap.get("id")==null?"":mtenMap.get("id").toString();
			String sByLawId = mtenMap.get("sByLawId")==null?"":mtenMap.get("sByLawId").toString();
			
			HashMap result = FileUrlDownload.ImgfileUrlReadAndDownload(MakeHan.File_url("LAWURL")+"flDownload.do?flSeq="+id, id,MakeHan.File_url("BLAW") + sByLawId);
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println(result.get("filenm"));
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="getFileName.do")
	public void getFileName(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		try {
			String fileUrl = mtenMap.get("path")==null?"":mtenMap.get("path").toString();
			URL Url = new URL(MakeHan.File_url("LAWURL")+fileUrl);
			URLConnection uCon = null;
            uCon = Url.openConnection();
            String fileNm = "";
            for (Map.Entry<String, List<String>> header : uCon.getHeaderFields().entrySet()) {
            	String key = header.getKey();
                for (String value : header.getValue()) {
                    System.out.println(key + " : " + value);
                    if(key!=null && key.equals("Content-Disposition")){
                    	String fn[] = value.split("fileName=");
                    	fileNm = fn[1].replaceAll("\"","").replaceAll(";","");
                    	System.out.println(fn[1].replaceAll("\"","").replaceAll(";",""));
                    }
                }
            }
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println(fileNm);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="setInsaInfo.do")
	public void setInsaInfo(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		mifService.setInsaInfo();
		JSONObject jl = new JSONObject();
		Json4Ajax.commonAjax(jl, response);
	}
	
	//사내메신저 연계
	@RequestMapping(value="setAlertApi.do")	
	public void setAlertApi(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) {
		String param1 = mtenMap.get("param1")==null?"120":mtenMap.get("param1").toString();
		String param2 = mtenMap.get("param2")==null?"[RK]행정포털연계키":mtenMap.get("param2").toString();
		String param3 = mtenMap.get("param3")==null?"보내는이":mtenMap.get("param3").toString();
		String param4 = mtenMap.get("param4")==null?"내용":mtenMap.get("param4").toString();
		String param5 = mtenMap.get("param5")==null?"":mtenMap.get("param5").toString();
		int param6 = mtenMap.get("param6")==null?1:Integer.parseInt(mtenMap.get("param6").toString());
		AlertApi aa = new AlertApi("98.33.11.55", 15010);
		aa.MakePacket(param1, param2, param6, param3, param4,param5);
		aa.SendPacket();
		
	}
}
