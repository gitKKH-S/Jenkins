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
import org.apache.commons.collections.map.ListOrderedMap;

/**
 * @Class Name : MtenResultMap.java
 * @Description : MtenResultMap.class
 * @Modification Information  
 * @
 * @  수정일                        수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2013. 12. 30.        황규관               최초생성
 * 
 * @author mten 개발팀 황규관
 * @since 2013. 12. 30.
 * @version 1.0
 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */
public class MtenResultMap extends ListOrderedMap {
	/*** Eclipse Class Decompiler plugin, copyright (c) 2012 Chao Chen (cnfree2000@hotmail.com) ***/
		private static final long serialVersionUID = 6723434363565852261L;
		public Object put(Object key, Object value) {
			//전자정부 프레임워크는 DB 상의 컬럼을 CamelCase 방식으로 변환하기때문에 해당 키값을 알맞게 camel형으로 바꾸어 줌
			//return super.put(CamelUtil.convert2CamelCase((String) key).toUpperCase(), value);
			value = value==null?"":value;
			return super.put(((String) key).toUpperCase(), value);
		}
}
