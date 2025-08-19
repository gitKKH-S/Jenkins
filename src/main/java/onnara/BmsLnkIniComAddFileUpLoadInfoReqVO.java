
package onnara;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>BmsLnkIniComAddFileUpLoadInfoReqVO complex type에 대한 Java 클래스입니다.
 * 
 * <p>다음 스키마 단편이 이 클래스에 포함되는 필요한 콘텐츠를 지정합니다.
 * 
 * <pre>
 * &lt;complexType name="BmsLnkIniComAddFileUpLoadInfoReqVO">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="exchangeLinkFileVo" type="{java:gov.bms.lnk.ini.vo}BmsLnkIniComExchangeLinkFileVO"/>
 *         &lt;element name="fileId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="fileName" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="fileTitle" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="loginVo" type="{java:gov.bms.lnk.ini.vo}BmsLnkIniLoginVO"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "BmsLnkIniComAddFileUpLoadInfoReqVO", propOrder = {
    "exchangeLinkFileVo",
    "fileId",
    "fileName",
    "fileTitle",
    "loginVo"
})
public class BmsLnkIniComAddFileUpLoadInfoReqVO {

    @XmlElement(required = true, nillable = true)
    protected BmsLnkIniComExchangeLinkFileVO exchangeLinkFileVo;
    @XmlElement(required = true, nillable = true)
    protected String fileId;
    @XmlElement(required = true, nillable = true)
    protected String fileName;
    @XmlElement(required = true, nillable = true)
    protected String fileTitle;
    @XmlElement(required = true, nillable = true)
    protected BmsLnkIniLoginVO loginVo;

    /**
     * exchangeLinkFileVo 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link BmsLnkIniComExchangeLinkFileVO }
     *     
     */
    public BmsLnkIniComExchangeLinkFileVO getExchangeLinkFileVo() {
        return exchangeLinkFileVo;
    }

    /**
     * exchangeLinkFileVo 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link BmsLnkIniComExchangeLinkFileVO }
     *     
     */
    public void setExchangeLinkFileVo(BmsLnkIniComExchangeLinkFileVO value) {
        this.exchangeLinkFileVo = value;
    }

    /**
     * fileId 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFileId() {
        return fileId;
    }

    /**
     * fileId 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFileId(String value) {
        this.fileId = value;
    }

    /**
     * fileName 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFileName() {
        return fileName;
    }

    /**
     * fileName 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFileName(String value) {
        this.fileName = value;
    }

    /**
     * fileTitle 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFileTitle() {
        return fileTitle;
    }

    /**
     * fileTitle 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFileTitle(String value) {
        this.fileTitle = value;
    }

    /**
     * loginVo 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link BmsLnkIniLoginVO }
     *     
     */
    public BmsLnkIniLoginVO getLoginVo() {
        return loginVo;
    }

    /**
     * loginVo 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link BmsLnkIniLoginVO }
     *     
     */
    public void setLoginVo(BmsLnkIniLoginVO value) {
        this.loginVo = value;
    }

}
