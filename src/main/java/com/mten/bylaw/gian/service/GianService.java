package com.mten.bylaw.gian.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.xml.sax.SAXException;


public interface GianService {
	
	public JSONObject gianOnsStart(Map<String, Object> mtenMap);
	
	public String gianStart(Map<String, Object> mtenMap);
	
	public void gianAllUpdate() throws IOException, SAXException, ParserConfigurationException, XPathExpressionException;
	
	public Map gainInsert(Map<String, Object> mtenMap);
	
	public Map gainDelete(Map<String, Object> mtenMap);
	
	public void testGian(String fpath,String fname);
}
