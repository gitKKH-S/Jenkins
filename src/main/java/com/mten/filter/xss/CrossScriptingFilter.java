package com.mten.filter.xss;

import org.springframework.util.AntPathMatcher;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;


public class CrossScriptingFilter implements Filter {
 
    private FilterConfig filterConfig;
	private List<String> excludeUrlList;				
     
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
		excludeUrlList = new ArrayList<String>();

		Enumeration enu = filterConfig.getInitParameterNames();
		while (enu.hasMoreElements()) {
			String key = (String)enu.nextElement();
			String value = filterConfig.getInitParameter(key);
			System.out.println("key"+key);
			System.out.println("value"+value);
			if (key.startsWith("exclude.url.")) {
				excludeUrlList.add(value);
			}
		}
    }
 
    public void doFilter2(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
    	  HttpServletRequest req = (HttpServletRequest) request ;
    	if(excludeUrl(req)){
    		chain.doFilter(request, response); 
    	}else{
    		chain.doFilter(new RequestWrapper((HttpServletRequest) request), response);
    	}
    	
    }

	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {

		if (req instanceof HttpServletRequest) {
			HttpServletRequest request = (HttpServletRequest)req;

			
			if (!isXssExcludeUrl(request)) {
				chain.doFilter(new RequestWrapper(request), res);
			} else {
				chain.doFilter(req, res);
			}
		} else {
			chain.doFilter(req, res);
		}
	}

	private boolean isXssExcludeUrl(HttpServletRequest request) {
		
		if (excludeUrlList != null) {
			AntPathMatcher antPathMatcher = new AntPathMatcher();
			for (String excludeUrl : excludeUrlList) {
				//if (antPathMatcher.match(excludeUrl, request.getRequestURI())) {
				if (request.getRequestURI().indexOf(excludeUrl)>-1) {
					return true;
				}
			}
		}
		return false;
	}

	public void destroy() {
        this.filterConfig = null;
    }
    
    private boolean excludeUrl(HttpServletRequest request) {
    	   String uri = request.getRequestURI().toString().trim();
    	   if(uri.contains("/filemn/")||uri.contains("/existing/")||uri.contains("/dll/")||uri.contains("/suit/")||uri.contains("/progress/")){
    	    return true;
    	   }else{
    	    return false;
    	   }
    }
}



