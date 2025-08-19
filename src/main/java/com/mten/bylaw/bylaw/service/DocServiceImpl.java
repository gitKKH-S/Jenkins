package com.mten.bylaw.bylaw.service;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.springframework.stereotype.Service;
import org.w3c.dom.CDATASection;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.mten.dao.CommonDao;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Service("docService")
public class DocServiceImpl implements DocService {
	protected final static Logger logger = Logger.getLogger( DocServiceImpl.class );
	@Resource(name="commonDao")
	private CommonDao commonDao;
	public JSONObject getMenuDocList(Map<String, Object> mtenMap) {
		List blist = commonDao.selectList("commonSql.getMenuDocList", mtenMap);
		JSONArray jl = JSONArray.fromObject(blist);
		JSONObject jo = new JSONObject();
		jo.put("total", blist.size());
		jo.put("result", jl);
		return jo;
	}
	
	public void insertDoctype(Map<String, Object> mtenMap) {
		commonDao.insert("insertDoctype",mtenMap);
	}
	
	public JSONObject deleteDoctype(Map<String, Object> mtenMap) {
		commonDao.delete("deleteDoctype",mtenMap);
		JSONObject result = new JSONObject();
		result.put("success", "true");
		return result;
	}
}


