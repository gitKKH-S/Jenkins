package com.mten.bylaw.suit.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.channels.FileChannel;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFPicture;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.ws.mime.MimeMessage;

import com.mten.bylaw.consult.DateUtil;
import com.mten.bylaw.mif.serviceSch.MifService;
import com.mten.bylaw.out.controller.GoogleOTP;
import com.mten.cmn.SessionListener;
import com.mten.dao.CommonDao;
import com.mten.email.MailSend;
import com.mten.email.SendMail;
import com.mten.util.AES256Cipher;
import com.mten.util.CommonMakeExcel;
import com.mten.util.FileUploadUtil;
import com.mten.util.MakeHan;
import com.mten.util.SMSClientSend;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("suitService")
public class SuitServiceImpl implements SuitService {
	protected final static Logger logger = Logger.getLogger(SuitServiceImpl.class);
	
	@Resource(name = "commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "mifService")
	private MifService mifService;
	
	String saveMsg = "저장이 완료되었습니다.";
	String delMsg = "삭제가 완료되었습니다.";
	
	public String getSeq() {
		return commonDao.selectOne("suitSql.getFileIdKey");
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
	
	public List getCodeList(Map<String, Object> mtenMap) {
		String type = mtenMap.get("type")==null?"":mtenMap.get("type").toString();
		
		List<String> typeList = new ArrayList<String>();
		if ("list".equals(type)) {
			typeList.add("LWSTYPECD");
			typeList.add("CASECD");
			typeList.add("JDGMTGBN");
		} else if ("suit".equals(type)) {
			typeList.add("LWSTYPECD");
			
			typeList.add("JDGMTGBN");
		} else if ("case".equals(type)) {
			typeList.add("CASECD");
			typeList.add("JDGMTGBN");
		} else if ("court".equals(type)) {
			typeList.add("COURTCD");
		} else if ("result".equals(type)) {
			// 진행상태		PROGRESSCD
			// 승패소구분	RESULTGBN
			// 판결상세		JDGMTGBN
			typeList.add("PROGRESSCD");
			typeList.add("RESULTGBN");
			typeList.add("JDGMTGBN");
		} else if ("date".equals(type)) {
			typeList.add("DATEGBN");
		} else if ("doc".equals(type)) {
			typeList.add("DOCGBN");
		} else if ("cost".equals(type)) {
			typeList.add("COSTGBN");
		} else if ("bank".equals(type)) {
			typeList.add("BANKGBN");
		} else if ("lawyer".equals(type)) {
			typeList.add("ARSP_NM");
			typeList.add("SPC_FLD_NM");
		}
		
		mtenMap.put("typeList", typeList);
		return commonDao.selectList("suitSql.getCodeList", mtenMap);
	}
	
	public List getProgList(Map<String, Object> mtenMap) {
		return commonDao.selectList("suitSql.getProgList", mtenMap);
	}
	
	public JSONObject selectOptionList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List<String> typeList = new ArrayList<String>();
		mtenMap.put("typeList", typeList);
		List list = commonDao.selectList("suitSql.selectSuitCodeList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject selectLwsLwrTypeCdList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectLwsLwrTypeCdList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject fileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest) {
		Iterator<String> itr = multipartRequest.getFileNames();
		String filePath = mtenMap.get("filePath")==null?"":mtenMap.get("filePath").toString();
		
		Map<String, Object> UPP = this.keyChangeUpperMap(mtenMap);
		JSONObject result = new JSONObject();
		Map map = new HashMap<String, Object>();
		
		mtenMap = UPP;
		
		String [] noList = {"exe", "bat", "sh", "java", "jsp", "html", "js", "css", "xml"};
		int noLeng = noList.length;
		boolean noFlg = true;
		
		while (itr.hasNext()) {
			String FILEID = commonDao.selectOne("suitSql.getFileIdKey");
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
						
						map.put("FILE_MNG_NO", FILEID);
						map.put("LWS_MNG_NO",       mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString());
						map.put("INST_MNG_NO",      mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
						map.put("TRGT_PST_MNG_NO",  mtenMap.get("TRGT_PST_MNG_NO")==null?"":mtenMap.get("TRGT_PST_MNG_NO").toString());
						map.put("FILE_SE", fileSe);
						
						String downFileNm = "";
						if ("SO1".equals(fileSe)) {
							downFileNm = "소송사무보고"+ "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length()));
						} else if ("SO2".equals(fileSe)) {
							downFileNm = "소송진행상황보고"+ "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length()));
						} else if ("SO3".equals(fileSe)) {
							downFileNm = "응소관련 자료제출 양식"+ "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length()));
						} else if ("SO4".equals(fileSe)) {
							downFileNm = "협조요청문"+ "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length()));
						} else if ("SO5".equals(fileSe)) {
							downFileNm = "판결문 접수에 따른 지원부서 의견요청"+ "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length()));
						} else {
							downFileNm = originalFilename;
						}
						
						map.put("DWNLD_FILE_NM", downFileNm);
						map.put("SRVR_FILE_NM", FILEID + "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length())));
						map.put("PHYS_FILE_NM", downFileNm);
						map.put("FILE_EXTN_NM", ext);
						map.put("FILE_SZ", FileSize);
						map.put("TRGT_PST_TBL_NM", mtenMap.get("TRGT_PST_TBL_NM")==null?"":mtenMap.get("TRGT_PST_TBL_NM").toString());
						
						map.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
						map.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
						map.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
						map.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
						
						commonDao.insert("suitSql.insertFile", map);
						
						if("PF".equals(fileSe)) {
							map.put("PHOTO_MNG_PATH_NM", FILEID + "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length())));
							commonDao.update("suitSql.updateLwyrImg", map);
						}
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
	
	public JSONObject selectCourtFileList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectCourtFileList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("flist", jr);
		return result;
	}
	
	public JSONObject courtFileUpload(Map<String, Object> mtenMap, MultipartHttpServletRequest multipartRequest) {
		Iterator<String> itr = multipartRequest.getFileNames();
		
		JSONObject result = new JSONObject();
		Map map = new HashMap<String, Object>();
		
		String [] noList = {"exe", "bat", "sh", "java", "jsp", "html", "js", "css", "xml"};
		int noLeng = noList.length;
		boolean noFlg = true;
		
		while (itr.hasNext()) {
			String FILEID = commonDao.selectOne("suitSql.getFileIdKey");
			MultipartFile mpf = multipartRequest.getFile(itr.next());
			String originalFilename = mpf.getOriginalFilename(); // 파일명
			
			long fileSize = mpf.getSize();
			String FileSize = String.valueOf(fileSize);
			
			String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO").toString();
			String INST_MNG_NO = mtenMap.get("INST_MNG_NO").toString();
			
			String fileids = FILEID + "." + (originalFilename.substring(originalFilename.lastIndexOf(".") + 1, originalFilename.length()));
			String fileFullPath = mtenMap.get("filePath") + fileids;
			String ext = originalFilename.substring(originalFilename.lastIndexOf("."), originalFilename.length());
			
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
						
						String filenm = originalFilename;
						String docdt = "";
						String docgbn = "";
						String serialnum = "";
						String docnm = "";
						String sdocnum = "";
						
						String[] fileTmp = filenm.split("_");
						System.out.println(fileTmp);
						
						docdt = fileTmp[1];
						docgbn = fileTmp[2];
						
						for (int i=2; i<=fileTmp.length-2; i++) {
							//docnm += fileTmp[i];
							if (fileTmp[i] != null) {
								if(docnm.equals("")) {
									docnm += fileTmp[i].toString();
								} else {
									docnm += "_"+fileTmp[i].toString();
								}
								
							}
							System.out.println("=====> " + docnm);
						}
						
						Pattern p = Pattern.compile("_\\d{5,7}[.]");
						Matcher m = p.matcher(filenm);
						while (m.find()) {
							serialnum = m.group();
						}
						
						map.put("LWS_DOC_MNG_NO", FILEID);
						map.put("LWS_MNG_NO", LWS_MNG_NO);
						map.put("INST_MNG_NO", INST_MNG_NO);
						
						map.put("DOC_CRTR_YMD", docdt.replaceAll("[.]", "-"));
						map.put("DOC_KND_NM", docgbn);
						map.put("DOC_SN", serialnum.replaceAll("_", "").replaceAll("[.]", ""));
						map.put("DOC_NM", docnm.replaceAll(ext, ""));
						map.put("ASST_DOC_NO", sdocnum);
						map.put("ORGNL_FILE_NM", originalFilename);
						map.put("SRVR_FILE_NM", FILEID + ext);
						map.put("FILE_SZ", FileSize);
						map.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM").toString());
						map.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO").toString());
						map.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO").toString());
						map.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM").toString());
						
						commonDao.insert("suitSql.insertCourtFile", map);
						
						result.put("msg", "suc");
					}else {
						System.out.println("파일업로드 실패");
						result.put("msg", "개인정보 검출 데이터를 확인하시기 바랍니다.");
					}
					
				} catch (Exception e) {
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
		List list = commonDao.selectList("suitSql.selectFileList", mtenMap);
		return list;
	}
	
	public JSONObject fileDelete(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("suitSql.deleteFile", mtenMap);
		
		String filePath = mtenMap.get("filePath").toString() + "" + mtenMap.get("serverfilenm");
		File file = new File(filePath);
		file.delete();
		
		result.put("msg", "파일이 삭제되었습니다.");
		return result;
	}
	
	public JSONObject courtFileDelete(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("suitSql.deleteCourtFileOne", mtenMap);
		
		String filePath = mtenMap.get("filePath").toString() + "" + mtenMap.get("serverfilenm");
		File file = new File(filePath);
		file.delete();
		result.put("msg", "파일이 삭제되었습니다.");
		return result;
	}
	
	public List<Map<String, Object>> getCourtFileList(Map<String, Object> mtenMap) {
		List<String> typeList = new ArrayList<String>();
		String chkFile = mtenMap.get("chkFile").toString();
		String[] chkFiles = chkFile.split(",");

		for (int i = 0; i < chkFiles.length; i++) {
			typeList.add(chkFiles[i]);
		}
		
		mtenMap.put("typeList", typeList);
		List list = commonDao.selectList("suitSql.selectCourtFileList", mtenMap);
		return list;
	}
	
	public JSONObject allCourtFileDelete(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List<String> typeList = new ArrayList<String>();
		String chkFile = mtenMap.get("chkFile").toString();
		String[] chkFiles = chkFile.split(",");
		
		for (int i = 0; i < chkFiles.length; i++) {
			typeList.add(chkFiles[i]);
		}
		mtenMap.put("typeList", typeList);
		
		List list = this.commonDao.selectList("suitSql.selectCourtFileList", mtenMap);
		if (list.size() > 0) {
			//commonDao.delete("suitSql.allCourtFileDelete", mtenMap);
			for(int i = 0; i < list.size(); ++i) {
				HashMap fMap = (HashMap)list.get(i);
				String filenm = fMap.get("SRVR_FILE_NM") == null ? "" : fMap.get("SRVR_FILE_NM").toString();
				String filePath = mtenMap.get("filePath").toString() + filenm;
				
				HashMap delMap = new HashMap();
				delMap.put("LWS_MNG_NO", fMap.get("LWS_MNG_NO")==null?"":fMap.get("LWS_MNG_NO").toString());
				delMap.put("INST_MNG_NO", fMap.get("INST_MNG_NO")==null?"":fMap.get("INST_MNG_NO").toString());
				delMap.put("LWS_DOC_MNG_NO", fMap.get("LWS_DOC_MNG_NO")==null?"":fMap.get("LWS_DOC_MNG_NO").toString());
				commonDao.delete("suitSql.deleteCourtFileOne", delMap);
				
				File file = new File(filePath);
				file.delete();
			}
			result.put("msg", "파일이 모두 삭제되었습니다.");
		} else {
			result.put("msg", "삭제 할 파일이 없습니다.");
		}
		return result;
	}
	
	public JSONObject selectSuitList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String Grpcd = mtenMap.get("grpcd") == null ? "" : mtenMap.get("grpcd").toString();
		if (Grpcd.indexOf("Y") > -1 || Grpcd.indexOf("C") > -1 || Grpcd.indexOf("L") > -1 || Grpcd.indexOf("G") > -1
				|| Grpcd.indexOf("D") > -1 || Grpcd.indexOf("E") > -1) {
			// 전체관리자 or 소송관리자
			mtenMap.put("grpcd", "Y");
		} else {
			// 그 외 일반사용자
			mtenMap.put("grpcd", "P");
		}
		List list = commonDao.selectList("suitSql.selectSuitList", mtenMap);
		int cnt = commonDao.select("suitSql.selectSuitListCnt", mtenMap);
		
		JSONArray jr = JSONArray.fromObject(list);
		
		result.put("result", jr);
		result.put("total", cnt);
		return result;
	}
	
	public List selectSuitMainList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectSuitMainList", mtenMap);
		return list;
	}
	
	public JSONObject selectConsultSuitList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String Grpcd = mtenMap.get("grpcd") == null ? "" : mtenMap.get("grpcd").toString();
		if (Grpcd.indexOf("Y") > -1 || Grpcd.indexOf("C") > -1 || Grpcd.indexOf("L") > -1) {
			// 전체관리자 or 소송관리자
			mtenMap.put("grpcd", "Y");
		} else {
			// 그 외 일반사용자
			mtenMap.put("grpcd", "P");
		}
		List list = commonDao.selectList("suitSql.selectConsultSuitList", mtenMap);
		int cnt = commonDao.select("suitSql.selectConsultSuitListCnt", mtenMap);
		
		JSONArray jr = JSONArray.fromObject(list);
		
		result.put("result", jr);
		result.put("total", cnt);
		return result;
	}
	
	public List selectConsultSuitMainList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectConsultSuitList", mtenMap);
		return list;
	}
	
	public HashMap getSuitDetail(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getSuitDetail", mtenMap);
	}
	
	public HashMap getSuitConsultDetail(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getSuitConsultDetail", mtenMap);
	}
	
	public JSONObject insertSuitInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		
		HashMap param = new HashMap();
		ArrayList<String> sendUserList = new ArrayList();
		ArrayList<String> sendUserNmList = new ArrayList();
		String teamReader = "";
		if (LWS_MNG_NO.equals("")) {
			// 소송 번호 부여 (소송상위코드별)
			String lwsNo = commonDao.selectOne("suitSql.getLwsNo", mtenMap);
			
			mtenMap.put("LWS_NO", lwsNo);
			// 신규등록
			commonDao.insert("suitSql.insertSuitInfo", mtenMap);
			LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
			
			mtenMap.put("empno", mtenMap.get("SPRVSN_EMP_NO")==null?"":mtenMap.get("SPRVSN_EMP_NO").toString());
			param = commonDao.selectOne("suitSql.getChrgEmpInfo", mtenMap);
			sendUserList.add(param.get("EMP_PK_NO")==null?"":param.get("EMP_PK_NO").toString());
			
			sendUserNmList.add(mtenMap.get("SPRVSN_EMP_NM")==null?"":mtenMap.get("SPRVSN_EMP_NM").toString());
			
			// 팀장 추출 임시 주석
			//param = commonDao.selectOne("suitSql.getEmpTeamReader", mtenMap);
			//teamReader = param.get("SPRVSN_TMLDR_NM")==null?"":param.get("SPRVSN_TMLDR_NM").toString();
			//sendUserList.add(param.get("EMP_PK_NO")==null?"":param.get("EMP_PK_NO").toString());
			mtenMap.put("empno", mtenMap.get("SPRVSN_TMLDR_NO")==null?"":mtenMap.get("SPRVSN_TMLDR_NO").toString());
			param = commonDao.selectOne("suitSql.getChrgEmpInfo", mtenMap);
			sendUserList.add(param.get("EMP_PK_NO")==null?"":param.get("EMP_PK_NO").toString());
			
			sendUserNmList.add(mtenMap.get("SPRVSN_TMLDR_NM")==null?"":mtenMap.get("SPRVSN_TMLDR_NM").toString());
		} else {
			// 수정
			commonDao.update("suitSql.updateSuitInfo", mtenMap);
			
			// 병합사건 등록
			int mcnt = mtenMap.get("mcnt")==null?0:Integer.parseInt(mtenMap.get("mcnt").toString());
			for(int i=0; i<mcnt; i++) {
				HashMap merMap = new HashMap();
				String MER_LWS_MNG_NO = mtenMap.get("MER_LWS_MNG_NO"+i)==null?"":mtenMap.get("MER_LWS_MNG_NO"+i).toString();
				if (!MER_LWS_MNG_NO.equals("")) {
					merMap.put("MER_YMD", mtenMap.get("MER_YMD"+i)==null?"":mtenMap.get("MER_YMD"+i).toString());
					merMap.put("MER_LWS_MNG_NO", MER_LWS_MNG_NO);
					merMap.put("MER_ASST_MNG_NO", LWS_MNG_NO);
					
					merMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM").toString());
					merMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO").toString());
					merMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM").toString());
					merMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO").toString());
					
					commonDao.insert("suitSql.insertMerInfo", merMap);
					
					// 병합대상 사건 심급 모두 INSERT
					commonDao.insert("suitSql.insertMerCaseInfo", merMap);
				}
			}
		}
		
		HashMap suitMap = commonDao.selectOne("suitSql.getSuitDetail", mtenMap);
		
		String cont = "귀 부서에 소송사건이 접수되었으니, 법률지원통합시스템에 접속하여 확인하여주시기 바랍니다.<br/><br/>";
		cont = cont + "관리번호 : " + (suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString()) + "<br/>" ;
		cont = cont + "담당자 : " + (suitMap.get("SPRVSN_EMP_NM")==null?"":suitMap.get("SPRVSN_EMP_NM").toString()) + "<br/>" ;
		cont = cont + "담당팀장 : " + (suitMap.get("SPRVSN_EMP_NM")==null?"":suitMap.get("SPRVSN_EMP_NM").toString());
		
		SendMail mail = new SendMail();
		mail.sendMail("[법률지원통합시스템] 소송사건 접수 안내", cont, sendUserList, sendUserNmList, null, "");
		
		result.put("LWS_MNG_NO", LWS_MNG_NO);
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject insertSuitConsultInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String LWS_RQST_MNG_NO = mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString();
		
		if (LWS_RQST_MNG_NO.equals("")) {
			// 신규등록
			commonDao.insert("suitSql.insertSuitConsultInfo", mtenMap);
			LWS_RQST_MNG_NO = mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString();
		} else {
			// 수정
			commonDao.update("suitSql.updateSuitConsultInfo", mtenMap);
			
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("FILE_MNG_NO", mtenMap.get("delfile[]"));
						commonDao.delete("suitSql.deleteFile", mtenMap);
					}
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("FILE_MNG_NO", delfile.get(i));
							commonDao.delete("suitSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		result.put("LWS_RQST_MNG_NO", LWS_RQST_MNG_NO);
		result.put("msg", saveMsg);
		return result;
	}
	
	public HashMap getCaseDetail(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getCaseDetail", mtenMap);
	}

	public List getEmpInfo(Map<String, Object> mtenMap) {
		return commonDao.selectList("suitSql.getEmpInfo", mtenMap);
	}
	
	public List getLastEmpInfo(Map<String, Object> mtenMap) {
		return commonDao.selectList("suitSql.getLastEmpInfo", mtenMap);
	}
	
	public JSONObject insertCaseInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		String INCDNT_NO = mtenMap.get("INCDNT_NO")==null?"":mtenMap.get("INCDNT_NO").toString();
		
		Pattern pattern = Pattern.compile("^(\\d+)([가-힣]+)(\\d+)$");
		Matcher matcher = pattern.matcher(INCDNT_NO);
		String SET_INCDNT_NO = "";
		if (matcher.matches()) {
			String c1 = matcher.group(1);
			String c2 = matcher.group(2);
			String c3 = matcher.group(3);
			
			if (!c1.matches("^\\d{4}$")) {
				result.put("res", "X");
				result.put("msg", "사건번호 형태가 유효하지 않습니다. 입력한 사건번호를 다시 확인하세요.");
				return result;
			}
			
			int year = Integer.parseInt(c1);
			int current = java.time.Year.now().getValue();
			if (year <= 1900 || year >= (current+2)) {
				result.put("res", "X");
				result.put("msg", "사건번호 형태가 유효하지 않습니다. 입력한 사건번호를 다시 확인하세요.");
				return result;
			}
			
			mtenMap.put("c2", c2);
			int chkGbn = commonDao.select("suitSql.chkIncdntNoGbn", mtenMap);
			
			if(chkGbn == 0) {
				result.put("res", "X");
				result.put("msg", "사건번호 형태가 유효하지 않습니다. 입력한 사건번호를 다시 확인하세요.");
				return result;
			}
			
			mtenMap.put("INCDNT_NO", c1+"@"+c2+"@"+c3);
		} else {
			result.put("res", "X");
			result.put("msg", "사건번호 형태가 유효하지 않습니다. 입력한 사건번호를 다시 확인하세요.");
			return result;
		}
		
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		String APLY_INCDNT_YN = mtenMap.get("APLY_INCDNT_YN")==null?"":mtenMap.get("APLY_INCDNT_YN").toString();
		String JDGM_CFMTN_YMD = mtenMap.get("JDGM_CFMTN_YMD")==null?"":mtenMap.get("JDGM_CFMTN_YMD").toString();
		String JDGM_UP_TYPE_CD = mtenMap.get("JDGM_UP_TYPE_CD")==null?"":mtenMap.get("JDGM_UP_TYPE_CD").toString();
		if (INST_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertCaseInfo", mtenMap);
			INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
			
			// 심급 등록 시 소송 주관부서를 수행부서 테이블에 기본 정보 등록
			HashMap empMap = commonDao.select("suitSql.getSuitSprvsn", mtenMap);
			String SPRVSN_EMP_NO = empMap.get("SPRVSN_EMP_NO")==null?"":empMap.get("SPRVSN_EMP_NO").toString();
			if (!SPRVSN_EMP_NO.equals("")) {
				HashMap relEmpMap = new HashMap();
				relEmpMap.put("INST_MNG_NO",       INST_MNG_NO);
				relEmpMap.put("LWS_FLFMT_EMP_NM",  empMap.get("SPRVSN_EMP_NM")==null?"":empMap.get("SPRVSN_EMP_NM").toString());
				relEmpMap.put("LWS_FLFMT_EMP_NO",  empMap.get("SPRVSN_EMP_NO")==null?"":empMap.get("SPRVSN_EMP_NO").toString());
				relEmpMap.put("LWS_FLFMT_DEPT_NM", empMap.get("SPRVSN_DEPT_NM")==null?"":empMap.get("SPRVSN_DEPT_NM").toString());
				relEmpMap.put("LWS_FLFMT_DEPT_NO", empMap.get("SPRVSN_DEPT_NO")==null?"":empMap.get("SPRVSN_DEPT_NO").toString());
				relEmpMap.put("FLFMT_BGNG",        empMap.get("FLGLW_YMD")==null?"":empMap.get("FLGLW_YMD").toString());
				relEmpMap.put("FLFMT_END",         "");
				relEmpMap.put("FLFMT_YN",          "Y");
				relEmpMap.put("RMRK_CN",           "주관부서");
				relEmpMap.put("DEL_YN",            "N");
				relEmpMap.put("WRTR_EMP_NM",       mtenMap.get("WRTR_EMP_NM").toString());
				relEmpMap.put("WRTR_EMP_NO",       mtenMap.get("WRTR_EMP_NO").toString());
				relEmpMap.put("WRT_DEPT_NM",       mtenMap.get("WRT_DEPT_NM").toString());
				relEmpMap.put("WRT_DEPT_NO",       mtenMap.get("WRT_DEPT_NO").toString());
				commonDao.insert("suitSql.insertRelDeptInfo", relEmpMap);
			}
			
		} else {
			commonDao.update("suitSql.updateCaseInfo", mtenMap);
		}
		
		if (!JDGM_CFMTN_YMD.equals("")) {
			// 만족도조사 태스크 등록
			List taskEmpList = commonDao.selectList("suitSql.getChrgEmpInfo2", mtenMap);
			HashMap taskMap = new HashMap();
			for(int i=0; i<taskEmpList.size(); i++) {
				HashMap listMap = (HashMap)taskEmpList.get(i);
				taskMap = new HashMap();
				taskMap.put("EMP_NO", listMap.get("EMP_NO")==null?"":listMap.get("EMP_NO").toString());
				taskMap.put("TASK_SE", "S4");
				taskMap.put("DOC_MNG_NO", INST_MNG_NO);
				taskMap.put("PRCS_YN", "N");
				int cnt = commonDao.selectOne("commonSql.getTaskCnt", taskMap);
				if (cnt == 0) {
					mifService.setTask(taskMap);
				}
			}
			
			HashMap mailMap = new HashMap();
			mailMap.put("MNGR_AUTHRT_NM", "E");
			List empList = commonDao.selectList("suitSql.getChrgEmpInfo4", mailMap);
			
			if (empList.size() > 0) {
				ArrayList<String> sendUserList = new ArrayList();
				ArrayList<String> sendUserNmList = new ArrayList();
				HashMap suitMap = commonDao.selectOne("suitSql.getChrgEmpInfo1", mtenMap);
				String title = "";
				String cont = "";
				title = "[법률지원통합시스템] "+(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+
						" "+(suitMap.get("INCDNT_NO")==null?"":suitMap.get("INCDNT_NO").toString())+" 사건이 종결되었습니다.";
				
				cont = cont + "아래 사건이 종결 등록되었으니, 법률지원통합시스템에 접속하여 확인하여주시기 바랍니다.<br/><br/>";
				cont = cont + "관리번호 : "+(suitMap.get("LWS_NO")==null?"":suitMap.get("LWS_NO").toString())+"<br/>";
				cont = cont + "사건번호 : "+(suitMap.get("INCDNT_NO")==null?"":suitMap.get("INCDNT_NO").toString());
				for(int i=0; i<empList.size(); i++) {
					HashMap empMap = (HashMap)empList.get(i);
					sendUserList.add(empMap.get("EMP_PK_NO")==null?"":empMap.get("EMP_PK_NO").toString());
					sendUserNmList.add(empMap.get("EMP_NM")==null?"":empMap.get("EMP_NM").toString());
				}
				SendMail mail = new SendMail();
				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
			}
		}
		
		// 소송 최종심급 업데이트
		// 임시로 현재 등록하는 심급으로 UPDATE 처리 함
		commonDao.update("suitSql.updateSuitLastInst", mtenMap);
		
		// 소송 당사자 정보 insert
		int ecnt = mtenMap.get("ecnt")==null?0:Integer.parseInt(mtenMap.get("ecnt").toString());
		for(int i=0; i<ecnt; i++) {
			HashMap empMap = new HashMap();
			String LWS_CNCPR_MNG_NO = mtenMap.get("LWS_CNCPR_MNG_NO"+i)==null?"":mtenMap.get("LWS_CNCPR_MNG_NO"+i).toString();
			String LWS_CNCPR_NM = mtenMap.get("LWS_CNCPR_NM"+i)==null?"":mtenMap.get("LWS_CNCPR_NM"+i).toString();
			
			empMap.put("INST_MNG_NO",      INST_MNG_NO);
			empMap.put("LWS_CNCPR_MNG_NO", LWS_CNCPR_MNG_NO);
			empMap.put("LWS_CNCPR_SE",     mtenMap.get("LWS_CNCPR_SE"+i)==null?"":mtenMap.get("LWS_CNCPR_SE"+i).toString());
			empMap.put("LWS_CNCPR_NM",     mtenMap.get("LWS_CNCPR_NM"+i)==null?"":mtenMap.get("LWS_CNCPR_NM"+i).toString());
			empMap.put("LWS_CNCPR_CNPL",   mtenMap.get("LWS_CNCPR_CNPL"+i)==null?"":mtenMap.get("LWS_CNCPR_CNPL"+i).toString());
			empMap.put("LWS_CNCPR_ADDR",   mtenMap.get("LWS_CNCPR_ADDR"+i)==null?"":mtenMap.get("LWS_CNCPR_ADDR"+i).toString());
			empMap.put("RMRK_CN",          mtenMap.get("RMRK_CN"+i)==null?"":mtenMap.get("RMRK_CN"+i).toString());
			
			empMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM").toString());
			empMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO").toString());
			empMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM").toString());
			empMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO").toString());
			
			if (!LWS_CNCPR_NM.equals("")) {
				if (LWS_CNCPR_MNG_NO.equals("")) {
					commonDao.insert("suitSql.insertEmpInfo", empMap);
				} else {
					commonDao.insert("suitSql.updateEmpInfo", empMap);
				}
			}
		}
		
		int cnt = commonDao.selectOne("suitSql.getAppCaseCnt", mtenMap);
		
		if ("Y".equals(APLY_INCDNT_YN) && cnt <= 0) {
			// 신청사건 등록
			HashMap apMap = new HashMap();
			apMap.put("SEL_INST_MNG_NO", INST_MNG_NO);
			apMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
			apMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
			apMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
			apMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
			
			// 본소 심급정보 그대로 신청사건 심급정보 복사
			commonDao.insert("suitSql.insertAppCaseInfo", apMap);
			
			// 본소 심급정보 그대로 신청사건 당사자정보 복사
			commonDao.insert("suitSql.insertApEmpInfo", apMap);
			
			apMap.put("LWS_MNG_NO", LWS_MNG_NO);
			commonDao.update("suitSql.updateSuitLastInst", apMap);
			
			HashMap empMap = commonDao.select("suitSql.getSuitDetail", mtenMap);
			String SPRVSN_EMP_NO = empMap.get("SPRVSN_EMP_NO")==null?"":empMap.get("SPRVSN_EMP_NO").toString();
			if (!SPRVSN_EMP_NO.equals("")) {
				HashMap relEmpMap = new HashMap();
				relEmpMap.put("INST_MNG_NO",       apMap.get("INST_MNG_NO").toString());
				relEmpMap.put("LWS_FLFMT_EMP_NM",  empMap.get("SPRVSN_EMP_NM")==null?"":empMap.get("SPRVSN_EMP_NM").toString());
				relEmpMap.put("LWS_FLFMT_EMP_NO",  empMap.get("SPRVSN_EMP_NO")==null?"":empMap.get("SPRVSN_EMP_NO").toString());
				relEmpMap.put("LWS_FLFMT_DEPT_NM", empMap.get("SPRVSN_DEPT_NM")==null?"":empMap.get("SPRVSN_DEPT_NM").toString());
				relEmpMap.put("LWS_FLFMT_DEPT_NO", empMap.get("SPRVSN_DEPT_NO")==null?"":empMap.get("SPRVSN_DEPT_NO").toString());
				relEmpMap.put("FLFMT_BGNG",        empMap.get("FLGLW_YMD")==null?"":empMap.get("FLGLW_YMD").toString());
				relEmpMap.put("FLFMT_END",         "");
				relEmpMap.put("FLFMT_YN",          "Y");
				relEmpMap.put("RMRK_CN",           "주관부서");
				relEmpMap.put("DEL_YN",            "N");
				relEmpMap.put("WRTR_EMP_NM",       mtenMap.get("WRTR_EMP_NM").toString());
				relEmpMap.put("WRTR_EMP_NO",       mtenMap.get("WRTR_EMP_NO").toString());
				relEmpMap.put("WRT_DEPT_NM",       mtenMap.get("WRT_DEPT_NM").toString());
				relEmpMap.put("WRT_DEPT_NO",       mtenMap.get("WRT_DEPT_NO").toString());
				commonDao.insert("suitSql.insertRelDeptInfo", relEmpMap);
			}
		}
		
		result.put("LWS_MNG_NO",  LWS_MNG_NO);
		result.put("INST_MNG_NO", INST_MNG_NO);
		result.put("res", "Y");
		result.put("msg", "저장되었습니다.");
		return result;
	}
	
	public HashMap getCaseResultDetail(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getCaseResultDetail", mtenMap);
	}

	public JSONObject insertCaseResultInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		String PRGRS_STTS_CD = mtenMap.get("PRGRS_STTS_CD")==null?"":mtenMap.get("PRGRS_STTS_CD").toString();
		String APLY_INCDNT_YN = mtenMap.get("APLY_INCDNT_YN")==null?"":mtenMap.get("APLY_INCDNT_YN").toString();
		
		HashMap suitMap = commonDao.select("suitSql.getSuitDetail", mtenMap);
		
		if ("10001003".equals(PRGRS_STTS_CD)) {
			mtenMap.put("TRMN_YN", "Y");
		} else {
			mtenMap.put("TRMN_YN", "N");
		}
		// 소송 종결 처리
		commonDao.update("suitSql.updateSuitEnd", mtenMap);
		
		commonDao.update("suitSql.insertCaseResultInfo", mtenMap);
		
		if ("insert".equals(gbn) && "Y".equals(APLY_INCDNT_YN)) {
			// 신청사건 등록
			HashMap apMap = new HashMap();
			apMap.put("SEL_INST_MNG_NO", INST_MNG_NO);
			apMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
			apMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
			apMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
			apMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
			
			// 본소 심급정보 그대로 신청사건 심급정보 복사
			commonDao.insert("suitSql.insertAppCaseInfo", apMap);
			
			// 본소 심급정보 그대로 신청사건 당사자정보 복사
			commonDao.insert("suitSql.insertApEmpInfo", apMap);
		}
		
		result.put("LWS_MNG_NO", LWS_MNG_NO);
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteSuitInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> param = new HashMap<String, Object>();
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO").toString();
		String delGbn = mtenMap.get("delGbn").toString();
		String filepath = mtenMap.get("filePath").toString();
		
		String INST_CD = mtenMap.get("INST_CD") == null ? "" : mtenMap.get("INST_CD").toString();
		String PRGRS_STTS_CD = mtenMap.get("PRGRS_STTS_CD") == null ? "" : mtenMap.get("PRGRS_STTS_CD").toString();
		String setEndyn = "";
		
		String INST_MNG_NO = "";
		param.put("LWS_MNG_NO", LWS_MNG_NO);
		param.put("delgbn", delGbn);
		
		try {
			if ("suit".equals(delGbn)) {
				// 탭 정보 삭제
				this.deleteTabInfo(LWS_MNG_NO, INST_MNG_NO, filepath);
				
				// 심급정보 삭제
				commonDao.delete("suitSql.deleteCaseInfo", param);
				
				// 관련부서 정보 삭제 rel_dept
				commonDao.delete("suitSql.deleteEmpInfo", param);
				
				// 소송정보 삭제
				commonDao.delete("suitSql.deleteSuitInfo", param);
			} else if ("case".equals(delGbn)) {
				INST_MNG_NO = mtenMap.get("selectedCaseId").toString();
				param.put("INST_MNG_NO", INST_MNG_NO);
				
				// 탭 정보 삭제
				this.deleteTabInfo(LWS_MNG_NO, INST_MNG_NO, filepath);
				
				// 심급정보 삭제
				commonDao.delete("suitSql.deleteCaseInfo", param);
				
				commonDao.update("suitSql.updateSuitLastInst", param);
			}
		} catch (Exception e) {
			System.out.println("정보 삭제 실패");
		}
		result.put("msg", delMsg);
		return result;
	}
	
	public JSONObject deleteSuitConsultInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		commonDao.delete("suitSql.deleteSuitConsultInfo", mtenMap);
		
		result.put("msg", delMsg);
		return result;
	}
	
	public JSONObject updateSuitConsultProg(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String prog = mtenMap.get("prog")==null?"":mtenMap.get("prog").toString();
		String LWS_RQST_MNG_NO = mtenMap.get("LWS_RQST_MNG_NO")==null?"":mtenMap.get("LWS_RQST_MNG_NO").toString();
		String filePath = mtenMap.get("filePath")==null?"":mtenMap.get("filePath").toString();
		
		if ("접수요청".equals(prog)) {
			// 알림 발송?
			// 진행상태만 변경
			mtenMap.put("PRGRS_STTS_NM", prog);
		} else if ("접수".equals(prog)) {
			// 접수 담당 직원, 접수 일자
			mtenMap.put("empnm", mtenMap.get("WRTR_EMP_NM").toString());
			mtenMap.put("empno", mtenMap.get("WRTR_EMP_NO").toString());
			mtenMap.put("PRGRS_STTS_NM", prog);
		} else if ("반려".equals(prog)) {
			// 접수 담당 직원, 접수 일자
			mtenMap.put("empnm", mtenMap.get("WRTR_EMP_NM").toString());
			mtenMap.put("empno", mtenMap.get("WRTR_EMP_NO").toString());
			mtenMap.put("PRGRS_STTS_NM", prog);
		}
		
		commonDao.update("suitSql.updateSuitConsultProg", mtenMap);
		
		if ("접수".equals(prog)) {
			HashMap suitMap = commonDao.select("suitSql.getSuitConsultDetail", mtenMap);
			
			mtenMap.put("LWS_UP_TYPE_CD", suitMap.get("LWS_UP_TYPE_CD")==null?"":suitMap.get("LWS_UP_TYPE_CD").toString());
			
			String lwsNo = commonDao.selectOne("suitSql.getLwsNo", mtenMap);
			
			mtenMap.put("LWS_NO", lwsNo);
			
			// 의뢰 내용을 소송정보에 등록
			commonDao.insert("suitSql.insertSuitToConsult", mtenMap);
			
			// 1심 등록
			commonDao.insert("suitSql.insertCaseToConsult", mtenMap);
			
			// 소송당사자 등록
			commonDao.insert("suitSql.insertEmpToConsult", mtenMap);
			
			// 소송 수행자 등록
			
			// 파일 이동
			HashMap fileMap = new HashMap();
			fileMap.put("LWS_MNG_NO", LWS_RQST_MNG_NO);
			fileMap.put("TRGT_PST_MNG_NO", LWS_RQST_MNG_NO);
			fileMap.put("TRGT_PST_TBL_NM", "TB_LWS_RQST");
			List list = commonDao.selectList("suitSql.selectFileList", fileMap);
			String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
			for(int f=0; f<list.size(); f++) {
				HashMap map = (HashMap)list.get(f);
				String FILEID = commonDao.selectOne("suitSql.getFileIdKey");
				fileCopy(filePath+map.get("SRVR_FILE_NM"), FILEID+"."+map.get("FILE_EXTN_NM"), filePath);
				
				map.put("FILE_MNG_NO", FILEID);
				map.put("INST_MNG_NO", LWS_MNG_NO);
				map.put("LWS_MNG_NO", LWS_MNG_NO);
				map.put("TRGT_PST_MNG_NO", LWS_MNG_NO);
				map.put("FILE_SE", "CONF");
				map.put("SRVR_FILE_NM", FILEID+"."+map.get("FILE_EXTN_NM"));
				map.put("TRGT_PST_TBL_NM", "TB_LWS_MNG");
				
				map.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM").toString());
				map.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO").toString());
				map.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM").toString());
				map.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO").toString());
				
				commonDao.insert("suitSql.insertFile", map);
			}
			
			// 등록 된 소송정보 pk를 의뢰정보에 update
			commonDao.update("suitSql.updateSuitConsultMngNo", mtenMap);
		}
		result.put("msg", saveMsg);
		return result;
	}
	
	public void deleteTabInfo(String LWS_MNG_NO, String INST_MNG_NO, String filepath) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("LWS_MNG_NO", LWS_MNG_NO);
		param.put("INST_MNG_NO", INST_MNG_NO);
		
		// 관련 데이터 모두 삭제
	}

	public JSONObject selectEmpUserList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectEmpUserList", mtenMap);
		
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject selectEmpList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectEmpList", mtenMap);

		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject chgEmpInfoSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		HashMap taskMap = new HashMap();
		
		// 기존 담당자 사용여부 N으로 수정
		commonDao.update("suitSql.updateChgEmpUseYn", mtenMap);
		
		taskMap.put("DOC_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
		taskMap.put("TASK_SE", "S2");
		commonDao.delete("commonSql.setTaskAllDel", taskMap);
		
		HashMap param = new HashMap();
		// 신규 담당자 저장
		if (mtenMap.get("chkUser[]") != null) {
			ArrayList<String> sendUserList = new ArrayList();
			ArrayList<String> sendUserNmList = new ArrayList();
			
			if (mtenMap.get("chkUser[]").getClass().equals(String.class)) {
				if (mtenMap.get("chkUser[]") != null && !mtenMap.get("chkUser[]").toString().equals("")) {
					mtenMap.put("empno", mtenMap.get("chkUser[]"));
					param = commonDao.selectOne("suitSql.getChrgEmpInfo", mtenMap);
					param.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
					param.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
					
					param.put("WRTR_EMP_NM"  , mtenMap.get("WRTR_EMP_NM"  ));
					param.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
					param.put("WRT_DEPT_NO"  , mtenMap.get("WRT_DEPT_NO"  ));
					param.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
					
					commonDao.insert("suitSql.insertChgEmpInfo", param);
					
					// 나의할일 추가
					taskMap = new HashMap();
					taskMap.put("EMP_NO", mtenMap.get("empno")==null?"":mtenMap.get("empno").toString());
					taskMap.put("TASK_SE", "S2");
					taskMap.put("DOC_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
					taskMap.put("PRCS_YN", "N");
					mifService.setTask(taskMap);
					
					sendUserList.add(param.get("EMP_PK_NO")==null?"":param.get("EMP_PK_NO").toString());
					sendUserNmList.add(param.get("EMP_NM")==null?"":param.get("EMP_NM").toString());
				}
			} else {
				ArrayList chkUser = mtenMap.get("chkUser[]")==null?new ArrayList():(ArrayList) mtenMap.get("chkUser[]");
				for (int i = 0; i < chkUser.size(); i++) {
					if (chkUser.get(i) != null && !chkUser.get(i).equals("")) {
						mtenMap.put("empno", chkUser.get(i));
						// 인사정보 Select (사번, 이름, 부서명, 부서코드)
						param = commonDao.selectOne("suitSql.getChrgEmpInfo", mtenMap);
						param.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO"));
						param.put("LWS_MNG_NO", mtenMap.get("LWS_MNG_NO"));
						
						param.put("WRTR_EMP_NM"  , mtenMap.get("WRTR_EMP_NM"  ));
						param.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
						param.put("WRT_DEPT_NO"  , mtenMap.get("WRT_DEPT_NO"  ));
						param.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM"));
						
						commonDao.insert("suitSql.insertChgEmpInfo", param);
						
						taskMap = new HashMap();
						taskMap.put("EMP_NO", mtenMap.get("empno")==null?"":mtenMap.get("empno").toString());
						taskMap.put("TASK_SE", "S2");
						taskMap.put("DOC_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
						taskMap.put("PRCS_YN", "N");
						mifService.setTask(taskMap);
						
						sendUserList.add(param.get("EMP_PK_NO")==null?"":param.get("EMP_PK_NO").toString());
						sendUserNmList.add(param.get("EMP_NM")==null?"":param.get("EMP_NM").toString());
					}
				}
			}
			
			HashMap sendMap = commonDao.selectOne("suitSql.getChrgEmpInfo1", mtenMap);
			String cont = "소송사건이 배정되었으니, 법률지원통합시스템에 접속하여 확인하여주시기 바랍니다.<br/><br/>"+
					"관리번호 : " + (sendMap.get("LWS_NO")==null?"":sendMap.get("LWS_NO").toString()) +"<br/>"+
					"사건번호 : " + (sendMap.get("INCDNT_NO")==null?"":sendMap.get("INCDNT_NO").toString());
			SendMail mail = new SendMail();
			mail.sendMail("[법률지원통합시스템] 소송사건 배정 안내", cont, sendUserList, sendUserNmList, null, "");
		}
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject selectCaseList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectCaseList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public String getInstMngNo(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getInstMngNo", mtenMap);
	}
	
	public static String fileCopy(String wonFile, String filenm, String copyPath){
		//스트림, 채널 선언  
		FileInputStream inputStream = null;  
		FileOutputStream outputStream = null;  
		FileChannel fcin = null;  
		FileChannel fcout = null;  
		try {
			//복사 대상이 되는 파일 생성   
			File sourceFile = new File(wonFile);
			//스트림 생성   
			inputStream = new FileInputStream(sourceFile); 
			
			outputStream = new FileOutputStream(copyPath+filenm);
			//채널 생성   
			fcin = inputStream.getChannel();
			fcout = outputStream.getChannel();
			//채널을 통한 스트림 전송
			long size = fcin.size();
			fcin.transferTo(0, size, fcout);
		} catch (IOException e) {
			System.out.println("ERROR : 파일복사 실패");
		} finally {
			//자원 해제  
			try{
				fcout.close();
			}catch(IOException ioe){System.out.println("ERROR : 파일복사 실패");}
			try{
				fcin.close();
			}catch(IOException ioe){System.out.println("ERROR : 파일복사 실패");}
			try{
				outputStream.close();
			}catch(IOException ioe){System.out.println("ERROR : 파일복사 실패");}
			try{
				inputStream.close();
			}catch(IOException ioe){System.out.println("ERROR : 파일복사 실패");}
		}
		return filenm;
	}
	
	
	
	public JSONObject selectDateList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectDateList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getDateDetail(Map<String, Object> mtenMap) {
		HashMap result = commonDao.selectOne("suitSql.getDateDetail", mtenMap);
		return result;
	}
	
	public JSONObject insertDateInfo( Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String DATE_MNG_NO = mtenMap.get("DATE_MNG_NO")==null?"":mtenMap.get("DATE_MNG_NO").toString();
		
		String strTerm = "";
		
		if (mtenMap.get("noticeterm[]") != null) {
			if (mtenMap.get("noticeterm[]").getClass().equals(String.class)) {
				if (mtenMap.get("noticeterm[]") != null && !mtenMap.get("noticeterm[]").toString().equals("")) {
					mtenMap.put("NOTI_INV", mtenMap.get("noticeterm[]"));
				}
			} else {
				ArrayList NOTI_INV = mtenMap.get("noticeterm[]") == null ? new ArrayList():(ArrayList) mtenMap.get("noticeterm[]");
				for (int i = 0; i < NOTI_INV.size(); i++) {
					if (NOTI_INV.get(i) != null && !NOTI_INV.get(i).equals("")) {
						strTerm += NOTI_INV.get(i)+",";
					}
				}
				mtenMap.put("NOTI_INV", strTerm);
			}
		}
		
		if(DATE_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertDateInfo", mtenMap);
		} else {
			commonDao.update("suitSql.updateDateInfo", mtenMap);
		}
		
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteCaseDate(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> param = new HashMap<String, Object>();
		
		String filepath = mtenMap.get("filepath").toString();
		
		// 기일정보에 연동 된 제출/송달서면 docid 조회
		List<String> docidList = commonDao.selectList("suitSql.selectDocid", mtenMap);
		
		if (docidList.size() > 0) {
			for(int d=0; d<docidList.size(); d++) {
				String docid = docidList.get(d).toString();
				param.put("TRGT_PST_MNG_NO", docid);
				param.put("TRGT_PST_TBL_NM", "TB_LWS_SBMSN_TMTL");
				param.put("FILE_SE", "DOC");
				List<Map<String, Object>> list = commonDao.selectList("suitSql.selectFileList", param);
				
				for (int i = 0; i < list.size(); i++) {
					param = new HashMap<String, Object>();
					param.put("FILE_MNG_NO", list.get(i).get("FILE_MNG_NO").toString());
					param.put("filePath", filepath);
					fileDelete(param);
				}
			}
		}
		
		// 기일정보에 연동 된 제출/송달서면 정보 삭제
		commonDao.delete("suitSql.deleteDocInfo", mtenMap);
		
		// 기일정보 삭제
		commonDao.delete("suitSql.deleteDateInfo", mtenMap);
		
		result.put("msg", delMsg);
		return result;
	}
	
	public List getDateDocFileList(Map mtenMap) {
		List list = commonDao.selectList("suitSql.getDateDocFileList", mtenMap);
		return list;
	}
	
	public JSONObject selectDocList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectDocList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public List selectRelDateList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectDateList", mtenMap);
		return list;
	}
	
	public HashMap getDocDetail(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getDocDetail", mtenMap);
	}
	
	public JSONObject insertDocInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String DOC_MNG_NO = mtenMap.get("DOC_MNG_NO").toString();
		if (DOC_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertDocInfo", mtenMap);
			DOC_MNG_NO = mtenMap.get("DOC_MNG_NO").toString();
		} else {
			commonDao.update("suitSql.updateDocInfo", mtenMap);
			
			if (mtenMap.get("delfile[]") != null) {
				if (mtenMap.get("delfile[]").getClass().equals(String.class)) {
					if (mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")) {
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("suitSql.deleteFile", mtenMap);
					}
				} else {
					ArrayList delfile = mtenMap.get("delfile[]") == null ? new ArrayList() : (ArrayList) mtenMap.get("delfile[]");
					for (int i = 0; i < delfile.size(); i++) {
						if (delfile.get(i) != null && !delfile.get(i).equals("")) {
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("suitSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		result.put("DOC_MNG_NO", DOC_MNG_NO);
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteDocInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String filepath = mtenMap.get("filepath").toString();
		String DOC_MNG_NO = mtenMap.get("DOC_MNG_NO")==null?"":mtenMap.get("DOC_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("TRGT_PST_MNG_NO", DOC_MNG_NO);
		param.put("TRGT_PST_TBL_NM", "TB_LWS_SBMSN_TMTL");
		param.put("FILE_SE", "DOC");
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectFileList", param);
		
		// file 삭제
		for (int i = 0; i < list.size(); i++) {
			param = new HashMap<String, Object>();
			param.put("fileid", list.get(i).get("FILEID").toString());
			param.put("serverfilenm", list.get(i).get("SERVERFILENM").toString());
			param.put("filePath", filepath);
			fileDelete(param);
		}
		
		HashMap delMap = new HashMap();
		delMap.put("LWS_MNG_NO",  mtenMap.get("LWS_MNG_NO").toString());
		delMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO").toString());
		delMap.put("DOC_MNG_NO",  mtenMap.get("DOC_MNG_NO").toString());
		commonDao.delete("suitSql.deleteDocInfo", delMap);
		
		result.put("msg", delMsg);
		
		return result;
	}
	
	public JSONObject selectRelEmpList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectRelEmpList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getRelEmpDetail(Map<String, Object> mtenMap) {
		HashMap result = new HashMap();
		HashMap empMap = commonDao.selectOne("suitSql.getRelEmpDetail", mtenMap);
		
		result.put("empMap", empMap);
		return result;
	}
	
	public JSONObject insertRelEmpInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = null;
		String LWS_FLFMT_MNG_NO = mtenMap.get("LWS_FLFMT_MNG_NO").toString();
		
		String FLFMT_YN = mtenMap.get("FLFMT_YN")==null?"":mtenMap.get("FLFMT_YN").toString();
		
		if (LWS_FLFMT_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertRelDeptInfo", mtenMap);
			LWS_FLFMT_MNG_NO = mtenMap.get("LWS_FLFMT_MNG_NO").toString();
			
			if("Y".equals(FLFMT_YN)){
				map = new HashMap<String, Object>();
				map.put("DOC_MNG_NO", mtenMap.get("LWS_MNG_NO"));
				map.put("DOC_SE", "SUIT");
				map.put("AUTHRT_SE", "P");
				map.put("AUTHRT_EMP_NO", mtenMap.get("LWS_FLFMT_EMP_NO"));
				map.put("AUTHRT_DEPT_NO", "");
				map.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO"));
				map.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM"));
				commonDao.insert("suitSql.insertRole", map);
			}
		} else {
			String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
			if("pop".equals(gbn)){
				commonDao.update("suitSql.updateRelDeptInfo", mtenMap);
			}else{
				commonDao.update("suitSql.updateRelDeptUsed", mtenMap);
			}
			
			if("N".equals(FLFMT_YN)){
				map = new HashMap<String, Object>();
				map.put("DOC_MNG_NO", mtenMap.get("LWS_MNG_NO"));
				map.put("DOC_SE", "SUIT");
				map.put("AUTHRT_SE", "P");
				map.put("AUTHRT_EMP_NO", mtenMap.get("LWS_FLFMT_EMP_NO"));
				commonDao.delete("suitSql.deleteRole", map);
			}
		}
		result.put("LWS_FLFMT_MNG_NO", LWS_FLFMT_MNG_NO);
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteRelEmpInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("suitSql.delRelEmpInfo", mtenMap);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("DOC_MNG_NO", mtenMap.get("LWS_MNG_NO"));
		map.put("DOC_SE", "SUIT");
		map.put("AUTHRT_SE", "P");
		map.put("AUTHRT_EMP_NO", mtenMap.get("LWS_FLFMT_EMP_NO"));
		commonDao.delete("suitSql.deleteRole", map);
		
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONArray getDeptList(Map mtenMap) {
		List<HashMap> nodeList = commonDao.selectList("suitSql.getDeptList",mtenMap);
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
	
	public JSONObject selectDeptList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectDeptList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject selectUserList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectUserList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	
	
	
	public JSONObject selectfLawFirmList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectLawFirmList", mtenMap);
		int cnt = commonDao.select("suitSql.selectLawFirmListCnt", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getLawfirmDetail(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getLawfirmDetail", mtenMap);
	}

	public JSONObject insertLawfirmInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String JDAF_CORP_MNG_NO = mtenMap.get("JDAF_CORP_MNG_NO").toString();
		
		if (JDAF_CORP_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertLawfirmInfo", mtenMap);
		} else {
			commonDao.update("suitSql.updateLawfirmInfo", mtenMap);
		}
		
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteLawfirmInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		commonDao.delete("suitSql.deleteLawyerInfo", mtenMap);
		commonDao.delete("suitSql.deleteLawfirmInfo", mtenMap);
		result.put("msg", delMsg);
		return result;
	}
	
	public List getBankList(Map<String, Object> mtenMap) {
		List list =  commonDao.selectList("suitSql.getBankList", mtenMap);
		List goList = new ArrayList();
		for(int i=0; i<list.size(); i++) {
			HashMap map = (HashMap)list.get(i);
			String actno = map.get("ACTNO")==null?"":map.get("ACTNO").toString();
			String deactno = "";
			try {
				deactno = AES256Cipher.AES_Decode(actno);
			} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
					| NoSuchPaddingException | InvalidAlgorithmParameterException | IllegalBlockSizeException
					| BadPaddingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				deactno = "";
			}
			map.put("ACTNO", deactno);
			
			goList.add(map);
		}
		
		return goList;
	}
	
	public JSONObject selectLawyerList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectLawyerList", mtenMap);
		int cnt = commonDao.select("suitSql.selectLawyerListCnt", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject selectLawyerListExcel(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String filePath = mtenMap.get("filePath")==null?"":mtenMap.get("filePath").toString();
		
		List list = commonDao.selectList("suitSql.selectLawyerList", mtenMap);
		int cnt = commonDao.select("suitSql.selectLawyerListCnt", mtenMap);
		
		List list2 = new ArrayList();
		for(int i=0; i<list.size(); i++) {
			HashMap map = (HashMap)list.get(i);
			String ARSP_NM = map.get("ARSP_NM")==null?"":map.get("ARSP_NM").toString();
			if (!ARSP_NM.equals("")) {
				ARSP_NM = this.lawyerArspNmList(ARSP_NM);
				map.put("ARSP_NM", ARSP_NM);
			}
			
			
			String PHOTO_MNG_PATH_NM = map.get("PHOTO_MNG_PATH_NM")==null?"":map.get("PHOTO_MNG_PATH_NM").toString();
			if (!PHOTO_MNG_PATH_NM.equals("")) {
				map.put("PHOTO_MNG_PATH_NM", filePath+PHOTO_MNG_PATH_NM);
			}
			
			list2.add(map);
		}
		
		
		JSONArray jr = JSONArray.fromObject(list2);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public String makeLawyerExcel(String sTit , ArrayList<String> columnList , ArrayList<String> columnRList , 
			List<Map<String,Object>> datalist, HttpServletRequest req, HttpServletResponse response, String filePath) {
		String fileNm = "법률고문현황.xlsx";
		
		//임의의 VO가 되주는 MAP 객체
		Map<String,Object>map=null;
		//가상 DB조회후 목록을 담을 LIST객체
		//ArrayList<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
		
		//1차로 workbook을 생성 
		XSSFWorkbook workbook=new XSSFWorkbook();
		//2차는 sheet생성 
		XSSFSheet sheet=workbook.createSheet(sTit);
		//엑셀의 행 
		XSSFRow row=null;
		//엑셀의 셀 
		XSSFCell cell=null;
		
		//Set Header Font
		XSSFFont headerFont = workbook.createFont();
		headerFont.setBoldweight(headerFont.BOLDWEIGHT_BOLD);
		headerFont.setFontHeightInPoints((short) 12);
		//Set Header Style
		CellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setFillBackgroundColor(IndexedColors.BLACK.getIndex());
		headerStyle.setAlignment(headerStyle.ALIGN_CENTER);
		headerStyle.setFont(headerFont);
		//headerStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		
		sheet.setColumnWidth(0, 200);
		//임의의 DB데이터 조회 
		int i=0;
		//row = sheet.createRow((short)i);
		//cell = row.createCell(0);
		//cell.setCellValue(String.valueOf(sTit));
		//cell.setCellStyle(headerStyle);
		//sheet.addMergedRegion(new CellRangeAddress(0,0,0,columnList.size()-1));
		
		//i++;
		row=sheet.createRow((short)i);
		for(int j=0;j<columnRList.size();j++){
			//생성된 row에 컬럼을 생성한다 
			cell=row.createCell(j);
			//map에 담긴 데이터를 가져와 cell에 add한다 
			cell.setCellValue(String.valueOf(columnRList.get(j)));
		}
		
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 1));
		
		i++;
		
		for(Map<String,Object>mapobject : datalist){
			// 시트에 하나의 행을 생성한다(i 값이 0이면 첫번째 줄에 해당) 
			row=sheet.createRow((short)i);
			row.setHeightInPoints(100); 
			i++;
			if(columnList !=null &&columnList.size() >0){
				for(int j=0;j<columnList.size();j++){
					//생성된 row에 컬럼을 생성한다 
					cell=row.createCell(j);
					//map에 담긴 데이터를 가져와 cell에 add한다 
					String cname = (String)columnList.get(j);
					if(cname.equals("PHOTO_MNG_PATH_NM")) {
						String fpath = String.valueOf(mapobject.get(columnList.get(j))==null?"":mapobject.get(columnList.get(j)));
						if(!fpath.equals("")) {
							System.out.println("fpath===>"+fpath);
							try {
								InputStream inputStream = new FileInputStream(fpath);
								byte[] imageBytes = IOUtils.toByteArray(inputStream);
						        inputStream.close();
						        
						        int pictureIdx = workbook.addPicture(imageBytes, workbook.PICTURE_TYPE_PNG);
						        XSSFDrawing drawing = sheet.createDrawingPatriarch();
						        
						        XSSFClientAnchor anchor = new XSSFClientAnchor();
						        anchor.setCol1(0); // 시작 열
						        anchor.setRow1(i-1); // 시작 행
						        anchor.setCol2(1); // 끝 열
						        anchor.setRow2(i); // 끝 행
						        
						        XSSFPicture picture = drawing.createPicture(anchor, pictureIdx);
						        //picture.resize();
							} catch (Exception e) {
								System.out.println("이미지오류!!");
							}
						}
					}else {
						cell.setCellValue(String.valueOf(mapobject.get(columnList.get(j))==null?"":mapobject.get(columnList.get(j))));
					}
				}
			}
		}
		System.out.println("row.getLastCellNum()"+row.getLastCellNum());
		for(int colNum = 0; colNum<row.getLastCellNum();colNum++){ 
			System.out.println(colNum);
			workbook.getSheetAt(0).autoSizeColumn(colNum,true);
			sheet.setColumnWidth(colNum, sheet.getColumnWidth(colNum) + 1600);
		}
		String sfName = "";
		String fileFullPath = "";
		try {
			long time = System.currentTimeMillis(); 
			SimpleDateFormat dayTime = new SimpleDateFormat("yyyymmddhhmmss");
			String str = dayTime.format(new Date(time));
			
			sfName = str +".xlsx";
			
			fileFullPath = filePath + "/" + sfName;
			
			FileOutputStream fileoutputstream=new FileOutputStream(fileFullPath);
			//파일을 쓴다
			workbook.write(fileoutputstream);
			//필수로 닫아주어야함 
			fileoutputstream.close();
			System.out.println("엑셀파일생성성공");
			CommonMakeExcel.filedownload(fileFullPath,fileNm,req, response);
		}catch(Exception e) {
			System.out.println("엑셀 생성 실패!!");
		}
		
		return fileNm;
	}
	
	public HashMap getLawyerDetail(Map<String, Object> mtenMap) {
		HashMap lawyerMap = commonDao.selectOne("suitSql.getLawyerDetail", mtenMap);
		String SPC_FLD_CD = lawyerMap.get("SPC_FLD_CD")==null?"":lawyerMap.get("SPC_FLD_CD").toString();
		//String [] spcFldNmList = SPC_FLD_CD.split(",");
		//HashMap spcMap = new HashMap();
		//String SPC_FLD_NM_KR = "";
		//for(int s=0; s<spcFldNmList.length; s++) {
		//	spcMap.put("SPC_FLD_NM", spcFldNmList[s]);
		//	SPC_FLD_NM_KR += commonDao.selectOne("suitSql.getSpcFldNm", spcMap)+",";
		//}
		lawyerMap.put("SPC_FLD_NM", this.lawyerSpcFldNmList(SPC_FLD_CD));
		
		String ARSP_NM = lawyerMap.get("ARSP_NM")==null?"":lawyerMap.get("ARSP_NM").toString();
		//String [] arspNmList = ARSP_NM.split(",");
		//HashMap arspMap = new HashMap();
		//String SET_ARSP_NM = "";
		//for(int s=0; s<arspNmList.length; s++) {
		//	arspMap.put("ARSP_NM", arspNmList[s]);
		//	SET_ARSP_NM += commonDao.selectOne("suitSql.getArspNm", arspMap)+",";
		//}
		lawyerMap.put("ARSP_NM", this.lawyerArspNmList(ARSP_NM));
		
		return lawyerMap;
	}
	
	public String lawyerSpcFldNmList(String SPC_FLD_CD) {
		String [] spcFldNmList = SPC_FLD_CD.split(",");
		HashMap spcMap = new HashMap();
		String SPC_FLD_NM_KR = "";
		for(int s=0; s<spcFldNmList.length; s++) {
			spcMap.put("SPC_FLD_NM", spcFldNmList[s]);
			SPC_FLD_NM_KR += commonDao.selectOne("suitSql.getSpcFldNm", spcMap)+",";
		}
		
		return SPC_FLD_NM_KR;
	}
	
	public String lawyerArspNmList(String ARSP_NM) {
		String [] arspNmList = ARSP_NM.split(",");
		HashMap arspMap = new HashMap();
		String SET_ARSP_NM = "";
		for(int s=0; s<arspNmList.length; s++) {
			arspMap.put("ARSP_NM", arspNmList[s]);
			SET_ARSP_NM += commonDao.selectOne("suitSql.getArspNm", arspMap)+",";
		}
		
		return SET_ARSP_NM;
	}
	
	public List getTnrList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.getTnrList", mtenMap);
		return list;
	}
	
	public JSONObject duchk(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		int cnt = commonDao.selectOne("suitSql.duchk", mtenMap);
		if(cnt > 0){
			result.put("SUCCESS", "N");
		}else{
			result.put("SUCCESS", "Y");
		}
		return result;
	}
	
	public JSONObject changePassWord(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		//String lawyerid = mtenMap.get("lawyerid").toString();
		
		commonDao.update("suitSql.passwordChg", mtenMap);
		
		int cnt = commonDao.selectOne("suitSql.duchk", mtenMap);
		if(cnt > 0){
			result.put("SUCCESS", "N");
		}else{
			result.put("SUCCESS", "Y");
			
			String pw = mtenMap.get("LGN_PSWD")==null?"":mtenMap.get("LGN_PSWD").toString();
			String MBL_TELNO = mtenMap.get("MBL_TELNO")==null?"":mtenMap.get("MBL_TELNO").toString();
			if("seoul123!!!".equals(pw)) {
				String title = "[서울시 법률지원소통창구] 비밀번호초기화 알림";
				String msg = "[서울시 법률지원소통창구] 시스템 로그인 비밀번호가 초기화 되었습니다. 초기 비밀번호는 seoul123!!! 입니다. 로그인 후 비밀번호를 변경하세요.";
				SMSClientSend.sendSMS(MBL_TELNO, title, msg);
			}
		}
		return result;
	}
	
	public JSONObject insertLawyerInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String LWYR_MNG_NO = mtenMap.get("LWYR_MNG_NO").toString();
		String strTerm = "";
		
		if (mtenMap.get("SPC_FLD_NM[]") != null) {
			if (mtenMap.get("SPC_FLD_NM[]").getClass().equals(String.class)) {
				if (mtenMap.get("SPC_FLD_NM[]") != null && !mtenMap.get("SPC_FLD_NM[]").toString().equals("")) {
					mtenMap.put("SPC_FLD_NM", mtenMap.get("SPC_FLD_NM[]"));
				}
			} else {
				ArrayList SPC_FLD_NM = mtenMap.get("SPC_FLD_NM[]") == null ? new ArrayList():(ArrayList) mtenMap.get("SPC_FLD_NM[]");
				for (int i = 0; i < SPC_FLD_NM.size(); i++) {
					if (SPC_FLD_NM.get(i) != null && !SPC_FLD_NM.get(i).equals("")) {
						strTerm += SPC_FLD_NM.get(i)+",";
					}
				}
				mtenMap.put("SPC_FLD_NM", strTerm);
			}
		}
		
		if (mtenMap.get("ARSP_NM[]") != null) {
			if (mtenMap.get("ARSP_NM[]").getClass().equals(String.class)) {
				if (mtenMap.get("ARSP_NM[]") != null && !mtenMap.get("ARSP_NM[]").toString().equals("")) {
					mtenMap.put("ARSP_NM", mtenMap.get("ARSP_NM[]"));
				}
			} else {
				ArrayList SPC_FLD_NM = mtenMap.get("ARSP_NM[]") == null ? new ArrayList():(ArrayList) mtenMap.get("ARSP_NM[]");
				for (int i = 0; i < SPC_FLD_NM.size(); i++) {
					if (SPC_FLD_NM.get(i) != null && !SPC_FLD_NM.get(i).equals("")) {
						strTerm += SPC_FLD_NM.get(i)+",";
					}
				}
				mtenMap.put("ARSP_NM", strTerm);
			}
		}
		
		if (LWYR_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertLawyerInfo", mtenMap);
			LWYR_MNG_NO = mtenMap.get("LWYR_MNG_NO").toString();
		} else {
			commonDao.update("suitSql.updateLawyerInfo", mtenMap);
		}
		// 계좌정보 INSERT
		int ecnt = mtenMap.get("ecnt")==null?0:Integer.parseInt(mtenMap.get("ecnt").toString());
		
		LWYR_MNG_NO = mtenMap.get("LWYR_MNG_NO").toString();
		for(int i=0; i<ecnt; i++) {
			HashMap bankMap = new HashMap();
			String BACNT_MNG_NO = mtenMap.get("BACNT_MNG_NO"+i)==null?"":mtenMap.get("BACNT_MNG_NO"+i).toString();
			String DPSTR_NM = mtenMap.get("DPSTR_NM"+i)==null?"":mtenMap.get("DPSTR_NM"+i).toString();
			
			if (!DPSTR_NM.equals("")) {
				String actno = "";
				try {
					actno = AES256Cipher.AES_Encode(mtenMap.get("ACTNO"+i)==null?"":mtenMap.get("ACTNO"+i).toString());
				} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
						| NoSuchPaddingException | InvalidAlgorithmParameterException | IllegalBlockSizeException
						| BadPaddingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				bankMap.put("BACNT_MNG_NO", BACNT_MNG_NO);
				bankMap.put("LWYR_MNG_NO", LWYR_MNG_NO);
				bankMap.put("DPSTR_NM",   mtenMap.get("DPSTR_NM"+i)==null?"":mtenMap.get("DPSTR_NM"+i).toString());
				bankMap.put("BANK_NM",    mtenMap.get("BANK_NM"+i)==null?"":mtenMap.get("BANK_NM"+i).toString());
				bankMap.put("BANK_SE_NO", mtenMap.get("BANK_SE_NO"+i)==null?"":mtenMap.get("BANK_SE_NO"+i).toString());
				bankMap.put("ACTNO",      actno);
				bankMap.put("USE_YN",     mtenMap.get("USE_YN"+i)==null?"":mtenMap.get("USE_YN"+i).toString());
				bankMap.put("RMRK_CN",    mtenMap.get("RMRK_CN"+i)==null?"":mtenMap.get("RMRK_CN"+i).toString());
				
				bankMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM").toString());
				bankMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO").toString());
				bankMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM").toString());
				bankMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO").toString());
				
				if (BACNT_MNG_NO.equals("")) {
					commonDao.insert("suitSql.insertBankInfo", bankMap);
				} else {
					commonDao.insert("suitSql.updateBankInfo", bankMap);
				}
			}
		}
		//  INSERT 변호사임기
		int tcnt = mtenMap.get("tcnt")==null?0:Integer.parseInt(mtenMap.get("tcnt").toString());
		
		LWYR_MNG_NO = mtenMap.get("LWYR_MNG_NO").toString();
		for(int i=0; i<tcnt; i++) {
			HashMap tnrMap = new HashMap();
			String TNR_MNG_NO = mtenMap.get("TNR_MNG_NO"+i)==null?"":mtenMap.get("TNR_MNG_NO"+i).toString();
			String ENTRST_BGNG_YMD = mtenMap.get("ENTRST_BGNG_YMD"+i)==null?"":mtenMap.get("ENTRST_BGNG_YMD"+i).toString();
			
			if (!ENTRST_BGNG_YMD.equals("")) {
				tnrMap.put("TNR_MNG_NO", TNR_MNG_NO);
				tnrMap.put("LWYR_MNG_NO", LWYR_MNG_NO);
				tnrMap.put("ENTRST_BGNG_YMD", mtenMap.get("ENTRST_BGNG_YMD"+i)==null?"":mtenMap.get("ENTRST_BGNG_YMD"+i).toString());
				tnrMap.put("ENTRST_END_YMD", mtenMap.get("ENTRST_END_YMD"+i)==null?"":mtenMap.get("ENTRST_END_YMD"+i).toString());
				
				tnrMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM").toString());
				tnrMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO").toString());
				tnrMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM").toString());
				tnrMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO").toString());
				
				if (TNR_MNG_NO.equals("")) {
					commonDao.insert("suitSql.insertTnrInfo", tnrMap);
				} else {
					commonDao.insert("suitSql.updateTnrInfo", tnrMap);
				}
			}
		}
		
		commonDao.update("suitSql.updateLawfirmInfo2", mtenMap);
		
		result.put("LWYR_MNG_NO", LWYR_MNG_NO);
		result.put("msg", saveMsg);
		return result;
	}
	
	
	public JSONObject insertLawyerInfoOut(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String LWYR_MNG_NO = mtenMap.get("LWYR_MNG_NO").toString();
		commonDao.update("suitSql.updateLawyerInfoOut", mtenMap);
		result.put("LWYR_MNG_NO", LWYR_MNG_NO);
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteLawyerInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("suitSql.deleteLawyerInfo", mtenMap);
		result.put("msg", delMsg);
		return result;
	}
	

	public JSONObject selectLawyerPopList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectLawyerPopList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	public JSONObject selectLawfirmPopList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectLawfirmPopList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject selectCostList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectCostList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public HashMap getCostDetail(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getCostDetail", mtenMap);
	}

	
	public List getCostTarget(Map<String, Object> mtenMap) {
		List chrgLawyerList = commonDao.selectList("suitSql.selectChrgLawyerList", mtenMap);
		return chrgLawyerList;
	}

	
	public JSONObject insertCostInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String CST_MNG_NO = mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString();
		
		if(CST_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertCostInfo", mtenMap);
			CST_MNG_NO = mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString();
		} else {
			commonDao.update("suitSql.updateCostInfo", mtenMap);
			
			if (mtenMap.get("delfile[]") != null) {
				if (mtenMap.get("delfile[]").getClass().equals(String.class)) {
					if (mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")) {
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("suitSql.deleteFile", mtenMap);
					}
				} else {
					ArrayList delfile = mtenMap.get("delfile[]") == null ? new ArrayList() : (ArrayList) mtenMap.get("delfile[]");
					for (int i = 0; i < delfile.size(); i++) {
						if (delfile.get(i) != null && !delfile.get(i).equals("")) {
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("suitSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		result.put("CST_MNG_NO", CST_MNG_NO);
		result.put("msg", saveMsg);
		return result;
	}

	
	public JSONObject deleteCostInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String filepath = mtenMap.get("filepath").toString();
		String CST_MNG_NO = mtenMap.get("CST_MNG_NO")==null?"":mtenMap.get("CST_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("TRGT_PST_MNG_NO", CST_MNG_NO);
		param.put("TRGT_PST_TBL_NM", "TB_LWS_CST");
		param.put("FILE_SE", "COST");
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectFileList", param);
		
		// file 삭제
		for (int i = 0; i < list.size(); i++) {
			param = new HashMap<String, Object>();
			param.put("fileid", list.get(i).get("FILEID").toString());
			param.put("serverfilenm", list.get(i).get("SERVERFILENM").toString());
			param.put("filePath", filepath);
			fileDelete(param);
		}
		
		HashMap delMap = new HashMap();
		delMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO").toString());
		delMap.put("CST_MNG_NO",  CST_MNG_NO);
		commonDao.delete("suitSql.deleteCostInfo", delMap);
		
		result.put("msg", delMsg);
		
		return result;
	}
	
	public JSONObject selectCalList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String gbn = mtenMap.get("gbn")==null?"":mtenMap.get("gbn").toString();
		String amt = mtenMap.get("amt")==null?"":mtenMap.get("amt").toString();
		
		HashMap calMap = new HashMap();
		calMap.put("gbn", gbn);
		if (!amt.equals("")) {
			calMap.put("amt", amt);
		}
		
		List list = commonDao.selectList("suitSql.selectCalList", calMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	
	public JSONObject insertCalInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String CALFM_MNG_NO = mtenMap.get("CALFM_MNG_NO").toString();
		if (CALFM_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertCalInfo", mtenMap);
		} else {
			commonDao.update("suitSql.updateCalInfo", mtenMap);
		}
		
		result.put("CALFM_SE", mtenMap.get("CALFM_SE").toString());
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteCalInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("suitSql.deleteCalInfo", mtenMap);
		result.put("msg", delMsg);
		return result;
	}
	
	public JSONObject selectChrgLawyerList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectChrgLawyerList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getChrgLawyerDetail(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getChrgLawyerDetail", mtenMap);
	}
	
	public JSONObject insertChrgLawyer(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String AGT_MNG_NO = mtenMap.get("AGT_MNG_NO").toString();
		if (AGT_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertChrgLawyer", mtenMap);
		} else {
			commonDao.update("suitSql.updateChrgLawyer", mtenMap);
			
			if (mtenMap.get("delfile[]") != null) {
				if (mtenMap.get("delfile[]").getClass().equals(String.class)) {
					if (mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")) {
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("suitSql.deleteFile", mtenMap);
					}
				} else {
					ArrayList delfile = mtenMap.get("delfile[]") == null ? new ArrayList() : (ArrayList) mtenMap.get("delfile[]");
					for (int i = 0; i < delfile.size(); i++) {
						if (delfile.get(i) != null && !delfile.get(i).equals("")) {
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("suitSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		result.put("AGT_MNG_NO", mtenMap.get("AGT_MNG_NO").toString());
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteChrgLawyer(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String AGT_MNG_NO = mtenMap.get("AGT_MNG_NO")==null?"":mtenMap.get("AGT_MNG_NO").toString();
		String filepath = mtenMap.get("filepath").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("TRGT_PST_MNG_NO", AGT_MNG_NO);
		param.put("TRGT_PST_TBL_NM", "TB_LWS_AGT");
		param.put("FILE_SE", "CHRG");
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectFileList", param);
		
		// file 삭제
		for (int i = 0; i < list.size(); i++) {
			param = new HashMap<String, Object>();
			param.put("fileid", list.get(i).get("FILEID").toString());
			param.put("serverfilenm", list.get(i).get("SERVERFILENM").toString());
			param.put("filePath", filepath);
			fileDelete(param);
		}
		
		commonDao.delete("suitSql.deleteChrgLawyer", mtenMap);
		result.put("msg", delMsg);
		return result;
	}

	public JSONObject insertChrgCost(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String AGT_MNG_NO = mtenMap.get("AGT_MNG_NO").toString();
		commonDao.update("suitSql.insertChrgCost", mtenMap);
		
		if (mtenMap.get("delfile[]") != null) {
			if (mtenMap.get("delfile[]").getClass().equals(String.class)) {
				if (mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")) {
					mtenMap.put("fileid", mtenMap.get("delfile[]"));
					commonDao.delete("suitSql.deleteFile", mtenMap);
				}
			} else {
				ArrayList delfile = mtenMap.get("delfile[]") == null ? new ArrayList() : (ArrayList) mtenMap.get("delfile[]");
				for (int i = 0; i < delfile.size(); i++) {
					if (delfile.get(i) != null && !delfile.get(i).equals("")) {
						mtenMap.put("fileid", delfile.get(i));
						commonDao.delete("suitSql.deleteFile", mtenMap);
					}
				}
			}
		}
		
		List empList = commonDao.selectList("suitSql.getChrgEmpInfo2", mtenMap);
		if (empList.size() > 0) {
			Map<String, Object> param = new HashMap<String, Object>();
			ArrayList<String> sendUserList = new ArrayList();
			ArrayList<String> sendUserNmList = new ArrayList();
			
			String cont = "";
			String LwsNo = "";
			String incdntNo = "";
			
			for(int i=0; i<empList.size(); i++){
				HashMap info = (HashMap)empList.get(i);
				LwsNo = info.get("LWS_MNG_NO")==null?"":info.get("LWS_MNG_NO").toString();
				incdntNo = info.get("INCDNT_NO")==null?"":info.get("INCDNT_NO").toString();
				sendUserList.add(info.get("EMP_PK_NO")==null?"":info.get("EMP_PK_NO").toString());
				sendUserNmList.add(info.get("EMP_NM")==null?"":info.get("EMP_NM").toString());
			}
			
			String OTST_AMT    = mtenMap.get("OTST_AMT")==null?"":mtenMap.get("OTST_AMT").toString();
			String SCS_PAY_AMT = mtenMap.get("SCS_PAY_AMT")==null?"":mtenMap.get("SCS_PAY_AMT").toString();
			String ACAP_AMT    = mtenMap.get("ACAP_AMT")==null?"":mtenMap.get("ACAP_AMT").toString();
			String APRV_YN     = mtenMap.get("APRV_YN")==null?"":mtenMap.get("APRV_YN").toString();
			String re          = " ";
			if ("R".equals(APRV_YN)) {
				re = " [보완]";
			}
			
			cont = cont + "아래 사건에 대해"+re+"소송비용 지급 요청이 있으니, 법률지원통합시스템에 접속하여 확인하여주시기 바랍니다.<br/>";
			cont = cont + "담당 변호사께서는 사건 소송위임탭의 위임정보 상세화면에서 소송비용지급요청내용을 확인하시고,<br/>";
			cont = cont + "이상이 없을 경우 [승인] 버튼을, 보완이 필요할 경우 [보완]버튼을 클릭하여 주시기 바랍니다. <br/>";
			cont = cont + "<br/>";
			cont = cont + "관리번호: "+LwsNo+"<br/>";
			cont = cont + "사건번호: "+incdntNo+"<br/>";
			
			cont = cont + "착수금 : "+OTST_AMT+"<br/>";
			cont = cont + "성공보수 : "+SCS_PAY_AMT+"<br/>";
			cont = cont + "수임료 : "+ACAP_AMT+"<br/>";
			
			SendMail mail = new SendMail();
			mail.sendMail("[법률지원통합시스템] "+LwsNo+" "+incdntNo+" 사건의 소송비용지급요청건이 있습니다."+re, cont, sendUserList, sendUserNmList, null, "");
		}
		
		result.put("AGT_MNG_NO", mtenMap.get("AGT_MNG_NO").toString());
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject updateChrgLawyerAmtList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String APRV_YN  = mtenMap.get("APRV_YN")==null?"":mtenMap.get("APRV_YN").toString();
		String GIVE_YN  = mtenMap.get("GIVE_YN")==null?"":mtenMap.get("GIVE_YN").toString();
		String GIVE_YMD = mtenMap.get("GIVE_YMD")==null?"":mtenMap.get("GIVE_YMD").toString();
		
		List LWS_MNG_NO_LIST  = new ArrayList();
		List INST_MNG_NO_LIST = new ArrayList();
		List AGT_MNG_NO_LIST  = new ArrayList();
		
		if (mtenMap.get("LWS_MNG_NO_LIST[]") != null) {
			if (mtenMap.get("LWS_MNG_NO_LIST[]").getClass().equals(String.class)) {
				if (mtenMap.get("LWS_MNG_NO_LIST[]") != null && !mtenMap.get("LWS_MNG_NO_LIST[]").toString().equals("")) {
					LWS_MNG_NO_LIST.add(mtenMap.get("LWS_MNG_NO_LIST[]"));
					INST_MNG_NO_LIST.add(mtenMap.get("INST_MNG_NO_LIST[]"));
					AGT_MNG_NO_LIST.add(mtenMap.get("AGT_MNG_NO_LIST[]"));
				}
			} else {
				LWS_MNG_NO_LIST  = mtenMap.get("LWS_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("LWS_MNG_NO_LIST[]");
				INST_MNG_NO_LIST = mtenMap.get("INST_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("INST_MNG_NO_LIST[]");
				AGT_MNG_NO_LIST  = mtenMap.get("AGT_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("AGT_MNG_NO_LIST[]");
			}
		}
		
		HashMap costMap = new HashMap();
		for(int c=0; c<LWS_MNG_NO_LIST.size(); c++) {
			String LWS_MNG_NO  = LWS_MNG_NO_LIST.get(c).toString();
			String INST_MNG_NO = INST_MNG_NO_LIST.get(c).toString();
			String AGT_MNG_NO  = AGT_MNG_NO_LIST.get(c).toString();
			
			costMap = new HashMap();
			costMap.put("LWS_MNG_NO",  LWS_MNG_NO);
			costMap.put("INST_MNG_NO", INST_MNG_NO);
			costMap.put("AGT_MNG_NO",  AGT_MNG_NO);
			costMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
			costMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
			costMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
			costMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
			
			costMap.put("APRV_YN",  APRV_YN);
			costMap.put("GIVE_YN",  GIVE_YN);
			costMap.put("GIVE_YMD", GIVE_YMD);
			
			commonDao.update("suitSql.updateChrgLawyerAmt", costMap);
			
			if (GIVE_YN.equals("")) {
				if ("Y".equals(APRV_YN)) {
					// 나의할일 추가
					List taskEmpList = commonDao.selectList("suitSql.getChrgEmpInfo2", costMap);
					HashMap taskMap = new HashMap();
					for(int i=0; i<taskEmpList.size(); i++) {
						HashMap listMap = (HashMap)taskEmpList.get(i);
						taskMap = new HashMap();
						taskMap.put("EMP_NO", listMap.get("EMP_NO")==null?"":listMap.get("EMP_NO").toString());
						taskMap.put("TASK_SE", "S1");
						taskMap.put("DOC_MNG_NO", AGT_MNG_NO);
						taskMap.put("PRCS_YN", "N");
						mifService.setTask(taskMap);
					}
					
					// 지급 담당자에게 메일 발송
					HashMap caseInfo = commonDao.selectOne("suitSql.getCaseDetail", costMap);
					
					costMap.put("ROLE", "E");
					List giveEmpList = commonDao.selectList("suitSql.getChrgEmpInfo3", costMap);
					
					HashMap lawAmt = commonDao.select("suitSql.getChrgLawyerDetail", costMap);
					
					if(giveEmpList.size() > 0) {
						ArrayList<String> sendUserList = new ArrayList();
						ArrayList<String> sendUserNmList = new ArrayList();
						String LWS_NO = "";
						String INCDNT_NO = "";
						String EMPNM = "";
						
						for(int i=0; i<giveEmpList.size(); i++){
							HashMap info = (HashMap)giveEmpList.get(i);
							LWS_NO    = info.get("LWS_NO")==null?"":info.get("LWS_NO").toString();
							INCDNT_NO = info.get("INCDNT_NO")==null?"":info.get("INCDNT_NO").toString();
							EMPNM     = info.get("EMPNM")==null?"":info.get("EMPNM").toString();
							
							sendUserList.add(info.get("EMP_PK_NO")==null?"":info.get("EMP_PK_NO").toString());
							sendUserNmList.add(info.get("EMPNM")==null?"":info.get("EMPNM").toString());
						}
						
						String OTST_AMT    = lawAmt.get("OTST_AMT")==null?"":lawAmt.get("OTST_AMT").toString();
						String SCS_PAY_AMT = lawAmt.get("SCS_PAY_AMT")==null?"":lawAmt.get("SCS_PAY_AMT").toString();
						String ACAP_AMT    = lawAmt.get("ACAP_AMT")==null?"":lawAmt.get("ACAP_AMT").toString();
						
						
						String title = "[법률지원통합시스템] "+LWS_NO+" "+INCDNT_NO+" 사건의 소송비용지급요청건에 대해 "+EMPNM+"가 승인하였습니다.";
						String cont = "";
						cont = cont + "아래 사건에 대한 소송비용 지급 요청에 대해 "+EMPNM+"가 승인하였습니다.<br/>";
						cont = cont + "<br/>";
						cont = cont + "관리번호: "+LWS_NO+"<br/>";
						cont = cont + "사건번호: "+INCDNT_NO+"<br/>";
						
						cont = cont + "착수금 : "+OTST_AMT+"<br/>";
						cont = cont + "성공보수 : "+SCS_PAY_AMT+"<br/>";
						cont = cont + "수임료 : "+ACAP_AMT;
						SendMail mail = new SendMail();
						mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
					}
				}
			} else if ("Y".equals(GIVE_YN)) {
				// 변호사에게 알림 발송
				String mobileNo = commonDao.selectOne("suitSql.sendLawyerInfo", costMap);
				HashMap caseInfo = commonDao.selectOne("suitSql.getCaseDetail", costMap);
				if(!mobileNo.equals("")) {
					String title = "[서울시 법률지원소통창구] "+caseInfo.get("INCDNT_NO")==null?"":caseInfo.get("INCDNT_NO").toString()+"비용지급완료";
					String msg = "[서울시 법률지원소통창구] "+caseInfo.get("INCDNT_NO")==null?"":caseInfo.get("INCDNT_NO").toString()+" 비용지급요청건에 대해 지급이 완료되었습니다.";
					SMSClientSend.sendSMS(mobileNo, title, msg);
				}
				
				// 나의 할 일 제거
				List taskEmpList = commonDao.selectList("suitSql.getChrgEmpInfo2", costMap);
				HashMap taskMap = new HashMap();
				for(int i=0; i<taskEmpList.size(); i++) {
					HashMap listMap = (HashMap)taskEmpList.get(i);
					taskMap = new HashMap();
					taskMap.put("EMP_NO", listMap.get("EMP_NO")==null?"":listMap.get("EMP_NO").toString());
					taskMap.put("TASK_SE", "S1");
					taskMap.put("DOC_MNG_NO", AGT_MNG_NO);
					taskMap.put("PRCS_YN", "Y");
					mifService.setTask(taskMap);
				}
			}
		}
		
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject updateChrgLawyerAmt(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.update("suitSql.updateChrgLawyerAmt", mtenMap);
		
		String APRV_YN = mtenMap.get("APRV_YN")==null?"":mtenMap.get("APRV_YN").toString();
		String GIVE_YN = mtenMap.get("GIVE_YN")==null?"":mtenMap.get("GIVE_YN").toString();
		
		if (GIVE_YN.equals("")) {
			if("R".equals(APRV_YN)) {
				// 변호사에게 알림 발송
				String mobileNo = commonDao.selectOne("suitSql.sendLawyerInfo", mtenMap);
				HashMap caseInfo = commonDao.selectOne("suitSql.getCaseDetail", mtenMap);
				if(!mobileNo.equals("")) {
					String title = "[서울시 법률지원소통창구] "+caseInfo.get("INCDNT_NO")==null?"":caseInfo.get("INCDNT_NO").toString()+" 비용지급요청건 보완 필요";
					String msg = "[서울시 법률지원소통창구] "+caseInfo.get("INCDNT_NO")==null?"":caseInfo.get("INCDNT_NO").toString()+" 비용지급요청건의 보완이 필요합니다. "
							+ "자세한 내용은 서울시 법률지원소통창구에 접속하여 확인바랍니다.";
					SMSClientSend.sendSMS(mobileNo, title, msg);
				}
			} else if ("Y".equals(APRV_YN)) {
				// 나의할일 추가
				List taskEmpList = commonDao.selectList("suitSql.getChrgEmpInfo2", mtenMap);
				HashMap taskMap = new HashMap();
				for(int i=0; i<taskEmpList.size(); i++) {
					HashMap listMap = (HashMap)taskEmpList.get(i);
					taskMap = new HashMap();
					taskMap.put("EMP_NO", listMap.get("EMP_NO")==null?"":listMap.get("EMP_NO").toString());
					taskMap.put("TASK_SE", "S1");
					taskMap.put("DOC_MNG_NO", mtenMap.get("AGT_MNG_NO")==null?"":mtenMap.get("AGT_MNG_NO").toString());
					taskMap.put("PRCS_YN", "N");
					mifService.setTask(taskMap);
				}
				
				// 지급 담당자에게 메일 발송
				HashMap caseInfo = commonDao.selectOne("suitSql.getCaseDetail", mtenMap);
				mtenMap.put("ROLE", "E");
				List giveEmpList = commonDao.selectList("suitSql.getChrgEmpInfo3", mtenMap);
				
				HashMap lawAmt = commonDao.select("suitSql.getChrgLawyerDetail", mtenMap);
				
				if(giveEmpList.size() > 0) {
					ArrayList<String> sendUserList = new ArrayList();
					ArrayList<String> sendUserNmList = new ArrayList();
					String LWS_NO = "";
					String INCDNT_NO = "";
					String EMPNM = "";
					
					for(int i=0; i<giveEmpList.size(); i++){
						HashMap info = (HashMap)giveEmpList.get(i);
						LWS_NO = info.get("LWS_NO")==null?"":info.get("LWS_NO").toString();
						INCDNT_NO = info.get("INCDNT_NO")==null?"":info.get("INCDNT_NO").toString();
						EMPNM = info.get("EMPNM")==null?"":info.get("EMPNM").toString();
						
						sendUserList.add(info.get("EMP_PK_NO")==null?"":info.get("EMP_PK_NO").toString());
						sendUserNmList.add(info.get("EMPNM")==null?"":info.get("EMPNM").toString());
					}
					
					String OTST_AMT    = lawAmt.get("OTST_AMT")==null?"":lawAmt.get("OTST_AMT").toString();
					String SCS_PAY_AMT = lawAmt.get("SCS_PAY_AMT")==null?"":lawAmt.get("SCS_PAY_AMT").toString();
					String ACAP_AMT    = lawAmt.get("ACAP_AMT")==null?"":lawAmt.get("ACAP_AMT").toString();
					
					
					String title = "[법률지원통합시스템] "+LWS_NO+" "+INCDNT_NO+" 사건의 소송비용지급요청건에 대해 "+EMPNM+"가 승인하였습니다.";
					String cont = "";
					cont = cont + "아래 사건에 대한 소송비용 지급 요청에 대해 "+EMPNM+"가 승인하였습니다.<br/>";
					cont = cont + "<br/>";
					cont = cont + "관리번호: "+LWS_NO+"<br/>";
					cont = cont + "사건번호: "+INCDNT_NO+"<br/>";
					
					cont = cont + "착수금 : "+OTST_AMT+"<br/>";
					cont = cont + "성공보수 : "+SCS_PAY_AMT+"<br/>";
					cont = cont + "수임료 : "+ACAP_AMT;
					SendMail mail = new SendMail();
					mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
				}
			}
		} else if ("Y".equals(GIVE_YN)) {
			// 변호사에게 알림 발송
			String mobileNo = commonDao.selectOne("suitSql.sendLawyerInfo", mtenMap);
			HashMap caseInfo = commonDao.selectOne("suitSql.getCaseDetail", mtenMap);
			if(!mobileNo.equals("")) {
				String title = "[서울시 법률지원소통창구] "+caseInfo.get("INCDNT_NO")==null?"":caseInfo.get("INCDNT_NO").toString()+"비용지급완료";
				String msg = "[서울시 법률지원소통창구] "+caseInfo.get("INCDNT_NO")==null?"":caseInfo.get("INCDNT_NO").toString()+" 비용지급요청건에 대해 지급이 완료되었습니다.";
				SMSClientSend.sendSMS(mobileNo, title, msg);
			}
			
			// 나의 할 일 제거
			List taskEmpList = commonDao.selectList("suitSql.getChrgEmpInfo2", mtenMap);
			HashMap taskMap = new HashMap();
			for(int i=0; i<taskEmpList.size(); i++) {
				HashMap listMap = (HashMap)taskEmpList.get(i);
				taskMap = new HashMap();
				taskMap.put("EMP_NO", listMap.get("EMP_NO")==null?"":listMap.get("EMP_NO").toString());
				taskMap.put("TASK_SE", "S1");
				taskMap.put("DOC_MNG_NO", mtenMap.get("AGT_MNG_NO")==null?"":mtenMap.get("AGT_MNG_NO").toString());
				taskMap.put("PRCS_YN", "Y");
				mifService.setTask(taskMap);
			}
		}
		
		result.put("msg", saveMsg);
		return result;
	}

	public JSONObject selectBondList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List bondList = commonDao.selectList("suitSql.selectBondList", mtenMap);
		JSONArray jr = JSONArray.fromObject(bondList);
		result.put("result", jr);
		return result;
	}

	public List selectRecInfoList(Map<String, Object> mtenMap) {
		List recList = commonDao.selectList("suitSql.selectRecInfoList", mtenMap);
		return recList;
	}

	public HashMap getBondDetail(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getBondDetail", mtenMap);
	}

	public HashMap getBondRecDetail(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getBondRecDetail", mtenMap);
	}

	public JSONObject insertBondInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String BND_MNG_NO = mtenMap.get("BND_MNG_NO").toString();
		if (BND_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertBondInfo", mtenMap);
		} else {
			commonDao.update("suitSql.updateBondInfo", mtenMap);
			
			if (mtenMap.get("delfile[]") != null) {
				if (mtenMap.get("delfile[]").getClass().equals(String.class)) {
					if (mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")) {
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("suitSql.deleteFile", mtenMap);
					}
				} else {
					ArrayList delfile = mtenMap.get("delfile[]") == null ? new ArrayList() : (ArrayList) mtenMap.get("delfile[]");
					for (int i = 0; i < delfile.size(); i++) {
						if (delfile.get(i) != null && !delfile.get(i).equals("")) {
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("suitSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		result.put("BND_MNG_NO", mtenMap.get("BND_MNG_NO").toString());
		result.put("msg", saveMsg);
		return result;
	}

	public JSONObject insertRecInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String BND_RTRVL_MNG_NO = mtenMap.get("BND_RTRVL_MNG_NO").toString();
		if (BND_RTRVL_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertRecInfo", mtenMap);
		} else {
			commonDao.update("suitSql.updateRecInfo", mtenMap);
		}
		
		result.put("BND_RTRVL_MNG_NO", mtenMap.get("BND_RTRVL_MNG_NO").toString());
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteRecInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("suitSql.deleteRecInfo", mtenMap);
		result.put("msg", delMsg);
		return result;
	}
	
	public JSONObject deleteBondInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String filepath = mtenMap.get("filepath").toString();
		String BND_MNG_NO = mtenMap.get("BND_MNG_NO")==null?"":mtenMap.get("BND_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("TRGT_PST_MNG_NO", BND_MNG_NO);
		param.put("TRGT_PST_TBL_NM", "TB_LWS_BND");
		param.put("FILE_SE", "BOND");
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectFileList", param);
		
		// file 삭제
		for (int i = 0; i < list.size(); i++) {
			param = new HashMap<String, Object>();
			param.put("fileid", list.get(i).get("FILEID").toString());
			param.put("serverfilenm", list.get(i).get("SERVERFILENM").toString());
			param.put("filePath", filepath);
			fileDelete(param);
		}
		
		HashMap delMap = new HashMap();
		delMap.put("LWS_MNG_NO",  mtenMap.get("LWS_MNG_NO").toString());
		delMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO").toString());
		delMap.put("BND_MNG_NO",  mtenMap.get("BND_MNG_NO").toString());
		commonDao.delete("suitSql.deleteRecInfo", delMap);
		commonDao.delete("suitSql.deleteBondInfo", delMap);
		
		result.put("msg", delMsg);
		
		return result;
	}
	
	public JSONObject selectReportList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List bondList = commonDao.selectList("suitSql.selectReportList", mtenMap);
		JSONArray jr = JSONArray.fromObject(bondList);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getReportDetail(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getReportDetail", mtenMap);
	}
	
	public JSONObject insertReportInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String RPTP_MNG_NO = mtenMap.get("RPTP_MNG_NO").toString();
		if (RPTP_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertReportInfo", mtenMap);
		} else {
			commonDao.update("suitSql.updateReportInfo", mtenMap);
			
			if (mtenMap.get("delfile[]") != null) {
				if (mtenMap.get("delfile[]").getClass().equals(String.class)) {
					if (mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")) {
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("suitSql.deleteFile", mtenMap);
					}
				} else {
					ArrayList delfile = mtenMap.get("delfile[]") == null ? new ArrayList() : (ArrayList) mtenMap.get("delfile[]");
					for (int i = 0; i < delfile.size(); i++) {
						if (delfile.get(i) != null && !delfile.get(i).equals("")) {
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("suitSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		result.put("RPTP_MNG_NO", mtenMap.get("RPTP_MNG_NO").toString());
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteReportInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String filepath = mtenMap.get("filepath").toString();
		String RPTP_MNG_NO = mtenMap.get("RPTP_MNG_NO")==null?"":mtenMap.get("RPTP_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("TRGT_PST_MNG_NO", RPTP_MNG_NO);
		param.put("TRGT_PST_TBL_NM", "TB_LWS_RPTP");
		param.put("FILE_SE", "REP");
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectFileList", param);
		
		// file 삭제
		for (int i = 0; i < list.size(); i++) {
			param = new HashMap<String, Object>();
			param.put("fileid", list.get(i).get("FILEID").toString());
			param.put("serverfilenm", list.get(i).get("SERVERFILENM").toString());
			param.put("filePath", filepath);
			fileDelete(param);
		}
		
		HashMap delMap = new HashMap();
		delMap.put("LWS_MNG_NO",  mtenMap.get("LWS_MNG_NO").toString());
		delMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO").toString());
		delMap.put("RPTP_MNG_NO",  mtenMap.get("RPTP_MNG_NO").toString());
		commonDao.delete("suitSql.deleteReportInfo", delMap);
		
		result.put("msg", delMsg);
		
		return result;
	}
	
	public JSONObject selectChkList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		
		List bondList = commonDao.selectList("suitSql.selectChkList", mtenMap);
		JSONArray jr = JSONArray.fromObject(bondList);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getChkInfoDetail(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getChkInfoDetail", mtenMap);
	}
	
	public JSONObject insertChkInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String grpcd = mtenMap.get("grpcd")==null?"":mtenMap.get("grpcd").toString();
		
		String RPTP_MNG_NO = mtenMap.get("RVW_MNG_NO").toString();
		String gbn = mtenMap.get("gbn").toString();
		ArrayList<String> sendUserList = new ArrayList();
		ArrayList<String> sendUserNmList = new ArrayList();
		
		List taskEmpList = commonDao.selectList("suitSql.getChrgEmpInfo2", mtenMap);
		HashMap suitMap = commonDao.selectOne("suitSql.getSuitDetail", mtenMap);
		
		if ("insert".equals(gbn)) {
			mtenMap.put("ANS_SEQ", 0);
			commonDao.insert("suitSql.insertChkInfo", mtenMap);
			
			if ("X".indexOf(grpcd) > -1) {
				//2. 송무1, 2팀 소속 변호사
				String title = "";
				String cont = "";
				for(int i=0; i<taskEmpList.size(); i++) {
					HashMap senMap = (HashMap)taskEmpList.get(i);
					title = "[법률지원통합시스템]"+(senMap.get("LWS_NO")==null?"":senMap.get("LWS_NO").toString())+" "+
							(senMap.get("INCDNT_NO")==null?"":senMap.get("INCDNT_NO").toString())+" 에 의견이 등록되었습니다.";
					cont = (senMap.get("LWS_NO")==null?"":senMap.get("LWS_NO").toString())+" "+
							(senMap.get("INCDNT_NO")==null?"":senMap.get("INCDNT_NO").toString())+" 에 의견이 등록되었으니, 법률지원통합시스템에 접속하여 확인하시기 바랍니다.";
					sendUserList.add(senMap.get("EMP_PK_NO")==null?"":senMap.get("EMP_PK_NO").toString());
				}
				
				//6. 부서 소송담당 주무관
				mtenMap.put("empno", suitMap.get("SPRVSN_EMP_NO")==null?"":suitMap.get("SPRVSN_EMP_NO").toString());
				HashMap param = commonDao.selectOne("suitSql.getChrgEmpInfo", mtenMap);
				sendUserList.add(param.get("EMP_PK_NO")==null?"":param.get("EMP_PK_NO").toString());
				sendUserNmList.add(param.get("EMP_NM")==null?"":param.get("EMP_NM").toString());
				
				SendMail mail = new SendMail();
				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
				
				// 내부담당자 나의 할 일 추가
				HashMap taskMap = new HashMap();
				for(int i=0; i<taskEmpList.size(); i++) {
					HashMap listMap = (HashMap)taskEmpList.get(i);
					taskMap = new HashMap();
					taskMap.put("EMP_NO", listMap.get("EMP_NO")==null?"":listMap.get("EMP_NO").toString());
					taskMap.put("TASK_SE", "S3");
					taskMap.put("DOC_MNG_NO", mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString());
					taskMap.put("PRCS_YN", "N");
					mifService.setTask(taskMap);
				}
			} else {
				// 외부 변호사 문자 발송
				List sendAgt = commonDao.selectList("suitSql.selectSendAgtInfo", mtenMap);
				
				try {
					HashMap sendInfo = commonDao.selectOne("suitSql.getChrgEmpInfo1", mtenMap);
					
					for(int i=0; i<sendAgt.size(); i++) {
						HashMap agtMap = (HashMap)sendAgt.get(i);
						String mobileNo = agtMap.get("MBL_TELNO")==null?"":agtMap.get("MBL_TELNO").toString();
						if(!mobileNo.equals("")) {
							String title = "[서울시 법률지원소통창구]"+(sendInfo.get("INCDNT_NO")==null?"":sendInfo.get("INCDNT_NO").toString())+" 의견 등록 알림";
							String msg = (sendInfo.get("INCDNT_NO")==null?"":sendInfo.get("INCDNT_NO").toString())+
									"에 의견이 등록되었으니, 법률지원소통창구에 접속하여 확인하시기 바랍니다.";
							SMSClientSend.sendSMS(mobileNo, title, msg);
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else if ("reply".equals(gbn)) {
			int cnt = commonDao.selectOne("suitSql.selectChkDepthCnt", mtenMap);
			mtenMap.put("ANS_SEQ", cnt);
			commonDao.insert("suitSql.insertChkInfo", mtenMap);
			
			if ("X".indexOf(grpcd) > -1) {
				//2. 송무1, 2팀 소속 변호사
				String title = "";
				String cont = "";
				for(int i=0; i<taskEmpList.size(); i++) {
					HashMap senMap = (HashMap)taskEmpList.get(i);
					title = "[법률지원통합시스템]"+(senMap.get("LWS_NO")==null?"":senMap.get("LWS_NO").toString())+" "+
							(senMap.get("INCDNT_NO")==null?"":senMap.get("INCDNT_NO").toString())+" 에 의견이 등록되었습니다.";
					cont = (senMap.get("LWS_NO")==null?"":senMap.get("LWS_NO").toString())+" "+
							(senMap.get("INCDNT_NO")==null?"":senMap.get("INCDNT_NO").toString())+" 에 의견이 등록되었으니, 법률지원통합시스템에 접속하여 확인하시기 바랍니다.";
					sendUserList.add(senMap.get("EMP_PK_NO")==null?"":senMap.get("EMP_PK_NO").toString());
					sendUserNmList.add(senMap.get("EMP_NM")==null?"":senMap.get("EMP_NM").toString());
				}
				
				//6. 부서 소송담당 주무관
				mtenMap.put("empno", suitMap.get("SPRVSN_EMP_NO")==null?"":suitMap.get("SPRVSN_EMP_NO").toString());
				HashMap param = commonDao.selectOne("suitSql.getChrgEmpInfo", mtenMap);
				sendUserList.add(param.get("EMP_PK_NO")==null?"":param.get("EMP_PK_NO").toString());
				sendUserNmList.add(param.get("EMP_NM")==null?"":param.get("EMP_NM").toString());
				
				SendMail mail = new SendMail();
				mail.sendMail(title, cont, sendUserList, sendUserNmList, null, "");
				
				// 내부담당자 나의 할 일 추가
				HashMap taskMap = new HashMap();
				for(int i=0; i<taskEmpList.size(); i++) {
					HashMap listMap = (HashMap)taskEmpList.get(i);
					taskMap = new HashMap();
					taskMap.put("EMP_NO", listMap.get("EMP_NO")==null?"":listMap.get("EMP_NO").toString());
					taskMap.put("TASK_SE", "S3");
					taskMap.put("DOC_MNG_NO", mtenMap.get("RVW_MNG_NO")==null?"":mtenMap.get("RVW_MNG_NO").toString());
					taskMap.put("PRCS_YN", "N");
					mifService.setTask(taskMap);
				}
			} else {
				// 외부 변호사 문자 발송
				List sendAgt = commonDao.selectList("suitSql.selectSendAgtInfo", mtenMap);
				
				try {
					HashMap sendInfo = commonDao.selectOne("suitSql.getChrgEmpInfo1", mtenMap);
					
					for(int i=0; i<sendAgt.size(); i++) {
						HashMap agtMap = (HashMap)sendAgt.get(i);
						String mobileNo = agtMap.get("MBL_TELNO")==null?"":agtMap.get("MBL_TELNO").toString();
						if(!mobileNo.equals("")) {
							String title = "[서울시 법률지원소통창구]"+(sendInfo.get("INCDNT_NO")==null?"":sendInfo.get("INCDNT_NO").toString())+" 의견 등록 알림";
							String msg = (sendInfo.get("INCDNT_NO")==null?"":sendInfo.get("INCDNT_NO").toString())+
									"에 의견이 등록되었으니, 법률지원소통창구에 접속하여 확인하시기 바랍니다.";
							SMSClientSend.sendSMS(mobileNo, title, msg);
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else {
			commonDao.update("suitSql.updateChkInfo", mtenMap);
			
			if (mtenMap.get("delfile[]") != null) {
				if (mtenMap.get("delfile[]").getClass().equals(String.class)) {
					if (mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")) {
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("suitSql.deleteFile", mtenMap);
					}
				} else {
					ArrayList delfile = mtenMap.get("delfile[]") == null ? new ArrayList() : (ArrayList) mtenMap.get("delfile[]");
					for (int i = 0; i < delfile.size(); i++) {
						if (delfile.get(i) != null && !delfile.get(i).equals("")) {
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("suitSql.deleteFile", mtenMap);
						}
					}
				}
			}
		}
		
		result.put("RVW_MNG_NO", mtenMap.get("RVW_MNG_NO").toString());
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteChkInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String filepath = mtenMap.get("filepath").toString();
		String RVW_MNG_NO = mtenMap.get("RVW_MNG_NO")==null?"":mtenMap.get("RVW_MNG_NO").toString();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("TRGT_PST_MNG_NO", RVW_MNG_NO);
		param.put("TRGT_PST_TBL_NM", "TB_LWS_RVW_PRGRS");
		param.put("FILE_SE", "CHK");
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectFileList", param);
		
		// file 삭제
		for (int i = 0; i < list.size(); i++) {
			param = new HashMap<String, Object>();
			param.put("fileid", list.get(i).get("FILEID").toString());
			param.put("serverfilenm", list.get(i).get("SERVERFILENM").toString());
			param.put("filePath", filepath);
			fileDelete(param);
		}
		
		HashMap delMap = new HashMap();
		delMap.put("LWS_MNG_NO",  mtenMap.get("LWS_MNG_NO").toString());
		delMap.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO").toString());
		delMap.put("RVW_MNG_NO",  mtenMap.get("RVW_MNG_NO").toString());
		commonDao.delete("suitSql.deleteChkInfo", delMap);
		
		result.put("msg", delMsg);
		
		return result;
	}
	
	public JSONObject selectMemoList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List bondList = commonDao.selectList("suitSql.selectMemoList", mtenMap);
		JSONArray jr = JSONArray.fromObject(bondList);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject insertMemo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String MEMO_MNG_NO = mtenMap.get("MEMO_MNG_NO")==null?"":mtenMap.get("MEMO_MNG_NO").toString();
		if (MEMO_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertMemo", mtenMap);
		} else {
			commonDao.update("suitSql.updateMemo", mtenMap);
		}
		
		result.put("MEMO_MNG_NO", mtenMap.get("MEMO_MNG_NO").toString());
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteMemo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.delete("suitSql.deleteMemo", mtenMap);
		result.put("msg", delMsg);
		return result;
	}
	
	public List getSatisitemList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.getSatisitemList", mtenMap);
		return list;
	}
	
	public JSONObject insertSatisitem(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String DGSTFN_SRVY_MNG_NO = mtenMap.get("DGSTFN_SRVY_MNG_NO")==null?"":mtenMap.get("DGSTFN_SRVY_MNG_NO").toString();
		if(DGSTFN_SRVY_MNG_NO.equals("")){
			commonDao.insert("suitSql.insertSatisitem",mtenMap);
		}else{
			commonDao.update("suitSql.updateSatisitem",mtenMap);
		}
		
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject selectSatisfactionList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectSatisfactionList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public List getSatisfactionList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.getSatisfactionList", mtenMap);
		return list;
	}
	
	public List getLawyerList(Map<String, Object> mtenMap) {
		//List list = commonDao.selectList("suitSql.getLawyerList", mtenMap);
		List list = commonDao.selectList("suitSql.selectChrgLawyerList", mtenMap);
		return list;
	}
	
	public List getProcSatisList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.getProcSatisList", mtenMap);
		return list;
	}
	
	public List getSatisitemList2(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.getSatisitemList", mtenMap);
		return list;
	}
	
	public int insertSatisfaction(org.json.simple.JSONArray jsonArr) {
		int result = 0;
		for(int i=0; i<jsonArr.size(); i++){
			HashMap map = (HashMap) jsonArr.get( i );
			if(String.valueOf(map.get("DGSTFN_ANS_MNG_NO")).length() > 0){
				commonDao.update("suitSql.updateSatisfaction", map );
			}else{
				commonDao.insert("suitSql.insertSatisfaction", map);
				
				String WRTR_EMP_NO = map.get("WRTR_EMP_NO")==null?"":map.get("WRTR_EMP_NO").toString();
				HashMap taskMap = new HashMap();
				taskMap = new HashMap();
				//taskMap.put("EMP_NO", WRTR_EMP_NO);
				taskMap.put("TASK_SE", "S4");
				taskMap.put("DOC_MNG_NO", map.get("TRGT_PST_MNG_NO")==null?"":map.get("TRGT_PST_MNG_NO").toString());
				taskMap.put("PRCS_YN", "Y");
				mifService.setTask(taskMap);
				
				//taskMap.put("TASK_SE", "C7");
				//mifService.setTask(taskMap);
				
				//taskMap.put("TASK_SE", "A7");
				//mifService.setTask(taskMap);
			}
		}
		return result;
	}
	
	public List getAgtList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.getAgtList", mtenMap);
		return list;
	}
	

	public JSONObject setViewYn(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		commonDao.update("suitSql.setViewYn", mtenMap);
		result.put("msg", saveMsg);
		return result;
	}
	
	
	public JSONObject selectUnchangeDateList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectUnchDateList", mtenMap);
		int cnt = commonDao.select("suitSql.selectUnchDateListCnt", mtenMap);
		
		JSONArray jr = JSONArray.fromObject(list);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getUnchDateInfo(Map<String, Object> mtenMap) {
		HashMap dateInfo = commonDao.selectOne("suitSql.selectUnchDateInfo", mtenMap);
		return dateInfo;
	}
	
	public JSONObject UnchDateInfoSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String UNCH_DATE_MNG_NO = mtenMap.get("UNCH_DATE_MNG_NO").toString();
		
		String strTerm = "";
		
		if (mtenMap.get("noticeterm[]") != null) {
			if (mtenMap.get("noticeterm[]").getClass().equals(String.class)) {
				if (mtenMap.get("noticeterm[]") != null && !mtenMap.get("noticeterm[]").toString().equals("")) {
					mtenMap.put("NOTI_INV", mtenMap.get("noticeterm[]"));
				}
			} else {
				ArrayList NOTI_INV = mtenMap.get("noticeterm[]") == null ? new ArrayList():(ArrayList) mtenMap.get("noticeterm[]");
				for (int i = 0; i < NOTI_INV.size(); i++) {
					if (NOTI_INV.get(i) != null && !NOTI_INV.get(i).equals("")) {
						strTerm += NOTI_INV.get(i)+",";
					}
				}
				mtenMap.put("NOTI_INV", strTerm);
			}
		}
		
		if (UNCH_DATE_MNG_NO.equals("")) {
			commonDao.insert("suitSql.insertUnchDate", mtenMap);
		} else {
			commonDao.update("suitSql.updateUnchDate", mtenMap);
		}
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject unchDateDelete(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		commonDao.delete("suitSql.deleteUnchDate", mtenMap);
		
		result.put("msg", delMsg);
		return result;
	}
	
	public JSONArray selectCalData(Map<String, Object> mtenMap) {
		String GRPCD = mtenMap.get("GRPCD")==null?"":mtenMap.get("GRPCD").toString();
		String gbn = "";
		
		if (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("G") > -1) {
			gbn = "T";
		} else if (GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1 || 
				GRPCD.indexOf("B") > -1 || GRPCD.indexOf("D") > -1) {
			gbn = "S";
		} else if (GRPCD.indexOf("E") > -1) {
			gbn = "E";
		} else if (GRPCD.indexOf("J") > -1 || GRPCD.indexOf("M") > -1) {
			gbn = "C";
		} else if (GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N") > -1) {
			gbn = "A";
		} else if (GRPCD.indexOf("I") > -1) {
			gbn = "Z";
		} else if(GRPCD.indexOf("P") > -1) {
			gbn = "P";
		}
		mtenMap.put("gbn", gbn);
		
		List list = commonDao.selectList("suitSql.selectCalData", mtenMap);
		for (int i = 0; i < list.size(); i++) {
			HashMap rs = (HashMap) list.get(i);
			rs.put("_id", rs.get("DATE_MNG_NO"));
			rs.put("title", rs.get("DATE_TYPE_NM"));
			rs.put("start", rs.get("DATE_YMD"));
			rs.put("end", rs.get("DATE_YMD"));
			rs.put("allDay", "true");
			rs.put("description", "Lorem ipsum dolor sit incid idunt ut Lorem ipsum sit.");
			rs.put("backgroundColor", "#3F5FCE");
			rs.put("textColor", "white");
		}
		JSONArray jr = JSONArray.fromObject(list);
		return jr;
	}
	
	public List selectMainCalData(Map<String, Object> mtenMap) {
		//mtenMap.put("gbn", "S");
		String GRPCD = mtenMap.get("GRPCD")==null?"":mtenMap.get("GRPCD").toString();
		String gbn = "";
		
		if (GRPCD.indexOf("Y") > -1 || GRPCD.indexOf("G") > -1) {
			gbn = "T";
		} else if (GRPCD.indexOf("C") > -1 || GRPCD.indexOf("L") > -1 || 
				GRPCD.indexOf("B") > -1 || GRPCD.indexOf("D") > -1 || GRPCD.indexOf("F") > -1) {
			gbn = "S";
		} else if (GRPCD.indexOf("E") > -1) {
			gbn = "E";
		} else if (GRPCD.indexOf("J") > -1 || GRPCD.indexOf("M") > -1) {
			gbn = "C";
		} else if (GRPCD.indexOf("A") > -1 || GRPCD.indexOf("N") > -1) {
			gbn = "A";
		} else if (GRPCD.indexOf("I") > -1) {
			gbn = "Z";
		} else if(GRPCD.indexOf("P") > -1) {
			gbn = "P";
		}
		
		mtenMap.put("gbn", gbn);
		List list = commonDao.selectList("suitSql.selectCalData", mtenMap);
		return list;
	}
	
	public HashMap selectRelCaseList(Map<String, Object> mtenMap) {
		HashMap result = new HashMap();
		
		List list = commonDao.selectList("suitSql.selectRelCaseList", mtenMap);
		int total = commonDao.selectOne("suitSql.getrelCaseListTotal", mtenMap);
		result.put("list", list);
		result.put("total", total);
		return result;
	}
	
	public HashMap selectRelCase(Map<String, Object> mtenMap) {
		HashMap result = new HashMap();
		List list = commonDao.selectList("suitSql.selectRelCase", mtenMap);
		result.put("list", list);
		return result;
	}
	
	public JSONObject saveRelCase(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		HashMap param = new HashMap();
		
		commonDao.insert("insertRelCase", mtenMap);
		
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject deleteRelCase(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		commonDao.delete("suitSql.deleteRelCase", mtenMap);
		result.put("msg", delMsg);
		return result;
	}
	
	public String getCnt1() {
		return commonDao.select("suitSql.getSuitConsultCnt");
	}
	
	public String getCnt2(String userId) {
		return commonDao.select("suitSql.getPregressCnt", userId);
	}
	
	public String getCnt3() {
		Date now = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String formatedNow = formatter.format(now);
		
		HashMap map = new HashMap();
		map.put("start", formatedNow);
		map.put("end", formatedNow);
		map.put("gbn", "S");
		List calList = commonDao.selectList("suitSql.selectCalData", map);
		
		String calCnt = calList.size()+"";
		return calCnt;
	}
	
	public List selectMerCaseInfo(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectMerCaseInfo", mtenMap);
		return list;
	}
	
	public HashMap selectMerCaseList(Map<String, Object> mtenMap) {
		HashMap result = new HashMap();
		List list = commonDao.selectList("suitSql.selectMerCaseList", mtenMap);
		int total = commonDao.selectOne("suitSql.getCaseListTotal", mtenMap);
		result.put("list", list);
		result.put("total", total);
		return result;
	}

	public JSONObject comInfoSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = null;
		
		// 기존에 등록 된 위원회 List 삭제
		// commonDao.delete("suitSql.deleteComiUser");
		
		String[] useridList = mtenMap.get("comUserid").toString().trim().split(",");
		String[] usernmList = mtenMap.get("comUsernm").toString().trim().split(",");
		String[] sosokcdList = mtenMap.get("comSosokcd").toString().trim().split(",");
		String[] sosoknmList = mtenMap.get("comSosoknm").toString().trim().split(",");
		
		if(!useridList.equals("")){
			for(int i=0; i<useridList.length; i++){
				map = new HashMap<String, Object>();
				if(!usernmList[i].toString().equals("")){
					map.put("userid", useridList[i].toString());
					map.put("usernm", usernmList[i].toString());
					map.put("sosokcd", sosokcdList[i].toString());
					map.put("sosoknm", sosoknmList[i].toString());
					if("0".equals(useridList[i].toString())){
						map.put("outyn", "Y");
					}else{
						map.put("outyn", "N");
					}
					commonDao.insert("suitSql.insertComiUserInfo", map);
				}
			}
		}
		
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject delComiUser(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = null;
		
		commonDao.update("suitSql.delComiUser", mtenMap);
		
		result.put("msg", delMsg);
		return result;
	}
	
	public int getReviewRoleChk(Map<String, Object> mtenMap) {
		return commonDao.select("suitSql.getReviewRoleChk", mtenMap);
	}
	
	public JSONObject reviewInfoSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = null;
		String LWS_DLBR_MNG_NO = mtenMap.get("LWS_DLBR_MNG_NO")==null?"":mtenMap.get("LWS_DLBR_MNG_NO").toString();
		if(LWS_DLBR_MNG_NO.equals("")){
			// 신규 등록
			commonDao.insert("suitSql.insertReviewInfo", mtenMap);
			LWS_DLBR_MNG_NO = mtenMap.get("LWS_DLBR_MNG_NO").toString();
			// 기존에 구성되어있는 심의의원 List 저장
			List<Map<String, Object>> list = commonDao.selectList("suitSql.selectComiUserList", mtenMap);
			if(list.size() > 0){
				for(int i=0; i<list.size(); i++){
					map = new HashMap<String, Object>();
					map.put("userid", list.get(i).get("USER_ID").toString());
					map.put("usernm", list.get(i).get("USER_NM").toString());
					map.put("sosokcd", list.get(i).get("DEPT_CODE").toString());
					map.put("sosoknm", list.get(i).get("DEPT_NAME").toString());
					map.put("committeeid", list.get(i).get("COMMITTEEID").toString());
					map.put("LWS_DLBR_MNG_NO", LWS_DLBR_MNG_NO);
					map.put("opinionyn", "");
					map.put("opinion", "");
					commonDao.insert("suitSql.insertreviewComi", map);
				}
			}
			
		}else{
			// 수정
			commonDao.update("suitSql.updateReviewInfo", mtenMap);
			// 기존에 등록 된 심의 할 소송 삭제
			commonDao.delete("suitSql.deleteReviewCase", mtenMap);
			
			if(mtenMap.get("delfile[]")!=null){
				if(mtenMap.get("delfile[]").getClass().equals(String.class)){
					if(mtenMap.get("delfile[]") != null && !mtenMap.get("delfile[]").toString().equals("")){
						mtenMap.put("fileid", mtenMap.get("delfile[]"));
						commonDao.delete("deleteFileOne",mtenMap);
					}
				}else{
					ArrayList delfile = mtenMap.get("delfile[]")==null?new ArrayList():(ArrayList)mtenMap.get("delfile[]");
					for(int i=0; i<delfile.size(); i++){
						if(delfile.get(i) != null && !delfile.get(i).equals("")){
							mtenMap.put("fileid", delfile.get(i));
							commonDao.delete("deleteFileOne",mtenMap);
						}
					}
				}
			}
		}
		
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		if(!LWS_MNG_NO.equals("")){
			map = new HashMap<String, Object>();
			map.put("LWS_DLBR_MNG_NO", LWS_DLBR_MNG_NO);
			map.put("LWS_MNG_NO", LWS_MNG_NO);
			map.put("INST_MNG_NO", mtenMap.get("INST_MNG_NO").toString());
			commonDao.insert("suitSql.insertReviewCase", map);
		}
		
		result.put("LWS_DLBR_MNG_NO", LWS_DLBR_MNG_NO);
		result.put("msg", saveMsg);
		return result;
	}
	
	/*
	public HashMap selectSuitReviewDetail(Map<String, Object> mtenMap) {
		HashMap result = new HashMap();
		HashMap map = new HashMap<String, Object>();
		HashMap reviewInfo = commonDao.selectOne("suitSql.selectSuitReviewDetail", mtenMap);
		List commiteeList = commonDao.selectList("suitSql.selectreviewComiList", mtenMap);
		HashMap opinionCnt = commonDao.selectOne("suitSql.selectReviewOpinionCnt", mtenMap);
		
		map.put("oseq", mtenMap.get("LWS_DLBR_MNG_NO")==null?"":mtenMap.get("LWS_DLBR_MNG_NO").toString());
		map.put("tableid", "TB_LWS_DLBR");
		List fileList = commonDao.selectList("suitSql.selectFileList", map);
		
		result.put("reviewInfo", reviewInfo);
		result.put("commiteeList", commiteeList);
		result.put("opinionCnt", opinionCnt);
		result.put("fileList", fileList);
		return result;
	}
	*/
	
	public HashMap getSuitReviewDetail(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getSuitReviewDetail", mtenMap);
	}
	
	public List getSuitReviewComiList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectreviewComiList", mtenMap);
		return list;
	}
	
	public HashMap getReviewOpinionCnt(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getReviewOpinionCnt", mtenMap);
	}
	
	public JSONObject delReviewInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> param = null;
		
		String filepath = mtenMap.get("filepath").toString();
		String LWS_DLBR_MNG_NO = mtenMap.get("LWS_DLBR_MNG_NO")==null?"":mtenMap.get("LWS_DLBR_MNG_NO").toString();
		
		// review file 삭제
		param = new HashMap<String, Object>();
		param.put("TRGT_PST_MNG_NO", LWS_DLBR_MNG_NO);
		param.put("TRGT_PST_TBL_NM", "TB_LWS_DLBR");
		List<Map<String, Object>> list = commonDao.selectList("suitSql.selectFileList", param);
		
		for (int i = 0; i < list.size(); i++) {
			param = new HashMap<String, Object>();
			param.put("FILE_MNG_NO", list.get(i).get("FILE_MNG_NO").toString());
			param.put("filePath", filepath);
			fileDelete(param);
		}
		
		// 심의 소송건 삭제
		commonDao.delete("suitSql.deleteReviewCase", mtenMap);
		
		// 구성 된 심의위원 삭제
		commonDao.delete("suitSql.deleteReviewComi", mtenMap);
		
		// 심의 정보 삭제
		commonDao.delete("suitSql.deleteReviewInfo", mtenMap);
		
		result.put("msg", delMsg);
		
		return result;
	}
	
	// 소송심의위원회 관련
	public JSONObject selectComiUserList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectComiUserList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject selectReviewList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectReviewList", mtenMap);
		int cnt = commonDao.select("suitSql.selectReviewListCnt", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("total", cnt);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject selectreviewComiList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectreviewComiList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	public JSONObject selectEndComList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectEndComList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	public JSONObject reviewComiSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		
		String LWS_DLBR_MNG_NO = mtenMap.get("LWS_DLBR_MNG_NO")==null?"":mtenMap.get("LWS_DLBR_MNG_NO").toString();
		
		String savegbn = mtenMap.get("savegbn")==null?"":mtenMap.get("savegbn").toString();
		
		if("next".equals(savegbn)){
			// 상태값을 심의위원회구성 으로 변경
			mtenMap.put("PRGRS_STTS_NM", "심의위원회구성");
			commonDao.update("suitSql.updateReviewState", mtenMap);
		}
		// 기존에 구성 된 위원회 List 삭제
		map.put("LWS_DLBR_MNG_NO", LWS_DLBR_MNG_NO);
		commonDao.delete("suitSql.deleteReviewComi", map);
		
		String[] useridList = mtenMap.get("comUserid").toString().trim().split(",");
		String[] usernmList = mtenMap.get("comUsernm").toString().trim().split(",");
		String[] sosokcdList = mtenMap.get("comSosokcd").toString().trim().split(",");
		String[] sosoknmList = mtenMap.get("comSosoknm").toString().trim().split(",");
		String[] commidList = mtenMap.get("comCommid").toString().trim().split(",");
		
		if(!useridList.equals("")){
			for(int i=0; i<useridList.length; i++){
				map = new HashMap<String, Object>();
				map.put("userid", useridList[i].toString());
				map.put("usernm", usernmList[i].toString());
				map.put("sosokcd", sosokcdList[i].toString());
				map.put("sosoknm", sosoknmList[i].toString());
				map.put("committeeid", commidList[i].toString());
				map.put("LWS_DLBR_MNG_NO", LWS_DLBR_MNG_NO);
				map.put("opinionyn", "");
				map.put("opinion", "");
				commonDao.insert("suitSql.insertreviewComi", map);
			}
		}
		
		result.put("msg", saveMsg);
		return result;
	}

	public JSONObject suitReviewRequest(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		// 상태값을 심의요청중으로 변경
		commonDao.update("suitSql.updateReviewState", mtenMap);
		result.put("msg", saveMsg);
		return result;
	}

	public JSONObject suitOpinionSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		
		commonDao.update("suitSql.updateReviewComi", mtenMap);
		
		int endcnt = commonDao.selectOne("suitSql.SelectOpinionEndCnt", mtenMap);
		if(endcnt == 0){
			// 상태값을 심의완료로 변경
			mtenMap.put("PRGRS_STTS_NM", "심의완료");
			commonDao.update("suitSql.updateReviewState", mtenMap);
		}else{
			// 상태값을 심의중 으로 변경
			mtenMap.put("PRGRS_STTS_NM", "의결중");
			commonDao.update("suitSql.updateReviewState", mtenMap);
		}
		
		result.put("msg", saveMsg);
		return result;
	}

	public JSONObject reviewEndInfoSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		// endinfo update
		// state 완료 update
		//mtenMap.put("state", "심의완료결재중");
		commonDao.update("suitSql.updateReviewEndInfo", mtenMap);
		
		HashMap opinionCnt = commonDao.selectOne("suitSql.getReviewOpinionCnt", mtenMap);
		
		int ycnt = Integer.parseInt(opinionCnt.get("YCNT")==null?"0":opinionCnt.get("YCNT").toString());
		int ncnt = Integer.parseInt(opinionCnt.get("NCNT")==null?"0":opinionCnt.get("NCNT").toString());
		int icnt = Integer.parseInt(opinionCnt.get("ICNT")==null?"0":opinionCnt.get("ICNT").toString());
		String reviewyn = "";
		
		if(ycnt > ncnt){
			reviewyn = "소송 심의 가결";
		}else if(ycnt <= ncnt){
			reviewyn = "소송 심의 부결";
		}else if((ycnt+ncnt) < icnt){
			reviewyn = "소송 심의 보류";
		}
		
		mtenMap.put("reviewyn", reviewyn);
		// 심급정보에 소송 심의 정보 반영 (임시 조치)
		commonDao.update("suitSql.updateCaseReviewyn", mtenMap);
		
		result.put("msg", saveMsg);
		return result;
	}

	public JSONObject reviewContInfoSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		// endinfo update
		// state 완료 update
		mtenMap.put("PRGRS_STTS_NM", "의결중");
		commonDao.update("suitSql.updateReviewContInfo", mtenMap);
		
		result.put("msg", saveMsg);
		return result;
	}

	public JSONObject reviewStateChange(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		// endinfo update
		// state 완료 update
		commonDao.update("suitSql.reviewStateChange", mtenMap);
		
		result.put("msg", saveMsg);
		return result;
	}
	
	
	
	
	public JSONObject cOtp2(Map<String, Object> mtenMap, HttpServletRequest request) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		
		// lockyn 체크
		String lockyn = commonDao.selectOne("suitSql.checkUserLock", mtenMap);
		if("Y".equals(lockyn)){
			result.put("msg", "비밀번호 오류 횟수 초과로 계정이 잠겨있습니다.\n관리자에게 문의 바랍니다.");
		}else{
			HashMap user = commonDao.selectOne("suitSql.loginCheck1", mtenMap);
			if(user == null){
				int userCnt = commonDao.selectOne("suitSql.duchk", mtenMap);
				if(userCnt == 0){
					result.put("msg", "사용자 정보가 존재하지 않습니다.\n아이디를 확인하세요.");
				}else{
					commonDao.update("suitSql.updateLockCnt", mtenMap);
					int lockCnt = commonDao.selectOne("suitSql.getLockCnt", mtenMap);
					result.put("msg", "비밀번호가 잘못되었습니다.\n입력오류횟수("+lockCnt+"/5)");
					if(lockCnt == 5){
						commonDao.update("suitSql.updateUserLock", mtenMap);
						result.put("msg", "비밀번호 오류횟수 초과로 계정이 잠금처리 되었습니다.\n관리자에게 문의 바랍니다.");
					}
				}
				result.put("openyn", "N");
			}else{
				commonDao.update("suitSql.updateUserLockReset", mtenMap);
				result.put("openyn", "Y");
				
				GoogleOTP otp = new GoogleOTP();
				HashMap<String, String> map2 = otp.generate(mtenMap.get("LGN_ID").toString(), "test.seoul.co.kr");
				String OTP_NO = map2.get("encodedKey");
				String url = map2.get("url");
				result.put("OTP_NO", OTP_NO);
				
				mtenMap.put("OTP_NO", OTP_NO);
				commonDao.update("suitSql.setOtpKey", mtenMap);
				
				result.put("url", url);
			}
		}
		return result;
	}
	
	public JSONObject resetLwyrAcct(Map<String, Object> mtenMap, HttpServletRequest request) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		
		int lwyr = commonDao.selectOne("suitSql.getResetLwyrInfo", mtenMap);
		if(lwyr > 0) {
			String LWYR_MNG_NO = commonDao.selectOne("suitSql.getLwyrMngNo", mtenMap);
			// 리셋
			String AsstYn = mtenMap.get("ASST_YN")==null?"":mtenMap.get("ASST_YN").toString();
			String mblno = mtenMap.get("mblno")==null?"":mtenMap.get("mblno").toString();
			if("Y".equals(AsstYn)) {
				mtenMap.put("GRPCD", "Z");
			} else {
				mtenMap.put("GRPCD", "X");
			}
			
			mtenMap.put("LWYR_MNG_NO", LWYR_MNG_NO);
			mtenMap.put("LGN_PSWD", "seoul123!!!");
			commonDao.update("suitSql.passwordChg", mtenMap);
			result.put("msg", "비밀번호가 초기화 되었습니다. 초기 비밀번호로 다시 로그인하세요");
			result.put("suc", "Y");
			
			String title = "[서울시 법률지원소통창구] 비밀번호초기화 알림";
			String msg = "[서울시 법률지원소통창구] 시스템 로그인 비밀번호가 초기화 되었습니다. 초기 비밀번호는 seoul123!!! 입니다. 로그인 후 비밀번호를 변경하세요.";
			SMSClientSend.sendSMS(mblno, title, msg);
		} else {
			result.put("msg", "계정정보가 존재하지 않습니다. 입력내용을 다시 확인하세요.");
			result.put("suc", "X");
		}
		return result;
	}
	
	public JSONObject lawyerLoginChk(Map<String, Object> mtenMap, HttpServletRequest request) {
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		
		// lockyn 체크
		String lockyn = commonDao.selectOne("suitSql.checkUserLock", mtenMap);
		if("Y".equals(lockyn)){
			result.put("msg", "비밀번호 오류 횟수 초과로 계정이 잠겨있습니다.\n관리자에게 문의 바랍니다.");
		}else{
			HashMap user = commonDao.selectOne("suitSql.loginCheck1", mtenMap);
			if(user == null){
				int userCnt = commonDao.selectOne("suitSql.duchk", mtenMap);
				if(userCnt == 0){
					result.put("msg", "사용자 정보가 존재하지 않습니다.\n아이디를 확인하세요.");
				} else {
					commonDao.update("suitSql.updateLockCnt", mtenMap);
					int lockCnt = commonDao.selectOne("suitSql.getLockCnt", mtenMap);
					result.put("msg", "비밀번호가 잘못되었습니다.\n입력오류횟수("+lockCnt+"/5)");
					if(lockCnt == 5){
						commonDao.update("suitSql.updateUserLock", mtenMap);
						result.put("msg", "비밀번호 오류횟수 초과로 계정이 잠금처리 되었습니다.\n관리자에게 문의 바랍니다.");
					} else {
						result.put("msg", "서비스 접근 권한이 없습니다.\n관리자에게 문의 바랍니다.");
					}
				}
				result.put("openyn", "N");
			}else{
				//String OTP_NO = user.get("OTP_NO")==null?"":user.get("OTP_NO").toString();
				//if(OTP_NO.equals("")) {
				//	result.put("msg", "otp 정보가 생성 되지 않았습니다. otp 생성 후 이용하시기 바랍니다.");
				//	result.put("openyn", "N");
				//}else {
				//	GoogleOTP otp = new GoogleOTP();
				//	boolean check = otp.checkCode(mtenMap.get("otp")==null?"":mtenMap.get("otp").toString(), OTP_NO);
				//	if(check) {
						HttpSession sessionChk = request.getSession(true);
						SessionListener.getInstance().printloginUsers();
						sessionChk.setMaxInactiveInterval(7200);
						sessionChk.setAttribute("userInfo", user);
						SessionListener.getInstance().setSession(sessionChk, mtenMap.get("LGN_ID").toString());
						result.put("openyn", "Y");
						String pw = mtenMap.get("LGN_PSWD").toString();
						if (pw.equals("seoul123!!!")) {
							result.put("pwchg", "N");
						} else {
							result.put("pwchg", "Y");
						}
						
						result.put("msg", "로그인 되었습니다.");
				//	}else {
				//		result.put("msg", "otp 정보가 잘못되었습니다. 다시 확인해주시기바랍니다.");
				//		result.put("openyn", "N");
				//	}
				//}
			}
		}
		return result;
	}
	
	public HashMap getOutSuitCnt(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getOutSuitCnt", mtenMap);
	}
	

	public JSONObject selectOutSuitList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectOutSuitList", mtenMap);
		int cnt = commonDao.select("suitSql.selectOutSuitListCnt", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		result.put("total", cnt);
		return result;
	}
	
	
	
	public JSONObject selectCaseInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		String LWS_MNG_NO = mtenMap.get("LWS_MNG_NO")==null?"":mtenMap.get("LWS_MNG_NO").toString();
		String INST_MNG_NO = mtenMap.get("INST_MNG_NO")==null?"":mtenMap.get("INST_MNG_NO").toString();
		
		HashMap params = new HashMap();
		params.put("INST_MNG_NO", INST_MNG_NO);
		params.put("LWS_MNG_NO", LWS_MNG_NO);
		HashMap map = commonDao.selectOne("suitSql.selectCaseInfoBase", params);
		
		ResourceBundle bundle = ResourceBundle.getBundle("egovframework.property.url");
		String RELAY2 = bundle.getString("mten.RELAY2")==null?"":(String)bundle.getString("mten.RELAY2");
		
		String casenum = map.get("INCDNT_NO")==null?"":map.get("INCDNT_NO").toString();
		String[] casenum2 = casenum.split("@");
		
		
		/*
		 * s1 : 관할법원
		 * s2 : 사건번호 1
		 * s3 : 사건번호 2
		 * s4 : 사건번호 3
		 * s5 : 상대방이름
		 * http://10.250.3.34:9500/caseinfo/index.jsp
		 */
		
		URL url = null;
		URLConnection connection = null;
		InputStream is = null;
		InputStreamReader isr = null;
		BufferedReader br = null;
		
		String dateInfo = new String();
		try {
			url = new URL(RELAY2+"/index.jsp"); // URL 세팅
			connection = url.openConnection(); // 접속
			((HttpURLConnection) connection).setRequestMethod("POST");
			
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setUseCaches(false);
			
			OutputStreamWriter wr = new OutputStreamWriter(connection.getOutputStream());
			
			String param = URLEncoder.encode("s1") + "=" + URLEncoder.encode(map.get("CT_NM").toString(), "utf-8")
				+ "&" + URLEncoder.encode("s2") + "=" + URLEncoder.encode(casenum2[0],"utf-8")
				+ "&" + URLEncoder.encode("s3") + "=" + URLEncoder.encode(casenum2[1],"utf-8")
				+ "&" + URLEncoder.encode("s4") + "=" + URLEncoder.encode(casenum2[2],"utf-8")
				+ "&" + URLEncoder.encode("s5") + "=" + URLEncoder.encode(map.get("LWS_CNCPR_NM").toString(),"utf-8");
			
			wr.write(param);
			wr.flush();
			
			is = connection.getInputStream(); // inputStream 이용
			isr = new InputStreamReader(is,"utf-8");
			br = new BufferedReader(isr);
			String buf = null;
			
			while (true) { // 무한반복
				buf = br.readLine(); // 화면에 있는 내용을 \n단위로 읽어온다
				
				if (buf == null) { // null일 경우 화면이 끝난 경우이므로
					break; // 반복문 끝
				} else {
					//System.out.println(buf);
					dateInfo += buf;
				}
			}
			System.out.println("=======================================================");
			System.out.println("=======================================================");
			System.out.println("=======================================================");
			System.out.println("suitServiceImpl selectCaseInfo >>>>>>>>>>>>>>>>>>>>>>>");
			
			System.out.println(dateInfo);
			System.out.println(dateInfo.indexOf("NO"));
			
			System.out.println("=======================================================");
			System.out.println("=======================================================");
			
			if(dateInfo.indexOf("NO") > -1) {
				result.put("msg", "no");
			} else {
				JSONParser parser = new JSONParser();
				result.put("result", dateInfo);
			}
			
			wr.close();
			is.close();
			isr.close();
			br.close();
		} catch (MalformedURLException mue) {
			System.out.println("대법원연계 실패!!");
		} catch (IOException ioe) {
			System.out.println("대법원연계 실패!!");
		}
		
		JSONObject getOb = (JSONObject) result.get("result");
		
		System.out.println("getOb.size() >>>>>>>>>>>>>>>");
		System.out.println(getOb);
		
		String getMsg = "";
		if (getOb != null && getOb.size() > 0) {
			getMsg = getOb.get("msg")==null?"":getOb.get("msg").toString();
			System.out.println(getMsg);
		}
		
		if("사건이 존재하지 않습니다.".equals(getMsg) || dateInfo.indexOf("NO") > -1) {
			result.put("msg", "no");
		} else {
			JSONArray arr = (JSONArray) getOb.get("data");
			
			System.out.println("getDateArrCnt ===========> " + arr.size());
			System.out.println("getDateArrCnt ===========> " + arr.size());
			System.out.println("getDateArrCnt ===========> " + arr.size());
			
			String msg = "";
			int newDate = 0;
			int upDate = 0;
			int newDoc = 0;
			int upDoc = 0;
			
			// 해당 사건의 기일, 문서 정보 제일 마지막 날짜 구해와서, 해당 날짜보다 뒤에 날짜 데이터만 insert처리
			// 날짜 비교는 부호 제거 후 숫자끼리만 비교 할 것
			HashMap param = new HashMap();
			for (int i=0; i<arr.size(); i++) {
				param = new HashMap();
				JSONObject dateInfoMap = (JSONObject) arr.get(i);
				
				String scont = dateInfoMap.get("scont")==null?"":dateInfoMap.get("scont").toString();
				scont = scont.trim();
				
				String sresult = dateInfoMap.get("sresult")==null?"":dateInfoMap.get("sresult").toString();
				sresult = sresult.trim();
				
				String sdt = dateInfoMap.get("sdate")==null?"":dateInfoMap.get("sdate").toString();
				sdt = sdt.replace(" ", "").replace(".", "-");
				
				String gbn = dateInfoMap.get("sgbn")==null?"":dateInfoMap.get("sgbn").toString();
				
				String matchcont = sdt+scont;
				
				// 테스트용 데이터
				//String scont = " 신청서접수";
				//String sresult = "";
				//String sdt = " 2019.10.02";
				//String gbn = "기일";
				//String matchcont = "2019-10-02신청서접수";
				
				if ("기일".equals(gbn)) {
					// 기일정보 insert
					String[] scontArr = scont.split("\\(");
					String sdatenm = scontArr[0];
					sdatenm = sdatenm.replace(" ", "");
					
					String [] reformData1 = scontArr[1].split("\\)");
					String [] testString = reformData1[0].split(" ");
					String place = "";
					String time = "";
					for(int zz=0; zz<testString.length; zz++) {
						String zzText = testString[zz].replaceAll(" ", "");
						if (!zzText.equals(sdatenm) ) {
							if (zzText.indexOf(":") > -1) {
								time = zzText.replaceAll(":", "").replaceAll(" ", "");
							} else {
								place += zzText + " ";
							}
						}
					}
					
					param.put("LWS_MNG_NO", LWS_MNG_NO);
					param.put("INST_MNG_NO", INST_MNG_NO);
					param.put("DATE_INSP_CN", matchcont);
					
					if (sdatenm.indexOf("준비") > -1) {
						sdatenm = "준비";
					} else if (sdatenm.indexOf("조정") > -1) {
						sdatenm = "조정";
					} else if (sdatenm.indexOf("변론") > -1) {
						sdatenm = "변론";
					} else if (sdatenm.indexOf("선고") > -1) {
						sdatenm = "선고";
					} else {
						sdatenm = sdatenm.substring(0, 2);
					}
					
					param.put("DATE_TYPE_NM", sdatenm);
					param.put("DATE_PLC_NM", place);
					param.put("DATE_TM", time);
					param.put("DATE_YMD", sdt);
					param.put("DATE_CN", scont);
					param.put("DATE_RSLT_CN", sresult);
					
					HashMap getDateInfo = commonDao.selectOne("suitSql.getMatchedDate", param);
					
					if(getDateInfo == null) {
						// INSERT 처리
						System.out.println("%%%%%%%%%%%%%%%% INSERT DATE %%%%%%%%%%%%%%%%");
						commonDao.insert("suitSql.insertCaseInfoDateData", param);
						
						newDate = newDate+1;
					} else {
						String DATE_MNG_NO = getDateInfo.get("DATE_MNG_NO")==null?"":getDateInfo.get("DATE_MNG_NO").toString();
						String DATE_RSLT_CN = getDateInfo.get("DATE_RSLT_CN")==null?"":getDateInfo.get("DATE_RSLT_CN").toString();
						if(DATE_MNG_NO != null && DATE_MNG_NO != "" && !sresult.equals(DATE_RSLT_CN)) {
							System.out.println("%%%%%%%%%%%%%%%% UPDATE DATE %%%%%%%%%%%%%%%%");
							// UPDATE 처리
							param.put("DATE_MNG_NO", DATE_MNG_NO);
							commonDao.update("suitSql.updateCaseInfoDateData", param);
							
							upDate = upDate+1;
						}
					}
				} else {
					// 문서정보 insert
					param.put("LWS_MNG_NO", LWS_MNG_NO);
					param.put("INST_MNG_NO", INST_MNG_NO);
					param.put("DOC_INSP_CN", matchcont);
					param.put("DOC_YMD", sdt);
					param.put("DOC_CN", scont);
					param.put("DOC_RSLT_CN", sresult);
					
					HashMap getDocInfo = commonDao.selectOne("suitSql.getMatchedDoc", param);
					
					if(getDocInfo == null) {
						// INSERT 처리
						System.out.println("%%%%%%%%%%%%%%%% INSERT DOC %%%%%%%%%%%%%%%%");
						commonDao.insert("suitSql.insertCaseInfoDocData", param);
						newDoc = newDoc+1;
					} else {
						String DOC_MNG_NO = getDocInfo.get("DOC_MNG_NO")==null?"":getDocInfo.get("DOC_MNG_NO").toString();
						String DOC_RSLT_CN = getDocInfo.get("DOC_RSLT_CN")==null?"":getDocInfo.get("DOC_RSLT_CN").toString();
						if(DOC_MNG_NO != null && DOC_MNG_NO != "" && !sresult.equals(DOC_RSLT_CN)) {
							System.out.println("%%%%%%%%%%%%%%%% UPDATE DOC %%%%%%%%%%%%%%%%");
							// UPDATE 처리
							param.put("DOC_MNG_NO", DOC_MNG_NO);
							commonDao.update("suitSql.updateCaseInfoDocData", param);
							
							upDoc = upDoc+1;
						}
					}
				}
			}
			
			msg = "대법원 데이터 수신이 종료되었습니다.\n신규 기일정보:"+newDate+"건\n수정 기일정보:"+upDate+"\n신규 제출송달:"+newDoc+"\n수정 제출송달:"+upDoc;
			
			result.put("msg", msg);
		}
		return result;
	}
	
	public JSONObject selectProgList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectProgList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public HashMap getDocMakeInfo1(Map<String, Object> mtenMap) {
		//소송사무보고(통보)
		return commonDao.select("suitSql.getDocMakeInfo1", mtenMap);
	}
	
	public HashMap getDocMakeInfo2(Map<String, Object> mtenMap) {
		//소송진행상황보고
		return commonDao.select("suitSql.getDocMakeInfo2", mtenMap);
	}
	
	public HashMap getDocMakeInfo3(Map<String, Object> mtenMap) {
		//소송진행상황보고
		return commonDao.select("suitSql.getDocMakeInfo3", mtenMap);
	}
	
	public List getDocMakeInfo3_1(Map<String, Object> mtenMap) {
		//소송사무보고(통보)
		return commonDao.selectList("suitSql.getDocMakeInfo3_1", mtenMap);
	}

	public JSONObject rfslRsnSave(Map<String, Object> mtenMap) {
		commonDao.update("suitSql.setRfslRsn", mtenMap);
		
		// 담당자 알림 전송 (문자 or 매신저 or 메일)
		return null;
	}
	
	
	public JSONObject getSuitTypeInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List<String> typeList = new ArrayList<String>();
		typeList.add("CASECD");
		typeList.add("LWSTYPECD");
		typeList.add("JDGMTGBN");
		mtenMap.put("typeList", typeList);
		
		List list = commonDao.selectList("suitSql.getCodeList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	public JSONObject getProgListSch(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.getProgList", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}
	
	
	public HashMap getLeftDateMain(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getLeftDate", mtenMap);
	}

	public JSONObject getLeftDate(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		result.put("result", commonDao.selectOne("suitSql.getLeftDate", mtenMap));
		return result;
	}

	public String getPwChg(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getPwChg", mtenMap);
	}
	
	public String getMainLwsTkcgCnt() {
		return commonDao.select("suitSql.getMainLwsTkcgCnt");
	}
	public String getMainLwsCstCnt() {
		return commonDao.select("suitSql.getMainLwsCstCnt");
	}
	
	public List selectMainLwsTkcgList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectMainLwsTkcgList", mtenMap);
		return list;
	}
	
	public List selectMainLwsCstList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectMainLwsCstList", mtenMap);
		return list;
	}
	
	public HashMap getMainYCnt2() {
		return commonDao.select("suitSql.getMainYCnt2");
	}
	
	public List selectConAgreeMainList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectConAgreeMainList", mtenMap);
		return list;
	}
	public String selectMainLawfirmEndInfoCnt() {
		return commonDao.select("suitSql.selectMainLawfirmEndInfoCnt");
	}
	public String selectMainLawyerCnt() {
		return commonDao.select("suitSql.selectMainLawyerCnt");
	}
	public List selectMainLawfirmEndInfoList(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectMainLawfirmEndInfoList", mtenMap);
		return list;
	}
	
	public String selectMainSuitTrmnYnCnt(String userId) {
		return commonDao.select("suitSql.selectMainSuitTrmnYnCnt", userId);
	}
	
	public List selectSuitMainList2(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectSuitMainList2", mtenMap);
		return list;
	}
	
	public int getMainCalDataCnt(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getMainDateCnt", mtenMap);
	}
	
	public void updateBondBuga(Map<String, Object> mtenMap) {
		commonDao.update("suitSql.updateBondBuga", mtenMap);
	}
	
	public JSONObject selectRoleInfo(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		List list = commonDao.selectList("suitSql.selectRoleInfo", mtenMap);
		JSONArray jr = JSONArray.fromObject(list);
		result.put("result", jr);
		return result;
	}

	public JSONObject roleInfoSave(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		Map map = new HashMap<String, Object>();
		
		String DOC_MNG_NO  = mtenMap.get("DOC_MNG_NO").toString();
		String DOC_SE      = mtenMap.get("DOC_SE").toString();
		String WRTR_EMP_NO = mtenMap.get("WRTR_EMP_NO").toString();
		String WRTR_EMP_NM = mtenMap.get("WRTR_EMP_NM").toString();
		String chkdepts    = mtenMap.get("chkDept").toString();
		String chkusers    = mtenMap.get("chkUser").toString();
		
		String[] chkdeptArr = chkdepts.split(",");
		String[] chkuserArr = chkusers.split(",");
		
		// 기존에 부여 된 권한 삭제
		commonDao.delete("suitSql.deleteRole", mtenMap);
		
		// 체크 된 부서 권한 부여
		for (int i = 0; i < chkdeptArr.length; i++) {
			if (!"".equals(chkdeptArr[i])) {
				map = new HashMap<String, Object>();
				map.put("DOC_MNG_NO", DOC_MNG_NO);
				map.put("DOC_SE", DOC_SE);
				map.put("AUTHRT_SE", "D");
				map.put("AUTHRT_EMP_NO", "");
				map.put("AUTHRT_DEPT_NO", chkdeptArr[i]);
				map.put("WRTR_EMP_NO", WRTR_EMP_NO);
				map.put("WRTR_EMP_NM", WRTR_EMP_NM);
				commonDao.insert("suitSql.insertRole", map);
			}
		}
		
		// 체크 된 사용자 권한 부여
		for (int u = 0; u < chkuserArr.length; u++) {
			if (!"".equals(chkuserArr[u])) {
				map = new HashMap<String, Object>();
				map.put("DOC_MNG_NO", DOC_MNG_NO);
				map.put("DOC_SE", DOC_SE);
				map.put("AUTHRT_SE", "P");
				map.put("AUTHRT_EMP_NO", chkuserArr[u]);
				map.put("AUTHRT_DEPT_NO", "");
				map.put("WRTR_EMP_NO", WRTR_EMP_NO);
				map.put("WRTR_EMP_NM", WRTR_EMP_NM);
				commonDao.insert("suitSql.insertRole", map);
			}
		}
		result.put("msg", saveMsg);
		return result;
	}

	public List selectSuitChrgCost(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectSuitChrgCost", mtenMap);
		return list;
	}
	
	public List selectSuitTotalCost(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.selectSuitTotalCost", mtenMap);
		return list;
	}

	public void setDocFileModiDate(Map<String, Object> mtenMap) {
		commonDao.update("suitSql.setDocFileModiDate", mtenMap);
	}

	public List getChrgEmpInfo4(Map<String, Object> mtenMap) {
		List list = commonDao.selectList("suitSql.getChrgEmpInfo4", mtenMap);
		return list;
	}
	
	public String getOutRcptYn(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getOutRcptYn", mtenMap);
	}

	public String getCostTargetOne(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.getCostTargetOne", mtenMap);
	}
	
	public JSONObject setOutCostState(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		// APRV_YN
		// N : 등록 O, 신청 X -> APRV_YN G로 / GIVE_APLY_YMD SYSDATE로
		// G : 등록 O, 신청 O
		// R : 보완필요
		// T : 보완후 재신청
		// Y : 승인완료
		
		commonDao.update("suitSql.setOutCostState", mtenMap);
		result.put("msg", saveMsg);
		return result;
	}
	
	public JSONObject updateCostAmtList(Map<String, Object> mtenMap) {
		JSONObject result = new JSONObject();
		
		String APRV_YN  = mtenMap.get("APRV_YN")==null?"":mtenMap.get("APRV_YN").toString();
		String GIVE_YN  = mtenMap.get("GIVE_YN")==null?"":mtenMap.get("GIVE_YN").toString();
		String GIVE_YMD = mtenMap.get("GIVE_YMD")==null?"":mtenMap.get("GIVE_YMD").toString();
		
		List LWS_MNG_NO_LIST  = new ArrayList();
		List INST_MNG_NO_LIST = new ArrayList();
		List CST_MNG_NO_LIST  = new ArrayList();
		
		if (mtenMap.get("LWS_MNG_NO_LIST[]") != null) {
			if (mtenMap.get("LWS_MNG_NO_LIST[]").getClass().equals(String.class)) {
				if (mtenMap.get("LWS_MNG_NO_LIST[]") != null && !mtenMap.get("LWS_MNG_NO_LIST[]").toString().equals("")) {
					LWS_MNG_NO_LIST.add(mtenMap.get("LWS_MNG_NO_LIST[]"));
					INST_MNG_NO_LIST.add(mtenMap.get("INST_MNG_NO_LIST[]"));
					CST_MNG_NO_LIST.add(mtenMap.get("CST_MNG_NO_LIST[]"));
				}
			} else {
				LWS_MNG_NO_LIST  = mtenMap.get("LWS_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("LWS_MNG_NO_LIST[]");
				INST_MNG_NO_LIST = mtenMap.get("INST_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("INST_MNG_NO_LIST[]");
				CST_MNG_NO_LIST  = mtenMap.get("CST_MNG_NO_LIST[]")==null?new ArrayList():(ArrayList)mtenMap.get("CST_MNG_NO_LIST[]");
			}
		}
		
		HashMap costMap = new HashMap();
		for(int c=0; c<LWS_MNG_NO_LIST.size(); c++) {
			String LWS_MNG_NO  = LWS_MNG_NO_LIST.get(c).toString();
			String INST_MNG_NO = INST_MNG_NO_LIST.get(c).toString();
			String CST_MNG_NO  = CST_MNG_NO_LIST.get(c).toString();
			
			costMap = new HashMap();
			costMap.put("LWS_MNG_NO",  LWS_MNG_NO);
			costMap.put("INST_MNG_NO", INST_MNG_NO);
			costMap.put("CST_MNG_NO",  CST_MNG_NO);
			costMap.put("WRTR_EMP_NM", mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString());
			costMap.put("WRTR_EMP_NO", mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString());
			costMap.put("WRT_DEPT_NM", mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString());
			costMap.put("WRT_DEPT_NO", mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString());
			
			costMap.put("APRV_YN",  APRV_YN);
			costMap.put("GIVE_YN",  GIVE_YN);
			costMap.put("GIVE_YMD", GIVE_YMD);
			
			commonDao.update("suitSql.setOutCostState", costMap);
			
			if (GIVE_YN.equals("")) {
				if ("Y".equals(APRV_YN)) {
					// 나의할일 추가
					//List taskEmpList = commonDao.selectList("suitSql.getChrgEmpInfo2", costMap);
					//HashMap taskMap = new HashMap();
					//for(int i=0; i<taskEmpList.size(); i++) {
					//	HashMap listMap = (HashMap)taskEmpList.get(i);
					//	taskMap = new HashMap();
					//	taskMap.put("EMP_NO", listMap.get("EMP_NO")==null?"":listMap.get("EMP_NO").toString());
					//	taskMap.put("TASK_SE", "S1");
					//	taskMap.put("DOC_MNG_NO", CST_MNG_NO);
					//	taskMap.put("PRCS_YN", "N");
					//	mifService.setTask(taskMap);
					//}
					//
					//// 지급 담당자에게 메일 발송
					//HashMap caseInfo = commonDao.selectOne("suitSql.getCaseDetail", costMap);
					//
					//costMap.put("ROLE", "E");
					//List giveEmpList = commonDao.selectList("suitSql.getChrgEmpInfo3", costMap);
					//
					//HashMap lawAmt = commonDao.select("suitSql.getChrgLawyerDetail", costMap);
					//
					//if(giveEmpList.size() > 0) {
					//	ArrayList<String> sendUserList = new ArrayList();
					//	String LWS_NO = "";
					//	String INCDNT_NO = "";
					//	String EMPNM = "";
					//	
					//	for(int i=0; i<giveEmpList.size(); i++){
					//		HashMap info = (HashMap)giveEmpList.get(i);
					//		LWS_NO    = info.get("LWS_NO")==null?"":info.get("LWS_NO").toString();
					//		INCDNT_NO = info.get("INCDNT_NO")==null?"":info.get("INCDNT_NO").toString();
					//		EMPNM     = info.get("EMPNM")==null?"":info.get("EMPNM").toString();
					//		
					//		sendUserList.add(info.get("EMP_PK_NO")==null?"":info.get("EMP_PK_NO").toString());
					//	}
					//	
					//	String OTST_AMT    = lawAmt.get("OTST_AMT")==null?"":lawAmt.get("OTST_AMT").toString();
					//	String SCS_PAY_AMT = lawAmt.get("SCS_PAY_AMT")==null?"":lawAmt.get("SCS_PAY_AMT").toString();
					//	String ACAP_AMT    = lawAmt.get("ACAP_AMT")==null?"":lawAmt.get("ACAP_AMT").toString();
					//	
					//	
					//	String title = "[법률지원통합시스템] "+LWS_NO+" "+INCDNT_NO+" 사건의 소송비용지급요청건에 대해 "+EMPNM+"가 승인하였습니다.";
					//	String cont = "";
					//	cont = cont + "아래 사건에 대한 소송비용 지급 요청에 대해 "+EMPNM+"가 승인하였습니다.<br/>";
					//	cont = cont + "<br/>";
					//	cont = cont + "관리번호: "+LWS_NO+"<br/>";
					//	cont = cont + "사건번호: "+INCDNT_NO+"<br/>";
					//	
					//	cont = cont + "착수금 : "+OTST_AMT+"<br/>";
					//	cont = cont + "성공보수 : "+SCS_PAY_AMT+"<br/>";
					//	cont = cont + "수임료 : "+ACAP_AMT;
					//	SendMail mail = new SendMail();
					//	mail.sendMail(title, cont, sendUserList, null, "");
					//}
				}
			} else if ("Y".equals(GIVE_YN)) {
				// 변호사에게 알림 발송
				//String mobileNo = commonDao.selectOne("suitSql.sendLawyerInfo", costMap);
				//HashMap caseInfo = commonDao.selectOne("suitSql.getCaseDetail", costMap);
				//if(!mobileNo.equals("")) {
				//	String title = "[서울시 법률지원소통창구] "+caseInfo.get("INCDNT_NO")==null?"":caseInfo.get("INCDNT_NO").toString()+"비용지급완료";
				//	String msg = "[서울시 법률지원소통창구] "+caseInfo.get("INCDNT_NO")==null?"":caseInfo.get("INCDNT_NO").toString()+" 비용지급요청건에 대해 지급이 완료되었습니다.";
				//	SMSClientSend.sendSMS(mobileNo, title, msg);
				//}
				//
				//// 나의 할 일 제거
				//List taskEmpList = commonDao.selectList("suitSql.getChrgEmpInfo2", costMap);
				//HashMap taskMap = new HashMap();
				//for(int i=0; i<taskEmpList.size(); i++) {
				//	HashMap listMap = (HashMap)taskEmpList.get(i);
				//	taskMap = new HashMap();
				//	taskMap.put("EMP_NO", listMap.get("EMP_NO")==null?"":listMap.get("EMP_NO").toString());
				//	taskMap.put("TASK_SE", "S1");
				//	taskMap.put("DOC_MNG_NO", AGT_MNG_NO);
				//	taskMap.put("PRCS_YN", "Y");
				//	mifService.setTask(taskMap);
				//}
			}
		}
		
		result.put("msg", saveMsg);
		return result;
	}

	public List getDateList(Map<String, Object> mtenMap) {
		return commonDao.selectList("suitSql.getDateList", mtenMap);
	}

	public List selectBondMain1(Map<String, Object> mtenMap) {
		return commonDao.selectList("suitSql.selectBondMain1", mtenMap);
	}

	public List selectBondMain2(Map<String, Object> mtenMap) {
		return commonDao.selectList("suitSql.selectBondMain2", mtenMap);
	}
	
	
	public int selectSuitRoleChk(Map<String, Object> mtenMap) {
		return commonDao.selectOne("suitSql.selectSuitRoleChk", mtenMap);
	}
}
