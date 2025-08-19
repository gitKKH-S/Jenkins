package com.mten.util;

import java.util.*;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class CommonMakeExcel {
	 public static String makeExcel(String sTit , ArrayList<String> columnList , ArrayList<String> columnRList , List<Map<String,Object>> datalist, HttpServletRequest req, HttpServletResponse response) {
		 String fileNm = sTit+".xlsx";
		 
		//임의의 VO가 되주는 MAP 객체
		Map<String,Object>map=null;
		//가상 DB조회후 목록을 담을 LIST객체
		//ArrayList<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
		
		//1차로 workbook을 생성 
		XSSFWorkbook workbook=new XSSFWorkbook();
		//2차는 sheet생성 
		XSSFSheet sheet=workbook.createSheet(sTit);
		//엑셀의 행 
		XSSFRow row=null;
		//엑셀의 셀 
		XSSFCell cell=null;
		
		//Set Header Font
		XSSFFont headerFont = workbook.createFont();
		headerFont.setBoldweight(headerFont.BOLDWEIGHT_BOLD);
		headerFont.setFontHeightInPoints((short) 12);
		//Set Header Style
		CellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setFillBackgroundColor(IndexedColors.BLACK.getIndex());
		headerStyle.setAlignment(headerStyle.ALIGN_CENTER);
		headerStyle.setFont(headerFont);
		//headerStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		
		//임의의 DB데이터 조회 
	    int i=0;
	    row=sheet.createRow((short)i);
        cell=row.createCell(0);
        cell.setCellValue(String.valueOf(sTit));
        cell.setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(0,0,0,columnList.size()-1));
    	i++;
	    row=sheet.createRow((short)i);
    	for(int j=0;j<columnRList.size();j++){
    		//생성된 row에 컬럼을 생성한다 
            cell=row.createCell(j);
            //map에 담긴 데이터를 가져와 cell에 add한다 
            cell.setCellValue(String.valueOf(columnRList.get(j)));
    	}
    	i++;
	    for(Map<String,Object>mapobject : datalist){
	        // 시트에 하나의 행을 생성한다(i 값이 0이면 첫번째 줄에 해당) 
	        row=sheet.createRow((short)i);
	        i++;
	        if(columnList !=null &&columnList.size() >0){
	            for(int j=0;j<columnList.size();j++){
		        	//생성된 row에 컬럼을 생성한다 
	                cell=row.createCell(j);
	                //map에 담긴 데이터를 가져와 cell에 add한다 
	                cell.setCellValue(String.valueOf(mapobject.get(columnList.get(j))==null?"":mapobject.get(columnList.get(j))));
	            }
	        }
	    }
	    System.out.println("row.getLastCellNum()"+row.getLastCellNum());
	    for(int colNum = 0; colNum<row.getLastCellNum();colNum++){ 
	    	System.out.println(colNum);
	    	workbook.getSheetAt(0).autoSizeColumn(colNum,true);
	    	sheet.setColumnWidth(colNum, sheet.getColumnWidth(colNum) + 1600);

	    }
	    String sfName = "";
	    String fileFullPath = "";
	    try {
	    	long time = System.currentTimeMillis(); 
			SimpleDateFormat dayTime = new SimpleDateFormat("yyyymmddhhmmss");
			String str = dayTime.format(new Date(time));

			sfName = str +".xlsx";
			
			fileFullPath = MakeHan.File_url("LAWTMP") + "/" + sfName;
			
	    	FileOutputStream fileoutputstream=new FileOutputStream(fileFullPath);
			//파일을 쓴다
			workbook.write(fileoutputstream);
			//필수로 닫아주어야함 
			fileoutputstream.close();
			System.out.println("엑셀파일생성성공");
			filedownload(fileFullPath,fileNm,req, response);
	    }catch(Exception e) {
	    	System.out.println("엑셀 생성 실패!!");
	    }
		
		
		return fileNm;
	 }
	 
	 public static void filedownload(String Serverfile,String downfile,HttpServletRequest req, HttpServletResponse response) throws IOException{
		File file = new File(Serverfile);
		boolean as = true;
		DataInputStream in = null;
		try {
			in = new DataInputStream(new FileInputStream(file));
		} catch (Exception e) {
			as = false;
		}

		ServletOutputStream os = null;
		if (as) {
			response.reset();
			os = response.getOutputStream();
			String whatExt = "";
			if (Serverfile != null) {
				whatExt = Serverfile.substring(Serverfile.length() - 4, Serverfile.length());

				if (".doc".equals(whatExt)) {
					// MS word file
					response.setContentType("application/msword; charset=Shift_JIS");
				} else if (".xls".equals(whatExt)) {
					// MS excel file
					response.setContentType("application/vnd.ms-excel; charset=Shift_JIS");
				} else if (".exe".equals(whatExt)) {
					// exe file
					response.setContentType("application/octet-stream; charset=Shift_JIS");
				} else if (".pdf".equals(whatExt)) {
					// pdf file
					response.setContentType("application/pdf; charset=Shift_JIS");
				} else {
					// etc
					response.setContentType("application/octet-stream; charset=Shift_JIS");
				}
				// 디코딩 필수
				response.setHeader("Content-Disposition", "attachment; filename =" + URLEncoder.encode(downfile, "utf-8"));

				byte buffer[] = new byte[1024];
				byte tmp;
				int x = 0;
				long count = 0;
				long size = file.length();
				try {
					byte tm;
					for (int i = 0; i < size; i++) {
						tm = in.readByte();
						os.write(tm);
					}
				} finally {
					os.close();
					in.close();
				}
			}
		} else {
			response.setContentType("text/html;charset=euc-kr");

			PrintWriter out = response.getWriter();

			out.println("<script>alert(\"첨부파일을 찾을수가 없습니다. 관리자에게 문의 바랍니다.\");</script>");
			out.close();
		}
	 }
}
