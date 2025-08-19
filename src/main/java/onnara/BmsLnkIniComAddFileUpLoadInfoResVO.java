
package onnara;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>BmsLnkIniComAddFileUpLoadInfoResVO complex type에 대한 Java 클래스입니다.
 * 
 * <p>다음 스키마 단편이 이 클래스에 포함되는 필요한 콘텐츠를 지정합니다.
 * 
 * <pre>
 * &lt;complexType name="BmsLnkIniComAddFileUpLoadInfoResVO">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="commonResVo" type="{java:gov.bms.lnk.ini.vo}BmsLnkIniCommonResVO"/>
 *         &lt;element name="fileId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="fileName" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="fileTitle" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "BmsLnkIniComAddFileUpLoadInfoResVO", propOrder = {
    "commonResVo",
    "fileId",
    "fileName",
    "fileTitle"
})
public class BmsLnkIniComAddFileUpLoadInfoResVO {

    @XmlElement(required = true, nillable = true)
    protected BmsLnkIniCommonResVO commonResVo;
    @XmlElement(required = true, nillable = true)
    protected String fileId;
    @XmlElement(required = true, nillable = true)
    protected String fileName;
    @XmlElement(required = true, nillable = true)
    protected String fileTitle;

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

}
