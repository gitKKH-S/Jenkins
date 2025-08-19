package com.mten.interceptor;


import com.mten.handler.ResponseData;
import com.mten.util.EgovClntInfo;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.util.StopWatch;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ControllerInterceptor implements HandlerInterceptor {
    
    protected  static Logger logger = LoggerFactory.getLogger(ControllerInterceptor.class);
    
    @Resource(name="UUIdGenerationServiceWithoutAddress")
    private EgovIdGnrService uUIdGenerationServiceWithIP;
    
    /**
     * 클라이언트의 요청을 컨트롤러에 전달하기 전에 호출되며, false를 리턴하면 다음 내용은 실행하지 않는다.
     */
    public boolean preHandle(HttpServletRequest request,
            HttpServletResponse response, Object handler) throws Exception {
        ResponseData.setContextPath(request.getSession().getServletContext().getRealPath("/"));
        //logger.info("preHandle");
        
        MDC.put("txid", String.valueOf(uUIdGenerationServiceWithIP.getNextBigDecimalId().intValue()));
//      MDC.put("txid", getTxid(request));
		MDC.put("ipaddr",  EgovClntInfo.getClntIP(request));
		MDC.put("acpturl", request.getRequestURI());

      
		StopWatch stopWatch = new StopWatch();
		stopWatch.start();
		request.setAttribute("stopwatch", stopWatch);

      if(logger.isInfoEnabled()) {
    	  logger.info("#############################################################");
      	  logger.info("Request URI :  "+ request.getRequestURI() + "  from Client Ip : "+ MDC.get("ipaddr")+"  start. ########");
      	  logger.info("#############################################################");
      }
      
		////////////////////////////////////////
		// Request 정보 출력
		///////////////////////////////////////
		
        return true;
    }

    /**
     * 클라이언트의 요청을 처리한 뒤에 호출되며, 컨트롤러에서 예외가 발생되면 실행하지 않는다.
     */
    public void postHandle(HttpServletRequest request,
            HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
        logger.info("postHandle");
    	
    	try {
       	StopWatch stopWatch = (StopWatch)request.getAttribute("stopwatch");
            stopWatch.stop();
            
       
           if(logger.isInfoEnabled()) {
        	   logger.info("#############################################################");
        	   logger.info(" Request URI :  "+request.getRequestURI() + "  from Client Ip : "+ MDC.get("ipaddr")+"  end. ***   elapsed time : ({} msecs", stopWatch.getTotalTimeMillis());
        	   logger.info("#############################################################");
           }
        
       } finally {
           MDC.remove("txid");
       }
          
           
    }

    /**
     * 클라이언트 요청 처리뒤 클리이언트에 뷰를 통해 응답을 전송한뒤 실행 됨. 뷰를 생설항때 예외가 발생해도 실행된다
     */
    public void afterCompletion(HttpServletRequest request,
            HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        logger.info("afterCompletion");
    }

}