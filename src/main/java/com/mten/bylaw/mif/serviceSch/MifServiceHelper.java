package com.mten.bylaw.mif.serviceSch;

import java.io.File;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletContext;

import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.mten.bylaw.bylaw.service.BylawService;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.*;

public class MifServiceHelper {
	private static final String MIFSERVICE_BEANID = "mifService";
	
	public static MifService getMifService(ServletContext ctx)
	{
		WebApplicationContext wac = WebApplicationContextUtils.getWebApplicationContext(ctx);
		return (MifService) wac.getBean(MIFSERVICE_BEANID);
	}
	
	public static void main(String[] args){
		ClassPathXmlApplicationContext ctx2 = new ClassPathXmlApplicationContext("classpath*:egovframework/spring/applicationContext*.xml");
		MifService se2 = (MifService)ctx2.getBean(MIFSERVICE_BEANID);
		//법령
		//se2.setInsertLaw();
		se2.setInsaInfo();
	}
}
