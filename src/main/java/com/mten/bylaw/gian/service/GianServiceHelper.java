package com.mten.bylaw.gian.service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.w3c.dom.CDATASection;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.DocumentType;
import org.w3c.dom.Element;

public class GianServiceHelper {
	private static final String NOTICESERVICE_BEANID = "gianService";
	
	public static GianService getGianService(ServletContext ctx)
	{
		WebApplicationContext wac = WebApplicationContextUtils.getWebApplicationContext(ctx);
		return (GianService) wac.getBean(NOTICESERVICE_BEANID);
	}
	
	public static void main(String[] args) {
		for(int i=0; i<20; i++){
		System.out.println(String.format("%03d", i+1));
		}
	}
}
