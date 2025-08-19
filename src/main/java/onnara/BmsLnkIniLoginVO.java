
package onnara;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>BmsLnkIniLoginVO complex type에 대한 Java 클래스입니다.
 * 
 * <p>다음 스키마 단편이 이 클래스에 포함되는 필요한 콘텐츠를 지정합니다.
 * 
 * <pre>
 * &lt;complexType name="BmsLnkIniLoginVO">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="authKey" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="deptCd" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="loginId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="systemId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "BmsLnkIniLoginVO", propOrder = {
    "authKey",
    "deptCd",
    "loginId",
    "systemId"
})
public class BmsLnkIniLoginVO {

    @XmlElement(required = true, nillable = true)
    protected String authKey;
    @XmlElement(required = true, nillable = true)
    protected String deptCd;
    @XmlElement(required = true, nillable = true)
    protected String loginId;
    @XmlElement(required = true, nillable = true)
    protected String systemId;

    /**
     * authKey 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAuthKey() {
        return authKey;
    }

    /**
     * authKey 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAuthKey(String value) {
        this.authKey = value;
    }

    /**
     * deptCd 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDeptCd() {
        return deptCd;
    }

    /**
     * deptCd 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDeptCd(String value) {
        this.deptCd = value;
    }

    /**
     * loginId 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLoginId() {
        return loginId;
    }

    /**
     * loginId 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLoginId(String value) {
        this.loginId = value;
    }

    /**
     * systemId 속성의 값을 가져옵니다.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSystemId() {
        return systemId;
    }

    /**
     * systemId 속성의 값을 설정합니다.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSystemId(String value) {
        this.systemId = value;
    }

}
