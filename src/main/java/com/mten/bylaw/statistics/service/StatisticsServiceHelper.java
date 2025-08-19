package com.mten.bylaw.statistics.service;

import java.io.File;

import javax.servlet.ServletContext;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class StatisticsServiceHelper {
	private static final String BYLAWSERVICE_BEANID = "statisticsService";
	
	public static StatisticsService getStatisticsService(ServletContext ctx)
	{
		WebApplicationContext wac = WebApplicationContextUtils.getWebApplicationContext(ctx);
		return (StatisticsService) wac.getBean(BYLAWSERVICE_BEANID);
	}
	
}
