package com.mten.bylaw.agree.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URLEncoder;
import java.nio.channels.FileChannel;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mten.bylaw.mif.serviceSch.MifService;
import com.mten.dao.CommonDao;
import com.mten.email.SendMail;
import com.mten.util.DateUtil;
import com.mten.util.FileUploadUtil;
import com.mten.util.MakeHan;
import com.mten.util.SMSClientSend;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("agreeService")
public class AgreeServiceImpl implements AgreeService {
	protected final static Logger logger = Logger.getLogger( AgreeServiceImpl.class );
	
	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name = "mifService")
	private MifService mifService;
	
	public JSONObject fileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest) {
		Iterator<String> itr = multipartRequest.getFileNames();
		
		JSONObject result = new JSONObject();
		Map map = new HashMap<String, Object>();
		
		String [] noList = {"exe", "bat", "sh", "java", "jsp", "html", "js", "css", "xml"};
		int noLeng = noList.length;
		boolean noFlg = true;
		
		while (itr.hasNext()) {
			String FILEID = commonDao.selectOne("agreeSql.getFileIdKey");
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			
			String originalFilename = mpf.getOriginalFilename(); // 파일명
			long fileSize = mpf.getSize();
			String FileSize = String.valueOf(fileSize);
			
			String fileids = FILEID + "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length()));
			
			String fileFullPath = mtenMap.get("filePath") + fileids;
			String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length());
			String fileSe = mtenMap.get("FILE_SE_NM") == null ? "" : mtenMap.get("FILE_SE_NM").toString();
			
			for(int i=0; i<noLeng; i++){
				if(ext.equalsIgnoreCase(noList[i])){
					noFlg = false;
				}
			}
			
			if(noFlg == true){
				try {
					boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
					if(pchk) {
						map = new HashMap<String, Object>();
						
						map.put("FILE_MNG_NO",      FILEID);
						map.put("CVTN_MNG_NO",      mtenMap.get("CVTN_MNG_NO").toString());
						map.put("TRGT_PST_MNG_NO",  mtenMap.get("TRGT_PST_MNG_NO").toString());
						map.put("TRGT_PST_TBL_NM",  mtenMap.get("TRGT_PST_TBL_NM").toString());
						map.put("FILE_SE_NM",       fileSe);
						
						map.put("DWNLD_FILE_NM", originalFilename);
						map.put("SRVR_FILE_NM", FILEID + "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length())));
						map.put("PHYS_FILE_NM", originalFilename);
						map.put("FILE_EXTN_NM", ext);
						map.put("FILE_SZ", FileSize);
						
						map.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM").toString());
						map.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO").toString());
						map.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM").toString());
						map.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO").toString());
						
						commonDao.insert("agreeSql.insertFile", map);
					}else {
						System.out.println("파일업로드 실패");
						result.put("msg", "개인정보 검출 데이터를 확인하시기 바랍니다.");
					}
					
				} catch (IOException e) {
					System.out.println("파일업로드 실패");
					e.printStackTrace();
				}
			}else{
				result.put("msg", "fail");
			}
		}
		return result;
	}

	public List getFileList(Map mtenMap) {
		List<String> ordgbnList = new ArrayList<String>();
		String ordgbn = mtenMap.get("ordgbn")==null?"":mtenMap.get("ordgbn").toString();
		if (!ordgbn.equals("")) {
			String[] docArr = ordgbn.split(",");
			
			for (int i = 0; i < docArr.length; i++) {
				ordgbnList.add(docArr[i]);
			}
		}
		mtenMap.put("ordgbnList", ordgbnList);
		List list = commonDao.selectList("agreeSql.selectFileList", mtenMap);
		return list;
	}
	
	public JSONObject selectAgreeList(Map<String, Object> mtenMap) {
		String Grpcd = mtenMap.get("grpcd") == null ? "" : mtenMap.get("grpcd").toString();
		//J M Q F
		if (Grpcd.indexOf("Y") > -1) {
			// 전체관리자 or 소송관리자
			mtenMap.put("grpcd", "Y");
		} else if(Grpcd.indexOf("A") > -1 || Grpcd.indexOf("N") > -1 || Grpcd.indexOf("R") > -1 || Grpcd.indexOf("F") > -1) {
			mtenMap.put("grpcd", "A");
		} else {
			// 그 외 일반사용자
			mtenMap.put("grpcd", "P");
		}
		
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("agreeSql.selectAgreeList", mtenMap);
		int cnt = commonDao.select("agreeSql.selectAgreeListCnt", mtenMap);
		
		JSONArray jr = JSONArray.fromObject(list);
		
		result.put("result", jr);
		result.put("total", cnt);
		return result;
	}
	
	public HashMap getAgreeDetail(Map<String, Object> mtenMap) {
		return commonDao.select("agreeSql.getAgreeDetail", mtenMap);
	}
	
	public HashMap getAgreeMakeDoc(Map<String, Object> mtenMap) {
		return commonDao.select("agreeSql.getAgreeMakeDoc", mtenMap);
	}
	
	public JSONObject agreeSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		
		if (CVTN_MNG_NO.equals("")) {
			// 신규등록
			String CVTN_SE = mtenMap.get("CVTN_SE")==null?"":mtenMap.get("CVTN_SE").toString();
			String CVTN_DOC_NO = commonDao.selectOne("getCvtnDocNo");
			String CVTN_INTL_DOC_NO = "";
			if ("국제".equals(CVTN_SE)) {
				CVTN_INTL_DOC_NO = commonDao.selectOne("getIntlCvtnDocNo");
			}
			
			mtenMap.put("CVTN_DOC_NO", CVTN_DOC_NO);
			mtenMap.put("CVTN_INTL_DOC_NO", CVTN_INTL_DOC_NO);
			
			commonDao.insert("agreeSql.agreeSave", mtenMap);
			CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		} else {
			// 수정
			commonDao.update("agreeSql.agreeUpdate", mtenMap);
			
			mtenMap.put("TRGT_PST_MNG_NO", CVTN_MNG_NO);
			
			if(mtenMap.get("delfile[]")!=null){
				mtenMap.put("gbnid", CVTN_MNG_NO);
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("agreeSql.deleteFile", mtenMap);
					}
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("agreeSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		result.put("CVTN_MNG_NO", CVTN_MNG_NO);
		result.put("msg", "협약의뢰가 저장되었습니다.");
		return result;
	}
	
	public JSONObject updateAgreeState(Map<String, Object> mtenMap) { //진행상황변경 //이 프로세스 어떻게 녹여야 할지 여쭤보기..담당자 선택으로 바로 저장 되는게 맞을지
		JSONObject docinfo = new JSONObject();
		
		String adm = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		String PRGRS_STTS_SE_NM = mtenMap.get("PRGRS_STTS_SE_NM")==null?"":mtenMap.get("PRGRS_STTS_SE_NM").toString();
		HashMap agreeinfo = commonDao.select("agreeSql.getAgreeDetail", mtenMap);
		
		if (!PRGRS_STTS_SE_NM.equals("")) {
			String con          = agreeinfo.get("INSD_OTSD_TASK_SE")==null?"":agreeinfo.get("INSD_OTSD_TASK_SE").toString();
			String INOUTCON     = agreeinfo.get("INSD_OTSD_TASK_SE")==null?"":agreeinfo.get("INSD_OTSD_TASK_SE").toString();
			String CHRGEMPNO    = agreeinfo.get("CVTN_TKCG_EMP_NO")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NO").toString();
			String CHRGEMPNM    = agreeinfo.get("CVTN_TKCG_EMP_NM")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NM").toString();
			String WRITEREMPNO  = agreeinfo.get("CVTN_RQST_EMP_NO")==null?"":agreeinfo.get("CVTN_RQST_EMP_NO").toString();
			String getAgreeNo   = agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString();
			String INOUTCONHAN = "";
			
			if ("O".equals(INOUTCON)) {
				INOUTCONHAN = "외부자문";
			} else if ("I".equals(INOUTCON)) {
				INOUTCONHAN = "내부자문";
			} else {
				INOUTCONHAN = "상관없음";
			}
			
			if ("작성중".equals(PRGRS_STTS_SE_NM)) {
				// 이후 단계에서 진행된것들 다 삭제?/ 겁토 담당자만 삭제?
				commonDao.delete("agreeSql.deleteAgreeLawyer2", mtenMap);
			} else if ("내부결재중".equals(PRGRS_STTS_SE_NM)) {
				
			} else if ("내부결재반려".equals(PRGRS_STTS_SE_NM)) {
				
			} else if ("접수대기".equals(PRGRS_STTS_SE_NM)) {
				// 내부결재 승인 되면서 자문의뢰일자 변경 
				commonDao.update("agreeSql.updateAgreeYmd", mtenMap);
				
				ArrayList<String> sendUserList = new ArrayList();
				ArrayList<String> sendUserNmList = new ArrayList();
				String title = "";
				String cont = "";
				
				// 법률자문팀장에게 메일 발송
				//HashMap map = new HashMap();
				//map.put("GRPCD", "R");
				//List teamReader = commonDao.selectList("consultSql.selectConsultTeamReader", map);
				//if (teamReader.size() > 0) {
				//	//[법률지원통합시스템] 신규 협약검토건이 등록되었습니다.({관리번호}, {제목}, {부서}, {내/외부/상관없음})
				//	title = title + "[법률지원통합시스템] 신규 협약검토건이 등록되었습니다.("+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString());
				//	title = title + ", "+(agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString());
				//	title = title + ", "+(agreeinfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeinfo.get("CVTN_RQST_DEPT_NM").toString());
				//	title = title + ", "+INOUTCONHAN+")";
				//	//법률지원통합시스템에 신규 협약검토건이 등록되었으니, 확인하여주시기 바랍니다.
				//	//{관리번호}, {제목}, {부서}, {내/외부/상관없음} 등
				//	cont = cont + "법률지원통합시스템에 신규 협약검토건이 등록되었으니, 확인하여주시기 바랍니다.<br/><br/>";
				//	cont = cont + "제목 : " + (agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString()) + "<br/>";
				//	cont = cont + "의뢰부서 : " + (agreeinfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeinfo.get("CVTN_RQST_DEPT_NM").toString()) + "<br/>";
				//	cont = cont + "의뢰방법 : " + INOUTCONHAN + "<br/>";
				//	cont = cont + "의뢰내용 : " + (agreeinfo.get("CVTN_RQST_CN")==null?"":agreeinfo.get("CVTN_RQST_CN").toString());
				//	
				//	for(int i=0; i<teamReader.size(); i++) {
				//		HashMap key = (HashMap)teamReader.get(i);
				//		sendUserList.add(key.get("EMP_PK_NO")==null?"":key.get("EMP_PK_NO").toString());
				//	}
				//	
				//	SendMail mail = new SendMail();
				//	mail.sendMail(title, cont, sendUserList, null, "");
				//}
				
				title = "";
				cont = "";
				sendUserList = new ArrayList();
				mtenMap.put("EMP_NO", agreeinfo.get("CVTN_RQST_LAST_APRVR_NO")==null?"":agreeinfo.get("CVTN_RQST_LAST_APRVR_NO").toString());
				String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
				
				sendUserList.add(empKey);
				sendUserNmList.add(agreeinfo.get("CVTN_RQST_LAST_APRVR_NM")==null?"":agreeinfo.get("CVTN_RQST_LAST_APRVR_NM").toString());
				
				title = "[법률지원통합시스템] 귀 부서에서 신규 협약검토건을 등록하였습니다.";
				cont = cont + "귀 부서에서 법률지원통합시스템에 신규 협약검토건을 등록하였으니, 참고하시기 바랍니다.<br/>";
				cont = cont + "(법률지원통합시스템 접속방법: 행정포털 > 업무데스크 > 법무 영역 > 법률지원통합시스템 클릭)<br/>";
				cont = cont + "제목 : " + (agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString()) + "<br/>";
				cont = cont + "의뢰부서 : " + (agreeinfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeinfo.get("CVTN_RQST_DEPT_NM").toString()) + "<br/>";
				cont = cont + "의뢰방법 : " + INOUTCONHAN + "<br/>";
				cont = cont + "의뢰내용 : " + (agreeinfo.get("CVTN_RQST_CN")==null?"":agreeinfo.get("CVTN_RQST_CN").toString());
				
				SendMail mail = new SendMail();
//				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
			} else if ("접수".equals(PRGRS_STTS_SE_NM)) {
				// 접수 될때 자문 접수 일자 업데이트 해주기 // CNSTN_RCPT_YMD
				commonDao.update("agreeSql.updateAgreeYmd", mtenMap);
				
				if (getAgreeNo.equals("")) {
					String AgreeNo = commonDao.selectOne("getCvtnDocNo");
					getAgreeNo = AgreeNo;
					mtenMap.put("CVTN_DOC_NO", getAgreeNo);
				} else {
					if (adm.equals("")) {
						docinfo.put("msg", "관리번호 부여 중 오류가 발생되었습니다. 관리자에게 문의하세요.");
						return docinfo;
					}
				}
//			} else if ("답변중".equals(PRGRS_STTS_SE_NM)) {
			} else if ("내부검토중".equals(PRGRS_STTS_SE_NM)) {
				
			} else if("외부검토중".equals(PRGRS_STTS_SE_NM)){
				ArrayList<String> sendUserList = new ArrayList();
				ArrayList<String> sendUserNmList = new ArrayList();
				String title = "";
				String cont = "";
				
				String CVTN_RQST_EMP_NM = agreeinfo.get("CVTN_RQST_EMP_NM")==null?"":agreeinfo.get("CVTN_RQST_EMP_NM").toString();
				String CVTN_RQST_DEPT_NM = agreeinfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeinfo.get("CVTN_RQST_DEPT_NM").toString();
				String CVTN_TKCG_EMP_NO = agreeinfo.get("CVTN_TKCG_EMP_NO")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NO").toString();
				String INSD_OTSD_TASK_SE = agreeinfo.get("INSD_OTSD_TASK_SE")==null?"":agreeinfo.get("INSD_OTSD_TASK_SE").toString();
				
				String CVTN_DOC_NO = agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString();
				String CVTN_TTL = agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString();
				
				mtenMap.put("EMP_NO", agreeinfo.get("CVTN_TKCG_EMP_NO")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NO").toString());
				String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
				sendUserList.add(empKey);
				sendUserNmList.add(agreeinfo.get("CVTN_TKCG_EMP_NM")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NM").toString());
				
				String empCall = commonDao.selectOne("agreeSql.getAgreeChrEmpInfo2", mtenMap);
				
				title = "[법률지원통합시스템] "+CVTN_DOC_NO+", "+CVTN_TTL+"에 대해 답변자로 "+mtenMap.get("usernm").toString()+"가 지정되었습니다.";
				cont = "귀하가 등록한 협약(외부)에 대해 "+mtenMap.get("usernm").toString()+"가 담당자로 지정되었음을 알려드립니다."
						+"향후 외부 고문변호사와 협약검토 진행 중 법률지원담당관에 문의사항이 있을 시, "+mtenMap.get("usernm").toString()+"에게 연락해주시기 바랍니다.<br/>"
						+ "<br/>"
						+ "변호사 연락처 : " + empCall;
				SendMail mail = new SendMail();
//				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
				
//			} else if ("팀장승인대기".equals(PRGRS_STTS_SE_NM)) {
			} else if ("팀장결재중".equals(PRGRS_STTS_SE_NM)) {
				// 팀장에게 알림 필요
				
//			} else if ("부장승인대기".equals(PRGRS_STTS_SE_NM)) {
			} else if ("과장결재중".equals(PRGRS_STTS_SE_NM)) {

			} else if ("만족도조사필요".equals(PRGRS_STTS_SE_NM)) {
			} else if ("만족도조사완료".equals(PRGRS_STTS_SE_NM)) {
				
			} else if ("완료".equals(PRGRS_STTS_SE_NM)) {
				String EMP_NO = commonDao.selectOne("agreeSql.selectAgreeChrEmp", mtenMap);
				HashMap taskMap = new HashMap();
				taskMap.put("EMP_NO", EMP_NO);
				taskMap.put("TASK_SE", "A7");
				taskMap.put("DOC_MNG_NO", CVTN_MNG_NO);
				taskMap.put("PRCS_YN", "N");
				int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
				if (cnt == 0) {
					mifService.setTask(taskMap);
				}
			}
			
			commonDao.update("agreeSql.updateAgreeState", mtenMap);
		} else {
			PRGRS_STTS_SE_NM = agreeinfo.get("PRGRS_STTS_SE_NM")==null?"":agreeinfo.get("PRGRS_STTS_SE_NM").toString();
			String INSD_OTSD_TASK_SE = agreeinfo.get("INSD_OTSD_TASK_SE")==null?"":agreeinfo.get("INSD_OTSD_TASK_SE").toString();
			mtenMap.put("PRGRS_STTS_SE_NM", PRGRS_STTS_SE_NM);
			mtenMap.put("INSD_OTSD_TASK_SE", INSD_OTSD_TASK_SE);
			
			commonDao.update("agreeSql.updateAgreeState", mtenMap);
		}
		docinfo.put("msg", "");
		return docinfo;
	}
	
	public JSONObject updateAgreeOpenyn(Map<String, Object> mtenMap) { // 공개여부 변경
		JSONObject docinfo = new JSONObject();
		String openyn = mtenMap.get("openyn")==null?"":mtenMap.get("openyn").toString();
		commonDao.update("agreeSql.updateAgreeOpenyn", mtenMap);
		return docinfo;
	}
	
	public JSONObject updateAgreeInout(Map<String, Object> mtenMap) { // 공개여부 변경
		JSONObject docinfo = new JSONObject();
		String inout = mtenMap.get("inout")==null?"":mtenMap.get("inout").toString();
		commonDao.update("agreeSql.updateAgreeInout", mtenMap);
		return docinfo;
	}
	
	public JSONObject agreeDelete(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("agreeSql.agreeDelete", mtenMap);
		result.put("msg", "ok");
		return result;
	}
	
	public List selectAgreeEmp(Map<String, Object> mtenMap) {
		return commonDao.selectList("agreeSql.selectAgreeEmpList", mtenMap);
	}
	
	public JSONObject setChrgEmpState(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		if (CVTN_MNG_NO.equals("")) {
			//commonDao.update("consultSql.setChrgEmpState", mtenMap);
		} else {
			commonDao.update("agreeSql.setChrgEmp", mtenMap);
			
			// 마지막 배정일자 업데이트
			commonDao.update("agreeSql.updateAltmntYmd", mtenMap);
			
			HashMap agreeinfo = commonDao.select("agreeSql.getAgreeDetail", mtenMap);
			String EMP_NO = mtenMap.get("userno")==null?"":mtenMap.get("userno").toString();
			String EMP_NM = mtenMap.get("usernm")==null?"":mtenMap.get("usernm").toString();
			
			String CVTN_RQST_EMP_NM = agreeinfo.get("CVTN_RQST_EMP_NM")==null?"":agreeinfo.get("CVTN_RQST_EMP_NM").toString();
			String CVTN_RQST_DEPT_NM = agreeinfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeinfo.get("CVTN_RQST_DEPT_NM").toString();
			String CVTN_TKCG_EMP_NO = agreeinfo.get("CVTN_TKCG_EMP_NO")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NO").toString();
			String INSD_OTSD_TASK_SE = agreeinfo.get("INSD_OTSD_TASK_SE")==null?"":agreeinfo.get("INSD_OTSD_TASK_SE").toString();
			String INOUTCONHAN = "";
			if ("O".equals(INSD_OTSD_TASK_SE)) {
				INOUTCONHAN = "외부자문";
			} else if ("I".equals(INSD_OTSD_TASK_SE)) {
				INOUTCONHAN = "내부자문";
			} else {
				INOUTCONHAN = "상관없음";
			}
			String CVTN_DOC_NO = agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString();
			String CVTN_TTL = agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString();
			
			ArrayList<String> sendUserList = new ArrayList();
			ArrayList<String> sendUserNmList = new ArrayList();
			String title = "";
			String cont = "";
			
			if ("I".equals(INSD_OTSD_TASK_SE)) {
				// 기존 지정 자문  검토 담당자 삭제처리
				commonDao.delete("agreeSql.deleteAgreeLawyer2", mtenMap);
				
				// 새로 지정된 자문팀 담당자를 동시에 자문 검토 담당자로 등록
				HashMap lawMap = new HashMap();
				lawMap.put("CVTN_MNG_NO", CVTN_MNG_NO);
				lawMap.put("INSD_OTSD_TASK_SE", "I");
				lawMap.put("chrgempno", mtenMap.get("userno"));
				lawMap.put("chrgempnm", mtenMap.get("usernm"));
				
				lawMap.put("writer",    mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
				lawMap.put("writerid",  mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
				lawMap.put("deptid",    mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
				lawMap.put("deptname",  mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
				commonDao.insert("agreeSql.insertAgreeLawyer2", lawMap);
				
				// 자문팀 담당자 등록시 검토자로도 자동 등록되니까 진행상태를 답변중으로 바로 변경해줌 // 추후 답변중으로 수동으로 상태 변경하게끔 변경한다면 이부분은 제거해야할듯.
				HashMap map = new HashMap();
				map.put("CVTN_MNG_NO", CVTN_MNG_NO);
//				map.put("PRGRS_STTS_SE_NM", "답변중");
				map.put("PRGRS_STTS_SE_NM", "내부검토중"); // 답변중을 내/외부 업무에 따라 내부검토중, 외부검토중으로 해주는게 맞는것 같아서 이렇게 수정
				commonDao.update("agreeSql.updateAgreeState", map);
				// 바로 접수되면서 답변둥으로 넘어가기 때문에 동시에 자문 접수 일자 업데이트 해주기 // CNSTN_RCPT_YMD
				map.put("PRGRS_STTS_SE_NM", "접수");
				commonDao.update("agreeSql.updateAgreeYmd", map);
				
				mtenMap.put("EMP_NO", agreeinfo.get("CVTN_TKCG_EMP_NO")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NO").toString());
				String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
				sendUserList.add(empKey);
				sendUserNmList.add(agreeinfo.get("CVTN_TKCG_EMP_NM")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NM").toString());
				
				String empCall = commonDao.selectOne("consultSql.getConsultChrEmpInfo", mtenMap);
				
				title = "[법률지원통합시스템] "+CVTN_DOC_NO+", "+CVTN_TTL+"에 대해 답변자로 "+mtenMap.get("usernm").toString()+"가 지정되었습니다.";
				cont = "귀하가 등록한 협약(내부)에 대해 "+mtenMap.get("usernm").toString()+"가 답변자로 지정되었음을 알려드립니다.<br/>"
						+ "<br/>"
						+ "변호사 연락처 : " + empCall;
				SendMail mail = new SendMail();
//				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
			} else {
				// 외부 바문의 경무 자문팀 담당자 등록시 검토자가 들어가있는지 확인하고 둘다 들어가있는 상태면 자동으로 진행상태 답변중으로 변경해줌 // 추후 답변중으로 수동으로 상태 변경하게끔 변경한다면 이부분은 제거해야할듯.
				int chkRvwPic = commonDao.selectOne("agreeSql.chkRvwPic", mtenMap);
				
				if (!INSD_OTSD_TASK_SE.equals("") && chkRvwPic > 0) {
					HashMap map = new HashMap();
					map.put("CVTN_MNG_NO", CVTN_MNG_NO);
					map.put("PRGRS_STTS_SE_NM", "외부검토중");
					commonDao.update("agreeSql.updateAgreeState", map);
					
					mtenMap.put("EMP_NO", agreeinfo.get("CVTN_TKCG_EMP_NO")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NO").toString());
					String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
					sendUserList.add(empKey);
					sendUserNmList.add(agreeinfo.get("CVTN_TKCG_EMP_NM")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NM").toString());
					
					String empCall = commonDao.selectOne("consultSql.getConsultChrEmpInfo2", mtenMap);
					
					title = "[법률지원통합시스템] "+CVTN_DOC_NO+", "+CVTN_TTL+"에 대해 답변자로 "+mtenMap.get("usernm").toString()+"가 지정되었습니다.";
					cont = "귀하가 등록한 협약(외부)에 대해 "+mtenMap.get("usernm").toString()+"가 담당자로 지정되었음을 알려드립니다."
							+"향후 외부 고문변호사와 협약검토 진행 중 법률지원담당관에 문의사항이 있을 시, "+mtenMap.get("usernm").toString()+"에게 연락해주시기 바랍니다.<br/>"
							+ "<br/>"
							+ "변호사 연락처 : " + empCall;
					SendMail mail = new SendMail();
//					mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
				}
			}

			sendUserList = new ArrayList();
			title = "";
			cont = "";
			mtenMap.put("EMP_NO", EMP_NO);
			String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
			sendUserList.add(empKey);
			sendUserNmList.add(EMP_NM);
			
			title = "[법률지원통합시스템] 신규 협약검토건이 지정되었습니다.("+INOUTCONHAN+", "+CVTN_DOC_NO+", "+CVTN_RQST_DEPT_NM+")";
			cont = cont + "법률지원통합시스템에 신규 협약검토건이 지정되었으니, 확인하여주시기 바랍니다.<br/>";
			cont = cont + "제목 : " + CVTN_TTL+"<br/>";
			cont = cont + "관리번호 : " + CVTN_DOC_NO+"<br/>";
			cont = cont + "의뢰직원 : " + CVTN_RQST_EMP_NM+"<br/>";
			cont = cont + "의뢰부서 : " + CVTN_RQST_DEPT_NM+"<br/>";
			cont = cont + "의뢰방법 : " + INOUTCONHAN;
			cont = cont + "의뢰내용 : " + (agreeinfo.get("CVTN_RQST_CN")==null?"":agreeinfo.get("CVTN_RQST_CN").toString());
			
			SendMail mail = new SendMail();
//			mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
			
			// 나의 할 일 추가 (C1)
			HashMap taskMap = new HashMap();
			taskMap.put("EMP_NO", mtenMap.get("userno")==null?"":mtenMap.get("userno").toString());
			taskMap.put("TASK_SE", "A1");
			taskMap.put("DOC_MNG_NO", CVTN_MNG_NO);
			taskMap.put("PRCS_YN", "N");
			int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
			if (cnt == 0) {
				mifService.setTask(taskMap);
			}
		}
		result.put("msg", "ok");
		return result;
	}
	
	public List selectAgreeLawyerList(Map mtenMap) {
		List list = commonDao.selectList("agreeSql.selectAgreeLawyerList", mtenMap);
		return list;
	}
	
	public List selectLawyerList2(Map mtenMap) {
		List list = commonDao.selectList("agreeSql.selectLawyerList2", mtenMap);
		return list;
	}
	
	public int selectLawyerTotal(Map mtenMap) {
		int cnt = commonDao.selectOne("agreeSql.selectLawyerTotal", mtenMap);
		return cnt;
	}
	
	public JSONObject agreeLawInfoSave(Map<String, Object> mtenMap) {
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		String INSD_OTSD_TASK_SE = mtenMap.get("INSD_OTSD_TASK_SE")==null?"":mtenMap.get("INSD_OTSD_TASK_SE").toString();
		String lawinfo = mtenMap.get("lawyerid")==null?"":mtenMap.get("lawyerid").toString();
		
		// 기존 지정 자문위원 법무법인 삭제처리
		commonDao.delete("agreeSql.deleteAgreeLawyer2", mtenMap);
		
		HashMap agreeinfo = commonDao.select("agreeSql.getAgreeDetail", mtenMap);
		String CVTN_DOC_NO = agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString();
		
		if (CVTN_DOC_NO.equals("")) {
			String AgreeNo = commonDao.selectOne("getCvtnDocNo");
			CVTN_DOC_NO = AgreeNo;
			mtenMap.put("CVTN_DOC_NO", CVTN_DOC_NO);
		}
//		mtenMap.put("PRGRS_STTS_SE_NM", "답변중");
		mtenMap.put("PRGRS_STTS_SE_NM", "외부검토중");
		commonDao.update("agreeSql.updateAgreeState", mtenMap);
		
		String[] lawArr = lawinfo.split(",");
		HashMap lawMap = new HashMap();
		lawMap.put("CVTN_MNG_NO", CVTN_MNG_NO);
		lawMap.put("INSD_OTSD_TASK_SE", INSD_OTSD_TASK_SE);
		
		lawMap.put("writer",    mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
		lawMap.put("writerid",  mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
		lawMap.put("deptid",    mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
		lawMap.put("deptname",  mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
		
		for(int i=0; i<lawArr.length; i++) {
			lawMap.put("advisorid", lawArr[i]);
			commonDao.insert("agreeSql.insertAgreeLawyer2", lawMap);

			lawMap.put("LWYR_MNG_NO", lawArr[i]);
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", lawMap);
			String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
			if(!mbl_no.equals("")) {
				String title = "서울시 협약검토 의뢰 안내";
				String msg = "서울시 "+(agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString())+
						", "+(agreeinfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeinfo.get("CVTN_RQST_DEPT_NM").toString())+
						"대한 협약검토 답변자로 지정되었습니다. 서울시 법률지원소통창구에 접속하시어 [승인], [거부]를 선택하여 주시기 바랍니다.";
//				SMSClientSend.sendSMS(mbl_no, title, msg);
			}
		}
		
		JSONObject docinfo = new JSONObject();
		docinfo.put("success", true);
		return docinfo;
	}
	
	public JSONObject deleteAgreeLawyer2(Map<String, Object> mtenMap) {
		commonDao.delete("agreeSql.deleteAgreeLawyer2", mtenMap);
		JSONObject docinfo = new JSONObject();
		docinfo.put("success", true);
		return docinfo;
	}
	
	public HashMap selectAgreeAnswerView(Map<String, Object> mtenMap) {
		return commonDao.selectOne("agreeSql.selectAgreeAnswerView", mtenMap);
	}
	
	public List selectAnswerBoard(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("agreeSql.selectAnswerBoard", mtenMap);
		return list;
	}
	
	public JSONObject answerSave(Map<String, Object> mtenMap){
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		String RVW_OPNN_MNG_NO = mtenMap.get("RVW_OPNN_MNG_NO")==null?"":mtenMap.get("RVW_OPNN_MNG_NO").toString();
		String AGRE_YN = mtenMap.get("AGRE_YN")==null?"":mtenMap.get("AGRE_YN").toString();
		String CVTN_CTRT_TYPE_CD_NM = mtenMap.get("CVTN_CTRT_TYPE_CD_NM")==null?"":mtenMap.get("CVTN_CTRT_TYPE_CD_NM").toString();
		String Grpcd = mtenMap.get("Grpcd")==null?"":mtenMap.get("Grpcd").toString();
		
		String lawfirm = mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString();
		String LwyrNm = mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString();
		
		if (RVW_OPNN_MNG_NO.equals("")) {
			commonDao.insert("agreeSql.insertAnswerBoard",mtenMap);
			
			RVW_OPNN_MNG_NO = mtenMap.get("RVW_OPNN_MNG_NO")==null?"":mtenMap.get("RVW_OPNN_MNG_NO").toString();
			
			commonDao.update("agreeSql.updateLawyerChckid", mtenMap);	// chckid update
		} else {
			commonDao.update("agreeSql.updateAnswerBoard", mtenMap);
			
			if(mtenMap.get("delfile[]")!=null){
				mtenMap.put("CVTN_MNG_NO", CVTN_MNG_NO);
				mtenMap.put("TRGT_PST_MNG_NO", RVW_OPNN_MNG_NO);
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("agreeSql.deleteFile", mtenMap);
					}
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("agreeSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		if (!CVTN_CTRT_TYPE_CD_NM.equals("의회 동의 여부 사전검토")) {
			AGRE_YN = "Y";
		}
		
		mtenMap.put("AGRE_YN", AGRE_YN);
		
		commonDao.update("agreeSql.setAgreYn", mtenMap);
		
		if (RVW_OPNN_MNG_NO.equals("")) {
			HashMap agreeinfo = commonDao.select("agreeSql.getAgreeDetail", mtenMap);
			
			if("X".equals(Grpcd)) {
				// 변호사가 등록했을 경우 내부변호사 나의할일에 추가
				HashMap taskMap = new HashMap();
				String EMP_NO = commonDao.selectOne("agreeSql.selectAgreeChrEmp", mtenMap);
				
				taskMap.put("EMP_NO", EMP_NO);
				taskMap.put("TASK_SE", "A6");
				taskMap.put("DOC_MNG_NO", CVTN_MNG_NO);
				taskMap.put("PRCS_YN", "N");
				int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
				if (cnt == 0) {
					mifService.setTask(taskMap);
				}
				
				// 13. 부서 자문등록자
				// 12. 법률자문팀 변호사
				ArrayList<String> sendUserList = new ArrayList();
				ArrayList<String> sendUserNmList = new ArrayList();
				HashMap tmpMap = new HashMap();
				tmpMap.put("EMP_NO", agreeinfo.get("CVTN_RQST_EMP_NO")==null?"":agreeinfo.get("CVTN_RQST_EMP_NO").toString());
				sendUserList.add(commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap));
				sendUserNmList.add(agreeinfo.get("CVTN_RQST_EMP_NM")==null?"":agreeinfo.get("CVTN_RQST_EMP_NM").toString());
				
				tmpMap.put("EMP_NO", agreeinfo.get("CVTN_TKCG_EMP_NO")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NO").toString());
				sendUserList.add(commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap));
				sendUserNmList.add(agreeinfo.get("CVTN_TKCG_EMP_NM")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NM").toString());
				
				String title = "[법률지원통합시스템] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+
						", "+(agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString())+
						"에 대해 "+(lawfirm+" "+LwyrNm)+"가 답변을 등록하였습니다.";
				String cont = "법률지원통합시스템에 답변이 등록되었으니, 확인하여주시기 바랍니다.<br/><br/>";
				cont = cont + "제목 : " + (agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+" "+(agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString())+"<br/>";
				cont = cont + "부서 : " + (agreeinfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeinfo.get("CVTN_RQST_DEPT_NM").toString())+" "+(agreeinfo.get("CVTN_RQST_EMP_NM")==null?"":agreeinfo.get("CVTN_RQST_EMP_NM").toString())+"<br/>";
				cont = cont + "고문변호사 : " + (lawfirm+" "+LwyrNm);
				SendMail mail = new SendMail();
//				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		docinfo.put("RVW_OPNN_MNG_NO", RVW_OPNN_MNG_NO);
		return docinfo;
	}
	
	public JSONObject deleteAnswer(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("agreeSql.deleteFile", mtenMap);
		commonDao.delete("agreeSql.deleteAnswer", mtenMap);
		
		// 검토 담당자 정보에서 RVW_OPNN_MNG_NO(검토의견 관리 번호) 제거
		HashMap param = new HashMap();
		param.put("RVW_OPNN_MNG_NO", "");
		param.put("CONSULTLAWYERID", mtenMap.get("CONSULTLAWYERID")==null?"":mtenMap.get("CONSULTLAWYERID").toString());
		commonDao.update("agreeSql.updateLawyerChckid", param);
		
		result.put("msg", "ok");
		return result;
	}
	
	public JSONObject answerResultSave(Map<String, Object> mtenMap){
		String INSD_OTSD_TASK_SE = mtenMap.get("INSD_OTSD_TASK_SE")==null?"":mtenMap.get("INSD_OTSD_TASK_SE").toString();
		String statenm = "답변완료";
		
//		if ("O".equals(INSD_OTSD_TASK_SE)) {
//			statenm = "만족도평가필요";
//		}
		commonDao.update("agreeSql.answerResultSave", mtenMap);
		
		HashMap param = new HashMap();
		param.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
		param.put("gbn", "N");
//		List lawyerList = commonDao.selectList("agreeSql.selectAgreeLawyerList", param);
//		List answerList = commonDao.selectList("agreeSql.selectAnswerBoard", param);
//		
//		int lawyerCnt = lawyerList.size();	// 총 자문위원 수
//		
//		int lawFlg = 0;
//		int anFlg = 0;
//		// 모든 자문 위원 데이터에 chckid가 있는가?
//		for (int l=0; l<lawyerCnt; l++) {
//			HashMap map = (HashMap) lawyerList.get(l);
//			String chckid = map.get("RVW_OPNN_MNG_NO")==null?"":map.get("RVW_OPNN_MNG_NO").toString();
//			
//			if(chckid.equals("")) {
//				lawFlg = lawFlg+1;
//			}
//		}
//		
//		// 모든 자문 위원의 답변 결과가 != 답변등록 인가?
//		for(int a=0; a<answerList.size(); a++) {
//			HashMap map = (HashMap) answerList.get(a);
//			String ansresult = map.get("RVW_OPNN_CMPTN_YN")==null?"":map.get("RVW_OPNN_CMPTN_YN").toString();
//			
//			if("N".equals(ansresult)) {
//				anFlg = anFlg+1;
//			}
//		}
//		
//		if ((lawyerList.size() == answerList.size()) && lawFlg == 0 && anFlg == 0) {
			// CONSULT 테이블 STATECD를 답변완료로 변경해야함!!!
		param = new HashMap();
		param.put("CVTN_MNG_NO", mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
//			param.put("PRGRS_STTS_SE_NM", statenm);
		if ("I".equals(INSD_OTSD_TASK_SE)) {
			statenm = "팀장결재중";
			param.put("PRGRS_STTS_SE_NM", statenm);
			//250618(알림필요)_내부의 경우 답변등록하고 완료 후 바로 팁장결재로 넘어가게 해야함 
		}else {
			param.put("PRGRS_STTS_SE_NM", statenm);
		}
		commonDao.update("agreeSql.updateAgreeState", param);
		
		// 답변완료료 상태 변경될시에 자문회신일자 업데이트 해주기
		commonDao.update("agreeSql.updateRplyYmd", param);
//		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject selectMemoList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("agreeSql.selectMemoList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public HashMap selectAgreeMemoView(Map<String, Object> mtenMap) {
		return commonDao.selectOne("agreeSql.selectAgreeMemoView", mtenMap);
	}
	
	public JSONObject saveMemoInfo(Map<String, Object> mtenMap){
		String CVTN_MEMO_MNG_NO = mtenMap.get("CVTN_MEMO_MNG_NO")==null?"":mtenMap.get("CVTN_MEMO_MNG_NO").toString();
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		String Grpcd = mtenMap.get("Grpcd")==null?"":mtenMap.get("Grpcd").toString();
		if (CVTN_MEMO_MNG_NO.equals("")) {
			commonDao.insert("agreeSql.insertAgreeMemo",mtenMap);
			CVTN_MEMO_MNG_NO = mtenMap.get("CVTN_MEMO_MNG_NO")==null?"":mtenMap.get("CVTN_MEMO_MNG_NO").toString();
			mtenMap.put("TRGT_PST_MNG_NO", CVTN_MEMO_MNG_NO);
		} else {
			commonDao.update("agreeSql.updateAgreeMemo", mtenMap);
			
			if(mtenMap.get("delfile[]")!=null){
				mtenMap.put("CVTN_MNG_NO", CVTN_MNG_NO);
				mtenMap.put("TRGT_PST_MNG_NO", CVTN_MEMO_MNG_NO);
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("agreeSql.deleteFile", mtenMap);
					}
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("agreeSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}

		if (CVTN_MEMO_MNG_NO.equals("")) {
			HashMap agreeinfo = commonDao.select("agreeSql.getAgreeDetail", mtenMap);
			if ("X".equals(Grpcd)) {
				// 변호사가 등록했을 경우 내부변호사 나의할일에 추가
				HashMap taskMap = new HashMap();
				String EMP_NO = commonDao.selectOne("agreeSql.selectAgreeChrEmp", mtenMap);
				
				taskMap.put("EMP_NO", EMP_NO);
				taskMap.put("TASK_SE", "A5");
				taskMap.put("DOC_MNG_NO", CVTN_MNG_NO);
				taskMap.put("PRCS_YN", "N");
				int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
				if (cnt == 0) {
					mifService.setTask(taskMap);
				}
				
				ArrayList<String> sendUserList = new ArrayList();
				ArrayList<String> sendUserNmList = new ArrayList();
				
				HashMap tmpMap = new HashMap();
				tmpMap.put("EMP_NO", agreeinfo.get("CVTN_RQST_EMP_NO")==null?"":agreeinfo.get("CVTN_RQST_EMP_NO").toString());
				sendUserList.add(commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap));
				sendUserNmList.add(agreeinfo.get("CVTN_RQST_EMP_NM")==null?"":agreeinfo.get("CVTN_RQST_EMP_NM").toString());
				
				tmpMap.put("EMP_NO", agreeinfo.get("CVTN_TKCG_EMP_NO")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NO").toString());
				sendUserList.add(commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap));
				sendUserNmList.add(agreeinfo.get("CVTN_TKCG_EMP_NM")==null?"":agreeinfo.get("CVTN_TKCG_EMP_NM").toString());
				
				String title = "[법률지원통합시스템] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+"에 의견이 등록되었습니다.";
				String cont = (agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+
						"에 의견이 등록되었으니, 법률지원통합시스템에 접속하여 확인하시기 바랍니다.";
				SendMail mail = new SendMail();
//				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
			} else {
				List lawyerList = commonDao.selectList("agreeSql.selectAgreeLawyerList", mtenMap);
				if(lawyerList.size() > 0) {
					for(int i=0; i<lawyerList.size(); i++) {
						HashMap lawyerMap = (HashMap)lawyerList.get(i);
						lawyerMap.put("LWYR_MNG_NO", lawyerMap.get("RVW_TKCG_EMP_NO")==null?"":lawyerMap.get("RVW_TKCG_EMP_NO").toString());
						HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", lawyerMap);
						
						String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
						if(!mbl_no.equals("")) {
							String title = "[서울시 법률지원소통창구]"+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+" 의견 등록 알림";
							String msg = (agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+"에 의견이 등록되었으니, 법률지원소통창구에 접속하여 확인하시기 바랍니다.";
//							SMSClientSend.sendSMS(mbl_no, title, msg);
						}
					}
				}
			}
		}
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		docinfo.put("CVTN_MEMO_MNG_NO", CVTN_MEMO_MNG_NO);
		return docinfo;
	}
	
	public JSONObject deleteMemo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		mtenMap.put("TRGT_PST_MNG_NO", mtenMap.get("CVTN_MEMO_MNG_NO")==null?"":mtenMap.get("CVTN_MEMO_MNG_NO").toString());
		commonDao.delete("agreeSql.deleteFile", mtenMap);
		commonDao.delete("agreeSql.deleteAgreeMemo", mtenMap);
		
		result.put("msg", "ok");
		return result;
	}
	
	public List getProcSatisList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("agreeSql.getProcSatisList", mtenMap);
		return list;
	}
	public List getSatisfactionList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("agreeSql.getSatisfactionList", mtenMap);
		return list;
	}
	public List getSatisitemList2(Map<String, Object> mtenMap) {
		mtenMap.put("SRVY_SE", "AGR");
		List list = commonDao.selectList("suitSql.getSatisitemList", mtenMap);
		return list;
	}
	public List getLawyerList2(Map<String, Object> mtenMap) {
		//List list = commonDao.selectList("suitSql.getLawyerList", mtenMap);
		List list = commonDao.selectList("agreeSql.selectConsultLawyerList", mtenMap);
		return list;
	}
	
	public String getCvtnCtrtTypeNm(Map<String, Object> mtenMap) {
		return commonDao.selectOne("agreeSql.getCvtnCtrtTypeNm", mtenMap);
	}
	
	public JSONObject agreeResultSave(Map<String, Object> mtenMap){
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		commonDao.update("agreeSql.agreeResultSave", mtenMap);
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		docinfo.put("CVTN_MNG_NO", CVTN_MNG_NO);
		return docinfo;
	}
	
	public HashMap selectAgreeResult(Map<String, Object> mtenMap) {
		return commonDao.selectOne("agreeSql.selectAgreeResult", mtenMap);
	}

	public HashMap getOutAgreeCnt (Map<String, Object> mtenMap) {
		
		return commonDao.selectOne("agreeSql.getOutAgreeCnt", mtenMap);
		
	}
	
	public JSONObject selectOutAgreeList(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("agreeSql.selectOutAgreeList", mtenMap);
		int cnt = commonDao.select("agreeSql.selectOutAgreeListTotal", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject setAgreeCost(Map<String, Object> mtenMap){
		String CVTN_CST_MNG_NO = mtenMap.get("CVTN_CST_MNG_NO")==null?"":mtenMap.get("CVTN_CST_MNG_NO").toString();
		
		if (CVTN_CST_MNG_NO.equals("")) {
			commonDao.insert("agreeSql.insertAgreeCost", mtenMap);
		} else {
			commonDao.update("agreeSql.updateAgreeCost", mtenMap);
		}
		
		HashMap agreeinfo = commonDao.select("agreeSql.getAgreeDetail", mtenMap);
		String CST_PRGRS_STTS_SE = mtenMap.get("CST_PRGRS_STTS_SE")==null?"R":mtenMap.get("CST_PRGRS_STTS_SE").toString();
		if("R".equals(CST_PRGRS_STTS_SE) || "Z".equals(CST_PRGRS_STTS_SE)) {
			String title = "[법률지원통합시스템] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+" 사건의 협약비용 지급요청건이 있습니다.";
			String cont = "";
			cont = cont + "아래 사건에 대해 협약비용 지급 요청이 있으니, 법률지원통합시스템에 접속하여 확인하여주시기 바랍니다.<br/>";
			cont = cont + "자문상세 메뉴에서 협약비용 지급 요청내용을 확인하시고, 이상이 없을 경우 [승인] 버튼을, 보완이 필요할 경우 [보완]버튼을 클릭하여 주시기 바랍니다.<br/>";
			cont = cont + "자문정보 : "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+" "+(agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString())+"<br/>";
			cont = cont + "요청 비용 : "+(mtenMap.get("CVTN_CST_AMT")==null?"":mtenMap.get("CVTN_CST_AMT").toString());
			
			ArrayList<String> sendUserList = new ArrayList();
			ArrayList<String> sendUserNmList = new ArrayList();
			
			HashMap mailMap = new HashMap();
			mailMap.put("MNGR_AUTHRT_NM", "F");
			List empList = commonDao.selectList("suitSql.getChrgEmpInfo4", mailMap);
			
			if (empList.size() > 0) {
				for(int i=0; i<empList.size(); i++) {
					HashMap empMap = (HashMap)empList.get(i);
					sendUserList.add(empMap.get("EMP_PK_NO")==null?"":empMap.get("EMP_PK_NO").toString());
					sendUserNmList.add(empMap.get("EMP_NM")==null?"":empMap.get("EMP_NM").toString());
				}
			}
			SendMail mail = new SendMail();
//			mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
		}
		
		if("C".equals(CST_PRGRS_STTS_SE)) {
			// 지급 안내
			// RVW_TKCG_EMP_NO
			// [서울시 법률지원소통창구] {사건번호} 자문료 지급완료
			// [서울시 법률지원소통창구] {사건번호} 자문료 지급 요청건에 대해 지급이 완료되었습니다.
			// {지급 금액, 지급 항목 등}
			mtenMap.put("LWYR_MNG_NO", mtenMap.get("RVW_TKCG_EMP_NO")==null?"":mtenMap.get("RVW_TKCG_EMP_NO").toString());
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", mtenMap);
			String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
			if(!mbl_no.equals("")) {
				String title = "[서울시 법률지원소통창구] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+" 자문료 지급완료";
				String msg = "[서울시 법률지원소통창구] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+
							" 자문료 지급 요청건에 대해 지급이 완료되었습니다. (지급 금액 : "+
							(mtenMap.get("CVTN_CST_AMT")==null?"":mtenMap.get("CVTN_CST_AMT").toString())+")";
//				SMSClientSend.sendSMS(mbl_no, title, msg);
			}
		}
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject setCostInfo(Map<String, Object> mtenMap){
		commonDao.update("agreeSql.setCostInfo", mtenMap);
		

		String CST_PRGRS_STTS_SE = mtenMap.get("CST_PRGRS_STTS_SE")==null?"":mtenMap.get("CST_PRGRS_STTS_SE").toString();
		String RVW_TKCG_EMP_NO = mtenMap.get("RVW_TKCG_EMP_NO")==null?"":mtenMap.get("RVW_TKCG_EMP_NO").toString();
		if("X".equals(CST_PRGRS_STTS_SE)) {
			// 보완요청
			// 외부변호사에게 문자 발송
			mtenMap.put("LWYR_MNG_NO", RVW_TKCG_EMP_NO);
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", mtenMap);
			
			String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
			if(!mbl_no.equals("")) {
				String title = "[서울시 법률지원소통창구] 자문료 지급요청건 보완 필요";
				String msg = "[서울시 법률지원소통창구] 자문료 지급요청건의 보완이 필요합니다. 자세한 내용은 서울시 법률지원소통창구에 접속하여 확인바랍니다.";
//				SMSClientSend.sendSMS(mbl_no, title, msg);
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	// 목록화면 통계 그림 위한 전체 건수 조회
	public int selectStateTotalCnt(Map<String, Object> mtenMap) {
		int cnt = commonDao.select("agreeSql.selectStateTotalCnt", mtenMap);
		return cnt;
	}
	
	// 목록화면 통계 그림 위한 진행상태별 건수 조회
	public List selectStateCnt(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("agreeSql.selectStateCnt", mtenMap);
		return list;
	}

	public static HashMap keyChangeUpperMap(Map param) {
		Iterator<String> iteratorKey = param.keySet().iterator(); // 키값 오름차순
		HashMap newMap = new HashMap();
		// //키값 내림차순 정렬
		while (iteratorKey.hasNext()) {
			String key = iteratorKey.next();
			if(!(key.equals("writerid")||key.equals("writer")||key.equals("deptid")||key.equals("deptname")||key.equals("grpcd"))) {
				newMap.put(key.toUpperCase(), param.get(key));
			}
		}
		return newMap;
	}
	
	public String saveFileDll(MultipartHttpServletRequest multipartRequest, Map<String, Object> mtenMap){
		Iterator<String> itr = multipartRequest.getFileNames();
		String filePath = mtenMap.get("filePath")==null?"":mtenMap.get("filePath").toString();
		
		Map<String, Object> UPP = this.keyChangeUpperMap(mtenMap);
		
		String result = "";
		Map map = new HashMap<String, Object>();
		
		mtenMap = UPP;
		
		String [] noList = {"exe", "bat", "sh", "java", "jsp", "html", "js", "css", "xml"};
		int noLeng = noList.length;
		boolean noFlg = true;
		
		while (itr.hasNext()) {
			String FILEID = commonDao.selectOne("agreeSql.getFileIdKey");
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			
			String originalFilename = mpf.getOriginalFilename(); // 파일명
			long fileSize = mpf.getSize();
			String FileSize = String.valueOf(fileSize);
			
			String fileids = FILEID + "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length()));
			
			String fileFullPath = filePath + fileids;
			String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length());
			String fileSe = mtenMap.get("FILE_SE") == null ? "" : mtenMap.get("FILE_SE").toString();
			
			for(int i=0; i<noLeng; i++){
				if(ext.equalsIgnoreCase(noList[i])){
					noFlg = false;
				}
			}
			
			if(noFlg == true){
				try {
					boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
					if(pchk) {
						map = new HashMap<String, Object>();
						
						map.put("FILE_MNG_NO",      FILEID);
						map.put("CVTN_MNG_NO",      mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
						map.put("TRGT_PST_MNG_NO",  mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString());
						map.put("TRGT_PST_TBL_NM",  "TB_CVTN_MNG");
						map.put("FILE_SE_NM",       fileSe);
						map.put("FILE_SE",          fileSe);
						map.put("DWNLD_FILE_NM", "검토의뢰서" + "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length())));
						map.put("SRVR_FILE_NM", FILEID + "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length())));
						map.put("PHYS_FILE_NM", "검토의뢰서" + "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length())));
						map.put("FILE_EXTN_NM", ext);
						map.put("FILE_SZ", FileSize);
						map.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
						map.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
						map.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
						map.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
						
						commonDao.insert("agreeSql.insertFile", map);
					}else {
						System.out.println("파일업로드 실패");
						result = "FAIL";
					}
					
				} catch (IOException e) {
					System.out.println("파일업로드 실패");
					e.printStackTrace();
				}
			}else{
				result = "FAIL";
			}
		}
		
		return result;
	}
	
	// 협약 답변 검토 의견 정보 조회
	public HashMap selectAgreeReviewComment(Map<String, Object> mtenMap) {
		return commonDao.selectOne("agreeSql.selectAgreeReviewComment", mtenMap);
	}
	
	// 협약 답변 검토 의견 내용 저장 수정
	public JSONObject saveReviewComment(Map<String, Object> mtenMap){
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		
		commonDao.update("agreeSql.updateAgreetReviewComment", mtenMap);
		mtenMap.put("gbnid", CVTN_MNG_NO);
		if(mtenMap.get("delfile[]")!=null){
			mtenMap.put("gbnid", CVTN_MNG_NO);
			if(mtenMap.get("delfile[]").getClass().equals(String.class)){
				if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
					mtenMap.put("fileid", mtenMap.get("delfile[]"));
					commonDao.delete("agreeSql.deleteFile", mtenMap);
				}
			}else{
				ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
				for(int i=0; i<delfile.size(); i++){
					if(delfile.get(i) != null && !delfile.get(i).equals("")){
						mtenMap.put("fileid", delfile.get(i));
						commonDao.delete("agreeSql.deleteFile", mtenMap);
					}
				}
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject deleteReviewComment(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		commonDao.delete("agreeSql.deleteGbnFile", mtenMap);
		mtenMap.put("CVTN_ANS_RVW_OPNN_CN", "");
		commonDao.delete("agreeSql.updateConsultReviewComment", mtenMap);
		
		result.put("msg", "ok");
		return result;
	}

	public JSONObject rfslRsnSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String RCPT_YN = mtenMap.get("RCPT_YN")==null?"":mtenMap.get("RCPT_YN").toString();
		String DOC_PK = mtenMap.get("DOC_PK")==null?"":mtenMap.get("DOC_PK").toString();
		String LWYR_NM = mtenMap.get("LWYR_NM")==null?"":mtenMap.get("LWYR_NM").toString();
		String EMP_NO = commonDao.selectOne("agreeSql.selectAgreeChrEmp", mtenMap);
		String sendyn = "";
		
		HashMap taskMap = new HashMap();
		taskMap.put("EMP_NO", EMP_NO);
		taskMap.put("DOC_MNG_NO", DOC_PK);
		taskMap.put("PRCS_YN", "N");
		
		mtenMap.put("CVTN_MNG_NO", DOC_PK);
		HashMap agreeinfo = commonDao.select("agreeSql.getAgreeDetail", mtenMap);
		
		if ("N".equals(RCPT_YN)) {
			// 담당자 알림 전송 (문자 or 매신저 or 메일)
			// 진행상태 돌리기 (-> 접수)
			mtenMap.put("PRGRS_STTS_SE_NM", "접수");
			commonDao.update("agreeSql.updateAgreeStateRfslRsn", mtenMap);
			sendyn = "거부";
			taskMap.put("TASK_SE", "A3");
		} else {
			sendyn = "승인";
			taskMap.put("TASK_SE", "A4");
			
			String cont = "";
			ArrayList<String> sendUserList = new ArrayList();
			ArrayList<String> sendUserNmList = new ArrayList();
			
			HashMap tmpMap = new HashMap();
			tmpMap.put("EMP_NO", agreeinfo.get("CVTN_RQST_EMP_NO")==null?"":agreeinfo.get("CVTN_RQST_EMP_NO").toString());
			String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap);
			
			tmpMap.put("LWYR_MNG_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", tmpMap);
			
			sendUserNmList.add(agreeinfo.get("CVTN_RQST_EMP_NM")==null?"":agreeinfo.get("CVTN_RQST_EMP_NM").toString());
			sendUserList.add(empKey);
			//[법률지원통합시스템] {관리번호}, {제목}에 대한 고문변호사로 {고문변호사명}이/가 지정되었습니다.
			// 귀하가 등록한 법률자문(외부)에 대해 {고문변호사}가 고문변호사로 지정되었음을 알려드립니다.
			//{고문변호사 연락처 정보}
			String title = "[법률지원통합시스템] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+
					", "+(agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString())+
					"에 대한 고문변호사로 "+LWYR_NM+"이/가 지정되었습니다.";
			cont = "귀하가 등록한 협약검토(외부)에 대해 "+LWYR_NM+"가 고문변호사로 지정되었음을 알려드립니다.<br/>";
			cont = cont + "개인연락처 : "   + (mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString()) + "<br/>";
			cont = cont + "사무실연락처 : " + (mbl.get("OFC_TELNO")==null?"":mbl.get("OFC_TELNO").toString()) + "<br/>";
			cont = cont + "이메일 : "       + (mbl.get("EML_ADDR")==null?"":mbl.get("EML_ADDR").toString());
			SendMail mail = new SendMail();
//			mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
		}
		
		int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
		if (cnt == 0) {
			mifService.setTask(taskMap);
		}
		
		commonDao.update("agreeSql.setRfslRsn", mtenMap);
		
		HashMap map = new HashMap();
		map.put("GRPCD", "R");
		List teamReader = commonDao.selectList("consultSql.selectConsultTeamReader", map);
		
		// 메일발송
		if (teamReader.size() > 0) {
			ArrayList<String> sendUserList = new ArrayList();
			ArrayList<String> sendUserNmList = new ArrayList();
			
			for(int i=0; i<teamReader.size(); i++) {
				HashMap map2 = (HashMap)teamReader.get(i);
				sendUserList.add(map2.get("EMP_PK_NO")==null?"":map2.get("EMP_PK_NO").toString());
				sendUserNmList.add(map2.get("EMP_NM")==null?"":map2.get("EMP_NM").toString());
			}
			
			String title = "[법률지원통합시스템] 외부 협약검토에 대해 "+LWYR_NM+
					"이/가 "+sendyn+"하였습니다. ("+
					(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+", "+
					(agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString())+", "+
					(agreeinfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeinfo.get("CVTN_RQST_DEPT_NM").toString())+")";
			
			String cont = "외부 협약검토 건에 대해 "+LWYR_NM+"이/가 "+sendyn+"하였습니다. 후속 절차를 진행해주시기 바랍니다.<br/><br/>";
			cont = cont + "관리번호 : "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+"<br/>";
			cont = cont + "제목 : "+(agreeinfo.get("CVTN_TTL")==null?"":agreeinfo.get("CVTN_TTL").toString())+"<br/>";
			cont = cont + "부서 : "+(agreeinfo.get("CVTN_RQST_DEPT_NM")==null?"":agreeinfo.get("CVTN_RQST_DEPT_NM").toString())+"<br/>";
			cont = cont + "작성자 : "+(agreeinfo.get("CVTN_RQST_EMP_NM")==null?"":agreeinfo.get("CVTN_RQST_EMP_NM").toString());
			
			SendMail mail = new SendMail();
//			mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
		}
		
		result.put("msg", "ok");
		return result;
	}
	
//	public String getCnt1() {
	public HashMap getCnt1() {
		return commonDao.select("agreeSql.getMainAgreeCnt1");
	}
	
	public HashMap getCnt2(String userId) {
		return commonDao.select("agreeSql.getMainAgreeCnt2", userId);
	}
	
	public String getCnt3() {
		Date now = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String formatedNow = formatter.format(now);
		
		HashMap map = new HashMap();
		map.put("start", formatedNow);
		map.put("end", formatedNow);
		map.put("gbn", "S");
		List calList = commonDao.selectList("agreeSql.selectCalData", map);
		
		String calCnt = calList.size()+"";
		return calCnt;
	}
	
	public List selectAgreeMainList1(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("agreeSql.selectAgreeMainList", mtenMap);
		return list;
	}
	
	public List selectAgreeMainList2(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("agreeSql.selectAgreeMainList", mtenMap);
		return list;
	}
	
	public HashMap selectMainAgrCnt(String userId) {
		return commonDao.select("agreeSql.selectMainAgrCnt", userId);
	}
	
	
	
	
	

	public List selectAgreeChrgCost(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("agreeSql.selectAgreeChrgCost", mtenMap);
		return list;
	}
	
	public JSONObject updateChrgLawyerAmt(Map<String, Object> mtenMap) {
		String CST_PRGRS_STTS_SE = mtenMap.get("CST_PRGRS_STTS_SE")==null?"":mtenMap.get("CST_PRGRS_STTS_SE").toString();
		String RVW_TKCG_EMP_NO = mtenMap.get("RVW_TKCG_EMP_NO")==null?"":mtenMap.get("RVW_TKCG_EMP_NO").toString();
		String CVTN_MNG_NO = mtenMap.get("CVTN_MNG_NO")==null?"":mtenMap.get("CVTN_MNG_NO").toString();
		
		commonDao.update("agreeSql.updateChrgLawyerAmt", mtenMap);
		
		if("X".equals(CST_PRGRS_STTS_SE)) {
			// 보완요청
			// 외부변호사에게 문자 발송
			mtenMap.put("LWYR_MNG_NO", RVW_TKCG_EMP_NO);
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", mtenMap);
			
			String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
			if(!mbl_no.equals("")) {
				String title = "[서울시 법률지원소통창구] 자문료 지급요청건 보완 필요";
				String msg = "[서울시 법률지원소통창구] 자문료 지급요청건의 보완이 필요합니다. 자세한 내용은 서울시 법률지원소통창구에 접속하여 확인바랍니다.";
//				SMSClientSend.sendSMS(mbl_no, title, msg);
			}
		}
		
		if("C".equals(CST_PRGRS_STTS_SE)) {
			// 지급 안내
			// RVW_TKCG_EMP_NO
			// [서울시 법률지원소통창구] {사건번호} 자문료 지급완료
			// [서울시 법률지원소통창구] {사건번호} 자문료 지급 요청건에 대해 지급이 완료되었습니다.
			// {지급 금액, 지급 항목 등}
			HashMap agreeinfo = commonDao.select("agreeSql.getAgreeDetail", mtenMap);
			
			mtenMap.put("LWYR_MNG_NO", RVW_TKCG_EMP_NO);
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", mtenMap);
			String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
			if(!mbl_no.equals("")) {
				String title = "[서울시 법률지원소통창구] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+" 자문료 지급완료";
				String msg = "[서울시 법률지원소통창구] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+
						" 자문료 지급 요청건에 대해 지급이 완료되었습니다. (지급 금액 : "+
						(mtenMap.get("CVTN_CST_AMT")==null?"":mtenMap.get("CVTN_CST_AMT").toString())+")";
//				SMSClientSend.sendSMS(mbl_no, title, msg);
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject updateChrgLawyerAmtList(Map<String, Object> mtenMap) {
		String CST_PRGRS_STTS_SE    = mtenMap.get("CST_PRGRS_STTS_SE")==null?"":mtenMap.get("CST_PRGRS_STTS_SE").toString();
		
		List CVTN_CST_MNG_NO_LIST  = new ArrayList();
		List CVTN_MNG_NO_LIST      = new ArrayList();
		List RVW_TKCG_EMP_NO_LIST   = new ArrayList();
		List CVTN_CST_AMT_LIST     = new ArrayList();
		
		if (mtenMap.get("CVTN_CST_MNG_NO_LIST[]") != null) {
			if (mtenMap.get("CVTN_CST_MNG_NO_LIST[]").getClass().equals(String.class)) {
				if (mtenMap.get("CVTN_CST_MNG_NO_LIST[]") != null && !mtenMap.get("CVTN_CST_MNG_NO_LIST[]").toString().equals("")) {
					CVTN_CST_MNG_NO_LIST.add(mtenMap.get("CVTN_CST_MNG_NO_LIST[]"));
					CVTN_MNG_NO_LIST.add(mtenMap.get("CVTN_MNG_NO_LIST[]"));
					RVW_TKCG_EMP_NO_LIST.add(mtenMap.get("RVW_TKCG_EMP_NO_LIST[]"));
					CVTN_CST_AMT_LIST.add(mtenMap.get("CVTN_CST_AMT_LIST[]"));
				}
			} else {
				CVTN_CST_MNG_NO_LIST  = mtenMap.get("CVTN_CST_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("CVTN_CST_MNG_NO_LIST[]");
				CVTN_MNG_NO_LIST      = mtenMap.get("CVTN_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("CVTN_MNG_NO_LIST[]");
				RVW_TKCG_EMP_NO_LIST   = mtenMap.get("RVW_TKCG_EMP_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("RVW_TKCG_EMP_NO_LIST[]");
				CVTN_CST_AMT_LIST     = mtenMap.get("CVTN_CST_AMT_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("CVTN_CST_AMT_LIST[]");
			}
		}
		
		HashMap costMap = new HashMap();
		for(int c=0; c<CVTN_CST_MNG_NO_LIST.size(); c++) {
			costMap = new HashMap();
			String CVTN_CST_MNG_NO = CVTN_CST_MNG_NO_LIST.get(c).toString();
			String CVTN_MNG_NO     = CVTN_MNG_NO_LIST.get(c).toString();
			String RVW_TKCG_EMP_NO = RVW_TKCG_EMP_NO_LIST.get(c).toString();
			String CVTN_CST_AMT    = CVTN_CST_AMT_LIST.get(c).toString();
			
			costMap.put("CVTN_MNG_NO", CVTN_MNG_NO);
			costMap.put("CVTN_CST_MNG_NO", CVTN_CST_MNG_NO);
			costMap.put("CST_PRGRS_STTS_SE", CST_PRGRS_STTS_SE);
			costMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
			costMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
			costMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
			costMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
			
			commonDao.update("agreeSql.updateChrgLawyerAmt", costMap);
			
			if("C".equals(CST_PRGRS_STTS_SE)) {
				// 지급 안내
				// RVW_TKCG_EMP_NO
				// [서울시 법률지원소통창구] {사건번호} 자문료 지급완료
				// [서울시 법률지원소통창구] {사건번호} 자문료 지급 요청건에 대해 지급이 완료되었습니다.
				// {지급 금액, 지급 항목 등}
				HashMap agreeinfo = commonDao.select("agreeSql.getAgreeDetail", costMap);
				
				costMap.put("LWYR_MNG_NO", RVW_TKCG_EMP_NO);
				HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", costMap);
				String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
				if(!mbl_no.equals("")) {
					String title = "[서울시 법률지원소통창구] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+" 자문료 지급완료";
					String msg = "[서울시 법률지원소통창구] "+(agreeinfo.get("CVTN_DOC_NO")==null?"":agreeinfo.get("CVTN_DOC_NO").toString())+
							" 자문료 지급 요청건에 대해 지급이 완료되었습니다. (지급 금액 : "+
							(CVTN_CST_AMT)+")";
//					SMSClientSend.sendSMS(mbl_no, title, msg);
				}
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject updateAgreeState2(Map<String, Object> mtenMap) { // 우측 상단 전체관리자 진행상황변경 콤보박스
		JSONObject docinfo = new JSONObject();
		
		String adm = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String consultid = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String statcd = mtenMap.get("statcd")==null?"":mtenMap.get("statcd").toString();
		
		commonDao.update("agreeSql.updateAgreeState2", mtenMap);
		docinfo.put("msg", "");
		return docinfo;
	}

	public String getOutRcptYn(Map<String, Object> mtenMap) {
		return commonDao.selectOne("agreeSql.getOutRcptYn", mtenMap);
	}
	
	public List selectRqstChangEmpList(Map<String, Object> mtenMap) {
		return commonDao.selectList("agreeSql.selectRqstChangEmpList", mtenMap);
	}
	
	public JSONObject agreeRqstChang(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		commonDao.update("agreeSql.agreeRqstChang", mtenMap);
		result.put("msg", "ok");
		return result;
	}

	public int getAgreeRole(Map<String, Object> mtenMap) {
		return commonDao.selectOne("agreeSql.getAgreeRole", mtenMap);
	}
	
	
	
	
	
	

	public int insertSatisfaction(org.json.simple.JSONArray jsonArr) {
		int result = 0;
		String CVTN_MNG_NO = "";
		
		for(int i=0; i<jsonArr.size(); i++){
			HashMap map = (HashMap) jsonArr.get( i );
			if(String.valueOf(map.get("DGSTFN_ANS_MNG_NO")).length() > 0){
				commonDao.update("suitSql.updateSatisfaction", map );
				
				CVTN_MNG_NO = map.get("TRGT_PST_MNG_NO")==null?"":map.get("TRGT_PST_MNG_NO").toString();
			}else{
				commonDao.insert("suitSql.insertSatisfaction", map);
				
				CVTN_MNG_NO = map.get("TRGT_PST_MNG_NO")==null?"":map.get("TRGT_PST_MNG_NO").toString();
				String WRTR_EMP_NO = map.get("WRTR_EMP_NO")==null?"":map.get("WRTR_EMP_NO").toString();
				HashMap taskMap = new HashMap();
				taskMap = new HashMap();
				//taskMap.put("EMP_NO", WRTR_EMP_NO);
				taskMap.put("TASK_SE", "A7");
				taskMap.put("DOC_MNG_NO", map.get("TRGT_PST_MNG_NO")==null?"":map.get("TRGT_PST_MNG_NO").toString());
				taskMap.put("PRCS_YN", "Y");
				mifService.setTask(taskMap);
			}
		}
		HashMap map = new HashMap();
		map.put("CVTN_MNG_NO", CVTN_MNG_NO);
		commonDao.update("agreeSql.updateDGSTFN_RSPNS_YN", map);
		
		return result;
	}
	
	public JSONObject sendSatisAlert(Map<String, Object> mtenMap) {
		JSONObject docinfo = new JSONObject();
		String title = "";
		String cont = "";
		ArrayList sendUserList = new ArrayList();
		ArrayList sendUserNmList = new ArrayList();
		
		mtenMap.put("EMP_NO", mtenMap.get("CVTN_RQST_EMP_NO")==null?"":mtenMap.get("CVTN_RQST_EMP_NO").toString());
		String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
		
		sendUserList.add(empKey);
		sendUserNmList.add(mtenMap.get("CVTN_RQST_EMP_NM")==null?"":mtenMap.get("CVTN_RQST_EMP_NM").toString());
		
		title = "[법률지원통합시스템] 협약 검토건에 대한 만족도 조사 요청";
		cont = cont + "귀 부서에서 법률지원통합시스템에 요청 한 협약 검토건이 완료되었습니다.<br/>";
		cont = cont + "시스템에서 만족도 조사 응답 요청드립니다.<br/>";
		
		SendMail mail = new SendMail();
//		mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
		
		docinfo.put("msg", "");
		return docinfo;
	}

	public List getSatisSendAgreeList() {
		return commonDao.selectList("agreeSql.getSatisSendAgreeList");
	}
	
	public void updateDGSTFN_GIAN(HashMap param) {
		commonDao.update("agreeSql.updateDGSTFN_GIAN", param);
	}
	
	public void updateDGSTFN_GIAN_STATE(HashMap param) {
		commonDao.update("agreeSql.updateDGSTFN_GIAN_STATE", param);
	}
	

	public JSONObject updateKeyword(Map<String, Object> mtenMap) {
		JSONObject docinfo = new JSONObject();
		commonDao.update("agreeSql.updateKeyword", mtenMap);
		docinfo.put("msg", "save");
		return docinfo;
	}
}
