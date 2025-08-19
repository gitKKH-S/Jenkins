package com.mten.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.FileChannel;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.GZIPOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveOutputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.commons.compress.utils.IOUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.FileCopyUtils;

import com.mten.bylaw.consult.DateUtil;

public class zipFileDownload {
	
	public void allFileDownload(HttpServletRequest req, HttpServletResponse res, List<Map<String, Object>> fList, String filePath){
		try{
			Map map = this.DownloadAllFiles(fList, filePath);
			//String filePaths = filePath;
			String fileName = (String)map.get("fileName");
			
			File tempFile = new File( filePath + fileName );
			String agentType = req.getHeader("Accept-Encoding");
			
			boolean flag = false;
			String whatExt = fileName.substring(fileName.length()-4, fileName.length());
			
			if ( agentType != null && agentType.indexOf("gzip") >= 0 ) {
				flag = true;
			}
			
			OutputStream out = null;
			
			if (flag) {
				res.setHeader("Content-Encoding", "gzip");
				res.setHeader("Content-disposition", "attachment;filename=" + java.net.URLEncoder.encode(fileName, "utf-8")+";");
				out = new GZIPOutputStream( res.getOutputStream() );
			} else {
				whatExt = fileName.substring(fileName.length()-4, fileName.length());
				if(".doc".equals(whatExt)){
					//MS word file
					res.setContentType("application/msword");
				} else if(".xls".equals(whatExt)) {
					//MS excel file
					res.setContentType("application/vnd.ms-excel");
				} else if(".exe".equals(whatExt)) {
					//exe file
					res.setContentType("application/octet-stream");
				} else if(".pdf".equals(whatExt)) {
					//pdf file
					res.setContentType("application/pdf");
				} else {
					//etc
					res.setContentType("application/octet-stream");
				}
				res.setHeader("Content-disposition", "attachment;filename=" + java.net.URLEncoder.encode(fileName, "utf-8")+";");
				out = res.getOutputStream();
			}
			
			InputStream in = new BufferedInputStream(new FileInputStream(filePath + fileName));
			FileCopyUtils.copy(in, out);
			
			tempFile.delete();
			in.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public Map DownloadAllFiles(List<Map<String, Object>> fList, String filePath) throws Exception{
		String filepath = filePath;
		String zipName = DateUtil.getShortDateString()+DateUtil.getShortTimeString();
		String tmppath = filepath+zipName;
		
		String zipnm = tmppath.toString()+".zip";
		
		byte[] buf = new byte[8192];
		
		//파일을 압축시킨다
		ZipArchiveOutputStream zipOut = new ZipArchiveOutputStream(new FileOutputStream(zipnm));
		
		zipOut.setLevel(9);
		String enc = new java.io.OutputStreamWriter(System.out).getEncoding();
		if("UTF8".equals(enc)){
			enc = "UTF-8";
		}
		zipOut.setEncoding(enc);
		
		for(int i=0; i<fList.size(); i++ ){
			FileInputStream in = null;
			Map map = fList.get(i);
			
			File file = new File(filepath + map.get("SERVERFILENM").toString());
			if(file.exists()){
				in = new FileInputStream(filepath + map.get("SERVERFILENM").toString());
			}else{
				
			}
			zipOut.putArchiveEntry(new ZipArchiveEntry(map.get("VIEWFILENM").toString()));
		
			int len;
			while((len = in.read(buf)) > 0){
				zipOut.write(buf, 0, len);
			}
			zipOut.closeArchiveEntry();
			in.close();
		}
		zipOut.close();
		
		Map map = new HashMap();
		map.put("fileName", zipName+".zip");
		map.put("filePath", filepath);
		return map;
	}
	
	public void listFileDownload(HttpServletRequest req, HttpServletResponse res, List<Map<String, Object>> fList, String filePath, String zipname, String tmpPath){
		try{
			Map map = this.listFileDownload(fList, filePath, zipname, tmpPath);
			//String filePaths = filePath;
			String fileName = (String)map.get("fileName");
			
			File tempFile = new File( filePath + fileName );
			String agentType = req.getHeader("Accept-Encoding");
			
			boolean flag = false;
			String whatExt = fileName.substring(fileName.length()-4, fileName.length());
			
			if ( agentType != null && agentType.indexOf("gzip") >= 0 ) {
				flag = true;
			}
			
			OutputStream out = null;
			
			if (flag) {
				res.setHeader("Content-Encoding", "gzip");
				res.setHeader("Content-disposition", "attachment;filename=" + java.net.URLEncoder.encode(fileName, "utf-8")+";");
				out = new GZIPOutputStream( res.getOutputStream() );
			} else {
				whatExt = fileName.substring(fileName.length()-4, fileName.length());
				if(".doc".equals(whatExt)){
					//MS word file
					res.setContentType("application/msword");
				} else if(".xls".equals(whatExt)) {
					//MS excel file
					res.setContentType("application/vnd.ms-excel");
				} else if(".exe".equals(whatExt)) {
					//exe file
					res.setContentType("application/octet-stream");
				} else if(".pdf".equals(whatExt)) {
					//pdf file
					res.setContentType("application/pdf");
				} else {
					//etc
					res.setContentType("application/octet-stream");
				}
				res.setHeader("Content-disposition", "attachment;filename=" + java.net.URLEncoder.encode(fileName, "utf-8")+";");
				out = res.getOutputStream();
			}
			
			InputStream in = new BufferedInputStream(new FileInputStream(filePath + fileName));
			FileCopyUtils.copy(in, out);
			
			tempFile.delete();
			in.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public String StringReplace(String str) {
		String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
		System.out.println("str===>"+str);
		str = str.replaceAll(match, "");
		System.out.println("str===>"+str);
		return str;
	}
	
	public Map listFileDownload(List<Map<String, Object>> fList, String filePath, String zipName, String tmpPath) throws Exception{
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat sdf = new SimpleDateFormat("YYYYMMDD");
		String getDate = sdf.format(timestamp);
		
		String zipnm = filePath + zipName + ".zip";
		byte[] buf = new byte[8192];
		ZipArchiveOutputStream zipOut = new ZipArchiveOutputStream(new FileOutputStream(zipnm));
		
		zipOut.setLevel(9);
		String enc = new java.io.OutputStreamWriter(System.out).getEncoding();
		if("UTF8".equals(enc)){
			enc = "UTF-8";
		}
		zipOut.setEncoding(enc);
		//File fol = new File(tmpPath+"/"+getDate+"/"+zipName);
		
		for(int i=0; i<fList.size(); i++){
			
			FileInputStream in = null;
			Map map = fList.get(i);
			String title = tmpPath+"/"+getDate+"/"+zipName+ "/" + this.StringReplace(map.get("PST_TTL").toString());
			title = title.trim();
			
			File ss = new File(title);
			if(i == 0 || !title.equals(this.StringReplace(fList.get(i-1).get("PST_TTL").toString()))){
				ss.mkdirs();
			}
			fileCopy(filePath+map.get("SRVR_FILE_NM").toString(), title+"/"+map.get("PHYS_FILE_NM").toString());
			
			File file = new File(filePath);
			if(file.exists()){
				in = new FileInputStream(filePath+map.get("SRVR_FILE_NM").toString());
			}else{
				
			}
			zipOut.putArchiveEntry(new ZipArchiveEntry(map.get("PST_TTL").toString()+"/"+map.get("PHYS_FILE_NM").toString()));
			
			int len;
			while((len = in.read(buf)) > 0){
				zipOut.write(buf, 0, len);
			}
			zipOut.closeArchiveEntry();
			in.close();
		}
		
		zipOut.close();
		
		Map map = new HashMap();
		map.put("fileName", zipName+".zip");
		map.put("filePath", filePath);
		
		return map;
	}
	
	public static void fileCopy(String f1, String f2){
		//스트림, 채널 선언  
		FileInputStream inputStream = null;  
		FileOutputStream outputStream = null;  
		FileChannel fcin = null;  
		FileChannel fcout = null;  
		try {
			//복사 대상이 되는 파일 생성   
			File sourceFile = new File(f1 );
			//스트림 생성   
			inputStream = new FileInputStream(sourceFile); 
			
			outputStream = new FileOutputStream(f2);   
			//채널 생성   
			fcin = inputStream.getChannel();   
			fcout = outputStream.getChannel();      
			//채널을 통한 스트림 전송   
			long size = fcin.size();   
			fcin.transferTo(0, size, fcout);  
		} catch (Exception e) {  
			e.printStackTrace();  
		} finally {   
			//자원 해제  
			try{    
				fcout.close();   
			}catch(IOException ioe){}   
			try{    
				fcin.close();   
			}catch(IOException ioe){}   
			try{    
				outputStream.close();   
			}catch(IOException ioe){}   
			try{    
				inputStream.close();   
			}catch(IOException ioe){}  
		} 
	}
}