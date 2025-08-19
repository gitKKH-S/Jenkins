
package onnara;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>BmsLnkIniComGetAttachReqVO complex type에 대한 Java 클래스입니다.
 * 
 * <p>다음 스키마 단편이 이 클래스에 포함되는 필요한 콘텐츠를 지정합니다.
 * 
 * <pre>
 * &lt;complexType name="BmsLnkIniComGetAttachReqVO">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="fileId" type="{http://www.w3.org/2001/XMLSchema}string"/>
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
@XmlType(name = "BmsLnkIniComGetAttachReqVO", propOrder = {
    "fileId",
    "loginVo"
})
public class BmsLnkIniComGetAttachReqVO {

    @XmlElement(required = true, nillable = true)
    protected String fileId;
    @XmlElement(required = true, nillable = true)
    protected BmsLnkIniLoginVO loginVo;

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
