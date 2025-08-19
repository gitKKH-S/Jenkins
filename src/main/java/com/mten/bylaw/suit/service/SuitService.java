package com.mten.bylaw.suit.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public interface SuitService {
	
	public String getSeq();
	
	// 소송코드
	public List getCodeList(Map<String, Object> mtenMap);
	public List getProgList(Map<String, Object> mtenMap);
	public JSONObject selectOptionList(Map<String, Object> mtenMap);
	public JSONObject selectLwsLwrTypeCdList(Map<String, Object> mtenMap);
	
	// 소송파일 관련
	public JSONObject fileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest);
	public List getFileList(Map mtenMap);
	
	// 소송
	public JSONObject selectSuitList(Map<String, Object> mtenMap);
	public List selectSuitMainList(Map<String, Object> mtenMap);
	public HashMap getSuitDetail(Map<String, Object> mtenMap);
	public JSONObject insertSuitInfo(Map<String, Object> mtenMap);
	public JSONObject deleteSuitInfo(Map<String, Object> mtenMap);
	
	// 심급
	public HashMap getCaseDetail(Map<String, Object> mtenMap);
	public JSONObject insertCaseInfo(Map<String, Object> mtenMap);
	public HashMap getCaseResultDetail(Map<String, Object> mtenMap);
	public JSONObject insertCaseResultInfo(Map<String, Object> mtenMap);
	public JSONObject selectCaseList(Map<String, Object> mtenMap);
	public String getInstMngNo(Map<String, Object> mtenMap);
	
	// 소송의뢰
	public JSONObject selectConsultSuitList(Map<String, Object> mtenMap);
	public List selectConsultSuitMainList(Map<String, Object> mtenMap);
	public HashMap getSuitConsultDetail(Map<String, Object> mtenMap);
	public JSONObject insertSuitConsultInfo(Map<String, Object> mtenMap);
	public JSONObject deleteSuitConsultInfo(Map<String, Object> mtenMap);
	public JSONObject updateSuitConsultProg(Map<String, Object> mtenMap);
	
	// 소송당사자
	public JSONObject selectEmpList(Map<String, Object> mtenMap);
	public List getEmpInfo(Map<String, Object> mtenMap);
	public List getLastEmpInfo(Map<String, Object> mtenMap);
	
	// 소송담당자
	public JSONObject selectEmpUserList(Map<String, Object> mtenMap);
	public JSONObject chgEmpInfoSave(Map<String, Object> mtenMap);
	
	// 기일정보
	public JSONObject selectDateList(Map<String, Object> mtenMap);
	public HashMap getDateDetail(Map<String, Object> mtenMap);
	public JSONObject insertDateInfo( Map<String, Object> mtenMap);
	public JSONObject deleteCaseDate(Map<String, Object> mtenMap);
	public List getDateDocFileList(Map mtenMap);
	
	// 제출송달
	public JSONObject selectDocList(Map<String, Object> mtenMap);
	public List selectRelDateList(Map<String, Object> mtenMap);
	public HashMap getDocDetail(Map<String, Object> mtenMap);
	public JSONObject insertDocInfo(Map<String, Object> mtenMap);
	public JSONObject deleteDocInfo(Map<String, Object> mtenMap);
	
	// 소송수행자
	public JSONObject selectRelEmpList(Map<String, Object> mtenMap);
	public HashMap getRelEmpDetail(Map<String, Object> mtenMap);
	public JSONObject insertRelEmpInfo(Map<String, Object> mtenMap);
	public JSONObject deleteRelEmpInfo(Map<String, Object> mtenMap);
	public JSONArray getDeptList(Map<String, Object> mtenMap);
	public JSONObject selectDeptList(Map<String, Object> mtenMap);
	public JSONObject selectUserList(Map<String, Object> mtenMap);
	
	// 법무법인
	public JSONObject selectfLawFirmList(Map<String, Object> mtenMap);
	public HashMap getLawfirmDetail(Map<String, Object> mtenMap);
	public List getTnrList(Map<String, Object> mtenMap);
	public JSONObject insertLawfirmInfo(Map<String, Object> mtenMap);
	public JSONObject deleteLawfirmInfo(Map<String, Object> mtenMap);
	
	public List getBankList(Map<String, Object> mtenMap);
	
	// 변호사
	public JSONObject selectLawyerList(Map<String, Object> mtenMap);
	public JSONObject selectLawyerListExcel(Map<String, Object> mtenMap);
	public String makeLawyerExcel(String sTit , ArrayList<String> columnList , ArrayList<String> columnRList , 
			List<Map<String,Object>> datalist, HttpServletRequest req, HttpServletResponse response, String filePath);
	
	public HashMap getLawyerDetail(Map<String, Object> mtenMap);
	public JSONObject insertLawyerInfo(Map<String, Object> mtenMap);
	public JSONObject insertLawyerInfoOut(Map<String, Object> mtenMap);
	public JSONObject deleteLawyerInfo(Map<String, Object> mtenMap);
	public JSONObject duchk(Map<String, Object> mtenMap);
	public JSONObject changePassWord(Map<String, Object> mtenMap);
	
	public JSONObject selectLawfirmPopList(Map<String, Object> mtenMap);
	public JSONObject selectLawyerPopList(Map<String, Object> mtenMap);
	public List getAgtList(Map<String, Object> mtenMap);
	
	// 비용
	public JSONObject selectCostList(Map<String, Object> mtenMap);
	public HashMap getCostDetail(Map<String, Object> mtenMap);
	public List getCostTarget(Map<String, Object> mtenMap);
	public JSONObject insertCostInfo(Map<String, Object> mtenMap);
	public JSONObject deleteCostInfo(Map<String, Object> mtenMap);
	
	// 비용계산식
	public JSONObject selectCalList(Map<String, Object> mtenMap);
	public JSONObject insertCalInfo(Map<String, Object> mtenMap);
	public JSONObject deleteCalInfo(Map<String, Object> mtenMap);
	
	// 위임정보
	public JSONObject selectChrgLawyerList(Map<String, Object> mtenMap);
	public HashMap getChrgLawyerDetail(Map<String, Object> mtenMap);
	public JSONObject insertChrgLawyer(Map<String, Object> mtenMap);
	public JSONObject deleteChrgLawyer(Map<String, Object> mtenMap);
	public JSONObject insertChrgCost(Map<String, Object> mtenMap);
	public JSONObject updateChrgLawyerAmt(Map<String, Object> mtenMap);
	public JSONObject updateChrgLawyerAmtList(Map<String, Object> mtenMap);
	
	// 채권정보
	public JSONObject selectBondList(Map<String, Object> mtenMap);
	public List selectRecInfoList(Map<String, Object> mtenMap);
	public HashMap getBondDetail(Map<String, Object> mtenMap);
	public HashMap getBondRecDetail(Map<String, Object> mtenMap);
	public JSONObject insertBondInfo(Map<String, Object> mtenMap);
	public JSONObject insertRecInfo(Map<String, Object> mtenMap);
	public JSONObject deleteRecInfo(Map<String, Object> mtenMap);
	public JSONObject deleteBondInfo(Map<String, Object> mtenMap);
	
	// 보고서
	public JSONObject selectReportList(Map<String, Object> mtenMap);
	public HashMap getReportDetail(Map<String, Object> mtenMap);
	public JSONObject insertReportInfo(Map<String, Object> mtenMap);
	public JSONObject deleteReportInfo(Map<String, Object> mtenMap);
	
	// 검토진행
	public JSONObject selectChkList(Map<String, Object> mtenMap);
	public HashMap getChkInfoDetail(Map<String, Object> mtenMap);
	public JSONObject insertChkInfo(Map<String, Object> mtenMap);
	public JSONObject deleteChkInfo(Map<String, Object> mtenMap);
	
	// 메모관리
	public JSONObject selectMemoList(Map<String, Object> mtenMap);
	public JSONObject insertMemo(Map<String, Object> mtenMap);
	public JSONObject deleteMemo(Map<String, Object> mtenMap);
	
	public List getSatisitemList(Map<String, Object> mtenMap);
	public JSONObject insertSatisitem(Map<String, Object> mtenMap);
	public JSONObject selectSatisfactionList(Map<String, Object> mtenMap);
	public List getSatisfactionList(Map<String, Object> mtenMap);
	public List getLawyerList(Map<String, Object> mtenMap);
	public List getProcSatisList(Map<String, Object> mtenMap);
	public List getSatisitemList2(Map<String, Object> mtenMap);

	public int insertSatisfaction(org.json.simple.JSONArray jsonArr);

	public JSONObject setViewYn(Map<String, Object> mtenMap);

	public JSONObject fileDelete(Map<String, Object> mtenMap);
	
	public JSONObject selectCourtFileList(Map<String, Object> mtenMap);
	public JSONObject courtFileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest);
	public JSONObject courtFileDelete(Map<String, Object> mtenMap);
	public List<Map<String, Object>> getCourtFileList(Map<String, Object> param);
	public JSONObject allCourtFileDelete(Map<String, Object> mtenMap);
	
	
	// 불변기일관리
	public JSONObject selectUnchangeDateList(Map<String, Object> mtenMap);
	public HashMap getUnchDateInfo(Map<String, Object> mtenMap);
	public JSONObject UnchDateInfoSave(Map<String, Object> mtenMap);
	public JSONObject unchDateDelete(Map<String, Object> mtenMap);
	
	// 기일 달력
	public JSONArray selectCalData(Map<String, Object> mtenMap);
	public List selectMainCalData(Map<String, Object> mtenMap);
	
	// 관련사건 대상 사건 목록 조회
	public HashMap selectRelCaseList(Map<String, Object> mtenMap);
	// 관련사건 목록 조회
	public HashMap selectRelCase(Map<String, Object> mtenMap);
	
	public JSONObject saveRelCase(Map<String, Object> mtenMap);
	public JSONObject deleteRelCase(Map<String, Object> mtenMap);
	
	public String getCnt1();	// 소송의뢰 접수대기 건수
	public String getCnt2(String userId);	// 소송 진행중 건수
	public String getCnt3();	// 금일 일정 건수
	
	public List selectMerCaseInfo(Map<String, Object> mtenMap);
	public HashMap selectMerCaseList(Map<String, Object> mtenMap);
	
	// 소송위원회 관련
	public JSONObject selectComiUserList(Map<String, Object> mtenMap);
	public JSONObject comInfoSave(Map<String, Object> mtenMap);
	public JSONObject delComiUser(Map<String, Object> mtenMap);
	
	// 소송심의 관련
	public int getReviewRoleChk(Map<String, Object> mtenMap);
	public JSONObject selectReviewList(Map<String, Object> mtenMap);
	
	public HashMap getSuitReviewDetail(Map<String, Object> mtenMap);
	public List getSuitReviewComiList(Map<String, Object> mtenMap);
	public HashMap getReviewOpinionCnt(Map<String, Object> mtenMap);
	
	public JSONObject reviewInfoSave(Map<String, Object> mtenMap);
	public JSONObject delReviewInfo(Map<String, Object> mtenMap);
	public JSONObject selectreviewComiList(Map<String, Object> mtenMap);
	public JSONObject selectEndComList(Map<String, Object> mtenMap);
	public JSONObject reviewComiSave(Map<String, Object> mtenMap);
	public JSONObject suitReviewRequest(Map<String, Object> mtenMap);
	public JSONObject suitOpinionSave(Map<String, Object> mtenMap);
	public JSONObject reviewEndInfoSave(Map<String, Object> mtenMap);
	public JSONObject reviewContInfoSave(Map<String, Object> mtenMap);
	public JSONObject reviewStateChange(Map<String, Object> mtenMap);
	
	///////////////////////////////////////////////////
	// 외부
	public JSONObject cOtp2(Map<String, Object> mtenMap, HttpServletRequest request);
	public JSONObject resetLwyrAcct(Map<String, Object> mtenMap, HttpServletRequest request);
	public JSONObject lawyerLoginChk(Map<String, Object> mtenMap, HttpServletRequest request);
	
	public HashMap getOutSuitCnt(Map<String, Object> mtenMap);
	public JSONObject selectOutSuitList(Map<String, Object> mtenMap);
	
	public JSONObject selectCaseInfo(Map<String, Object> mtenMap);
	public JSONObject selectProgList(Map<String, Object> mtenMap);
	
	
	
	public HashMap getDocMakeInfo1(Map<String, Object> mtenMap);
	public HashMap getDocMakeInfo2(Map<String, Object> mtenMap);
	public HashMap getDocMakeInfo3(Map<String, Object> mtenMap);
	public List getDocMakeInfo3_1(Map<String, Object> mtenMap);
	
	
	
	public JSONObject rfslRsnSave(Map<String, Object> mtenMap);
	
	
	
	
	public JSONObject getSuitTypeInfo(Map<String, Object> mtenMap);
	public JSONObject getProgListSch(Map<String, Object> mtenMap);
	
	public HashMap getLeftDateMain(Map<String, Object> mtenMap);
	public JSONObject getLeftDate(Map<String, Object> mtenMap);
	
	public String getPwChg(Map<String, Object> mtenMap);
	
	// 메인 소장접수, 소송비용 권한 - 담당자 미배정 건수
	public String getMainLwsTkcgCnt();
	// 소송비용 지급 요청 건수
	public String getMainLwsCstCnt();
	// 메인 담당자 미배정 목록
	public List selectMainLwsTkcgList(Map<String, Object> mtenMap);
	// 메인 비용 미지급 목록
	public List selectMainLwsCstList(Map<String, Object> mtenMap);
	
	// 메인 관리자 권한 진행중 건수
	public HashMap getMainYCnt2();
	
	// 메인 관리자 진행중인 자문/협약 목록
	public List selectConAgreeMainList(Map<String, Object> mtenMap);
	
	// 만료 예정 법률 고문 건수 
	public String selectMainLawfirmEndInfoCnt();
	// 법률 고문 건수
	public String selectMainLawyerCnt();
	// 만료 예정 법률 고문 목록
	public List selectMainLawfirmEndInfoList(Map<String, Object> mtenMap);
	
	// 법률 고문 건수
	public String selectMainSuitTrmnYnCnt(String userId);
	// 메인 일반사용자 사건 목록
	public List selectSuitMainList2(Map<String, Object> mtenMap);
	
	
	public int getMainCalDataCnt(Map<String, Object> mtenMap);
	
	public void updateBondBuga(Map<String, Object> mtenMap);
	
	public JSONObject selectRoleInfo(Map<String, Object> mtenMap);
	public JSONObject roleInfoSave(Map<String, Object> mtenMap);
	
	public List selectSuitChrgCost(Map<String, Object> mtenMap);
	
	public void setDocFileModiDate(Map<String, Object> mtenMap);

	public List getChrgEmpInfo4(Map<String, Object> mtenMap);
	
	public String getOutRcptYn(Map<String, Object> mtenMap);
	
	
	
	public String getCostTargetOne(Map<String, Object> mtenMap);
	public List selectSuitTotalCost(Map<String, Object> mtenMap);
	public JSONObject setOutCostState(Map<String, Object> mtenMap);
	public JSONObject updateCostAmtList(Map<String, Object> mtenMap);

	public List getDateList(Map<String, Object> mtenMap);
	
	
	
	
	
	
	public List selectBondMain1(Map<String, Object> mtenMap);
	public List selectBondMain2(Map<String, Object> mtenMap);
	
	
	public int selectSuitRoleChk(Map<String, Object> mtenMap);
}
