package com.mten.bylaw.approve.service;

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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
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

import com.mten.dao.CommonDao;
import com.mten.util.DateUtil;
import com.mten.util.MakeHan;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("approveService")
public class ApproveServiceImpl implements ApproveService {
	protected final static Logger logger = Logger.getLogger( ApproveServiceImpl.class );
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	public JSONObject approveSave(Map<String, Object> mtenMap) {
		
		String ATRZ_SE_NM = mtenMap.get("ATRZ_SE_NM")==null?"":mtenMap.get("ATRZ_SE_NM").toString();
		String ATRZ_DMND_PST_MNG_NO = mtenMap.get("ATRZ_DMND_PST_MNG_NO")==null?"":mtenMap.get("ATRZ_DMND_PST_MNG_NO").toString();
		
		String ATRZ_DMND_EMP_NO = mtenMap.get("WRTR_EMP_NO")==null?"":mtenMap.get("WRTR_EMP_NO").toString();
		String ATRZ_DMND_EMP_NM = mtenMap.get("WRTR_EMP_NM")==null?"":mtenMap.get("WRTR_EMP_NM").toString();
		String ATRZ_DMND_DEPT_NO = mtenMap.get("WRT_DEPT_NO")==null?"":mtenMap.get("WRT_DEPT_NO").toString();
		String ATRZ_DMND_DEPT_NM = mtenMap.get("WRT_DEPT_NM")==null?"":mtenMap.get("WRT_DEPT_NM").toString();
		ArrayList signerid = new ArrayList();
		ArrayList signer = new ArrayList();
		ArrayList gdeptid = new ArrayList();
		ArrayList gdept = new ArrayList();
		
		if(mtenMap.get("signerid").getClass().equals(String.class)) {
			signerid.add(mtenMap.get("signerid")==null?"":mtenMap.get("signerid").toString());
			signer.add(mtenMap.get("signer")==null?"":mtenMap.get("signer").toString());
			gdeptid.add(mtenMap.get("gdeptid")==null?"":mtenMap.get("gdeptid").toString());
			gdept.add(mtenMap.get("gdept")==null?"":mtenMap.get("gdept").toString());
		}
		if(mtenMap.get("signerid").getClass().equals(ArrayList.class)) {
			signerid = mtenMap.get("signerid")==null?new ArrayList():(ArrayList)mtenMap.get("signerid");
			signer = mtenMap.get("signer")==null?new ArrayList():(ArrayList)mtenMap.get("signer");
			gdeptid = mtenMap.get("gdeptid")==null?new ArrayList():(ArrayList)mtenMap.get("gdeptid");
			gdept = mtenMap.get("gdept")==null?new ArrayList():(ArrayList)mtenMap.get("gdept");
		}
		
		
		//결재라인정보 처리 시작
		mtenMap.put("APRVR_NO", ATRZ_DMND_EMP_NO);
		mtenMap.put("APRVR_NM", ATRZ_DMND_EMP_NM);
		mtenMap.put("ATRZ_DMND_EMP_NO", ATRZ_DMND_EMP_NO);
		mtenMap.put("ATRZ_DMND_EMP_NM", ATRZ_DMND_EMP_NM);
		mtenMap.put("ATRZ_SEQ", 0);
		commonDao.insert("insertTB_COM_INF_APLN",mtenMap);
		mtenMap.put("APLN_NO", mtenMap.get("APLN_MNG_NO"));
		int k=1;
		String currentuser = "";
		String currentuserid = "";
		for(int i=signer.size()-1; i>=0; i--) {
			mtenMap.put("APRVR_NO", signerid.get(i));
			mtenMap.put("APRVR_NM", signer.get(i));
			mtenMap.put("ATRZ_SEQ", k);
			commonDao.insert("insertTB_COM_INF_APLN",mtenMap);
			if(k==1) {
				//결재정보 처리 시작
				mtenMap.put("ATRZ_DMND_DEPT_NO", ATRZ_DMND_DEPT_NO);
				mtenMap.put("ATRZ_DMND_DEPT_NM", ATRZ_DMND_DEPT_NM);
				commonDao.insert("insertTB_COM_INF_ATRZ_INFO",mtenMap);
				//결재정보 처리 끝

			}
			k++;
		}
		//결재라인정보 처리 끝
		
		
		//결재자정보 처리 시작
		mtenMap.put("APRVR_NO", ATRZ_DMND_EMP_NO);
		mtenMap.put("APRVR_NM", ATRZ_DMND_EMP_NM);
		mtenMap.put("APRVR_DEPT_NO", ATRZ_DMND_EMP_NO);
		mtenMap.put("APRVR_DEPT_NM", ATRZ_DMND_EMP_NM);
		mtenMap.put("ATRZ_YN", "Y");
		mtenMap.put("ATRZ_SEQ", 0);
		commonDao.insert("insertTB_COM_INF_ATRZ_STTS",mtenMap);
		k=1;
		for(int i=signer.size()-1; i>=0; i--) {
			mtenMap.put("APRVR_NO", signerid.get(i));
			mtenMap.put("APRVR_NM", signer.get(i));
			mtenMap.put("APRVR_DEPT_NO", gdeptid.get(i));
			mtenMap.put("APRVR_DEPT_NM", gdept.get(i));
			mtenMap.put("ATRZ_YN", "N");
			mtenMap.put("ATRZ_SEQ", k);
			commonDao.insert("insertTB_COM_INF_ATRZ_STTS",mtenMap);
			k++;
		}
		//결재자정보 처리 끝
		
		//상신후 결재중으로 문서 상태 변경
		if(ATRZ_SE_NM.equals("CONSULT")){	//자문처리
			//TB_CNSTN_MNG
			//PRGRS_STTS_SE_NM
			//결재중
			mtenMap.put("consultno", ATRZ_DMND_PST_MNG_NO);
			mtenMap.put("STATE", "결재중");
			commonDao.update("setTableSate",mtenMap);
		}else if(ATRZ_SE_NM.equals("AGREE")){	//협약처리
			mtenMap.put("CVTN_MNG_NO", ATRZ_DMND_PST_MNG_NO);
			mtenMap.put("PRGRS_STTS_SE_NM", "결재중");
			commonDao.update("agreeSql.updateAgreeState", mtenMap);
		}
		
		// 첫번째 결재자에게 알림 발송
		
		
		JSONObject docinfo = JSONObject.fromObject(mtenMap);
		return docinfo;
	}
	
	public JSONObject approveLineSend(Map<String, Object> mtenMap) {
		List alist = commonDao.selectList("selectTB_COM_INF_APLN",mtenMap);
		JSONArray jr = JSONArray.fromObject(alist);
		JSONObject result = new JSONObject();
		result.put("result", jr);
		return result;
	}
	
	public JSONObject setGianForm(Map<String, Object> mtenMap) {
		List alist = commonDao.selectList("setGianForm",mtenMap);
		JSONArray jr = JSONArray.fromObject(alist);
		JSONObject result = new JSONObject();
		result.put("result", jr);
		return result;
	}
	
	public JSONObject chgState(Map<String, Object> mtenMap, HttpServletRequest request) {
		HttpSession session = request.getSession(true);
		HashMap se = (HashMap)session.getAttribute("userInfo"); 
		String writerid = se.get("USERID")==null?"":se.get("USERID").toString();
		String writer = se.get("USERNAME")==null?"":se.get("USERNAME").toString();
		
		String ATRZ_SE_NM = mtenMap.get("ATRZ_SE_NM")==null?"":mtenMap.get("ATRZ_SE_NM").toString();
		String ATRZ_DMND_PST_MNG_NO = mtenMap.get("ATRZ_DMND_PST_MNG_NO")==null?"":mtenMap.get("ATRZ_DMND_PST_MNG_NO").toString();
		String GSTATE = mtenMap.get("GSTATE")==null?"":mtenMap.get("GSTATE").toString();
		
		mtenMap.put("APRVR_NM", writer);
		mtenMap.put("APRVR_NO", writerid);
		
		if(GSTATE.equals("R")) {	//회수처리
			mtenMap.put("ATRZ_STTS_NM", "회수");
			mtenMap.put("ATRZ_CMPTN_YN", "Y");
			commonDao.update("updateTB_COM_INF_ATRZ_INFO",mtenMap);
			
			mtenMap.put("ATRZ_YN", "R");
			commonDao.update("updateTB_COM_INF_ATRZ_STTS",mtenMap);
			
			if(ATRZ_SE_NM.equals("CONSULT")){	//자문처리
				mtenMap.put("consultid", ATRZ_DMND_PST_MNG_NO);
				mtenMap.put("statcd", "답변중");
				commonDao.update("consultSql.updateConsultState",mtenMap);
			}else if(ATRZ_SE_NM.equals("AGREE")){	//협약처리
				mtenMap.put("CVTN_MNG_NO", ATRZ_DMND_PST_MNG_NO);
				mtenMap.put("PRGRS_STTS_SE_NM", "답변중");
				commonDao.update("agreeSql.updateAgreeState", mtenMap);
			}
		}
		
		if(GSTATE.equals("N")) {	//반려처리
			mtenMap.put("ATRZ_STTS_NM", "반려");
			mtenMap.put("ATRZ_CMPTN_YN", "Y");
			commonDao.update("updateTB_COM_INF_ATRZ_INFO",mtenMap);
			
			mtenMap.put("ATRZ_YN", "D");
			commonDao.update("updateTB_COM_INF_ATRZ_STTS",mtenMap);
			
			if(ATRZ_SE_NM.equals("CONSULT")){	//자문처리
				mtenMap.put("consultid", ATRZ_DMND_PST_MNG_NO);
				mtenMap.put("statcd", "답변중");
				commonDao.update("consultSql.updateConsultState",mtenMap);
			}else if(ATRZ_SE_NM.equals("AGREE")){	//협약처리
				mtenMap.put("CVTN_MNG_NO", ATRZ_DMND_PST_MNG_NO);
				mtenMap.put("PRGRS_STTS_SE_NM", "답변중");
				commonDao.update("agreeSql.updateAgreeState", mtenMap);
			}
		}
		
		if(GSTATE.equals("Y")) {	//승인처리
			mtenMap.put("ATRZ_YN", "Y");
			commonDao.update("updateTB_COM_INF_ATRZ_STTS",mtenMap);
			
			HashMap chk = commonDao.select("selectChkApprove",mtenMap);
			System.out.println(chk);
			if(chk == null) {
				mtenMap.put("ATRZ_STTS_NM", "결재완료");
				mtenMap.put("ATRZ_CMPTN_YN", "Y");
				commonDao.update("updateTB_COM_INF_ATRZ_INFO",mtenMap);
				
				if(ATRZ_SE_NM.equals("CONSULT")){	//자문처리
					mtenMap.put("consultid", ATRZ_DMND_PST_MNG_NO);
					mtenMap.put("statcd", "만족도평가필요");
					commonDao.update("consultSql.updateConsultState",mtenMap);
				}else if(ATRZ_SE_NM.equals("AGREE")){	//협약처리
					mtenMap.put("CVTN_MNG_NO", ATRZ_DMND_PST_MNG_NO);
					mtenMap.put("PRGRS_STTS_SE_NM", "만족도평가필요");
					commonDao.update("agreeSql.updateAgreeState", mtenMap);
				}
			} else {
				mtenMap.put("ATRZ_STTS_NM", "결재중");
				mtenMap.put("ATRZ_CMPTN_YN", "N");
				mtenMap.put("APRVR_NM", chk.get("APRVR_NM"));
				mtenMap.put("APRVR_NO", chk.get("APRVR_NO"));
				commonDao.update("updateTB_COM_INF_ATRZ_INFO",mtenMap);
				
				HashMap user = commonDao.selectOne("selectAlertUser", mtenMap);
				// chk.get("APRVR_NO") 활용해서 다음 결재자에게 알림 발송
				// 문자 알림시 MBL_TELNO
				// 메신저, 메일 알림 시 EMP_PK_NO
			}
		}
		JSONObject result = new JSONObject();
		result.put("msg", "ok");
		return result;
	}
	
	public JSONObject showGianList(Map<String, Object> mtenMap) {
		List alist = commonDao.selectList("showGianList",mtenMap);
		List slist = commonDao.selectList("showGianList2",mtenMap);
		JSONArray jr1 = JSONArray.fromObject(alist);
		JSONArray jr2 = JSONArray.fromObject(slist);
		JSONObject result = new JSONObject();
		result.put("result1", jr1);
		result.put("result2", jr2);
		return result;
	}
}
