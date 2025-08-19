package com.mten.bylaw.bylawweb.service;

import java.io.File;

import javax.servlet.ServletContext;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class BylawwebServiceHelper {
	private static final String BYLAWSERVICE_BEANID = "bylawwebService";
	
	public static BylawwebService getBylawwebService(ServletContext ctx)
	{
		WebApplicationContext wac = WebApplicationContextUtils.getWebApplicationContext(ctx);
		return (BylawwebService) wac.getBean(BYLAWSERVICE_BEANID);
	}
	
	public static void main(String[] args){
		ClassPathXmlApplicationContext ctx2 = new ClassPathXmlApplicationContext("classpath*:egovframework/spring/applicationContext*.xml");
		BylawwebService se2 = (BylawwebService)ctx2.getBean(BYLAWSERVICE_BEANID);
		//System.out.println(se2.setXmlSchBon("100093039"));
		//se2.setXmlschBonSetting();
		//se2.byulListInosert();
	}
	
}
