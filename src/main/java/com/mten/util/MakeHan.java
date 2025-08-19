package com.mten.util;

import java.io.*;
import java.nio.channels.FileChannel;
import java.text.*;
import java.util.*;
import java.util.regex.*;

import javax.servlet.http.HttpServletRequest;


public class MakeHan {
	
	public static String setCircleNum(String xmlData, String type){
		String[] sCircleNum = {"(16)","(17)","(18)","(19)","(20)","(21)","(22)","(23)","(24)","(25)","(26)","(27)","(28)","(29)","(30)"};
		String[] sChgNum = {"##16##","##17##","##18##","##19##","##20##","##21##","##22##","##23##","##24##","##25##","##26##","##27##","##28##","##29##","##30##"};
		
		if(xmlData != null  && !"".equals(xmlData)){
			for(int i=0;i<sCircleNum.length;i++){
				xmlData = xmlData.replaceAll(sChgNum[i], sCircleNum[i]);
			}
		}
		return xmlData;
	}
	
	public static String getDateParse(String date){
		if(date == null){
			return "";
		}
		SimpleDateFormat df = new SimpleDateFormat("EEE MMM d HH:mm:ss zzz yyyy", Locale.ENGLISH);
		SimpleDateFormat df1 = new SimpleDateFormat("yyyy-MM-dd ");
		Date d1 =null;
		String formattedDate=null;
		try {
			d1=df.parse(date);
			formattedDate =df1.format(d1);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return formattedDate;
		
	}
	public static boolean isContains(String str1,String str2){
		if(str1.indexOf(str2)!=-1) return true;
		else return false;
	}
	
	public static String sub_sub(String Title) throws Exception{
		if(Title.length()<10){
			return Title;
		}else{
			Title=Title.substring(0,10)+"...";
		}
		return Title;
		}
	public static String toKorean( String st ) {
	    if (st == null) return null;
	    try {
	      st = new String( st.getBytes("8859_1"), "euc-kr" );
	    } catch ( java.io.UnsupportedEncodingException e ) {
	      System.out.println( e.toString() );
	    }
	    return st;
	  }
	public static String toKorean_notic( String st ) {
	    if (st == null) return null;
	    try {
	      st = new String( st.getBytes("8859_1"), "euc-kr" );
	    } catch ( java.io.UnsupportedEncodingException e ) {
	      System.out.println( e.toString() );
	    }
	    return st;
	  }
	public static String toKorean2( String st ) {
	    if (st == null) return null;
	    try {
	      st = new String( st.getBytes("8859_1"), "utf-8" );
	    } catch ( java.io.UnsupportedEncodingException e ) {
	      System.out.println( e.toString() );
	    }
	    return st;
	  }
	
	public static String toDecoding( String st ) {
	    if (st == null) return null;
	    try {
	      st = new String( st.getBytes("euc-kr"), "8859_1" );
	    } catch ( java.io.UnsupportedEncodingException e ) {
	      System.out.println( e.toString() );
	    }
	    return st;
	  }
	public static String toDecoding2( String st ) {
	    if (st == null) return null;
	    try {
	      st = new String( st.getBytes("euc-kr"), "utf-8" );
	    } catch ( java.io.UnsupportedEncodingException e ) {
	      System.out.println( e.toString() );
	    }
	    return st;
	  }
	public static String File_url(String Data_cd) throws IOException { 
		ResourceBundle bundle = null;
        bundle = ResourceBundle.getBundle("egovframework.property.url");  
		String File_url = (String)bundle.getString("mten."+Data_cd);
		System.out.println("=========File_url : "+File_url);
		return File_url;
	}
	
	public static String get_data(){
		Calendar now    = Calendar.getInstance(); 
		int year      = now.get(Calendar.YEAR); 
		int month     = now.get(Calendar.MONTH) + 1; 
		int nowdate   = now.get(Calendar.DATE);
		String nowdate1="";
		String month1="";
		if(nowdate<10){
			nowdate1="0"+nowdate;
		}else{nowdate1=""+nowdate;}
		if(month<10){
			month1="0"+month;
		}else{month1=""+month;}
		String up_data=year+"-"+month1+"-"+nowdate1;
		
		System.out.println("up_data"+up_data);
		
		return up_data;
	}
	
	public static String get_data2(){
		Calendar now    = Calendar.getInstance(); 
		int year      = now.get(Calendar.YEAR); 
		int month     = now.get(Calendar.MONTH) + 1; 
		int nowdate   = now.get(Calendar.DATE);
		int second   = now.get(Calendar.SECOND);
		int MILLISECOND = now.get(Calendar.MILLISECOND);
		String nowdate1="";
		String month1="";
		if(nowdate<10){
			nowdate1="0"+nowdate;
		}else{nowdate1=""+nowdate;}
		if(month<10){
			month1="0"+month;
		}else{month1=""+month;}
		String up_data=year+month1+nowdate1+second+MILLISECOND;
		
		System.out.println("up_data"+up_data);
		
		return up_data;
	}

	
	public static String getDate_4(){
		Date now = new Date ( );
		SimpleDateFormat sdf4 = new SimpleDateFormat ( "yyyyMMdd",new Locale("en","US") );
		sdf4.setTimeZone ( TimeZone.getTimeZone ( "Asia/Seoul" ) );
		return sdf4.format ( now );
	}

	public static String convertFilename(String orgnStr) {
	    String restrictChars = "|\\\\?*<\":>/";
	    String regExpr = "[" + restrictChars + "]+";

	    // 파일명으로 사용 불가능한 특수문자 제거
	    String tmpStr = orgnStr.replaceAll(regExpr, "");

	    // 공백문자 "_"로 치환
	    return tmpStr.replaceAll("[ ]", "_");
	}
	
	public static void deleteFolder(String path) {
	    File folder = new File(path);
	    try {
		if(folder.exists()){
                File[] folder_list = folder.listFiles(); //파일리스트 얻어오기
				
		for (int i = 0; i < folder_list.length; i++) {
		    if(folder_list[i].isFile()) {
			folder_list[i].delete();
			System.out.println("파일이 삭제되었습니다.");
		    }else {
			deleteFolder(folder_list[i].getPath()); //재귀함수호출
			System.out.println("폴더가 삭제되었습니다.");
		    }
		    folder_list[i].delete();
		 }
		 folder.delete(); //폴더 삭제
	       }
	   } catch (Exception e) {
		e.getStackTrace();
	   }
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


