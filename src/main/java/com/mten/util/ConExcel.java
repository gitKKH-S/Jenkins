package com.mten.util;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ConExcel {
	
	public static void main(String args[]) throws FileNotFoundException, IOException{
		getExcelData("C:/Users/Administrator/Desktop/19년일괄업로드/2.xlsx");
	}
	
	public static HashMap getVal(XSSFCell cell, String NM,HashMap map){
		if(cell != null){
			//CONTRACTDEPTID
	    	//System.out.println(row.getCell(3).getRawValue());
			System.out.println(NM + "/" + cell.getCellType());
			System.out.println(NM + "XSSFCell.CELL_TYPE_STRING/" + XSSFCell.CELL_TYPE_STRING);
			System.out.println(NM + "XSSFCell.CELL_TYPE_BLANK/" + XSSFCell.CELL_TYPE_BLANK);
			System.out.println(NM + "XSSFCell.CELL_TYPE_NUMERIC/" + XSSFCell.CELL_TYPE_NUMERIC);
			System.out.println(NM + "XSSFCell.CELL_TYPE_FORMULA/" + XSSFCell.CELL_TYPE_FORMULA);
			System.out.println(NM + "XSSFCell.CELL_TYPE_ERROR/" + XSSFCell.CELL_TYPE_ERROR);
        	switch (cell.getCellType()) {
            	
	             case XSSFCell.CELL_TYPE_STRING:
                    map.put(NM, cell.getRichStringCellValue().getString());
                    break;

	             case HSSFCell.CELL_TYPE_BLANK:
	            	map.put(NM, "");
                    break;
	             
	             case HSSFCell.CELL_TYPE_NUMERIC : 
	            	 if( DateUtil.isCellDateFormatted(cell)) {
	            		Date date = cell.getDateCellValue();
	     				String cellString = new SimpleDateFormat("yyyy-MM-dd").format(date);
	     				map.put(NM, cellString);
	            	 }else{
	            		 System.out.println("==========================================================================");
	            		 System.out.println((double)cell.getNumericCellValue());
	            		 System.out.println((int)cell.getNumericCellValue());
	            		 System.out.println(cell.getNumericCellValue());
	            		 System.out.println("==========================================================================");
	            		 BigDecimal bigDecimal = new BigDecimal((double)cell.getNumericCellValue());
	            		 map.put(NM, bigDecimal);
	            	 }
					break;
				 
	             case HSSFCell.CELL_TYPE_FORMULA :
	            	 map.put(NM, cell.getRawValue());
					
	             case HSSFCell.CELL_TYPE_ERROR : break;
				 	
	             default: break;
        	}
        }
		return map;
	}
	
	public static ArrayList getExcelData(String fileurl) throws FileNotFoundException, IOException{
		ArrayList dataList = new ArrayList();
		FileInputStream fis = new FileInputStream(fileurl);
		//HSSFWorkbook workbook = new HSSFWorkbook(fis);
		//HSSFSheet sheet2 = workbook.getSheetAt(0);
		
		
		
		XSSFWorkbook work = new XSSFWorkbook(fis);
		
		
		
		int sheetNum = work.getNumberOfSheets();
		//System.out.println("sheetNum===>"+sheetNum);
		
		XSSFSheet sheet = work.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		
		ArrayList clist = new ArrayList();
		XSSFRow crow = sheet.getRow(1);
		if(crow != null){
	    	int cells = crow.getPhysicalNumberOfCells();
	    	for(int cellnum =0; cellnum < cells; cellnum++){
	    		XSSFCell cell = crow.getCell(cellnum);
	    		clist.add(cell.getStringCellValue());
	    	}
		}
		for( int rownum = 3; rownum < rows; rownum++){
			XSSFRow row = sheet.getRow(rownum);
			HashMap map = new HashMap();
			//System.out.println("row===>"+row);
		    if(row != null){
		    	int cells = row.getPhysicalNumberOfCells();
		    	/*System.out.println(row.getCell(3));
		    	
		    	System.out.println("clist===>"+clist);*/
		    	for(int cellnum =0; cellnum < cells; cellnum++){
		            XSSFCell cell = row.getCell(cellnum);
		            for(int k=0; k<clist.size(); k++){
		            	if(cellnum==k){
		            		System.out.println("cell===>"+cell);
		            		getVal(cell,(String)clist.get(k),map);
		            	}
		            }
		    	}
		    	System.out.println(map);
		    	String SDOCNO = map.get("SDOCNO")==null?"":map.get("SDOCNO").toString();
		    	if(!SDOCNO.equals("")){
			    	System.out.println("SDOCNO=====>"+SDOCNO);
	            	String SDOCNOS[] = SDOCNO.split("-");
	            	map.put("DOCYEAR", "20"+SDOCNOS[0]);
	            	map.put("SERIAL", SDOCNOS[1]);
	            	
	            	String BDOCNO = map.get("BDOCNO").toString();
	            	String BDOCNOS[] = BDOCNO.split("-");
	            	map.put("SDOCNO2", map.get("SDOCNO"));
	            	map.put("SDOCNO", map.get("SDOCNO")+"-"+BDOCNOS[1]+"-"+BDOCNOS[2]);
	            	map.put("SERIALSUB", BDOCNOS[2]);
	            	dataList.add(map);
		    	}
		    }
			
		}
		return dataList;
	}
	
	public static String createExcel(ArrayList<Map<String,Object>> list ,String Path){
		Date now = new Date();
		String fileNm = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREAN).format(now);
		
		ArrayList<String> columnList=new ArrayList<String>();	//데이터컬럼명
		ArrayList<String> columnRList=new ArrayList<String>();	//화면용컬럼명
		
		columnRList.add("key");
		columnRList.add("계약체결부서");
		columnRList.add("전사관리번호");
		columnRList.add("부서관리번호");
		columnRList.add("계약구분");
		columnRList.add("계약유형");
		columnRList.add("계약명");
		columnRList.add("계약기간");
		columnRList.add("계약체결일");
		columnRList.add("계약금");
		columnRList.add("계약상대방");
		columnRList.add("지불방식");
		columnRList.add("하자담보");
		columnRList.add("계약이행");
		columnRList.add("지체상금");
		columnRList.add("기타");
		columnRList.add("계약담당자");
		columnRList.add("계약상대방유형");
		columnRList.add("단가계약여부");
		columnRList.add("부가세포함여부");
		columnRList.add("법률검토의뢰여부");
		columnRList.add("법률검토의뢰일");
		columnRList.add("계약지연사유");
		columnRList.add("계약내용");
		
		columnList.add("DOCID");
		columnList.add("CONTRACTDEPTNM");
		columnList.add("SDOCNO");
		columnList.add("BDOCNO");
		columnList.add("DOCTYPE");
		columnList.add("DOCCD");
		columnList.add("DOCTITLE");
		columnList.add("DUEDT");
		columnList.add("CONTRACTDT");
		columnList.add("CONTRACTAMT");
		columnList.add("COUNTERPARTNM");
		columnList.add("PAYMENTMETHOD");
		columnList.add("M1");
		columnList.add("M2");
		columnList.add("M3");
		columnList.add("M4");
		columnList.add("CONTRACTCHARGEUSERNM");
		columnList.add("COUNTERPARTGBN");
		columnList.add("UNITPRICEYN");
		columnList.add("SURTAXYN");
		columnList.add("LAWCONSULTYN");
		columnList.add("LAWCONSULTDT");
		columnList.add("BIGO");
		columnList.add("DOCCONT");
		
		//임의의 VO가 되주는 MAP 객체
		Map<String,Object>map=null;
		
		System.out.println(columnList);
		//1차로 workbook을 생성 
		XSSFWorkbook workbook=new XSSFWorkbook();
		//2차는 sheet생성 
		XSSFSheet sheet=workbook.createSheet("문서관리시스템 리스트");
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
		CellStyle headerStyle2 = workbook.createCellStyle();
		headerStyle2.setAlignment(headerStyle2.ALIGN_CENTER);
		//임의의 DB데이터 조회 
		    int i=0;
		    row=sheet.createRow((short)i);
	        cell=row.createCell(0);
	        cell.setCellValue(String.valueOf("문서관리시스템 리스트"));
	        cell.setCellStyle(headerStyle);
	        sheet.addMergedRegion(new CellRangeAddress(0,0,0,columnList.size()-1));
	    	i++;
		    row=sheet.createRow((short)i);
	    	for(int j=0;j<columnRList.size();j++){
	    		//생성된 row에 컬럼을 생성한다 
	            cell=row.createCell(j);
	            //map에 담긴 데이터를 가져와 cell에 add한다 
	            cell.setCellValue(String.valueOf(columnRList.get(j)));
	            cell.setCellStyle(headerStyle2);
	    	}
	    	i++;
		    for(Map<String,Object>mapobject : list){
		        // 시트에 하나의 행을 생성한다(i 값이 0이면 첫번째 줄에 해당) 
		        row=sheet.createRow((short)i);
		        i++;
		        if(columnList !=null &&columnList.size() >0){
		            for(int j=0;j<columnList.size();j++){
			        	//생성된 row에 컬럼을 생성한다 
		                cell=row.createCell(j);
		                //map에 담긴 데이터를 가져와 cell에 add한다 
		                cell.setCellValue(cleanXSS(String.valueOf(mapobject.get(columnList.get(j))==null?"":mapobject.get(columnList.get(j)))));
		            }
		        }
		    }
		    System.out.println("row.getLastCellNum()"+row.getLastCellNum());
		    for(int colNum = 0; colNum<row.getLastCellNum();colNum++){ 
		    	System.out.println(colNum);
		    	workbook.getSheetAt(0).autoSizeColumn(colNum,true);
		    	sheet.setColumnWidth(colNum, sheet.getColumnWidth(colNum) + 1600);

		    }
			try{
				FileOutputStream fileoutputstream=new FileOutputStream(Path+fileNm+".xlsx");
				//파일을 쓴다
				workbook.write(fileoutputstream);
				//필수로 닫아주어야함 
				fileoutputstream.close();
				System.out.println("엑셀파일생성성공");
			}catch(Exception e){
				System.out.println(e);
			}
		return fileNm+".xlsx";
	}
	
	public static String cleanXSS(String value) {
    	value = value.replaceAll("&lt;", "<").replaceAll("&gt;", ">");
        value = value.replaceAll("&#40;", "\\(").replaceAll("&#41;", "\\)");
        value = value.replaceAll("&#91;", "\\[").replaceAll("&#93;", "\\]");
        value = value.replaceAll("&#39;", "'");
        value = value.replaceAll("&#58;", ":");
        value = value.replaceAll("&#64;", "@");
        value = value.replaceAll("&#47;", "\\/");
        value = value.replaceAll("&#42;", "\\*");
        value = value.replaceAll("&quot;", "\"");
        value = value.replaceAll("&#61", "\\=");
        return value;
    }
	
	public static void filedownload(String Serverfile,String downfile,HttpServletRequest req, HttpServletResponse response) throws IOException{
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
				System.out.println(downfile);
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
			
			out.println("<script>alert(\"첨부파일을 찾을수가 없습니다. 관리자에게 문의 바랍니다.\");</script>");
			out.close();
		}
	}
}
