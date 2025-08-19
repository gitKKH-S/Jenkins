package com.mten.util;

import java.io.IOException;
import java.io.StringReader;
import java.util.HashMap;
import java.util.*;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;


public class BindObject {
	private static BindObject instance = new BindObject();

	public static BindObject getInstance() {
		return instance;
	}
	  
	public HashMap getXmlParsing(String xmlData) throws JDOMException, IOException{
		HashMap para = new HashMap();
		
		SAXBuilder builder = new SAXBuilder();
		Document document = builder.build(new StringReader(xmlData));

		Element root = document.getRootElement();
		List child2 = root.getChildren();
		for (Iterator iter = child2.iterator();iter.hasNext();) {
			Element node = (Element) iter.next();
			
			String name = (String) node.getName();
			String value = (String) node.getText();
			para.put(name.toLowerCase(), value);
		}
		System.out.println(para);
		return para;
	}
}
