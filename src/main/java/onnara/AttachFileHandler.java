package onnara;


import javax.activation.DataHandler;
import javax.xml.namespace.QName;
import javax.xml.soap.*;
import javax.xml.ws.handler.MessageContext;
import javax.xml.ws.handler.soap.SOAPHandler;
import javax.xml.ws.handler.soap.SOAPMessageContext;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Iterator;
import java.util.Set;


public class AttachFileHandler implements SOAPHandler<SOAPMessageContext> {

    private String savePath = "D:/temp/";

    @Override
    public boolean handleMessage(SOAPMessageContext context) {
        Boolean isRequest = (Boolean) context.get(MessageContext.MESSAGE_OUTBOUND_PROPERTY);
        if(!isRequest) {         //for request message
            try {
                SOAPMessage soapMessage = context.getMessage();
                SOAPPart soapPart = soapMessage.getSOAPPart();          //SOAPPart 객체 생성
                SOAPEnvelope soapEnvelope = soapPart.getEnvelope();     //SOAPEnvelope 객체 생성
                SOAPBody soapBody = soapEnvelope.getBody();             //SOAPBody 객체 얻기
                SOAPElement operElement;                                //SOAP Element of the operation

                if (soapBody.getChildElements().hasNext()) {
                    /* xmlns:n1="http://hamoni.mogaha.go.kr/bms" */
                    operElement = (SOAPElement) soapBody.getChildElements().next();

                    // xmlns:ns2="java:gov.bms.lnk.ini.vo"
                    Iterator itOpParams = operElement.getChildElements();

                    String fileName = "";
                    while(itOpParams.hasNext()) {
                        SOAPElement paramElm = (SOAPElement) itOpParams.next();
                        String elenm = paramElm.getElementName().getLocalName();
                        if (elenm.endsWith("fileId")) {
                            fileName = paramElm.getValue();
                            break;
                        }
                    }
                    Iterator ia = soapMessage.getAttachments();
                    if (ia.hasNext()) {
                        AttachmentPart part = (AttachmentPart) ia.next();
                        DataHandler dh = part.getDataHandler();
                        /*임시 디렉토리에 파일 ID로 저장한다.*/
                        File outFile = new File(savePath+File.separator+fileName);
                        dh.writeTo(new FileOutputStream(outFile));


                        System.out.println("File Saved (" + savePath+File.separator+fileName + " ) ");
                    }
                }
            } catch(NullPointerException ne){
                System.out.println("NullPointerException 에러가 발생했습니다.");
                throw ne;
            } catch (java.lang.Exception e) {
                e.printStackTrace();
                System.out.println("[handleResponse() ERROR] : " + e.getMessage());
            }
        }
        
        return true;
    }

    @Override
    public boolean handleFault(SOAPMessageContext context) {
        return false;
    }

    @Override
    public void close(MessageContext context) {

    }


    @Override
    public Set<QName> getHeaders() {
        return null;
    }
}
