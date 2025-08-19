package com.mten.util;

import java.io.* ;
import java.util.*;
import java.lang.*;
import java.math.*;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.* ;
import org.apache.poi.ss.usermodel.* ;
import org.apache.poi.ss.util.Region ;
import org.apache.poi.hssf.util.HSSFColor;


public class ExcelWriterUtil {
	 /** 
     * @param args 
     * @throws ParseException 
     */ 
	 private static HSSFCellStyle getTitleStyle(HSSFWorkbook workbook)
	 {
	  HSSFCellStyle style = null;
	  style = workbook.createCellStyle();
	  style.setFont(getFont(workbook,"Arial",14,true));
	  style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	  style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
	  return style;
	 }

	 private static HSSFCellStyle getColumStyle(HSSFWorkbook workbook, String fontName, int fontSize, boolean isBold, boolean isBG)
	 {
	  HSSFCellStyle style = null;
	  HSSFFont font;

	  style = workbook.createCellStyle();
	  style.setFont(getFont(workbook,fontName,fontSize,isBold));
	  style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	  style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
	  if (isBG) {
	   style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
	   style.setFillPattern(CellStyle.SOLID_FOREGROUND);
	  }
	  style.setBorderBottom(CellStyle.BORDER_THIN);
	     style.setBottomBorderColor(IndexedColors.GREY_80_PERCENT.getIndex());
	     style.setBorderLeft(CellStyle.BORDER_THIN);
	     style.setLeftBorderColor(IndexedColors.GREY_80_PERCENT.getIndex());
	     style.setBorderRight(CellStyle.BORDER_THIN);
	     style.setRightBorderColor(IndexedColors.GREY_80_PERCENT.getIndex());
	     style.setBorderTop(CellStyle.BORDER_THIN);
	     style.setTopBorderColor(IndexedColors.GREY_80_PERCENT.getIndex());

	  return style;
	 }
	 
	 private static HSSFFont getFont(HSSFWorkbook workbook, String fontName, int fontSize, boolean isBold)
	 {
	  HSSFFont font;
	  font = workbook.createFont();
	  font.setFontHeightInPoints((short)fontSize);
	  font.setFontName(fontName);
	  if (isBold) font.setBoldweight(Font.BOLDWEIGHT_BOLD);
	  font.setColor(HSSFColor.BLACK.index);
	  
	  return font;
	 }
	 
	 public static void getWorkbook(HttpServletResponse response,
			 List<Map<String, Object>> list, String[] title, String[] column){
		 //파일명
		 String name="excelDownload.xls";
		 response.setHeader("Content-Disposition", "attachment; filename=" + name);
		 

		 OutputStream os = null;
		 HSSFWorkbook workbook = null;
		 HSSFSheet sheet = null;
		 HSSFRow row = null;
		 HSSFCell cell = null;
		 
		 try {
		  workbook = new HSSFWorkbook();

		  //시트 이름 지정 및 시트 생성
		  sheet = workbook.createSheet("sheet1");

		  row = sheet.createRow((short)0);
		  row.setHeightInPoints(25);
		  //sheet.addMergedRegion(new Region(0, (short)0,0, (short)10));

		  //0번째 줄에 타이틀 출력
		  cell = row.createCell((short)0);
		  cell.setCellStyle(getTitleStyle(workbook));  
		  cell.setCellValue("Sample List");
		  
		  row = sheet.createRow((short)1);
		  row.setHeightInPoints(18);

		 

		  //컬럼명, 넓이 지정 및 출력

		  //int[] cellWidth = {5500,4000,3000};

		  for (int i=0; i<title.length; i++) {
		   //sheet.setColumnWidth((short)i, (short)cellWidth[i]);
		   cell = row.createCell((short)i);
		   cell.setCellValue(title[i]);
		  }
		  

		  //2번째 줄부터 데이터 출력
		  for (int i=0; i<list.size(); i++)
		  {
			  Map<String,Object> map = list.get(i);
			  row = sheet.createRow((short)i+2);
		   
		   	  for (int j=0; j<column.length;j++){
		   		  cell = row.createCell((short)j);
		   		  cell.setCellValue(""+map.get(column[j]));
		   	  }

		  }
		  
		  
		 // out.clear();
		 // out=pageContext.pushBody();

		  os = response.getOutputStream();
		  workbook.write(os);
		  
		 }
		 catch (Exception e) {
		  
		 }
		 finally {
		  try {
			os.close();
		} catch (IOException e) {

			e.printStackTrace();
		}
		 }

	 }
}
