package com.mten.bylaw.bylawweb.controller;


import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.bylawweb.service.BylawwebService;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.util.CommonMakeExcel;
import com.mten.util.Json4Ajax;
import com.mten.util.JsonHelper;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



@Controller
@RequestMapping("/web/regulation/")
public class BylawwebController extends DefaultController{
	@Resource(name="bylawwebService")
	private BylawwebService bylawwebService;
	
	@Resource(name="bylawService")
	private BylawService bylawService;
	
	@RequestMapping(value="regulationMain.do")
	public String regulationMain(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "regulation/regulationMain.web";
	}
	
	@RequestMapping(value="regulationList.do")
	public String regulationList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String mtype = mtenMap.get("mtype")==null?"":mtenMap.get("mtype").toString();
		String dUrl = "regulation/regulationList.frm";
		if(mtype.equals("dsch")) {
			dUrl = "regulation/regulationSchList.frm";
		}
		return dUrl;
	}
	
	//트리노드
	@RequestMapping(value="getTreeNode.do")
	protected void getTreeNode(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response) throws Exception {
		System.out.println("mtenMap===>"+mtenMap);
		String mtype = mtenMap.get("mtype")==null?"":mtenMap.get("mtype").toString();
		JSONArray jr = new JSONArray();
		if(mtype.equals("htree")||mtype.equals("ctree")) {
			jr = bylawwebService.getTreeNode(mtenMap);
		}else if(mtype.equals("dtree")) {
			jr = bylawwebService.getDeptNode(mtenMap);
		}else if(mtype.equals("recent")||mtype.equals("fav")) {
			HttpSession session = req.getSession();
			HashMap se = (HashMap)session.getAttribute("userInfo"); 
			String memberid = se.get("USERNO")==null?"":se.get("USERNO").toString();	
			mtenMap.put("memberid",memberid);
			jr = bylawwebService.getRecentNode(mtenMap);
		}
		Json4Ajax.commonAjax(jr, response);
	}
	
	@RequestMapping(value="regulationListData.do")
	public void regulationListData(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String start = mtenMap.get("start")==null?"":mtenMap.get("start").toString();
		String limit = mtenMap.get("limit")==null?"":mtenMap.get("limit").toString();
		String mtype = mtenMap.get("mtype")==null?"":mtenMap.get("mtype").toString();
		
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
		}else {
			if(mtype.equals("recent")) {
				mtenMap.put("orderby", "order by startdt desc");
			}
			if(mtype.equals("htree")) {
				mtenMap.put("orderby", "order by PROMULDT desc");
			}
		}
		
		if(mtype.equals("fav")) {
			HttpSession session = req.getSession();
			HashMap se = (HashMap)session.getAttribute("userInfo"); 
			String memberid = se.get("USERNO")==null?"":se.get("USERNO").toString();	
			mtenMap.put("memberid",memberid);
		}
		JSONObject result = bylawwebService.regulationListData(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="regulationView.do")
	public String regulationView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println("mtenMap===>"+mtenMap);
		String noformyn = mtenMap.get("noformyn")==null?"":mtenMap.get("noformyn").toString();
		String durl = "";
		HashMap result = new HashMap();
		
		if(noformyn.equals("N")){
			result = bylawwebService.regulationView(mtenMap);
			durl = "regulation/regulationView.frm";
		}else if(noformyn.equals("Y")){
			result = bylawwebService.regulationNoFormView(mtenMap);
			durl = "regulation/regulationNoFormView.frm";
		}
		
		model.addAttribute("param", mtenMap);
		model.addAttribute("bonInfo", result);
		System.out.println("durl===>"+durl);
		return durl;
	}
	
	@RequestMapping(value="regulationViewPop.do")
	public String regulationViewPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println("mtenMap===>"+mtenMap);
		String noformyn = mtenMap.get("noformyn")==null?"":mtenMap.get("noformyn").toString();
		String bookid = mtenMap.get("bookid")==null?"":mtenMap.get("bookid").toString();
		String durl = "";
		HashMap result = new HashMap();
		
		if(bookid.equals("")) {
			HashMap binfo = bylawwebService.getBookInfo2(mtenMap);
			bookid = binfo.get("BOOKID")==null?"":binfo.get("BOOKID").toString();
			noformyn = binfo.get("NOFORMYN")==null?"":binfo.get("NOFORMYN").toString();
			mtenMap.put("bookid", bookid);
			mtenMap.put("noformyn", noformyn);
		}
		
		if(noformyn.equals("N")){
			result = bylawwebService.regulationView(mtenMap);
			durl = "regulation/regulationViewPop.frm";
		}else if(noformyn.equals("Y")){
			result = bylawwebService.regulationNoFormView(mtenMap);
			durl = "regulation/regulationNoFormViewPop.frm";
		}
		
		model.addAttribute("param", mtenMap);
		model.addAttribute("bonInfo", result);
		System.out.println("durl===>"+durl);
		return durl;
	}
	
	@RequestMapping(value="bonPop.do")
	public void bonPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println("mtenMap===>"+mtenMap);
		String noformyn = mtenMap.get("NOFORMYN")==null?"":mtenMap.get("NOFORMYN").toString();
		String durl = "";
		HashMap result = new HashMap();
		if(noformyn.equals("N")){
			result = bylawwebService.regulationView(mtenMap);
		}else if(noformyn.equals("Y")){
			result = bylawwebService.regulationNoFormView(mtenMap);
			
			List flist = result.get("flist")==null?new ArrayList(): (List)result.get("flist");
			String junFname = "";
			for(int i=0; i<flist.size(); i++){
				HashMap fre = (HashMap)flist.get(i);
				String fcd = fre.get("FILECD")==null?"":fre.get("FILECD").toString();
				if(fcd.equals("전문")){
					junFname = fre.get("SERVERFILE")==null?"":fre.get("SERVERFILE").toString();
				}
			}
			if(junFname.equals("")){
				for(int i=0; i<flist.size(); i++){
					HashMap fre = (HashMap)flist.get(i);
					junFname = fre.get("SERVERFILE")==null?"":fre.get("SERVERFILE").toString();
				}	
			}
			result.put("bon", junFname);
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
	
	@RequestMapping(value="popPrint.do")
	public String popPrint(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String noformyn = mtenMap.get("noformyn")==null?"":mtenMap.get("noformyn").toString();
		HashMap result = bylawwebService.regulationView(mtenMap);
		model.addAttribute("param", mtenMap);
		model.addAttribute("bonInfo", result);
		return "regulation/popPrint.frm";
	}
	
	@RequestMapping(value="multipleView.do")
	public String multipleView(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		return "regulation/multipleView.frm";
	}
	
	@RequestMapping(value="setFav.do")
	public void setFav(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = req.getSession();
		HashMap se = (HashMap)session.getAttribute("userInfo"); 
		String memberid = se.get("USERNO")==null?"":se.get("USERNO").toString();	
		mtenMap.put("memberid",memberid);
		JSONObject result = bylawwebService.setFav(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="historyListSelect.do")
	public void historyListSelect(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		JSONObject result = bylawwebService.historyListSelect(mtenMap);
		Json4Ajax.commonAjax(result, response);
	}
	
	@RequestMapping(value="joPop.do")
	public String joPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap result = bylawwebService.getOldjo(mtenMap);
		model.addAttribute("param", mtenMap);
		model.addAttribute("oldjo", result);
		return "regulation/joPop.pop";
	}
	
	@RequestMapping(value="printJoPop.do")
	public String printJoPop(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		model.addAttribute("bookInfo", bylawwebService.BookInfo(mtenMap));
		return "regulation/printJoPop.pop";
	}
	
	@RequestMapping(value="2_popup.do")
	public String popup2(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("statecd", "현행");
		model.addAttribute("param", mtenMap);
		model.addAttribute("list", bylawwebService.getDanList(mtenMap));
		return "regulation/2_popup.dll";
	}
	
	@RequestMapping(value="3_popup.do")
	public String popup3(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("statecd", "현행");
		model.addAttribute("param", mtenMap);
		model.addAttribute("list", bylawwebService.getDanList(mtenMap));
		return "regulation/3_popup.dll";
	}
	
	@RequestMapping(value="4_popup.do")
	public String popup4(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("statecd", "현행");
		model.addAttribute("param", mtenMap);
		model.addAttribute("list", bylawwebService.getDanList(mtenMap));
		return "regulation/4_popup.dll";
	}
	
	@RequestMapping(value="frameBon.do")
	public String frameBon(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String Book_id_r = mtenMap.get("Book_id_r")==null?"":mtenMap.get("Book_id_r").toString();
		String Book_id_r2 = mtenMap.get("Book_id_r2")==null?"":mtenMap.get("Book_id_r2").toString();
		String Book_id_c = mtenMap.get("Book_id_c")==null?"":mtenMap.get("Book_id_c").toString();
		String Book_id_l = mtenMap.get("Book_id_l")==null?"":mtenMap.get("Book_id_l").toString();
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		String Bookid="";
		if(gbn.equals("center")){
			Bookid = Book_id_c; 
		}
		if(gbn.equals("left")){
			Bookid = Book_id_l;
		}
		if(gbn.equals("right")){
			Bookid = Book_id_r;
		}
		if(gbn.equals("right2")){
			Bookid = Book_id_r2;
		}
		mtenMap.put("bookid", Bookid);
		model.addAttribute("bookInfo", bylawwebService.BookInfo(mtenMap));
		model.addAttribute("param", mtenMap);
		return "regulation/frameBon.dll";
	}
	
	@RequestMapping(value="Dan_print.do")
	public String Dan_print(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "regulation/Dan_print.dll";
	}
	
	@RequestMapping(value="createHwp.do")
	public String createHwp(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "regulation/createHwp.dll";
	}
	
	@RequestMapping(value="2_compare.do")
	public String compare2(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("statecd", "현행");
		model.addAttribute("param", mtenMap);
		model.addAttribute("list", bylawwebService.getDanList(mtenMap));
		return "regulation/2_compare.dll";
	}
	
	@RequestMapping(value="3_compare.do")
	public String compare3(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("statecd", "현행");
		model.addAttribute("param", mtenMap);
		model.addAttribute("list", bylawwebService.getDanList(mtenMap));
		return "regulation/3_compare.dll";
	}
	
	@RequestMapping(value="4_compare.do")
	public String compare4(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		mtenMap.put("statecd", "현행");
		model.addAttribute("param", mtenMap);
		model.addAttribute("list", bylawwebService.getDanList(mtenMap));
		return "regulation/4_compare.dll";
	}
	
	@RequestMapping(value="dan_fram2.do")
	public String dan_fram2(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "regulation/dan_fram2.dll";
	}
	
	@RequestMapping(value="dan_fram3.do")
	public String dan_fram3(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "regulation/dan_fram3.dll";
	}
	
	@RequestMapping(value="dan_fram4.do")
	public String dan_fram4(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("param", mtenMap);
		return "regulation/dan_fram4.dll";
	}
	
	@RequestMapping(value="allDownload.do")
	public void allDownload(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap finfo = bylawwebService.AllZip(mtenMap);
		System.out.println("finfo===>"+finfo);
		String sfnm = finfo.get("fName")==null?"":finfo.get("fName").toString();
		String pfnm = finfo.get("sName")==null?"":finfo.get("sName").toString();
		String path =  MakeHan.File_url("LAW");
		filedownload(path+sfnm,pfnm,req, response);
	}
	
	public void filedownload(String Serverfile,String downfile,HttpServletRequest req, HttpServletResponse response) throws IOException{
		File file = new File(Serverfile);
		boolean as=true;
		DataInputStream in = null;
		try{
			in = new DataInputStream(new FileInputStream(file));
		}catch (Exception e){
			as = false;
		}
		
		ServletOutputStream os = null;
		if(as){
			response.reset();
			os = response.getOutputStream();
			String whatExt = "";
			if (Serverfile != null)
			{
				whatExt = Serverfile.substring(Serverfile.length()-4, Serverfile.length());
	  
				if(".doc".equals(whatExt)){
					//MS word file
					response.setContentType("application/msword; charset=Shift_JIS");
				} else if(".xls".equals(whatExt)) {
					//MS excel file    
					response.setContentType("application/vnd.ms-excel; charset=Shift_JIS");
				} else if(".exe".equals(whatExt)) {
					//exe file
					response.setContentType("application/octet-stream; charset=Shift_JIS");
				} else if(".pdf".equals(whatExt)) {
					//pdf file
					response.setContentType("application/pdf; charset=Shift_JIS");
				} else {
					//etc
					response.setContentType("application/octet-stream; charset=Shift_JIS");
				}
				//디코딩 필수
				downfile = java.net.URLEncoder.encode(downfile, "utf-8");//this.encoding
				downfile = downfile.replaceAll("\\+", "%20");
				response.setHeader("Content-Disposition", "attachment; filename =" + downfile);

				byte buffer[] = new byte[1024];
				byte tmp;
				int x = 0;
				long count = 0;
				long size = file.length();
				try
				{
					byte tm;
					for (int i = 0; i < size; i++)
					{
						tm = in.readByte();
						os.write(tm);
					}
				}
				finally
				{
					os.close();
					in.close();
				}
			}
		}else{
			response.setContentType("text/html;charset=euc-kr");
			
			PrintWriter out=response.getWriter();
			
			out.println("<script>alert(\"첨부파일을 찾을수가 없습니다. 관리자에게 문의 바랍니다.\");history.go(-1);</script>");
			out.close();
		}
	}
	
	@RequestMapping(value="regulationListDataMakeExcel.do")
	public void regulationListDataMakeExcel(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		String start = mtenMap.get("start")==null?"":mtenMap.get("start").toString();
		String limit = mtenMap.get("limit")==null?"":mtenMap.get("limit").toString();
		String mtype = mtenMap.get("mtype")==null?"":mtenMap.get("mtype").toString();
		
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
		}else {
			if(mtype.equals("recent")) {
				mtenMap.put("orderby", "order by startdt desc");
			}
		}
		
		if(mtype.equals("fav")) {
			HttpSession session = req.getSession();
			HashMap se = (HashMap)session.getAttribute("userInfo"); 
			String memberid = se.get("USERNO")==null?"":se.get("USERNO").toString();	
			mtenMap.put("memberid",memberid);
		}
		JSONObject result = bylawwebService.regulationListData(mtenMap);
		
		List datalist = JsonHelper.toList((JSONArray)result.get("result"));
		
		String sTit = "규정리스트";
		ArrayList<String> columnList = new ArrayList<String>();	//데이터컬럼명
		ArrayList<String> columnRList = new ArrayList<String>();	//화면용컬럼명
		columnRList.add("규정명");
		columnRList.add("제/개정");
		columnRList.add("공포일");
		columnRList.add("시행일");
		columnRList.add("담당부서");
		
		columnList.add("TITLE");
		columnList.add("REVCD");
		columnList.add("PROMULDT");
		columnList.add("STARTDT");
		columnList.add("DEPTNAME");
		CommonMakeExcel.makeExcel(sTit, columnList, columnRList, datalist, req, response);
	}
	
	@RequestMapping(value="joFileList.do")
	public String joFileList(Map<String, Object> mtenMap ,HttpServletRequest req, HttpServletResponse response, ModelMap model) throws Exception {
		List fl = bylawwebService.joFileList(mtenMap);
		model.addAttribute("fl", fl);
		return "regulation/joFileList.frm";
	}
}
