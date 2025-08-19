package com.mten.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.ArrayList;


public class MakeData {
	public static int cnt = 100000;
	public static void main(String args[]){
		File io = new File("C:/Users/mten01/Desktop/과거자문의견서/old/");
		File sub[] = io.listFiles();
		for(int i=0; i<sub.length; i++){
			File re = sub[i];
			if(re.isDirectory()){
				getFilelist(re);
			}
		}
	}
	
	public static ArrayList getFilelist(File is){
		File sub[] = is.listFiles();
		ArrayList arr = new ArrayList();
		for(int i=0; i<sub.length; i++){
			File re = sub[i];
			if(re.isDirectory()){
				getFilelist(re);
			}
			if(re.isFile()){
				getFilePath(re);
			}
		}
		
		return arr;
	}
	
	public static void getFilePath(File io){
		String fnm = io.getName();
		String ext = fnm.substring(fnm.lastIndexOf("."), fnm.length());
		String mkdir = "C:/Users/mten01/Desktop/과거자문의견서/new/";
		File ss = new File(mkdir);
		ss.mkdirs();
		
		fileCopy(io.getParent()+"/"+io.getName(),mkdir+"/"+cnt+ext);
		
		System.out.println(cnt +"	"+io.getParent()+"	"+io.getName()+"	"+cnt+ext);
		cnt++;
	}
	
	public static void fileCopy(String f1, String f2){
		//��Ʈ��, ä�� ����  
		FileInputStream inputStream = null;  
		FileOutputStream outputStream = null;  
		FileChannel fcin = null;  
		FileChannel fcout = null;  
		try {
			//���� ����� �Ǵ� ���� ����   
			File sourceFile = new File(f1 );
			//��Ʈ�� ����   
			inputStream = new FileInputStream(sourceFile); 
			
			outputStream = new FileOutputStream(f2);   
			//ä�� ����   
			fcin = inputStream.getChannel();   
			fcout = outputStream.getChannel();      
			//ä���� ���� ��Ʈ�� ����   
			long size = fcin.size();   
			fcin.transferTo(0, size, fcout);  
		} catch (Exception e) {  
			e.printStackTrace();  
		} finally {   
			//�ڿ� ����  
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
