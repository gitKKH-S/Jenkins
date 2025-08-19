package com.mten.bylaw.consult.service;

import java.io.File;

import javax.servlet.ServletContext;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class ConsultServiceHelper {
	private static final String CONSULTSERVICE_BEANID = "cousultService";
	
	public static ConsultService getConsultService(ServletContext ctx)
	{
		WebApplicationContext wac = WebApplicationContextUtils.getWebApplicationContext(ctx);
		return (ConsultService) wac.getBean(CONSULTSERVICE_BEANID);
	}
	
	public static void main(String[] args){
		ClassPathXmlApplicationContext ctx2 = new ClassPathXmlApplicationContext("classpath*:egovframework/spring/applicationContext*.xml");
		ConsultService se2 = (ConsultService)ctx2.getBean(CONSULTSERVICE_BEANID);
	}
	
}
