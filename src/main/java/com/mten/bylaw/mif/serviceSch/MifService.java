package com.mten.bylaw.mif.serviceSch;

import java.util.*;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public interface MifService {
	public String getUrlXml(String path);
	public String getUrlXml_in(String sUrl, String Url, String sLawId);
	public int setInsertLaw();
	public String outFile(String url,String sLawId);
	public String outFile2(String url, String sByLawId);
	public void updateLaw();
	public int setInsertByLaw();
	public void updateByLaw();
	
	public void getXmlTest(String url , String sLawId ,String gbn);
	
	public void noticeSms(String getDate);
	public void noticeLawyerInfo(String getDate);
	public void noticeMail(String getDate);
	
	public void setInsaInfo();
	
	public void setTask(HashMap taskMap);
	
	public void updateSuitDate();
	
	public void setSuitOldData();
	public void setConsultOldData();
	public void setAgreeOldData();
	public void setConferenceOldData();
}
