<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "javax.sql.*" %>
<%@ page import = "javax.naming.*"%> 
<%@ page import = "java.util.*"%> 
 

 

<%

	String sLOGONID  = request.getParameter("LOGONID"); //로그인 회원 ID
	String sACLID	= request.getParameter("ACLID");   //ACL 권한 판단을 위한 정보(ACLID) 예)KMS||COMM_BOARD||235712
	String sFILEID	= request.getParameter("FILEID");    //문서에 대한 유니크한 아이디(FILEID) + 시스템명 
                                                          //예)KMS||COMM_BOARD||235712||FasooPackager(COM).doc||PROJECT_KMS_V2
	String sETC4 = request.getParameter("ETC4");        //문서 버젼 에)Ver1.1
	String sETC5 = request.getParameter("ETC5");       //기타 정보 - 보안 Tag 예)Fasoo FasooPackagerAPI 매뉴얼 

  
	 
	String sRightsResult = "RIGHTS_RESULT=NO";
	String sTargetString = "";
	String sPurposeString = "";
	String sRightsString = "";
	
	String VIEWPurpose = "";  	 	//보기 권한
	String EDITPurpose = "";    	//수정 권한
	String EXTRACTPurpose = "";		//원본추출 권한
	String PRINTPurpose = "";		//출력 권한
	String SAVEPurpose = "";		//복호화 권한
	String PRINTSCRPurpose = "";	//캡쳐 권한


	String VIEW_YN = "N";  //VIEW   
	String PRINT_YN = "N";  //PRINT, SECURE_PRINT   
	String EDIT_YN = "N";  //EDIT ,SECURE_SAVE,SECURE_EXTRACT   
	String SAVE_YN = "N";  //SAVE 암호화 해제권한
	String PRINTSCR_YN = "N";

 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 모든 권한 VIEW@-1@0@0,PRINT@-1@0@0,SECURE_PRINT@-1@0@0,EDIT@-1@0@0,SECURE_SAVE@-1@0@0,SAVE@-1@0@0,SECURE_EXTRACT@-1@0@0,
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	System.out.println("sLOGONID : " + sLOGONID);
	System.out.println("sACLID : " + sACLID);
	System.out.println("sFILEID : " + sFILEID);

	if ( "".equals(sLOGONID) || sLOGONID == null )
	{
		sRightsString = "허용하지 않는 사용자 ID 입니다.";
	}
	else
	{
		sRightsResult = "RIGHTS_RESULT=YES";
		sTargetString = "&TARGET_STRING="+sLOGONID+",O,-1,0,0";
 
		VIEW_YN = "Y";
		PRINT_YN = "Y";
		EDIT_YN = "Y";


		if("admin1".equals(sLOGONID) || "30B230B25461546114767E8B344FFFFA".equals(sLOGONID) || "1FA91FA91CE61CE615596836996FFFF9".equals(sLOGONID) || "007FF97FF947034703156320435E2564".equals(sLOGONID) || "16D016D0759C759C16F18F78999FFFFC".equals(sLOGONID) || "663666363414341415DCBB146B6FFFFA".equals(sLOGONID) || "1C371C373414341415DCBB146B6FFFFA".equals(sLOGONID) || "7EE77EE7FCD0FCD165564FAD5FFFFFF1".equals(sLOGONID) || "6DBD6DBD4AAA4AAA15DCBB16D91FFFFB".equals(sLOGONID))
		{ 	  //관리자만 복호화 권한 
			VIEW_YN = "Y";
			PRINT_YN = "Y";
			EDIT_YN = "Y";
			SAVE_YN = "Y";  //복호화 권한
			PRINTSCR_YN = "Y";
		}

		if("Y".equals(VIEW_YN))
		{  //보기 권한
			VIEWPurpose = "VIEW@-1@0@0,";
		}
		if("Y".equals(EDIT_YN))
		{   //수정 권한
			EDITPurpose = "EDIT@-1@0@0,SECURE_SAVE@-1@0@0,";
		}
		if("Y".equals(PRINT_YN))
		{    //출력 권한
			PRINTPurpose = "SECURE_PRINT@-1@0@0,";
		}
		if("Y".equals(SAVE_YN))
		{    //복호화 권한
			SAVEPurpose = "SAVE@-1@0@0,";
		}
		if("Y".equals(PRINTSCR_YN))
		{
			PRINTSCRPurpose = "PRINT_SCREEN@-1@0@0,";
		}
		
		// sPurposeString = "&PURPOSE_STRING=" + VIEWPurpose + EDITPurpose + EXTRACTPurpose + PRINTPurpose + SAVEPurpose;
		sPurposeString = "&PURPOSE_STRING=" + VIEWPurpose + EDITPurpose + EXTRACTPurpose + PRINTPurpose + SAVEPurpose + PRINTSCRPurpose;	
		
	}
	if("".equals(sRightsString))
	{
		out.println(sRightsResult + sTargetString + sPurposeString);
	}
	else
	{
		out.println(sRightsString);
	}

	System.out.println(sRightsResult + sTargetString + sPurposeString);
	//System.out.println("RIGHTS_RESULT=YES&TARGET_STRING=admin,O,-1,0,0&PURPOSE_STRING=VIEW@-1@0@0,PRINT@-1@0@0,SECURE_PRINT@-1@0@0,EDIT@-1@0@0,SECURE_SAVE@-1@0@0,SAVE@-1@0@0,SECURE_EXTRACT@-1@0@0,");


%>
