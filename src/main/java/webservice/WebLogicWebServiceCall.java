package webservice;

import java.io.File;
import java.util.ArrayList;

import javax.xml.namespace.QName;
import javax.xml.rpc.handler.HandlerInfo;
import javax.xml.rpc.handler.HandlerRegistry;
import javax.xml.rpc.Stub;

import gov.bms.lnk.ini.vo.BmsLnkIniComAddAttachReqVO;
import gov.bms.lnk.ini.vo.BmsLnkIniComExchangeIdResVO;
import gov.bms.lnk.ini.vo.BmsLnkIniComExchangeLinkFileVO;
import gov.bms.lnk.ini.vo.BmsLnkIniCommonResVO;
import gov.bms.lnk.ini.vo.BmsLnkIniDctExchangeCallDraftReqVO;
import gov.bms.lnk.ini.vo.BmsLnkIniDctExchangeCallDraftResVO;
import gov.bms.lnk.ini.vo.BmsLnkIniLoginVO;
import gov.bms.webservices.client.BmsSifComService_V2;
import gov.bms.webservices.client.BmsSifComService_V2Port;
import gov.bms.webservices.client.BmsSifComService_V2_Impl;
import gov.bms.webservices.client.BmsSifDctCallAddService_V2;
import gov.bms.webservices.client.BmsSifDctCallAddService_V2Port;
import gov.bms.webservices.client.BmsSifDctCallAddService_V2_Impl;

public class WebLogicWebServiceCall {
	
	
	private BmsSifComService_V2 service;
    private BmsSifComService_V2Port port;
    
    private BmsSifDctCallAddService_V2 service2;
    private BmsSifDctCallAddService_V2Port port2;
    
    private String WSDL = "";
    private String WSDL2 = "";
    
    private String httpStr = "";
    
    public WebLogicWebServiceCall(String strAddr) {
    	this.httpStr = strAddr;
        init(strAddr);
    }
    
    /**
     * 서비스 클라이언트 초기화.
     */
    private void init(String strAddr) {
        //BmsDocumentService Proxy 객체 생성
        try{
        	
        	WSDL = strAddr + "/bms/service/BmsSifComService_V2?WSDL";
        	service = new BmsSifComService_V2_Impl( WSDL );
        	port= service.getBmsSifComService_V2Port();
        	
        	
        	WSDL2 = strAddr + "/bms/service/BmsSifDctCallAddService_V2?WSDL";
        	service2 = new BmsSifDctCallAddService_V2_Impl( WSDL2 );
        	port2= service2.getBmsSifDctCallAddService_V2Port();
        
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    
	public String exchangeIDCall(String loginid , String deptcd , String systemid , String authkey) throws Exception{
		
		BmsLnkIniLoginVO loginvo = new BmsLnkIniLoginVO();
		loginvo.setLoginId(loginid);
		loginvo.setDeptCd(deptcd);
		loginvo.setSystemId(systemid);
		loginvo.setAuthKey(authkey);
		
		
		BmsLnkIniComExchangeIdResVO vo = port.getExchangeID(loginvo);
		
		System.out.println("연계ID 수신결과 : retVo" + vo);
		String exchangeId = vo.getExchangeResultIdVo().getExId();
		System.out.println("연계ID 수신결과 : exchangeId" + exchangeId);
		
		return exchangeId;
		
	}
	
	public String addExchangeFileInfoCall(String fullfilePath ,String loginid , String deptcd , String systemid , String authkey, String exchangeId) throws Exception{
		String retStr = "";
		BmsLnkIniComAddAttachReqVO inputvo = null;
		File dirInfo = new File(fullfilePath);
		String dirList[] = dirInfo.list();
		
		BmsLnkIniLoginVO loginvo = new BmsLnkIniLoginVO();
		loginvo.setLoginId(loginid);
		loginvo.setDeptCd(deptcd);
		loginvo.setSystemId(systemid);
		loginvo.setAuthKey(authkey);
		
		int fileCnt = dirList.length;
				
		if(fileCnt > 2){
			for(int i=0; i < fileCnt; i++){
				BmsLnkIniComExchangeLinkFileVO exchangeLinkFileVo = new BmsLnkIniComExchangeLinkFileVO();
			    	System.out.println(fullfilePath+dirList[i] + i);
					exchangeLinkFileVo.setExID(exchangeId);
				    exchangeLinkFileVo.setFileTitle(fullfilePath+dirList[i]);
				    exchangeLinkFileVo.setUserID(loginid);
				   
				    inputvo = new BmsLnkIniComAddAttachReqVO();
					inputvo.setLoginVo(loginvo);
				    inputvo.setExchangeLinkFileVo(exchangeLinkFileVo);
				    
				    BmsLnkIniAddAttachFileHandlerTest hand = new BmsLnkIniAddAttachFileHandlerTest();
		            HandlerRegistry registry = service.getHandlerRegistry();
		            QName portName = new QName("http://hamoni.mogaha.go.kr/bms", "BmsSifComService_V2Port");
		            ArrayList hList = new ArrayList();
		            hList.add(new HandlerInfo(BmsLnkIniAddAttachFileHandlerTest.class, null, null));            
		            registry.setHandlerChain(portName, hList);
				    
				    BmsLnkIniCommonResVO retVo = port.addExchangeFileInfo(inputvo);
				    System.out.println("----------------------------------------\n"+retVo+"\n");
				    retStr = retVo.getRecptRsltCd();
				    
				    /*if("INI0000".equals(retStr)){
				    	retStr = makeDocInfoCall(loginvo,exchangeId);
				    }*/
			}
		 }else{
				
				retStr = fullfilePath+" 폴더에 파일이 없거나 \n\n필수 연계파일(header.inf, open_exchange_exchange.xml)이 없습니다.";
			}
			
		
		return retStr;
	}
	

	/*public String makeDocInfoCall(BmsLnkIniLoginVO loginvo,String exchangeId) throws Exception{
		

		BmsLnkIniDctExchangeCallDraftReqVO callVo = new BmsLnkIniDctExchangeCallDraftReqVO();
		callVo.setLoginVo(loginvo);
		callVo.setExID(exchangeId);
		BmsLnkIniDctExchangeCallDraftResVO callRtnVo = port2.addExchangeCallDraft(callVo);
	
		BmsLnkIniCommonResVO retVo3 = callRtnVo.getCommonResVo();
		String WSresultCode = retVo3.getRecptRsltCd(); 
		String WSresultMsg = retVo3.getErrConts();
		String errorType = callRtnVo.getErrorType();
		String errorMsg = callRtnVo.getErrorMsg();
		String docId= callRtnVo.getDocID();
		
		System.out.println("===> WSresultCode = " + WSresultCode);
		System.out.println("===> WSresultMsg = " + WSresultMsg);
		System.out.println("===> errorType = " + errorType);
		System.out.println("===> errorMsg = " + errorMsg);
		System.out.println("===> 연계정보생성 웹서비스 호출 완료 : DOCID=" + docId);
		
		return docId;
	}*/
	
	
	public String getSSOUrl(String loginid ,String deptcd,String exchangeId){
		
		String del = "" + (char)18 + "";
		
		String urlStr = httpStr + "/bms/com/SSO.do?L1=" + 
		sutil.Encrypt.com_Encode("SSO" + del + loginid + del + deptcd + del) +
		"&DOC_TYPE=EX&EX_ID=" + sutil.Encrypt.com_Encode(del + exchangeId + del);
		
		
		return urlStr;
		
	}
}
