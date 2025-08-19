package com.mten.handler;

import com.mten.bylaw.defaults.DefaultConsts;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Client에 전달할 Response 데이터 관련 처리를 위한 클래스
 * @ClassName ResponseData.java
 * @Description  Client에 전달할 Response 데이터 관련 처리를 위한 클래스
 * @Modification-Information
 *    수정일   수정자       수정내용
 *  ----------   ----------   -------------------------------
 * 
 * 
 * @author
 * @since 
 * @version 1.0
 * @see 
 * 
 *  Copyright (C) 2017 by Unlimited K-water, All right reserved.
 */
public class ResponseData {

    public final static String STATUS_SUCESS = "success";
    public final static String STATUS_ERROR = "error";
    
    private static String contextPath = null;
    
    public static ModelAndView createModelAndView() {
		return new ModelAndView(DefaultConsts.JSON_VIEW_NAME);
	}
    
    /**
     * Context Path를 설정한다.
     * @param path context path 명
    */
    public static void setContextPath(String path) {
        if (contextPath == null) {
            contextPath = path;
        }
    }
    
    /**
     * Context Path를 조회한다.
     * @return
    */
    public static String getContexntPath() {
        return contextPath;
    }
    
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @return ModelAndView 객체
     */    
    public static ModelAndView getResponseData(String code) {
        if (code.equals(DefaultConsts.STATUS_SUCESS)) {
            return getResponseData(code, DefaultConsts.STATUS_SUCESS_MESSAGE);
        } else if (code.equals(DefaultConsts.STATUS_ERROR)) {
            return getResponseData(code, DefaultConsts.STATUS_ERROR_MESSAGE);
        } else {
            return getResponseData(code, DefaultConsts.STATUS_OTHER_MESSAGE);
        }
    }
    
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param status 처리결과 상태코드 ("success", "error")
     * @return ModelAndView 객체
     */    
    public static ModelAndView getResponseData(Map<String, Object> data) {
        return getResponseData(DefaultConsts.STATUS_SUCESS, data);
    }
    
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param data 처리결과 데이터
     * @return ModelAndView
    */
    public static ModelAndView getResponseData(@SuppressWarnings("rawtypes") List<Map> data) {
        return getResponseData(DefaultConsts.STATUS_SUCESS, data);
    }

    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @param code_name 처리결과 메시지
     * @return ModelAndView
     */
    public static ModelAndView getResponseData(String code, String codeName) {
        ModelAndView mav = createModelAndView();
        Map<String, Object> message = new HashMap<String, Object>();
        message.put(DefaultConsts.MESSAGE_CODE_NODE_NAME, code);
        message.put(DefaultConsts.MESSAGE_CODE_NAME_NODE_NAME, codeName);
       
        mav.addObject(DefaultConsts.MESSAGE_NODE_NAME, message);

        return mav;
    }
    
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @param data 처리결과 데이터
     * @return ModelAndView
     */
    public static ModelAndView getResponseData(String code, Map<String, Object> data) {
        ModelAndView mav = getResponseData(code);
        if (data != null) {
            mav.addObject(DefaultConsts.DATA_NODE_NAME, data);
        }
        
        return mav;
    }
    
    /**
     * 메소드에 대한 설명
     * @param code 처리결과 상태코드 ("success", "error")
     * @param data 처리결과 데이터
     * @return
    */
    public static ModelAndView getResponseData(String code, @SuppressWarnings("rawtypes") List<Map> data) {
        ModelAndView mav = getResponseData(code);
        
        if (data != null) {
            mav.addObject(DefaultConsts.DATA_NODE_NAME, data);
        }
        
        return mav;
    }
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @param codeName 처리결과 메시지
     * @param data 처리결과 데이터
     * @return ModelAndView
     */
    public static ModelAndView getResponseData(String code, String codeName, Map<String, Object> data) {
        ModelAndView mav = createModelAndView();
        
        Map<String, Object> message = new HashMap<String, Object>();
        message.put(DefaultConsts.MESSAGE_CODE_NODE_NAME, code);
        message.put(DefaultConsts.MESSAGE_CODE_NAME_NODE_NAME, codeName);
        
        mav.addObject(DefaultConsts.MESSAGE_NODE_NAME, message);
        
        if (data != null) {
            mav.addObject(DefaultConsts.DATA_NODE_NAME, data);
        }
        
        return mav;
    }
    
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @param codeName 처리결과 메시지
     * @param data 처리결과 데이터
     * @return ModelAndView
    */
    public static ModelAndView getResponseData(String code, String codeName, @SuppressWarnings("rawtypes") List<Map> data) {
        ModelAndView mav = createModelAndView();
        
        Map<String, Object> message = new HashMap<String, Object>();
        message.put(DefaultConsts.MESSAGE_CODE_NODE_NAME, code);
        message.put(DefaultConsts.MESSAGE_CODE_NAME_NODE_NAME, codeName);
        
        mav.addObject(DefaultConsts.MESSAGE_NODE_NAME, message);
        
        if (data != null) {
            mav.addObject(DefaultConsts.DATA_NODE_NAME, data);
        }
        
        return mav;
    }
    
    /**
     *  Client에 전달할 Response 데이터의 메세지 데이터를 생성한다.
     * @param mav 전달할 ModelAndView
     * @param strErrCode 에러코드
     * @param strErrMsg 에러 메세지
     * @return
    */
    public static  ModelAndView getMessageData(ModelAndView mav, String strErrCode, String strErrMsg) {
    	
        Map<String, Object> message = new HashMap<String, Object>();
        message.put(DefaultConsts.MESSAGE_CODE_NODE_NAME, strErrCode);
        message.put(DefaultConsts.MESSAGE_CODE_NAME_NODE_NAME, strErrMsg);
        
        return mav.addObject(DefaultConsts.MESSAGE_NODE_NAME, message);
	}
}
