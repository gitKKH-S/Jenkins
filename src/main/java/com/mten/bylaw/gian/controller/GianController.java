package com.mten.bylaw.gian.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.CDATASection;

import com.mten.bylaw.admin.service.UserService;
import com.mten.bylaw.agree.service.AgreeService;
import com.mten.bylaw.bylaw.service.BylawService;
import com.mten.bylaw.consult.service.ConsultService;
import com.mten.bylaw.gian.service.GianService;
import com.mten.bylaw.suit.service.SuitService;
import com.mten.util.MakeHan;

@Controller
@RequestMapping("/gian/ons/")
public class GianController {
	
	@Resource(name="gianService")
	private GianService gianService;
	
	@Resource(name="agreeService")
	private AgreeService agreeService;
	
	@Resource(name = "suitService")
	private SuitService suitService;
	
	@Resource(name="bylawService")
	private BylawService bylawService;
	
	@Resource(name="cousultService")
	private ConsultService consultService;
	
	/*
	  flist = [{SERVERFILE:'',PCFILENAME:''},{SERVERFILE:'',PCFILENAME:''}];	//결재첨부파일정보
		FPATH = "SUIT"  //문서구분
		TITLE = ""		//결재제목
		BON = ""		//결재본문
		SUMMARY = ""; //문서요지
	 */
	@RequestMapping("gianOnsStart.do")
	public void gianOnsStart(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String docgbn = mtenMap.get("DOCGBN")==null?"":mtenMap.get("DOCGBN").toString();
		String filecd = mtenMap.get("FILECD")==null?"":mtenMap.get("FILECD").toString();
		String docid = mtenMap.get("DOCID")==null?"":mtenMap.get("DOCID").toString();
		String subdocid = mtenMap.get("SUBDOCID")==null?"":mtenMap.get("SUBDOCID").toString();
		String fnm = mtenMap.get("FNM")==null?"":mtenMap.get("FNM").toString();
		String snm = mtenMap.get("SNM")==null?"":mtenMap.get("SNM").toString();
		
		String giangbn = mtenMap.get("giangbn")==null?"":mtenMap.get("giangbn").toString();
		
		String GIANID = suitService.getSeq();
		
		if(docgbn.equals("SUIT")){
			HashMap suitMap = suitService.getSuitDetail(mtenMap);
			HashMap caseMap = suitService.getCaseDetail(mtenMap);
			List empList    = suitService.getEmpInfo(mtenMap);
			List lwyrList   = suitService.getCostTarget(mtenMap);
			
			String LWS_UP_TYPE_NM = suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString();
			
			// 소송유형별 원고, 피고, 판결일 등 용어 변수 정의
			//국가소송
			//행정소송
			//민사소송
			//조정사건
			//국배심
			//헌법소원
			//주민소송
			//권한쟁의
			//직무관련사건
			//민사집행
			
			
			String title = "";
			String cont = "";
			String wonEmpTxt = "";
			String piEmpTxt = "";
			
			for(int i=0; i<empList.size(); i++) {
				HashMap empMap = (HashMap)empList.get(i);
				String gubun = empMap.get("LWS_CNCPR_SE_NM")==null?"":empMap.get("LWS_CNCPR_SE_NM").toString();
				if ("원고".equals(gubun)) {
					wonEmpTxt = wonEmpTxt + " " + empMap.get("LWS_CNCPR_NM")==null?"":empMap.get("LWS_CNCPR_NM").toString()+",";
				} else if ("피고".equals(gubun)) {
					piEmpTxt = piEmpTxt + " " + empMap.get("LWS_CNCPR_NM")==null?"":empMap.get("LWS_CNCPR_NM").toString()+",";
				}
			}
			
			if (wonEmpTxt.endsWith(",")) {
				wonEmpTxt = wonEmpTxt.substring(0, wonEmpTxt.length()-1);
			}
			
			if (piEmpTxt.endsWith(",")) {
				piEmpTxt = piEmpTxt.substring(0, wonEmpTxt.length()-1);
			}
			
			if("SUIT1".equals(giangbn)) {
				title = "소송사무보고(소장 접수)(관리번호 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "아래 행정사건에 대하여 붙임과 같이 소장을 접수하였음을 알려드립니다.\n\n";
				cont = cont + "○ 사  건: "+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "○ 당사자: 원고 "+wonEmpTxt+"\n";
				cont = cont + "           피고 "+piEmpTxt+"\n";
				cont = cont + "○ 송달일: "+(caseMap.get("RLNG_TMTL_YMD")==null?"":caseMap.get("RLNG_TMTL_YMD").toString())+"\n\n";
				cont = cont + "붙임 1. 소송사무보고 1부.\n";
				cont = cont + "     2. 소장 및 첨부서류(별도 송부) 1부. 끝.";
			} else if ("SUIT2".equals(giangbn)) {
				title = "소장 접수에 따른 입증자료 제출 요청(관리번호 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "○ 사  건: "+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "○ 당사자: 원고 "+wonEmpTxt+"\n";
				cont = cont + "           피고 "+piEmpTxt+"\n";
				cont = cont + "○ 송달일: "+(caseMap.get("RLNG_TMTL_YMD")==null?"":caseMap.get("RLNG_TMTL_YMD").toString())+"\n";
				cont = cont + "○ 사건개요: "+(suitMap.get("INCDNT_OTLN")==null?"":suitMap.get("INCDNT_OTLN").toString())+"\n";
				cont = cont + "위 사건의 소송지원부서로 지정되었으므로 아래 사항에 유의하여 차질없이 처리 하시기 바랍니다.\n\n";
				cont = cont +"1. 소송보조자 통보: 통보일로부터 3일 이내(′25. 0. 0.)\n";
				cont = cont + "  - 소송보조자 직렬, 직급, 이름 연락처 및 E-mail 주소를 E-mail(박언지 법률전문관: eonji@seoul.go.kr)로 제출\n";
				cont = cont + "  - 소송보조자는 담당 팀장급 및 실무자로 2인 이상 지정(5급 상당 1명 포함\n";
				cont = cont +"2. 사실관계 및 입증자료, 주장 내용 제출: 통보일로부터 10일 이내(′25. 0. 0.)\n";
				cont = cont + "  - 사실관계의 확인 및 원고 주장 내용에 대한 반박과 입증자료\n\n";
				cont = cont + "※ 소송지원부서의 의무\n";
				cont = cont + "① 입증자료 제출, 법률지원담당관 및 소송대리인 요구시 자료 발굴·제출\n";
				cont = cont + "② 법원, 법률지원담당관 및 소송대리인의 요구에 따른 법원 출석 및 증언\n";
				cont = cont + "③ 각 심급별 판결 결과, 화해권고 등 결정에 따른 의견제출\n";
				cont = cont + "④ 판결 확정 이후의 판결금 지급/회수 등 필요한 후속 조치 수행\n\n";
				cont = cont + "붙임 1. 소장 1부.\n";
				cont = cont + "     2. 서증 및 첨부(별도송부) 1부.\n";
				cont = cont + "     3. 응소관련 자료제출 양식 1부. 끝.";
			} else if ("SUIT3".equals(giangbn)) {
				// 소장 접수에 따른 입증자료 제출
				title = "소장 접수에 따른 입증자료 제출(관리번호 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "1. 법률지원담당관-0000(2025.0.00)호와 관련입니다.\n";
				cont = cont + "2. 「"+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+
						"」관련 소장 접수에 따른 응소 관련 자료를 붙임과 같이 제출합니다.\n\n";
				cont = cont + "붙임 응소 관련 자료 1부. 끝.";
			} else if ("SUIT4".equals(giangbn)) {
				// 민사소송 응소방침
				title = (suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+
						"소송 응소방침(관리번호 "+(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "우리시를 당사자로 하는 다음 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+
						"소송에 대하여 아래와 같이 응소하고자 합니다.\n\n";
				cont = cont + "1. 사건의 표시\n";
				cont = cont + "   가. 사    건: "+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "   나. 당 사 자: 원고 "+wonEmpTxt+"\n";
				cont = cont + "                 피고 "+piEmpTxt+"\n";
				cont = cont + "   다. 소장 송달일: "+(caseMap.get("RLNG_TMTL_YMD")==null?"":caseMap.get("RLNG_TMTL_YMD").toString())+"\n";
				cont = cont + "   라. 소송물 가액: "+(caseMap.get("LWS_EQVL")==null?"":caseMap.get("LWS_EQVL").toString())+"원\n";
				cont = cont + "   마. 소송지원부서: "+(suitMap.get("SPRVSN_DEPT_NM")==null?"":suitMap.get("SPRVSN_DEPT_NM").toString())+"\n\n";
				cont = cont + "2. 청구취지\n";
				cont = cont + "   가. \n";
				cont = cont + "   나. \n";
				cont = cont + "   다. \n\n";
				cont = cont + "3. 청구원인\n";
				cont = cont + "   가. \n";
				cont = cont + "   나. \n";
				cont = cont + "   다. \n\n";
				cont = cont + "4. 응소이유\n";
				cont = cont + "   가. \n";
				cont = cont + "   나. \n";
				cont = cont + "   다. \n\n";
				cont = cont + "5. 소송대리인 및 소송담당자 지정\n";
				cont = cont + "   [기획조정실 법률지원담당관]\n";
				
				// 송무팀 전체 (GRPCD C인 사람 전체?)
				HashMap param = new HashMap();
				param.put("MNGR_AUTHRT_NM", "C");
				List chrgEmpList = suitService.getChrgEmpInfo4(param);
				for(int e=0; e<chrgEmpList.size(); e++) {
					HashMap emp = (HashMap)chrgEmpList.get(e);
					cont = cont + "      "+(emp.get("EMP_NM")==null?"":emp.get("EMP_NM").toString())+"\n";
				}
				
				// 주관부서정보
				cont = cont + "   ["+(suitMap.get("SPRVSN_DEPT_NM")==null?"":suitMap.get("SPRVSN_DEPT_NM").toString())+"]\n";
				// 주관부서 팀장 (컬럼 새로 추가)
				cont = cont + "      "+(suitMap.get("SPRVSN_TMLDR_NM")==null?"":suitMap.get("SPRVSN_TMLDR_NM").toString())+"\n";
				// 주관부서 직원
				cont = cont + "      "+(suitMap.get("SPRVSN_EMP_NM")==null?"":suitMap.get("SPRVSN_EMP_NM").toString())+"\n\n";
				
				cont = cont + "붙임 1. 소장 1부.\n";
				cont = cont + "     2. 소송지원부서 응소의견 1부. 끝.";
			} else if ("SUIT5".equals(giangbn)) {
				// 대리인(변호사) 및 소송담당자 지정 통보(
				title = (suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+
						" 대리인(변호사) 및 소송담당자 지정 통보(관리번호 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "1. 아래와 같이 소송대리인(변호사)을 지정하였음을 통보합니다.\n";
				cont = cont + "2. 대리인은 원고 및 피고의 법원 제출 문서와 소송 진행상황을 붙임 문서를 참고하여 법률지원담당관의 주담당자와 소송지원부서 주보조자 모두에게 상시 통보하여 주시기 바랍니다.\n";
				cont = cont + "3. 소송보조자는 추후에도 소송대리인 및 법률지원담당관의 요청에 따라 관련 자료 제출 등 적극 지원하여 원할히 소송수행 할 수 있도록 적극 협조하여 주시기 바랍니다.\n\n";
				cont = cont + "사   건: "+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "당 사 자: 원고 "+wonEmpTxt+"\n";
				cont = cont + "           피고 "+piEmpTxt+"\n";
				cont = cont + "소송 대리인: " + "";
				cont = cont + "소송 담당자: " + "\n";
				// 송무팀 전체 (GRPCD C인 사람 전체?)
				HashMap param = new HashMap();
				param.put("MNGR_AUTHRT_NM", "C");
				List chrgEmpList = suitService.getChrgEmpInfo4(param);
				for(int e=0; e<chrgEmpList.size(); e++) {
					HashMap emp = (HashMap)chrgEmpList.get(e);
					cont = cont + "      "+(emp.get("EMP_NM")==null?"":emp.get("EMP_NM").toString())+"\n";
				}
				
				// 주관부서정보
				cont = cont + "   ["+(suitMap.get("SPRVSN_DEPT_NM")==null?"":suitMap.get("SPRVSN_DEPT_NM").toString())+"]\n";
				// 주관부서 팀장 (컬럼 새로 추가)
				cont = cont + "      "+(suitMap.get("SPRVSN_TMLDR_NM")==null?"":suitMap.get("SPRVSN_TMLDR_NM").toString())+"\n";
				// 주관부서 직원
				cont = cont + "      "+(suitMap.get("SPRVSN_EMP_NM")==null?"":suitMap.get("SPRVSN_EMP_NM").toString())+"\n\n";
				
				cont = cont + "※ 소송보조자의 의무\n";
				cont = cont + "  ① 입증자료 제출, 법률지원담당관 및 소송대리인 요구시 자료 발굴·제출\n";
				cont = cont + "  ② 법원, 법률지원담당관 및 소송대리인의 요구에 따른 법원 출석 및 증언\n";
				cont = cont + "  ③ 각 심급별 판결 결과, 화해권고 등 결정에 따른 의견제출\n";
				cont = cont + "  ④ 판결 확정 이후에 필요한 판결금 지급 등 후속 조치 수행\n\n";
				
				cont = cont + "붙임 1. 소송위임장 1부.\n";
				cont = cont + "     2. 협조요청문 1부. 끝.";
			} else if ("SUIT6".equals(giangbn)) {
				// 소송수행자 지정 통보
				title = (suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+
						" 소송수행자 지정 통보(관리번호 "+(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "1. 귀원의 무궁한 발전을 기원합니다.\n";
				cont = cont + "2. "+(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+
						" 수행과 관련하여 붙임과 같이 소송수행자지정서를 제출합니다.\n\n";
				cont = cont + "붙임 1. 소송수행자 지정서 1부. 끝.";
			} else if ("SUIT7".equals(giangbn)) {
				// 진행상황 통보
				title = (suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+
						" 진행상황 통보(관리번호 "+(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "1. "+(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+
						"사건에 대하여 아래와 같이 소송진행상황을 통보합니다.\n";
				cont = cont + "2. 아래 사항을 참조하여 추후 자료취합 및 의견제출요청에 협조하여 주시기 바랍니다.\n";
				cont = cont + "[표 삽입]\n";
				cont = cont + "끝.";
			} else if ("SUIT8".equals(giangbn)) {
				// 소송사무보고 (변론기일 출석)
				
				List dateList = suitService.getDateList(mtenMap);
				
				title = "소송사무보고(변론기일 출석)"+"(관리번호 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "「국가를 당사자로 하는 소송에 관한 법률 시행령」 제6조에 의거 붙임과 같이 서면을 제출하고 변론기일에 출석하였음을 보고합니다.\n\n";
				cont = cont + "1. 사건의 표시\n";
				cont = cont + "  가. 사 건: "+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "  나. 원 고: " + wonEmpTxt + "\n";
				cont = cont + "  다. 피 고: " + piEmpTxt + "\n\n";
				
				cont = cont + "2. 소송진행사항\n";
				for(int i=0; i<dateList.size(); i++) {
					HashMap map = (HashMap) dateList.get(i);
					String DATE_YMD = map.get("DATE_YMD")==null?"":map.get("DATE_YMD").toString();
					if (!DATE_YMD.equals("")) {
						cont = cont + "  - " + DATE_YMD + "\n";
					}
				}
				cont = cont + "\n";
				cont = cont + "붙임. 소송진행상황보고 1부. 끝.";
			} else if ("SUIT9".equals(giangbn)) {
				// 소송사무보고 (판결문 접수)
				title = "소송사무보고(판결문 접수)"+"(관리번호 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "「국가를 당사자로 하는 소송에 관한 법률 시행령」 제6조에 의거 붙임과 같이 판결문이 접수되었음을 보고합니다.\n\n";
				cont = cont + "1. 사건의 표시\n";
				cont = cont + "  가. 사      건: "+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "  나. 원      고: " + wonEmpTxt + "\n";
				cont = cont + "      피      고: " + piEmpTxt + "\n\n";
				cont = cont + "  다. 소송물가액: " + (caseMap.get("LWS_EQVL")==null?"":caseMap.get("LWS_EQVL").toString())+"원\n";
				cont = cont + "  라. 판결선고일: " + 
						(caseMap.get("JDGM_ADJ_YMD")==null?"":caseMap.get("JDGM_ADJ_YMD").toString().replaceAll("-", ". ")) +
						". " + (caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString())+"\n";
				cont = cont + "  마. 판결문송달: " +
						(caseMap.get("RLNG_TMTL_YMD")==null?"":caseMap.get("RLNG_TMTL_YMD").toString().replaceAll("-", ". ")) + ". \n\n";
				cont = cont + "붙임 1. 소송사무보고(별지 제32호 서식) 1부.\n";
				cont = cont + "     2. 판결문 1부. 끝.";
			} else if ("SUIT10".equals(giangbn)) {
				// 판결문 접수에 따른 상고(포기)여부 의견제출 요청
				String JDGM_UP_TYPE_NM = caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString();
				
				title = "판결문 접수에 따른 상고(포기)여부 의견제출 요청"+"(관리번호 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "○ 사      건: "+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "○ 당  사  자: 원고: " + wonEmpTxt + "\n";
				cont = cont + "              피고: " + piEmpTxt + "\n";
				cont = cont + "○ 소송물가액: "+(caseMap.get("LWS_EQVL")==null?"":caseMap.get("LWS_EQVL").toString())+"원\n";
				cont = cont + "○ 판결선고일: " +
						(caseMap.get("JDGM_ADJ_YMD")==null?"":caseMap.get("JDGM_ADJ_YMD").toString().replaceAll("-", ". ")) + ". " +
						(caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString())+"\n";
				cont = cont + "○ 판결문송달: " +
						(caseMap.get("RLNG_TMTL_YMD")==null?"":caseMap.get("RLNG_TMTL_YMD").toString().replaceAll("-", ". ")) + ". \n";
				cont = cont + "○ 상고기한: " + " \n\n";
				
				cont = cont + "위 사건의 소송지원부로서, 아래 사항을 기한 내에 처리하여 주시기 바랍니다.\n";
				cont = cont + "※ 상고의견 등 제출: 통보일로부터 7일 이내 ('25. 00. 00.)\n\n";
				cont = cont + "※ 소송지원부서의 의무\n";
				cont = cont + "① 소송보조자를 통한 입증자료 제출, 법률지원담당관 등 요구시 자료 발굴 제출\n";
				cont = cont + "② 법원, 법률지원담당관 및 소송대리인의 요구에 따른 법원 출석 및 증언\n";
				cont = cont + "③ 각 심급별 판결 결과, 화해권고 등 결정에 따른 의견제출\n";
				cont = cont + "④ 판결 확정 이후 필요한 후속 조치 수행\n\n";
				cont = cont + "붙임 1. 판결문 1부.\n";
				cont = cont + "     2. 판결문 접수에 따른 지원부서 의견(양식) 1부. 끝.";
				
			} else if ("SUIT11".equals(giangbn)) {
				// 판결문 접수에 따른 의견제출
				title = "판결문 접수에 따른 의견제출"+"(관리번호 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "1. 법률지원담당관-0000(2025. 00. 00.)호 관련입니다.\n";
				cont = cont + "2. 우리시를 당사자로 진행한 소송사건의 판결문 접수에 따른 의견서를 붙임과 같이 제출합니다.\n";
				cont = cont + "  가. 사건의 표시\n";
				cont = cont + "  ○ 사  건: "+(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
								(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "  ○ 당  사  자: 원고 - " + wonEmpTxt + "\n";
				cont = cont + "                피고 - " + piEmpTxt + "\n";
				cont = cont + "    ※ 소송대리인: ";
				for(int i=0; i<lwyrList.size(); i++) {
					HashMap map = (HashMap)lwyrList.get(i);
					cont = cont + (map.get("JDAF_CORP_NM")==null?"":map.get("JDAF_CORP_NM").toString()) +
							" 담당변호사 " + (map.get("LWYR_NM")==null?"":map.get("LWYR_NM").toString())+"\n";
				}
				cont = cont + "  나. 판결선고일: " +
						(caseMap.get("JDGM_ADJ_YMD")==null?"":caseMap.get("JDGM_ADJ_YMD").toString().replaceAll("-", ". ")) +
						". (" + (caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString())+")\n\n";
				cont = cont + "붙임 의견제출서 1부. 끝.";
			} else if ("SUIT12".equals(giangbn)) {
				// 즉시항고 포기방침
				title = "즉시항고 포기방침(관리번호 "+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "아래 "+(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+
						"사건에 대하여 법원의 " + (caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString()) +
						" 결정을 받아들이고 즉시항고를 포기하고자 합니다.\n\n";
				cont = cont + "1. 사건의 표시\n";
				cont = cont + "  가. 사   건: "+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "  나. 당사자: 원고 " + wonEmpTxt + "\n";
				cont = cont + "              피고 " + piEmpTxt + "\n";
				cont = cont + "  다. 결정일: ";
			} else if ("SUIT13".equals(giangbn)) {
				// 소송사무보고(종결)
				title = "소송사무보고(종결)(관리번호"+
						(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+" "+
						(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+")";
				cont = cont + "아래 "+(suitMap.get("LWS_UP_TYPE_NM")==null?"":suitMap.get("LWS_UP_TYPE_NM").toString())+"사건이 붙임과 같이 종결되었음을 알려드립니다.\n\n";
				cont = cont + "1. 사건의 표시\n";
				cont = cont + "  가. 사      건: "+(caseMap.get("CT_NM")==null?"":caseMap.get("CT_NM").toString())+" "+
						(caseMap.get("INCDNT_NO")==null?"":caseMap.get("INCDNT_NO").toString())+" "+
						(suitMap.get("LWS_INCDNT_NM")==null?"":suitMap.get("LWS_INCDNT_NM").toString())+"\n";
				cont = cont + "  나. 원      고: "+ wonEmpTxt + "\n";
				cont = cont + "      피      고: "+ piEmpTxt + "\n";
				cont = cont + "  다. 소송물가액: "+(caseMap.get("LWS_EQVL")==null?"":caseMap.get("LWS_EQVL").toString())+"원\n";
				cont = cont + "  라. 판결선고일: " + 
						(caseMap.get("JDGM_ADJ_YMD")==null?"":caseMap.get("JDGM_ADJ_YMD").toString().replaceAll("-", ". ")) +
						". " + (caseMap.get("JDGM_UP_TYPE_NM")==null?"":caseMap.get("JDGM_UP_TYPE_NM").toString())+"\n";
				cont = cont + "  마. 판결확정일: " +
						(caseMap.get("JDGM_CFMTN_YMD")==null?"":caseMap.get("JDGM_CFMTN_YMD").toString().replaceAll("-", ". ")) + ". \n\n";
				cont = cont + "붙임 1. 소송사무보고(별지 제32호 서식) 1부.\n";
				cont = cont + "     2. 판결문 및 나의사건검색(확정증명원) 각 1부. 끝.";
			}
			
			HashMap para = new HashMap();
			para.put("gbnid", docid);
			para.put("filegbn", filecd);
			
			List flist = new ArrayList();
			String fnms[] = fnm.split("\\|");
			String snms[] = snm.split("\\|");
			for(int i=0; i<snms.length; i++){
				HashMap result = new HashMap();
				result.put("SERVERFILE", snms[i]);
				result.put("PCFILENAME", fnms[i]);
				flist.add(result);
			}
			mtenMap.put("GIANID", GIANID);
			mtenMap.put("BODY", cont);
			mtenMap.put("TITLE", title);
			mtenMap.put("flist", flist);
			
			//gianService.gainDelete(mtenMap);
			//gianService.gainInsert(mtenMap);
		}

		//기안 테이블 저장
		JSONObject result = gianService.gianOnsStart(mtenMap);
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter writer = null;
		writer = response.getWriter();
		writer.println(result);
		writer.close();
	}
		
	//첨부파일이 없는 기안기 호출 시작
	@RequestMapping("gianStart.do")
	public void gianStart(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		//기안 테이블 저장
		String gianid = gianService.gianStart(mtenMap);
		
		JSONObject result = new JSONObject();
		result.put("gianid", gianid);
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter writer = null;
		writer = response.getWriter();
		writer.println(result);
		writer.close();
	}
		
	//첨부파일이 있는 기안기 호출 시작
	@RequestMapping("gianStart2.do")
	public void gianStart2(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		//기안 테이블 저장
		String gianid = gianService.gianStart(mtenMap);
		
		JSONObject result = new JSONObject();
		result.put("gianid", gianid);
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter writer = null;
		writer = response.getWriter();
		writer.println(result);
		writer.close();
	}
			
	//전자결재에서 결과 호출
	@RequestMapping("gianReturn.do")
	public void gianReturn(Map<String, Object> mtenMap ,HttpServletRequest request, HttpServletResponse response) throws Exception{
		String GIANID = request.getParameter("draftId")==null?"":request.getParameter("draftId");
		String STATCD = request.getParameter("statCd")==null?"":request.getParameter("statCd");
		String GWID = request.getParameter("apprId")==null?"":request.getParameter("apprId");
		HashMap para = new HashMap();
		para.put("GIANID", GIANID);
		para.put("STATCD", STATCD);
		para.put("GWID", GWID);
		System.out.println("전자결제 호출 파라미터===>"+para);
		gianService.gianAllUpdate();
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter writer = null;
		writer = response.getWriter();
		writer.println("Y");
		writer.close();
	}
		
}