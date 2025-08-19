package com.mten.bylaw.defaults;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.web.servlet.ModelAndView;

import com.mten.handler.ResponseData;

import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * Controller 객체의 부모 클래스인 DefaultController
 * @ClassName DefaultController.java
 * @Description  Controller 객체의 부모 클래스인 DefaultController
 * @Modification-Information
 *    수정일   수정자       수정내용
 *  ----------   ----------   -------------------------------
 *  2017. 3. 1.     Soft Arch 최초생성
 * 
 * @author K-water 업무시스템 혁신사업 : Soft Arch 아무개 
 * @since  2017. 3. 1.
 * @version 1.0
 * @see 
 * 
 *  Copyright (C) 2017 by Unlimited K-water, All right reserved.
 */
public class DefaultController {

	
	/**
	 * WEBSQUARE에 전달할 ModelAndView를 생성한다.
	 * @return ModelAndView 전달할 ModelAndView
	*/
    public ModelAndView createModelAndView() {
		return ResponseData.createModelAndView();
	}

	/**
	 * WEBSQUARE에 전달할 DataSet을 추가한다.
	 * @param mav 전달할 ModelAndView
	 * @param strDataSetName 전달할 DataSet 명
	 * @param objData DataSet
	*/
	@SuppressWarnings("rawtypes")
	protected void addOutDataSet(ModelAndView mav, String strDataSetName, Object objData) {
		//objData가 Map일 경우 각 항목별로 풀어서 전달하도록 처리
		if (objData instanceof Map){
			Iterator iter = ((Map) objData).entrySet().iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry)iter.next();
				String key = (String)entry.getKey();
				Object value = entry.getValue();
				mav.addObject(key, value);
			}
		}else {
			mav.addObject(strDataSetName, objData);
		}
	}

	/**
	 * WEBSQUARE에 전달할 Variable 을 추가한다.
	 * @param mav 전달할 ModelAndView
	 * @param strVariableName 전달할 변수명
	 * @param objVal 전달할 DataSet 
	*/
	protected void addOutVariable(ModelAndView mav, String strVariableName, Object objVal) {
		mav.addObject(strVariableName, objVal);
	}

	/**
	 * 메소드에 대한 설명
	 * @param mav 전달할 ModelAndView
	 * @param intErrCode
	 * @param strErrMsg
	 * @return ModelAndView
	*/
	protected ModelAndView setResultSet(ModelAndView mav, int intErrCode, String strErrMsg) {
		mav.addObject(DefaultConsts.WEBSQUARE_ERROR_CODE_NAME, String.valueOf(intErrCode));
		mav.addObject(DefaultConsts.WEBSQUARE_ERROR_MSG_NAME,  strErrMsg);

		return mav;
	}
	
	/**
	 * Client에 전달할 Response 데이터의 메세지 데이터를 생성한다.
     * @param mav 전달할 ModelAndView
     * @param intErrCode 에러코드
     * @param strErrMsg 에러 메세지
	 * @return ModelAndView
	*/
	public ModelAndView getMessageData(ModelAndView mav, String strErrCode, String strErrMsg) {
		return ResponseData.getMessageData(mav, strErrCode, strErrMsg);
	}

	/**
	 * 메소드에 대한 설명
	 * @param mav
	 * @param intErrCode
	 * @param e
	 * @return
	*/
	public ModelAndView setResultSet(ModelAndView mav, int intErrCode, Exception e) {
		mav.addObject(DefaultConsts.WEBSQUARE_ERROR_CODE_NAME, String.valueOf(intErrCode));
		mav.addObject(DefaultConsts.WEBSQUARE_ERROR_MSG_NAME,  e.getMessage());

		return mav;
	}
	
	/**
	 * Client에 전달할 Response 데이터의 메세지 데이터를 생성한다.
     * @param mav 전달할 ModelAndView
     * @param intErrCode 에러코드
     * @param e exception e
	 * @return ModelAndView
	*/
	protected ModelAndView getMessageData(ModelAndView mav, int intErrCode, Exception e) {
		return ResponseData.getMessageData(mav, String.valueOf(intErrCode), e.getMessage());
	}
	
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @param codeName 처리결과 메시지
     * @param data 처리결과 데이터
     * @return ModelAndView
    */
	protected ModelAndView addResponseData(String code, String codeName, Map<String, Object> data) {
        return ResponseData.getResponseData(code, codeName, data);
	}
	
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @param codeName 처리결과 메시지
     * @param data 처리결과 데이터
     * @return ModelAndView
    */
	protected ModelAndView addResponseData(String code, String codeName, @SuppressWarnings("rawtypes") List<Map> data) {
        return ResponseData.getResponseData(code, codeName, data);
	}
	
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @return ModelAndView
    */
	protected ModelAndView addResponseData(String code) {
        return ResponseData.getResponseData(code);
    }
	
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param data 처리결과 데이터
     * @return ModelAndView
    */
	public ModelAndView addResponseData(Map<String, Object> data) {
        return addResponseData(DefaultConsts.STATUS_SUCESS, data);
    }
	
    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param data 처리결과 데이터
     * @return ModelAndView
    */
	public ModelAndView addResponseData(@SuppressWarnings("rawtypes") List<Map> data) {
        return addResponseData(DefaultConsts.STATUS_SUCESS, data);
    }

    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @param codeName 처리결과 메시지
     * @return ModelAndView
    */
	public ModelAndView addResponseData(String code, String codeName) {
        return ResponseData.getResponseData(code, codeName);
    }

    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @param data 처리결과 데이터
     * @return ModelAndView
    */
	public ModelAndView addResponseData(String code, Map<String, Object> data) {
        return ResponseData.getResponseData(code, data);
    }

    /**
     * Client에 전달할 Response 데이터를 생성한다.
     * @param code 처리결과 상태코드 ("success", "error")
     * @param data 처리결과 데이터
     * @return ModelAndView
    */
	public ModelAndView addResponseData(String code, @SuppressWarnings("rawtypes") List<Map> data) {
        return  ResponseData.getResponseData(code, data);
    }
}
