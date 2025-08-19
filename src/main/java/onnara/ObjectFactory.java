
package onnara;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the onnara package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _AddExchangeFileInfo_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "addExchangeFileInfo");
    private final static QName _GetExchangeIDResponse_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "getExchangeIDResponse");
    private final static QName _AddFileUpLoadInfo_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "addFileUpLoadInfo");
    private final static QName _AddFileUpLoadInfoResponse_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "addFileUpLoadInfoResponse");
    private final static QName _GetExchangeFileResponse_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "getExchangeFileResponse");
    private final static QName _GetExchangeFile_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "getExchangeFile");
    private final static QName _IsAliveResponse_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "isAliveResponse");
    private final static QName _BmsLnkIniCommonResVO_QNAME = new QName("java:gov.bms.lnk.ini.vo", "bmsLnkIniCommonResVO");
    private final static QName _GetExchangeID_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "getExchangeID");
    private final static QName _Exception_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "Exception");
    private final static QName _AddExchangeFileInfoResponse_QNAME = new QName("http://hamoni.mogaha.go.kr/bms", "addExchangeFileInfoResponse");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: onnara
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link BmsLnkIniCommonResVO }
     * 
     */
    public BmsLnkIniCommonResVO createBmsLnkIniCommonResVO() {
        return new BmsLnkIniCommonResVO();
    }

    /**
     * Create an instance of {@link Exception }
     * 
     */
    public Exception createException() {
        return new Exception();
    }

    /**
     * Create an instance of {@link BmsLnkIniLoginVO }
     * 
     */
    public BmsLnkIniLoginVO createBmsLnkIniLoginVO() {
        return new BmsLnkIniLoginVO();
    }

    /**
     * Create an instance of {@link BmsLnkIniComGetAttachReqVO }
     * 
     */
    public BmsLnkIniComGetAttachReqVO createBmsLnkIniComGetAttachReqVO() {
        return new BmsLnkIniComGetAttachReqVO();
    }

    /**
     * Create an instance of {@link BmsLnkIniComAddFileUpLoadInfoResVO }
     * 
     */
    public BmsLnkIniComAddFileUpLoadInfoResVO createBmsLnkIniComAddFileUpLoadInfoResVO() {
        return new BmsLnkIniComAddFileUpLoadInfoResVO();
    }

    /**
     * Create an instance of {@link BmsLnkIniComGetAttachResVO }
     * 
     */
    public BmsLnkIniComGetAttachResVO createBmsLnkIniComGetAttachResVO() {
        return new BmsLnkIniComGetAttachResVO();
    }

    /**
     * Create an instance of {@link BmsLnkIniComAddFileUpLoadInfoReqVO }
     * 
     */
    public BmsLnkIniComAddFileUpLoadInfoReqVO createBmsLnkIniComAddFileUpLoadInfoReqVO() {
        return new BmsLnkIniComAddFileUpLoadInfoReqVO();
    }

    /**
     * Create an instance of {@link BmsLnkIniComExchangeIdResVO }
     * 
     */
    public BmsLnkIniComExchangeIdResVO createBmsLnkIniComExchangeIdResVO() {
        return new BmsLnkIniComExchangeIdResVO();
    }

    /**
     * Create an instance of {@link BmsLnkIniComAddAttachReqVO }
     * 
     */
    public BmsLnkIniComAddAttachReqVO createBmsLnkIniComAddAttachReqVO() {
        return new BmsLnkIniComAddAttachReqVO();
    }

    /**
     * Create an instance of {@link BmsLnkIniComExchangeResultID }
     * 
     */
    public BmsLnkIniComExchangeResultID createBmsLnkIniComExchangeResultID() {
        return new BmsLnkIniComExchangeResultID();
    }

    /**
     * Create an instance of {@link BmsLnkIniComExchangeLinkFileVO }
     * 
     */
    public BmsLnkIniComExchangeLinkFileVO createBmsLnkIniComExchangeLinkFileVO() {
        return new BmsLnkIniComExchangeLinkFileVO();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link BmsLnkIniComAddAttachReqVO }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "addExchangeFileInfo")
    public JAXBElement<BmsLnkIniComAddAttachReqVO> createAddExchangeFileInfo(BmsLnkIniComAddAttachReqVO value) {
        return new JAXBElement<BmsLnkIniComAddAttachReqVO>(_AddExchangeFileInfo_QNAME, BmsLnkIniComAddAttachReqVO.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link BmsLnkIniComExchangeIdResVO }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "getExchangeIDResponse")
    public JAXBElement<BmsLnkIniComExchangeIdResVO> createGetExchangeIDResponse(BmsLnkIniComExchangeIdResVO value) {
        return new JAXBElement<BmsLnkIniComExchangeIdResVO>(_GetExchangeIDResponse_QNAME, BmsLnkIniComExchangeIdResVO.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link BmsLnkIniComAddFileUpLoadInfoReqVO }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "addFileUpLoadInfo")
    public JAXBElement<BmsLnkIniComAddFileUpLoadInfoReqVO> createAddFileUpLoadInfo(BmsLnkIniComAddFileUpLoadInfoReqVO value) {
        return new JAXBElement<BmsLnkIniComAddFileUpLoadInfoReqVO>(_AddFileUpLoadInfo_QNAME, BmsLnkIniComAddFileUpLoadInfoReqVO.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link BmsLnkIniComAddFileUpLoadInfoResVO }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "addFileUpLoadInfoResponse")
    public JAXBElement<BmsLnkIniComAddFileUpLoadInfoResVO> createAddFileUpLoadInfoResponse(BmsLnkIniComAddFileUpLoadInfoResVO value) {
        return new JAXBElement<BmsLnkIniComAddFileUpLoadInfoResVO>(_AddFileUpLoadInfoResponse_QNAME, BmsLnkIniComAddFileUpLoadInfoResVO.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link BmsLnkIniComGetAttachResVO }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "getExchangeFileResponse")
    public JAXBElement<BmsLnkIniComGetAttachResVO> createGetExchangeFileResponse(BmsLnkIniComGetAttachResVO value) {
        return new JAXBElement<BmsLnkIniComGetAttachResVO>(_GetExchangeFileResponse_QNAME, BmsLnkIniComGetAttachResVO.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link BmsLnkIniComGetAttachReqVO }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "getExchangeFile")
    public JAXBElement<BmsLnkIniComGetAttachReqVO> createGetExchangeFile(BmsLnkIniComGetAttachReqVO value) {
        return new JAXBElement<BmsLnkIniComGetAttachReqVO>(_GetExchangeFile_QNAME, BmsLnkIniComGetAttachReqVO.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Boolean }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "isAliveResponse")
    public JAXBElement<Boolean> createIsAliveResponse(Boolean value) {
        return new JAXBElement<Boolean>(_IsAliveResponse_QNAME, Boolean.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link BmsLnkIniCommonResVO }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "java:gov.bms.lnk.ini.vo", name = "bmsLnkIniCommonResVO")
    public JAXBElement<BmsLnkIniCommonResVO> createBmsLnkIniCommonResVO(BmsLnkIniCommonResVO value) {
        return new JAXBElement<BmsLnkIniCommonResVO>(_BmsLnkIniCommonResVO_QNAME, BmsLnkIniCommonResVO.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link BmsLnkIniLoginVO }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "getExchangeID")
    public JAXBElement<BmsLnkIniLoginVO> createGetExchangeID(BmsLnkIniLoginVO value) {
        return new JAXBElement<BmsLnkIniLoginVO>(_GetExchangeID_QNAME, BmsLnkIniLoginVO.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Exception }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "Exception")
    public JAXBElement<Exception> createException(Exception value) {
        return new JAXBElement<Exception>(_Exception_QNAME, Exception.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link BmsLnkIniCommonResVO }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://hamoni.mogaha.go.kr/bms", name = "addExchangeFileInfoResponse")
    public JAXBElement<BmsLnkIniCommonResVO> createAddExchangeFileInfoResponse(BmsLnkIniCommonResVO value) {
        return new JAXBElement<BmsLnkIniCommonResVO>(_AddExchangeFileInfoResponse_QNAME, BmsLnkIniCommonResVO.class, null, value);
    }

}
