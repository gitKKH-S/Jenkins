package com.mten.bylaw.consult.service;

import java.util.*;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public interface ConsultService {
	// 자문 목록 데이터
	public JSONObject consultListData(Map<String, Object> mtenMap); 
	// 자문의뢰 기본 정보 저장
	public JSONObject consultSave(Map<String, Object> mtenMap);
	// 자문 파일 저장
	public JSONObject saveFile(MultipartHttpServletRequest multipartRequest , Map<String, Object> mtenMap);
	// 자문의뢰 상세
	public HashMap getConsultInfo(Map<String, Object> mtenMap); 
	// 자문 파일 목록 조회
	public List getFileList2(Map param);
	// 첨부파일 구분자로 가져오기
	public List getAnswerFileList(Map mtenMap);
	// 자문 위원 목록 조회
	public List selectConsultLawyerList(Map<String, Object> mtenMap);
	// 자문 회신내용 조회
	public List selectAnswerBoard(Map<String, Object> mtenMap);
	// 자문 승인자 조회
	public List selectAgreeEmp();
	// 자문 진행상태 변경
	public JSONObject updateConsultState(Map<String, Object> mtenMap);
	public JSONObject updateConsultState2(Map<String, Object> mtenMap);
	// 자문 공개여부 변경
	public JSONObject updateConsultOpenyn(Map<String, Object> mtenMap);
	// 자문 정보 삭제
	public JSONObject consultDelete(Map<String, Object> mtenMap);
	// 자문 담당자 관리 팝업 호출
	public List selectChrgEmpList(Map<String, Object> mtenMap);
	// 자문 담당자 선택 및 변경(담당자 상태 변경 필요한지 모르겠음)
	public JSONObject setChrgEmpState(Map<String, Object> mtenMap);
	// 자문 담당자 관리 팝업 호출
	public List selectRqstDeptManagerList(Map<String, Object> mtenMap);
	// 변호사 목록 조회
	public List selectLawyerList2(Map<String, Object> mtenMap);
	public int selectLawyerTotal(Map<String, Object> mtenMap);
	// 자문 검토 담당자 선택
	public JSONObject setConsultRvwPic(Map<String, Object> mtenMap);
	// 자문 유형 및 자문위원 저장
	public JSONObject consultLawInfoSave(Map<String, Object> mtenMap);
	// 자문 외부 검토자 삭제
	public JSONObject deleteConsultLawyer2(Map<String, Object> mtenMap);
	// 진행 메모 목록 조회
	public JSONObject selectMemoList(Map<String, Object> mtenMap);
	// 지믄 메모 상세(수정) 화면 호출시 
	public HashMap selectConsultMemoView(Map<String, Object> mtenMap);
	// 자문 메모 등록
	public JSONObject saveMemoInfo(Map<String, Object> mtenMap);
	// 자문 메모 삭제
	public JSONObject deleteMemo(Map<String, Object> mtenMap);
	// 자문 답변 내용 조회
	public HashMap selectConsultAnswerView(Map<String, Object> mtenMap);
	// 자문 답변글 등록
	public JSONObject answerSave(Map<String, Object> mtenMap);
	// 자문 답변 삭제
	public JSONObject deleteAnswer(Map<String, Object> mtenMap);
	// 자문 답변완료 처리 업데이트
	public JSONObject answerResultSave(Map<String, Object> mtenMap);
	// 자문 비용 정보 내용 조회
//	public HashMap selectConsultCstInfoView(Map<String, Object> mtenMap);
	
	// 구두 자문 목록 데이터
	public JSONObject verbalAdviceListData(Map<String, Object> mtenMap);
	// 구두 자문 기본 정보 등록
	public JSONObject verbalAdviceSave(Map<String, Object> mtenMap);
	// 구두 자문 정보 삭제
	public JSONObject verbalAdviceDelete(Map<String, Object> mtenMap);
	// 구두 자문 직원 선택 팝업 부서 목록
	public JSONArray getDeptList(Map<String, Object> mtenMap);
	// 구두 자문 직원 선택 팝업 직원 목록
	public JSONObject selectUserList(Map<String, Object> mtenMap);
	// 구두 자문 직원 선택 팝업 부서 목록
	public JSONObject selectDeptList(Map<String, Object> mtenMap);
	
	// 자문 내/외부 유형 변경
	public JSONObject updateInsdOtsdTaskSe(Map<String, Object> mtenMap);
	
	// 자문 목록 통계 그림 위한 전체 건수 조회
	public int selectStateTotalCnt(Map<String, Object> mtenMap);
	// 자문 목록 통계 그림 위한 진행상태별 건수 조회
	public List selectStateCnt(Map<String, Object> mtenMap);
	
	// 자문 답변 검토 의견 내용 조회
	public HashMap selectConsultReviewComment(Map<String, Object> mtenMap);
	// 자문 답변 검토 의견 내용 저장 수정
	public JSONObject saveReviewComment(Map<String, Object> mtenMap);
	// 자문 답변 검토 의견 정보 삭제
	public JSONObject deleteReviewComment(Map<String, Object> mtenMap);

	public List<Map<String, Object>> listFileDownload(Map<String, Object> mtenMap);
	
	public List getSatisfactionList(Map<String, Object> mtenMap);
	public List getLawyerList2(Map<String, Object> mtenMap);
	public List getProcSatisList(Map<String, Object> mtenMap);
	public List getSatisitemList2(Map<String, Object> mtenMap);
	
	public HashMap getOutConsultCnt(Map<String, Object> mtenMap);
	
	public JSONObject selectOutConsultList(Map<String, Object> mtenMap); //자문의뢰리스트
	
	public JSONObject setConsultCost(Map<String, Object> mtenMap);
	public JSONObject setCostInfo(Map<String, Object> mtenMap);
	
	public JSONObject rfslRsnSave(Map<String, Object> mtenMap);
	
	// 자문 관련 사용자 메인화면 접근시 건수
	public String getCnt1();	// 접수대기 건수
	public String getCnt2(String userId);	// 진행중 건수
	public String getCnt3();	// 나의 할일 건수
	
	public List selectConsultMainList1(Map<String, Object> mtenMap);
	public List selectConsultMainList2(Map<String, Object> mtenMap);
	
	public String getMainConCstCnt();	// 자문료 지급 요청 건수
	public List selectMainConCstList(Map<String, Object> mtenMap);
//	public HashMap getBondDetail(Map<String, Object> mtenMap);
	
	public HashMap selectMainConCnt(String userId);
	
	// 자문의뢰 상세
	public HashMap getDeptHeadInfo(Map<String, Object> mtenMap);
	
	
	
	public List selectConsultChrgCost(Map<String, Object> mtenMap);
	public JSONObject updateChrgLawyerAmt(Map<String, Object> mtenMap);
	public JSONObject updateChrgLawyerAmtList(Map<String, Object> mtenMap);
	
	// 자문 의뢰자 변경 팝업 호출
	public List selectRqstChangEmpList(Map<String, Object> mtenMap);
	// 자문 의뢰자 변경
	public JSONObject consultRqstChang(Map<String, Object> mtenMap);
	
	
	
	public String getOutRcptYn(Map<String, Object> mtenMap);
	public int getConsultRole(Map<String, Object> mtenMap);
	
	
	
	public int insertSatisfaction(org.json.simple.JSONArray jsonArr);
	public JSONObject sendSatisAlert(Map<String, Object> mtenMap);
	public JSONObject sendSatisAlertList(Map<String, Object> mtenMap);
	public List getSatisSendConsultList();
	public JSONObject updateKeyword(Map<String, Object> mtenMap);
}


