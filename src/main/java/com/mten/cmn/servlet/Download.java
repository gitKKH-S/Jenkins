package com.mten.cmn.servlet;
/*
 * 다운로드 서블릿
 */
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.ResourceBundle;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.ServletRequestUtils;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.bylaw.service.BylawServiceHelper;
import com.mten.util.fasooDrm;
/**
* 
*/

public class Download extends HttpServlet
{
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
	{
		ResourceBundle bundle = ResourceBundle.getBundle("egovframework.property.url");
		
		String Serverfile = request.getParameter("Serverfile");
		String Pcfilename = ServletRequestUtils.getStringParameter(request, "Pcfilename", Serverfile);
		String fkey = ServletRequestUtils.getStringParameter(request, "folder", "");
		String DRMYN = ServletRequestUtils.getStringParameter(request, "DRMYN", "");
		
		String filePath = (String)bundle.getString("mten."+fkey);
		
		System.out.println("Pcfilename"+Pcfilename);
		System.out.println("Serverfile"+Serverfile);
		System.out.println("filePath"+filePath);
		
		if(fkey.equals("ATTACH") || fkey.equals("LAW")){
			ServletContext application = getServletContext();
			BylawService byservice = BylawServiceHelper.getBylawService(application);
			HashMap para = new HashMap();
			para.put("fileid", Serverfile);
			para = byservice.getFileName(para);
			Pcfilename = para.get("PCFILENAME")==null?Serverfile:para.get("PCFILENAME").toString();
		}
		
		if(DRMYN.equals("Y")) {
			fasooDrm.fileDoPackaging(Serverfile, "E"+Serverfile, filePath);
			Serverfile = "E"+Serverfile;
		}
		
		File file = new File(filePath+ Serverfile);
		String currentDir = request.getServletPath().substring(0, request.getServletPath().lastIndexOf('/'));
		
		boolean as=true;
		DataInputStream in = null;
		try{
			in = new DataInputStream(new FileInputStream(file));
		}catch (Exception e){
			as = false;
		}
		System.out.println("as"+as);System.out.println("in"+in);
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
					response.setContentType("application/octet-stream;charset=utf-8");
				}
				//디코딩 필수
				Pcfilename = java.net.URLEncoder.encode(Pcfilename, "utf-8");//this.encoding
				Pcfilename = Pcfilename.replaceAll("\\+", "%20");
				response.setHeader("Content-Disposition", "attachment; filename =" + Pcfilename);
	
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
			out.println("<script>alert(\""+"첨부파일을 찾을수가 없습니다. 관리자에게 문의 바랍니다.\");history.go(-1);</script>");
			out.close();
		}
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
	{
		doGet(request, response);
	}

}


