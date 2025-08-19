package com.mten.util;

import java.io.* ;
import java.util.*;

import org.apache.poi.hssf.usermodel.* ;
import org.apache.poi.xssf.usermodel.* ;
import org.apache.poi.poifs.filesystem.POIFSFileSystem ;

public class ExcelReaderUtil {
	 /** 
     * @param args 
     * @throws ParseException 
     */ 
	public static List excelUpload(String filePath) throws Exception{
		HashMap<String, String> map = new HashMap<String, String>();
		ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();	
			
				System.out.println("=====excelUpload=======");
				
				String extention = filePath.substring(filePath.lastIndexOf(".") + 1);	//파일 확장
				System.out.println("==== "+filePath);
				
				if(extention.equals("xls")){
					
				    try {
		
				    	 POIFSFileSystem fileSystem = new POIFSFileSystem(new FileInputStream(new File(filePath)));
						 
						 HSSFWorkbook work = new HSSFWorkbook(fileSystem);
						 
						 int sheetNum = work.getNumberOfSheets();
						 
						 for (int loop = 0; loop < sheetNum; loop++){
							 HSSFSheet sheet  = work.getSheetAt(loop);
							 
							 int rows = sheet.getPhysicalNumberOfRows();
							 
							 for (int rownum = 0; rownum < rows; rownum++){
								 HSSFRow row = sheet.getRow(rownum);
								 
								 if (row != null){
									 int cells = row.getPhysicalNumberOfCells();
									 
									 for (int cellnum = 0; cellnum < cells; cellnum++){
										 HSSFCell cell = row.getCell(cellnum);
										 System.out.println("cellnum::"+cellnum+"::");
										 System.out.println("cell::"+cell+"::");
										 if (cell != null){
											 switch(cell.getCellType()){
											 	case HSSFCell.CELL_TYPE_FORMULA :
//											        map.put(""+cellnum,  cell.getCellFormula());
											 		map.put("COL"+cellnum,  Long.toString((long) cell.getNumericCellValue()));
											 		break;
											 	case HSSFCell.CELL_TYPE_STRING : 
											 		map.put("COL"+cellnum, cell.getRichStringCellValue().getString());
											 		break;
											 	case HSSFCell.CELL_TYPE_NUMERIC : 
											 		
											        if (org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell)){
											             map.put("COL"+cellnum, cell.getDateCellValue().toString());
											       }else{
											    	     map.put("COL"+cellnum, Long.toString((long) cell.getNumericCellValue()));
											       }
															
											 		break;						 		
											 	case HSSFCell.CELL_TYPE_BLANK :
											 		map.put("COL"+cellnum, "");
											 		break;
											 	case HSSFCell.CELL_TYPE_ERROR : break;
											 	default: break;
											 }
										 }
									 }
								 }
								 list.add(map);						 
							 }
						 }		    	
				    	
					} catch (IOException e) {
						e.printStackTrace();
					}
				 }else{
				    try {
		
				    	XSSFWorkbook work = new XSSFWorkbook(new FileInputStream(new File(filePath)));

//						 int sheetNum = work.getNumberOfSheets();
						  
//						 for (int loop = 0; loop < sheetNum; loop++){
//							 XSSFSheet sheet  = work.getSheetAt(loop);
				    	
				    		XSSFSheet sheet  = work.getSheetAt(0);
							 
							 int rows = sheet.getPhysicalNumberOfRows();
							 
							 for (int rownum = 0; rownum < rows; rownum++){
								 XSSFRow row = sheet.getRow(rownum);
								 
								 if (row != null){
									 int cells = row.getPhysicalNumberOfCells();
									 
									 for (int cellnum = 0; cellnum < cells; cellnum++){
										 XSSFCell cell = row.getCell(cellnum);
										 
										 if (cell != null){
											 switch(cell.getCellType()){
											 	case HSSFCell.CELL_TYPE_FORMULA :
											        map.put("COL"+cellnum,  Long.toString((long) cell.getNumericCellValue()));
											 		break;
											 	case HSSFCell.CELL_TYPE_STRING : 
											 		map.put("COL"+cellnum, cell.getRichStringCellValue().getString());
											 		break;
											 	case HSSFCell.CELL_TYPE_NUMERIC : 
											 		
											        if (org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell)){
											             map.put("COL"+cellnum, cell.getDateCellValue().toString());
											       }else{
											    	     map.put("COL"+cellnum, Long.toString((long) cell.getNumericCellValue()));
											       }
															
											 		break;						 		
											 	case HSSFCell.CELL_TYPE_BLANK :
											 		map.put("COL"+cellnum, "");
											 		break;
											 	case HSSFCell.CELL_TYPE_ERROR : break;
											 	default: break;
											 }
										 }
									 }
								 }
								 list.add(map);
								 map = new HashMap();
							 }
//						 }		    	
				    	
					} catch (IOException e) {
						e.printStackTrace();
					}
		 		}
			return list;
    } 	
	
}
