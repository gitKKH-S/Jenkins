package com.mten.bylaw.bylaw.service;

import java.io.File;

import javax.servlet.ServletContext;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class BylawServiceHelper {
	private static final String BYLAWSERVICE_BEANID = "bylawService";
	
	public static BylawService getBylawService(ServletContext ctx)
	{
		WebApplicationContext wac = WebApplicationContextUtils.getWebApplicationContext(ctx);
		return (BylawService) wac.getBean(BYLAWSERVICE_BEANID);
	}
	
	public static void main(String[] args){
		ClassPathXmlApplicationContext ctx2 = new ClassPathXmlApplicationContext("classpath*:egovframework/spring/application*.xml");
		BylawService se2 = (BylawService)ctx2.getBean(BYLAWSERVICE_BEANID);
		//System.out.println(se2.setXmlSchBon("100093039"));
		se2.setXmlschBonSetting();
		//se2.byulListInosert();
	}
	
	public static void main2(String[] args){
		ClassPathXmlApplicationContext ctx2 = new ClassPathXmlApplicationContext("/config/applicationContext*.xml");
		BylawService se2 = (BylawService)ctx2.getBean(BYLAWSERVICE_BEANID);
		File aa = new File("D:/att/");
		File aaa[] = aa.listFiles();
		String dd = "";
		for(int i=0; i<aaa.length; i++){
			File ss = (File)aaa[i];
			dd = dd + "," + ss.getName().toUpperCase().replaceAll("\\.PDF", "").replaceAll("\\.DOC", "");
		}
		System.out.println(dd);
	}
}
