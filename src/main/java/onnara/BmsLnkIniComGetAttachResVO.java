
package onnara;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>BmsLnkIniComGetAttachResVO complex type에 대한 Java 클래스입니다.
 * 
 * <p>다음 스키마 단편이 이 클래스에 포함되는 필요한 콘텐츠를 지정합니다.
 * 
 * <pre>
 * &lt;complexType name="BmsLnkIniComGetAttachResVO">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="commonResVo" type="{java:gov.bms.lnk.ini.vo}BmsLnkIniCommonResVO"/>
 *         &lt;element name="fileId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "BmsLnkIniComGetAttachResVO", propOrder = {
    "commonResVo",
    "fileId"
})
public class BmsLnkIniComGetAttachResVO {

    @XmlElement(required = true, nillable = true)
    protected BmsLnkIniCommonResVO commonResVo;
    @XmlElement(required = true, nillable = true)
    protected String fileId;

    /**
     * commonResVo 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link BmsLnkIniCommonResVO }
     *     
     */
    public BmsLnkIniCommonResVO getCommonResVo() {
        return commonResVo;
    }

    /**
     * commonResVo 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link BmsLnkIniCommonResVO }
     *     
     */
    public void setCommonResVo(BmsLnkIniCommonResVO value) {
        this.commonResVo = value;
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

}
