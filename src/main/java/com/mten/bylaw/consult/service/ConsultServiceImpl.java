package com.mten.bylaw.consult.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
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
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mten.bylaw.consult.Constants;
import com.mten.bylaw.mif.serviceSch.MifService;
import com.mten.dao.CommonDao;
import com.mten.dao.SmsDao;
import com.mten.email.SendMail;
import com.mten.util.DateUtil;
import com.mten.util.FileUploadUtil;
import com.mten.util.MakeHan;
import com.mten.util.SMSClientSend;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("cousultService")
public class ConsultServiceImpl implements ConsultService {
	protected final static Logger logger = Logger.getLogger( ConsultServiceImpl.class );
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="smsDao")
	private SmsDao smsDao;

	@Resource(name = "mifService")
	private MifService mifService;
	
	String saveMsg = "저장이 완료되었습니다.";
	String delMsg = "삭제가 완료되었습니다.";
	
	public String saveFileDll(MultipartHttpServletRequest multipartRequest, Map<String, Object> mtenMap) {
		Iterator<String> itr = multipartRequest.getFileNames();
		while (itr.hasNext()) { // 받은 파일들을 모두 돌린다.
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			String fileid = commonDao.select("commonSql.getSeq");
			String originalFilename = mpf.getOriginalFilename();
			String ext = originalFilename.substring(originalFilename.lastIndexOf("."), originalFilename.length());
			String fileFullPath = mtenMap.get("filePath") + "/" + fileid+ext;
			long fileSize = mpf.getSize();
			String FileSize = String.valueOf(fileSize);
			
			try {
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
				if(pchk) {
					mtenMap.put("fileid", fileid);
					mtenMap.put("serverfilenm", fileid+ext);
					mtenMap.put("ext", ext);
					mtenMap.put("ext", ext);
					mtenMap.put("FILE_SZ", FileSize);
					commonDao.insert("consultSql.insertFile",mtenMap);
				}else {
					System.out.println("파일업로드 실패");
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "";
	}
	
	public JSONObject nextStepconsult(Map<String, Object> mtenMap) {
		String statcd = mtenMap.get("statcd")==null?"":mtenMap.get("statcd").toString();
		if(statcd.equals("송무팀접수대기")) {
			//자문 기본 정보
			HashMap consult = commonDao.selectOne("consultSql.getConsult", mtenMap);
			String CHRGEMPNO = consult.get("CHRGEMPNO")==null?"":consult.get("CHRGEMPNO").toString();
			String MENUID = consult.get("MENUID")==null?"":consult.get("MENUID").toString();
			if(CHRGEMPNO.equals("") && !MENUID.equals(Constants.Counsel.INOUT_E_MENUID)) {	//담당자가 미배정 상태일경우에만 담당자 셋팅
				HashMap CHRGINFO = commonDao.selectOne("consultSql.searchCHRG");	//userno,username
				mtenMap.put("chrgempno", CHRGINFO.get("userno"));
				mtenMap.put("chrgempnm", CHRGINFO.get("username"));
				mtenMap.put("chrgregdt", "today");
			}
		}
		commonDao.update("consultSql.nextStepconsult",mtenMap);
		
		Map<String, Object> param = null;
		if(statcd.equals("검토의견작성중")) {
			// 외부자문 - 변호사에게 문자 발송
			mtenMap.put("sms", "Y");
			List<Map<String, Object>> lawyerList = commonDao.selectList("consultSql.getConsultLawyerList", mtenMap);
			if(lawyerList.size() > 0){
				for(int i=0; i<lawyerList.size(); i++){
					String phone = lawyerList.get(i).get("PHONE")==null?"":lawyerList.get(i).get("PHONE").toString();
					if(!phone.equals("")){
						param = new HashMap<String, Object>();
						param.put("subject", "[자문의뢰알림]");
						param.put("phone", lawyerList.get(i).get("PHONE"));
						param.put("bphone", "03180752363");
						param.put("msg", "고양시청에서 자문을 의뢰하였습니다. 시스템 확인바랍니다.");
						smsDao.insert("suitSql.sendSms", param);
						
						param = new HashMap<String, Object>();
						param.put("consultlawyerid", lawyerList.get(i).get("CONSULTLAWYERID")==null?"":lawyerList.get(i).get("CONSULTLAWYERID").toString());
						param.put("consultid", lawyerList.get(i).get("CONSULTID")==null?"":lawyerList.get(i).get("CONSULTID").toString());
						param.put("lawyerid", lawyerList.get(i).get("LAWYERID")==null?"":lawyerList.get(i).get("LAWYERID").toString());
						commonDao.update("consultSql.setLawyerNotiYn", param);
					}
				}
			}
		}
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public HashMap selectChckBoardView(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.selectChckBoardView", mtenMap);
	}
	
	public List consultLawyerList(Map<String, Object> mtenMap) {
		return commonDao.selectList("consultSql.getConsultLawyerList", mtenMap);
	}
	
	public JSONObject chckSave(Map<String, Object> mtenMap){
		String chckid = mtenMap.get("chckid")==null?"":mtenMap.get("chckid").toString();
		
		HashMap consult = commonDao.selectOne("consultSql.getConsult", mtenMap);
		String INOUTCON = consult.get("INOUTCON")==null?"":consult.get("INOUTCON").toString();
		
		if(chckid.equals("")) {
			
			if(INOUTCON.equals("O")||INOUTCON.equals("E")) {
				if(mtenMap.get("LAWYERID")!=null && !mtenMap.get("LAWYERID").toString().equals("")) {
					mtenMap.put("writerid", mtenMap.get("LAWYERID"));
				}
				if(mtenMap.get("LAWFIRMID")!=null && !mtenMap.get("LAWFIRMID").toString().equals("")) {
					mtenMap.put("sdeptid", mtenMap.get("LAWFIRMID"));
				}
				if(mtenMap.get("OFFICE")!=null && !mtenMap.get("OFFICE").toString().equals("")) {
					mtenMap.put("writer", mtenMap.get("OFFICE"));
				}
				if(mtenMap.get("OFFICE")!=null && !mtenMap.get("OFFICE").toString().equals("")) {
					mtenMap.put("sdeptname", mtenMap.get("OFFICE"));
				}
			}
			
			commonDao.insert("consultSql.insertChckBoard",mtenMap);
			
			int opinionListSize = commonDao.selectList("consultSql.selectChckBoard",mtenMap).size();
			int lawyerListSize = commonDao.selectList("consultSql.getConsultLawyerList",mtenMap).size();
			if(INOUTCON.equals("I") || ( (INOUTCON.equals("O")||INOUTCON.equals("E")) && opinionListSize==lawyerListSize)) {
				//if(INOUTCON.equals("I") || INOUTCON.equals("E")){
				//	mtenMap.put("statcd", "완료");
				//}else if(INOUTCON.equals("O")) {
				//	mtenMap.put("statcd", "만족도평가필요");
				//	
				//}
				//commonDao.update("consultSql.nextStepconsult",mtenMap);
				
				mtenMap.put("statcd", "만족도평가필요");
				commonDao.update("consultSql.nextStepconsult", mtenMap);
			}
			
			if (INOUTCON.equals("O") || INOUTCON.equals("E")) {
				new HashMap();
				new ArrayList();
				List<Map<String, Object>> list = commonDao.selectList("suitSql.selectSmsEmpList", mtenMap);
				if (list.size() > 0) {
					for(int i = 0; i < list.size(); ++i) {
						HashMap info = (HashMap)list.get(i);
						Map<String, Object> delfile = new HashMap();
						delfile.put("bphone", "03180752365");
						delfile.put("phone", info.get("PHONE").toString());
						delfile.put("msg", "법무행정통합지원시스템에 의뢰하신 자문에 검토의견이 등록되었습니다.");
						delfile.put("subject", "[검토의견 등록 알림]");
					}
				}
			}
		}else {
			String lawfirmyn = "";
			String Grpcd = mtenMap.get("Grpcd")==null?"":mtenMap.get("Grpcd").toString();
			if ( Grpcd.indexOf( "X" ) > -1) {	//변호사일경우 등록일 수정
				lawfirmyn = "Y";
			}
			mtenMap.put( "lawfirmyn" , lawfirmyn );
			
			commonDao.update("consultSql.updateChckBoard", mtenMap);
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("FILEID", mtenMap.get("delfile[]"));
						commonDao.delete("consultSql.deleteFile", mtenMap);
					}
						
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("FILEID", delfile.get(i));
							commonDao.delete("consultSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public int deleteChckBoard(Map<String, Object> mtenMap) {
		mtenMap.put("gbnid", mtenMap.get("chckid"));
		commonDao.delete("consultSql.deleteFile",mtenMap);
		
		mtenMap.put("statcd", "검토의견작성중");
		commonDao.update("consultSql.nextStepconsult",mtenMap);
		
		return commonDao.delete("consultSql.deleteChckBoard",mtenMap);
	}
	
	public HashMap getSatisfactionItems(Map<String, Object> mtenMap){
		
		//HashMap resultMap = new HashMap();
		//resultMap.put( "satisList" , commonDao.selectList("consultSql.getSatisfactionList",mtenMap ) );
		//resultMap.put( "lawyerList" , commonDao.selectList("consultSql.getConsultLawyerList",mtenMap ) );
		//
		//mtenMap.put( "useyn" , "Y" );
		//resultMap.put( "procSatisList" , commonDao.selectList("consultSql.getProcSatisList",mtenMap ) );
		//resultMap.put( "satisItemList" , commonDao.selectList("consultSql.getSatisitemList",mtenMap ) );
		//
		//return resultMap;
		String inoutcon = mtenMap.get("inoutcon") == null ? "" : mtenMap.get("inoutcon").toString();
		HashMap resultMap = new HashMap();
		resultMap.put("satisList", this.commonDao.selectList("consultSql.getSatisfactionList", mtenMap));
		if ("O".equals(inoutcon)) {
			resultMap.put("lawyerList", this.commonDao.selectList("consultSql.getConsultLawyerList", mtenMap));
		} else {
			resultMap.put("lawyerList", this.commonDao.selectList("consultSql.getConsultInLawyer", mtenMap));
		}
		
		mtenMap.put("useyn", "Y");
		resultMap.put("procSatisList", this.commonDao.selectList("consultSql.getProcSatisList", mtenMap));
		resultMap.put("satisItemList", this.commonDao.selectList("consultSql.getSatisitemList", mtenMap));
		return resultMap;
	}
	
	public HashMap getConsultant(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.getConsultant", mtenMap);
	}
	
	public HashMap getLawyerAccountInfo(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.getLawyerAccountInfo", mtenMap);
	}
	
	public JSONObject outerconsultantcost4Ajax(Map<String, Object> mtenMap){
		String consultantid = mtenMap.get("consultantid")==null?"":mtenMap.get("consultantid").toString();
		if(consultantid.equals("")) {
			commonDao.insert("consultSql.insertConsultants",mtenMap);
		}else {
			commonDao.update("consultSql.updateConsultant", mtenMap);
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("FILEID", mtenMap.get("delfile[]"));
						commonDao.delete("consultSql.deleteFile", mtenMap);
					}
						
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("FILEID", delfile.get(i));
							commonDao.delete("consultSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public int saveSatisfaction( org.json.simple.JSONArray jsonArr ) {
		int result = 0;
		for ( int i=0; i<jsonArr.size(); i++ ) {
			HashMap map = (HashMap) jsonArr.get( i );
			
			if ( String.valueOf( map.get( "satisfactionid" ) ).length() > 0 ) {
				commonDao.update("consultSql.updateSatisfaction", map );
			}
			else {
				// 사원번호로 사원명 조회
				String usrEmpno = String.valueOf( map.get( "writer" ) );
				map.put( "writer" , commonDao.selectOne("consultSql.getUsrNmByEmpno", usrEmpno ) );
				
				commonDao.insert("consultSql.insertSatisfaction", map );
			}
		}
		return result;
	}
	
	public int countSatisfaction(HashMap map) {
		return commonDao.selectOne("consultSql.countSatisfaction",map);
	}
	
	public List getSatisitemList(HashMap map) {
		return commonDao.selectList("consultSql.getSatisitemList",map);
	}
	
	public List getConsultantList(Map<String, Object> mtenMap) {
		return commonDao.selectList("consultSql.getConsultantList",mtenMap);
	}
	
	public int saveSatisitem(Map<String, Object> mtenMap) {
		int result = 0; 
		String satisitemid = mtenMap.get("satisitemid")==null?"":mtenMap.get("satisitemid").toString();
		if(satisitemid.length()>0){
			commonDao.update("suitSql.updateSatisitem",mtenMap);
		}else{
			commonDao.insert("suitSql.insertSatisitem",mtenMap);
		}
		return result;
	}
	
	public JSONObject consultCostList(Map<String, Object> mtenMap) {
		System.out.println("mtenMap===>"+mtenMap);
		List llist = commonDao.selectList("consultSql.consultCostList",mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", llist.size());
		result.put("result", jr);
		return result;
	}
	
	public JSONObject consultCostSave(Map<String, Object> mtenMap){
		String COSTID = mtenMap.get("costid")==null?"":mtenMap.get("costid").toString();
		if(COSTID.equals("")) {
			commonDao.insert("consultSql.insertConsultCost",mtenMap);
		}else {
			commonDao.update("consultSql.updateConsultCost", mtenMap);
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("FILEID", mtenMap.get("delfile[]"));
						commonDao.delete("consultSql.deleteFile", mtenMap);
					}
						
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("FILEID", delfile.get(i));
							commonDao.delete("consultSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public HashMap consultCost(Map<String, Object> mtenMap){
		HashMap result = new HashMap();
		//자문의뢰서 첨부파일
		mtenMap.put("gbnid", mtenMap.get("costid"));
		mtenMap.put("filegbn", "consultcost");
		List fconsultlist = commonDao.selectList("consultSql.selectFileList", mtenMap);
		
		result.put("costInfo", commonDao.selectOne("consultSql.consultCost",mtenMap));
		result.put("fcostlist", fconsultlist);
		return result;
	}
	
	public JSONObject CostListData(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("consultSql.CostListData", mtenMap);
		int cnt = commonDao.select("consultSql.getCostListDataTotal", mtenMap);		
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public void deleteConsultCost(Map<String, Object> mtenMap) {
		commonDao.delete("consultSql.deleteConsultCost",mtenMap);
	}
	
	public JSONObject senddtSave(Map<String, Object> mtenMap) {
		commonDao.update("consultSql.senddtSave", mtenMap);
		JSONObject result = new JSONObject();
		result.put("msg", "ok");
		return result;
	}
	
	public JSONObject chgUserSetting(Map<String, Object> mtenMap) {
		commonDao.update("consultSql.chgUserSetting", mtenMap);
		JSONObject result = new JSONObject();
		result.put("msg", "저장되었습니다.");
		return result;
	}
	
	public HashMap downloadAllFiles(Map<String, Object> mtenMap) throws Exception{
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		List fileList = new ArrayList();
		if(gbn.equals("makezip1")) {
			fileList = commonDao.selectList("consultSql.downloadAllFiles1",mtenMap );
		}
		if(gbn.equals("makezip2")) {
			fileList = commonDao.selectList("consultSql.downloadAllFiles2",mtenMap );
		}
		String uploadPath = "CONSULT";
		
		String filePath = MakeHan.File_url( uploadPath );
		String ofilePath = MakeHan.File_url( uploadPath );
		String zipFileNm = uploadPath + "_" + DateUtil.getShortDateString() + DateUtil.getShortTimeString();
		String tmpPath = filePath + zipFileNm;
		String zipTmpNm = tmpPath + ".zip";
		
		String encoding = new java.io.OutputStreamWriter( System.out ).getEncoding();
		if ( "UTF8".equals( encoding ) ) {
			encoding = "UTF-8";
		}
		
		byte[] buf = new byte[8192];
		
		ZipArchiveOutputStream zaos = new ZipArchiveOutputStream( new FileOutputStream( zipTmpNm ) );
		zaos.setLevel( 9 );
		zaos.setEncoding( encoding );
		
		FileInputStream fis = null;
		Map tmpMap = null;
		for ( int i=0; i<fileList.size(); i++ ) {
			fis = null;
			tmpMap = (Map) fileList.get( i );
			String folder = (tmpMap.get( "CONSULTNO" )==null?"":tmpMap.get( "CONSULTNO" ).toString())+(tmpMap.get( "TITLE" )==null?"":tmpMap.get( "TITLE" ).toString());
			folder = MakeHan.convertFilename(folder);
			File fchk = new File( ofilePath + folder );
			if(!fchk.exists()) {
				fchk.mkdir();
			}
			
			MakeHan.fileCopy(filePath + tmpMap.get( "SERVERFILENM" ),  ofilePath + folder + "/" + tmpMap.get( "VIEWFILENM" ) );
			
			File file = new File( ofilePath + tmpMap.get( "SERVERFILENM" ) );
			
			if ( file.exists() ) {
				fis = new FileInputStream( ofilePath + tmpMap.get( "SERVERFILENM" ) );
			}else {
			}
			
			zaos.putArchiveEntry( new ZipArchiveEntry( String.valueOf( folder +"/"+ tmpMap.get( "VIEWFILENM" ) ) ) );
			
			int length;
			while ( ( length = fis.read( buf ) ) > 0 ) {
				zaos.write( buf , 0 , length );
			}
			
			zaos.closeArchiveEntry();
			fis.close();
		}
		
		zaos.close();
		
		for ( int i=0; i<fileList.size(); i++ ) {
			tmpMap = (Map) fileList.get( i );
			String folder = (tmpMap.get( "CONSULTNO" )==null?"":tmpMap.get( "CONSULTNO" ).toString())+(tmpMap.get( "TITLE" )==null?"":tmpMap.get( "TITLE" ).toString());
			folder = MakeHan.convertFilename(folder);
			MakeHan.deleteFolder(ofilePath + folder);
		}
		
		HashMap result = new HashMap();
		result.put( "fileName" , zipFileNm + ".zip" );
		result.put( "filePath" , filePath );
		
		return result;
	}
	
	public JSONObject deleteConsult(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("consultSql.deleteConsult", mtenMap);	//TB_SU_CONSULT
		commonDao.delete("consultSql.deleteConsultAprv", mtenMap);	//TB_SU_CONSULT_APRV_INFO
		commonDao.delete("consultSql.deleteChrgInfo", mtenMap);	//TB_SU_CONSULT_CHRG_INFO
		commonDao.delete("consultSql.deleteChckBoard", mtenMap);	//TB_SU_CONSULT_CHCK_INFO
		commonDao.delete("consultSql.deleteConsultCost", mtenMap);	//tb_su_consult_cost
		mtenMap.put("gbnid", mtenMap.get("consultid"));
		commonDao.delete("consultSql.deleteFile", mtenMap);	//TB_SU_CONSULT_FILE
		commonDao.delete("consultSql.deleteConsultLawyer", mtenMap);	//tb_su_consult_lawyer
		
		commonDao.delete("consultSql.deleteConsultantAprv", mtenMap);//TB_SU_CONSULTANT_APRV_INFO
		commonDao.delete("consultSql.deleteConsultant", mtenMap);	//TB_SU_CONSULTANT
		
		
		result.put("msg", "ok");
		return result;
	}
	
	public JSONObject changeOpenynconsult(Map<String, Object> mtenMap){
		commonDao.update("consultSql.changeOpenynconsult", mtenMap);
		JSONObject result = new JSONObject();
		result.put("msg", "ok");
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public HashMap getConsultans2(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.selectCConsultans", mtenMap);
	}
	
	public static HashMap keyChangeLowerMap(Map param) {
		Iterator<String> iteratorKey = param.keySet().iterator(); // 키값 오름차순
		HashMap newMap = new HashMap();
		// //키값 내림차순 정렬
		while (iteratorKey.hasNext()) {
			String key = iteratorKey.next();
			newMap.put(key.toLowerCase(), param.get(key));
		}
		return newMap;

	}
	


	
	public JSONObject addConsult(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		//String consultid = mtenMap.get("consultid").toString();
		//String sourcetableid = mtenMap.get("sourcetableid").toString();
		String cid = mtenMap.get("consultid")==null?"0":mtenMap.get("consultid").toString();
		String inoutcd = mtenMap.get("inoutcd")==null?"":mtenMap.get("inoutcd").toString();
		String refconsultid = mtenMap.get("refconsultid")==null?"":mtenMap.get("refconsultid").toString();
		
		if(cid.equals("")) {
			cid = "0";
		}
		int consultid = Integer.parseInt(cid);
		int sourcetableid = consultid;
		//String consulstatecd  = mtenMap.get("consulstatecd").toString();
		Map<String, Object> map = new HashMap<String, Object>();
		
		HashMap outConsult = new HashMap();
		outConsult.put("consultid", mtenMap.get("refconsultid"));
		outConsult.put("refconsultid", mtenMap.get("consultid"));
		
		if (!Constants.Counsel.TYPE_INTN.equals(inoutcd) && refconsultid.equals("")) {
			mtenMap.put("consultid","");
			mtenMap.put("deptsenginsabun","");
			mtenMap.put("deptsenginname","");
			java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.KOREA);
			mtenMap.put("jeobsudt",formatter.format(new java.util.Date()));
		}
		
		
		if(consultid == 0 || mtenMap.get("consultid").toString().equals("")) {
			if (!Constants.Counsel.TYPE_INTN.equals(inoutcd)) {
				mtenMap.put("consultstatecd", Constants.Counsel.PRGS_STAT_LAW_RECPT);
			}else {
				mtenMap.put("consultstatecd", Constants.Counsel.PRGS_STAT_DEPT_REG);
			}
			
			commonDao.insert("consultSql.insertConsult", mtenMap);
			sourcetableid = Integer.parseInt(mtenMap.get("consultid").toString());

			java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.KOREA);
			String today = formatter.format(new java.util.Date());
			HashMap reg = new HashMap();
			reg.put("sourcetableid",sourcetableid);
			reg.put("adttm",today);
			reg.put("aname",mtenMap.get("jilmunname"));
			reg.put("asabun",mtenMap.get("jilmunsabun"));
			reg.put("rdttm",today);
			reg.put("rname",mtenMap.get("jilmunname"));
			reg.put("rsabun",mtenMap.get("jilmunsabun"));
			commonDao.insert("consultSql.insertCReg",reg);
			
			
			map = new HashMap<String, Object>();
			map.put("writer", mtenMap.get("writer"));
			map.put("writerid", mtenMap.get("writerid"));
			map.put("deptid", mtenMap.get("deptid"));
			map.put("docid", sourcetableid);
			map.put("docgbn", "CONSULT");
			map.put("rolegbn", "P");
			commonDao.insert("consultSql.insertConsultRole", map);
			
		}else {
			commonDao.update("consultSql.updateConsult2", mtenMap);
			java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmm", java.util.Locale.KOREA);
			String today = formatter.format(new java.util.Date());
			HashMap reg = new HashMap();
			reg.put("sourcetableid",sourcetableid);
			reg.put("adttm",today);
			reg.put("aname",mtenMap.get("jilmunname"));
			reg.put("asabun",mtenMap.get("jilmunsabun"));
			reg.put("rdttm",today);
			reg.put("rname",mtenMap.get("jilmunname"));
			reg.put("rsabun",mtenMap.get("jilmunsabun"));
			commonDao.update("consultSql.updateCReg",reg);
			
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("FILEID", mtenMap.get("delfile[]"));
						commonDao.delete("consultSql.deleteTB_SU_C_FILE", mtenMap);
					}
						
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("FILEID", delfile.get(i));
							commonDao.delete("consultSql.deleteTB_SU_C_FILE", mtenMap);
						}
					}
				}
			}
		}
		
		if (!Constants.Counsel.TYPE_INTN.equals(inoutcd) && !outConsult.get("refconsultid").equals(outConsult.get("consultid"))) {
			commonDao.update("consultSql.updateConsult", outConsult);
		}

		result.put("sourcetableid", sourcetableid);
		result.put("msg", "ok");
	
		return result;
	}
	
	public JSONObject deleteTB_SU_C_FILE(Map<String, Object> mtenMap) {
		commonDao.delete("consultSql.deleteTB_SU_C_FILE", mtenMap);
		JSONObject result = new JSONObject();
		result.put("msg", "OK");
		return result;
	}
	
	public JSONObject getConsultList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectConsultList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject getConsultTotal(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectConsultTotal", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public HashMap getConsult(Map<String, Object> mtenMap) {
		HashMap mp = commonDao.selectOne("consultSql.selectConsultDetail", mtenMap);
		return mp;
	}

	
	public JSONObject getRefConsult(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectRefConsult", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	

	
	public void setConsult(Map<String, Object> mtenMap) {
		commonDao.update("consultSql.updateConsult", mtenMap);
	}

	
	public JSONObject removeConsult(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("consultSql.deleteConsult", mtenMap);
		
		mtenMap.put("FILECD", "의뢰서");
		mtenMap.put("SOURCETABLEID", mtenMap.get("consultid"));
		commonDao.delete("consultSql.deleteTB_SU_C_FILE2", mtenMap);
		result.put("msg", "ok");
		return result;
	}

	//수정
	public JSONObject approveConsult(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.updateApprve", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	
	//의견서
	public JSONObject getConsultansList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectConsultansList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject getConsultans(Map<String, Object> mtenMap) {
		HashMap list = commonDao.selectOne("consultSql.selectCConsultans", mtenMap);
		return JSONObject.fromObject(list);
	}

	public JSONObject setConsultans(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.updateConsultans", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject removeConsultans(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.deleteConsultans", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject getDate(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.getDate", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject setAprvstatus(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.setAprvstatus", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject setConsultstatecd(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.setConsultstatecd", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject getQuestion(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.getQuestion", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject setResearcResult(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.setResearcResult", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject getMobileNo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.getMobileNo", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	


	
	public JSONObject selectSati_statistics(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectSati_statistics", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject getConsultMyList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectConsultMyList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject setOpenyn(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.update("consultSql.setOpenyn", mtenMap);
		result.put("msg", "ok");
		return result;
	}
	//0903
	





	public JSONObject selectConsultansList(Map<String, Object> mtenMap) { //의견서리스트 
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectConsultansList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}



	public JSONObject getConsultansPopDetail(Map<String, Object> mtenMap) {
		
		JSONObject result = new JSONObject();
		HashMap consultansinfo = commonDao.selectOne("consultSql.selectConsultansPopDetail", mtenMap);
		if(consultansinfo == null){
			result.put("data", "");
		}else{
			
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("sourcetableid", mtenMap.get("consultansid").toString());
		//map.put("sourcetableid", mtenMap.get("consultid").toString());
		map.put("filecd", "의견서");	
		result.put("fList", commonDao.selectList("consultSql.selectFileList", map));
	

		//HashMap consultansinfo = commonDao.selectOne("consultSql.selectConsultansPopDetail", mtenMap);
		result.put("consultid", consultansinfo.get("CONSULTID")==null?"":consultansinfo.get("CONSULTID"));
		result.put("consultansid", consultansinfo.get("CONSULTANSID")==null?"":consultansinfo.get("CONSULTANSID"));
		result.put("title", consultansinfo.get("TITLE")==null?"":consultansinfo.get("TITLE"));
		result.put("sasilyoji", consultansinfo.get("SASILYOJI")==null?"":consultansinfo.get("SASILYOJI"));
		result.put("bubview", consultansinfo.get("BUBVIEW")==null?"":consultansinfo.get("BUBVIEW"));
		result.put("dept", consultansinfo.get("DEPT")==null?"":consultansinfo.get("DEPT"));
		result.put("bubmusenginname", consultansinfo.get("BUBMUSENGINNAME")==null?"":consultansinfo.get("BUBMUSENGINNAME"));
		result.put("consultcd", consultansinfo.get("CONSULTCD")==null?"":consultansinfo.get("CONSULTCD"));
		result.put("consultstatecd", consultansinfo.get("CONSULTSTATECD")==null?"":consultansinfo.get("CONSULTSTATECD"));
		
		}
		
		return result;
	}

	
	public JSONObject addConsultans(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		HashMap consultans = new HashMap();
		consultans.put("consultansid",mtenMap.get("consultansid"));
		consultans.put("consultid",mtenMap.get("consultid"));
		consultans.put("refconsultid",mtenMap.get("refconsultid"));
		consultans.put("title",mtenMap.get("title"));
		consultans.put("sasilyoji",mtenMap.get("sasilyoji"));
		consultans.put("bubview",mtenMap.get("bubview"));
		consultans.put("bubmusenginsabun",mtenMap.get("bubmusenginsabun"));
		consultans.put("bubmusenginname",mtenMap.get("bubmusenginname"));
		consultans.put("emailsusindt",mtenMap.get("emailsusindt")==null?"":mtenMap.get("emailsusindt").toString().replaceAll("-",""));
		consultans.put("hoisindt",mtenMap.get("hoisindt")==null?"":mtenMap.get("hoisindt").toString().replaceAll("-",""));
		consultans.put("bublawyerid",mtenMap.get("bublawyerid"));
		
		HashMap consult = new HashMap();	
		consult.put("consultid",mtenMap.get("consultid"));
		consult.put("refconsultid",mtenMap.get("refconsultid"));
		consult.put("consultcatcd",mtenMap.get("consultcatcd"));
		consult.put("consultcd",mtenMap.get("consultcd"));
		consult.put("inoutcd",mtenMap.get("inoutcd"));
		consult.put("title",mtenMap.get("title"));
		consult.put("sasilkoreo",mtenMap.get("sasilkoreo"));
		consult.put("yoji",mtenMap.get("yoji"));
		consult.put("relrule",mtenMap.get("relrule"));
		consult.put("deptview",mtenMap.get("deptview"));
		consult.put("jilmunsabun",mtenMap.get("jilmunsabun"));
		consult.put("jilmunname",mtenMap.get("jilmunname"));
		consult.put("email",mtenMap.get("email"));
		consult.put("phone",mtenMap.get("phone"));
		consult.put("dept",mtenMap.get("dept"));
		consult.put("hopedt",mtenMap.get("hopedt")==null?"":mtenMap.get("hopedt").toString().replaceAll("-",""));
		consult.put("deptsenginsabun",mtenMap.get("deptsenginsabun"));
		consult.put("deptsenginname",mtenMap.get("deptsenginname"));
		consult.put("balsindt",mtenMap.get("balsindt")==null?"":mtenMap.get("balsindt").toString().replaceAll("-",""));
		consult.put("banreason",mtenMap.get("banreason"));
		consult.put("consultstatecd",mtenMap.get("consultstatecd"));
		consult.put("bubsabun",mtenMap.get("bubsabun"));
		consult.put("bubname",mtenMap.get("bubname"));
		consult.put("jeobsudt",mtenMap.get("jeobsudt")==null?"":mtenMap.get("jeobsudt").toString().replaceAll("-",""));
		consult.put("bublawyerid",mtenMap.get("bublawyerid"));
		
		String consultansidchk = mtenMap.get("consultansid")==null?"":mtenMap.get("consultansid").toString();
		
		if(!consultansidchk.equals("") || consultansidchk.length()>0) {
			commonDao.update("consultSql.updateCConsultans",consultans);
			
			consult.put("refconsultid","");
			consult.put("title","");
			this.setConsult(consult);
			
			result.put("sourcetableid", consultansidchk);
			
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("FILEID", mtenMap.get("delfile[]"));
						commonDao.delete("consultSql.deleteTB_SU_C_FILE", mtenMap);
					}
						
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("FILEID", delfile.get(i));
							commonDao.delete("consultSql.deleteTB_SU_C_FILE", mtenMap);
						}
					}
				}
			}
		}else {
			consultans.put("refconsultid",consult.get("consultid"));
			
			commonDao.insert("consultSql.insertConsultans", mtenMap);
			String consultansid = mtenMap.get("consultansid").toString();
			
			
			if (consultansid != null && consultansid.length() >0) {
				consult.put("refconsultid","");
				consult.put("title","");
				consult.put("consultstatecd",Constants.Counsel.PRGS_STAT_LAW_RECPT);
				System.out.println(consult);
				this.setConsult(consult);
			}
			commonDao.update("consultSql.updateConsult", mtenMap);	// 	
			result.put("sourcetableid", consultansid);
		}
		
		return result;
	}


	


	//진행상황변경
	public JSONObject getConsultProgressInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String menuGbn = mtenMap.get("gbn").toString();
		
		List<String> typeList = new ArrayList<String>();
		if("list".equals(menuGbn)){
			//typeList.add("PROGRESSCD");
			typeList.add("PRGSSTAT");
		}
		mtenMap.put("typeList", typeList);
		
		//List list = commonDao.selectList("suitSql.selectSuitTypeInfo", mtenMap);
		List list = commonDao.selectList("consultSql.selectConsultProgressInfo", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	//consultcd
	public JSONObject getConsultCdInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String menuGbn = mtenMap.get("gbn").toString();
		
		List<String> typeList = new ArrayList<String>();
		if("list".equals(menuGbn)){
			typeList.add("CONSULTCD");
		}
		mtenMap.put("typeList", typeList);
		List list = commonDao.selectList("consultSql.selectConsultCdInfo", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	
	
	//file
	public JSONObject fileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest) {
		Iterator<String> itr = multipartRequest.getFileNames();
		JSONObject result = new JSONObject();
		Map map = new HashMap<String, Object>();
		
		while (itr.hasNext()) {
			String FILEID = commonDao.selectOne("consultSql.getFileIdKey");
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			String originalFilename = mpf.getOriginalFilename(); // 파일명
			String fileFullPath = mtenMap.get("filePath") + "/" + FILEID+"."
									+(originalFilename.substring(originalFilename.lastIndexOf(".")+1,originalFilename.length())); // 파일 전체 경로
			System.out.println("get fileFullPath >>>>>>>>>>> " + fileFullPath);
			long fileSize = mpf.getSize();
			String FileSize = String.valueOf(fileSize);
			try {
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
				
				if(pchk) {
					map = new HashMap<String, Object>();
					
					map.put("fileid", FILEID);
					System.out.println("get FILEID >>>>>>>>>>> " + FILEID);
					map.put("sourcetableid", mtenMap.get("sourcetableid").toString());
					map.put("pcfilename", originalFilename);
					map.put("serverfilename", FILEID+"."+(originalFilename.substring(originalFilename.lastIndexOf(".")+1,originalFilename.length())));
					map.put("fileext", originalFilename.substring(originalFilename.lastIndexOf(".")+1,originalFilename.length()));
					map.put("filecd", mtenMap.get("filecd").toString());
					
					
					//mtenMap.put("fileid", FILEID);
					//mtenMap.put("viewname", originalFilename);
					//mtenMap.put("servname", FILEID+"."+(originalFilename.substring(originalFilename.lastIndexOf(".")+1,originalFilename.length())));
					//mtenMap.put("ext", originalFilename.substring(originalFilename.lastIndexOf(".")+1,originalFilename.length()));
					map.put("FILE_SZ", FileSize);
					commonDao.insert("consultSql.insertFile", map);
					result.put("msg", "suc");
				}else {
					System.out.println("파일업로드 실패");
					result.put("msg", "개인정보 검출 데이터를 확인하시기 바랍니다.");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	
	public JSONObject fileDelete(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String filePath = mtenMap.get("filePath").toString()+""+mtenMap.get("serverfilenm");
		File file = new File(filePath);
		if(file.exists()){
			if(file.delete()){
				commonDao.delete("consultSql.deleteFileOne", mtenMap);
				result.put("msg", "파일이 삭제되었습니다.");
			}else{
				result.put("msg", "파일 삭제를 실패하였습니다. 관리자에게 문의하세요");
			}
		}
		
		return result;
	}
	
	public JSONObject getFileList(Map<String, Object> mtenMap){
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectFileList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("flist", jr);
		return result;
	}
	
	public JSONObject selectDateFileList(Map<String, Object> mtenMap){
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectDateFileList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("flist", jr);
		return result;
	}
	
	
	public JSONObject selectDocList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectDocList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	//계약서등록
	public JSONObject contractFileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest) {
		Iterator<String> itr = multipartRequest.getFileNames();
		JSONObject result = new JSONObject();
		Map map = new HashMap<String, Object>();
		
		while (itr.hasNext()) {
			String FILEID = commonDao.selectOne("consultSql.getFileIdKey");
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			String originalFilename = mpf.getOriginalFilename(); // 파일명
			String fileFullPath = mtenMap.get("filePath") + "/" + FILEID+"."
									+(originalFilename.substring(originalFilename.lastIndexOf(".")+1,originalFilename.length())); // 파일 전체 경로
			long fileSize = mpf.getSize();
			String FileSize = String.valueOf(fileSize);
			try {
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
				
				if(pchk) {
					map = new HashMap<String, Object>();
					
					map.put("fileid", FILEID);
					System.out.println("get FILEID >>>>>>>>>>> " + FILEID);
					map.put("sourcetableid", mtenMap.get("sourcetableid").toString());
					//map.put("sourcetableid", mtenMap.get("consulid").toString());
					//map.put("pcfilename", mtenMap.get("pcfilename").toString());
					//map.put("serverfilename", mtenMap.get("serverfilename").toString());
					//map.put("fileext", mtenMap.get("fileext").toString());
					//map.put("filecd", mtenMap.get("filecd").toString());
					map.put("filecd", "계약서");	
					map.put("FILE_SZ", FileSize);
					
					map.put("pcfilename", originalFilename);
					map.put("serverfilename", FILEID+"."+(originalFilename.substring(originalFilename.lastIndexOf(".")+1,originalFilename.length())));
					map.put("fileext", originalFilename.substring(originalFilename.lastIndexOf(".")+1,originalFilename.length()));
					//map.put("filecd", mtenMap.get("filecd").toString());
					
					
					
					commonDao.insert("consultSql.insertContractFile", map);
					result.put("msg", "suc");
				}else {
					System.out.println("파일업로드 실패");
					result.put("msg", "개인정보 검출 데이터를 확인하시기 바랍니다.");
				}
				
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}


	public JSONObject consultStatechg(Map<String, Object> mtenMap) { //진행상황변경
		JSONObject result = new JSONObject();
		commonDao.update("consultSql.consultStatechg", mtenMap);
		result.put("msg", "ok");
		return result;
	}
	
	public JSONObject getBanReasonInfo(Map<String, Object> mtenMap) { //반려사유확인
		JSONObject result = new JSONObject();
		
		String type = mtenMap.get("paramType")==null?"":mtenMap.get("paramType").toString();
		HashMap list = new HashMap();
		if(type.equals("req") || type.equals("reqBub")) {
			list = commonDao.selectOne("consultSql.getBanReasonInfo", mtenMap);
		}else {
			list = commonDao.selectOne("consultSql.getBanReasonInfo2", mtenMap);
		}
		
		result.put("consultid", mtenMap.get("consultid")==null?"":mtenMap.get("consultid"));
		result.put("consultansid", mtenMap.get("consultansid")==null?"":mtenMap.get("consultansid"));
		if(list!=null) {
			result.put("banreason", list.get("BANREASON")==null?"":list.get("BANREASON"));
		}
		return result;
	}


	public JSONObject banReasonUpdate(Map<String, Object> mtenMap) { //반려사유입력
		String type = mtenMap.get("paramType")==null?"":mtenMap.get("paramType").toString();
		if(type.equals("req")) {	//부서반려
			mtenMap.put("consultstatecd", Constants.Counsel.PRGS_STAT_DEPT_REJT);
			commonDao.update("consultSql.banReasonUpdate", mtenMap);
			
			commonDao.update("consultSql.updateApprve2",mtenMap);
		}else if(type.equals("reqBub")){	//송무팀반려
			mtenMap.put("consultstatecd", Constants.Counsel.PRGS_STAT_LAWBUB_REJT);
			mtenMap.put("bubsabun", "");
			mtenMap.put("bubname", "");
			mtenMap.put("jeobsudt", "");
			commonDao.update("consultSql.banReasonUpdate3", mtenMap);
			
			commonDao.update("consultSql.updateApprve2",mtenMap);
		}else {	//의견서 부서반려
			commonDao.update("consultSql.banReasonUpdate2", mtenMap);
			
			mtenMap.put("consultstatecd", Constants.Counsel.PRGS_STAT_LAW_REJT);
			commonDao.update("consultSql.updateApprve2",mtenMap);
		}
		
		
		JSONObject result = new JSONObject();
		
		result.put("msg", "ok");
		return result;
	}
	
	public JSONObject selectRoleInfo(Map<String, Object> mtenMap) { //권한
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectRoleInfo", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	
	public JSONObject roleInfoSave(Map<String, Object> mtenMap){ //권한
		JSONObject result = new JSONObject();
		Map map = new HashMap<String, Object>();
		
		String consultid = mtenMap.get("consultid").toString();
		String writerid = mtenMap.get("writerid").toString();
		String writer = mtenMap.get("writer").toString();
		String chkdepts = mtenMap.get("chkDept").toString();
		String chkusers = mtenMap.get("chkUser").toString();
		String [] chkdeptArr = chkdepts.split(",");
		String [] chkuserArr = chkusers.split(",");
		
		// 기존에 부여 된 권한 삭제
		commonDao.delete("consultSql.deleteRole", mtenMap);
		
		// 체크 된 부서 권한 부여
		for(int i=0; i<chkdeptArr.length; i++){
			if(!"".equals(chkdeptArr[i])){
				map = new HashMap<String, Object>();
				map.put("consultid", consultid);
				map.put("docgbn", "CONSULT");
				map.put("rolegbn", "D");
				map.put("rolewriterid", "");
				map.put("roledeptid", chkdeptArr[i]);
				map.put("writerid", writerid);
				map.put("writer", writer);
				commonDao.insert("consultSql.insertRole", map);
			}
		}
		
		// 체크 된 사용자 권한 부여
		for(int u=0; u<chkuserArr.length; u++){
			if(!"".equals(chkuserArr[u])){
				map = new HashMap<String, Object>();
				map.put("consultid", consultid);
				map.put("docgbn", "CONSULT");
				map.put("rolegbn", "P");
				map.put("rolewriterid", chkuserArr[u]);
				map.put("roledeptid", "");
				map.put("writerid", writerid);
				map.put("writer", writer);
				commonDao.insert("consultSql.insertRole", map);
			}
		}
		result.put("msg", saveMsg);
		return result;
	}
	
	//설문 researchSave
	public JSONObject researchSave(Map<String, Object> mtenMap) {
		
		JSONObject result = new JSONObject();
		commonDao.insert("consultSql.researchSave", mtenMap);
		result.put("msg", "ok");
		return result;
	}
	
	public JSONObject goResearchManage(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.getQuestion", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject getItemInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		HashMap list = commonDao.selectOne("consultSql.getQuestion", mtenMap);
		
		result.put("satisitemid", list.get("SATISITEMID")==null?"":list.get("SATISITEMID"));
		result.put("item", list.get("ITEM")==null?"":list.get("ITEM"));
		result.put("useyn", list.get("USEYN")==null?"":list.get("USEYN"));
		result.put("writercd", list.get("WRITERCD")==null?"":list.get("WRITERCD"));
		
		return result;
	}


	
	public JSONObject addQuestion(Map<String, Object> mtenMap) throws Exception {
		JSONObject result = new JSONObject();
		String satisitemid = mtenMap.get("satisitemid").toString();
		if("".equals(satisitemid)) {
			commonDao.insert("consultSql.insertQuestion", mtenMap);
		}else {
			commonDao.update("consultSql.updateQuestion", mtenMap);
		}
		
			result.put("msg", "ok");
	
		return result;
	}
	
	public JSONObject delQuestion(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String satisitemid = mtenMap.get("satisitemid").toString();
		commonDao.delete("consultSql.delQuestion", mtenMap);
		result.put("msg", delMsg);
		return result;
	}
	
	public List selectExcelConsultList(Map<String, Object> mtenMap) { //consult excel
		List list = commonDao.selectList("consultSql.selectExcelConsultList", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return list;
	}
	
	public List selectExcelConsultansList(Map<String, Object> mtenMap) { //consult excel
		List list = commonDao.selectList("consultSql.selectExcelConsultansList", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return list;
	}
	
	public HashMap getConsult2(Map param) {
		return commonDao.selectOne("consultSql.selectConsultDetail", param);
	}
	
	public HashMap getRefConsult2(Map param) {
		return commonDao.selectOne("consultSql.selectRefCConsult", param);
	}
	
	public HashMap getLawyer(String bublawyerid) {
		return commonDao.selectOne("consultSql.selectCBublawyer", bublawyerid);
	}
	
	public JSONObject aprvConsult4Ajax(Map<String, Object> mtenMap) {
		String consultstatecd = mtenMap.get("consultstatecd")==null?"":mtenMap.get("consultstatecd").toString();
		String inoutcd = mtenMap.get("inoutcd")==null?"":mtenMap.get("inoutcd").toString();
		
		if(consultstatecd.equals("송무팀승인")) {
			//메일발송
			
		}
		JSONObject result = new JSONObject();
		HashMap para = new HashMap();
		if (Constants.Counsel.TYPE_EXTN.equals(inoutcd)	&& Constants.Counsel.PRGS_STAT_LAW_APRV.equals(consultstatecd)) {
			para.put("refconsultid", mtenMap.get("refconsultid"));
			para.put("consultcd", mtenMap.get("consultcd"));
		}else {
			para.put("consultid", mtenMap.get("consultid"));
		}
		para.put("banreason", "");
		para.put("consultstatecd", consultstatecd);
		commonDao.update("consultSql.updateApprve",para);
		commonDao.update("consultSql.updateApprve3",para);
		result.put("msg", "ok");
		return result;
	}
	
	public int getRoleChk2(Map<String, Object> mtenMap) {
		int chk = commonDao.select("consultSql.getRolechk2",mtenMap);
		return chk;
	}
	
	public JSONObject saveCharger4Ajax(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.KOREA);
		
		mtenMap.put("jeobsudt", formatter.format(new java.util.Date()));
		mtenMap.put("consultstatecd", Constants.Counsel.PRGS_STAT_LAW_RECPT);
		commonDao.update("consultSql.updateConsult",mtenMap);
		
		result.put("msg", "ok");
		return result;
	}
	
	public HashMap selectCReg(HashMap para) {
		return commonDao.selectOne("consultSql.selectCReg", para);
	}
	
	public List<Map<String, Object>> listFileDownload(Map<String, Object> mtenMap) {
		String gbn = mtenMap.get("gbn").toString();
		List list = new ArrayList();
		if("2".equals(gbn)){
			// 의견서
			list = commonDao.selectList("consultSql.listFileDownload2", mtenMap);
		}else{
			// 의뢰서 / 계약서
			list = commonDao.selectList("consultSql.listFileDownload1", mtenMap);
		}
		return list;
	}
	
	public JSONObject removeConsultans4Ajax(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("consultSql.deleteCConsultans",mtenMap);
		
		HashMap para = new HashMap();
		para.put("consultid", mtenMap.get("consultid"));
		
		int chk = commonDao.selectOne("consultSql.selectConsultansTotalCount", para);
		if(chk==0) {
			mtenMap.put("consultstatecd", Constants.Counsel.PRGS_STAT_LAW_RECPT);
			commonDao.update("consultSql.updateApprve2",mtenMap);
		}
		result.put("msg", "ok");
		return result;
	}
	
	//1029
	public JSONObject getResult(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.getResult", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public List selectCgbn() {
		return commonDao.selectList("consultSql.selectCgbn");
	}
	
	public JSONObject changeC(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.update("consultSql.changeC",mtenMap);
		result.put("msg", "ok");
		return result;
	}
	
	public JSONObject consultListData(Map<String, Object> mtenMap) {
		System.out.println("mtenMap값 ::: " + mtenMap.toString());
		System.out.println("mtenMap의 메뉴 ::: " + mtenMap.get("menuid"));
		
		String Grpcd = mtenMap.get("grpcd") == null ? "" : mtenMap.get("grpcd").toString();
		//J M Q F
		if (Grpcd.indexOf("Y") > -1) {
			// 전체관리자 or 소송관리자
			mtenMap.put("grpcd", "Y");
		} else if(Grpcd.indexOf("J") > -1 || Grpcd.indexOf("M") > -1 || Grpcd.indexOf("Q") > -1 || Grpcd.indexOf("F") > -1) {
			mtenMap.put("grpcd", "J");
		} else {
			// 그 외 일반사용자
			mtenMap.put("grpcd", "P");
		}
		
		List llist = commonDao.selectList("consultSql.getConsultList", mtenMap);
		int cnt = commonDao.select("consultSql.getConsultTotal", mtenMap);		
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getConsultInfo(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.getConsult", mtenMap);
	}
	
	public List getFileList2(Map param) {
		return commonDao.selectList("consultSql.selectFileList", param);
	}
	
	public List selectAnswerBoard(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("consultSql.selectAnswerBoard", mtenMap);
		return list;
	}
	
	public List selectAgreeEmp() {
		List list = commonDao.selectList("consultSql.selectAgreeEmp");
		return list;
	}
	
	public JSONObject consultSave(Map<String, Object> mtenMap){
		String CONSULTID = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String writerdept = mtenMap.get("writerdeptcd")==null?"":mtenMap.get("writerdeptcd").toString();
		String cnstn_rqst_emp_no = mtenMap.get("cnstn_rqst_emp_no")==null?"":mtenMap.get("cnstn_rqst_emp_no").toString();
		String cnstn_rqst_dept_no = mtenMap.get("cnstn_rqst_dept_no")==null?"":mtenMap.get("cnstn_rqst_dept_no").toString();
		if(CONSULTID.equals("")) {
			commonDao.insert("consultSql.insertConsult", mtenMap);
			mtenMap.put("CNSTN_MNG_NO", mtenMap.get("cnstn_mng_no"));
			
			CONSULTID = mtenMap.get("cnstn_mng_no")==null?"":mtenMap.get("cnstn_mng_no").toString();
		}else {
			commonDao.update("consultSql.updateConsult2", mtenMap);
			mtenMap.put("CNSTN_MNG_NO", mtenMap.get("consultid"));
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("consultSql.deleteFile", mtenMap);
					}
						
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("consultSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		// 권한 삭제
//		HashMap map = new HashMap();
//		map.put("docid", CONSULTID);
//		map.put("rolegbn", "DW");
//		map.put("docgbn", "CONSULT");
//		commonDao.delete("consultSql.deleteRole", map);
		
		// 권한 재등록 (부서단위)
		HashMap params = new HashMap();
		params.put("doc_mng_no", CONSULTID);
		params.put("doc_se", "CONSUL");
		params.put("authrt_se", "P");
		params.put("authrt_emp_no", cnstn_rqst_emp_no);
		params.put("authrt_dept_no", cnstn_rqst_dept_no);
		params.put("writer", mtenMap.get("WRTR_EMP_NM").toString());
		params.put("writerid", mtenMap.get("WRTR_EMP_NO").toString());
		params.put("deptname", mtenMap.get("WRT_DEPT_NM").toString());
		params.put("deptid", mtenMap.get("WRT_DEPT_NO").toString());
		commonDao.insert("consultSql.insertRole", params);
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject saveFile(MultipartHttpServletRequest multipartRequest, Map<String, Object> mtenMap){
		Iterator<String> itr = multipartRequest.getFileNames();
		JSONObject jr = new JSONObject();
		while (itr.hasNext()) { // 받은 파일들을 모두 돌린다.
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			String fileid = commonDao.select("commonSql.getSeq");
			String originalFilename = mpf.getOriginalFilename();
			String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length());
			String serverFileNm = fileid + "." + ext;
			String fileFullPath = mtenMap.get("filePath") + serverFileNm;
			long fileSize = mpf.getSize();
			String FileSize = String.valueOf(fileSize);
			String setFileNm = mtenMap.get("filenm")==null?"":mtenMap.get("filenm").toString();
			if(!setFileNm.equals("")){
				originalFilename = setFileNm+ext;
			}
			
			try {
				boolean pchk = FileUploadUtil.saveFile(mpf, fileFullPath);
				if(pchk) {
					mtenMap.put("fileid", fileid);
					mtenMap.put("viewfilenm", originalFilename);
					mtenMap.put("downfilenm", originalFilename);
//					mtenMap.put("serverfilenm", fileid+ext);
					mtenMap.put("serverfilenm", serverFileNm);
					mtenMap.put("ext", ext);
					mtenMap.put("FILE_SZ", FileSize);
					jr.put("ofname",originalFilename);
					jr.put("fname",fileid+ext);
					commonDao.insert("consultSql.insertFile",mtenMap);
				}else {
					System.out.println("파일업로드 실패");
					jr.put("msg", "개인정보 검출 데이터를 확인하시기 바랍니다.");
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return jr;
	}
	
//	public JSONObject updateConsultState2(Map<String, Object> mtenMap) { //진행상황변경 //이 프로세스 어떻게 녹여야 할지 여쭤보기..담당자 선택으로 바로 저장 되는게 맞을지
//		JSONObject docinfo = new JSONObject();
//		
//		String adm = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
//		String consultid = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
//		String statcd = mtenMap.get("statcd")==null?"":mtenMap.get("statcd").toString();
//		HashMap consultinfo = commonDao.selectOne("consultSql.getConsult", mtenMap);
//		
//		commonDao.update("consultSql.updateConsultState2", mtenMap);
//		docinfo.put("msg", "");
//		return docinfo;
//	}
		// psy
	public JSONObject updateConsultState(Map<String, Object> mtenMap) { //진행상황변경 //이 프로세스 어떻게 녹여야 할지 여쭤보기..담당자 선택으로 바로 저장 되는게 맞을지
		JSONObject docinfo = new JSONObject();
		
		String adm = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String consultid = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String statcd = mtenMap.get("statcd")==null?"":mtenMap.get("statcd").toString();
		HashMap consultinfo = commonDao.selectOne("consultSql.getConsult", mtenMap);
		
		if (!statcd.equals("")) {
			String con = consultinfo.get("INSD_OTSD_TASK_SE")==null?"":consultinfo.get("INSD_OTSD_TASK_SE").toString();
			String CHRGEMPNO = consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString();
			String CHRGEMPNM = consultinfo.get("CNSTN_TKCG_EMP_NM")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NM").toString();
			String WRITEREMPNO = consultinfo.get("CNSTN_RQST_EMP_NO")==null?"":consultinfo.get("CNSTN_RQST_EMP_NO").toString();
			String getConsultno = consultinfo.get("CNSTN_DOC_NO")==null?"":consultinfo.get("CNSTN_DOC_NO").toString();
			String INOUTCON = consultinfo.get("INSD_OTSD_TASK_SE")==null?"":consultinfo.get("INSD_OTSD_TASK_SE").toString();
			String CNSTN_SE_NM = consultinfo.get("CNSTN_SE_NM")==null?"":consultinfo.get("CNSTN_SE_NM").toString();
			String INOUTCONHAN = "";
			
			if ("O".equals(INOUTCON)) {
				INOUTCONHAN = "외부자문";
			} else if ("I".equals(INOUTCON)) {
				INOUTCONHAN = "내부자문";
			} else {
				INOUTCONHAN = "상관없음";
			}
			
			if ("작성중".equals(statcd)) { //접수대기 나눠야하나 상의드려보기_0503
				
				// 이후 단계에서 진행된것들 다 삭제?/ 겁토 담당자만 삭제?
				commonDao.delete("consultSql.deleteConsultLawyer2", mtenMap);
			} else if ("접수대기".equals(statcd)) {
				
				// 의뢰자가 접수요청버튼 누르게 되면 자문의뢰일자 변경 
				commonDao.update("consultSql.updateCnstnRqstYmd", mtenMap);
				
				ArrayList<String> sendUserList = new ArrayList();
				ArrayList<String> sendUserNmList = new ArrayList();
				String title = "";
				String cont = "";
				
				// 법률자문팀장에게 메일 발송
				HashMap map = new HashMap();
				map.put("GRPCD", "Q");
				List teamReader = commonDao.selectList("consultSql.selectConsultTeamReader", map);
				if (teamReader.size() > 0) {
					title = title + "[법률지원통합시스템] 신규 자문건이 등록되었습니다.("+(consultinfo.get("CNSTN_TTL")==null?"":consultinfo.get("CNSTN_TTL").toString());
					title = title + ", "+(consultinfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NM").toString());
					title = title + ", "+INOUTCONHAN+")";
					
					cont = cont + "법률지원통합시스템에 신규 자문건이 등록되었으니, 확인하여주시기 바랍니다.<br/><br/>";
					cont = cont + "제목 : "     + (consultinfo.get("CNSTN_TTL")==null?"":consultinfo.get("CNSTN_TTL").toString())+"<br/>";
					cont = cont + "의뢰부서 : " + (consultinfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NM").toString())+"<br/>";
					cont = cont + "의뢰방법 : " + INOUTCONHAN + "<br/>";
					cont = cont + "의뢰내용 : " + (consultinfo.get("CNSTN_RQST_CN")==null?"":consultinfo.get("CNSTN_RQST_CN").toString());
					
					for(int i=0; i<teamReader.size(); i++) {
						HashMap key = (HashMap)teamReader.get(i);
						sendUserList.add(key.get("EMP_PK_NO")==null?"":key.get("EMP_PK_NO").toString());
						sendUserNmList.add(key.get("EMP_NM")==null?"":key.get("EMP_NM").toString());
					}
					
					SendMail mail = new SendMail();
//					mail.sendMail(title, cont, sendUserList, sendUserNmList, null, ""); // 250710_테스트하면서 알림 안보내지게 로컬 주석
				}
				// 의뢰부서의 팀장, 과장 메일 발송 (CNSTN_RQST_DEPT_TMLDR_EMP_NO ?)
				
				title = "";
				cont = "";
				
				sendUserList = new ArrayList();
				mtenMap.put("EMP_NO", consultinfo.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO")==null?"":consultinfo.get("CNSTN_RQST_DEPT_TMLDR_EMP_NO").toString());
				String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
				
				sendUserList.add(empKey);
				sendUserNmList.add(consultinfo.get("CNSTN_RQST_DEPT_TMLDR_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_TMLDR_NM").toString());
				title = "[법률지원통합시스템] 귀 부서에서 신규 법률자문건을 등록하였습니다.";
				cont = cont + "귀 부서에서 법률지원통합시스템에 신규 법률자문건을 등록하였으니, 참고하시기 바랍니다.<br/>";
				cont = cont + "(법률지원통합시스템 접속방법: 행정포털 > 업무데스크 > 법무 영역 > 법률지원통합시스템 클릭)<br/>";
				cont = cont + "제목 : "     + (consultinfo.get("CNSTN_TTL")==null?"":consultinfo.get("CNSTN_TTL").toString())+"<br/>";
				cont = cont + "의뢰부서 : " + (consultinfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NM").toString())+"<br/>";
				cont = cont + "의뢰방법 : " + INOUTCONHAN;
				cont = cont + "의뢰내용 : " + (consultinfo.get("CNSTN_RQST_CN")==null?"":consultinfo.get("CNSTN_RQST_CN").toString());
				
				SendMail mail = new SendMail();
//				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");	// 250710_테스트하면서 알림 안보내지게 로컬 주석
				
			} else if ("접수".equals(statcd)) {
				
				// 접수 될때 자문 접수 일자 업데이트 해주기 // CNSTN_RCPT_YMD
				commonDao.update("consultSql.updateCnstnRcptYmd", mtenMap);
				
				if (getConsultno.equals("")) {
					String consultno = commonDao.selectOne("consultSql.createConsultno",mtenMap);
					getConsultno = consultno;
					mtenMap.put("consultno", consultno);
					if ("국제".equals(CNSTN_SE_NM)) {
						String consultno2 = commonDao.selectOne("consultSql.createConsultno2",mtenMap);
						mtenMap.put("consultno2", consultno2);
					}
				} else {
					if (adm.equals("")) {
						docinfo.put("msg", "관리번호 부여 중 오류가 발생되었습니다. 관리자에게 문의하세요.");
						return docinfo;
					}
				}
				
//			} else if ("답변중".equals(statcd)) {
			} else if ("내부검토중".equals(statcd)) {
				
			}else if("외부검토중".equals(statcd)){
				String cnstn_tkcg_emp_no = consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString();
				String insd_otsd_task_se = consultinfo.get("INSD_OTSD_TASK_SE")==null?"":consultinfo.get("INSD_OTSD_TASK_SE").toString();
				String EMP_NO = mtenMap.get("userno")==null?"":mtenMap.get("userno").toString();
				
				String CNSTN_DOC_NO = consultinfo.get("CNSTN_DOC_NO")==null?"":consultinfo.get("CNSTN_DOC_NO").toString();
				String CNSTN_TTL = consultinfo.get("CNSTN_TTL")==null?"":consultinfo.get("CNSTN_TTL").toString();
				String CNSTN_RQST_EMP_NM = consultinfo.get("CNSTN_RQST_EMP_NM")==null?"":consultinfo.get("CNSTN_RQST_EMP_NM").toString();
				String CNSTN_RQST_DEPT_NM = consultinfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NM").toString();
				
				ArrayList<String> sendUserList = new ArrayList();
				ArrayList<String> sendUserNmList = new ArrayList();
				String title = "";
				String cont = "";
				
				mtenMap.put("EMP_NO", consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString());
				String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
				sendUserList.add(empKey);
				sendUserNmList.add(consultinfo.get("CNSTN_TKCG_EMP_NM")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NM").toString());
				
				mtenMap.put("CNSTN_MNG_NO", consultinfo.get("CNSTN_MNG_NO")==null?"":consultinfo.get("CNSTN_MNG_NO").toString());
				HashMap lawMap2 = commonDao.selectOne("consultSql.getConsultChrEmpInfo2", mtenMap);
				
				if (lawMap2 != null) {
					title = "[법률지원통합시스템] "+CNSTN_DOC_NO+", "+CNSTN_TTL+"에 대해 답변자로 "+(lawMap2.get("LWYR_NM")==null?"":lawMap2.get("LWYR_NM").toString())+"가 지정되었습니다.";
					cont = cont + "귀하가 등록한 법률자문(외부)에 대해 "+(lawMap2.get("LWYR_NM")==null?"":lawMap2.get("LWYR_NM").toString())+"가 담당자로 지정되었음을 알려드립니다.<br/>";
					cont = cont + "향후 외부 고문변호사와 법률자문 진행 중 법률지원담당관에 문의사항이 있을 시, "+(lawMap2.get("LWYR_NM")==null?"":lawMap2.get("LWYR_NM").toString())+"에게 연락해주시기 바랍니다.<br/>";
					cont = cont + "<br/>";
					cont = cont + "변호사 연락처 : " + (lawMap2.get("OFC_TELNO")==null?"":lawMap2.get("OFC_TELNO").toString());
					
					SendMail mail = new SendMail();
//					mail.sendMail(title, cont, sendUserList, sendUserNmList, null, ""); // 250710_테스트하면서 알림 안보내지게 로컬 주석
				}
			} else if ("답변중".equals(statcd)) {
				
			} else if ("팀장결재중".equals(statcd)) {
				// 팀장에게 알림 필요
				
			} else if ("과장결재중".equals(statcd)) {
				
			} else if ("만족도평가필요".equals(statcd)) {
			} else if ("만족도조사완료".equals(statcd)) {
				
			} else if ("완료".equals(statcd)) {
				String EMP_NO = commonDao.selectOne("consultSql.selectConsultChrEmp", mtenMap);
				HashMap taskMap = new HashMap();
				taskMap.put("EMP_NO", EMP_NO);
				taskMap.put("TASK_SE", "C7");
				taskMap.put("DOC_MNG_NO", consultid);
				taskMap.put("PRCS_YN", "N");
				int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
				if (cnt == 0) {
					mifService.setTask(taskMap);
				}
			}
			
			commonDao.update("consultSql.updateConsultState", mtenMap);
		} else {
			String outreqdt = mtenMap.get("outreqdt")==null?"":mtenMap.get("outreqdt").toString();
			String STATCD = consultinfo.get("STATCD")==null?"":consultinfo.get("STATCD").toString();
			String INOUTCON = consultinfo.get("INOUTCON")==null?"":consultinfo.get("INOUTCON").toString();
			mtenMap.put("statcd", STATCD);
			mtenMap.put("inoutcon", INOUTCON);
			
			commonDao.update("consultSql.updateConsultState", mtenMap);
		}
		docinfo.put("msg", "");
		return docinfo;
//		result.put("msg", "ok");
//		return result;
	}
	
	public JSONObject updateConsultOpenyn(Map<String, Object> mtenMap) { // 공개여부 변경
		JSONObject docinfo = new JSONObject();
		String openyn = mtenMap.get("openyn")==null?"":mtenMap.get("openyn").toString();
		
		commonDao.update("consultSql.updateConsultOpenyn", mtenMap);
		
		
		docinfo.put("msg", "");
		return docinfo;
	}

	public JSONObject consultDelete(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		// TB_CNSTN_MNG DELETE
		commonDao.delete("consultSql.deleteConsult2", mtenMap);
		
		// TB_CNSTN_RVW_OPNN DELETE
		commonDao.delete("consultSql.deleteConsultAnswer", mtenMap);
		
		// TB_CO_CONSULT_FILE DELETE
		commonDao.delete("consultSql.deleteConsultFile", mtenMap);
		
		// TB_CNSTN_RVW_PIC DELETE
		commonDao.delete("consultSql.deleteConsultLawyer2", mtenMap);
		
		// TB_COM_REL_DOC DELETE
		commonDao.delete("consultSql.deleteRelConsult", mtenMap);
		
		// TB_COM_PRSL_AUTHRT DELETE
		commonDao.delete("consultSql.deleteConsultRole", mtenMap);
		
		// TB_CNSTN_MEMO DELETE
		commonDao.delete("consultSql.deleteConsultProg", mtenMap);
		
		result.put("msg", "ok");
		return result;
	}
	
	public List selectChrgEmpList(Map<String, Object> mtenMap) {
		return commonDao.selectList("consultSql.selectChrgEmpList", mtenMap); //psy _w자문팀 담당자 권한 있는 직원만 불러올 수 있게 변경
	}
	
	public List selectRqstDeptManagerList(Map<String, Object> mtenMap) {
		return commonDao.selectList("consultSql.selectRqstDeptManagerList", mtenMap);
	}
	
	public JSONObject setChrgEmpState(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String consultid = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		if (consultid.equals("")) {
			commonDao.update("consultSql.setChrgEmpState", mtenMap);
		} else {
			commonDao.update("consultSql.setChrgEmp", mtenMap);
			int chk = commonDao.selectOne("consultSql.selectAltmntCount", mtenMap); // 마지막 배정일자 있는지 조회
			if (chk > 0) {
				// 마지막 배정일자 업데이트
				commonDao.update("consultSql.updateAltmntYmd", mtenMap);
			}else {
				// 마지막 배정일자 등록
				commonDao.insert("consultSql.insertAltmntYmd", mtenMap);
			}
			
			HashMap consultinfo = commonDao.selectOne("consultSql.getConsult", mtenMap);
			String cnstn_tkcg_emp_no = consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString();
			String insd_otsd_task_se = consultinfo.get("INSD_OTSD_TASK_SE")==null?"":consultinfo.get("INSD_OTSD_TASK_SE").toString();
			String EMP_NO = mtenMap.get("userno")==null?"":mtenMap.get("userno").toString();
			String EMP_NM = mtenMap.get("usernm")==null?"":mtenMap.get("usernm").toString();
			
			String CNSTN_DOC_NO = consultinfo.get("CNSTN_DOC_NO")==null?"":consultinfo.get("CNSTN_DOC_NO").toString();
			String CNSTN_TTL = consultinfo.get("CNSTN_TTL")==null?"":consultinfo.get("CNSTN_TTL").toString();
			String CNSTN_RQST_EMP_NM = consultinfo.get("CNSTN_RQST_EMP_NM")==null?"":consultinfo.get("CNSTN_RQST_EMP_NM").toString();
			String CNSTN_RQST_DEPT_NM = consultinfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NM").toString();
			String INOUTCON = consultinfo.get("INSD_OTSD_TASK_SE")==null?"":consultinfo.get("INSD_OTSD_TASK_SE").toString();
			String INOUTCONHAN = "";
			if ("O".equals(INOUTCON)) {
				INOUTCONHAN = "외부자문";
			} else if ("I".equals(INOUTCON)) {
				INOUTCONHAN = "내부자문";
			} else {
				INOUTCONHAN = "상관없음";
			}
			
			ArrayList<String> sendUserList = new ArrayList();
			ArrayList<String> sendUserNmList = new ArrayList();
			String title = "";
			String cont = "";
			
			if ("I".equals(insd_otsd_task_se)) {
				// 기존 지정 자문  검토 담당자 삭제처리
				commonDao.delete("consultSql.deleteConsultLawyer2", mtenMap);
				
				// 새로 지정된 자문팀 담당자를 동시에 자문 검토 담당자로 등록
				HashMap lawMap = new HashMap();
				lawMap.put("consultid", consultid);
				lawMap.put("inoutcon", "I");
				lawMap.put("chrgempno", mtenMap.get("userno"));
				lawMap.put("chrgempnm", mtenMap.get("usernm"));
				lawMap.put("writer",    mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
				lawMap.put("writerid",  mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
				lawMap.put("deptid",    mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
				lawMap.put("deptname",  mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
				commonDao.insert("consultSql.insertConsultLawyer2", lawMap);
				
				// 자문팀 담당자 등록시 검토자로도 자동 등록되니까 진행상태를 답변중으로 바로 변경해줌 // 추후 답변중으로 수동으로 상태 변경하게끔 변경한다면 이부분은 제거해야할듯.
				HashMap map = new HashMap();
				map.put("consultid", consultid);
//				map.put("statcd", "답변중");
				map.put("statcd", "내부검토중");
				commonDao.update("consultSql.updateConsultState", map);
				// 바로 접수되면서 답변둥으로 넘어가기 때문에 동시에 자문 접수 일자 업데이트 해주기 // CNSTN_RCPT_YMD
				commonDao.update("consultSql.updateCnstnRcptYmd", mtenMap);
				
				mtenMap.put("EMP_NO", consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString());
				String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
				sendUserList.add(empKey);
				sendUserNmList.add(consultinfo.get("CNSTN_TKCG_EMP_NM")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NM").toString());
				
				String empCall = commonDao.selectOne("consultSql.getConsultChrEmpInfo", mtenMap);
				
				title = "[법률지원통합시스템] "+CNSTN_DOC_NO+", "+CNSTN_TTL+"에 대해 답변자로 "+(mtenMap.get("usernm").toString())+"가 지정되었습니다.";
				cont = "귀하가 등록한 법률자문(내부)에 대해 "+mtenMap.get("usernm").toString()+"가 답변자로 지정되었음을 알려드립니다.<br/><br/>변호사 연락처 : " + empCall;
				SendMail mail = new SendMail();
//				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, ""); // 250710_테스트하면서 알림 안보내지게 로컬 주석
			} else {
				// 외부 바문의 경무 자문팀 담당자 등록시 검토자가 들어가있는지 확인하고 둘다 들어가있는 상태면 자동으로 진행상태 답변중으로 변경해줌
				// 추후 답변중으로 수동으로 상태 변경하게끔 변경한다면 이부분은 제거해야할듯.
				int chkRvwPic = commonDao.selectOne("consultSql.chkRvwPic", mtenMap);
				
				if (!"".equals(cnstn_tkcg_emp_no) && chkRvwPic > 0) {
					HashMap map = new HashMap();
					map.put("consultid", consultid);
//					map.put("statcd", "답변중");
					map.put("statcd", "외부검토중");
					commonDao.update("consultSql.updateConsultState", map);
					
					mtenMap.put("EMP_NO", consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString());
					String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
					sendUserList.add(empKey);
					sendUserNmList.add(consultinfo.get("CNSTN_TKCG_EMP_NM")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NM").toString());
					
					mtenMap.put("CNSTN_MNG_NO", consultinfo.get("CNSTN_MNG_NO")==null?"":consultinfo.get("CNSTN_MNG_NO").toString());
					HashMap lawMap2 = commonDao.selectOne("consultSql.getConsultChrEmpInfo2", mtenMap);
					
					if (lawMap2 != null) {
						title = "[법률지원통합시스템] "+CNSTN_DOC_NO+", "+CNSTN_TTL+"에 대해 답변자로 "+(lawMap2.get("LWYR_NM")==null?"":lawMap2.get("LWYR_NM").toString())+"가 지정되었습니다.";
						cont = cont + "귀하가 등록한 법률자문(외부)에 대해 "+(lawMap2.get("LWYR_NM")==null?"":lawMap2.get("LWYR_NM").toString())+"가 담당자로 지정되었음을 알려드립니다.<br/>";
						cont = cont + "향후 외부 고문변호사와 법률자문 진행 중 법률지원담당관에 문의사항이 있을 시, "+(lawMap2.get("LWYR_NM")==null?"":lawMap2.get("LWYR_NM").toString())+"에게 연락해주시기 바랍니다.<br/>";
						cont = cont + "<br/>";
						cont = cont + "변호사 연락처 : " + (lawMap2.get("OFC_TELNO")==null?"":lawMap2.get("OFC_TELNO").toString());
						
						SendMail mail = new SendMail();
//						mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");	// 250710_테스트하면서 알림 안보내지게 로컬 주석
					}
				}
			}
			
			sendUserList = new ArrayList();
			title = "";
			cont = "";
			mtenMap.put("EMP_NO", EMP_NO);
			String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
			sendUserList.add(empKey);
			sendUserNmList.add(EMP_NM);
			
			title = "[법률지원통합시스템] 신규 법률자문이 지정되었습니다.("+INOUTCONHAN+", "+CNSTN_DOC_NO+", "+CNSTN_RQST_DEPT_NM+")";
			cont = cont + "법률지원통합시스템에 신규 자문건이 지정되었으니, 확인하여주시기 바랍니다.<br/>";
			cont = cont + "제목 : "     + CNSTN_TTL+"<br/>";
			cont = cont + "관리번호 : " + CNSTN_DOC_NO+"<br/>";
			cont = cont + "의뢰직원 : " + CNSTN_RQST_EMP_NM+"<br/>";
			cont = cont + "의뢰부서 : " + CNSTN_RQST_DEPT_NM+"<br/>";
			cont = cont + "의뢰방법 : " + INOUTCONHAN;
			cont = cont + "의뢰내용 : " + (consultinfo.get("CNSTN_RQST_CN")==null?"":consultinfo.get("CNSTN_RQST_CN").toString());
			
			SendMail mail = new SendMail();
//			mail.sendMail(title, cont, sendUserList, sendUserNmList, null, ""); // 250710_테스트하면서 알림 안보내지게 로컬 주석
			
			// 나의 할 일 추가 (C1)
			HashMap taskMap = new HashMap();
			taskMap.put("EMP_NO", EMP_NO);
			taskMap.put("TASK_SE", "C1");
			taskMap.put("DOC_MNG_NO", consultid);
			taskMap.put("PRCS_YN", "N");
			int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
			if (cnt == 0) {
				mifService.setTask(taskMap);
			}
		}
		result.put("msg", "ok");
		return result;
	}
	
	public List selectConsultLawyerList(Map mtenMap) {
		List list = commonDao.selectList("consultSql.selectConsultLawyerList", mtenMap);
		return list;
	}
	
	public List selectLawyerList2(Map mtenMap) {
		List list = commonDao.selectList("consultSql.selectLawyerList2", mtenMap);
		return list;
	}
	
	public int selectLawyerTotal(Map mtenMap) {
		int cnt = commonDao.selectOne("consultSql.selectLawyerTotal", mtenMap);
		return cnt;
	}
	
	public JSONObject consultLawInfoSave(Map<String, Object> mtenMap) {
		
		String consultid = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String inoutcon = mtenMap.get("inoutcon")==null?"":mtenMap.get("inoutcon").toString();
		String lawinfo = mtenMap.get("lawyerid")==null?"":mtenMap.get("lawyerid").toString();
		
		// 기존 지정 자문위원 법무법인 삭제처리
		commonDao.delete("consultSql.deleteConsultLawyer2", mtenMap);
		
//		if("I".equals(inoutcon)) {
//			mtenMap.put("statcd", "답변중");
//		}
		
		HashMap consultinfo = commonDao.selectOne("consultSql.getConsult", mtenMap);
		String getConsultno = consultinfo.get("CNSTN_DOC_NO")==null?"":consultinfo.get("CNSTN_DOC_NO").toString();
		String cnstn_tkcg_emp_no = consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString();
		String insd_otsd_task_se = consultinfo.get("INSD_OTSD_TASK_SE")==null?"":consultinfo.get("INSD_OTSD_TASK_SE").toString();
		String EMP_NO = mtenMap.get("userno")==null?"":mtenMap.get("userno").toString();
		
		String CNSTN_DOC_NO = consultinfo.get("CNSTN_DOC_NO")==null?"":consultinfo.get("CNSTN_DOC_NO").toString();
		String CNSTN_TTL = consultinfo.get("CNSTN_TTL")==null?"":consultinfo.get("CNSTN_TTL").toString();
		String CNSTN_RQST_EMP_NM = consultinfo.get("CNSTN_RQST_EMP_NM")==null?"":consultinfo.get("CNSTN_RQST_EMP_NM").toString();
		String CNSTN_RQST_DEPT_NM = consultinfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NM").toString();
		String INOUTCON = consultinfo.get("INSD_OTSD_TASK_SE")==null?"":consultinfo.get("INSD_OTSD_TASK_SE").toString();
		String INOUTCONHAN = "";
		if ("O".equals(INOUTCON)) {
			INOUTCONHAN = "외부자문";
		} else if ("I".equals(INOUTCON)) {
			INOUTCONHAN = "내부자문";
		} else {
			INOUTCONHAN = "상관없음";
		}
		
		if (getConsultno.equals("")) {
//			mtenMap.put("menuid", Constants.Counsel.REP_MENUID);
			String consultno = commonDao.selectOne("consultSql.createConsultno",mtenMap);
			getConsultno = consultno;
			mtenMap.put("consultno", consultno);
		}
		
		String[] lawArr = lawinfo.split(",");
		
		commonDao.update("consultSql.updateConsultState", mtenMap);
		
		HashMap lawMap = new HashMap();
		lawMap.put("consultid", consultid);
		lawMap.put("inoutcon", inoutcon);
		
		lawMap.put("writer",    mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
		lawMap.put("writerid",  mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
		lawMap.put("deptid",    mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
		lawMap.put("deptname",  mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
		
		for(int i=0; i<lawArr.length; i++) {
			lawMap.put("advisorid", lawArr[i]);
			commonDao.insert("consultSql.insertConsultLawyer2", lawMap);
			
			lawMap.put("LWYR_MNG_NO", lawArr[i]);
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", lawMap);
			String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
			if(!mbl_no.equals("")) {
				String title = "서울시 법률자문 의뢰 안내";
				String msg = "서울시 "+(consultinfo.get("CNSTN_TTL")==null?"":consultinfo.get("CNSTN_TTL").toString())+
						", "+(consultinfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultinfo.get("CNSTN_RQST_DEPT_NM").toString())+
						"건에 대한 법률자문 답변자로 지정되었습니다. 서울시 법률지원소통창구에 접속하시어 [승인], [거부]여부를 선택하여 주시기 바랍니다.";
//				SMSClientSend.sendSMS(mbl_no, title, msg); // 250710_테스트하면서 알림 안보내지게 로컬 주석
			}
		}
		
		JSONObject docinfo = new JSONObject();
		docinfo.put("success", true);
		return docinfo;
	}
	
	public JSONObject deleteConsultLawyer2(Map<String, Object> mtenMap) {
		commonDao.delete("consultSql.deleteConsultLawyer2", mtenMap);
		
		JSONObject docinfo = new JSONObject();
		docinfo.put("success", true);
		return docinfo;
	}
	
	public JSONObject selectMemoList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectMemoList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public HashMap selectConsultMemoView(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.selectConsultMemoView", mtenMap);
	}
	
	public List getAnswerFileList(Map mtenMap) {
		List list = commonDao.selectList("consultSql.getAnswerFileList", mtenMap);
		return list;
	}
	
	public JSONObject saveMemoInfo(Map<String, Object> mtenMap){
		String CNSTN_MEMO_MNG_NO = mtenMap.get("CNSTN_MEMO_MNG_NO")==null?"":mtenMap.get("CNSTN_MEMO_MNG_NO").toString();
		String Grpcd = mtenMap.get("Grpcd")==null?"":mtenMap.get("Grpcd").toString();
		String CNSTN_MNG_NO = mtenMap.get("CNSTN_MNG_NO")==null?"":mtenMap.get("CNSTN_MNG_NO").toString();
		
		if (CNSTN_MEMO_MNG_NO.equals("")) {
			commonDao.insert("consultSql.insertConsultMemo",mtenMap);
			CNSTN_MEMO_MNG_NO = mtenMap.get("CNSTN_MEMO_MNG_NO")==null?"":mtenMap.get("CNSTN_MEMO_MNG_NO").toString();
			mtenMap.put("TRGT_PST_MNG_NO", CNSTN_MEMO_MNG_NO);
		} else {
			commonDao.update("consultSql.updateConsultMemo", mtenMap);
			if(mtenMap.get("delfile[]")!=null){
				mtenMap.put("CNSTN_MNG_NO", CNSTN_MNG_NO);
				mtenMap.put("TRGT_PST_MNG_NO", CNSTN_MEMO_MNG_NO);
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("consultSql.deleteFile", mtenMap);
					}
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("consultSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		if (CNSTN_MEMO_MNG_NO.equals("")) {
			mtenMap.put("consultid", CNSTN_MNG_NO);
			HashMap consultInfo = commonDao.selectOne("consultSql.getConsult", mtenMap);
			
			if ("X".equals(Grpcd)) {
				// 변호사가 등록했을 경우 내부변호사 나의할일에 추가
				HashMap taskMap = new HashMap();
				String EMP_NO = commonDao.selectOne("consultSql.selectConsultChrEmp", mtenMap);
				
				taskMap.put("EMP_NO", EMP_NO);
				taskMap.put("TASK_SE", "C5");
				taskMap.put("DOC_MNG_NO",  mtenMap.get("consultid")==null?"": mtenMap.get("consultid").toString());
				taskMap.put("PRCS_YN", "N");
				int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
				if (cnt == 0) {
					mifService.setTask(taskMap);
				}
				
				ArrayList<String> sendUserList = new ArrayList();
				ArrayList<String> sendUserNmList = new ArrayList();
				
				HashMap tmpMap = new HashMap();
				tmpMap.put("EMP_NO", consultInfo.get("CNSTN_RQST_EMP_NO")==null?"":consultInfo.get("CNSTN_RQST_EMP_NO").toString());
				sendUserList.add(commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap));
				sendUserNmList.add(consultInfo.get("CNSTN_RQST_EMP_NM")==null?"":consultInfo.get("CNSTN_RQST_EMP_NM").toString());
				
				tmpMap.put("EMP_NO", consultInfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultInfo.get("CNSTN_TKCG_EMP_NO").toString());
				sendUserList.add(commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap));
				sendUserNmList.add(consultInfo.get("CNSTN_TKCG_EMP_NM")==null?"":consultInfo.get("CNSTN_TKCG_EMP_NM").toString());
				
				String title = "[법률지원통합시스템] "+(consultInfo.get("CNSTN_DOC_NO")==null?"":consultInfo.get("CNSTN_DOC_NO").toString())+"에 의견이 등록되었습니다.";
				String cont = (consultInfo.get("CNSTN_DOC_NO")==null?"":consultInfo.get("CNSTN_DOC_NO").toString())+
						"에 의견이 등록되었으니, 법률지원통합시스템에 접속하여 확인하시기 바랍니다.";
				SendMail mail = new SendMail();
//				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, ""); // 250710_테스트하면서 알림 안보내지게 로컬 주석
			} else {
				// 외부 변호사에게 알림 문자 발송
				// {사건번호}에 의견이 등록되었으니, 법률지원소통창구에 접속하여 확인하시기 바랍니다.
				
				List lawyerList = commonDao.selectList("consultSql.selectConsultLawyerList", mtenMap);
				if(lawyerList.size() > 0) {
					for(int i=0; i<lawyerList.size(); i++) {
						HashMap lawyerMap = (HashMap)lawyerList.get(i);
						lawyerMap.put("LWYR_MNG_NO", lawyerMap.get("RVW_TKCG_EMP_NO")==null?"":lawyerMap.get("RVW_TKCG_EMP_NO").toString());
						HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", lawyerMap);
						
						if (mbl != null) {
							String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
							if(!mbl_no.equals("")) {
								String title = "[서울시 법률지원소통창구]"+(consultInfo.get("CNSTN_DOC_NO")==null?"":consultInfo.get("CNSTN_DOC_NO").toString())+"의견 등록 알림";
								String msg = (consultInfo.get("CNSTN_DOC_NO")==null?"":consultInfo.get("CNSTN_DOC_NO").toString())+"에 의견이 등록되었으니, 법률지원소통창구에 접속하여 확인하시기 바랍니다.";
//								SMSClientSend.sendSMS(mbl_no, title, msg); // 250710_테스트하면서 알림 안보내지게 로컬 주석
							}
						}
					}
				}
			}
		}
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject deleteMemo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		mtenMap.put("gbnid", mtenMap.get("CNSTN_MNG_NO"));
		mtenMap.put("TRGT_PST_MNG_NO", mtenMap.get("CNSTN_MEMO_MNG_NO"));
		
		commonDao.delete("consultSql.deleteFile", mtenMap);
		commonDao.delete("consultSql.deleteConsultMemo", mtenMap);
		
		result.put("msg", "ok");
		return result;
	}
	
	public HashMap selectConsultAnswerView(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.selectConsultAnswerView", mtenMap);
	}
	
	public JSONObject answerSave(Map<String, Object> mtenMap){
		String RVW_OPNN_MNG_NO = mtenMap.get("RVW_OPNN_MNG_NO")==null?"":mtenMap.get("RVW_OPNN_MNG_NO").toString();
		String CNSTN_MNG_NO = mtenMap.get("CNSTN_MNG_NO")==null?"":mtenMap.get("CNSTN_MNG_NO").toString();
		String Grpcd = mtenMap.get("Grpcd")==null?"":mtenMap.get("Grpcd").toString();
		HashMap consult = commonDao.selectOne("consultSql.getConsult", mtenMap);
		
		String lawfirm = mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString();
		String LwyrNm = mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString();
		
		if (RVW_OPNN_MNG_NO.equals("")) {
			commonDao.insert("consultSql.insertAnswerBoard",mtenMap);
			commonDao.update("consultSql.updateLawyerChckid", mtenMap);	// chckid update
			mtenMap.put("gbnid", CNSTN_MNG_NO);
			RVW_OPNN_MNG_NO = mtenMap.get("RVW_OPNN_MNG_NO")==null?"":mtenMap.get("RVW_OPNN_MNG_NO").toString();
			mtenMap.put("TRGT_PST_MNG_NO", RVW_OPNN_MNG_NO);
		} else {
			commonDao.update("consultSql.updateAnswerBoard", mtenMap);
			mtenMap.put("gbnid", CNSTN_MNG_NO);
			mtenMap.put("TRGT_PST_MNG_NO", RVW_OPNN_MNG_NO);
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("consultSql.deleteFile", mtenMap);
					}
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("consultSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		if (RVW_OPNN_MNG_NO.equals("")) {
			if("X".equals(Grpcd)) {
				// 변호사가 등록했을 경우 내부변호사 나의할일에 추가
				HashMap taskMap = new HashMap();
				String EMP_NO = commonDao.selectOne("consultSql.selectConsultChrEmp", mtenMap);
				
				taskMap.put("EMP_NO", EMP_NO);
				taskMap.put("TASK_SE", "C6");
				taskMap.put("DOC_MNG_NO", mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString());
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
				tmpMap.put("EMP_NO", consult.get("CNSTN_RQST_EMP_NO")==null?"":consult.get("CNSTN_RQST_EMP_NO").toString());
				sendUserList.add(commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap));
				sendUserNmList.add(consult.get("CNSTN_RQST_EMP_NM")==null?"":consult.get("CNSTN_RQST_EMP_NM").toString());
				
				tmpMap.put("EMP_NO", consult.get("CNSTN_TKCG_EMP_NO")==null?"":consult.get("CNSTN_TKCG_EMP_NO").toString());
				sendUserList.add(commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap));
				sendUserNmList.add(consult.get("CNSTN_TKCG_EMP_NM")==null?"":consult.get("CNSTN_TKCG_EMP_NM").toString());
				
				String title = "[법률지원통합시스템] "+(consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+
						", "+(consult.get("CNSTN_TTL")==null?"":consult.get("CNSTN_TTL").toString())+
						"에 대해 "+(lawfirm+" "+LwyrNm)+"가 답변을 등록하였습니다.";
				String cont = "법률지원통합시스템에 답변이 등록되었으니, 확인하여주시기 바랍니다.<br/><br/>";
				cont = cont + "제목 : " + (consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+" "+(consult.get("CNSTN_TTL")==null?"":consult.get("CNSTN_TTL").toString())+"<br/>";
				cont = cont + "부서 : " + (consult.get("CNSTN_RQST_DEPT_NM")==null?"":consult.get("CNSTN_RQST_DEPT_NM").toString())+" "+(consult.get("CNSTN_RQST_EMP_NM")==null?"":consult.get("CNSTN_RQST_EMP_NM").toString())+"<br/>";
				cont = cont + "고문변호사 : " + (lawfirm+" "+LwyrNm);
				SendMail mail = new SendMail();
//				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, ""); // 250710_테스트하면서 알림 안보내지게 로컬 주석
			}
		}
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject deleteAnswer(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		mtenMap.put("gbnid", mtenMap.get("consultid"));
		
		commonDao.delete("consultSql.deleteFile", mtenMap);
		commonDao.delete("consultSql.deleteAnswer", mtenMap);
		
		// 검토 담당자 정보에서 RVW_OPNN_MNG_NO(검토의견 관리 번호) 제거
		HashMap param = new HashMap();
		param.put("chckid", "");
		param.put("CONSULTLAWYERID", mtenMap.get("CONSULTLAWYERID")==null?"":mtenMap.get("CONSULTLAWYERID").toString());
		commonDao.update("consultSql.updateLawyerChckid", param);
		
		result.put("msg", "ok");
		return result;
	}
	
	public JSONObject answerResultSave(Map<String, Object> mtenMap){
		String inoutcon = mtenMap.get("inoutcon")==null?"":mtenMap.get("inoutcon").toString();
		String prgrs_stts = mtenMap.get("prgrs_stts")==null?"":mtenMap.get("prgrs_stts").toString();
		String statenm = "답변완료";
//		if ("O".equals(inoutcon)) { // 외부의 경우에 만족도 평가 필요로 변경하시려고 하신게 맞을지?
//			statenm = "만족도평가필요";
//		}

		commonDao.update("consultSql.answerResultSave", mtenMap);
		
		HashMap param = new HashMap();
		param.put("consultid", mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString());
		param.put("gbn", "N");
//		List lawyerList = commonDao.selectList("consultSql.selectConsultLawyerList", param);
//		List answerList = commonDao.selectList("consultSql.selectAnswerBoard", param);
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
//			// CONSULT 테이블 STATECD를 답변완료로 변경해야함!!!
//			param = new HashMap();
//			param.put("consultid", mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString());
//			param.put("statcd", statenm);
//			commonDao.update("consultSql.updateConsultState", param);
//			
//			// 답변완료료 상태 변경될시에 자문회신일자 업데이트 해주기
//			commonDao.update("consultSql.updateCnstnRplyYmd", param);
//		}
		if ("I".equals(inoutcon)) { // 외부의 경우에 만족도 평가 필요로 변경하시려고 하신게 맞을지?
			statenm = "팀장결재중";
			//250618알림필요-내부 자문 답변완료버튼 누를시에 팀장결재중으로 바로 넘기면서 알림 발송 필요할듯.
		} 
		// CONSULT 테이블 STATECD를 답변완료로 변경해야함!!!
		param = new HashMap();
		param.put("consultid", mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString());
		param.put("statcd", statenm);
		commonDao.update("consultSql.updateConsultState", param);
		
		// 답변완료료 상태 변경될시에 자문회신일자 업데이트 해주기
		commonDao.update("consultSql.updateCnstnRplyYmd", param);
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject setConsultRvwPic(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String consultid = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String userno = mtenMap.get("userno")==null?"":mtenMap.get("userno").toString();
		String usernm = mtenMap.get("usernm")==null?"":mtenMap.get("usernm").toString();
		if (consultid.equals("")) {
//			commonDao.update("consultSql.setChrgEmpState", mtenMap);
		} else {
//			commonDao.update("consultSql.setChrgEmp", mtenMap);
			int chk = commonDao.selectOne("consultSql.chkRvwPic", mtenMap); // 자문 검토 담당자가 이미 있는지 조회
			if (chk > 0) {
				// 자문 검토 담당자 수정
				commonDao.update("consultSql.updateRvwPic", mtenMap);
			}else {
				// 자문 검토 담당자 등록
//				commonDao.insert("consultSql.insertRvwPic", mtenMap); // 이렇게 만들려고 했지만 기존 자문 검토자 insert 쿼리 써보도록..
				HashMap map = new HashMap();
				map.put("consultid", consultid);
				map.put("inoutcon", "O");
				map.put("chrgempno", userno);
				map.put("chrgempnm", usernm);
				map.put("writer", mtenMap.get("WRTR_EMP_NM").toString());
				map.put("writerid", mtenMap.get("WRTR_EMP_NO").toString());
				map.put("deptname", mtenMap.get("WRT_DEPT_NM").toString());
				map.put("deptid", mtenMap.get("WRT_DEPT_NO").toString());
				commonDao.insert("consultSql.insertConsultLawyer2", map);
			}
			
			HashMap consultinfo = commonDao.selectOne("consultSql.getConsult", mtenMap);
			String cnstn_tkcg_emp_no = consultinfo.get("CNSTN_TKCG_EMP_NO")==null?"":consultinfo.get("CNSTN_TKCG_EMP_NO").toString();
			
			int chkRvwPic = commonDao.selectOne("consultSql.chkRvwPic", mtenMap);
			
			if (!"".equals(cnstn_tkcg_emp_no) && chkRvwPic > 0) {
				HashMap map = new HashMap();
				map.put("consultid", consultid);
				map.put("statcd", "답변중");
				commonDao.update("consultSql.updateConsultState", map);
			}
		}
		result.put("msg", "ok");
		return result;
	}	
	
	
	
	public JSONObject selectSatisfactionList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectSatisfactionList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public List getSatisfactionList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("consultSql.getSatisfactionList", mtenMap);
		return list;
	}
	
	public List getLawyerList2(Map<String, Object> mtenMap) {
		//List list = commonDao.selectList("suitSql.getLawyerList", mtenMap);
		List list = commonDao.selectList("consultSql.selectConsultLawyerList", mtenMap);
		return list;
	}
	
	public List getProcSatisList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("consultSql.getProcSatisList", mtenMap);
		return list;
	}
	
	public List getSatisitemList2(Map<String, Object> mtenMap) {
		
		mtenMap.put("SRVY_SE", "CON");
		
		List list = commonDao.selectList("suitSql.getSatisitemList", mtenMap);
		return list;
	}
	
	public HashMap getOutConsultCnt (Map<String, Object> mtenMap) {
		
		return commonDao.selectOne("consultSql.getOutConsultCnt", mtenMap);
		
	}

	public JSONObject selectOutConsultList(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("consultSql.selectOutConsultList", mtenMap);
		int cnt = commonDao.select("consultSql.selectOutConsultListTotal", mtenMap);
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	
	
	public JSONObject setConsultCost(Map<String, Object> mtenMap){
		String CNSTN_CST_MNG_NO = mtenMap.get("CNSTN_CST_MNG_NO")==null?"":mtenMap.get("CNSTN_CST_MNG_NO").toString();
		
		if (CNSTN_CST_MNG_NO.equals("")) {
			commonDao.insert("consultSql.insertConsultCost", mtenMap);
		} else {
			commonDao.update("consultSql.updateConsultCost", mtenMap);
		}
		
		mtenMap.put("consultid", mtenMap.get("CNSTN_MNG_NO")==null?"":mtenMap.get("CNSTN_MNG_NO").toString());
		HashMap consult = commonDao.selectOne("consultSql.getConsult", mtenMap);
		String CST_PRGRS_STTS_SE = mtenMap.get("CST_PRGRS_STTS_SE")==null?"R":mtenMap.get("CST_PRGRS_STTS_SE").toString();
		if("R".equals(CST_PRGRS_STTS_SE) || "Z".equals(CST_PRGRS_STTS_SE)){//"X".equals(CST_PRGRS_STTS_SE)) {
			String title = "[법률지원통합시스템] "+(consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+" 사건의 자문비용 지급요청건이 있습니다.";
			String cont = "";
			cont = cont + "아래 사건에 대해 자문비용 지급 요청이 있으니, 법률지원통합시스템에 접속하여 확인하여주시기 바랍니다.<br/>";
			cont = cont + "자문상세 메뉴에서 자문비용 지급 요청내용을 확인하시고, 이상이 없을 경우 [승인] 버튼을, 보완이 필요할 경우 [보완]버튼을 클릭하여 주시기 바랍니다.<br/>";
			cont = cont + "자문정보 : "+(consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+" "+(consult.get("CNSTN_TTL")==null?"":consult.get("CNSTN_TTL").toString())+"<br/>";
			cont = cont + "요청 비용 : "+(mtenMap.get("CNSTN_CST_AMT")==null?"":mtenMap.get("CNSTN_CST_AMT").toString());
			
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
//			mail.sendMail(title, cont, sendUserList, sendUserNmList, null, ""); // 250710_테스트하면서 알림 안보내지게 로컬 주석
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
				String title = "[서울시 법률지원소통창구] "+(consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+" 자문료 지급완료";
				String msg = "[서울시 법률지원소통창구] "+(consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+" 자문료 지급 요청건에 대해 지급이 완료되었습니다. (지급 금액 : "+(mtenMap.get("CNSTN_CST_AMT")==null?"":mtenMap.get("CNSTN_CST_AMT").toString())+")";
//				SMSClientSend.sendSMS(mbl_no, title, msg);	// 250710_테스트하면서 알림 안보내지게 로컬 주석
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject setCostInfo(Map<String, Object> mtenMap){
		commonDao.update("consultSql.setCostInfo", mtenMap);
		
		String CST_PRGRS_STTS_SE = mtenMap.get("CST_PRGRS_STTS_SE")==null?"":mtenMap.get("CST_PRGRS_STTS_SE").toString();
		String RVW_TKCG_EMP_NO = mtenMap.get("RVW_TKCG_EMP_NO")==null?"":mtenMap.get("RVW_TKCG_EMP_NO").toString();
		if("X".equals(CST_PRGRS_STTS_SE)) {
			// 보완요청
			// 외부변호사에게 문자 발송
			mtenMap.put("LWYR_MNG_NO", RVW_TKCG_EMP_NO);
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", mtenMap);
			
			String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
			if(!mbl_no.equals("")) {
				String title = "[서울시 법률지원소통창구] 자문료 지급요청건 보완필요";
				String msg = "[서울시 법률지원소통창구] 자문료 지급요청건의 보완이 필요합니다. 자세한 내용은 서울시 법률지원소통창구에 접속하여 확인바랍니다.";
//				SMSClientSend.sendSMS(mbl_no, title, msg); // 250710_테스트하면서 알림 안보내지게 로컬 주석
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	// 구두 자문 목록 데이터
	public JSONObject verbalAdviceListData(Map<String, Object> mtenMap) {
		List llist = commonDao.selectList("consultSql.getVerbalAdviceList", mtenMap);
		int cnt = commonDao.select("consultSql.getVerbalAdviceTotal", mtenMap);		
		JSONObject result = new JSONObject();
		JSONArray jr = JSONArray.fromObject(llist);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject verbalAdviceSave(Map<String, Object> mtenMap){
		String CONSULTID = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String writerdept = mtenMap.get("writerdeptcd")==null?"":mtenMap.get("writerdeptcd").toString();
		String cnstn_rqst_emp_no = mtenMap.get("cnstn_rqst_emp_no")==null?"":mtenMap.get("cnstn_rqst_emp_no").toString();
		String cnstn_rqst_dept_no = mtenMap.get("cnstn_rqst_dept_no")==null?"":mtenMap.get("cnstn_rqst_dept_no").toString();
		if(CONSULTID.equals("")) {
			commonDao.insert("consultSql.insertVerbalAdvice", mtenMap);
			mtenMap.put("gbnid", mtenMap.get("cnstn_mng_no"));
			
			CONSULTID = mtenMap.get("cnstn_mng_no")==null?"":mtenMap.get("cnstn_mng_no").toString();
			System.out.println("??????????????????????????????????? " + CONSULTID);
		}else {
			commonDao.update("consultSql.updateVerbalAdvice", mtenMap);
			System.out.println("수정할때 자문 고유 번호 뭔가??? " + mtenMap.get("consultid"));
			mtenMap.put("gbnid", mtenMap.get("consultid"));
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("consultSql.deleteFile", mtenMap);
					}
						
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("consultSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		// 권한 삭제
//		HashMap map = new HashMap();
//		map.put("docid", CONSULTID);
//		map.put("rolegbn", "DW");
//		map.put("docgbn", "CONSULT");
//		commonDao.delete("consultSql.deleteRole", map);
		
		// 권한 재등록 (부서단위)
		HashMap params = new HashMap();
		params.put("doc_mng_no", CONSULTID);
		params.put("doc_se", "CONSUL");
		params.put("authrt_se", "P");
		params.put("authrt_emp_no", cnstn_rqst_emp_no);
		params.put("authrt_dept_no", cnstn_rqst_dept_no);
		params.put("writer", mtenMap.get("WRTR_EMP_NM").toString());
		params.put("writerid", mtenMap.get("WRTR_EMP_NO").toString());
		params.put("deptname", mtenMap.get("WRT_DEPT_NM").toString());
		params.put("deptid", mtenMap.get("WRT_DEPT_NO").toString());
		commonDao.insert("consultSql.insertRole", params);
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject verbalAdviceDelete(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		// TB_CNSTN_MNG DELETE
		commonDao.delete("consultSql.deleteConsult2", mtenMap);
		
		// TB_CO_CONSULT_FILE DELETE
		commonDao.delete("consultSql.deleteConsultFile", mtenMap);
		
		result.put("msg", "ok");
		return result;
	}
	
	public JSONArray getDeptList(Map mtenMap) {
		List<HashMap> nodeList = commonDao.selectList("consultSql.getDeptList",mtenMap);
		for(int i=0; i<nodeList.size(); i++) {
			HashMap result = nodeList.get(i);
			String gbn = result.get("SORT_SEQ")==null?"":result.get("SORT_SEQ").toString();
			String useyn = result.get("USE_YN")==null?"":result.get("USE_YN").toString();
			boolean leaf = false;
			result.put("text", result.get("DEPT_NM"));
			result.put("id", result.get("DEPT_NO"));
			result.put("cls", gbn);
			result.put("leaf", leaf);
			result.put("qtip", result.get("DEPT_NM"));
		}
		JSONArray jl = JSONArray.fromObject(nodeList);
		return jl;
	}
	
	// 구두자문 직원선택 팝업 직원 목록
	public JSONObject selectUserList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("consultSql.selectUserList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	// 구두자문 직원선택 팝업 부서 목록
	public JSONObject selectDeptList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectDeptList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	// 자문 내/외부 유형 변경
	public JSONObject updateInsdOtsdTaskSe(Map<String, Object> mtenMap) {
		JSONObject docinfo = new JSONObject();
		
		commonDao.update("consultSql.updateInsdOtsdTaskSe", mtenMap);
		
		
		docinfo.put("msg", "");
		return docinfo;
	}
	
	// 목록화면 통계그림 진행상태 전체 건수 조회
	public int selectStateTotalCnt(Map<String, Object> mtenMap) {
		int cnt = commonDao.select("consultSql.selectStateTotalCnt", mtenMap);
		return cnt;
	}
	
	// 목록화면 통계그림 진행상태별 건수 조회
	public List selectStateCnt(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("consultSql.selectStateCnt", mtenMap);
		return list;
	}
	
	public HashMap selectConsultReviewComment(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.selectConsultReviewComment", mtenMap);
	}
	
	public JSONObject saveReviewComment(Map<String, Object> mtenMap){
		String CNSTN_MNG_NO = mtenMap.get("CNSTN_MNG_NO")==null?"":mtenMap.get("CNSTN_MNG_NO").toString();
		
		commonDao.update("consultSql.updateConsultReviewComment", mtenMap);
		mtenMap.put("CNSTN_MNG_NO", CNSTN_MNG_NO);
		if(mtenMap.get("delfile[]")!=null){
			mtenMap.put("CNSTN_MNG_NO", CNSTN_MNG_NO);
			if(mtenMap.get("delfile[]").getClass().equals(String.class)){
				if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
					mtenMap.put("fileid", mtenMap.get("delfile[]"));
					commonDao.delete("consultSql.deleteFile", mtenMap);
				}
			}else{
				ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
				for(int i=0; i<delfile.size(); i++){
					if(delfile.get(i) != null && !delfile.get(i).equals("")){
						mtenMap.put("fileid", delfile.get(i));
						commonDao.delete("consultSql.deleteFile", mtenMap);
					}
				}
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject deleteReviewComment(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		commonDao.delete("consultSql.deleteGbnFile", mtenMap);
		mtenMap.put("CNSTN_ANS_RVW_OPNN_CN", "");
		commonDao.delete("consultSql.updateConsultReviewComment", mtenMap);
		
		result.put("msg", "ok");
		return result;
	}

	public JSONObject rfslRsnSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String RCPT_YN = mtenMap.get("RCPT_YN")==null?"":mtenMap.get("RCPT_YN").toString();
		String DOC_PK = mtenMap.get("DOC_PK")==null?"":mtenMap.get("DOC_PK").toString();
		String LWYR_NM = mtenMap.get("LWYR_NM")==null?"":mtenMap.get("LWYR_NM").toString();
		String EMP_NO = commonDao.selectOne("consultSql.selectConsultChrEmp", mtenMap);
		String sendyn = "";
		HashMap taskMap = new HashMap();
		taskMap.put("EMP_NO", EMP_NO);
		taskMap.put("DOC_MNG_NO", DOC_PK);
		taskMap.put("PRCS_YN", "N");
		
		mtenMap.put("consultid", DOC_PK);
		HashMap consultInfo = commonDao.selectOne("consultSql.getConsult", mtenMap);
		
		if ("N".equals(RCPT_YN)) {
			// 담당자 알림 전송 (문자 or 매신저 or 메일)
			// 진행상태 돌리기 (-> 접수)
			mtenMap.put("statcd", "접수");
			commonDao.update("consultSql.updateConsultStateRfslRsn", mtenMap);
			sendyn = "거부";
			taskMap.put("TASK_SE", "C3");
		} else {
			sendyn = "승인";
			taskMap.put("TASK_SE", "C4");
			
			// 자문 요청자 메일발송
			
			String cont = "";
			ArrayList<String> sendUserList = new ArrayList();
			ArrayList<String> sendUserNmList = new ArrayList();
			
			HashMap tmpMap = new HashMap();
			tmpMap.put("EMP_NO", consultInfo.get("CNSTN_RQST_EMP_NO")==null?"":consultInfo.get("CNSTN_RQST_EMP_NO").toString());
			String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", tmpMap);
			
			tmpMap.put("LWYR_MNG_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", tmpMap);
			
			sendUserList.add(empKey);
			sendUserNmList.add(consultInfo.get("CNSTN_RQST_EMP_NM")==null?"":consultInfo.get("CNSTN_RQST_EMP_NM").toString());
			
			//[법률지원통합시스템] {관리번호}, {제목}에 대한 고문변호사로 {고문변호사명}이/가 지정되었습니다.
			// 귀하가 등록한 법률자문(외부)에 대해 {고문변호사}가 고문변호사로 지정되었음을 알려드립니다.
			//{고문변호사 연락처 정보}
			String title = "[법률지원통합시스템] "+(consultInfo.get("CNSTN_DOC_NO")==null?"":consultInfo.get("CNSTN_DOC_NO").toString())+
					", "+(consultInfo.get("CNSTN_TTL")==null?"":consultInfo.get("CNSTN_TTL").toString())+
					"에 대한 고문변호사로 "+LWYR_NM+"이/가 지정되었습니다.";
			cont = "귀하가 등록한 법률자문(외부)에 대해 "+LWYR_NM+"가 고문변호사로 지정되었음을 알려드립니다.<br/>";
			cont = cont + "개인연락처 : " + (mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString()) + "<br/>";
			cont = cont + "사무실연락처 : " + (mbl.get("OFC_TELNO")==null?"":mbl.get("OFC_TELNO").toString()) + "<br/>";
			cont = cont + "이메일 : " + (mbl.get("EML_ADDR")==null?"":mbl.get("EML_ADDR").toString());
			SendMail mail = new SendMail();
//			mail.sendMail(title, cont, sendUserList, sendUserNmList, null, ""); // 250710_테스트하면서 알림 안보내지게 로컬 주석
		}
		
		int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
		if (cnt == 0) {
			mifService.setTask(taskMap);
		}
		commonDao.update("consultSql.setRfslRsn", mtenMap);
		
		// 내부담당자 (법무팀)
		// CNSTN_TKCG_EMP_NO
		// 내부담당자 팀장 (법무팀)
		HashMap map = new HashMap();
		map.put("GRPCD", "Q");
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
			
			String title = "[법률지원통합시스템] 외부 법률자문에 대해 "+LWYR_NM+
					"이/가 "+sendyn+"하였습니다. ("+
					(consultInfo.get("CNSTN_DOC_NO")==null?"":consultInfo.get("CNSTN_DOC_NO").toString())+", "+
					(consultInfo.get("CNSTN_TTL")==null?"":consultInfo.get("CNSTN_TTL").toString())+", "+
					(consultInfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultInfo.get("CNSTN_RQST_DEPT_NM").toString())+")";
			
			String cont = "외부 법률자문 건에 대해 "+LWYR_NM+"이/가 "+sendyn+"하였습니다. 후속 절차를 진행해주시기 바랍니다.<br/><br/>";
			cont = cont + "관리번호 : "+(consultInfo.get("CNSTN_DOC_NO")==null?"":consultInfo.get("CNSTN_DOC_NO").toString())+"<br/>";
			cont = cont + "제목 : "+(consultInfo.get("CNSTN_TTL")==null?"":consultInfo.get("CNSTN_TTL").toString())+"<br/>";
			cont = cont + "부서 : "+(consultInfo.get("CNSTN_RQST_DEPT_NM")==null?"":consultInfo.get("CNSTN_RQST_DEPT_NM").toString())+"<br/>";
			cont = cont + "작성자 : "+(consultInfo.get("CNSTN_RQST_EMP_NM")==null?"":consultInfo.get("CNSTN_RQST_EMP_NM").toString());
			
			SendMail mail = new SendMail();
//			mail.sendMail(title, cont, sendUserList, sendUserNmList, null, ""); // 250710_테스트하면서 알림 안보내지게 로컬 주석
		}
		
		result.put("msg", "ok");
		return result;
	}
	
	public String getCnt1() {
		return commonDao.select("consultSql.getMainConsultCnt1");
	}
	
	public String getCnt2(String userId) {
		return commonDao.select("consultSql.getMainConsultCnt2", userId);
	}
	
	public String getCnt3() {
		Date now = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String formatedNow = formatter.format(now);
		
		HashMap map = new HashMap();
		map.put("start", formatedNow);
		map.put("end", formatedNow);
		map.put("gbn", "S");
		List calList = commonDao.selectList("consultSql.selectCalData", map);
		
		String calCnt = calList.size()+"";
		return calCnt;
	}
	
	public List selectConsultMainList1(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("consultSql.getConsultList", mtenMap);
		return list;
	}
	
	public List selectConsultMainList2(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("consultSql.selectConsultMainList", mtenMap);
		return list;
	}
	
	public String getMainConCstCnt() {
		return commonDao.select("consultSql.getMainConCstCnt");
	}
	
	public List selectMainConCstList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("consultSql.selectMainConCstList", mtenMap);
		return list;
	}
	
	public HashMap selectMainConCnt(String userId) {
		return commonDao.select("consultSql.selectMainConCnt", userId);
	}
	
	public HashMap getDeptHeadInfo(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.getDeptHeadInfo", mtenMap);
	}
	
	public JSONObject updateConsultState2(Map<String, Object> mtenMap) { // 우측 상단 전체관리자 진행상황변경 콤보박스
		JSONObject docinfo = new JSONObject();
		
		String adm = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String consultid = mtenMap.get("consultid")==null?"":mtenMap.get("consultid").toString();
		String statcd = mtenMap.get("statcd")==null?"":mtenMap.get("statcd").toString();
		
		commonDao.update("consultSql.updateConsultState2", mtenMap);
		docinfo.put("msg", "");
		return docinfo;
	}
	
	
	public List selectConsultChrgCost(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("consultSql.selectConsultChrgCost", mtenMap);
		return list;
	}
	
	public JSONObject updateChrgLawyerAmt(Map<String, Object> mtenMap) {
		String CST_PRGRS_STTS_SE = mtenMap.get("CST_PRGRS_STTS_SE")==null?"":mtenMap.get("CST_PRGRS_STTS_SE").toString();
		String RVW_TKCG_EMP_NO = mtenMap.get("RVW_TKCG_EMP_NO")==null?"":mtenMap.get("RVW_TKCG_EMP_NO").toString();
		String CNSTN_CST_AMT = mtenMap.get("CNSTN_CST_AMT")==null?"":mtenMap.get("CNSTN_CST_AMT").toString();
		
		
		commonDao.update("consultSql.updateChrgLawyerAmt", mtenMap);
		
		if("X".equals(CST_PRGRS_STTS_SE)) {
			// 보완요청
			// 외부변호사에게 문자 발송
			mtenMap.put("LWYR_MNG_NO", RVW_TKCG_EMP_NO);
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", mtenMap);
			
			String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
			if(!mbl_no.equals("")) {
				String title = "[서울시 법률지원소통창구] 자문료 지급요청건 보완필요";
				String msg = "[서울시 법률지원소통창구] 자문료 지급요청건의 보완이 필요합니다. 자세한 내용은 서울시 법률지원소통창구에 접속하여 확인바랍니다.";
//				SMSClientSend.sendSMS(mbl_no, title, msg); // 250710_테스트하면서 알림 안보내지게 로컬 주석
			}
		}
		
		if("C".equals(CST_PRGRS_STTS_SE)) {
			// 지급 안내
			// RVW_TKCG_EMP_NO
			// [서울시 법률지원소통창구] {사건번호} 자문료 지급완료
			// [서울시 법률지원소통창구] {사건번호} 자문료 지급 요청건에 대해 지급이 완료되었습니다.
			// {지급 금액, 지급 항목 등}
			HashMap consult = commonDao.selectOne("consultSql.getConsult", mtenMap);
			mtenMap.put("LWYR_MNG_NO", mtenMap.get("RVW_TKCG_EMP_NO")==null?"":mtenMap.get("RVW_TKCG_EMP_NO").toString());
			HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", mtenMap);
			String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
			if(!mbl_no.equals("")) {
				String title = "[서울시 법률지원소통창구] "+(consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+" 자문료 지급완료";
				String msg = "[서울시 법률지원소통창구] "+(consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+" 자문료 지급 요청건에 대해 지급이 완료되었습니다. (지급 금액 : "+(CNSTN_CST_AMT)+")";
//				SMSClientSend.sendSMS(mbl_no, title, msg); // 250710_테스트하면서 알림 안보내지게 로컬 주석
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject updateChrgLawyerAmtList(Map<String, Object> mtenMap) {
		String CST_PRGRS_STTS_SE    = mtenMap.get("CST_PRGRS_STTS_SE")==null?"":mtenMap.get("CST_PRGRS_STTS_SE").toString();
		
		List CNSTN_CST_MNG_NO_LIST  = new ArrayList();
		List CNSTN_MNG_NO_LIST      = new ArrayList();
		List RVW_TKCG_EMP_NO_LIST   = new ArrayList();
		List CNSTN_CST_AMT_LIST     = new ArrayList();
		
		if (mtenMap.get("CNSTN_CST_MNG_NO_LIST[]") != null) {
			if (mtenMap.get("CNSTN_CST_MNG_NO_LIST[]").getClass().equals(String.class)) {
				if (mtenMap.get("CNSTN_CST_MNG_NO_LIST[]") != null && !mtenMap.get("CNSTN_CST_MNG_NO_LIST[]").toString().equals("")) {
					CNSTN_CST_MNG_NO_LIST.add(mtenMap.get("CNSTN_CST_MNG_NO_LIST[]"));
					CNSTN_MNG_NO_LIST.add(mtenMap.get("CNSTN_MNG_NO_LIST[]"));
					RVW_TKCG_EMP_NO_LIST.add(mtenMap.get("RVW_TKCG_EMP_NO_LIST[]"));
					CNSTN_CST_AMT_LIST.add(mtenMap.get("CNSTN_CST_AMT_LIST[]"));
				}
			} else {
				CNSTN_CST_MNG_NO_LIST  = mtenMap.get("CNSTN_CST_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("CNSTN_CST_MNG_NO_LIST[]");
				CNSTN_MNG_NO_LIST      = mtenMap.get("CNSTN_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("CNSTN_MNG_NO_LIST[]");
				RVW_TKCG_EMP_NO_LIST   = mtenMap.get("RVW_TKCG_EMP_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("RVW_TKCG_EMP_NO_LIST[]");
				CNSTN_CST_AMT_LIST     = mtenMap.get("CNSTN_CST_AMT_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("CNSTN_CST_AMT_LIST[]");
			}
		}
		
		HashMap costMap = new HashMap();
		for(int c=0; c<CNSTN_CST_MNG_NO_LIST.size(); c++) {
			costMap = new HashMap();
			String CNSTN_CST_MNG_NO  = CNSTN_CST_MNG_NO_LIST.get(c).toString();
			String CNSTN_MNG_NO      = CNSTN_MNG_NO_LIST.get(c).toString();
			String RVW_TKCG_EMP_NO   = RVW_TKCG_EMP_NO_LIST.get(c).toString();
			String CNSTN_CST_AMT     = CNSTN_CST_AMT_LIST.get(c).toString();
			
			costMap.put("consultid", CNSTN_MNG_NO);
			costMap.put("CNSTN_CST_MNG_NO", CNSTN_CST_MNG_NO);
			costMap.put("CST_PRGRS_STTS_SE", CST_PRGRS_STTS_SE);
			costMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
			costMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
			costMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
			costMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
			
			commonDao.update("consultSql.updateChrgLawyerAmt", costMap);
			
			if("C".equals(CST_PRGRS_STTS_SE)) {
				// 지급 안내
				// RVW_TKCG_EMP_NO
				// [서울시 법률지원소통창구] {사건번호} 자문료 지급완료
				// [서울시 법률지원소통창구] {사건번호} 자문료 지급 요청건에 대해 지급이 완료되었습니다.
				// {지급 금액, 지급 항목 등}
				HashMap consult = commonDao.selectOne("consultSql.getConsult", costMap);
				costMap.put("LWYR_MNG_NO", RVW_TKCG_EMP_NO);
				HashMap mbl = commonDao.selectOne("suitSql.getLawyerDetail", costMap);
				String mbl_no =  mbl.get("MBL_TELNO")==null?"":mbl.get("MBL_TELNO").toString();
				if(!mbl_no.equals("")) {
					String title = "[서울시 법률지원소통창구] "+(consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+" 자문료 지급완료";
					String msg = "[서울시 법률지원소통창구] "+(consult.get("CNSTN_DOC_NO")==null?"":consult.get("CNSTN_DOC_NO").toString())+" 자문료 지급 요청건에 대해 지급이 완료되었습니다. (지급 금액 : "+(CNSTN_CST_AMT)+")";
//					SMSClientSend.sendSMS(mbl_no, title, msg); // 250710_테스트하면서 알림 안보내지게 로컬 주석
				}
			}
		}
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public List selectRqstChangEmpList(Map<String, Object> mtenMap) {
		return commonDao.selectList("consultSql.selectRqstChangEmpList", mtenMap);
	}
	
	public JSONObject consultRqstChang(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		commonDao.update("consultSql.consultRqstChang", mtenMap);
		result.put("msg", "ok");
		return result;
	}
	
	public String getOutRcptYn(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.getOutRcptYn", mtenMap);
	}

	public int getConsultRole(Map<String, Object> mtenMap) {
		return commonDao.selectOne("consultSql.getConsultRole", mtenMap);
	}
	
	
	
	
	public int insertSatisfaction(org.json.simple.JSONArray jsonArr) {
		int result = 0;
		String CNSTN_MNG_NO = "";
		for(int i=0; i<jsonArr.size(); i++){
			HashMap map = (HashMap) jsonArr.get( i );
			if(String.valueOf(map.get("DGSTFN_ANS_MNG_NO")).length() > 0){
				CNSTN_MNG_NO = map.get("TRGT_PST_MNG_NO")==null?"":map.get("TRGT_PST_MNG_NO").toString();
				commonDao.update("suitSql.updateSatisfaction", map );
			}else{
				commonDao.insert("suitSql.insertSatisfaction", map);
				
				CNSTN_MNG_NO = map.get("TRGT_PST_MNG_NO")==null?"":map.get("TRGT_PST_MNG_NO").toString();
				String WRTR_EMP_NO = map.get("WRTR_EMP_NO")==null?"":map.get("WRTR_EMP_NO").toString();
				HashMap taskMap = new HashMap();
				taskMap = new HashMap();
				//taskMap.put("EMP_NO", WRTR_EMP_NO);
				taskMap.put("TASK_SE", "C7");
				taskMap.put("DOC_MNG_NO", map.get("TRGT_PST_MNG_NO")==null?"":map.get("TRGT_PST_MNG_NO").toString());
				taskMap.put("PRCS_YN", "Y");
				mifService.setTask(taskMap);
			}
		}
		HashMap map = new HashMap();
		map.put("CNSTN_MNG_NO", CNSTN_MNG_NO);
		commonDao.update("consultSql.updateDGSTFN_RSPNS_YN", map);
		
		return result;
	}
	

	public JSONObject sendSatisAlert(Map<String, Object> mtenMap) {
		JSONObject docinfo = new JSONObject();
		String title = "";
		String cont = "";
		ArrayList sendUserList = new ArrayList();
		ArrayList sendUserNmList = new ArrayList();
		
		mtenMap.put("EMP_NO", mtenMap.get("CNSTN_RQST_EMP_NO")==null?"":mtenMap.get("CNSTN_RQST_EMP_NO").toString());
		String empKey = commonDao.selectOne("consultSql.getConsultSendEmpKey", mtenMap);
		
		sendUserList.add(empKey);
		sendUserNmList.add(mtenMap.get("CNSTN_RQST_EMP_NM")==null?"":mtenMap.get("CNSTN_RQST_EMP_NM").toString());
		
		title = "[법률지원통합시스템] 자문 검토건에 대한 만족도 조사 요청";
		cont = cont + "귀 부서에서 법률지원통합시스템에 요청 한 자문 검토건이 완료되었습니다.<br/>";
		cont = cont + "시스템에서 만족도 조사 응답 요청드립니다.<br/>";
		
		SendMail mail = new SendMail();
//		mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
		
		docinfo.put("msg", "");
		return docinfo;
	}
	
	public JSONObject sendSatisAlertList(Map<String, Object> mtenMap) {
		JSONObject docinfo = new JSONObject();
		String title = "";
		String cont = "";
		ArrayList sendUserList = new ArrayList();
		ArrayList sendUserNmList = new ArrayList();
		
		String gbn = mtenMap.get("GBN")==null?"":mtenMap.get("GBN").toString();
		
		if ("CONSULT".equals(gbn)) {
			title = "[법률지원통합시스템] 자문 검토건에 대한 만족도 조사 요청";
			cont = cont + "귀 부서에서 법률지원통합시스템에 요청 한 자문 검토건이 완료되었습니다.<br/>";
			cont = cont + "시스템에서 만족도 조사 응답 요청드립니다.<br/>";
		} else {
			title = "[법률지원통합시스템] 협약 검토건에 대한 만족도 조사 요청";
			cont = cont + "귀 부서에서 법률지원통합시스템에 요청 한 협약 검토건이 완료되었습니다.<br/>";
			cont = cont + "시스템에서 만족도 조사 응답 요청드립니다.<br/>";
		}
		
		List pkList = new ArrayList();
		List empPkList = new ArrayList();
		List empNmList = new ArrayList();
		
		if (mtenMap.get("empPkList[]") != null) {
			if (mtenMap.get("empPkList[]").getClass().equals(String.class)) {
				if (mtenMap.get("empPkList[]") != null && !mtenMap.get("empPkList[]").toString().equals("")) {
					empPkList.add(mtenMap.get("empPkList[]"));
					pkList.add(mtenMap.get("pkList[]"));
					empNmList.add(mtenMap.get("empNmList[]"));
				}
			} else {
				empPkList = mtenMap.get("empPkList[]")==null?new ArrayList():(ArrayList)mtenMap.get("empPkList[]");
				pkList    = mtenMap.get("pkList[]")==null?new ArrayList():(ArrayList)mtenMap.get("pkList[]");
				empNmList = mtenMap.get("empNmList[]")==null?new ArrayList():(ArrayList)mtenMap.get("empNmList");
			}
		}
		
		for(int i=0; i<empPkList.size(); i++) {
			sendUserList.add(empPkList.get(i).toString());
			sendUserNmList.add(empNmList.get(i).toString());
		}
		
		SendMail mail = new SendMail();
//		mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
		
		docinfo.put("msg", "");
		return docinfo;
	}

	public List getSatisSendConsultList() {
		return commonDao.selectList("consultSql.getSatisSendConsultList");
	}
	

	public JSONObject updateKeyword(Map<String, Object> mtenMap) {
		JSONObject docinfo = new JSONObject();
		commonDao.update("consultSql.updateKeyword", mtenMap);
		docinfo.put("msg", "save");
		return docinfo;
	}
}
