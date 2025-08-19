package com.mten.bylaw.bylaw.controller;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.ConstantCode;
import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.code.service.CodeService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.minterface.hwp.HwpTextExtractor;
import com.mten.util.CommonMakeExcel;
import com.mten.util.FileUploadUtil;
import com.mten.util.Json4Ajax;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/bylaw/adm/")
public class BylawController extends DefaultController{
	@Resource(name="bylawService")
	private BylawService bylawService;
	
	@Resource(name="codeService")
	private CodeService codeService;
	
	//규정편집기화면
	@RequestMapping(value="mainLayout2.do")
	public String mainLayout2(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String stateCd = mtenMap.get("stateCd")==null?"현행":(String)mtenMap.get("stateCd");
		if(stateCd.equals("H")) {
			stateCd = "현행";
		}else if(stateCd.equals("C")) {
			stateCd = "폐지";	
		}
		model.put("stateCd", stateCd);
		return "existing/mainLayout2.adm";
	}
	
	//규정편집기화면
	@RequestMapping(value="progressMn.do")
	public String progressMn(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "progressmn/progressMn.adm";
	}
		
	//정형문서 제개정화면
	@RequestMapping(value="bylawEnactment.do")
	public String bylawEnactment(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.put("param", mtenMap);
		
		String pstate = mtenMap.get("pstate")==null?"":mtenMap.get("pstate").toString();
		String Bookid = mtenMap.get("Bookid")==null?"":mtenMap.get("Bookid").toString();
		int Revcha = 0;
		
		//U : 문서정보수정
		//RE : 개정
		//CRE :연속개정
		HashMap<String,String> meta = new HashMap();
		if(pstate.equals("U")||pstate.equals("RE")||pstate.equals("P")||pstate.equals("CRE")){
			meta = bylawService.selectMETA(Bookid);
			String rcha = meta.get("REVCHA")==null?"0":meta.get("REVCHA");
			if(pstate.equals("U")||pstate.equals("CRE")){
				Revcha = Integer.parseInt(rcha);
			}else if(pstate.equals("RE")||pstate.equals("P")){
				Revcha = Integer.parseInt(rcha)+1;
			}
		}else {
			Revcha = 0;
		}
		meta.put("REVCHA", Revcha+"");
		
		ArrayList codename = new ArrayList();
		codename.add("BOOKCD");
		codename.add("STATECD");
		codename.add("REVCD");
		codename.add("REVMETHOD");
		codename.add("BOOKSUBCD");
		HashMap col=new HashMap() ;
		col.put("codename", codename);
		
		List<HashMap> clist = codeService.OrderSelect(col);
	    HashMap selectboxs = new HashMap();
	    for(int i=0;i<codename.size();i++) {
	    	String codecd = (String)codename.get(i);
	    	selectboxs.put(codecd, this.selectBoxHtml(clist, codecd, meta.get(codecd)==null?"":meta.get(codecd)));
	    }
	    model.put("selectboxs", selectboxs);
	    model.put("meta", meta);
	    HashMap dpara = new HashMap();
	    dpara.put("root", ConstantCode.DEPTROOT);
	    dpara.put("dept", meta.get("DEPT"));
	    String deptselectbox = bylawService.setDeptList(dpara);
	    model.put("deptselectbox", deptselectbox);
		return "existing/bylawEnactment.extjs";
	}
	
	public StringBuffer selectBoxHtml(List<HashMap> clist,String key,String value) {
		StringBuffer select= new StringBuffer();
		for(int k=0; k<clist.size(); k++){
			HashMap cb = (HashMap)clist.get(k);
      		String code = cb.get("CODE")==null?"":cb.get("CODE").toString();
      		String Codename = cb.get("CODENAME")==null?"":cb.get("CODENAME").toString();
      		String Codeid = cb.get("CODEID")==null?"":cb.get("CODEID").toString();
      		if(Codename.equals(key)){
      			if(value.equals(code)){
      				if(code.equals("------------")){
      					select.append("<option value=\"\" selected>"+code+"</option>");
      				}else{
      					select.append("<option value=\""+code+"\" selected>"+code+"</option>");
      				}
      			}else{
      				if(code.equals("------------")){
      					select.append("<option value=\"\">"+code+"</option>");	
      				}else{
      					select.append("<option value=\""+code+"\">"+code+"</option>");
      				}
      			}
      		}
      	}
		return select;
	}
	
	@RequestMapping(value="getUserList.do")
	public ModelAndView getUserList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONArray jr = bylawService.getUserList(mtenMap);
		return addResponseData(jr);	
	}
		
	//문서정보 VIEW
	@RequestMapping(value="getDocInfoView.do")
	public ModelAndView getDocInfoView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject jr = bylawService.getDocInfoView(mtenMap,req);
		return addResponseData(jr);	
	}
	
	//문서정보 VIEW
	@RequestMapping(value="getDocBon.do")
	public ModelAndView getDocBon(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject jr = bylawService.getDocBon(mtenMap,req);
		return addResponseData(jr);	
	}
	
	//한글창
	@RequestMapping(value="noFormView.do")
	public ModelAndView noFormView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.put("param", mtenMap);
		
		Map resultMap = bylawService.noFormView(mtenMap);
		System.out.println(resultMap);
		model.put("fileName", resultMap.get("fileName"));
		JSONObject jo = JSONObject.fromObject(resultMap);
		
		return addResponseData(jo);
	}
	
	@RequestMapping(value="goHwp.do")
	public String goHwp(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "regulation/hwp.dll";
	}
	
	//제목검색
	@RequestMapping(value="schList.do")
	public ModelAndView schList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		JSONObject jr = bylawService.schList(mtenMap,req);
		return addResponseData(jr);	
	}
	
	//제정문 파일 업로드
	@RequestMapping(value="bylawEnactmentFileUpload.do")
	public void bylawEnactmentFileUpload(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception{
		Iterator<String> itr = multipartRequest.getFileNames();
		String sfName = "";
		while (itr.hasNext()) { 
			String formName = itr.next();
			System.out.println(formName);
			MultipartFile mpf = multipartRequest.getFile(formName);
			String originalFilename = mpf.getOriginalFilename();
			
			long time = System.currentTimeMillis(); 
			SimpleDateFormat dayTime = new SimpleDateFormat("yyyymmddhhmmss");
			String str = dayTime.format(new Date(time));

			sfName = str +"."+ originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
			
			String fileFullPath = MakeHan.File_url("LAWTMP") + "/" + sfName;
			System.out.println("fileFullPath1===>"+fileFullPath);
			
			boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
		}
		JSONObject result = new JSONObject();
		result.put("sfName", sfName);
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println(result);
			writer.close();
		}
		catch (IOException ioe) {
		}
	} 
	
	@RequestMapping(value="bylawEnactmentHwpedit.do")
	public String bylawEnactmentHwpedit(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "existing/bylawEnactmentHwpedit.extjs"; 
	}
	
	@RequestMapping(value="EgcProc.do")
	public String EgcProc(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String pstate = mtenMap.get("PSTATE")==null?"":mtenMap.get("PSTATE").toString();
		String Bookid = mtenMap.get("BOOKID")==null?"":mtenMap.get("BOOKID").toString();
		String REVCD = mtenMap.get("REVCD")==null?"":mtenMap.get("REVCD").toString();
		String CHG = mtenMap.get("CHG")==null?"":mtenMap.get("CHG").toString();
		String NOFORMYN_BAK = mtenMap.get("NOFORMYN")==null?"":mtenMap.get("NOFORMYN").toString();
		String FILENAME =  mtenMap.get("FILENAME")==null?"":mtenMap.get("FILENAME").toString();
		String bonhtml =  mtenMap.get("bonhtml")==null?"":mtenMap.get("bonhtml").toString();
		String bontxt =  mtenMap.get("bontxt")==null?"":mtenMap.get("bontxt").toString();
		
		String Promuldt = mtenMap.get("PROMULDT")==null?"7777-12-31":mtenMap.get("PROMULDT").toString();
		if(Promuldt.equals(""))Promuldt="7777-12-31";
		String Startdt = mtenMap.get("STARTDT")==null?"6666-12-31":mtenMap.get("STARTDT").toString();
		if(Startdt.equals(""))Startdt="6666-12-31";
		String Enddt = mtenMap.get("ENDDT")==null?"5555-12-31":mtenMap.get("ENDDT").toString();
		if(Enddt.equals(""))Enddt="5555-12-31";
		
		mtenMap.put("PROMULDT", Promuldt);
		mtenMap.put("STARTDT", Startdt);
		mtenMap.put("ENDDT", Enddt);
		
		if((REVCD.equals("제정")||REVCD.equals("전부개정")||CHG.equals("Y")) && bonhtml.equals("")) {
			String tempDir = MakeHan.File_url("LAWTMP");
			File hwp = new File(tempDir+FILENAME); // 텍스트를 추출할 HWP 파일
			Writer writer = new StringWriter(); // 추출된 텍스트를 출력할 버퍼
			try {
				HwpTextExtractor.extract(hwp, writer);
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} // 파일로부터 텍스트 추출
			String text = writer.toString(); // 추출된 텍스트
			
			mtenMap.put("bonhtml", text);
			mtenMap.put("bontxt", text);
		}
		
		if(REVCD.equals("제정")||REVCD.equals("전부개정")||CHG.equals("Y")) {	//연혁 수정을 위한 데이터 셋팅
			mtenMap.put("ALLREVYN", "Y");	
		}else {
			mtenMap.put("ALLREVYN", "N");
		}
		mtenMap.put("NOFORMYN", "N");
		
		String bonTxt = "";
		if(pstate.equals("I")) {	//제정
			mtenMap.put("STATECD","1000");
			mtenMap.put("STATEID","1000");
			mtenMap = bylawService.setXmlBon(mtenMap);
			String Title = mtenMap.get("TITLE")==null?"":mtenMap.get("TITLE").toString();
			String Revcha = mtenMap.get("REVCHA")==null?"":mtenMap.get("REVCHA").toString();
			bonTxt = "<div id=\"bb\" style=\"margin: 5px 5px 5px 25px; text-align: left; display:''\">";
			bonTxt = bonTxt + Title+" "+Revcha+ "차 문서를 제정중 입니다.";
			bonTxt = bonTxt + "</div>";
			model.addAttribute("docInfo", mtenMap);
		}else if(pstate.equals("YURE")) {	//내용수정
			HashMap docInfo = bylawService.selectMETA(Bookid);
			String Title = docInfo.get("TITLE")==null?"":docInfo.get("TITLE").toString();
			String Revcha = docInfo.get("REVCHA")==null?"":docInfo.get("REVCHA").toString();
			bonTxt = "<div id=\"bb\" style=\"margin: 5px 5px 5px 25px; text-align: left; display:''\">";
			bonTxt = bonTxt + Title+" "+Revcha+ "차의 내용을 수정중 입니다.";
			bonTxt = bonTxt + "</div>";
			model.addAttribute("docInfo", docInfo);
		}else if(pstate.equals("RE")||pstate.equals("P")) {	//개정
			mtenMap.put("PROMULDT", "7777-12-31");
			mtenMap.put("STARTDT", "6666-12-31");
			mtenMap.put("ENDDT", "5555-12-31");
			mtenMap.put("USEYN", "Y");
			mtenMap.put("DELYN", "N");
			mtenMap.put("STATECD","1000");
			mtenMap.put("STATEID","1000");
			if(REVCD.equals("전부개정")||CHG.equals("Y")||NOFORMYN_BAK.equals("Y")){						//정형문서 전부개정
				mtenMap = bylawService.allDocRevision(mtenMap);
			}else {
				mtenMap = bylawService.DocRevision(mtenMap);				//일반개정
			}
			
			String Title = mtenMap.get("TITLE")==null?"":mtenMap.get("TITLE").toString();
			String Revcha = mtenMap.get("REVCHA")==null?"":mtenMap.get("REVCHA").toString();
			bonTxt = "<div id=\"bb\" style=\"margin: 5px 5px 5px 25px; text-align: left; display:''\">";
			bonTxt = bonTxt + Title+" "+Revcha+ "차의 내용을 개정중 입니다.";
			bonTxt = bonTxt + "</div>";
			model.addAttribute("docInfo", mtenMap);
		}else if(pstate.equals("U")) {	//문서정보수정
			mtenMap = bylawService.noFormUp(mtenMap);
			String Title = mtenMap.get("TITLE")==null?"":mtenMap.get("TITLE").toString();
			String Revcha = mtenMap.get("REVCHA")==null?"":mtenMap.get("REVCHA").toString();
			bonTxt = "<div id=\"bb\" style=\"margin: 5px 5px 5px 25px; text-align: left; display:''\">";
			bonTxt = bonTxt + Title+" "+Revcha+ "차의 문서정보를 수정중 입니다.";
			bonTxt = bonTxt + "</div>";
			model.addAttribute("docInfo", mtenMap);
		}
		model.addAttribute("bonTxt", bonTxt);
		return "existing/EgcProc.extjs"; 
	}
	
	@RequestMapping(value="updatelog.do")
	public void updatelog(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println("mtenMap=====>"+mtenMap);
		mtenMap = bylawService.setUpdatelog(mtenMap);
		JSONObject jo = JSONObject.fromObject(mtenMap);
		jo.put("success", true);
		Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="makeExcel.do")
	public void makeExcel(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String sTit = "규정메타정보";
		List<Map<String,Object>> datalist = bylawService.makeExcel(mtenMap);
		ArrayList<String> columnList = new ArrayList<String>();	//데이터컬럼명
		ArrayList<String> columnRList = new ArrayList<String>();	//화면용컬럼명
		columnRList.add("카테고리정보");
		columnRList.add("규정명");
		columnRList.add("개정구분");
		columnRList.add("개정차수");
		columnRList.add("규정구분");
		columnRList.add("시행일");
		columnRList.add("공포일");
		columnRList.add("부서명");
		columnRList.add("담당자");
		
		columnList.add("PATH");
		columnList.add("TITLE");
		columnList.add("REVCD");
		columnList.add("REVCHA");
		columnList.add("BOOKCD");
		columnList.add("STARTDT");
		columnList.add("PROMULDT");
		columnList.add("DEPTNAME");
		columnList.add("USERNAME");
		CommonMakeExcel.makeExcel(sTit, columnList, columnRList, datalist, req, response);
	}
	
	@RequestMapping(value="getDocInfo.do")
	public ModelAndView getDocInfo(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		String Bookid = mtenMap.get("Bookid")==null?"":mtenMap.get("Bookid").toString();
		HashMap docInfo = bylawService.selectMETA(Bookid);
		JSONObject jr = JSONObject.fromObject(docInfo);
		return addResponseData(jr);	
	}
	
	//비정형문서 등록
	@RequestMapping(value="noFormInsert.do")
	public void noFormInsert(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception{
		Iterator<String> itr = multipartRequest.getFileNames();
		String sfName = "";
		while (itr.hasNext()) { 
			String formName = itr.next();
			System.out.println(formName);
			MultipartFile mpf = multipartRequest.getFile(formName);
			String originalFilename = mpf.getOriginalFilename();
			if(!originalFilename.equals("")) {
				String keyid = bylawService.getKey();
	
				sfName = keyid +"."+ originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
				
				String fileFullPath = MakeHan.File_url("LAW") + "/" + sfName;
				System.out.println("fileFullPath1===>"+fileFullPath);
				
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
				mtenMap.put("PCFILENAME", originalFilename);
				mtenMap.put("FILEID", keyid);
				mtenMap.put("SERVERFILE", sfName);
				mtenMap.put("FILETYPE", originalFilename.substring(originalFilename.lastIndexOf(".") + 1));
				mtenMap.put("FILECD", "JUN");
				mtenMap.put("UPDT", MakeHan.get_data());
			}
		}
		mtenMap = bylawService.noFormInsert(mtenMap);
		JSONObject result = new JSONObject();
		JSONObject result1 = new JSONObject();
		result1.put("bookid", mtenMap.get("BOOKID"));
		result1.put("statehistoryid", mtenMap.get("STATEHISTORYID"));
		result.put("success", true);
		result.put("key", result1);
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			writer.println(result);
			writer.close();
		}
		catch (IOException ioe) {
		}
	}
	
	@RequestMapping(value="fileUpload.do")
	public String fileUpload(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "existing/fileUpload.extjs"; 
	}
	
	@RequestMapping(value="addjoFile.do")
	public String addjoFile(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		ArrayList codename = new ArrayList();
		codename.add("CONTGBN");
		HashMap col=new HashMap() ;
		col.put("codename", codename);
		
		List<HashMap> clist = codeService.OrderSelect(col);
	    HashMap selectboxs = new HashMap();
	    for(int i=0;i<codename.size();i++) {
	    	String codecd = (String)codename.get(i);
	    	selectboxs.put(codecd, this.selectBoxHtml(clist, codecd, ""));
	    }
	    model.put("selectboxs", selectboxs);
		return "existing/addjoFile.extjs"; 
	}
	
	@RequestMapping(value="progressList.do")
	public void progressList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.progressList(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="changeTitle.do")
	public void changeTitle(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.changeTitle(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="updateStep.do")
	public void updateStep(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 mtenMap.put("uInfo", req.getContextPath());
		 JSONObject jo = bylawService.updateStep(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="deleteProc.do")
	public void deleteProc(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.deleteProc(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="setRevreason.do")
	public void setRevreason(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.setRevreason(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="setJenmun.do")
	public void setJenmun(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.setJenmun(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="setMemo.do")
	public void setMemo(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.setMemo(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="getMemo.do")
	public void getMemo(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.getMemo(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="promuldtInsert.do")
	public void promuldtInsert(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.promuldtInsert(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="docDelete.do")
	public void docDelete(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.deleteCansel(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="fileUploadProc.do")
	public void fileUploadProc(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception{
		mtenMap.put("BOOKID", mtenMap.get("Bookid"));
		mtenMap.put("STATEHISTORYID", mtenMap.get("statehistoryid"));
		String[] fileCd = {"AN","GAE","JUN","SIN","REA","VIEW","BYUL","ETC"};
		int i=0;
		Iterator<String> itr = multipartRequest.getFileNames();
		String sfName = "";
		ArrayList fl = new ArrayList();
		while (itr.hasNext()) { 
			String formName = itr.next();
			System.out.println(formName);
			MultipartFile mpf = multipartRequest.getFile("ffDoc_00"+(i+1));
			
			if(mpf==null)
				continue;
			if(mpf.getOriginalFilename()!=null && !mpf.getOriginalFilename().equals("")){
				String originalFilename = mpf.getOriginalFilename();
				if(!originalFilename.equals("")) {
					String keyid = bylawService.getKey();
		
					sfName = keyid +"."+ originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
					
					String fileFullPath = MakeHan.File_url("LAW") + "/" + sfName;
					System.out.println("fileFullPath1===>"+fileFullPath);
					
					boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
					
					HashMap para = new HashMap();
					para.put("BOOKID", mtenMap.get("Bookid"));
					para.put("STATEHISTORYID", mtenMap.get("statehistoryid"));
					para.put("FILEID", keyid);
					para.put("PCFILENAME", originalFilename);
					para.put("SERVERFILE", sfName);
					para.put("FILETYPE", originalFilename.substring(originalFilename.lastIndexOf(".") + 1));
					para.put("FILECD", fileCd[i]);
					para.put("UPDT", MakeHan.get_data());
					fl.add(para);
				}
			}
			i++;
		}
		
		itr = multipartRequest.getFileNames();
		i=0;
		while (itr.hasNext()) { 
			String formName = itr.next();
			System.out.println(formName);
			MultipartFile mpf = multipartRequest.getFile("ffDoc_007_"+i);
			
			if(mpf==null)
				continue;
			if(mpf.getOriginalFilename()!=null && !mpf.getOriginalFilename().equals("")){
				String originalFilename = mpf.getOriginalFilename();
				if(!originalFilename.equals("")) {
					String keyid = bylawService.getKey();
		
					sfName = keyid +"."+ originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
					
					String fileFullPath = MakeHan.File_url("LAW") + "/" + sfName;
					System.out.println("fileFullPath1===>"+fileFullPath);
					
					boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
					
					HashMap para = new HashMap();
					para.put("BOOKID", mtenMap.get("Bookid"));
					para.put("STATEHISTORYID", mtenMap.get("statehistoryid"));
					para.put("FILEID", keyid);
					para.put("PCFILENAME", originalFilename);
					para.put("SERVERFILE", sfName);
					para.put("FILETYPE", originalFilename.substring(originalFilename.lastIndexOf(".") + 1));
					para.put("FILECD", fileCd[6]);
					para.put("UPDT", MakeHan.get_data());
					fl.add(para);
					i++;
				}
			}
			
		}
		
		itr = multipartRequest.getFileNames();
		i=0;
		while (itr.hasNext()) { 
			String formName = itr.next();
			System.out.println(formName);
			MultipartFile mpf = multipartRequest.getFile("ffDoc_008_"+i);
			
			if(mpf==null)
				continue;
			if(mpf.getOriginalFilename()!=null && !mpf.getOriginalFilename().equals("")){
				String originalFilename = mpf.getOriginalFilename();
				if(!originalFilename.equals("")) {
					String keyid = bylawService.getKey();
		
					sfName = keyid +"."+ originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
					
					String fileFullPath = MakeHan.File_url("LAW") + "/" + sfName;
					System.out.println("fileFullPath1===>"+fileFullPath);
					
					boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
					HashMap para = new HashMap();
					para.put("BOOKID", mtenMap.get("Bookid"));
					para.put("STATEHISTORYID", mtenMap.get("statehistoryid"));
					para.put("FILEID", keyid);
					para.put("PCFILENAME", originalFilename);
					para.put("SERVERFILE", sfName);
					para.put("FILETYPE", originalFilename.substring(originalFilename.lastIndexOf(".") + 1));
					para.put("FILECD", fileCd[7]);
					para.put("UPDT", MakeHan.get_data());
					fl.add(para);
					i++;
				}
			}
			
		}
		bylawService.setLawfileInsert(fl);
		response.sendRedirect(multipartRequest.getContextPath()+"/bylaw/adm/fileUpload.do?Bookid="+mtenMap.get("Bookid")+"&noFormYn="+mtenMap.get("noFormYn")+"&statehistoryid="+mtenMap.get("statehistoryid"));
	}
	
	@RequestMapping(value="delByulProc.do")
	public void delByulProc(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception{
		bylawService.delAttFile(mtenMap);
		response.sendRedirect(req.getContextPath()+"/bylaw/adm/fileUpload.do?Bookid="+mtenMap.get("Bookid")+"&noFormYn="+mtenMap.get("noFormYn")+"&statehistoryid="+mtenMap.get("statehistoryid"));
	}
	
	@RequestMapping(value="makeLink.do")
	public void makeLink(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.makeLink(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="ruleDeptView.do")
	public String ruleDeptView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "existing/ruleDeptView.extjs"; 
	}
	
	@RequestMapping(value="ruleDeptData.do")
	public void ruleDeptData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.ruleDeptData(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="ruleDeptInsert.do")
	public void ruleDeptInsert(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.ruleDeptInsert(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping(value="ruleTree.do")
	public String ruleTree(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "existing/ruleTree.extjs"; 
	}
	
	@RequestMapping("/getRuleTree.do")
	public void getRuleTree(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONArray result =  bylawService.getRuleTree(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping(value="LawAllData.do")
	public void LawAllData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		 JSONObject jo = bylawService.LawAllData(mtenMap);
		 Json4Ajax.commonAjax(jo, response);
	}
	
	@RequestMapping("/saveRuleTree.do")
	public void saveRuleTree(Map<String, Object> mtenMap,HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		String TITLE = mtenMap.get("title")==null?"":mtenMap.get("title").toString();
		TITLE = TITLE.replaceAll("&amp;#40;", "(").replaceAll("&amp;#41;", ")");
		mtenMap.put("title",TITLE);
		JSONObject result =  bylawService.saveRuleTree(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping("/delRuleTree.do")
	public void delRuleTree(Map<String, Object> mtenMap,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONObject result =  bylawService.delRuleTree(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping("/updateRuleTree.do")
	public void updateRuleTree(Map<String, Object> mtenMap,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONObject result =  bylawService.updateRuleTree(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping(value="ruleTreeView.do")
	public String ruleTreeView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "existing/ruleTreeView.extjs"; 
	}
	
	@RequestMapping("chkCatruleList.do")
	public void chkCatruleList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception{
		JSONObject result = bylawService.chkCatruleList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping("getDept.do")
	public void getDept(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception{
		mtenMap.put("root", ConstantCode.DEPTROOT);
		JSONArray result = bylawService.getDept(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping("getCatruleInsert.do")
	public void getCatruleInsert(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception{
		JSONObject result = bylawService.getCatruleInsert(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping("getCatruleList.do")
	public void getCatruleList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception{
		JSONObject result = bylawService.getCatruleList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("getCatruleDelete.do")
	public void getCatruleDelete(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception{
		JSONObject result = bylawService.getCatruleDelete(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping("setXmlschBonSetting.do")
	public void setXmlschBonSetting(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception{
		bylawService.setXmlschBonSetting();
	} 
	
	@RequestMapping("getJoMunList.do")
	public void getJoMunList(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONArray result = bylawService.getJoMunList(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping(value="etcLink.do")
	public String etcLink(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "existing/etcLink.extjs"; 
	}
	
	@RequestMapping("ectLinkInsert.do")
	public void ectLinkInsert(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONObject result = bylawService.ectLinkInsert(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping(value = "ContfileUpload.do") // ajax에서 호출하는 부분
	@ResponseBody
	public String ContfileUpload(Map<String, Object> mtenMap ,MultipartHttpServletRequest multipartRequest) { // Multipart로
		bylawService.ContfileUpload(multipartRequest, mtenMap);
		return "success";
	}
	
	@RequestMapping("selectContFile.do")
	public void selectContFile(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		JSONArray result = bylawService.selectContFile(mtenMap);
		Json4Ajax.commonAjax(result, response);
	} 
	
	@RequestMapping("ContFileDelete.do")
	public void ContFileDelete(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		bylawService.DllImgDelete(mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", true);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("moveNode.do")
	public void moveNode(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		JSONObject result = bylawService.moveNode(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping("docInfoUpdate.do")
	public void docInfoUpdate(Map<String, Object> mtenMap ,HttpServletRequest request,HttpServletResponse response, ModelMap model) throws Exception{
		JSONObject result = bylawService.docInfoUpdate(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
}
