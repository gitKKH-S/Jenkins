package com.mten.bylaw.agree.service;

import java.io.IOException;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import net.sf.json.JSONObject;


public interface AgreeService {
	public JSONObject fileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest);
	public List getFileList(Map mtenMap);
	
	
	public JSONObject selectAgreeList(Map<String, Object> mtenMap);
	public HashMap getAgreeDetail(Map<String, Object> mtenMap);
	public HashMap getAgreeMakeDoc(Map<String, Object> mtenMap);
	public JSONObject agreeSave(Map<String, Object> mtenMap);
	public JSONObject updateAgreeState(Map<String, Object> mtenMap);
	public JSONObject updateAgreeState2(Map<String, Object> mtenMap);
	public JSONObject updateAgreeOpenyn(Map<String, Object> mtenMap);
	public JSONObject updateAgreeInout(Map<String, Object> mtenMap);
	public JSONObject agreeDelete(Map<String, Object> mtenMap);
	public List selectAgreeEmp(Map<String, Object> mtenMap);
	public JSONObject setChrgEmpState(Map<String, Object> mtenMap);
	
	public List selectAgreeLawyerList(Map<String, Object> mtenMap);
	public List selectLawyerList2(Map<String, Object> mtenMap);
	public int selectLawyerTotal(Map<String, Object> mtenMap);
	public JSONObject agreeLawInfoSave(Map<String, Object> mtenMap);
	public JSONObject deleteAgreeLawyer2(Map<String, Object> mtenMap);
	
	public HashMap selectAgreeAnswerView(Map<String, Object> mtenMap);
	public List selectAnswerBoard(Map<String, Object> mtenMap);
	public JSONObject answerSave(Map<String, Object> mtenMap);
	public JSONObject deleteAnswer(Map<String, Object> mtenMap);
	public JSONObject answerResultSave(Map<String, Object> mtenMap);
	
	public JSONObject selectMemoList(Map<String, Object> mtenMap);
	public HashMap selectAgreeMemoView(Map<String, Object> mtenMap);
	public JSONObject saveMemoInfo(Map<String, Object> mtenMap);
	public JSONObject deleteMemo(Map<String, Object> mtenMap);
	
	public List getProcSatisList(Map<String, Object> mtenMap);
	public List getSatisfactionList(Map<String, Object> mtenMap);
	public List getSatisitemList2(Map<String, Object> mtenMap);
	public List getLawyerList2(Map<String, Object> mtenMap);
	
	public String getCvtnCtrtTypeNm(Map<String, Object> mtenMap);
	public JSONObject agreeResultSave(Map<String, Object> mtenMap);
	public HashMap selectAgreeResult(Map<String, Object> mtenMap);
	
	public HashMap getOutAgreeCnt(Map<String, Object> mtenMap);
	public JSONObject selectOutAgreeList(Map<String, Object> mtenMap);
	public JSONObject setAgreeCost(Map<String, Object> mtenMap);
	public JSONObject setCostInfo(Map<String, Object> mtenMap);
	
	// 협약 목록 통계 그림 위한 전체 건수 조회
	public int selectStateTotalCnt(Map<String, Object> mtenMap);
	// 협약 목록 통계 그림 위한 진행상태별 건수 조회
	public List selectStateCnt(Map<String, Object> mtenMap);
	
	public String saveFileDll(MultipartHttpServletRequest multipartRequest, Map<String, Object> mtenMap);
	
	// 협약 답변 검토 의견 정보 조회
	public HashMap selectAgreeReviewComment(Map<String, Object> mtenMap);
	// 협약 답변 검토 의견 내용 저장 수정
	public JSONObject saveReviewComment(Map<String, Object> mtenMap);
	// 협약 답변 검토 의견 정보 삭제
	public JSONObject deleteReviewComment(Map<String, Object> mtenMap);
	
	
	public JSONObject rfslRsnSave(Map<String, Object> mtenMap);
	
	// 협약 관련 사용자 메인화면 접근시 건수
//	public String getCnt1();	// 접수대기 건수
	public HashMap getCnt1();	// 접수대기 건수
	public HashMap getCnt2(String userId);	// 진행중 건수
	public String getCnt3();	// 나의 할일 건수
	public List selectAgreeMainList1(Map<String, Object> mtenMap);
	public List selectAgreeMainList2(Map<String, Object> mtenMap);
	
	public HashMap selectMainAgrCnt(String userId);
	
	

	public List selectAgreeChrgCost(Map<String, Object> mtenMap);
	public JSONObject updateChrgLawyerAmt(Map<String, Object> mtenMap);
	public JSONObject updateChrgLawyerAmtList(Map<String, Object> mtenMap);
	public String getOutRcptYn(Map<String, Object> mtenMap);
	
	// 협약 의뢰자 변경 팝업 호출
	public List selectRqstChangEmpList(Map<String, Object> mtenMap);
	// 협약 의뢰자 변경
	public JSONObject agreeRqstChang(Map<String, Object> mtenMap);
	public int getAgreeRole(Map<String, Object> mtenMap);
	
	
	
	public int insertSatisfaction(org.json.simple.JSONArray jsonArr);
	public JSONObject sendSatisAlert(Map<String, Object> mtenMap);
	public List getSatisSendAgreeList();
	
	public void updateDGSTFN_GIAN(HashMap param);
	public void updateDGSTFN_GIAN_STATE(HashMap param);
	
	
	
	public JSONObject updateKeyword(Map<String, Object> mtenMap);
}
