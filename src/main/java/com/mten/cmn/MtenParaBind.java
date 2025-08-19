/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.mten.cmn;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebArgumentResolver;
import org.springframework.web.context.request.NativeWebRequest;

import com.mten.util.MakeHan;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * @Class Name : MtenParaBind.java
 * @Description : MtenParaBind.class
 * @Modification Information
 * @
 * @  수정일                        수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2013. 9. 6.        황규관               최초생성
 *
 * @author mten 개발팀 황규관
 * @since 2013. 9. 6.
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */
/*** Eclipse Class Decompiler plugin, copyright (c) 2012 Chao Chen (cnfree2000@hotmail.com) ***/

public class MtenParaBind implements WebArgumentResolver {
	public Object resolveArgument(MethodParameter methodParameter,	NativeWebRequest webRequest) throws Exception {
		Class clazz = methodParameter.getParameterType();
		System.out.println(clazz);
		String paramName = methodParameter.getParameterName();
		System.out.println("paramName===>"+paramName);
		if ((clazz.equals(Map.class)) && (paramName.equals("mtenMap"))) {
			Map commandMap = new HashMap();
			HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();
			Enumeration enumeration = request.getParameterNames();
			
			while (enumeration.hasMoreElements()) {
				String key = (String) enumeration.nextElement();
				String[] values = request.getParameterValues(key);
				if (values != null) {
					if(values.length == 1){
						commandMap.put(key, (values.length > 1) ? values : values[0]);
					}else{
						ArrayList list = new ArrayList();
						for(int k=0; k<values.length; k++){
							list.add(values[k]);
						}
						commandMap.put(key, list);
					}
				}
			}
			try {
				//System.out.println("AAAAAAAAAAAAA"+webRequest.getAttribute("userInfo", webRequest.SCOPE_SESSION));
				HttpSession session = request.getSession(true);
				HashMap se = (HashMap)session.getAttribute("userInfo"); 
				String writerid = se.get("USERID")==null?"":se.get("USERID").toString();
				if (writerid.equals("")) {
					writerid = se.get("USERNO")==null?"":se.get("USERNO").toString();
				}
				String writer = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
				String deptid = se.get("DEPTCD")==null?"":se.get("DEPTCD").toString();
				String deptname = se.get("DEPTNAME")==null?"":se.get("DEPTNAME").toString();
				String grpcd = se.get("GRPCD")==null?"":se.get("GRPCD").toString();
				String jikcd = se.get("JIKCD")==null?"":se.get("JIKCD").toString();
				String cip = se.get("cip")==null?"":se.get("cip").toString();
				commandMap.put("writer", writer);
				
				commandMap.put("WRTR_EMP_NM", writer);
				commandMap.put("WRTR_EMP_NO", writerid);
				commandMap.put("WRT_YMD", MakeHan.get_data());
				commandMap.put("WRT_DEPT_NM", deptname);
				commandMap.put("WRT_DEPT_NO", deptid);
				
				commandMap.put("MDFCN_EMP_NM", writer);
				commandMap.put("MDFCN_EMP_NO", writerid);
				commandMap.put("MDFCN_YMD", MakeHan.get_data());
				commandMap.put("MDFCN_DEPT_NM", deptname);
				commandMap.put("MDFCN_DEPT_NO", deptid);
				commandMap.put("ACSR_IP_ADDR", cip);
				
				String start = commandMap.get("start")==null?"":commandMap.get("start").toString();
				String limit = commandMap.get("limit")==null?"":commandMap.get("limit").toString();
				
				if(!start.equals("") & !limit.equals("")){
					int a = Integer.parseInt(start);
					int b = Integer.parseInt(limit);
					int result = 1;
					if(b != 0){
						result = a/b+1;
					}
					commandMap.put("pageno", result);
				}
				if(commandMap.get("pagesize")==null) {
					commandMap.put("pagesize", 20);
					commandMap.put("pageno", "1");
				}else {
					commandMap.put("pagesize", Integer.parseInt(commandMap.get("pagesize").toString()));
				}
			}catch(Exception e) {
				System.out.println("session 파라미터 셋팅 불가..");
			}
			return commandMap;
		}
		return UNRESOLVED;
	}
}