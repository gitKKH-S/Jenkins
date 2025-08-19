package com.mten.filter.xss;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;


public class RequestWrapper extends HttpServletRequestWrapper {
 
    public RequestWrapper(HttpServletRequest request) {
        super(request);
    }
 
    @Override
    public String[] getParameterValues(String parameter) {
 
        String[] values = super.getParameterValues(parameter);
        if (values == null) {
            return null;
        }
        int count = values.length;
        String[] encodedValues = new String[count];
        for (int i = 0; i < count; i++) {
            encodedValues[i] = cleanXSS(values[i]);
        }
        return encodedValues;
    }
 
    @Override
    public String getParameter(String parameter) {
        String value = super.getParameter(parameter);
        if (value == null) {
            return "";
        }
        if(parameter.equals("mainpith")) {
        	return value;
        }else {
        	return cleanXSS(value);
        }
    }
 
    @Override
    public String getHeader(String name) {
        String value = super.getHeader(name);
        if (value == null)
            return null;
        if(name.equals("mainpith")) {
        	return value;
        }else {
        	return cleanXSS(value);
        }
    }

 
    private String cleanXSS(String value) {
    	value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        //value = value.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
        value = value.replaceAll("\\[", "&#91;").replaceAll("\\]", "&#93;");
        value = value.replaceAll("'", "&#39;");
        value = value.replaceAll("eval\\((.*)\\)", "");
        value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
        value = value.replaceAll("script", "");
        value = value.replaceAll(":", "&#58;");
        //value = value.replaceAll("@", "&#64;");
        value = value.replaceAll("\\/", "&#47;");
        value = value.replaceAll("\\*", "&#42;");
        value = value.replaceAll("\"", "&quot;");
        value = value.replaceAll("\\=", "&#61");
        return value;
    }
}