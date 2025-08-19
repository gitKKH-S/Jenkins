package com.mten.interceptor;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class AuthenticInterceptor extends HandlerInterceptorAdapter {
	
	private static final Logger LOGGER =  Logger.getLogger(AuthenticInterceptor.class);
	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {	
		System.out.println("로그인 체크가 가능한가???");
		HttpSession session = request.getSession();
		System.out.println("로그인 체크가 가능한가???"+session.getAttribute("userInfo"));
		HashMap para = (HashMap)session.getAttribute("userInfo"); 
		System.out.println("로그인 체크가 가능한가para???"+para);
		if(para ==null){
			String type = request.getHeader("X-Requested-With")==null?"":request.getHeader("X-Requested-With");
			if (type.equals("XMLHttpRequest")){
				System.out.println("ajax 호출인가??");
				response.sendRedirect(request.getContextPath() +"/common/loginJsonException.do");
			}else{
				System.out.println("로그인에러!!!");
				response.sendRedirect(request.getContextPath() +"/common/loginException.do");
			}
			return false;
		}else{
			return super.preHandle(request, response, handler);
		}
		
		
		

		/*if(null == loginVO){
			LOGGER.debug("Session Is Null.");
			
			if(loginProppertyService.getBoolean(DefaultConsts.AUTOLOGIN_USE, true)){


				 ThreadLocal setting end 
				
				return super.preHandle(request, response, handler);
			}
			else{
				response.sendRedirect(request.getContextPath() +"/resources/jsp/checkLogin.jsp");
				return false;
			}
			
		}else{
			LOGGER.debug("Session Is Not Null.");

			

			 ThreadLocal setting end 
			return super.preHandle(request, response, handler);
		}*/
	}
}
