/**  

 * @see
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */
package com.mten.cmn;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;

public class LogonAspectBean {
	public void beforeRead(JoinPoint joinPoint){
		System.out.println("공통관심사항 실행됨");
		HttpServletRequest request = null;
        HttpServletResponse response = null;
        for ( Object o : joinPoint.getArgs() ){ 
            if ( o instanceof HttpServletRequest ) {
                request = (HttpServletRequest)o;
            } 
            if ( o instanceof HttpServletResponse ) {
                response = (HttpServletResponse)o;
            } 
        }
        System.out.printf("황규관 로그 2014. 2. 27.====>(%s)\n",request);
        System.out.printf("황규관 로그 2014. 2. 27.====>(%s)\n",response);
        try{
            HttpSession session = request.getSession();
            
            HashMap para = (HashMap)session.getAttribute("userInfo"); 
 //           HashMap reMap = (HashMap)session.getAttribute("logon");
                System.out.println("### Margo ==> loginId : " + para);
                if (para == null ) {
                    throw new RuntimeException("먼저 로그인을 하셔야 합니다.");
                }           
        }catch(Exception e){
             System.out.println(e);
            throw new RuntimeException("먼저 로그인을 하셔야 합니다.");
 
        }       
	}
	
	
}
