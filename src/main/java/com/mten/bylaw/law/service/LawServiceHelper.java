package com.mten.bylaw.law.service;

import javax.servlet.ServletContext;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class LawServiceHelper {
	private static final String LAWSERVICE_BEANID = "lawService";
	
	public static LawService getLawService(ServletContext ctx)
	{
		WebApplicationContext wac = WebApplicationContextUtils.getWebApplicationContext(ctx);
		return (LawService) wac.getBean(LAWSERVICE_BEANID);
	}
}
