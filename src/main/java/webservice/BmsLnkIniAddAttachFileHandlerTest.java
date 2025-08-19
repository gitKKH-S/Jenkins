package webservice;


import gov.bms.lnk.ini.vo.BmsLnkIniComExchangeLinkFileVO;


import java.io.File;
import java.net.InetAddress;
import java.util.Iterator;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.xml.rpc.handler.MessageContext;
import javax.xml.rpc.handler.soap.SOAPMessageContext;
import javax.xml.rpc.soap.SOAPFaultException;
import javax.xml.soap.AttachmentPart;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPFactory;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;


import weblogic.webservice.GenericHandler;

public class BmsLnkIniAddAttachFileHandlerTest extends GenericHandler {
	
	public static final String CLASS_NAME = BmsLnkIniAddAttachFileHandlerTest.class.getName();
	
    public boolean handleRequest(MessageContext mc) {

        BmsLnkIniComExchangeLinkFileVO exchangeLinkFileVo = new BmsLnkIniComExchangeLinkFileVO();
        
        try {
           System.out.println("BmsLnkIniAddAttachFileHandler AttachFile Handler Start....  ");
           System.out.println("ip=************"+InetAddress.getLocalHost());
            SOAPMessageContext messageContext = (SOAPMessageContext) mc;
            SOAPMessage soapMessage = messageContext.getMessage();
            SOAPPart soapPart = soapMessage.getSOAPPart();
            SOAPEnvelope soapEnvelope = soapPart.getEnvelope();
            SOAPBody soapBody = soapEnvelope.getBody();
            System.out.println("SOAPMessageObject create OK ....  "+soapBody.toString());
            
            //SOAP Element of the operation
            SOAPElement operElement = (SOAPElement) soapBody.getChildElements().next();
            System.out.println("-***************************EEEEND**"+operElement.getElementName().getURI());
            if(!operElement.getElementName().toString().endsWith("addExchangeFileInfo"))
                return true;

            //SOAP Params
            Iterator itOpParams = operElement.getChildElements();

            String fileName = "";            
            
            while(itOpParams.hasNext()) {
                SOAPElement paramElm = (SOAPElement) itOpParams.next();
                String elenm = paramElm.getElementName().toString();
                if (elenm.endsWith("exchangeLinkFileVo")) {
                    Iterator itFileElm = paramElm.getChildElements();
                    while(itFileElm.hasNext()){
                        SOAPElement fileElm = (SOAPElement) itFileElm.next();
                        String fileElmNm = fileElm.getElementName().toString();
                        if (fileElmNm.endsWith("fileTitle") && !isNull(fileElm.getValue())){
                            fileName = fileElm.getValue();                            
                        }
                    }
                    /* fileTitle 추가 */
                    addChildElement(paramElm, "fileTitle", getFileName(fileName));  
                }
            }       
            
           System.out.println("fileName : " + fileName);
           System.out.println("fileTitle : " + getFileName(fileName));
            
            soapMessage.saveChanges();    
            soapMessage.writeTo(System.out);
                        
            //application/octet-stream
            AttachmentPart part = soapMessage.createAttachmentPart();
            part.setContentType("application/octet-stream");
            FileDataSource fds = new FileDataSource(fileName);
            part.setDataHandler(new DataHandler(fds));
            soapMessage.addAttachmentPart(part);
           System.out.println("BmsLnkIniAddAttachFileHandler AttachFile Handler end....  ");
        } catch (Exception e) {
            e.printStackTrace();
           System.out.println("[handleResponse() ERROR] : " + e.getMessage());
            SOAPFaultException se = new SOAPFaultException(null, e.getMessage(), null, null);
            throw se;
        } 
        return true;
    }
    
    /**
     * 객체를 받아서 null이면 false로 리턴
     *
     * @param obj
     * @return boolean
     */
    public static final boolean isNull(Object obj) {
        if(obj == null) return true;
        
        if (obj instanceof String && ((obj.toString()).trim().equals("") || (obj.toString()).trim().equals("null")))
            return true;
        else
            return false;
    }
    
    public static final String getFileName(String pathFile){
        char delim = 0x00;
        String fileName = "";
        if(isNull(pathFile)) return fileName;
        delim = File.separatorChar;
        
        fileName = pathFile.substring(pathFile.lastIndexOf(delim)+1);
        
        return fileName;
    }
    
    /**
     * element를 추가한다.
     * 
     * @param parentElement
     * @param elementName
     * @param text
     * @throws SOAPException
     */
    private void addChildElement(SOAPElement parentElement, String elementName, String text) throws SOAPException {
        SOAPFactory soapFactory = SOAPFactory.newInstance();      
        SOAPElement childElement = parentElement.addChildElement(soapFactory.createName(elementName));
        childElement.addTextNode(text);
    }
}
