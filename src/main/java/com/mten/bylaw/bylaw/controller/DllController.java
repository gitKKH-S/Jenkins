package com.mten.bylaw.bylaw.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.admin.service.UserService;
import com.mten.bylaw.agree.service.AgreeService;
import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.consult.service.ConsultService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.cmn.SessionListener;
import com.mten.minterface.hwp.HwpTextExtractor;
import com.mten.util.ConExcel;
import com.mten.util.ExcelReaderUtil;
import com.mten.util.FileUploadUtil;
import com.mten.util.Json4Ajax;
import com.mten.util.MakeHan;
import com.mten.util.ZipUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Controller
@RequestMapping("/dll/")
public class DllController extends DefaultController{
	@Value("#{fileinfo['mten.BBS']}") 
	public String filePath; 
	
	@Value("#{fileinfo['mten.LAW']}") 
	public String lawfilePath; 
	
	@Value("#{fileinfo['mten.IMG']}") 
	public String imgfilePath; 
	
	@Value("#{fileinfo['mten.AGREE']}") 
	public String agreefilePath; 
	
	@Value("#{fileinfo['mten.DBMS']}") 
	public String DBMS;
	
	@Value("#{fileinfo['mten.DOCTYPE']}") 
	public String DOCTYPE;
	
	@Value("#{fileinfo['mten.CONSULT']}")
	public String consultfilePath;
	
	@Value("#{fileinfo['mten.SUIT']}")
	public String suitfilePath;
	
	@Value("#{fileinfo['mten.METAXML']}")
	public String xmlPath;
	
	
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
	
	@RequestMapping("/getQueryReq.do")
	public String getQueryReq(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest, HttpServletResponse response, ModelMap model) throws Exception{
		Iterator<String> itr = multipartRequest.getFileNames();
		while (itr.hasNext()) { 
			String formName = itr.next();
			MultipartFile mpf = multipartRequest.getFile(formName);
			String originalFilename = mpf.getOriginalFilename();
			
			String fileFullPath = lawfilePath + originalFilename;
			System.out.println("fileFullPath1===>"+fileFullPath);
			
			boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
			
			StringBuffer sb = new StringBuffer();
			//FileReader fr_R = null;
		    BufferedReader bfr_R = null;
		    try{
		    	
		    	bfr_R = new BufferedReader(new InputStreamReader(new FileInputStream(fileFullPath),"euc-kr"));
			    sb = new StringBuffer();
			    String sTmp = "";
			    
			    while((sTmp = bfr_R.readLine()) != null){
			        try{
			        	sb.append(sTmp + "\r\n");	
			        }catch(NullPointerException e){
			        	sb = new StringBuffer();
			        	sb.append(sTmp + "\r\n");
			        }
			    }
		    	bfr_R.close();
		    	//fr_R.close();
		    }catch(IOException e){
		    	
		    	System.out.print("TEXT 추출 에러");
		    }finally{
		    	
		    }
		    
			String text = sb.toString(); // 추출된 텍스트
			if(DBMS.equals("MSSQL")) {
				text = text.replaceAll("\\|\\|", "+");
			}
			
			System.out.println(text);
			mtenMap.put("query", text);
			
		}
		String xml = bylawService.dllReqSelect(mtenMap);
		xml = xml.replaceAll("1월 ", "JAN")
				.replaceAll("2월 ", "FEB")
				.replaceAll("3월 ", "MAR")
				.replaceAll("4월 ", "APR")
				.replaceAll("5월 ", "MAY")
				.replaceAll("6월 ", "JUN")
				.replaceAll("7월 ", "JUL")
				.replaceAll("8월 ", "AUG")
				.replaceAll("9월 ", "SEP")
				.replaceAll("10월 ", "OCT")
				.replaceAll("11월 ", "NOV")
				.replaceAll("12월 ", "DEC");
		
		System.out.println(xml);
		model.addAttribute("body", xml);
		return "/dll/blank.dll";
	}
	
	@RequestMapping("/getQueryReq2.do")
	public String getQueryReq2(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
			String text = "SELECT PARAM,DID AS ID FROM TB_LM_ALLDOWN WHERE DID = '10239717' "; // 추출된 텍스트
			if(DBMS.equals("MSSQL")) {
				text = text.replaceAll("\\|\\|", "+");
			}
			
			System.out.println(text);
			mtenMap.put("query", text);
			
		String xml = bylawService.dllReqSelect(mtenMap);
		xml = xml.replaceAll("1월 ", "JAN")
				.replaceAll("2월 ", "FEB")
				.replaceAll("3월 ", "MAR")
				.replaceAll("4월 ", "APR")
				.replaceAll("5월 ", "MAY")
				.replaceAll("6월 ", "JUN")
				.replaceAll("7월 ", "JUL")
				.replaceAll("8월 ", "AUG")
				.replaceAll("9월 ", "SEP")
				.replaceAll("10월 ", "OCT")
				.replaceAll("11월 ", "NOV")
				.replaceAll("12월 ", "DEC");
		
		System.out.println(xml);
		model.addAttribute("body", xml);
		return "/dll/blank.dll";
	}
	
	
	
	@RequestMapping("/getXmlstatehistoryid.do")
	public String getXmlstatehistoryid(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		String xml = bylawService.getSelectXml(mtenMap);
		model.addAttribute("body", xml);
		model.addAttribute("gbn", "xml");
		return "/dll/blank.dll";
	}
	
	@RequestMapping("/setContxml.do")
	public void setContxml(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		long time = System.currentTimeMillis(); 
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyymmddhhmmss");
		String str = dayTime.format(new Date(time));
		
		String metaxml = mtenMap.get("metaxml")==null?"":mtenMap.get("metaxml").toString();
		System.out.println(metaxml);
		String fxml = str+".xml";
		JSONObject result =  new JSONObject();
		
		System.out.println("*****************************************************");
		System.out.println("*****************************************************");
		System.out.println(str);
		System.out.println(fxml);
		System.out.println(xmlPath);
		System.out.println(xmlPath+fxml);
		System.out.println("*****************************************************");
		System.out.println("*****************************************************");
		
		try{
			FileOutputStream fos = new FileOutputStream(xmlPath+fxml,false);
			OutputStreamWriter out = new OutputStreamWriter(fos,"UTF-8");
			out.write(metaxml);
			out.close();
			fos.close();

			result.put("result", fxml);
		}catch(Exception e){
			e.printStackTrace();
			result.put("result", "X");
		}
		
		System.out.println("result==>"+result);
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			
			writer.println(result);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping("/setFileContxml.do")
	public void setFileContxml(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest ,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("setFileContxml.do");
		String metaXml = mtenMap.get("metaXml")==null?"":mtenMap.get("metaXml").toString();
		mtenMap = this.getXmlParsing(mtenMap,metaXml);
		Iterator<String> itr = multipartRequest.getFileNames();
		while (itr.hasNext()) { 
			String formName = itr.next();
			System.out.println(formName);
			MultipartFile mpf = multipartRequest.getFile(formName);
			String originalFilename = mpf.getOriginalFilename();
			
			String fileFullPath = lawfilePath + "/" + originalFilename;
			System.out.println("fileFullPath1===>"+fileFullPath);
			
			boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
			
			StringBuffer sb = new StringBuffer();
			//FileReader fr_R = null;
		    BufferedReader bfr_R = null;
		    try{
		    	
		    	bfr_R = new BufferedReader(new InputStreamReader(new FileInputStream(fileFullPath),"euc-kr"));
			    sb = new StringBuffer();
			    String sTmp = "";
			    
			    while((sTmp = bfr_R.readLine()) != null){
			        try{
			        	sb.append(sTmp + "\r\n");	
			        }catch(NullPointerException e){
			        	sb = new StringBuffer();
			        	sb.append(sTmp + "\r\n");
			        }
			    }
		    	bfr_R.close();
		    	
		    	if(formName.equals("fileb")) {
		    		mtenMap.put("xmldata", sb.toString());
		    	}else if(formName.equals("fileg")) {
		    		mtenMap.put("xmloldnewrevision", sb.toString());
		    	}
		    }catch(IOException e){
		    	
		    	System.out.print("TEXT 추출 에러");
		    }finally{
		    	
		    }
		}
		bylawService.setLawXMLDataUpdate(mtenMap);
		
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println("Y");
			writer.close();
		}
		catch (IOException ioe) {
		}
	}
	
	public Map<String, Object> getXmlParsing(Map<String, Object> mtenMap,String xmlData) throws JDOMException, IOException{
		
		SAXBuilder builder = new SAXBuilder();
		Document document = builder.build(new StringReader(xmlData));

		Element root = document.getRootElement();
		List child2 = root.getChildren();
		for (Iterator iter = child2.iterator();iter.hasNext();) {
			Element node = (Element) iter.next();
			
			String name = (String) node.getName();
			String value = (String) node.getText();
			mtenMap.put(name.toLowerCase(), value);
		}
		System.out.println(mtenMap);
		return mtenMap;
	}

	@RequestMapping("/getCode.do")
	public String getCode(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("getCode.do");
		model.addAttribute("body", bylawService.getKey());
		return "/dll/blank.dll";
	}
	
	@RequestMapping("/getXmlNew.do")
	public String getXmlNew(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("getXmlNew.do");
		return "/index.main";
	}
	
	@RequestMapping("/getXmlNew2.do")
	public String getXmlNew2(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("getXmlNew2.do");
		return "/index.main";
	}
	
	@RequestMapping("/getBookStatecd.do")
	public String getBookStatecd(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("getBookStatecd.do");
		return "/index.main";
	}
	
	@RequestMapping("/setSimsaUpdate.do")
	public String setSimsaUpdate(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("setSimsaUpdate.do");
		return "/index.main";
	}
	
	@RequestMapping("/getRevreason.do")
	public String getRevreason(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("getRevreason.do");
		return "/index.main";
	}
	
	@RequestMapping("/noFormFilelist.do")
	public String noFormFilelist(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("noFormFilelist.do");
		return "/index.main";
	}
	
	@RequestMapping("/dllFileTxt.do")
	public String dllFileTxt(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("dllFileTxt.do");
		return "/index.main";
	}
	
	@RequestMapping("/dllImgUpload.do")
	public void dllImgUpload(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("dllImgUpload.do");
		String pp = mtenMap.get("pcfilename")==null?"":mtenMap.get("pcfilename").toString();
		System.out.println("pcfilename===>"+pp);
		System.out.println("pcfilename===>"+MakeHan.toDecoding(pp));
		System.out.println("pcfilename===>"+MakeHan.toDecoding2(pp));
		System.out.println("pcfilename===>"+MakeHan.toKorean(pp));
		System.out.println("pcfilename===>"+MakeHan.toKorean2(pp));
		System.out.println("pcfilename===>"+MakeHan.toKorean_notic(pp));
		
		System.out.println("pcfilename===>"+URLDecoder.decode(mtenMap.get("pcfilename")==null?"":mtenMap.get("pcfilename").toString(),"utf-8"));
		System.out.println("sayu===>"+MakeHan.toKorean2(mtenMap.get("sayu")==null?"":mtenMap.get("sayu").toString()));
		System.out.println("juyo===>"+MakeHan.toKorean2(mtenMap.get("juyo")==null?"":mtenMap.get("juyo").toString()));
		
		mtenMap.put("pcfilename", MakeHan.toKorean2(mtenMap.get("pcfilename")==null?"":mtenMap.get("pcfilename").toString()));
		mtenMap.put("revreason", MakeHan.toKorean2(mtenMap.get("sayu")==null?"":mtenMap.get("sayu").toString()));
		mtenMap.put("mainpith", MakeHan.toKorean2(mtenMap.get("juyo")==null?"":mtenMap.get("juyo").toString()));
		
		String work = mtenMap.get("work")==null?"":mtenMap.get("work").toString();
		String Filecd = mtenMap.get("filecd")==null?"":mtenMap.get("filecd").toString();
		String serverfile = mtenMap.get("serverfile")==null?"":mtenMap.get("serverfile").toString();
		
		if(!work.equals("DELETE")){
			String destDir ="";
			if(Filecd.equals("IMAGE")){
				destDir = imgfilePath;
			}else{
				destDir = lawfilePath;
			}
			Iterator<String> itr = multipartRequest.getFileNames();
			while (itr.hasNext()) { 
				String formName = itr.next();
				System.out.println(formName);
				MultipartFile mpf = multipartRequest.getFile(formName);
				String originalFilename = mpf.getOriginalFilename();
				System.out.println(originalFilename);
				String fileFullPath = destDir + "/" + serverfile;
				System.out.println("fileFullPath1===>"+fileFullPath);
				
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
			}
			System.out.println("mtenMap===>"+mtenMap);
			bylawService.DllImgUpload(mtenMap);
		}else{
			bylawService.DllImgDelete(mtenMap);
		}
	}
	
	@RequestMapping("/delByulProc.do")
	public void delByulProc(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("delByulProc.do");
		bylawService.delAttFile(mtenMap);
	}
	
	@RequestMapping("/ServerFileCheck.do")
	public void ServerFileCheck(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("ServerFileCheck.do");
		HashMap result = bylawService.getFileInfoDLL(mtenMap);
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println(result==null?"FALSE":result.get("SERVERFILE"));
			writer.close();
		}
		catch (IOException ioe) {
		}
	}
	
	@RequestMapping("/ServerFileBeing.do")
	public void ServerFileBeing(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("ServerFileBeing.do");
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println(bylawService.ServerFileBeing(mtenMap));
			writer.close();
		}
		catch (IOException ioe) {
		}
	}
	
	@RequestMapping("/albubXml.do")
	public String albubXml(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("albubXml.do");
		return "/index.main";
	}
	
	@RequestMapping("/SaveDoc.do")
	public void SaveDoc(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest,HttpServletResponse response, ModelMap model) throws Exception{
		Iterator<String> itr = multipartRequest.getFileNames();
		while (itr.hasNext()) { 
			String formName = itr.next();
			System.out.println(formName);
			MultipartFile mpf = multipartRequest.getFile(formName);
			String originalFilename = mpf.getOriginalFilename();
			System.out.println(originalFilename);
			String fileFullPath = DOCTYPE + "/" + originalFilename;
			System.out.println("fileFullPath1===>"+fileFullPath);
			
			boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
		}
	}
	
	public Map<String, Object> getFileXmlParsing(Map<String, Object> mtenMap,String xmlData) throws JDOMException, IOException{
			
		SAXBuilder builder = new SAXBuilder();
		Document document = builder.build(new StringReader(xmlData));

		Element root = document.getRootElement();
		List child2 = root.getChildren();
		for (Iterator iter = child2.iterator();iter.hasNext();) {
			Element node = (Element) iter.next();
			
			String name = (String) node.getName();
			String value = (String) node.getText();
			mtenMap.put(name.toLowerCase(), value);
			
			List child3 = node.getChildren();
			if(child3.size()>0) {
				for (Iterator iters = child3.iterator();iters.hasNext();) {
					Element nodes = (Element) iters.next();
					
					String names = (String) nodes.getName();
					String values = (String) nodes.getText();
					mtenMap.put(names.toLowerCase(), values);
				}
			}
			
		}
		System.out.println(mtenMap);
		return mtenMap;
	}

	@RequestMapping("/SaveContentDoc.do")
	public void SaveContentDoc(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest,HttpServletResponse response, ModelMap model) throws Exception{
		String metaXml = mtenMap.get("metaXml")==null?"":mtenMap.get("metaXml").toString();
		mtenMap = this.getFileXmlParsing(mtenMap,metaXml);
		
		System.out.println("saveContentDoc >>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(mtenMap);
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println("saveContentDoc >>>>>>>>>>>>>>>>>>>>>>>>");
		
		String filepath = "";
		String docgbn = mtenMap.get("docgbn")==null?"":mtenMap.get("docgbn").toString();
		if(docgbn.equals("AGREE")){
			mtenMap.put("filePath", agreefilePath);
			agreeService.saveFileDll(multipartRequest, mtenMap);
		}
		if(docgbn.equals("CONSULT")){
			mtenMap.put("filePath", consultfilePath);
			//consultService.saveFileDll(multipartRequest, mtenMap);
		}
		
		if(docgbn.equals("SUIT")){
			mtenMap.put("filePath", suitfilePath);
			suitService.fileUpload(mtenMap, multipartRequest);
		}
		
	}
	
	@RequestMapping("/UpdateContentDoc.do")
	public void UpdateContentDoc(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest,HttpServletResponse response, ModelMap model) throws Exception{
		String metaXml = mtenMap.get("metaXml")==null?"":mtenMap.get("metaXml").toString();
		mtenMap = this.getFileXmlParsing(mtenMap, metaXml);
		
		String docgbn = mtenMap.get("docgbn")==null?"":mtenMap.get("docgbn").toString();
		if(docgbn.equals("AGREE")){
			mtenMap.put("filePath", agreefilePath);
		}
		
		if(docgbn.equals("CONSULT")){
			mtenMap.put("filePath", consultfilePath);
		}
		
		if(docgbn.equals("SUIT")){
			mtenMap.put("filePath", suitfilePath);
		}
		
		Iterator<String> itr = multipartRequest.getFileNames();
		while (itr.hasNext()) { // 받은 파일들을 모두 돌린다.
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			String originalFilename = mpf.getOriginalFilename();
			String fileFullPath = mtenMap.get("filePath") + "/" + originalFilename;
			boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
			
			// 수정일자 업데이트
			mtenMap.put("originalFilename", originalFilename);
			suitService.setDocFileModiDate(mtenMap);
		}
	}
	
	
	@RequestMapping("/metaXml.do")
	public void metaXml(Map<String, Object> mtenMap, HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		long time = System.currentTimeMillis(); 
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyymmddhhmmss");
		String str = dayTime.format(new Date(time));
		
		String metaxml = mtenMap.get("metaxml")==null?"":mtenMap.get("metaxml").toString();
		System.out.println(metaxml);
		String fxml = str+".xml";
		JSONObject result =  new JSONObject();
		
		System.out.println("*****************************************************");
		System.out.println("*****************************************************");
		System.out.println(str);
		System.out.println(fxml);
		System.out.println(xmlPath);
		System.out.println(xmlPath+fxml);
		System.out.println("*****************************************************");
		System.out.println("*****************************************************");
		
		try{
			FileOutputStream fos = new FileOutputStream(xmlPath+fxml,false);
			OutputStreamWriter out = new OutputStreamWriter(fos,"UTF-8");
			out.write(metaxml);
			out.close();
			fos.close();
			
			result.put("result", fxml);
		}catch(Exception e){
			e.printStackTrace();
			result.put("result", "X");
		}
		
		System.out.println("result==>"+result);
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			
			writer.println(result);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping("/{page1}/setSession.do")
	public void setSession(@PathVariable String page1 ,Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		System.out.println("mtenMap==>"+mtenMap);
		String addr = mtenMap.get("addr")==null?"":mtenMap.get("addr").toString();
		String USERID = page1;
		System.out.println("USERID===>"+USERID);
		System.out.println("setSession addr==>"+addr);
		Hashtable loginUsers = SessionListener.getInstance().getloginUsers();
		Enumeration e = loginUsers.keys();
		HttpSession session = null;
		int i = 0;
		System.out.println("여기1111111111 :::::: ");
//		if(e == null) {
			mtenMap.put("EMP_NO", page1);
			mtenMap.put("IP_ADDR", addr);
			mtenMap.put("INSTL_YN", "Y");
			userService.setInstallChk(mtenMap);
//		}
		System.out.println("여기222222222222 :::::: ");
	}
	
	@RequestMapping("/InstallChk.do")
	public void InstallChk(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		HttpSession httpSession = request.getSession();
		HashMap loginUser = (HashMap)httpSession.getAttribute("userInfo");
		System.out.println("loginUser 값 111 ::::::  " + loginUser.toString());
		JSONObject result =  new JSONObject();
		if(loginUser != null) {
			System.out.println("여기를 타나????12345");
			result.put("result", "X");
		}
		String inschk = loginUser.get("inschk")==null?"":loginUser.get("inschk").toString();
		result.put("result", inschk);
		
		mtenMap.put("EMP_NO",  loginUser.get("USERID"));
		mtenMap.put("IP_ADDR", loginUser.get("IP_ADDR"));
		result.put("result", userService.getInstallChk(mtenMap));
		System.out.println("설치 체크 값 ::::::  " + result.toString());
		Json4Ajax.commonAjax(result, response);
	}
}
