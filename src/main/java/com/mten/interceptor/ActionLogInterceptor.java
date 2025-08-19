package com.mten.interceptor;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.bylaw.service.LogService;
import com.mten.bylaw.bylaw.service.ProcService;
import com.mten.bylaw.pds.service.PdsService;
import com.mten.bylaw.web.service.WebService;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.ResourceBundle;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class ActionLogInterceptor extends HandlerInterceptorAdapter {
	
	@Resource(name="logService")
	private LogService logService;
	
	@Override
	public boolean preHandle(HttpServletRequest request,HttpServletResponse response, Object handler) throws Exception {	
		System.out.println("요청 처리전!!");
		return true;
	}
	
	public String formatWith24HourSupport(LocalDateTime time) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");

        if (time.getHour() == 0 && time.getMinute() == 0 && time.getSecond() == 0 && time.getNano() < 1_000_000) {
            String date = time.minusDays(1).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            return date + " 24:00:00.000";
        }

        return time.format(formatter);
    }
	
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		ResourceBundle bundle = ResourceBundle.getBundle("egovframework.property.logmsg"); 
		 
		System.out.println("요청 처리후!!"+request.getRequestURL());
		System.out.println("요청 URL 전체 : " + request.getRequestURL());
	    System.out.println("요청 URI       : " + request.getRequestURI());
	    System.out.println("컨텍스트 경로  : " + request.getContextPath());
	    System.out.println("서블릿 경로    : " + request.getServletPath());
	    System.out.println("쿼리 스트링    : " + request.getQueryString());
	    System.out.println("HTTP 메서드    : " + request.getMethod());
	    
	    LocalDateTime now = LocalDateTime.now();
        String output = formatWith24HourSupport(now);
        
	    String path = request.getServletPath().replace("/web", "");
	    String[] parts = path.split("/");
	    System.out.println("parts[1]===>"+parts[1]);
	    
	    HashMap para = request.getAttribute("logMap")==null?new HashMap():(HashMap)request.getAttribute("logMap");
	    HashMap logMap = new HashMap();
	    logMap.put("LOG_CRT_DT", output);
	    logMap.put("LOG_SE", parts[1]);
	    logMap.put("ACSR_NM", para.get("WRTR_EMP_NM"));
	    logMap.put("ACSR_NO", para.get("WRTR_EMP_NO"));
	    logMap.put("ACSR_DEPT_NO", para.get("WRT_DEPT_NO"));
	    logMap.put("ACSR_DEPT_NM", para.get("WRT_DEPT_NM"));
	    logMap.put("ACSR_IP_ADDR", para.get("ACSR_IP_ADDR"));
	    logMap.put("LOG_CRT_URL_ADDR", path);
	    logMap.put("TRSM_ARTCL_CN", para.toString());
	    
        if (parts[1].equals("consult")) {
            String page = parts[2]; // "main"
            if (parts[2].indexOf("write")>-1) {
            	logMap.put("RMRK_CN", "자문 작성페이지호출");
            }
            if (parts[2].indexOf("save")>-1) {
            	logMap.put("RMRK_CN", "");
            }
            
            System.out.println("Interceptor에서 추출한 page: " + page);
        }else if (parts[1].equals("suit")) {
            String page = parts[2]; // "main"
            System.out.println("Interceptor에서 추출한 page: " + page);
        }else if (parts[1].equals("agree")) {
            String page = parts[2]; // "main"
            System.out.println("Interceptor에서 추출한 page: " + page);
        }else if (parts[1].equals("pds")) {
            String page = parts[2]; // "main"
            System.out.println("Interceptor에서 추출한 page: " + page);
        }else if (parts[1].equals("approve")) {
            String page = parts[2]; // "main"
            System.out.println("Interceptor에서 추출한 page: " + page);
        }else if (parts[1].equals("login")) {
            String page = parts[2]; // "main"
            System.out.println("Interceptor에서 추출한 page: " + page);
        }else if (parts[1].equals("bylaw")) {
            String page = parts[3]; // "main"
            System.out.println("Interceptor에서 추출한 page: " + page);
        }else if (parts[1].equals("out")) {
        	String page = parts[2]; // "main"
            System.out.println("Interceptor에서 추출한 page: " + page);
        }
        
        try {
        	logMap.put("RMRK_CN", bundle.getString(path));
            System.out.println(logMap);
            logService.setLog(logMap);
        }catch(Exception e) {
        	System.out.println("로그 key 없음!!");
        }
        
    }
}
