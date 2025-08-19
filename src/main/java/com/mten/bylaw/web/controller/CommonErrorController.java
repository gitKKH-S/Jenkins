package com.mten.bylaw.web.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mten.bylaw.admin.service.UserService;
import com.mten.bylaw.admin.service.UserServiceImpl;
import com.mten.bylaw.defaults.DefaultController;
import com.mten.util.ConExcel;
import com.mten.util.ExcelReaderUtil;
import com.mten.util.Json4Ajax;
import com.mten.util.ZipUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Controller
public class CommonErrorController {
	
	protected final static Logger logger = Logger.getLogger( CommonErrorController.class );
	
	@RequestMapping(value="/common/error{error_code}.do")
    public String error(HttpServletRequest request, @PathVariable String error_code) {
        String msg = (String) request.getAttribute("javax.servlet.error.message"); 
         
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("STATUS_CODE", request.getAttribute("javax.servlet.error.status_code"));
        map.put("REQUEST_URI", request.getAttribute("javax.servlet.error.request_uri"));
        map.put("EXCEPTION_TYPE", request.getAttribute("javax.servlet.error.exception_type"));
        map.put("EXCEPTION", request.getAttribute("javax.servlet.error.exception"));
        map.put("SERVLET_NAME", request.getAttribute("javax.servlet.error.servlet_name"));
         
        try {
            int status_code = Integer.parseInt(error_code);
            switch (status_code) {
            case 400: msg = "잘못된 요청입니다."; break;
            case 403: msg = "접근이 금지되었습니다."; break;
            case 404: msg = "페이지를 찾을 수 없습니다."; break;
            case 405: msg = "요청된 메소드가 허용되지 않습니다."; break;
            case 500: msg = "서버에 오류가 발생하였습니다."; break;
            case 503: msg = "서비스를 사용할 수 없습니다."; break;
            default: msg = "알 수 없는 오류가 발생하였습니다."; break;
            }
        } catch(Exception e) {
            msg = "기타 오류가 발생하였습니다.";
        } finally {
            map.put("MESSAGE", msg);
        }
         
        //logging
        if(map.isEmpty() == false ) {
            Iterator<Entry<String, Object>> iterator = map.entrySet().iterator();
            Entry<String, Object> entry = null;
            while(iterator.hasNext()) {
                entry = iterator.next();
                logger.info("key : "+entry.getKey()+", value : "+entry.getValue());
            }
        }
         
        return "/common/error.err";
    }

	@RequestMapping(value="/common/errorException.do")
    public String errorException(HttpServletRequest request) {
        
        return "/common/error.err";
    }
	
	@RequestMapping(value="/common/loginException.do")
    public String loginException(HttpServletRequest request) {
        System.out.println("로그인 에러");
        return "/common/loginException.err";
    }
	
	@RequestMapping(value="/common/loginJsonException.do")
    public String loginJsonException(HttpServletRequest request) {
        System.out.println("로그인 에러");
        return "/common/loginJsonException.err";
    }
	
	@RequestMapping(value="/common/noPrivacy.do")
	public String noRole(HttpServletRequest request) {
		System.out.println("개인정보 검출");
		return "/common/noPrivacy.err";
	}
}
