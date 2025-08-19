
package onnara;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>BmsLnkIniCommonResVO complex type에 대한 Java 클래스입니다.
 * 
 * <p>다음 스키마 단편이 이 클래스에 포함되는 필요한 콘텐츠를 지정합니다.
 * 
 * <pre>
 * &lt;complexType name="BmsLnkIniCommonResVO">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="errConts" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="recptDthms" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="recptRsltCd" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "BmsLnkIniCommonResVO", propOrder = {
    "errConts",
    "recptDthms",
    "recptRsltCd"
})
public class BmsLnkIniCommonResVO {

    @XmlElement(required = true, nillable = true)
    protected String errConts;
    @XmlElement(required = true, nillable = true)
    protected String recptDthms;
    @XmlElement(required = true, nillable = true)
    protected String recptRsltCd;

    /**
     * errConts 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getErrConts() {
        return errConts;
    }

    /**
     * errConts 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setErrConts(String value) {
        this.errConts = value;
    }

    /**
     * recptDthms 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRecptDthms() {
        return recptDthms;
    }

    /**
     * recptDthms 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRecptDthms(String value) {
        this.recptDthms = value;
    }

    /**
     * recptRsltCd 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRecptRsltCd() {
        return recptRsltCd;
    }

    /**
     * recptRsltCd 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRecptRsltCd(String value) {
        this.recptRsltCd = value;
    }

}
