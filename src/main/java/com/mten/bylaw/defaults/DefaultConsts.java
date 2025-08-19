package com.mten.bylaw.defaults;

/**
 * Default 상수 정의 클래스
 * @ClassName DefaultConsts.java
 * @Description  Default 상수 정의 클래스
 * @Modification-Information
 *    수정일           수정자       수정내용
 *  ----------   ----------   -------------------------------
 *  2017. 7. 20.     60002841(권영훈)   최초생성
 * 
 * @author K-water 업무시스템 혁신사업 : 정보화표준 권영훈 
 * @since  2017. 7. 20.
 * @version 1.0
 * 
 *  Copyright (C) 2017 by Unlimited K-water, All right reserved.
 */

public class DefaultConsts {

	/** 자동로그인여부 Property ID */
	public static final String AUTOLOGIN_USE = "autologin.use";

    /** Session에 저장된 Login 정보 */
	public static final String SESSION_LOGIN_INFO = "LoginVO";
	
	/** 실행모드 Property ID */
	public static final String RUN_MODE = "run.mode";

	/** 실행모드 Property Value */
	public static final String RUN_MODE_LOCAL = "localhost";
	public static final String RUN_MODE_DEVSERVER = "devserver";
	public static final String RUN_MODE_SERVER = "server";

	/** Error Code */
	public static final int ERR_CODE = -1;

	/** Success Code */
	public static final int OK_CODE = 0;

	/** Session Timeout Error Code */
	public static final int ERR_TIMEOUT_CODE = -99;
	
	/** json View Name으로 view에 설정된 bean id와 동일해야 한다. */ 
	public static final String JSON_VIEW_NAME = "jsonView";

	/** WEBSQUARE View로 전달되는 오류코드명 */ 
	public static final String WEBSQUARE_ERROR_CODE_NAME = "ErrorCode";

	/** WEBSQUARE View로 전달되는 오류메시지명 */ 
	public static final String WEBSQUARE_ERROR_MSG_NAME = "ErrorMsg";
	
	/** CSRF Valid Token을 XPLAFORM에 전달하기 위한 파라미터명 */
	public static final String WEBSQUARE_TOKEN_NAME = "outSavedToken";

	/** ThreadLocal에 설정된 로그인 사용자의 사용자ID 변수명 */
	public static final String THREAD_LOCAL_USR_ID = "usrId";

	/** ThreadLocal에 설정된 로그인 사용자의 사원번호 변수명 */
	public static final String THREAD_LOCAL_USR_EMPNO = "usrEmpno";

	/** ThreadLocal에 설정된 로그인 사용자의 ID 변수명 */
	public static final String THREAD_LOCAL_USR_NM = "usrNm";

	/** ThreadLocal에 설정된 로그인 사용자의 SYSTEM 구분 코드 변수명 */
	public static final String THREAD_LOCAL_SYS_DIV_CD = "sysDivCd";

	/** ThreadLocal에 설정된 로그인 사용자의 업무 구분 코드 변수명 */
	public static final String THREAD_LOCAL_BIZN_DIV_CD = "biznDivCd";

	/** ThreadLocal에 설정된 로그인 사용자의 권한 코드 변수명 */
	public static final String THREAD_LOCAL_ATHR_ID = "athrId";

	/** ThreadLocal에 설정된 로그인 사용자의 부서코드 */
	public static final String THREAD_LOCAL_USR_DEPT_CD = "usrDeptCd";

	/** ThreadLocal에 설정된 로그인 사용자의 부서명 */
	public static final String THREAD_LOCAL_USR_DEPT_NM = "usrDeptNm";

	/** ThreadLocal에 설정된 로그인 사용자의 직위코드 */
	public static final String THREAD_LOCAL_USR_OFCPS_CD = "usrOfcpsCd";

	/** ThreadLocal에 설정된 로그인 사용자의 직위명 */
	public static final String THREAD_LOCAL_USR_OFCPS_NM = "usrOfcpsNm";

	/** ThreadLocal에 설정된 로그인 사용자의 직급코드 */
	public static final String THREAD_LOCAL_USR_JGRD_CD = "usrJgrdCd";

	/** ThreadLocal에 설정된 로그인 사용자의 직급명 */
	public static final String THREAD_LOCAL_USR_JGRD_NM = "usrJgrdNm";

	/** ThreadLocal에 설정된 로그인 사용자의 본부코드 */
	public static final String THREAD_LOCAL_USR_HQ_CD = "usrHqCd";

	/** ThreadLocal에 설정된 로그인 사용자의 본부명 */
	public static final String THREAD_LOCAL_USR_HQ_NM = "usrHqNm";

	/** ThreadLocal에 설정된 로그인 사용자의 부(문)코드 */
	public static final String THREAD_LOCAL_USR_SECT_CD = "usrSectCd";

	/** ThreadLocal에 설정된 로그인 사용자의 부(문)명 */
	public static final String THREAD_LOCAL_USR_SECT_NM = "usrSectNm";

	/** ThreadLocal에 설정된 로그인 사용자의 팀코드 */
	public static final String THREAD_LOCAL_USR_TEAM_CD = "usrTeamCd";

	/** ThreadLocal에 설정된 로그인 사용자의 팀명 */
	public static final String THREAD_LOCAL_USR_TEAM_NM = "usrTeamNm";

	/** ThreadLocal에 설정된 로그인 사용자의 직군코드 */
	public static final String THREAD_LOCAL_USR_JBGP_CD = "usrJbgpCd";

	/** ThreadLocal에 설정된 로그인 사용자의 직군명 */
	public static final String THREAD_LOCAL_USR_JBGP_NM = "usrJbgpNm";

	/** ThreadLocal에 설정된 로그인 사용자의 직렬코드 */
	public static final String THREAD_LOCAL_USR_JBLN_CD = "usrJblnCd";

	/** ThreadLocal에 설정된 로그인 사용자의 직렬명 */
	public static final String THREAD_LOCAL_USR_JBLN_NM = "usrJblnNm";

	/** ThreadLocal에 설정된 로그인 사용자의 직무코드 */
	public static final String THREAD_LOCAL_USR_DTY_CD = "usrDtyCd";

	/** ThreadLocal에 설정된 로그인 사용자의 직무명 */
	public static final String THREAD_LOCAL_USR_DTY_NM = "usrDtyNm";

	/** ThreadLocal에 설정된 로그인 사용자의 코스트센터코드 */
	public static final String THREAD_LOCAL_CSTCT_CD = "usrCstctCd";

	/** ThreadLocal에 설정된 로그인 사용자의 접속IP */
	public static final String THREAD_LOCAL_CONECT_IP = "conectIp";

	/** ThreadLocal에 설정된 본부명   */
	@Deprecated
	public static final String THREAD_LOCAL_HEAD_NM = "head" ;

	/** ThreadLocal에 설정된 본부코드   */
	@Deprecated
	public static final String THREAD_LOCAL_BON_CD = "bonCd";

	/** ThreadLocal에 설정된  팀명   */
	@Deprecated
	public static final String THREAD_LOCAL_SECT_NM= "sect" ;

	/** ThreadLocal에 설정된  팀코드  */
	@Deprecated
	public static final String THREAD_LOCAL_SECT_CD = "timCd";

	/** ThreadLocal에 설정된   과명 */
	@Deprecated
	public static final String THREAD_LOCAL_KWA_MN="team";

	/**   ThreadLocal에 설정된  과코드 */
	@Deprecated
	public static final String THREAD_LOCAL_KWA_CD = "kwaCd" ;

	/**  ThreadLocal에 설정된  직군명  */
	@Deprecated
	public static final String THREAD_LOCAL_BGROUP = "bgroup" ;

	/** ThreadLocal에 설정된  직군코드   */
	@Deprecated
	public static final String THREAD_LOCAL_ZGUN_CD = "zgunc" ;

	/**  ThreadLocal에 설정된  직렬명  */
	@Deprecated
	public static final String THREAD_LOCAL_DGROUP ="dgroup" ;

	/**  ThreadLocal에 설정된  직렬코드  */
	@Deprecated
	public static final String THREAD_LOCAL_ZGP_CD="zgpCd";

	/** ThreadLocal에 설정된  직무명   */
	@Deprecated
	public static final String THREAD_LOCAL_AFF_CD ="affCd" ;

	/**   ThreadLocal에 설정된  직무코드  */
	@Deprecated
	public static final String THREAD_LOCAL_STE_CD  ="steCd" ;

	/**   코스트센터 */
	@Deprecated
	public static final String THREAD_LOCAL_KOSTL ="kostl" ;

	/** ThreadLocal에 설정된 로그인 사용자의 코스트센터명 */
	@Deprecated
	public static final String THREAD_LOCAL_CSTCT_NM = "usrCstctNm";


	/** 상태코드 */
    public final static String STATUS_SUCESS = "success";
    public final static String STATUS_ERROR = "error";
    public final static String STATUS_DUP_LOGIN = "error_dup_login";

	/** 상태코드 메세지 */
    public final static String STATUS_SUCESS_MESSAGE = "서비스 처리에 성공했습니다.";
    public final static String STATUS_ERROR_MESSAGE = "서비스 처리에 실패했습니다.";
    public final static String STATUS_OTHER_MESSAGE = "서비스 처리 결과를 알 수 없습니다.";

	/** 데이터 영역 Node 명 */
    public final static String DATA_NODE_NAME = "data";

	/** 메세지 영역 Node 명 */
    public final static String MESSAGE_NODE_NAME = "message";

	/** 메세지 영역 code 명 */
    public final static String MESSAGE_CODE_NODE_NAME = "code";
    
	/** 메세지 영역 code name 명 */
    public final static String MESSAGE_CODE_NAME_NODE_NAME = "code_name";
}
