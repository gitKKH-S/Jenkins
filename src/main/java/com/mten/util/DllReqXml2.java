/**  
 * @Class Name : DllReqXml.java
 * @Description : DllReqXml.class
 * @Modification Information  
 * @
 * @  수정일                        수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2013. 10. 10.        황규관               최초생성
 * 
 * @author mten 개발팀 황규관
 * @since 2013. 10. 10.
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */
package com.mten.util;
import java.sql.Clob;
import java.sql.SQLException;
import java.util.*;
import java.io.*;


import com.mten.cmn.MtenResultMap;
import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.*;
public class DllReqXml2 {
	  
	private SAXBuilder builder = new SAXBuilder();

	  private String root_node = "data";
	  private String child_node = "item";

	  // iBATIS 
	  public Document iBATISForMake(List result) throws Exception {
	    Element data = new Element(root_node);
System.out.printf("황규관 로그 2013. 10. 30.====>(%s)\n",result);
	    for (int i = 0; i < result.size(); i++ ) {
	    	MtenResultMap re = (MtenResultMap)result.get(i);
	    	Set key = re.keySet();
	    	Element element = new Element(child_node);
	    	
			for (Iterator iterator = key.iterator(); iterator.hasNext();) {
				String keyName = (String)iterator.next();
				String valueName = re.get(keyName)==null?"":re.get(keyName).toString();
				
				if (re.get(keyName) instanceof Clob) {
					try {
						valueName = clobToString(((Clob) re.get(keyName)));
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				
				addElement(element,keyName,valueName);
				if(keyName.equals("ID")){
		        	addAttribute(element,keyName,valueName);
		        }
			}
			data.addContent(element);
	    }

	    Document document = new Document(data);

	    return document;
	  }
	  
	  public String clobToString(Clob clob) throws SQLException, IOException {
			if (clob == null) {
				return "";
			}
			StringBuffer strOut = new StringBuffer();
			String str = "";
			BufferedReader br = new BufferedReader(clob.getCharacterStream());
			while ((str = br.readLine()) != null) {
				strOut.append(str);
				//strOut.append(new String((str.toString()).getBytes("iso-8859-1"), "euc-kr"));
			}
			br.close();
			return strOut.toString();
		}
	  
	  // 엘리먼트 생성
	  public Element addElement(Element parent, String name, String value) {
	    Element element = new Element(name);
	    element.addContent(new CDATA(value));
	    parent.addContent(element);
	    return parent;
	  }

	  // 애트리뷰트 생성
	  public void addAttribute(Element element, String name, String value){
	    Attribute attribute = new Attribute(name,value);
	    element.setAttribute(attribute);
	  }

}
