package com.mten.bylaw.consult;

public class Constants {
	public static final String PAGE_MODE_INPUT 	= "I";
	public static final String PAGE_MODE_UPDATE = "U";
	
	public class Lawcase {
		public static final String BIZ_NAME = "PAN";
	}
	
	public class Counsel {
		/**/
		public static final String BIZ_NAME 			= "COUNSEL";
		public static final String BIZ_NAME_ANS 		= "COUNSELANS";
		public static final String KORAIL_LAWYERTEAM_CD = "B551519"; //현재 코레일에서 사용하는 송무팀 부서코드
		/* 자문상태코드 */
		public static final String PRGS_STAT_DEPT_REG 	= "작성중";//등록
		public static final String PRGS_STAT_DEPT_PER 	= "의뢰요청";
		public static final String PRGS_STAT_DEPT_REQM 	= "의뢰승인요청중";//부서승인요청
		 	public static final String PRGS_STAT_DEPT_REJT 	= "부서장반려";//부서반려
		 	public static final String PRGS_STAT_DEPT_APRV 	= "부서장승인";//부서승인
		public static final String PRGS_STAT_LAW_RECPT 	= "송무팀접수대기"; 
		 	
		public static final String PRGS_STAT_LAW_ORVIEW = "송무팀접수완료";//의견회신완료
															//의견요청승인중
		public static final String PRGS_STAT_LAW_NRVIEW = "검토의견작성중";
		public static final String PRGS_STAT_LAW_REQM	= "검토의견작성완료";
		public static final String PRGS_STAT_LAW_APRV	= "의견회신";
		public static final String PRGS_STAT_LAW_RVIEW 	= "의견회신요청중";
		public static final String PRGS_STAT_LAW_REJT 	= "만족도평가필요";
		public static final String PRGS_STAT_LAWBUB_REJT = "송무팀반려";
		public static final String PRGS_STAT_USER_SAT 	= "만족도평가완료"; 
//		public static final String PRGS_STAT_USER_SAT 	= "지급결의필요";
		public static final String PRGS_STAT_CON_TRACT  = "완료";//완료
		
		/**/
		/*고문 비고문 코레일*/
		public static final String TYPE_INTN		= "내부";//내부
		public static final String TYPE_EXTN		= "외부";//외부
		public static final String TYPE_GNLR		= "자문";
		public static final String TYPE_CONR		= "협약";
		
		/*소송의뢰*/
		public static final String TYPE_REQSOSONG	= "소송의뢰";
		/**/
		public static final String CHRG_TEAM		= "송무팀";
		/**/
		public static final String AUTH_CHRG_TEAM	= "송무팀원";
		public static final String AUTH_CHRG_SETTER	= "송무팀자문수신";
		
		public static final String PRGS_STAT_AGRE_REG	= "등록";
		public static final String PRGS_STAT_AGRE_REGO  = "등록결재중";
		public static final String PRGS_STAT_AGRE_REGN  = "등록반송";
		public static final String PRGS_STAT_AGRE_LAW   = "송무팀검토";
		public static final String PRGS_STAT_AGRE_LAWO  = "송무팀결재중";
		public static final String PRGS_STAT_AGRE_LAWN	= "송무팀검토반송";
		public static final String PRGS_STAT_AGRE_VIEW	= "협약검토대기";
		public static final String PRGS_STAT_AGRE_VIEWO = "협약검토결재중";
		public static final String PRGS_STAT_AGRE_VIEWN	= "협약검토반송";
		public static final String PRGS_STAT_AGRE_OK	= "완료";
		
		public static final String INOUT_I_MENUID	= "100000131";
		public static final String INOUT_O_MENUID	= "10118690";
		public static final String INOUT_E_MENUID	= "10118691";
		
		//우편번호 승인키
		// U01TX0FVVEgyMDIwMTIyNDE3MzI0MjExMDU5Mjg=
		
		
		//개발 승인키
		// U01TX0FVVEgyMDE3MTIyMDA5NTIyMDEwNzU2MTY= 
	}
}
